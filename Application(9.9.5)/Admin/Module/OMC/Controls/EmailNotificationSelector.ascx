<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="EmailNotificationSelector.ascx.vb" Inherits="Dynamicweb.Admin.OMC.Controls.EmailNotificationSelector" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<div id="divSelectContainer" class="omc-notifications-edit" runat="server">
    <table class="omc-notifications-edit-table">
        <tr class="omc-notifications-edit-table-row" valign="top">
            <td class="omc-notifications-edit-table-cell omc-notifications-edit-field-label">
                <dw:TranslateLabel ID="lbNotification" Text="Notification" runat="server" />
            </td>
            <td class="omc-notifications-edit-table-cell omc-notifications-edit-field-value">
                <dw:TemplatedDropDownList ID="ddNotifications" Width="250" ExpandableAreaWidth="300" ExpandableAreaHeight="100" OnClientDataExchange="Dynamicweb.Controls.OMC.EmailNotificationEditor._listDataExchange" runat="server">
                    <BoxTemplate>
                        <span class="omc-notifications-edit-list-item"><%#Eval("Label")%></span>
                    </BoxTemplate>
                    <ItemTemplate>
                        <span class="omc-notifications-edit-list-item"><%#Eval("Label")%></span>
                    </ItemTemplate>
                </dw:TemplatedDropDownList>
            </td>
        </tr>
    </table>
</div>