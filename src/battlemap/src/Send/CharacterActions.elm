module IO.CharacterTurn exposing (send)

-- Elm -------------------------------------------------------------------------
import Http

import Json.Encode
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Constants.IO

import Event
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
encode : Model -> Json.Encode.Value
encode model =
   (Json.Encode.encode
      0
      (Json.Encode.object
         [
            ("user_token", Json.Encode.string model.user_token),
            ("char_id", Json.Encode.string ...),
            ("path", Jsong.Encode.string ...),
            ("target_id", Jsong.Encode.string ...)
         ]
      )
   )

decode : (Json.Decode.Decoder a)
decode =

receive : (Http.Result (Http.Error a)) -> Event
receive reply =

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
send : Model -> (Http.Request String)
send model =
   (Http.send
      (receive)
      (Http.post
         Constants.IO.battlemap_handler_url
         (Http.jsonBody (encode model))
         (decode)
      )
   )
