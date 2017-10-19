import Html

import Model
import Event

import Init
import Subscriptions
import View
import Update

main : (Program Never Model.Type Event.Type)
main =
   (Html.program
      {
         init = Init.init,
         view = View.view,
         update = Update.update,
         subscriptions = Subscriptions.subscriptions
      }
   )
