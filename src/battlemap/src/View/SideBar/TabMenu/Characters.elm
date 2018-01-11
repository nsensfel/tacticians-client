module View.SideBar.TabMenu.Characters exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

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
            (
               "asset-character-portrait-"
               ++ (Struct.Character.get_portrait_id char)
            )
         ),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.CharacterInfoRequested
               (Struct.Character.get_ref char)
            )
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
