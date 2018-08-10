module View.Header exposing (get_html)

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
         (link_html "/login/" "Play" False),
         (link_html "/news/" "News" False),
         (link_html "/community/" "Community" False),
         (link_html "/about/" "About" False),
         (link_html "/battle/?id=0" "[D] Battle" True),
         (link_html "/map-editor/?id=0" "[D] Map Editor" True)
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
