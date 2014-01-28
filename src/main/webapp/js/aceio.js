/**
 * Created by trenta on 23/01/14.
 */

var aceLoginInfoUrl;
var aceGetWeeksUrl;
var aceGetWorkItemsUrl;
var aceLoginUrl;
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
        /* CRITICAL We could iterate through this list, to find a project and work
         * item that matches the time frame, and just add to it's hours for the
         * day of the week, as well as the comment. */
        if (0 < workList.length)
        {
            jQuery('#work').show();
        }
    });

    // Check for existing login
    guid = getCookie("fasttime");
    log("Ace GUID: %s", guid);
    if (guid !== undefined && guid.length == 36)
    {
        jQuery.ajax({
            url: aceLoginInfoUrl,
            type: 'get',
            dataType: 'json',
            data: 'guid=' + guid,
            success: function (page, status, jqXHR)
            {
                aceLogin(page, status, jqXHR);
            },
            error: function (page, status, jqXHR)
            {
                aceIOError(page, status, jqXHR);
            }
        });
    }

    // Register login form button clicks for submitting the data through ajax.
    jQuery('#login-submit').unbind('click.login').bind('click.login',
            function (event)
            {
                log('submit clicked');
                jQuery('#msg').replaceWith('<div id="msg"></div>');
                var formData = jQuery("#fm1").serialize();
                log('Form Data: %s', formData);
                jQuery.ajax({
                    url: aceLogin,
                    type: 'post',
                    dataType: 'json',
                    data: formData,
                    success: function (page, status, jqXHR)
                    {
                        aceLogin(page, status, jqXHR);
                        location.reload();
                    },
                    error: function (page, status, jqXHR)
                    {
                        aceIOError(page, status, jqXHR);
                    }
                });
                event.preventDefault();
            });
});

/**
 * Loads the in progress work list into workList global variable.
 */
function loadMyWorkItems(workWeek)
{
    for (i = 0; i < workWeek.results.length; i++)
    {
        jQuery.ajax({
            url: aceGetWorkItemsUrl,
            type: 'get',
            dataType: 'json',
            data: 'guid=' + guid + '&timeperiodid=' +
                    workWeek.results[i].TIMESHEET_PERIOD_ID,
            workListGenerator: true,
            success: function (page, status, jqXHR)
            {
                for (i = 0; i < page.results.length; i++)
                {
                    var workItem = page.results[i];
                    log('work item %o', workItem);
                    workWeekStart =
                            new Date(+/\/Date\((\d*)\)\//.exec(workItem.DATE_WEEK_START)[1] +
                                    new Date().getTimezoneOffset() * 60 * 1000);
                    log('date: %s', workWeekStart);
                    var newWorkItem = {
                        weekStart: workWeekStart,
                        approvalStatus: workItem.APPROVAL_STATUS,
                        approvalStatusName: workItem.APPROVAL_STATUS_NAME,
                        project: workItem.PROJECT_ID,
                        projectName: workItem.PROJECT_NAME,
                        taskId: workItem.TASK_ID,
                        taskName: workItem.TASK_RESUME,
                        timeSheetLineId: workItem.TIMESHEET_LINE_ID,
                        timeSheetPeriodId: workItem.TIMESHEET_PERIOD_ID,
                        work: {
                            sun: workItem.TOTAL1,
                            mon: workItem.TOTAL2,
                            tue: workItem.TOTAL3,
                            wed: workItem.TOTAL4,
                            thu: workItem.TOTAL5,
                            fri: workItem.TOTAL6,
                            sat: workItem.TOTAL7,
                            total: workItem.TOTAL
                        }
                    };

                    if (0 != newWorkItem.timeSheetLineId)
                    { // only *real* time items, not the predicted ones.
                        workList.push(newWorkItem);
                        var workRow = '' +
                                '            <tr>' +
                                '            <td>' +
                                newWorkItem.approvalStatusName +
                                '</td>' +
                                '            <td>' + newWorkItem.projectName +
                                '</td>' +
                                '            <td>' + newWorkItem.taskName +
                                '</td>';
                        workRow += '<td>'
                        workRow += newWorkItem.work.sun + '-';
                        workRow += newWorkItem.work.mon + '-';
                        workRow += newWorkItem.work.tue + '-';
                        workRow += newWorkItem.work.wed + '-';
                        workRow += newWorkItem.work.thu + '-';
                        workRow += newWorkItem.work.fri + '-';
                        workRow += newWorkItem.work.sat;
                        workRow += '</td>';
                        workRow += '            </tr>'
                        jQuery('#time').append(workRow);
                    }
                }
            },
            error: function (page, status, jqXHR)
            {
                aceIOError(page, status, jqXHR);
            }
        });
    }
}

/**
 * Loads the task items for each week.
 */
function loadMyWeeks()
{
    jQuery.ajax({
        url: aceGetWeeksUrl,
        type: 'get',
        dataType: 'json',
        data: 'guid=' + guid,
        success: function (page, status, jqXHR)
        {
            log('my weeks: %o', page);
            workList = [];
            loadMyWorkItems(page);
        },
        error: function (page, status, jqXHR)
        {
            aceIOError(page, status, jqXHR);
        }
    });
}
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