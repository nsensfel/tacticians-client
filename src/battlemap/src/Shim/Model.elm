module Shim.Model exposing (generate)

-- Elm -------------------------------------------------------------------------
import Dict

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.CharacterTurn
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
      battlemap = (Struct.Battlemap.empty),
      characters = (Dict.empty),
      error = Nothing,
      controlled_team = 0,
      player_id = "0",
      ui = (Struct.UI.default),
      char_turn = (Struct.CharacterTurn.new)
   }
