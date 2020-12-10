<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EmailPersonalization.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.EmailPersonalization" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Email Personalization</title>
    <dw:ControlResources runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/OMC/js/EmailPersonalization.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/css/EmailPersonalization.css" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Overlay/Overlay.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        if (parent) {
            parent.dialog.set_okButtonOnclick('OMCPersonalizationDialog', function () {
                Dynamicweb.Page.Personalization.get_current().saveSegments();
            });
        }
    </script>
</head>
<body class="area-blue">
    <div class="dw8-container">

        <form id="MainForm" runat="server">
            <dwc:Card runat="server" ID="card">
                <dw:Toolbar runat="server" ShowEnd="false" ShowStart="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdAddSection" runat="server" Divide="None" Icon="PlusSquare" OnClientClick="Dynamicweb.Page.Personalization.get_current().addSegment();" Text="Add segment" />
                    <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="Help" Text="Help" OnClientClick="Dynamicweb.Page.Personalization.get_current().help();" />
                </dw:Toolbar>

                <dw:List runat="server" ID="SegmentList" ShowTitle="false" PageSize="1000" Height="400" Width="780">
                </dw:List>

                <dw:ContextMenu ID="SegmentContextMenu" runat="server">
                    <dw:ContextMenuButton ID="cmdSelectAll" Icon="Check" Text="Select all" runat="server" OnClientClick="Dynamicweb.Page.Personalization.get_current().selectSegment(ContextMenu.callingID);" />
                    <dw:ContextMenuButton ID="cmdDeselectAll" Icon="Close" Text="Deselect all" runat="server" OnClientClick="Dynamicweb.Page.Personalization.get_current().deselectSegment(ContextMenu.callingID);" />
                    <dw:ContextMenuButton ID="cmdDeleteSegment" Icon="Remove" Divide="Before" Text="Delete segment" runat="server" OnClientClick="Dynamicweb.Page.Personalization.get_current().delSegment(ContextMenu.callingID);" />
                </dw:ContextMenu>
                <dw:Overlay runat="server" ID="__ribbonOverlay"></dw:Overlay>
            </dwc:Card>
        </form>

        <%Translate.GetEditOnlineScript()%>
    </div>

</body>
</html>
