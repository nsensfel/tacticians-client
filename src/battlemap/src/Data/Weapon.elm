module Data.Weapon exposing (generate_dict, shim_none)
-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Weapon

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
dataset : (List (Int, Struct.Weapon.Type))
dataset =
   [
      -- TODO: have those in separate text files, and put them here only at
      -- compilation.
      (
         0,
         (Struct.Weapon.new
            0
            "None"
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
            Struct.Weapon.Melee
            Struct.Weapon.Long
            Struct.Weapon.Blunt
            Struct.Weapon.Light
         )
      ),
      (
         13,
         (Struct.Weapon.new
            13
            "Short Bow (Broadhead)"
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
            Struct.Weapon.Ranged
            Struct.Weapon.Short
            Struct.Weapon.Pierce
            Struct.Weapon.Heavy
         )
      ),
      (
         19,
         (Struct.Weapon.new
            19
            "Arbalest (Broadhead)"
            Struct.Weapon.Ranged
            Struct.Weapon.Long
            Struct.Weapon.Slash
            Struct.Weapon.Heavy
         )
      ),
      (
         20,
         (Struct.Weapon.new
            20
            "Arbalest (Blunt)"
            Struct.Weapon.Ranged
            Struct.Weapon.Long
            Struct.Weapon.Blunt
            Struct.Weapon.Heavy
         )
      ),
      (
         21,
         (Struct.Weapon.new
            21
            "Arbalest (Bodkin Point)"
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
generate_dict : (Dict.Dict Int Struct.Weapon.Type)
generate_dict = (Dict.fromList dataset)

-- Let's not handle the dict just yet.
shim_none : (Struct.Weapon.Type)
shim_none =
   (Struct.Weapon.new
      0
      "None"
      Struct.Weapon.Melee
      Struct.Weapon.Short
      Struct.Weapon.Blunt
      Struct.Weapon.Light
   )
