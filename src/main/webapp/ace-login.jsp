<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:url var="aceLoginInfo" value="/proxy/">
  <c:param name="fct" value="getlogininfo"/>
  <c:param name="format" value="JSON"/>
</c:url>

<c:url var="aceLogin" value="/proxy/">
  <c:param name="fct" value="login"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON"/>
</c:url>


<%-- CRITICAL use cookie login info --%>

<script type="text/javascript">
  /*      <![CDATA[ */

  (function ($)
  {
    $(document).ready(function ()
    {

      var guid = getCookie("fasttime");
      log("Ace GUID: %s", guid);
      if (guid !== undefined && guid.length == 36)
      {
        $.ajax({
          url: '${aceLoginInfo}',
          type: 'get',
          dataType: 'json',
          data: 'guid=' + guid,
          success: function (page, status, jqXHR)
          {
             aceLogin(page, status, jqXHR);
          },
          error: function (page, status, jqXHR)
          {
            aceIOError(page, status, jqXHR);
          }
        });
      }

      $('#login-submit').unbind('click.login').bind('click.login',
        function (event)
        {
          log('submit clicked');
          $('#msg').replaceWith('<div id="msg"></div>');
          var formData = $("#fm1").serialize();
          log('Form Data: %s', formData);
          $.ajax({
            url: '${aceLogin}',
            type: 'post',
            dataType: 'json',
            data: formData,
            success: function (page, status, jqXHR)
            {
              aceLogin(page, status, jqXHR);
            },
            error: function (page, status, jqXHR)
            {
              aceIOError(page, status, jqXHR);
            }
          });
          event.preventDefault();
        });
    });

  }(jQuery));
  /*      ]]> */
</script>