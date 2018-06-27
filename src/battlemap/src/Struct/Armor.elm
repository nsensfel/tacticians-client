module Struct.Armor exposing
   (
      Type,
      Ref,
      Category(..),
      new,
      get_id,
      get_name,
      get_category,
      get_resistance_to,
      get_image_id,
      decoder,
      none,
      apply_to_attributes
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Struct.Attributes
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias PartiallyDecoded =
   {
      id : Int,
      nam : String,
      ct : String,
      cf : Float
   }

type alias Type =
   {
      id : Int,
      name : String,
      category : Category,
      coef : Float
   }

type alias Ref = Int

type Category =
   Kinetic
   | Leather
   | Chain
   | Plate

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
finish_decoding : PartiallyDecoded -> Type
finish_decoding add_armor =
   {
      id = add_armor.id,
      name = add_armor.nam,
      category =
         (
            case add_armor.ct of
               "k" -> Kinetic
               "c" -> Chain
               "p" -> Plate
               _   -> Leather
         ),
      coef = add_armor.cf
   }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> String -> Category -> Float -> Type
new id name category coef =
   {
      id = id,
      name = name,
      category = category,
      coef = coef
   }

get_id : Type -> Ref
get_id ar = ar.id

get_name : Type -> String
get_name ar = ar.name

get_category : Type -> String
get_category ar = ar.name

get_image_id : Type -> String
get_image_id ar = (toString ar.id)

get_resistance_to : Struct.Weapon.DamageType -> Type -> Int
get_resistance_to dmg_type ar =
   (ceiling
      (
         ar.coef
         *
         (
            case (dmg_type, ar.category) of
               (Struct.Weapon.Slash, Kinetic) -> 0.0
               (Struct.Weapon.Slash, Leather) -> 5.0
               (Struct.Weapon.Slash, Chain) -> 10.0
               (Struct.Weapon.Slash, Plate) -> 10.0
               (Struct.Weapon.Blunt, Kinetic) -> 10.0
               (Struct.Weapon.Blunt, Leather) -> 5.0
               (Struct.Weapon.Blunt, Chain) -> 5.0
               (Struct.Weapon.Blunt, Plate) -> 5.0
               (Struct.Weapon.Pierce, Kinetic) -> 5.0
               (Struct.Weapon.Pierce, Leather) -> 5.0
               (Struct.Weapon.Pierce, Chain) -> 5.0
               (Struct.Weapon.Pierce, Plate) -> 10.0
         )
      )
   )

apply_to_attributes : Type -> Struct.Attributes.Type -> Struct.Attributes.Type
apply_to_attributes ar atts =
   let
      impact = (ceiling (-20.0 * ar.coef))
      half_impact = (ceiling (-10.0 * ar.coef))
   in
      case ar.category of
         Kinetic -> (Struct.Attributes.mod_mind impact atts)
         Leather ->
            (Struct.Attributes.mod_constitution
               half_impact
               (Struct.Attributes.mod_dexterity
                  half_impact
                  atts
               )
            )

         Chain ->
            (Struct.Attributes.mod_constitution
               half_impact
               (Struct.Attributes.mod_dexterity
                  half_impact
                  (Struct.Attributes.mod_speed impact atts)
               )
            )

         Plate ->
            (Struct.Attributes.mod_constitution
               half_impact
               (Struct.Attributes.mod_dexterity
                  half_impact
                  (Struct.Attributes.mod_speed
                     impact
                     (Struct.Attributes.mod_strength impact atts)
                  )
               )
            )

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map
      (finish_decoding)
      (Json.Decode.Pipeline.decode
         PartiallyDecoded
         |> (Json.Decode.Pipeline.required "id" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "ct" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "cf" Json.Decode.float)
      )
   )

none : Type
none =
   (new
      0
      "None"
      Leather
      0.0
   )
