<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<ht:script type="text/javascript" jquery="true" ready="true">
  log('started');
</ht:script>

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

      log('registering click');
      $('#login-submit').unbind('click.login').bind('click.login',
        function (event)
        {
          log('suabmit clicked');
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

<div class="box fl-panel" id="login">
  <form id="fm1" class="fm-v clearfix"
        method="post">

    <h2>Ace Project Login</h2>
    <p>
      <strong>Note:</strong> your username and password will
      not be stored on this site.
    </p>

    <%-- The following is for error messages--%>
    <div id="msg"></div>

    <div class="row fl-controls-left">
      <label for="username" class="fl-label">
        <span class="accesskey">U</span>ser ID:</label>
      <input id="username" name="username" class="required"
             tabindex="1" accesskey="u" type="text" value=""
             size="25">

    </div>
    <div class="row fl-controls-left">
      <label for="password" class="fl-label"><span
        class="accesskey">P</span>assword:</label>


      <input id="password" name="password" class="required"
             tabindex="2" accesskey="p" type="password"
             value="" size="25">
    </div>

    <div class="row btn-row">
      <input class="btn-submit" id="login-submit" name="submit" accesskey="l"
             value="LOGIN" tabindex="4" type="submit">
      <input class="btn-reset" name="reset" accesskey="c"
             value="CLEAR" tabindex="5" type="reset">
    </div>
  </form>
</div>