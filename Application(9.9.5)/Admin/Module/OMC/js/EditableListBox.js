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

Dynamicweb.Controls.OMC.EditableListBox = function () {
    /// <summary>Represents an editable list box.</summary>

    this._proxy = null;
    this._valuesCache = null;
    this._proxyInitialized = false;
}

Dynamicweb.Controls.OMC.EditableListBox.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.OMC.EditableListBox.prototype.add_itemAdding = function (handler) {
    /// <summary>Registers new handler which is executed when the new item is about to be added to the list.</summary>
    /// <param name="handler">Handler to register.</param>

    this.get_proxy().add_itemAdding(handler);
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.add_itemRemoving = function (handler) {
    /// <summary>Registers new handler which is executed when the new item is about to be added to the list.</summary>
    /// <param name="handler">Handler to register.</param>

    this.get_proxy().add_itemRemoving(handler);
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.get_proxy = function () {
    /// <summary>Gets the object that is used to manipulate the control.</summary>

    if (!this._proxy) {
        this._proxy = new Dynamicweb.Extensibility.Editors.MultipleValuesEditor({ container: this.get_container().id, autoInitialize: false });
    }

    return this._proxy;
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.get_values = function () {
    /// <summary>Gets the list of currently selected values.</summary>

    return !this._proxyInitialized ? (this._valuesCache || []) : this.get_proxy().get_values();
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.set_values = function (value) {
    /// <summary>Sets the list of currently selected values.</summary>
    /// <param name="value">The list of currently selected values.</param>

    if (!this._proxyInitialized) {
        this._valuesCache = value;
    } else {
        this.get_proxy().set_values(value);
    }
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.add = function (value) {
    /// <summary>Adds new value.</summary>
    /// <param name="value">Value to add.</param>

    this.get_proxy().add(value);
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.remove = function (index) {
    /// <summary>Removes the given value.</summary>
    /// <param name="index">Zero-based index of the value to remove.</param>

    this.get_proxy().remove(index);
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.clear = function () {
    /// <summary>Clears the list as well as the hidden field that contains currently selected values.</summary>

    this.get_proxy().clear();
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.clearList = function () {
    /// <summary>Clears the list only.</summary>

    this.get_proxy().clearList();
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.refresh = function () {
    /// <summary>Refreshes the list.</summary>

    this.get_proxy().refresh();
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;
    var terminology = this.get_terminology();

    for (var prop in terminology) {
        if (typeof (terminology[prop]) != 'function') {
            this.get_proxy().get_terminology()[prop] = terminology[prop];
        }
    }

    this.get_proxy().initialize();
    this._proxyInitialized = true;

    if (this._valuesCache) {
        this.set_values(this._valuesCache);
        this._valuesCache = null;
    }

    this.add_propertyChanged(function (sender, args) {
        if (args.name == 'isEnabled') {
            self.get_proxy().set_isEnabled(args.value);
        }
    });
}