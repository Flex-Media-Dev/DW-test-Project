<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" CodeBehind="Dashboard.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.Dashboard" Async="true" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" src="js/queryString.js"></script>
    <style type="text/css">
        .screen-container {
            padding: 0 0 4px 0;
        }
    </style>
    <script>
        function initDashboard() {
            var el = document.getElementById("ecom-main-iframe");
            el.setAttribute("src", "/Admin/Dashboard/Ecommerce/View/<%=NodePath%>");
            document.getElementById('slave-content').addClassName('hidden');
            el.removeClassName('hidden');
        }
    </script>
</asp:Content>



