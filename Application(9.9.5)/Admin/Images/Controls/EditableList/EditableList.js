/* ++++++ Registering namespace ++++++ */

if (!Dynamicweb) {
    Dynamicweb = {};
}

if (!Dynamicweb.Controls) {
    Dynamicweb.Controls = {};
}

if (!Dynamicweb.Controls.EditableList) {
    Dynamicweb.Controls.EditableList = {};
}

/* ++++++++++++++++++ Helpers ++++++++++++++++++ */

Dynamicweb.Controls.EditableList.ValidationHelper = {};

Dynamicweb.Controls.EditableList.ValidationHelper.validateArgument = function (propertyName, propertyValue, validator, thisArg) {
    if (Dynamicweb.Utilities.TypeHelper.isUndefined(propertyValue) || Dynamicweb.Utilities.TypeHelper.isNull(propertyValue)) {
        throw 'Missed argument:' + propertyName;
    }

    if (validator && !validator.call(thisArg || this, propertyValue)) {
        throw 'Invalid argument:' + propertyName;
    }
};

Dynamicweb.Controls.EditableList.TemplateHelper = {};

Dynamicweb.Controls.EditableList.TemplateHelper.compile = function (template, source) {
    var result = template;
    Dynamicweb.Controls.EditableList.ValidationHelper.validateArgument('template', template, Dynamicweb.Utilities.TypeHelper.isString);
    Dynamicweb.Controls.EditableList.ValidationHelper.validateArgument('source', source, Dynamicweb.Utilities.TypeHelper.isObject);

    Dynamicweb.Utilities.CollectionHelper.forEach(source, function (value, key) {
        var reg = new RegExp('{' + key + '}', 'gi');
        result = result.replace(reg, value.toString());
    });

    return result;
};

Dynamicweb.Controls.EditableList.EventHelper = {};

