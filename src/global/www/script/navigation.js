/******************************************************************************/
/** Navigation ****************************************************************/
/******************************************************************************/

/***
 * This module allows navigation to another page.
 **/

var tacticians_online = tacticians_online || new Object();

tacticians_online.navigation = new Object();

tacticians_online.navigation.go_to =
function (url)
{
   window.location.href = url;
}

tacticians_online.navigation.attach_to =
function (app)
{
   app.ports.go_to.subscribe(tacticians_online.navigation.go_to);
}
