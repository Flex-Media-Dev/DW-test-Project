<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NewsV2_cpl.aspx.vb" Inherits="Dynamicweb.Admin.NewsV2.NewsV2_cpl" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register Assembly="DynamicWeb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html>
<head>
    <title><%=Translate.JsTranslate("NewsV2")%></title>

    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <dwc:ScriptLib runat="server" ID="ScriptLib">
        <script type="text/javascript" src="/Admin/Content/JsLib/prototype-1.7.js"></script>
        <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
        <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>
    </dwc:ScriptLib>

    <script type="text/javascript" src="/admin/module/newsv2/js/main.js"></script>

    <script type="text/javascript">
        function onLoad() {
            document.getElementById('NewsRssCacheTime').setAttribute("onchange", "checkNewsRssCacheTime();");
        }

        function onSave() {
            if (checkNewsRssCacheTime()) {
                var elemForm = document.getElementById('<%=Form1.ClientID%>');
                if (elemForm != null) {
                    elemForm.submit();
                }
            }
        }

        function onSaveAndClose() {
            if (checkNewsRssCacheTime()) {
                var elemCheckBox = document.getElementById('<%=SaveAndClose.ClientID%>');
                if (elemCheckBox != null) {
                    elemCheckBox.checked = true;
                }

                var elemForm = document.getElementById('<%=Form1.ClientID%>');
                if (elemForm != null) {
                    elemForm.submit();
                }
            }
        }

        function checkNewsRssCacheTime() {
            dwGlobal.hideControlErrors("NewsRssCacheTime", "");
            if (!document.getElementById('NewsRssCacheTime').value || 0 === document.getElementById('NewsRssCacheTime').value.length) {
                return true;
            }

            var cacheTime = parseInt(document.getElementById('NewsRssCacheTime').value);
            if (isNaN(cacheTime)) {
                dwGlobal.showControlErrors("NewsRssCacheTime", "<%= Translate.Translate("Only numbers from 1 to 99") %>");
                document.getElementById('NewsRssCacheTime').focus();
                return false;
            } else if (cacheTime <= 0) {
                dwGlobal.showControlErrors("NewsRssCacheTime", "<%= Translate.Translate("Blocking period must be at least 1 min") %>");
                document.getElementById('NewsRssCacheTime').focus();
                return false;
            }
            return true;
        }
    </script>
</head>

<body class="area-blue" onload="onLoad();">
    <div class="dw8-container">
        <form id="Form1" name="Form1" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="NewsV2"></dwc:CardHeader>
                <dwc:CardBody runat="server">
                    <asp:CheckBox ID="SaveAndClose" runat="server" />

                    <dwc:GroupBox ID="GroupBoxStart1" runat="server" DoTranslation="true" Title="RSS Display Cache">                        
                        <dwc:InputText ID="NewsRssCacheTime" Label="Cached for" Info="minutes" runat="server" MaxLength="2" ValidationMessage="" />
                    </dwc:GroupBox>

                    <dwc:GroupBox ID="GroupBox1" runat="server" DoTranslation="true" Title="Autoarkivering">
                        <dwc:CheckBox runat="server" ID="MoveNewsToArchive" Label="Autoarkivering" />
                        <dwc:CheckBox runat="server" ID="SetValidUntilToNever" Label="Fjern udløbsdato" />
                        <dwc:InputText ID="SetValidDays" Label="Standard udløbsdato" runat="server" MaxLength="3" />
                    </dwc:GroupBox>

                    <dwc:GroupBox ID="GroupBox2" runat="server" DoTranslation="true" Title="Custom fields">
                        <dwc:Button runat="server" ID="cfGeneral" Name="cfGeneral" OnClick="main.openCustomFields();" Title="Edit custom fields" DoTranslate="true" />
                        <dwc:Button runat="server" ID="cfGroups" Name="cfGroups" OnClick="main.openCustomFieldsSpecific();" Title="Edit custom field groups" DoTranslate="true" />
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
        </form>

        <dwc:ActionBar runat="server">
            <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" KeyboardShortcut="ctrl+s" OnClientClick="onSave();" ID="cmdSave" ShowWait="true" WaitTimeout="1000">
            </dw:ToolbarButton>
            <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="onSaveAndClose();" ID="cmdSaveAndClose" ShowWait="true">
            </dw:ToolbarButton>
            <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="location='ControlPanel.aspx';" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
            </dw:ToolbarButton>
        </dwc:ActionBar>
    </div>    

    <% Translate.GetEditOnlineScript() %>
</body>
</html>
