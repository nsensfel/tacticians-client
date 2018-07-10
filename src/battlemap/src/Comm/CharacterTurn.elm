module Comm.CharacterTurn exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Battlemap -------------------------------------------------------------------
import Constants.IO

import Comm.Send

import Struct.Character
import Struct.CharacterTurn
import Struct.Direction
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
encode_move : Struct.Model.Type -> (Maybe Json.Encode.Value)
encode_move model =
   case (Struct.CharacterTurn.get_path model.char_turn) of
      [] -> Nothing
      path ->
         (Just
            (Json.Encode.object
               [
                  ("t", (Json.Encode.string "mov")),
                  (
                     "p",
                     (Json.Encode.list
                        (List.map
                           (
                              (Json.Encode.string)
                              <<
                              (Struct.Direction.to_string)
                           )
                           (List.reverse path)
                        )
                     )
                  )
               ]
            )
         )

encode_weapon_switch : Struct.Model.Type -> (Maybe Json.Encode.Value)
encode_weapon_switch model =
   if (Struct.CharacterTurn.has_switched_weapons model.char_turn)
   then
      (Just
         (Json.Encode.object
            [
               ("t", (Json.Encode.string "swp"))
            ]
         )
      )
   else
      Nothing

encode_attack : Struct.Model.Type -> (Maybe Json.Encode.Value)
encode_attack model =
   case (Struct.CharacterTurn.try_getting_target model.char_turn) of
      Nothing -> Nothing

      (Just ix) ->
         (Just
            (Json.Encode.object
               [
                  ("t", (Json.Encode.string "atk")),
                  ("tix", (Json.Encode.int ix))
               ]
            )
         )

encode_actions : Struct.Model.Type -> (List Json.Encode.Value)
encode_actions model =
   case
      (
         (encode_move model),
         (encode_weapon_switch model),
         (encode_attack model)
      )
   of
      ((Just move), Nothing, Nothing) -> [move]
      ((Just move), Nothing, (Just attack)) -> [move, attack]
      (Nothing, (Just switch_weapon), Nothing) -> [switch_weapon]
      (Nothing, (Just switch_weapon), (Just attack)) -> [switch_weapon, attack]
      (Nothing, Nothing, (Just attack)) -> [attack]
      _ -> []

try_encoding : Struct.Model.Type -> (Maybe Json.Encode.Value)
try_encoding model =
   case (Struct.CharacterTurn.try_getting_active_character model.char_turn) of
      (Just char) ->
         (Just
            (Json.Encode.object
               [
                  ("stk", (Json.Encode.string model.session_token)),
                  ("pid", (Json.Encode.string model.player_id)),
                  ("bid", (Json.Encode.string model.battlemap_id)),
                  (
                     "cix",
                     (Json.Encode.int (Struct.Character.get_index char))
                  ),
                  (
                     "act",
                     (Json.Encode.list (encode_actions model))
                  )
               ]
            )
         )

      _ ->
         Nothing

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try : Struct.Model.Type -> (Maybe (Cmd Struct.Event.Type))
try model =
   (Comm.Send.try_sending
      model
      Constants.IO.character_turn_handler
      try_encoding
   )
