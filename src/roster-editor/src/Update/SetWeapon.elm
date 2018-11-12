module Update.SetWeapon exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Roster Editor ---------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI
import Struct.Weapon
import Struct.WeaponSet

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Weapon.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ref =
   (
      (
         case (model.edited_char, (Dict.get ref model.weapons)) of
            ((Just char), (Just weapon)) ->
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.set_weapons
                           (
                              if (Struct.UI.is_selecting_main_weapon model.ui)
                              then
                                 (Struct.WeaponSet.set_active_weapon
                                    weapon
                                    (Struct.Character.get_weapons char)
                                 )
                              else
                                 (Struct.WeaponSet.set_secondary_weapon
                                    weapon
                                    (Struct.Character.get_weapons char)
                                 )
                           )
                           char
                        )
                     )
               }

            _ -> model
      ),
      Cmd.none
   )
