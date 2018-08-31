module Struct.Model exposing
   (
      Type,
      new,
      invalidate,
      reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------

-- Main Menu -------------------------------------------------------------------
import Struct.Error
import Struct.Flags
import Struct.Player
import Struct.UI

import Util.Array

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      help_request: Struct.HelpRequest.Type,
      error: (Maybe Struct.Error.Type),
      player_id: String,
      session_token: String,
      player: Struct.Player.Type,
      ui: Struct.UI.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Struct.Flags.Type -> Type
new flags =
   {
      help_request = Struct.HelpRequest.None,
      error = Nothing,
      player_id = flags.user_id,
      session_token = flags.token,
      player = (Struct.Player.none),
      ui = (Struct.UI.default)
   }

reset : Type -> Type
reset model =
   {model |
      error = Nothing
   }

invalidate : Struct.Error.Type -> Type -> Type
invalidate err model =
   {model |
      error = (Just err)
   }

clear_error : Type -> Type
clear_error model = {model | error = Nothing}