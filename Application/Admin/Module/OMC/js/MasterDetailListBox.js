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

Dynamicweb.Controls.OMC.MasterDetailListBox = function () {
    /// <summary>Represents an editable list box.</summary>

    this._listControlInitialized = false;
    this._disableListEvents = false;
    this._listMaster = null;
    this._listDetail = null;

    this._selectedRow = null;
    this._selectedValue = null;
    this._hashedValues = {};
    this._hiddenValues = null;
    this._valuesCache = null;
}

Dynamicweb.Controls.OMC.MasterDetailListBox.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.OMC.MasterDetailListBox.prototype.add_itemAdding = function (handler) {
    /// <summary>Registers new handler which is executed when the new item is about to be added to the list.</summary>
    /// <param name="handler">Handler to register.</param>

    this.get_listMaster().add_itemAdding(handler);
}

Dynamicweb.Controls.OMC.MasterDetailListBox.prototype.add_itemRemoving = function (handler) {
    /// <summary>Registers new handler which is executed when the new item is about to be added to the list.</summary>
    /// <param name="handler">Handler to register.</param>

    this.get_listMaster().add_itemRemoving(handler);
}

Dynamicweb.Controls.OMC.MasterDetailListBox.prototype.get_listMaster = function () {
    /// <summary>Gets the object that is used to manipulate the control.</summary>

    if (!this._listMaster) {
        this._listMaster = new Dynamicweb.Extensibility.Editors.MultipleValuesEditor({ container: this.get_container().id + "Master", autoInitialize: false });
        this._listMaster.add_itemClicking((function (list, args) {
            if (this._disableListEvents) return;

            if (this._selectedRow) this._selectedRow.removeClassName('selected');
            this.get_listDetail().clear();

            this._selectedValue = args._item;
            this._selectedRow = args._row.up('li');
            this._selectedRow.addClassName('selected');

            this._disableListEvents = true;
            this.get_listDetail().set_values(this._hashedValues[this._selectedValue]);
            this.get_listDetail().set_isEnabled(true);
            this._disableListEvents = false;
        }).bind(this));
        this._listMaster.add_itemAdding((function (list, args) {
            if (this._disableListEvents) return;

            if (this._selectedRow) this._selectedRow.removeClassName('selected');
            this._disableListEvents = true;
            this.get_listDetail().clear();
            this.get_listDetail().set_isEnabled(true);
            this._disableListEvents = false;

            this._selectedValue = args._item;
            this._selectedRow = args._row.up('li');
            this._selectedRow.addClassName('selected');
            this._hashedValues[this._selectedValue] = [];
            this._hiddenValues.value = Object.toJSON(this._hashedValues);
        }).bind(this));
        this._listMaster.add_itemRemoving((function (list, args) {
            if (this._disableListEvents) return;

            delete this._hashedValues[args._item];
            this._disableListEvents = true;
            this.get_listDetail().clear();
            this.get_listDetail().set_isEnabled(false);
            this._disableListEvents = false;

            this._selectedValue = null;
            this._selectedRow = null;
            this._hiddenValues.value = Object.toJSON(this._hashedValues);
        }).bind(this));
    }

    return this._listMaster;
}

Dynamicweb.Controls.OMC.MasterDetailListBox.prototype.get_listDetail = function () {
    /// <summary>Gets the object that is used to manipulate the control.</summary>

    if (!this._listDetail) {
        this._listDetail = new Dynamicweb.Extensibility.Editors.MultipleValuesEditor({ container: this.get_container().id + "Detail", autoInitialize: true });

        this._listDetail.add_itemAdding((function (list, args) {
                if (this._disableListEvents) return;

                this._hashedValues[this._selectedValue] = list.get_values();
                this._hiddenValues.value = Object.toJSON(this._hashedValues);
            }).bind(this));
        this._listDetail.add_itemRemoving((function (list, args) {
                if (this._disableListEvents) return;

                var values = list.get_values();
                var item = args.get_item();
                var index = values.indexOf(item);

                if (index !== -1) {
                    values.splice(index, 1);
                }

                this._hashedValues[this._selectedValue] = values;             
                this._hiddenValues.value = Object.toJSON(this._hashedValues);
            }).bind(this));
    }

    return this._listDetail;
}

Dynamicweb.Controls.OMC.MasterDetailListBox.prototype.get_values = function () {
    /// <summary>Gets the list of currently selected values.</summary>

    return this._hiddenValues.value;
    //return !this._listControlInitialized ? (this._valuesCache || []) : this.get_listMaster().get_values();
}

Dynamicweb.Controls.OMC.MasterDetailListBox.prototype.set_values = function (value) {
    /// <summary>Sets the list of currently selected values.</summary>
    /// <param name="value">The list of currently selected values.</param>

    if (!this._listControlInitialized) {
        this._valuesCache = value;
    } else {
        value = value || "{}";
        this._hiddenValues.value = value; 
        this._hashedValues = value.evalJSON(value);

        this._disableListEvents = true;
        this.get_listMaster().set_values(this.get_MasterValues());
        this._disableListEvents = false;
    }
}

Dynamicweb.Controls.OMC.MasterDetailListBox.prototype.get_MasterValues = function () {
    var result = '';
    for (key in this._hashedValues) {
        if (result) result += ',' + key; 
        else result = key;
    }

    return result;
}

Dynamicweb.Controls.OMC.MasterDetailListBox.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>
    var self = this;
    var terminology = this.get_terminology();

    for (var prop in terminology) {
        if (typeof (terminology[prop]) != 'function') {
            this.get_listMaster().get_terminology()[prop] = terminology[prop];
        }
    }

    this._hiddenValues = $(this.get_container().id + "Values");

    this.get_listMaster().initialize();
    this._listControlInitialized = true;
    this.get_listDetail().set_isEnabled(false);

    if (this._valuesCache) {
        this.set_values(this._valuesCache);
        this._valuesCache = null;
    }

    this.add_propertyChanged(function (sender, args) {
        if (args.name == 'isEnabled') {
            self.get_listMaster().set_isEnabled(args.value);
        }
    });
}