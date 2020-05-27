module Util.Navigator exposing
   (
      get_character_navigator,
      get_character_attack_navigator
   )

-- Elm -------------------------------------------------------------------------
import Array
import List

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_character_navigator : (
      Struct.Battle.Type ->
      Struct.Character.Type ->
      Struct.Navigator.Type
   )
get_character_navigator battle char =
   let
      base_char = (Struct.Character.get_base_character char)
      weapon = (BattleCharacters.Struct.Character.get_active_weapon base_char)
   in
      (Struct.Navigator.new
         (Struct.Character.get_location char)
         (Battle.Struct.Attributes.get_movement_points
            (BattleCharacters.Struct.Character.get_attributes base_char)
         )
         (BattleCharacters.Struct.Weapon.get_defense_range weapon)
         (BattleCharacters.Struct.Weapon.get_attack_range weapon)
         (BattleMap.Struct.Map.get_tile_data_function
            (Struct.Battle.get_map battle)
            (List.map
               (Struct.Character.get_location)
               (Array.toList
                  (Struct.Battle.get_characters battle)
               )
            )
            (Struct.Character.get_location char)
         )
      )

get_character_attack_navigator : (
      Struct.Battle.Type ->
      Struct.Character.Type ->
      Struct.Navigator.Type
   )
get_character_attack_navigator battle char =
   let
      base_char = (Struct.Character.get_base_character char)
      weapon = (BattleCharacters.Struct.Character.get_active_weapon base_char)
   in
      (Struct.Navigator.new
         (Struct.Character.get_location char)
         0
         (BattleCharacters.Struct.Weapon.get_defense_range weapon)
         (BattleCharacters.Struct.Weapon.get_attack_range weapon)
         (BattleMap.Struct.Map.get_tile_data_function
            (Struct.Battle.get_map battle)
            (List.map
               (Struct.Character.get_location)
               (Array.toList
                  (Struct.Battle.get_characters battle)
               )
            )
            (Struct.Character.get_location char)
         )
      )
