if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.ItemListEdit = function () {
    this._terminology = {};
    this._validation = null;
    this._validationPopup = null;
    this._listId = null;
    this._rowId = null;
    this._pageId = null;
    this._isNewRow = false;
    this._isInstantSave = false;
    this._namedItemListId = null;
}

Dynamicweb.Items.ItemListEdit._instance = null;

Dynamicweb.Items.ItemListEdit.get_current = function () {
    if (!Dynamicweb.Items.ItemListEdit._instance) {
        Dynamicweb.Items.ItemListEdit._instance = new Dynamicweb.Items.ItemListEdit();
    }

    return Dynamicweb.Items.ItemListEdit._instance;
}

Dynamicweb.Items.ItemListEdit.prototype.get_validation = function () {
    if (!this._validation) {
        this._validation = new Dynamicweb.Validation.ValidationManager();
    }

    return this._validation;
}

Dynamicweb.Items.ItemListEdit.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Items.ItemListEdit.prototype.get_validationPopup = function () {
    if (this._validationPopup && typeof (this._validationPopup) == 'string') {
        this._validationPopup = eval(this._validationPopup);
    }

    return this._validationPopup;
}

Dynamicweb.Items.ItemListEdit.prototype.set_validationPopup = function (value) {
    this._validationPopup = value;
}

Dynamicweb.Items.ItemListEdit.prototype.set_listId = function (value) {
    this._listId = value;
}

Dynamicweb.Items.ItemListEdit.prototype.set_rowId = function (value) {
    this._rowId = value;
}

Dynamicweb.Items.ItemListEdit.prototype.set_pageId = function (value) {
    this._pageId = value;
}

Dynamicweb.Items.ItemListEdit.prototype.set_isNewRow = function (value) {
    this._isNewRow = value;
}

Dynamicweb.Items.ItemListEdit.prototype.get_isNewRow = function () {
    return this._isNewRow;
}

Dynamicweb.Items.ItemListEdit.prototype.set_isInstantSave = function (value) {
    this._isInstantSave = value;
}

Dynamicweb.Items.ItemListEdit.prototype.get_isInstantSave = function () {
    return this._isInstantSave;
}

Dynamicweb.Items.ItemListEdit.prototype.set_namedItemListId = function (value) {
    this._namedItemListId = value;
}

Dynamicweb.Items.ItemListEdit.prototype.initialize = function () {
    var self = this;
    setTimeout(function () {
        if (typeof (Dynamicweb.Controls) != 'undefined' && typeof (Dynamicweb.Controls.OMC) != 'undefined' && typeof (Dynamicweb.Controls.OMC.DateSelector) != 'undefined') {
            Dynamicweb.Controls.OMC.DateSelector.Global.set_offset({ top: -26, left: Prototype.Browser.IE ? 1 : 0}); // Since the content area is fixed to screen at 138px from top (Edititem.css)
        }
    }, 500);
    self._mainForm = document.forms[0];
    self._mainForm.on("submit", function (evt) {
        self.save(true);
        Event.stop(evt);
    });

    var buttons = $$('.item-edit-field-group-button-collapse');
    for (var i = 0; i < buttons.length; i++) {
        Event.observe(buttons[i], 'click', function (e) {
            var elm = this;
            elm.next('.item-edit-field-group-content').toggleClassName('collapsed');
        });
    }
}

Dynamicweb.Items.ItemListEdit.prototype.showValidationResults = function () {
    this.get_validationPopup().set_contentUrl('/Admin/Content/PageValidate.aspx?ID=' + this.get_page().id);
    this.get_validationPopup().show();
}

Dynamicweb.Items.ItemListEdit.prototype.validate = function (onComplete) {
    if (Dynamicweb.Items.GroupVisibilityRule) {
        Dynamicweb.Items.GroupVisibilityRule.get_current().filterValidators(this.get_validation()).beginValidate(onComplete);
    } else {
        this.get_validation().beginValidate(onComplete);
    };
}

Dynamicweb.Items.ItemListEdit.prototype.save = function (close) {
    var self = this;

    this.validate(function (result) {
        if (result.isValid) {
            // Fire event to handle saving
            window.document.fire("General:DocumentOnSave");

            self.prepareRichEditors();
            $('hClose').value = (!!close).toString();
            var submit = self._mainForm.onsubmit || function () { }; // Force richeditors saving
            submit(); 

            self._mainForm.request({
                onComplete: function (transport) {
                    if (!self.get_isInstantSave()) {
                        var jsonObj = transport.responseText.evalJSON();
                        var dlgOpener = Action._getCurrentDialogOpener();
                        var list = dlgOpener.document.getElementById(self._listId + 'Container');
                        if (self.get_isNewRow()) {
                            list.ListItem.addRow(self._rowId, jsonObj); // JSON.parse(json)
                        }
                        else {
                            list.ListItem.editRow(self._rowId, jsonObj);
                        }
                    }
                    self.set_isNewRow(false);

                    if (close) self.close();
                },
                onFailure: function () { alert('Something went wrong!'); }
            })
        }
    });
}

Dynamicweb.Items.ItemListEdit.prototype.prepareRichEditors = function () {
    if (typeof (tinymce) !== 'undefined') {
        tinymce.triggerSave();
    } else if (typeof (CKEDITOR) != 'undefined') {
        for (var i in CKEDITOR.instances) {
            CKEDITOR.instances[i].updateElement();
        }
    } else if (typeof (FCKeditorAPI) != 'undefined') {
        for (var i in FCKeditorAPI.Instances) {
            FCKeditorAPI.Instances[i].UpdateLinkedField();
        }
    }

}

Dynamicweb.Items.ItemListEdit.prototype.saveAndClose = function () {
    this.save(true);
}

Dynamicweb.Items.ItemListEdit.prototype.cancel = function () {
    this.close();
}

Dynamicweb.Items.ItemListEdit.prototype.close = function () {
    if (!this.get_isInstantSave()) {
        Action.Execute({ Name: 'CloseDialog', Result: 'cancel' });
    }
    else {
        location = '/Admin/Content/Items/Editing/NamedItemListEdit.aspx?PageID=' + this._pageId + '&NamedItemList=' + this._namedItemListId;
    }
}