<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DeploymentConfiguration.aspx.vb" Inherits="Dynamicweb.Admin.DeploymentConfiguration" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <dwc:ScriptLib runat="server"></dwc:ScriptLib>
    <title>Deployment configuration</title>
    <script type="text/javascript" src="js/Deployment.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
</head>
<body>
    <form id="dataGroupForm" action="Deployment.aspx" method="post" enableviewstate="false">
        <div class="screen-container">
            <input type="hidden" id="deploymentAction" name="deploymentAction" runat="server" />
            <input type="hidden" id="dataGroupId" name="dataGroupId" runat="server" />
            <dwc:Card ID="output" runat="server">
                <dwc:CardHeader Title="Deployment" runat="server"></dwc:CardHeader>
                <dw:Toolbar ID="toolbar1" runat="server" ShowAsRibbon="true">
                    <dw:ToolbarButton runat="server" Text="Compare selected" ID="cmdCompareSelected" Icon="Compare" OnClientClick="CompareButtonClicked();" ShowWait="true">
                    </dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Text="Select and continue" ID="cmdSelected" Icon="List" OnClientClick="SelectButtonClicked();" ShowWait="true" Divide="After">
                    </dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Text="Add data group" ID="cmdAddDataGroup" Icon="Wrench" ShowWait="true" WaitTimeout="500">
                    </dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Text="Edit data group" ID="cmdEditDataGroup" Icon="Edit" ShowWait="true" WaitTimeout="500">
                    </dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Text="Delete" ID="cmdDeleteDataGroup" Icon="Delete" ShowWait="true" WaitTimeout="500">
                    </dw:ToolbarButton>
                </dw:Toolbar>
                <dw:GroupBox ID="GroupOne" runat="server">
                    <dw:Infobar ID="destinationInfobar" runat="server" Type="Warning" Message="" Visible="false" />
                    <dwc:SelectPicker ID="destinationSelector" Name="destinationId" runat="server" Label="Selected destination"></dwc:SelectPicker>
                </dw:GroupBox>
            </dwc:Card>
        </div>
    </form>
</body>
</html>
