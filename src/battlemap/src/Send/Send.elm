module Send exposing (Reply, try_sending)

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Encode

import Http

-- Battlemap -------------------------------------------------------------------
import Struct.Model
import Struct.Event

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Reply = (List String)

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
decoder : (Json.Decode.Decoder (List (List String)))
decoder =
   (Json.Decode.list (Json.Decode.list Json.Decode.string))

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try_sending : (
      Struct.Model.Type ->
      String ->
      (Struct.Model.Type -> (Maybe Json.Encode.Value)) ->
      (Maybe (Cmd Struct.Event.Type))
   )
try_sending model recipient try_encoding_fun =
   case (try_encoding_fun model) of
      (Just serial) ->
         (Just
            (Http.send
               Struct.Event.ServerReplied
               (Http.post
                  recipient
                  (Http.jsonBody serial)
                  (decoder)
               )
            )
         )

      Nothing -> Nothing
