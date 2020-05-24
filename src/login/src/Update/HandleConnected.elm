module Update.HandleConnected exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Url

-- Shared ----------------------------------------------------------------------
import Shared.Action.Ports

import Shared.Struct.Flags

-- Local Module ----------------------------------------------------------------
import Constants.IO

import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   (
      model,
      (Shared.Action.Ports.go_to
         (Constants.IO.base_url ++
            (
               case
                  (Shared.Struct.Flags.maybe_get_parameter "goto" model.flags)
               of
                  Nothing -> "/main-menu/"
                  (Just string) ->
                     case (Url.percentDecode string) of
                        Nothing -> "/main-menu/"
                        (Just "") -> "/main-menu/"
                        (Just url) -> url
            )
         )
      )
   )
