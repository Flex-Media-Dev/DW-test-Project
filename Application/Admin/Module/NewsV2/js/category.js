
var category = {
    list: function () {
        main.openInContentFrame("Category_list.aspx");
    },

    add: function () {
        category.edit(0);
    },

    edit: function (categoryId) {
        var url = "Category_edit.aspx?ID=" + categoryId;
        main.openInContentFrame(url);
    },

    sort: function () {
        var url = "Category_sort.aspx";
        main.openInContentFrame(url);
    },

    remove: function (categoryId) {
        if (main.confirmDelete()) {
            main.openInContentFrame("OperationHandler.aspx?cmd=delete_category&CategoryID=" + categoryId);
        }
    },

    editClick: function (categoryId) {
        var categoryId = ContextMenu.callingItemID;
        category.edit(categoryId);
    },

    deleteClick: function () {
        var categoryId = ContextMenu.callingItemID;
        category.remove(categoryId);
    },

    permissions: function (categoryId) {
        var qs = Object.toQueryString({
            'CloseOnExit': 'True',
            'DialogID': 'permissionEditDialog',
            categoryId: categoryId
        });

        var redirect = Object.toQueryString({
            'redirect': encodeURI('/Admin/module/newsv2/CategoryPermissions.aspx?' + qs)
        });

        var d;
        var dialogIfarme;
        if (typeof (dialog) == 'undefined') {
            d = window.parent.dialog;
            dialogIfarme = window.parent.document.getElementById('permissionEditDialogFrame');
        }
        else {
            d = dialog;
            dialogIfarme = document.getElementById('permissionEditDialogFrame');
        }

        d.setTitle('permissionEditDialog', 'Edit permissions');
        dialogIfarme.src = '/Admin/FastLoadRedirect.aspx?' + redirect;
        d.show('permissionEditDialog');
    },

    permissionsClick: function () {
        var categoryId = ContextMenu.callingItemID;
        this.permissions(categoryId);
    }

}
