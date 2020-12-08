<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomPriceList.aspx.vb" Inherits="Dynamicweb.Admin.EcomPriceList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function createPriceListPage(opts) {
            let dialogId = "ProductPricesDialog";
            let api = {
                init: function (opts) {
                    this.options = opts;
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.setTitle(dialogId, this.options.labels.listDialogTitle);
                    }
                },
                cancel: function () {
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.hide(dialogId);
                    }
                },
                deleteSelected: function (evt) {
                    evt.stopPropagation();
                    let ids = this._getSelectedItemsIds();
                    if (ids.length) {
                        Action.Execute(this.options.actions.delete, { ProductId: this.options.productId, ids: ids });
                    }
                },

                listRowSelected: function () {
                    if (this.options.deletePermitted) {
                        if (List && List.getSelectedRows(this.options.ids.list).length > 0) {
                            Toolbar.setButtonIsDisabled('cmdDelete', false);
                        } else {
                            Toolbar.setButtonIsDisabled('cmdDelete', true);
                        }
                    }
                },

                add: function () {
                    let dlgTitle = this.options.labels.createItemDialogTitle;
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.setTitle(dialogId, dlgTitle);
                    }
                    Action.Execute(this.options.actions.edit, { ProductId: this.options.productId, PriceId: "" });
                },

                edit: function (evt, priceId) {
                    if (!priceId) {
                        let row = window.List.getRowByID(this.options.ids.list, 'row' + window.ContextMenu.callingID);
                        priceId = row.readAttribute("itemid");
                    }
                    let dlgTitle = this.options.labels.editItemDialogTitle;
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.setTitle(dialogId, dlgTitle);
                    }
                    Action.Execute(this.options.actions.edit, { ProductId: this.options.productId, PriceId: priceId });
                },

                copy: function (evt) {
                    evt.stopPropagation();
                    let ids = this._getSelectedItemsIds();
                    if (ids.length) {
                        Action.Execute(this.options.actions.copy, { ProductId: this.options.productId, ids: ids });
                    }
                },

                _getSelectedItemsIds: function () {
                    let rows = window.List.getSelectedRows(this.options.ids.list);
                    if (!rows.length) {
                        if (window.ContextMenu.callingID) {
                            let row = window.List.getRowByID(this.options.ids.list, 'row' + window.ContextMenu.callingID);
                            rows = [row];
                        }
                    }
                    let ids = [];
                    if (rows.length > 0) {
                        for (let i = 0; i < rows.length; i++) {
                            ids.push(rows[i].readAttribute("itemid"));
                        }
                    }
                    return ids;
                }
            };
            api.init(opts);
            return api;
        }
    </script>
</head>

<body>
    <form id="MainForm" runat="server">
        <dwc:Card runat="server">
            <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                <dw:ToolbarButton ID="cmdCancel" runat="server" Icon="Cancel" Text="Cancel" OnClientClick="currentPage.cancel()" />
                <dw:ToolbarButton ID="cmdAdd" runat="server" Icon="PlusSquare" Text="New price" OnClientClick="currentPage.add()" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Icon="Remove" Text="Delete price" OnClientClick="currentPage.deleteSelected(event)" Disabled="true" />
            </dw:Toolbar>
            <dw:List runat="server" ID="PriceList" AllowMultiSelect="true" HandleSortingManually="false" Personalize="true" ShowPaging="true" ShowTitle="false" PageSize="25" NoItemsMessage="No prices found" OnClientSelect="currentPage.listRowSelected();">
                <Filters>
                    <dw:ListAutomatedSearchFilter runat="server" />
                </Filters>
            </dw:List>
        </dwc:Card>
        <dw:ContextMenu ID="PriceListContextMenu" runat="server">
            <dw:ContextMenuButton ID="editButton" runat="server" Icon="Pencil" Text="Edit" OnClientClick="currentPage.edit();" />
            <dw:ContextMenuButton ID="copyButton" runat="server" Icon="ContentCopy" Text="Copy" OnClientClick="currentPage.copy(event);" />
            <dw:ContextMenuButton ID="deleteButton" runat="server" Icon="Delete" Text="Delete" OnClientClick="currentPage.deleteSelected(event);" />
        </dw:ContextMenu>
    </form>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
