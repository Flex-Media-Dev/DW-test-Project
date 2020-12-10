if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

Dynamicweb.PresetSettings = function () {
    this.confirmAction = { Name: "OpenDialog", Url: "/Admin/CommonDialogs/Confirm?Caption=Confirm%20Action" };
    this.openScreenAction = { Name: "OpenScreen", Url: location.pathname + location.search };

    this.options = {};
    this.options.labels = {};

    this.options.existingPresets = [];
    this.options.labels.overwritePresetValues = 'Do you want to overwrite the existing values?';
    this.options.labels.no = 'No';
    this.options.labels.yes = 'Yes';
    this.options.labels.ok = 'OK';
    this.options.labels.invalidPresetName = 'Please specify the setting preset name.';
    this.options.labels.invalidPresetNameFormat = 'The name is incorrect.';

    this._form = document.forms["Form1"] || document.forms[0];
};

Dynamicweb.PresetSettings._instance = null;

Dynamicweb.PresetSettings.get_current = function () {
    if (!Dynamicweb.PresetSettings._instance) {
        Dynamicweb.PresetSettings._instance = new Dynamicweb.PresetSettings();
    }

    return Dynamicweb.PresetSettings._instance;
};

Dynamicweb.PresetSettings.prototype.initialize = function (options) {
    var self = this;
    Object.assign(self.options, options);
}

Dynamicweb.PresetSettings.prototype._validateInput = function (elementToValidate) {
    if (!elementToValidate.value) {
        dwGlobal.showControlErrors(elementToValidate, this.options.labels.invalidPresetName || "Please specify the setting preset name.");
        elementToValidate.focus();
        return false;
    } else if (!elementToValidate.value.match(new RegExp("^[a-zA-Z]+[ a-zA-Z0-9_]*$"))) {
        dwGlobal.showControlErrors(elementToValidate, this.options.labels.invalidPresetNameFormat || "The name is incorrect.");
        elementToValidate.focus();
        return false;
    }
    return true;
};

//buttons is flags enum value where SubmitOk = 1,  SubmitCancel = 2,    Cancel = 4,    Close = 8
Dynamicweb.PresetSettings.prototype.showConfirmMessage = function (message, onConfirm, onCancel, buttons, cancelButtonTitle, okButtonTitle) {
    var self = this;
    var confirmation = self._cloneAction(self.confirmAction);
    if (confirmation) {
        if (confirmation.Url.indexOf("&Message=") > -1) {
            confirmation.Url = confirmation.Url.replace(new RegExp('Message=[^&]*&*', "ig"), "");
        }
        confirmation.Url += "&Message=" + encodeURIComponent(message);
        if (onConfirm) {
            if (typeof (onConfirm) == "function") {
                confirmation.OnSubmitted = { Name: "ScriptFunction", Function: function () { onConfirm() } };
            } else if (typeof (onConfirm) == "object") {
                confirmation.OnSubmitted = onConfirm;
            }
        }
        if (buttons) {
            confirmation.Url += "&Buttons=" + buttons;
        }
        if (cancelButtonTitle) {
            confirmation.Url += "&CancelTitle=" + cancelButtonTitle;
            confirmation.Url += "&SubmitCancelTitle=" + cancelButtonTitle;
        }
        if (okButtonTitle) {
            confirmation.Url += "&SubmitOkTitle=" + okButtonTitle;
        }

        if (onCancel) {
            if (typeof (onCancel) == "function") {
                confirmation.OnCancelled = { Name: "ScriptFunction", Function: function () { onCancel() } };
            } else if (typeof (onCancel) == "object") {
                confirmation.OnCancelled = onCancel;
            }
        }
        Action.Execute(confirmation);
    }
};

Dynamicweb.PresetSettings.prototype._cloneAction = function (originalAction) {
    if (null == originalAction || "object" != typeof originalAction) return originalAction;
    var copy = originalAction.constructor();
    for (var attr in originalAction) {
        if (originalAction.hasOwnProperty(attr)) copy[attr] = originalAction[attr];
    }
    return copy;
};

Dynamicweb.PresetSettings.prototype._createHidden = function (controlId, value, parentElement) {
    parentElement = parentElement || this._form;
    var el = document.getElementsByName(controlId);
    if (!el.length) {
        el = document.createElement('input');
        el.type = 'hidden';
        el.name = controlId;
        parentElement.appendChild(el);
    }
    el.value = value;
};

Dynamicweb.PresetSettings.prototype.submitFormWithCommand = function (command) {
    Action.showCurrentScreenLoader(true);
    $('Cmd').value = command;
    this._form.submit();
};

Dynamicweb.PresetSettings.prototype.selectPreset = function (presetId) {
    this._createHidden("preset", presetId);
    this.submitFormWithCommand('ChangePreset');
}

Dynamicweb.PresetSettings.prototype.savePreset = function (presetNameElement) {
    let self = this;
    let presetNameEl = presetNameElement || document.getElementById('PresetName');
    if (this._validateInput(presetNameEl)) {
        let presetWithSameName = null;
        if (presetWithSameName = self.options.existingPresets.find(function (preset) { return preset.Name.toLowerCase() == presetNameEl.value.toLowerCase(); })) {
            self.showConfirmMessage(self.options.labels.overwritePresetValues, function () {
                self._createHidden("presetId", presetWithSameName.Id);
                self.submitFormWithCommand('SavePreset');
            }, null, null, self.options.labels.no, self.options.labels.yes);
        }
        else if (presetWithSameName = self.options.groupPresets.find(function (preset) { return preset.Name.toLowerCase() == presetNameEl.value.toLowerCase(); })) {
            self.showConfirmMessage(self.options.labels.notAllowOverwritePresetValue, function () {
            }, null, 4, null, null);
        }
        else {
            self.submitFormWithCommand('SavePreset');
        }
    }
}