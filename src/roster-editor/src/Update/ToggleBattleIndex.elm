module Update.ToggleBattleIndex exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

-- Shared ----------------------------------------------------------------------
import Util.Array

-- Local Module ----------------------------------------------------------------
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
      battle_order =
         (Array.set
            (Struct.Character.get_battle_index char)
            -1
            model.battle_order
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
   case (Util.Array.indexed_search (\e -> (e == -1)) model.battle_order) of
      Nothing -> model
      (Just (battle_index, _)) ->
         {model |
            edited_char = Nothing,
            battle_order = (Array.set battle_index index model.battle_order),
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
