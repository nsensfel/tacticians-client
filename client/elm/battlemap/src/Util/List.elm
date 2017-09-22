module Util.List exposing (pop)

import List

pop : List a -> (Maybe (a, List a))
pop l =
   case
      ((List.head l), (List.tail l))
   of
      (Nothing, _) -> Nothing
      (_ , Nothing) -> Nothing
      ((Just head), (Just tail)) -> (Just (head, tail))
