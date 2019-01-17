module Action.Scroll exposing (to)

-- Elm -------------------------------------------------------------------------
import Browser.Dom

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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
to : Struct.Location.Type -> Struct.UI.Type -> (Task.Task Browser.Dom.Error (List ()))
to loc ui =
   (Browser.Dom.setViewportOf
      Constants.UI.viewer_html_id
      (
         (tile_to_px ui loc.x)
         - Constants.UI.half_viewer_min_width
         -- center on that tile, not its top left corner
         + ((tile_to_px ui 1) / 2.0)
      )
      (
         (tile_to_px ui loc.y)
         - Constants.UI.half_viewer_min_height
         -- center on that tile, not its top left corner
         + ((tile_to_px ui 1) / 2.0)
      )
   )
