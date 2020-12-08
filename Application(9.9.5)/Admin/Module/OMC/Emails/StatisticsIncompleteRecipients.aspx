<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="StatisticsIncompleteRecipients.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.StatisticsIncompleteRecipients" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>


<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />  
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <dw:List ID="incompleteRecipients" ShowPaging="true" Title="Incomplete recipients" NoItemsMessage="No scheduled tasks found" ShowTitle="true" runat="server" PageSize="25">
        <Columns>
            <dw:ListColumn ID="colRecipientName" Name="Recipient name" runat="server" />
            <dw:ListColumn ID="colRecipientEmail" Name="Recipient email" runat="server" />
        </Columns>
    </dw:List>
</asp:Content>

