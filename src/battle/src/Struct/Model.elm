module Struct.Model exposing
   (
      Type,
      new,
      add_character,
      update_character,
      update_character_fun,
      add_weapon,
      add_armor,
      add_portrait,
      add_glyph_board,
      add_glyph,
      add_skill,
      add_player,
      add_tile,
      invalidate,
      initialize_animator,
      apply_animator_step,
      move_animator_to_next_step,
      reset,
      full_debug_reset,
      clear_error,
      tile_omnimods_fun
   )

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import Set

-- Shared ----------------------------------------------------------------------
import Struct.Flags

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Glyph
import BattleCharacters.Struct.GlyphBoard
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Skill
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Map
import BattleMap.Struct.Marker
import BattleMap.Struct.Tile

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.HelpRequest
import Struct.TurnResult
import Struct.TurnResultAnimator
import Struct.Player
import Struct.UI

import Util.Array

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      flags : Struct.Flags.Type,
      help_request : Struct.HelpRequest.Type,
      animator : (Maybe Struct.TurnResultAnimator.Type),
      map : BattleMap.Struct.Map.Type,
      characters : (Array.Array Struct.Character.Type),
      players : (Array.Array Struct.Player.Type),
      weapons :
         (Dict.Dict
            BattleCharacters.Struct.Weapon.Ref
            BattleCharacters.Struct.Weapon.Type
         ),
      armors :
         (Dict.Dict
            BattleCharacters.Struct.Armor.Ref
            BattleCharacters.Struct.Armor.Type
         ),
      portraits :
         (Dict.Dict
            BattleCharacters.Struct.Portrait.Ref
            BattleCharacters.Struct.Portrait.Type
         ),
      glyph_boards :
         (Dict.Dict
            BattleCharacters.Struct.GlyphBoard.Ref
            BattleCharacters.Struct.GlyphBoard.Type
         ),
      glyphs :
         (Dict.Dict
            BattleCharacters.Struct.Glyph.Ref
            BattleCharacters.Struct.Glyph.Type
         ),
      skills :
         (Dict.Dict
            BattleCharacters.Struct.Skill.Ref
            BattleCharacters.Struct.Skill.Type
         ),
      tiles : (Dict.Dict BattleMap.Struct.Tile.Ref BattleMap.Struct.Tile.Type),
      error : (Maybe Struct.Error.Type),
      player_id : String,
      battle_id : String,
      session_token : String,
      player_ix : Int,
      ui : Struct.UI.Type,
      char_turn : Struct.CharacterTurn.Type,
      timeline : (Array.Array Struct.TurnResult.Type)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
regenerate_attack_of_opportunity_markers_of_char : (
      Int ->
      Struct.Character.Type ->
      Type ->
      Type
   )
regenerate_attack_of_opportunity_markers_of_char char_ix char model =
   if ((Struct.Character.get_player_index char) == model.player_ix)
   then model
   else
      let
         marker_name = ("matk_c" ++ (String.fromInt char_ix))
         map_without_this_marker =
            (BattleMap.Struct.Map.remove_marker marker_name model.map)
      in
         case (Struct.Character.get_melee_attack_range char) of
            0 -> {model | map = map_without_this_marker}
            attack_range ->
                  {model |
                     map =
                        (BattleMap.Struct.Map.add_marker
                           marker_name
                           (BattleMap.Struct.Marker.new_melee_attack
                              char_ix
                              (BattleMap.Struct.Location.add_neighborhood_to_set
                                 (BattleMap.Struct.Map.get_width
                                    map_without_this_marker
                                 )
                                 (BattleMap.Struct.Map.get_height
                                    map_without_this_marker
                                 )
                                 attack_range
                                 (Struct.Character.get_location char)
                                 (Set.empty)
                              )
                           )
                           map_without_this_marker
                        )
                  }

regenerate_attack_of_opportunity_markers : Int -> Type -> Type
regenerate_attack_of_opportunity_markers char_ix model =
   case (Array.get char_ix model.characters) of
      Nothing -> model
      (Just char) ->
         (regenerate_attack_of_opportunity_markers_of_char char_ix char model)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
tile_omnimods_fun : (
      Type ->
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type)
   )
tile_omnimods_fun model =
   (\loc -> (BattleMap.Struct.Map.get_omnimods_at loc model.tiles model.map))

new : Struct.Flags.Type -> Type
new flags =
   let
      maybe_battle_id = (Struct.Flags.maybe_get_param "id" flags)
      model =
         {
            flags = flags,
            help_request = Struct.HelpRequest.None,
            animator = Nothing,
            map = (BattleMap.Struct.Map.empty),
            characters = (Array.empty),
            weapons = (Dict.empty),
            armors = (Dict.empty),
            portraits = (Dict.empty),
            glyph_boards = (Dict.empty),
            glyphs = (Dict.empty),
            skills = (Dict.empty),
            tiles = (Dict.empty),
            players = (Array.empty),
            error = Nothing,
            battle_id = "",
            player_id =
               (
                  if (flags.user_id == "")
                  then "0"
                  else flags.user_id
               ),
            session_token = flags.token,
            player_ix = 0,
            ui = (Struct.UI.default),
            char_turn = (Struct.CharacterTurn.new),
            timeline = (Array.empty)
         }
   in
      case maybe_battle_id of
         Nothing ->
            (invalidate
               (Struct.Error.new
                  Struct.Error.Failure
                  "Could not find battle id."
               )
               model
            )

         (Just id) -> {model | battle_id = id}

