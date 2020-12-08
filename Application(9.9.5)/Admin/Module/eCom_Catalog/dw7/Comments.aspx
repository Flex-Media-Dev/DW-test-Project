<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" CodeBehind="Comments.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.Comments" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script>
        function initPage() {
            var el = document.getElementById("ecom-main-iframe");
            el.setAttribute("src", "/Admin/Content/Comments/List.aspx?Type=ecomProduct&LangID=<%=Dynamicweb.Ecommerce.Common.Context.LanguageID%>&IsFullPage=True");
            document.getElementById('slave-content').addClassName('hidden');
            el.removeClassName('hidden');
        }
    </script>
</asp:Content>