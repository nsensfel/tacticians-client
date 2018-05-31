module Data.Weapons exposing (generate_dict, none)
-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Weapon

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
dataset : (List (Struct.Weapon.Ref, Struct.Weapon.Type))
dataset =
   [
      -- TODO: have those in separate text files, and put them here only at
      -- compilation.
      (
         0,
         (Struct.Weapon.new
            0
            "None"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Short
            Struct.Weapon.Blunt
            Struct.Weapon.Light
         )
      ),
      (
         1,
         (Struct.Weapon.new
            1
            "Dagger"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Short
            Struct.Weapon.Slash
            Struct.Weapon.Light
         )
      ),
      (
         2,
         (Struct.Weapon.new
            2
            "Sword"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Short
            Struct.Weapon.Slash
            Struct.Weapon.Heavy
         )
      ),
      (
         3,
         (Struct.Weapon.new
            3
            "Claymore"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Long
            Struct.Weapon.Slash
            Struct.Weapon.Light
         )
      ),
      (
         4,
         (Struct.Weapon.new
            4
            "Bardiche"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Long
            Struct.Weapon.Slash
            Struct.Weapon.Heavy
         )
      ),
      (
         5,
         (Struct.Weapon.new
            5
            "Stiletto"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Short
            Struct.Weapon.Pierce
            Struct.Weapon.Light
         )
      ),
      (
         6,
         (Struct.Weapon.new
            6
            "Pickaxe"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Short
            Struct.Weapon.Pierce
            Struct.Weapon.Heavy
         )
      ),
      (
         7,
         (Struct.Weapon.new
            7
            "Rapier"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Long
            Struct.Weapon.Pierce
            Struct.Weapon.Light
         )
      ),
      (
         8,
         (Struct.Weapon.new
            8
            "Pike"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Long
            Struct.Weapon.Pierce
            Struct.Weapon.Heavy
         )
      ),
      (
         9,
         (Struct.Weapon.new
            9
            "Club"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Short
            Struct.Weapon.Blunt
            Struct.Weapon.Light
         )
      ),
      (
         10,
         (Struct.Weapon.new
            10
            "Mace"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Short
            Struct.Weapon.Blunt
            Struct.Weapon.Heavy
         )
      ),
      (
         11,
         (Struct.Weapon.new
            11
            "Staff"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Long
            Struct.Weapon.Blunt
            Struct.Weapon.Light
         )
      ),
      (
         12,
         (Struct.Weapon.new
            12
            "War Hammer"
            1.0
            Struct.Weapon.Melee
            Struct.Weapon.Long
            Struct.Weapon.Blunt
            Struct.Weapon.Heavy
         )
      ),
      (
         13,
         (Struct.Weapon.new
            13
            "Short Bow (Broadhead)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Short
            Struct.Weapon.Slash
            Struct.Weapon.Light
         )
      ),
      (
         14,
         (Struct.Weapon.new
            14
            "Short Bow (Blunt)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Short
            Struct.Weapon.Blunt
            Struct.Weapon.Light
         )
      ),
      (
         15,
         (Struct.Weapon.new
            15
            "Short Bow (Bodkin Point)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Short
            Struct.Weapon.Pierce
            Struct.Weapon.Light
         )
      ),
      (
         16,
         (Struct.Weapon.new
            16
            "Long Bow (Broadhead)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Long
            Struct.Weapon.Slash
            Struct.Weapon.Light
         )
      ),
      (
         17,
         (Struct.Weapon.new
            17
            "Long Bow (Blunt)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Long
            Struct.Weapon.Blunt
            Struct.Weapon.Light
         )
      ),
      (
         18,
         (Struct.Weapon.new
            18
            "Long Bow (Bodkin Point)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Long
            Struct.Weapon.Pierce
            Struct.Weapon.Light
         )
      ),
      (
         19,
         (Struct.Weapon.new
            19
            "Crossbow (Broadhead)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Short
            Struct.Weapon.Slash
            Struct.Weapon.Heavy
         )
      ),
      (
         20,
         (Struct.Weapon.new
            20
            "Crossbow (Blunt)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Short
            Struct.Weapon.Blunt
            Struct.Weapon.Heavy
         )
      ),
      (
         21,
         (Struct.Weapon.new
            21
            "Crossbow (Bodkin Point)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Short
            Struct.Weapon.Pierce
            Struct.Weapon.Heavy
         )
      ),
      (
         22,
         (Struct.Weapon.new
            22
            "Arbalest (Broadhead)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Long
            Struct.Weapon.Slash
            Struct.Weapon.Heavy
         )
      ),
      (
         23,
         (Struct.Weapon.new
            23
            "Arbalest (Blunt)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Long
            Struct.Weapon.Blunt
            Struct.Weapon.Heavy
         )
      ),
      (
         24,
         (Struct.Weapon.new
            24
            "Arbalest (Bodkin Point)"
            1.0
            Struct.Weapon.Ranged
            Struct.Weapon.Long
            Struct.Weapon.Pierce
            Struct.Weapon.Heavy
         )
      )
   ]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
generate_dict : (Dict.Dict Struct.Weapon.Ref Struct.Weapon.Type)
generate_dict = (Dict.fromList dataset)

-- If it's not found.
none : (Struct.Weapon.Type)
none =
   (Struct.Weapon.new
      0
      "None"
      1.0
      Struct.Weapon.Melee
      Struct.Weapon.Short
      Struct.Weapon.Blunt
      Struct.Weapon.Light
   )
