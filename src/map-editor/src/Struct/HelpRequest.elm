module Struct.HelpRequest exposing (Type(..))

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes
import Battle.Struct.DamageType

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   None
   | Attribute Battle.Struct.Attributes.Category
   | DamageType Battle.Struct.DamageType.Type
