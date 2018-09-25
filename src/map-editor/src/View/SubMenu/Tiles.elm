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
-- TODO: display and allow selection of all variations.
get_icon_html : Int -> (Html.Html Struct.Event.Type)
get_icon_html icon_id =
   (Html.div
      [
         (Html.Attributes.class "map-tile"),
         (Html.Attributes.class "map-tiled"),
         (Html.Attributes.class "clickable"),
         (Html.Attributes.class "map-tile-variant-0"),
         (Html.Events.onClick
            (Struct.Event.TemplateRequested (icon_id, 0))
         )
      ]
      (View.Map.Tile.get_content_html
         (Struct.Tile.new_instance
            {x = 0, y = 0}
            icon_id
            0
            0
            0
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
