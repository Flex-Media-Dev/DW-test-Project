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

Dynamicweb.Controls.OMC.ColorSelector = function () {
    /// <summary>Represents a color selector.</summary>

    this._selectedColor = '';
    this._selectedColorControl = null;
}

/* Inheritance */
Dynamicweb.Controls.OMC.ColorSelector.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.OMC.ColorSelector.prototype.get_selectedColor = function () {
    /// <summary>Gets the currently selected color.</summary>

    var ret = this._selectedColor;

    if (!this._selectedColorControl && this.get_container() && this.get_container().id) {
        this._selectedColorControl = this.get_container().select('input');
        if (this._selectedColorControl && this._selectedColorControl.length) {
            this._selectedColorControl = this._selectedColorControl[0];
        }
    }

    if (this._selectedColorControl) {
        if (this._selectedColor != null) {
            if (!this._selectedColor.value.length) {
                this._selectedColorControl.value = this._selectedColor;
            }
        }

        this._selectedColor = null;

        ret = this._selectedColorControl.value;
    }

    return ret;
}

Dynamicweb.Controls.OMC.ColorSelector.prototype.set_selectedColor = function (value) {
    /// <summary>Sets the currently selected color.</summary>
    /// <param name="value">The currently selected color.</param>

    if (!this._selectedColorControl && this.get_container() && this.get_container().id) {
        this._selectedColorControl = this.get_container().select('input');
        if (this._selectedColorControl && this._selectedColorControl.length) {
            this._selectedColorControl = this._selectedColorControl[0];
        }
    }

    if (this._selectedColorControl) {
        this._selectedColorControl.value = value;
    } else {
        this._selectedColor = value;
    }
}

Dynamicweb.Controls.OMC.ColorSelector.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;
    
    this.add_propertyChanged(function (sender, args) {
        var selectedColor = null;

        if (args.name == 'isEnabled') {
            selectedColor = self.get_container().select('input');
            if (selectedColor && selectedColor.length) {
                selectedColor = selectedColor[0];
                selectedColor.disabled = !args.value;
            }
        }
    });
}