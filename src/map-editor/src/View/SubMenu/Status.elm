module View.SubMenu.Status exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.UI

import View.SubMenu.Status.TileInfo
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "map-footer-tabmenu-content"),
         (Html.Attributes.class "map-footer-tabmenu-content-status")
      ]
      [
         (case (Struct.UI.get_previous_action model.ui) of
            (Just (Struct.UI.SelectedLocation loc)) ->
               (View.SubMenu.Status.TileInfo.get_html
                  model
                  (Struct.Location.from_ref loc)
               )

            _ ->
               (Html.text "Nothing is being focused.")
         )
      ]
   )
