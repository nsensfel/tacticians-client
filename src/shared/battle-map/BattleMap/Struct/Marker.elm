module BattleMap.Struct.Marker exposing
   (
      Type,
      new,
      get_locations,
      is_in_locations,
      decoder,
      encode
   )

-- Elm -------------------------------------------------------------------------
import Set
import Json.Decode
import Json.Encode
import List

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      permissions : (Set.Set String),
      locations : (Set.Set BattleMap.Struct.Location.Ref)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------

new : Type
new =
   {
      permissions = (Set.empty),
      locations = (Set.empty)
   }

get_locations : Type -> (Set.Set BattleMap.Struct.Location.Ref)
get_locations marker = marker.locations

is_in_locations : BattleMap.Struct.Location.Ref -> Type -> Bool
is_in_locations loc_ref marker =
   (Set.member loc_ref marker.locations)

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map2
      Type
      (Json.Decode.field
         "p"
         (Json.Decode.map
            (Set.fromList)
            (Json.Decode.list (Json.Decode.string))
         )
      )
      (Json.Decode.field
         "l"
         (Json.Decode.map
            (Set.fromList)
            (Json.Decode.list
               (Json.Decode.map
                  (BattleMap.Struct.Location.get_ref)
                  (BattleMap.Struct.Location.decoder)
               )
            )
         )
      )
   )

encode : Type -> Json.Encode.Value
encode marker =
   (Json.Encode.object
      [
         (
            "p",
            (Json.Encode.list
               (Json.Encode.string)
               (Set.toList marker.permissions)
            )
         ),
         (
            "l",
            (Json.Encode.list
               (\e ->
                  (BattleMap.Struct.Location.encode
                     (BattleMap.Struct.Location.from_ref e)
                  )
               )
               (Set.toList marker.locations)
            )
         )
      ]
   )
