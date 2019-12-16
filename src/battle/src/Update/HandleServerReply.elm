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
import BattleCharacters.Struct.DataSetItem

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
import Struct.UI

import Update.Puppeteer

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

add_characters_dataset_item : (
      BattleCharacters.Struct.DataSetItem.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_characters_dataset_item item current_state =
   let (model, cmds) = current_state in
      (
         {model |
            characters_dataset =
               (BattleCharacters.Struct.DataSetItem.add_to
                  item
                  model.characters_dataset
               )
         },
         cmds
      )

add_map_dataset_item : (
      BattleMap.Struct.Tile.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_map_dataset_item item current_state =
   let (model, cmds) = current_state in
      (
         {model |
            map_dataset =
               (BattleMap.Struct.DataSetItem.add_to
                  item
                  model.map_dataset
               )
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
   let
      (model, cmds) = current_state
      (next_model, more_cmds) =
         (Update.Puppeteer.apply_to
            (
               {model |
                  puppeteer =
                     (List.foldl
                        (\tr puppeteer ->
                           (Struct.Puppeteer.append_forward
                              (Struct.PuppeteerAction.from_turn_result tr)
                              puppeteer
                           )
                        )
                        model.puppeteer
                        turn_results
                     ),
                  battle =
                     (Struct.Battle.set_timeline
                        (Array.append
                           (Array.fromList turn_results)
                           (Struct.Battle.get_timeline model.battle)
                        )
                        model.battle
                     )
               }
            )
         )
   in
      (
         next_model,
         if (mode_cmds == Cmd.none)
         then cmd
         else [more_cmds|cmd]
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
            puppeteer =
               (List.foldr
                  (\tr puppeteer ->
                     (Struct.Puppeteer.append_backward
                        (Struct.PuppeteerAction.from_turn_result tr)
                        puppeteer
                     )
                  )
                  model.puppeteer
                  turn_results
               ),
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

      (Struct.ServerReply.AddCharactersDataSetItem item) ->
         (add_characters_dataset_item item current_state)

      (Struct.ServerReply.AddMapDataSetItem item) ->
         (add_map_dataset_item item current_state)

      (Struct.ServerReply.AddPlayer pl) ->
         (add_player pl current_state)

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
