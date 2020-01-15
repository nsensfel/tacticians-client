module View.SubMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.UI

import View.Controlled.CharacterCard

import View.SubMenu.Characters
import View.SubMenu.Settings
import View.SubMenu.Status
import View.SubMenu.Timeline

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_inner_html : (
      Struct.Model.Type ->
      Struct.UI.Tab ->
      (Html.Html Struct.Event.Type)
   )
get_inner_html model tab =
   case tab of
      Struct.UI.StatusTab ->
         (View.SubMenu.Status.get_html model)

      Struct.UI.CharactersTab ->
         (Html.Lazy.lazy
            (View.SubMenu.Characters.get_html)
            model.battle
         )

      Struct.UI.SettingsTab ->
         (View.SubMenu.Settings.get_html model)

      Struct.UI.TimelineTab ->
         (View.SubMenu.Timeline.get_html model)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (Struct.UI.maybe_get_displayed_tab model.ui) of
      (Just tab) ->
         (Html.div
            [(Html.Attributes.class "sub-menu")]
            [(get_inner_html model tab)]
         )

      Nothing ->
         case (Struct.CharacterTurn.maybe_get_target model.char_turn) of
            (Just char_ref) ->
               case (Array.get char_ref model.characters) of
                  (Just char) ->
                     (Html.div
                        [(Html.Attributes.class "sub-menu")]
                        [
                           (Html.text "Targeting:"),
                           (Html.Lazy.lazy3
                              (View.Controlled.CharacterCard.get_summary_html
                                 (Struct.Battle.get_own_player_index
                                    model.battle
                                 )
                              )
                              model.char_turn
                              char
                           )
                        ]
                     )

                  Nothing ->
                     (Util.Html.nothing)

            Nothing ->
               (Util.Html.nothing)
