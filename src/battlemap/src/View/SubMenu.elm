module View.SubMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

import Util.Html

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_inner_html : (
      Struct.Model.Type ->
      Struct.UI.Tab ->
      (List (Html.Html Struct.Event.Type))
   )
get_inner_html model tab =
   [(Html.text "Not available")]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (Struct.UI.try_getting_displayed_tab model.ui) of
      (Just tab) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-sub-menu")
            ]
            (get_inner_html model tab)
         )

      Nothing ->
         (Util.Html.nothing)
