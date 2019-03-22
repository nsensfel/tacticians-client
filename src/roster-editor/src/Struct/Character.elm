module Struct.Character exposing
   (
      Type,
      new,
      get_index,
      get_battle_index,
      set_battle_index,
      get_name,
      set_name,
      get_equipment,
      set_equipment,
      get_current_omnimods,
      get_attributes,
      get_statistics,
      get_is_using_secondary,
      set_was_edited,
      get_was_edited,
      switch_weapons
   )

-- Elm -------------------------------------------------------------------------

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods
import Battle.Struct.Attributes
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
      ix : Int,
      battle_ix : Int,
      name : String,
      equipment : BattleCharacters.Struct.Equipment,
      attributes : Battle.Struct.Attributes.Type,
      statistics : Battle.Struct.Statistics.Type,
      is_using_secondary : Bool,
      current_omnimods : Battle.Struct.Omnimods.Type,
      was_edited : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
refresh_omnimods : Type -> Type
refresh_omnimods char =
   let
      equipment = char.equipment
      current_omnimods =
         (Battle.Struct.Omnimods.merge
            (Battle.Struct.Omnimods.merge
               (BattleCharacters.Struct.Weapon.get_omnimods
                  (
                     if (char.is_using_secondary)
                     then
                        (BattleCharacters.Struct.Equipment.get_secondary_weapon
                           equipment
                        )
                     else
                        (BattleCharacters.Struct.Equipment.get_primary_weapon
                           equipment
                        )
                  )
               )
               (BattleCharacters.Struct.Armor.get_omnimods char.armor)
            )
            (BattleCharacters.Struct.GlyphBoard.get_omnimods_with_glyphs
               (BattleCharacters.Struct.Equipment.get_glyphs equipment)
               (BattleCharacters.Struct.Equipment.get_glyph_board equipment)
            )
         )
      current_attributes =
         (Battle.Struct.Omnimods.apply_to_attributes
            current_omnimods
            (Battle.Struct.Attributes.default)
         )
      current_statistics =
         (Battle.Struct.Omnimods.apply_to_statistics
            current_omnimods
            (Battle.Struct.Statistics.new_raw current_attributes)
         )
   in
      {char |
         attributes = current_attributes,
         statistics = current_statistics,
         current_omnimods = current_omnimods
      }


--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : (
      Int ->
      String ->
      BattleCharacters.Struct.Equipment.Type ->
      Type
   )
new index name equipment =
   (refresh_omnimods
      {
         ix = index,
         battle_ix = -1,
         name = name,
         equipment = equipment,
         attributes = (Battle.Struct.Attributes.default),
         statistics =
            (Battle.Struct.Statistics.new_raw
               (Battle.Struct.Attributes.default)
            ),
         is_using_secondary = False,
         current_omnimods = (Battle.Struct.Omnimods.none),
         was_edited = False
      }
   )

get_index : Type -> Int
get_index c = c.ix

get_battle_index : Type -> Int
get_battle_index c = c.battle_ix

set_battle_index : Int -> Type -> Type
set_battle_index battle_ix c = {c | battle_ix = battle_ix}

get_name : Type -> String
get_name c = c.name

set_name : String -> Type -> Type
set_name name char = {char | name = name}

get_equipment : Type -> BattleCharacters.Struct.Equipment.Type
get_equipment c = c.equipment

set_equipment : BattleCharacters.Struct.Equipment.Type -> Type -> Type
set_equipment equipment char = (refresh_omnimods {char | equipment = equipment})

get_current_omnimods : Type -> Battle.Struct.Omnimods.Type
get_current_omnimods c = c.current_omnimods

get_attributes : Type -> Battle.Struct.Attributes.Type
get_attributes char = char.attributes

get_statistics : Type -> Battle.Struct.Statistics.Type
get_statistics char = char.statistics

get_is_using_secondary : Type -> Bool
get_is_using_secondary char = char.is_using_secondary

get_was_edited : Type -> Bool
get_was_edited char = char.was_edited

set_was_edited : Bool -> Type -> Type
set_was_edited val char = {char | was_edited = val}

switch_weapons : Type -> Type
switch_weapons char =
   (refresh_omnimods
      {char | is_using_secondary = (not char.is_using_secondary)}
   )
