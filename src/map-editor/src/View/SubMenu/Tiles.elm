module View.SubMenu.Tiles exposing (get_html)

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
get_icon_html : (
      (Struct.Tile.Ref, Struct.Tile.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_icon_html (ref, tile) =
   (Html.div
      [
         (Html.Attributes.class "map-tile"),
         (Html.Attributes.class "map-tiled"),
         (Html.Attributes.class "clickable"),
         (Html.Attributes.class "map-tile-variant-0"),
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
         (Html.Attributes.class "tabmenu-tiles-tab")
      ]
      (List.map
         (get_icon_html)
         (Dict.toList model.tiles)
      )
   )
