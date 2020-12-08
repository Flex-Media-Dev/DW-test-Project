<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" CodeBehind="StatisticView.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.StatisticView" Async="true" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/queryString.js"></script>
    <style type="text/css">
        .screen-container {
            padding: 0 0 4px 0;
        }
    </style>
    <script>
        function initStatisticView() {
            var el = document.getElementById("ecom-main-iframe");
            el.setAttribute("src", "/Admin/Module/eCom_Catalog/dw7/views/FramedStatisticView.aspx?AddIn=<%=Request.QueryString("AddIn")%>");
            document.getElementById('slave-content').addClassName('hidden');
            el.removeClassName('hidden');
        }
    </script>
</asp:Content>

