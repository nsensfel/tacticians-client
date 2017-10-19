module View.Battlemap.Navigator exposing (get_html)

import List
import Html
import Html.Attributes
import Html.Events

import Battlemap.Location
import Battlemap.Marker
import Battlemap.Navigator

import Event

get_html : (
      Int ->
      Battlemap.Navigator.Summary ->
      (List (Html.Html Event.Type))
   )
get_html tile_size nav_summary =
   (List.map
      (\(loc_ref, marker) ->
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
      )
      nav_summary.markers
   )
