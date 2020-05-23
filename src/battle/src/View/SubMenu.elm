module View.SubMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

-- Shared ----------------------------------------------------------------------
import Shared.Util.Html

-- Local Module ----------------------------------------------------------------
import Struct.Battle
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
         (Html.Lazy.lazy2
            (View.SubMenu.Characters.get_html)
            model.battle.characters
            model.battle.own_player_ix
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
         (Shared.Util.Html.nothing)
