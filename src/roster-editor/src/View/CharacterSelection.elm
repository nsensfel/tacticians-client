module View.CharacterSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import List

import Html
import Html.Attributes

-- Roster Editor ---------------------------------------------------------------
import Struct.Event
import Struct.Model

import View.CharacterCard
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
         (Html.Attributes.class "character-selection")
      ]
      (
         (Html.text "Character Selection")
         ::
         (List.map
            (View.CharacterCard.get_minimal_html)
            (Array.toList model.characters)
         )
      )
   )
