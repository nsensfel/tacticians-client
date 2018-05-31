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
            "Morrigan's Pity"
            Struct.Armor.Kinetic
            5.0
         )
      ),
      (
         2,
         (Struct.Armor.new
            1
            "Last Night's Hunt"
            Struct.Armor.Leather
            5.0
         )
      ),
      (
         3,
         (Struct.Armor.new
            1
            "Garden Fence"
            Struct.Armor.Chain
            5.0
         )
      ),
      (
         4,
         (Struct.Armor.new
            1
            "Bits of Wall"
            Struct.Armor.Plate
            5.0
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
