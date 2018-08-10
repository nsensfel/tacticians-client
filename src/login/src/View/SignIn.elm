module View.SignIn exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map -------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.article
      []
      [
         (Html.div
            [
               (Html.Attributes.class "user-input")
            ]
            [
               (Html.h1 [] [ (Html.text "Username") ]),
               (Html.input
                  [
                     (Html.Events.onInput Struct.Event.SetUsername),
                     (Html.Attributes.value model.username)
                  ]
                  [
                  ]
               )
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
                     (Html.Attributes.type_ "password"),
                     (Html.Events.onInput Struct.Event.SetPassword1),
                     (Html.Attributes.value model.password1)
                  ]
                  [
                  ]
               )
            ]
         ),
         (Html.button
            [
               (Html.Events.onClick Struct.Event.SignInRequested)
            ]
            [
               (Html.text "Send")
            ]
         )
      ]
   )
