module Update.Puppeteer exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Delay

-- Local module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.Puppeteer
import Struct.PuppeteerAction

import Update.Puppeteer.AnnounceLoss
import Update.Puppeteer.AnnounceVictory
import Update.Puppeteer.DisplayCharacterNavigator
import Update.Puppeteer.DisplayMessage
import Update.Puppeteer.Focus
import Update.Puppeteer.Move
import Update.Puppeteer.RefreshCharacter
import Update.Puppeteer.RefreshCharactersOf
import Update.Puppeteer.StartTurn
import Update.Puppeteer.SwapWeapons
import Update.Puppeteer.Target
import Update.Puppeteer.ToggleCharacterEffect

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Struct.PuppeteerAction.Effect ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward effect model =
   case effect of
      (Struct.PuppeteerAction.AnnounceLoss player_ix) ->
         (Update.Puppeteer.AnnounceLoss.forward player_ix model)

      (Struct.PuppeteerAction.AnnounceVictory player_ix) ->
         (Update.Puppeteer.AnnounceVictory.forward player_ix model)

      (Struct.PuppeteerAction.Focus character_ix) ->
         (Update.Puppeteer.Focus.forward character_ix model)

      (Struct.PuppeteerAction.ToggleCharacterEffect (character_ix, deffect)) ->
         (Update.Puppeteer.ToggleCharacterEffect.forward
            character_ix
            deffect
            model
         )

      (Struct.PuppeteerAction.DisplayMessage message) ->
         (Update.Puppeteer.DisplayMessage.forward message model)

      (Struct.PuppeteerAction.ClearMessage message) ->
         (Update.Puppeteer.DisplayMessage.backward message model)

      (Struct.PuppeteerAction.Move (character_ix, direction)) ->
         (Update.Puppeteer.Move.forward character_ix direction model)

      (Struct.PuppeteerAction.RefreshCharacter (on_forward, character_ix)) ->
         (Update.Puppeteer.RefreshCharacter.forward
            on_forward
            character_ix
            model
         )

      (Struct.PuppeteerAction.RefreshCharactersOf (on_forward, player_ix)) ->
         (Update.Puppeteer.RefreshCharactersOf.forward
            on_forward
            player_ix
            model
         )

      (Struct.PuppeteerAction.DisplayCharacterNavigator character_ix) ->
         (Update.Puppeteer.DisplayCharacterNavigator.forward
            character_ix
            model
         )

      (Struct.PuppeteerAction.ClearCharacterNavigator character_ix) ->
         (Update.Puppeteer.DisplayCharacterNavigator.backward
            character_ix
            model
         )

      (Struct.PuppeteerAction.StartTurn player_ix) ->
         (Update.Puppeteer.StartTurn.forward player_ix model)

      (Struct.PuppeteerAction.SwapWeapons character_ix) ->
         (Update.Puppeteer.SwapWeapons.forward character_ix model)

      (Struct.PuppeteerAction.Target (actor_ix, target_ix)) ->
         (Update.Puppeteer.Target.forward actor_ix target_ix model)

