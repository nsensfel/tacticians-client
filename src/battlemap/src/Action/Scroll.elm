module Action.Scroll exposing (to)

-- Elm -------------------------------------------------------------------------
import Dom
import Dom.Scroll

import Task

-- Battlemap -------------------------------------------------------------------
import Constants.UI

import Struct.UI
import Struct.Location

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
-- FIXME: Scrolling so that the focused element is in the middle, not in the top
-- left corner, would be much better.

scroll_to_x : Int -> Struct.UI.Type -> (Task.Task Dom.Error ())
scroll_to_x x ui =
   (Dom.Scroll.toX
      Constants.UI.viewer_html_id
      (
         (toFloat x)
         * (Struct.UI.get_zoom_level ui)
         * (toFloat Constants.UI.tile_size)
      )
   )

scroll_to_y : Int -> Struct.UI.Type -> (Task.Task Dom.Error ())
scroll_to_y y ui =
   (Dom.Scroll.toY
      Constants.UI.viewer_html_id
      (
         (toFloat y)
         * (Struct.UI.get_zoom_level ui)
         * (toFloat Constants.UI.tile_size)
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
