<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:url var="aceLoginInfo" value="https://api.aceproject.com/">
  <c:param name="fct" value="getlogininfo"/>
  <c:param name="format" value="JSON2"/>
</c:url>

<c:url var="aceGetWeeks" value="https://api.aceproject.com/">
  <c:param name="fct" value="getmyweeks"/>
  <c:param name="format" value="JSON2"/>
  <c:param name="approvalstatus" value="0"/>
</c:url>

<c:url var="aceGetWorkItems" value="https://api.aceproject.com/">
  <c:param name="fct" value="getmyworkitems"/>
  <c:param name="format" value="JSON2"/>
  <c:param name="approvalstatus" value="0"/>
</c:url>

<c:url var="aceLogin" value="https://api.aceproject.com/">
  <c:param name="fct" value="login"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON2"/>
</c:url>

<c:url var="aceGetProjects" value="https://api.aceproject.com/">
  <c:param name="fct" value="getprojects"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON2"/>
  <c:param name="sortorder" value="PROJECT_NAME"/>
</c:url>

<script type="text/javascript">
  /*      <![CDATA[ */

  aceLoginInfoUrl = '${aceLoginInfo}';
  aceGetWeeksUrl = '${aceGetWeeks}';
  aceGetWorkItemsUrl = '${aceGetWorkItems}';
  aceLoginUrl = '${aceLogin}';
  aceGetProjects = '${aceGetProjects}';

  /*  new Date(new Date().setFullYear('2014', '01', '27'));
   alert(myDate.getYear + '-' + myDate.getMonth());*/

  /*      ]]> */
</script>
