module Update.HandleServerReply.AddChar exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Struct.Attributes
import Struct.Character
import Struct.Error
import Struct.Model

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias CharAtt =
   {
      con : Int,
      dex : Int,
      int : Int,
      min : Int,
      spe : Int,
      str : Int
   }

type alias CharData =
   {
      id : String,
      name : String,
      icon : String,
      portrait : String,
      loc_x : Int,
      loc_y : Int,
      health : Int,
      team : Int,
      enabled : Bool,
      att : CharAtt
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
attributes_decoder : (Json.Decode.Decoder CharAtt)
attributes_decoder =
   (Json.Decode.Pipeline.decode
      CharAtt
      |> (Json.Decode.Pipeline.required "con" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "dex" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "int" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "min" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "spe" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "str" Json.Decode.int)
   )

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
      |> (Json.Decode.Pipeline.required "health" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "team" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "enabled" Json.Decode.bool)
      |> (Json.Decode.Pipeline.required "att" attributes_decoder)
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
               {x = char_data.loc_x, y = char_data.loc_y}
               char_data.health
               char_data.team
               char_data.enabled
               (Struct.Attributes.new
                  char_data.att.con
                  char_data.att.dex
                  char_data.att.int
                  char_data.att.min
                  char_data.att.spe
                  char_data.att.str
               )
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
