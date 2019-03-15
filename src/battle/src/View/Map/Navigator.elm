module View.Map.Navigator exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

import List

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Constants.UI

import Struct.Event
import Struct.Marker
import Struct.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
marker_get_html : (
      Bool ->
      (BattleMap.Struct.Location.Ref, Struct.Marker.Type) ->
      (Html.Html Struct.Event.Type)
   )
marker_get_html is_interactive (loc_ref, marker) =
   let loc = (BattleMap.Struct.Location.from_ref loc_ref) in
   (Html.div
      (
         [
            (Html.Attributes.class "marker-icon"),
            (Html.Attributes.class "tiled"),
            (Html.Attributes.class
               (
                  (
                     case marker of
                        Struct.Marker.CanGoToCanDefend -> "can-go-to-can-defend"
                        Struct.Marker.CanGoToCantDefend ->
                           "can-go-to-cant-defend"

                        Struct.Marker.CanAttackCanDefend ->
                           "can-attack-can-defend"

                        Struct.Marker.CanAttackCantDefend ->
                           "can-attack-cant-defend"
                  )
                  ++
                  "-marker"
               )
            ),
            (Html.Attributes.style
               "top"
               ((String.fromInt (loc.y * Constants.UI.tile_size)) ++ "px")
            ),
            (Html.Attributes.style
               "left"
               ((String.fromInt (loc.x * Constants.UI.tile_size)) ++ "px")
            )
         ]
         ++
         (
            if (is_interactive)
            then
               if
               (
                  (marker == Struct.Marker.CanGoToCanDefend)
                  || (marker == Struct.Marker.CanGoToCantDefend)
               )
               then
                  [
                     (Html.Attributes.class "navigator-interactive"),
                     (Html.Attributes.class "clickable"),
                     (Html.Events.onClick
                        (Struct.Event.CharacterOrTileSelected loc_ref)
                     )
                  ]
               else
                  [
                     (Html.Attributes.class "navigator-interactive")
                  ]
            else
               [
                  (Html.Attributes.class "navigator-non-interactive"),
                  (Html.Events.onClick
                     (Struct.Event.CharacterOrTileSelected loc_ref)
                  )
               ]
         )
      )
      [
      ]
   )

path_node_get_html : (
      Bool ->
      BattleMap.Struct.Direction.Type ->
      (
         BattleMap.Struct.Location.Type,
         BattleMap.Struct.Direction.Type,
         (List (Html.Html Struct.Event.Type))
      ) ->
      (
         BattleMap.Struct.Location.Type,
         BattleMap.Struct.Direction.Type,
         (List (Html.Html Struct.Event.Type))
      )
   )
path_node_get_html is_below_markers next_dir (curr_loc, curr_dir, curr_nodes) =
   (
      (BattleMap.Struct.Location.neighbor next_dir curr_loc),
      next_dir,
      (
         (Html.div
            [
               (Html.Attributes.class "path-icon"),
               (Html.Attributes.class
                  (
                     if (is_below_markers)
                     then
                        "path-icon-below-markers"
                     else
                        "path-icon-above-markers"
                  )
               ),
               (Html.Attributes.class "tiled"),
               (Html.Attributes.class
                  (
                     "path-icon-"
                     ++
                     (BattleMap.Struct.Direction.to_string curr_dir)
                     ++
                     (BattleMap.Struct.Direction.to_string next_dir)
                  )
               ),
               (Html.Events.onClick
                  (Struct.Event.CharacterOrTileSelected
                     (BattleMap.Struct.Location.get_ref curr_loc)
                  )
               ),
               (Html.Attributes.style
                  "top"
                  (
                     (String.fromInt
                        (curr_loc.y * Constants.UI.tile_size)
                     )
                     ++
                     "px"
                  )
               ),
               (Html.Attributes.style
                  "left"
                  (
                     (String.fromInt
                        (curr_loc.x * Constants.UI.tile_size)
                     )
                     ++
                     "px"
                  )
               )
            ]
            [
            ]
         )
         ::
         curr_nodes
      )
   )

mark_the_spot : (
      BattleMap.Struct.Location.Type ->
      BattleMap.Struct.Direction.Type ->
      (Html.Html Struct.Event.Type)
   )
mark_the_spot loc origin_dir =
   (Html.div
      [
         (Html.Attributes.class "path-icon"),
         (Html.Attributes.class "path-icon-above-markers"),
         (Html.Attributes.class "tiled"),
         (Html.Attributes.class
            (
               "path-icon-mark"
               ++
               (BattleMap.Struct.Direction.to_string origin_dir)
            )
         ),
         (Html.Events.onClick
            (Struct.Event.CharacterOrTileSelected
               (BattleMap.Struct.Location.get_ref loc)
            )
         ),
         (Html.Attributes.style
            "top"
            ((String.fromInt (loc.y * Constants.UI.tile_size)) ++ "px")
         ),
         (Html.Attributes.style
            "left"
            ((String.fromInt (loc.x * Constants.UI.tile_size)) ++ "px")
         )
      ]
      [
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Navigator.Summary ->
      Bool ->
      (List (Html.Html Struct.Event.Type))
   )
get_html nav_summary is_interactive =
   if (is_interactive)
   then
      (
         (List.map (marker_get_html True) nav_summary.markers)
         ++
         (
            let
               (final_loc, final_dir, path_node_htmls) =
                  (List.foldr
                     (path_node_get_html nav_summary.locked_path)
                     (
                        nav_summary.starting_location,
                        BattleMap.Struct.Direction.None,
                        []
                     )
                     nav_summary.path
                  )
            in
               ((mark_the_spot final_loc final_dir) :: path_node_htmls)
         )
      )
   else
      (List.map (marker_get_html False) nav_summary.markers)
