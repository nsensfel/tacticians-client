module View.Battlemap exposing (view)

import View.Battlemap.Tile
import View.Battlemap.Navigator

view : Battlemap.Type -> (Html.Html Event.Type)
view battlemap =
   (Html.div
      [
         (Html.Attribute.class "battlemap-container")
      ]
      [
         (
         ,
         case battlemap.navigator of
            (Just navigator) ->
               (Html.div
                  [
                     (Html.Attribute.class "battlemap-navigator-container")
                  ]
                  [ (Battlemap.Navigator.Html.view battlemap.navigator) ]
               )

            Nothing -> (Html.text "") -- Meaning no element.
      ]
   )
