module Update.SelectTile exposing (apply_to)

-- Battle Map -------------------------------------------------------------------
import BattleMap.Struct.Direction
import BattleMap.Struct.Location

-- Battle Characters ------------------------------------------------------------
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
try_autopiloting : (
      BattleMap.Struct.Direction.Type ->
      (Maybe Struct.Navigator.Type) ->
      (Maybe Struct.Navigator.Type)
   )
try_autopiloting dir maybe_navigator =
   case maybe_navigator of
      (Just navigator) ->
         (Struct.Navigator.try_adding_step dir navigator)

      Nothing -> Nothing

go_to_current_tile : (
      Struct.Model.Type ->
      BattleMap.Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
go_to_current_tile model loc_ref =
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
            char_turn = (Struct.CharacterTurn.lock_path model.char_turn)
         },
         Cmd.none
      )
   else
      -- And we didn't just click on that tile.
      (
         {model |
            ui =
               (Struct.UI.reset_displayed_nav
                  (Struct.UI.set_displayed_tab
                     Struct.UI.StatusTab
                     (Struct.UI.set_previous_action
                        (Just (Struct.UI.SelectedLocation loc_ref))
                        model.ui
                     )
                  )
               )
         },
         Cmd.none
      )

go_to_another_tile : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Navigator.Type ->
      BattleMap.Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
go_to_another_tile model char navigator loc_ref =
   case (Struct.Navigator.try_getting_path_to loc_ref navigator) of
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
                           new_navigator
                           (Struct.CharacterTurn.set_active_char
                              (Struct.Character.set_base_character
                                 (BattleCharacters.Struct.Character.set_extra_omnimods
                                    (Struct.Model.tile_omnimods_fun
                                       model
                                       (Struct.Navigator.get_current_location
                                          new_navigator
                                       )
                                    )
                                    (Struct.Character.get_base_character char)
                                 )
                              )
                           )
                           model.char_turn
                        ),
                     ui =
                        (Struct.UI.set_displayed_tab
                           Struct.UI.StatusTab
                           (Struct.UI.set_previous_action
                              (Just (Struct.UI.SelectedLocation loc_ref))
                              model.ui
                           )
                        )
                  },
                  Cmd.none
               )

            Nothing ->
               (
                  (Struct.Model.invalidate
                     (Struct.Error.new
                        Struct.Error.Programming
                        "SelectTile/Navigator: Could not follow own path."
                     )
                     model
                  ),
                  Cmd.none
               )

      Nothing -> -- Clicked outside of the range indicator
         ((Struct.Model.reset model), Cmd.none)

go_to_tile : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Navigator.Type ->
      BattleMap.Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
go_to_tile model char navigator loc_ref =
   if
   (
      loc_ref
      ==
      (BattleMap.Struct.Location.get_ref
         (Struct.Navigator.get_current_location navigator)
      )
   )
   then (go_to_current_tile model loc_ref)
   else (to_to_another_tile model char navigator loc_ref)

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
      (
         (Struct.CharacterTurn.try_getting_navigator model.char_turn),
         (Struct.CharacterTurn.try_getting_active_character model.char_turn)
      )
   of
      ((Just navigator), (Just char)) ->
         (go_to_tile model char navigator loc_ref)

      _ ->
         (
            {model |
               ui =
                  (Struct.UI.reset_displayed_nav
                     (Struct.UI.set_displayed_tab
                        Struct.UI.StatusTab
                        (Struct.UI.set_previous_action
                           (Just (Struct.UI.SelectedLocation loc_ref))
                           model.ui
                        )
                     )
                  )
            },
            Cmd.none
         )
