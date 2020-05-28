module Update.Puppeteer.TogglePause exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Local module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.Puppeteer

import Update.Puppeteer
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   (Update.Puppeteer.apply_to
      {model|
         puppeteer =
            (Struct.Puppeteer.set_is_paused
               (not (Struct.Puppeteer.get_is_paused model.puppeteer))
               model.puppeteer
            )
      }
   )
