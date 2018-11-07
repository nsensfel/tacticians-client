module View.Roster exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Main Menu -------------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.div
      [
         (Html.Attributes.class "main-menu-roster")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "main-menu-roster-header")
            ]
            [
               (Html.text "Characters")
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "main-menu-roster-options-body")
            ]
            [
               (Html.a
                  [
                     (Html.Attributes.href "/roster-editor/")
                  ]
                  [
                     (Html.text "Edit Main Roster")
                  ]
               )
            ]
         )
      ]
   )
