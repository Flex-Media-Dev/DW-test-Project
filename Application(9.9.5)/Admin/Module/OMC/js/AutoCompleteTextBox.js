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

Dynamicweb.Controls.OMC.AutoCompleteDataProvider = function () {
    /// <summary>Represents an interface that all custom data providers must implement in order to override auto-completion process.</summary>

    this._textBox = null;
}

Dynamicweb.Controls.OMC.AutoCompleteDataProvider.prototype.get_textBox = function () {
    /// <summary>Gets the textox which this data provider is bound to.</summary>

    return this._textBox;
}

Dynamicweb.Controls.OMC.AutoCompleteDataProvider.prototype.getAutoCompletionData = function (value, onComplete) {
    /// <summary>Queries auto-completion data.</summary>
    /// <param name="value">Current value.</param>
    /// <param name="onComplete">A callback that is called when auto-completion data is retrieved.</param>

    return (onComplete || function () { })([]);
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox = function () {
    /// <summary>Provides auto-complete textbox.</summary>

    this._start = 0;
    this._end = null;
    this._delay = 200;
    this._isEnabled = true;
    this._timeoutID = null;
    this._dataSource = false;
    this._cacheResults = true;
    this._isInsideAbsolute = null;
    this._dataSourceSpecifier = null;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBoxPositionArgs = function () {
    /// <summary>Provides information about auto-completion container position.</summary>

    this._left = 0;
    this._top = 0;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBoxPositionArgs.prototype.get_left = function () {
    /// <summary>Gets the horizontal offset of the auto-completion container (in pixels) relative to the document.</summary>

    return this._left;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBoxPositionArgs.prototype.set_left = function (value) {
    /// <summary>Sets the horizontal offset of the auto-completion container (in pixels) relative to the document.</summary>
    /// <param name="value">The horizontal offset of the auto-completion container (in pixels) relative to the document.</param>

    this._left = value || 0;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBoxPositionArgs.prototype.get_top = function () {
    /// <summary>Gets the vertical offset of the auto-completion container (in pixels) relative to the document.</summary>

    return this._top;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBoxPositionArgs.prototype.set_top = function (value) {
    /// <summary>Sets the vertical offset of the auto-completion container (in pixels) relative to the document.</summary>
    /// <param name="value">The vertical offset of the auto-completion container (in pixels) relative to the document.</param>

    this._top = value || 0;
}

/* Inheritance */
Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.add_positionChanged = function (handler) {
    /// <summary>Registers new handler which is executed when the auto-completion container gets positioned.</summary>
    /// <param name="handler">Handler to register.</param>

    this.addEventHandler('positionChanged', handler);
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.add_textChanged = function (handler) {
    /// <summary>Registers new handler which is executed when the text within the textbox is changed.</summary>
    /// <param name="handler">Handler to register.</param>

    this.addEventHandler('textChanged', handler);
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.add_keyPressed = function (handler) {
    /// <summary>Registers new handler which is executed when the key is pressed.</summary>
    /// <param name="handler">Handler to register.</param>

    this.addEventHandler('keyPressed', handler);
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.get_dataSource = function () {
    /// <summary>Gets the custom auto-completion data source.</summary>

    if (!this._dataSource) {
        if (this._dataSourceSpecifier) {
            if (typeof (this._dataSourceSpecifier) == 'string') {
                this._dataSource = eval('new ' + this._dataSourceSpecifier + '();');
            } else if (typeof (this._dataSourceSpecifier) == 'function') {
                this._dataSource = this._dataSourceSpecifier(this, {});
            } else {
                this._dataSource = this._dataSourceSpecifier;
            }
        }

        if (this._dataSource) {
            if (typeof (this._dataSource.getAutoCompletionData) != 'function') {
                this._dataSource = null;
            } else {
                this._dataSource._textBox = this;
            }
        }
    }

    return this._dataSource;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.set_dataSource = function (value) {
    /// <summary>Sets the custom auto-completion data source.</summary>
    /// <param name="value">The custom auto-completion data source.</param>

    this._dataSourceSpecifier = value;
    this._dataSource = null;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.get_start = function () {
    /// <summary>Gets the number of characters the user must type first before autocomplete triggers.</summary>

    return this._start;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.set_start = function (value) {
    /// <summary>Sets the number of characters the user must type first before autocomplete triggers.</summary>
    /// <param name="value">The number of characters the user must type first before autocomplete triggers.</param>

    this._start = parseInt(value);

    if (isNaN(this._start) || this._start <= 1) {
        this._start = 1;
    }
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.get_end = function () {
    /// <summary>Gets the number of characters after which the autocomplete is disabled.</summary>

    return this._end;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.set_end = function (value) {
    /// <summary>Sets the number of characters after which the autocomplete is disabled.</summary>
    /// <param name="value">The number of characters after which the autocomplete is disabled.</param>

    if (value == null) {
        this._end = null;
    } else {
        this._end = parseInt(value);

        if (isNaN(this._end) || this._end <= 1) {
            this._end = 1;
        }
    }
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.get_delay = function () {
    /// <summary>Gets the delay (in milliseconds) to wait before retrieving auto-completion results.</summary>

    return this._delay;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.set_delay = function (value) {
    /// <summary>Sets the delay (in milliseconds) to wait before retrieving auto-completion results.</summary>
    /// <param name="value">The delay (in milliseconds) to wait before retrieving auto-completion results.</param>

    this._delay = parseInt(value);

    if (isNaN(this._delay) || this._delay < 0) {
        this._delay = 0;
    }
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.get_cacheResults = function () {
    /// <summary>Gets value indicating whether to cache auto-completion results.</summary>

    return this._cacheResults;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.set_cacheResults = function (value) {
    /// <summary>Sets value indicating whether to cache auto-completion results.</summary>
    /// <param name="value">Value indicating whether to cache auto-completion results.</param>

    this._cacheResults = !!value;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.get_value = function () {
    /// <summary>Gets the textbox value.</summary>

    return this.get_state().text.value;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.set_value = function (value) {
    /// <summary>Sets the textbox value.</summary>
    /// <param name="value">Textbox value.</param>

    this.get_state().text.value = value || '';
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.get_isEnabled = function () {
    /// <summary>Gets value indicating whether textbox is enabled.</summary>

    var ret = this._isEnabled;

    if (this.get_state().text) {
        ret = !this.get_state().text.disabled;
    }

    return ret;
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.set_isEnabled = function (value) {
    /// <summary>Sets value indicating whether textbox is enabled.</summary>
    /// <param name="value">Value indicating whether textbox is enabled.</param>

    if (this.get_state().text) {
        this.get_state().text.disabled = !value;
    } else {
        this._isEnabled = !!value;
    }
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.beginComplete = function (ignoreDelay) {
    /// <summary>Begins auto-completion.</summary>

    var value = '';
    var self = this;
    var queryResults = true;

    if (typeof (ignoreDelay) != 'undefined' && ignoreDelay != null && !!ignoreDelay) {
        value = this.get_state().text.value;

        if (value.length >= this.get_start() && (this.get_end() == null || value.length < this.get_end())) {
            if (this.get_cacheResults()) {
                if (this.get_state().resultsCache[value] != null) {
                    queryResults = false;
                    this.showAutoCompletionData(this.get_state().resultsCache[value]);
                }
            }

            if (queryResults) {
                this.getAutoCompletionData(value, function (data) {
                    if (self.get_cacheResults()) {
                        self.get_state().resultsCache[value] = data;
                    }

                    self.showAutoCompletionData(data);
                });
            }
        } else {
            $(self.get_state().data).hide();
        }
    } else {
        if (this._timeoutID) {
            clearTimeout(this._timeoutID);
            this._timeoutID = null;
        }

        this._timeoutID = setTimeout(function () {
            self.beginComplete(true);
        }, this.get_delay());
    }
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.getAutoCompletionData = function (value, onComplete) {
    /// <summary>Queries auto-completion data.</summary>
    /// <param name="value">Current value.</param>
    /// <param name="onComplete">A callback that is called when auto-completion data is retrieved.</param>

    var self = this;

    onComplete = onComplete || function () { }

    if (this.get_dataSource()) {
        this.get_dataSource().getAutoCompletionData(value, onComplete);
    } else {
        Dynamicweb.Ajax.DataLoader.load({
            target: this.get_associatedControlID(),
            argument: value,
            onComplete: function (response) { onComplete(response); },
            onError: function () { onComplete([]); }
        });
    }
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.showAutoCompletionData = function (data) {
    /// <summary>Shows auto-completion data.</summary>
    /// <param name="data">Auto-completion data.</param>

    var list = null;
    var item = null;
    var link = null;
    var self = this;
    var container = $(this.get_state().data);

    container.innerHTML = '';

    if (data && data.length) {
        list = document.createElement('ul');

        for (var i = 0; i < data.length; i++) {
            item = document.createElement('li');
            link = document.createElement('a');

            link.innerHTML = data[i];
            link.href = 'javascript:void(0);';

            Event.observe(link, 'mousedown', function (e) {
                self.set_value(Event.element(e).innerHTML);
            });

            item.appendChild(link);
            list.appendChild(item);
        }

        container.appendChild(list);

        container.show();
        this.updatePosition(container);
    } else {
        container.hide();
    }
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.updatePosition = function () {
    /// <summary>Updates the position of the auto-completion container.</summary>

    var args = null;
    var t = $(this.get_state().text);
    var scroll = { top: 0, left: 0 };
    var offset = { top: 0, left: 0 };
    var position = { left: 0, top: 0 };
    var container = $(this.get_state().data);
    var dimensions = { width: 0, height: 0 };
    var positionedOffset = { top: 0, left: 0 };

    offset = t.viewportOffset();
    dimensions = t.getDimensions();
    scroll = $(document.body).cumulativeScrollOffset();

    position.left = offset.left;
    position.top = offset.top + dimensions.height + 1;

    if (!this._checkInsideAbsolute()) {
        position.left += scroll.left;
        position.top += scroll.top
    } else {
        positionedOffset = t.positionedOffset();

        position.left = positionedOffset.left;
        position.top = positionedOffset.top + dimensions.height + 1;
    }

    args = new Dynamicweb.Controls.OMC.AutoCompleteTextBoxPositionArgs();

    args.set_left(position.left);
    args.set_top(position.top);

    this.onPositionChanged(args);

    container.setStyle({
        left: args.get_left() + 'px',
        top: args.get_top() + 'px'
    });

    if (container.getWidth() < dimensions.width) {
        container.setStyle({
            width: (dimensions.width - 2) + 'px'
        });
    }
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.onPositionChanged = function (e) {
    /// <summary>Fires "positionChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.raiseEvent('positionChanged', e);
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.onTextChanged = function (e) {
    /// <summary>Fires "textChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.raiseEvent('textChanged', e);
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.onKeyPressed = function (e) {
    /// <summary>Fires "keyPressed" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.raiseEvent('keyPressed', e);
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;
    var beginCompleteWrapper = function (e) { self.beginComplete(); }

    this.get_state().text = $(this.get_container()).select('input[type="text"]')[0];
    this.get_state().data = $(this.get_container()).select('div.ac-textbox-data')[0];
    this.get_state().resultsCache = {};

    Event.observe(this.get_state().text, 'keyup', beginCompleteWrapper);
    Event.observe(this.get_state().text, 'keydown', function (e) {
        var code = e.keyCode;

        if (code == 0 && typeof (e.charCode) != 'undefined' && e.charCode > 0) {
            code = e.charCode;
        }

        self.onKeyPressed({ keyCode: code });
    });

    Event.observe(this.get_state().text, 'paste', beginCompleteWrapper);
    Event.observe(this.get_state().text, 'blur', function () { self.onTextChanged(self, {}); });

    Event.observe(document.body, 'click', function () { $(self.get_state().data).hide(); });
}

Dynamicweb.Controls.OMC.AutoCompleteTextBox.prototype._checkInsideAbsolute = function () {
    /// <summary>Checks whether the textbox is inside absolutely positioned element.</summary>
    /// <private />

    var p = null;
    var ret = false;
    var parent = function (e) {
        return e.parentNode || e.parentElement;
    }

    if (this._isInsideAbsolute != null) {
        ret = this._isInsideAbsolute;
    } else {
        p = this.get_container();

        while ((p = parent(p)) != null) {
            if (p.style && ((p.style.position && p.style.position == 'absolute') || (p.style.zIndex > 0 && (parseInt(p.style.top) > 0 || parseInt(p.style.left) > 0)))) {
                ret = true;
                break;
            }
        }

        this._isInsideAbsolute = ret;
    }

    return ret;
}

