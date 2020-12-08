<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomVatGroupList.aspx.vb" Inherits="Dynamicweb.Admin.EcomVatGroupList" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript">
        function VatGroupListPage(options) {
            let dialogId = "ProductVatGroupsDialog";

            function getSelectedRows() {
                return List.getSelectedRows('VatGroupList');
            }

            function getSelectedRowId() {
                return ContextMenu.callingItemID;
            }

            function executeCommand(cmd, ids) {
                if (ids) {
                    document.getElementById('cmd').value = cmd;
                    document.getElementById('rowIds').value = ids;
                    WaterMark.hideAll();
                    form1.submit();
                }
            }

            var api = {
                initialize: function (options) {
                    var self = this;
                    this.options = options;
                    this.productId = options.ProductId;
                    this.variantId = options.VariantId;
                    this.languageId = options.LanguageId;
                    this.labels = options.Labels;
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.setTitle(dialogId, this.labels.listDialogTitle);
                    }
                },
                add: function () {
                    let dlgTitle = this.labels.createItemDialogTitle;
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.setTitle(dialogId, dlgTitle);
                    }
                    location.href = 'EcomVatGroupEdit.aspx?productId=' + this.productId + '&variantId=' + this.variantId + '&languageId=' + this.languageId;
                },
                edit: function (id) {
                    let dlgTitle = this.labels.editItemDialogTitle;
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.setTitle(dialogId, dlgTitle);
                    }

                    if (!id) id = getSelectedRowId();
                    location.href = 'EcomVatGroupEdit.aspx?productId=' + this.productId + '&variantId=' + this.variantId + '&languageId=' + this.languageId + '&vatGroupId=' + id;
                },
                copy: function (id) {
                    if (!id) id = getSelectedRowId();
                    location.href = 'EcomVatGroupEdit.aspx?productId=' + this.productId + '&variantId=' + this.variantId + '&languageId=' + this.languageId + '&vatGroupId=' + id + '&copy=true';
                },
                delete: function (id) {
                    if (confirm(this.labels.deleteMessage)) {
                        if (!id) id = getSelectedRowId();
                        executeCommand('delete', id);
                    }
                },
                deleteSelected: function () {
                    if (confirm(this.labels.deleteMessage)) {
                        var rows = getSelectedRows();
                        if (rows.length > 0) {
                            var ids = rows.map(function (row) { return row.getAttribute('itemid'); })
                            executeCommand('delete', ids.join(','));
                        }
                    }
                },
                onRowSelected: function () {
                    if (this.options.deletePermitted) {
                        var rows = getSelectedRows();

                        if (rows.length > 0) {
                            document.getElementById('cmdDelete').disabled = false;
                        }
                        else {
                            document.getElementById('cmdDelete').disabled = true;
                        }
                    }
                },
                cancel: function () {
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.hide(dialogId);
                    }
                }
            }

            api.initialize(options);
            return api;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="cmd" name="cmd" />
        <input type="hidden" id="rowIds" name="rowIds" />
        <dwc:Card runat="server">
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdCancel" runat="server" Icon="Cancel" Text="Cancel" OnClientClick="currentPage.cancel()" />
                <dw:ToolbarButton ID="cmdAdd" runat="server"  Icon="PlusSquare" Text="New VAT group" OnClientClick="currentPage.add()" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Icon="Remove" Text="Delete VAT group" OnClientClick="currentPage.deleteSelected()" Disabled="true" />
            </dw:Toolbar>

            <dw:List ID="VatGroupList" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25" OnClientSelect="currentPage.onRowSelected();">
                <Filters>
                    <dw:ListAutomatedSearchFilter runat="server" />
                </Filters>
                <Columns>
                    <dw:ListColumn ID="colVatGroup" runat="server" Name="VAT group" EnableSorting="true" />
                    <dw:ListColumn ID="colCountry" runat="server" Name="Country" EnableSorting="true" />
                </Columns>
            </dw:List>
        </dwc:Card>

        <dw:ContextMenu ID="VatGroupContextMenu" runat="server">
            <dw:ContextMenuButton ID="editButton" runat="server" Icon="Pencil" Text="Edit" OnClientClick="currentPage.edit();" />
            <dw:ContextMenuButton ID="copyButton" runat="server" Icon="ContentCopy" Text="Copy" OnClientClick="currentPage.copy();" />
            <dw:ContextMenuButton ID="deleteButton" runat="server" Icon="Delete" Text="Delete" OnClientClick="currentPage.delete();" />
        </dw:ContextMenu>
    </form>
</body>
</html>
