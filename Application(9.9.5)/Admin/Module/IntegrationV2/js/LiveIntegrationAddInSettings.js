var SettingsPage = function (pageContentID) {
    this.onSave = null;
    this.onCancel = null;
    this.onHelp = null;

    this.pageContentID = pageContentID;
}

SettingsPage.prototype.initialize = function () {
    this.stretchContent();

    if (window.attachEvent) {
        window.attachEvent('onresize', function () { SettingsPage.getInstance().stretchContent(); });
    } else if (window.addEventListener) {
        window.addEventListener('resize', function (e) { SettingsPage.getInstance().stretchContent(); }, false);
    }
}

SettingsPage.prototype.stretchContent = function () {
    var toolbarHeight = 0;
    var content = $(this.pageContentID);

    if (content) {
        toolbarHeight = $('divToolbar').getHeight();
        content.setStyle({ 'height': (document.body.clientHeight - toolbarHeight) + 'px' });
    }
}

SettingsPage.prototype.save = function (close) {
    if (!Toolbar.buttonIsDisabled('cmdSave')) {
        this._findCheckboxNames();
        if (close == null || typeof (close) == 'undefined' || close == false)
            document.getElementById('hiddenSource').value = "ManagementCenterSave";
        this._evalCallback(this.onSave, null);
    }
}

SettingsPage.prototype.saveAndClose = function () {
    if (!Toolbar.buttonIsDisabled('cmdSaveAndClose')) {
        this.save(true);
    }
}

SettingsPage.prototype.cancel = function () {
    if (!Toolbar.buttonIsDisabled('cmdCancel')) {
        if (this._evalCallback(this.onCancel, null))
            location = '/Admin/Module/IntegrationV2/LiveIntegration/ErpLiveIntegration_Edit.aspx';
    }
}

SettingsPage.prototype.submit = function () {
    document.getElementById('MainForm').submit();
}

SettingsPage.prototype._evalCallback = function (callback, args) {
    var ret = true;

    if (typeof (callback) == 'function') {
        ret = callback(this, args);
    }

    return ret;
}

SettingsPage.prototype._findCheckboxNames = function () {
    var names = '';
    var form = document.getElementById('MainForm');

    for (var i = 0; i < form.length; i++) {
        if (form[i].name != undefined) {
            if (form[i].type == 'checkbox') {
                names = names + form[i].name + '@';
            }
        }
    }

    document.getElementById('hiddenCheckboxNames').value = names;
}