module Model exposing (Model, model)

import Battlemap as Bp exposing (Battlemap, random)
import Battlemap.Location exposing (..)
import Battlemap.Navigator as Nr exposing (Navigator, new_navigator)

-- MODEL
type alias Model =
   {
      battlemap: Bp.Battlemap,
      navigator: (Maybe Nr.Navigator)
   }

model : Model
model =
   {
      battlemap = (Bp.random),
      navigator = (Just (Nr.new_navigator {x=2, y=4}))
   }
