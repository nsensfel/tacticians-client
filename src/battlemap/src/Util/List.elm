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
