module Shared.Util.Http exposing (error_to_string)

import Http

error_to_string : Http.Error -> String
error_to_string error =
   case error of
      (Http.BadUrl string) -> ("Invalid URL: \"" ++ string ++ "\"")
      Http.Timeout -> "Timed out"
      Http.NetworkError -> "Connection lost, network error."
      (Http.BadStatus response) ->
         (
            "The HTTP request failed: "
            ++ (String.fromInt response)
            ++ "."
         )
      (Http.BadBody string) ->
         (
            "Server response not understood:\""
            ++ string
            ++ "\"."
         )
