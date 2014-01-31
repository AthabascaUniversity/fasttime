/**
 * Created by trenta on 23/01/14.
 */

var aceLoginInfoUrl;
var aceGetWeeksUrl;
var aceGetWorkItemsUrl;
var aceLoginUrl;
var aceGetProjects;
var guid;

function getRowUrl(newWorkItem)
{
    var workRowUrl = './work-row.jsp?' +
        'statusId=' +
        encodeURI(newWorkItem.approvalStatusId) +
        '&statusName=' +
        encodeURI(newWorkItem.approvalStatusName) +
        '&projectId=' +
        encodeURI(newWorkItem.projectId) +
        '&projectName=' +
        encodeURI(newWorkItem.projectName) +
        '&taskId=' +
        encodeURI(newWorkItem.taskId) +
        '&taskName=' +
        encodeURI(newWorkItem.taskName) +
        '&timeSheetLineId=' +
        encodeURI(newWorkItem.timeSheetLineId) +
        '&comment=' +
        encodeURI(newWorkItem.comment);

    workRowUrl += '&sun=' + newWorkItem.work.sun;
    workRowUrl += '&mon=' + newWorkItem.work.mon;
    workRowUrl += '&tue=' + newWorkItem.work.tue;
    workRowUrl += '&wed=' + newWorkItem.work.wed;
    workRowUrl += '&thu=' + newWorkItem.work.thu;
    workRowUrl += '&fri=' + newWorkItem.work.fri;
    workRowUrl += '&sat=' + newWorkItem.work.sat;

    return workRowUrl;
}

var projects = {0: {projectId: '', projectName: ''}};

