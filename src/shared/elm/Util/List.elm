module Util.List exposing (..)

import Set

import List

pop : List a -> (Maybe (a, List a))
pop l =
   case
      ((List.head l), (List.tail l))
   of
      (Nothing, _) -> Nothing
      (_ , Nothing) -> Nothing
      ((Just head), (Just tail)) -> (Just (head, tail))

get_first : (a -> Bool) -> (List a) -> (Maybe a)
get_first fun list =
   (List.head (List.filter fun list))

product_map : (a -> b -> c) -> (List a) -> (List b) -> (List c)
product_map product_fun list_a list_b =
   (product_map_rec (product_fun) list_a list_b [])

product_map_rec : (a -> b -> c) -> (List a) -> (List b) -> (List c) -> (List c)
product_map_rec product_fun list_a list_b result =
   case (pop list_a) of
      Nothing -> result
      (Just (head, tail)) ->
         (product_map_rec
            (product_fun)
            tail
            list_b
            (List.append
               (List.map (product_fun head) list_b)
               result
            )
         )

duplicates : (List comparable) -> (Set.Set comparable)
duplicates list =
   let
      (encountered, final_result) =
         (List.foldl
            (\elem (met, result) ->
               if (Set.member elem met)
               then (met, (Set.insert elem result))
               else ((Set.insert elem met), result)
            )
            ((Set.empty), (Set.empty))
            list
         )
   in
      final_result
