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
