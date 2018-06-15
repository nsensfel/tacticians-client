module View.SubMenu.Status exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.UI

import View.SubMenu.Status.CharacterInfo
import View.SubMenu.Status.TileInfo
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
         (Html.Attributes.class "battlemap-footer-tabmenu-content"),
         (Html.Attributes.class "battlemap-footer-tabmenu-content-status")
      ]
      [
         (case (Struct.UI.get_previous_action model.ui) of
            (Just (Struct.UI.SelectedLocation loc)) ->
               (View.SubMenu.Status.TileInfo.get_html
                  model
                  (Struct.Location.from_ref loc)
               )

            (Just (Struct.UI.SelectedCharacter target_char)) ->
               case (Dict.get target_char model.characters) of
                  (Just char) ->
                     (View.SubMenu.Status.CharacterInfo.get_html
                        model
                        char
                     )

                  _ -> (Html.text "Error: Unknown character selected.")

            _ ->
               (Html.text "Nothing is being focused.")
         )
      ]
   )
