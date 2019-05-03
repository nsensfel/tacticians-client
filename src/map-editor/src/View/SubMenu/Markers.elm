module View.SubMenu.Markers exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map
import BattleMap.Struct.Marker

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_marker_html : (
      String ->
      (String, BattleMap.Struct.Marker.Type)
      -> (Html.Html Struct.Event.Type)
   )
get_marker_html current_selection (ref, marker) =
   (Html.option
      [
         (Html.Attributes.value ref),
         (Html.Attributes.selected (ref == current_selection))
      ]
      [ (Html.text ref) ]
   )

get_selector_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_selector_html model =
   (Html.div
      [
      ]
      [
         (Html.select
            [
               (Html.Events.onInput Struct.Event.SetMarkerName)
            ]
            (List.map
               (get_marker_html (Struct.UI.get_marker_name model.ui))
               (Dict.toList (BattleMap.Struct.Map.get_markers model.map))
            )
         ),
         (Html.button
            [
               (Html.Events.onClick  Struct.Event.LoadMarker)
            ]
            [(Html.text "Load")]
         ),
         (Html.button
            [
               (Html.Events.onClick Struct.Event.SaveMarker)
            ]
            [(Html.text "Save")]
         ),
         (Html.button
            [
               (Html.Events.onClick Struct.Event.RemoveMarker)
            ]
            [(Html.text "Remove")]
         )
      ]
   )

new_marker_menu : (Html.Html Struct.Event.Type)
new_marker_menu =
   (Html.div
      []
      [
         (Html.input
            [
               (Html.Events.onInput Struct.Event.SetMarkerName)
            ]
            [
            ]
         ),
         (Html.button
            [
               (Html.Events.onClick Struct.Event.NewMarker)
            ]
            [
               (Html.text "Add")
            ]
         )
      ]
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
      [
         (new_marker_menu),
         (get_selector_html model)
      ]
   )
