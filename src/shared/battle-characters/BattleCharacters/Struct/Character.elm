module BattleCharacters.Struct.Character exposing
   (
      Type,
      Unresolved,
      get_name,
      set_name,
      get_equipment,
      set_equipment,
      dirty_set_equipment,
      get_omnimods,
      set_extra_omnimods,
      dirty_set_extra_omnimods,
      get_statistics,
      get_active_weapon,
      get_inactive_weapon,
      is_using_secondary,
      switch_weapons,
      dirty_switch_weapons,
      decoder,
      encode,
      resolve,
      to_unresolved
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

import Json.Encode

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods
import Battle.Struct.Statistics

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Weapon
import BattleCharacters.Struct.GlyphBoard

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      name : String,
      equipment : BattleCharacters.Struct.Equipment.Type,
      statistics : Battle.Struct.Statistics.Type,
      is_using_secondary : Bool,
      omnimods : Battle.Struct.Omnimods.Type,
      extra_omnimods : Battle.Struct.Omnimods.Type
   }

type alias Unresolved =
   {
      name : String,
      equipment : BattleCharacters.Struct.Equipment.Unresolved,
      is_using_secondary : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
refresh_omnimods : Type -> Type
refresh_omnimods char =
   let
      equipment = char.equipment
      omnimods =
         (Battle.Struct.Omnimods.merge
            (Battle.Struct.Omnimods.merge
               (Battle.Struct.Omnimods.merge
                  char.extra_omnimods
                  (BattleCharacters.Struct.Weapon.get_omnimods
                     (get_active_weapon char)
                  )
               )
               (BattleCharacters.Struct.Armor.get_omnimods
                  (BattleCharacters.Struct.Equipment.get_armor equipment)
               )
            )
            (BattleCharacters.Struct.GlyphBoard.get_omnimods_with_glyphs
               (BattleCharacters.Struct.Equipment.get_glyphs equipment)
               (BattleCharacters.Struct.Equipment.get_glyph_board equipment)
            )
         )
      statistics =
         (Battle.Struct.Omnimods.apply_to_statistics
            omnimods
            (Battle.Struct.Statistics.default)
         )
   in
      {char |
         statistics = statistics,
         omnimods = omnimods
      }


--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_active_weapon : Type -> BattleCharacters.Struct.Weapon.Type
get_active_weapon char =
   if (char.is_using_secondary)
   then (BattleCharacters.Struct.Equipment.get_secondary_weapon char.equipment)
   else (BattleCharacters.Struct.Equipment.get_primary_weapon char.equipment)

get_inactive_weapon : Type -> BattleCharacters.Struct.Weapon.Type
get_inactive_weapon char =
   if (char.is_using_secondary)
   then (BattleCharacters.Struct.Equipment.get_primary_weapon char.equipment)
   else (BattleCharacters.Struct.Equipment.get_secondary_weapon char.equipment)

get_name : Type -> String
get_name c = c.name

set_name : String -> Type -> Type
set_name name char = {char | name = name}

get_equipment : Type -> BattleCharacters.Struct.Equipment.Type
get_equipment c = c.equipment

set_equipment : BattleCharacters.Struct.Equipment.Type -> Type -> Type
set_equipment equipment char = (refresh_omnimods {char | equipment = equipment})

dirty_set_equipment : BattleCharacters.Struct.Equipment.Type -> Type -> Type
dirty_set_equipment equipment char = {char | equipment = equipment}

get_omnimods : Type -> Battle.Struct.Omnimods.Type
get_omnimods char = char.omnimods

set_extra_omnimods : Battle.Struct.Omnimods.Type -> Type -> Type
set_extra_omnimods om char = (refresh_omnimods {char | extra_omnimods = om})

dirty_set_extra_omnimods : Battle.Struct.Omnimods.Type -> Type -> Type
dirty_set_extra_omnimods om char = {char | extra_omnimods = om}

get_statistics : Type -> Battle.Struct.Statistics.Type
get_statistics char = char.statistics

is_using_secondary : Type -> Bool
is_using_secondary char = char.is_using_secondary

switch_weapons : Type -> Type
switch_weapons char =
   (refresh_omnimods
      {char | is_using_secondary = (not char.is_using_secondary)}
   )

dirty_switch_weapons : Type -> Type
dirty_switch_weapons char =
   {char | is_using_secondary = (not char.is_using_secondary)}

decoder : (Json.Decode.Decoder Unresolved)
decoder =
   (Json.Decode.succeed
      Unresolved
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |>
         (Json.Decode.Pipeline.required
            "eq"
            BattleCharacters.Struct.Equipment.decoder
         )
      |> (Json.Decode.Pipeline.required "sec" Json.Decode.bool)
   )

to_unresolved : Type -> Unresolved
to_unresolved char =
   {
      name = char.name,
      equipment =
         (BattleCharacters.Struct.Equipment.to_unresolved char.equipment),
      is_using_secondary = char.is_using_secondary
   }

encode : Unresolved -> Json.Encode.Value
encode ref =
   (Json.Encode.object
      [
         ("nam", (Json.Encode.string ref.name)),
         ("eq", (BattleCharacters.Struct.Equipment.encode ref.equipment)),
         ("sec", (Json.Encode.bool ref.is_using_secondary))
      ]
   )

resolve : (
      (
         BattleCharacters.Struct.Equipment.Unresolved ->
         BattleCharacters.Struct.Equipment.Type
      ) ->
      Battle.Struct.Omnimods.Type ->
      Unresolved ->
      Type
   )
resolve resolve_equipment extra_omnimods ref =
   (refresh_omnimods
      {
         name = ref.name,
         equipment = (resolve_equipment ref.equipment),
         statistics = (Battle.Struct.Statistics.default),
         is_using_secondary = ref.is_using_secondary,
         omnimods = (Battle.Struct.Omnimods.none),
         extra_omnimods = extra_omnimods
      }
   )
