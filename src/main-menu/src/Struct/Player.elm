module Struct.Player exposing
   (
      Type,
      get_id,
      get_username,
      get_maps,
      get_campaigns,
      get_invasions,
      get_events,
      get_roster_id,
      get_inventory_id,
      decoder,
      none
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode
import Json.Decode.Pipeline

-- Main Menu -------------------------------------------------------------------
import Struct.BattleSummary
import Struct.MapSummary

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : String,
      name : String,
      maps : (Array.Array Struct.MapSummary.Type),
      campaigns : (Array.Array Struct.BattleSummary.Type),
      invasions : (Array.Array Struct.BattleSummary.Type),
      events : (Array.Array Struct.BattleSummary.Type),
      roster_id : String,
      inventory_id : String
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_id : Type -> String
get_id t = t.id

get_username : Type -> String
get_username t = t.name

get_maps : Type -> (Array.Array Struct.MapSummary.Type)
get_maps t = t.maps

get_campaigns : Type -> (Array.Array Struct.BattleSummary.Type)
get_campaigns t = t.campaigns

get_invasions : Type -> (Array.Array Struct.BattleSummary.Type)
get_invasions t = t.invasions

get_events : Type -> (Array.Array Struct.BattleSummary.Type)
get_events t = t.events

get_roster_id : Type -> String
get_roster_id t = t.roster_id

get_inventory_id : Type -> String
get_inventory_id t = t.inventory_id

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nme" Json.Decode.string)
      |> (Json.Decode.Pipeline.required
            "maps"
            (Json.Decode.array Struct.MapSummary.decoder)
         )
      |> (Json.Decode.Pipeline.required
            "cmps"
            (Json.Decode.array Struct.BattleSummary.decoder)
         )
      |> (Json.Decode.Pipeline.required
            "invs"
            (Json.Decode.array Struct.BattleSummary.decoder)
         )
      |> (Json.Decode.Pipeline.required
            "evts"
            (Json.Decode.array Struct.BattleSummary.decoder)
         )
      |> (Json.Decode.Pipeline.required "rtid" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ivid" Json.Decode.string)
   )

none : Type
none =
   {
      id = "",
      name = "Unknown",
      maps = (Array.empty),
      campaigns = (Array.empty),
      invasions = (Array.empty),
      events = (Array.empty),
      roster_id = "",
      inventory_id = ""
   }
