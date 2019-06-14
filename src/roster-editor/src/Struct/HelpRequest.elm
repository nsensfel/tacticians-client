module Struct.HelpRequest exposing (Type(..))

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Statistics
import Battle.Struct.DamageType

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   None
   | Statistic Battle.Struct.Statistics.Category
   | DamageType Battle.Struct.DamageType.Type
