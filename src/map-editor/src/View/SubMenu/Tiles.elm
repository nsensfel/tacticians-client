module View.SubMenu.Tiles exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Tile

import View.Map.Tile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon_html : Int -> (Html.Html Struct.Event.Type)
get_icon_html index =
   let tile_id = (String.fromInt index) in
      (Html.div
         [
            (Html.Attributes.class "map-tile"),
            (Html.Attributes.class "map-tiled"),
            (Html.Attributes.class "clickable"),
            (Html.Attributes.class "map-tile-variant-0"),
            (Html.Events.onClick
               (Struct.Event.TemplateRequested (tile_id, "0"))
            )
         ]
         (View.Map.Tile.get_content_html
            (Struct.Tile.new_instance
               {x = 0, y = 0}
               tile_id
               "0"
               0
               "0"
               []
            )
         )
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.div
      [
         (Html.Attributes.class "tabmenu-content"),
         (Html.Attributes.class "tabmenu-tiles-tab")
      ]
      (List.map
         (get_icon_html)
         (List.range 0 5)
      )
   )
