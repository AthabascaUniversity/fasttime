<%@ page import="java.util.Calendar" %>
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
    <a href="" id="icon-${timeSheetLineId}">
      <img src="<c:url value="/images/blue-arrow.jpg"/>"/>
    </a>

    <div id="comment-${timeSheetLineId}" style="display: none;">
      <label for="comments-${timeSheetLineId}"></label>
      <textarea id="comments-${timeSheetLineId}" name="comments"
                cols="30" rows="2">${comment}</textarea>
    </div>
  </td>
</tr>
<script type="text/javascript">
  /*      <![CDATA[ */
  jQuery(document).ready(function ()
  {
    jQuery('#icon-${timeSheetLineId}').unbind('click.comment').bind('click.comment',
      function (event)
      {
        log('comment click');
        jQuery("#comment-${timeSheetLineId}").center();
        jQuery("#comment-${timeSheetLineId}").show();
        event.preventDefault();
      });
  });
  /*      ]]> */

</script>