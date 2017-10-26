module Model.RequestDirection exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Direction

import Character

import UI

import Model
import Error

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : (
      Model.Type ->
      Character.Ref ->
      Battlemap.Direction.Type ->
      Model.Type
   )
make_it_so model char_ref dir =
   let
      new_bmap =
         (Battlemap.try_adding_step_to_navigator
            model.battlemap
            (Dict.values model.characters)
            dir
         )
   in
      case new_bmap of
         (Just bmap) ->
            {model |
               battlemap = bmap,
               ui =
                  (UI.set_previous_action
                     model.ui
                     (Just UI.UsedManualControls)
                  )
            }

         Nothing ->
            (Model.invalidate
               model
               (Error.new
                  Error.IllegalAction
                  "Unreachable/occupied tile."
               )
            )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Model.Type -> Battlemap.Direction.Type -> Model.Type
apply_to model dir =
   case (Model.get_state model) of
      (Model.ControllingCharacter char_ref) ->
         (make_it_so model char_ref dir)

      _ ->
         (Model.invalidate
            model
            (Error.new
               Error.IllegalAction
               "This can only be done while moving a character."
            )
         )
