module Shim.Model exposing (generate)

-- Elm -------------------------------------------------------------------------
import Dict

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
--generate : Struct.Model.Type
generate =
   {
      state = Struct.Model.Default,
      error = Nothing,
      battlemap = (Struct.Battlemap.empty),
      controlled_team = 0,
      controlled_character = Nothing,
      player_id = "0",
      targets = [],
      characters = (Dict.empty),
      ui = (Struct.UI.default)
   }
