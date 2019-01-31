module View.Header exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Map -------------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
link_html : String -> String -> Bool -> (Html.Html Struct.Event.Type)
link_html src label is_active =
   (Html.a
      [
         (Html.Attributes.href src)
      ]
      [
         (
            if (is_active)
            then (Html.text label)
            else (Html.s [] [(Html.text label)])
         )
      ]
   )

navigation_html : (Html.Html Struct.Event.Type)
navigation_html =
   (Html.nav
      []
      [
         (link_html "/main-menu" "Main Menu" True),
         (link_html "/about.html" "About" True),
         (link_html "/news/" "News" False),
         (link_html "/community/" "Community" False),
         (link_html "/login/?action=disconnect" "Disconnect" True)
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.header
      []
      [
         (Html.div
            [
               (Html.Attributes.class "main-server-logo")
            ]
            [
               (Html.a
                  [
                     (Html.Attributes.href "__CONF_SERVER_URL")
                  ]
                  [
                     (Html.img
                        [
                           (Html.Attributes.src "__CONF_SERVER_LOGO")
                        ]
                        [
                        ]
                     )
                  ]
               )
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "main-server-version")
            ]
            [
               (Html.text "__CONF_VERSION")
            ]
         ),
         (navigation_html)
      ]
   )
