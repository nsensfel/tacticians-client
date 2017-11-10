module Send exposing (Reply, try_sending)

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Encode

import Http

-- Battlemap -------------------------------------------------------------------
import Model

import Event

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
      Model.Type ->
      String ->
      (Model.Type -> (Maybe Json.Encode.Value)) ->
      (Maybe (Cmd Event.Type))
   )
try_sending model recipient try_encoding_fun =
   case (try_encoding_fun model) of
      (Just serial) ->
         (Just
            (Http.send
               Event.ServerReplied
               (Http.post
                  recipient
                  (Http.jsonBody serial)
                  (decoder)
               )
            )
         )

      Nothing -> Nothing
