if (typeof (Dynamicweb) === 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) === 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.ItemEdit = function () {
    this._terminology = {};
    this._definition = null;
    this._item = null;
    this._validation = null;
    this._validationPopup = null;
};

Dynamicweb.Items.ItemEdit._instance = null;

Dynamicweb.Items.ItemEdit.get_current = function () {
    if (!Dynamicweb.Items.ItemEdit._instance) {
        Dynamicweb.Items.ItemEdit._instance = new Dynamicweb.Items.ItemEdit();
    }

    return Dynamicweb.Items.ItemEdit._instance;
};

Dynamicweb.Items.ItemEdit.prototype.get_terminology = function () {
    return this._terminology;
};

Dynamicweb.Items.ItemEdit.prototype.get_validation = function () {
    if (!this._validation) {
        this._validation = new Dynamicweb.Validation.ValidationManager();
    }

    return this._validation;
};

Dynamicweb.Items.ItemEdit.prototype.get_validationPopup = function () {
    if (this._validationPopup && typeof (this._validationPopup) === 'string') {
        this._validationPopup = eval(this._validationPopup);
    }

    return this._validationPopup;
};

Dynamicweb.Items.ItemEdit.prototype.set_validationPopup = function (value) {
    this._validationPopup = value;
};


Dynamicweb.Items.ItemEdit.prototype.get_itemType = function () {
    return this._item;
};

Dynamicweb.Items.ItemEdit.prototype.set_itemType = function (value) {
    this._item = value;
};

Dynamicweb.Items.ItemEdit.prototype.get_definition = function () {
    return this._definition;
};

Dynamicweb.Items.ItemEdit.prototype.set_definition = function (value) {
    this._definition = value;
};

Dynamicweb.Items.ItemEdit.prototype.set_showCancelWarn = function (value) {
    this._showCancelWarn = value;
};

Dynamicweb.Items.ItemEdit.prototype.get_showCancelWarn = function () {
    return this._showCancelWarn;
};

Dynamicweb.Items.ItemEdit.prototype.initialize = function () {
};

Dynamicweb.Items.ItemEdit.prototype.showValidationResults = function () {
    this.get_validationPopup().set_contentUrl('/Admin/Content/PageValidate.aspx?ID=' + this.get_page().id);
    this.get_validationPopup().show();
};

Dynamicweb.Items.ItemEdit.prototype.validate = function (onComplete) {
    if (Dynamicweb.Items.GroupVisibilityRule) {
        Dynamicweb.Items.GroupVisibilityRule.get_current().filterValidators(this.get_validation()).beginValidate(onComplete);
    } else {
        this.get_validation().beginValidate(onComplete);
    }
};

Dynamicweb.Items.ItemEdit.prototype.save = function () {
    var success = true;

    this.validate(function (result) {
        if (result.isValid) {
            // Fire event to handle saving
            window.document.fire("General:DocumentOnSave");

            var form = document.getElementById("MainForm");
            if (typeof form.onsubmit === 'function') {
                form.onsubmit();
            }
            form.submit();
        }
        success = result.isValid;
    });

    return success;
};