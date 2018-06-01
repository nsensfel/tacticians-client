module Comm.AddChar exposing (decode)

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Data.Armors
import Data.Weapons

import Struct.Armor
import Struct.Character
import Struct.Model
import Struct.ServerReply
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
weapon_getter : Struct.Model.Type -> Struct.Weapon.Ref -> Struct.Weapon.Type
weapon_getter model ref =
   case (Dict.get ref model.weapons) of
      (Just w) -> w
      Nothing -> Data.Weapons.none

armor_getter : Struct.Model.Type -> Struct.Armor.Ref -> Struct.Armor.Type
armor_getter model ref =
   case (Dict.get ref model.armors) of
      (Just w) -> w
      Nothing -> Data.Armors.none

internal_decoder : Struct.Character.Type -> Struct.ServerReply.Type
internal_decoder char = (Struct.ServerReply.AddCharacter char)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Struct.Model.Type -> (Json.Decode.Decoder Struct.ServerReply.Type))
decode model =
   (Json.Decode.map
      (internal_decoder)
      (Struct.Character.decoder (weapon_getter model) (armor_getter model))
   )
