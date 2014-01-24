<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<%@ tag dynamic-attributes="attributes" %>
<%@ tag description="
Adds required text if necessary.  Checks a checkbox or radio button if
checked is 'true'.  Enforces the use of type, name, and value. " %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag isELIgnored="false" %>
<%@ attribute name="type" required="true" %>
<%@ attribute name="id" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="value" required="true" %>
<%@ attribute name="disabled" required="false" %>
<%@ attribute name="formatText" required="false" description="Text to display after the input for a format example" %>
<%@ attribute name="checked" required="false"
              description="true if the radio button or checkbox should be checked" %>
<%@ attribute name="invaliderror" required="false" description="
Determines if the validation error text is displayed or not, for this input.
Default: true"%>
<%@ attribute name="required" required="false" description="
  true if the field is required.  A standard 'required' notification will
  be displayed to the user" %>
<c:if test="${attributes.maxlength != null}">
  <c:set var="ml">maxlength="${attributes.maxlength}"</c:set>
</c:if>
<c:if test="${attributes.size != null}">
  <c:set var="ms">size="${attributes.size}"</c:set>
</c:if>
<c:if test="${attributes.class != null}">
  <c:set var="class">${attributes.class}</c:set>
</c:if>
<c:choose>
  <c:when test="${checked}">
    <c:set var="checked">checked="checked"</c:set>
  </c:when>
  <c:otherwise>
    <c:set var="checked" value=""/>
  </c:otherwise>
</c:choose>
<c:if test="${class != null or required == 'true'}">
  <c:set var="class">class="${class}${required == 'true'?' required':''}"</c:set>
</c:if>

<input ${class} type="${type}" id="${id}" name="${name}"
                value="${value}" ${ml} ${ms} ${checked}
                ${disabled == 'true'?'disabled="disabled"':''}
  <c:forEach items="${attributes}" var="da">${da.key}="${da.value}"</c:forEach>
/>
<%--@elvariable id="errorList" type="ca.montage.banner.web.validation.ErrorList"--%>
${required == 'true'?reqf:''}
${formatText != '' and formatText != null?formatText:''}
<c:if test="${invaliderror != 'false'}"><ht:input-error id="${id}" name="${name}"/></c:if>

