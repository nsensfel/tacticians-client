module Data.Armors exposing (generate_dict, none)
-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Armor

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
dataset : (List (Struct.Armor.Ref, Struct.Armor.Type))
dataset =
   [
      -- TODO: have those in separate text files, and put them here only at
      -- compilation.
      (
         0,
         (Struct.Armor.new
            0
            "None"
            Struct.Armor.Leather
            0.0
         )
      ),
      (
         1,
         (Struct.Armor.new
            1
            "Last Meal's Pelts"
            Struct.Armor.Leather
            0.5
         )
      ),
      (
         2,
         (Struct.Armor.new
            2
            "Bits from a Wall"
            Struct.Armor.Plate
            0.5
         )
      ),
      (
         3,
         (Struct.Armor.new
            3
            "Some Garden Fence"
            Struct.Armor.Chain
            0.5
         )
      ),
      (
         4,
         (Struct.Armor.new
            4
            "Morrigan's Pity"
            Struct.Armor.Kinetic
            0.5
         )
      )
   ]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
generate_dict : (Dict.Dict Struct.Armor.Ref Struct.Armor.Type)
generate_dict = (Dict.fromList dataset)

-- If it's not found.
none : (Struct.Armor.Type)
none =
   (Struct.Armor.new
      0
      "None"
      Struct.Armor.Leather
      0.0
   )
