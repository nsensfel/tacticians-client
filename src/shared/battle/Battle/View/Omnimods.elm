module Battle.View.Omnimods exposing
   (
      get_signed_html,
      get_unsigned_html,
      get_user_friendly_html
   )

-- Elm -------------------------------------------------------------------------
import List

import Html
import Html.Attributes
import Html.Events

-- Battle ----------------------------------------------------------------------
import Battle.Struct.DamageType
import Battle.Struct.Omnimods
import Battle.Struct.Attributes

import Battle.View.DamageType
import Battle.View.Attribute

-- Local Module ----------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_signed_html : Battle.Struct.Omnimods.Type -> (Html.Html Struct.Event.Type)
get_signed_html omnimods =
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
               (Html.Attributes.class "omnimod-attribute-mods")
            ]
            (List.map
               (\(k, v) ->
                  (Battle.View.Attribute.get_signed_html
                     (Battle.Struct.Attributes.decode_category k)
                     v
                  )
               )
               (Battle.Struct.Omnimods.get_attribute_mods omnimods)
            )
         )
      ]
   )

get_unsigned_html : Battle.Struct.Omnimods.Type -> (Html.Html Struct.Event.Type)
get_unsigned_html omnimods =
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
                  (Battle.View.DamageType.get_unsigned_html
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
                  (Battle.View.DamageType.get_unsigned_html
                     (Battle.Struct.DamageType.decode k)
                     v
                  )
               )
               (Battle.Struct.Omnimods.get_defense_mods omnimods)
            )
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-attribute-mods")
            ]
            (List.map
               (\(k, v) ->
                  (Battle.View.Attribute.get_unsigned_html
                     (Battle.Struct.Attributes.decode_category k)
                     v
                  )
               )
               (Battle.Struct.Omnimods.get_attribute_mods omnimods)
            )
         )
      ]
   )

get_user_friendly_html : (
      Battle.Struct.Omnimods.Type ->
      (Html.Html Struct.Event.Type)
   )
get_user_friendly_html omnimods =
   let
      omnimods_with_mins =
         (Battle.Struct.Omnimods.merge_attributes
            (Battle.Struct.Attributes.default)
            omnimods
         )
      scaled_omnimods =
         (Battle.Struct.Omnimods.apply_damage_modifier
            (Battle.Struct.Omnimods.get_attribute_mod
               Battle.Struct.Attributes.DamageModifier
               omnimods_with_mins
            )
            omnimods_with_mins
         )
   in
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
                     (Battle.View.DamageType.get_unsigned_html
                        (Battle.Struct.DamageType.decode k)
                        (max 0 v)
                     )
                  )
                  (Battle.Struct.Omnimods.get_attack_mods scaled_omnimods)
               )
            ),
            (Html.div
               [
                  (Html.Attributes.class "omnimod-defense-mods")
               ]
               (List.map
                  (\(k, v) ->
                     (Battle.View.DamageType.get_unsigned_html
                        (Battle.Struct.DamageType.decode k)
                        (max 0 v)
                     )
                  )
                  (Battle.Struct.Omnimods.get_defense_mods scaled_omnimods)
               )
            ),
            (Html.div
               [
                  (Html.Attributes.class "omnimod-attribute-mods")
               ]
               (List.map
                  (\(k, v) ->
                     (Battle.View.Attribute.get_unsigned_html
                        (Battle.Struct.Attributes.decode_category k)
                        (max 0 v)
                     )
                  )
                  (Battle.Struct.Omnimods.get_attribute_mods scaled_omnimods)
               )
            )
         ]
      )
