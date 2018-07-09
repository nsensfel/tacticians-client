/******************************************************************************/
/** Session Management ********************************************************/
/******************************************************************************/

/***
 * This module uses local storage to keep users logged in across pages, and
 * through further visits.
 **/

var tacticians_online = tacticians_online || new Object();

tacticians_online.session = new Object();

tacticians_online.session.private = new Object();
tacticians_online.session.private.user_id = "";
tacticians_online.session.private.token = "";

tacticians_online.session.store =
function ()
{
   localStorage.setItem("user_id", tacticians_online.session.private.user_id);
   localStorage.setItem("token", tacticians_online.session.private.token);
}

tacticians_online.session.reset =
function ()
{
   localStorage.removeItem("user_id");
   localStorage.removeItem("token");
}

tacticians_online.session.load =
function ()
{
   tacticians_online.session.private.user_id = localStorage.getItem("user_id");
   tacticians_online.session.private.token = localStorage.getItem("token");

   if (tacticians_online.session.private.user_id == null)
   {
      tacticians_online.session.private.user_id = "";
   }

   if (tacticians_online.session.private.token == null)
   {
      tacticians_online.session.private.token = "";
   }
}

tacticians_online.session.get_user_id =
function ()
{
   return tacticians_online.session.private.user_id;
}

tacticians_online.session.get_token =
function ()
{
   return tacticians_online.session.private.token;
}

tacticians_online.session.set_user_id =
function (user_id)
{
   tacticians_online.session.private.user_id = user_id;
}

tacticians_online.session.set_token =
function (token)
{
   tacticians_online.session.private.token = token;
}

tacticians_online.session.store_new_session =
function (user_id, token)
{
   tacticians_online.session.set_user_id(user_id);
   tacticians_online.session.set_token(token);
   tacticians_online.session.store();
}

tacticians_online.session.attach_to =
function (app)
{
   app.ports.store_new_session.subscribe =
      tacticians_online.session.store_new_session;

   app.ports.reset_session.subscribe = tacticians_online.session.reset;
}
