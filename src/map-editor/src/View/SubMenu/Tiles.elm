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
-- TODO: display and allow selection of all variations.
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
                     let
                        icon_id_str = (toString icon_id)
                     in
                        (
                           "url("
                           ++ Constants.IO.tile_assets_url
                           ++ icon_id_str
                           ++ "-"
                           ++ icon_id_str
                           ++"-0.svg)"
                        )
                  )
               )
            ]
         ),
         (Html.Events.onClick
            (Struct.Event.TemplateRequested (icon_id, icon_id, 0))
         )
      ]
      [
      ]
   )

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
         (List.range 0 3)
      )
   )
