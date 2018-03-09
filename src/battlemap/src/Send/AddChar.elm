module Send.AddChar exposing (decode)

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Data.Weapons

import Struct.Attributes
import Struct.Character
import Struct.Model
import Struct.ServerReply
import Struct.WeaponSet

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

type alias Location =
   {
      x : Int,
      y : Int
   }

type alias CharData =
   {
      ix : Int,
      nam : String,
      ico : String,
      prt : String,
      lc : Location,
      hea : Int,
      pla : String,
      ena : Bool,
      att : CharAtt,
      awp : Int,
      swp : Int
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

location_decoder : (Json.Decode.Decoder Location)
location_decoder =
   (Json.Decode.Pipeline.decode
      Location
      |> (Json.Decode.Pipeline.required "x" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "y" Json.Decode.int)
   )

char_decoder : (Json.Decode.Decoder CharData)
char_decoder =
   (Json.Decode.Pipeline.decode
      CharData
      |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ico" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "prt" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "lc" location_decoder)
      |> (Json.Decode.Pipeline.required "hea" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "pla" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ena" Json.Decode.bool)
      |> (Json.Decode.Pipeline.required "att" attributes_decoder)
      |> (Json.Decode.Pipeline.required "awp" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "swp" Json.Decode.int)
   )

internal_decoder : Struct.Model.Type -> CharData -> Struct.ServerReply.Type
internal_decoder model char_data =
   (Struct.ServerReply.AddCharacter
      (Struct.Character.new
         (toString char_data.ix)
         char_data.nam
         char_data.ico
         char_data.prt
         {x = char_data.lc.x, y = char_data.lc.y}
         char_data.hea
         char_data.pla
         char_data.ena
         (Struct.Attributes.new
            char_data.att.con
            char_data.att.dex
            char_data.att.int
            char_data.att.min
            char_data.att.spe
            char_data.att.str
         )
         (
            case
               (
                  (Dict.get char_data.awp model.weapons),
                  (Dict.get char_data.swp model.weapons)
               )
            of
               ((Just wp_0), (Just wp_1)) ->
                  (Struct.WeaponSet.new wp_0 wp_1)

               _ ->
                  (Struct.WeaponSet.new
                     (Data.Weapons.none)
                     (Data.Weapons.none)
                  )
         )
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Struct.Model.Type -> (Json.Decode.Decoder Struct.ServerReply.Type))
decode model = (Json.Decode.map (internal_decoder model) char_decoder)
