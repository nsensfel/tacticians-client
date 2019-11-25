module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Delay

import Dict

import Http

import Time

import Url

-- Shared ----------------------------------------------------------------------
import Action.Ports

import Struct.Flags

import Util.Http

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.DataSet
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Glyph
import BattleCharacters.Struct.GlyphBoard
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Skill
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSet
import BattleMap.Struct.Map
import BattleMap.Struct.Tile

-- Local Module ----------------------------------------------------------------
import Constants.IO

import Struct.Battle
import Struct.Character
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Player
import Struct.ServerReply
import Struct.TurnResult
import Struct.TurnResultAnimator
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
disconnected : (
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
disconnected current_state =
   let (model, cmds) = current_state in
      (
         model,
         [
            (Action.Ports.go_to
               (
                  Constants.IO.base_url
                  ++ "/login/?action=disconnect&goto="
                  ++
                  (Url.percentEncode
                     (
                        "/battle/?"
                        ++ (Struct.Flags.get_params_as_url model.flags)
                     )
                  )
               )
            )
         ]
      )

add_armor : (
      BattleCharacters.Struct.Armor.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_armor ar current_state =
   let (model, cmds) = current_state in
      (
         {model |
            characters_dataset =
               (BattleCharacters.Struct.DataSet.add_armor
                  ar
                  model.characters_dataset
               )
         },
         cmds
      )

add_portrait : (
      BattleCharacters.Struct.Portrait.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_portrait pt current_state =
   let (model, cmds) = current_state in
      (
         {model |
            characters_dataset =
               (BattleCharacters.Struct.DataSet.add_portrait
                  pt
                  model.characters_dataset
               )
         },
         cmds
      )

add_glyph_board : (
      BattleCharacters.Struct.GlyphBoard.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_glyph_board gb current_state =
   let (model, cmds) = current_state in
      (
         {model |
            characters_dataset =
               (BattleCharacters.Struct.DataSet.add_glyph_board
                  gb
                  model.characters_dataset
               )
         },
         cmds
      )

add_glyph : (
      BattleCharacters.Struct.Glyph.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_glyph gl current_state =
   let (model, cmds) = current_state in
      (
         {model |
            characters_dataset =
               (BattleCharacters.Struct.DataSet.add_glyph
                  gl
                  model.characters_dataset
               )
         },
         cmds
      )

add_weapon : (
      BattleCharacters.Struct.Weapon.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_weapon wp current_state =
   let (model, cmds) = current_state in
      (
         {model |
            characters_dataset =
               (BattleCharacters.Struct.DataSet.add_weapon
                  wp
                  model.characters_dataset
               )
         },
         cmds
      )

add_skill : (
      BattleCharacters.Struct.Skill.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_skill sk current_state =
   let (model, cmds) = current_state in
      (
         {model |
            characters_dataset =
               (BattleCharacters.Struct.DataSet.add_skill
                  sk
                  model.characters_dataset
               )
         },
         cmds
      )

add_tile : (
      BattleMap.Struct.Tile.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_tile tl current_state =
   let (model, cmds) = current_state in
      (
         {model |
            map_dataset =
               (BattleMap.Struct.DataSet.add_tile tl model.map_dataset)
         },
         cmds
      )

add_player : (
      Struct.Player.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_player pl current_state =
   let (model, cmds) = current_state in
      (
         {model |
            battle = (Struct.Battle.add_player model.flags pl model.battle)
         },
         cmds
      )

add_character : (
      Struct.Character.Unresolved ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_character unresolved_char current_state =
   let (model, cmds) = current_state in
      (
         {model |
            battle =
               (Struct.Battle.add_character
                  (Struct.Character.resolve
                     (\loc ->
                        (BattleMap.Struct.Map.tile_omnimods_fun
                           loc
                           model.map_dataset
                           (Struct.Battle.get_map model.battle)
                        )
                     )
                     model.characters_dataset
                     unresolved_char
                  )
                  model.battle
               )
         },
         cmds
      )

set_map : (
      BattleMap.Struct.Map.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
set_map map current_state =
   let (model, cmds) = current_state in
      (
         {model |
            battle =
               (Struct.Battle.set_map
                  (BattleMap.Struct.Map.solve_tiles
                     model.map_dataset
                     (Struct.Battle.get_map model.battle)
                  )
                  model.battle
               )
         },
         cmds
      )

add_to_timeline : (
      (List Struct.TurnResult.Type) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_to_timeline turn_results current_state =
   let (model, cmds) = current_state in
      (
         {model |
            animator =
               (Struct.TurnResultAnimator.maybe_new
                  (List.reverse turn_results)
                  False
               ),
            ui =
               (Struct.UI.set_displayed_tab
                  Struct.UI.TimelineTab
                  model.ui
               ),
            battle =
               (Struct.Battle.set_timeline
                  (Array.append
                     (Array.fromList turn_results)
                     (Struct.Battle.get_timeline model.battle)
                  )
                  model.battle
               )
         },
         (
            (Delay.after 1 Delay.Millisecond Struct.Event.AnimationEnded)
            :: cmds
         )
      )

set_timeline : (
      (List Struct.TurnResult.Type) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
set_timeline turn_results current_state =
   let (model, cmds) = current_state in
      (
         {model |
            battle =
               (Struct.Battle.set_timeline
                  (Array.fromList turn_results)
                  model.battle
               )
         },
         cmds
      )

apply_command : (
      Struct.ServerReply.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
apply_command command current_state =
   case command of
      Struct.ServerReply.Disconnected -> (disconnected current_state)

      (Struct.ServerReply.AddWeapon wp) ->
         (add_weapon wp current_state)

      (Struct.ServerReply.AddArmor ar) ->
         (add_armor ar current_state)

      (Struct.ServerReply.AddPortrait pt) ->
         (add_portrait pt current_state)

      (Struct.ServerReply.AddSkill sk) ->
         (add_skill sk current_state)

      (Struct.ServerReply.AddGlyphBoard pt) ->
         (add_glyph_board pt current_state)

      (Struct.ServerReply.AddGlyph pt) ->
         (add_glyph pt current_state)

      (Struct.ServerReply.AddPlayer pl) ->
         (add_player pl current_state)

      (Struct.ServerReply.AddTile tl) ->
         (add_tile tl current_state)

      (Struct.ServerReply.AddCharacter char) ->
         (add_character char current_state)

      (Struct.ServerReply.SetMap map) ->
         (set_map map current_state)

      (Struct.ServerReply.TurnResults results) ->
         (add_to_timeline results current_state)

      (Struct.ServerReply.SetTimeline timeline) ->
         (set_timeline timeline current_state)

      Struct.ServerReply.Okay -> current_state

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Result Http.Error (List Struct.ServerReply.Type)) ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model query_result =
   case query_result of
      (Result.Err error) ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new Struct.Error.Networking
                  (Util.Http.error_to_string error)
               )
               model
            ),
            Cmd.none
         )

      (Result.Ok commands) ->
         let
            (new_model, elm_commands) =
               (List.foldl (apply_command) (model, [Cmd.none]) commands)
         in
            (
               new_model,
               (
                  case elm_commands of
                     [] -> Cmd.none
                     [cmd] -> cmd
                     _ -> (Cmd.batch elm_commands)
               )
            )
