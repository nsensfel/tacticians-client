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
import Update.Puppeteer.Focus
import Update.Puppeteer.Hit
import Update.Puppeteer.Move
import Update.Puppeteer.RefreshCharacter
import Update.Puppeteer.RefreshCharactersOf
import Update.Puppeteer.StartTurn
import Update.Puppeteer.SwapWeapons
import Update.Puppeteer.Target

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_effect_forward : (
      Struct.PuppeteerAction.Effect ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
apply_effect_forward effect model =
   case effect of
      (AnnounceLoss player_ix) ->
         (Update.PuppeteerAction.AnnounceLoss.forward player_ix model)

      (AnnounceVictory player_ix) ->
         (Update.PuppeteerAction.AnnounceVictory.forward player_ix model)

      (Focus character_ix) ->
         (Update.PuppeteerAction.Focus.forward character_ix model)

      (Hit attack) ->
         (Update.PuppeteerAction.Hit.forward attack model)

      (Move (character_ix, direction)) ->
         (Update.PuppeteerAction.Move.forward character_ix direction model)

      (RefreshCharacter (on_forward, character_ix)) ->
         (Update.PuppeteerAction.RefreshCharacter.forward
            on_forward
            character_ix
            model
         )

      (RefreshCharactersOf (on_forward, player_ix)) ->
         (Update.PuppeteerAction.RefreshCharactersOf.forward
            on_forward
            player_ix
            model
         )

      (StartTurn player_ix) ->
         (Update.PuppeteerAction.StartTurn.forward player_ix model)

      (SwapWeapons character_ix) ->
         (Update.PuppeteerAction.SwapWeapons.forward character_ix model)

      (Target (actor_ix, target_ix)) ->
         (Update.PuppeteerAction.Target.forward actor_ix target_ix model)

apply_effect_backward : (
      Struct.PuppeteerAction.Effect ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
apply_effect_backward effect model =
   case effect of
      (AnnounceLoss player_ix) ->
         (Update.PuppeteerAction.AnnounceLoss.backward player_ix model)

      (AnnounceVictory player_ix) ->
         (Update.PuppeteerAction.AnnounceVictory.backward player_ix model)

      (Focus character_ix) ->
         (Update.PuppeteerAction.Focus.backward character_ix model)

      (Hit attack) ->
         (Update.PuppeteerAction.Hit.backward attack model)

      (Move (character_ix, direction)) ->
         (Update.PuppeteerAction.Move.backward character_ix direction model)

      (RefreshCharacter (on_forward, character_ix)) ->
         (Update.PuppeteerAction.RefreshCharacter.backward
            on_backward
            character_ix
            model
         )

      (RefreshCharactersOf (on_forward, player_ix)) ->
         (Update.PuppeteerAction.RefreshCharactersOf.backward
            on_forward
            player_ix
            model
         )

      (StartTurn player_ix) ->
         (Update.PuppeteerAction.StartTurn.backward player_ix model)

      (SwapWeapons character_ix) ->
         (Update.PuppeteerAction.SwapWeapons.backward character_ix model)

      (Target (actor_ix, target_ix)) ->
         (Update.PuppeteerAction.Target.backward actor_ix target_ix model)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model =
   case (Struct.Puppeteer.try_getting_current_action model.puppeteer) of
      Nothing -> (model, (Cmd.none))
      (Just action) ->
         case action of
            (Perform effects) ->
               if (Struct.Puppeteer.get_is_playing_forward model.puppeteer)
               then
                  -- TODO: iterate over the effects
                  let updated_model = (forward effect model) in
                     (apply_to
                        {updated_model|
                           puppeteer =
                              (Struct.Puppeteer.forward
                                 updated_model.puppeteer
                              )
                        }
                     )
               else
                  -- TODO: iterate over the effects
                  let updated_model = (backward effect model) in
                     (apply_to
                        {updated_model|
                           puppeteer =
                              (Struct.Puppeteer.backward
                                 updated_model.puppeteer
                              )
                        }
                     )

            (PerformFor (time, effects)) ->
               (
                  (
                     if
                        (Struct.Puppeteer.get_is_playing_forward
                           model.puppeteer
                        )
                     then
                     -- TODO: iterate over the effects
                        let updated_model = (forward effect model) in
                           {updated_model|
                              puppeteer =
                                 (Struct.Puppeteer.forward
                                    updated_model.puppeteer
                                 )
                           }
                     else
                        -- TODO: iterate over the effects
                        let updated_model = (backward effect model) in
                           {updated_model|
                              puppeteer =
                                 (Struct.Puppeteer.backward
                                    updated_model.puppeteer
                                 )
                           }
                     ),
                     (Delay.after time Delay.Second Struct.Event.AnimationEnded)
               )
