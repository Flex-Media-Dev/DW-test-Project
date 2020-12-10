if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = {};
}

Dynamicweb.Controls.Combobox = {};

Dynamicweb.Controls.Combobox.ValidationHelper = {};

Dynamicweb.Controls.Combobox.ValidationHelper.validateArgument = function (propertyName, propertyValue, validator, thisArg) {
    if (Dynamicweb.Utilities.TypeHelper.isUndefined(propertyValue) || Dynamicweb.Utilities.TypeHelper.isNull(propertyValue)) {
        throw 'Missed argument:' + propertyName;
    }

    if (validator && !validator.call(thisArg || this, propertyValue)) {
        throw 'Invalid argument:' + propertyName;
    }
};

Dynamicweb.Controls.Combobox.EventHelper = {};

Dynamicweb.Controls.Combobox.EventHelper.action = function (options, thisArg) {
    if (options) {
        var raiseEvent = options.eventEmitter || options.target.raiseEvent;

        thisArg || (thisArg = options.target);

        raiseEvent(options.before, options.args);

        if (!options.args.cancel) {
            if (options.success) {
                options.success.call(thisArg);
            }

            if (options.after) {
                delete options.args.cancel;
                raiseEvent(options.after, options.args);
            }
        } else {
            if (options.failure) {
                options.failure.call(thisArg);
            }
        }
    }
};

Dynamicweb.Controls.Combobox.Dialog = function () {
    var _self = this,
        _container,
        _textInput = null,
        _valueInput = null,
        _id,
        _editors = new Dynamicweb.Utilities.Dictionary(),
        _model,
        _opened = false,
        _initialized = false,
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        _eventEmitter = new Dynamicweb.Utilities.EventEmitter(),
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _validationHelper = Dynamicweb.Controls.Combobox.ValidationHelper,
        _eventNames = {
            'opened': 'opened',
            'completed': 'completed',
            'canceled': 'canceled',
            'closed' : 'closed'
        };

    function open() {
        _opened = true;
        dialog.show(_id);
    }

    function close() {
        dialog.hide(_id);
        _opened = false;
    }

    function bindToView(model) {
        _textInput.value = model.text || '';
        _valueInput.value = model.value || '';
    }

    function bindToModel(model) {
        model.text = _textInput.value;
        model.value = _valueInput.value;
    }

    _self.initialize = function (params) {
        if (!_initialized) {
            _validationHelper.validateArgument('initialize', params, function (x) { return !_typeHelper.isUndefined(x); });
            _validationHelper.validateArgument('initialize', params.id, function (x) { return !_typeHelper.isUndefined(x); });

            _id = params.id;
            _container = _ajaxDoc.getElementById(_id);
            _textInput = _ajaxDoc.find(_container, '.combobox-editor-text .editor-field-value > input')[0];
            _valueInput = _ajaxDoc.find(_container, '.combobox-editor-value .editor-field-value > input')[0];

            _ajaxDoc.subscribe(_container, 'click', 'button.dialog-button-ok', function (event, element) {
                _self.complete();
            });

            _ajaxDoc.subscribe(_container, 'click', 'button.dialog-button-cancel', function (event, element) {
                _self.cancel();
            });
        }
    };

    _self.get_isOpened = function () {
        return _opened;
    };

    _self.open = function (model) {
        if (!_opened) {
            _model = model;

            bindToView(model);
            open();
            _textInput.focus();

            _eventEmitter.fire(_eventNames.opened, { sender: _self });
        }
    };

    _self.complete = function () {
        var args;
        if (_opened) {
            bindToModel(_model);

            Dynamicweb.Controls.Combobox.EventHelper.action({
                target: _self,
                eventEmitter: Dynamicweb.Utilities.FuncHelper.proxy(_eventEmitter.fire, _eventEmitter),
                before: _eventNames.completed,
                args: { model: _model, cancel: false },
                success: function () {
                    _model = null;

                    close();

                    _eventEmitter.fire(_eventNames.closed, { sender: _self });
                }
            });
        }
    };

    _self.cancel = function () {
        if (_opened) {
            close();

            _eventEmitter.fire(_eventNames.canceled, { sender: _self });
        }
    };

    _self.add_onOpened = function (handler) {
        _eventEmitter.on(_eventNames.opened, handler);
    };

    _self.remove_onOpened = function (handler) {
        _eventEmitter.off(_eventNames.opened, handler);
    };

    _self.add_onComplete = function (handler) {
        _eventEmitter.on(_eventNames.completed, handler);
    };

    _self.remove_onComplete = function (handler) {
        _eventEmitter.off(_eventNames.completed, handler);
    };

    _self.add_onCanceled = function (handler) {
        _eventEmitter.on(_eventNames.canceled, handler);
    };

    _self.remove_onCanceled = function (handler) {
        _eventEmitter.off(_eventNames.canceled, handler);
    };

    _self.add_onClosed = function (handler) {
        _eventEmitter.on(_eventNames.closed, handler);
    };

    _self.remove_onClosed = function (handler) {
        _eventEmitter.off(_eventNames.closed, handler);
    };
};

