<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" AutoEventWireup="false" CodeBehind="EditProductSmartSearch.aspx.vb" Inherits="Dynamicweb.Admin.EditProductSmartSearch" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server" style="height:100%">
    <style>
        #slave-content{
            height:100%;
        }
</style>
    <iframe name="ProductsSmartSearchFrame" id="ProductsSmartSearchFrame" src="/Admin/Content/Management/SmartSearches/EditSmartSearch.aspx?CMD=<%= Dynamicweb.Context.Current.Request("CMD")%>&ID=<%= Dynamicweb.Context.Current.Request("ID")%>&preview=<%= Dynamicweb.Context.Current.Request("preview")%>&backUrl=<%= Dynamicweb.Context.Current.Request("backUrl")%>&providerType=<%= Dynamicweb.Context.Current.Request("providerType")%>&calledFrom=eCom&groupID=<%= Dynamicweb.Context.Current.Request("groupID")%>" frameborder="0" height="100%" width="100%"></iframe>
<% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
   
</asp:Content>

