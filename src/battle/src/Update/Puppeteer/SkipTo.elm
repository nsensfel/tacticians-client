module Update.Puppeteer.SkipTo exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Shared ----------------------------------------------------------------------
import Shared.Update.Sequence

-- Local module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.Puppeteer

import Update.Puppeteer
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

restore_puppeteer : (
      Bool ->
      Bool ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
restore_puppeteer is_paused play_forward model =
   (
      {model |
         puppeteer =
            (Struct.Puppeteer.set_is_ignoring_time
               False
               (Struct.Puppeteer.set_is_paused
                  is_paused
                  (Struct.Puppeteer.set_is_playing_forward
                     play_forward
                     model.puppeteer
                  )
               )
            )
      },
      Cmd.none
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Bool ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to skip_forward model =
   (Shared.Update.Sequence.sequence
      [
         (Update.Puppeteer.apply_to),
         (restore_puppeteer
            (Struct.Puppeteer.get_is_paused model.puppeteer)
            (Struct.Puppeteer.get_is_playing_forward model.puppeteer)
         ),
         (Update.Puppeteer.apply_to)
      ]
      {model |
         puppeteer =
            (Struct.Puppeteer.set_is_ignoring_time
               True
               (Struct.Puppeteer.set_is_paused
                  False
                  (Struct.Puppeteer.set_is_playing_forward
                     skip_forward
                     model.puppeteer
                  )
               )
            )
      }
   )
