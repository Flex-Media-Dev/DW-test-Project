/* ++++++ Registering namespace ++++++ */

if (typeof (OMC) == 'undefined') {
    var OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

OMC.EditTheme = function () {
    /// <summary>Represents a report theme edit page.</summary>

    this._terminology = {};
    this._fontSelector = null;
    this._initialized = false;
    this._advancedSettingsVisible = false;
}

OMC.EditTheme.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object that holds all localized strings.</summary>

    if (!this._terminology) {
        this._terminology = [];
    }

    return this._terminology;
}

OMC.EditTheme.prototype.get_fontSelector = function () {
    /// <summary>Gets an instance of the font selector control.</summary>

    var self = this;

    if (typeof (this._fontSelector) == 'string') {
        try {
            this._fontSelector = eval(this._fontSelector);
        } catch (ex) { self._fontSelector = null; }
    }

    return this._fontSelector;
}

OMC.EditTheme.prototype.set_fontSelector = function (value) {
    /// <summary>Sets an instance of the font selector control.</summary>
    /// <param name="value">An instance of the font selector control.</summary>

    this._fontSelector = value;
}

OMC.EditTheme.prototype.get_advancedSettingsVisible = function () {
    /// <summary>Gets value indicating whether advanced chart settings dialog is visible.</summary>

    return this._advancedSettingsVisible;
}

OMC.EditTheme.prototype.set_advancedSettingsVisible = function (value) {
    /// <summary>Sets value indicating whether advanced settings dialog is visible.</summary>
    /// <param name="value">Value indicating whether advanced settings dialog is visible.</param>

    this._advancedSettingsVisible = !!value;

    if (this._advancedSettingsVisible) {
        dialog.show('dlgAdvancedSettings');
    } else {
        dialog.hide('dlgAdvancedSettings');
    }
}

OMC.EditTheme.prototype.get_settingsGrid = function () {
    /// <summary>Gets the reference to settings grid.</summary>

    if (this._settingsGrid && typeof (this._settingsGrid) == 'string') {
        this._settingsGrid = eval(this._settingsGrid);
    }

    return this._settingsGrid;
}

OMC.EditTheme.prototype.set_settingsGrid = function (value) {
    /// <summary>Sets the reference to settings grid.</summary>
    /// <param name="value">The reference to settings grid.</param>

    this._settingsGrid = value;
}

OMC.EditTheme.prototype.initialize = function () {
    /// <summary>Initializes the object.</summary>

    var self = this;

    if (!this._initialized) {
        this.get_settingsGrid().onRowAddedCompleted = function (row) {
            self._onSettingsCountChange(1);
        }

        this._initialized = true;
    }
}

OMC.EditTheme.prototype.validate = function (onComplete) {
    /// <summary>Validates the form.</summary>
    /// <param name="onComplete">Callback that is executed when the form is validated.</param>

    var url = '';
    var name = null;
    var self = this;
    var lineWidth = null, pointSize = null;
    var callback = onComplete || function () { }

    name = $$('input.field-name')[0];
    lineWidth = $$('input.field-linewidth')[0];
    pointSize = $$('input.field-pointsize')[0];

    if (!name.value) {
        alert(this.get_terminology()['EmptyName']);

        try {
            name.focus();
        } catch (ex) { }

        callback(false);
    } else if (parent.OMC.MasterPage.get_current().containsInvalidNameCharacters(name.value)) {
        alert(this.get_terminology()['InvalidNameCharacters'].replace('%%', '\'' + parent.OMC.MasterPage.get_current().get_invalidNameCharacters().join(' ') + '\''));

        try {
            name.focus();
            name.select();
        } catch (ex) { }

        callback(false);
    } else if (!this._validateNumber(lineWidth)) {
        alert(this.get_terminology()['InvalidLineWidth']);

        try {
            lineWidth.focus();
            lineWidth.select();
        } catch (ex) { }

        callback(false);
    } else if (!this._validateNumber(pointSize)) {
        alert(this.get_terminology()['InvalidPointSize']);

        try {
            pointSize.focus();
            pointSize.select();
        } catch (ex) { }

        callback(false);
    } else if (this.get_fontSelector() != null && this.get_fontSelector().validate({
        validateEmptyFontFamily: false, validateInvalidFontSize: true
    }) != 'OK') {

        alert(this.get_terminology()['InvalidFontSize']);

        if (this.get_fontSelector().get_fontSizeControl()) {
            try {
                this.get_fontSelector().get_fontSizeControl().focus();
                this.get_fontSelector().get_fontSizeControl().select();
            } catch (ex) { }
        }

        callback(false);
    } else {
        url = '/Admin/Module/OMC/Reports/EditTheme.aspx?CheckExistance=' + encodeURIComponent(name.value) + '&OriginalThemeID=' +
            encodeURIComponent(document.getElementById('OriginalThemeID').value);

        new Ajax.Request(url, {
            method: 'get',
            onComplete: function (transport) {
                isValid = transport.responseText.toLowerCase() == 'false';

                if (!isValid) {
                    alert(self.get_terminology()['ExistingName']);

                    try {
                        name.focus();
                        name.select();
                    } catch (ex) { }
                }

                callback(isValid);
            }
        });
    }
}

