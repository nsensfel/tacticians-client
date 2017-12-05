-- Elm ------------------------------------------------------------------------
import Html

-- Battlemap -------------------------------------------------------------------
import Struct.Model
import Struct.Event

import ElmModule.Init
import ElmModule.Subscriptions
import ElmModule.View
import ElmModule.Update

main : (Program Never Struct.Model.Type Struct.Event.Type)
main =
   (Html.program
      {
         init = ElmModule.Init.init,
         view = ElmModule.View.view,
         update = ElmModule.Update.update,
         subscriptions = ElmModule.Subscriptions.subscriptions
      }
   )
