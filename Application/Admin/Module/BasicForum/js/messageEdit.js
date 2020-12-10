var messageEdit =
{

    deleteThreadClick: function (categoryId, parentId) {
        var confirmMessage = "Delete current thread?";
        if (confirm(confirmMessage)) {
            window.open("PerformForumAction.ashx?cmd=thread&CategoryID=" + categoryId + "&ParentID=" + parentId, "ContentFrame");
        }

    },

    deletePostClick: function (categoryId, parentId, messageId) {
        var confirmMessage = "Delete current post?";
        if (confirm(confirmMessage)) {
            window.open("PerformForumAction.ashx?cmd=message&CategoryID=" + categoryId + "&ParentID=" + parentId + "&MessageID=" + messageId, "ContentFrame");
        }
    }
}
