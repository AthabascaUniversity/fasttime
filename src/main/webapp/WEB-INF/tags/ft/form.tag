<%@ tag dynamic-attributes="attributes" %>
<%@ tag description="Deals with common html form handling in OROS.
* adds a submit button
* Automatically hooks submission with ajax
* adds the default DispatcherServlet action if none specified
* enforces usage of things like id, and method" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<%@ tag isELIgnored="false" %>
<%@ tag body-content="scriptless" %>
<%@ attribute name="action" required="false"
              description="
  The html form action attribute.  Defaults to /servlet/DispatcherServlet" %>
<%@ attribute name="method" required="true"
              description="html method attribute" %>
<%@ attribute name="id" required="true" description="the html id of the form" %>
<%@ attribute name="divSelector" required="true"
              description="the css selector of the element that should be
              replaced by the ajax html results" %>
<%@ attribute name="onErrorHide" required="false"
              description="if an error occurs, the css selector of the element to hide" %>

<%@ attribute name="onValidateSelector" required="true" description="
  If the OROS validation fails, display the contents of the
  returned page in this element instead.  Usually the same
  element (such as a div) which you were displaying the page (such
  as an HTML form) in previously " %>
<%@ attribute name="extraJQuery" required="false" description="
  if you need more control over the jquery ajax call attributes, such as
  using the success function, use this.  It should be a javascript property
  structure, with a preceding comma to indicate the start of a new property.
  Obviously only jQuery supported properties, or orosAjaxCall properties are useful" %>
<%@ attribute name="showsubmit" type="java.lang.Boolean" required="false"
              description="
show the submit button, or allow submission some other way"%>
<%@ attribute name="includeSubmit" type="java.lang.Boolean" required="false"
  description="Defaults to true.  If false is specified, you will include
  your own submit button and or buttons.  Please note that only a submit
  button with an id of id-submit, will be automatically handled by a
  jQuery ajax call. where 'id' is the id specified in the 'id' attribute" %>
<%@ attribute name="showerrors" type="java.lang.Boolean" required="false"
              description="
Determines if the common form validation note, for when a form validation
fails, should be displayed in this form. Normally this would be true, so true
is the default value."%>
<%@ attribute name="submitName" required="false" description="
The name of the submit button, in other words the 'value' attribute" %>
<%@ attribute name="prefixButtons" required="false" fragment="true"
              description="Buttons to appear before the submit"%>
<%@ attribute name="suffixButtons" required="false" fragment="true"
              description="Buttons to appear after the submit"%>
<c:set var="submitId" value="${id}-submit"/>
<c:set var="includeSubmit" value="${includeSubmit == null?true:includeSubmit}"/>
<c:set var="submitName" value="${submitName == null?'Submit':submitName}"/>
<c:url var="dispatcherUrl" value="/servlet/DispatcherServlet"/>
<form class="cmxform" action="${action == null?dispatcherUrl:action}" method="${method}"
      id="${id}" aria-live="polite">
  <c:if test="${fn:length(ErrorList.errorMap) > 0 and showerrors != 'false'}">
    <div class="error-box">
      Some information may be missing - please review the information below.
    </div>
  </c:if>
  <jsp:doBody/>
  <div class="button">
    <jsp:invoke fragment="prefixButtons"/>
    <c:if test="${includeSubmit}">
      <input class="submit cancel" type="submit" name="submit" id="${submitId}"
             value="${submitName}"/>
    </c:if>
    <jsp:invoke fragment="suffixButtons"/>
  </div>
</form>
<%--@elvariable id="ErrorList" type="ca.montage.banner.web.validation.ErrorList"--%>
<script type="text/javascript">
  /*      <![CDATA[ */
  (function ($)
  {
    $(document).ready(function ()
    {
      if (${showsubmit == 'false'})
      {
        $("#${submitId}").hide();
      }

      $("#${submitId}").click(
        function (event)
      {
        orosLog("form id %s", "${id}");
        orosLog("submit id %s", "${submit}");
        orosLog("%s", jQuery);
        var formData = $("#${id}").serialize() + "&submit=true";
        orosAjaxCall('${divSelector}', {
          ajaxUrl:dispatcherUrl,
          data:formData,<c:if test="${!empty(onErrorHide)}">
          onErrorHide: "${onErrorHide}",</c:if>
          onValidateSelector:'${onValidateSelector}'
          ${extraJQuery}
        });
        event.preventDefault();
      });
    });
  })(jQuery);
  /*      ]]> */
</script>
