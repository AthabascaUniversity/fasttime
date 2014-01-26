<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:url var="aceLoginInfo" value="/proxy/">
  <c:param name="fct" value="getlogininfo"/>
  <c:param name="format" value="JSON"/>
</c:url>

<c:url var="aceGetWeeks" value="/proxy/">
  <c:param name="fct" value="getmyweeks"/>
  <c:param name="format" value="JSON"/>
  <c:param name="approvalstatus" value="0"/>
</c:url>

<c:url var="aceGetWorkItems" value="/proxy/">
  <c:param name="fct" value="getmyworkitems"/>
  <c:param name="format" value="JSON"/>
  <c:param name="approvalstatus" value="0"/>
</c:url>

<c:url var="aceLogin" value="/proxy/">
  <c:param name="fct" value="login"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON"/>
</c:url>

<script type="text/javascript">
  /*      <![CDATA[ */

  (function ($)
  {
    $(document).ready(function ()
    {
      // Check for existing login
      guid = getCookie("fasttime");
      log("Ace GUID: %s", guid);
      if (guid !== undefined && guid.length == 36)
      {
        $.ajax({
          url: '${aceLoginInfo}',
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
      $('#login-submit').unbind('click.login').bind('click.login',
        function (event)
        {
          log('submit clicked');
          $('#msg').replaceWith('<div id="msg"></div>');
          var formData = $("#fm1").serialize();
          log('Form Data: %s', formData);
          $.ajax({
            url: '${aceLogin}',
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

  }(jQuery));

  /**
   * Loads the in progress work list into workList global variable.
   */
  function loadMyWorkItems(workWeek)
  {
    for (i = 0; i < workWeek.results.length; i++)
    {
      jQuery.ajax({
        url: '${aceGetWorkItems}',
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
                '            <td>' + newWorkItem.approvalStatusName +
                '</td>' +
                '            <td>' + newWorkItem.projectName + '</td>' +
                '            <td>' + newWorkItem.taskName + '</td>';
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
      url: '${aceGetWeeks}',
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

  /*  new Date(new Date().setFullYear('2014', '01', '27'));
   alert(myDate.getYear + '-' + myDate.getMonth());*/

  /*      ]]> */
</script>