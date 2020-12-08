<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RequestHelper.aspx.vb" Inherits="Dynamicweb.Admin.RequestHelper" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.eCommerce.UserPermissions" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><%=Translate.JsTranslate("Request Helper")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" />

    <script type="text/javascript">
        var id = <%=itemId %>;
    
        function ajaxLoader(url,divId) {
            new Ajax.Updater(divId, url, {
                asynchronous: false, 
                evalScripts: true,
                method: 'get',
                
                onSuccess: function(request) {
                    $(divId).update(request.responseText)
                }
            });
        }

        function ok() {
            var reqString = "@" + $("ddlSelect").value + '("' + $("var_name").value + '")';
            opener.recieveValuesFromHelper(id, reqString);
            window.close();
        }
        
        function cancel() {
            window.close();
        }
        
        function showInfoPane() {
            ajaxLoader("RequestHelper.aspx?AJAXCMD=INFO&type=" + $("ddlSelect").value, infoPane);
        }
    </script>
</head>
<body class="edit">
    <form id="form1" runat="server">
        <div>
            <dwc:GroupBox Title="Request/Session" runat="server" DoTranslation="true">
                <div id="builder"></div>
            </dwc:GroupBox>

            <div style="text-align: right; padding-right: 5px;">
                <input type="button" onclick="ok();" value="<%=Translate.jstranslate("Ok") %>" />
                <input type="button" onclick="cancel();" value="<%=Translate.jstranslate("Cancel") %>" />
            </div>
        </div>

        <div style="margin-top: 20px; float: none;">
            <dwc:GroupBox Title="Info" runat="server" DoTranslation="true">
                <div id="infoPane"></div>
            </dwc:GroupBox>
        </div>
    </form>

    <script type="text/javascript">
        ajaxLoader("RequestHelper.aspx?AJAXCMD=BUILDER&value=<%=value %>", builder)
        $("ddlSelect").onchange();
    </script>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
