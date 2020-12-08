<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EventViewerEmailNotification.aspx.vb" Inherits="Dynamicweb.Admin.EventViewerEmailNotification" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Event viewer details</title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerEmailNotification.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerEmailNotification.css" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <form id="MainForm" runat="server">
        <input type="hidden" id="cmdValue" name="cmdValue" value="" />
        <dw:Overlay ID="PleaseWait" runat="server" />
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Event viewer notification"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <dw:Toolbar runat="server">
                    <dw:ToolbarButton ID="DeleteButton" Text="Delete" Icon="Remove" OnClientClick="EventViewerEmailNotification.delete();" runat="server"></dw:ToolbarButton>
                </dw:Toolbar>

                <dwc:GroupBox runat="server" Title="General">
                    <dwc:InputText ID="ConfigurationName" Label="Name" runat="server" />
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Filter">
                    <dwc:SelectPicker ID="NotificationCategory" Label="Category" runat="server"></dwc:SelectPicker>
                    <dwc:CheckBoxGroup ID="NotificationLevel" Label="Notification levels" runat="server"></dwc:CheckBoxGroup>
                    <dwc:InputNumber ID="SendInterval" Label="Send interval" Info="Minimum minutes delay between each email notification." runat="server" />
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Recipients">
                    <dwc:SelectPicker ID="Destination" Label="Destination" runat="server" onchange="EventViewerEmailNotification.onChangeNotificationDestination();">
                        <asp:ListItem Selected="True" Text="Send email" Value="Email"></asp:ListItem>
                        <asp:ListItem Text="Health monitoring service" Value="MonitoringService"></asp:ListItem>
                    </dwc:SelectPicker>
                    <dwc:InputTextArea ID="NotifiedEmails" Label="Subscribed emails" Info="Email-addresses of people who should be notificed.<br />Valid separators: space, comma, semicolon, line break." runat="server" />
                    <dwc:InputText ID="NotificationUri" Label="Monitoring service uri" Info="Uri address of health monitoring service." runat="server" />
                </dwc:GroupBox>
            </dwc:CardBody>
            <dwc:CardFooter runat="server" />
        </dwc:Card>
    </form>
    <dwc:ActionBar runat="server">
        <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" OnClientClick="EventViewerEmailNotification.save();" ID="cmdSave" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="EventViewerEmailNotification.saveAndClose();" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="EventViewerEmailNotification.cancel();" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
    </dwc:ActionBar>
</body>
</html>
