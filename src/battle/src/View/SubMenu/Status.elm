module View.SubMenu.Status exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

import BattleMap.View.TileInfo

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

import View.SubMenu.Status.CharacterInfo

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
         (Html.Attributes.class "footer-tabmenu-content"),
         (Html.Attributes.class "footer-tabmenu-content-status")
      ]
      [
         (case (Struct.UI.get_previous_action model.ui) of
            (Just (Struct.UI.SelectedLocation loc)) ->
               (Html.Lazy.lazy3
                  (BattleMap.View.TileInfo.get_html)
                  model.map_dataset
                  loc
                  model.battle.map
               )

            (Just (Struct.UI.SelectedCharacter target_char)) ->
               case (Array.get target_char model.characters) of
                  (Just char) ->
                     (Html.Lazy.lazy2
                        (View.SubMenu.Status.CharacterInfo.get_html)
                        model.player_ix
                        char
                     )

                  _ -> (Html.text "Error: Unknown character selected.")

            _ ->
               (Html.text "Nothing is being focused.")
         )
      ]
   )
