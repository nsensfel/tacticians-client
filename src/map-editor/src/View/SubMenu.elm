module View.SubMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Shared ----------------------------------------------------------------------
import Shared.Util.Html

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

import View.SubMenu.Markers
import View.SubMenu.Settings
import View.SubMenu.TileStatus
import View.SubMenu.Tiles

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

      Struct.UI.MarkersTab ->
         (View.SubMenu.Markers.get_html model)

      Struct.UI.TilesTab ->
         (View.SubMenu.Tiles.get_html model)

      Struct.UI.SettingsTab ->
         (View.SubMenu.Settings.get_html model)

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
