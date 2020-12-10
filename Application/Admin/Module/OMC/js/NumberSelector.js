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

Dynamicweb.Controls.OMC.NumberFormatter = function () {
    /// <summary>Represents a number formatter.</summary>

    this._thouthandSeparator = ',';
    this._decimalSeparator = '.';
    this._decimalPrecision = 2;
    this._localizable = false;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.get_localizable = function () {
    /// <summary>Gets value indicating whether formatted numbers are localized according to the given settings.</summary>

    return this._localizable;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.set_localizable = function (value) {
    /// <summary>Sets value indicating whether formatted numbers are localized according to the given settings.</summary>
    /// <param name="value">Value indicating whether formatted numbers are localized according to the given settings.</param>

    this._localizable = !!value;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.get_thouthandSeparator = function () {
    /// <summary>Gets the thouthand separator.</summary>

    return this._thouthandSeparator;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.set_thouthandSeparator = function (value) {
    /// <summary>Sets the decimal separator.</summary>
    /// <param name="value">Decimal separator.</param>

    this._thouthandSeparator = value;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.get_decimalSeparator = function () {
    /// <summary>Gets the thouthand separator.</summary>

    return this._decimalSeparator;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.set_decimalSeparator = function (value) {
    /// <summary>Sets the decimal separator.</summary>
    /// <param name="value">Decimal separator.</param>

    this._decimalSeparator = value;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.get_decimalPrecision = function () {
    /// <summary>Gets the thouthand separator.</summary>

    return this._decimalPrecision;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.set_decimalPrecision = function (value) {
    /// <summary>Sets the decimal precision.</summary>
    /// <param name="value">Decimal precision.</param>

    this._decimalPrecision = value;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.format = function (value, params) {
    /// <summary>Formats the given number.</summary>
    /// <param name="value">Number to format.</param>
    /// <param name="params">Additional parameters.</param>

    var ret = '';

    if (!params) params = {};

    if (typeof (value) != 'undefined' && value != null && typeof (value) == 'number') {
        var integerPart = this.getIntegerPart(value);
        var decimalPart = this.getDecimalPart(value);

        if (integerPart != 0) {
            if (this.get_localizable()) {
                ret = integerPart.toString().replace(/\B(?=(\d{3})+(?!\d))/g, this.get_thouthandSeparator());
            } else {
                ret = integerPart.toString();
            }
        } else {
            ret = '0';
        }

        if (decimalPart != 0) {
            ret += (this.get_decimalSeparator().toString() + decimalPart.toString().replace(/[\d]+./, ''));
        } else if (!!params.forceDecimalPart) {
            ret += this.get_decimalSeparator().toString();
            for (var i = 0; i < this.get_decimalPrecision(); i++) {
                ret += '0';
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.getIntegerPart = function (number) {
    /// <summary>Returns the integer part of a given number.</summary>
    /// <param name="number">Number to get the integer part from.</param>

    return number > 0 ? Math.floor(number) : (number < 0 ? Math.ceil(number) : 0);
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.getDecimalPart = function (number) {
    /// <summary>Returns the decimal part of a given number.</summary>
    /// <param name="number">Decimal to get the integer part from.</param>
    
    return Math.abs(this.round(this.round(number) % 1));
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.round = function (number) {
    /// <summary>Rounds the given number to the specified number of decimal points.</summary>
    /// <param name="number">Number to round.</param>

    var decimals = this.get_decimalPrecision();

    return Math.round(number * Math.pow(10, decimals)) / Math.pow(10, decimals);
}

Dynamicweb.Controls.OMC.NumberFormatter.prototype.parse = function (value, parser, params) {
    /// <summary>Parses the  number from the given value.</summary>
    /// <param name="value">Value to parse number from.</param>
    /// <param name="parser">Parser to use.</param>
    /// <param name="params">Additional parameters.</param>

    var ret = 0;
    var parsed = null;

    if (!params) params = {};

    if (typeof (params.defaultValue) != 'undefined' && params.defaultValue != null) {
        ret = params.defaultValue;
    }

    if (typeof (value) != 'undefined' && parser != null) {
        parsed = parser(this.normalize(value));

        if (!isNaN(parsed) && parsed != null) {
            ret = parsed;
        }

        ret = this.round(ret);
    }

    return ret;
}


Dynamicweb.Controls.OMC.NumberFormatter.prototype.normalize = function (value) {
    /// <summary>Normalizes the given value to be suitable for parsing.</summary>
    /// <param name="value">Value to normalize.</param>

    var ret = value;
    var separator = this.get_decimalSeparator();
    var thouthands = this.get_thouthandSeparator();

    if (typeof (ret) != 'undefined' && ret != null && typeof (ret) == 'string') {
        if (separator != '.') {
            ret = ret.replace(new RegExp(separator, 'g'), '#');
        }

        if (thouthands == '.') {
            thouthands = '\\' + thouthands;
        }

        ret = ret.replace(new RegExp(thouthands, 'g'), '');
        ret = ret.replace(/#/g, '.');
    }

    return ret;
}

Dynamicweb.Controls.OMC.NumberSelectorValueParser = function () {
    /// <summary>Represents an object that all value parsers must implement.</summary>

    this._selector = null;
}

Dynamicweb.Controls.OMC.NumberSelectorValueParser.prototype.get_selector = function () {
    /// <summary>Gets the owning selector control.</summary>

    return this._selector;
}

Dynamicweb.Controls.OMC.NumberSelectorValueParser.prototype.set_selector = function (value) {
    /// <summary>Sets the owning selector control.</summary>
    /// <param name="value">The owning selector control.</param>

    this._selector = value;
}

Dynamicweb.Controls.OMC.NumberSelectorValueParser.prototype.valueFromString = function (input) {
    /// <summary>Parses the value from its string representation.</summary>
    /// <param name="input">String representation of the value.</param>
}

Dynamicweb.Controls.OMC.NumberSelectorValueParser.prototype.valueToString = function (value) {
    /// <summary>Converts the given value to its string representation.</summary>
    /// <param name="value">Value to convert.</param>
}

Dynamicweb.Controls.OMC.NumberSelectorValueParser.prototype.getDefaultValue = function () {
    /// <summary>Returns the default value.</summary>
}

Dynamicweb.Controls.OMC.NumberSelectorValueParser.prototype.incrementValue = function (value) {
    /// <summary>Increments the given value.</summary>
    /// <param name="value">Value to increment.</param>
}

Dynamicweb.Controls.OMC.NumberSelectorValueParser.prototype.decrementValue = function (value) {
    /// <summary>Decrements the given value.</summary>
    /// <param name="value">Value to decrement.</param>
}

Dynamicweb.Controls.OMC.NumberSelectorValueParser.prototype.compareValues = function (value1, value2) {
    /// <summary>Compares the two values and returns the comparison result.</summary>
    /// <param name="value1">First value to compare.</param>
    /// <param name="value2">Second value to compare.</param>
}

Dynamicweb.Controls.OMC.IntegerValueParser = function () {
    /// <summary>Represents an integer value parser.</summary>

    this._valueChangeStep = 1;
}

/* Inheritance */
Dynamicweb.Controls.OMC.IntegerValueParser.prototype = new Dynamicweb.Controls.OMC.NumberSelectorValueParser();

Dynamicweb.Controls.OMC.IntegerValueParser.prototype.get_valueChangeStep = function () {
    /// <summary>Gets the value change step.</summary>

    return this._valueChangeStep;
}

Dynamicweb.Controls.OMC.IntegerValueParser.prototype.set_valueChangeStep = function (value) {
    /// <summary>Sets the value change step.</summary>
    /// <param name="value">The value change step.</param>

    this._valueChangeStep = value;
}

Dynamicweb.Controls.OMC.IntegerValueParser.prototype.valueFromString = function (input) {
    /// <summary>Parses the value from its string representation.</summary>
    /// <param name="input">String representation of the value.</param>

    return this.get_selector().get_numberFormatter().parse(input, function (v) { return parseInt(v, 10); }, { defaultValue: this.getDefaultValue() });
}

Dynamicweb.Controls.OMC.IntegerValueParser.prototype.valueToString = function (value) {
    /// <summary>Converts the given value to its string representation.</summary>
    /// <param name="value">Value to convert.</param>

    return this.get_selector().get_numberFormatter().format(value);
}

Dynamicweb.Controls.OMC.IntegerValueParser.prototype.getDefaultValue = function () {
    /// <summary>Returns the default value.</summary>

    return 0;
}

Dynamicweb.Controls.OMC.IntegerValueParser.prototype.incrementValue = function (value) {
    /// <summary>Increments the given value.</summary>
    /// <param name="value">Value to increment.</param>

    return this.get_selector().get_numberFormatter().round(value + this.get_valueChangeStep());
}

Dynamicweb.Controls.OMC.IntegerValueParser.prototype.decrementValue = function (value) {
    /// <summary>Decrements the given value.</summary>
    /// <param name="value">Value to decrement.</param>

    return this.get_selector().get_numberFormatter().round(value - this.get_valueChangeStep());
}

Dynamicweb.Controls.OMC.IntegerValueParser.prototype.compareValues = function (value1, value2) {
    /// <summary>Compares the two values and returns the comparison result.</summary>
    /// <param name="value1">First value to compare.</param>
    /// <param name="value2">Second value to compare.</param>

    return value1 - value2;
}

Dynamicweb.Controls.OMC.FloatValueParser = function () {
    /// <summary>Represents an float value parser.</summary>
}

/* Inheritance */
Dynamicweb.Controls.OMC.FloatValueParser.prototype = new Dynamicweb.Controls.OMC.IntegerValueParser();

Dynamicweb.Controls.OMC.FloatValueParser.prototype.valueFromString = function (input) {
    /// <summary>Parses the value from its string representation.</summary>
    /// <param name="input">String representation of the value.</param>

    return this.get_selector().get_numberFormatter().parse(input, function (v) { return parseFloat(v); }, { defaultValue: this.getDefaultValue() });
}

Dynamicweb.Controls.OMC.FloatValueParser.prototype.valueToString = function (value) {
    /// <summary>Converts the given value to its string representation.</summary>
    /// <param name="value">Value to convert.</param>

    return this.get_selector().get_numberFormatter().format(value, { forceDecimalPart: true });
}

Dynamicweb.Controls.OMC.NumberSelector = function () {
    /// <summary>Represents a number selector.</summary>

    this._selectedValue = '';
    this._minValue = 0;
    this._maxValue = 0;
    this._allowNegativeValues = false;

    this._changeValueInterval = null;
    this._changeValueTimeout = null;
    this._changeValueEndHandler = null;
    this._hasFocus = false;
    this._isSilent = false;
    this._parser = null;
    this._numberFormatter = null;
}

/* Inheritance */
Dynamicweb.Controls.OMC.NumberSelector.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.OMC.NumberSelector.prototype.add_valueChanged = function (callback) {
    /// <summary>Registers new callback which is executed when the value changes.</summary>
    /// <param name="callback">Callback to register.</param>

    this.addEventHandler('valueChanged', callback);
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.get_numberFormatter = function () {
    /// <summary>Gets the number formatter.</summary>

    if (!this._numberFormatter) {
        this._numberFormatter = new Dynamicweb.Controls.OMC.NumberFormatter();
    }

    return this._numberFormatter;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.set_numberFormatter = function (value) {
    /// <summary>Sets the number formatter.</summary>
    /// <param name="value">The number formatter.</param>

    this._numberFormatter = value;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.get_parser = function () {
    /// <summary>Gets an object that is responsible for parsing values.</summary>

    return this._parser;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.set_parser = function (value) {
    /// <summary>Sets an object that is responsible for parsing values.</summary>
    /// <param name="value">An object that is responsible for parsing values.</param>

    this._parser = value;

    /* Doesn't satisfy the contract */
    if (this._parser && typeof (this._parser.valueFromString) != 'function') {
        this._parser = null;
    } else {
        this._parser.set_selector(this);
    }
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.get_isSilent = function () {
    /// <summary>Gets value indicating whether to prohibit any notifications from being fired.</summary>

    return this._isSilent;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.set_isSilent = function (value) {
    /// <summary>Sets value indicating whether to prohibit any notifications from being fired.</summary>
    /// <param name="value">Value indicating whether to prohibit any notifications from being fired.</param>

    this._isSilent = !!value;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.get_hasFocus = function () {
    /// <summary>Gets value indicating whether control is currently focused.</summary>

    return this._hasFocus;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.get_selectedValue = function () {
    /// <summary>Gets the currently selected value.</summary>

    var ret = null;

    if (typeof (this.get_state().value) != 'undefined' && this.get_parser() != null) {
        ret = this.get_parser().valueFromString(this.get_state().value.value);

        if (this.get_parser().compareValues(ret, this.get_maxValue()) > 0) {
            ret = this.get_maxValue();
        } else if (this.get_parser().compareValues(ret, this.get_minValue()) < 0) {
            ret = this.get_minValue();
        }

        if (this.get_parser().compareValues(ret, 0) < 0 && !this.get_allowNegativeValues()) {
            ret = this.get_minValue();
            if (ret < 0) {
                ret = 0;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.set_selectedValue = function (value) {
    /// <summary>Sets the currently selected value.</summary>
    /// <param name="value">Currently selected value.</param>

    var val = null;

    if (this.get_parser() != null) {
        val = this.get_parser().valueFromString(value);

        if (typeof (this.get_state().value) != 'undefined') {
            if (this.get_parser().compareValues(val, this.get_maxValue()) > 0) {
                val = this.get_maxValue();
            } else if (this.get_parser().compareValues(val, this.get_minValue()) < 0) {
                val = this.get_minValue();
            }

            if (this.get_parser().compareValues(val, 0) < 0 && !this.get_allowNegativeValues()) {
                val = this.get_minValue();
                if (val < 0) {
                    val = 0;
                }
            }

            this.get_state().value.value = this.get_parser().valueToString(val);
            this.onValueChanged({ value: val });
        }
    }
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.get_minValue = function () {
    /// <summary>Gets the minimum allowed value.</summary>

    return this._minValue;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.set_minValue = function (value) {
    /// <summary>Sets the minimum allowed value.</summary>
    /// <param name="value">The minimum allowed value.</param>

    this._minValue = null;

    if (this.get_parser() != null) {
        this._minValue = this.get_parser().valueFromString(value);
    }
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.get_maxValue = function () {
    /// <summary>Gets the maximum allowed value.</summary>

    return this._maxValue;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.set_maxValue = function (value) {
    /// <summary>Sets the maximum allowed value.</summary>
    /// <param name="value">The maximum allowed value.</param>

    this._maxValue = null;

    if (this.get_parser() != null) {
        this._maxValue = this.get_parser().valueFromString(value);
    }
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.get_allowNegativeValues = function () {
    /// <summary>Gets value indicating whether negative numbers are allowed.</summary>

    return this._allowNegativeValues;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.set_allowNegativeValues = function (value) {
    /// <summary>Sets value indicating whether negative numbers are allowed.</summary>
    /// <param name="value">Value indicating whether negative numbers are allowed.</param>

    this._allowNegativeValues = !!value;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.changeValue = function (factor) {
    /// <summary>Changes the current value according to value change step.</summary>
    /// <param name="factor">Numeric value indicating the direction of the change.</param>

    var ret = false;
    var newValue = 0;

    if (typeof (factor) != 'number' || factor == 0) {
        factor = 1;
    }

    if (factor > 1) {
        factor = 1;
    } else if (factor < 1) {
        factor = -1;
    }

    if (this.get_parser() != null) {
        if (factor > 0) {
            newValue = this.get_parser().incrementValue(this.get_selectedValue());
        } else {
            newValue = this.get_parser().decrementValue(this.get_selectedValue());
        }
    }

    if (this.get_parser().compareValues(newValue, this.get_minValue()) >= 0 &&
        this.get_parser().compareValues(newValue, this.get_maxValue()) <= 0 &&
        (this.get_allowNegativeValues() || this.get_parser().compareValues(newValue, 0) >= 0)) {

        ret = true;
        this.set_selectedValue(newValue);
    }

    return ret;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.updateValue = function () {
    /// <summary>Updates the currently selected value according to current validation rules (value range, numeric parsing).</summary>

    this.set_selectedValue(this.get_state().value.value);
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;
    var actionWrapper = function (e, action) {
        if (action && typeof (action) == 'function') {
            if (self.get_isEnabled()) {
                action();
            } else {
                Event.stop(e);
            }
        }
    }

    this._initializeState();

    this.add_propertyChanged(function (sender, args) {
        var selectedValue = self.get_selectedValue();

        if (args.name == 'isEnabled' && self.get_parser() != null) {
            if (args.value) {
                self.get_state().value.disabled = false;

                if (self.get_parser().compareValues(selectedValue, self.get_minValue()) <= 0) {
                    self.get_state().downButton.addClassName('number-selector-arrow-disabled');
                } else {
                    self.get_state().downButton.removeClassName('number-selector-arrow-disabled');
                }

                if (self.get_parser().compareValues(selectedValue, self.get_maxValue()) >= 0) {
                    self.get_state().upButton.addClassName('number-selector-arrow-disabled');
                } else {
                    self.get_state().upButton.removeClassName('number-selector-arrow-disabled');
                }
            } else {
                self.get_state().value.disabled = true;
                self.get_state().downButton.addClassName('number-selector-arrow-disabled');
                self.get_state().upButton.addClassName('number-selector-arrow-disabled');
            }
        }
    });

    Event.observe(this.get_state().upButton, 'mousedown', function (e) { actionWrapper(e, function () { self._beginChangeValue(self.get_state().upButton, self.get_state().downButton, 1); }); });
    Event.observe(this.get_state().downButton, 'mousedown', function (e) { actionWrapper(e, function () { self._beginChangeValue(self.get_state().downButton, self.get_state().upButton, -1); }); });

    Event.observe(this.get_state().upButton, 'mouseout', function (e) { actionWrapper(e, function () { self._endChangeValue(); }); });
    Event.observe(this.get_state().downButton, 'mouseout', function (e) { actionWrapper(e, function () { self._endChangeValue(); }); });

    Event.observe(this.get_state().upButton, 'mouseup', function (e) { actionWrapper(e, function () { self._endChangeValue(); }); });
    Event.observe(this.get_state().downButton, 'mouseup', function (e) { actionWrapper(e, function () { self._endChangeValue(); }); });

    Event.observe(this.get_state().value, 'focus', function (e) {
        self._hasFocus = true;
    });

    Event.observe(this.get_state().value, 'blur', function (e) {
        self._hasFocus = false;
        self.updateValue();
    });

    try {
        this.set_selectedValue(this.get_selectedValue());
    } catch (ex) { }
}

Dynamicweb.Controls.OMC.NumberSelector.prototype.onValueChanged = function (e) {
    /// <summary>Fires "valueChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.raiseEvent('valueChanged', e);
}

Dynamicweb.Controls.OMC.NumberSelector.prototype._beginChangeValue = function (button, opposite, factor) {
    /// <summary>Initiates the repetitive value change.</summary>
    /// <param name="button">Action trigger (arrow).</param>
    /// <param name="opposite">Opposite button.</param>
    /// <param name="factor">Change factor.</param>
    /// <private />

    var self = this;

    this._endChangeValue();

    if (this._changeValue(button, opposite, factor)) {
        this._changeValueTimeout = setTimeout(function () {
            self._changeValueInterval = setInterval(function () {
                if (!self._changeValue(button, opposite, factor)) {
                    self._endChangeValue();
                }
            }, 100);
        }, 500);
    }
}

Dynamicweb.Controls.OMC.NumberSelector.prototype._endChangeValue = function () {
    /// <summary>Finalizes the repetitive value change.</summary>
    /// <private />

    if (this._changeValueTimeout) {
        clearTimeout(this._changeValueTimeout);
        this._changeValueTimeout = null;
    }

    if (this._changeValueInterval) {
        clearInterval(this._changeValueInterval);
        this._changeValueInterval = null;
    }
}

Dynamicweb.Controls.OMC.NumberSelector.prototype._changeValue = function (button, opposite, factor) {
    /// <summary>Changes the currently selected value.</summary>
    /// <param name="button">Button representing an initiator of the change.</param>
    /// <param name="opposite">Opposite button.</param>
    /// <param name="factor">Change factor.</param>
    /// <private />

    var ret = false;

    if (!button.hasClassName('number-selector-arrow-disabled')) {
        ret = this.changeValue(factor);

        if (!ret) {
            button.addClassName('number-selector-arrow-disabled');
            this._endChangeValue();
        } else if (opposite.hasClassName('number-selector-arrow-disabled')) {
            opposite.removeClassName('number-selector-arrow-disabled');
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.NumberSelector.prototype._initializeState = function () {
    /// <summary>Initializes object cache.</summary>
    /// <private />
    
    if (this.get_container()) {
        this.get_state().value = $(this.get_container().select('input.number-selector-value')[0]);
        this.get_state().upButton = $(this.get_container().select('a.number-selector-arrow-up')[0]);
        this.get_state().downButton = $(this.get_container().select('a.number-selector-arrow-down')[0]);
    }
}