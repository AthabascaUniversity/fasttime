<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<div class="ui-corner-all">
  <table class="border">
    <tr>
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
      <td>
        <label for="projects">Projects</label>
        <select id="projects" name="project">
        </select>
      </td>
      <td>
        <label for="tasks">Tasks</label>
        <select id="tasks" name="task">
        </select>
      </td>
      <td>
        <a class="aEditableField" href="#">0.00</a>

        <div style="display:none;">
          <input type="text"
                 class="input-small-list"
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