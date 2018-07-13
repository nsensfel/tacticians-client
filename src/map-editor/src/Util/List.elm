module Util.List exposing (..)

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

