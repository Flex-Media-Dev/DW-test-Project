if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.PresetItemEdit = function () {
    this._terminology = {};
    this._validation = null;
    this._validationPopup = null;
}

Dynamicweb.Items.PresetItemEdit._instance = null;

Dynamicweb.Items.PresetItemEdit.get_current = function () {
    if (!Dynamicweb.Items.PresetItemEdit._instance) {
        Dynamicweb.Items.PresetItemEdit._instance = new Dynamicweb.Items.PresetItemEdit();
    }

    return Dynamicweb.Items.PresetItemEdit._instance;
}

Dynamicweb.Items.PresetItemEdit.prototype.get_validation = function () {
    if (!this._validation) {
        this._validation = new Dynamicweb.Validation.ValidationManager();
    }

    return this._validation;
}

Dynamicweb.Items.PresetItemEdit.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Items.PresetItemEdit.prototype.initialize = function () {
    var self = this;
    setTimeout(function () {
        if (typeof (Dynamicweb.Controls) != 'undefined' && typeof (Dynamicweb.Controls.OMC) != 'undefined' && typeof (Dynamicweb.Controls.OMC.DateSelector) != 'undefined') {
            Dynamicweb.Controls.OMC.DateSelector.Global.set_offset({ top: -26, left: Prototype.Browser.IE ? 1 : 0}); // Since the content area is fixed to screen at 138px from top (Edititem.css)
        }
    }, 500);
    self._mainForm = document.forms[0];
    self._mainForm.on("submit", function (evt) {
        console.log("submit?");
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

Dynamicweb.Items.PresetItemEdit.prototype.validate = function (onComplete) {
    if (Dynamicweb.Items.GroupVisibilityRule) {
        Dynamicweb.Items.GroupVisibilityRule.get_current().filterValidators(this.get_validation()).beginValidate(onComplete);
    } else {
        this.get_validation().beginValidate(onComplete);
    };
}

Dynamicweb.Items.PresetItemEdit.prototype.save = function () {
    this.request("save");
}

Dynamicweb.Items.PresetItemEdit.prototype.newPreset = function () {
    this.request("newPreset");
}

Dynamicweb.Items.PresetItemEdit.prototype.overwritePreset = function () {
    this.request("overwritePreset");
}

Dynamicweb.Items.PresetItemEdit.prototype.request = function (command) {
    var self = this;

    this.validate(function (result) {
        if (result.isValid) {
            self.prepareRichEditors();
            var submit = self._mainForm.onsubmit || function () { }; // Force richeditors saving
            submit();

            self._mainForm.request({
                parameters: { cmd: command },
                onComplete: function (transport) {
                    var action = transport.responseJSON;
                    Action.Execute(action);

                    self.close('save');
                },
                onFailure: function () { alert('Something went wrong!'); }
            })
        }
    });
}

Dynamicweb.Items.PresetItemEdit.prototype.cancel = function () {
    this.close();
}

Dynamicweb.Items.PresetItemEdit.prototype.close = function (result) {
    result = result || 'cancel';
    Action.Execute({ Name: 'CloseDialog', Result: result });
}

Dynamicweb.Items.PresetItemEdit.prototype.prepareRichEditors = function () {
    if (typeof (CKEDITOR) != 'undefined') {
        for (var i in CKEDITOR.instances) {
            CKEDITOR.instances[i].updateElement();
        }
    } else if (typeof (FCKeditorAPI) != 'undefined') {
        for (var i in FCKeditorAPI.Instances) {
            FCKeditorAPI.Instances[i].UpdateLinkedField();
        }
    }

}