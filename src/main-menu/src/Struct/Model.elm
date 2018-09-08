module Struct.Model exposing
   (
      Type,
      new,
      invalidate,
      reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------

-- Shared ----------------------------------------------------------------------
import Struct.Flags

-- Main Menu -------------------------------------------------------------------
import Struct.Error
import Struct.Player
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      flags: Struct.Flags.Type,
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
      flags = flags,
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
