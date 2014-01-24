<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="guid" value="${cookie.fasttime.value}"/>
<c:url var="aceSite" value="https://athabascau.aceproject.com">
  <c:param name="guid" value="${guid}"/>
</c:url>
<c:url var="aceLogout" value="https://athabascau.aceproject.com/Logout.asp"/>
<div id="sidebar">
  <div class="sidebar-content">
    <div id="identity">
    </div>
    <div id="news">
      <ul>
        <li><a href="${aceLogout}">Logout</a></li>
        <li><a href="${aceSite}">Ace Project Site</a></li>
        <li><a href="http://www.athabascau.ca/contact">Contact
          us</a></li>
      </ul>
    </div>

    <p class="fl-panel fl-note fl-bevel-white fl-font-size-80">
      <span style="color:red;">SECURITY NOTICE:</span>It is
      very important to log out of your AU account AND
      shutdown your browser after using AU web services,
      otherwise anyone with access to the browser could use
      your account.</p>
  </div>
</div>