module View.MapListing exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
-- import Html.Events

-- Map -------------------------------------------------------------------
import Struct.MapSummary
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_item_html : Struct.MapSummary.Type -> (Html.Html Struct.Event.Type)
get_item_html item =
   (Html.a
      [
         (Html.Attributes.href
            (
               "/map-editor/?id="
               ++ (Struct.MapSummary.get_id item)
            )
         )
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "main-menu-map-summary-name")
            ]
            [
               (Html.text (Struct.MapSummary.get_name item))
            ]
         )
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      (List Struct.MapSummary.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_html map_summaries =
   (Html.div
      [
         (Html.Attributes.class "main-menu-map-listing")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "main-menu-map-listing-header")
            ]
            [
               (Html.text "Territories")
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "main-menu-map-listing-body")
            ]
            (List.map (get_item_html) map_summaries)
         )
      ]
   )
