<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  response.setHeader("Access-Control-Allow-Origin", "*");
%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">

<c:set var="protocol" value="<%=request.getProtocol()%>"/>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Fast Time for Ace Project</title>
  <link type="text/css" rel="stylesheet"
        href="css/cas.css">
  <link href="css/ui-lightness/jquery-ui-1.10.4.custom.css" rel="stylesheet">

  <link rel="shortcut icon"
        href="${protocol}://www.athabascau.ca/globalIncludes/core/assets/ico/favicon.ico"
        type="image/x-icon">
  <script type="text/javascript"
          src="<c:url value="/js/jquery-2.0.3.js"/>"></script>
 	<script src="js/jquery-ui-1.10.4.custom.js" type="text/javascript"></script>
  <script type="text/javascript"
          src="<c:url value="/js/common.js"/>"></script>
  <script type="text/javascript"
          src="<c:url value="/js/aceio.js"/>"></script>
</head>

<body class="fl-theme-iphone">

<div id="cas">
  <div class="flc-screenNavigator-view-container">
    <div class="fl-screenNavigator-view">
      <div id="header" class="flc-screenNavigator-navbar fl-navbar fl-table">
        <h1 id="company-name">Athabasca University</h1>

        <div class="slogan">Focused on the future of Learning</div>
        <h1 id="app-name" class="fl-table-cell">Fast Time for Ace Project</h1>
      </div>
      <div id="content" class="fl-screenNavigator-scroll-container">
        <div>
          <jsp:include page="login.jsp"/>
          <jsp:include page="sidebar.jsp"/>
        </div>
        <div style="display: none;" id="work">
          <table class="debugtable border" id="time">
            <tr>
              <th>Status</th>
              <th>Project</th>
              <th>Task</th>
              <th>Work</th>
              <th>Notes</th>
            </tr>
          </table>
        </div>
        <div id="footer"
             class="fl-panel fl-note fl-bevel-white fl-font-size-80">


          <div id="copyright">
            <p>AU, Canada's <strong>Open University</strong>, is an
              internationally recognized leader in online and distance
              learning.</p>

            <p>
              <a href="http://www.athabascau.ca/contact">Contact AU</a> |
              <a href="http://www.athabascau.ca/privacy">Privacy Policy</a>
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%--  <script type="text/javascript"
            src="js/jquery.min.js"></script>
    <script type="text/javascript"
            src="js/jquery-ui.min.js"></script>--%>
</div>

<div id="loading" class="ui-state-highlight ui-corner-all">
  <p id="loading-message">
    Processing...
  </p>
  <img alt="Loading animated GIF" src="<c:url value="/images/ajax-loader.gif"/>"
       title="processing..."/>
</div>

</body>
</html>