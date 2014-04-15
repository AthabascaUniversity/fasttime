/**
 * Created by trenta on 23/01/14.
 */

var aceLoginInfoUrl;
var aceGetMyWeeksUrl;
var aceGetWeeksUrl;
var aceCreateWeekUrl;
var aceSaveWorkItemUrl;
var aceGetWorkItemsUrl;
var aceLoginUrl;
var aceGetProjectsUrl;
var aceGetTaskssUrl;

var guid;

var workItemCount = 0;

function getRowParams(newWorkItem)
{
    var workRowUrl =
        'statusId=' +
            encodeURI(newWorkItem.approvalStatusId) +
            '&statusName=' +
            encodeURI(newWorkItem.approvalStatusName) +
            '&weekStart=' +
            newWorkItem.weekStart.getTime() +
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
            encodeURI(newWorkItem.comment) +
            '&total=' +
            encodeURI(newWorkItem.work.total);

    workRowUrl += '&sun=' + newWorkItem.work.sun;
    workRowUrl += '&mon=' + newWorkItem.work.mon;
    workRowUrl += '&tue=' + newWorkItem.work.tue;
    workRowUrl += '&wed=' + newWorkItem.work.wed;
    workRowUrl += '&thu=' + newWorkItem.work.thu;
    workRowUrl += '&fri=' + newWorkItem.work.fri;
    workRowUrl += '&sat=' + newWorkItem.work.sat;

    return workRowUrl;
}

var projects = {
    list: {0: {projectId: '', projectName: ''}},
    /**
     * Gets the available projects from the Ace Project API
     */
    getProjects: function ()
    {
        log('loading projects...');
        jQuery.ajax({
            url: aceGetProjectsUrl,
            data: 'guid=' + guid + '&FilterCompletedProject=false',
            success: function (page, status, jqXHR)
            {
                log('projects: %o', page);
                projects.list = convertArrayOfObjects(page.results, {
                    projectId: 'PROJECT_ID',
                    projectName: 'PROJECT_NAME'
                }, 'projectId');
                log('projects: %o', projects.list);
                for (key in projects.list)
                {
                    projects.list[key].getTasks =
                        /*
                         * Gets the available tasks for each project
                         */
                        function (callBack)
                        {
                            if (this.tasks !== undefined)
                            {
                                callBack(this.tasks);
                            }
                            else
                            {
                                var newTasks;
                                var $this = this;
                                jQuery.ajax({
                                    url: aceGetTaskssUrl,
                                    data: 'guid=' + guid +
                                        '&projectId=' + $this.projectId +
                                        '&FilterTaskCompleted=false',
                                    success: function (page, status, jqXHR)
                                    {
                                        log('ace tasks response: %o', page);
                                        $this.tasks =
                                            convertArrayOfObjects(page.results,
                                                {
                                                    taskId: 'TASK_ID',
                                                    taskName: 'TASK_RESUME',
                                                    taskDescription: 'TASK_DESC_CREATOR'
                                                }, 'taskId');
                                        $this.tasks.loadCombo = function ()
                                        {
                                            projects.loadTaskCombo($this.tasks);
                                        };
                                        callBack($this.tasks);
                                    },
                                    error: function (jqXHR, textStatus,
                                        errorThrown)
                                    {
                                        aceIOError(jqXHR, textStatus,
                                            errorThrown);
                                    }
                                });
                            }
                        };

                }
                projects.loadCombo(projects.list);
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                aceIOError(jqXHR, textStatus, errorThrown);
            }
        });
    },
    /**
     * Loads the task combo box.
     * @param tasks
     */
    loadTaskCombo: function (tasks)
    {
        var taskParameters = tasksToParameters(tasks);
        jQuery('#tasks option').remove();
        jQuery.ajax({
            url: 'task-options.jsp',
            appendElement: '#tasks',
            data: 'guid=' + guid + taskParameters,
            success: function (page, status, jqXHR)
            {
                log('projects html: %o', page);
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                aceIOError(jqXHR, textStatus, errorThrown);
            }
        });
    },
    /**
     * Loads the project list combo box.
     */
    loadCombo: function ()
    {
        var projectParameters = projectsToParameters(projects.list);

        jQuery('#projects option').remove();
        jQuery.ajax({
            url: 'project-options.jsp',
            appendElement: '#projects',
            data: 'guid=' + guid + projectParameters,
            success: function (page, status, jqXHR)
            {
                log('projects html: %o', page);
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                aceIOError(jqXHR, textStatus, errorThrown);
            }
        });
    }
};

