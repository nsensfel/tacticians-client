module View.SubMenu.Markers exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Tile
import BattleMap.Struct.Map
import BattleMap.Struct.Marker
import BattleMap.Struct.TileInstance

import BattleMap.View.Tile

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_marker_html : (
      (String, BattleMap.Struct.Marker.Type)
      -> (Html.Html Struct.Event.Type)
   )
get_marker_html (ref, marker) =
   (Html.div
      [
      ]
      [(Html.text ref)]
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
         (Dict.toList (BattleMap.Struct.Map.get_markers model.map))
      )
   )
