module Struct.Flags exposing
   (
      Type,
      -- TODO: refactor into try_getting_parameter and so on.
      maybe_get_param,
      force_get_param,
      get_params_as_url,
      get_session_token,
      get_user_id
   )

-- Elm -------------------------------------------------------------------------
import List

-- Shared ----------------------------------------------------------------------
import Util.List

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      user_id : String,
      token : String,
      url_params : (List (List String))
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
param_as_url : (List String) -> String
param_as_url param =
   case param of
      [name, value] -> (name ++ "=" ++ value)
      _ -> ""

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
maybe_get_param : String -> Type -> (Maybe String)
maybe_get_param param flags =
   case
      (Util.List.get_first
         (\e -> ((List.head e) == (Just param)))
         flags.url_params
      )
   of
      Nothing -> Nothing
      (Just a) ->
         case (List.tail a) of
            Nothing -> Nothing
            (Just b) -> (List.head b)

force_get_param : String -> Type -> String
force_get_param param flags =
   case (maybe_get_param param flags) of
      Nothing -> ""
      (Just str) -> str

get_params_as_url : Type -> String
get_params_as_url flags =
   (List.foldl
      (\param -> \current_params ->
         (current_params ++ "&" ++ (param_as_url param))
      )
      ""
      flags.url_params
   )

get_session_token : Type -> String
get_session_token flags = flags.token

get_user_id : Type -> String
get_user_id flags = flags.user_id
