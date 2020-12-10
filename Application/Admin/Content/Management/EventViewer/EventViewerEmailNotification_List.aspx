<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EventViewerEmailNotification_List.aspx.vb" Inherits="Dynamicweb.Admin.EventViewerEmailNotification_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head>
    <title>Notification configurations</title>
    <dw:ControlResources runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerEmailNotification_List.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function help() {
            <%=Gui.HelpPopup("", "modules.eventviewer.notifications") %>
        }

        EventViewerEmailNotificationList.terminology.ConfirmDelete = '<%= Translate.Translate("Do you want to delete?") %>';
</script>
</head>
<body class="screen-container">
    <form id="MainForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Event viewer notifications" />
            <dw:Toolbar runat="server">
                <dw:ToolbarButton ID="AddNotificationButton" OnClientClick="EventViewerEmailNotificationList.edit();" Text="Add notification" Icon="PlusSquare" runat="server" />
                <dw:ToolbarButton ID="HelpButton" OnClientClick="help();" Text="Help" Icon="Help" runat="server" />
            </dw:Toolbar>

            <dw:List ID="EmailNotifications" ShowTitle="false" NoItemsMessage="No configurations found" ShowPaging="true" PageSize="25" AllowMultiSelect="false" HandleSortingManually="false" runat="server">
                <Columns>
                    <dw:ListColumn Name="Name" EnableSorting="true" runat="server" />
                    <dw:ListColumn Name="Recipient/Service URL" EnableSorting="true" runat="server" />
                    <dw:ListColumn Name="Category/Action" EnableSorting="true" runat="server" />
                </Columns>
            </dw:List>
        </dwc:Card>
    </form>
</body>
</html>
