<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="Cart.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.Cart" %>
<%@ Register Src="~/Admin/Module/eCom_Catalog/dw7/edit/UCOrderEdit.ascx" TagPrefix="oe" TagName="UCOrderEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="Content" ContentPlaceHolderID="MainContent" runat="server" >
    <%If Not Request("ID") = "" Then%>
        <oe:UCOrderEdit runat="server" id="UCOrderEdit" />
    <%Else%>
        <div class="emptyOrder">
            <%=Translate.Translate("This user has not added any items to his shopping cart")%>
        </div>
    <%End If%>
</asp:Content>
