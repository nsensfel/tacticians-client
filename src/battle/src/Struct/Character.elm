module Struct.Character exposing
   (
      Type,
      Unresolved,
      get_index,
      get_player_index,
      get_current_health,
      get_sane_current_health,
      set_current_health,
      get_current_skill_points,
      set_current_skill_points,
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
      refresh_omnimods,
      add_extra_display_effect,
      toggle_extra_display_effect,
      remove_extra_display_effect,
      get_extra_display_effects,
      get_extra_display_effects_list,
      reset_extra_display_effects,
      decoder,
      resolve
   )

-- Elm -------------------------------------------------------------------------
import Set

import Json.Decode
import Json.Decode.Pipeline

-- Shared ----------------------------------------------------------------------
import Shared.Util.Set

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods
import Battle.Struct.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.StatusIndicator
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      ix : Int,
      location : BattleMap.Struct.Location.Type,
      health : Int,
      skill_points : Int,
      status_indicators : (List BattleCharacters.Struct.StatusIndicator.Type),
      player_ix : Int,
      enabled : Bool,
      defeated : Bool,
      base : BattleCharacters.Struct.Character.Type,
      extra_display_effects : (Set.Set String)
   }

type alias Unresolved =
   {
      ix : Int,
      location : BattleMap.Struct.Location.Type,
      health : Int,
      skill_points : Int,
      status_indicators : (List BattleCharacters.Struct.StatusIndicator.Type),
      player_ix : Int,
      enabled : Bool,
      defeated : Bool,
      base : BattleCharacters.Struct.Character.Unresolved
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
fix_health : Int -> Type -> Type
fix_health previous_max_health char =
   let
      new_max_health =
         (Battle.Struct.Attributes.get_max_health
            (BattleCharacters.Struct.Character.get_attributes char.base)
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

get_player_index : Type -> Int
get_player_index c = c.player_ix

get_current_health : Type -> Int
get_current_health c = c.health

get_sane_current_health : Type -> Int
get_sane_current_health c = (max 0 c.health)

set_current_health : Int -> Type -> Type
set_current_health health c = {c | health = health}

get_current_skill_points : Type -> Int
get_current_skill_points c = c.skill_points

set_current_skill_points : Int -> Type -> Type
set_current_skill_points skill_points c = {c | skill_points = skill_points}

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
         (Battle.Struct.Attributes.get_max_health
            (BattleCharacters.Struct.Character.get_attributes char.base)
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

refresh_omnimods : (
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type) ->
      Type ->
      Type
   )
refresh_omnimods omnimods_fun char =
   let
      previous_max_health =
         (Battle.Struct.Attributes.get_max_health
            (BattleCharacters.Struct.Character.get_attributes char.base)
         )
   in
      (fix_health
         previous_max_health
         {char |
            base =
               (BattleCharacters.Struct.Character.set_extra_omnimods
                  (omnimods_fun char.location)
                  char.base
               )
         }
      )

get_base_character : Type -> BattleCharacters.Struct.Character.Type
get_base_character char = char.base

set_base_character : BattleCharacters.Struct.Character.Type -> Type -> Type
set_base_character new_base char =
   let
      previous_max_health =
         (Battle.Struct.Attributes.get_max_health
            (BattleCharacters.Struct.Character.get_attributes char.base)
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

add_extra_display_effect : String -> Type -> Type
add_extra_display_effect effect_name char =
   {char |
      extra_display_effects =
         (Set.insert effect_name char.extra_display_effects)
   }

toggle_extra_display_effect : String -> Type -> Type
toggle_extra_display_effect effect_name tile =
   {tile |
      extra_display_effects =
         (Shared.Util.Set.toggle effect_name tile.extra_display_effects)
   }

remove_extra_display_effect : String -> Type -> Type
remove_extra_display_effect effect_name char =
   {char |
      extra_display_effects =
         (Set.remove effect_name char.extra_display_effects)
   }

get_extra_display_effects : Type -> (Set.Set String)
get_extra_display_effects char = char.extra_display_effects

get_extra_display_effects_list : Type -> (List String)
get_extra_display_effects_list char = (Set.toList char.extra_display_effects)

reset_extra_display_effects : Int -> Type -> Type
reset_extra_display_effects viewer_ix char =
   {char |
      extra_display_effects =
         (Set.fromList
            [
               (
                  if (viewer_ix == char.player_ix)
                  then "ally"
                  else "enemy"
               ),
               ("team-" ++ (String.fromInt char.player_ix)),
               (
                  if (char.enabled)
                  then "enabled"
                  else "disabled"
               ),
               (
                  if (is_alive char)
                  then "alive"
                  else "dead"
               )
            ]
         )
   }

decoder : Int -> (Json.Decode.Decoder Unresolved)
decoder ix =
   (Json.Decode.succeed
      Unresolved
      |> (Json.Decode.Pipeline.hardcoded ix)
      |> (Json.Decode.Pipeline.required "lc" BattleMap.Struct.Location.decoder)
      |> (Json.Decode.Pipeline.required "he" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "sp" Json.Decode.int)
      |>
         (Json.Decode.Pipeline.required
            "sti"
            (Json.Decode.list (BattleCharacters.Struct.StatusIndicator.decoder))
         )
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
      location = ref.location,
      health = ref.health,
      skill_points = ref.skill_points,
      player_ix = ref.player_ix,
      status_indicators = ref.status_indicators,
      enabled = ref.enabled,
      defeated = ref.defeated,
      base =
         (BattleCharacters.Struct.Character.resolve
            (equipment_resolver)
            (location_omnimod_resolver ref.location)
            ref.base
         ),
      extra_display_effects = (Set.empty)
   }