backward : (
      Struct.PuppeteerAction.Effect ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward effect model =
   case effect of
      (Struct.PuppeteerAction.AnnounceLoss player_ix) ->
         (Update.Puppeteer.AnnounceLoss.backward player_ix model)

      (Struct.PuppeteerAction.AnnounceVictory player_ix) ->
         (Update.Puppeteer.AnnounceVictory.backward player_ix model)

      (Struct.PuppeteerAction.Focus character_ix) ->
         (Update.Puppeteer.Focus.backward character_ix model)

      (Struct.PuppeteerAction.DisplayMessage message) ->
         (Update.Puppeteer.DisplayMessage.backward message model)

      (Struct.PuppeteerAction.ClearMessage message) ->
         (Update.Puppeteer.DisplayMessage.forward message model)

      (Struct.PuppeteerAction.ToggleCharacterEffect (character_ix, deffect)) ->
         (Update.Puppeteer.ToggleCharacterEffect.backward
            character_ix
            deffect
            model
         )

      (Struct.PuppeteerAction.DisplayCharacterNavigator character_ix) ->
         (Update.Puppeteer.DisplayCharacterNavigator.backward
            character_ix
            model
         )

      (Struct.PuppeteerAction.ClearCharacterNavigator character_ix) ->
         (Update.Puppeteer.DisplayCharacterNavigator.forward
            character_ix
            model
         )

      (Struct.PuppeteerAction.Move (character_ix, direction)) ->
         (Update.Puppeteer.Move.backward character_ix direction model)

      (Struct.PuppeteerAction.RefreshCharacter (on_forward, character_ix)) ->
         (Update.Puppeteer.RefreshCharacter.backward
            on_forward
            character_ix
            model
         )

      (Struct.PuppeteerAction.RefreshCharactersOf (on_forward, player_ix)) ->
         (Update.Puppeteer.RefreshCharactersOf.backward
            on_forward
            player_ix
            model
         )

      (Struct.PuppeteerAction.StartTurn player_ix) ->
         (Update.Puppeteer.StartTurn.backward player_ix model)

      (Struct.PuppeteerAction.SwapWeapons character_ix) ->
         (Update.Puppeteer.SwapWeapons.backward character_ix model)

      (Struct.PuppeteerAction.Target (actor_ix, target_ix)) ->
         (Update.Puppeteer.Target.backward actor_ix target_ix model)

apply_effects_forward : (
      (List Struct.PuppeteerAction.Effect) ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
apply_effects_forward effects model =
   let
      (last_model, cmd_list) =
         (List.foldl
            (\effect (current_model, current_cmds) ->
               let
                  (updated_model, new_commands) = (forward effect current_model)
               in
                  (
                     updated_model,
                     (new_commands ++ current_cmds)
                  )
            )
            (model, [])
            effects
         )
   in
      (
         {last_model |
            puppeteer = (Struct.Puppeteer.forward last_model.puppeteer)
         },
         cmd_list
      )

apply_effects_backward : (
      (List Struct.PuppeteerAction.Effect) ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
apply_effects_backward effects model =
   let
      (last_model, cmd_list) =
         (List.foldr
            (\effect (current_model, current_cmds) ->
               let
                  (updated_model, new_commands) =
                     (backward effect current_model)
               in
                  (
                     updated_model,
                     (current_cmds ++ new_commands)
                  )
            )
            (model, [])
            effects
         )
   in
      (
         {last_model |
            puppeteer = (Struct.Puppeteer.backward last_model.puppeteer)
         },
         cmd_list
      )

apply_to_rec : (
      Struct.Model.Type ->
      (List (Cmd Struct.Event.Type)) ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to_rec model cmds =
   case (Struct.Puppeteer.maybe_get_current_action model.puppeteer) of
      Nothing -> (model, (Cmd.batch cmds))
      (Just action) ->
         case action of
            (Struct.PuppeteerAction.Perform effects) ->
               let
                  (new_model, new_cmds) =
                     (
                        if
                           (Struct.Puppeteer.get_is_playing_forward
                              model.puppeteer
                           )
                        then (apply_effects_forward effects model)
                        else (apply_effects_backward effects model)
                     )
               in
                  (apply_to_rec new_model (new_cmds ++ cmds))

            (Struct.PuppeteerAction.PerformFor (time, effects)) ->
               let
                  (new_model, new_cmds) =
                     (
                        if
                           (Struct.Puppeteer.get_is_playing_forward
                              model.puppeteer
                           )
                        then (apply_effects_forward effects model)
                        else (apply_effects_backward effects model)
                     )
               in
                  if (Struct.Puppeteer.get_is_ignoring_time new_model.puppeteer)
                  then (apply_to_rec new_model (new_cmds ++ cmds))
                  else
                     (
                        new_model,
                        (Cmd.batch
                           (
                              (Delay.after
                                 time
                                 Delay.Second
                                 Struct.Event.AnimationEnded
                              )
                              :: (new_cmds ++ cmds)
                           )
                        )
                     )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   if (Struct.Puppeteer.get_is_paused model.puppeteer)
   then (model, Cmd.none)
   else (apply_to_rec model [])
