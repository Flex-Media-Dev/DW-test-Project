
var menuActions = {

    contentFrame: function () {
        return document.getElementById("ContentFrame");
    },

    addThread: function () {
        var categoryId = ContextMenu.callingID;
        var parentId = 0;
        var messageId = 0;
        menuActions.contentFrame().src= "MessageEdit.aspx?CategoryID=" + categoryId + "&ParentID=" + parentId + "&MessageID=" + messageId;
    },

    showThreads: function (categoryId) {
        if (categoryId == null || categoryId == 'undefined') {
            categoryId = ContextMenu.callingID;
        }
        menuActions.contentFrame().src = "ListThreads.aspx?CategoryID=" + categoryId;
    },

    editCategory: function (categoryId) {
        if (categoryId == null || categoryId == 'undefined') {
            categoryId = ContextMenu.callingID;
        }

        if (categoryId > 0) {
            menuActions.contentFrame().src = "CategoryEdit.aspx?CategoryID=" + categoryId;
        }
        else {
            menuActions.contentFrame().src = "CategoryEdit.aspx";
        }
    },

    editCategory: function (categoryId) {
        if (categoryId == null || categoryId == 'undefined') {
            categoryId = ContextMenu.callingID;
        }

        if (categoryId > 0) {
            menuActions.contentFrame().src = "CategoryEdit.aspx?CategoryID=" + categoryId;
        }
        else {
            menuActions.contentFrame().src = "CategoryEdit.aspx";
        }
    },

    activateCategoryMenu: function (activate) {
        var categoryId = ContextMenu.callingID;
        window.open("Default.aspx?CategoryID=" + categoryId + "&Activate=" + activate, "mainframe");
    },


    deleteCategory: function () {
        categoryId = ContextMenu.callingID;
        var confirmMessage = "Delete category?\n(" + GroupTree.getNodeByGroupID(categoryId).name + ")" + "\n\nWARNING!\nAll posts in the category will be deleted!";

        if (confirm(confirmMessage)) {

            window.open("PerformForumAction.ashx?cmd=category&CategoryID=" + categoryId, "mainframe");

            var tree = GroupTree.getTree();

            /* Removing the category from the tree */
            if (tree) {
                tree.removeNode(GroupTree.getNodeIDByGroupID(categoryId));
                tree.selectedNode = null;
            }
        }
    },

    addCategory: function () {
        menuActions.editCategory(0);
    },

    listCategory: function () {
        menuActions.contentFrame().src = "CategoryList.aspx";
    },

    contextMenuView: function (sender, args) {
        /// <summary>Determines the contents of the context-menu.</summary>
        /// <param name="sender">Event sender.</param>
        /// <param name="args">Event arguments.</param>
        if (GroupTree.getNodeByGroupID(ContextMenu.callingID).additionalattributes['__isactive'] == true) {
            ret = 'deactivate_cat';
        } else {
            ret = 'activate_cat';
        }
        return ret;
    }

}
