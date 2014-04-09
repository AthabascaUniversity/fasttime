<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<option>-- Select Project --</option>
<c:forEach items="${paramValues['projectId']}" var="projectId"
           varStatus="status">
  <c:set var="key" value="projectName-${projectId}"/>
<option id="${projectId}" value="${projectId}">
  <c:out value="${param[key]}" escapeXml="true"/> </option>
</c:forEach>