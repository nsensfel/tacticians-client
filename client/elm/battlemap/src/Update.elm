module Update exposing (Msg(Increment, Decrement), update)

import Model exposing (Model, model)

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
   case msg of
      Increment -> (model + 1)
      Decrement -> (model - 1)
