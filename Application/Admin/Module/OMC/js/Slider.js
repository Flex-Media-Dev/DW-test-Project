/* Scriptaculous 1.8 Slider patch */
if (typeof (Control) != 'undefined' && typeof (Control.Slider) != 'undefined') {
    Control.Slider.prototype.drawOriginal = Control.Slider.prototype.draw;
    Control.Slider.prototype.draw = function (event) {
        if (typeof (this.offsetX) != 'undefined' && typeof (this.offsetY) != 'undefined') {
            this.drawOriginal(event);
        } else {
            this.endDrag(event);
        }
    }
}
/* End: Scriptaculous 1.8 Slider patch */

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

Dynamicweb.Controls.OMC.Slider = function () {
    /// <summary>Represents a slider.</summary>

    this._selectedValue = '';
    this._minValue = 0;
    this._maxValue = 0;
    this._slider = null;
    this._fillSelection = true;
    this._width = 100;
    this._valuePosition = 0;
    this._valuePositionChanged = false;
    this._handleMouseOut = false;
}

/* Inheritance */
Dynamicweb.Controls.OMC.Slider.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.OMC.SliderImplementationFactory = function () {
    /// <summary>Represents a slider implementation factory.</summary>
}

Dynamicweb.Controls.OMC.SliderImplementationFactory.createSlider = function (params) {
    /// <summary>Returns a new slider.</summary>
    /// <param name="params">Slider parameters.</param>

    params = params || {};

    return new Control.Slider(params.handle, params.track, params);
}

Dynamicweb.Controls.OMC.Slider.prototype.add_valueChanged = function (handler) {
    /// <summary>Registers new handler which is executed when the value changes.</summary>
    /// <param name="handler">Handler to register.</param>

    this.addEventHandler('valueChanged', handler);
}

Dynamicweb.Controls.OMC.Slider.prototype.add_valueChanging = function (handler) {
    /// <summary>Registers new handler which is executed while the user moves the slier and so the value continuously changes.</summary>
    /// <param name="handler">Handler to register.</param>

    his.addEventHandler('valueChanging', handler);
}

Dynamicweb.Controls.OMC.Slider.prototype.get_fillSelection = function () {
    /// <summary>Gets value indicating whether to fill the part of the slider that represents a selected value with different color.</summary>

    return this._fillSelection;
}

Dynamicweb.Controls.OMC.Slider.prototype.set_fillSelection = function (value) {
    /// <summary>Sets value indicating whether to fill the part of the slider that represents a selected value with different color.</summary>
    /// <param name="value">Value indicating whether to fill the part of the slider that represents a selected value with different color.</param>

    this._fillSelection = !!value;
}

Dynamicweb.Controls.OMC.Slider.prototype.get_valuePosition = function () {
    /// <summary>Gets the position of the slider value.</summary>

    return this._valuePosition;
}

Dynamicweb.Controls.OMC.Slider.prototype.set_valuePosition = function (value) {
    /// <summary>Sets the position of the slider value.</summary>
    /// <param name="value">The position of the slider value.</param>

    this._valuePosition = parseInt(value) || 0;
    this._valuePositionChanged = true;

    this._moveValueContainer();

    this._valuePositionChanged = false;
}

Dynamicweb.Controls.OMC.Slider.prototype.get_width = function () {
    /// <summary>Gets the width of the slider (in pixels).</summary>

    return this._width;
}

Dynamicweb.Controls.OMC.Slider.prototype.set_width = function (value) {
    /// <summary>Sets the width of the slider (in pixels).</summary>
    /// <param name="value">The width of the slider (in pixels).</param>

    this._width = parseInt(value);

    if (typeof (this.get_state().axis) != 'undefined') {
        this.get_state().axis.style.width = this._width + 'px';
        this.get_container().style.width = this._width + 'px';
    }
}

Dynamicweb.Controls.OMC.Slider.prototype.get_selectedValue = function () {
    /// <summary>Gets the currently selected value.</summary>

    var ret = this.getInteger(this.get_state().value.value, 0);

    if (ret > this.get_maxValue()) {
        ret = this.get_maxValue();
    } else if (ret < this.get_minValue()) {
        ret = this.get_minValue();
    }

    return ret;
}

Dynamicweb.Controls.OMC.Slider.prototype.set_selectedValue = function (value) {
    /// <summary>Sets the currently selected value.</summary>
    /// <param name="value">Currently selected value.</param>

    var val = 0;

    val = this._updateSelectedValueField(value);

    if (this._slider) {
        /* "onValueChanged" will be fired by the slider */
        this._slider.setValue(val);
    } else {
        this.onValueChanged({ value: val });
    }
}

Dynamicweb.Controls.OMC.Slider.prototype.get_minValue = function () {
    /// <summary>Gets the minimum allowed value.</summary>

    return this._minValue;
}

