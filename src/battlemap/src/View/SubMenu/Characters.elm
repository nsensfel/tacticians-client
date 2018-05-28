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

import View.Character

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_character_text_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_character_text_html char =
   (Html.div
      [
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.CharacterInfoRequested
               (Struct.Character.get_ref char)
            )
         )
      ]
      [
         (Html.text
            (
               (Struct.Character.get_name char)
               ++ ": "
               ++ (toString (Struct.Character.get_current_health char))
               ++ " HP, "
               ++
               (
                  if (Struct.Character.is_enabled char)
                  then
                     "active"
                  else
                     "inactive"
               )
               ++ " (Player "
               ++ (Struct.Character.get_player_id char)
               ++ ")."
            )
         )
      ]
   )

get_character_element_html : (
      String ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_character_element_html viewer_id char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-characters-element"),
         (
            if (Struct.Character.is_enabled char)
            then
               (Html.Attributes.class "battlemap-characters-element-active")
            else
               (Html.Attributes.class "battlemap-characters-element-inactive")
         )
      ]
      [
         (View.Character.get_portrait_html viewer_id char),
         (get_character_text_html char)
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
         (get_character_element_html model.player_id)
         (Dict.values model.characters)
      )
   )
