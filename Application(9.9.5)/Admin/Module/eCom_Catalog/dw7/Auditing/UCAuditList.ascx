<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UCAuditList.ascx.vb" Inherits="Dynamicweb.Admin.UCAuditList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="dwa" Namespace="Dynamicweb.Admin" Assembly="Dynamicweb.Admin" %>


<dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
    <dw:ToolbarButton ID="cmdShowDetails" Icon="Eye" Text="Details" runat="server" Disabled="true" OnClientClick="currentPage.showDetails(event);" />
    <dw:ToolbarButton ID="cmdExportToExcel" Icon="SignOut" Text="Export" runat="server" OnClientClick="currentPage.exportToExcel(event);" />
</dw:Toolbar>
<dw:Infobar ID="AuditDisabledWarning" Visible="false" runat="server" DisplayType="Warning" Message="Audit is not enabled in 'Settings/Solution settings', so new changes will not be visible in this list."></dw:Infobar>

<dw:List ID="lstAudit" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False" PageSize="25" AllowMultiSelect="true" OnClientSelect="currentPage.itemSelected();"
    UseCountForPaging="true"
    HandleSortingManually="true"
    HandlePagingManually="true" Personalize="true">
    <Filters>
        <dw:ListAutomatedSearchFilter runat="server" ID="TextFilter" Priority="2" WaterMarkText="" />
        <dw:ListDropDownListFilter ID="ObjectTypeFilter" Label="Object type" AutoPostBack="true" Priority="1" runat="server"></dw:ListDropDownListFilter>
        <dw:ListDropDownListFilter ID="ObjectActionFilter" Label="Description" AutoPostBack="true" Priority="3" runat="server"></dw:ListDropDownListFilter>
        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="90" Label="Paging size" AutoPostBack="true" Priority="4" runat="server">
            <Items>
                <dw:ListFilterOption Text="25" Value="25" DoTranslate="false" Selected="true" />
                <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                <dw:ListFilterOption Text="150" Value="150" DoTranslate="false" />
                <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                <dw:ListFilterOption Text="500" Value="500" DoTranslate="false" />
            </Items>
        </dw:ListDropDownListFilter>
        <dw:ListDateFilter ID="DateFromFilter" Label="From" IncludeTime="true" runat="server" OnClientChange="dateRangeFilterChanged('lstAudit:DateFromFilter');"></dw:ListDateFilter>
        <dw:ListDateFilter ID="DateToFilter" Label="To" IncludeTime="true" runat="server" OnClientChange="dateRangeFilterChanged('lstAudit:DateToFilter');"></dw:ListDateFilter>
    </Filters>
    <Columns>
        <dw:ListColumn ID="clmDate" TranslateName="True" Name="Date" runat="server" EnableSorting="true" />
        <dw:ListColumn ID="clmUpdatedBy" TranslateName="True" Name="Updated by" runat="server" EnableSorting="true" />
        <dw:ListColumn ID="clmObjectType" TranslateName="True" Name="Object Type" runat="server" EnableSorting="true" />
        <dw:ListColumn ID="clmLanguage" TranslateName="True" Name="Language" runat="server" EnableSorting="true" />
        <dw:ListColumn ID="clmId" TranslateName="True" Name="Object" runat="server" EnableSorting="true" />
        <dw:ListColumn ID="clmObjectInfo" TranslateName="True" Name="Object Information" runat="server" />
        <dw:ListColumn ID="clmAction" TranslateName="True" Name="Description" runat="server" />
    </Columns>
</dw:List>
