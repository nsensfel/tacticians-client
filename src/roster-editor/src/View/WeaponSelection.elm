module View.WeaponSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Roster Editor ---------------------------------------------------------------
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "selection-window"),
         (Html.Attributes.class "roster-editor-weapon-selection")
      ]
      [
         (Html.text "Weapon Selection")
      ]
   )
