/* Namespace registration */

if (typeof (Dynamicweb) == 'undefined') {
    Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Extensibility) == 'undefined') {
    Dynamicweb.Extensibility = new Object();
}

if (typeof (Dynamicweb.Extensibility.Editors) == 'undefined') {
    Dynamicweb.Extensibility.Editors = new Object();
}

/* End: Namespace registration */

Dynamicweb.Extensibility.Editors.MultipleValuesEditor = function (params) {
    /// <summary>Renders the list of items with an ability for adding/removing items.</summary>
    /// <param name="params">Object representing constructor parameters.</param>

    if (!params) {
        params = {};
    }

    this._containerID = params.container;
    this._terminology = params.terminology || {};

    this._cache = {};
    this._initialized = false;
    this._itemClicking = [];
    this._itemAdding = [];
    this._itemRemoving = [];
    this._isEnabled = true;

    if (typeof (params.autoInitialize) == 'undefined' || !!params.autoInitialize) {
        this.initialize();
    }
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.get_isEnabled = function () {
    /// <summary>Gets value indicating whether control is enabled.</summary>

    return this._isEnabled;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.set_isEnabled = function (value) {
    /// <summary>Sets value indicating whether control is enabled.</summary>
    /// <param name="value">Value indicating whether control is enabled.</param>

    this._isEnabled = !!value;

    this._cache.textbox.disabled = !this._isEnabled;

    if (this._isEnabled) {
        this._cache.list.up().removeClassName('dwe-disabled');
        this._cache.textboxButton.removeClassName('dwe-disabled');
    } else {
        this._cache.list.up().addClassName('dwe-disabled');
        this._cache.textboxButton.addClassName('dwe-disabled');
    }
}


Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.get_terminology = function () {
    /// <summary>Gets the object containing localized strings that are used for rendering.</summary>

    return this._terminology;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.get_values = function () {
    /// <summary>Gets the list of currently selected values.</summary>

    return this._get();
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.set_values = function (value) {
    /// <summary>Sets the list of currently selected values.</summary>
    /// <param name="value">The list of currently selected values.</param>
    
    this._set(value);

    this.refresh();
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.add_itemClicking = function (callback) {
    /// <summary>Registers new callback which is executed when an item is selected.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }

    this._itemClicking[this._itemClicking.length] = callback;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.add_itemAdding = function (callback) {
    /// <summary>Registers new callback which is executed when the new item is about to be added to the list.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }

    this._itemAdding[this._itemAdding.length] = callback;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.add_itemRemoving = function (callback) {
    /// <summary>Registers new callback which is executed when the new item is about to be added to the list.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }

    this._itemRemoving[this._itemRemoving.length] = callback;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.add_ready = function (callback) {
    /// <summary>Registers new callback which is executed when the page is loaded.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }
    Event.observe(document, 'dom:loaded', function () {
        callback(this, {});
    });
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.initialize = function () {
    /// <summary>Initializes the editor.</summary>

    var self = this;

    if (!this._initialized) {
        this._cache = {};

        this._cache.container = $(this._containerID);
        this._cache.list = $(this._cache.container.select('ul.box-control-box')[0]);
        this._cache.values = $(this._cache.container.select('input[type="hidden"]')[0]);
        this._cache.textbox = $(this._cache.container.select('.dwe-values-add input')[0]);
        this._cache.textboxButton = $(this._cache.container.select('.dwe-values-add span')[0]);

        Event.observe(this._cache.textbox, 'keydown', function (e) {
            if (e.keyCode == 13) {
                self.add(self._cache.textbox.value);
                self._cache.textbox.value = '';

                Event.stop(e);
            }
        });

        Event.observe(this._cache.textboxButton, 'click', function (e) {
            if (self.get_isEnabled()) {
                self.add(self._cache.textbox.value);
                self._cache.textbox.value = '';

                try {
                    self._cache.textbox.focus();
                } catch (ex) { }
            }
        });

        this._cache.textboxButton.writeAttribute('title', this.get_terminology().addItem || '');

        this.refresh();

        this._initialized = true;
    }
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.add = function (value) {
    /// <summary>Adds new value.</summary>
    /// <param name="value">Value to add.</param>

    if (value) {
        this._add(value);
        this._render(value);
    }
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.remove = function (index) {
    /// <summary>Removes the given value.</summary>
    /// <param name="index">Zero-based index of the value to remove.</param>

    var args = null;
    var span = null;
    var allowRemove = true;
    var values = this._get();
    var items = this._cache.list.select('li');

    if (index >= 0 && index < items.length) {
        span = $(items[index]).select('span');
        if (span != null && span.length > 0) {
            span = $(span[0]);

            if (values != null && index < values.length) {
                args = new Dynamicweb.Extensibility.Editors.MultipleValuesEditor.ItemEventArgs(values[index], span);
                allowRemove = this._notify('itemRemoving', args);
            }
        }

        if (allowRemove) {
            $(items[index]).up().removeChild(items[index]);
            this._remove(index);
        }
    }
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.clear = function () {
    /// <summary>Clears the list as well as the hidden field that contains currently selected values.</summary>

    this.clearList();
    this._clear();
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.clearList = function () {
    /// <summary>Clears the list only.</summary>

    this._cache.list.update('');
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype.refresh = function () {
    /// <summary>Refreshes the list.</summary>

    this._populate();
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._get = function () {
    /// <summary>Gets an array of values within the "values" field.</summary>
    /// <private />

    return this._cache.values.value.length > 0 ? this._cache.values.value.split(',') : [];
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._set = function (data) {
    /// <summary>Overwrites the "values" field value.</summary>
    /// <param name="data">Either a single value or an array of values that must be assigned.</param>
    /// <private />

    var val = '';

    if (typeof (data) != 'undefined') {
        if (typeof (data) == 'string') {
            val = data;
        } else if (data.length != null) {
            for (var i = 0; i < data.length; i++) {
                val += data[i];
                if (i < (data.length - 1)) {
                    val += ',';
                }
            }
        }

        this._cache.values.value = val;
    }
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._clear = function () {
    /// <summary>Clears the "values" field.</summary>
    /// <private />

    this._cache.values.value = '';
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._add = function (data) {
    /// <summary>Adds given elements to the "values" field.</summary>
    /// <param name="data">Either a single value or an array of values that must be added.</param>
    /// <private />

    var values = this._get();
    
    if (typeof (data) != 'undefined') {
        if (typeof (data) == 'string') {
            values[values.length] = data;
        } else if (data.length) {
            for (var i = 0; i < data.length; i++) {
                if (typeof (data[i]) != 'undefined' && data[i] != null) {
                    values[values.length] = data[i];
                }
            }
        }

        this._set(values);
    }
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._remove = function (data) {
    /// <summary>Removes given elements from the "values" field.</summary>
    /// <param name="data">Either a single index or an array of indexes of values that must be removed.</param>
    /// <private />

    var index = 0;
    var newValues = [];
    var values = this._get();
    
    if (typeof (data) != 'undefined') {
        if (typeof (data) == 'number') {
            index = parseInt(data);
            if (!isNaN(index) && index >= 0 && index < values.length) {
                for (var i = 0; i < values.length; i++) {
                    if (i != index) {
                        newValues[newValues.length] = values[i];
                    }
                }
            }
        } else if (data.length) {
            for (var i = 0; i < data.length; i++) {
                index = parseInt(data[i]);
                if (!isNaN(index) && index >= 0 && index < values.length) {
                    for (var j = 0; j < values.length; j++) {
                        if (j != index) {
                            newValues[newValues.length] = values[j];
                        }
                    }
                }
            }
        }

        this._set(newValues);
    }
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._populate = function () {
    /// <summary>Populates "values" field on a list.</summary>
    /// <private />

    var offset = 0;
    var toBeRemoved = [];
    var values = this._get();

    this.clearList();

    if (values && values.length) {
        for (var i = 0; i < values.length; i++) {
            if (!this._render(values[i], i, false)) {
                toBeRemoved[toBeRemoved.length] = i;
            }
        }

        if (toBeRemoved.length > 0) {
            for (var i = 0; i < toBeRemoved.length; i++) {
                this.remove(toBeRemoved[i] - offset);
                offset += 1;
            }
        }
    }
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._encode = function (value) {
    /// <summary>Performs a simple HTML encode of the given string.</summary>
    /// <param name="value">Value to process.</param>
    /// <returns>HTML-encoded string.</returns>
    /// <private />

    var ret = '';

    if (value && value.length) {
        ret = value;
        ret = ret.replace(/</g, '&lt;');
        ret = ret.replace(/>/g, '&gt;');
    }

    return ret;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._decode = function (value) {
    /// <summary>Performs a simple HTML decode of the given string.</summary>
    /// <param name="value">Value to process.</param>
    /// <returns>HTML-decoded string.</returns>
    /// <private />

    var ret = '';

    if (value && value.length) {
        ret = value;
        ret = ret.replace(/&lt;/gi, '<');
        ret = ret.replace(/&gt;/gi, '>');
    }

    return ret;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._render = function (value, index, tryRemove) {
    /// <summary>Renders the given value inside the list.</summary>
    /// <param name="value">Value to render.</param>
    /// <param name="index">Zero-based index of the value.</param>
    /// <param name="tryRemove">Value indicating whether to automatically remove item from the list if this behavior is denoted by notification.</param>
    /// <returns>Value indicating whether item has been successfully rendered.</returns>
    /// <private />

    var ret = true;
    var row = null;
    var link = null;
    var self = this;
    var span = null;
    var args = null;
    var values = null;

    if (value) {
        if (typeof (index) == 'undefined' || index == null || index < 0) {
            index = -1;
            values = this._get();

            if (values && values.length) {
                for (var i = 0; i < values.length; i++) {
                    if ((values[i] + '').toLowerCase() == value.toLowerCase()) {
                        index = i;
                        break;
                    }
                }
            }
        }

        row = new Element('li');
        link = new Element('a');
        icon = new Element('i');
        span = new Element('span');
        span.addClassName('text');

        Event.observe(row, 'click', function (e) {
            var row = $(Event.element(e));
            var span = row.down('span');

            if (span) {
                var args = new Dynamicweb.Extensibility.Editors.MultipleValuesEditor.ItemEventArgs(span.innerHTML, span);
                this._notify('itemClicking', args);
            }
        }.bind(this));

        Event.observe(link, 'click', function (e) {
            var row = null;
            var items = null;

            if (self.get_isEnabled()) {
                row = $(Event.element(e)).up('li');
                items = self._cache.list.select('li');

                for (var i = 0; i < items.length; i++) {
                    if (items[i] == row) {
                        self.remove(i);
                        break;
                    }
                }
            }
        });

        link.writeAttribute('title', this.get_terminology().removeItem || '');

        var truncatedValue = value;
        if (truncatedValue.length > 36) {
            truncatedValue = truncatedValue.substr(0, 36) + '...';
        }

        span.appendChild(document.createTextNode(truncatedValue));
        icon.addClassName('fa fa-remove color-danger');

        row.appendChild(span);        
        link.appendChild(icon);
        row.appendChild(link);

        this._cache.list.appendChild(row);

        args = new Dynamicweb.Extensibility.Editors.MultipleValuesEditor.ItemEventArgs(value, span);
        if (!this._notify('itemAdding', args)) {
            ret = false;

            if (typeof (tryRemove) == 'undefined' || tryRemove == null || !!tryRemove) {
                this.remove(index);
            }
        }
    }

    return ret;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.prototype._notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>
    /// <returns>Value indicating whether it's allowed to proceed with execution.</returns>
    /// <private />

    var ret = true;
    var callbacks = [];

    if (eventName) {
        if (!args) {
            args = {};
        }

        if (eventName.toLowerCase() == 'itemadding') {
            callbacks = this._itemAdding;
        } else if (eventName.toLowerCase() == 'itemremoving') {
            callbacks = this._itemRemoving;
        } else if (eventName.toLowerCase() == 'itemclicking') {
            callbacks = this._itemClicking;
        }

        for (var i = 0; i < callbacks.length; i++) {
            try {
                if (typeof (callbacks[i]) == 'function') {
                    callbacks[i](this, args);
                    if (typeof (args.get_cancel) == 'function') {
                        if (!!args.get_cancel()) {
                            ret = false;
                            break;
                        }
                    }
                }
            } catch (ex) { }
        }
    }

    return ret;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.ItemEventArgs = function (item, row) {
    /// <summary>Provides information passed during item being added/removed.</summary>
    /// <param name="item">Item being added/removed.</param>
    /// <param name="row">A reference to DOM element containing the given item.</param>

    this._cancel = false;
    this._item = item;
    this._row = row;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.ItemEventArgs.prototype.get_cancel = function () {
    /// <summary>Gets value indicating whether to stop further execution and cancel the default behavior.</summary>

    return this._cancel;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.ItemEventArgs.prototype.set_cancel = function (value) {
    /// <summary>Sets value indicating whether to stop further execution and cancel the default behavior.</summary>
    /// <param name="value">Value indicating whether to stop further execution and cancel the default behavior.</param>

    this._cancel = !!value;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.ItemEventArgs.prototype.get_item = function () {
    /// <summary>Gets the item that is being added/removed.</summary>

    return this._item;
}

Dynamicweb.Extensibility.Editors.MultipleValuesEditor.ItemEventArgs.prototype.get_row = function () {
    /// <summary>Gets the reference to the DOM element representing a row containing the given item.</summary>

    return this._row;
}
