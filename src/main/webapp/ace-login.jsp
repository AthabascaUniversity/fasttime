<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:url var="aceLoginInfo" value="/proxy/">
  <c:param name="fct" value="getlogininfo"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON"/>
</c:url>

<c:url var="aceLogin" value="/proxy/">
  <c:param name="fct" value="login"/>
  <c:param name="accountid" value="athabascau"/>
  <c:param name="format" value="JSON"/>
</c:url>

<script type="text/javascript">
  /*      <![CDATA[ */

  (function ($)
  {

    $(document).ready(function ()
    {
      $('#login-submit').unbind('click.login').bind('click.login',
        function (event)
        {
          log('submit clicked');
          jQuery('#msg').replaceWith('<div id="msg"></div>');
          var formData = $("#fm1").serialize();
          log('Form Data: %s', formData);
          $.ajax({
            url: '${aceLogin}',
            type: 'post',
            dataType: 'json',
            data: formData,
            success: function (page, status, jqXHR)
            {
              log('succes: %o', page);
              if ('ok' == page.status)
              {
                loginInfo = page.results[0];
                jQuery('#identity').replaceWith('<div id="identity">Welcome ' +
                  loginInfo.FIRST_NAME + ' ' + loginInfo.LAST_NAME +
                  '</div>');
                document.cookie="fasttime=" + loginInfo.GUID + "; path=/fasttime";
                jQuery('#login').hide();
              }
              else
              {
                jQuery('#msg').replaceWith('' +
                  '<div id="msg" class="errors" style="background-color: rgb(255, 238, 221);">' +
                  page.results[0].ERRORDESCRIPTION +
                  '</div>');
              }
            },
            error: function (page, status, jqXHR)
            {
              log('error: %o, %o', page, jqXHR);
              jQuery('#msg').replaceWith('' +
                '<div id="msg" class="errors" style="background-color: rgb(255, 238, 221);">' +
                '<p>An error occurred communicating with ace project.  ' +
                'Please use ace project directly, and try again later.</p> ' +
              '</div>');
            }
          });
          event.preventDefault();
        });
    });

  }(jQuery));
  /*      ]]> */
</script>