<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="Overview.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Experiments.Overview" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Split tests" />
        <dw:List ID="lstExperiments" runat="server" ShowTitle="false" ShowPaging="true" PageSize="25">
                <Columns>
                    <dw:ListColumn ID="PageIcon" EnableSorting="false" runat="server" HeaderAlign="Center" ItemAlign="Center" Width="25"> </dw:ListColumn>
                    <dw:ListColumn ID="ExperimentNameColumn" EnableSorting="true" runat="server" Name="Split tests name"></dw:ListColumn>
                    <dw:ListColumn ID="PageColumn" EnableSorting="true" runat="server" Name="Page"></dw:ListColumn>
                    <dw:ListColumn ID="WebsiteColumn" EnableSorting="true" runat="server" Name="Website"></dw:ListColumn>
                    <dw:ListColumn ID="TypeColumn" EnableSorting="true" runat="server" Name="Type"></dw:ListColumn>
                    <dw:ListColumn ID="ScheduledTypeColumn" EnableSorting="true" runat="server" Name="Scheduled type"></dw:ListColumn>
                    <dw:ListColumn ID="GoalColumn" EnableSorting="true" runat="server" Name="Goal"></dw:ListColumn>
                    <dw:ListColumn ID="StateColumn" EnableSorting="true" runat="server" Name="State"></dw:ListColumn>
                    <dw:ListColumn ID="VewReportColumn" runat="server" Name="View Report"></dw:ListColumn>
                </Columns>
        </dw:List>

        <dw:Dialog ID="OMCExperimentDialog" runat="server" Width="750" ShowOkButton="false" ShowCancelButton="false" Title="Setup split test">
            <iframe id="OMCExperimentDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>         
    </dwc:Card>
</asp:Content>

<asp:Content ContentPlaceHolderID="FooterContext" runat="server">
    <dw:Contextmenu ID="ExperimentListContext" runat="server" OnClientSelectView="menuActions.contextMenuView">
		<dw:ContextmenuButton ID="cmdExperimentStart" runat="server" Divide="None" Icon="Play" Text="Start" Views="start_exp"  OnClientClick="OMCExperimentStart(ContextMenu.callingItemID);" />
		<dw:ContextmenuButton ID="cmdExperimentPause" runat="server" Divide="None" Icon="Pause" Text="Pause" Views="pause_exp" OnClientClick="OMCExperimentPause(ContextMenu.callingItemID);" />
		<dw:ContextmenuButton ID="cmdExperimentStop" runat="server" Divide="None" Icon="Stop" Text="Stop and conclude" Views="pause_exp,start_exp" OnClientClick="OMCExperimentDelete(ContextMenu.callingItemID);" />
		<dw:ContextmenuButton ID="cmdExperimentViewReport" runat="server" Divide="Before" Icon="LineChart" Text="View report" Views="pause_exp,start_exp" OnClientClick="OMCExperimentReport(ContextMenu.callingItemID);" />
	</dw:Contextmenu>
</asp:Content>