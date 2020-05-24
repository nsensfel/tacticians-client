module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Http

import Url

-- Shared ----------------------------------------------------------------------
import Shared.Action.Ports

import Shared.Struct.Flags

import Shared.Util.Http

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map
import BattleMap.Struct.DataSetItem

-- Local Module ----------------------------------------------------------------
import Constants.IO

import Struct.Error
import Struct.Event
import Struct.Model
import Struct.ServerReply
import Struct.TilePattern

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
            (Shared.Action.Ports.go_to
               (
                  Constants.IO.base_url
                  ++ "/login/?action=disconnect&goto="
                  ++
                  (Url.percentEncode
                     (
                        "/map-editor/?"
                        ++
                        (Shared.Struct.Flags.get_parameters_as_url model.flags)
                     )
                  )
               )
            )
         ]
      )

add_map_dataset_item : (
      BattleMap.Struct.DataSetItem.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_map_dataset_item item current_state =
   let (model, cmds) = current_state in
      (
         {model |
            map_dataset =
               (BattleMap.Struct.DataSetItem.add_to item model.map_dataset)
         },
         cmds
      )

add_tile_pattern : (
      Struct.TilePattern.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
add_tile_pattern tp current_state =
   let (model, cmds) = current_state in
      ((Struct.Model.add_tile_pattern tp model), cmds)

set_map : (
      BattleMap.Struct.Map.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
set_map map current_state =
   let (model, cmds) = current_state in
      (
         {model |
            map = (BattleMap.Struct.Map.solve_tiles model.map_dataset map)
         },
         cmds
      )

refresh_map : (
      (Struct.Model.Type, (List (Cmd Struct.Event.Type))) ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
refresh_map current_state =
   let (model, cmds) = current_state in
      (
         {model |
            map = (BattleMap.Struct.Map.solve_tiles model.map_dataset model.map)
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

      (Struct.ServerReply.AddMapDataSetItem it) ->
         (add_map_dataset_item it current_state)

      (Struct.ServerReply.AddTilePattern tp) ->
         (add_tile_pattern tp current_state)

      (Struct.ServerReply.SetMap map) ->
         (set_map map current_state)

      Struct.ServerReply.Okay ->
         (refresh_map current_state)

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
               (Struct.Error.new
                  Struct.Error.Networking
                  (Shared.Util.Http.error_to_string error)
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
