<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Leads/Details/EntryContent.Master" CodeBehind="FileDownloads.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.FileDownloads" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
     <div class="visitor-details-border">
        <dw:List ID="lstFiles" PageSize="15" ShowTitle="false" NoItemsMessage="No files found" runat="server">
            <Columns>
                <dw:ListColumn ID="colPath" Name="Path" Width="500" runat="server" />
            </Columns>
        </dw:List>
    </div>
</asp:Content>
