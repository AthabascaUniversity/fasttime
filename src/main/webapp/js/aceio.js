/**
 * Created by trenta on 23/01/14.
 */


var guid;

var workList = [
    {
        weekStart: new Date(),
        approvalStatus: '',
        approvalStatusName: '',
        project: '',
        projectName: '',
        taskId: '',
        taskName: '',
        timeSheetLineId: '',
        timeSheetPeriodId: '',
        work: {
            sun: '',
            mon: '',
            tue: '',
            wed: '',
            thu: '',
            fri: '',
            sat: '',
            total: ''
        }
    }
];

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
        guid = loginInfo.GUID;
        loadMyWeeks();
    }
    else
    {
        jQuery('#msg').replaceWith('' +
                '<div id="msg" class="errors" style="background-color: rgb(255, 238, 221);">' +
                page.results[0].ERRORDESCRIPTION +
                '</div>');
        jQuery('#login').show();
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

jQuery(document).ready(function ()
{
    jQuery(document).ajaxStop(function (event, XMLHttpRequest, ajaxOptions)
    {
        log('work list: %o', workList);
        if (workList.length > 0)
        {
            jQuery('#work').show();
        }

        for (i = 0; i < workList.length; i++)
        {
            workRow = '' +
                    '            <tr>' +
                    '            <td>' + workList[i].approvalStatusName +
                    '</td>' +
                    '            <td>' + workList[i].projectName + '</td>' +
                    '            <td>' + workList[i].taskName + '</td>';
            workRow += '<td>'
            workRow += workList[i].work.sun + '-';
            workRow += workList[i].work.mon + '-';
            workRow += workList[i].work.tue + '-';
            workRow += workList[i].work.wed + '-';
            workRow += workList[i].work.thu + '-';
            workRow += workList[i].work.fri + '-';
            workRow += workList[i].work.sat;
            workRow += '</td>';
            workRow += '            </tr>'
            jQuery('#time').append(workRow);
        }
    });
});

/**
 * Pass a url, and a test call is created, and the results logged.  guid is
 * automatically appended.  This allows playing around in the chrome developer
 * tools, or firebug.
 */
function testCall(queryUrl)
{
    jQuery.ajax({
      url: queryUrl,
      type: 'get',
      dataType: 'json',
      data: 'guid=' + guid,
      success: function (page, status, jqXHR)
      {
          log('test result: ', page);
      },
      error: function (page, status, jqXHR)
      {
        aceIOError(page, status, jqXHR);
      }
    });

}