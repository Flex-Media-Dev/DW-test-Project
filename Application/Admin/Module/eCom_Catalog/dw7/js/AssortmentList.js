var assortmentList = {
    addAssortment: function () {
        document.location.href = '/Admin/module/eCom_Catalog/dw7/edit/EcomAssortment_Edit.aspx?backUrl=' + encodeURIComponent('/Admin/module/eCom_Catalog/dw7/lists/EcomAssortment_List.aspx');
    },

    editAssortment: function (id) {
        if (!id) {
            id = ContextMenu.callingItemID;
        }

        document.location.href = '/Admin/module/eCom_Catalog/dw7/edit/EcomAssortment_Edit.aspx?CMD=EDIT_ASSORTMENT&ID=' + id + '&backUrl=' + encodeURIComponent('/Admin/module/eCom_Catalog/dw7/lists/EcomAssortment_List.aspx');
    },

    deleteAssortment: function () {
        var row = List.getRowByID('AssortmentList', ContextMenu.callingID);
        if (row) {
            let hasRelation = row.getAttribute('HasRelation');
            let userAssotiated = row.getAttribute('HasUserAssotiated');

            let str1 = hasRelation ? eCommerce.MasterPage.getInstance().get_terminology()['AssortDelConfirmText1'] : '';
            let str2 = userAssotiated ? eCommerce.MasterPage.getInstance().get_terminology()['AssortDelConfirmText2'] : '';
            let str3 = eCommerce.MasterPage.getInstance().get_terminology()['AssortDelConfirmText3'];

            if ((hasRelation || userAssotiated) && !confirm(str1 + str2 + str3)) {
                return;
            }

            document.location.href = '/Admin/module/eCom_Catalog/dw7/edit/EcomAssortment_Edit.aspx?CMD=DELETE_ASSORTMENT&ID=' + ContextMenu.callingItemID;
        }
    },

    rebuildAssortment: function () {
        let isAssortmentRebuiltRunning = false;
        let node = this.findTreeNode(ContextMenu.callingItemID);

        if (node) {
            isAssortmentRebuiltRunning = node.additionalattributes['IsAssortmentRebuiltRunning'];
        }
        if (isAssortmentRebuiltRunning) {
            return;
        }

        new Ajax.Request('/Admin/module/eCom_Catalog/dw7/edit/EcomAssortment_Edit.aspx?CMD=BUILD_ASSORTMENT&ID=' + ContextMenu.callingItemID, {
            method: 'get'
        });
    },

    attachShop: function () {
        let id = ContextMenu.callingItemID;

        var win = window.open('/Admin/module/ecom_catalog/dw7/edit/EcomGroupTree.aspx?CMD=AttachShop&AssortmentID=' + id + '&clientedit=false', '', 'displayWindow,width=460,height=400,scrollbars=no');
    },

    attachGroup: function () {
        let id = ContextMenu.callingItemID;

        var win = window.open('/Admin/module/ecom_catalog/dw7/edit/EcomGroupTree.aspx?CMD=AttachGroup&AssortmentID=' + id + '&clientedit=false', '', 'displayWindow,width=460,height=400,scrollbars=no');
    },

    attachProduct: function () {
        let id = ContextMenu.callingItemID;

        var win = window.open('/Admin/module/ecom_catalog/dw7/edit/EcomGroupTree.aspx?CMD=ShowProdGroupList&AppendType=AppendProduct&AssortmentID=' + id + '&clientedit=false', '', 'displayWindow,width=460,height=400,scrollbars=no');
    },

    newPermissions: function () {
        let id = ContextMenu.callingItemID;
        eCommerce.startPermissions('', '', '0', '_GROUPS_ASSORTMENTS_' + id);
    },

    onAssortmentListSelectView: function () {
        var ret = [];
        var row = List.getRowByID('AssortmentList', ContextMenu.callingID);
        if (row) {
            var permissionLevel = parseInt(row.getAttribute('PermissionLevel'));
            ret[0] = 'cmdRebuildAssortment';

            if (permissionLevel >= PermissionLevels.PermissionLevelDelete) {
                ret[ret.length] = 'cmdDeleteAssortment';
            }
            if (permissionLevel >= PermissionLevels.PermissionLevelAll) {
                ret[ret.length] = 'cmdAssortmentPermissions';
            }
            if (permissionLevel >= PermissionLevels.PermissionLevelEdit) {
                ret[ret.length] = 'cmdEditAssortment';
                ret[ret.length] = 'cmdEditAssortment2';
                ret[ret.length] = 'cmdAssortmentAttachShop';
                ret[ret.length] = 'cmdAssortmentAttachGroup';
                ret[ret.length] = 'cmdAssortmentAttachProduct';
            }
        }

        return ret;
    },

    onAssortmentListRebuildGetState: function () {
        let node = this.findTreeNode(ContextMenu.callingItemID);
        if (!node) {
            return 'disabled';
        }

        var isAssortmentRebuiltRunning = node.additionalattributes['IsAssortmentRebuiltRunning'];
        if (isAssortmentRebuiltRunning === true) {
            return 'disabled';
        }

        return 'enabled';
    },

    findTreeNode(itemId) {
        var tree = eCommerce.SystemTree.getInstance();
        var node = tree.findNode('GROUPS/ASSORTMENTS/' + itemId);

        return node;
    }
};