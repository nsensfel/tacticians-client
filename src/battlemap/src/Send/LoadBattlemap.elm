module Send.LoadBattlemap exposing (try)

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Encode

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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try : Model.Type -> (Maybe (Cmd Event.Type))
try model =
   (Send.try_sending model Constants.IO.battlemap_loading_handler try_encoding)
