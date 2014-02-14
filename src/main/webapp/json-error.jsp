<%@ page import="org.json.simple.JSONObject" %>
  <%@page isErrorPage="true" %>
  <%
  response.setHeader("Warning", exception.toString());
  %>