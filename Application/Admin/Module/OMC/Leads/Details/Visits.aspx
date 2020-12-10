<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="Visits.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.Visits" %>
<%@ Register TagPrefix="omc" TagName="VisitsList" Src="~/Admin/Module/OMC/Controls/VisitsList.ascx" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-border">
        <omc:VisitsList id="vList" runat="server" />
    </div>
</asp:Content>
