<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="VisitsList.ascx.vb" Inherits="Dynamicweb.Admin.OMC.Controls.VisitsList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<div id="divVisitsContainer" class="omc-visits-list" runat="server">
    <dw:List ID="lstVisits" PageSize="15" ShowTitle="false" NoItemsMessage="No visits found" runat="server">
        <Columns>
            <dw:ListColumn ID="colIPAddress" Name="IP-address" Width="100" runat="server" />
            <dw:ListColumn ID="colVisitDate" Name="Visit date" Width="145" runat="server" />
            <dw:ListColumn ID="colPageviews" Name="Pageviews" HeaderAlign="Center" Width="80" runat="server" />
            <dw:ListColumn ID="colCompany" Name="Company" Width="380" runat="server" />
            <dw:ListColumn ID="colDetails" Name="Details" Width="50" runat="server" ItemAlign="Center" />
        </Columns>
    </dw:List>
</div>