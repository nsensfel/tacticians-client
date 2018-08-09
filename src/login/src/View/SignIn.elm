module View.SignIn exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map -------------------------------------------------------------------
import Struct.Event
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.article
      []
      [
         (Html.div
            [
               (Html.Attributes.class "user-input")
            ]
            [
               (Html.h1 [] [(Html.text "Username")]),
               (Html.input [] [])
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "user-input")
            ]
            [
               (Html.h1 [] [(Html.text "Password")]),
               (Html.input
                  [
                     (Html.Attributes.type_ "password")
                  ]
                  []
               )
            ]
         ),
         (Html.button
            []
            [ (Html.text "Send") ]
         )
      ]
   )