Dynamicweb.Controls.Combobox.Dropdown = function () {
    var _self = this,
        _initialized = false,
        _allowEditing = true,
        _editItem = null,
        _editItemVisible = false,
        _parent = null,
        _container = null,
        _button = null,
        _menu = null,
        _selectedItem = null,
        _items = new Dynamicweb.Utilities.Dictionary(),
        _isOpened = false,
        _isEnabled = true,
        _isVisible = true,
        _toString = String.prototype.toString,
        _collHelper = Dynamicweb.Utilities.CollectionHelper,
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        _validationHelper = Dynamicweb.Controls.Combobox.ValidationHelper,
        _funcHelper = Dynamicweb.Utilities.FuncHelper,
        _eventEmitter = new Dynamicweb.Utilities.EventEmitter(),
        _eventNames = {
            'opened': 'opened',
            'closed': 'closed',
            'selected': 'selected',
            'focusIn': 'focusIn',
            'new' : 'new'
        },
        _directions = {
            'UP': 'UP',
            'DOWN' : 'DOWN'
        };

    function createItem(item) {
        var el = null, text = null;
        _validationHelper.validateArgument("item", item, _typeHelper.isObject);
        _validationHelper.validateArgument("item", item, function (v) { return !_typeHelper.isEmpty(v); });
        _validationHelper.validateArgument("item.text", item.text, _typeHelper.isString);
        _validationHelper.validateArgument("item.value", item.value, function (v) { return _typeHelper.isString(v) || _typeHelper.isNumber(v); });

        el = _ajaxDoc.createElement('li');
        _ajaxDoc.attribute(el, 'data-value', item.value);

        el.appendChild(_ajaxDoc.createElement('span'));

        text = _ajaxDoc.createElement('a', {
            'href': '#'
        });

        text.appendChild(document.createTextNode(item.text));
        el.appendChild(text);

        return el;
    }

    function close() {
        _ajaxDoc.removeClass(_menu, 'opened');
        _ajaxDoc.unsubscribe(document, 'click', listener);
        _isOpened = false;
        _eventEmitter.fire(_eventNames.closed, { sender: this });
    }

    function open() {
        select();
        _ajaxDoc.addClass(_menu, 'opened');
        _ajaxDoc.subscribe(document, 'click', listener);
        _isOpened = true;
        _eventEmitter.fire(_eventNames.opened, { sender: this });
    }

    function toggle() {
        if (_isOpened) {
            close();
        } else {
            open();
        }
    }

    function select(element) {
        if (element === _selectedItem) {
            return;
        }

        if (_selectedItem) {
            _ajaxDoc.removeClass(_selectedItem, 'in-focus');
        }

        _selectedItem = element || null;

        if (_selectedItem) {
            _ajaxDoc.addClass(_selectedItem, 'in-focus');
        }
    }

    function moveSelection(direction) {
        var element = null;
        
        if (!_self.get_isEnabled()) {
            return;
        }

        if (_self.get_count() > 0) {
            if (!_selectedItem || _self.get_count() === 1) {
                select(_items.first());
            } else {
                if (direction === _directions.UP) {
                    if (_selectedItem.previousElementSibling) {
                        select(_selectedItem.previousElementSibling);
                    } else {
                        select(_items.last());
                    }
                } else if (direction === _directions.DOWN) {
                    if (_selectedItem.nextElementSibling) {
                        select(_selectedItem.nextElementSibling);
                    } else {
                        select(_items.first());
                    }
                }
            }

            if (_selectedItem) {
                _eventEmitter.fire(_eventNames.selected, { sender: _self, element: _selectedItem, value: _ajaxDoc.attribute(_selectedItem, 'data-value') });
            }
        } else {
            if (_self.get_allowEditing()) {
                select(_editItem);
            }
        }
    }

    function getParent(element) {
        var el = null,
            selector = 'combobox',
            found = _ajaxDoc.hasClass(element, selector);

        if (!found) {
            el = _ajaxDoc.parent(element, '.' + selector);
        }

        return el;
    }

    function listener(event, element) {
        var parent = null;
        if (_isOpened) {
            parent = getParent(event.target);

            if (!parent || parent !== _parent) {
                close();
            }
        }
    }

    function onDataSourceChange() {
        var showEditItem;
        if (_allowEditing) {

            if (_editItemVisible) {
                _menu.removeChild(_editItem);
            }

            _menu.appendChild(_editItem);
            _editItemVisible = true;
        }
    }

    function onItemClicked(element) {
        var value;

        if (_self.get_isEnabled()) {

            close();

            if (element !== _editItem) {
                value = _ajaxDoc.attribute(element, 'data-value');

                if (_items.containsKey(value)) {
                    _eventEmitter.fire(_eventNames.selected, { sender: _self, element: element, value: value });
                }
            } else {
                _eventEmitter.fire(_eventNames.new, { sender: _self, element: element });
            }
        }
    }

    _self.initialize = function (param) {
        var html = '', text = null;
        if (!_initialized) {
            _validationHelper.validateArgument("param", param, _typeHelper.isObject);
            _validationHelper.validateArgument("param", param, function (v) { return !_typeHelper.isEmpty(v); });
            _validationHelper.validateArgument("param.parent", param.parent, _typeHelper.isElement);

            _parent = param.parent;
            _isVisible = _typeHelper.isUndefined(param.isVisible) ? true : param.isVisible;

            // container
            _container = _ajaxDoc.createElement('div', {
                'class': 'buttons' +  (_isVisible ? '' : ' hidden')
            });

            if (param.class) {
                _ajaxDoc.addClass(_container, param.class);
            }

            if (param.attributes) {
                _validationHelper.validateArgument("param.attributes", param.attributes, _typeHelper.isObject);

                _collHelper.forEach(param.attributes, function (value, name) {
                    _ajaxDoc.attribute(_container, name, value);
                });
            }

            // button
            _button = _ajaxDoc.createElement('a', {
                'href': '#'
            });

            if (param.text) {
                _container.appendChild(document.createTextNode(param.text));
            }

            _button.appendChild(_ajaxDoc.createElement('span'));

            //menu
            _menu = _ajaxDoc.createElement('ul', {
                'class': 'combobox-list'
            });

            //edit item
            _editItem = createItem({ text: param.terminology.new ? param.terminology.new + '...' :  'Create...', value: '_$edit_' });
            _ajaxDoc.addClass(_editItem, 'add-new');

            //register event handlers
            _ajaxDoc.subscribe(_container, 'click', function () {
                if (_self.get_isEnabled()) {
                    toggle();
                }
            });

            _ajaxDoc.subscribe(_menu, 'click', 'li', function (event, element) {
                onItemClicked(element);
            });

            _ajaxDoc.subscribe(_menu, 'mouseover', 'li', function (event, element) {
                select(element);

                _eventEmitter.fire(_eventNames.focusIn, { sender: _self, element: element });
            });

            _ajaxDoc.subscribe(_parent, 'keydown', function (event, element) {
                var keyCode = event.which;

                if (!_self.get_isOpened()) {
                    _self.open();
                }

                if (keyCode === 38) {
                    _self.up();
                } else if (keyCode === 40) {
                    _self.down();
                } else if (keyCode === 27) {
                    _self.close();
                } else if (keyCode === 13) {
                    if (_selectedItem) {
                        onItemClicked(_selectedItem);
                    }
                }
            });

            _container.appendChild(_button);

            _parent.appendChild(_menu);
            _parent.appendChild(_container);

            _initialized = true;
        }
    };

    _self.get_container = function () {
        return _menu;
    };

    _self.get_allowEditing = function () {
        return _allowEditing;
    };

    _self.set_allowEditing = function (value) {
        _validationHelper.validateArgument('allowEditing', value, _typeHelper.isBoolean);

        _allowEditing = value;
    };

    _self.get_isOpened = function () {
        return _isOpened;
    };

    _self.get_isEnabled = function () {
        return _isEnabled;
    };

    _self.set_isEnabled = function (value) {
        _validationHelper.validateArgument('isEnabled', value, _typeHelper.isBoolean);

        if (value) {
            _ajaxDoc.removeClass('disabled');
        } else {
            _ajaxDoc.addClass('disabled');
        }

        _isEnabled = value;
    };

    _self.get_isVisible = function () {
        return _isVisible;
    };

    _self.set_isVisible = function (value) {
        _validationHelper.validateArgument('isVisible', value, _typeHelper.isBoolean);
        _isVisible = value;

        if (value) {
            _ajaxDoc.removeClass(_container, 'hidden');
        } else {
            _ajaxDoc.addClass(_container, 'hidden');
        }
    };

    _self.toggle = function () {
        toggle.call(this);
    };

    _self.get_dataSource = function () {
        var result = [];

        _collHelper.forEach(_items, function (el) {
            result.push({
                value: _ajaxDoc.attribute(el, 'data-value'),
                text: _ajaxDoc.find(el, 'a').innerHTML
            });
        }, this);

        return result;
    };

    _self.set_dataSource = function (items) {
        this.clear();

        if (_typeHelper.isFunction(items.forEach)) {
            items.forEach(function (a, b) {
                if (_typeHelper.isObject(a)) {
                    _self.addItem(a);
                } else {
                    _self.addItem(b);
                }
            });
        } else {
            _collHelper.forEach(items, this.addItem, this);
        }

        onDataSourceChange();
    };

    _self.get_selected = function () {
        var result = '';

        if (_selectedItem) {
            result = _ajaxDoc.attribute(_selectedItem, 'data-value');
        }

        return result;
    };

    _self.set_selected = function (key) {
        var item = _items.get(key);

        if (item) {
            select(item);
        }
    };

    _self.get_count = function () {
        return _items.count();
    };

    _self.addItem = function (item) {
        var el = createItem(item);

        _items.add(item.value, el);
        _menu.appendChild(el);
        onDataSourceChange();
    };

    _self.removeItem = function (value) {
        var key = value;

        if (value) {
            if (_typeHelper.isObject(value)) {
                key = value.value;
            }

            _menu.removeChild(_items.get(key));
            _items.remove(key);            
        }

        onDataSourceChange();
    };

    _self.clear = function () {
        _items.forEach(function (el, key) {
            _menu.removeChild(el);
        }, this);
        _items.clear();
        onDataSourceChange();
    };

    _self.open = function () {
        if (this.get_isEnabled()) {
            open();
        }
    };

    _self.close = function () {
        if (this.get_isEnabled()) {
            close();
        }
    };

    _self.up = function () {
        moveSelection(_directions.UP);
    };

    _self.down = function () {
        moveSelection(_directions.DOWN);
    };

    _self.add_onOpen = function (handler) {
        _eventEmitter.on(_eventNames.opened, handler);
    };

    _self.remove_onOpen = function (handler) {
        _eventEmitter.off(_eventNames.opened, handler);
    };

    _self.add_onClose = function (handler) {
        _eventEmitter.on(_eventNames.closed, handler);
    };

    _self.remove_onClose = function (handler) {
        _eventEmitter.off(_eventNames.closed, handler);
    };

    _self.add_onSelected = function (handler) {
        _eventEmitter.on(_eventNames.selected, handler);
    };

    _self.remove_onSelected = function (handler) {
        _eventEmitter.off(_eventNames.selected, handler);
    };

    _self.add_onFocusIn = function (handler) {
        _eventEmitter.on(_eventNames.focusIn, handler);
    };

    _self.remove_onFocusIn = function (handler) {
        _eventEmitter.off(_eventNames.focusIn, handler);
    };

    _self.add_onNew = function (handler) {
        _eventEmitter.on(_eventNames.new, handler);
    };

    _self.remove_onNew = function (handler) {
        _eventEmitter.off(_eventNames.new, handler);
    };
};

