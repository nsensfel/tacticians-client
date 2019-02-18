module Comm.SetMap exposing (decode)

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode

-- Battle ----------------------------------------------------------------------
import Constants.Movement

import Struct.Map
import Struct.MapMarker
import Struct.ServerReply
import Struct.Tile

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias MapData =
   {
      w : Int,
      h : Int,
      t : (List (List String)),
      m : (Dict.Dict String Struct.MapMarker.Type)
   }

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

deserialize_tile_instance : Int -> Int -> (List String) -> Struct.Tile.Instance
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
            []
         )

internal_decoder : MapData -> Struct.ServerReply.Type
internal_decoder map_data =
   (Struct.ServerReply.SetMap
      (Struct.Map.new
         map_data.w
         map_data.h
         (List.indexedMap
            (deserialize_tile_instance map_data.w)
            map_data.t
         )
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.map
      internal_decoder
      (Json.Decode.map4 MapData
         (Json.Decode.field "w" Json.Decode.int)
         (Json.Decode.field "h" Json.Decode.int)
         (Json.Decode.field
            "t"
            (Json.Decode.list (Json.Decode.list Json.Decode.string))
         )
         (Json.Decode.field
            "m"
            (Json.Decode.map
               (Dict.fromList)
               (Json.Decode.keyValuePairs (Struct.MapMarker.decoder))
            )
         )
      )
   )
