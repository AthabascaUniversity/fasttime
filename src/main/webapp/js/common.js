/**
 * Created with IntelliJ IDEA.
 * User: trenta
 * Date: 23/01/14
 * Time: 7:18 PM
 * To change this template use File | Settings | File Templates.
 */


function log()
{
    if (!window.console) window.console = {};
    if (!window.console.log) window.console.log = function ()
    {
    };

    console.log.apply(console, arguments);
}


/***
 * w3c cookie code: http://www.w3schools.com/js/js_cookies.asp
 *
 * @param cname name of the cookie.
 *
 * @returns {string}
 */
function getCookie(cname)
{
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++)
    {
        var c = ca[i].trim();
        if (0 == c.indexOf(name)) return c.substring(name.length, c.length);
    }
    return "";
}