OMC.EditTheme.prototype.confirmDeleteSetting = function (link) {
    /// <summary>Displays a confirm message of deleting the setting row and deletes it if the user confirms his choice.</summary>
    /// <param name="link">Link that user has clicked.</param>

    var row = null;
    var txName = null;
    var settingName = '';
    var msg = this.get_terminology()['DeleteSetting'];

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

OMC.EditTheme.prototype.deleteSetting = function (row) {
    /// <summary>Deletes the given row from the settings grid.</summary>
    /// <param name="row">Row to delete.</param>

    if (row) {
        this.get_settingsGrid().deleteRows([row]);
        this._onSettingsCountChange(-1);
    }
}

OMC.EditTheme.prototype.save = function () {
    /// <summary>Saves the theme.</summary>

    parent.Toolbar.setButtonIsDisabled('cmdSave', true);
    parent.Toolbar.setButtonIsDisabled('cmdCancel', true);

    this.validate(function (isValid) {
        if (isValid) {
            document.getElementById('cmdSubmit').click();
        } else {
            parent.Toolbar.setButtonIsDisabled('cmdSave', false);
            parent.Toolbar.setButtonIsDisabled('cmdCancel', false);
        }
    });
}

OMC.EditTheme.prototype._validateNumber = function (field) {
    /// <summary>Determines whether the value of the given field matches the numeric pattern.</summary>
    /// <param name="field">Field to examine.</param>
    /// <returns>Value indicating whether the value of the given field matches the numeric pattern.</returns>
    /// <private />

    var ret = false;

    if (field) {
        if (field.value && field.value.length) {
            ret = !!field.value.match(new RegExp('^[0-9]+$'));
        } 
    }

    return ret;
}

OMC.EditTheme.prototype._onSettingsCountChange = function (delta) {
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

OMC.EditTheme._listDataExchange = function (sender, args) {
    /// <summary>Occurs when the data between currently selected list item and the box template needs to be exchanged.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event argument.</param>
    /// <private />

    var f = null;

    if (args.dataSource && args.dataDestination) {
        f = typeof (args.dataSource.innerText) != 'undefined' ? args.dataSource.innerText : args.dataSource.textContent;
        args.dataDestination.innerHTML = '<span class="p-selected">' + f + '</span>';
    }
}

OMC.EditTheme._onColorsItemAdding = function (sender, args) {
    /// <summary>Occurs when the new item is being added to the "Colors" list box.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event argument.</param>
    /// <private />

    var color = null;
    var container = null;

    if (args) {
        if (args.get_item() && args.get_row()) {
            color = args.get_item();

            if (color.indexOf('#') != 0) {
                if ((color.length == 6 || color.length == 3) && color.match(/^[a-fA-F0-9]+$/gi)) {
                    color = '#' + color.toUpperCase();
                }
            } else {
                color = color.toUpperCase();
            }
            
            args.get_row().update('');

            container = new Element('span', { 'class': 'color-row', 'title': color });
            container.setStyle({ 'backgroundColor': color });

            args.get_row().appendChild(container);
            args.get_row().appendChild(document.createTextNode(color));
        }
    }
}