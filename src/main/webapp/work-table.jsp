<%@ page import="java.util.Calendar" %>
<%@ page errorPage="json-error.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

  <c:if test="${status.first}">
    <table class="debugtable border" id="time">
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
    </tr>
  </c:if>

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
    <td>${sun}</td>
    <td>${mon}</td>
    <td>${tue}</td>
    <td>${wed}</td>
    <td>${thu}</td>
    <td>${fri}</td>
    <td>${sat}</td>
    <td>
      <div id="comment-${timeSheetLineId}">
        <label for="comments-${timeSheetLineId}"></label>
        <textarea id="comments-${timeSheetLineId}" name="comments"
                  cols="30" rows="2">${comment}</textarea>
      </div>
    </td>
  </tr>
  <c:if test="${status.last}">
    </table>
  </c:if>
</c:forEach>