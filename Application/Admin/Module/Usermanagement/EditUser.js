
/* Represents user row context menu */
var RowContextMenu = function (params) {
    this.context = [];

    this.parameters = { menuID: '', onSelectContext: null, userID: -1 }

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
RowContextMenu.prototype.enableContext = function (name) {
    var buttons = null;
    var menuItems = null, item = null;
    if (this.context) {
        /* Retrieving buttons to be shown in the context menu */
        buttons = this.context[name];

        if (buttons) {
            menuItems = $$('div[id="' + this.parameters.menuID +
                '"] > span[class~="container"] > span');

            if (menuItems && menuItems.length > 0) {

                /* Show dividers */
                var dividers = $$('div[id="' + this.parameters.menuID + '"] > span[class~="container"] > div[class="divider"]');
                for (var i = 0; i < dividers.length; i++) {
                    $(dividers[i]).show();
                }

                for (var i = 0; i < menuItems.length; i++) {
                    item = menuItems[i];
                    
                    /* Showing button */
                    if (this._findIndex(buttons, item.id) >= 0) {
                        /* Tracking all visible items (buttons & dividers) */
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

        /* Showing context menu */
        ContextMenu.show(eventObject, this.parameters.menuID, itemID);

        /* Switching context */
        if (typeof (this.parameters.onSelectContext) == 'function') {
            context = this.parameters.onSelectContext(row, itemID);
            this.enableContext(context);
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
var AddressContext = function (userID, groupID, smartSearchID, repositoryName, repositoryQueryName, deleteSingleMsg, deleteMultipleMsg, deleteMainAddressMsg, deleteDefaultAddressMsg) {
    this.userID = userID;
    this.groupID = groupID;
    this.smartSearchID = smartSearchID;
    this.repositoryName = repositoryName;
    this.repositoryQueryName = repositoryQueryName;
    this.deleteSingleMsg = deleteSingleMsg;
    this.deleteMultipleMsg = deleteMultipleMsg;
    this.deleteMainAddressMsg = deleteMainAddressMsg;
    this.deleteDefaultAddressMsg = deleteDefaultAddressMsg;
}

AddressContext.prototype.navigateEditAddress = function () {
    var addressID = ContextMenu.callingID;
    if (addressID != null) {
        this._editAddress(addressID, false);
    } else {
        this.navigateNewAddress();
    }
}

AddressContext.prototype.navigateNewAddress = function () {
    this._editAddress(0, true);
}

AddressContext.prototype._editAddress = function (addressId, isNew) {
    document.location = 'EditUserAddress.aspx?UserID=' + this.userID + '&GroupID=' + this.groupID + '&AddressID=' + addressId + '&СreateNew=' + isNew + '&SmartSearchID=' + this.smartSearchID + '&RepositoryName=' + this.repositoryName + '&QueryName=' + this.repositoryQueryName;
}

/* 'Delete' | 'Delete selected' action */
AddressContext.prototype.removeAddress = function () {
    var ids = this._getTargetIDs();
    ContextMenu.hide();

    if (this._isMainAddressSelected()) {
        alert(this.deleteMainAddressMsg)
    }else if(this._isDefaultAddressSelected()){
        alert(this.deleteDefaultAddressMsg)
    } else {
        var deleteMsg = this.deleteSingleMsg
        if (ids.indexOf(',') != -1) {
            deleteMsg = this.deleteMultipleMsg;
        }
        if (confirm(deleteMsg)) {
            document.location = 'EditUser.aspx?RemoveAddress=True&UserID=' + this.userID + '&GroupID=' + this.groupID + '&RemoveAddressID=' + ids;
        }
    }
}

AddressContext.prototype.makeDefaultAddress = function () {
    var addressID = ContextMenu.callingID;
    ContextMenu.hide();
    document.location = 'EditUser.aspx?MakeDefault=True&UserID=' + this.userID + '&GroupID=' + this.groupID + '&AddressID=' + addressID;
}

/* Retrieves action IDs */
AddressContext.prototype._getTargetIDs = function () {
    var row = List.getRowByID('AddressList', ContextMenu.callingID);
    var ret = ContextMenu.callingID;

    if (row) {
        if (List.rowIsSelected(row)) {
            ret = this._getSelectedIDs();
        }
    }

    return ret;
}

/* Retrieves IDs selected by the 'Multi-select' method */
AddressContext.prototype._getSelectedIDs = function () {
    var rows = List.getSelectedRows('AddressList');
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

AddressContext.prototype._isMainAddressSelected = function () {
    var rows = List.getSelectedRows('AddressList');    
    if (rows && rows.length > 0) {
        for (var i = 0; i < rows.length; i++) {
            if (rows[i].readAttribute('__isMainAddress') == 'true')
                return true;
        }
    }
    if (ContextMenu.callingID != null) {
        var row = List.getRowByID('AddressList', ContextMenu.callingID);
        if (row && row.readAttribute('__isMainAddress') == 'true') {            
            return true;
        }
    }
    return false;
}

AddressContext.prototype._isDefaultAddressSelected = function () {
    var rows = List.getSelectedRows('AddressList');
    if (rows && rows.length > 0) {
        for (var i = 0; i < rows.length; i++) {
            if (rows[i].readAttribute('__isDefault') == 'true')
                return true;
        }
    }
    if (ContextMenu.callingID != null) {
        var row = List.getRowByID('AddressList', ContextMenu.callingID);
        if (row && row.readAttribute('__isDefault') == 'true') {
            return true;
        }
    }
    return false;
}

function getSelectedRows() {
    var rows = new Array;

    // The item that is right clicked
    if (ContextMenu.callingItemID != null) rows[0] = ContextMenu.callingItemID;

    // The selected items in the list (will overwrite the right clicked item if any exists)
    var selectedRows = List.getSelectedRows('AddressList');
    if (selectedRows.length > 0) {
        for (var i = 0; i < selectedRows.length; i++) {
            rows[i] = selectedRows[i].attributes['id'].value;
        }
    }
    return rows;
}

function addressListRowSelected() {
    var selectedRows = getSelectedRows();
    if (selectedRows.length > 0 && selectedRows.indexOf("0") < 0) {
        Ribbon.enableButton('BtnDeleteAddresses');        
    } else {
        Ribbon.disableButton('BtnDeleteAddresses');        
    }
}

/* Represents order list page commands */
var OrderListPage = function (userID, groupID, deleteMsg) {
    this.userID = userID;
    this.groupID = groupID;
    this.deleteMsg = deleteMsg;
}


OrderListPage.enableResetButton = function () {
	Ribbon.enableButton('ButtonReset');
}

OrderListPage.ResetFilters = function () {
    // Set Action
    //$('ActionHidden').value = "ResetFilters";

    document.getElementById('OrderList:OrderStateFilter').selectedIndex = 0;
    document.getElementById('OrderList:CaptureStateFilter').selectedIndex = 0;
    document.getElementById('OrderList:CompletedFilter').selectedIndex = 0;
    document.getElementById('OrderList:DatePresetFilter').selectedIndex = 0;
    Calendar.DWClearDate('FromDateFilter:DateSelector');
    Calendar.DWClearDate('ToDateFilter:DateSelector');
    document.getElementById('OrderList:PageSizeFilter').value = "25";
    document.getElementById('OrderList:TextFilter').value = "";

    OrderListPage.ApplyFilters();
}

OrderListPage.ApplyFilters = function () {
    // Submit
    List._submitForm('EditUserForm');
}

/* This is executed when a preset is selected in the preset dropdown */
OrderListPage.setDatePreset = function () {
	var fromDatePrefix = 'FromDateFilter:DateSelector';
	var toDatePrefix = 'ToDateFilter:DateSelector';
	var preset = document.getElementById('OrderList:DatePresetFilter').value;

	var today = new Date();
	today.setHours(0, 0, 0, 0);


	if (preset == 'All_Time') {
		Calendar.DWClearDate(fromDatePrefix);
		Calendar.DWClearDate(toDatePrefix);
	} else if (preset == 'Today') {
		Calendar.updateDWLabel(fromDatePrefix, today, true);
		Calendar.updateDWLabel(toDatePrefix, today, true);
	} else if (preset == 'Last_Week') {
		var lastWeek = new Date()
		lastWeek.setHours(0, 0, 0, 0);
		lastWeek.setTime(lastWeek.getTime() - 1000 * 60 * 60 * 24 * 6);
		Calendar.updateDWLabel(fromDatePrefix, lastWeek, true);
		Calendar.updateDWLabel(toDatePrefix, today, true);
	} else if (preset == 'Last_Month') {
		var lastMonth = new Date()
		lastMonth.setHours(0, 0, 0, 0);
		var month = lastMonth.getMonth() - 1;
		if (month == -1)
			lastMonth.setFullYear(lastMonth.getFullYear() - 1, 11);
		else
			lastMonth.setMonth(month)
		Calendar.updateDWLabel(fromDatePrefix, lastMonth, true);
		Calendar.updateDWLabel(toDatePrefix, today, true);
	} else if (preset == 'Last_6_Months') {
		var last6Months = new Date()
		last6Months.setHours(0, 0, 0, 0);
		var month = last6Months.getMonth() - 6;
		if (month < 0)
			last6Months.setFullYear(lastMonth.getFullYear() - 1, month + 12);
		else
			last6Months.setMonth(month)
		Calendar.updateDWLabel(fromDatePrefix, last6Months, true);
		Calendar.updateDWLabel(toDatePrefix, today, true);
	} else if (preset == 'Last_Year') {
		var lastYear = new Date()
		lastYear.setHours(0, 0, 0, 0);
		lastYear.setFullYear(lastYear.getFullYear() - 1);
		Calendar.updateDWLabel(fromDatePrefix, lastYear, true);
		Calendar.updateDWLabel(toDatePrefix, today, true);
	}

	// Reset selection
	if (preset != '')
	    document.getElementById('OrderList:DatePresetFilter').selectedIndex = 0;
}

OrderListPage.viewOrder = function (orderID) {
    parent.document.location.href = '/Admin/Module/eCom_Catalog/dw7/Edit/EcomOrder_Edit.aspx?Caller=usermanagement&ID=' + orderID;
}

OrderListPage.prototype.showOrder = function () {
    var rowID = ContextMenu.callingItemID;
    OrderListPage.viewOrder(rowID);
}

OrderListPage.prototype.deleteOrder = function () {
    ContextMenu.hide();

    if (confirm(this.deleteMsg))
        this.performMenuAction("DeleteOrder");
}

OrderListPage.prototype.setOrderState = function (orderState) {
    $('SelectedOrderStateID').value = orderState;
    this.performMenuAction("SetOrderState");
}

OrderListPage.prototype.createRma = function () {
    var rowID = ContextMenu.callingItemID;
    parent.document.location.href = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomRma_Edit.aspx?Caller=usermanagement&OrderID=" + rowID;
}

OrderListPage.prototype.printOrder = function () {
    var rowID = ContextMenu.callingItemID;
    parent.document.location.href = "/Admin/Module/eCom_Catalog/dw7/OrderList.aspx?Caller=usermanagement&PageNumber=1&print=true&printOrderId=" + rowID + "&AccessUserId=" + this.userID;
}

OrderListPage.prototype.captureOrder = function () {
    var rowID = ContextMenu.callingItemID;
    window.open("/Admin/Module/eCom_Catalog/dw7/OrderBulkCapture.aspx?IDs=" + rowID, "Capture order");   
}

OrderListPage.prototype.performMenuAction = function (action) {
    // Set Action
    $('ActionHidden').value = action;
    $('OrderIDsHidden').value = ContextMenu.callingItemID;

    // Submit
    List._submitForm('EditUserForm');
}

//Impersonation functionality
var ImpersonationContext = function (userID, groupID) {
    this.userID = userID;
    this.groupID = groupID;    
}

ImpersonationContext.prototype.saveImpersonationDialog = function () {
    document.getElementById('EditUserForm').action = 'EditUser.aspx?UserID=' + this.userID + '&GroupID=' + this.groupID + '&SaveImpersonationDialog=true';
    document.getElementById('EditUserForm').submit();
    dialog.hide('ImpersonationDialog');
}

function changeItemType() {
    var e = Dynamicweb.UserManagement.User.Editors.current();
    e.saveChanges();
}

function closeChangeItemTypeDialog() {
    var e = Dynamicweb.UserManagement.User.Editors.current();
    e.cancelChanges();
}

function showErrors(options) {
    var _noEmailMsg = $('NoEmailDiv');
    var _noUsernameMsg = $('NoUsernameDiv');
    var _noNameMsg = $('NoNameDiv');
    var _usernameTakenMsg = $('UsernameTakenDiv');
    var _wrongEmailMsg = $('WrongEmailFormatDiv');

    if (_noEmailMsg) {
        _noEmailMsg.style.display = options.noEmail ? '' : 'none';
    }
    if (_noUsernameMsg) {
        _noUsernameMsg.style.display = options.noUsername ? '' : 'none';
    }
    if (_usernameTakenMsg) {
        _usernameTakenMsg.style.display = options.nameTaken ? '' : 'none';
    }
    if (_wrongEmailMsg) {
        _wrongEmailMsg.style.display = options.wrongEmail ? '' : 'none';
    }
    if (_noNameMsg) {
        _noNameMsg.style.display = options.noName ? '' : 'none';
    }
}

/* Editor configuration */
function popupEditorConfiguration() {
    // Set selected value
    // Have to do this everytime the dialog opens, because the user might have opened it before and hit cancel.
    var dropdown = $('ConfigurationSelector');
    var hidden = $('ConfigurationSelectorValue');
    for (i = 0; i < dropdown.length; i++) {
        if (dropdown[i].value == hidden.value) {
            dropdown.selectedIndex = i;
            break;
        }
    }
    // Show dialog
    dialog.show("EditorConfigurationDialog");
}

function setEditorConfiguration() {
    $('ConfigurationSelectorValue').value = $('ConfigurationSelector').value;
    dialog.hide('EditorConfigurationDialog');
}

function popupAllowBackend() {
    var checkbox = $('AllowBackendCheckbox');
    var hidden = $('AllowBackendValue');
    checkbox.checked = hidden.value == 'true' ? true : false;
    dialog.show('AllowBackendDialog');
}

function setAllowBackend() {
    $('AllowBackendValue').value = $('AllowBackendCheckbox').checked ? 'true' : 'false';
    if ($('AllowBackendCheckbox').checked) {
        $('AllowBackendLoginButton').addClassName('active');
    } else {
        $('AllowBackendLoginButton').removeClassName('active');
    }
    dialog.hide('AllowBackendDialog');
}

function SetMainDiv(action) {
    var editUserForm = $('EditUserForm');
    editUserForm.action = 'EditUser.aspx' +
        '?GroupID=' + groupID +
        '&UserID=' + userID +
        '&' + action + "=True";
    editUserForm.submit();
}

(function (ns) {
    var editor = {
        init: function (opts) {
            this.options = opts;
            this.options.ids = this.options.ids || {
                dialog: "ItemTypeDialog",
                form: "EditGroupForm",
                waitOverlay: "UpdatingOverlay",
                itemType: "ItemTypeSelect",
                defaultUserItemType: "ItemTypeUserDefaultSelect",
            };
        },

        _showWait: function () {
            new overlay(this.options.ids.waitOverlay).show();
        },

        _hideWait: function () {
            new overlay(this.options.ids.waitOverlay).hide();
        },

        currentItemType: function () {
            return RichSelect.getSelectedValue(this.options.ids.itemType);
        },

        saveChanges: function () {
            var systemName = this.currentItemType();

            if (this.options.data.itemType != systemName) {
                if (this.options.data.itemType && !confirm(this.options.titles.changeItemConfirm)) {
                    return;
                }
            }
            window.dialog.hide(this.options.ids.dialog);
            if (this.options.data.userId && this.options.data.itemType != systemName) {
                window.save(false, true);
            }
        },

        cancelChanges: function () {
            var fnSetDefaultForRichSelect = function (richSelectName, defaultVal) {
                var rsId = richSelectName + (defaultVal ? defaultVal : "dwrichselectitem");
                var rsEl = $(rsId);
                if (rsEl) {
                    RichSelect.setselected(rsEl.down("div"), richSelectName);
                }
            };

            fnSetDefaultForRichSelect(this.options.ids.itemType, this.options.data.itemType);
            window.dialog.hide(this.options.ids.dialog);
        }
    };

    ns.createEditor = function (opts) {
        editor.init(opts);
        return editor;
    };

    ns.current = function (newEditor) {
        if (!Dynamicweb.Utilities.TypeHelper.isUndefined(newEditor)) {
            ns._editor = newEditor;
        }
        return ns._editor;
    };
})(Dynamicweb.Utilities.defineNamespace("Dynamicweb.UserManagement.User.Editors"));