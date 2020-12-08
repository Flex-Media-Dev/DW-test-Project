<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Deployment.aspx.vb" Inherits="Dynamicweb.Admin.Deployment" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Deployment</title>
    <dwc:ScriptLib runat="server"></dwc:ScriptLib>
    <script type="text/javascript" src="js/Deployment.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Dialog/Dialog.js"></script>    
    <style>
        .comparison {
            width:100%;
        }
        .comparison > ul {
            padding:0;
        }
        .comparison li {
            list-style-type: none;
        }        
        .comparison td i {
            margin-right:10px;
        }
        .comparison-summary {
            margin: 10px 0 10px 180px;
            border: 1px solid #9e9e9e;
        }
        .comparison-summary th, .comparison-summary td {
            padding: 10px;
        }
        .comparison-summary th {
            text-align:left;
        }
        .comparison-summary th i {
            margin-right:10px;
        }
        .comparison-summary td {
            text-align:right;
        }
        .comparison-status {
            width: 25px;
        }
        .comparison-details {
            width: 70px;
        }
    </style>
</head>
<body>
    <form id="dataGroupForm" runat="server" enableviewstate="false">
        <div class="screen-container">
            <input type="hidden" id="deploymentAction" name="deploymentAction" runat="server" />
            <input type="hidden" id="dataGroupId" name="dataGroupId" runat="server" />
            <input type="hidden" id="destinationId" name="destinationId" runat="server" />
            <input type="hidden" id="exportDefaultName" name="exportDefaultName" runat="server" />
            <dwc:Card ID="output" runat="server">
                <dwc:CardHeader Title="Deployment" runat="server"></dwc:CardHeader>
                <dw:Toolbar ID="toolbar1" runat="server" ShowAsRibbon="true">
                    <dw:ToolbarButton runat="server" Text="Transfer selected" ID="cmdTransfer" Icon="Exchange" OnClientClick="TransferButtonClicked();" Disabled="true" ShowWait="true">
                    </dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Text="Export selected" ID="cmdExport" Icon="Exchange" OnClientClick="ExportButtonClicked();" Disabled="true">
                    </dw:ToolbarButton>
                </dw:Toolbar>
                <dw:GroupBox runat="server">
                    <dw:Infobar ID="destinationInfobar" runat="server" Type="Warning" Message="" TranslateMessage="False" Visible="false" />
                    <dwc:InputText ID="destinationName" Name="destinationName" runat="server" Label="Selected destination" Value="" Disabled="true"></dwc:InputText>
                    <dwc:CheckBoxGroup ID="DataItemFilters" Label="Filters" runat="server" OnClick="filterDataGroupsClicked(this);"></dwc:CheckBoxGroup>
                </dw:GroupBox>
            </dwc:Card>
        </div>
        <dwc:ActionBar ID="actionbar1" runat="server">
            <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" ID="cmdCancel" ShowWait="true" WaitTimeout="500" OnClientClick="Cancel();">
            </dw:ToolbarButton>
        </dwc:ActionBar>

        <dw:Dialog ID="ExportPackageDialog" Title="Export selected" Size="Medium"  OkAction="exportSelected();" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" runat="server">
            <dwc:GroupBox runat="server">
                <div class="form-group">
	                <label class="control-label"><dw:TranslateLabel runat="server" Text="Folder" /></label>                        
                    <dw:FolderManager ID="exportFolder" Name="exportFolder" Folder="/System/Deployment/Packages" runat="server" />
	            </div>
                <dwc:InputText runat="server" Label="Package name" ID="packageName" />
            </dwc:GroupBox>
        </dw:Dialog>
    </form>
    <dw:Dialog ID="ComparisonDetailsDialog" Title="Comparison" Size="Large" HidePadding="true" ShowOkButton="true" ShowCancelButton="false" ShowClose="true" runat="server">
        <iframe id="ComparisonDetailsDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>
    <dw:Overlay ID="deploymentOverlay" runat="server"></dw:Overlay>
</body>
</html>
<%Translate.GetEditOnlineScript()%>