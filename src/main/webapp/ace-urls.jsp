<%@ page import="java.util.Calendar" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:url var="aceLoginInfo" value="http://localhost:8080/fasttime/proxy/">
  <c:param name="fct" value="getlogininfo"/>
  <c:param name="format" value="JSON2"/>
</c:url>

<%
  Calendar dateFrom = Calendar.getInstance();
  Calendar dateTo = Calendar.getInstance();
  // start of week
  dateFrom.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
  // back one week, meaning two weeks total.
  dateFrom.add(Calendar.DAY_OF_YEAR, -14);
  request.setAttribute("dateFrom", dateFrom);
  request.setAttribute("dateTo", dateTo);
%>


<c:url var="aceGetWeeks" value="http://localhost:8080/fasttime/proxy/">
  <c:param name="fct" value="getmyweeks"/>
  <c:param name="format" value="JSON2"/>
  <c:param name="approvalstatus" value="0"/>
  <c:param name="filterdate">
    <fmt:formatDate value="${dateTo.time}"
                    pattern="yyyy-MM-dd"/>
  </c:param>
</c:url>

<c:url var="aceGetWorkItems" value="http://localhost:8080/fasttime/proxy/">
  <c:param name="fct" value="getmyworkitems"/>
  <c:param name="format" value="JSON2"/>
  <c:param name="approvalstatus" value="0"/>
  <c:param name="TimesheetDateFrom">
    <fmt:formatDate value="${dateFrom.time}"
                    pattern="yyyy-MM-dd"/>
  </c:param>
  <c:param name="TimesheetDateTo">
    <fmt:formatDate value="${dateTo.time}"
                    pattern="yyyy-MM-dd"/>
  </c:param>
</c:url>

<c:url var="aceLogin" value="http://localhost:8080/fasttime/proxy/">
  <c:param name="fct" value="login"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON2"/>
</c:url>

<c:url var="aceGetProjects" value="http://localhost:8080/fasttime/proxy/">
  <c:param name="fct" value="getprojects"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON2"/>
  <c:param name="sortorder" value="project_name"/>
  <c:param name="AssignedOnly" value="true"/>
  <c:param name="UseShowHide" value="true"/>
</c:url>

<c:url var="aceGetTasks" value="http://localhost:8080/fasttime/proxy/">
  <c:param name="fct" value="gettasks"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON2"/>
</c:url>

<script type="text/javascript">
  /*      <![CDATA[ */

  aceLoginInfoUrl = '${aceLoginInfo}';
  aceGetWeeksUrl = '${aceGetWeeks}';
  aceGetWorkItemsUrl = '${aceGetWorkItems}';
  aceLoginUrl = '${aceLogin}';
  aceGetProjectsUrl = '${aceGetProjects}';
  aceGetTaskssUrl = '${aceGetTasks}';

  /*  new Date(new Date().setFullYear('2014', '01', '27'));
   alert(myDate.getYear + '-' + myDate.getMonth());*/

  /*      ]]> */
</script>
