<%@ taglib prefix="ht" tagdir="/WEB-INF/tags/ht" %>
<ht:script type="text/javascript" jquery="true" ready="true">
  log('started');
</ht:script>
<%--<ht:script type="text/javascript">
  jQuery('#login').click(
  function (event)
  {
    orosLog("form id %s", "${id}");
    orosLog("submit id %s", "${submit}");
    orosLog("%s", jQuery);
    var formData = $("#${id}").serialize() + "&submit=true";
    orosAjaxCall('${divSelector}', {
    ajaxUrl:dispatcherUrl,
    data:formData,<c:if test="${!empty(onErrorHide)}">
    onErrorHide: "${onErrorHide}",</c:if>
    onValidateSelector:'${onValidateSelector}'
    ${extraJQuery}
  });
  event.preventDefault();
</ht:script>--%>

<div class="box fl-panel" id="login">
  <form id="fm1" class="fm-v clearfix"
        method="post">

    <h2>Ace Project Login</h2>

    <p>
      <strong>Note:</strong> your username and password will
      not be stored on this site.
    </p>

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
      <input class="btn-submit" name="submit" accesskey="l"
             value="LOGIN" tabindex="4" type="submit">
      <input class="btn-reset" name="reset" accesskey="c"
             value="CLEAR" tabindex="5" type="reset">
    </div>
  </form>
</div>