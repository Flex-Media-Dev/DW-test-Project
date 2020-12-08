<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="EmailsList.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.EmailsList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>


<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="../js/marketing-common.js"></script>
    <script src="../js/EmailList.js"></script>
    <script>
        function showHelp() {
            <%=Gui.Help("omc.email.list", "omc.email.list")%>
        }
    </script>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
            <dw:ToolbarButton ID="cmdCopy" Icon="Copy" Text="Copy" runat="server" Disabled="true" OnClientClick="currentPage.copyEmail();" />
            <dw:ToolbarButton ID="cmdMove" Icon="ArrowRight" Text="Move" runat="server" Disabled="true" Visible="false" OnClientClick="currentPage.moveEmail();" />
            <dw:ToolbarButton ID="cmdDelete" Icon="Delete" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.confirmDeleteEmail();" />
            <dw:ToolbarButton ID="cmdHelp" Icon="Help" Text="Help" OnClientClick="currentPage.help();" runat="server" Divide="Before" />
        </dw:Toolbar>
        <div style="overflow: auto;">
            <dw:List runat="server" ID="lstEmailsList" ShowTitle="false" NoItemsMessage="No emails found" PageSize="25" AllowMultiSelect="true" ShowPaging="true" UseCountForPaging="true" HandlePagingManually="true" HandleSortingManually="true" OnClientSelect="currentPage.emailSelected();">
                <Filters>
                    <dw:ListTextFilter runat="server" ID="emailSearch" WaterMarkText="Search" Width="175" ShowSubmitButton="True" Divide="None" Priority="1" Label="Search emails" />
                    <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Show on page" AutoPostBack="true" Priority="2" runat="server">
                        <Items>
                            <dw:ListFilterOption Text="25" Value="25" Selected="true" DoTranslate="false" />
                            <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                            <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                            <dw:ListFilterOption Text="All" Value="1000" DoTranslate="false" />
                        </Items>
                    </dw:ListDropDownListFilter>
                    <dw:ListFlagFilter ID="filterDraft" runat="server" Label="Drafts" IsSet="true" Divide="none" LabelFirst="false" AutoPostBack="true" Visible="false" />
                    <dw:ListFlagFilter ID="filterScheduled" runat="server" Label="Scheduled" IsSet="true" Divide="none" LabelFirst="false" AutoPostBack="true" Visible="false"/>
                    <dw:ListFlagFilter ID="filterSplitTest" runat="server" Label="Split Test" IsSet="true" Divide="none" LabelFirst="false" AutoPostBack="true" Visible="false"/>
                    <dw:ListFlagFilter ID="filterSent" runat="server" Label="Sent" IsSet="true" Divide="none" LabelFirst="false" AutoPostBack="true" Visible="false"/>
                </Filters>
            </dw:List>
        </div>
    </dwc:Card>
    <dw:Overlay ID="LoadingOverlay" runat="server"></dw:Overlay>
</asp:Content>

<asp:Content ContentPlaceHolderID="FooterContext" runat="server">
    <dw:ContextMenu ID="menuEditEmail" OnShow="" OnClientSelectView="currentPage.setContexMenuView" runat="server">
        <dw:ContextMenuButton ID="cmdEditNewsletter" Text="Edit email" Icon="edit" OnClientClick="currentPage.editEmail(ContextMenu.callingItemID);" Views="Basic,SplitTest,Statistics,Resend,SplitTestAndStatistics,SplitTestAndResend,StatisticsAndResend,SplitTestAndStatisticsAndResend" runat="server" />
        <dw:ContextMenuButton ID="cmdMoveNewsletter" Text="Move email" Icon="envelopeO" OnClientClick="currentPage.moveEmail()" Views="Basic,SplitTest,Statistics,Resend,SplitTestAndStatistics,SplitTestAndResend,StatisticsAndResend,SplitTestAndStatisticsAndResend" runat="server" />
        <dw:ContextMenuButton ID="cmdSplitTestReport" Text="Split test report" icon="lineChart" OnClientClick="currentPage.showSplitTestReport(ContextMenu.callingItemID);" Views="SplitTest,SplitTestAndStatistics,SplitTestAndResend,SplitTestAndStatisticsAndResend" runat="server" />
        <dw:ContextMenuButton ID="cmdStatisticsNewsletter" Text="Statistics" icon="BarChartO" OnClientClick="currentPage.emailStatistics(ContextMenu.callingItemID);" Views="Statistics,SplitTestAndStatistics,StatisticsAndResend,SplitTestAndStatisticsAndResend" runat="server" />
        <dw:ContextMenuButton ID="cmdSaveAsTemplate" Text="Save as template" icon="PieChart" OnClientClick="currentPage.showSaveAsTemplateDialog(ContextMenu.callingItemID);" Views="Basic,SplitTest,Statistics,Resend,SplitTestAndStatistics,SplitTestAndResend,StatisticsAndResend,SplitTestAndStatisticsAndResend" runat="server" />
        <dw:ContextMenuButton ID="cmdCopyNewsletter" Text="Copy email" Icon="copy" OnClientClick="currentPage.copyEmail()" Views="Basic,SplitTest,Statistics,Resend,SplitTestAndStatistics,SplitTestAndResend,StatisticsAndResend,SplitTestAndStatisticsAndResend" runat="server" />
        <dw:ContextMenuButton ID="cmdResend" Divide="Before" Text="Resend to" Icon="envelopeO" OnClientClick="" Views="Resend,SplitTestAndResend,StatisticsAndResend,SplitTestAndStatisticsAndResend" runat="server">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdDeleteNewsletter" Divide="Before" Text="Delete email" icon="TimesCircle" OnClientClick="currentPage.confirmDeleteEmail()" Views="Basic,SplitTest,Statistics,Resend,SplitTestAndStatistics,SplitTestAndResend,StatisticsAndResend,SplitTestAndStatisticsAndResend" runat="server" />
    </dw:ContextMenu>

    <dw:ContextMenu ID="menuEditTemplate" OnShow="" runat="server">
        <dw:ContextMenuButton ID="cmdEditTemplate" Text="Edit email template" Icon="Pencil" OnClientClick="currentPage.editEmail(ContextMenu.callingItemID);" runat="server" />
        <dw:ContextMenuButton ID="cmdDeleteTemplate" Divide="Before" Text="Delete email template" Icon="Remove" OnClientClick="currentPage.confirmDeleteEmail();" runat="server" />
    </dw:ContextMenu>
</asp:Content>
