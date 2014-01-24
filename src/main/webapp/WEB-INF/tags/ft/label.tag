<%@ tag dynamic-attributes="attributes" %>
<%@ tag isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="css" required="false" %>
<c:if test="${attributes.errorcss}">
<c:set var="cssVar" value="${attributes.for}css"/>
</c:if>

<label for="${attributes.for}" class="${requestScope[cssVar]} ${css}">
  <jsp:doBody/>
</label>