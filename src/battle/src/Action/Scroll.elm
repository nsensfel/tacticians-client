module Action.Scroll exposing (to)

-- Elm -------------------------------------------------------------------------
import Dom
import Dom.Scroll

import Task

-- Map -------------------------------------------------------------------
import Constants.UI

import Struct.UI
import Struct.Location

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
-- FIXME: Scrolling so that the focused element is in the middle, not in the top
-- left corner, would be much better.
tile_to_px : Struct.UI.Type -> Int -> Float
tile_to_px ui t =
   (
      (toFloat t)
      * (Struct.UI.get_zoom_level ui)
      * (toFloat Constants.UI.tile_size)
   )

scroll_to_x : Int -> Struct.UI.Type -> (Task.Task Dom.Error ())
scroll_to_x x ui =
   (Dom.Scroll.toX
      Constants.UI.viewer_html_id
      (
         (tile_to_px ui x)
         - Constants.UI.half_viewer_min_width
         -- center on that tile, not its top left corner
         + ((tile_to_px ui 1) / 2.0)
      )
   )

scroll_to_y : Int -> Struct.UI.Type -> (Task.Task Dom.Error ())
scroll_to_y y ui =
   (Dom.Scroll.toY
      Constants.UI.viewer_html_id
      (
         (tile_to_px ui y)
         - Constants.UI.half_viewer_min_height
         -- center on that tile, not its top left corner
         + ((tile_to_px ui 1) / 2.0)
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
to : Struct.Location.Type -> Struct.UI.Type -> (Task.Task Dom.Error (List ()))
to loc ui =
   (Task.sequence
      [
         (scroll_to_x loc.x ui),
         (scroll_to_y loc.y ui)
      ]
   )
