<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" CodeBehind="OrderList.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.OrderList" Async="true" %>
<%@ Register Src="~/Admin/Module/eCom_Catalog/dw7/UCOrderList.ascx" TagPrefix="ol" TagName="UCOrderList" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" src="js/queryString.js"></script>
    <script type="text/javascript" src="js/OrderList.js"></script>
    <link rel="Stylesheet" type="text/css" href="css/OrderList.css" media="screen" />
    <link rel="Stylesheet" type="text/css" href="/Admin/Images/Ribbon/UI/List/List.css" />
    <link rel="Stylesheet" type="text/css" href="css/OrderListPrint.css" media="print" />
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <ol:UCOrderList runat="server" ID="UCOrderList" />  
</asp:Content>


