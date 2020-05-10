module Shared.Struct.Flags exposing
   (
      Type,
      maybe_get_parameter,
      force_get_parameter,
      get_parameters_as_url,
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
      url_parameters : (List (List String))
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
parameter_as_url : (List String) -> String
parameter_as_url parameter =
   case parameter of
      [name, value] -> (name ++ "=" ++ value)
      _ -> ""

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
maybe_get_parameter : String -> Type -> (Maybe String)
maybe_get_parameter parameter flags =
   case
      (Util.List.get_first
         (\e -> ((List.head e) == (Just parameter)))
         flags.url_parameters
      )
   of
      Nothing -> Nothing
      (Just a) ->
         case (List.tail a) of
            Nothing -> Nothing
            (Just b) -> (List.head b)

force_get_parameter : String -> Type -> String
force_get_parameter parameter flags =
   case (maybe_get_parameter parameter flags) of
      Nothing -> ""
      (Just str) -> str

get_parameters_as_url : Type -> String
get_parameters_as_url flags =
   (List.foldl
      (\parameter -> \current_parameters ->
         (current_parameters ++ "&" ++ (parameter_as_url parameter))
      )
      ""
      flags.url_parameters
   )

get_session_token : Type -> String
get_session_token flags = flags.token

get_user_id : Type -> String
get_user_id flags = flags.user_id
