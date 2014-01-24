<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<%@ tag isELIgnored="false" %>
<%@ tag description="
Creates an 'error' div for the input with 'name' and 'id'.  'name' is
 used as a lookup into the ErrorList.errorMap request or session attribute.
 If 'id' is not given, an error div is not created.  Also logs the error to
 the javascript console. " %>
<%@ attribute name="id" required="false" description="id of the input" %>
<%@ attribute name="name" required="true" description="name of the input, for looking up input errors" %>
<c:if test="${id != null and id != ''}">
  <div class="invalid" ${ErrorList.errorMap[name] == null?'style="display: none;"':''} id="error-${id}">
    <ht:script type="text/javascript" jquery="true" ready="true">
       orosLog('${name}-error: ${ErrorList.errorMap[name] != null} - ${ErrorList.errorMap[name].errorMessage}');
    </ht:script>
    <p>${ErrorList.errorMap[name].errorMessage}</p></div>
</c:if>
