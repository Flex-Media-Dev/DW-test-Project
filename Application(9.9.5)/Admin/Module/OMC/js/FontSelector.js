/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

if (typeof (Dynamicweb.Controls.OMC) == 'undefined') {
    Dynamicweb.Controls.OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Controls.OMC.FontSelector = function (controlID) {
    /// <summary>Represents a font selector.</summary>
    /// <param name="controlID">Unique identifier of the control assigned by ASP.NET.</param>

    this._selector = null;
    this._selectorID = this._selector;

    this._fontFamily = '';
    this._fontSize = 0;
    this._fontFamilyControl = null;
    this._fontSizeControl = null;
}

/* Inheritance */
Dynamicweb.Controls.OMC.FontSelector.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.OMC.FontSelector.prototype.get_selector = function () {
    /// <summary>Gets the font family selector control.</summary>

    if (this._selector == null || typeof (this._selector) == 'string') {
        try {
            this._selector = eval(this._selectorID);
        } catch (ex) { }
    }

    return this._selector;
}

Dynamicweb.Controls.OMC.FontSelector.prototype.set_selector = function (value) {
    /// <summary>Sets the font family selector control.</summary>
    /// <param name="value">Font family selector control.</param>

    this._selector = value;

    if (typeof (value) == 'string') {
        this._selectorID = value;
    } else {
        this._selectorID = '';
    }
}

Dynamicweb.Controls.OMC.FontSelector.prototype.get_fontFamily = function () {
    /// <summary>Gets the currently selected font family.</summary>

    var ret = this._fontFamily;

    if (this.get_fontFamilyControl()) {
        if (this._fontFamily != null) {
            if (!this.get_fontFamilyControl().value.length) {
                this.get_fontFamilyControl().value = this._fontFamily;
            }

            this._fontFamily = null;
        }

        ret = this.get_fontFamilyControl().value;
    }
}

Dynamicweb.Controls.OMC.FontSelector.prototype.set_fontFamily = function (value) {
    /// <summary>Sets the currently selected font family.</summary>
    /// <param name="value">The currently selected font family.</param>

    if (this.get_fontFamilyControl()) {
        this.get_fontFamilyControl().value = value;
    } else {
        this._fontFamily = value;
    }
}

Dynamicweb.Controls.OMC.FontSelector.prototype.get_fontSize = function () {
    /// <summary>Gets the currently selected font size.</summary>

    var ret = this._fontSize;

    if (this.get_fontSizeControl()) {
        if (this._fontSize != null) {
            if (!this.get_fontSizeControl().value.length) {
                this.get_fontSizeControl().value = this._fontSize;
            }

            this._fontSize = null;
        }

        ret = this.get_fontSizeControl().value;
    }

    return parseInt(ret) || 0;
}

Dynamicweb.Controls.OMC.FontSelector.prototype.set_fontSize = function (value) {
    /// <summary>Sets the currently selected font size.</summary>
    /// <param name="value">The currently selected font size.</param>

    if (this.get_fontSizeControl()) {
        this.get_fontSizeControl().value = parseInt(value) || 0;
    } else {
        this._fontSize = value;
    }
}

Dynamicweb.Controls.OMC.FontSelector.prototype.get_fontFamilyControl = function () {
    /// <summary>Gets the reference to DOM element representing a font family value holder.</summary>

    if (!this._fontFamilyControl && this.get_container() && this.get_container().id) {
        this._fontFamilyControl = this.get_container().select('input.font-selector-family');
        if (this._fontFamilyControl && this._fontFamilyControl.length) {
            this._fontFamilyControl = this._fontFamilyControl[0];
        }
    }

    return this._fontFamilyControl;
}

Dynamicweb.Controls.OMC.FontSelector.prototype.get_fontSizeControl = function () {
    /// <summary>Gets the reference to DOM element representing a font size control.</summary>

    if (!this._fontSizeControl && this.get_container() && this.get_container().id) {
        this._fontSizeControl = this.get_container().select('input.font-selector-size');
        if (this._fontSizeControl && this._fontSizeControl.length) {
            this._fontSizeControl = this._fontSizeControl[0];
        }
    }

    return this._fontSizeControl;
}

Dynamicweb.Controls.OMC.FontSelector.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;
    var fontFamilyControl = null;

    this.add_propertyChanged(function (sender, args) {
        if (args.name == 'isEnabled') {
            if (args.value) {
                self.get_selector().set_isEnabled(true);
                self.get_fontSizeControl().disabled = false;

            } else {
                self.get_selector().set_isEnabled(false);
                self.get_fontSizeControl().disabled = true;
            }
        }
    });

    if (this.get_selector()) {
        if (typeof (this.get_selector().initialize) == 'function') {
            this.get_selector().initialize();
        }

        if (typeof (this.get_selector().add_valueChanged) == 'function') {
            this.get_selector().add_valueChanged(function (sender, args) {
                self.set_fontFamily(args.value);
            });
        }
    }

    if (this.get_container() && this.get_container().id) {
        fontFamilyControl = this.get_container().select('input.font-selector-family');
        if (fontFamilyControl && fontFamilyControl.length) {
            this.set_fontFamily(fontFamilyControl[0].value);
        }
    }
}

