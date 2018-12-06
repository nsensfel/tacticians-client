module Update.ToggleBattleIndex exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

-- Roster Editor ---------------------------------------------------------------
import Util.Array

import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
remove_battle_index : (
      Struct.Model.Type ->
      Struct.Character.Type->
      Int ->
      Struct.Model.Type
   )
remove_battle_index model char index =
   {model |
      edited_char = Nothing,
      used_indices =
         (Array.set
            (Struct.Character.get_battle_index char)
            False
            model.used_indices
         ),
      characters =
         (Array.set
            index
            (Struct.Character.set_battle_index -1 char)
            model.characters
         )
   }

give_battle_index : (
      Struct.Model.Type ->
      Struct.Character.Type->
      Int ->
      Struct.Model.Type
   )
give_battle_index model char index =
   case (Util.Array.indexed_search (\e -> (not e)) model.used_indices) of
      Nothing -> model
      (Just (battle_index, _)) ->
         {model |
            edited_char = Nothing,
            used_indices = (Array.set battle_index True model.used_indices),
            characters =
               (Array.set
                  index
                  (Struct.Character.set_battle_index battle_index char)
                  model.characters
               )
         }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model index =
   case (Array.get index model.characters) of
      Nothing ->
         -- TODO: error
         (model, Cmd.none)

      (Just char) ->
         (
            (
               if ((Struct.Character.get_battle_index char) == -1)
               then (give_battle_index model char index)
               else (remove_battle_index model char index)
            ),
            Cmd.none
         )
