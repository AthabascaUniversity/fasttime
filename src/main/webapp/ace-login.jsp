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
  var guid;

  var workList = [];

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

  function loadMyWorkItems(workWeek)
  {
    for (i = 0; i < workWeek.results.length; i++)
    {
      log('work item: %o', workWeek.results[i]);
      jQuery.ajax({
        url: '${aceGetWorkItems}',
        type: 'get',
        dataType: 'json',
        data: 'guid=' + guid + '&timeperiodid=' +
          workWeek.results[i].TIMESHEET_PERIOD_ID,
        success: function (page, status, jqXHR)
        {
          for (i = 0; i < page.results.length; i++)
          {
            var workItem = page.results[i];
            log('work item %o', workItem);
            var newWorkItem = {
              approvalStatus: workItem.APPROVAL_STATUS,
              approvalStatusName: workItem.APPROVAL_STATUS_NAME,
              project: workItem.PROJECT_ID,
              projectName: workItem.PROJECT_NAME,
              taskId: workItem.TASK_ID,
              taskName: workItem.TASK_RESUME,
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
            workList.push(newWorkItem);
          }
          log('work list: %o', workList);
        },
        error: function (page, status, jqXHR)
        {
          aceIOError(page, status, jqXHR);
        }
      });
    }
  }

  function loadMyWeeks()
  {
    jQuery.ajax({
      url: '${aceGetWeeks}',
      type: 'get',
      dataType: 'json',
      data: 'guid=' + guid,
      success: function (page, status, jqXHR)
      {
        log('weeks %o', page);
        loadMyWorkItems(page);
      },
      error: function (page, status, jqXHR)
      {
        aceIOError(page, status, jqXHR);
      }
    });
  }


  /*      ]]> */
</script>