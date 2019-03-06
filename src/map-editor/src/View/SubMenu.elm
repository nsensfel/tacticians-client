module View.SubMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

import Util.Html

import View.SubMenu.Tiles
import View.SubMenu.Settings
import View.SubMenu.TileStatus

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
         (View.SubMenu.TileStatus.get_html model)

      Struct.UI.TilesTab ->
         (View.SubMenu.Tiles.get_html model)

      Struct.UI.SettingsTab ->
         (View.SubMenu.Settings.get_html model)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (Struct.UI.try_getting_displayed_tab model.ui) of
      (Just tab) ->
         (Html.div
            [(Html.Attributes.class "sub-menu")]
            [(get_inner_html model tab)]
         )

      Nothing ->
         (Util.Html.nothing)
