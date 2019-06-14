module Battle.View.Omnimods exposing
   (
      get_html_with_modifier,
      get_html
   )

-- Elm -------------------------------------------------------------------------
import List

import Html
import Html.Attributes
import Html.Events

-- Battle ----------------------------------------------------------------------
import Battle.Struct.DamageType
import Battle.Struct.Omnimods
import Battle.Struct.Statistics

import Battle.View.DamageType
import Battle.View.Statistic

-- Local Module ----------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html_with_modifier : (
      Float ->
      Battle.Struct.Omnimods.Type ->
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
               (\(k, v) ->
                  (Battle.View.DamageType.get_signed_html
                     (Battle.Struct.DamageType.decode k)
                     (ceiling ((toFloat v) * attack_multiplier))
                  )
               )
               (Battle.Struct.Omnimods.get_attack_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-defense-mods")
            ]
            (List.map
               (\(k, v) ->
                  (Battle.View.DamageType.get_signed_html
                     (Battle.Struct.DamageType.decode k)
                     v
                  )
               )
               (Battle.Struct.Omnimods.get_defense_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-statistics-mods")
            ]
            (List.map
               (\(k, v) ->
                  (Battle.View.Statistic.get_signed_html
                     (Battle.Struct.Statistics.decode_category k)
                     v
                  )
               )
               (Battle.Struct.Omnimods.get_statistics_mods omnimods)
            )
         )
      ]
   )

get_html : Battle.Struct.Omnimods.Type -> (Html.Html Struct.Event.Type)
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
               (\(k, v) ->
                  (Battle.View.DamageType.get_signed_html
                     (Battle.Struct.DamageType.decode k)
                     v
                  )
               )
               (Battle.Struct.Omnimods.get_attack_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-defense-mods")
            ]
            (List.map
               (\(k, v) ->
                  (Battle.View.DamageType.get_signed_html
                     (Battle.Struct.DamageType.decode k)
                     v
                  )
               )
               (Battle.Struct.Omnimods.get_defense_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-statistics-mods")
            ]
            (List.map
               (\(k, v) ->
                  (Battle.View.Statistic.get_signed_html
                     (Battle.Struct.Statistics.decode_category k)
                     v
                  )
               )
               (Battle.Struct.Omnimods.get_statistics_mods omnimods)
            )
         )
      ]
   )
