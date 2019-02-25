module Comm.SetMap exposing (decode)

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode

-- Map -------------------------------------------------------------------------
import Constants.Movement

import Struct.Map
import Struct.MapMarker
import Struct.ServerReply
import Struct.Tile
import Struct.TileInstance

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
deserialize_tile_borders : (
      (List String) ->
      (List Struct.Tile.Border) ->
      (List Struct.Tile.Border)
   )
deserialize_tile_borders rem_ints current_borders =
   case rem_ints of
      [] -> (List.reverse current_borders)
      (a :: (b :: c)) ->
         (deserialize_tile_borders
            c
            ((Struct.Tile.new_border a b) :: current_borders)
         )

      _ -> []

deserialize_tile_instance : (
      Int ->
      Int ->
      (List String) ->
      Struct.Tile.Instance
   )
deserialize_tile_instance map_width index t =
   case t of
      (a :: (b :: c)) ->
         (Struct.Tile.new_instance
            {
               x = (modBy map_width index),
               y = (index // map_width)
            }
            a
            b
            Constants.Movement.cost_when_out_of_bounds
            "-1"
            (deserialize_tile_borders c [])
         )

      _ ->
         (Struct.Tile.new_instance
            {
               x = (modBy map_width index),
               y = (index // map_width)
            }
            "0"
            "0"
            Constants.Movement.cost_when_out_of_bounds
            "-1"
            []
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.map
      (\map -> (Struct.ServerReply.SetMap map))
      (Struct.Map.decoder)
   )
