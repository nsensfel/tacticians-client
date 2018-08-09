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
link_html : (
      Struct.UI.Tab ->
      String ->
      Struct.UI.Tab ->
      (Html.Html Struct.Event.Type)
   )
link_html tab label active_tab =
   (Html.a
      (
         if (tab == active_tab)
         then
            [
               (Html.Attributes.class "active")
            ]
         else
            [
               (Html.Attributes.class "inactive"),
               (Html.Events.onClick (Struct.Event.TabSelected tab))
            ]
      )
      [
         (Html.text label)
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Maybe Struct.UI.Tab) -> (Html.Html Struct.Event.Type)
get_html maybe_tab =
   let
      tab =
         case maybe_tab of
            Nothing -> Struct.UI.SignInTab
            (Just t) -> t
   in
      (Html.nav
         []
         [
            (link_html Struct.UI.SignInTab "Login" tab),
            (link_html Struct.UI.SignUpTab "Create Account" tab),
            (link_html Struct.UI.RecoveryTab "Recover Account" tab)
         ]
      )
