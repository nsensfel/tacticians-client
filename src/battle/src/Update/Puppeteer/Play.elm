module Update.Puppeteer.Play exposing (apply_to)

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
apply_to : (
      Bool ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to play_forward model =
   (Update.Puppeteer.apply_to
      {model|
         puppeteer =
            (Struct.Puppeteer.set_is_playing_forward
               play_forward
               model.puppeteer
            )
      }
   )
