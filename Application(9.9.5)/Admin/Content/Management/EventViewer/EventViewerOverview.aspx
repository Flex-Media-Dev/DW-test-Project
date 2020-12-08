<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EventViewerOverview.aspx.vb" Inherits="Dynamicweb.Admin.EventViewerOverview" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Event viewer</title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerOverview.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerOverview.css" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <form id="form1" runat="server" onsubmit="EventViewerOverview.showWaitSpinner();" method="get" enableviewstate="false">
        <dw:Overlay ID="PleaseWait" runat="server" />

        <div class="card">
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="cmdReload" runat="server" Size="Small" Text="Reload" Icon="Refresh" OnClientClick="EventViewerOverview.reload();"></dw:ToolbarButton>
            </dw:Toolbar>
            <div id="EventListContent">
                <dw:List ID="eventList" runat="server" Title="Event viewer" ShowTitle="false" ShowPaging="true" EnableViewState="false" Personalize="true" HandleSortingManually="true" NoItemsMessage="No event entries found. Search again further back in time.">
                    <Filters>
                        <dw:ListAutomatedSearchFilter runat="server" ID="TextFilter" Priority="2" WaterMarkText="" />
                        <dw:ListDropDownListFilter ID="CategoryFilter" Width="200" Label="Category" AutoPostBack="true" Priority="1" runat="server" ClientIDMode="Static"></dw:ListDropDownListFilter>
                        <dw:ListDropDownListFilter ID="LogEventLevelFilter" Width="120" Label="Log level" AutoPostBack="true" Priority="3" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="All" Value="" />
                                <dw:ListFilterOption Text="Information" Value="info" />
                                <dw:ListFilterOption Text="Warning" Value="warn" />
                                <dw:ListFilterOption Text="Error" Value="error" />
                            </Items>
                        </dw:ListDropDownListFilter>
                        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="80" Label="Paging size" AutoPostBack="true" Priority="4" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="5" Value="5" DoTranslate="false" />
                                <dw:ListFilterOption Text="20" Value="20" DoTranslate="false" />
                                <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" Selected="true" />
                                <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                                <dw:ListFilterOption Text="500" Value="500" DoTranslate="false" />
                            </Items>
                        </dw:ListDropDownListFilter>
                        <dw:ListDropDownListFilter ID="DurationFilter" Width="120" Label="Time period" AutoPostBack="true" Priority="4" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="Any" Value="" DoTranslate="false" />
                                <dw:ListFilterOption Text="1 hour" Value="onehour" DoTranslate="false" />
                                <dw:ListFilterOption Text="2 hours" Value="twohours" DoTranslate="false" />
                                <dw:ListFilterOption Text="3 hours" Value="threehours" DoTranslate="false" />
                                <dw:ListFilterOption Text="6 hours" Value="sixhours" DoTranslate="false" />
                                <dw:ListFilterOption Text="12 hours" Value="twelvehours" DoTranslate="false" />
                                <dw:ListFilterOption Text="24 hours" Value="day" DoTranslate="false" Selected="true" />
                                <dw:ListFilterOption Text="Last week" Value="week" DoTranslate="false" />
                                <dw:ListFilterOption Text="Last month" Value="month" DoTranslate="false" />
                                <dw:ListFilterOption Text="Last 3 months" Value="quarter" DoTranslate="false" />
                                <dw:ListFilterOption Text="Last 6 months" Value="halfyear" DoTranslate="false" />
                                <dw:ListFilterOption Text="Last Year" Value="year" DoTranslate="false" />
                            </Items>
                        </dw:ListDropDownListFilter>
                    </Filters>
                    <Columns>
                        <dw:ListColumn ID="Col1" Name="Id" EnableSorting="true" runat="server" Width="100" Visible="false" />
                        <dw:ListColumn ID="Col2" Name="" EnableSorting="false" runat="server" ItemAlign="Center" Width="25" />
                        <dw:ListColumn ID="Col3" Name="Date" EnableSorting="true" runat="server" Width="150" />
                        <dw:ListColumn ID="Col4" Name="Level" EnableSorting="true" runat="server" Width="100" />
                        <dw:ListColumn ID="Col5" Name="Category" EnableSorting="true" runat="server" Width="100" />
                        <dw:ListColumn ID="Col6" Name="Action" EnableSorting="true" runat="server" Width="150" />
                        <dw:ListColumn ID="Col7" Name="Description" EnableSorting="false" runat="server" />
                    </Columns>
                </dw:List>
            </div>
        </div>
    </form>
    <p>&nbsp;</p>
</body>
</html>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>