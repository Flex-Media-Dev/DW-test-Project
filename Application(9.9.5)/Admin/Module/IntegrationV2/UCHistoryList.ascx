<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UCHistoryList.ascx.vb" Inherits="Dynamicweb.Admin.UCHistoryList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<input type="hidden" name="jobName" id="jobName" value="<%=Request("jobName")%>" />
<input type="hidden" name="opType" id="opType" value="1" />
<input type="hidden" name="tabActive" id="tabActive" value="<%=Request("tabActive")%>" />

<dw:Toolbar ID="historyListBar" runat="server" ShowStart="False" ShowEnd="False">
    <dw:ToolbarButton ID="historyBarOkButton" runat="server" Text="OK" OnClientClick="GotoToList();" Icon="Check">
    </dw:ToolbarButton>
    <dw:ToolbarButton ID="historyBarReconfBtn" runat="server" Text="Reconfigure" OnClientClick="GotoToConfig();" Icon="cog">
    </dw:ToolbarButton>
</dw:Toolbar>
<dw:TabHeader ID="logTabs" ReturnWhat="all" runat="server" Tabs="Last" Visible ="false" />

<div id="refreshArea">
    <input type="hidden" id="continueRefresh" runat="server" value="true" />
    <div id="Tab1">
        <div style="padding: 5px 8px;" id="stateRunning" runat="server" visible="true"><i class="fa fa-refresh fa-spin size-3x"></i> <dw:TranslateLabel Text="Running" runat="server" /></div>
        <div style="padding: 5px 8px;" id="stateCompleted" runat="server" visible="false"><i class="fa  fa-check color-success size-3x"></i> <dw:TranslateLabel Text="Completed" runat="server" /></div>
        <div style="padding: 5px 8px;" id="stateFailed" runat="server" visible="false"><i class="fa fa-times-circle color-danger size-3x"></i> <dw:TranslateLabel Text="Failed" runat="server" /> (<span id="failText" runat="server"></span>)</div>
        <dw:List ID="lastCtrl" runat="server" ShowTitle="False" TranslateTitle="False" PageSize="100" UseCountForPaging="true" HandlePagingManually="true">
            <Columns>
                <dw:ListColumn ID="clmIcon" runat="server" Name="" EnableSorting="false" Width="25"></dw:ListColumn>
                <dw:ListColumn ID="clmLastTime" runat="server" Name="Time" EnableSorting="True" Width="170"></dw:ListColumn>
                <dw:ListColumn ID="clmLastMessage" runat="server" Name="Message" WidthPercent="100"></dw:ListColumn>
            </Columns>
        </dw:List>
    </div>
    <div id="Tab2" style="display: none;">
        <dw:List ID="historyCtrl" runat="server" ShowTitle="False" TranslateTitle="False" PageSize="100" UseCountForPaging="true" HandlePagingManually="true">
            <Columns>
                <dw:ListColumn ID="ListColumn1" runat="server" Name="" EnableSorting="false" Width="25"></dw:ListColumn>
                <dw:ListColumn ID="clmHistoryTime" runat="server" Name="Time" EnableSorting="True" Width="170"></dw:ListColumn>
                <dw:ListColumn ID="clmHistoryMessage" runat="server" Name="Message"></dw:ListColumn>
            </Columns>
        </dw:List>
    </div>
    <dw:Infobar runat="server" Visible="false" ID="logFilesWarning" TranslateMessage="true" UseInlineStyles="true" Message="Showing the 5 newest logs. Older logs can be found in the file archive"></dw:Infobar>
</div>
<%If Request("logType") = "live" Then%>
<script type="text/javascript">
    //This JS refreshes the logging information until the logfile is finished, at which point the loop is terminated.
    var refreshIntervalId = null;
    function stopEndlessLoop(doc) {
        if (doc.getElementById("continueRefresh").value == "false" && refreshIntervalId !== null) {
            clearInterval(refreshIntervalId);
        }
    }
    if (document.getElementById("continueRefresh").value == "true") {
        refreshIntervalId = setInterval(function () {
            reloadElement("refreshArea", stopEndlessLoop);
        }, 2000);
    }
</script>
<%End If%>