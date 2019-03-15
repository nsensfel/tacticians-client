module Struct.Event exposing (Type(..), attempted)

-- Elm -------------------------------------------------------------------------
import Http

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Weapon

-- Local Module ----------------------------------------------------------------
import Struct.Error
import Struct.Glyph
import Struct.GlyphBoard
import Struct.HelpRequest
import Struct.ServerReply
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   None
   | CharacterSelected Int
   | ToggleCharacterBattleIndex Int
   | Failed Struct.Error.Type
   | GoToMainMenu
   | RequestedHelp Struct.HelpRequest.Type
   | ServerReplied (Result Http.Error (List Struct.ServerReply.Type))
   | TabSelected Struct.UI.Tab
   | ClickedOnGlyph Int
   | SaveRequest
   | GoRequest

   | SetCharacterName String

   | SelectedArmor BattleCharacters.Struct.Armor.Ref
   | SelectedGlyph Struct.Glyph.Ref
   | SelectedGlyphBoard Struct.GlyphBoard.Ref
   | SelectedPortrait BattleCharacters.Struct.Portrait.Ref
   | SelectedWeapon BattleCharacters.Struct.Weapon.Ref

   | SwitchWeapons

attempted : (Result.Result err val) -> Type
attempted act =
   case act of
      (Result.Ok _) -> None
      (Result.Err msg) ->
         (Failed
            (Struct.Error.new
               Struct.Error.Failure
               -- TODO: find a way to get some relevant text here.
               "(text representation not implemented)"
            )
         )
