<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--@elvariable id="model" type="com.github.trentonadams.WorkList"--%>
<c:forEach items="${model.list}" var="item">
  <p>${item.taskName}</p>
</c:forEach>
