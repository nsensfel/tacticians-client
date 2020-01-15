module View.SubMenu.Timeline exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.TurnResult
import Struct.Model

import View.SubMenu.Timeline.Attack
import View.SubMenu.Timeline.Movement
import View.SubMenu.Timeline.WeaponSwitch
import View.SubMenu.Timeline.PlayerVictory
import View.SubMenu.Timeline.PlayerDefeat
import View.SubMenu.Timeline.PlayerTurnStart

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_turn_result_html : (
      (Array.Array Struct.Character.Type) ->
      Int ->
      Struct.TurnResult.Type ->
      (Html.Html Struct.Event.Type)
   )
get_turn_result_html characters player_ix turn_result =
   case turn_result of
      (Struct.TurnResult.Moved movement) ->
         (View.SubMenu.Timeline.Movement.get_html
            characters
            player_ix
            movement
         )

      (Struct.TurnResult.Attacked attack) ->
         (View.SubMenu.Timeline.Attack.get_html
            characters
            player_ix
            attack
         )

      (Struct.TurnResult.SwitchedWeapon weapon_switch) ->
         (View.SubMenu.Timeline.WeaponSwitch.get_html
            characters
            player_ix
            weapon_switch
         )

      (Struct.TurnResult.PlayerWon pvict) ->
         (View.SubMenu.Timeline.PlayerVictory.get_html pvict)

      (Struct.TurnResult.PlayerLost pdefeat) ->
         (View.SubMenu.Timeline.PlayerDefeat.get_html pdefeat)

      (Struct.TurnResult.PlayerTurnStarted pturns) ->
         (View.SubMenu.Timeline.PlayerTurnStart.get_html pturns)

true_get_html : Struct.Battle.Type -> (Html.Html Struct.Event.Type)
true_get_html battle =
   (Html.div
      [
         (Html.Attributes.class "tabmenu-content"),
         (Html.Attributes.class "tabmenu-timeline-tab")
      ]
      (Array.toList
         (Array.map
            (get_turn_result_html
               (Struct.Battle.get_characters battle)
               (Struct.Battle.get_own_player_index battle)
            )
            (Struct.Battle.get_timeline battle)
         )
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.Lazy.lazy (true_get_html) model.battle)
