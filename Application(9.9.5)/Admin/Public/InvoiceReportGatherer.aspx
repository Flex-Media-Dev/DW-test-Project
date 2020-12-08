<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="HostHeaders_cpl.aspx.vb" Inherits="Dynamicweb.Admin.InvoiceReportGatherer" %>
<%@ Register TagPrefix="management" TagName="ImpersonationDialog" Src="/Admin/Content/Management/ImpersonationDialog/ImpersonationDialog.ascx" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<!DOCTYPE html>

<html>
    <head id="Head1" runat="server">
        <title>Catillo Report Gatherer</title>
        <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" IncludeScriptaculous="true"></dw:ControlResources>
    </head>
    <script type="text/javascript">
        (function worker() {
            new Ajax.Request('/Admin/Public/InvoiceReportGatherer.aspx?status=' + Math.random(), {
                method: 'get',
                onSuccess: function (data) {
                    if (data.responseText != '') {
                        $('progress').insert({ after: data.responseText + '<br>' });
                    }
                },
                onComplete: function () {
                    // Schedule the next request when the current one's complete
                    setTimeout(worker, 1000);
                }
            });
        })();

        function DoPostbackWithMode(mode) {
            $('credentialsMode').setValue(mode)
            $('form1').request({
                onComplete: function () {
                    $('progress').insert({ after: 'Started <br>' });
                }
            })
        };
        
	</script>
    <body>
        <form id="form1" runat="server">
        <div>
            <asp:Label ID="lblResult" runat="server" Text="Click the button to gather the reports"></asp:Label>
        </div>
        <div>
            Name: <input type="text" name="txtName" /><br/>
            Password: <input type="text" name="txtPassword" /><br/>
            Domain: <input type="text" name="txtDomain" /><br/>
        </div>
        <div>
            <input type="hidden" name="credentialsMode" id="credentialsMode" value="unknown"/>
            <input type="button" id="btnHostnordic"  value="Using Hosting credentials" onclick="DoPostbackWithMode('Hostnordic');" />
            <input type="button" id="btnBackend" value="Using Backend Credentials" onclick="DoPostbackWithMode('Backend');" />
            <input type="button" id="btnCustom"  value="Using Custom Credentials" onclick="DoPostbackWithMode('Custom');" />
        </div>
        </form>
        <div id="progress" ></div>
    </body>
</html>
