module BattleMap.Struct.Marker exposing
   (
      Type,
      new,
      get_locations,
      set_locations,
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
type alias MeleeAttackZoneStruct =
   {
      character_ix : Int
   }

type alias SpawnZoneStruct =
   {
      player_ix : Int
   }

type DataType =
   MeleeAttackZone MeleeAttackZoneStruct
   | SpawnZone SpawnZoneStruct
   | None

type alias Type =
   {
      locations : (Set.Set BattleMap.Struct.Location.Ref),
      data : DataType
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
decoder_internals : String -> (Json.Decode.Decoder DataType)
decoder_internals t =
   case t of
      "matk" ->
         (Json.Decode.map
            (\e -> (MeleeAttackZone e))
            (Json.Decode.map
               MeleeAttackZoneStruct
               (Json.Decode.field "cix" (Json.Decode.int))
            )
         )

      "spawn" ->
         (Json.Decode.map
            (\e -> (SpawnZone e))
            (Json.Decode.map
               SpawnZoneStruct
               (Json.Decode.field "pix" (Json.Decode.int))
            )
         )

      _ -> (Json.Decode.succeed None)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Type
new =
   {
      locations = (Set.empty),
      data = None
   }

get_locations : Type -> (Set.Set BattleMap.Struct.Location.Ref)
get_locations marker = marker.locations

set_locations : (Set.Set BattleMap.Struct.Location.Ref) -> Type -> Type
set_locations locations marker = {marker | locations = locations}

is_in_locations : BattleMap.Struct.Location.Ref -> Type -> Bool
is_in_locations loc_ref marker = (Set.member loc_ref marker.locations)

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map2
      Type
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
      (Json.Decode.andThen
         (decoder_internals)
         (Json.Decode.field "t" (Json.Decode.string))
      )
   )

encode : Type -> Json.Encode.Value
encode marker =
   (Json.Encode.object
      [
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
         ),
         (
            "d",
            (
               case marker.data of
                  SpawnZone zone ->
                     (Json.Encode.object
                        [
                           ("t", (Json.Encode.string "spawn")),
                           ("pix", (Json.Encode.int zone.player_ix))
                        ]
                     )

                  MeleeAttackZone zone ->
                     (Json.Encode.object
                        [
                           ("t", (Json.Encode.string "matk")),
                           ("cix", (Json.Encode.int zone.character_ix))
                        ]
                     )

                  None ->
                     (Json.Encode.object
                        [
                           ("t", (Json.Encode.string "none"))
                        ]
                     )
            )
         )
      ]
   )