Dynamicweb.Controls.Combobox.TextInput = function () {
    var _self = this,
        _id = null,
        _initialized = false,
        _isEnabled = true,
        _isReadOnly = false,
        _parent = null,
        _container = null,
        _item = {text: '', value: ''},
        _validationHelper = Dynamicweb.Controls.Combobox.ValidationHelper,
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        _eventEmitter = new Dynamicweb.Utilities.EventEmitter(),
        _eventNames = {
            'typing': 'typing',
            'focusIn': 'focusIn',
            'focusOut': 'focusOut'
        };

    _self.initialize = function (param) {
        if (!_initialized) {
            _validationHelper.validateArgument("param", param, _typeHelper.isObject);
            _validationHelper.validateArgument("param", param, function (v) { return !_typeHelper.isEmpty(v); });
            _validationHelper.validateArgument("param.parent", param.parent, _typeHelper.isElement);

            _parent = param.parent;
            _container = _ajaxDoc.createElement('input', {
                'type': 'text',
                'class': 'combobox-text' + (param.isEnabled === false ? ' disabled' : '')
            });

            _ajaxDoc.subscribe(_container, 'focus', function (event, element) {
                if (_isEnabled) {
                    _eventEmitter.fire(_eventNames.focusIn, { sender: _self, text: _container.value });
                }
            });

            _ajaxDoc.subscribe(_container, 'blur', function (event, element) {
                if (_isEnabled) {
                    _eventEmitter.fire(_eventNames.focusOut, { sender: _self, text: _container.value });
                }
            });

            _ajaxDoc.subscribe(_container, 'keyup', function (event, element) {
                var keyCode = event.which;

                if (_isEnabled) {
                    if ((keyCode <= 90 && keyCode >= 48) || keyCode === 8) {
                        _eventEmitter.fire(_eventNames.typing, { sender: _self, text: _container.value });
                    }
                }
            });

            _parent.appendChild(_container);

            _initialized = true;
        }
    };

    _self.get_container = function () {
        return _container;
    };

    _self.get_currentText = function () {
        return _container.value;
    };

    _self.get_value = function () {
        return _typeHelper.clone(_item);
    };

    _self.set_value = function (item) {
        _item = item;
        _container.value = item ? _item.text || _item.value : '';
    };

    _self.get_isEnabled = function () {
        return _isEnabled;
    };

    _self.set_isEnabled = function (value) {
        _isEnabled = value;

        if (!_isEnabled) {
            _ajaxDoc.addClass(_container, 'disabled');
        } else {
            _ajaxDoc.removeClass(_container, 'disabled');
        }
    };

    _self.get_isReadOnly = function () {
        return _isReadOnly;
    };

    _self.set_isReadOnly = function (value) {
        _isReadOnly = value;

        if (value) {
            _ajaxDoc.attribute(_container, 'readonly', 'readonly');
        } else {
            _ajaxDoc.removeAttribute(_container, 'readonly');
        }
    };

    _self.focusIn = function () {
        _container.focus();
    };

    _self.focusOut = function () {
        _container.blur();
    };

    _self.add_onTyping = function (handler) {
        _eventEmitter.on(_eventNames.typing, handler);
    };

    _self.remove_onTyping = function (handler) {
        _eventEmitter.off(_eventNames.typing, handler);
    };

    _self.add_onFocusIn = function (handler) {
        _eventEmitter.on(_eventNames.focusIn, handler);
    };

    _self.remove_onFocusIn = function (handler) {
        _eventEmitter.off(_eventNames.focusIn, handler);
    };

    _self.add_onFocusOut = function (handler) {
        _eventEmitter.on(_eventNames.focusOut, handler);
    };

    _self.remove_onFocusOut = function (handler) {
        _eventEmitter.off(_eventNames.focusOut, handler);
    };
};

