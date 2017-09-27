import Html
import View
import Shim.Model
import Update

main =
   (Html.beginnerProgram
      {
         model = Shim.Model.generate,
         view = View.view,
         update = Update.update
      }
   )
