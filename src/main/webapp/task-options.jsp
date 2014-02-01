<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<option>-- Select Task --</option>
<c:forEach items="${paramValues['taskId']}" var="taskId" varStatus="status">
<option id="${taskId}" value="${taskId}">${paramValues['taskName'][status.index]}</option>
</c:forEach>