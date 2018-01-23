module Struct.Attributes exposing
   (
      Type,
      get_constitution,
      get_dexterity,
      get_intelligence,
      get_mind,
      get_speed,
      get_strength,
      new
   )

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
