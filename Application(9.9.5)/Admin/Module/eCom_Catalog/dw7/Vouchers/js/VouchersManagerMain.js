var vouchersManagerMain = {

    contentFrame: function () {
        return window.parent.document.getElementById("ContentFrame");
    },

    showVouchersList: function (ListID) {
        window.location = "VouchersList.aspx?ListID=" + ListID;
    },

    editList: function (ListId) {
        if (ListId == null || ListId == 'undefined') {
            ListId = ContextMenu.callingItemID;
        }

        if (ListId > 0) {
            window.location = 'VouchersListEdit.aspx?ListID=' + ListId;
        }
        else {
            window.location = 'VouchersListEdit.aspx';
        }
    },

    addVouchersListToCategory: function (CategoryID) {
        if (CategoryID == null || CategoryID == 'undefined') {
            CategoryID = ContextMenu.callingItemID;
        }

        if (CategoryID > 0) {
            window.location = 'VouchersListEdit.aspx?CategoryID=' + CategoryID;
        }
        else {
            window.location = 'VouchersListEdit.aspx';
        }
    },

    activateList: function (ListId) {
        if (ListId == 0 || ListId == null) {
            ListId = ContextMenu.callingItemID;
        }
        window.location = "VouchersActions.ashx?cmd=ActivateList&ListID=" + ListId + "&State=true";
    },

    deactivateList: function (ListId) {
        if (ListId == 0 || ListId == null) {
            ListId = ContextMenu.callingItemID;
        }
        window.location = "VouchersActions.ashx?cmd=ActivateList&ListID=" + ListId + "&State=false";
    },
    
    callingItem: function () {
        var item = ContextMenu.callingItemID;
        return eval("(" + item + ")");
    },

    contextMenuView: function (sender, args) {
        if (getListRowByID(ContextMenu.callingID).additionalattributes['__isactive'] == true) {
            ret = 'deactivate_cat';
        }
        else {
            ret = 'activate_cat';
        }
        return ret;
    },

    reloadTree: function () {
        window.location = "VouchersManagerMain.aspx?" + (new Date());
    },

    deleteList: function () {
        var ListId = ContextMenu.callingItemID;
        var confirmMessage = "Delete List?\n" + "\n\nWARNING!\nAll vouchers in the list will be deleted!";
        if (confirm(confirmMessage)) {
            window.location = "VouchersActions.ashx?cmd=DeleteList&ListID=" + ListId;
        }
    }
}
