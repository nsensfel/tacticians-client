module Struct.Character exposing
   (
      Type,
      Rank(..),
      Unresolved,
      get_index,
      get_player_index,
      get_rank,
      get_current_health,
      get_sane_current_health,
      set_current_health,
      get_location,
      set_location,
      dirty_set_location,
      is_enabled,
      is_defeated,
      is_alive,
      set_enabled,
      set_defeated,
      get_base_character,
      set_base_character,
      get_melee_attack_range,
      decoder,
      resolve
   )

-- Elm -------------------------------------------------------------------------
import Set

import Json.Decode
import Json.Decode.Pipeline

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods
import Battle.Struct.Statistics

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Rank =
   Optional
   | Target
   | Commander

type alias Type =
   {
      ix : Int,
      rank : Rank,
      location : BattleMap.Struct.Location.Type,
      health : Int,
      player_ix : Int,
      enabled : Bool,
      defeated : Bool,
      base : BattleCharacters.Struct.Character.Type
   }

type alias Unresolved =
   {
      ix : Int,
      rank : Rank,
      location : BattleMap.Struct.Location.Type,
      health : Int,
      player_ix : Int,
      enabled : Bool,
      defeated : Bool,
      base : BattleCharacters.Struct.Character.Unresolved
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
str_to_rank : String -> Rank
str_to_rank str =
   case str of
      "t" -> Target
      "c" -> Commander
      _ -> Optional

fix_health : Int -> Type -> Type
fix_health previous_max_health char =
   let
      new_max_health =
         (Battle.Struct.Statistics.get_max_health
            (BattleCharacters.Struct.Character.get_statistics char.base)
         )
   in
      {char |
         health =
            (clamp
               1
               new_max_health
               (round
                  (
                     ((toFloat char.health) / (toFloat previous_max_health))
                     * (toFloat new_max_health)
                  )
               )
            )
      }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_melee_attack_range : Type -> Int
get_melee_attack_range c =
   if (is_alive c)
   then
      (
         let
            active_weapon =
               (BattleCharacters.Struct.Character.get_active_weapon
                  (get_base_character c)
               )
         in
            case
               (BattleCharacters.Struct.Weapon.get_defense_range active_weapon)
            of
               0 ->
                  (BattleCharacters.Struct.Weapon.get_attack_range
                     active_weapon
                  )

               _ -> 0
      )
   else 0

get_index : Type -> Int
get_index c = c.ix

get_rank : Type -> Rank
get_rank c = c.rank

get_player_index : Type -> Int
get_player_index c = c.player_ix

get_current_health : Type -> Int
get_current_health c = c.health

get_sane_current_health : Type -> Int
get_sane_current_health c = (max 0 c.health)

set_current_health : Int -> Type -> Type
set_current_health health c = {c | health = health}

get_location : Type -> BattleMap.Struct.Location.Type
get_location t = t.location

set_location : (
      BattleMap.Struct.Location.Type ->
      Battle.Struct.Omnimods.Type ->
      Type ->
      Type
   )
set_location location omnimods char =
   let
      previous_max_health =
         (Battle.Struct.Statistics.get_max_health
            (BattleCharacters.Struct.Character.get_statistics char.base)
         )
   in
      (fix_health
         previous_max_health
         {char |
            location = location,
            base =
               (BattleCharacters.Struct.Character.set_extra_omnimods
                  omnimods
                  char.base
               )
         }
      )

dirty_set_location : BattleMap.Struct.Location.Type -> Type -> Type
dirty_set_location location char = { char | location = location }

get_base_character : Type -> BattleCharacters.Struct.Character.Type
get_base_character char = char.base

set_base_character : BattleCharacters.Struct.Character.Type -> Type -> Type
set_base_character new_base char =
   let
      previous_max_health =
         (Battle.Struct.Statistics.get_max_health
            (BattleCharacters.Struct.Character.get_statistics char.base)
         )
   in
      (fix_health
         previous_max_health
         {char | base = new_base}
      )

is_alive : Type -> Bool
is_alive char = ((char.health > 0) && (not char.defeated))

is_enabled : Type -> Bool
is_enabled char = char.enabled

is_defeated : Type -> Bool
is_defeated char = char.defeated

set_enabled : Bool -> Type -> Type
set_enabled enabled char = {char | enabled = enabled}

set_defeated : Bool -> Type -> Type
set_defeated defeated char = {char | defeated = defeated}

decoder : (Json.Decode.Decoder Unresolved)
decoder =
   (Json.Decode.succeed
      Unresolved
      |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
      |>
         (Json.Decode.Pipeline.required
            "rnk"
            (Json.Decode.map
               (str_to_rank)
               (Json.Decode.string)
            )
         )
      |> (Json.Decode.Pipeline.required "lc" BattleMap.Struct.Location.decoder)
      |> (Json.Decode.Pipeline.required "hea" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "pla" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "ena" Json.Decode.bool)
      |> (Json.Decode.Pipeline.required "dea" Json.Decode.bool)
      |>
         (Json.Decode.Pipeline.required
            "bas"
            (BattleCharacters.Struct.Character.decoder)
         )
   )

resolve : (
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type) ->
      (
         BattleCharacters.Struct.Equipment.Unresolved ->
         BattleCharacters.Struct.Equipment.Type
      ) ->
      Unresolved ->
      Type
   )
resolve location_omnimod_resolver equipment_resolver ref =
   {
      ix = ref.ix,
      rank = ref.rank,
      location = ref.location,
      health = ref.health,
      player_ix = ref.player_ix,
      enabled = ref.enabled,
      defeated = ref.defeated,
      base =
         (BattleCharacters.Struct.Character.resolve
            (equipment_resolver)
            (location_omnimod_resolver ref.location)
            ref.base
         )
   }
