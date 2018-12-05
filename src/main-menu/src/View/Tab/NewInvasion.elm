module View.Tab.NewInvasion exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Main Menu -------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI
import Struct.InvasionRequest
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
                  (Struct.Event.InvasionSetCategory
                     Struct.BattleSummary.InvasionAttack
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
                  (Struct.Event.InvasionSetCategory
                     Struct.BattleSummary.InvasionDefend
                  )
               )
            ]
            [
               (Html.text "New Defense")
            ]
         )
      ]
   )

select_size_html : Struct.InvasionRequest.Size -> (Html.Html Struct.Event.Type)
select_size_html max_size =
   (Html.div
      [
      ]
      [
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.InvasionSetSize
                     Struct.InvasionRequest.Small
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
                  (Struct.Event.InvasionSetSize
                     Struct.InvasionRequest.Medium
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
                  (Struct.Event.InvasionSetSize
                     Struct.InvasionRequest.Large
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


get_actual_html : Struct.InvasionRequest.Type -> (Html.Html Struct.Event.Type)
get_actual_html inv_req =
   case (Struct.InvasionRequest.get_category inv_req) of
      Struct.BattleSummary.InvasionEither -> (select_category_html)
      Struct.BattleSummary.InvasionAttack ->
         (
            case (Struct.InvasionRequest.get_size inv_req) of
               -- TODO: use roster size as upper limit.
               Nothing -> (select_size_html Struct.InvasionRequest.Large)
               _ ->
                  (Html.a
                     [
                        (Html.Attributes.href
                           (
                              "/roster-editor/"
                              ++
                              (Struct.InvasionRequest.get_url_params inv_req)
                           )
                        )
                     ]
                     [
                        (Html.text "Select Characters")
                     ]
                  )
         )
      Struct.BattleSummary.InvasionDefend ->
         (
            case (Struct.InvasionRequest.get_map_id inv_req) of
               -- FIXME: Requires model.
               "" -> (select_map_html)
               _ ->
                  case (Struct.InvasionRequest.get_size inv_req) of
                     Nothing ->
                        -- TODO: use min(RosterSize, MapSize) as upper limit.
                        (select_size_html Struct.InvasionRequest.Large)
                     _ ->
                        (Html.a
                           [
                              (Html.Attributes.href
                                 (
                                    "/roster-editor/"
                                    ++
                                    (Struct.InvasionRequest.get_url_params
                                       inv_req
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

      (Struct.UI.NewInvasion inv_req) ->
         (get_actual_html inv_req)
