module Update.RequestDirection exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Direction
import Struct.Character
import Struct.UI
import Struct.Model
import Struct.Error

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      Struct.Direction.Type ->
      Struct.Model.Type
   )
make_it_so model char_ref dir =
   let
      new_bmap =
         (Struct.Battlemap.try_adding_step_to_navigator
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
                  (Struct.UI.set_previous_action
                     model.ui
                     (Just Struct.UI.UsedManualControls)
                  )
            }

         Nothing ->
            (Struct.Model.invalidate
               model
               (Struct.Error.new
                  Struct.Error.IllegalAction
                  "Unreachable/occupied tile."
               )
            )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Direction.Type ->
      Struct.Model.Type
   )
apply_to model dir =
   case model.controlled_character of
      (Just char_ref) ->
         (
            (make_it_so model char_ref dir),
            Cmd.none
         )

      _ ->
         (
            (Struct.Model.invalidate
               model
               (Struct.Error.new
                  Struct.Error.IllegalAction
                  "This can only be done while moving a character."
               )
            ),
            Cmd.none
         )
