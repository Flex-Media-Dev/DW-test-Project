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

if (!Dynamicweb.Controls.EditableList.Editors) {
    Dynamicweb.Controls.EditableList.Editors = {};
}

Dynamicweb.Controls.EditableList.Editors.get_editor = function (metadata) {
    var editor,
        ctor = Dynamicweb.Controls.EditableList.Editors[metadata.editorTypeName];

    if (ctor && typeof ctor === 'function') {
        editor = new ctor();
        editor.initialize(metadata);
    }

    return editor;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor = function () {
    this._id = null;
    this._value = null;
    this._isEnabled = true;
    this._isVisible = true;
    this._initialized = false;
    this._binder = null;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.get_id = function () {
    return this._id;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.get_container = function () {
    return this._container;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.get_value = function () {
    return this._value;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.set_value = function (value) {
    this._value = value;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.get_isEnabled = function () {
    return this._isEnabled;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.set_isEnabled = function (value) {
    this._isEnabled = value;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.get_isVisible = function () {
    return this._isVisible;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.set_isVisible = function (value) {
    this._isVisible = value;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.format = function (value) {
    return value || "";
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.convert = function (value) {
    return value;
};

Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.initialize = function (metadata) {
    var self = this,
        ajaxDoc = Dynamicweb.Ajax.Document.get_current();

    if (!this._initialized) {
        this._id = metadata.id || '';
        this._isEnabled = metadata.enabled || true;
        this._isVisible = metadata.visible || true;
        this._container = ajaxDoc.getElementById(this._id);
        this._value = this._container.value;
        this._binder = new Dynamicweb.UIBinder(this);

        this._binder.bindProperty('value', [{
            elements: [],
            action: function (sender, args) {
                var target = args.target,
                    value = args.value;

                target._container.value = value;
            }
        }]);

        this._binder.bindProperty('isEnabled', [{
            elements: [],
            action: function (sender, args) {
                var target = args.target,
                    value = args.value;

                value = value ? '' : 'readonly';

                ajaxDoc.attribute(self._container, 'readonly', value);
            }
        }]);

        this._binder.bindProperty('isVisible', [{
            elements: [],
            action: function (sender, args) {
                var target = args.target,
                    value = args.value;

                if (value) {
                    ajaxDoc.show(self._container);
                } else {
                    ajaxDoc.hide(self._container);
                }
            }
        }]);

        ajaxDoc.subscribe(this._container, 'change', function (event, element) {
            self._value = element.value;
        });

        this._initialized = true;
    }
};

Dynamicweb.Controls.EditableList.Editors.TextEditor = function () {
    this._isRequired = false;
};

Dynamicweb.Controls.EditableList.Editors.TextEditor.prototype = new Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor();

Dynamicweb.Controls.EditableList.Editors.TextEditor.prototype.convert = function (value) {
    return String.prototype.toString.call(value);
};

Dynamicweb.Controls.EditableList.Editors.TextEditor.prototype.initialize = function (metadata) {
    if (!this._initialized) {
        Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.initialize.call(this, metadata);
        this._isRequired = metadata.required;
    }
};

Dynamicweb.Controls.EditableList.Editors.ListEditor = function () {
    this._options = [];
};

Dynamicweb.Controls.EditableList.Editors.ListEditor.prototype = new Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor();

Dynamicweb.Controls.EditableList.Editors.ListEditor.prototype.format = function (value) {
    var result = value,
        option = Dynamicweb.Utilities.CollectionHelper.first(this._options, function (v) { return v.value === value; }, this);

    if (option) {
        result = option.text;
    } else if (this._options.length) {
        result = this._options[0].text;
    }

    return result;
};
Dynamicweb.Controls.EditableList.Editors.ListEditor.prototype.get_options = function () {
    return this._options;
};

Dynamicweb.Controls.EditableList.Editors.ListEditor.prototype.set_options = function (value) {
    this._options = value;
};


Dynamicweb.Controls.EditableList.Editors.ListEditor.prototype.initialize = function (metadata) {
    var self = this,
    ajaxDoc = Dynamicweb.Ajax.Document.get_current();

    if (!this._initialized) {
        this._id = metadata.id || '';
        this._isEnabled = metadata.enabled || true;
        this._isVisible = metadata.visible || true;
        this._container = ajaxDoc.getElementById(this._id);
        this._value = this._container.value;
        this._options = metadata.options;
        this._binder = new Dynamicweb.UIBinder(this);

        this._binder.bindProperty('value', [{
            elements: [],
            action: function (sender, args) {
                var target = args.target,
                    value = args.value;

                if (!value) {
                    if (target._options && target._options.length) {
                        value = target._options[0].value;
                    } else {
                        value = '';
                    }

                    target._value = value;
                }

                target._container.value = value;
            }
        }]);

        this._binder.bindProperty('isEnabled', [{
            elements: [],
            action: function (sender, args) {
                var target = args.target,
                    value = args.value;

                value = value ? '' : 'readonly';

                Dynamicweb.Ajax.Document.get_current().attribute(target._container, 'readonly', value);
            }
        }]);

        this._binder.bindProperty('isVisible', [{
            elements: [],
            action: function (sender, args) {
                var target = args.target,
                    value = args.value;

                if (value) {
                    Dynamicweb.Ajax.Document.get_current().show(target._container);
                } else {
                    Dynamicweb.Ajax.Document.get_current().hide(target._container);
                }
            }
        }]);

        this._binder.bindProperty('options', [{
            elements: [],
            action: function (sender, args) {
                var target = args.target;
                var newOptions = args.value;
                var el = target._container;
                el.options.length = 0; // remove all
                newOptions.forEach(function (item) {
                    var opt = document.createElement('option');
                    opt.value = item.value;
                    opt.innerHTML = item.text;
                    el.options.add(opt);
                });
            }
        }]);

        ajaxDoc.subscribe(this._container, 'change', function (event, element) {
            self._value = element.value;
        });

        this._initialized = true;
    }
};

Dynamicweb.Controls.EditableList.Editors.CheckboxEditor = function () { };

Dynamicweb.Controls.EditableList.Editors.CheckboxEditor.prototype = new Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor();

Dynamicweb.Controls.EditableList.Editors.CheckboxEditor.prototype.initialize = function (metadata) {
    var self = this,
    ajaxDoc = Dynamicweb.Ajax.Document.get_current()

    if (!this._initialized) {
        Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.initialize.call(this, metadata);

        this._binder.bindProperty('value', [{
            elements: [],
            action: function (sender, args) {
                var target = args.target,
                    value = args.value;

                self._container.checked = value;
            }
        }]);

        ajaxDoc.subscribe(this._container, 'change', function (event, element) {
            self._value = element.checked;
        });
    }
};

Dynamicweb.Controls.EditableList.Editors.CheckboxEditor.prototype.format = function (value) {
    return value ? "<i class=\"fa fa-check color-success\"></i>" : "<i class=\"fa fa-remove color-danger\"></i>";
};

Dynamicweb.Controls.EditableList.Editors.RadioEditor = function () { };

Dynamicweb.Controls.EditableList.Editors.RadioEditor.prototype = new Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor();

Dynamicweb.Controls.EditableList.Editors.RadioEditor.prototype.initialize = function (metadata) {
    if (!this._initialized) {
        Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.call(this, metadata);
        this._options = metadata.options;
    }
};

Dynamicweb.Controls.EditableList.Editors.AjaxControlEditor = function () { };

Dynamicweb.Controls.EditableList.Editors.AjaxControlEditor.prototype = new Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor();

Dynamicweb.Controls.EditableList.Editors.AjaxControlEditor.prototype.initialize = function (metadata) {
    if (!this._initialized) {
        this._id = metadata.id || '';
        this._control = Dynamicweb.Ajax.ControlManager.get_current().findControl(this._id);
        this._container = this._control.get_container();
        this._binder = new Dynamicweb.UIBinder(this);

        this._binder.bindProperty('isEnabled', {
            elements: [],
            action: function (sender, args) {
                var value = args.value,
                    target = args.target;

                target._control.set_isEnabled(value);
            }
        });

        this._binder.bindProperty('isVisible', {
            elements: [],
            action: function (sender, args) {
                var value = args.value,
                    target = args.target;

                if (value) {
                    Dynamicweb.Ajax.Document.get_current().show(target._container);
                } else {
                    Dynamicweb.Ajax.Document.get_current().hide(target._container);
                }
            }
        });

        this._initialized = true;
    }
};

Dynamicweb.Controls.EditableList.Editors.DateEditor = function () { };

Dynamicweb.Controls.EditableList.Editors.DateEditor.prototype = new Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor();

Dynamicweb.Controls.EditableList.Editors.DateEditor.prototype.get_value = function () {
    return this._control.get_selectedDate();
};

Dynamicweb.Controls.EditableList.Editors.DateEditor.prototype.set_value = function (value) {
    this._control.set_selectedDate(this.convert(value), false);
};

Dynamicweb.Controls.EditableList.Editors.DateEditor.prototype.format = function (value) {
    return this._control.formatDate((this.convert(value) || null), this._control.get_dateFormat());
};

Dynamicweb.Controls.EditableList.Editors.DateEditor.prototype.convert = function (str, removeOffset) {
    var result = str;

    if (typeof result === 'string') {
        result = new Date(result);
        if (!this._control._includeTime) {            
            result = new Date(result.getFullYear(), result.getMonth(), result.getDate());            
        }
    }

    return result;
};

Dynamicweb.Controls.EditableList.Editors.DateEditor.prototype.initialize = function (metadata) {
    if (!this._initialized) {
        Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.initialize.call(this, metadata);
        this._control = {
            get_selectedDate: function () {                
                var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
                var dtp = datepicker.dict[metadata.id];

                return datepicker.IsNotSet(metadata.id) ? null: dtp.getDate();
            },
            set_selectedDate: function (dt, preventOnSelect) {
                var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
                datepicker.SetDate(metadata.id, dt);
            },
            get_dateFormat: function () {
                return "YYYY-MM-DD";
            },
            formatDate: function (dt, frm) {
                if (!dt) {
                    return document.getElementById('DWCalendarNotSetString').value;
                }

                if (typeof dt === 'string') {
                    dt = new Date(Date.parse(dt));
                }
                return dt.toDateString();
            }
        };
    }
};

Dynamicweb.Controls.EditableList.Editors.NumberEditor = function () { };

Dynamicweb.Controls.EditableList.Editors.NumberEditor.prototype = new Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor();

Dynamicweb.Controls.EditableList.Editors.NumberEditor.prototype.initialize = function (metadata) {
    if (!this._initialized) {
        Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.initialize.call(this, metadata);
        var self = this;
        var formatter = null;
        var parser = null;
        var isDecimal = self._container.getAttribute("data-number-type") == "decimal";
        if (Dynamicweb.Controls.OMC.NumberFormatter) {
            formatter = new Dynamicweb.Controls.OMC.NumberFormatter();
            formatter.set_localizable(metadata.culture);
            formatter.set_decimalPrecision(metadata.decimalPrecision);
            formatter.set_decimalPrecision(metadata.decimalPrecision);

            if (isDecimal) {
                parser = new Dynamicweb.Controls.OMC.FloatValueParser();
            }
            else {
                parser = new Dynamicweb.Controls.OMC.IntegerValueParser();
            }
        }

        self._container.setAttribute("step", isDecimal ? "any" : "1");        

        if (!formatter) {
            formatter = {
                format: function (val) {
                    return val;
                }
            };
        }

        this._control = {
            get_selectedValue: function () {
                return parser ? parser.valueFromString(self._container.value) : isDecimal ? parseFloat(self._container.value) : parseInt(self._container.value);
            },
            set_selectedValue: function (val) {
                self._container.value = parser ? parser.valueToString(val) : val.toString();
            },
            get_numberFormatter: function () {
                return formatter;
            }
        };

        if (parser) {
            parser.set_selector(this._control);
        }
    }
};


Dynamicweb.Controls.EditableList.Editors.NumberEditor.prototype.get_value = function () {
    return this._control.get_selectedValue();
};

Dynamicweb.Controls.EditableList.Editors.NumberEditor.prototype.set_value = function (value) {
    this._control.set_selectedValue(value, false);
};

Dynamicweb.Controls.EditableList.Editors.NumberEditor.prototype.format = function (value) {
    return this._control.get_numberFormatter().format(value);
};

Dynamicweb.Controls.EditableList.Editors.UserEditor = function () { };

Dynamicweb.Controls.EditableList.Editors.UserEditor.prototype = new Dynamicweb.Controls.EditableList.Editors.AjaxControlEditor();

Dynamicweb.Controls.EditableList.Editors.UserEditor.prototype.get_value = function () {
    return this._control.get_value();
};

Dynamicweb.Controls.EditableList.Editors.UserEditor.prototype.set_value = function (value) {
    this._control.set_value(value);
};

Dynamicweb.Controls.EditableList.Editors.UserEditor.prototype.set_value_text = function (value, text) {
    this._control.set_value(value, text);
};

Dynamicweb.Controls.EditableList.Editors.UserEditor.prototype.format = function (value) {
    return value ? value.text : '';
};

Dynamicweb.Controls.EditableList.Editors.UserEditor.prototype.initialize = function (metadata) {
    if (!this._initialized) {
        var self = this;
        Dynamicweb.Controls.EditableList.Editors.AjaxControlEditor.prototype.initialize.call(this, metadata);

        this._control.set_provider(function (options) {
            var callback = options.callback;

            // See \Admin\Images\Controls\CustomSelector\CustomSelector.js
            if (metadata.select === 'User') {
                self.addUser(metadata, callback);
                return;
            } else if (metadata.select === 'Group') {
                self.addGroup(callback);
                return;
            } else {
                console.log("EditableList.Editors.UserEditor has wrong type: " + metadata.select);
            }
        });
    }
};

Dynamicweb.Controls.EditableList.Editors.UserEditor.prototype.addUser = function (metadata, callback) {
    Action.Execute({
        Name: "OpenDialog",
        Url: "/admin/users/dialogs/selectuser?onlyBackend=" + metadata.onlyBackend + "&hideAdmins=" + metadata.hideAdmins,
        OnSelected: {
            Name: "ScriptFunction",
            Function: function (opts, model) {
                var id = model.Selected;
                var name = model.SelectedName;
                callback(id, name); 
            }
        }
    });
}

Dynamicweb.Controls.EditableList.Editors.UserEditor.prototype.addGroup = function (callback) {
    Action.Execute({
        Name: "OpenDialog",
        Url: "/admin/users/dialogs/selectusergroup?mode=1&multiselect=false",
        OnSelected: {
            Name: "ScriptFunction",
            Function: function (opts, model) {
                for (var i = 0; i < model.length; i++) {
                    var id = model[i].Selected;
                    var name = model[i].SelectedName;
                    var userCount = model[i].UsersCount;
                    callback(id, name);
                }
            }
        }
    });
}

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor = function () { };

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype = new Dynamicweb.Controls.EditableList.Editors.AjaxControlEditor();

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.get_dataSource = function () {
    return this._control.get_dataSource();
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.set_dataSource = function (value) {
    this._control.set_dataSource(value);
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.clear = function () {
    this._control.clear();
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.addItem = function (value) {
    this._control.addItem(value);
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.removeItem = function (value) {
    this._control.removeItem(value);
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.getItem = function (value) {
    return this._control.getItem(value);
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.findItem = function (criteria) {
    return this._control.findItem(criteria);
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.findItems = function (criteria) {
    return this._control.findItems(criteria);
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.get_value = function () {
    var item = this._control.get_selected();

    return item ? item.value : '';
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.set_value = function (value) {
    this._control.set_selected(this._control.getItem(value) || this._control.firstItem());
};

Dynamicweb.Controls.EditableList.Editors.ComboboxEditor.prototype.format = function (value) {
    var item = this._control.getItem(value);

    return item ? item.text : '';
};


///==============

(function (ns) {
    var ProductEditor = function () { };
    var methods = ProductEditor.prototype = new ns.AjaxControlEditor();
    methods.get_value = function () {
        return this._control.get_value();
    };

    methods.set_value = function (obj) {
        return this._control.set_value(obj.value, obj.text);
    };

    methods.set_value_text = function (value, text) {
        this._control.set_value(value, text);
    };

    methods.format = function (obj) {
        return obj && obj.value ? obj.text : this.defaultText;
    };
    methods._getSelectObj = function (metadata) {
        var obj = {};
        var nameObj = {
            value: ""
        };
        var idObj = {
            parent: obj,
            value: "",
            onchange: function () {

                this.parent.exec(this.parent.id.value, this.parent.name.value);
            }
        };
        obj.name = nameObj;
        obj.id = idObj;
        if (metadata.select === 'Group') {
            // special ini if needed
        } else if (metadata.select === 'Product') {
            obj.Name_Proxy = nameObj;
            obj.ID_Proxy = idObj;
        }
        return obj;
    },
    methods.initialize = function (metadata) {
        var self = this;
        self.defaultText = metadata.defaultValueText;
        if (!this._initialized) {
            var openWindow = function (url, windowName, width, height) {
                return window.open(url, windowName, 'status=0,toolbar=0,menubar=0,resizable=0,directories=0,titlebar=0,modal=no,width=' + width + ',height=' + height);
            };
            ns.AjaxControlEditor.prototype.initialize.call(this, metadata);
            var elem = document.getElementById(this._control._associatedControlID);
            elem.selectedItem = self._getSelectObj(metadata)

            this._control.set_provider(function (options) {
                var url = '/Admin/Module/eCom_Catalog/dw7/Edit/EcomGroupTree.aspx';
                var title;
                var params = ["AddCaller=1", "doAppend=true", "invokeOnChangeOnID=true"];
                elem.selectedItem.exec = options.callback;
                if (metadata.select === 'Group') {
                    title = 'AddGroupPopup';
                    params.push('CMD=ShowGroup');
                    params.push('appendType=GetGroupID');
                    var caller1 = encodeURIComponent("window.opener." + options.caller.get_associatedControlID() + ".selectedItem.id");
                    params.push('caller=' + caller1);
                    var caller2 = encodeURIComponent("window.opener." + options.caller.get_associatedControlID() + ".selectedItem.name");
                    params.push('caller2=' + caller2);
                } else if (metadata.select === 'Product') {
                    title = 'AddProductPopup';
                    params.push('CMD=ShowProd');
                    params.push('appendType=GetProdID');
                    var caller1 = encodeURIComponent("window.opener." + options.caller.get_associatedControlID() + ".selectedItem.DW_REPLACE_Proxy");
                    params.push('caller=' + caller1);
                } else if (metadata.select === 'ProductVariant') {
                    title = 'AddProductVariantPopup';
                    params.push('CMD=ProdItemProd');
                    params.push('appendType=GetProdID');
                    var caller1 = encodeURIComponent("window.opener." + options.caller.get_associatedControlID() + ".selectedItem.DW_REPLACE_Proxy");
                    params.push('caller=' + caller1);
                }

                if (url && params.length) {
                    url += '?' + params.join('&');
                    openWindow(url, (title || 'Ecom managment'), 600, 400);
                }
            });
        }
    };

    ns.ProductEditor = ProductEditor;

    var ProductsAndGroupsEditor = function () { };
    methods = ProductsAndGroupsEditor.prototype = new ns.HtmlControlEditor();
    methods.initialize = function (metadata) {
        if (!this._initialized) {
            Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.initialize.call(this, metadata);
            this._isRequired = metadata.required;
            this.metadata = metadata;
            var self = this;
            self._getDefaultInEmpty = function (obj) {
                if (!obj || obj == "") {
                    obj = {
                        Values: "[some]",
                        Items: []
                    };
                }
                return obj;
            };
            this._binder.bindProperty('value', [{
                elements: [],
                action: function (sender, args) {
                    var target = args.target;
                    var obj = target._getDefaultInEmpty(args.value);
                    target._container.value = obj.Values;
                    $(target.metadata.id + "_some_value").value = obj.Values.substr(6);
                }
            }]);
        }
    };

    methods.set_value = function (obj) {
        obj = this._getDefaultInEmpty(obj);
        var someListId = this.metadata.id + "_some";
        ClearProdItems(someListId)
        fillMultiProductsAndGroups(someListId, obj);
        return obj;
    };

    methods.get_value = function () {
        var items = [];
        $(this.metadata.id + "_some_div").childElements().forEach(function (el) {
            items.push(JSON.parse(el.getAttribute('itemData')));
        });
        var obj = {
            Values: this._container.value,
            Type: 1, // some
            Items: items
        };

        return obj;
    };
    methods.format = function (value) {
        return "";
    };

    ns.ProductsAndGroupsEditor = ProductsAndGroupsEditor;

    var CustomHtmlEditor = function () { };
    methods = CustomHtmlEditor.prototype = new ns.HtmlControlEditor();
    methods.initialize = function (metadata) {
        if (!this._initialized) {
            this._id = metadata.id || '';
            this._isEnabled = metadata.enabled || true;
            this._isVisible = metadata.visible || true;
            this._binder = new Dynamicweb.UIBinder(this);
            this.customInit = window[metadata.customInit];
            this._customEditor = this.customInit(this, metadata);
            this._container = this._container || this._customEditor.container();
        }
    };

    methods.set_value = function (val) {
        this._customEditor.val(val);
    };

    methods.get_value = function () {
        return this._customEditor.val();
    };

    ns.CustomHtmlEditor = CustomHtmlEditor;

    var FileEditor = function () { };
    methods = FileEditor.prototype = new ns.HtmlControlEditor();
    methods.initialize = function (metadata) {
        if (!this._initialized) {
            const id = metadata.id;
            metadata.id = "FM_" + id;
            Dynamicweb.Controls.EditableList.Editors.HtmlControlEditor.prototype.initialize.call(this, metadata);
            this._isRequired = metadata.required;
            this.metadata = metadata;
            var self = this;

            this._binder.bindProperty('value', [{
                elements: [],
                action: function (sender, args) {                    
                    var target = args.target;
                    let name = args.value;
                    let path = self.makePath(args.value);
                    _findOptionOrCreate(target._container, name, path, false, false)
                    target._container.value = name;
                    if (target._container.onchange && typeof (target._container.onchange) == 'function') {
                        target._container.onchange();
                    }
                }
            }]);
        }
    };

    methods.makePath = function (val) {
        let path = `/Files/${val}`;
        return path;
    };

    methods.set_value = function (obj) {
        this._container.value = obj;
    };

    methods.get_value = function () {
        return this._container.value;
    };
    ns.FileEditor = FileEditor;

})(Dynamicweb.Controls.EditableList.Editors);