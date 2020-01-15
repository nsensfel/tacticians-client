module Struct.UI exposing
   (
      Type,
      Tab(..),
      default,
      -- Tab
      maybe_get_displayed_tab,
      set_displayed_tab,
      reset_displayed_tab,
      to_string,
      tab_from_string,
      get_all_tabs
   )

-- Map -------------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Tab =
   SignInTab
   | SignUpTab
   | SignedInTab
   | SignedOutTab
   | RecoveryTab

type alias Type =
   {
      displayed_tab : (Maybe Tab)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
default : Type
default =
   {
      displayed_tab = Nothing
   }

-- Tab -------------------------------------------------------------------------
maybe_get_displayed_tab : Type -> (Maybe Tab)
maybe_get_displayed_tab ui = ui.displayed_tab

set_displayed_tab : Tab -> Type -> Type
set_displayed_tab tab ui = {ui | displayed_tab = (Just tab)}

reset_displayed_tab : Type -> Type
reset_displayed_tab ui = {ui | displayed_tab = Nothing}

to_string : Tab -> String
to_string tab =
   case tab of
      SignInTab -> "Sign In"
      SignUpTab -> "Create Account"
      SignedInTab -> "Signed In"
      SignedOutTab -> "Signed Out"
      RecoveryTab -> "Account Recovery"

tab_from_string : String -> Tab
tab_from_string str =
   case str of
      "signin" -> SignInTab
      "signup" -> SignUpTab
      "recover" -> RecoveryTab
      _ -> SignInTab

get_all_tabs : (List Tab)
get_all_tabs =
   [SignInTab, SignUpTab, RecoveryTab]
