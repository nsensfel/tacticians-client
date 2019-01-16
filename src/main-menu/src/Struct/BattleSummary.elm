module Struct.BattleSummary exposing
   (
      Type,
      Category(..),
      Mode(..),
      get_id,
      get_name,
      get_mode,
      get_category,
      get_deadline,
      is_players_turn,
      is_pending,
      is_empty_slot,
      get_invasion_category,
      decoder,
      none
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Main Menu -------------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Category =
   Invasion
   | Event
   | Campaign

type Mode =
   Attack
   | Defend
   | Either

type alias Type =
   {
      ix : Int,
      id : String,
      name : String,
      mode : Mode,
      category : Category,
      deadline : String,
      is_players_turn : Bool,
      is_pending : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
mode_from_string : String -> Mode
mode_from_string str =
   case str of
      "a" -> Attack
      "d" -> Defend
      _ -> Either

category_from_string : String -> Category
category_from_string str =
   case str of
      "i" -> Invasion
      "e" -> Event
      _ -> Campaign



--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_id : Type -> String
get_id t = t.id

get_name : Type -> String
get_name t = t.name

get_mode : Type -> Mode
get_mode t = t.mode

get_category : Type -> Category
get_category t = t.category

get_deadline : Type -> String
get_deadline t = t.deadline

is_players_turn : Type -> Bool
is_players_turn t = t.is_players_turn

is_pending : Type -> Bool
is_pending t = t.is_pending

is_empty_slot : Type -> Bool
is_empty_slot t = (t.id == "")

get_invasion_category : Int -> Mode
get_invasion_category ix =
   if (ix < 3)
   then Attack
   else if (ix < 6)
   then Either
   else Defend

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nme" Json.Decode.string)
      |>
         (Json.Decode.Pipeline.required
            "mod"
            (Json.Decode.map mode_from_string (Json.Decode.string))
         )
      |>
         (Json.Decode.Pipeline.required
            "cat"
            (Json.Decode.map category_from_string (Json.Decode.string))
         )
      |> (Json.Decode.Pipeline.required "ldt" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ipt" Json.Decode.bool)
      |> (Json.Decode.Pipeline.required "ipd" Json.Decode.bool)
   )

none : Type
none =
   {
      ix = -1,
      id = "",
      name = "Unknown",
      mode = Either,
      category = Campaign,
      deadline = "Never",
      is_players_turn = False,
      is_pending = False
   }
