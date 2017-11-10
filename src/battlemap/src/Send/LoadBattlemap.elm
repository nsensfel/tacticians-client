module Send.LoadBattlemap exposing (try_sending)

-- Elm -------------------------------------------------------------------------
import Http

import Dict

import Json.Encode
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Constants.IO

import Battlemap
import Battlemap.Direction

import UI

import Model

import Send

import Event

--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
try_encoding : Model.Type -> (Maybe Json.Encode.Value)
try_encoding model =
   case (Model.get_state model) of
      (Model.ControllingCharacter char_ref) ->
         (Just
--            (Json.Encode.encode
--               0
               (Json.Encode.object
                  [
                     ("battlemap_id", Json.Encode.string char_ref)
                  ]
               )
--            )
         )

      _ ->
         Nothing

decode : (Json.Decode.Decoder (Dict.Dict String (List String))) --Send.Reply)
decode =
   (Json.Decode.dict
      (Json.Decode.list Json.Decode.string)
   )

-- Reply:
-- {
--    TYPES: (list Instr-Type),
--    DATA: (list Instr-Data)
-- }
--
-- Instr-Type : display-message, move-char, etc...
-- Instr-Data : {category: int, content: string}, {char_id: string, x: int, y: int}

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try_sending : Model.Type -> (Maybe (Cmd Event.Type))
try_sending model =
   case (try_encoding model) of
      (Just serial) ->
         (Just
            (Http.send
               Event.ServerReplied
               (Http.post
                  Constants.IO.battlemap_loading_handler
                  (Http.jsonBody serial)
                  (decode)
               )
            )
         )

      Nothing -> Nothing
