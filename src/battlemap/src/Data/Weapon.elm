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
