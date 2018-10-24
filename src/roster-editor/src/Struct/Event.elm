module Struct.Event exposing (Type(..), attempted)

-- Elm -------------------------------------------------------------------------
import Http

-- Roster Editor ---------------------------------------------------------------
import Struct.Armor
import Struct.Error
import Struct.Glyph
import Struct.GlyphBoard
import Struct.HelpRequest
import Struct.Portrait
import Struct.ServerReply
import Struct.UI
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   None
   | CharacterSelected Int
   | Failed Struct.Error.Type
   | GoToMainMenu
   | RequestedHelp Struct.HelpRequest.Type
   | ServerReplied (Result Http.Error (List Struct.ServerReply.Type))
   | TabSelected Struct.UI.Tab

   | SelectedArmor Struct.Armor.Ref
   | SelectedGlyph (Struct.Glyph.Ref, Int)
   | SelectedGlyphBoard Struct.GlyphBoard.Ref
   | SelectedPortrait Struct.Portrait.Ref
   | SelectedWeapon Struct.Weapon.Ref

attempted : (Result.Result err val) -> Type
attempted act =
   case act of
      (Result.Ok _) -> None
      (Result.Err msg) ->
         (Failed (Struct.Error.new Struct.Error.Failure (toString msg)))
