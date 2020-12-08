var dwGlobal = dwGlobal || {};
dwGlobal.marketing = dwGlobal.marketing || {};

dwGlobal.marketing.dialogId = "pwDialog";

dwGlobal.marketing.getCheckedRows = function (listId) {
    var ids = null;
    var checkedRows = window.List.getSelectedRows(listId);
    if (checkedRows && checkedRows.length > 0) {
        ids = checkedRows.map(function (row) { return row.attributes.itemid.value; });
    }
    else if (window.ContextMenu.callingItemID) {
        ids = [window.ContextMenu.callingItemID];
    }
    return ids || [];
};

dwGlobal.marketing.navigate = function (url) {
    window.location = url;
};

dwGlobal.marketing.executeTask = function (name, parameters, onComplete, silentMode) {
    /// <summary>Exeuctes specified server task.</summary>
    /// <param name="name">Name of the task.</param>
    /// <param name="parameters">Object containing task parameters.</param>
    /// <param name="onComplete">Callback to be executed when task completes.</param>
    /// <param name="silentMode">Value indicating whether not to perform any UI updates (such as disabling of UI elements) while the task is executing.</param>

    var url = '';
    var ret = null;
    var self = this;

    var onCompleteFn = onComplete || function () { }

    if (name) {
        url = '/Admin/Module/OMC/Task.ashx?Name=' + encodeURIComponent(name) + '&timestamp=' + (new Date()).getTime();

        ret = Dynamicweb.Ajax.doPostBack({
            url: url,
            explicitMode: true,
            parameters: parameters || {},
            onComplete: function (transport) {
                onCompleteFn(transport.responseText);
            }
        });
    }
    else {
        onCompleteFn('');
    }

    return ret;
};

dwGlobal.marketing.showDialog = function (url, width, height, params, okAction) {
    params = params || {};
    var dialogId = dwGlobal.marketing.dialogId;
    if (url && url.length) {
        if (params.title) dialog.setTitle(dialogId, params.title);

        var okBtn = dialog.get_okButton(dialogId);
        if (okAction != null && okBtn) {
            okBtn.on("click", okAction);
        } else if (okBtn) {
            okBtn.hide();
        }
        var size = null;
        switch (true) {
            case (height <= 350): {
                size = dialog.sizes.small;
                break;
            }
            case (height < 500): {
                size = dialog.sizes.medium;
                break;
            }
            case (height >= 500): {
                size = dialog.sizes.large;
                break;
            }
        }
        dialog.show(dialogId, url, size);
    }
}

dwGlobal.marketing.hideDialog = function () {
    var dialogId = dwGlobal.marketing.dialogId;
    dialog.hide(dialogId);
}