Dynamicweb.Controls.OMC.Slider.prototype.set_minValue = function (value) {
    /// <summary>Sets the minimum allowed value.</summary>
    /// <param name="value">The minimum allowed value.</param>

    this._minValue = this.getInteger(value, 0);
}

Dynamicweb.Controls.OMC.Slider.prototype.get_maxValue = function () {
    /// <summary>Gets the maximum allowed value.</summary>

    return this._maxValue;
}

Dynamicweb.Controls.OMC.Slider.prototype.set_maxValue = function (value) {
    /// <summary>Sets the maximum allowed value.</summary>
    /// <param name="value">The maximum allowed value.</param>

    this._maxValue = this.getInteger(value, 0);
}


Dynamicweb.Controls.OMC.Slider.prototype.getInteger = function (value, defaultValue) {
    /// <summary>Parses the  number from the given value.</summary>
    /// <param name="value">Value to parse number from.</param>
    /// <param name="defaultValue">Default value used on a fallback.</param>

    var ret = defaultValue;

    if (typeof (value) != 'undefined') {
        ret = parseInt(value);

        if (isNaN(ret) || ret == null) {
            ret = defaultValue;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.Slider.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;

    this._initializeState();

    this.add_propertyChanged(function (sender, args) {
        if (args.name == 'isEnabled') {
            if (self._slider) {
                if (args.value) {
                    self._slider.setEnabled();
                } else {
                    self._slider.setDisabled();
                }
            }

            if (self.get_container()) {
                if (args.value) {
                    self.get_container().removeClassName('dw-slider-disabled');
                } else {
                    self.get_container().addClassName('dw-slider-disabled');
                }
            }
        }
    });

    this._slider = Dynamicweb.Controls.OMC.SliderImplementationFactory.createSlider({
        handle: this.get_state().handle,
        track: this.get_state().axis,
        range: $R(this.get_minValue(), this.get_maxValue()),
        sliderValue: this.get_selectedValue(),
        disabled: !this.get_isEnabled(),
        onSlide: function (value) { self.onValueChanging({ value: parseInt(value) }); },
        onChange: function (value) { self.onValueChanged({ value: parseInt(value) }); }
    });

    this._slider.handleLength = this.get_state().handleWidth;

    Event.observe(this.get_state().handle, 'click', function (e) { Event.stop(e); });
    Event.observe(this.get_state().axis, 'click', function (e) {
        var offset = 0;
        var valueUncut = 0;
        var actualValue = 0;
        var elm = Event.element(e);

        offset = (typeof (e.layerX) != 'undefined' ? e.layerX : e.offsetX);
        valueUncut = self.get_maxValue() * offset / self.get_width();

        if (valueUncut > (Math.floor(valueUncut) + 0.5)) {
            actualValue = Math.floor(valueUncut) + 1;
        } else {
            actualValue = Math.floor(valueUncut);
        }

        if (self.get_isEnabled()) {
            self.set_selectedValue(actualValue);
        }
    });

    Event.observe(this.get_state().handle, 'mouseover', function (e) {
        if (self.get_valuePosition() == 1 || self.get_valuePosition() == 3) {
            self._handleMouseOut = false;

            self.get_state().valueContainer.show();
            self._moveValueContainer();
        }
    });

    Event.observe(this.get_state().handle, 'mouseout', function (e) {
        if (self.get_valuePosition() == 1 || self.get_valuePosition() == 3) {
            self._handleMouseOut = true;

            if (!self._slider || !self._slider.dragging) {
                self.get_state().valueContainer.hide();
            }
        }
    });

    if (this.get_fillSelection()) {
        this._fill();
    }

    /* To trigger the disabled CSS class */
    this.set_isEnabled(this.get_isEnabled());

    this._moveValueContainer();
    this._updateValueContainer();

    this.get_state().handle.style.position = 'absolute';
}

Dynamicweb.Controls.OMC.Slider.prototype.onValueChanged = function (e) {
    /// <summary>Fires "valueChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    if (this.get_fillSelection()) {
        this._fill();
    }

    this._updateSelectedValueField(e.value);
    this._updateValueContainer();

    if (typeof (this.get_state().valueContainer) != 'undefined' && this._slider) {
        if (!this._slider.dragging && this._handleMouseOut) {
            this.get_state().valueContainer.hide();
        }
    }

    this.raiseEvent('valueChanged', e);
}

Dynamicweb.Controls.OMC.Slider.prototype.onValueChanging = function (e) {
    /// <summary>Fires "valueChanging" event.</summary>
    /// <param name="e">Event arguments.</param>

    if (this.get_fillSelection()) {
        this._fill();
    }

    this._updateSelectedValueField(e.value);
    this._updateValueContainer();

    if (this.get_valuePosition() == 1 || this.get_valuePosition() == 3) {
        this._moveValueContainer();
    }

    this.raiseEvent('valueChanging', e);
}

Dynamicweb.Controls.OMC.Slider.prototype._fill = function () {
    /// <summary>Fills the selected area with different color.</summary>
    /// <private />

    if (typeof (this.get_state().fill) != 'undefined') {
        this.get_state().fill.style.width = this.get_state().handle.style.left;
    }
}

Dynamicweb.Controls.OMC.Slider.prototype._initializeState = function () {
    /// <summary>Initializes object state.</summary>
    /// <private />

    var c = null;
    
    if (this.get_container()) {
        this.get_state().value = $(this.get_container().select('input.dw-slider-value')[0]);
        this.get_state().axis = $(this.get_container().select('.dw-slider-axis')[0]);
        this.get_state().handle = $(this.get_container().select('.dw-slider-handle')[0]);
        this.get_state().fill = $(this.get_container().select('.dw-slider-fill')[0]);
        this.get_state().columnLeft = $(this.get_container().select('.dw-slider-column-left')[0]);
        this.get_state().columnRight = $(this.get_container().select('.dw-slider-column-right')[0]);
        this.get_state().handleWidth = this.get_state().handle.getWidth() || 8;
        this.get_state().handleHeight = this.get_state().handle.getHeight() || 14;
        this.get_state().table = $(this.get_container().select('table')[0]);

        c = document.createElement('div');
        c.className = 'dw-slider-highlight-value';
        c.style.display = 'none';

        this.get_state().axis.appendChild(c);

        this.get_state().valueContainer = c;
    }
}

Dynamicweb.Controls.OMC.Slider.prototype._moveValueContainer = function () {
    /// <summary>Moves value container to the corresponding slider cell.</summary>
    /// <private />

    var offset = null;
    var scroll = null;
    var handleHeight = 0;
    var handleLeft = null;

    if (typeof (this.get_state().handleHeight) != 'undefined') {
        handleHeight = this.get_state().handleHeight;
        handleLeft = parseInt(this.get_state().handle.style.left.replace('px', ''));

        if (this.get_valuePosition() != 0) {
            if (this.get_valuePosition() == 1 || this.get_valuePosition() == 3) { /* Top or Bottom */
                this.get_state().valueContainer.addClassName('dw-slider-highlight-value-float');

                if (this._valuePositionChanged) {
                    this.get_state().valueContainer.hide();
                }

                this.get_container().appendChild(this.get_state().valueContainer);

                offset = this.get_container().cumulativeOffset();
                scroll = this.get_container().cumulativeScrollOffset();

                this.get_state().valueContainer.style.left = (offset.left + handleLeft - 12) + 'px';

                if (this.get_valuePosition() == 1) {
                    this.get_state().valueContainer.style.top = (offset.top - scroll.top - 18) + 'px';
                } else {
                    this.get_state().valueContainer.style.top = ((offset.top - scroll.top + handleHeight + 4) + 'px');
                }
            } else {
                this.get_state().valueContainer.removeClassName('dw-slider-highlight-value-float');
                this.get_state().valueContainer.show();

                if (this.get_valuePosition() == 2) { /* Left */
                    this.get_state().columnLeft.show();
                    this.get_state().columnRight.hide();

                    this.get_state().columnLeft.appendChild(this.get_state().valueContainer);
                } else if (this.get_valuePosition() == 4) { /* Right */
                    this.get_state().columnLeft.hide();
                    this.get_state().columnRight.show();

                    this.get_state().columnRight.appendChild(this.get_state().valueContainer);
                }
            }
        } else {
            this.get_state().columnLeft.hide();
            this.get_state().columnRight.hide();
            this.get_state().valueContainer.hide();
        }
    }
}

Dynamicweb.Controls.OMC.Slider.prototype._updateSelectedValueField = function (value) {
    /// <summary>Updates selected value field.</summary>
    /// <param name="value">New value.</param>
    /// <private />

    var ret = 0;
    var val = this.getInteger(value, 0);

    if (val > this.get_maxValue()) {
        val = this.get_maxValue();
    } else if (val < this.get_minValue()) {
        val = this.get_minValue();
    }

    ret = val;

    if (typeof (this.get_state().value) != 'undefined') {
        this.get_state().value.value = val.toString();
    }

    return ret;
}

Dynamicweb.Controls.OMC.Slider.prototype._updateValueContainer = function () {
    /// <summary>Updates the position of the value container as well as its text.</summary>
    /// <private />

    var value = 0;
    var position = 0;
    var offset = null;
    var handleLeft = 0;

    if (typeof (this.get_state().handle) != 'undefined') {
        value = this.get_selectedValue();
        position = this.get_valuePosition();
        offset = this.get_container().cumulativeOffset();
        handleLeft = parseInt(this.get_state().handle.style.left.replace('px', ''));

        this.get_state().valueContainer.innerHTML = value;

        if (position == 1 || position == 3) {
            this.get_state().valueContainer.style.left = (offset.left + handleLeft - 12) + 'px';
        }
    }
}