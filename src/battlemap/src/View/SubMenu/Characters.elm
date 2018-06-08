module View.SubMenu.Characters exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model

import View.Controlled.CharacterCard

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_character_element_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_character_element_html model char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-characters-element"),
         (
            if (Struct.Character.is_alive char)
            then
               (Html.Attributes.class "clickable")
            else
               (Html.Attributes.class "")
         ),
         (Html.Events.onClick
            (Struct.Event.LookingForCharacter (Struct.Character.get_ref char))
         ),
         (
            if (Struct.Character.is_enabled char)
            then
               (Html.Attributes.class "battlemap-characters-element-active")
            else
               (Html.Attributes.class "battlemap-characters-element-inactive")
         )
      ]
      [
         (View.Controlled.CharacterCard.get_minimal_html model char)
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tabmenu-content"),
         (Html.Attributes.class "battlemap-tabmenu-characters-tab")
      ]
      (List.map
         (get_character_element_html model)
         (Dict.values model.characters)
      )
   )
