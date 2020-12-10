<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Sms.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.Sms" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" IncludeScriptaculous="true"></dw:ControlResources>
    <script language="javascript" type="text/javascript">
        function save(cmd) {
            $('cmdSave').value = cmd;
            $('form1').submit();
        }

        function cancel() {
            window.location = "/Admin/Blank.aspx";
        }
    </script>
</head>

<body style="overflow: auto;" class="area-teal screen-container">
    <div class="card">
        <div class="card-header">
            <h2 class="subtitle"><%= Translate.Translate("Sms")%></h2>
        </div>

        <dw:Toolbar ID="toolbar" runat="server" ShowEnd="false">
            <dw:ToolbarButton runat="server" Text="Save" Icon="Save" OnClientClick="save('cmdSave');" ID="btnSave" ShowWait="true" />
            <dw:ToolbarButton runat="server" Text="Save And Close" Icon="Save" OnClientClick="save('cmdSaveAndClose');" ID="btnSaveAndClose" ShowWait="true" />
            <dw:ToolbarButton runat="server" Text="Cancel" Icon="TimesCircle" OnClientClick="cancel();" ID="btnCancel" ShowWait="true" />
        </dw:Toolbar>

        <form id="form1" runat="server">
            <input type="hidden" id="cmdSave" name="cmdSave" value="" />
            <div id="content" style="overflow: auto;">

                <dw:GroupBox ID="GroupBoxRecipientsList" runat="server" Title="Settings">
                    <table cellpadding="2" cellspacing="0">
                        <tr>
                            <td style="width: 170px">
                                <dw:TranslateLabel ID="GatewayEmailTitle" Text="Sms gateway" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="GatewayEmail" CssClass="std" />&nbsp;<small>Example: {0}.username@email2sms.dk</small>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 170px">
                                <dw:TranslateLabel ID="CopySmsToEmailTitle" Text="Copy sms to email address" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="CopySmsToEmail" CssClass="std" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>

            </div>
        </form>
    </div>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
