module View.Battlemap.Navigator exposing (get_html)

import Html
--import Html.Attributes
--import Html.Events

--import Battlemap.Location
import Battlemap.Navigator

import Event

get_html : (
      Int ->
      Battlemap.Navigator.Summary ->
      (List (Html.Html Event.Type))
   )
get_html tile_size nav_summary = []
