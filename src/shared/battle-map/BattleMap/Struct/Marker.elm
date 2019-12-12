module BattleMap.Struct.Marker exposing
   (
      Type,
      DataType,
      new,
      new_melee_attack,
      get_locations,
      set_locations,
      is_dangerous,
      get_data,
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
   | Tag
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

new_melee_attack : Int -> (Set.Set BattleMap.Struct.Location.Ref) -> Type
new_melee_attack char_ix locations =
   {
      locations = locations,
      data = (MeleeAttackZone {character_ix = char_ix})
   }

get_locations : Type -> (Set.Set BattleMap.Struct.Location.Ref)
get_locations marker = marker.locations

set_locations : (Set.Set BattleMap.Struct.Location.Ref) -> Type -> Type
set_locations locations marker = {marker | locations = locations}

get_data : Type -> DataType
get_data marker = marker.data

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

                  -- TODO/FIXME: Do not encode those, since they should not be
                  -- sent to the server.
                  _ -> (Json.Encode.null)
            )
         )
      ]
   )

is_dangerous : Type -> Bool
is_dangerous marker =
   case marker.data of
      (MeleeAttackZone _) -> True
      _ -> False
