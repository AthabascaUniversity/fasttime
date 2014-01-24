<%@ tag dynamic-attributes="attributes" %>
<%@ tag description="
Adds required text if necessary.  Checks a checkbox or radio button if
checked is 'true'.  Enforces the use of type, name, and value. " %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<%@ tag isELIgnored="false" %>
<%@ attribute name="id" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="required" required="false" description="
  true if the field is required.  A standard 'required' notification will
  be displayed to the user" %>
<%@ attribute name="invaliderror" required="false" description="
Determines if the validation error text is displayed or not, for this input.
Default: true"%>
<c:if test="${attributes.class != null}">
  <c:set var="class">${attributes.class}</c:set>
</c:if>
<c:set var="class">class="${class}"</c:set>
<select ${class} id="${id}" name="${name}" title="${title}">
  <jsp:doBody/>
</select>
<%--@elvariable id="ErrorList" type="ca.montage.banner.web.validation.ErrorList"--%>
${required == 'true'?reqf:''}
<c:if test="${invaliderror != 'false'}"><ht:input-error id="${id}" name="${name}"/></c:if>