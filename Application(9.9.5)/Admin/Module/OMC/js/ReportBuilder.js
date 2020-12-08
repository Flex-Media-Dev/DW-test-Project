/* ++++++ Registering namespace ++++++ */

if (typeof (OMC) == 'undefined') {
    var OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

OMC.ReportBuilder = function (factSelector, categorySelector) {
    /// <summary>Represents a report edit page.</summary>
    /// <param name="factSelector">An instance of the fact selector.</summary>
    /// <param name="categorySelector">An instance of the category selector (drop-down list).</summary>

    this._factSelector = factSelector;
    this._categorySelector = categorySelector;

    this._emptyNameMessage = '';
    this._existingNameMessage = '';
    this._invalidNameMessage = '';
    this._invalidDataMessage = '';
    this._invalidChartAreaSize = '';
    this._deleteSettingMessage = '';
    this._initialized = false;
    this._settingsGrid = null;
    this._advancedSettingsVisible = false;
    this._reportID = '';
    this._reportCategoryID = '';
    this._savedMessage = '';
    this._saveMessage = '';
    this._reportType = null;
    this._emptyPageLinkMessage = '';
}

OMC.ReportBuilder.prototype.get_factSelector = function () {
    /// <summary>Gets the reference to the fact selector.</summary>

    if (typeof (this._factSelector) == 'string') {
        this._factSelector = eval(this._factSelector);
    }

    return this._factSelector;
}

OMC.ReportBuilder.prototype.get_categorySelector = function () {
    /// <summary>Gets the reference to the category selector (drop-down list).</summary>

    if (typeof (this._categorySelector) == 'string') {
        this._categorySelector = eval(this._categorySelector);
    }

    return this._categorySelector;
}

OMC.ReportBuilder.prototype.get_reportID = function () {
    /// <summary>Gets the ID of the current report.</summary>

    return this._reportID;
}

OMC.ReportBuilder.prototype.set_reportID = function (value) {
    /// <summary>Sets the ID of the current report.</summary>
    /// <param name="value">The ID of the current report.</param>

    this._reportID = value;
}

OMC.ReportBuilder.prototype.get_reportType = function () {
    /// <summary>Gets the type of the report.</summary>

    var field = null;

    if (!this._reportType || !this._reportType.length) {
        field = document.getElementById('ReportType');

        if (field) {
            this._reportType = (field.value || '').toString().toLowerCase();
        } else {
            this._reportType = 'unknown';
        }
    }

    return this._reportType;
}

OMC.ReportBuilder.prototype.set_reportType = function (value) {
    /// <summary>Sets the typef of the report.</summary>
    /// <param name="value">The type of the report.</param>

    var c = null;
    var name = null;
    var className = '';
    var containers = null;

    this._reportType = value;

    containers = $$('.reporttype');
    className = 'reporttype-' + (value || '').toString().toLowerCase();

    if (containers && containers.length) {
        for (var i = 0; i < containers.length; i++) {
            c = $(containers[i]);

            if (c.hasClassName(className)) {
                c.show();
            } else {
                c.hide();
            }
        }
    }

    document.getElementById('ReportType').value = (value || '');

    name = $$('input.field-name')[0];

    if (name) {
        try {
            name.focus();
        } catch (ex) { }
    }
}

OMC.ReportBuilder.prototype.get_reportCategoryID = function () {
    /// <summary>Gets the ID of the current report category.</summary>

    return this._reportCategoryID;
}

OMC.ReportBuilder.prototype.set_reportCategoryID = function (value) {
    /// <summary>Sets the ID of the current report category.</summary>
    /// <param name="value">The ID of the current report category.</param>

    this._reportCategoryID = value;
}

OMC.ReportBuilder.prototype.get_emptyNameMessage = function () {
    /// <summary>Gets the "Empty name" error message.</summary>

    return this._emptyNameMessage;
}

OMC.ReportBuilder.prototype.set_emptyNameMessage = function (value) {
    /// <summary>Sets the "Empty name" error message.</summary>
    /// <param name="value">The "Empty name" error message.</param>

    this._emptyNameMessage = value;
}

OMC.ReportBuilder.prototype.get_emptyPageLinkMessage = function () {
    /// <summary>Gets the "Empty page URL" error message.</summary>

    return this._emptyPageLinkMessage;
}

OMC.ReportBuilder.prototype.set_emptyPageLinkMessage = function (value) {
    /// <summary>Sets the "Empty page URL" error message.</summary>
    /// <param name="value">The "Empty page URL" error message.</param>

    this._emptyPageLinkMessage = value;
}

OMC.ReportBuilder.prototype.get_invalidNameMessage = function () {
    /// <summary>Gets the "Invalid name" error message.</summary>

    return this._invalidNameMessage;
}

OMC.ReportBuilder.prototype.set_invalidNameMessage = function (value) {
    /// <summary>Sets the "Invalid name" error message.</summary>
    /// <param name="value">The "Empty name" error message.</param>

    this._invalidNameMessage = value;
}

OMC.ReportBuilder.prototype.get_existingNameMessage = function () {
    /// <summary>Gets the "Existing name" error message.</summary>

    return this._existingNameMessage;
}

OMC.ReportBuilder.prototype.set_existingNameMessage = function (value) {
    /// <summary>Sets the "Existing name" error message.</summary>
    /// <param name="value">The "Existing name" error message.</param>

    this._existingNameMessage = value;
}

OMC.ReportBuilder.prototype.get_deleteSettingMessage = function () {
    /// <summary>Gets the "Delete setting" error message.</summary>

    return this._deleteSettingMessage;
}

OMC.ReportBuilder.prototype.set_deleteSettingMessage = function (value) {
    /// <summary>Sets the "Delete setting" error message.</summary>
    /// <param name="value">The "Delete setting" error message.</param>

    this._deleteSettingMessage = value;
}

OMC.ReportBuilder.prototype.get_saveMessage = function () {
    /// <summary>Gets the "Save" message.</summary>

    return this._saveMessage;
}

OMC.ReportBuilder.prototype.set_saveMessage = function (value) {
    /// <summary>Sets the Save" message.</summary>
    /// <param name="value">The "Save" message.</param>

    this._saveMessage = value;
}

OMC.ReportBuilder.prototype.get_savedMessage = function () {
    /// <summary>Gets the "Saved" message.</summary>

    return this._savedMessage;
}

OMC.ReportBuilder.prototype.set_savedMessage = function (value) {
    /// <summary>Sets the Saved" message.</summary>
    /// <param name="value">The "Saved" message.</param>

    this._savedMessage = value;
}

OMC.ReportBuilder.prototype.get_settingsGrid = function () {
    /// <summary>Gets the reference to chart settings grid.</summary>

    if (this._settingsGrid && typeof (this._settingsGrid) == 'string') {
        this._settingsGrid = eval(this._settingsGrid);
    }

    return this._settingsGrid;
}

OMC.ReportBuilder.prototype.set_settingsGrid = function (value) {
    /// <summary>Sets the reference to chart settings grid.</summary>
    /// <param name="value">The reference to chart settings grid.</param>

    this._settingsGrid = value;
}

OMC.ReportBuilder.prototype.get_advancedSettingsVisible = function () {
    /// <summary>Gets value indicating whether advanced chart settings dialog is visible.</summary>

    return this._advancedSettingsVisible;
}

OMC.ReportBuilder.prototype.set_advancedSettingsVisible = function (value) {
    /// <summary>Sets value indicating whether advanced settings dialog is visible.</summary>
    /// <param name="value">Value indicating whether advanced settings dialog is visible.</param>

    this._advancedSettingsVisible = !!value;

    if (this._advancedSettingsVisible) {
        dialog.show('dlgAdvancedSettings');
    } else {
        dialog.hide('dlgAdvancedSettings');
    }
}

OMC.ReportBuilder.prototype.get_invalidDataMessage = function () {
    /// <summary>Gets the "Invalid data" error message.</summary>

    return this._invalidDataMessage;
}

OMC.ReportBuilder.prototype.set_invalidDataMessage = function (value) {
    /// <summary>Sets the "Invalid data" error message.</summary>
    /// <param name="value">The "Invalid data" error message.</param>

    this._invalidDataMessage = value;
}

OMC.ReportBuilder.prototype.get_invalidChartAreaSize = function () {
    /// <summary>Gets the "Invalid chart area size" error message.</summary>

    return this._invalidChartAreaSize;
}

OMC.ReportBuilder.prototype.set_invalidChartAreaSize = function (value) {
    /// <summary>Sets the "Invalid chart area size" error message.</summary>
    /// <param name="value">"Invalid chart area size" error message.</param>

    this._invalidChartAreaSize = value;
}

OMC.ReportBuilder.prototype.saveAndClose = function () {
    /// <summary>Saves the report and closes the form.</summary>

    this.save(true);
}

OMC.ReportBuilder.prototype.save = function (closeWindow) {
    /// <summary>Saves the report.</summary>

    var self = this;

    /* First, disabling the "Save" button indicating that the operating is being performed */
    parent.Ribbon.disableButton('cmdSave');

    this.validate(function (isValid) {
        var form = null;

        if (isValid) {
            form = self._getPostbackForm();
            document.getElementById('CloseOnSave').value = (!!closeWindow).toString();

            if (form) {
                /* Submitting a form to a hidden frame */
                form.target = 'frmPostback';
            }

            document.getElementById('cmdSubmit').click();
        } else {
            parent.Ribbon.enableButton('cmdSave');
        }
    });
}

OMC.ReportBuilder.prototype.onAfterSave = function (response) {
    /// <summary>Occurs when the postback frame gets loaded.</summary>
    /// <param name="response">Response.</param>

    var self = this;
    var form = this._getPostbackForm();

    if (form) {
        /* Clearing the target, just in case */
        form.target = '';
    }

    if (response) {
        document.getElementById('OriginalReportID').value = response.id;
        document.getElementById('OriginalReportCategoryID').value = response.categoryID;
        
        /* Do we need to update the tree? */
        if (response.uniqueID != response.originalUniqueID || response.reportType != response.originalReportType) {
            /* Getting the unique ID of the parent node */
            parentNodeUniqueID = parent.OMC.MasterPage.get_current().get_tree().get_dynamic().reducePath(response.uniqueID);

            /* Do we need to remove the original report node? */
            if (response.originalUniqueID && response.originalUniqueID.length) {
                parent.OMC.MasterPage.get_current().get_tree().get_dynamic().removeNode(response.originalUniqueID);
            }

            /* Reloading tree level (category) */
            parent.OMC.MasterPage.get_current().reload(parentNodeUniqueID, {
                highlight: response.uniqueID
            });
        }
    }

    /* Changing the text of a Ribbon button (from "Save" to "Saved") - indicates that changes are committed */
    parent.Ribbon.set_buttonText('cmdSave', this.get_savedMessage());

    /* Changing the text back shortly */
    setTimeout(function () {
        parent.Ribbon.set_buttonText('cmdSave', self.get_saveMessage());
        parent.Ribbon.enableButton('cmdSave');
    }, 3000);
}

OMC.ReportBuilder.prototype.initialize = function (params) {
    /// <summary>Initializes the object.</summary>
    /// <param name="params">Parameters.</param>

    var self = this;
    var inputs = null;

    if (!params) {
        params = {};
    }

    if (!this._initialized) {
        inputs = $$('input');
        if (inputs && inputs.length) {
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].type == 'text') {
                    Event.observe(inputs[i], 'keydown', function (evt) {
                        var ret = true;

                        if (evt.keyCode == 13) {
                            ret = false;
                            Event.stop(evt);
                        }

                        return ret;
                    });
                }
            }
        }

        this.get_settingsGrid().onRowAddedCompleted = function (row) {
            self._onSettingsCountChange(1);
        }

        setTimeout(function () {
            var name = $$('input.field-name')[0];

            if (name) {
                try {
                    name.focus();
                } catch (ex) { }
            }

            if (typeof (params.reportType) != 'undefined' && params.reportType != null) {
                self.set_reportType(params.reportType);
            }
        }, 50);

        this._initialized = true;
    }
}

