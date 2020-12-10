/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

/* ++++++ End: Registering namespace ++++++ */


/* ++++++ CustomListBox ++++++ */

Dynamicweb.Controls.CustomListBox = {};

/* ++++++ Underlying сontrol ++++++ */

Dynamicweb.Controls.CustomListBox.UnderlyingControl = function () {
    this.reset();
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.set_isEnabled = function (value) {
    var doc = Dynamicweb.Ajax.Document.get_current();

    if (value) {
        doc.removeClass(this._list, 'disabled');
        doc.removeClass(this._addButton, 'disabled');
        doc.removeClass(this._removeButton, 'disabled');
        doc.removeClass(this._clearButton, 'disabled');
    } else {
        doc.addClass(this._list, 'disabled');
        doc.addClass(this._addButton, 'disabled');
        doc.addClass(this._removeButton, 'disabled');
        doc.addClass(this._clearButton, 'disabled');
    }

    this._isEnabled = value;
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.get_isEnabled = function () {
    return this._isEnabled;
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.clear = function () {
    var collHelper = Dynamicweb.Utilities.CollectionHelper;

    collHelper.forEach(this._items, function (itemList) {
        this._list.removeChild(itemList);
    }, this);

    this._items.length = 0;
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.reset = function () {
    if (this._initialized) {
        this._parent.removeChild(this._list);
        this._parent.removeChild(this._buttonsWrap);
        this._eventEmitter.reset();
    }

    this._initialized = false;
    this._isEnabled = true;
    this._parent = null;
    this._eventEmitter = null;
    this._list = null;
    this._items = null;
    this._buttonsWrap = null;
    this._addButton = null;
    this._removeButton = null;
    this._clearButton = null;
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.addItem = function (item) {
    var doc = Dynamicweb.Ajax.Document.get_current(),
        listItem,
        itemText,
        itemIcon,
        len;

    this._validateItem(item);

    listItem = doc.createElement('li', { 'class': 'custom-listbox-item' })
    itemText = doc.createElement('span', {
        'class': 'text',
        'title': item.text || item.value
    });
    itemText.innerHTML = item.text || item.value;

    if (!item.icon) {
        itemIcon = doc.createElement('i', { 'class': 'no-icon' });
    } else {
        itemIcon = doc.createElement('i', { 'class': item.icon });
    }
    
    listItem.appendChild(itemIcon);
    listItem.appendChild(itemText);
    this._list.appendChild(listItem);
    len = this._items.push(listItem);

    return (len - 1);
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.removeItem = function (index) {
    var listItem = this._items[index];

    if (listItem) {
        this._items.splice(index, 1);
        this._list.removeChild(listItem);
    }
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.setSelectedIndex = function (index) {
    var doc = Dynamicweb.Ajax.Document.get_current(),
        collectionHelper = Dynamicweb.Utilities.CollectionHelper,
        itemList;

    itemList = this._items[index];

    if (itemList) {
        collectionHelper.forEach(this._items, function (il) {
            doc.removeClass(il, 'selected');
        }, this);

        doc.addClass(itemList, 'selected');
    }
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.getSelectedIndex = function () {
    var doc = Dynamicweb.Ajax.Document.get_current(),
        itemListIndex = -1;

    Dynamicweb.Utilities.CollectionHelper.first(this._items, function (element, index) {
        if (doc.hasClass(element, 'selected')) {
            itemListIndex = index;
            return true;
        } else {
            return false;
        };
    });

    return itemListIndex;
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.add_onAddClick = function (handler) {
    this._eventEmitter.on('add', handler);
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.remove_onAddClick = function (handler) {
    this._eventEmitter.off('add', handler);
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.add_onRemoveClick = function (handler) {
    this._eventEmitter.on('remove', handler);
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.remove_onRemoveClick = function (handler) {
    this._eventEmitter.off('remove', handler);
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.add_onClearClick = function (handler) {
    this._eventEmitter.on('clear', handler);
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.remove_onClearClick = function (handler) {
    this._eventEmitter.off('clear', handler);
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype.initialize = function (parameters) {
    var self = this,
      ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
      funcHelper = Dynamicweb.Utilities.FuncHelper,
      typeHelper = Dynamicweb.Utilities.TypeHelper,
      collectionHelper = Dynamicweb.Utilities.CollectionHelper,
      item;

    if (!this._initialized) {
        if (typeHelper.isUndefined(parameters) || !typeHelper.isObject(parameters)) {
            throw 'Missed or invalid paramters argument!';
        }

        if (!typeHelper.isElement(parameters.parent)) {
            throw 'Missed or invalid parent argument!';
        }

        this._parent = parameters.parent;
        this._eventEmitter = new Dynamicweb.Utilities.EventEmitter();

        this._items = [];

        this._list = ajaxDoc.createElement('ul', {
            'class': 'custom-listbox-list box-control-box'
        });

        this._buttonsWrap = ajaxDoc.createElement('div', {
            'class': 'box-control-actions'
        });

        this._addButton = ajaxDoc.createElement('button', {
            'type' : 'button',
            'title': parameters.addTitle || 'Add'
        });

        this._addButton.appendChild(ajaxDoc.createElement('i', {
            'class': 'fa fa-plus color-success'
        }));

        this._removeButton = ajaxDoc.createElement('button', {
            'type': 'button',
            'title': parameters.removeTitle || 'Remove selected'
        });

        this._removeButton.appendChild(ajaxDoc.createElement('i', {
            'class': 'fa fa-minus'
        }));

        this._clearButton = ajaxDoc.createElement('button', {
            'type': 'button',
            'title': parameters.clearTitle || 'Remove all'
        }); 

        this._clearButton.appendChild(ajaxDoc.createElement('i', {
            'class': 'fa fa-remove color-danger'
        }));

        this._parent.appendChild(this._list);

        this._buttonsWrap.appendChild(this._addButton);
        this._buttonsWrap.appendChild(this._removeButton);
        this._buttonsWrap.appendChild(this._clearButton);

        this._parent.appendChild(this._buttonsWrap);

        ajaxDoc.subscribe(this._list, 'click', 'li', funcHelper.proxy(function (event, element) {
            console.log(ajaxDoc);
            if (this.get_isEnabled()) {
                if (!ajaxDoc.hasClass(element, 'selected')) {
                    collectionHelper.forEach(this._items, function (item) { ajaxDoc.removeClass(item, 'selected'); });
                    ajaxDoc.addClass(element, 'selected');
                } else {
                    ajaxDoc.removeClass(element, 'selected');
                }
            }
        }, this));

        ajaxDoc.subscribe(this._addButton, 'click', funcHelper.proxy(function (event, element) {
            if (this.get_isEnabled()) {
                this._eventEmitter.fire('add', this);
            }
        }, this));

        ajaxDoc.subscribe(this._removeButton, 'click', funcHelper.proxy(function (event, element) {
            if (this.get_isEnabled()) {
                this._eventEmitter.fire('remove', this);
            }
        }, this));

        ajaxDoc.subscribe(this._clearButton, 'click', funcHelper.proxy(function (event, element) {
            if (this.get_isEnabled()) {
                this._eventEmitter.fire('clear', this);
            }
        }, this));

        this._initialized = true;
    }
};

Dynamicweb.Controls.CustomListBox.UnderlyingControl.prototype._validateItem = function (item) {
    var typeHelper = Dynamicweb.Utilities.TypeHelper;

    if (typeHelper.isUndefined(item) || typeHelper.isUndefined(item.value)) {
        throw 'Invalid item!';
    }
};

/* ++++++ Selector ++++++ */

Dynamicweb.Controls.CustomListBox.ListBox = function () {
    /// <summary>Represents a custom selector.</summary>
}

Dynamicweb.Controls.CustomListBox.ListBox.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.CustomListBox.ListBox.prototype.get_provider = function () {
    /// <summary>Gets select provider which executes select operation.</summary>

    return this._provider;
}

Dynamicweb.Controls.CustomListBox.ListBox.prototype.set_provider = function (value) {
    /// <summary>Registers new select provider which executes select operation.</summary>
    /// <param name="value">Provider to register.</param>

    if (Dynamicweb.Utilities.TypeHelper.isFunction(value)) {
        this._provider = value;
    } else {
        throw 'Invalid value type!';
    }
}

Dynamicweb.Controls.CustomListBox.ListBox.prototype.set_dataSource = function (value) {
    var typeHelper = Dynamicweb.Utilities.TypeHelper,
        collectionHelper = Dynamicweb.Utilities.CollectionHelper;

    if (this.get_isEnabled()) {
        if (typeHelper.isArray(value) || typeHelper.isObject(value)) {
            //validate items
            collectionHelper.forEach(value, this._validateItem, this);

            // clear the data source
            this._dataSource.length = 0;

            //add items 
            collectionHelper.forEach(value, this.addItem, this);
        } else {
            throw 'Invalid data source type!';
        }
    }
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.get_dataSource = function () {
    return Dynamicweb.Utilities.CollectionHelper.values(this._dataSource);
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.clear = function () {
    if (this.get_isEnabled()) {
        this._dataSource.length = 0;
        this.get_state().underlyingControl.clear();
    }
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.addItem = function (item) {
    var foundItem;
    if (this.get_isEnabled()) {
        this._validateItem(item);
        
        foundItem = this.find(function (i) { return Dynamicweb.Utilities.TypeHelper.compare(item, i); });

        // don't add the item if the same exists.
        if (!foundItem) {
            this._dataSource.push(item);
            this.get_state().underlyingControl.addItem(item);
        }
    }
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.removeItem = function (index) {
    var typeHelper = Dynamicweb.Utilities.TypeHelper,
        result;

    if (this.get_isEnabled()) {
        if (typeHelper.isNumber(index)) {
            result = this._dataSource[index];
            if (result) {
                this._dataSource.splice(index, 1);
                this.get_state().underlyingControl.removeItem(index);
            }
        } else {
            throw 'Invalid argument!';
        }
    }

    return result;
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.getItem = function (index) {
    var typeHelper = Dynamicweb.Utilities.TypeHelper,
        result;

    if (typeHelper.isNumber(index)) {
        result = this._dataSource[index];
    } else {
        throw 'Invalid argument!';
    }

    return result;
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.find = function (criteria) {
    if (!Dynamicweb.Utilities.TypeHelper.isFunction(criteria)) {
        throw 'Invalid argument!';
    }

    return Dynamicweb.Utilities.CollectionHelper.first(this._dataSource, criteria);
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.get_state = function () {
    var self = this,
        ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        container = self.get_container();

    if (!this._state) {
        if (container) {
            self._state = {};
            self._state.underlyingControl = new Dynamicweb.Controls.CustomListBox.UnderlyingControl();
            self._state.underlyingControl.initialize({
                parent: container,
                addTitle: this.get_terminology()['Add'],
                removeTitle: this.get_terminology()['Remove'],
                clearTitle: this.get_terminology()['Clear']
            });
            self._state.postData = ajaxDoc.find(container.parentElement, 'input[type="hidden"][name="' + this._containerID + '"]')[0];
            self._state.postData.value = '';
        }
    }

    return this._state;
}

Dynamicweb.Controls.CustomListBox.ListBox.prototype.reset = function () {

    if (this._initialized) {
        this.get_state().underlyingControl.reset();
        this.get_state().postData.value = '';
    }

    Dynamicweb.Ajax.Control.prototype.reset.call(this);
    this._dataSource = [];
    this._provider = null;
    this._state = null;
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>
    var self = this,
        submitCalls = 0,
        ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        typeHelper = Dynamicweb.Utilities.TypeHelper,
        funcHelper = Dynamicweb.Utilities.FuncHelper,
        collectionHelper = Dynamicweb.Utilities.CollectionHelper,
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

    this._binder.add_propertyChanged(propertyChangedRouter({
        'isEnabled': function (value) {
            this.get_state().underlyingControl.set_isEnabled(value);
        }
    }, this));

    this.get_state().underlyingControl.add_onAddClick(funcHelper.proxy(function () {
        if (this.get_isEnabled() && this.get_provider()) {
            submitCalls = 0;
            this.get_provider()({
                caller: this,
                callback: funcHelper.proxy(function (item) {
                    var event;

                    this._validateItem(item);
                    event = { cancel: false };
                    this.raiseEvent('valueSelecting', { sender: this, event: event, item: item });

                    if (!event.cancel) {
                        this.addItem(item);
                        this.raiseEvent('valueSelected', { sender: this, item: item });
                    }
                }, this)
            });
        }
    }, this));

    this.get_state().underlyingControl.add_onRemoveClick(funcHelper.proxy(function () {
        if (this.get_isEnabled()) {
            submitCalls = 0;
            var event = { cancel: false },
                index = this.get_state().underlyingControl.getSelectedIndex(),
                item = this.getItem(index);

            if (!item) {
                return;
            }

            this.raiseEvent('valueRemoving', { sender: this, event: event, item: item });

            if (!event.cancel) {
                this.removeItem(index);
                this.raiseEvent('valueRemoved', { sender: this, item: item });
            }
        }
    }, this));

    this.get_state().underlyingControl.add_onClearClick(funcHelper.proxy(function () {
        if (this.get_isEnabled()) {
            submitCalls = 0;
            var event = { cancel: false };

            this.raiseEvent('listClearing', { sender: this, event: event });

            if (!event.cancel) {
                this.clear();
                this.raiseEvent('listCleared', { sender: this });
            }
        }
    }, this));

    // update UI
    this._binder.notifyPropertyChanged('isEnabled', this._isEnabled);
    // handle postback event to flush data.
    var form = ajaxDoc.getElementsBySelector('form')[0];

    if (form) {
        var submit = form.onsubmit || function () { };

        form.onsubmit = funcHelper.proxy(function () {
            if (submitCalls === 0) {
                submitCalls += 1;
                this.get_state().postData.value = JSON.stringify(this.get_dataSource());
                submit();
            }
        }, this);
    }
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype._validateItem = function (item) {
    var typeHelper = Dynamicweb.Utilities.TypeHelper;

    if (typeHelper.isUndefined(item) || typeHelper.isUndefined(item.value) || typeHelper.isUndefined(item.text)) {
        throw 'Invalid item!';
    }
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.add_onItemAdding = function (callback) {
    this.addEventHandler('itemAdding', callback);
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.add_onItemAdded = function (callback) {
    this.addEventHandler('itemAdded', callback);
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.add_onItemRemoving = function (callback) {
    this.addEventHandler('itemRemoving', callback);
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.add_onItemRemoved = function (callback) {
    this.addEventHandler('itemRemoved', callback);
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.add_onListClearing = function (callback) {
    this.addEventHandler('listClearing', callback);
};

Dynamicweb.Controls.CustomListBox.ListBox.prototype.add_onListCleared = function (callback) {
    this.addEventHandler('listCleared', callback);
};

/* ++++++ End: CustomListBox ++++++ */