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
      maps : (List Struct.MapSummary.Type),
      campaigns : (List Struct.BattleSummary.Type),
      invasions : (List Struct.BattleSummary.Type),
      events : (List Struct.BattleSummary.Type),
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

get_maps : Type -> (List Struct.MapSummary.Type)
get_maps t = t.maps

get_campaigns : Type -> (List Struct.BattleSummary.Type)
get_campaigns t = t.campaigns

get_invasions : Type -> (List Struct.BattleSummary.Type)
get_invasions t = t.invasions

get_events : Type -> (List Struct.BattleSummary.Type)
get_events t = t.events

get_roster_id : Type -> String
get_roster_id t = t.roster_id

get_inventory_id : Type -> String
get_inventory_id t = t.inventory_id

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nme" Json.Decode.string)
      |> (Json.Decode.Pipeline.required
            "maps"
            (Json.Decode.list Struct.MapSummary.decoder)
         )
      |> (Json.Decode.Pipeline.required
            "cmps"
            (Json.Decode.list Struct.BattleSummary.decoder)
         )
      |> (Json.Decode.Pipeline.required
            "invs"
            (Json.Decode.list Struct.BattleSummary.decoder)
         )
      |> (Json.Decode.Pipeline.required
            "evts"
            (Json.Decode.list Struct.BattleSummary.decoder)
         )
      |> (Json.Decode.Pipeline.required "rtid" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ivid" Json.Decode.string)
   )

none : Type
none =
   {
      id = "",
      name = "Unknown",
      maps = [],
      campaigns = [],
      invasions = [],
      events = [],
      roster_id = "",
      inventory_id = ""
   }
