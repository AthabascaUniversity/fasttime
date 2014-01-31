<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<div class="ui-corner-all">
  <table class="border">
    <tr class="tr" id="tr1" tdid="2786">
      <td>
        <label for="date">Date</label>
        <input type="text" id="date" name="date"/>
        <ht:script type="text/javascript" jquery="true" ready="true">
          $("#date").datepicker({onSelect: function ()
          {

          }, autoSize: true,
            dateFormat: "yy-M-dd"
          });
        </ht:script>
      </td>
      <td project_id="52" style="white-space:nowrap">
        <label for="projects">Projects</label>
        <select id="projects" name="project">
          <option>Loading...</option>
        </select>
      </td>
      <td task_id="680" style="white-space:nowrap">
        <label for="tasks">Tasks</label>
        <select id="tasks" name="task">
          <option>First select a project</option>
        </select>
      </td>
      <td align="right">
        <a tdid="2786.2" class="aEditableField" href="#">0.00</a>

        <div style="display:none;" tdid="2786.2">
          <input type="text"
                 class="input-small-list"
                 tdid="2786.2"
                 size="2"
                 autocomplete="off">
        </div>
      </td>
      <%--      <td time_type_id="1">Regular&nbsp;</td>--%>
      <td style="white-space:nowrap"> &nbsp;
        <label for="comment">Comment</label>
        <input type="text" id="comment" name="comment">
      </td>
    </tr>
  </table>
</div>