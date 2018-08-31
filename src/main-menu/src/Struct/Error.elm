module Struct.Error exposing (Type, Mode(..), new, to_string)

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Mode =
   IllegalAction
   | Programming
   | Unimplemented
   | Networking
   | Failure

type alias Type =
   {
      mode: Mode,
      message: String
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Mode -> String -> Type
new mode str =
   {
      mode = mode,
      message = str
   }

to_string : Type -> String
to_string e =
   (
      (case e.mode of
         Failure -> "The action failed: "
         IllegalAction -> "Request discarded: "
         Programming -> "Error in the program (please report): "
         Unimplemented -> "Update discarded due to unimplemented feature: "
         Networking -> "Error while conversing with the server: "
      )
      ++ e.message
   )

