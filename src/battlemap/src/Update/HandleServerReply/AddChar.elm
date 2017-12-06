module Update.HandleServerReply.AddChar exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Error
import Struct.Model

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias CharData =
   {
      id : String,
      name : String,
      icon : String,
      portrait : String,
      health : Int,
      max_health : Int,
      loc_x : Int,
      loc_y : Int,
      team : Int,
      mov_pts : Int,
      atk_rg : Int,
      enabled : Bool
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
      |> (Json.Decode.Pipeline.required "health" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "max_health" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "loc_x" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "loc_y" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "team" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "mov_pts" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "atk_rg" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "enabled" Json.Decode.bool)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> String -> Struct.Model.Type
apply_to model serialized_char =
   case
      (Json.Decode.decodeString
         char_decoder
         serialized_char
      )
   of
      (Result.Ok char_data) ->
         (Struct.Model.add_character
            model
            (Struct.Character.new
               char_data.id
               char_data.name
               char_data.icon
               char_data.portrait
               char_data.health
               char_data.max_health
               {x = char_data.loc_x, y = char_data.loc_y}
               char_data.team
               char_data.mov_pts
               char_data.atk_rg
               char_data.enabled
            )
         )

      (Result.Err msg) ->
         (Struct.Model.invalidate
            model
            (Struct.Error.new
               Struct.Error.Programming
               ("Could not deserialize character: " ++ msg)
            )
         )
