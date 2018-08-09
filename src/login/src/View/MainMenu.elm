module View.MainMenu exposing (get_html)

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
link_html : String -> Bool -> (Html.Html Struct.Event.Type)
link_html label is_active =
   (Html.a
      [
         (Html.Attributes.class
            (
               if (is_active)
               then "active"
               else "inactive"
            )
         )
      ]
      [
         (Html.text label)
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.main_
      [
      ]
      [
         (Html.nav
            []
            [
               (link_html "Login" True),
               (link_html "Create Account" False),
               (link_html "Recover Account" False)
            ]
         ),
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
      ]
   )
