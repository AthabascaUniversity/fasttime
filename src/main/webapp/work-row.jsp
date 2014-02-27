<%@ page import="java.util.Calendar" %>
<%@ page errorPage="json-error.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="statusId" value="${param['statusId']}"/>
<c:set var="statusName" value="${param['statusName']}"/>
<c:set var="projectId" value="${param['projectId']}"/>
<c:set var="projectName" value="${param['projectName']}"/>
<c:set var="taskId" value="${param['taskId']}"/>
<c:set var="taskName" value="${param['taskName']}"/>
<c:set var="timeSheetLineId" value="${param['timeSheetLineId']}"/>
<c:set var="comment" value="${param['comment']}"/>
<c:set var="sun" value="${param['sun']}"/>
<c:set var="mon" value="${param['mon']}"/>
<c:set var="tue" value="${param['tue']}"/>
<c:set var="wed" value="${param['wed']}"/>
<c:set var="thu" value="${param['thu']}"/>
<c:set var="fri" value="${param['fri']}"/>
<c:set var="sat" value="${param['sat']}"/>

<%
  final Calendar weekStart = Calendar.getInstance();
  weekStart.setTimeInMillis(Long.parseLong(request.getParameter("weekStart")));
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
  <td>${sun}</td>
  <td>${mon}</td>
  <td>${tue}</td>
  <td>${wed}</td>
  <td>${thu}</td>
  <td>${fri}</td>
  <td>${sat}</td>
  <td>
    <div id="comments-displayed-${timeSheetLineId}" style="display: inline;">
      ${comment}
    </div>

    <div id="commentdiv-${timeSheetLineId}" style="display: none;">
      <label for="comments-${timeSheetLineId}"></label>
      <textarea id="comments-${timeSheetLineId}" name="comments"
                cols="50" rows="3">${comment}</textarea>
    </div>
  </td>
</tr>
<script type="text/javascript">
  /*      <![CDATA[ */
  jQuery(document).ready(function ()
  {
    jQuery('#comments-displayed-${timeSheetLineId}').unbind('click.comment').bind('click.comment',
      function (event)
      {
        log('comment click');
        jQuery("#comments-displayed-${timeSheetLineId}").hide();
        jQuery("#commentdiv-${timeSheetLineId}").show();
        jQuery("#comments-${timeSheetLineId}").focus();
        event.preventDefault();
      });

    jQuery('#commentdiv-${timeSheetLineId}').focusout(
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