Dynamicweb.Controls.Combobox.Widget = function () {
    var _self = this,
        _postValueField = null,
        _initialized = false,
        _allowEditing = true,
        _allowEmpty = false,
        _allowAutocompletion = true,
        _editExpression = '',
        _postValueContainer = 0,
        _autocompleteExpression,
        _input = null,
        _dropdown = null,
        _dialog = null,
        _dataSource = new Dynamicweb.Utilities.Dictionary(),
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        _validationHelper = Dynamicweb.Controls.Combobox.ValidationHelper,
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _collHelper = Dynamicweb.Utilities.CollectionHelper,
        _funcHelper = Dynamicweb.Utilities.FuncHelper,
        _stringHelper = Dynamicweb.Utilities.StringHelper,
        _toLower = String.prototype.toLowerCase,
        _eventNames = {
            'ITEM_CHANGING': 'ITEM_CHANGING',
            'ITEM_CHANGED': 'ITEM_CHANGED',
            'ITEM_CREATING': 'ITEM_CREATING',
            'ITEM_CREATED': 'ITEM_CREATED'
        };

    function markAsSelected(item) {
        if (item) {
            _dataSource.forEach(function (i) {
                i.selected = false;
            });

            item.selected = true;
        }
    }

    function addItem(item) {
        _validationHelper.validateArgument('item', item, function (x) { return !_typeHelper.isUndefined(x); });
        _validationHelper.validateArgument('item.value', item.value, function (x) { return !_typeHelper.isUndefined(x); });
        _validationHelper.validateArgument('item.text', item.text, function (x) { return !_typeHelper.isUndefined(x); });

        _dataSource.add(item.value, item);
    }

    function removeItem(item) {
        if (_typeHelper.isUndefined(item)) {
            return;
        }

        if (_typeHelper.isObject(item)) {
            _dataSource.remove(item.value);
        } else if (_typeHelper.isString(item)) {
            _dataSource.remove(item);
        }
    }

    function createEmptyItem() {
        return { value: '', text: '' };
    }

    function defaultAutocomlpete(text, item) {
        if (!text) {
            return true;
        } else {
            return item.text ? _stringHelper.startsWith(_toLower.call(item.text), _toLower.call(text)) : true;
        }
    }

    function autocomplete(text, item) {
        if (_autocompleteExpression) {
            return _autocompleteExpression(text, item, _self);
        } else {
            return defaultAutocomlpete(text, item);
        }
    }

    function defaultEditExpression(item) {
        _dialog.open(item);
    }

    function edit(item) {
        if (_typeHelper.isFunction(_editExpression)) {
            _editExpression({
                sender: _self,
                item: item,
                complete: completeEdit,
                cancel: cancelEdit
            });
        } else {
            defaultEditExpression(item);
        }
    }

    function completeEdit(item) {
        Dynamicweb.Controls.Combobox.EventHelper.action({
            target: _self,
            before: _eventNames.ITEM_CREATING,
            after: _eventNames.ITEM_CREATED,
            args: { value: item, cancel: false },
            success: function () {
                if (_stringHelper.trim(item.text) && _stringHelper.trim(item.value)) {
                    item.status = 'new';
                    _dataSource.add(item.value, item);
                    _self._binder.notifyPropertyChanged('dataSource', _dataSource);
                    _input.set_value(item);
                } else {
                    setDefaultValue();
                }

                _dropdown.close();
            },
            failure: function () {
                _input.focusIn();
            }
        });
    }

    function cancelEdit() {
        setDefaultValue();
        _input.focusIn();
    }

    function setDefaultValue() {
        var first = _dataSource.first(function () { return true; });

        if (first) {
            _input.set_value(first);
        } else {
            _input.set_value({ value: '', text: '' });
        }
    }

    _self.initialize = function (param) {
        var form,
            submit,
            submitCalls = 0,
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
        },
            methodCalledRouter = function (methodHandlers, context) {
            return (function (handlers, thisArg) {
                return function (sender, args) {
                    var name = args.name,
                        parameters = args.parameters,
                        handler;

                    handler = handlers[name];

                    if (handler) {
                        handler.apply(thisArg, parameters);
                    }
                };
            })(methodHandlers, context);
        };

        if (!_self._initialized) {
            _postValueField = _ajaxDoc.getElementsBySelector('input[type="hidden"][name="' + this._associatedControlID + '"]')[0];

            _input = new Dynamicweb.Controls.Combobox.TextInput();
            _input.initialize({ parent: this.get_container() });

            _dropdown = new Dynamicweb.Controls.Combobox.Dropdown();
            _dropdown.initialize({
                parent: this.get_container(),
                terminology: {
                    'new' : this.get_terminology()['new']
                }
            });

            _dialog = new Dynamicweb.Controls.Combobox.Dialog();
            _dialog.initialize({
                id: 'combobox-dialog-' + this.get_associatedControlID()
            });

            _self.add_propertyChanged(propertyChangedRouter({
                'allowAutocompletion': function (value) {
                    _input.set_isReadOnly(!value);
                },
                'allowEmpty': function (value) {
                    if (value === false) {
                        var selected = this.get_selected();

                        if (!selected || !selected.text || !selected.value) {
                            this.set_selected(_dataSource.first());
                        }
                    }
                },
                'allowEditing': function (value) {
                    _dropdown.set_allowEditing(value);
                },
                'isEnabled': function (value) {
                    _dropdown.set_isEnabled(value);
                    _input.set_isEnabled(value);
                    
                    if (value === true) {
                        if (_allowAutocompletion) {
                            _input.set_isReadOnly(false);
                        }
                    } else {
                        _input.set_isReadOnly(true);
                    }
                },
                'selected': function (item) {
                    Dynamicweb.Controls.Combobox.EventHelper.action({
                        target: _self,
                        before: _eventNames.ITEM_CHANGING,
                        after: _eventNames.ITEM_CHANGED,
                        args: { value: item, cancel: false },
                        success: function () {
                            markAsSelected(item);
                            _input.set_value(item);

                            if (item && !_dataSource.containsKey(item.value)) {
                                this.addItem(item);
                            }
                        }
                    });
                },
                'dataSource': function () {
                    _dropdown.clear();
                    _dataSource.forEach(_dropdown.addItem, _dropdown);
                }
            }, _self));

            _self._binder.add_methodCalled(methodCalledRouter({
                'addItem': function (value) {
                    _dropdown.addItem(value);
                },
                'removeItem': function (value) {
                    _dropdown.removeItem(value);
                },
                'clear': function () {
                    _dropdown.clear();
                }
            }));

            _input.add_onFocusIn(_funcHelper.proxy(_dropdown.open, _dropdown));

            _input.add_onFocusOut(function (eventName, args) {
                setTimeout(function () {
                    var selected;

                    // check wheather selected text is valid
                    if (!_dialog.get_isOpened()) {
                        if (!selected) {
                            if (!_self.get_allowEmpty()) {
                                selected = _input.get_value();
                            } else {
                                selected = createEmptyItem();
                            }
                        }
                        
                        _input.set_value(selected);
                    }

                    _dropdown.close();

                    if (_dropdown.get_count() === 0) {
                        _dropdown.set_dataSource(_dataSource);
                    }
                }, 150);
            });

            _input.add_onTyping(function (eventName, args) {
                var items = _dataSource.where(function (item) {
                    return autocomplete(args.text, item);
                });

                _dropdown.clear();
                _collHelper.forEach(items, _dropdown.addItem, _dropdown);
            });

            _dropdown.add_onSelected(function (eventName, args) {
                _self.set_selected(_self.getItem(args.value));
            });

            _dropdown.add_onNew(function (eventName, args) {
                edit({ text: _input.get_currentText() });
            });

            _dropdown.add_onOpen(function (eventName, args) {
                _ajaxDoc.addClass(_self.get_container(), 'opened');
                _ajaxDoc.width(_dropdown.get_container(), (parseFloat(_ajaxDoc.width(_input.get_container())) + 1) + 'px');
            });

            _dropdown.add_onClose(function () {
                _ajaxDoc.removeClass(_self.get_container(), 'opened');
            });

            _dialog.add_onComplete(function (eventName, args) {                
                completeEdit(args.model);
            });

            _dialog.add_onCanceled(function (eventName, args) {
                cancelEdit();
            });
            
            _self._binder.notifyPropertyChanged('allowAutocompletion', _allowAutocompletion);
            _self._binder.notifyPropertyChanged('allowEditing', _allowEditing);
            _self._binder.notifyPropertyChanged('dataSource', _dataSource);
            _self._binder.notifyPropertyChanged('isEnabled', _self.get_isEnabled());
            _self._binder.notifyPropertyChanged('selected', _dataSource.first());

            form = _ajaxDoc.getElementsBySelector('form')[0];

            if (form) {
                submit = form.onsubmit || function () { };

                form.onsubmit = _funcHelper.proxy(function () {
                    if (submitCalls === 0) {
                        submitCalls += 1;
                        _postValueField.value = JSON.stringify(_dataSource.values());
                        submit();
                    }
                }, _self);
            }
        }
    };

    _self.get_allowEditing = function () {
        return _allowEditing;
    };

    _self.set_allowEditing = function (value) {
        _validationHelper.validateArgument('allowEditing', value, _typeHelper.isBoolean);

        _allowEditing = value;
    };

    _self.get_editExpression = function () {
        return _editor;
    };

    _self.set_editExpression = function (value) {
        if (_typeHelper.isFunction(value)) {
            _editExpression = value;
        } else if (_typeHelper.isString(value)) {
            _editExpression = eval(value);
        } else {
            throw 'Invalid argument type: editor. Expected "string" or "function".';
        }
    };

    _self.get_allowAutocompletion = function () {
        return _allowAutocompletion;
    };

    _self.set_allowAutocompletion = function (value) {
        _validationHelper.validateArgument('value', value, _typeHelper.isBoolean);

        _allowAutocompletion = value;
    };

    _self.get_autocompleteExpression = function () {
        return _autocompleteExpression;
    };

    _self.set_autocompleteExpression = function (expression) {
        _validationHelper.validateArgument('autocompleteExpression', expression, function (x) { return !_typeHelper.isUndefined(x); });

        if (_typeHelper.isString(expression)) {
            _autocompleteExpression = eval(expression);
        } else if (_typeHelper.isFunction(expression)) {
            _autocompleteExpression = expression;
        } else {
            throw 'Invalid argument type: autocompleteExpression. Expected "string" or "function".';
        }
    };

    _self.get_allowEmpty = function () {
        return _allowEmpty;
    };

    _self.set_allowEmpty = function (value) {
        _validationHelper.validateArgument('allowEmpty', value, _typeHelper.isBoolean);
        _allowEmpty = value;
    };

    _self.get_isVisible = function () {
        return _ajaxDoc.hasClass(this.get_container(), 'hidden');
    };

    _self.set_isVisible = function (value) {
        _validationHelper.validateArgument('value', value, _typeHelper.isBoolean);

        if (value) {
            _ajaxDoc.removeClass(this.get_container(), 'hidden');
        } else {
            _ajaxDoc.addClass(this.get_container(), 'hidden');
        }
    };

    _self.get_selected = function () {
        return _input.get_value();
    };

    _self.set_selected = function (item) {
        var validate = function (x) {
            if (_self.get_allowEmpty()) {
                return true;
            } else {
                return !_typeHelper.isUndefined(x);
            }
        };

        _validationHelper.validateArgument('item', item, validate);
        _validationHelper.validateArgument('item.value', item.value, validate);
    };

    _self.get_dataSource = function () {
        return _dataSource.values();
    };

    _self.set_dataSource = function (items) {
        _validationHelper.validateArgument('dataSource', items, function (x) { return !_typeHelper.isUndefined(x); });
        
        _dataSource.clear();

        _collHelper.forEach(items, addItem, this);

        if (!_self.get_allowEmpty()) {
            if (_dataSource.count() > 0) {
                _self.set_selected(_dataSource.first());
            }
        }
    };

    _self.clear = function () {
        this.set_selected(createEmptyItem());
        this.set_dataSource([]);
    };

    _self.addItem = addItem;

    _self.removeItem = removeItem;

    _self.getItem = function (value) {
        return _dataSource.get(value);
    };

    _self.findItem = function (criteria) {
        return _dataSource.first(criteria, this);
    };

    _self.findItems = function (criteria) {
        return _dataSource.where(criteria, this);
    };

    _self.firstItem = function (criteria) {
        return _dataSource.first(criteria);
    };

    _self.lastItem = function (criteria) {
        return _dataSource.last(criteria);
    };

    _self.addItemChanging = function (handler) {
        this.addEventHandler(_eventNames.VALUE_CHANGING, handler);
    };

    _self.removeItemChanging = function (handler) {
        this.removeEventHandler(_eventNames.VALUE_CHANGING, handler);
    };

    _self.addItemChanged = function (handler) {
        this.addEventHandler(_eventNames.VALUE_CHANGED, handler);
    };

    _self.removeItemChanged = function (handler) {
        this.removeEventHandler(_eventNames.VALUE_CHANGED, handler);
    };

    _self.addItemCreating = function (handler) {
        this.addEventHandler(_eventNames.VALUE_CREATING, handler);
    };

    _self.removeItemCreating = function (handler) {
        this.removeEventHandler(_eventNames.VALUE_CREATING, handler);
    };

    _self.addItemCreated = function (handler) {
        this.addEventHandler(_eventNames.VALUE_CREATED, handler);
    };

    _self.removeItemCreated = function (handler) {
        this.removeEventHandler(_eventNames.VALUE_CREATED, handler);
    };
};

Dynamicweb.Controls.Combobox.Widget.prototype = new Dynamicweb.Ajax.Control();