OMC.ReportBuilder.prototype.validate = function (onComplete) {
    /// <summary>Validates the form.</summary>
    /// <param name="onComplete">Callback that is executed when the form is validated.</param>

    var url = '';
    var ret = false;
    var name = null;
    var self = this;
    var link = null;
    var isValid = false;
    var valuesJoined = '';
    var callback = onComplete || function () { }
    var values = this.get_factSelector().getSelectedFacts('Values');

    name = $$('input.field-name')[0];

    if (!name.value) { // First of all, checking whether "Name" field is empty 
        alert(this.get_emptyNameMessage());

        try {
            name.focus();
        } catch (ex) { }

        callback(false);
    } else if (parent.OMC.MasterPage.get_current().containsInvalidNameCharacters(name.value)) { // Checking whether "Name" field contains invalid characters
        alert(this.get_invalidNameMessage().replace('%%', '\'' + parent.OMC.MasterPage.get_current().get_invalidNameCharacters().join(' ') + '\''));

        try {
            name.focus();
            name.select();
        } catch (ex) { }

        callback(false);
    } else {
        url = '/Admin/Module/OMC/Reports/ReportBuilder.aspx?CheckExistance=' + encodeURIComponent(name.value) + '&CategoryID=' +
            encodeURIComponent(this._getCleanCategoryID(this.get_categorySelector().get_selectedItem().innerHTML)) + '&OriginalReportID=' +
            encodeURIComponent(document.getElementById('OriginalReportID').value);

        // Checking whether another report with the given name already exists
        new Ajax.Request(url, {
            method: 'get',
            onComplete: function (transport) {
                isValid = transport.responseText.toLowerCase() == 'false';
                
                if (!isValid) { // Existing report - displaying error message
                    alert(self.get_existingNameMessage());
                    try {
                        name.focus();
                    } catch (ex) { }

                    callback(isValid);
                } else if (!self._validateNumber($$('input.field-width')[0]) || !self._validateNumber($$('input.field-height')[0])) { // Checking chart size
                    alert(self.get_invalidChartAreaSize());

                    callback(false);
                } else {
                    if (self.get_reportType() == 'default') {
                        if (!values.length) { // We need at least one fact for the "Values" section
                            alert(self.get_invalidDataMessage());

                            callback(false);
                        } else {
                            if (self.get_factSelector().getSelectedFacts('ColumnLabels').length && values.length > 1) { // Checking whether all "Values" facts have the same type
                                for (var i = 0; i < values.length; i++) {
                                    valuesJoined += values[i].uniqueID;
                                    if (i < (values.length - 1)) {
                                        valuesJoined += ',';
                                    }
                                }

                                url = '/Admin/Module/OMC/Reports/ReportBuilder.aspx?CheckValueTypes=' + encodeURIComponent(valuesJoined);

                                new Ajax.Request(url, {
                                    method: 'get',
                                    onComplete: function (transport) {
                                        isValid = transport.responseText.toLowerCase() == 'false';

                                        if (!isValid) {
                                            alert(self.get_invalidDataMessage());
                                        }

                                        callback(isValid);
                                    }
                                });
                            } else {
                                callback(true);
                            }
                        }
                    } else if (self.get_reportType() == 'page') {
                        link = $$('input.field-url')[0];

                        if (!link.value) { // Checking whether "URL" field is empty
                            alert(self.get_emptyPageLinkMessage());

                            try {
                                link.focus();
                            } catch (ex) { }

                            callback(false);
                        } else {
                            callback(true);
                        }
                    } else {
                        callback(true);
                    }
                }
            }
        });
    }
}

