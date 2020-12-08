<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DestinationListEdit.aspx.vb" Inherits="Dynamicweb.Admin.DestinationListEdit" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit destination</title>
    <dw:ControlResources CombineOutput="False" IncludePrototype="false" runat="server">
        <Items>
            <dw:GenericResource Url="js/DestinationList.js" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <dwc:Card ID="editArea" runat="server">
        <dwc:CardHeader ID="editAreaHeader" Title="Edit destination" runat="server"></dwc:CardHeader>
        <dw:GroupBox ID="editAreaBody" runat="server">
            <form id="editForm" runat="server" method="post">
                <dwc:InputText ID="destinationName" name="destinationName" label="Name" runat="server" />
                <dwc:InputText ID="destinationUrl" name="destinationUrl" label="Url" Info="http://www.example.com" runat="server" />
                <dw:GroupBox Title="Remote administrator user" runat="server">
                    <dwc:InputText ID="destinationUsername" name="destinationUsername" label="Username" runat="server" />
                    <dwc:InputText ID="destinationPassword" name="destinationPassword" Password="true" label="Password" runat="server" />
                </dw:GroupBox>
                <button onclick="verifyConnectionClick();return false;" class="btn" style="margin-left:180px">Test connection</button>&nbsp;&nbsp;<span id="verifyconnectionresult"></span>
            </form>
        </dw:GroupBox>
    </dwc:Card>
    <dwc:ActionBar ID="actionBar" runat="server">
        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500" OnClientClick="document.getElementById('editForm').submit();">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="location.href='DestinationList.aspx';" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
    </dwc:ActionBar>
    <dw:Overlay ID="destinationOverlay" Message="Testing connection..." runat="server"></dw:Overlay>
</body>
</html>
<% Translate.GetEditOnlineScript() %>