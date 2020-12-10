<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LoadBalancingEmailNotificationEdit.aspx.vb" Inherits="Dynamicweb.Admin.LoadBalancingEmailNotificationEdit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Event viewer details</title>
    <dw:ControlResources runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function save(close) {
            if (close) {
                document.getElementById('cmdValue').value = "SaveAndClose";
            }
            document.getElementById('MainForm').submit();
        }

        function cancel() {
            location = '/Admin/Content/Management/Pages/LoadBalancing_cpl.aspx';
        }
    </script>
</head>
<body class="screen-container">
    <form id="MainForm" runat="server">
        <input type="hidden" id="cmdValue" name="cmdValue" value="" />
        <dw:Overlay ID="PleaseWait" runat="server" />
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Load balancing notification"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server" Title="General">
                    <dwc:CheckBox ID="NotificationsActive" Label="Active" Name="/Globalsettings/Settings/Clustering/NotificationsActive" runat="server" />
                    <dwc:InputTextArea ID="NotifiedEmails" Label="Subscribed emails" Name="/Globalsettings/Settings/Clustering/NotificationEmails" Info="Email-addresses of people who should be notificed.<br />Valid separators: space, comma, semicolon, line break." runat="server" />
                </dwc:GroupBox>
            </dwc:CardBody>
            <dwc:CardFooter runat="server" />
        </dwc:Card>
    </form>

    <dwc:ActionBar runat="server">
        <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" OnClientClick="save();" ID="cmdSave" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="save(true);" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="cancel();" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
    </dwc:ActionBar>
</body>
</html>
