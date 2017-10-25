module Model.SelectTile exposing (apply_to)

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Direction
import Battlemap.Location

import Character

import Model.RequestDirection
import Model.EndTurn

import UI
import Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
autopilot : Battlemap.Direction.Type -> Model.Type -> Model.Type
autopilot dir model =
   (Model.RequestDirection.apply_to model dir)

go_to_tile : Model.Type -> Character.Ref -> Battlemap.Location.Ref -> Model.Type
go_to_tile model char_ref loc_ref =
   case (Battlemap.try_getting_navigator_location model.battlemap) of
      (Just nav_loc) ->
         if (loc_ref == (Battlemap.Location.get_ref nav_loc))
         then
            -- We are already there.
            if (UI.has_just_used_manual_controls model.ui)
            then
               -- And we didn't just click on that tile.
               {model |
                  ui = (UI.set_has_just_used_manual_controls model.ui False)
               }
            else
               -- And we just clicked on that tile.
               (Model.EndTurn.apply_to model)
         else
            -- We have to try getting there.
            case
               (Battlemap.try_getting_navigator_path_to
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
                                 (Battlemap.clear_navigator_path
                                    model.battlemap
                                 )
                           }
                           path
                        )
                  in
                     {new_model |
                        ui =
                           (UI.set_has_just_used_manual_controls
                              new_model.ui
                              False
                           )
                     }

               Nothing -> -- Clicked outside of the range indicator
                  (Model.reset model model.characters)
      Nothing -> -- Clicked outside of the range indicator
         (Model.reset model model.characters)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Model.Type -> Battlemap.Location.Ref -> Model.Type
apply_to model loc_ref =
   case (Model.get_state model) of
      (Model.ControllingCharacter char_ref) ->
         (go_to_tile model char_ref loc_ref)

      _ -> {model | state = (Model.InspectingTile loc_ref)}