var myWork = {
    /**
     * Loads the task items for each week.
     */
    loadWeeks: function loadMyWeeks()
    {
        jQuery.ajax({
            url: aceGetMyWeeksUrl,
            data: 'guid=' + guid,
            success: function (page, status, jqXHR)
            {
                log('my weeks: %o', page);
                myWork.list = [];
                myWork.load(page);
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                aceIOError(jqXHR, textStatus, errorThrown);
            }
        });
    },
    /**
     * Loads the in progress work list into workList global variable.
     */
    load: function (workWeek)
    {
        // clear the time in the table before reloading it
//        jQuery('#time td').remove();
        var myAjaxCalls = [];
        for (i = 0; i < workWeek.results.length; i++)
        {
            myAjaxCalls.push(jQuery.ajax({
                url: aceGetWorkItemsUrl,
                data: 'guid=' + guid + '&timeperiodid=' +
                    workWeek.results[i].TIMESHEET_PERIOD_ID,
                workListGenerator: true,
                success: function (page, status, jqXHR)
                {
                    log('raw work items: %o', page);
                    for (var i = 0; i < page.results.length; i++)
                    {
                        var workItem = page.results[i];
                        var newWorkItem = convertObject(workItem, {
                            'approvalStatusId': 'APPROVAL_LEVEL',
                            'approvalStatusName': 'GLOBAL_APPROVAL_STATUS',
                            'projectId': 'PROJECT_ID',
                            'projectName': 'PROJECT_NAME',
                            'taskId': 'TASK_ID',
                            'taskName': 'TASK_RESUME',
                            'timeSheetLineId': 'TIMESHEET_LINE_ID',
                            'timeSheetPeriodId': 'TIMESHEET_PERIOD_ID',
                            'comment': 'COMMENT'
                        });


                        newWorkItem['weekStart'] =
                            convertMSDateToDate(workItem.DATE_WEEK_START);

                        newWorkItem['weekEnd'] =
                            convertMSDateToDate(workItem.DATE_WEEK_END);
                        newWorkItem['work'] = {
                            sun: workItem.TOTAL1,
                            mon: workItem.TOTAL2,
                            tue: workItem.TOTAL3,
                            wed: workItem.TOTAL4,
                            thu: workItem.TOTAL5,
                            fri: workItem.TOTAL6,
                            sat: workItem.TOTAL7,
                            total: workItem.TOTAL
                        };

                        if (0 != newWorkItem.timeSheetLineId)
                        { // only *real* time items, not the predicted ones, and
                            log('converted work item: %o', newWorkItem);
                            myWork.list.push(newWorkItem);
                        }
                    }
                },
                error: function (jqXHR, textStatus, errorThrown)
                {
                    aceIOError(jqXHR, textStatus, errorThrown);
                }
            }));
        }

        /**
         * when() accepts multiple ajax objects, and calls done once after
         * all of them have completed.  This ensure the load process is
         * entirely complete.
         */
        jQuery.when.apply(jQuery, myAjaxCalls).done(function ()
            {
                log('my work items: %o', myWork.list);
                var tableData = '';

                for (var i = 0; i < myWork.list.length; i++)
                {
                    if (i > 0)
                    {
                        tableData += '&';
                    }
                    tableData += getRowParams(myWork.list[i]);
                }

                log('tableData: %s', tableData);

                jQuery.ajax(
                    {
                        url: './work-table.jsp',
                        data: tableData,
                        type: 'post',
                        success: function (page, status, jqXHR)
                        {
                            jQuery('#time').replaceWith(page);
                        }
                    }
                );
                jQuery('#work').show();
            }
        );
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
        projects.getProjects();
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
function aceIOError(jqXHR, textStatus, errorThrown)
{
    log('error: %o, %o, %o', jqXHR, textStatus, errorThrown);

//    jQuery('#login').show();
    jQuery('#msg').replaceWith('' +
        '<div id="msg" class="errors" style="background-color: rgb(255, 238, 221);">' +
        '<p>An error occurred communicating with ace project.  ' +
        'Please use ace project directly, and try again later.</p> ' +
        '</div>');
}

jQuery(document).ready(function ()
{
    jQuery(document).ajaxSuccess(function (event, XMLHttpRequest, ajaxOptions)
    {
        log('success: %o, %o, %o', event, XMLHttpRequest, ajaxOptions);
        if (XMLHttpRequest.responseJSON !== undefined &&
            XMLHttpRequest.responseJSON.status !== undefined &&
            XMLHttpRequest.responseJSON.status == 'fail')
        {
            jQuery('#msg').show().append(
                '<p>' +
                    XMLHttpRequest.responseJSON.results[0].ERRORDESCRIPTION +
                    '</p> '
            );
        }

        if (ajaxOptions.appendElement !== undefined)
        {
            /* Handle appending html response to an element */
            jQuery(ajaxOptions.appendElement).append(XMLHttpRequest.responseText);
        }
    });

    jQuery(document).ajaxError(function (event, jqXHR, settings, exception)
        {
            switch (jqXHR.status)
            {
                case 500:
                    jQuery('#msg').show().append(
                        '<p>Error code ' + jqXHR.status + ' ' +
                            jqXHR.statusText + ' ' +
                            jqXHR.getResponseHeader('Warning') + '</p> '
                    );
                    break;
                case 404:
                    jQuery('#msg').show().append(
                        '<p>Error code ' + jqXHR.status + ' ' +
                            jqXHR.statusText + ' ' +
                            jqXHR.getResponseHeader('Warning') + '</p> '
                    );
                    break;
            }
            log('error: %o, %o, %o', event, jqXHR, settings);
        }
    );

    // Check for existing login
    guid = getCookie("fasttime");
    log("Ace GUID: %s", guid);
    if (guid !== undefined && guid.length == 36)
    {
        jQuery.ajax({
            url: aceLoginInfoUrl,
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
                url: aceLoginUrl,
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
    if (mapping === undefined)
    {   // there is no mapping, just copy.
        outObject = inObject;
    }
    else
    {
        for (var key in mapping)
        {
            log('mapping: %s = %s, %o', key, mapping[key],
                inObject[mapping[key]]);
            outObject[key] = inObject[mapping[key]];
        }
    }

//    log('mapped object: %o', outObject);
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
function convertArrayOfObjects(inArray, mapping, keyMapping, comparator)
{
    var outArray;
    if (keyMapping === undefined)
    {   // convert as straight array.
        outArray = [];

        if (inArray instanceof Object)
        {   // assume associative array.
            for (var key in inArray)
            {
                outArray.push(convertObject(inArray[key], mapping));
            }
            if (comparator !== undefined)
            {
                outArray.sort(comparator);
            }
        }
        else if (inArray instanceof Array)
        {
            for (var i = 0; i < inArray.length; i++)
            {
                outArray[i] = convertObject(inArray[i], mapping);
            }
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

function projectCompare(a, b)
{
    if (a.projectName < b.projectName)
        return -1;
    if (a.projectName > b.projectName)
        return 1;
    return 0;
}

function projectsToParameters(ascArray)
{
    var parameters = '';
    var projectList = convertArrayOfObjects(ascArray, undefined, undefined,
        projectCompare)
    for (var key = 0; key < projectList.length; key++)
    {
        var projectId = projectList[key]['projectId'];
        var projectName = projectList[key]['projectName'];
        parameters += '&';
        parameters += 'projectId=' + encodeURIComponent(projectId);
        parameters += '&' + 'projectName-' + projectId + '=' +
            encodeURIComponent(projectName);
    }
    return parameters;
}

function tasksToParameters(ascArray)
{
    var parameters = '';
    for (var key in ascArray)
    {
        if (typeof(ascArray[key]) == "function")
        {
            continue;
        }
        parameters += '&';
        parameters += 'taskId=' + encodeURI(ascArray[key]['taskId']);
        parameters += '&taskName-' + encodeURI(ascArray[key]['taskId']) +
            '=' + encodeURI(ascArray[key]['taskName']);
        parameters += '&taskDescription-' + encodeURI(ascArray[key]['taskId']) +
            '=' + encodeURI(ascArray[key]['taskDescription']);
    }
    return parameters;
}

function convertMSDateToDate(msDate)
{
    var timeMs = parseInt(/\/Date\((\d*)\)\//.exec(msDate)[1]);
    timeMs += new Date().getTimezoneOffset() * 60 * 1000;
    return new Date(timeMs);
}