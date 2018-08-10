module View.AccountRecovery exposing (get_html)

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
               (Html.h1 [] [(Html.text "Email")]),
               (Html.input
                  [
                     (Html.Events.onInput Struct.Event.SetEmail1),
                     (Html.Attributes.value model.email1)
                  ]
                  [
                  ]
               )
            ]
         ),
         (Html.button
            [
               (Html.Events.onClick Struct.Event.RecoveryRequested)
            ]
            [
               (Html.text "Send")
            ]
         )
      ]
   )
