module Update.SelectTile exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.CharacterTurn
import Struct.Direction
import Struct.Error
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.Navigator
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
try_autopiloting : (
      Struct.Direction.Type ->
      (Maybe Struct.Navigator.Type) ->
      (Maybe Struct.Navigator.Type)
   )
try_autopiloting dir maybe_nav =
   case maybe_nav of
      (Just navigator) ->
         (Struct.Navigator.try_adding_step navigator dir)

      Nothing -> Nothing

go_to_tile : (
      Struct.Model.Type ->
      Struct.Navigator.Type ->
      Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
go_to_tile model navigator loc_ref =
   if
   (
      loc_ref
      ==
      (Struct.Location.get_ref
         (Struct.Navigator.get_current_location navigator)
      )
   )
   then
      -- We are already there.
      if
      (
         (Struct.UI.get_previous_action model.ui)
         ==
         (Just (Struct.UI.SelectedLocation loc_ref))
      )
      then
         -- And we just clicked on that tile.
         (
            {model |
               char_turn =
                  (Struct.CharacterTurn.lock_path model.char_turn)
            },
            Cmd.none
         )
      else
         -- And we didn't just click on that tile.
         (
            {model |
               ui =
                  (Struct.UI.set_previous_action
                     model.ui
                     (Just (Struct.UI.SelectedLocation loc_ref))
                  )
            },
            Cmd.none
         )
   else
      -- We have to try getting there.
      case
         (Struct.Navigator.try_getting_path_to
            navigator
            loc_ref
         )
      of
         (Just path) ->
            case
               (List.foldr
                  (try_autopiloting)
                  (Just (Struct.Navigator.clear_path navigator))
                  path
               )
            of
               (Just new_navigator) ->
                  (
                     {model |
                        char_turn =
                           (Struct.CharacterTurn.set_navigator
                              model.char_turn
                              new_navigator
                           ),
                        ui =
                           (Struct.UI.set_previous_action
                              model.ui
                              (Just (Struct.UI.SelectedLocation loc_ref))
                           )
                     },
                     Cmd.none
                  )

               Nothing ->
                  (
                     (Struct.Model.invalidate
                        model
                        (Struct.Error.new
                           Struct.Error.Programming
                           "SelectTile/Navigator: Could not follow own path."
                        )
                     ),
                     Cmd.none
                  )

         Nothing -> -- Clicked outside of the range indicator
            ((Struct.Model.reset model model.characters), Cmd.none)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model loc_ref =
   case (Struct.CharacterTurn.try_getting_navigator model.char_turn) of
      (Just navigator) ->
         (go_to_tile model navigator loc_ref)

      _ ->
         (
            {model |
               ui =
                  (Struct.UI.set_previous_action
                     model.ui
                     (Just (Struct.UI.SelectedLocation loc_ref))
                  )
            },
            Cmd.none
         )
