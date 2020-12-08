/* Represents user row context menu */
var RowContextMenu = function (params) {
    this.context = [];
    this._everyOneGroupID = -1000;

    this.parameters = { menuID: '', onSelectContext: null, groupID: -1 }

    if (params)
        this.parameters = params;
}

/* Registers new context */
RowContextMenu.prototype.registerContext = function (name, buttons) {
    if (!this.context)
        this.context = [];

    this.context[name] = buttons;
}

/* Switches current context menu according to specified context */
RowContextMenu.prototype.enableContext = function (name, userPermissionLevel) {
    var buttons = null;
    var menuItems = null;
    var visibleItems = [];
    var isVirtualGroup = false;

    if (this.parameters.groupID) {
        isVirtualGroup = this.parameters.groupID === this._everyOneGroupID;
    }

    if (this.context) {
        /* Retrieving buttons to be shown in the context menu */
        buttons = this.context[name];

        if (buttons) {
            menuItems = $$('div[id="' + this.parameters.menuID +
                '"] > span[class~="container"] > span');

            if (menuItems && menuItems.length > 0) {
                for (var i = 0; i < menuItems.length; i++) {
                    var canShow = true;
                    var item = menuItems[i];
                    var itemIsDivider = item.select('a[class="divider"]').length > 0;

                    if (isVirtualGroup)
                        canShow = (item.id != 'cmdDetachFromGroup' && item.id != 'cmdNewUser');

                    if (canShow) {
                        var accessPermissionLevel = this.parameters.permissionLevels[item.id];
                        canShow = accessPermissionLevel && userPermissionLevel >= accessPermissionLevel;
                    }

                    /* Showing button */
                    if ((this._findIndex(buttons, item.id) >= 0 || itemIsDivider) && canShow) {
                        /* Tracking all visible items (buttons & dividers) */
                        visibleItems[visibleItems.length] = { element: item, isDivider: itemIsDivider }
                        item.show();
                    }
                    else {
                        item.hide();
                    }
                }

                /* Hiding unnecessary dividers */
                this._hideDividers();
            }
        }
    }
}

/* Shows context menu */
RowContextMenu.prototype.show = function (row, eventObject) {
    var context = null;
    var itemID = '';
    if (row) {
        /* Retrieving user ID */
        itemID = row.id;
        if (itemID == null || itemID.length == 0)
            itemID = row.readAttribute('rowid');

        if (itemID)
            itemID = itemID.replace(/row/gi, '');

        var permissionLevel = row.dataset.permission;

        /* Showing context menu */
        ContextMenu.show(eventObject, this.parameters.menuID, itemID);

        /* Switching context */
        if (typeof (this.parameters.onSelectContext) == 'function') {
            context = this.parameters.onSelectContext(row, itemID);
            this.enableContext(context, permissionLevel);
        }
    }

    return false;
}

/* Hides unnecessary dividers */
RowContextMenu.prototype._hideDividers = function () {
    var index = 0;
    var menu = $(this.parameters.menuID).getElementsBySelector('span.container');
    menu = $(menu)[0].childElements();

    // remove hidden elements 
    var length = menu.length;
    for (var i = 0; i < length; i++) {
        if (!$(menu[i - index]).visible()) {
            menu.splice(i - index, 1);
            index++;
        }
    }

    // remove dividers from start
    while ($(menu[0]).readAttribute('class') === 'divider') {
        $(menu[0]).hide();
        menu.shift();
    }

    // remove deviders from end
    index = menu.length - 1;
    while (index > 0 && $(menu[index]).readAttribute('class') == 'divider') {
        $(menu[index]).hide();
        menu.pop();
        index--;
    }

    // remove double dividers from body
    for (var i = 1; i < menu.length - 1; i++) {
        if ($(menu[i]).readAttribute('class') === 'divider' && $(menu[i + 1]).readAttribute('class') === 'divider') {
            $(menu[i]).hide();
        }
    }
}

/* Searches for specified element in the specified array */
RowContextMenu.prototype._findIndex = function (list, element) {
    var ret = -1;

    if (list && typeof (list) != 'undefined') {
        for (var i = 0; i < list.length; i++) {
            if (list[i] == element) {
                ret = i;
                break;
            }
        }
    }

    return ret;
}

