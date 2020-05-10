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

import Update.Sequence

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.DataSetItem
import BattleCharacters.Struct.Equipment

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSet
import BattleMap.Struct.DataSetItem
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
import Struct.Puppeteer
import Struct.PuppeteerAction
import Struct.ServerReply
import Struct.TurnResult

import Update.Puppeteer

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
disconnected : (
      Struct.Model.Type ->
      (Cmd Struct.Event.Type)
   )
disconnected model =
   (
      model,
      (Action.Ports.go_to
         (
            Constants.IO.base_url
            ++ "/login/?action=disconnect&goto="
            ++
            (Url.percentEncode
               (
                  "/battle/?"
                  ++ (Struct.Flags.get_parameters_as_url model.flags)
               )
            )
         )
      )
   )

add_characters_data_set_item : (
      BattleCharacters.Struct.DataSetItem.Type ->
      Struct.Model.Type ->
      (Cmd Struct.Event.Type)
   )
add_characters_data_set_item item model =
   (
      {model |
         characters_data_set =
            (BattleCharacters.Struct.DataSetItem.add_to
               item
               model.characters_data_set
            )
      },
      Cmd.none
   )

add_map_data_set_item : (
      BattleMap.Struct.DataSetItem.Type ->
      Struct.Model.Type ->
      (Cmd Struct.Event.Type)
   )
add_map_data_set_item item model =
   (
      {model |
         map_data_set =
            (BattleMap.Struct.DataSetItem.add_to item model.map_data_set)
      },
      Cmd.none
   )

add_player : (
      Struct.Player.Type ->
      Struct.Model.Type ->
      (Cmd Struct.Event.Type)
   )
add_player pl model =
   (
      {model |
         battle = (Struct.Battle.add_player model.flags pl model.battle)
      },
      Cmd.none
   )

add_character : (
      Struct.Character.Unresolved ->
      Struct.Model.Type ->
      (Cmd Struct.Event.Type)
   )
add_character unresolved_char model =
   (
      {model |
         battle =
            (Struct.Battle.add_character
               (Struct.Character.resolve
                  (\loc ->
                     (BattleMap.Struct.Map.get_omnimods_at
                        loc
                        model.map_data_set
                        (Struct.Battle.get_map model.battle)
                     )
                  )
                  (BattleCharacters.Struct.Equipment.resolve
                     model.characters_data_set
                  )
                  unresolved_char
               )
               model.battle
            )
      },
      Cmd.none
   )

set_map : (
      BattleMap.Struct.Map.Type ->
      Struct.Model.Type ->
      (Cmd Struct.Event.Type)
   )
set_map map model =
   (
      {model |
         battle =
            (Struct.Battle.set_map
               (BattleMap.Struct.Map.solve_tiles
                  model.map_data_set
                  map
               )
               model.battle
            )
      },
      Cmd.none
   )

add_to_timeline : (
      (List Struct.TurnResult.Type) ->
      Struct.Model.Type ->
      (Cmd Struct.Event.Type)
   )
add_to_timeline turn_results model =
   (Update.Puppeteer.apply_to
      (
         {model |
            puppeteer =
               (List.foldl
                  (\turn_result puppeteer ->
                     (Struct.Puppeteer.append_forward
                        (Struct.PuppeteerAction.from_turn_result
                           turn_result
                        )
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

set_timeline : (
      (List Struct.TurnResult.Type) ->
      Struct.Model.Type ->
      (Cmd Struct.Event.Type)
   )
set_timeline turn_results model =
   (
      {model |
         puppeteer =
            (List.foldr
               (\turn_result puppeteer ->
                  (Struct.Puppeteer.append_backward
                     (Struct.PuppeteerAction.from_turn_result turn_result)
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
      Cmd.none
   )

server_command_to_update : (
      Struct.ServerReply.Type ->
      (Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type)))
   )
server_command_to_update server_command =
   case server_command of
      Struct.ServerReply.Disconnected -> (disconnected)

      (Struct.ServerReply.AddCharactersDataSetItem item) ->
         (add_characters_data_set_item item)

      (Struct.ServerReply.AddMapDataSetItem item) ->
         (add_map_data_set_item item)

      (Struct.ServerReply.AddPlayer pl) ->
         (add_player pl)

      (Struct.ServerReply.AddCharacter char) ->
         (add_character char)

      (Struct.ServerReply.SetMap map) -> (set_map map)

      (Struct.ServerReply.TurnResults results) -> (add_to_timeline results)

      (Struct.ServerReply.SetTimeline timeline) -> (set_timeline timeline)

      Struct.ServerReply.Okay -> (do_nothing)

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

      (Result.Ok server_command) ->
         (Update.Sequence.sequence
            (List.map (server_command_to_update) commands)
            model
         )
