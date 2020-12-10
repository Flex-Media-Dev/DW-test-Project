<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" CodeBehind="EcomOrder_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderEdit" Async="true" %>
<%@ Register Src="~/Admin/Module/eCom_Catalog/dw7/edit/UCOrderEdit.ascx" TagPrefix="oe" TagName="UCOrderEdit" %>


<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" src="../js/orderEdit.js"></script>
    <link rel="Stylesheet" type="text/css" href="../css/orderEdit.css" />
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <oe:UCOrderEdit runat="server" id="UCOrderEdit" />
</asp:Content>
