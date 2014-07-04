<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<option>-- Select Task --</option>
<c:forEach items="${paramValues['taskId']}" var="taskId" varStatus="status">
  <c:set var="taskName" value="taskName-${taskId}"/>
  <c:set var="taskDescription" value="taskDescription-${taskId}"/>
<option id="${taskId}" title="<c:out value="${param[taskDescription]}" escapeXml="true"/>" value="${taskId}">
<c:out value="${param[taskName]}" escapeXml="true"/></option>
</c:forEach>