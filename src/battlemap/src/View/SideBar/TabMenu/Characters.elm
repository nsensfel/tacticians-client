module View.SideBar.TabMenu.Characters exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_character_portrait_html : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_character_portrait_html char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-portrait"),
         (Html.Attributes.class
            ("asset-char-portrait-" ++ (Struct.Character.get_portrait_id char))
         )
      ]
      [
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
         (get_character_portrait_html)
         (Dict.values model.characters)
      )
   )
