module View.Toolbox exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map
import BattleMap.Struct.Tile
import BattleMap.Struct.TileInstance

import BattleMap.View.Tile

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.Toolbox

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_template_icon_html : (
      BattleMap.Struct.TileInstance.Type ->
      (Html.Html Struct.Event.Type)
   )
get_template_icon_html template =
   (Html.div
      [
         (Html.Attributes.class "toolbox-template"),
         (Html.Attributes.class "tiled"),
         (Html.Attributes.class "tile"),
         (Html.Attributes.class "tile-variant-0")
      ]
      (BattleMap.View.Tile.get_content_html template)
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
               Struct.Toolbox.Focus -> "Focus"
               Struct.Toolbox.Sample -> "Sample"
               Struct.Toolbox.AddSelection -> "Select+"
               Struct.Toolbox.RemoveSelection -> "Select-"
            )
         )
      ]
   )

get_modes_menu_html : Struct.Toolbox.Type -> (Html.Html Struct.Event.Type)
get_modes_menu_html tb =
   (Html.div
      [(Html.Attributes.class "toolbox-modes")]
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
      [(Html.Attributes.class "toolbox-shapes")]
      (List.map
         (get_shape_button (Struct.Toolbox.get_shape tb))
         (Struct.Toolbox.get_shapes (Struct.Toolbox.get_mode tb))
      )
   )

get_others_menu_html : (Html.Html Struct.Event.Type)
get_others_menu_html =
   (Html.div
      [(Html.Attributes.class "toolbox-others")]
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
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   let tb = model.toolbox in
      (Html.div
         [(Html.Attributes.class "toolbox")]
         [
            (get_template_icon_html (Struct.Toolbox.get_template tb)),
            (get_modes_menu_html tb),
            (get_shapes_menu_html tb),
            (get_others_menu_html)
         ]
      )
