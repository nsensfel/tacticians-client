module View.Omnimods exposing
   (
      get_html_with_modifier,
      get_html
   )

-- Elm -------------------------------------------------------------------------
import List

import Html
import Html.Attributes
import Html.Events

-- Roster Editor ---------------------------------------------------------------
import Struct.Event
import Struct.Omnimods

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_mod_html : (String, Int) -> (Html.Html Struct.Event.Type)
get_mod_html mod =
   let
      (category, value) = mod
   in
      (Html.div
         [
            (Html.Attributes.class "info-card-mod")
         ]
         [
            (Html.div
               [
                  (Html.Attributes.class "omnimod-icon"),
                  (Html.Attributes.class ("omnimod-icon-" ++ category)),
                  (
                     if (value < 0)
                     then (Html.Attributes.class "omnimod-icon-negative")
                     else (Html.Attributes.class "omnimod-icon-positive")
                  )
               ]
               [
               ]
            ),
            (Html.text (String.fromInt value))
         ]
      )

get_multiplied_mod_html : Float -> (String, Int) -> (Html.Html Struct.Event.Type)
get_multiplied_mod_html multiplier mod =
   let
      (category, value) = mod
   in
      (Html.div
         [
            (Html.Attributes.class "character-card-mod")
         ]
         [
            (Html.div
               [
                  (Html.Attributes.class "omnimod-icon"),
                  (Html.Attributes.class ("omnimod-icon-" ++ category)),
                  (
                     if (value < 0)
                     then (Html.Attributes.class "omnimod-icon-negative")
                     else (Html.Attributes.class "omnimod-icon-positive")
                  )
               ]
               [
               ]
            ),
            (Html.text
               (
                  (String.fromInt value)
                  ++ " ("
                  ++(String.fromInt (ceiling ((toFloat value) * multiplier)))
                  ++ ")"
               )
            )
         ]
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html_with_modifier : (
      Float ->
      Struct.Omnimods.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html_with_modifier attack_multiplier omnimods =
   (Html.div
      [
         (Html.Attributes.class "omnimod-listing")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "omnimod-attack-mods")
            ]
            (List.map
               (get_multiplied_mod_html attack_multiplier)
               (Struct.Omnimods.get_attack_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-defense-mods")
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_defense_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-attribute-mods")
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_attributes_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-statistics-mods")
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_statistics_mods omnimods)
            )
         )
      ]
   )

get_html : Struct.Omnimods.Type -> (Html.Html Struct.Event.Type)
get_html omnimods =
   (Html.div
      [
         (Html.Attributes.class "omnimod-listing")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "omnimod-attack-mods")
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_attack_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-defense-mods")
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_defense_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-attribute-mods")
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_attributes_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-statistics-mods")
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_statistics_mods omnimods)
            )
         )
      ]
   )
