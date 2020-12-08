<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="PageVisits.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.PageVisits" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-border">
        <dw:List ID="lstPages" PageSize="15" ShowTitle="false" NoItemsMessage="No pages found" runat="server">
            <Columns>
                <dw:ListColumn ID="colName" Name="Name" Width="170" runat="server" />
                <dw:ListColumn ID="colPath" Name="Path" Width="250" runat="server" />
                <dw:ListColumn ID="colArea" Name="Language/Area" Width="100" runat="server" />
                <dw:ListColumn ID="colView" Name="View page" HeaderAlign="Center" ItemAlign="Center" Width="80" runat="server" />
            </Columns>
        </dw:List>
    </div>
</asp:Content>
