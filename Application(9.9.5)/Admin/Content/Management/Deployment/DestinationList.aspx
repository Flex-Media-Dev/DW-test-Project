<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DestinationList.aspx.vb" Inherits="Dynamicweb.Admin.DestinationList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Deployment Setup</title>
    <dw:ControlResources CombineOutput="False" IncludePrototype="false" runat="server">
        <Items>
            <dw:GenericResource Url="js/DestinationList.min.js" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Destinations" />
        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
            <dw:ToolbarButton runat="server" ID="addUrlInfoButton" Divide="None" Icon="PlusSquare" Text="Add" OnClientClick="createDestination(); return false;" />
        </dw:Toolbar>
        <dwc:CardBody runat="server">
            <dw:List ID="DeploymentDestinationList" ShowPaging="false" NoItemsMessage="No deployment destinations configured" ShowTitle="false" ShowCollapseButton="false" runat="server">
                <Columns>
                    <dw:ListColumn Name="Name" runat="server" />
                    <dw:ListColumn Name="Url" runat="server" />
                </Columns>
            </dw:List>
        </dwc:CardBody>
    </dwc:Card>

    <dw:ContextMenu ID="cmItem" runat="server">
        <dw:ContextMenuButton ID="cmiEdit" Views="common" Icon="Pencil" Text="Edit" OnClientClick="editDestination(); return false;" runat="server" />
        <dw:ContextMenuButton ID="cmiDelete" Views="common" Icon="Delete" Text="Delete" Divide="Before" OnClientClick="showDelete(); return false;" runat="server" />
    </dw:ContextMenu>

    <dw:Dialog ID="confirmDeleteDialog" runat="server" Title="Bekræft" OkAction="deleteDestination();" ShowOkButton="true" ShowCancelButton="true" Width="300">
        <dw:Infobar runat="server" Message="Selected destination will be removed." Type="Warning"></dw:Infobar>
        <div><%=Translate.JsTranslate("Are you sure you want to delete") %> <span id="warningMessageUrl"></span>?</div>
    </dw:Dialog>
</body>
</html>
<% Translate.GetEditOnlineScript() %>