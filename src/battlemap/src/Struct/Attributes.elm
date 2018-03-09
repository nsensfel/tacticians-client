module Struct.Attributes exposing
   (
      Type,
      get_constitution,
      get_dexterity,
      get_intelligence,
      get_mind,
      get_speed,
      get_strength,
      mod_constitution,
      mod_dexterity,
      mod_intelligence,
      mod_mind,
      mod_speed,
      mod_strength,
      new,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      constitution : Int,
      dexterity : Int,
      intelligence : Int,
      mind : Int,
      speed : Int,
      strength : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_within_range : Int -> Int -> Int -> Int
get_within_range vmin vmax v = (min vmax (max vmin v))

get_within_att_range : Int -> Int
get_within_att_range v = (get_within_range 0 100 v)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_constitution : Type -> Int
get_constitution t = t.constitution

get_dexterity : Type -> Int
get_dexterity t = t.dexterity

get_intelligence : Type -> Int
get_intelligence t = t.intelligence

get_mind : Type -> Int
get_mind t = t.mind

get_speed : Type -> Int
get_speed t = t.speed

get_strength : Type -> Int
get_strength t = t.strength

mod_constitution : Int -> Type -> Type
mod_constitution i t =
   {t |
      constitution = (get_within_att_range (i + t.constitution))
   }

mod_dexterity : Int -> Type -> Type
mod_dexterity i t =
   {t |
      dexterity = (get_within_att_range (i + t.dexterity))
   }

mod_intelligence : Int -> Type -> Type
mod_intelligence i t =
   {t |
      intelligence = (get_within_att_range (i + t.intelligence))
   }

mod_mind : Int -> Type -> Type
mod_mind i t =
   {t |
      mind = (get_within_att_range (i + t.mind))
   }

mod_speed : Int -> Type -> Type
mod_speed i t =
   {t |
      speed = (get_within_att_range (i + t.speed))
   }

mod_strength : Int -> Type -> Type
mod_strength i t =
   {t |
      strength = (get_within_att_range (i + t.strength))
   }

new : (
      Int -> -- constitution
      Int -> -- dexterity
      Int -> -- intelligence
      Int -> -- mind
      Int -> -- speed
      Int -> -- strength
      Type
   )
new con dex int min spe str =
   {
      constitution = con,
      dexterity = dex,
      intelligence = int,
      mind = min,
      speed = spe,
      strength = str
   }

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "con" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "dex" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "int" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "min" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "spe" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "str" Json.Decode.int)
   )
