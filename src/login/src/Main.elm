module Main exposing (main)

-- Elm ------------------------------------------------------------------------
import Browser

-- Map -------------------------------------------------------------------
import Struct.Model
import Struct.Event
import Struct.Flags

import ElmModule.Init
import ElmModule.Subscriptions
import ElmModule.View
import ElmModule.Update

main : (Program Struct.Flags.Type Struct.Model.Type Struct.Event.Type)
main =
   (Browser.element
      {
         init = ElmModule.Init.init,
         view = ElmModule.View.view,
         update = ElmModule.Update.update,
         subscriptions = ElmModule.Subscriptions.subscriptions
      }
   )
