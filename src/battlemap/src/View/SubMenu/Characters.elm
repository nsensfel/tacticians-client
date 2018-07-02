module View.SubMenu.Characters exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array 

import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Event

import View.Controlled.CharacterCard

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_character_element_html : (
      Int ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_character_element_html player_ix char =
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
            (Struct.Event.LookingForCharacter (Struct.Character.get_index char))
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
         (View.Controlled.CharacterCard.get_minimal_html player_ix char)
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      (Array.Array Struct.Character.Type) ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_html characters player_ix =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tabmenu-content"),
         (Html.Attributes.class "battlemap-tabmenu-characters-tab")
      ]
      (List.map
         (get_character_element_html player_ix)
         (Array.toList characters)
      )
   )
