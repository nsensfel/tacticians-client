module Update.SelectCharacterOrTile exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Location
import Struct.Model

import Update.SelectCharacter
import Update.SelectTile

import Util.Array

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model loc_ref =
   case
      (Util.Array.filter_first
         (\c ->
            (
               (
                  (Struct.Character.get_location c)
                  == (Struct.Location.from_ref loc_ref)
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