/* Represents user context menu actions */
var UserContext = function (groupID, smartSearchID, repositoryName, repositoryQueryName)
{
    this.groupID = groupID;
    this.smartSearchID = smartSearchID;
    this.repositoryName = repositoryName;
    this.repositoryQueryName = repositoryQueryName;
}

/*  Retrieves query parameters from context */
UserContext.prototype._getQueryParameters = function (isLeadingParameters) {
    return (isLeadingParameters ? '?' : '&') + 'GroupID=' + this.groupID + '&SmartSearchID=' + this.smartSearchID + '&RepositoryName=' + this.repositoryName + '&QueryName=' + this.repositoryQueryName;
}

/* 'Edit user' action */
UserContext.prototype.editUser = function (id) {
    var userID = ContextMenu.callingID;

    if (id != null)
        userID = id;

    this.openEditForm('?UserID=' + userID + this._getQueryParameters());
}

/* 'Delete' | 'Delete selected' action */
UserContext.prototype.deleteUser = function () {
    var message = $('spDeleteUser').innerText;
    var ids = this._getTargetIDs();

    ContextMenu.hide();

    if (typeof (ids) != 'undefined' && ids.indexOf(',') >= 0) {
        message = $('spDeleteUsers').innerText;
    }
    if (confirm(message)) { 
        $('SelectedUserIds').value = ids;
        $('cmd').value = 'Delete';

        List._submitForm();
    }
}

/* 'Activate' | 'Deactivate' | 'Activate selected' | 'Deactivate selected' action */
UserContext.prototype.setActive = function (isActive) {
    $('SelectedUserIds').value = this._getTargetIDs();
    $('cmd').value = 'SetActive';
    $('cmdArgument').value = isActive.toString();

    List._submitForm();
}

/* 'New user' action */
UserContext.prototype.newUser = function (copyFromExisting) {
    var params = this._getQueryParameters(true);

    if (copyFromExisting)
        params += '&CopyFrom=' + ContextMenu.callingID;

    this.openEditForm(params);
}

/* Shows group selection dialog */
UserContext.prototype.showGroupsDialog = function () {
    dialog.show('AttachGroupsDialog');
}

/* Shows group selection dialog with all groups for the selected user */
UserContext.prototype.showAllGroupsDialog = function () {
    $('SelectedUserIds').value = this._getTargetIDs();
    $('cmd').value = 'showAllGroups';

    List._submitForm();
}

/* Fired when groups are selected */
UserContext.prototype.attachToGroups = function () {    
    $('cmd').value = 'Attach';
    $('cmdArgument').value = $('GroupsSelectorhidden').value;

    List._submitForm();
}

/* 'Detach from group' action */
UserContext.prototype.detachFromGroup = function () {
    $('SelectedUserIds').value = this._getTargetIDs();
    $('cmd').value = 'Detach';

    List._submitForm();
}

/* Opens user edit form */
UserContext.prototype.openEditForm = function (params) {
    document.location = 'EditUser.aspx' + params;
}

/* Retrieves action IDs */
UserContext.prototype._getTargetIDs = function () {
    var row = List.getRowByID('UserList', ContextMenu.callingID);
    var ret = ContextMenu.callingID;

    if (row) {
        if (List.rowIsSelected(row)) {
            ret = this._getSelectedIDs();
        }
    }

    return ret;
}

/* Retrieves IDs selected by the 'Multi-select' method */
UserContext.prototype._getSelectedIDs = function () {
    var rows = List.getSelectedRows('UserList');
    var ret = '', userID = '';

    if (rows && rows.length > 0) {
        for (var i = 0; i < rows.length; i++) {
            userID = rows[i].id;
            if (userID != null && userID.length > 0) {
                ret += (userID.replace(/row/gi, '') + ',')
            }
        }
    }

    if (ret.length > 0) {
        ret = ret.substring(0, ret.length - 1);
    }

    return ret;
}

function getVarValueFromURL(url, varName) {
    var query = url.substring(url.indexOf('?') + 1);
    var vars = query.split("&");
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");
        if (pair[0] === varName) {
            return pair[1];
        }
    }
    return "";
}