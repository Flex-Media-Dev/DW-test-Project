<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VouchersManagerMain.aspx.vb" Inherits="Dynamicweb.Admin.VouchersManager.VouchersManagerMain" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
        <Items>
            <dw:GenericResource Url="js/VouchersManagerMain.js" />
            <dw:GenericResource Url="../js/ecomLists.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("", "administration.managementcenter.eCommerce.productcatalog.vouchers") %>
        }

        function showVoucherList(e, listId) {
            if (e != null) {
                var t = $(e.srcElement || e.target);
                if (t.tagName == "IMG" && t.id.indexOf("img_") == 0) {
                    return;
                }
            }
            var url = "VouchersList.aspx?ListID=" + listId;
            document.location.href = url;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" style="height: 100%;">
        <div class="card-header">
            <h2 class="subtitle"><%=Translate.Translate("Vouchers") %></h2>
        </div>

        <dw:Toolbar ID="ListBar1" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="SaveToolbarButton" runat="server" Divide="None" Icon="Save" Text="Save" Disabled="true"></dw:ToolbarButton>
            <dw:ToolbarButton ID="SaveAndCloseToolbarButton" runat="server" Divide="None" Icon="Save" Text="Save and Close" Disabled="true"></dw:ToolbarButton>
            <dw:ToolbarButton ID="CancelToolbarButton" runat="server" Divide="None" Icon="TimesCircle" Text="Cancel" OnClientClick="doEcom7Close();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="NewVoucherListToolbarButton" runat="server" Divide="None" Icon="PlusSquare" Text="New voucher list" OnClientClick="vouchersManagerMain.editList();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="HelpToolbarButton" runat="server" Divide="None" Icon="Help" Text="Help" OnClientClick="help();"></dw:ToolbarButton>
        </dw:Toolbar>

        <dw:List ID="VouchersLists" runat="server" Title="Vouchers" ShowTitle="True" PageSize="25" ContextMenuID="VouchersListsContext" OnRowExpand="VouchersLists_RowExpand">
            <Columns>
                <dw:ListColumn ID="colName" runat="server" Name="Name" EnableSorting="true" />
                <dw:ListColumn ID="colCreated" runat="server" Name="Created" EnableSorting="true" />
                <dw:ListColumn ID="colActive" runat="server" Name="Active" EnableSorting="true" />
                <dw:ListColumn ID="colValueProvider" runat="server" Name="Value Provider" EnableSorting="true" />
                <dw:ListColumn ID="colProviderName" runat="server" Name="Provider Name" EnableSorting="true" />
                <dw:ListColumn ID="colValue" runat="server" Name="Value" EnableSorting="true" />
                <dw:ListColumn ID="colType" runat="server" Name="Type" EnableSorting="true" />
                <dw:ListColumn ID="colDateFrom" runat="server" Name="Date From" EnableSorting="true" />
                <dw:ListColumn ID="colDateTo" runat="server" Name="Date To" EnableSorting="true" />
                <dw:ListColumn ID="colDiscountGiven" runat="server" Name="Discount given" EnableSorting="true" />
                <dw:ListColumn ID="colDiscountCount" runat="server" Name="Discount count" EnableSorting="true" />
            </Columns>
        </dw:List>
    </form>

    <dw:ContextMenu ID="VouchersListsActiveItemContext" runat="server">
        <dw:ContextMenuButton ID="AddListContextMenuButton1" runat="server" Divide="None" Icon="Pencil" Text="Edit list" Views="activate_cat,deactivate_cat" OnClientClick="vouchersManagerMain.editList()"></dw:ContextMenuButton>
        <dw:ContextMenuButton ID="DeactivateListContextMenuButton" runat="server" Divide="None" Icon="NotInterested" Text="Deactivate list" Views="deactivate_cat" OnClientClick="vouchersManagerMain.deactivateList()"></dw:ContextMenuButton>
        <dw:ContextMenuButton ID="DeleteListContextMenuButton1" runat="server" Divide="None" Icon="Delete" Text="Delete list" Views="activate_cat,deactivate_cat" OnClientClick="vouchersManagerMain.deleteList();"></dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:ContextMenu ID="VouchersListsInactiveItemContext" runat="server">
        <dw:ContextMenuButton ID="AddListContextMenuButton2" runat="server" Divide="None" Icon="Pencil" Text="Edit list" Views="activate_cat,deactivate_cat" OnClientClick="vouchersManagerMain.editList()"></dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ActivateListContextMenuButton" runat="server" Divide="None" Icon="Check" IconColor="Default" Text="Activate list" Views="activate_cat" OnClientClick="vouchersManagerMain.activateList()"></dw:ContextMenuButton>
        <dw:ContextMenuButton ID="DeleteListContextMenuButton2" runat="server" Divide="None" Icon="Delete" Text="Delete list" Views="activate_cat,deactivate_cat" OnClientClick="vouchersManagerMain.deleteList();"></dw:ContextMenuButton>
    </dw:ContextMenu>

    <script type="text/javascript">
        //vouchersManagerMain.listList();
    </script>
    <% Translate.GetEditOnlineScript()%>
</body>
</html>
