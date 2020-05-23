module Update.SelectCharacterOrTile exposing (apply_to)

-- Shared ----------------------------------------------------------------------
import Shared.Util.Array

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Struct.Battle
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
      BattleMap.Struct.Location.Ref ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to loc_ref model =
   case
      (Shared.Util.Array.filter_first
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
         (Struct.Battle.get_characters model.battle)
      )
   of
      (Just char) ->
         (Update.SelectCharacter.apply_to
            (Struct.Character.get_index char)
            model
         )

      Nothing ->
         (Update.SelectTile.apply_to loc_ref model)

