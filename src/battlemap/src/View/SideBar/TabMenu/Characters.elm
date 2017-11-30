module View.SideBar.TabMenu.Characters exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
--import Html.Events

-- Battlemap -------------------------------------------------------------------
import Character

import Event

import Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_character_portrait_html : Character.Type -> (Html.Html Event.Type)
get_character_portrait_html char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-portrait"),
         (Html.Attributes.class
            ("asset-char-portrait-" ++ (Character.get_portrait_id char))
         )
      ]
      [
      ]
   )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Model.Type -> (Html.Html Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tabmenu-content"),
         (Html.Attributes.class "battlemap-tabmenu-characters-tab")
      ]
      (List.map
         (get_character_portrait_html)
         (Dict.values model.characters)
      )
   )
