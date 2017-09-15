import Html exposing (Html)
import View exposing (view)
import Model exposing (model)
import Update exposing (update)

main =
   (Html.beginnerProgram
      {
         model = model,
         view = view,
         update = update
      }
   )
