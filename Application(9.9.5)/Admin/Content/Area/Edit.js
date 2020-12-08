if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Area) == 'undefined') {
    Dynamicweb.Area = new Object();
}

Dynamicweb.Area.ItemEdit = function () {
    this._terminology = {};
    this._itemId = '';
    this._itemType = '';
    this._validation = null;
    this._validationPopup = null;
    this._itemTypePageProperty = '';
}

Dynamicweb.Area.ItemEdit._instance = null;

Dynamicweb.Area.ItemEdit.get_current = function () {
    if (!Dynamicweb.Area.ItemEdit._instance) {
        Dynamicweb.Area.ItemEdit._instance = new Dynamicweb.Area.ItemEdit();
    }

    return Dynamicweb.Area.ItemEdit._instance;
}

Dynamicweb.Area.ItemEdit.prototype.get_validation = function () {
    if (!this._validation) {
        this._validation = new Dynamicweb.Validation.ValidationManager();
    }

    return this._validation;
}

Dynamicweb.Area.ItemEdit.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Area.ItemEdit.prototype.get_validationPopup = function () {
    if (this._validationPopup && typeof (this._validationPopup) == 'string') {
        this._validationPopup = eval(this._validationPopup);
    }

    return this._validationPopup;
}

Dynamicweb.Area.ItemEdit.prototype.set_validationPopup = function (value) {
    this._validationPopup = value;
}

Dynamicweb.Area.ItemEdit.prototype.get_itemId = function () {
    return this._itemId;
}

Dynamicweb.Area.ItemEdit.prototype.set_itemId = function (value) {
    this._itemId = value;
}

Dynamicweb.Area.ItemEdit.prototype.get_itemType = function () {
    return this._itemType;
}

Dynamicweb.Area.ItemEdit.prototype.set_itemType = function (value) {
    this._itemType = value;
}

Dynamicweb.Area.ItemEdit.prototype.get_itemTypePageProperty = function () {
    return this._itemTypePageProperty;
}

Dynamicweb.Area.ItemEdit.prototype.set_itemTypePageProperty = function (value) {
    this._itemTypePageProperty = value;
}

Dynamicweb.Area.ItemEdit.prototype.initialize = function () {
    setTimeout(function () {
        if (typeof (Dynamicweb.Controls) != 'undefined' && typeof (Dynamicweb.Controls.OMC) != 'undefined' && typeof (Dynamicweb.Controls.OMC.DateSelector) != 'undefined') {
            Dynamicweb.Controls.OMC.DateSelector.Global.set_offset({ top: -118, left: Prototype.Browser.IE ? 1 : 0 }); // Since the content area is fixed to screen at 118px from top 
        }
    }, 500);
}

Dynamicweb.Area.ItemEdit.prototype.validate = function (onComplete) {
    if (Dynamicweb.Items.GroupVisibilityRule) {
        Dynamicweb.Items.GroupVisibilityRule.get_current().filterValidators(this.get_validation()).beginValidate(onComplete);
    } else {
        this.get_validation().beginValidate(onComplete);
    };
}

Dynamicweb.Area.ItemEdit.prototype.showWait = function () {
    new overlay('PleaseWait').show();
}

Dynamicweb.Area.ItemEdit.prototype.hideWait = function () {
    new overlay('PleaseWait').hide();
}

Dynamicweb.Area.ItemEdit.prototype.changeItemType = function () {
    var systemName;

    // Page property item
    systemName = $("ItemTypePageSelect").value;
    if (this.get_itemTypePageProperty() != systemName) {
        if (this.get_itemTypePageProperty() && !confirm(this.get_terminology()['ChangeItemPageConfirm'])) {
            return;
        }
    }

    // Website property item
    systemName = $("ItemTypeSelect").value;
    if (this.get_itemType() != systemName) {
        if (!this.get_itemType() || confirm(this.get_terminology()['ChangeItemConfirm'])) {
            this.showWait();
            $("action").value = "changeItemType";
            $("MainForm").target = "";
            $("MainForm").submit();
        }
        else {
            return;
        }
    }

    dialog.hide("AreaItemTypeDialog");
}

Dynamicweb.Area.ItemEdit.prototype.cancelChangeItemType = function () {
    var ItemTypeSelect = null;

    // Website property item
    var itemType = $F("AreaSavedItemTypeProperty");
    if (itemType)
        ItemTypeSelect = "ItemTypeSelect" + itemType;
    else
        ItemTypeSelect = "ItemTypeSelectdwrichselectitem";

    ItemTypeSelect = $(ItemTypeSelect);
    if (ItemTypeSelect) RichSelect.setselected(ItemTypeSelect.down("div"), "ItemTypeSelect");

    // Page property item
    var itemTypePage = $F("AreaSavedItemTypePageProperty");
    if (itemTypePage)
        ItemTypeSelect = "ItemTypePageSelect" + itemTypePage;
    else
        ItemTypeSelect = "ItemTypePageSelectdwrichselectitem";

    ItemTypeSelect = $(ItemTypeSelect);
    if (ItemTypeSelect) RichSelect.setselected(ItemTypeSelect.down("div"), "ItemTypePageSelect");



    dialog.hide("AreaItemTypeDialog");
}
