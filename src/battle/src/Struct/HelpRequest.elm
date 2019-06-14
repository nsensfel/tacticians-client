module Struct.HelpRequest exposing (Type(..))

-- Elm -------------------------------------------------------------------------

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Statistics
import Battle.Struct.DamageType

-- Local Module ----------------------------------------------------------------
import Struct.Character

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   None
   | Rank Struct.Character.Rank
   | Statistic Battle.Struct.Statistics.Category
   | DamageType Battle.Struct.DamageType.Type
