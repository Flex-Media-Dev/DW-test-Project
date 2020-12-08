var DirectPaths = {
    editSave: function (close) {
        DirectPaths.initiatePostBack("ItemEdit", close ? "close" : "")
    },

    initiatePostBack: function (action, target) {
        var f = document.getElementById('MainForm');
        var postBackField = document.getElementById('PostBackAction');

        if (typeof (WaterMark) != 'undefined') {
            WaterMark.hideAll();
        }

        if (!f && document.forms.length > 0) {
            f = document.forms[0];
        }

        if (postBackField)
            postBackField.value = action + ':' + target;

        f.submit();
    },

    deleteItems: function (itemID) {
        var msg = document.getElementById('confirmDelete').innerHTML;

        if (typeof (itemID) == 'undefined') {
            itemID = this.getTargetIDs(true);
        }

        ContextMenu.hide();
        if (itemID) {
            if (confirm(msg)) {
                this.initiatePostBack('ItemDelete', itemID);
            }
        }
        if (window.event) {
            window.event.cancelBubble = true;
            if (window.event.stopPropagation) {
                window.event.stopPropagation();
            }
        }

        return false;
    },

    activateItems: function () {
        this.initiatePostBack('ItemActivate', this.getTargetIDs());
    },

    deactivateItems: function () {
        this.initiatePostBack('ItemDeactivate', this.getTargetIDs());
    },

    setItemsStatus: function (status) {
        this.initiatePostBack('ItemStatus_' + status, this.getTargetIDs());
    },

    editItem: function (id) {
        Action.Execute({
            Name: "OpenScreen",
            Url: "Edit.aspx?id=" + id
        });
    },

    getTargetIDs: function (delCmd) {
        var ret = '';
        var rows = List.getSelectedRows('lstPaths');
        var lim = delCmd ? 0 : 1;
        if (rows != null && rows.length > lim) {
            for (var i = 0; i < rows.length; i++) {
                ret += rows[i].id.replace(/row/gi, '');
                if (i < rows.length - 1) {
                    ret += ',';
                }
            }
        } else {
            ret = ContextMenu.callingID;
        }

        return ret;
    },

    onSelectItemContextMenuView: function (sender, args) {
        var ret = '';
        var row = null;
        var activeRows = 0;
        var rows = List.getSelectedRows('lstPaths');

        if (rows == null || rows.length < 2) {
            if (rows.length > 0) {
                row = rows[0];
            } else {
                row = List.getRowByID('lstPaths', args.callingID);
            }

            if (!row.classList.contains("dis")) {
                ret = 'SingleActiveItem';
            } else {
                ret = 'SingleInactiveItem';
            }
        } else {
            for (var i = 0; i < rows.length; i++) {
                row = rows[i];
                if (row.readAttribute('__active') == 'true') {
                    activeRows += 1;
                }
            }

            if (activeRows == rows.length) {
                ret = 'MultipleActiveItems';
            } else if (activeRows == 0) {
                ret = 'MultipleInactiveItems';
            } else {
                ret = 'MixedItems';
            }
        }

        return ret;
    },

    swichToBatchEditMode: function () {
        var ids = $("lstPaths_body").select("tr[itemid]").invoke("getAttribute", "itemid").join(",");
        $("pathIds").value = ids;

        theForm.action = "ListItemBatchEditing.aspx?areaFilter=" + $("lstPaths:areaFilter").value;
        theForm.__VIEWSTATE.value = "";
        theForm.submit();
    },

    swichToListMode: function() {
        window.location = "List.aspx?restore=true";
    },

    batchMode_ListInit: function () {
        var rows = dwGrid_Items.rows.getAll();
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            DirectPaths.ensureLinkValidator(row);
        }
        if (typeof (ValidatorOnLoad) == "function") {
            ValidatorOnLoad();
        }
        dwGrid_Items.onRowAddedCompleted = DirectPaths.batchMode_rowAdded;
    },

    ensureLinkValidator: function (row) {
        var ctrl = row.findControl("__link__");
        if (ctrl) {
            validatorElId = row.element.id + "__link__validator"
            dwGrid_Items.ensureValidators([validatorElId])
            var validatorEl = document.getElementById(validatorElId);
            dwGrid_Items.registerValidators([validatorEl]);
            validatorEl.controltovalidate = "Link_" + ctrl.id;
            validatorEl.evaluationfunction = "CustomValidatorEvaluateIsValid";
            validatorEl.clientvalidationfunction = "checkLinkRequired";
            validatorEl.validateemptytext = "true";            
        }
    },

    batchMode_Save: function (close) {
        document.getElementById("SubAction").value = close ? "Close" : "";
        document.getElementById("SaveButton").click();
    },

    batchMode_rowAdded: function (row) {
        DirectPaths.ensureLinkValidator(row);
        if (typeof (ValidatorOnLoad) == "function") {
            ValidatorOnLoad();
        }
    },

    batchMode_handleRowSelected: function (obj) {
        var row = dwGrid_Items.findContainingRow(obj);
        if (row) {
            var rows = dwGrid_Items.rows.getAll();
            for (var i = 0; i < rows.length; i++) {
                var currentRow = rows[i];
                var actionId = currentRow.element.id + "_DeleteAction";
                var ctrl = currentRow.findControl(actionId);
                if (ctrl) {
                    if (currentRow.rowIndex == row.rowIndex) {
                        currentRow.findControl(actionId).style.visibility = "visible";
                    } else {
                        currentRow.findControl(actionId).style.visibility = "hidden";
                    }
                }
            }
        }
    },

    batchMode_DeleteRow: function (obj) {
        var cur_row = dwGrid_Items.findContainingRow(obj);
        DirectPaths._batchMode_deleteRow(cur_row);
    },

    _batchMode_deleteRow: function (row) {
        for (var i = Page_Validators.length - 1; i >= 0; i--)
            if (Page_Validators[i].id.indexOf(row.element.id) == 0)
                Page_Validators.splice(i, 1);
        dwGrid_Items.deleteRows([row]);
    }
};

//validation
function checkRequired(sender, args) {
    var val = args.Value;
    if (!val || val.trim().length == 0) {
        markControl(sender, false);
        args.IsValid = false;
        return;
    }

    markControl(sender, true);
    args.IsValid = true;
}

function checkLinkRequired(sender, args) {
    checkRequired(sender, args);
}

function markControl(sender, isValid) {
    var ctrl = document.getElementById(sender.controltovalidate);
    if (isValid) {
        ctrl.removeClassName("invalidcell");
    }
    else {
        ctrl.addClassName("invalidcell");
    }
}

String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, "");
}