var myWork = {
    /**
     * Loads the task items for each week.
     */
    loadWeeks: function loadMyWeeks()
    {
        jQuery.ajax({
            url: aceGetWeeksUrl,
            type: 'get',
            dataType: 'json',
            data: 'guid=' + guid,
            success: function (page, status, jqXHR)
            {
                log('my weeks: %o', page);
                myWork.list = [];
                myWork.load(page);
            },
            error: function (page, status, jqXHR)
            {
                aceIOError(page, status, jqXHR);
            }
        });
    },
    /**
     * Loads the in progress work list into workList global variable.
     */
    load: function (workWeek)
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
                            new Date(Date.parse(workItem.DATE_WEEK_START) +
                                new Date().getTimezoneOffset() * 60 * 1000);
                        log('date: %s', workWeekStart);
                        var newWorkItem = convertObject(workItem, {
                            'approvalStatusId': 'APPROVAL_STATUS',
                            'approvalStatusName': 'APPROVAL_STATUS_NAME',
                            'projectId': 'PROJECT_ID',
                            'projectName': 'PROJECT_NAME',
                            'taskId': 'TASK_ID',
                            'taskName': 'TASK_RESUME',
                            'timeSheetLineId': 'TIMESHEET_LINE_ID',
                            'timeSheetPeriodId': 'TIMESHEET_PERIOD_ID',
                            'comment': 'COMMENT'
                        });

                        newWorkItem['weekStart'] = workWeekStart;
                        newWorkItem['work'] = {
                                sun: workItem.TOTAL1,
                                mon: workItem.TOTAL2,
                                tue: workItem.TOTAL3,
                                wed: workItem.TOTAL4,
                                thu: workItem.TOTAL5,
                                fri: workItem.TOTAL6,
                                sat: workItem.TOTAL7,
                                total: workItem.TOTAL
                            }

                        if (0 != newWorkItem.timeSheetLineId)
                        { // only *real* time items, not the predicted ones.
                            myWork.list.push(newWorkItem);
                            jQuery.ajax(
                                {   // global ajaxSuccess handles append.
                                    url: getRowUrl(newWorkItem),
                                    appendElement: '#time'
                                });
                        }
                    }
                },
                error: function (page, status, jqXHR)
                {
                    aceIOError(page, status, jqXHR);
                }
            });
        }
    },
    ajaxStop: function ()
    {
        log('work list: %o', myWork.list);
        /* CRITICAL We could iterate through this list, to find a project and work
         * item that matches the time frame, and just add to it's hours for the
         * day of the week, as well as the comment. */
        if (0 < myWork.list.length)
        {
            jQuery('#work').show();
        }
    },
    list: [
        {
            weekStart: new Date(),
            weekEnd: new Date(),
            approvalStatusId: '',
            approvalStatusName: '',
            projectId: '',
            projectName: '',
            taskId: '',
            taskName: '',
            timeSheetLineId: '',
            timeSheetPeriodId: '',
            comment: '',
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
    ]
};

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
        log('Getting user info');
        loginInfo = page.results[0];
        jQuery('#identity').replaceWith('' +
            '<div id="identity">Welcome ' +
            loginInfo.FIRST_NAME + ' ' + loginInfo.LAST_NAME +
            '</div>');
        document.cookie =
            "fasttime=" + loginInfo.GUID + "; path=/fasttime";
        jQuery('#login').hide();
        guid = loginInfo.GUID;
        myWork.loadWeeks();
        jQuery.ajax({
            url: aceGetProjects,
            type: 'post',
            dataType: 'json',
            data: 'guid=' + guid,
            success: function (page, status, jqXHR)
            {
                log('projects: %o', page);
                projects = convertArrayOfObjects(page.results, {
                    projectId: 'PROJECT_ID',
                    projectName: 'PROJECT_NAME'
                }, 'projectId');
                log('projects: %o', projects);
            },
            error: function (page, status, jqXHR)
            {
                aceIOError(page, status, jqXHR);
            }
        });
    }
    else
    {
        log('Login error: %o, %o', page, status);
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
        myWork.ajaxStop();
    });

    jQuery(document).ajaxSuccess(function (event, XMLHttpRequest, ajaxOptions)
    {
        if (ajaxOptions.appendElement !== undefined)
        {
            /* Handle appending html response to an element */
            jQuery(ajaxOptions.appendElement).append(XMLHttpRequest.responseText);
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
                log('loading projects...');
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
                url: aceLoginUrl,
                type: 'post',
                dataType: 'json',
                data: formData,
                success: function (page, status, jqXHR)
                {
                    aceLogin(page, status, jqXHR);
                },
                error: function (page, status, jqXHR)
                {
                    aceIOError(page, status, jqXHR);
                }
            });
            event.preventDefault();
        });

    jQuery('#date').unbind('change.date').bind('change.date',
        function (event)
        {
            event.preventDefault();
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

/**
 * Converts one type of associative array to another with different keys.
 *
 * @param inObject the object to convert
 * @param mapping the mapping of keys to other keys.  The key is the destination
 * key, while the value associated with the key is the original key name.
 * @returns {} the resulting object
 */
function convertObject(inObject, mapping)
{
    var outObject = {};
    for (var key in mapping)
    {
//        log('mapping: %s = %s, %o', key, mapping[key], inObject[mapping[key]]);
        outObject[key] = inObject[mapping[key]];
    }

    log('mapped object: %o', outObject);
    return outObject;
}

/**
 * Converts an array of one type of associative arrays to another with
 * different keys.
 *
 * @param inArray the array containing objects to convert
 * @param mapping the mapping of keys to other keys.  The key is the destination
 * key, while the value associated with the key is the original key name.
 * @param keyMapping optional parameter specifying that the new array should
 * have keys equal to the value of this key in the final object.  If not defined,
 * store in a standard array.
 *
 * e.g. Convert array to standard array of associative arrays
 * convertArrayOfObjects([{blahId: 0, blah: 'blahValue'}], {'duh' : 'blah', 'id' : 'blahId'});
 *
 * e.g. Map the array to an array keyed on the id.
 * convertArrayOfObjects([{blahId: 0, blah: 'blahValue'}], {'duh' : 'blah', 'id' : 'blahId'}, 'id');
 *
 * @returns {} the resulting array object
 *
 * @returns {Array}
 */
function convertArrayOfObjects(inArray, mapping, keyMapping)
{
    var outArray;
    if (keyMapping === undefined)
    {   // convert as straight array.
        outArray = [];
        for (var i = 0; i < inArray.length; i++)
        {
            outArray[i] = convertObject(inArray[i], mapping);
        }
    }
    else
    {   // convert using the specified value of the object as the key
        // for the new array
        outArray = {};
        for (var i = 0; i < inArray.length; i++)
        {
            var newObject = convertObject(inArray[i], mapping);
            outArray[newObject[keyMapping]] = newObject;
        }
    }
    return outArray;
}