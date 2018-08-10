<!DOCTYPE html>
<html>
   <head>
      <title>__CONF_SERVER_NAME - Landing Page</title>
      <meta charset="UTF-8">
      <meta name="description" content="Turn-based tactics browser MMO.">
      <meta name="keywords" content="MMO,TBT,TTB,turn based,browser game">
      <meta name="author" content="__CONF_AUTHOR_NAME">
      <link rel="icon" type="image/x-icon" href="favicon.ico">
      <link rel="stylesheet" type="text/css" href="/css/global.css">
      <link rel="stylesheet" type="text/css" href="/css/verbose.css">
   </head>
   <body>
      <header>
         <div class="main-server-logo">
            <a href="__CONF_SERVER_URL"><img src="__CONF_SERVER_LOGO"/></a>
         </div>
         <div class="main-server-version">__CONF_VERSION</div>
         <nav>
            <a href="/login/"><s>Play</s></a>
            <a href="/news/"><s>News</s></a>
            <a href="/community/"><s>Community</s></a>
            <a href="/about/"><s>About</s></a>
            <a href="/battle/?id=0">[D] Battle</a>
            <a href="/map-editor/?id=0">[D] Map Editor</a>
         </nav>
      </header>
      <main>
         <article>
            <header>What is __CONF_SERVER_NAME?</header>
            <p>
               __CONF_SERVER_NAME is a turn-based strategy game. It is free and
               open source (under the Apache 2.0 License): you can download the
               code for this website
               <a href="https://noot-noot.org/cgit.cgi/tacticians-client/"
               >here</a>
               and the code for the server-side content
               <a href="https://noot-noot.org/cgit.cgi/tacticians-server/"
               >here</a>.
            </p>
         </article>
         <article>
            <header>(Ridiculously) Early Access Warning</header>
            <p>
               __CONF_SERVER_NAME is still in its infancy: most features are
               missing, and the available ones are incomplete. For now, this
               website is intented as a way to assess the current state of the
               project, but not as a way to actually play the game. Indeed,
               users should expect frequent resets without warnings, as the
               underlying data structures may require changes and translation of
               the existing data is not deemed worthwhile.
            </p>
         </article>
         <article>
            <header>Game Modes</header>
            <p>
               __CONF_SERVER_NAME is intended to have both solo and multiplayer
               modes. Players can group up (or go alone) to face the
               story campaigns. Competitive matches are also available, with
               players invading or defending customized maps.
            </p>
            <h1>Player Progress</h1>
            <p>
               As they progress through the game, players unlock character
               customization items, equipment, achievements, additional
               campaigns, and resources to build their own maps.
            </p>
            <p>
               Map building resources are the only items that can be acquired
               multiple times, since they have to be spent. All of the other
               items can be used as many times as the player wants, once they
               are unlocked. There is no trading between players.
            </p>
            <h1>Battle Duration</h1>
            <p>
               The game is played asynchronously, in a concept similar to
               Play-By-Mail games: players are notified when it is their time
               to play, and have no need to be connected otherwise.
               Consequently, battles in __CONF_SERVER_NAME can be played in
               sequences of very small sessions. The downside being that, since
               the other players may not be readily available, games are likely
               to last a very long time. To address this issue, the players
               will be able to set time limits for turns (with a minimum of
               25h), and multiple games can be played simultaneously.
            </p>
            <h1>Co-Operative Campaigns</h1>
            <p>
               Because of the time spent on each battle, having players grind
               on low difficulty battles with low chances of reward would
               prove to be very boring. Instead, campaigns are intended to
               be challenging, without randomness factor for their rewards.
               Campaigns will be structured as trees, with branches available
               depending on either player choice or consequences of previous
               battles (character death, secret uncovered, etc).
            </p>
            <p>
               Players characters are chosen at the start of a campaign. This
               selection cannot be changed while the campaign is in progress
               (although playing the same campaign simultaneously with a
               different selection is possible). Furthermore, any outside
               changes made to the characters have no impact on ongoing
               campaigns. Additionally, the characters are not healed or
               restored between battles, unless the scenario explicitly features
               a restoration event.
            </p>
            <p>
               Upon reaching victory in a battle, the player is offered two
               choices: either carry on to one of the next available campaign
               events, or revert the effects of the battle and attempt it once
               again in hopes of a better result. Upon defeat, the latter is
               automatically selected.
            </p>
            <h1>Players VS Players</h1>
            <p>
               As part of the early campaigns, players are given lands.
               Players are able to customize those lands by spending resources,
               which are earned either by defending their own land, or by
               invading other players'. This resource can also be used as an
               alternative way to earn some campaign rewards. Players may
               group together to build, defend, and invade larger maps. The
               number of groups a player can belong to is not limited, but, for
               obvious reasons, they are not allowed to participate in both the
               defense and the invasion sides of the same battle.
            </p>
            <p>
               Players versus players battles are subject to random events.
               For example, non-player characters may intrude on an ongoing
               battle.
            </p>
         </article>
         <article>
            <header>Business Model</header>
            <p>
               __CONF_SERVER_NAME has an open business policy, meaning that
               information on all incomes and purchases are publicly available.
            </p>
            <h1>Advantages Acquired by Paying</h1>
            <p>
               In __CONF_SERVER_NAME, the only purchasable digital goods are
               the cosmetics sold by artists. Cosmetic items do not provide
               anything other than visual boons.
            </p>
            <h1>Money Income: Sell of Cosmetics</h1>
            <p>
               The main source of income planned for __CONF_SERVER_NAME is the
               sell of cosmetics from artists in the community. Those cosmetics
               would have to be validated before being put into place, with a
               first pre-selection done by the community itself, and a final
               approval made by us.
            </p>
            <p>
               Artist remuneration is intended to go as follows: the money
               spent by the player goes through the usual taxes (government,
               payment platform share, etc), then the artist receives 75% of
               the remaining amount, and __CONF_SERVER_NAME gets the rest. The
               listed price of the item is chosen by the artist and validated by
               us.
            </p>
            <p>
               Plans include the introduction of a 15 days delay between
               purchase and the distribution of money between __CONF_SERVER_NAME
               and the artist, in an attempt at making refunds less complicated.
               How the taxes are handled in such case is still to be determined.
            </p>
            <p>
               Ownership of sold items is still to the artists, meaning that
               they do not have to use a license as permissive as
               __CONF_SERVER_NAME's for their art. As a result, those items are
               not part of __CONF_SERVER_NAME's source code, and forks of the
               project should deal with the artist directly.
            </p>
         </article>
      </main>
   </body>
</html>