Dynamicweb.Controls.EditableList.EventHelper.action = function (options, thisArg) {
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

/* ++++++++++++++++++ Enums ++++++++++++++++++ */

Dynamicweb.Controls.EditableList.Enums = {};

Dynamicweb.Controls.EditableList.Enums.EventType = {
    ROW_CREATING: 'ROW_CREATING',
    ROW_CREATED: 'ROW_CREATED',
    ROW_UPDATING: 'ROW_UPDATING',
    ROW_UPDATED: 'ROW_UPDATED',
    ROW_DELETING: 'ROW_DELETING',
    ROW_DELETED: 'ROW_DELETED',
    DIALOG_OPENING: 'DIALOG_OPENING',
    DIALOG_OPENED: 'DIALOG_OPENED',
    EDIT_DATA_BINDING: 'EDIT_DATA_BINDING',
    EDIT_DATA_BINDED: 'EDIT_DATA_BINDED'
};

Dynamicweb.Controls.EditableList.Enums.ModelState = {
    CLEAN: 'Clean',
    DELETED: 'Deleted',
    DIRTY: 'Dirty',
    NEW: 'New'
};

Dynamicweb.Controls.EditableList.Enums.ModelEvent = {
    PROPERTY_CHANGED: 'PROPERTY_CHANGED',
    STATE_CHANGED: 'STATE_CHANGED'
};

/* ++++++++++++++++++ Table ++++++++++++++++++ */

Dynamicweb.Controls.EditableList.Dropdown = function () {
    var _self = this,
        _id = null,
        _initialized = false,
        _parent = null,
        _container = null,
        _button = null,
        _menu = null,
        _options = new Dynamicweb.Utilities.Dictionary(),
        _isOpened = false,
        _isVisible = true,
        _toString = String.prototype.toString,
        _collHelper = Dynamicweb.Utilities.CollectionHelper,
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        _validationHelper = Dynamicweb.Controls.EditableList.ValidationHelper,
        _funcHelper = Dynamicweb.Utilities.FuncHelper,
        _eventEmitter = new Dynamicweb.Utilities.EventEmitter(),
        _eventNames = {
            'opened': 'opened',
            'closed' : 'closed',
            'clicked': 'clicked'
        };

    function createOption(option) {
        var el = null, text = null;
        _validationHelper.validateArgument("option", option, _typeHelper.isObject);
        _validationHelper.validateArgument("option", option, function (v) { return !_typeHelper.isEmpty(v); });
        _validationHelper.validateArgument("option.text", option.text, _typeHelper.isString);
        _validationHelper.validateArgument("option.id", option.id, function (v) { return _typeHelper.isString(v) || _typeHelper.isNumber(v); });

        el = _ajaxDoc.createElement('li', option.attributes || {});
        _ajaxDoc.attribute(el, 'data-id', option.id);

        if (option.class) {
            _ajaxDoc.addClass(el, option.class);
        }

        el.appendChild(_ajaxDoc.createElement('span'));

        text = _ajaxDoc.createElement('a', {
            'href': '#'
        });

        text.appendChild(document.createTextNode(option.text));
        el.appendChild(text);

        return el;
    }

    function findOption(id) {
        return _options.get(_toString.call(id));
    }

    function close() {
        _ajaxDoc.removeClass(_menu, 'opened');
        _ajaxDoc.unsubscribe(document, 'click', listener);
        _isOpened = false;
        _eventEmitter.fire(_eventNames.closed, { sender: this });
    }

    function open() {
        _ajaxDoc.addClass(_menu, 'opened');
        if (_menu.offsetParent.offsetLeft + _menu.offsetLeft < 0) {
            _menu.style.left = (_menu.offsetLeft + _menu.offsetWidth - _menu.offsetParent.offsetLeft) + "px";
        }

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

    function getParent(element) {
        var el = null,
            selector = 'editable-list-dropdown',
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

            if (!parent || parent !== _container) {
                close();
            }
        }
    }

    _self.initialize = function (param) {
        var html = '', text = null;
        if (!_initialized) {
            _validationHelper.validateArgument("param", param, _typeHelper.isObject);
            _validationHelper.validateArgument("param", param, function (v) { return !_typeHelper.isEmpty(v); });
            _validationHelper.validateArgument("param.parent", param.parent, _typeHelper.isElement);

            _id = param.id;
            _parent = param.parent;
            _isVisible = _typeHelper.isUndefined(param.isVisible) ? true : param.isVisible;

            // container
            _container = _ajaxDoc.createElement('div', {
                'class': 'editable-list-dropdown' + (_isVisible ? '' : ' hidden')
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
            _menu = _ajaxDoc.createElement('ul');

            if (param.options) {
                _collHelper.forEach(param.options, function (option) {
                    _self.add_option(option);
                });
            }

            //register event handlers
            _ajaxDoc.subscribe(_button, 'click', toggle);
            _ajaxDoc.subscribe(_menu, 'click', 'li', function (event, element) {
                var id = _ajaxDoc.attribute(element, 'data-id');

                close();

                if (id && _options.containsKey(id)) {
                    _eventEmitter.fire(_eventNames.clicked, { sender: _self, element: element, id: id});
                }
            });

            _container.appendChild(_button);
            _container.appendChild(_menu);
            _parent.appendChild(_container);

            _initialized = true;
        }
    };

    _self.get_id = function () {
        return _id;
    };

    _self.get_isOpened = function () {
        return _isOpened;
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

    _self.add_option = function (option) {
        var el = createOption(option);

        _options.add(_toString.call(option.id), option.id);
        _menu.appendChild(el);
    };

    _self.remove_option = function (id) {
        var option = findOption(id);
        
        if (option) {
            _options.remove(id);
            _menu.removeChild(option);
        }
    };

    _self.clear = function () {
        _options.forEach(this.remove_option, this);
        _options.clear();
    };

    _self.add_opened = function (handler) {
        _eventEmitter.on(_eventNames.opened, handler);
    };

    _self.remove_opened = function (handler) {
        _eventEmitter.off(_eventNames.opened, handler);
    };

    _self.add_closed = function (handler) {
        _eventEmitter.on(_eventNames.closed, handler);
    };

    _self.remove_closed = function (handler) {
        _eventEmitter.off(_eventNames.closed, handler);
    };

    _self.add_clicked = function (handler) {
        _eventEmitter.on(_eventNames.clicked, handler);
    };

    _self.remove_clicked = function (handler) {
        _eventEmitter.off(_eventNames.clicked, handler);
    };
};

Dynamicweb.Controls.EditableList.Table = function () {
    var _self = this,
        _allowEditing = true,
        _allowAddNewRow = true,
        _addNewRowCaption = 'Click here to add a new row',
        _allowSorting = false,
        _allowDeleteRow = true,
        _deleteColumnCaption = 'Delete',
        _parent = null,
        _container = null,
        _table = null,
        _header = null,
        _headerRow = null,
        _body = null,
        _delBtnHeaderColumn = null,
        _delBtnColumn = null,
        _addNewRow = null,
        _metadata = new Dynamicweb.Utilities.Dictionary(),
        _columns = new Dynamicweb.Utilities.Dictionary(),
        _rows = new Dynamicweb.Utilities.Dictionary(),
        _binder = null,
        _eventEmitter = new Dynamicweb.Utilities.EventEmitter(),
        _initialized = false,
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _eventNames = {
            'row': 'row',
            'column': 'column',
            'new': 'new',
            'delete': 'delete',
            'sorting': 'sorting'
        };

    function createColumn(metadata) {
        var td,
            container,
            text,
            style = '',
            cellOptions = metadata.cellOptions,
            isButton = _typeHelper.isUndefined(metadata.editorMetadata),
            dropdown = null;

        td = _ajaxDoc.createElement('td', {
            'class': 'editable-list-cell' + (isButton ? ' editable-list-button column-button' : ''),
            'id': metadata.name
        });

        if (!_typeHelper.isEmpty(cellOptions.width)) {
            style += ' width:' + cellOptions.width + '; ';
        }

        if (!_typeHelper.isEmpty(cellOptions.height)) {
            style += ' height:' + cellOptions.height + '; ';
        }

        if (cellOptions.visible === false) {
            style += ' display: none; ';
        }

        if (style) {
            _ajaxDoc.attribute(td, 'style', style);
        }

        container = _ajaxDoc.createElement('div');
        container.appendChild(_ajaxDoc.createElement('span', {'class' : 'separator'}));

        text = _ajaxDoc.createElement('span');
        text.appendChild(document.createTextNode(cellOptions.caption));
        container.appendChild(text);

        if (!isButton) {
            dropdown = new Dynamicweb.Controls.EditableList.Dropdown();
            dropdown.initialize({
                'parent' : container,
                'id': metadata.name,
                'class' : 'sorting',
                'options': [
                    {
                        'id': 'sorting-ascending',
                        'text': 'Sort ascending',
                        'class': 'sorting-ascending'
                    },
                    {
                        'id': 'sorting-descending',
                        'text': 'Sort descending',
                        'class': 'sorting-descending'
                    }
                ],
                'isVisible': _allowSorting
            });

            dropdown.add_clicked(function (eventName, args) {
                var id = args.id,
                    element = args.element,
                    direction = '',
                    column = '';

                if (id === 'sorting-descending') {
                    direction = 'descending';
                } else if (id === 'sorting-ascending') {
                    direction = 'ascending';
                }

                column = args.sender.get_id();

                if (column && direction) {
                    _eventEmitter.fire(_eventNames.sorting, { sender: _self, direction: direction, column: column });
                }
            });
        }

        td.appendChild(container);

        return td;
    }

    function createRow(model) {
        var tr,
        td,
        span,
        tdStyle = '',
        spanStyle = '',
        cellStyle,
        attributes,
        value,
        imageUrl;

        tr = _ajaxDoc.createElement('tr', {
            'data-model-id': model.get_id(),
            'class': 'editable-list-row editable-list-data'
        });

        _metadata.forEach(function (columnMetadata) {
            if (columnMetadata) {
                style = '';
                value = '',
                imageUrl = '',
                cellOptions = columnMetadata.cellOptions;
                isButton = _typeHelper.isUndefined(columnMetadata.editorMetadata),
                css = isButton ? 'editable-list-button column-button' : 'editable-list-data' ;

                td = _ajaxDoc.createElement('td', {
                    'class': 'editable-list-cell ' + css,
                    'data-model-id': model.get_id(),
                    'data-column-id': columnMetadata.name
                });

                span = _ajaxDoc.createElement('span');

                if (_typeHelper.isObject(cellOptions)) {
                    if (cellOptions.cssClass) {
                        _ajaxDoc.attribute(td, 'class', cellOptions.cssClass);
                    }

                    if (cellOptions.horizontalAlign && cellOptions.horizontalAlign !== 'NotSet') {
                        _ajaxDoc.attribute(td, 'align', cellOptions.horizontalAlign);
                    }

                    if (cellOptions.verticalAlign && cellOptions.verticalAlign !== 'NotSet') {
                        _ajaxDoc.attribute(td, 'valign', cellOptions.verticalAlign);
                    }

                    if (_typeHelper.isObject(cellOptions.backgroundImage)) {
                        if (_typeHelper.isFunction(cellOptions.backgroundImage.imageExpressionCompiled)) {
                            imageUrl = cellOptions.backgroundImage.imageExpressionCompiled(model);
                        } else if (_typeHelper.isString(cellOptions.backgroundImage.imageUrl)) {
                            imageUrl = cellOptions.backgroundImage.imageUrl;
                        }

                        if (imageUrl) {
                            style = ' background-image: url("' + imageUrl + '"); ';
                            style += ' display:block; ';

                            if (cellOptions.backgroundImage.repeat) {
                                style += ' background-repeat:' + cellOptions.backgroundImage.repeat + '; ';
                            }

                            if (cellOptions.backgroundImage.position) {
                                style += ' background-position:' + cellOptions.backgroundImage.position + '; ';
                            }

                            _ajaxDoc.attribute(span, 'style', style);
                        }
                    } else {
                        _ajaxDoc.addClass(span, 'no-image');

                        if (isButton) {
                            span.innerHTML = cellOptions.caption || columnMetadata.name;
                        }
                    }

                    style = '';

                    if (cellOptions.height) {
                        style += ' height:' + cellOptions.height + '; ';
                    }

                    if (cellOptions.width) {
                        style += ' width:' + cellOptions.width + '; ';
                    }

                    if (cellOptions.visible === false) {
                        style += ' display: none; ';
                    }

                    if (style) {
                        _ajaxDoc.attribute(td, 'style', style);
                    }
                }

                if (!isButton) {
                    value = model.get_propertyValue(columnMetadata.name);

                    if (columnMetadata.editor) {
                        span.innerHTML = columnMetadata.editor.format(typeof (value) == "undefined" || value == null ? columnMetadata.defaultValue : value);
                    }
                }
                
                td.appendChild(span);
                tr.appendChild(td);
            }
        }, _self);

        // delete button
        if (_delBtnColumn) {
            td = _ajaxDoc.clone(_delBtnColumn, true);
            _ajaxDoc.attribute(td, 'data-model-id', model.get_id());
            tr.appendChild(td);

            if (!_self.get_allowEditing()) {
                _ajaxDoc.hide(td);
            }
        }

        return tr;
    }

    _self.initialize = function (params) {
        var html,
            element,
            updateNewRow,
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

        if (!_initialized) {
            _parent = params.parent || document;

            if (_typeHelper.isBoolean(params.allowEditing)) {
                _allowEditing = params.allowEditing;
            }
            if (_typeHelper.isBoolean(params.allowAddNewRow)) {
                _allowAddNewRow = params.allowAddNewRow;
            }
            if (_typeHelper.isString(params.addNewRowCaption)) {
                _addNewRowCaption = params.addNewRowCaption
            }
            if (_typeHelper.isBoolean(params.allowDeleteRow)) {
                _allowDeleteRow = params.allowDeleteRow;
            }

            if (_typeHelper.isBoolean(params.allowSorting)) {
                _allowSorting = params.allowSorting;
            }

            if (_typeHelper.isString(params.deleteColumnCaption)) {
                _deleteColumnCaption = params.deleteColumnCaption;
            }
            _header = _ajaxDoc.createElement('thead');
            _headerRow = _ajaxDoc.createElement('tr', {
                'class': 'editable-list-row editable-list-header'
            });
            if (params.personalize) {
                var associatedControlId = _parent.id;
                _headerRow.on("contextmenu", function (e) {
                    e.preventDefault();
                    return ContextMenu.show(e, "ColumnSelector:" + associatedControlId, null, null, 'BottomRightRelative', _headerRow);
                });
            }

            if (_allowDeleteRow) {
                _delBtnColumn = _ajaxDoc.createElement('td', {
                    'class': 'editable-list-cell delete-button text-right p-5'
                });
                _delBtnColumn.innerHTML = '<a class="btn btn-link" href="javascript:void(0);"><i class="fa fa-remove color-danger"></i></a>';

                _delBtnHeaderColumn = _ajaxDoc.createElement('td', {
                    'class': 'editable-list-cell editable-list-button delete-button'
                });
                html = '<div>';
                html += '<span class="separator"></span>';
                html += '<span>';
                html += (_deleteColumnCaption || 'Delete');
                html += '</span>';
                html += '</div>';
                _delBtnHeaderColumn.innerHTML = html;
                _headerRow.appendChild(_delBtnHeaderColumn);
            }
            _header.appendChild(_headerRow);

            _addNewRow = _ajaxDoc.createElement('tr', {
                'class': 'editable-list-row editable-list-button add-button text-center'
            });
            _addNewRowColumn = _ajaxDoc.createElement('td', {
                'colspan': _metadata.count() + _delBtnHeaderColumn ? 1 : 0 //edit button header
            });
            _addNewRowColumn.innerHTML = '<button type="button" class="btn btn-flat"><i class="fa fa-plus-square color-success"></i> ' +_addNewRowCaption + '</button>';
            _addNewRow.appendChild(_addNewRowColumn);

            _body = _ajaxDoc.createElement('tbody', {
                'class': 'editable-list-body'
            });
            _body.appendChild(_addNewRow);

            _table = _ajaxDoc.createElement('table', {
                'cellspacing': 0,
                'class': 'editable-list'
            });
            _table.appendChild(_header);
            _table.appendChild(_body);

            _container = _ajaxDoc.createElement('div', {
                'class': 'editable-list-container'
            });

            _container.appendChild(_table);

            _observable = new Dynamicweb.Observable(_self);

            // Bind properties to UI
            updateNewRow = function (sender, args) {
                var td;

                td = _addNewRowColumn;
                _ajaxDoc.attribute(td, 'colspan', (_metadata.count() + 1));
            };

            _observable.add_methodCalled(methodCalledRouter({
                'addColumn': updateNewRow,
                'removeColumn': updateNewRow,
                'removeAllColumns': updateNewRow
            }, _self));

            _observable.add_propertyChanged(propertyChangedRouter({
                'allowEditing': function (value) {
                    var action;

                    if (value) {
                        action = _ajaxDoc.show;
                    } else {
                        action = _ajaxDoc.hide;
                    }

                    action.call(_ajaxDoc, _addNewRow);
                    if (_delBtnHeaderColumn) {
                        action.call(_ajaxDoc, _delBtnHeaderColumn);
                    }

                    _rows.forEach(function (row) {
                        var deleteButton = _ajaxDoc.find(row, 'td.delete-button')[0];

                        if (deleteButton) {
                            action.call(_ajaxDoc, deleteButton);
                        }
                    });
                },
                'allowSorting': function (value) { },
                'allowAddNewRow': function (value) {
                    var action;
                    if (value) {
                        action = _ajaxDoc.show;
                    } else {
                        action = _ajaxDoc.hide;
                    }
                    action.call(_ajaxDoc, _addNewRow);                    
                }
            }, _self));

            _observable.notifyPropertyChanged('editing', _self.get_allowEditing());

            _observable.notifyPropertyChanged('addNewRow', _self.get_allowAddNewRow());

            // Bind UI events
            _ajaxDoc.subscribe(_table, 'click', 'tr.add-button', function (event, element) {
                _eventEmitter.fire(_eventNames.new, element);
            });

            _ajaxDoc.subscribe(_table, 'click', 'td.delete-button', function (event, element) {
                _eventEmitter.fire(_eventNames.delete, _ajaxDoc.attribute(element, 'data-model-id'));
            });

            _ajaxDoc.subscribe(_table, 'click', 'td.column-button', function (event, element) {
                var args = {
                    sender: _self,
                    row: _ajaxDoc.attribute(element, 'data-model-id'),
                    column: _ajaxDoc.attribute(element, 'data-column-id')
                };

                _eventEmitter.fire(_eventNames.column, args);
            });

            _ajaxDoc.subscribe(_table, 'click', 'td.editable-list-data', function (event, element) {
                _eventEmitter.fire(_eventNames.row, _ajaxDoc.attribute(element, 'data-model-id'));
            });

            _parent.appendChild(_container);
            _initialized = true;
        }
    };

    _self.get_container = function () {
        return _table;
    };

    _self.get_allowEditing = function () {
        return _allowEditing;
    };

    _self.set_allowEditing = function (value) {
        _allowEditing = value;
    };

    _self.get_deleteColumnCaption = function () {
        return _deleteColumnCaption;
    };

    _self.set_deleteColumnCaption = function (value) {
        _deleteColumnCaption = value;
    };

    _self.get_allowAddNewRow = function () {
        return _allowAddNewRow;
    };

    _self.set_allowAddNewRow = function (value) {
        _allowAddNewRow = value;
    };

    _self.get_addNewRowCaption = function () {
        return _addNewRowCaption;
    }

    _self.set_addNewRowCaption = function (value) {
        _addNewRowCaption = value;
    }

    _self.get_allowSorting = function () {
        return _allowSorting;
    };

    _self.set_allowSorting = function (value) {
        _allowSorting = value;
    };

    _self.get_columnCount = function () {
        return _columns.count();
    };

    _self.get_rowCount = function () {
        return _rows.count();
    };

    _self.addColumn = function (metadata) {
        var td;

        if (_typeHelper.isEmpty(metadata)) {
            throw 'Invalid column metadata!';
        }

        if (_metadata.containsKey(metadata.name) || _columns.containsKey(metadata.name)) {
            throw 'Column with specified name already exists!';
        }

        td = createColumn(metadata);

        _metadata.add(metadata.name, metadata);
        _columns.add(metadata.name, td);
        if (_delBtnHeaderColumn) {
            _headerRow.insertBefore(td, _delBtnHeaderColumn);
        } else {
            _headerRow.appendChild(td);
        }
        
    };

    _self.addRow = function (model) {
        var tr;

        if (_typeHelper.isUndefined(model)) {
            throw 'Missed model!';
        }

        if (_rows.containsKey(model.get_id())) {
            throw 'Row with specified id already exists!';
        }

        tr = createRow(model);

        _rows.add(model.get_id(), tr);
        _body.insertBefore(tr, _addNewRow);
    };

    _self.updateRow = function (model) {
        var oldRow, newRow;

        if (_typeHelper.isUndefined(model)) {
            throw 'Missed model!';
        }

        if (!_rows.containsKey(model.get_id())) {
            throw 'Row with specified id does not exist!';
        }

        newRow = createRow(model);
        oldRow = _rows.get(model.get_id());

        _rows.remove(model.get_id());
        _rows.add(model.get_id(), newRow);

        _body.replaceChild(newRow, oldRow);
        if (model.hidden) {
            newRow.style.display = "none";
        } else {
            newRow.style.display = "";
        }
    };

    _self.updateColumn = function (metadata) {
        var oldColumn, newColumn;

        if (_typeHelper.isEmpty(metadata)) {
            throw 'Invalid column metadata!';
        }

        if (!_metadata.containsKey(metadata.name) || !_columns.containsKey(metadata.name)) {
            throw 'Column with specified name does not exist!';
        }

        newColumn = createColumn(metadata);
        oldColumn = _columns.get(metadata.name);

        _columns.remove(metadata.name);
        _columns.add(metadata.name, newColumn);

        _metadata.remove(metadata.name);
        _metadata.add(metadata.name, metadata);

        _headerRow.replaceChild(newColumn, oldColumn);
    };

    _self.removeColumn = function (column) {
        var id;

        if (_typeHelper.isString(column)) {
            id = column;
        } else if (_typeHelper.isElement(column)) {
            id = _ajaxDoc.attribute(column, 'id');
        } else {
            throw 'Invalid column type!';
        }

        if (!id) {
            throw 'Invalid column id!';
        }

        if (!_columns.containsKey(id) || !_columns.containsKey(id)) {
            throw 'Column does not exist!';
        }

        column = _columns.get(id);
        _metadata.remove(id);
        _columns.remove(id);
        _headerRow.removeChild(column);
    };

    _self.removeRow = function (model) {
        var id,
            row;

        if (_typeHelper.isObject(model) && _typeHelper.isFunction(model.get_id)) {
            id = model.get_id();
        } else if (_typeHelper.isString(model)) {
            id = model;
        } else if (_typeHelper.isElement(model)) {
            id = _ajaxDoc.attribute(model, 'data-model-id');
        } else {
            throw 'Invalid argument!';
        }

        Dynamicweb.Controls.EditableList.ValidationHelper.validateArgument('id', id);

        if (!_rows.containsKey(id)) {
            throw 'Row does not exist!';
        }

        row = _rows.get(id);

        Dynamicweb.Controls.EditableList.ValidationHelper.validateArgument('element', row);

        _rows.remove(id);
        _body.removeChild(row);
    };

    _self.removeAllColumns = function () {
        _columns.forEach(function (column) {
            _headerRow.removeChild(column);
        }, _self);

        _metadata.clear();
        _columns.clear();
    };

    _self.removeAllRows = function () {
        _rows.forEach(function (row) {
            _body.removeChild(row);
        }, _self);

        _rows.clear();
    };

    _self.calculateHeightInfo = function (callback, thisArg) {
        var chain = new Dynamicweb.Utilities.TimeoutChain(),
            interval = 50,
            result = { tableHeaderRow: 0, tableDataRow: 0, tableAddNewRowButton: 0 },
            dataRow;

        chain.add(function () {
            if (_headerRow) {
                result.tableHeaderRow = parseFloat(_ajaxDoc.height(_headerRow));
            }

            if (_addNewRow) {
                result.tableAddNewRowButton = parseFloat(_ajaxDoc.height(_addNewRow));
            }

            dataRow = createRow(new Dynamicweb.Controls.EditableList.Model('_row_height_', {}));
            _ajaxDoc.hide(dataRow);
            _body.insertBefore(dataRow, _addNewRow);

        }, interval);

        chain.add(function () {            
            if (dataRow) {
                result.tableDataRow = parseFloat(_ajaxDoc.height(dataRow));
                _body.removeChild(dataRow);
            }
        }, interval);

        chain.add(function () {
            if (callback) {
                callback.call(thisArg || this, result);
            }
        }, interval);

        chain.start();
    };

    _self.add_deleteButtonClicked = function (handler) {
        _eventEmitter.on(_eventNames.delete, handler);
    };

    _self.remove_deleteButtonClicked = function (handler) {
        _eventEmitter.off(_eventNames.delete, handler);
    };

    _self.add_columnButtonClicked = function (handler) {
        _eventEmitter.on(_eventNames.column, handler);
    };

    _self.remove_columnButtonClicked = function (handler) {
        _eventEmitter.off(_eventNames.column, handler);
    };

    _self.add_columnSortClicked = function (handler) {
        _eventEmitter.on(_eventNames.sorting, handler);
    };

    _self.remove_columnSortClicked = function (handler) {
        _eventEmitter.off(_eventNames.sorting, handler);
    };

    _self.add_rowClicked = function (handler) {
        _eventEmitter.on(_eventNames.row, handler);
    };

    _self.remove_rowClicked = function (handler) {
        _eventEmitter.off(_eventNames.row, handler);
    };

    _self.add_newRowButtonClicked = function (handler) {
        _eventEmitter.on(_eventNames.new, handler);
    };

    _self.remove_newRowButtonClicked = function (handler) {
        _eventEmitter.off(_eventNames.new, handler);
    };
};

Dynamicweb.Controls.EditableList.Pager = function () {
    var _self = this,
        _initialized = false,
        _parent,
        _container,
        _ctlText,
        _btnToBegin,
        _btnToPrev,
        _btnToNext,
        _btnToEnd,
        _text = 'Page {current} of {end}',
        _current = 1,
        _end = 1,
        _binder,
        _isVisible = true,
        _eventEmitter = new Dynamicweb.Utilities.EventEmitter(),
        _funcHelper = Dynamicweb.Utilities.FuncHelper,
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        _validationHelper = Dynamicweb.Controls.EditableList.ValidationHelper;

    function fireClickEvent() {
        _eventEmitter.fire('clicked', { sender: _self, current: _self.get_current(), end: _self.get_end() });
    }

    function toggle(disabled, element) {
        if (!disabled) {
            _ajaxDoc.addClass(element, 'disabled');
        } else {
            _ajaxDoc.removeClass(element, 'disabled');
        }
    }
    _self.fireClickEvent = fireClickEvent;
    _self.initialize = function (params) {
        if (!_initialized) {
            if (!params) {
                throw 'Missed parameters!';
            }

            if (!_typeHelper.isElement(params.parent)) {
                throw 'Invalid parent!';
            }

            _parent = params.parent;

            _container = _ajaxDoc.createElement('div', { 'class': 'footer-controls editable-list-pager' + (_self.get_end() == 1 ? ' hidden' : '') });

            _ctlText = _ajaxDoc.createElement('span', { 'class': 'footer-label pager-label' });

            _btnToBegin = _ajaxDoc.createElement('i', {
                'class': 'editable-list-button fa fa-angle-double-left',
                'data-role': 'pager',
                'data-action': 'toBegin',
            });

            _btnToPrev = _ajaxDoc.createElement('i', {
                'class': 'editable-list-button fa fa-angle-left',
                'data-role': 'pager',
                'data-action': 'toPrev',
                'src': '/Admin/Images/Ribbon/UI/List/navigate_left.png'
            });

            _btnToNext = _ajaxDoc.createElement('i', {
                'class': 'editable-list-button fa fa-angle-right',
                'data-role': 'pager',
                'data-action': 'toNext',
            });

            _btnToEnd = _ajaxDoc.createElement('i', {
                'class': 'editable-list-button fa fa-angle-double-right',
                'data-role': 'pager',
                'data-action': 'toEnd',
            });

            _container.appendChild(_btnToBegin);
            _container.appendChild(_btnToPrev);
            _container.appendChild(_ctlText);
            _container.appendChild(_btnToNext);
            _container.appendChild(_btnToEnd);

            _binder = new Dynamicweb.UIBinder(_self);

            // Binds properties to UI
            _binder.bindProperty('text', [{
                elements: [],
                action: function (sender, args) {
                    args.target.refresh();
                }
            }]);

            _binder.bindProperty('current', [{
                elements: [],
                action: function (sender, args) {
                    args.target.refresh();
                }
            }]);

            _binder.bindProperty('end', [{
                elements: [],
                action: function (sender, args) {
                    args.target.refresh();
                }
            }]);

            _binder.bindProperty('isVisible', [{
                elements: [],
                action: function (sender, args) {
                    var self = args.target,
                        currentValue = self.get_isVisible();

                    if (currentValue) {
                        _ajaxDoc.show(_container);
                    } else {
                        _ajaxDoc.hide(_container);
                    }
                }
            }]);

            // Binds UI to properties
            _ajaxDoc.subscribe(_btnToBegin, 'click', _funcHelper.proxy(function () {
                if (this.get_current() === 1) {
                    return;
                }

                this.set_current(1);
                fireClickEvent();
            }, _self));

            _ajaxDoc.subscribe(_btnToPrev, 'click', _funcHelper.proxy(function () {
                if (this.get_current() === 1) {
                    return;
                }

                this.set_current(this.get_current() - 1);
                fireClickEvent();
            }, _self));

            _ajaxDoc.subscribe(_btnToNext, 'click', _funcHelper.proxy(function () {
                if (this.get_current() === this.get_end()) {
                    return;
                }

                this.set_current(this.get_current() + 1);
                fireClickEvent();
            }, _self));

            _ajaxDoc.subscribe(_btnToEnd, 'click', _funcHelper.proxy(function () {
                if (this.get_current() === this.get_end()) {
                    return;
                }

                this.set_current(this.get_end());
                fireClickEvent();
            }, _self));

            _parent.appendChild(_container);

            _self.set_isVisible(!!params.isVisible);
            _self.refresh();

            _initialized = true;
        }
    };

    _self.get_text = function () {
        return _text;
    };

    _self.set_text = function (value) {
        _validationHelper.validateArgument('text', value, _typeHelper.isString);
        _text = value;
    };

    _self.get_current = function (value) {
        return _current;
    };

    _self.set_current = function (value) {
        _validationHelper.validateArgument('current', value, function (propertyValue) {
            return _typeHelper.isNumber(propertyValue) && propertyValue > 0 && propertyValue <= _end;
        }, _self);

        _current = value;
    };

    _self.get_end = function () {
        return _end;
    };

    _self.set_end = function (value) {
        _validationHelper.validateArgument('end', value, function (propertyValue) {
            return _typeHelper.isNumber(propertyValue) && propertyValue > 0 && propertyValue >= _current;
        }, _self);

        _end = value;
    };

    _self.get_isVisible = function () {
        return _isVisible;
    };

    _self.set_isVisible = function (value) {
        _validationHelper.validateArgument('isVisible', value, _typeHelper.isBoolean);
        _isVisible = value;
    };

    _self.refresh = function () {
        /// <summary>Updates buttons state.</summary>
        var end = _self.get_end();
        var current = _self.get_current();
        var pagerIsVisible = _self.get_isVisible();

        _ctlText.innerHTML = Dynamicweb.Controls.EditableList.TemplateHelper.compile(_self.get_text(), {
            'current': current,
            'end': end
        });

        if (pagerIsVisible) {
            if (end === 1) {
                _ajaxDoc.hide(_container);
                
            } else {
                _ajaxDoc.show(_container);
            }
        }

        if (end === 1) {
            toggle(false, _btnToBegin);
            toggle(false, _btnToPrev);
            toggle(false, _btnToNext);
            toggle(false, _btnToEnd);
        } else if (current === 1) {
            toggle(false, _btnToBegin);
            toggle(false, _btnToPrev);
            toggle(true, _btnToNext);
            toggle(true, _btnToEnd);
        } else if (current === end) {
            toggle(true, _btnToBegin);
            toggle(true, _btnToPrev);
            toggle(false, _btnToNext);
            toggle(false, _btnToEnd);
        } else {
            toggle(true, _btnToBegin);
            toggle(true, _btnToPrev);
            toggle(true, _btnToNext);
            toggle(true, _btnToEnd);
        }
    };

    _self.add_buttonClicked = function (handler) {
        _eventEmitter.on('clicked', handler);
    };

    _self.remove_buttonClicked = function (handler) {
        _eventEmitter.off('clicked', handler);
    };
};

Dynamicweb.Controls.EditableList.Header = function () {
    var self = this;
    var parent = null;
    var container = null;
    var initialized = false;
    var typeHelper = Dynamicweb.Utilities.TypeHelper;
    var ajaxDoc = Dynamicweb.Ajax.Document.get_current();
    var filters = [];
    var query = null;
    self.initialize = function (params) {
        if (!initialized) {
            if (!params) {
                throw 'Missed parameters!';
            }
            parent = params.parent;
            var cols = parent.get_columns();
            var filterableColumns = Dynamicweb.Utilities.CollectionHelper.where(cols, function (col, idx) {
                return col.filterable;
            });
            if (filterableColumns.length > 0) {
                container = ajaxDoc.getElementById("editable-list-filters-" + parent.get_associatedControlID());
                var filtersCnt = ajaxDoc.find(container, ".filters-area")[0];
                var filterCollapseMarker = ajaxDoc.find(container, ".collapseFiltersCell > i")[0];
                filterCollapseMarker.title = parent.get_terminology()["ShowFilterArea"];
                var time = 0.4;
                var listControlEl = ajaxDoc.getElementById(parent.get_associatedControlID());
                filterCollapseMarker.on("click", function () {
                    ajaxDoc.addClass(listControlEl, "animation");
                    if (filtersCnt.style.display == 'none') {
                        // Uncollapse
                        Effect.BlindDown(filtersCnt, { duration: time });
                        setTimeout(function () {
                            ajaxDoc.attribute(filterCollapseMarker, 'class', ajaxDoc.attribute(filterCollapseMarker, 'data-up'));
                            filterCollapseMarker.title = parent.get_terminology()["HideFilterArea"];
                            parent._binder.notifyPropertyChanged('filter.AreaCollapse', false);
                            ajaxDoc.removeClass(listControlEl, "animation");
                        }, time * 1000);
                    } else {
                        // Collapse
                        Effect.BlindUp(filtersCnt, { duration: time });
                        setTimeout(function () {
                            ajaxDoc.attribute(filterCollapseMarker, 'class', ajaxDoc.attribute(filterCollapseMarker, 'data-down'));
                            filterCollapseMarker.title = parent.get_terminology()["ShowFilterArea"];
                            parent._binder.notifyPropertyChanged('filter.AreaCollapse', true);
                            ajaxDoc.removeClass(listControlEl, "animation");
                        }, time * 1000);
                    }
                });

                Dynamicweb.Utilities.CollectionHelper.forEach(filterableColumns, function (col, idx) {
                    var obj = {
                        name: col.name,
                        editorMetadata: {},
                        editor: null
                    }
                    typeHelper.extend(obj.editorMetadata, col.editorMetadata);
                    obj.editorMetadata.id = "Filter" + obj.editorMetadata.id;
                    obj.editorMetadata.clientID = "Filter" + obj.editorMetadata.clientID;
                    obj.editorMetadata.uniqueID = "Filter" + obj.editorMetadata.uniqueID;
                    if (obj.editorMetadata.filterOptions) {
                        if (obj.editorMetadata.filterOptions.length > 0) {
                            obj.editorMetadata.options = obj.editorMetadata.filterOptions;
                        }
                        delete obj.editorMetadata.filterOptions;
                    }
                    filters.push(obj);
                    obj.editor = Dynamicweb.Controls.EditableList.Editors.get_editor(obj.editorMetadata);
                    obj.filterResetValue = obj.editor.get_value();
                });

                if (filters.length) {
                    var applyBtnEl = ajaxDoc.find(container, ".filter-apply")[0];
                    applyBtnEl.on("click", function (e) {
                        e.preventDefault();
                        var filterQueryObj = null;
                        filters.forEach(function (f) {
                            var value = null;
                            if (f.editorMetadata.editorTypeName == "UserEditor") {
                                value = f.editor.get_value();
                                if (!value.value) {
                                    return null;
                                }
                            } else {
                                value = f.editor.get_value();
                                if (value == "0") {
                                    return null;
                                }
                            }
                            if (value) {
                                filterQueryObj = filterQueryObj || {};
                                filterQueryObj[f.name] = value;
                            }
                        }, self);
                        self.query = filterQueryObj;
                        parent._binder.notifyPropertyChanged('filter.query', self.query);
                    });

                    var resetBtnEl = ajaxDoc.find(container, ".filter-reset")[0];
                    resetBtnEl.on("click", function (e) {
                        e.preventDefault();
                        filters.forEach(function (f) {
                            f.editor.set_value(f.filterResetValue);
                        });
                        self.query = null;
                        parent._binder.notifyPropertyChanged('filter.query', self.query);
                    });

                }
            }

            initialized = true;
        }
    };

    self.get_container = function () {
        return container;
    };

    self.get_width = function () {
        return ajaxDoc.width(self.get_container());
    };

    self.set_width = function (value) {
        ajaxDoc.width(self.get_container(), value);
    };


    self.calculateHeightInfo = function (callback, thisArg) {
        setTimeout(function () {
            var result = { header: 0 };
            var container = self.get_container();

            if (container) {
                result.header = parseFloat(ajaxDoc.height(container));
            }

            if (callback) {
                callback.call(thisArg || this, result);
            }
        }, 50);
    };
};

Dynamicweb.Controls.EditableList.Footer = function () {
    var _self = this,
        _parent,
        _container,
        _pager = new Dynamicweb.Controls.EditableList.Pager(),
        _initialized = false,
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current();

    _self.initialize = function (params) {
        if (!_initialized) {
            if (!params) {
                throw 'Missed parameters!';
            }

            if (!_typeHelper.isElement(params.parent)) {
                throw 'Invalid parent!';
            }

            _parent = params.parent;
            _container = _ajaxDoc.createElement('div', { 'class': 'subheader editable-list-footer' });
            _pager.initialize({
                parent: _container,
                isVisible: !!params.allowPaging
            });

            _parent.appendChild(_container);

            _initialized = true;
        }
    };

    _self.get_container = function () {
        return _container;
    };

    _self.get_width = function () {
        return _ajaxDoc.width(_self.get_container());
    };

    _self.set_width = function (value) {
        _ajaxDoc.width(_self.get_container(), value);
    };

    _self.get_pager = function () {
        return _pager;
    };

    _self.calculateHeightInfo = function (callback, thisArg) {
        setTimeout(function () {
            var result = {footer: 0 },
                container = _self.get_container();

            if (container) {
                result.footer = parseFloat(_ajaxDoc.height(container));
            }

            if (callback) {
                callback.call(thisArg || this, result);
            }
        }, 50);
    };
};

Dynamicweb.Controls.EditableList.Overlay = function () {
    var _self = this,
        _id,
        _container,
        _opened = false,
        _callers = 0,
        _initialized = false,
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current();

    _self.initialize = function (params) {
        if (!_initialized) {

            if (!params || !params.id) {
                throw 'Invalid paramters!';
            }

            _id = params.id;
            _container = new overlay(_id);
            _initialized = true;
        }
    };

    _self.open = function (timeout, callback, thisArg) {
        if (_callers === 0) {
            setTimeout(function () {
                _container.show();

                if (callback) {
                    callback.call(thisArg || this);
                }
            }(timeout || 0));
        }

        _callers += 1;
    };

    _self.close = function (timeout, callback, thisArg) {
        if (_callers > 0) {
            _callers -= 1;

            if (_callers === 0) {
                setTimeout(function () {
                    _container.hide();

                    if (callback) {
                        callback.call(thisArg || this);
                    }
                }, (timeout || 0));
            }
        }
    };

    _self.isOpened = function () {
        return _opened;
    };
};

Dynamicweb.Controls.EditableList.Dialog = function () {
    var _self = this,
        _container,
        _id,
        _metadata,
        _editors = new Dynamicweb.Utilities.Dictionary(),
        _model,
        _modelBackup,
        _opened = false,
        _initialized = false,
        _doc = Dynamicweb.Ajax.Document.get_current(),
        _eventEmitter = new Dynamicweb.Utilities.EventEmitter(),
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _collHelper = Dynamicweb.Utilities.CollectionHelper;

    function bindToView(model) {
        _metadata.forEach(function (meta) {
            var value;

            if (meta.editor) {
                value = model.get_propertyValue(meta.name);

                if (_typeHelper.isUndefined(value)) {
                    value = meta.defaultValue;
                }

                meta.editor.set_value(value);
            }
        }, this);
    }

    function bindToModel(model) {
        _metadata.forEach(function (meta) {
            var value;

            if (meta.editor) {
                value = meta.editor.get_value();

                if (_typeHelper.isUndefined(value) && !_typeHelper.isUndefined(meta.defaultValue)) {
                    value = meta.defaultValue;
                }

                model.set_propertyValue(meta.name, value);
            }
        }, _self);
    }

    function revertChanges(model, backup) {
        var props = backup.get_properties();

        _collHelper.forEach(props, function (propValue, propName) {
            _model.set_propertyValue(propName, propValue);
        }, this);
    };

    function toggleEditor(editor, visible) {
        var row = _doc.parent(editor.get_container(), 'div.editor-container'); // get editor's container

        if (row) {
            if (visible === true) {
                _doc.show(row);
            } else {
                _doc.hide(row);
            }
        }

        editor.set_isVisible(visible);
    }

    _self.initialize = function (params) {
        if (!_initialized) {
            if (!params || !params.id || !params.metadata) {
                throw 'Invalid parameters!';
            }

            _id = params.id;
            _container = _doc.getElementById(_id);
            _metadata = params.metadata;

            params.metadata.forEach(function (meta) {
                var options = meta.editFormOptions,
                    editor = meta.editor;

                // buttons don't have such options.
                if (options && editor) {
                    toggleEditor(editor, options.visible);
                }
            }, this);

            _doc.subscribe(_container.select('> div > div.cmd-pane > button.dialog-button-ok')[0], 'click', function (event, element) {
                _self.complete();
            });

            _doc.subscribe(_container.select('> div > div.cmd-pane > button.dialog-button-cancel')[0], 'click', function (event, element) {
                _self.cancel();
            });

            _doc.subscribe(_container.select('.boxhead .close > i')[0], 'click', function (event, element) {
                _self.cancel();
            });
        }
    };

    _self.open = function (model, bindActionObj) {
        if (!_opened) {
            _model = model;
            _modelBackup = model.clone();

            if (bindActionObj) {
                bindActionObj.success = function () {
                    bindToView(_model);
                };
                Dynamicweb.Controls.EditableList.EventHelper.action(bindActionObj);
            } else {
                bindToView(_model);
            }
            dialog.show(_id);

            _opened = true;
        }
    };

    _self.complete = function () {
        var args;
        if (_opened) {
            bindToModel(_model);

            Dynamicweb.Controls.EditableList.EventHelper.action({
                target: _self,
                eventEmitter: Dynamicweb.Utilities.FuncHelper.proxy(_eventEmitter.fire, _eventEmitter),
                before: 'complete',
                args: { model: _model, cancel: false },
                success: function () {
                    _model = null;
                    _modelBackup = null;

                    dialog.hide(_id);
                    _opened = false;
                },
                failure: function () {
                    revertChanges(_model, _modelBackup);
                }
            });
        }
    };

    _self.cancel = function () {
        if (_opened) {
            _eventEmitter.fire('cancel', _model);
            _model = null;

            dialog.hide(_id);
            _opened = false;
        }
    };

    _self.add_complete = function (handler) {
        _eventEmitter.on('complete', handler);
    };

    _self.remove_complete = function (handler) {
        _eventEmitter.off('complete', handler);
    };

    _self.add_cancel = function (handler) {
        _eventEmitter.on('cancel', handler);
    };

    _self.remove_cancel = function (handler) {
        _eventEmitter.off('cancel', handler);
    };
};

Dynamicweb.Controls.EditableList.Model = function (id, properties, state) {
    var _self = this,
        _id = id || '',
        _state = state || Dynamicweb.Controls.EditableList.Enums.ModelState.NEW,
        _properties = properties || {},
        _eventEmitter = new Dynamicweb.Utilities.EventEmitter(),
        _events = Dynamicweb.Controls.EditableList.Enums.ModelEvent,
        _states = Dynamicweb.Controls.EditableList.Enums.ModelState,
        _validstates = Dynamicweb.Utilities.CollectionHelper.toArray(_states),
        _validationHelper = Dynamicweb.Controls.EditableList.ValidationHelper,
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _collectionHelper = Dynamicweb.Utilities.CollectionHelper;

    function canChangeState(from, to) {
        var result = true;

        if (from === to) {
            result = false;
        } else if (from === _states.DELETED) {
            result = false;
        } else if ((from === _states.NEW) || (to === _states.NEW)) {
            result = false;
        } else if (_validstates.indexOf(to) === -1) {
            result = false;
        }

        return result;
    }

    function canChangeProperty() {
        var result = true;

        if (_state === _states.DELETED) {
            result = false;
        }

        return result;
    }

    // Returns model id.
    _self.get_id = function () {
        return _id;
    };

    // Sets new model id.
    _self.set_id = function (value) {
        if (_state !== _states.NEW) {
            throw 'Changing id is allowed ONLY for NEW models!';
        }

        _validationHelper.validateArgument('id', value, _typeHelper.isString);

        _id = value;
    };

    // Returns model state.
    _self.get_state = function () {
        return _state;
    };

    // Sets model state.
    _self.set_state = function (value) {
        var from = _state,
            to = value;

        if (canChangeState(from, to)) {
            _state = to;
            _eventEmitter.fire(_events.STATE_CHANGED, { sender: _self, from: from, to: to });
        }
    };

    // Returns array of property names.
    _self.get_names = function () {
        return _collectionHelper.keys(_properties);
    };

    // Returns array of property values.
    _self.get_values = function () {
        return _collectionHelper.values(_properties);
    };

    // Returns model properties.
    _self.get_properties = function () {
        return _typeHelper.clone(_properties);
    };

    // Returns property value.
    _self.get_propertyValue = function (propertyName) {
        return _properties[propertyName];
    };

    // Sets property value.
    _self.set_propertyValue = function (propertyName, propertyValue) {
        var differ = false;
        if (canChangeProperty()) {

            differ = !_typeHelper.compare(_properties[propertyName], propertyValue);

            if (differ) {
                _properties[propertyName] = propertyValue;

                _eventEmitter.fire(_events.PROPERTY_CHANGED, { sender: _self, name: propertyName, value: propertyValue });

                _self.set_state(_states.DIRTY);
            }
        }
    };

    // Serializes values.
    _self.serialize = function () {
        var newProperies = {};

        _collectionHelper.forEach(_properties, function (propValue, propName) {
            var newValue = propValue;

            if (_typeHelper.isDate(propValue)) {
                // get date without local timezone offset
                newValue = new Date(propValue.getTime() - new Date().getTimezoneOffset() * 60000);
            }

            newProperies[propName] = newValue;
        });

        return {
            state: _self.get_state(),
            properties: newProperies
        };
    };

    // Clones the current model.
    _self.clone = function () {
        var newProperies = {};

        _collectionHelper.forEach(_properties, function (propValue, propName) {
            var newValue = propValue;

            if (_typeHelper.isString(propValue)) {
                newValue = propValue.toString();
            } else if (_typeHelper.isObject(propValue)) {
                if (_typeHelper.isFunction(propValue.clone)) {
                    newValue = propValue.clone();
                } else if (_typeHelper.isFunction(propValue.copyTo)) {
                    propValue.copyTo(newValue);
                }
            }

            newProperies[propName] = propValue;
        });

        return new Dynamicweb.Controls.EditableList.Model(_id, newProperies, _state);
    };

    // Compares current model to specified.
    _self.compareTo = function (comparable) {
        var result = true,
            props;

        if (!_typeHelper.isInstanceOf(comparable, Dynamicweb.Controls.EditableList.Model)) {
            return false;
        }

        props = comparable.get_properties();

        if (_collectionHelper.count(_properties) === _collectionHelper.count(props)) {
            _collectionHelper.forEach(_properties, function (value, name) {
                if (!props.hasOwnProperty(name)) {
                    result = false;
                    return false;
                }

                if (!_typeHelper.compare(value, props[name])) {
                    result = false;
                    return false;
                }
            });
        } else {
            result = false;
        }

        return result;
    };

    // Adds 'PropertyChanged' event handler.
    _self.add_propertyChanged = function (handler) {
        _eventEmitter.on(Dynamicweb.Controls.EditableList.Enums.ModelEvent.PROPERTY_CHANGED, handler);
    };

    // Removes 'PropertyChanged' event handler.
    _self.remove_propertyChanged = function (handler) {
        _eventEmitter.off(Dynamicweb.Controls.EditableList.Enums.ModelEvent.PROPERTY_CHANGED, handler);
    };

    // Adds 'StateChanged' event handler.
    _self.add_stateChanged = function (handler) {
        _eventEmitter.on(Dynamicweb.Controls.EditableList.Enums.ModelEvent.STATE_CHANGED, handler);
    };

    // Removes 'StateChanged' event handler.
    _self.remove_stateChanged = function (handler) {
        _eventEmitter.off(Dynamicweb.Controls.EditableList.Enums.ModelEvent.STATE_CHANGED, handler);
    };
};

Dynamicweb.Controls.EditableList.ModelCollection = function () {
    var _self = this,
        _collections = {},
        _eventEmitter = new Dynamicweb.Utilities.EventEmitter(),
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _collectionHelper = Dynamicweb.Utilities.CollectionHelper,
        _states = _collectionHelper.toArray(Dynamicweb.Controls.EditableList.Enums.ModelState),
        _filter = null,
        _onModelStateChanged = function (eventName, args) {
            var sender = args.sender,
                from = args.from,
                to = args.to,
                fromCollection = findCollection(from),
                toCollection = findCollection(to);

            if (_typeHelper.isUndefined(fromCollection)) {
                return;
            }

            if (_typeHelper.isUndefined(toCollection)) {
                toCollection = createCollection(to);
            }

            fromCollection.remove(sender.get_id());
            toCollection.add(sender.get_id(), sender);

            _eventEmitter.fire('state', { sender: _self, model: args.sender, from: args.from, to: args.to });
        },
        _onModelPropertyChanged = function (eventName, args) {
            var propChangedObj = { sender: _self, model: args.sender, name: args.name, value: args.value };
            _checkModelIsHidden(propChangedObj.model)
            _eventEmitter.fire('property', propChangedObj);
        },
        _checkModelIsHidden = function (model) {
            var isHidden = false;
            if (_self._filter) {
                _collectionHelper.forEach(_self._filter, function (val, propName) {
                    if (val) {
                        var propVal = model.get_propertyValue(propName);
                        if (!quickCompare(val, propVal)) {
                            isHidden = true;
                            return false;
                        }
                    }
                }, _self);
            }
            if (isHidden) {
                model.hidden = true;
            } else {
                delete model.hidden;
            }
        };

    function quickCompare(a, b) {
        var isPrimitiveType = function (obj) {
            return Dynamicweb.Utilities.TypeHelper.isBoolean(obj) ||
            Dynamicweb.Utilities.TypeHelper.isString(obj) ||
            Dynamicweb.Utilities.TypeHelper.isNumber(obj) ||
            t instanceof RegExp;
        };

        var compare2Objects = function (x, y) {
            if (x == y) {
                return true;
            }
            if (x instanceof Date || y instanceof Date) {
                if (x instanceof Date) {
                    var xOffset = x.getTimezoneOffset() * 60000;
                    x = (new Date(x.getTime()- xOffset)).toISOString();
                }
                if (y instanceof Date) {
                    var yOffset = y.getTimezoneOffset() * 60000;
                    y = (new Date(y.getTime() - yOffset)).toISOString();
                }
                x = x || "";
                y = y || "";
                x = x.substr(0, x.indexOf("T"));
                y = y.substr(0, y.indexOf("T"));
            }

            if (isPrimitiveType(x) && isPrimitiveType(y)) {
                return x.toString() === y.toString();
            }

                // At last checking prototypes as good a we can
                if (!(x instanceof Object && y instanceof Object)) {
                    return false;
            }

            var p;
            for (p in y) {
                if (!compare2Objects(x[p], y[p])) {
                    return false;
            }
            }

            for (p in x) {
                if (!compare2Objects(x[p], y[p])) {
                    return false;
            }
            }

            return true;
        };

        return compare2Objects(a, b);
    };

    function isValidState(state) {
        return _states.indexOf(state) > -1;
    }

    function findCollection(state) {
        var foundCollection;

        if (_typeHelper.isUndefined(state)) {
            foundCollection = _collectionHelper.values(_collections);
        } else if (_typeHelper.isString(state)) {
            foundCollection = _collections[state];
        } else if (_typeHelper.isArray(state) || _typeHelper.isObject(state)) {
            foundCollection = [];
            _collectionHelper.forEach(state, function (collection) {
                foundCollection.push(collection);
            }, this);
        } else {
            throw 'Invalid state!';
        }

        return foundCollection;
    }

    function forEachCollection(callback, state) {
        var foundCollection;

        if (_typeHelper.isUndefined(state)) {
            _collectionHelper.forEach(_collections, callback, _self);
        } else if (_typeHelper.isString(state)) {
            foundCollection = findCollection(state);

            if (!_typeHelper.isUndefined(foundCollection)) {
                callback.call(_self, foundCollection, state);
            }
        } else if (_typeHelper.isArray(state)) {
            _collectionHelper.forEach(state, function (currentState) {
                var result = true;

                forEachCollection(function (foundCollection) {
                    result = callback.call(this, foundCollection, currentState);
                    return result;
                }, currentState);

                return result;
            }, _self);
        }
    }

    function createCollection(state) {
        var result;

        if (!isValidState(state)) {
            throw 'Invalid state!';
        }

        result = new Dynamicweb.Utilities.Dictionary();

        _collections[state] = result;

        return result;
    }

    function getCompareFunction(key) {
        var func,
            validStates = [Dynamicweb.Controls.EditableList.Enums.ModelState.CLEAN, Dynamicweb.Controls.EditableList.Enums.ModelState.NEW],
            model = _self.first(function (m) { return !_typeHelper.isUndefined(m.get_propertyValue(key)); }, validStates),
            value = null;

        if (model) {
            value = model.get_propertyValue(key);

            if (_typeHelper.isNumber(value)) {
                func = function (a, b) { return a - b; };
            } else if (_typeHelper.isDate(value)) {
                func = function (a, b) { return new Date(b) - new Date(a); };
            } else {
                func = function (a, b) {
                    if (a > b) {
                        return 1;
                    }
                        
                    if (a < b) {
                        return -1;
                    }
                    
                    return 0;
                };
            }
        }

        return func;
    }

    // Returns all model's ids by specified state.
    _self.keys = function (state) {
        var result = [];

        forEachCollection(function (collection) {
            result = result.concat(collection.keys());
        }, state);

        return result;
    };

    // Returns all models by specified state.
    _self.values = function (state) {
        var result = [];

        forEachCollection(function (collection) {
            result = result.concat(collection.values());
        }, state);

        return result;
    };

    // Returns models count by specified state.
    _self.count = function (state) {
        var result = 0;
        forEachCollection(function (collection) {
            collection.forEach(function (model) {
                if (!model.hidden) {
                    result++;
                }
            });
        }, state);

        return result;
    };

    // Adds new model.
    _self.add = function (model) {
        var id,
            state,
            collection;

        if (_typeHelper.isUndefined(model) || !_typeHelper.isInstanceOf(model, Dynamicweb.Controls.EditableList.Model)) {
            throw 'Invalid model!';
        }

        id = model.get_id();
        state = model.get_state();
        collection = findCollection(state);

        if (!_typeHelper.isUndefined(collection)) {
            if (collection.containsKey(id)) {
                throw 'Id is not unique!';
            }
        } else {
            collection = createCollection(state);
        }
        _checkModelIsHidden(model);
        collection.add(id, model);

        model.add_stateChanged(_onModelStateChanged);
        model.add_propertyChanged(_onModelPropertyChanged);

        _eventEmitter.fire('add', { sender: _self, model: model });
    };

    // Returns model by id.
    _self.get = function (id) {
        var result;

        forEachCollection(function (collection) {
            result = collection.get(id);

            return _typeHelper.isUndefined(result);
        });

        return result;
    };

    // Removes model by id.
    _self.remove = function (id) {
        var model,
            state,
            collection;

        if (_typeHelper.isObject(id) && _typeHelper.isInstanceOf(id, Dynamicweb.Controls.EditableList.Model)) {
            model = id;
        } else if (_typeHelper.isString(id)) {
            model = _self.get(id);
        } else {
            throw 'Invalid argument!';
        }

        if (_typeHelper.isUndefined(model)) {
            return;
        }

        state = model.get_state();
        collection = findCollection(state);

        if (_typeHelper.isUndefined(collection)) {
            return;
        }

        if (state === Dynamicweb.Controls.EditableList.Enums.ModelState.NEW) {
            collection.remove(model.get_id());
        } else {
            model.set_state(Dynamicweb.Controls.EditableList.Enums.ModelState.DELETED);
        }

        model.remove_stateChanged(_onModelStateChanged);
        model.remove_propertyChanged(_onModelPropertyChanged);

        _eventEmitter.fire('remove', { sender: _self, model: model });
    };

    // Removes all models and un-subscribe from their events
    _self.clear = function (state) {
        _self.forEach(function (model) {
            model.remove_stateChanged(_onModelStateChanged);
            model.remove_propertyChanged(_onModelPropertyChanged);
        }, state);

        if (_typeHelper.isUndefined(state) || _typeHelper.isEmpty(state)) {
            _collections = {};
        } else if(_typeHelper.isString(state)) {
            delete _collections[state];
        } else if (_typeHelper.isArray(state)) {
            _collectionHelper.forEach(state, function (v) { delete _collections[v]; });
        }

        _eventEmitter.fire('clear', { sender: _self });
    };

    //Iterates over the models by specififed state.
    _self.forEach = function (callback, state, thisArg) {
        var foundCollection;

        if (_typeHelper.isUndefined(callback)) {
            return;
        }

        forEachCollection(function (collection, currentState) {
            var result;

            collection.forEach(function (model) {
                result = callback.call(this, model, currentState);

                return result;
            }, (thisArg || this));

            return result;
        }, state);
    };

    //Iterates over the models by specififed range and state.
    _self.forEachRange = function (callback, skip, take, state, thisArg) {
        var values;

        if (_typeHelper.isUndefined(callback)) {
            return;
        }

        values = _collectionHelper.where(_self.values(state), function (model) {
            return !model.hidden;
        });

        _collectionHelper.forEachRange(values, function (model) {
            return callback.call(this, model);
        }, skip, take, thisArg || _self);
    };

    // Returns the first element of the sequence that satisfies a criteria.
    _self.first = function (criteria, state, thisArg) {
        var result;

        _self.forEach(function (model) {
            if (criteria.call(this, model) === true) {
                result = model;
                return false;
            }
        }, state, thisArg);

        return result;
    };

    // Filters a sequence of values based on a criteria.
    _self.where = function (criteria, state, thisArg) {
        var result = [];

        _self.forEach(function (model) {
            if (criteria.call(this, model) === true) {
                result.push(model);
            }
        }, state, thisArg);

        return result;
    };

    // Returns the array of sorted elements of a sequence according to a key..
    _self.orderBy = function (key, compareFunction, state) {
        compareFunction || (compareFunction = getCompareFunction.call(_self, key));

        return _self.values(state).sort(function (a, b) {
            var vA, vB;
            if (a) {
                vA = a.get_propertyValue(key);
            }
    
            if (b) {
                vB = b.get_propertyValue(key);
            }
    
            return compareFunction(vA, vB, key);
        });
    };

    // Returns the array of sorted elements of a sequence in descending order according to a key.
    _self.orderByDescending = function (key, compareFunction, state) {
        return _self.orderBy(key, compareFunction, state).reverse();
    };

    // Adds 'ModelAdded' event handler.
    _self.add_modelAdded = function (handler) {
        _eventEmitter.on('add', handler);
    };

    // Removes 'ModelAdded' event handler.
    _self.remove_modelAdded = function (handler) {
        _eventEmitter.off('add', handler);
    };

    // Adds 'ModelRemoved' event handler.
    _self.add_modelRemoved = function (handler) {
        _eventEmitter.on('remove', handler);
    };

    // Removes 'ModelRemoved' event handler.
    _self.remove_modelRemoved = function (handler) {
        _eventEmitter.off('remove', handler);
    };

    //Adds 'ModelStateChanged' event handler.
    _self.add_modelStateChanged = function (handler) {
        _eventEmitter.on('state', handler);
    };

    //Removes 'ModelStateChanged' event handler.
    _self.remove_modelStateChanged = function (handler) {
        _eventEmitter.off('state', handler);
    };

    //Adds 'ModelPropertyChanged' event handler'.
    _self.add_modelPropertyChanged = function (handler) {
        _eventEmitter.on('property', handler);
    };

    //Removes 'ModelPropertyChanged' event handler'.
    _self.remove_modelPropertyChanged = function (handler) {
        _eventEmitter.off('property', handler);
    };

    //Adds 'CollectionClear' event handler'.
    _self.add_cleared = function (handler) {
        _eventEmitter.on('clear', handler);
    };

    //Removes 'CollectionClear' event handler'.
    _self.remove_cleared = function (handler) {
        _eventEmitter.off('clear', handler);
    };

    _self.serialize = function () {
        var result = [];

        _self.forEach(function (model) { result.push(model.serialize()); });

        return result;
    };

    _self.set_filter = function (val) {
        _self._filter = val;
        _self.forEach(function (model) {
            _checkModelIsHidden(model);
        });
    }

    _self.get_filter = function () {
        return _self._filter;
    }
};

Dynamicweb.Controls.EditableList.List = function () {
    var _self = this,
        _allowEditing = true,
        _allowAddNewRow = true,
        _addNewRowCaption = '',
        _allowDeleteRow = true,
        _allowPaging = true,
        _allowSorting = false,
        _personalize = false,
        _personalizeUrl = null,
        _checkboxStates = null,
        _deleteColumnCaption = 'Delete',
        _pageSize = 10,
        _rowIndexCounter = 0,
        _postValueContainer = 0,
        _pageCount = 0,
        _pageIndex = 0,
        _postValueField,
        _metadata = new Dynamicweb.Observable(new Dynamicweb.Utilities.Dictionary()),
        _models = new Dynamicweb.Controls.EditableList.ModelCollection(),
        _dialog = new Dynamicweb.Controls.EditableList.Dialog(),
        _overlay = new Dynamicweb.Controls.EditableList.Overlay(),
        _header = new Dynamicweb.Controls.EditableList.Header(),
        _table = new Dynamicweb.Controls.EditableList.Table(),
        _footer = new Dynamicweb.Controls.EditableList.Footer(),
        _events = Dynamicweb.Controls.EditableList.Enums.EventType,
        _modelStates = Dynamicweb.Controls.EditableList.Enums.ModelState,
        _renderableStates = [_modelStates.CLEAN, _modelStates.NEW, _modelStates.DIRTY],
        _win = window,
        _doc = document,
        _ajaxDoc = Dynamicweb.Ajax.Document.get_current(),
        _typeHelper = Dynamicweb.Utilities.TypeHelper,
        _collHelper = Dynamicweb.Utilities.CollectionHelper,
        _funcHelper = Dynamicweb.Utilities.FuncHelper,
        _validationHelper = Dynamicweb.Controls.EditableList.ValidationHelper,
        _heightInfo;

    function generateId() {
        _rowIndexCounter += 1;
        return '_$row_' + _rowIndexCounter + '_';
    }

    function checkModelProperties(props) {
        return _metadata.get_target().all(function (meta) { return props.hasOwnProperty(meta.name) || _typeHelper.isUndefined(meta.editorMetadata); });
    }

    function createModel(value) {
        var model;

        if (_typeHelper.isUndefined(value)) {
            throw 'Invalid value! Missed argument.';
        }

        if (_typeHelper.isInstanceOf(value, Dynamicweb.Controls.EditableList.Model)) {
            model = value;

            if (!model.get_id()) {
                model.set_id(generateId());
            }
        } else {
            model = new Dynamicweb.Controls.EditableList.Model(generateId(), value);
        }

        if (!checkModelProperties(model.serialize().properties)) {
            throw 'Invalid value! Properties mismatch.';
        }

        return model;
    }

    function resize() {
        var height = 0,
            footerMargin = 0,
            footerContainer,
            dataCount = 0,
            currentPage = 1,
            endPage = 1;

        if (_self.get_allowPaging()) {
            footerContainer = _footer.get_container();
            currentPage = _self.get_pager().get_current();
            currentPageRowsCount = Math.min(_self.count(_renderableStates) - (currentPage - 1) * _pageSize, _pageSize);
            var min = _pageSize < 4 ? _pageSize : 4;
            var minSpacesRowsCount = currentPageRowsCount < min ? min : currentPageRowsCount;

            _collHelper.forEach(_heightInfo, function (value, name) {                
                if (name !== 'tableDataRow') {
                    height += value;
                } else {
                    height += value * minSpacesRowsCount;
                }
            }, this);

            if (height > 0) {
                _ajaxDoc.height(_self.get_container(), height + 'px');

                
                endPage = _self.get_pager().get_end();
                
                
                footerMargin = height - _heightInfo.footer - _heightInfo.header - (_self.get_allowAddNewRow() ? _heightInfo.tableAddNewRowButton : 0) - _heightInfo.tableHeaderRow - _heightInfo.tableDataRow * currentPageRowsCount;
                footerContainer.style.marginTop = '0px';
                footerContainer.style.marginTop = footerMargin + 'px';
            }
        } else {
            _ajaxDoc.height(_self.get_container(), 'auto');
        }
    }

    function refreshPager () {
        var pager = _self.get_pager(),
            end = Math.ceil(_models.count(_renderableStates) / _pageSize),
            current = pager.get_current();

        if (end <= 0) {
            end = 1;
        }

        if (end < current) {
            pager.set_current(end);
        }

        pager.set_end(end);
    }

    function canRender() {
        var pager = _self.get_pager(),
            result = true;

        if (_self.get_allowPaging()) {
            result = pager.get_end() === pager.get_current();
        }

        return result;
    }

    function renderPage(pageNumber) {
        var skip, take;

        _table.removeAllRows();

        if (_self.get_allowPaging()) {
            skip = _pageSize * (pageNumber - 1),
            take = _pageSize;

            _models.forEachRange(function (model) {
                _table.addRow(model);
            }, skip, take, _renderableStates, this);
        } else {
            _models.forEach(function (model) {
                _table.addRow(model);
            }, _renderableStates, this);
        }
    }

    function order(direction, columnName) {
        var column = _metadata.get_target().get(columnName),
            ordered;

        if (column) {
            if (direction === 'ascending') {
                ordered = _models.orderBy(columnName, column.sortExpressionCompiled, _renderableStates);
            } else {
                ordered = _models.orderByDescending(columnName, column.sortExpressionCompiled, _renderableStates);
            }

            _models.clear(_renderableStates);

            _collHelper.forEach(ordered, function (x) { _models.add(x);});

            var pager = _self.get_pager();
            pager.set_current(1);
            pager.fireClickEvent();
        }
    }

    _self.init = function (opts) {
        _self.options = opts
    };

    _self.initialize = function () {
        if (!_self._initialized) {
            _self.set_columns(_self.options.columns);
            _self.set_dataSource(_self.options.dataSource || []);
            _self.set_addNewRowCaption(_self.options.addNewRowCaption || 'Click here to add a new row');
            var form,
                submit,
                submitCalls = 0,
                allowEditingCheck = function (callback) {
                    return function () {
                        if (_self.get_allowEditing()) {
                            callback.apply(_self, arguments);
                        }
                    };
                },
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

            // controls initializing 
            _postValueField = _ajaxDoc.getElementsBySelector('input[type="hidden"][name="' + this._associatedControlID + '"]')[0];
            _dialog.initialize({ id: 'editable-list-dialog-' + this._associatedControlID, metadata: _metadata.get_target() });
            _overlay.initialize({ id: 'editable-list-overlay-' + this._associatedControlID });
            _header.initialize({ parent: this });            
            _table.initialize({ parent: this.get_container(), allowEditing: this.get_allowEditing(), allowSorting: this.get_allowSorting(), allowAddNewRow: this.get_allowAddNewRow(), addNewRowCaption: this.get_addNewRowCaption(), allowDeleteRow: this.get_allowDeleteRow(), deleteColumnCaption: this.get_deleteColumnCaption(), personalize: this.get_personalize() });

            // on 'Add new' row click event handler
            _table.add_newRowButtonClicked(allowEditingCheck(function () {
                if (_self.get_isEnabled()) {
                    var model = new Dynamicweb.Controls.EditableList.Model();
                    var bindActionObj = {
                        target: _self,
                        before: _events.EDIT_DATA_BINDING,
                        after: _events.EDIT_DATA_BINDED,
                        args: { row: model, cancel: false }
                    };
                    Dynamicweb.Controls.EditableList.EventHelper.action({
                        target: _self,
                        before: _events.DIALOG_OPENING,
                        after: _events.DIALOG_OPENED,
                        args: { row: model, cancel: false },
                        success: function () {
                            _dialog.open(model, bindActionObj);
                        }
                    });
                }
            }));

            // on data row click event handler
            _table.add_rowClicked(allowEditingCheck(function (eventName, id) {
                var model = _models.get(id);
                if (model) {
                    var bindActionObj = {
                        target: _self,
                        before: _events.EDIT_DATA_BINDING,
                        after: _events.EDIT_DATA_BINDED,
                        args: { row: model, cancel: false }
                    };
                    Dynamicweb.Controls.EditableList.EventHelper.action({
                        target: _self,
                        before: _events.DIALOG_OPENING,
                        after: _events.DIALOG_OPENED,
                        args: { row: model, cancel: false },
                        success: function () {
                            _dialog.open(model, bindActionObj);
                        }
                    });
                }
            }));

            // on 'Delete' button click event handler
            _table.add_deleteButtonClicked(allowEditingCheck(function (eventName, id) {
                _self.removeRow(id);
            }));

            // on column button click event handler.
            _table.add_columnButtonClicked(allowEditingCheck(function (eventName, args) {
                var model = _models.get(args.row),
                    column = _metadata.get_target().get(args.column),
                    func, context;

                if (model && column && column.actionCompiled) {
                    column.actionCompiled(model, column);
                }
            }));

            _table.add_columnSortClicked(_funcHelper.proxy(function (eventName, args) {
                if (args.column) {
                    if (args.direction === 'ascending') {
                        this.orderBy(args.column);
                    } else {
                        this.orderByDescending(args.column);
                    }
                }
            }, _self));

            // on 'Ok' button click event handler
            _dialog.add_complete(_funcHelper.proxy(function (eventName, args) {
                // new
                if (!args.model.get_id()) {
                    Dynamicweb.Controls.EditableList.EventHelper.action({
                        target: _self,
                        before: _events.ROW_CREATING,
                        after: _events.ROW_CREATED,
                        args: { row: args.model, cancel: false },
                        success: function () {
                            _models.add(createModel(args.model));
                        },
                        failure: function () {
                            args.cancel = true;
                        }
                    });
                } else {
                    Dynamicweb.Controls.EditableList.EventHelper.action({
                        target: _self,
                        before: _events.ROW_UPDATING,
                        after: _events.ROW_UPDATED,
                        args: { row: args.model, cancel: false },
                        failure: function () {
                            args.cancel = true;
                        }
                    });
                }
            }, _self));

            // metadata collection events
            _metadata.add_methodCalled(methodCalledRouter({
                'add': function (key, value) {
                    _table.addColumn(value);
                },
                'remove': function (key) {
                    _table.addColumn(key);
                },
                'clear': function () {
                    _table.removeAllColumns();
                }
            }, _self));

            // models collection events
            _models.add_modelAdded(_funcHelper.proxy(function (eventName, args) {
                if (!args.model.hidden) {
                    refreshPager();

                    // can we render on the current page?
                    if (canRender()) {
                        _table.addRow(args.model);
                    } else {
                        if (this.get_allowPaging()) {
                            // render next page on adding new row.
                            document.getElementsByClassName('footer-controls editable-list-pager')[0].classList.remove("hidden");
                            _footer.get_pager().set_current(_footer.get_pager().get_current() + 1);
                            renderPage(_footer.get_pager().get_current());
                        }
                    }

                    resize();
                }
            }, _self));

            _models.add_modelRemoved(_funcHelper.proxy(function (eventName, args) {
                var count = _models.count(_renderableStates),
                    skip,
                    take,
                    pager,
                    currentPage;

                refreshPager();
                _table.removeRow(args.model);

                // can we render on the current page?
                if (this.get_allowPaging()) {
                    currentPage = _self.get_pager().get_current();

                    if (count >= (_pageSize * currentPage)) {
                        // in order to prevent re-rendering of the whole page we ust get the next model
                        // and render it
                        if (_table.get_rowCount() > 0) {
                            skip = _pageSize * currentPage - 1;
                            take = 1;

                            _models.forEachRange(function (nextModel) {
                                _table.addRow(nextModel);
                            }, skip, take, _renderableStates, _self);
                        } else {
                            // current page is empty, render the whole page
                            renderPage(currentPage);
                        }
                    }
                }

                resize();
            }, _self));

            _models.add_cleared(_funcHelper.proxy(function (eventName, args) {
                _rowIndexCounter = 0;
                _table.removeAllRows();
                refreshPager();
                resize();
            }, _self));

            _models.add_modelPropertyChanged(_funcHelper.proxy(function (eventName, args) {
                if (args.model.hidden) {
                    refreshPager();
                    renderPage(_footer.get_pager().get_current());
                    resize();
                } else {
                    _table.updateRow(args.model);
                }                
            }, _self));

            // pager any button click event handler
            _self.get_pager().add_buttonClicked(_funcHelper.proxy(function (eventname, args) {
                renderPage(args.current);
                resize();
            }, _self));

            // editable list property changed events handlers
            _self.add_propertyChanged(propertyChangedRouter({
                'allowPaging': function (value) {
                    var container = _ajaxDoc.find(_self.get_container(), '.editable-list-container')[0];

                    if (value) {
                        _ajaxDoc.removeClass(container, 'no-paging');
                    } else {
                        _ajaxDoc.addClass(container, 'no-paging');
                    }

                    _self.get_pager().set_isVisible(value);
                    renderPage(1);
                    resize();
                },
                'allowEditing': function (value) {
                    _table.set_allowEditing(value);
                },
                'allowAddNewRow': function (value) {
                    _table.set_allowAddNewRow(value);
                },                
                'columns': function () {
                    _table.removeAllColumns();

                    _metadata.get_target().forEach(function (meta) {
                        _table.addColumn(meta);
                    });
                },
                'dataSource': function () {
                    _table.removeAllRows();

                    _self.forEach(function (model) {
                        _table.addRow(model);
                    });
                },
                'orderBy': function () {
                    setTimeout(function () {
                        renderPage(this.get_pager().get_current());
                    }, 250);
                },
                'orderByDescending': function () {
                    setTimeout(function () {
                        renderPage(this.get_pager().get_current());
                    }, 250);
                },
                'filter.AreaCollapse': function (val) {
                    _header.calculateHeightInfo(function (headerHeightInfo) {
                        _typeHelper.extend(_heightInfo, headerHeightInfo);
                        resize.call(this);
                    }, this);
                },
                'filter.query': function (val) {
                    var oldFilter = _models.get_filter();
                    _models.set_filter(val);
                    refreshPager();
                    renderPage(1);
                    resize.call(this);
                }
            }, _self));

            _self._binder.notifyPropertyChanged('columns', _metadata);
            _self._binder.notifyPropertyChanged('dataSource', _models);
            _self._binder.notifyPropertyChanged('allowEditing', this.get_allowEditing());
            _self._binder.notifyPropertyChanged('allowAddNewRow', this.get_allowAddNewRow());
            _self._binder.notifyPropertyChanged('allowPaging', this.get_allowPaging());

            form = _ajaxDoc.getElementsBySelector('form')[0];

            if (form) {
                submit = form.onsubmit || function () { };

                form.onsubmit = _funcHelper.proxy(function () {
                    if (submitCalls === 0) {
                        submitCalls += 1;
                        _postValueField.value = JSON.stringify(_models.serialize());
                        submit();
                    }
                }, _self);
            }
            
            refreshPager();
            _footer.initialize({ parent: this.get_container(), allowPaging: this.get_allowPaging() });

            // get rows height for control resizing.
            _table.calculateHeightInfo(function (tableHeightInfo) {
                _footer.calculateHeightInfo(function (footerHeightInfo) {
                    _header.calculateHeightInfo(function (headerHeightInfo) {
                        _heightInfo = {};
                        _typeHelper.extend(_heightInfo, headerHeightInfo);
                        _typeHelper.extend(_heightInfo, tableHeightInfo);
                        _typeHelper.extend(_heightInfo, footerHeightInfo);
                        resize.call(this);
                    }, this);
                }, this);
            }, this);
        }
    };

    _self.get_allowEditing = function () {
        return _allowEditing;
    };

    _self.set_allowEditing = function (value) {
        _validationHelper.validateArgument('allowEditing', value, _typeHelper.isBoolean);
        _allowEditing = value;
    };

    _self.get_allowAddNewRow = function () {
        return _allowAddNewRow;
    };

    _self.set_allowAddNewRow = function (value) {
        _validationHelper.validateArgument('allowAddNewRow', value, _typeHelper.isBoolean);
        _allowAddNewRow = value;
    };

    _self.get_addNewRowCaption = function () {
        return _addNewRowCaption;
    }

    _self.set_addNewRowCaption = function (value) {
        _validationHelper.validateArgument('_addNewRowCaption', value, _typeHelper.isString);
        _addNewRowCaption = value;
    }

    _self.get_allowDeleteRow = function () {
        return _allowDeleteRow;
    };

    _self.set_allowDeleteRow = function (value) {
        _validationHelper.validateArgument('allowDeleteRow', value, _typeHelper.isBoolean);
        _allowDeleteRow = value;
    };

    _self.get_allowPaging = function () {
        return _allowPaging;
    };

    _self.set_allowPaging = function (value) {
        _validationHelper.validateArgument('allowPaging', value, _typeHelper.isBoolean);
        _allowPaging = value;
    };

    _self.get_allowSorting = function () {
        return _allowSorting;
    };

    _self.set_allowSorting = function (value) {
        _validationHelper.validateArgument('allowSorting', value, _typeHelper.isBoolean);
        _allowSorting = value;
    };

    _self.get_deleteColumnCaption = function () {
        return _deleteColumnCaption;
    };

    _self.set_deleteColumnCaption = function (value) {
        _validationHelper.validateArgument('deleteColumnCaption', value, _typeHelper.isString);
        _deleteColumnCaption = value;
    };

    _self.get_dialog = function () {
        return _dialog;
    };

    _self.get_pageSize = function () {
        return _pageSize;
    };

    _self.set_pageSize = function (value) {
        _validationHelper.validateArgument('pageSize', value, _typeHelper.isNumber);
        _pageSize = value;
    };

    _self.get_pager = function () {
        return _footer.get_pager();
    };

    _self.get_columns = function () {
        return _metadata.get_target().values();
    };

    _self.set_columns = function (value) {
        _validationHelper.validateArgument('columns', value, _typeHelper.isObject);

        _metadata.get_target().clear();

        _collHelper.forEach(value, function (meta) {

            if (meta.editorMetadata) {
                meta.editor = Dynamicweb.Controls.EditableList.Editors.get_editor(meta.editorMetadata);
            }

            if (meta.action) {
                meta.actionCompiled = eval(meta.action);
            }

            if (meta.sortExpression) {
                meta.sortExpressionCompiled = eval(meta.sortExpression);
            }

            if (meta.cellOptions) {
                if (meta.cellOptions.backgroundImage && meta.cellOptions.backgroundImage.imageExpression) {
                    meta.cellOptions.backgroundImage.imageExpressionCompiled = eval(meta.cellOptions.backgroundImage.imageExpression);
                }
            }
            
            _metadata.get_target().add(meta.name, meta);
        }, _self);
    };

    _self.get_dataSource = function () {
        return _models.values();
    };

    _self.set_dataSource = function (value) {
        _validationHelper.validateArgument('dataSource', value, function (propertyValue) {
            return _typeHelper.isArray(propertyValue) || _typeHelper.isObject(propertyValue);
        });

        _models.clear();

        _collHelper.forEach(value, function (item) {
            checkModelProperties(item.properties);
            _models.add(new Dynamicweb.Controls.EditableList.Model(generateId(), item.properties, item.state));
        }, _self);
    };

    _self.get_personalize = function () {
        return _personalize;
    };

    _self.set_personalize = function (value) {
        _personalize = value;
    };

    _self.get_personalizeUrl = function () {
        return _personalizeUrl;
    };

    _self.set_personalizeUrl = function (value) {
        _personalizeUrl = value;
    };

    _self.get_checkboxStates = function () {
        return _checkboxStates;
    };

    _self.set_checkboxStates = function (value) {
        _checkboxStates = value;
    };
    

    _self.count = function (state) {
        return _models.count(state);
    };

    _self.addRow = function (value) {
        var model = createModel(value);

        Dynamicweb.Controls.EditableList.EventHelper.action({
            target: _self,
            before: _events.ROW_CREATING,
            after: _events.ROW_CREATED,
            args: { row: model, cancel: false },
            success: function () {
                _models.add(model);
            }
        });
    };

    _self.addRowRange = function (value) {
        _validationHelper.validateArgument('addRowRange', value, function (x) { return !_typeHelper.isUndefined(x); });
        _collHelper.forEach(value, _self.addRow, _self);
    };

    _self.removeRow = function (id) {
        var args,
            model = _models.get(id);

        if (model) {
            Dynamicweb.Controls.EditableList.EventHelper.action({
                target: _self,
                before: Dynamicweb.Controls.EditableList.Enums.EventType.ROW_DELETING,
                after: Dynamicweb.Controls.EditableList.Enums.EventType.ROW_DELETED,
                args: { row: model, cancel: false },
                success: function () {
                    _models.remove(model);
                }
            });
        }
    };

    _self.getColumn = function (id) {
        return _metadata.get_target().get(id);
    };

    _self.getRow = function (id) {
        return _models.get(id);
    };

    _self.findColumn = function (criteria, thisArg) {
        return _metadata.get_target().first(criteria, thisArg);
    };

    _self.findRow = function (criteria, thisArg) {
        return _models.first(criteria, _renderableStates, thisArg);
    };

    _self.findColumns = function (criteria, thisArg) {
        return _metadata.get_target().where(criteria, thisArg);
    };

    _self.findRows = function (criteria, thisArg) {
        return _models.where(criteria, _renderableStates, thisArg);
    };

    _self.forEach = function (callback, thisArg) {
        _models.forEach(callback, _renderableStates, thisArg);
    };

    _self.orderBy = function (columnName) {
        order.call(_self, 'ascending', columnName);
    };

    _self.orderByDescending = function (columnName) {
        order.call(_self, 'descending', columnName);
    };

    _self.add_dialogOpening = function (handler) {
        _self.addEventHandler(_events.DIALOG_OPENING, handler);
    };

    _self.remove_dialogOpening = function (handler) {
        _self.removeEventHandler(_events.DIALOG_OPENING, handler);
    };

    _self.add_dialogOpened = function (handler) {
        _self.addEventHandler(_events.DIALOG_OPENED, handler);
    };

    _self.remove_dialogOpened = function (handler) {
        _self.removeEventHandler(_events.DIALOG_OPENED, handler);
    };

    _self.add_editDataBinding = function (handler) {
        _self.addEventHandler(_events.EDIT_DATA_BINDING, handler);
    };

    _self.remove_editDataBinding = function (handler) {
        _self.removeEventHandler(_events.EDIT_DATA_BINDING, handler);
    };

    _self.add_editDataBinded = function (handler) {
        _self.addEventHandler(_events.EDIT_DATA_BINDED, handler);
    };

    _self.remove_editDataBinded = function (handler) {
        _self.removeEventHandler(_events.EDIT_DATA_BINDED, handler);
    };
    _self.add_rowCreating = function (handler) {
        _self.addEventHandler(_events.ROW_CREATING, handler);
    };

    _self.remove_rowCreating = function (handler) {
        _self.removeEventHandler(_events.ROW_CREATING, handler);
    };

    _self.add_rowCreated = function (handler) {
        this.addEventHandler(_events.ROW_CREATED, handler);
    };

    _self.remove_rowCreated = function (handler) {
        this.removeEventHandler(_events.ROW_CREATED, handler);
    };

    _self.add_rowDeleting = function (handler) {
        this.addEventHandler(_events.ROW_DELETING, handler);
    };

    _self.remove_rowDeleting = function (handler) {
        this.removeEventHandler(_events.ROW_DELETING, handler);
    };

    _self.add_rowDeleted = function (handler) {
        this.addEventHandler(_events.ROW_DELETED, handler);
    };

    _self.remove_rowDeleted = function (handler) {
        this.removeEventHandler(_events.ROW_DELETED, handler);
    };

    _self.add_rowUpdating = function (handler) {
        this.addEventHandler(_events.ROW_UPDATING, handler);
    };

    _self.remove_rowUpdating = function (handler) {
        this.removeEventHandler(_events.ROW_UPDATING, handler);
    };

    _self.add_rowUpdated = function (handler) {
        this.addEventHandler(_events.ROW_UPDATED, handler);
    };

    _self.remove_rowUpdated = function (handler) {
        this.removeEventHandler(_events.ROW_UPDATED, handler);
    };

    _self.changeColumn = function (e, colName) {
        e.preventDefault();
        var mnuEl = e.currentTarget;
        _self._changeColumnState(mnuEl, colName);
    };

    _self._changeColumnState = function (mnuEl, colName) {
        var col = this.findColumn(function (col) {
            return col.name == colName;
        });

        if (col) {
            col.cellOptions.visible = !col.cellOptions.visible;
            var columnsStateVisible = [];
            var columnsStateInvisible = [];
            this.get_columns().each(function (col) {
                if (col.cellOptions.visible) {
                    columnsStateVisible.push(col.name);
                } else {
                    columnsStateInvisible.push(col.name);
                }
            });
            this._updateColumnsStates(columnsStateVisible, columnsStateInvisible);
        }
    };

    _self.columnsSelectorDialog = function (e) {
        e.preventDefault();
        this.get_columns().each(function (col) {
            var checkBoxEl = $("dialog_" + _self.get_associatedControlID() + "_item_" + col.name);
            checkBoxEl.checked = col.cellOptions.visible;
        });

        dialog.show("columnSelectorDialog_" + this.get_associatedControlID());
    };

    _self.cancelColumnSelectorDialog = function () {
        dialog.hide("columnSelectorDialog_" + this.get_associatedControlID());
    };

    _self.dialogUpdateColumns = function () {
        var container = $("dialog_" + this.get_associatedControlID() + "_container");
        var columns = container.getElementsBySelector("input");
        var ctrlEl = $(this.get_associatedControlID());
        var colStates = "";
        var checkboxStates = this.get_checkboxStates();
        var columnsStateVisible = [];
        var columnsStateInvisible = [];

        for (var i = 0; i < columns.length; i++) {
            var colEl = columns[i];
            var colName = colEl.getAttribute('customdata');
            if (colEl.checked) {
                columnsStateVisible.push(colName);
            } else {
                columnsStateInvisible.push(colName);
            }
        }
        this._updateColumnsStates(columnsStateVisible, columnsStateInvisible);
        dialog.hide("columnSelectorDialog_" + this.get_associatedControlID());
    };

    _self._updateColumnsStates = function (visibleCols, invisibleCols) {
        var colsIdx = {};
        this.get_columns().each(function (col) {
            colsIdx[col.name] = col;
        });
        var newOrderedCols = [];
        for (var i = 0; i < visibleCols.length; i++) {
            var col = colsIdx[visibleCols[i]];
            if (col) {
                col.cellOptions.visible = true;
                col.cellOptions.index = newOrderedCols.length;
                newOrderedCols.push(col);
            }
        }

        for (var i = 0; i < invisibleCols.length; i++) {
            var col = colsIdx[invisibleCols[i]];
            if (col) {
                col.cellOptions.visible = false;
                col.cellOptions.index = newOrderedCols.length;
                newOrderedCols.push(col);
            }
        }

        this.set_columns(newOrderedCols);
        this.forEach(function (model) {
            _table.updateRow(model);
        });

        var menuItemCnt = $("ColumnSelector:" + this.get_associatedControlID()).select(".container")[0];
        var checkboxStates = this.get_checkboxStates();
        var updateMenuItemState = function (colName, visible) {
            var mnuItem = $("ColumnSelector_" + colName);
            var checkBoxIconEl = mnuItem.select(".item i")[0];
            if (checkBoxIconEl) {
                checkBoxIconEl.className = visible ? checkboxStates.checked : checkboxStates.unchecked;
                menuItemCnt.insert(mnuItem);
            } else {
                var checkboxEl = mnuItem.select(".item input.checkbox")[0];
                if (checkboxEl) {
                    checkboxEl.checked = visible;
                    menuItemCnt.insert(mnuItem);
                }
            }
        };
        var colStates = "";
        for (var i = 0; i < newOrderedCols.length; i++) {
            var col = newOrderedCols[i];
            updateMenuItemState(col.name, col.cellOptions.visible);
            colStates += col.name + ":" + col.cellOptions.visible + ",";
        }
        Dynamicweb.Ajax.DataLoader.load({
            url: this.get_personalizeUrl(),
            target: this.get_associatedControlID(),
            argument: "UpdateColumns:" + colStates,
            onComplete: function () { }
        });
    };

    _self.dialogSelectColumn = function (columnId) {
        var old = $("dialog_" + this.get_associatedControlID() + "_name_" + this.dialogSelectedColumnId);
        if (old) {
            old.parentElement.removeClassName('list-dialog-columns-item-selected');
        }

        var span = $("dialog_" + this.get_associatedControlID() + "_name_" + columnId);
        span.parentElement.addClassName("list-dialog-columns-item-selected");

        this.dialogSelectedColumnId = columnId;
    };

    _self.dialogColumnUpClick = function () {
        var row = $("dialog_" + this.get_associatedControlID() + "_row_" + this.dialogSelectedColumnId);

        var prevRows = row.previousSiblings();
        var prevRow = prevRows[0];

        Element.insert(row, { after: prevRow });
    };

    _self.dialogColumnDownClick = function () {
        var row = $("dialog_" + this.get_associatedControlID() + "_row_" + this.dialogSelectedColumnId);

        var prevRows = row.nextSiblings();
        var prevRow = prevRows[0];

        Element.insert(row, { before: prevRow });
    };

    _self.dialogColumnShowClick = function () {
        var item = $("dialog_" + this.get_associatedControlID() + "_item_" + this.dialogSelectedColumnId);
        item.checked = true;
    };

    _self.dialogColumnHideClick = function () {
        var item = $("dialog_" + this.get_associatedControlID() + "_item_" + this.dialogSelectedColumnId);
        item.checked = false;
    };    
};

Dynamicweb.Controls.EditableList.List.prototype = new Dynamicweb.Ajax.Control();