Dynamicweb.Controls.OMC.FontSelector.prototype.validate = function (params) {
    /// <summary>Validates the control.</summary>
    /// <param name="params">Validation parameters.</param>
    /// <returns>Validation result.</returns>

    var ret = 'OK';

    if (!params) {
        params = {};

        params.validateEmptyFontFamily = true;
        params.validateInvalidFontSize = true;
    }

    if (!!params.validateEmptyFontFamily && this.get_fontFamily().length == 0) {
        ret = 'EmptyFontFamily';
    } else if (!!params.validateInvalidFontSize && this.get_fontSize() <= 0) {
        ret = 'InvalidFontSize';
    }

    return ret;
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStandard = function (id) {
    /// <summary>Represents a font family selector which is based on a standard SELECT control.</summary>
    /// <param name="id">Control identifier.</param>

    this._controlID = id;
    this._callbacks = [];
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStandard.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;
    var ctrl = $(this._controlID);

    if (ctrl) {
        Event.observe(ctrl, 'change', function (e) {
            self._notify(ctrl.options[ctrl.selectedIndex].value);
        });
    }
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStandard.prototype.get_isEnabled = function () {
    /// <summary>Gets value indicating whether drop-down list is enabled.</summary>

    var ret = true;
    var ctrl = $(this._controlID);

    if (ctrl) {
        ret = !ctrl.disabled;
    }

    return ret;
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStandard.prototype.set_isEnabled = function (value) {
    /// <summary>Sets value indicating whether drop-down list is enabled.</summary>
    /// <param name="value">Value indicating whether drop-down list is enabled.</param>

    var ret = true;
    var ctrl = $(this._controlID);

    if (ctrl) {
        ctrl.disabled = !value;
    }

    return ret;
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStandard.prototype.add_valueChanged = function (callback) {
    /// <summary>Registers a callback that is fired whenever drop-down list value changes.</summary>
    /// <param name="callback">Callback to fire.</param>

    this._callbacks[this._callbacks.length] = callback || function () { }
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStandard.prototype._notify = function (value) {
    /// <summary>Notifies clients that the drop-down list value has changed.</summary>
    /// <param name="value">Selected value.</param>
    /// <private />

    for (var i = 0; i < this._callbacks.length; i++) {
        if (typeof (this._callbacks[i]) == 'function') {
            try {
                this._callbacks[i](this, { value: value });
            } catch (ex) { }
        }
    }
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStylish = function (list) {
    /// <summary>Represents a font family selector which is based on a TemplatedDropDownList control.</summary>
    /// <param name="list">Client-side object instance of the underlying control.</param>

    this._list = list;
    this._callbacks = [];
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStylish.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;

    try {
        this._list = eval(this._list);
    } catch (ex) { }

    if (this._list) {
        this._list.add_dataExchange(function (sender, args) {
            var f = null;

            if (args.dataSource && args.dataDestination) {
                f = typeof (args.dataSource.innerText) != 'undefined' ? args.dataSource.innerText : args.dataSource.textContent;
                args.dataDestination.innerHTML = '<span class="font-selector-dd-item" style="font-family: ' + f + '">' + f + '</span>';
            }
        });

        this._list.add_selectedIndexChanged(function (sender, args) {
            if (args.item) {
                self._notify(typeof (args.item.innerText) != 'undefined' ? args.item.innerText : args.item.textContent);
            }
        });
    }
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStylish.prototype.get_isEnabled = function () {
    /// <summary>Gets value indicating whether drop-down list is enabled.</summary>

    var ret = true;

    if (this._list) {
        ret = this._list.get_isEnabled();
    }

    return ret;
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStylish.prototype.set_isEnabled = function (value) {
    /// <summary>Sets value indicating whether drop-down list is enabled.</summary>
    /// <param name="value">Value indicating whether drop-down list is enabled.</param>

    if (this._list) {
        this._list.set_isEnabled(value);
    }
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStylish.prototype.add_valueChanged = function (callback) {
    /// <summary>Registers a callback that is fired whenever drop-down list value changes.</summary>
    /// <param name="callback">Callback to fire.</param>

    this._callbacks[this._callbacks.length] = callback || function () { }
}

Dynamicweb.Controls.OMC.FontSelector.DropDownListStylish.prototype._notify = function (value) {
    /// <summary>Notifies clients that the drop-down list value has changed.</summary>
    /// <param name="value">Selected value.</param>
    /// <private />

    for (var i = 0; i < this._callbacks.length; i++) {
        if (typeof (this._callbacks[i]) == 'function') {
            try {
                this._callbacks[i](this, { value: value });
            } catch (ex) { }
        }
    }
}



