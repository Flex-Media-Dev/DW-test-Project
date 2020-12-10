
var message = {

    filters: null,

    makeSticky: function (categoryId, parentId) {
        var messageId = ContextMenu.callingID;
        window.open("MessageEdit.aspx?CategoryID=" + categoryId + "&ParentID=" + parentId + "&MessageID=" + messageId, "ContentFrame");
    },

    edit: function (categoryId, parentId, messageId) {
        window.open("MessageEdit.aspx?CategoryID=" + categoryId + "&ParentID=" + parentId + "&MessageID=" + messageId, "ContentFrame");
    },

    back: function (categoryId) {
        window.open("ListThreads.aspx?CategoryID=" + categoryId, "ContentFrame");
    },

    list: function (threadId) {
        window.open("ListMessages.aspx?ThreadID=" + threadId, "ContentFrame");
    },

    edit: function (categoryId, parentId, messageId) {

        var qs = Object.toQueryString({
            CategoryID: categoryId,
            filters: message.filters,
            ParentID: parentId,
            MessageID: messageId
        });

        window.open("MessageEdit.aspx?" + qs, "ContentFrame");
    },

    editCategory: function (categoryId) {
        window.open("CategoryEdit.aspx?CategoryID=" + categoryId, "ContentFrame");
    },

    remove: function (categoryId, parentId, messageId) {
        var confirmMessage = "Delete message?";

        if (parentId == 0) {
            confirmMessage = "Delete thread?";
        }

        if (confirm(confirmMessage)) {
            window.open("PerformForumAction.ashx?cmd=message&CategoryID=" + categoryId + "&ParentID=" + parentId + "&MessageID=" + messageId, "ContentFrame");
        }
    },

    deleteThreadClick: function (categoryId) {
        var messageId = ContextMenu.callingID;
        var parentId = ContextMenu.callingItemID;
        var confirmMessage = "Delete thread?";
        if (confirm(confirmMessage)) {
            window.open("PerformForumAction.ashx?cmd=thread&CategoryID=" + categoryId + "&ParentID=" + parentId, "ContentFrame");
        }

    },

    deleteClick: function (categoryId, parentId) {
        var messageId = ContextMenu.callingID;
        message.remove(categoryId, parentId, messageId);
    },

    addThread: function () {
        var categoryId = ContextMenu.callingItemID;
        message.edit(categoryId, 0, 0);
    },

    editClick: function (categoryId, parentId) {
        var messageId = ContextMenu.callingID;
        var parentId = ContextMenu.callingItemID;
        message.edit(categoryId, parentId, messageId);
    },

    editPostClick: function (categoryId, parentId) {
        var messageId = ContextMenu.callingItemID;
        message.edit(categoryId, parentId, messageId);
    },

    editThreadClick: function (categoryId, parentId) {
        var messageId = ContextMenu.callingItemID;
        if (messageId == null)
            messageId = parentId;
        parentId = 0;
        message.edit(categoryId, parentId, messageId);
    },

    listCategory: function () {
        window.open("CategoryList.aspx", "ContentFrame");
    }

}
