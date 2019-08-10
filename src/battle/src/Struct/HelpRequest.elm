module Struct.HelpRequest exposing (Type(..))

-- Elm -------------------------------------------------------------------------

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes
import Battle.Struct.DamageType

-- Local Module ----------------------------------------------------------------
import Struct.Character

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   None
   | Rank Struct.Character.Rank
   | Attribute Battle.Struct.Attributes.Category
   | DamageType Battle.Struct.DamageType.Type
