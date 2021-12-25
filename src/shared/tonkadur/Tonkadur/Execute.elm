module Tonkadur.Execute exposing (execute)

-- Elm -------------------------------------------------------------------------
import List

-- Tonkadur --------------------------------------------------------------------
import Tonkadur.Types

import Tonkadur.Compute

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
---- UPDATE MEMORY -------------------------------------------------------------
apply_at_address : (
      (List.List String) ->
      (
         String ->
         (Dict.Dict String Value) ->
         (Dict.Dict String Value)
      )
      (Dict.Dict String Value) ->
      (Dict.Dict String Value)
   )
apply_at_address address fun memory =
   case address of
      [] -> memory
      (last_element :: []) -> (fun last_element memory)
      (next_element :: next_address) ->
         (Dict.update
            next_element
            (\maybe_value ->
               case maybe_value of
                  (Just value) ->
                     (Just
                        (apply_at_address
                           next_address
                           fun
                           (Tonkadur.Types.value_to_dict value)
                        )
                     )

                  Nothing -> Nothing
            )
         )

---- INSTRUCTIONS --------------------------------------------------------------
add_event_option : (
      String ->
      (List.List Tonkadur.Types.Computation) ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State ->
   )
add_event_option name parameters state =
   (Tonkadur.Types.append_option
      (Event name (List.map (Tonkadur.Compute.compute state) parameters))
      state
   )

add_text_option : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
   )
add_text_option label state =
   (Tonkadur.Types.append_option
      (Choice (Tonkadur.Compute.compute label state))
      state
   )

assert : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
   )
assert condition label state =
   if (Tonkadur.Types.value_to_bool (Tonkadur.Compute.compute state condition))
   then
      -- TODO: some special error report
      state
   else state

display : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
)
display label state =
   -- TODO: where do we put displayed values?
   state

end : Tonkadur.Types.State -> Tonkadur.Types.State
end state =
   -- TODO: what do we do with this?
   state

extra_instruction : (
      String ->
      (List.List Tonkadur.Types.Computation) ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
   )
extra_instruction name parameters state =
   -- No extra instruction supported.
   -- TODO: error report.

initialize : (
      String ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
   )
initialize type_name address state =
   {state |
      memory =
         (apply_at_address
            (Tonkadur.Types.value_to_list
               (Tonkadur.Compute.compute state address)
            )
            (\last_addr dict ->
               (Dict.insert
                  last_addr
                  (Tonkadur.Types.get_default state type_name)
                  dict
               )
            )
            state.memory
         )
   }

prompt_command : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
   )
prompt_command address min max label state =
   -- TODO: how to prompt for input?
   state

prompt_integer : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
   )
prompt_integer address min max label state =
   -- TODO: how to prompt for input?
   state

prompt_string : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
   )
prompt_integer address min max label state =
   -- TODO: how to prompt for input?
   state

remove : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
   )
remove address state =
   {state |
      memory =
         (apply_at_address
            (Tonkadur.Types.value_to_list
               (Tonkadur.Compute.compute state address)
            )
            (\last_addr dict -> (Dict.remove last_addr dict))
            state.memory
         )
   }

resolve_choice : Tonkadur.Types.State -> Tonkadur.Types.State
resolve_choice state =
   -- TODO: how to prompt for input?
   state

set_pc : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
)
set_pc value state =
   {state |
      program_counter =
         (Tonkadur.Types.value_to_int
            (Tonkadur.Compute.compute state value)
         )
   }

set_random : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
)
set_random address min max state =
   let
      (value, next_random_seed) =
         (Random.step
            (Random.int
               (Tonkadur.Types.value_to_int
                  (Tonkadur.Compute.compute state min)
                  (Tonkadur.Compute.compute state max)
               )
            )
            state.random_seed
         )
   in
   {state |
      memory =
         (apply_at_address
            (Tonkadur.Types.value_to_list
               (Tonkadur.Compute.compute state address)
            )
            (\last_addr dict -> (Dict.insert last_addr (IntValue value) dict))
            state.memory
         ),

      random_seed = next_random_seed
   }

set : (
      Tonkadur.Types.Computation ->
      Tonkadur.Types.Computation ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State
)
set address value state =
   {state |
      memory =
         (apply_at_address
            (Tonkadur.Types.value_to_list
               (Tonkadur.Compute.compute state address)
            )
            (\last_addr dict ->
               (Dict.insert
                  last_addr
                  (Tonkadur.Compute.compute state value)
                  dict
               )
            )
            state.memory
         )
   }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
execute : (
      Tonkadur.Types.Instruction ->
      Tonkadur.Types.State ->
      Tonkadur.Types.State ->
   )
execute instruction state =
   case instruction of
      (AddEventOption name parameters) ->
         (add_event_option name parameters state)

      (AddTextOption label) ->
         (add_text_option name parameters state)

      (Assert condition label) ->
         (assert condition label state)

      (Display label) -> (display label state)
      End -> (end state)
      (ExtraInstruction name parameters) ->
         (extra_instruction name parameters state)

      (Initialize type_name address) -> (initialize type_name address state)
      (PromptCommand address min max label) ->
         (prompt_command address min max label state)

      (PromptInteger address min max label) ->
         (prompt_integer address min max label state)

      (PromptString address min max label) ->
         (prompt_string address min max label state)

      (Remove address) -> (remove address state)
      ResolveChoice -> (resolve_choice state)
      (SetPC value) -> (set_pc value state)
      (SetRandom address min max) -> (set_random address min max state)
      (Set address value) -> (set address value state)

