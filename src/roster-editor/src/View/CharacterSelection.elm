module View.CharacterSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import List

import Html
import Html.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model

import View.CharacterCard

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
handle_unresolved_characters : (
      Struct.Model.Type ->
      (List (Html.Html Struct.Event.Type))
   )
handle_unresolved_characters model =
   if (List.isEmpty model.unresolved_characters)
   then []
   else
      (
         (Html.text
            "Unresolved Characters:"
         )
         ::
         (List.map
            (\char ->
               (Html.text
                  (BattleCharacters.Struct.Character.get_unresolved_name
                     (Struct.Character.get_unresolved_base_character char)
                  )
               )
            )
             model.unresolved_characters
         )
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "selection-window"),
         (Html.Attributes.class "character-selection")
      ]
      (
         [
            (Html.text
               "Character Selection"
            ),
            (Html.div
               [
                  (Html.Attributes.class "selection-window-listing")
               ]
               (List.map
                  (View.CharacterCard.get_minimal_html)
                  (Array.toList model.characters)
               )
            )
         ]
         ++
         (handle_unresolved_characters model)
      )
   )
