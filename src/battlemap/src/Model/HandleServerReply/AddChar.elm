module Model.HandleServerReply.AddChar exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Location

import Character

import Error

import Model

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias CharData =
   {
      id : String,
      name : String,
      icon : String,
      portrait : String,
      loc_x : Int,
      loc_y : Int,
      team : Int,
      mov_pts : Int,
      atk_rg : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
char_decoder : (Json.Decode.Decoder CharData)
char_decoder =
   (Json.Decode.Pipeline.decode
      CharData
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "name" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "icon" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "portrait" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "loc_x" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "loc_y" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "team" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "mov_pts" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "atk_rg" Json.Decode.int)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Model.Type -> String -> Model.Type
apply_to model serialized_char =
   case
      (Json.Decode.decodeString
         char_decoder
         serialized_char
      )
   of
      (Result.Ok char_data) ->
         (Model.add_character
            model
            (Character.new
               char_data.id
               char_data.name
               char_data.icon
               char_data.portrait
               {x = char_data.loc_x, y = char_data.loc_y}
               char_data.team
               char_data.mov_pts
               char_data.atk_rg
            )
         )

      (Result.Err msg) ->
         (Model.invalidate
            model
            (Error.new
               Error.Programming
               ("Could not deserialize character: " ++ msg)
            )
         )
