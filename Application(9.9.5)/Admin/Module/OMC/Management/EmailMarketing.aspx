<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EmailMarketing.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.EmailMarketing" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
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
            <h2 class="subtitle"><%= Translate.Translate("Email Marketing")%></h2>
        </div>

        <dw:Toolbar ID="toolbar" runat="server" ShowEnd="false">
            <dw:ToolbarButton runat="server" Text="Save" Icon="Save" OnClientClick="save('cmdSave');" ID="btnSave" ShowWait="true" />
            <dw:ToolbarButton runat="server" Text="Save And Close" Icon="Save" OnClientClick="save('cmdSaveAndClose');" ID="btnSaveAndClose" ShowWait="true" />
            <dw:ToolbarButton runat="server" Text="Cancel" Icon="TimesCircle" OnClientClick="cancel();" ID="btnCancel" ShowWait="true" />
        </dw:Toolbar>

        <form id="form1" runat="server">
            <input type="hidden" id="cmdSave" name="cmdSave" value="" />
            <div id="content" style="overflow: auto;">
                <dw:GroupBox runat="server" Title="Email sending" DoTranslation="true">
                    <dwc:InputNumber ID="SendingTimeout" Label="Sending time-out" Info="minutes" runat="server" Max="99999" />
                </dw:GroupBox>
                <dw:GroupBox ID="GroupBoxRecipientsList" runat="server" Title="Settings for recipient list in statistics">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="RecipientsListMaxCountTitle" Text="Count" runat="server" />
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="RecipientsListMaxCount" CssClass="std" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="RecipientsListDefaultSortTitle" Text="Sort by" runat="server" />
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="RecipientsListDefaultSort" CssClass="std" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <dwc:CheckBox runat="server" ID="EnableEmailNameField" Label ="Enable &quot;Email name&quot; field" Indent="false" />
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
