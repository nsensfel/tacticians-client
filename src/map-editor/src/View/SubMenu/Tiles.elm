module View.SubMenu.Tiles exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Tile
import BattleMap.Struct.TileInstance

import BattleMap.View.Tile

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon_html : (
      (BattleMap.Struct.Tile.Ref, BattleMap.Struct.Tile.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_icon_html (ref, tile) =
   (Html.div
      [
         (Html.Attributes.class "tile"),
         (Html.Attributes.class "tiled"),
         (Html.Attributes.class "clickable"),
         (Html.Attributes.class "tile-variant-0"),
         (Html.Events.onClick
            (Struct.Event.TemplateRequested
               ((BattleMap.Struct.Tile.get_id tile), "0")
            )
         )
      ]
      (BattleMap.View.Tile.get_content_html
         (BattleMap.Struct.TileInstance.default tile)
      )
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
