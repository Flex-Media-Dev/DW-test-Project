<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="EmailLeadList.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.EmailLeadList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="visitor-details-border">
        <dw:List ID="lstEmails" PageSize="15" ShowTitle="false" NoItemsMessage="No pages found" runat="server">
            <Columns>
                <dw:ListColumn ID="colSubject" Name="Subject" Width="80" runat="server" />
                <dw:ListColumn ID="colFrom" Name="From" Width="80" runat="server" />
                <dw:ListColumn ID="colRecipients" Name="Sent To" Width="280" runat="server" />
                <dw:ListColumn ID="colSentDate" Name="Sent date" Width="150" runat="server" />
            </Columns>
        </dw:List>
    </div>
</asp:Content>
