module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Delay

import Dict

import Http

import Time

-- Map -------------------------------------------------------------------
import Struct.Map
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.ServerReply
import Struct.Tile
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
add_tile : (
      Struct.Tile.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
add_tile tl current_state =
   case current_state of
      (_, (Just _)) -> current_state
      (model, _) -> ((Struct.Model.add_tile tl model), Nothing)

set_map : (
      Struct.Map.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
set_map map current_state =
   case current_state of
      (_, (Just _)) -> current_state
      (model, _) ->
         (
            {model |
               map = (Struct.Map.solve_tiles (Dict.values model.tiles) map)
            },
            Nothing
         )

apply_command : (
      Struct.ServerReply.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
apply_command command current_state =
   case command of
      (Struct.ServerReply.AddTile tl) ->
         (add_tile tl current_state)

      (Struct.ServerReply.SetMap map) ->
         (set_map map current_state)

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
               (Struct.Error.new Struct.Error.Networking (toString error))
               model
            ),
            Cmd.none
         )

      (Result.Ok commands) ->
         case (List.foldl (apply_command) (model, Nothing) commands) of
            (updated_model, Nothing) -> updated_model
            (_, (Just error)) -> (Struct.Model.invalidate error model)
