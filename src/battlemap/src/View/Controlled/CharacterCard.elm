module View.Controlled.CharacterCard exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.Statistics

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_portrait : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_portrait char =
   (Html.div
      [
         (Html.Attributes.class
            (
               "asset-character-portrait-"
               ++ (Struct.Character.get_portrait_id char)
            )
         ),
         (Html.Attributes.class "battlemap-character-portrait"),
         (Html.Attributes.class "battlemap-character-card-portrait")
      ]
      [
      ]
   )

get_name : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_name_html char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card-name")
      ]
      [
         (Html.string (Struct.Character.get_name char))
      ]
   )

get_health_bar : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_health_bar char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card-health")
      ]
      [
         (Html.string
            (
               (toString (Struct.Character.get_current_health char))
               ++ "/"
               ++
               (toString
                  (Struct.Statistics.get_health
                     (Struct.Character.get_statistics char)
                  )
               )
            )
         )
      ]
   )

get_movement_bar : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_movement_bar char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card-movement")
      ]
      [
         (Html.string
            (
               "???/"
               ++
               (toString
                  (Struct.Statistics.get_movement_points
                     (Struct.Character.get_statistics char)
                  )
               )
            )
         )
      ]
   )

get_weapon_details : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_details model char weapon =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card-weapon")
      ]
      [
         (Html.string (Struct.Weapon.get_name wp))
      ]
   )

get_stat : String -> Int -> Boolean -> (Html.Html Struct.Event.Type)
get_stat name val perc =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card-stats-item")
      ]
      [
         (Html.string
            (
               name
               ++ " "
               ++ (toString val)
               ++
               (
                  if perc
                  then
                     "%"
                  else
                     ""
               )
            )
         )
      ]
   )

get_relevant_stats : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_relevant_stats model char weapon =
   let
      stats = (Struct.Character.get_statistics char)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-character-card-stats")
         ]
         [
            (get_stat "Dodg" (Struct.Statistics.get_dodges stats) True),
            (get_stat "Parr" (Struct.Statistics.get_parries stats) True),
            (get_stat "Accu" (Struct.Statistics.get_accuracy stats) False),
            (get_stat "2Hit" (Struct.Statistics.get_double_hits stats) True),
            (get_stat "Crit" (Struct.Statistics.get_critical_hits stats) True)
         ]
      )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model character weapon =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card")
      ]
      [
         (get_portrait char),
         (get_name char),
         (get_health_bar char),
         (get_movement_bar char),
         (get_weapon_details model char weapon),
         (get_relevant_stats model char weapon)
      ]
   )
