module Main exposing (main)

-- Elm ------------------------------------------------------------------------
import Browser

-- Shared ----------------------------------------------------------------
import Shared.Struct.Flags

-- Local Module ----------------------------------------------------------
import Struct.Model
import Struct.Event

import ElmModule.Init
import ElmModule.Subscriptions
import ElmModule.View
import ElmModule.Update

main : (Program Shared.Struct.Flags.Type Struct.Model.Type Struct.Event.Type)
main =
   (Browser.element
      {
         init = ElmModule.Init.init,
         view = ElmModule.View.view,
         update = ElmModule.Update.update,
         subscriptions = ElmModule.Subscriptions.subscriptions
      }
   )
