module View.Battlemap.Navigator exposing (get_html)

import List
import Html
import Html.Attributes
import Html.Events

import Battlemap.Location
import Battlemap.Direction
import Battlemap.Marker
import Battlemap.Navigator

import Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
marker_get_html : (
      Int ->
      (Battlemap.Location.Ref, Battlemap.Marker.Type) ->
      (Html.Html Event.Type)
   )
marker_get_html tile_size (loc_ref, marker) =
   (Html.div
      [
         (Html.Attributes.class "battlemap-marker-icon"),
         (Html.Attributes.class "battlemap-tiled"),
         (Html.Attributes.class
            (
               "asset-marker-icon-"
               ++
               if (marker == Battlemap.Marker.CanGoTo)
               then
                  "can-go-to"
               else
                  "can-attack"
            )
         ),
         (Html.Events.onClick
            (Event.TileSelected loc_ref)
         ),
         (Html.Attributes.style
            (
               let
                  loc = (Battlemap.Location.from_ref loc_ref)
               in
                  [
                     ("top", ((toString (loc.y * tile_size)) ++ "px")),
                     ("left", ((toString (loc.x * tile_size)) ++ "px"))
                  ]
            )
         )
      ]
      [
      ]
   )

path_node_get_html : (
      Int ->
      Battlemap.Direction.Type ->
      (
         Battlemap.Location.Type,
         Battlemap.Direction.Type,
         (List (Html.Html Event.Type))
      ) ->
      (
         Battlemap.Location.Type,
         Battlemap.Direction.Type,
         (List (Html.Html Event.Type))
      )
   )
path_node_get_html tile_size new_dir (curr_loc, prev_dir, curr_nodes) =
   let
      new_loc = (Battlemap.Location.neighbor curr_loc new_dir)
   in
      (
         new_loc,
         new_dir,
         (
            (Html.div
               [
                  (Html.Attributes.class "battlemap-path-icon"),
                  (Html.Attributes.class "battlemap-tiled"),
                  (Html.Attributes.class
                     (
                        "asset-path-icon-"
                        ++
                        (Battlemap.Direction.to_string prev_dir)
                        ++
                        (Battlemap.Direction.to_string new_dir)
                     )
                  ),
                  (Html.Events.onClick
                     (Event.TileSelected (Battlemap.Location.get_ref new_loc))
                  ),
                  (Html.Attributes.style
                     [
                        (
                           "top",
                           ((toString (new_loc.y * tile_size)) ++ "px")
                        ),
                        (
                           "left",
                           ((toString (new_loc.x * tile_size)) ++ "px")
                        )
                     ]
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
      Int ->
      Battlemap.Location.Type ->
      Battlemap.Direction.Type ->
      (Html.Html Event.Type)
   )
mark_the_spot tile_size loc origin_dir =
   (Html.div
      [
         (Html.Attributes.class "battlemap-path-icon"),
         (Html.Attributes.class "battlemap-tiled"),
         (Html.Attributes.class
            (
               "asset-path-icon-mark"
               ++
               (Battlemap.Direction.to_string origin_dir)
            )
         ),
         (Html.Events.onClick
            (Event.TileSelected (Battlemap.Location.get_ref loc))
         ),
         (Html.Attributes.style
            [
               (
                  "top",
                  ((toString (loc.y * tile_size)) ++ "px")
               ),
               (
                  "left",
                  ((toString (loc.x * tile_size)) ++ "px")
               )
            ]
         )
      ]
      [
      ]
   )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Int ->
      Battlemap.Navigator.Summary ->
      (List (Html.Html Event.Type))
   )
get_html tile_size nav_summary =
   (
      (List.map (marker_get_html tile_size) nav_summary.markers)
      ++
      (
         let
            (final_loc, final_dir, path_node_htmls) =
               (List.foldr
                  (path_node_get_html tile_size)
                  (nav_summary.starting_location, Battlemap.Direction.None, [])
                  nav_summary.path
               )
         in
            ((mark_the_spot tile_size final_loc final_dir) :: path_node_htmls)
      )
   )
