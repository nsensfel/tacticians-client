module View.SubMenu.Tiles exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Constants.IO

import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon_html : Int -> (Html.Html Struct.Event.Type)
get_icon_html icon_id =
   (Html.div
      [
         (Html.Attributes.class "map-tile"),
         (Html.Attributes.class "map-tiled"),
         (Html.Attributes.class "clickable"),
         (Html.Attributes.class "map-tile-variant-0"),
         (Html.Attributes.style
            [
               (
                  "background-image",
                  (
                     "url("
                     ++ Constants.IO.tile_assets_url
                     ++ (toString icon_id)
                     ++".svg)"
                  )
               )
            ]
         ),
         (Html.Events.onClick (Struct.Event.TemplateRequested icon_id))
      ]
      [
      ]
   )

m4_include(__MAKEFILE_DATA_DIR/tile/global.m4.conf)m4_dnl
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.div
      [
         (Html.Attributes.class "map-tabmenu-content"),
         (Html.Attributes.class "map-tabmenu-tiles-tab")
      ]
      (List.map
         (get_icon_html)
         (List.range 0 __TILE_CLASS_MAX_ID)
      )
   )
