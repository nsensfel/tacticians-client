module View.BattleListing exposing (get_html)

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
get_html : (
      String ->
      String ->
      (List Struct.BattleRef) ->
      (Html.Html Struct.Event.Type)
   )
get_html name class battle_refs =
   (Html.div
      [
         (Html.Attributes.class class)
         (Html.Attributes.class "main-menu-battle-listing")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-listing-header")
            ]
            [
               (Html.text name)
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-listing-body")
            ]
            (List.map
               (get_battle_ref_html)
               battle_refs
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-listing-add-new")
            ]
            [
               (Html.text "New")
            ]
         )
      ]
   )
