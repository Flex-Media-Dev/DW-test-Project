/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

/* ++++++ End: Registering namespace ++++++ */


/* ++++++ CustomSelector ++++++ */

Dynamicweb.Controls.CustomSelector = {};

/* ++++++ Underlying сontrol ++++++ */

Dynamicweb.Controls.CustomSelector.UnderlyingControl = function () {
    this.reset();
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.reset = function () {
    if (this._initialized) {
        this._parent.removeChild(this._container);
        this._parent.removeChild(this._addButon);
        this._parent.removeChild(this._removeButton);

        this._eventEmitter.reset();
    }

    this._initialized = false;
    this._parent = null;
    this._container = null;
    this._input = null;
    this._addButon = null;
    this._removeButton = null;
    this._eventEmitter = null;
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.set_value = function (value) {
    this._input.value = value;
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.get_value = function () {
    return this._input.value;
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.set_isEnabled = function (value) {
    var doc = Dynamicweb.Ajax.Document.get_current();
    if (value) {
        doc.attribute(this._input, "disabled", false);
        doc.removeClass(this._addButton, 'disabled');
        doc.removeClass(this._removeButton, 'disabled');
    } else {
        doc.attribute(this._input, "disabled", true);
        doc.addClass(this._addButton, 'disabled');
        doc.addClass(this._removeButton, 'disabled');
    }
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.get_isEnabled = function () {
    return Dynamicweb.Ajax.Document.get_current().attribute(this._input, 'disabled');
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.add_onAddClick = function (handler) {
    this._eventEmitter.on('add', handler);
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.remove_onAddClick = function (handler) {
    this._eventEmitter.off('add', handler);
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.add_onRemoveClick = function (handler) {
    this._eventEmitter.on('remove', handler);
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.remove_onRemoveClick = function (handler) {
    this._eventEmitter.off('remove', handler);
};

Dynamicweb.Controls.CustomSelector.UnderlyingControl.prototype.initialize = function (parameters) {
    var self = this,
        ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        funcHelper = Dynamicweb.Utilities.FuncHelper,
        typeHelper = Dynamicweb.Utilities.TypeHelper;

    if (!this._initialized) {
        if (typeHelper.isUndefined(parameters) || !typeHelper.isObject(parameters)) {
            throw 'Missed or invalid paramters argument!';
        }

        if (!typeHelper.isElement(parameters.parent)) {
            throw 'Missed or invalid parent argument!';
        }

        this._parent = parameters.parent;
        ajaxDoc.addClass(this._parent, 'input-group');

        this._eventEmitter = new Dynamicweb.Utilities.EventEmitter();

        this._removeButton = ajaxDoc.createElement('span', {
            'title': parameters.removeTitle || 'Remove',
            'class': 'input-group-addon last'
        });
        this._removeButton.innerHTML = '<i class=\"fa fa-remove color-danger\"></i>'

        this._addButton = ajaxDoc.createElement('span', {
            'title': parameters.addTitle || 'Add',
            'class': 'input-group-addon last'
        });
        if (parameters.selectType == 'User') {
            this._addButton.innerHTML = '<i class=\"md md-person-outline\"></i>'
        }
        else if (parameters.selectType == 'Group') {
            this._addButton.innerHTML = '<i class=\"md md-people-outline color-users\"></i>'
        }
        else {
            this._addButton.innerHTML = '<i class=\"fa fa-plus color-success\"></i>'
        }

        this._input = ajaxDoc.createElement('input', {
            'type': 'text',
            'readonly': 'readonly',
            'class': 'form-control std'
        });

        this._container = ajaxDoc.createElement('div', {
            'class': 'form-group-input'
        });

        this._container.appendChild(this._input);

        this._parent.appendChild(this._container);
        this._parent.appendChild(this._addButton);
        this._parent.appendChild(this._removeButton);


        ajaxDoc.subscribe(this._addButton, 'click', funcHelper.proxy(function (event, element) {
            this._eventEmitter.fire('add', this);
        }, this));

        ajaxDoc.subscribe(this._removeButton, 'click', funcHelper.proxy(function (event, element) {
            this._eventEmitter.fire('remove', this);
        }, this));

        this._initialized = true;
    }
};

/* ++++++ Selector ++++++ */

Dynamicweb.Controls.CustomSelector.Selector = function () {
    /// <summary>Represents a custom selector.</summary>
}

Dynamicweb.Controls.CustomSelector.Selector.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.CustomSelector.Selector.prototype.add_onValueSelecting = function (callback) {
    /// <summary>Registers new callback which is executed when the value is selected.</summary>
    /// <param name="callback">Callback to register.</param>

    this.addEventHandler('valueSelecting', callback);
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.add_onValueSelected = function (callback) {
    /// <summary>Registers new callback which is executed when the value is selected.</summary>
    /// <param name="callback">Callback to register.</param>

    this.addEventHandler('valueSelected', callback);
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.add_onValueRemoving = function (callback) {
    /// <summary>Registers new callback which is executed when the value is removed.</summary>
    /// <param name="callback">Callback to register.</param>

    this.addEventHandler('valueRemoving', callback);
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.add_onValueRemoved = function (callback) {
    /// <summary>Registers new callback which is executed when the value is removed.</summary>
    /// <param name="callback">Callback to register.</param>

    this.addEventHandler('valueRemoved', callback);
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.get_provider = function () {
    /// <summary>Gets select provider which executes select operation.</summary>

    return this._provider;
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.set_provider = function (value) {
    /// <summary>Registers new select provider which executes select operation.</summary>
    /// <param name="value">Provider to register.</param>
    /// <example>set_provider(function (options) { 
    ///  //where option is object which contains sender and callback which should be invoked after selection. 
    ///  var value, text;
    ///  //... select some value and it's text presentation ...
    ///  options.callback(value, text);
    ///});

    if (this.get_isEnabled()) {
        if (Dynamicweb.Utilities.TypeHelper.isFunction(value)) {
            this._provider = value;
        } else {
            throw 'Invalid value type!';
        }
    }
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.get_value = function () {
    /// <summary>Gets the current value.</summary>

    return { value: this._value, text: this._text };;
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.set_value = function (value, text) {
    /// <summary>Sets the currently selected value.</summary>
    /// <param name="value">Object which contains value and text presentation or array.</param>
    var typeHelper = Dynamicweb.Utilities.TypeHelper;

    if (this.get_isEnabled()) {

        if (typeHelper.isObject(value)) {
            this._value = value.value || '';
            this._text = value.text || this._value;
        } else {
            this._value = value || '';
            this._text = text || this._value;
        }

        this.raiseEvent('valueChanged', this.get_value());
    }
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.set_selectType = function (value) {
    /// <summary>Sets the kind of object can be selected.</summary>
    /// <param name="value">The kind of object(e.g. User, Group e.t.c).</param>

    if (this.get_isEnabled()) {
        this._selectType = value;
    }
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.get_state = function () {
    var self = this,
        ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        container = self.get_container();

    if (!this._state) {
        if (container) {
            self._state = {};
            self._state.underlyingControl = new Dynamicweb.Controls.CustomSelector.UnderlyingControl();
            self._state.underlyingControl.initialize({
                parent: container,
                addTitle: this.get_terminology()['Add'],
                removeTitle: this.get_terminology()['Remove'],
                selectType: this._selectType
            });
            self._state.postData = ajaxDoc.find(container.parentElement, 'input[type="hidden"][name="' + this._containerID + '"]')[0];
            self._state.postData.value = '';
        }
    }

    return this._state;
}

Dynamicweb.Controls.CustomSelector.Selector.prototype.reset = function () {

    if (this._initialized) {
        this.get_state().underlyingControl.reset();
    }

    this._value = '';
    this._text = '';
    this._provider = null;
    this._selectType = null;
};

Dynamicweb.Controls.CustomSelector.Selector.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this,
        ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        funcHelper = Dynamicweb.Utilities.FuncHelper,
        propertyChangedRouter = function (propertyHandlers, context) {
            return (function (handlers, thisArg) {
                return function (sender, args) {
                    var name = args.name,
                        value = args.value,
                        handler;

                    handler = handlers[name];

                    if (handler) {
                        handler.call(thisArg, value);
                    }
                };
            })(propertyHandlers, context);
        };

    this.add_propertyChanged(propertyChangedRouter({
        'isEnabled': function (value) {
            this.get_state().underlyingControl.set_isEnabled(value);
        },
        'value': function () {
            var v;
            if (this.get_isEnabled()) {
                v = this.get_value();
                this.get_state().underlyingControl.set_value(v.text);
                this.get_state().postData.value = v.value;
            }
        }
    }, this));

    this.get_state().underlyingControl.add_onAddClick(funcHelper.proxy(function () {
        if (this.get_isEnabled() && this.get_provider()) {
            this.get_provider()({
                caller: this,
                callback: funcHelper.proxy(function (value, text) {
                    var event;

                    event = { cancel: false };
                    this.raiseEvent('valueSelecting', { value: { value: value, text: text }, event: event });

                    if (!event.cancel) {
                        this.set_value(value, text);
                        this.raiseEvent('valueSelected', this.get_value());
                    }
                }, this)
            });
        }
    }, this));

    this.get_state().underlyingControl.add_onRemoveClick(funcHelper.proxy(function () {
        if (this.get_isEnabled()) {
            var event = { cancel: false };

            this.raiseEvent('valueRemoving', { value: this.get_value(), event: event });

            if (!event.cancel) {
                this.set_value('', '');
                this.raiseEvent('valueRemoved', this.get_value());
            }
        }
    }, this));

    //render values
    this.set_value(this.get_value());
    this.set_isEnabled(this.get_isEnabled());
}

/* ++++++ End: CustomSelector ++++++ */