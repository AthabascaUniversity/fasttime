<%@ page import="org.json.simple.JSONObject" %>
  <%@page isErrorPage="true" %>
  <%@page contentType="application/json; charset=UTF-8" %>

  <%
      final JSONObject jsonObject = new JSONObject();
      jsonObject.put("message", exception.getMessage());
      jsonObject.put("exception", exception.toString());

  %>
  <%=jsonObject.toJSONString()%>