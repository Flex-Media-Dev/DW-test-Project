<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="EmailNotificationList.ascx.vb" Inherits="Dynamicweb.Admin.OMC.Controls.EmailNotificationList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<div id="divListContainer" class="omc-notifications-list" runat="server">
    <input type="hidden" id="fAction" class="omc-notifications-list-action" value="" runat="server" />
    <input type="hidden" id="fArgument" class="omc-notifications-list-argument" value="" runat="server" />

    <dw:List ID="lstNotifications" ShowPaging="true" ShowTitle="false" AllowMultiSelect="false" NoItemsMessage="No notifications found." PageSize="10" runat="server">
        <Columns>
            <dw:ListColumn ID="colName" Name="Name" TranslateName="True" Width="350" EnableSorting="false" runat="server" />
            <dw:ListColumn ID="colRecipients" Name="Recipients" TranslateName="true" Width="100" EnableSorting="false" ItemAlign="Center" HeaderAlign="Center" runat="server" />
            <dw:ListColumn ID="colDelete" Name="Delete" TranslateName="true" Width="100" EnableSorting="false" ItemAlign="Center" HeaderAlign="Center" runat="server" />
        </Columns>
    </dw:List>

    <dw:ContextMenu ID="cmNotification" runat="server">
        <dw:ContextMenuButton ID="cmdEditNotification" Text="Edit" Image="EditDocument" runat="server" />
        <dw:ContextMenuButton ID="cmdDeleteNotification" Text="Delete" Image="DeleteDocument" runat="server" />
    </dw:ContextMenu>

    <div style="display: none">
        <asp:Button ID="cmdPostBack" CssClass="omc-notifications-list-action-activator" runat="server" />
    </div>
</div>