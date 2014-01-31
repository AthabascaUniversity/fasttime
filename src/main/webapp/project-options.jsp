<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<option>-- Select Project --</option>
<c:forEach items="${paramValues['projectId']}" var="projectId"
           varStatus="status">
<option id="${projectId}" value="${projectId}">${paramValues['projectName'][status.index]}</option>
</c:forEach>