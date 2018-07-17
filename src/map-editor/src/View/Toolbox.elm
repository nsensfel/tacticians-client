module View.Toolbox exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Struct.Battlemap -------------------------------------------------------------------
import Constants.IO

import Struct.Event
import Struct.Tile
import Struct.Toolbox

import Util.Html

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_template_icon_html : Struct.Tile.Instance -> (Html.Html Struct.Event.Type)
get_template_icon_html template =
   (Html.div
      [
         (Html.Attributes.class "map-toolbox-template"),
         (Html.Attributes.class "map-tiled"),
         (Html.Attributes.class "map-tile"),
         (Html.Attributes.class "map-tile-variant-0"),
         (Html.Attributes.style
            [
               (
                  "background-image",
                  (
                     "url("
                     ++ Constants.IO.tile_assets_url
                     ++ (Struct.Tile.get_icon_id template)
                     ++".svg)"
                  )
               )
            ]
         )
      ]
      [
      ]
   )

get_mode_button : (
      Struct.Toolbox.Mode ->
      Struct.Toolbox.Mode ->
      (Html.Html Struct.Event.Type)
   )
get_mode_button current mode =
   (Html.button
      (
         if (current == mode)
         then [(Html.Attributes.disabled True)]
         else [(Html.Events.onClick (Struct.Event.ModeRequested mode))]
      )
      [
         (Html.text
            (case mode of
               Struct.Toolbox.Draw -> "Draw"
               Struct.Toolbox.AddSelection -> "Select+"
               Struct.Toolbox.RemoveSelection -> "Select-"
            )
         )
      ]
   )

get_modes_menu_html : Struct.Toolbox.Type -> (Html.Html Struct.Event.Type)
get_modes_menu_html tb =
   (Html.div
      [(Html.Attributes.class "map-toolbox-modes")]
      (List.map
         (get_mode_button (Struct.Toolbox.get_mode tb))
         (Struct.Toolbox.get_modes)
      )
   )

get_shape_button : (
      Struct.Toolbox.Shape ->
      Struct.Toolbox.Shape ->
      (Html.Html Struct.Event.Type)
   )
get_shape_button current shape =
   (Html.button
      (
         if (current == shape)
         then [(Html.Attributes.disabled True)]
         else [(Html.Events.onClick (Struct.Event.ShapeRequested shape))]
      )
      [
         (Html.text
            (case shape of
               Struct.Toolbox.Simple -> "Single"
               Struct.Toolbox.Fill -> "Fill"
               Struct.Toolbox.Square -> "Rectangle"
            )
         )
      ]
   )

get_shapes_menu_html : Struct.Toolbox.Type -> (Html.Html Struct.Event.Type)
get_shapes_menu_html tb =
   (Html.div
      [(Html.Attributes.class "map-toolbox-shapes")]
      (List.map
         (get_shape_button (Struct.Toolbox.get_shape tb))
         (Struct.Toolbox.get_shapes)
      )
   )

get_others_menu_html : (Html.Html Struct.Event.Type)
get_others_menu_html =
   (Html.div
      [(Html.Attributes.class "map-toolbox-others")]
      [
         (Html.button
            [(Html.Events.onClick Struct.Event.ClearSelectionRequested)]
            [(Html.text "Clear Selection")]
         ),
         (Html.button
            [(Html.Events.onClick Struct.Event.PrettifySelectionRequested)]
            [(Html.text "Prettify Selection")]
         )
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Toolbox.Type -> (Html.Html Struct.Event.Type)
get_html tb =
   (Html.div
      [(Html.Attributes.class "map-toolbox")]
      [
         (get_template_icon_html (Struct.Toolbox.get_template tb)),
         (get_modes_menu_html tb),
         (get_shapes_menu_html tb),
         (get_others_menu_html)
      ]
   )
