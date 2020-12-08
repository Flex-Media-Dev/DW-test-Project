var forumCategory = {

    contentFrame: function () {
        return document.getElementById("ContentFrame");
    },

    addThread: function (categoryId) {
        var parentId = 0;
        var messageId = 0;
        window.open("MessageEdit.aspx?CategoryID=" + categoryId, "ContentFrame");
    },


    listControl: {
        callingItem: function () {
            var item = ContextMenu.callingItemID;
            return eval("(" + item + ")");
        },

        contextMenuView: function (sender, args) {
            /// <summary>Determines the contents of the context-menu.</summary>
            /// <param name="sender">Event sender.</param>
            /// <param name="args">Event arguments.</param>

            var ret = '';
            var row = null;
            var activeRows = 0;

            row = List.getRowByID('categoriesList', args.callingID);

            if (row.readAttribute('__active') == 'true') {
                ret = 'deactivate_cat';
            } else {
                ret = 'activate_cat';
            }
            return ret;
        }
    },

    addCategory: function () {
        forumCategory.editCategory(0);
    },

    activateCategoryMenu: function (activate) {
        var categoryId = ContextMenu.callingItemID;
        window.parent.open("PerformForumAction.ashx?cmd=categoryactivate&CategoryID=" + categoryId + "&Activate=" + activate, "mainframe");
    },

    deleteCategoryRibbon: function (categoryId) {
        var confirmMessage = "Delete current category?\n \nWARNING!\nAll posts in the category will be deleted!";

        if (confirm(confirmMessage)) {
            window.parent.open("PerformForumAction.ashx?cmd=category&CategoryID=" + categoryId, "mainframe");
        }
    },


    deleteCategoryMenu: function (categoryId) {
        callingID = ContextMenu.callingID;
        categoryId = ContextMenu.callingItemID;

        row = List.getRowByID('categoriesList', callingID);
        var confirmMessage = "Delete category?\n(" + row.childElements()[1].innerText + ")" + "\n\nWARNING!\nAll posts in the category will be deleted!";

        if (confirm(confirmMessage)) {
            window.parent.open("PerformForumAction.ashx?cmd=category&CategoryID=" + categoryId, "mainframe");
        }
    },

    deleteCategory: function (categoryId) {
        if (categoryId == 0 || categoryId == null) {
            categoryId = ContextMenu.callingItemID;
        }
        var confirmMessage = "Delete category?\n(" + GroupTree.getNodeByGroupID(categoryId).name + ")" + "\n\nWARNING!\nAll posts in the category will be deleted!";

        if (confirm(confirmMessage)) {
            forumCategory.openInContentFrame("PerformForumAction.ashx?cmd=category&CategoryID=" + categoryId, "ContentFrame");
        }
    },


    editCategory: function (categoryId) {
        if (categoryId == 0 || categoryId == null) {
            categoryId = ContextMenu.callingItemID;
        }

        var qs = Object.toQueryString({
            categoryId: categoryId,
            filters: message.filters
        });

        forumCategory.openInContentFrame("CategoryEdit.aspx?" + qs);
    },

    showThreads: function (categoryId) {
        if (categoryId == null || categoryId == 'undefined') {
            categoryId = ContextMenu.callingID;
        }

        var cf = document.getElementById("ContentFrame");
        if (cf) {
            cf.src = "ListThreads.aspx?CategoryID=" + categoryId;
        }
        else {
            forumCategory.openInContentFrame("ListThreads.aspx?CategoryID=" + categoryId);
        }
    },

    makeUrlUnique: function (url) {
        var s = "?";
        if (url.indexOf("?") > 0) {
            s = "&";
        }
        return url + s + "zzz=" + Math.random();
    },

    openInContentFrame: function (url) {
        url = this.makeUrlUnique(url);
        var cf = window.parent.document.getElementById("ContentFrame");
        if (cf) {
            cf.src = url;
        }
        else if (window.opener) {
            window.opener.location.href = url; //open in opener window
        }
        else {
            window.location.href = url; //reload current window
        }

    },

    permissions: function (categoryId) {
        var qs = Object.toQueryString({
            'CloseOnExit': 'True',
            'DialogID': 'permissionEditDialog',
            CategoryID: categoryId
        });

        var redirect = Object.toQueryString({
            'redirect': encodeURI('/Admin/Module/BasicForum/Moderators.aspx?' + qs)
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
    }
}
