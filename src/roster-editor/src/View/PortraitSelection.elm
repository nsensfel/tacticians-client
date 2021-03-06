module View.PortraitSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

import List

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Portrait

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_portrait_html : (
      BattleCharacters.Struct.Portrait.Type ->
      (Html.Html Struct.Event.Type)
   )
get_portrait_html pt =
   (Html.div
      [
         (Html.Attributes.class "character-portrait-and-icon"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.SelectedPortrait
               (BattleCharacters.Struct.Portrait.get_id pt)
            )
         )
     ]
      [
         (Html.div
            [
               (Html.Attributes.class "character-portrait"),
               (Html.Attributes.class "character-portrait-team-0")
            ]
            [
               (Html.div
                  [
                     (Html.Attributes.class "character-portrait-body"),
                     (Html.Attributes.class
                        (
                           "asset-character-portrait-"
                           ++ (BattleCharacters.Struct.Portrait.get_id pt)
                        )
                     )
                  ]
                  [
                  ]
               )
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "tiled"),
               (Html.Attributes.class "character-icon")
            ]
            [
               (Html.div
                  [
                     (Html.Attributes.class "character-icon-body"),
                     (Html.Attributes.class "asset-character-team-body-0")
                  ]
                  [
                  ]
               ),
               (Html.div
                  [
                     (Html.Attributes.class "character-icon-head"),
                     (Html.Attributes.class
                        (
                           "asset-character-icon-"
                           ++ (BattleCharacters.Struct.Portrait.get_icon_id pt)
                        )
                     )
                  ]
                  [
                  ]
               )
            ]
         )
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "selection-window"),
         (Html.Attributes.class "portrait-selection")
      ]
      [
         (Html.text "Portrait Selection"),
         (Html.div
            [
               (Html.Attributes.class "selection-window-listing")
            ]
            (List.map
               (get_portrait_html)
               (Dict.values model.portraits)
            )
         )
      ]
   )
