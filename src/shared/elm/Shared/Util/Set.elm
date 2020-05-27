module Shared.Util.Set exposing (..)

import Set

import List

toggle : comparable -> (Set.Set comparable) -> (Set.Set comparable)
toggle e set =
   if (Set.member e set)
   then (Set.remove e set)
   else (Set.insert e set)
