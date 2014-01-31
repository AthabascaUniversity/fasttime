<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:forEach items="${paramValues['projectId']}" var="projectId"
           varStatus="status">
<option id="${projectId}">${paramValues['projectName'][status.index]}</option>
</c:forEach>