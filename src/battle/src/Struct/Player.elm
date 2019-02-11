module Struct.Player exposing
   (
      Type,
      Ref,
      get_id,
      get_index,
      get_incarnation_index,
      get_luck,
      set_luck,
      decoder,
      none
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Battle ----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Ref = Int

type alias Type =
   {
      id : String,
      ix : Int,
      incarnation_ix : Int,
      luck : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_id : Type -> String
get_id pl = pl.id

get_index : Type -> Int
get_index pl = pl.ix

get_incarnation_index : Type -> Int
get_incarnation_index pl = pl.incarnation_ix

get_luck : Type -> Int
get_luck pl = pl.luck

set_luck : Int -> Type -> Type
set_luck luck pl = {pl | luck = luck}

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "iix" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "luk" Json.Decode.int)
   )

none : Type
none =
   {
      id = "",
      ix = -1,
      incarnation_ix = -1,
      luck = 0
   }
