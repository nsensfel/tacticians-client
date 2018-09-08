module Update.HandleConnected exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Http

-- Login -----------------------------------------------------------------------
import Action.Ports

import Constants.IO

import Struct.Event
import Struct.Flags
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
      (Action.Ports.go_to
         (Constants.IO.base_url ++
            (
               case (Struct.Flags.maybe_get_param "goto" model.flags) of
                  Nothing -> "/main-menu/"
                  (Just string) ->
                     case (Http.decodeUri string) of
                        Nothing -> "/main-menu/"
                        (Just "") -> "/main-menu/"
                        (Just url) -> url
            )
         )
      )
   )
