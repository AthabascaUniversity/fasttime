<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<div id="fm1" class="ui-corner-all">
  <table class="border">
    <tr>
      <td><label for="date">Date</label></td>
      <td><input type="text" id="date" name="date" size="15" maxlength="15"/>
        <ht:script type="text/javascript" jquery="true" ready="true">
          $("#date").datepicker({onSelect: function ()
          {
            jQuery('#projects').focus();
          }, autoSize: true,
            dateFormat: "yy-mm-dd"
          });
          jQuery('#date').datepicker("setDate", new Date());
        </ht:script>
      </td>
    </tr>
    <tr>
      <td><label for="projects">Projects</label></td>
      <td><select id="projects" name="project">
      </select></td>
    </tr>
    <tr>
      <td><label for="tasks">Tasks</label></td>
      <td><select id="tasks" name="task">
      </select></td>
    </tr>
    <tr>
      <td><label for="hours">Hours</label></td>
      <td><input type="text"
             name="hours"
             id="hours"
             class="input-small-list"
             size="5"
             maxlength="5"
             autocomplete="off"/></td>
      <%--      <td time_type_id="1">Regular&nbsp;</td>--%>
    </tr>
    <tr>
      <td><label for="comment">Comment</label></td>
      <td><textarea name="comments" id="comments" style="width: 40em;"
                rows="3"></textarea></td>
    </tr>
    <tr>
      <td colspan="2">
        <input type="submit" id="save" value="Save"/>
      </td>
    </tr>
  </table>
</div>

<div>
  <input type="checkbox" id="day-only"/> <label for="day-only">Show today
  only</label>

  <script type="text/javascript">
    /*      <![CDATA[ */
    var dayNamesShort = {0: 'sun', 1: 'mon', 2: 'tue', 3: 'wed', 4: 'thu',
      5: 'fri', 6: 'sat'};
    jQuery(document).ready(function ()
    {
      $('#day-only').unbind('click.day').bind('click.day', function (event)
      {
        var day = dayNamesShort[new Date().getDay()];
        if (this.checked)
        {
          log('checked');
          $('[id*=' + day + '][value=0]').parent().parent().hide();
        }
        else
        {
          log('unchecked');
          $('[id*=' + day + '][value=0]').parent().parent().show();
        }
      });
    });
    /*      ]]> */
  </script>

</div>

<script type="text/javascript">
  /*      <![CDATA[ */
  function aceSaveWork(date, projectId, taskId, hours, comments, week)
  {
    var jsDate = new Date(date);
    var hoursDay = '&hoursday' + (jsDate.getUTCDay() + 1) + '=' + hours;

    jQuery.ajax({
      url: aceSaveWorkItemUrl,
      data: 'guid=' + guid + '&weekStart=' + week.weekStart.toISOString() +
        '&projectid=' + projectId + '&taskid=' + taskId +
        hoursDay + '&comments=' + comments + '&timetypeid=1',
      success: function (page, status, jqXHR)
      {
        log('savework results: %o', page);
        myWork.loadWeeks();
        $('#comments').val('');
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
      // hook the project drop down
      projectsCombo.unbind('change.project').bind('change.project',
        function (event)
        {
          if (projects.list[projectsCombo.val()] !== undefined)
          { // load the tasks for the project selected
            projects.list['' + projectsCombo.val()].getTasks(function (tasks)
            {
              tasks.loadCombo();
            });
          }
          else
          { // clear the tasks, as a project is no longer selected.
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