OMC.ReportBuilder.prototype.confirmDeleteSetting = function (link) {
    /// <summary>Displays a confirm message of deleting the setting row and deletes it if the user confirms his choice.</summary>
    /// <param name="link">Link that user has clicked.</param>

    var row = null;
    var txName = null;
    var settingName = '';
    var msg = this.get_deleteSettingMessage();

    if (link) {
        row = this.get_settingsGrid().findContainingRow(link);
        if (row) {
            txName = row.findControl('txName');
            if (txName) {
                settingName = txName.value;
                if (!settingName || !settingName.length) {
                    settingName = '[none]';
                }

                msg = msg.replace('%%', settingName).replace(/&quot;/gi, '"');

                /*if (confirm(msg)) { */
                    this.deleteSetting(row);
                /*} */
            }
        }
    }
}

OMC.ReportBuilder.prototype.deleteSetting = function (row) {
    /// <summary>Deletes the given row from the settings grid.</summary>
    /// <param name="row">Row to delete.</param>

    if (row) {
        this.get_settingsGrid().deleteRows([row]);
        this._onSettingsCountChange(-1);
    }
}

OMC.ReportBuilder.prototype._getPostbackForm = function () {
    /// <summary>Returns a postback form.</summary>

    var ret = null;
    var form = null;
    var forms = document.getElementsByTagName('form');

    if (forms && forms.length) {
        if (forms.length == 1) {
            ret = forms[0];
        } else {
            for (var i = 0; i < forms.length; i++) {
                form = $(forms[i]);

                if (form.readAttribute('action') == 'post' && form.readAttribute('name') == 'aspnetForm') {
                    ret = forms[i];
                    break;
                }
            }
        }
    }

    return ret;
}

