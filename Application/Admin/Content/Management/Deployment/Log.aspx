<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Log.aspx.vb" Inherits="Dynamicweb.Admin.Log" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>Deployment log</title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="false" runat="server" IncludeUIStylesheet="true">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Management/Deployment/js/Log.min.js" />
        </Items>
    </dw:ControlResources>
</head>
<body class="area-black screen-container">
    <dwc:Card runat="server">
        <form id="form1" runat="server">
            <dwc:CardHeader runat="server" Title="Deployment Logs" />
            <dw:Overlay ID="forward" Message="Please wait" runat="server"></dw:Overlay>
            <dwc:CardBody runat="server">
                <div>
                    <dw:Toolbar runat="server" ID="JobSelect" ShowEnd="false">
                        <dw:ToolbarButton runat="server" ID="btnDeleteLogs" Text="Delete old logs" Icon="Delete" Translate="true" OnClientClick="DeleteLogs();" />
                    </dw:Toolbar>
                </div>
                <div id="jobs">
                    <input type="hidden" name="selectedJob" id="selectedJob" runat="server" />
                    <input type="hidden" name="action" id="action" runat="server" />
                    <dw:List ID="activityList" Title="Activities" AllowMultiSelect="true" Personalize="true" runat="server" ContextMenuID="activityListContextMenu">
                        <Columns>
                            <dw:ListColumn ID="clmName" Name="Name" runat="server" />
                            <dw:ListColumn ID="clmSource" Name="Source" runat="server" />
                            <dw:ListColumn ID="clmSourceUrl" Name="Source Url" runat="server" />
                            <dw:ListColumn ID="clmDestination" Name="Destination" runat="server" />
                            <dw:ListColumn ID="clmDestinationUrl" Name="Destination Url" runat="server" />
                            <dw:ListColumn ID="clmStatus" Name="Status" runat="server" Width="120" />
                        </Columns>
                    </dw:List>

                    <dw:ContextMenu runat="server" ID="activityListContextMenu" OnClientSelectView="OnSelectCtxView">
                        <dw:ContextMenuButton runat="server" ID="LogButton" Text="Log" Icon="InfoCircle">
                        </dw:ContextMenuButton>
                        <dw:ContextMenuButton runat="server" ID="DeleteActivityButton" Text="Delete" Icon="Remove" OnClientClick="DeleteActivity();">
                        </dw:ContextMenuButton>
                    </dw:ContextMenu>
                </div>
            </dwc:CardBody>

            <dw:Dialog Title="Delete activity" ID="DeleteActivityDialog" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="DeleteActivity();">
                Are you sure you want to delete the activity?
            </dw:Dialog>
        </form>
    </dwc:Card>
</body>
<%Translate.GetEditOnlineScript()%>
</html>

