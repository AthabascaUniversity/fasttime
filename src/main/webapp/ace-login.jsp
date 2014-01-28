<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:url var="aceLoginInfo" value="/proxy/">
  <c:param name="fct" value="getlogininfo"/>
  <c:param name="format" value="JSON"/>
</c:url>

<c:url var="aceGetWeeks" value="/proxy/">
  <c:param name="fct" value="getmyweeks"/>
  <c:param name="format" value="JSON"/>
  <c:param name="approvalstatus" value="0"/>
</c:url>

<c:url var="aceGetWorkItems" value="/proxy/">
  <c:param name="fct" value="getmyworkitems"/>
  <c:param name="format" value="JSON"/>
  <c:param name="approvalstatus" value="0"/>
</c:url>

<c:url var="aceLogin" value="/proxy/">
  <c:param name="fct" value="login"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON"/>
</c:url>

<script type="text/javascript">
  /*      <![CDATA[ */

  aceLoginInfoUrl = '${aceLoginInfo}';
  aceGetWeeksUrl = '${aceGetWeeks}';
  aceGetWorkItemsUrl = '${aceGetWorkItems}';
  aceLoginUrl = '${aceLogin}';

  /*  new Date(new Date().setFullYear('2014', '01', '27'));
   alert(myDate.getYear + '-' + myDate.getMonth());*/

  /*      ]]> */
</script>