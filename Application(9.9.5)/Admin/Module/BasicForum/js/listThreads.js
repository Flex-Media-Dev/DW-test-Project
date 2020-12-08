var listThreads = {

    contentFrame: function () {
        return document.getElementById("ContentFrame");
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

            row = List.getRowByID('List1', args.callingID);

            if (row.readAttribute('__sticky') == 'true') {
                ret = 'unsticky';
            } else {
                ret = 'sticky';
            }
            return ret;
        }
    },

//    deleteThreadClick: function (categoryId) {
//        var parentId = ContextMenu.callingItemID;
//        var confirmMessage = "Delete thread?";
//        if (confirm(confirmMessage)) {
//            window.open("PerformForumAction.ashx?cmd=thread&CategoryID=" + categoryId + "&ParentID=" + parentId, "ContentFrame");
//        }
//    },

    openInContentFrame: function (url) {
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

    stickThread: function (categoryId, stick) {
        var parentID = ContextMenu.callingItemID;
        listThreads.openInContentFrame("ListThreads.aspx?CategoryID=" + categoryId + "&ThreadID=" + parentID + "&Stick=" + stick);
    }

}

