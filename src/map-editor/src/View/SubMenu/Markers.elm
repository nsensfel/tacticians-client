module View.SubMenu.Markers exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Map Editor ------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.Tile
import Struct.TileInstance

import View.Map.Tile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_marker_html : (
      (String, Struct.MapMarker.Type)
      -> (Html.Html Struct.Event.Type)
   )
get_marker_html (ref, marker) =
   (Html.div
      [
         (Html.Attributes.class "tile"),
         (Html.Attributes.class "tiled"),
         (Html.Attributes.class "clickable"),
         (Html.Attributes.class "tile-variant-0"),
         (Html.Events.onClick
            (Struct.Event.TemplateRequested ((Struct.Tile.get_id tile), "0"))
         )
      ]
      (View.Map.Tile.get_content_html (Struct.TileInstance.default tile))
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "tabmenu-content"),
         (Html.Attributes.class "tabmenu-markers-tab")
      ]
      (List.map
         (get_marker_html)
         (Dict.toList (Struct.Map.get_markers model.map))
      )
   )
