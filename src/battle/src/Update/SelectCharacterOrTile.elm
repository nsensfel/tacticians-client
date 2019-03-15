module Update.SelectCharacterOrTile exposing (apply_to)

-- Shared ----------------------------------------------------------------------
import Util.Array

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model

import Update.SelectCharacter
import Update.SelectTile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      BattleMap.Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model loc_ref =
   case
      (Util.Array.filter_first
         (\c ->
            (
               (
                  (Struct.Character.get_location c)
                  == (BattleMap.Struct.Location.from_ref loc_ref)
               )
               &&
               (Struct.Character.is_alive c)
            )
         )
         model.characters
      )
   of
      (Just char) ->
         (Update.SelectCharacter.apply_to
            model
            (Struct.Character.get_index char)
         )

      Nothing ->
         (Update.SelectTile.apply_to model loc_ref)

