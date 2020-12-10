<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="EmailNotificationEditor.ascx.vb" Inherits="Dynamicweb.Admin.OMC.Controls.EmailNotificationEditor" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

<div id="divEditContainer" class="omc-notifications-edit" runat="server">
    <span class="omc-notifications-edit-prop-id">
        <asp:HiddenField ID="hNotificationID" Value="" runat="server" />
    </span>

    <table class="omc-notifications-edit-table">
        <tr class="omc-notifications-edit-table-row" valign="top">
            <td class="omc-notifications-edit-table-cell omc-notifications-edit-field-label">
                <dw:TranslateLabel ID="lbName" Text="Name" runat="server" />
            </td>
            <td class="omc-notifications-edit-table-cell omc-notifications-edit-field-value">
                <asp:TextBox ID="txName" CssClass="std omc-notifications-edit-prop-name" runat="server" />
            </td>
        </tr>
        <tr valign="top">
            <td class="omc-notifications-edit-table-cell omc-notifications-edit-field-label">
                <dw:TranslateLabel ID="lbProfile" Text="Scheme" runat="server" />
            </td>
            <td class="omc-notifications-edit-table-cell omc-notifications-edit-field-value">
                <dw:TemplatedDropDownList ID="ddProfile" Width="250" ExpandableAreaWidth="300" ExpandableAreaHeight="100" OnClientDataExchange="Dynamicweb.Controls.OMC.EmailNotificationEditor._listDataExchange" runat="server">
                    <BoxTemplate>
                        <span class="omc-notifications-edit-list-item"><%#Eval("Label")%></span>
                    </BoxTemplate>
                    <ItemTemplate>
                        <span class='omc-notifications-edit-list-item<%#If(Dynamicweb.Core.Converter.ToBoolean(Eval("IsEnabled")), String.Empty, " dw-list-item-disabled")%>'><%#Eval("Label")%></span>
                    </ItemTemplate>
                </dw:TemplatedDropDownList>
            </td>
        </tr>
        <tr valign="top">
            <td class="omc-notifications-edit-table-cell omc-notifications-edit-field-label">
                <dw:TranslateLabel ID="lbRecipients" Text="Recipients" runat="server" />
            </td>
            <td class="omc-notifications-edit-table-cell omc-notifications-edit-field-value">
                <omc:EditableListBox id="lstRecipients" runat="server" />
            </td>
        </tr>
    </table>

    <div style="display: none">
        <asp:Button ID="cmdSave" CssClass="omc-notifications-edit-save-activator" runat="server" />
        <asp:Button ID="cmdCancel" CssClass="omc-notifications-edit-cancel-activator" runat="server" />
    </div>
</div>