OMC.ReportBuilder.prototype._getPostbackFrame = function () {
    /// <summary>Returns a window object that corresponds to a postback frame.</summary>

    var ret = null;
    var frames = document.getElementsByTagName('iframe');

    if (frames && frames.length) {
        for (var i = 0; i < frames.length; i++) {
            if ($(frames[i]).readAttribute('name') == 'frmPostback') {
                ret = frames[i].contentWindow || frames[i].window;
                break;
            }
        }
    }

    return ret;
}

OMC.ReportBuilder.prototype._onSettingsCountChange = function (delta) {
    /// <summary>Occurs when the number of advanced chart settings has been changed.</summary>
    /// <param name="delta">Indicatese how many chart settings has been either added or removed.</param>

    var current = 0;
    var outer = document.getElementById('spCountOuter');
    var inner = document.getElementById('spCountInner');

    if (inner) {
        current = parseInt(typeof (inner.innerText) != 'undefined' ? inner.innerText : inner.textContent);
    }

    current += parseInt(delta);
    if (current < 0) {
        current = 0;
    }

    if (inner) {
        inner.innerHTML = current;
    }

    if (outer) {
        outer.style.display = current > 0 ? '' : 'none';
    }
}

OMC.ReportBuilder.prototype._getCleanCategoryID = function (categoryID) {
    /// <summary>Returns clean category ID.</summary>
    /// <param name="categoryID">Category ID.</param>
    /// <returns>Clean category ID.</returns>
    /// <private />
    
    var ret = categoryID;

    ret = ret.replace(/<[\/]?div[^>]*>/gi, '');
    ret = ret.replace(/<span[^>]*>[^<]+<\/span>/gi, '/');
    ret = ret.replace('&nbsp;', '');

    return ret;
}

OMC.ReportBuilder.prototype._validateNumber = function (field) {
    /// <summary>Determines whether the value of the given field matches the numeric pattern.</summary>
    /// <param name="field">Field to examine.</param>
    /// <returns>Value indicating whether the value of the given field matches the numeric pattern.</returns>
    /// <private />

    var ret = false;

    if (field) {
        if (field.value && field.value.length) {
            ret = !!field.value.match(new RegExp('^[0-9]+$'));
        } else {
            ret = true;
        }
    }

    return ret;
}

OMC.ReportBuilder._chartTypesDataExchange = function (sender, args) {
    /// <summary>Occurs when the data between the currently selected item needs to be exchanged with data for the newly selected item.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>
    /// <private />

    if (args.dataSource && args.dataDestination) {
        args.dataDestination.innerHTML = '<div class="p-selected">' + $(args.dataSource).select('.p-name')[0].innerHTML + '</div>';
    }
}

OMC.ReportBuilder._categoriesDataExchange = function (sender, args) {
    /// <summary>Occurs when the data between the currently selected item needs to be exchanged with data for the newly selected item.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>
    /// <private />

    if (args.dataSource && args.dataDestination) {
        args.dataDestination.innerHTML = $(args.dataSource).innerHTML;
    }
}