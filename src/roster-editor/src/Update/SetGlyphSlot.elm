module Update.SetGlyphSlot exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Glyph
import BattleCharacters.Struct.GlyphBoard
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI

import Update.SelectTab

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_glyph_board_slot_factor : (
      Int ->
      Struct.Character.Type ->
      Int
   )
get_glyph_board_slot_factor index char =
   case
      (Array.get
         index
         (Array.fromList
            (BattleCharacters.Struct.GlyphBoard.get_slots
               (BattleCharacters.Struct.Equipment.get_glyph_board
                  (BattleCharacters.Struct.Character.get_equipment
                     (Struct.Character.get_base_character char)
                  )
               )
            )
         )
      )
   of
      Nothing -> 0
      (Just factor) -> factor

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to index model =
   case model.edited_char of
      Nothing -> (model, Cmd.none)
      (Just char) ->
         (Update.SelectTab.apply_to
            {model|
               ui =
                  (Struct.UI.set_glyph_slot
                     (
                        index,
                        (get_glyph_board_slot_factor index char)
                     )
                     model.ui
                  )
            }
            Struct.UI.GlyphSelectionTab
         )
