/**
 * Created by trenta on 23/01/14.
 */


/***
 * Uses account info returned through a query to either the ace login, or
 * getloginfo web service calls.  Hides the login, or prints an error.
 *
 * @param page jQuery page
 * @param status jQuery status
 * @param jqXHR jQuery jqXHR
 */
function aceLogin(page, status, jqXHR)
{
    log('success: %o', page);
    if ('ok' == page.status)
    {
        loginInfo = page.results[0];
        jQuery('#identity').replaceWith('' +
                '<div id="identity">Welcome ' +
                loginInfo.FIRST_NAME + ' ' + loginInfo.LAST_NAME +
                '</div>');
        document.cookie =
                "fasttime=" + loginInfo.GUID + "; path=/fasttime";
        jQuery('#login').hide();


    }
    else
    {
        jQuery('#msg').replaceWith('' +
                '<div id="msg" class="errors" style="background-color: rgb(255, 238, 221);">' +
                page.results[0].ERRORDESCRIPTION +
                '</div>');
    }
}

/**
 * Call this on your jQuery 'error' function.
 *
 * @param page jQuery page
 * @param status jQuery status
 * @param jqXHR jQuery jqXHR
 */
function aceIOError(page, status, jqXHR)
{
    log('error: %o, %o', page, jqXHR);
    jQuery('#login').show();
    jQuery('#msg').replaceWith('' +
            '<div id="msg" class="errors" style="background-color: rgb(255, 238, 221);">' +
            '<p>An error occurred communicating with ace project.  ' +
            'Please use ace project directly, and try again later.</p> ' +
            '</div>');
}