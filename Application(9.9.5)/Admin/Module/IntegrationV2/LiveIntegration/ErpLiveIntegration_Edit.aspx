<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ErpLiveIntegration_Edit.aspx.vb" Inherits="Dynamicweb.Admin.ErpLiveIntegration_Edit" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Live Integration Add-ins</title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludePrototype="true" IncludeUIStylesheet="true" />
    <script type="text/javascript">
        function redirectToSettingsPage(typeName) {
            var url = '/Admin/Module/IntegrationV2/LiveIntegration/LiveIntegrationAddInSettings.aspx';
            if (typeName != null) {
                url += '?addInFullName=' + typeName;
            }
            window.location.href = url;
        }
        function showLogs(url) {
            dialog.show("HistoryLogDialog", url);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    
        <dw:List ID="addInList" Title="Live Integration Add-Ins list" AllowMultiSelect="false" TranslateTitle="True" runat="server">
            <Columns>
                <dw:ListColumn ID="addInName" Name="Add-In Name" runat="server" Width="200" />
                <dw:ListColumn ID="addInType" Name="Add-In Label" runat="server" Width="200" />                    
            </Columns>
        </dw:List>
        <dw:ContextMenu ID="addInListContextMenu" runat="server">
            <dw:ContextMenuButton runat="server" ID="addInLogButton" Text="Show log" Icon="EventNote"></dw:ContextMenuButton>
            <dw:ContextMenuButton runat="server" ID="addInDownloadLogButton" Text="Download log" Icon="Download"></dw:ContextMenuButton>
        </dw:ContextMenu>
        <dw:Dialog ID="HistoryLogDialog" runat="server" Title="Live Integration add-in log" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" >
            <iframe id="HistoryLogDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>
        <% 
            Translate.GetEditOnlineScript()
        %>
    </form>
</body>
</html>
