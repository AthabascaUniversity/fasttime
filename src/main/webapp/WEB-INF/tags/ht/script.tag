<%@ tag description="Deals with common html script handling in OROS.
* adds the CDATA section around the sript
* Adds the jquery function($){/* code here */}(jQuery); construct around the
block of code" %>
<%@ tag isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="type" required="true"
              description="java script type attribute" %>
<%@ attribute name="jquery" required="false"
              description="'true' if you want the jquery wrapper function
              surrounding the block so that you can use '$'" %>
<%@ attribute name="ready" required="false"
              description="'true' if you want the jquery document ready
              wrapper event surrounding the block so that you can use have
              the script run when the document is ready.  jquery must also
              be set to 'true'" %>
<script type="${type}">
  /*      <![CDATA[ */
  <c:if test="${jquery == 'true'}">
  (function($){
    <c:if test="${ready == 'true'}">
    $(document).ready(function () {
    </c:if>
  </c:if>
  <jsp:doBody/>
  <c:if test="${jquery == 'true'}">
    <c:if test="${ready == 'true'}">
    });
    </c:if>
  }(jQuery));
  </c:if>
  /*      ]]> */
</script>
