<%@ page import="java.util.Calendar" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page errorPage="json-error.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- CRITICAL supposedly query parameter order is not guaranteed.  We need to
transform this into a web service. --%>
<table class="debugtable border" id="time" style="display: none;">
<tr>
  <th>Week Start</th>
  <th>Status</th>
  <th>Project</th>
  <th>Task</th>
  <th>Sun</th>
  <th>Mon</th>
  <th>Tue</th>
  <th>Wed</th>
  <th>Thu</th>
  <th>Fri</th>
  <th>Sat</th>
  <th>Notes</th>
  <th>Total</th>
</tr>
<c:forEach items="${paramValues['statusId']}" var="statusId"
           varStatus="status">
  <c:set var="statusName" value="${paramValues['statusName'][status.index]}"/>
  <c:set var="projectId" value="${paramValues['projectId'][status.index]}"/>
  <c:set var="projectName" value="${paramValues['projectName'][status.index]}"/>
  <c:set var="taskId" value="${paramValues['taskId'][status.index]}"/>
  <c:set var="taskName" value="${paramValues['taskName'][status.index]}"/>
  <c:set var="timeSheetLineId"
         value="${paramValues['timeSheetLineId'][status.index]}"/>
  <c:set var="comment" value="${paramValues['comment'][status.index]}"/>
  <c:set var="sun" value="${paramValues['sun'][status.index]}"/>
  <c:set var="mon" value="${paramValues['mon'][status.index]}"/>
  <c:set var="tue" value="${paramValues['tue'][status.index]}"/>
  <c:set var="wed" value="${paramValues['wed'][status.index]}"/>
  <c:set var="thu" value="${paramValues['thu'][status.index]}"/>
  <c:set var="fri" value="${paramValues['fri'][status.index]}"/>
  <c:set var="sat" value="${paramValues['sat'][status.index]}"/>
  <c:set var="total" value="${paramValues['total'][status.index]}"/>

  <%
    final Calendar weekStart = Calendar.getInstance();
    weekStart.setTimeInMillis(Long.parseLong(request.getParameter(
      "weekStart")));
    request.setAttribute("weekStart", weekStart);
  %>
  <tr>
    <td>
      <fmt:formatDate value="${weekStart.time}"
                      pattern="yyyy-MM-dd"/>
    </td>
    <td>${statusName}</td>
    <td>${projectName}</td>
    <td>${taskName}</td>
    <c:set var="index" value="${timeSheetLineId}"/>
    <td><input name="sun-${timeSheetLineId}-${sun}" id="sun-${timeSheetLineId}"
               value="${sun}" size="2" width="2"/></td>
    <td><input name="mon-${timeSheetLineId}-${mon}" id="mon-${timeSheetLineId}"
               value="${mon}" size="2" width="2"/></td>
    <td><input name="tue-${timeSheetLineId}-${tue}" id="tue-${timeSheetLineId}"
               value="${tue}" size="2" width="2"/></td>
    <td><input name="wed-${timeSheetLineId}-${wed}" id="wed-${timeSheetLineId}"
               value="${wed}" size="2" width="2"/></td>
    <td><input name="thu-${timeSheetLineId}-${thu}" id="thu-${timeSheetLineId}"
               value="${thu}" size="2" width="2"/></td>
    <td><input name="fri-${timeSheetLineId}-${fri}" id="fri-${timeSheetLineId}"
               value="${fri}" size="2" width="2"/></td>
    <td><input name="sat-${timeSheetLineId}-${sat}" id="sat-${timeSheetLineId}"
               value="${sat}" size="2" width="2"/></td>
    <td>
      <div id="comments-displayed-${timeSheetLineId}" style="display: inline;">
          ${comment}
      </div>

      <div id="commentdiv-${timeSheetLineId}" style="display: none;">
        <label for="comments-${timeSheetLineId}"></label>
        <textarea id="comments-${timeSheetLineId}" name="comments"
                  cols="50" rows="3">${comment}</textarea>
      </div>

      <script type="text/javascript">
        /*      <![CDATA[ */
        function aceSaveHours(day, timeSheetLineId, hours)
        {

          jQuery.ajax({
            url: aceSaveItemHoursUrl,
            data: 'guid=' + guid + '&day=' + day +
              '&timesheetlineid=' + timeSheetLineId + '&nbhours=' + hours,
            success: function (page, status, jqXHR)
            {
              log('save hours results: %o', page);
              myWork.loadWeeks();
              $('#comments').val('');
            }
          });
        }

        jQuery(document).ready(function ()
        {
          jQuery('#time').show(); // show if there are items to display.
          jQuery('input[id^=sun],input[id^=mon],input[id^=tue],input[id^=wed],input[id^=thu],input[id^=fri],input[id^=sat]').unbind('focusout.hours').bind('focusout.hours',
            function (event)
            {
              var name = $(this).attr('name');
              var hours = $(this).val();
              var day;
              var timeSheetLineId;
              name = name.split('-');
              day = weekMap[name[0]];
              timeSheetLineId = name[1];
              if (name[2] != hours)
              {
                log('saving %s, name: %o, day: %s, hours: %s, lineid: %s',
                  $(this).attr('id'), name, day, hours, timeSheetLineId);

                aceSaveHours(day, timeSheetLineId, hours);
              }
              event.preventDefault();
            });

          jQuery('#comments-displayed-${timeSheetLineId}').unbind('click.comment').bind('click.comment',
            function (event)
            {
              log('comment click');
              jQuery("#comments-displayed-${timeSheetLineId}").hide();
              jQuery("#commentdiv-${timeSheetLineId}").show();
              jQuery("#comments-${timeSheetLineId}").focus();
              event.preventDefault();
            });

          jQuery('#commentdiv-${timeSheetLineId}').unbind('focusout.comment').bind('focusout.comment',
            function (event)
            {
              log('comment blurred');
              var displayed = jQuery("#comments-displayed-${timeSheetLineId}");
              var textBox = jQuery("#comments-${timeSheetLineId}");
              displayed.val(textBox.val());
              displayed.show();
              jQuery('#commentdiv-${timeSheetLineId}').hide();
              event.preventDefault();
            });
        });
        /*      ]]> */
      </script>
    </td>
    <td>${total}</td>
  </tr>
</c:forEach>
</table>
