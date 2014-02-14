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
            dateFormat: "yy-M-dd"
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
        <textarea name="comments" id="comments" rows="1"></textarea>
      </td>
      <td>
        <input type="submit" id="save" value="Save"/>
      </td>
    </tr>
  </table>
</div>

<script type="text/javascript">
  /*      <![CDATA[ */
  function aceSaveWork(date, projectId, taskId, hours, comments)
  {
    log('saving values %s, %s, %s, %s, %s', date, projectId, taskId, hours,
      comments);
    jQuery.ajax({
      url: aceGetWeeksUrl,
      data: 'guid=' + guid
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
          aceSaveWork(date.val(), projectsCombo.val(), tasks.val(), hours.val(),
            comments.val());
        }
      );
    }
  );
  /*      ]]> */
</script>