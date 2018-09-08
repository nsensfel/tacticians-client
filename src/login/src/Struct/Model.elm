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

-- Login -----------------------------------------------------------------------
import Struct.Error
import Struct.HelpRequest
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      help_request: Struct.HelpRequest.Type,
      error: (Maybe Struct.Error.Type),
      flags: Struct.Flags.Type,
      username: String,
      password1: String,
      password2: String,
      email1: String,
      email2: String,
      player_id: String,
      session_token: String,
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
   let
      maybe_mode = (Struct.Flags.maybe_get_param "mode" flags)
      model =
         {
            help_request = Struct.HelpRequest.None,
            flags = flags,
            error = Nothing,
            username = "",
            password1 = "",
            password2 = "",
            email1 = "",
            email2 = "",
            player_id = flags.user_id,
            session_token = flags.token,
            ui = (Struct.UI.default)
         }
   in
      case maybe_mode of
         Nothing -> model

         (Just id) ->
            {model |
               ui =
                  (Struct.UI.set_displayed_tab
                     (Struct.UI.tab_from_string id)
                     model.ui
                  )
            }

reset : Type -> Type
reset model =
   {model |
      help_request = Struct.HelpRequest.None,
      error = Nothing,
      ui = (Struct.UI.default)
   }

invalidate : Struct.Error.Type -> Type -> Type
invalidate err model =
   {model |
      error = (Just err)
   }

clear_error : Type -> Type
clear_error model = {model | error = Nothing}
