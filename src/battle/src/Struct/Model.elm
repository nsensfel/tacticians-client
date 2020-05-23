module Struct.Model exposing
   (
      Type,
      new,
      invalidate,
      clear
   )

-- Shared ----------------------------------------------------------------------
import Shared.Struct.Flags

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.DataSet

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSet

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.CharacterTurn
import Struct.Error
import Struct.MessageBoard
import Struct.Puppeteer
import Struct.TurnResult
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      flags : Shared.Struct.Flags.Type,
      puppeteer : Struct.Puppeteer.Type,
      ui : Struct.UI.Type,
      char_turn : Struct.CharacterTurn.Type,
      message_board : Struct.MessageBoard.Type,

      battle : Struct.Battle.Type,

      -- Data Sets -------------------------------------------------------------
      characters_data_set : BattleCharacters.Struct.DataSet.Type,
      map_data_set : BattleMap.Struct.DataSet.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Shared.Struct.Flags.Type -> Type
new flags =
   let
      model =
         {
            flags = flags,
            puppeteer = (Struct.Puppeteer.new),
            ui = (Struct.UI.default),
            char_turn = (Struct.CharacterTurn.new),
            message_board = (Struct.MessageBoard.new),

            characters_data_set = (BattleCharacters.Struct.DataSet.new),
            map_data_set = (BattleMap.Struct.DataSet.new),

            battle = (Struct.Battle.new)
         }
   in
      case (Shared.Struct.Flags.maybe_get_parameter "id" flags) of
         Nothing ->
            (invalidate
               (Struct.Error.new
                  Struct.Error.Failure
                  "Could not find battle id."
               )
               model
            )

         (Just id) ->
            {model |
               battle = (Struct.Battle.set_id id model.battle)
            }

clear : Type -> Type
clear model =
   {model |
      message_board = (Struct.MessageBoard.clear model.message_board),
      ui =
         (Struct.UI.reset_displayed_nav
            (Struct.UI.set_previous_action Nothing model.ui)
         ),
      char_turn = (Struct.CharacterTurn.new)
   }

invalidate : Struct.Error.Type -> Type -> Type
invalidate err model =
   {model |
      message_board =
         (Struct.MessageBoard.display
            (Struct.MessageBoard.Error err)
            model.message_board
         )
   }
