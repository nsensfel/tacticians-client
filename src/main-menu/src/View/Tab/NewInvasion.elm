module View.Tab.NewBattle exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Main Menu -------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI
import Struct.BattleRequest
import Struct.BattleSummary

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
select_category_html : (Html.Html Struct.Event.Type)
select_category_html =
   (Html.div
      [
      ]
      [
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetCategory
                     Struct.BattleSummary.BattleAttack
                  )
               )
            ]
            [
               (Html.text "New Offensive")
            ]
         ),
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetCategory
                     Struct.BattleSummary.BattleDefend
                  )
               )
            ]
            [
               (Html.text "New Defense")
            ]
         )
      ]
   )

select_size_html : Struct.BattleRequest.Size -> (Html.Html Struct.Event.Type)
select_size_html max_size =
   (Html.div
      [
      ]
      [
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetSize
                     Struct.BattleRequest.Small
                  )
               )
            ]
            [
               (Html.text "Small")
            ]
         ),
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetSize
                     Struct.BattleRequest.Medium
                  )
               )
            ]
            [
               (Html.text "Medium")
            ]
         ),
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetSize
                     Struct.BattleRequest.Large
                  )
               )
            ]
            [
               (Html.text "Large")
            ]
         )
      ]
   )

select_map_html : (Html.Html Struct.Event.Type)
select_map_html =
   (Html.div
      [
      ]
      [
         (Html.text "Map Selection")
      ]
   )


get_actual_html : Struct.BattleRequest.Type -> (Html.Html Struct.Event.Type)
get_actual_html battle_req =
   case (Struct.BattleRequest.get_category battle_req) of
      Struct.BattleSummary.Invasion ->

      _ ->
         case 
      Struct.BattleSummary.Either -> (select_category_html)
      Struct.BattleSummary.Attack ->
         (
            case (Struct.BattleRequest.get_size battle_req) of
               -- TODO: use roster size as upper limit.
               Nothing -> (select_size_html Struct.BattleRequest.Large)
               _ ->
                  (Html.a
                     [
                        (Html.Attributes.href
                           (
                              "/roster-editor/"
                              ++
                              (Struct.BattleRequest.get_url_params battle_req)
                           )
                        )
                     ]
                     [
                        (Html.text "Select Characters")
                     ]
                  )
         )
      Struct.BattleSummary.Defend ->
         (
            case (Struct.BattleRequest.get_map_id battle_req) of
               -- FIXME: Requires model.
               "" -> (select_map_html)
               _ ->
                  case (Struct.BattleRequest.get_size battle_req) of
                     Nothing ->
                        -- TODO: use min(RosterSize, MapSize) as upper limit.
                        (select_size_html Struct.BattleRequest.Large)
                     _ ->
                        (Html.a
                           [
                              (Html.Attributes.href
                                 (
                                    "/roster-editor/"
                                    ++
                                    (Struct.BattleRequest.get_url_params
                                       battle_req
                                    )
                                 )
                              )
                           ]
                           [
                              (Html.text "Select Characters")
                           ]
                        )
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (Struct.UI.get_action model.ui) of
      Struct.UI.None ->
         -- TODO: explain & let the user go back to the main menu.
         (Html.text "Error.")

      (Struct.UI.NewBattle battle_req) ->
         (get_actual_html battle_req)