add_character : Struct.Character.Type -> Type -> Type
add_character char model =
   let characters = model.characters in
      (regenerate_attack_of_opportunity_markers_of_char
         (Array.length characters)
         char
         {model | characters = (Array.push char characters)}
      )

add_weapon : BattleCharacters.Struct.Weapon.Type -> Type -> Type
add_weapon wp model =
   {model |
      weapons =
         (Dict.insert
            (BattleCharacters.Struct.Weapon.get_id wp)
            wp
            model.weapons
         )
   }

add_armor : BattleCharacters.Struct.Armor.Type -> Type -> Type
add_armor ar model =
   {model |
      armors =
         (Dict.insert
            (BattleCharacters.Struct.Armor.get_id ar)
            ar
            model.armors
         )
   }

add_portrait : BattleCharacters.Struct.Portrait.Type -> Type -> Type
add_portrait pt model =
   {model |
      portraits =
         (Dict.insert
            (BattleCharacters.Struct.Portrait.get_id pt)
            pt
            model.portraits
         )
   }

add_glyph_board : BattleCharacters.Struct.GlyphBoard.Type -> Type -> Type
add_glyph_board pt model =
   {model |
      glyph_boards =
         (Dict.insert
            (BattleCharacters.Struct.GlyphBoard.get_id pt)
            pt
            model.glyph_boards
         )
   }

add_glyph : BattleCharacters.Struct.Glyph.Type -> Type -> Type
add_glyph pt model =
   {model |
      glyphs =
         (Dict.insert
            (BattleCharacters.Struct.Glyph.get_id pt)
            pt
            model.glyphs
         )
   }

add_skill : BattleCharacters.Struct.Skill.Type -> Type -> Type
add_skill sk model =
   {model |
      skills =
         (Dict.insert
            (BattleCharacters.Struct.Skill.get_id sk)
            sk
            model.skills
         )
   }

add_player : Struct.Player.Type -> Type -> Type
add_player pl model =
   {model |
      players =
         (Array.push
            pl
            model.players
         ),
      player_ix =
         if ((Struct.Player.get_id pl) == model.player_id)
         then (Struct.Player.get_index pl)
         else model.player_ix
   }

add_tile : BattleMap.Struct.Tile.Type -> Type -> Type
add_tile tl model =
   {model |
      tiles =
         (Dict.insert
            (BattleMap.Struct.Tile.get_id tl)
            tl
            model.tiles
         )
   }

reset : Type -> Type
reset model =
   {model |
      help_request = Struct.HelpRequest.None,
      error = Nothing,
      ui =
         (Struct.UI.reset_displayed_nav
            (Struct.UI.set_previous_action Nothing model.ui)
         ),
      char_turn = (Struct.CharacterTurn.new)
   }

full_debug_reset : Type -> Type
full_debug_reset model =
   {model |
      help_request = Struct.HelpRequest.None,
      animator = Nothing,
      map = (BattleMap.Struct.Map.empty),
      characters = (Array.empty),
      weapons = (Dict.empty),
      armors = (Dict.empty),
      portraits = (Dict.empty),
      glyph_boards = (Dict.empty),
      glyphs = (Dict.empty),
      skills = (Dict.empty),
      tiles = (Dict.empty),
      error = Nothing,
      ui = (Struct.UI.default),
      char_turn = (Struct.CharacterTurn.new),
      timeline = (Array.empty)
   }

initialize_animator : Type -> Type
initialize_animator model =
   let
      timeline_list = (Array.toList model.timeline)
      (characters, players) =
         (List.foldr
            (\event (pcharacters, pplayers) ->
               (Struct.TurnResult.apply_inverse_step
                  (tile_omnimods_fun model)
                  event
                  pcharacters
                  pplayers
               )
            )
            (model.characters, model.players)
            timeline_list
         )
   in
      {model |
         animator =
            (Struct.TurnResultAnimator.maybe_new
               (List.reverse timeline_list)
               True
            ),
         ui = (Struct.UI.default),
         characters = characters,
         players = players
      }

move_animator_to_next_step : Type -> Type
move_animator_to_next_step model =
   case model.animator of
      Nothing -> model
      (Just animator) ->
         case (Struct.TurnResultAnimator.maybe_trigger_next_step animator) of
            Nothing ->
               (Set.foldl
                  (regenerate_attack_of_opportunity_markers)
                  {model | animator = Nothing }
                  (Struct.TurnResultAnimator.get_animated_character_indices
                     animator
                  )
               )

            just_next_animator -> {model | animator = just_next_animator }

apply_animator_step : Type -> Type
apply_animator_step model =
   case model.animator of
      Nothing -> model
      (Just animator) ->
         case (Struct.TurnResultAnimator.get_current_animation animator) of
            (Struct.TurnResultAnimator.TurnResult turn_result) ->
               let
                  (characters, players) =
                     (Struct.TurnResult.apply_step
                        (tile_omnimods_fun model)
                        turn_result
                        model.characters
                        model.players
                     )
               in
                  {model |
                     characters = characters,
                     players = players
                  }
            _ -> model

update_character : Int -> Struct.Character.Type -> Type -> Type
update_character ix new_val model =
   {model |
      characters = (Array.set ix new_val model.characters)
   }

update_character_fun : (
      Int ->
      ((Maybe Struct.Character.Type) -> (Maybe Struct.Character.Type)) ->
      Type ->
      Type
   )
update_character_fun ix fun model =
   {model |
      characters = (Util.Array.update ix (fun) model.characters)
   }

invalidate : Struct.Error.Type -> Type -> Type
invalidate err model =
   {model |
      error = (Just err)
   }

clear_error : Type -> Type
clear_error model = {model | error = Nothing}
