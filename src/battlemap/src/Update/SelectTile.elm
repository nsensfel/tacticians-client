module Update.SelectTile exposing (apply_to)

-- Elrm ------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.Direction
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.UI

import Update.EndTurn
import Update.RequestDirection

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
autopilot : Struct.Direction.Type -> Struct.Model.Type -> Struct.Model.Type
autopilot dir model =
   (Update.RequestDirection.apply_to model dir)

go_to_tile : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
go_to_tile model char_ref loc_ref =
   case -- (Struct.Battlemap.try_getting_navigator_location model.battlemap)
      (Just {x = 0, y = 0})
   of
      (Just nav_loc) ->
         if (loc_ref == (Struct.Location.get_ref nav_loc))
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
               (Update.EndTurn.apply_to model)
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
               (Struct.Battlemap.try_getting_navigator_path_to
                  model.battlemap
                  loc_ref
               )
            of
               (Just path) ->
                  let
                     new_model =
                        (List.foldr
                           (autopilot)
                           {model |
                              battlemap =
                                 (Struct.Battlemap.clear_navigator_path
                                    model.battlemap
                                 )
                           }
                           path
                        )
                  in
                     (
                        {new_model |
                           ui =
                              (Struct.UI.set_previous_action
                                 new_model.ui
                                 (Just (Struct.UI.SelectedLocation loc_ref))
                              )
                        },
                        Cmd.none
                     )

               Nothing -> -- Clicked outside of the range indicator
                  ((Struct.Model.reset model model.characters), Cmd.none)

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
   case
      (Struct.CharacterTurn model.char_turn)
   of
      (Just char_ref) ->
         (go_to_tile model char_ref loc_ref)

      _ -> ({model | state = (Struct.Model.InspectingTile loc_ref)}, Cmd.none)
