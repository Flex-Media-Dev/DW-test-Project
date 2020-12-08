<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master"
    AutoEventWireup="false" CodeBehind="NotificationList.aspx.vb" Inherits="Dynamicweb.Admin.NotificationList" %>

<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" src="images/layermenu.js"></script>
    <script type="text/javascript" src="js/queryString.js"></script>
    <script type="text/javascript" src="js/NotificationList.js"></script>
    <style type="text/css">
        a:hover{ text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
  <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false" >
    <dw:ToolbarButton ID="cmdDelete" runat="server" Disabled="true" Divide="None" Icon="Delete" Text="Delete" OnClientClick="notificationList.delete();"></dw:ToolbarButton>
  </dw:Toolbar>
  <div class="breadcrumb"><asp:Literal ID="Breadcrumb" runat="server" /></div>
  <input type="hidden" runat="server" id="Action" value="" />
  <input type="hidden" runat="server" id="SelectedRows" value="" />
  <dw:List ID="NotificationList" StretchContent="true" ShowTitle="false" runat="server" OnClientSelect="notificationList.onSelectRow();"
        AllowMultiSelect="true" UseCountForPaging="true" HandleSortingManually="true" HandlePagingManually="true" Personalize="true" PageSize="25">
        <Filters>
            <dw:ListDropDownListFilter ID="ShowFilter" Label="Show" autopostback="true" runat="server">
                <Items>
                    <dw:ListFilterOption Text="Active" value="active" selected="true"  />
                    <dw:ListFilterOption Text="Sent" value="sent"  />
                    <dw:ListFilterOption Text="All" value="all"  />
                </Items>
            </dw:ListDropDownListFilter>
            <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Page Size" AutoPostBack="true" runat="server">
                <Items>
                    <dw:ListFilterOption Text="25" Value="25" Selected="true" DoTranslate="false" />
                    <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                    <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                    <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                    <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                    <dw:ListFilterOption Text="All" Value="all" DoTranslate="True"/>
                </Items>
            </dw:ListDropDownListFilter>
        </Filters>
            <Columns>
                <dw:ListColumn ID="ListColumn1" runat="server" EnableSorting="true" Name="Email" TranslateName="true" />
                <dw:ListColumn ID="ListColumn2" runat="server" EnableSorting="true" Name="User" TranslateName="true" />
                <dw:ListColumn ID="ListColumn3" runat="server" EnableSorting="true" Name="Product" TranslateName="true" />
                <dw:ListColumn ID="ListColumn4" runat="server" EnableSorting="true" Name="Created" TranslateName="true" />
                <dw:ListColumn ID="ListColumn5" runat="server" EnableSorting="true" Name="Sent" TranslateName="true" />
            </Columns>
    </dw:List>

    <script type="text/javascript">
        notificationList.action = $('<%=Action.ClientID %>');
        notificationList.selectedRows = $('<%=selectedRows.ClientID %>');
        notificationList.deleteQuestion = "<%= _deleteQuestion %>";
    </script>
    
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>

</asp:Content>