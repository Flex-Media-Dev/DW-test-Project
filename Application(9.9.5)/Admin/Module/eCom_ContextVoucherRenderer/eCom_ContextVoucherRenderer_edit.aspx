<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="eCom_ContextVoucherRenderer_edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_ContextVoucherRenderer_edit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
</head>
<body>
    <input type="hidden" name="eCom_ContextVoucherRenderer_settings" value="VoucherListId, VoucherTemplate" />
    <dw:ModuleHeader ID="dwHeaderModule" runat="server" ModuleSystemName="eCom_ContextVoucherRenderer" />

    <dw:GroupBox ID="grpboxPaging" Title="Settings" runat="server">
        <table cellpadding="2" cellspacing="0" width="100%" border="0">
            <colgroup>
                <col width="170px" />
                <col />
            </colgroup>
            <tr style="padding-top: 10px;">
                <td valign="top">
                    <dw:TranslateLabel ID="dwVoucherList" runat="server" Text="Voucher list" />
                </td>
                <td style="padding-left: 2px;">
                    <asp:Literal ID="VoucherListId" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr style="padding-top: 10px;">
                <td valign="top">
                    <dw:TranslateLabel ID="dwVoucherTemplate" runat="server" Text="Voucher Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="VoucherTemplate" Name="VoucherTemplate" Folder="Templates/eCom/Vouchers" FullPath="True" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</body>
</html>
