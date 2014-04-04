<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<div class="ui-corner-all">
  <table class="border">
    <tr>
      <td>
        <%--<label for="date">Date</label>--%>
        <input type="text" id="date" name="date"/>
        <ht:script type="text/javascript" jquery="true" ready="true">
          $("#date").datepicker({onSelect: function ()
          {
            jQuery('#projects').focus();
          }, autoSize: true,
            dateFormat: "yy-mm-dd"
          });
        </ht:script>
      </td>
      <td>
        <%--<label for="projects">Projects</label>--%>
        <select id="projects" name="project">
        </select>
      </td>
      <td>
        <%--<label for="tasks">Tasks</label>--%>
        <select id="tasks" name="task">
        </select>
      </td>
      <td>
        <input type="text"
               name="hours"
               id="hours"
               class="input-small-list"
               size="2"
               autocomplete="off">
      </td>
      <%--      <td time_type_id="1">Regular&nbsp;</td>--%>
      <td style="white-space:nowrap"> &nbsp;
        <%--<label for="comment">Comment</label>--%>
        <textarea name="comments" id="comments" style="width: 40em;" rows="3"></textarea>
      </td>
      <td>
        <input type="submit" id="save" value="Save"/>
      </td>
    </tr>
  </table>
</div>

<script type="text/javascript">
  /*      <![CDATA[ */
  function aceSaveWork(date, projectId, taskId, hours, comments, week)
  {
    var jsDate = new Date(date);
    var hoursDay = '&hoursday' + (jsDate.getUTCDay()+ 1) + '=' + hours;

    jQuery.ajax({
      url: aceSaveWorkItemUrl,
      data: 'guid=' + guid + '&weekStart=' + week.weekStart.toISOString() +
        '&projectid=' + projectId + '&taskid=' + taskId +
        hoursDay + '&comments=' + comments + '&timetypeid=1',
      success: function (page, status, jqXHR)
      {
        log('savework results: %o', page);
        myWork.loadWeeks();
      }
    });
  }

  function aceSaveWorkGetWeek(date, projectId, taskId, hours, comments)
  {
    log('saving values %s, %s, %s, %s, %s', date, projectId, taskId, hours,
      comments);
    jQuery.ajax({
      url: aceGetWeeksUrl,
      data: 'guid=' + guid + '&filterdate=' + date,
      success: function (page, status, jqXHR)
      {
        if (page.results.length == 0)
        {
          log('no weeks available, creating a new week');
          jQuery.ajax({
            url: aceCreateWeekUrl,
            data: 'guid=' + guid + '&dateweekstart=' + date,
            success: function (page, status, jqXHR)
            {
              week = convertObject(page.results[0], {
                'weekStart': 'DATE_WEEK_START',
                'weekEnd': 'DATE_WEEK_END',
                'timeSheetPeriodId': 'TIMESHEET_PERIOD_ID'
              });
              week.weekStart = convertMSDateToDate(week.weekStart);
              week.weekEnd = convertMSDateToDate(week.weekEnd);
              aceSaveWork(date, projectId, taskId, hours, comments, week);
            }
          });
        }
        else
        {
          week = convertObject(page.results[0], {
            'weekStart': 'DATE_WEEK_START',
            'weekEnd': 'DATE_WEEK_END',
            'timeSheetPeriodId': 'TIMESHEET_PERIOD_ID'
          });
          week.weekStart = convertMSDateToDate(week.weekStart);
          week.weekEnd = convertMSDateToDate(week.weekEnd);
          aceSaveWork(date, projectId, taskId, hours, comments, week);
        }
      }
    });
  }

  jQuery(document).ready(
    function ()
    {
      var projectsCombo = jQuery('#projects');
      projectsCombo.unbind('change.project').bind('change.project',
        function (event)
        {
          if (projects.list[projectsCombo.val()] !== undefined)
          {
            projects.list['' + projectsCombo.val()].getTasks(function (tasks)
            {
              tasks.loadCombo();
            });
          }
          else
          {
            jQuery('#tasks option').remove();
          }
        });
      var saveButton = jQuery('#save');
      saveButton.unbind('click.save').bind('click.save', function (event)
        {
          var date = jQuery('#date');
          var tasks = jQuery('#tasks');
          var hours = jQuery('#hours');
          var comments = jQuery('#comments');
          aceSaveWorkGetWeek(date.val(), projectsCombo.val(), tasks.val(),
            hours.val(),
            comments.val());
        }
      );
    }
  );
  /*      ]]> */
</script>