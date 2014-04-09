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
// CRITICAL    console.log.call(console, 'stack: %o', new Error().stack);
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

/**
 * Centers an element.  The element will
 * - always be to the right of or aligned to the left of #content
 * - always be below or aligned to the top of #content
 * - never exceed the width of #content
 * - never exceed the height of #content
 * @return {*}
 */
jQuery.fn.center = function ()
{
    this.css("position", "absolute");
    var topCoord = (jQuery(window).height() - this.height()) / 2 +
        jQuery(window).scrollTop();
    var leftCoord = (jQuery(window).width() - this.width()) / 2 +
        jQuery(window).scrollLeft();
    log("top: %s, left: %s, %o", topCoord, leftCoord, this);

    // make sure we're within the bounds of the content div.
    if (topCoord < jQuery('body').offset().top)
    {
        topCoord = jQuery('body').offset().top;
    }
    if (leftCoord < jQuery('body').offset().left)
    {
        leftCoord = jQuery('body').offset().left;
    }
    this.css("top", topCoord + "px");
    this.css("left", leftCoord + "px");

    var maxWidth = jQuery('body').width();
    var maxHeight = (jQuery(window).height() -
        jQuery('body').offset().top) / 2;
    this.adjustDimensions(maxWidth, maxHeight);

    return this;
};

/**
 * Adjust the maximum width and height of the element.
 *
 * @param maxWidth
 * @param maxHeight
 */
jQuery.fn.adjustDimensions = function (maxWidth, maxHeight)
{
    log(" maxWidth: " + maxWidth + ", maxHeight: " +
        maxHeight);
    if (jQuery(this).width() > maxWidth)
    {
        log('reducing popup width from ' + jQuery(this).width() +
            ' to ' + maxWidth);
        jQuery(this).width(maxWidth);
    }
    if (jQuery(this).height() > maxHeight)
    {
        log('reducing popup height from ' +
            jQuery(this).height() +
            ' to ' + maxHeight);
        jQuery(this).height(maxHeight);
    }

    return this;
};

jQuery(document).ready(function ()
    {
        loadingDiv = jQuery("div#loading");
        loadingDiv.hide();
        log('setup loading spinner');
        jQuery(document).ajaxStart(function ()
        {
            log('begin ajaxStart ' + new Date().getTime());
            loadingDiv.center();
            /*            jQuery(this).fadeIn('slow', function () {
             orosLog('oros - fadein complete ' + new Date().getTime());
             });*/
            loadingDiv.show();
            jQuery('#msg').hide();
            log('end ajaxStart ' + new Date().getTime());
        });
        jQuery(document).ajaxStop(function ()
        {
            log('begin ajaxStop ' + new Date().getTime());
            loadingDiv.hide();
            loadingDiv.stop();
            log('end ajaxStop ' + new Date().getTime());
        });
    }
);