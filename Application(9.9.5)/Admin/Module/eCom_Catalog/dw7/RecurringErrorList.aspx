<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" CodeBehind="RecurringErrorList.aspx.vb" Inherits="Dynamicweb.Admin.RecurringErrorList" Async="true" %>

<%@ Register Src="~/Admin/Module/eCom_Catalog/dw7/UCOrderList.ascx" TagPrefix="ol" TagName="UCOrderList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>


<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" src="js/queryString.js"></script>
    <script type="text/javascript" src="js/OrderList.js"></script>
    <link rel="Stylesheet" type="text/css" href="css/OrderList.css" media="screen" />
    <link rel="Stylesheet" type="text/css" href="css/OrderListPrint.css" media="print" />
</asp:Content>





<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <dw:Toolbar ID="OrderListToolbar" runat="server">
        <dw:ToolbarButton runat="server" ID="ButtonResetFilters" Text="Reset" Icon="Undo" OnClientClick="ResetFilters();" />
        <dw:ToolbarButton runat="server" ID="ButtonApplyAllFilters" Text="Apply" Icon="Check" IconColor="Default" OnClientClick="javascript:List._submitForm('List');" />

        <dw:ToolbarButton runat="server" ID="buttonHelp" Text="Help" Icon="Help" OnClientClick="helpOP();" Divide="Before" />
    </dw:Toolbar>
    <div class="list-with-subtitle">
        <dw:List ID="List" runat="server" Title="Log" ShowTitle="true">
            <Filters>
                <dw:ListDateFilter runat="server" ID="OrderFromDate" Label="From" />
                <dw:ListDateFilter runat="server" ID="OrderToDate" Label="To" />
                <dw:ListDropDownListFilter runat="server" ID="ErrorFilters" Width="150" Label="Show" >
                    <Items>
                        <dw:ListFilterOption Text="Errors" Value="Errors" />
                        <dw:ListFilterOption Text="Everything" Value="Everything" />
                    </Items>
                </dw:ListDropDownListFilter>
                <dw:ListTextFilter runat="server" ID="OrderIdFilter" Width="150" Label="Order Id" />
            </Filters>
            <Columns>
                <dw:ListColumn ID="Type" Name="Type" runat="server" Width="30"></dw:ListColumn>
                <dw:ListColumn ID="Date" Name="Date" runat="server" Width="150" EnableSorting="true"></dw:ListColumn>
                <dw:ListColumn ID="Order" Name="Order" runat="server" Width="75" EnableSorting="true"></dw:ListColumn>
                <dw:ListColumn ID="Message" Name="Message" runat="server"></dw:ListColumn>
            </Columns>
        </dw:List>
    </div>
</asp:Content>
