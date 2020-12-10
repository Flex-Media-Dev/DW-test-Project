if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.ItemFieldOptionsEdit = function () {
    this._terminology = {};
    this._initialized = false;
    this._itemType = '';
    this._forms = [];
    this._sourceType = $('SourceTypeValue');
    this._parent = '';
    this._isTranslateOnly = false;
};

if (typeof (Dynamicweb.Items.ItemFieldOptionsEdit.Forms) == 'undefined') {
    Dynamicweb.Items.ItemFieldOptionsEdit.Forms = new Object();
}

/* Maybe a spelling error (dropdawn) */

Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn = function(dropdawn, values, callback) {
    dropdawn.length = 0;
    var method = function (e) { return new Option(e.Text, e.Value); };
    values.each(function (e) {
        dropdawn.options.add(method(e));
    });

    if (typeof (callback) !== 'undefined') {
        callback(dropdawn.value);
    }
};
/* Maybe a spelling error (dropdawn) */

Dynamicweb.Items.ItemFieldOptionsEdit._instance = null;

Dynamicweb.Items.ItemFieldOptionsEdit.get_current = function () {
    if (!Dynamicweb.Items.ItemFieldOptionsEdit._instance) {
        Dynamicweb.Items.ItemFieldOptionsEdit._instance = new Dynamicweb.Items.ItemFieldOptionsEdit();
    }

    return Dynamicweb.Items.ItemFieldOptionsEdit._instance;
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.isValidStrParam = function (param) {
    return ((typeof (param) !== 'undefined') && param.toString().trim() !== '');
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.get_terminology = function () {
    return this._terminology;
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.deleteRow = function (link) {
    var row = dwGrid_StaticSourceGrid.findContainingRow(link);

    if (row) {
        if (!this.get_isTranslateOnly()) {
            if (confirm(this.get_terminology()['DeleteOption'])) {
                dwGrid_StaticSourceGrid.deleteRows([row]);
            }
        }
    }
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.request = function (params, callback, hide) {
    if (typeof (params) === 'undefined') {
        return;
    }

    var that = this;

    params['IsAjax'] = true;
    params['ItemType'] = this._itemType;
    params['EditForm'] = this.get_sourceType();

    new Ajax.Request('/Admin/Content/Items/ItemTypes/ItemFieldOptionsEdit.aspx', {
        method: 'post',
        parameters: params,
        onSuccess: function(response) {
            if (typeof (callback) !== 'undefined') {
                callback(response);
            }
        },
        onFailure: function() {
            alert(this.get_terminology()['RequestFailure']);
        }
    });
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.get_isTranslateOnly = function () {
    return this._isTranslateOnly;
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.set_isTranslateOnly = function (value) {
    if (!typeof value === 'boolean') {
        return;
    }

    this._isTranslateOnly = value;
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.get_sourceType = function() {
    return this._sourceType.value;
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.set_sourceType = function (value) {
    this._sourceType.value = value;
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.get_form = function (id) {
    var form = this._forms[id];

    if (typeof (form) === 'undefined') {
        if (id === '0') {
            form = new Dynamicweb.Items.ItemFieldOptionsEdit.Forms.StaticSourceForm(id, this);
        } else if (id === '1') {
            form = new Dynamicweb.Items.ItemFieldOptionsEdit.Forms.SqlSourceForm(id, this, 'SqlSourceModel');
        } else if (id === '2') {
            form = new Dynamicweb.Items.ItemFieldOptionsEdit.Forms.ItemTypeSourceForm(id, this, 'ItemTypeSourceModel');
        }

        this.set_form(id, form);
    }

    return form;
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.set_form = function (id, form) {
    this._forms[id] = form;
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.toggleForm = function () {
    this.get_form(this.get_sourceType()).toggle();
};

Dynamicweb.Items.ItemFieldOptionsEdit.prototype.initialize = function (itemType) {
    var self = this;
    if (!this._initialized) {
        if (parent) {
            var frame = window.frameElement;
            var container = $(frame).up('div#dlgFieldOptions');
            parent.dialog.get_okButton(container).onclick = function () {
                self.get_form(self.get_sourceType()).save(function () {
                    document.getElementById('MainForm').submit();
                    parent.dialog.hide("dlgFieldOptions");
                });
            }
        }
             
        this._itemType = itemType;
        this._initialized = true;
        this.toggleForm();

        $$('#SourceTypeList input[type="radio"][value="' + this.get_sourceType() + '"]')[0].checked = true;

        $('SourceTypeList').on('change', 'input', (function (event, element) {
            this.set_sourceType(element.value);
            this.toggleForm();
        }).bind(this));

        if (this.get_isTranslateOnly()) {
            Dynamicweb.Utilities.CollectionHelper.forEach($$('input, select'), function (el) {
                el.writeAttribute('disabled', 'disabled');
            });
            Dynamicweb.Utilities.CollectionHelper.forEach($$('input.static-label'), function (el) {
                el.removeAttribute('disabled');
            });
        }
    }
};

Dynamicweb.Items.ItemFieldOptionsEdit.Forms.BaseForm = Class.create({
    initialize: function (id, parent, modelId) {
        this.id = 'edit-form-' + id;
        this.el = $(this.id);
        this.initialized = false;
        this.visible = false;
        this.parent = parent;
        this.isModelNew = true;
        this.modelSource = $(modelId);
        this.preloadData = $('PreloadData').value.trim();
        
        if (typeof (this.modelSource) !== "undefined") {
            this.model = this.modelSource.value.evalJSON();
        }
    },
    
    completeInitialize: function () {
        this.initialized = true;
        this.toggle();
    },
    
    canChangeValue: function () {
        return this.initialized || this.isModelNew;
    },

    toggle: function () {
        $$('.source-edit-form').each(function (item) { item.hide(); });
        if (this.initialized) {
            this.el.show();
            this.visible = true;
        }
    },
    
    validate: function(callback) {
        var success = function(response) {
            var isValid = true;
            if (response.responseText.trim() !== '') {
                alert(response.responseText);
                isValid = false;
            }
            
            if (typeof (callback) !== 'undefined') {
                callback(isValid);
            }
        };

        this.request({ Action: 'Validate', Source: this.modelSource.value }, success.bind(this), true);
    },
    
    save: function (callback) {
        if (typeof (this.modelSource) !== "undefined") {
            this.modelSource.value = Object.toJSON(this.model);
        }
        
        this.validate((function (isValid) {
            if (!isValid) {
                return;
            }

            if (typeof (callback) !== 'undefined') {
                callback();
            }
        }).bind(this));
    },
    
    request: function (parameters, callback, hide) {
        if (typeof parameters === "undefined" || parameters === null) {
            return;
        }
        
        this.parent.request(parameters, callback, hide);
    }
});

Dynamicweb.Items.ItemFieldOptionsEdit.Forms.StaticSourceForm = Class.create(Dynamicweb.Items.ItemFieldOptionsEdit.Forms.BaseForm, {
    initialize: function ($super, id, parent) {
        $super(id, parent);
        this.model = {};
        this.completeInitialize();
    },
    validate: function ($super, callback) {
        var isValid = true;
        var rowsCount = this.el.select('input.static-label').length + this.el.select('input.static-value').length;
        var filledRowsCount = this.el.select('input.static-label[value]').length + this.el.select('input.static-value[value]').length;

        if (rowsCount === 0) {
            isValid = false;
            alert("Create at least one row!");
        } else if (rowsCount !== filledRowsCount) {
            isValid = false;
            alert("All fields must be filled!");
        }

        if (typeof (callback) !== 'undefined') {
            callback(isValid);
        }
    }
});

Dynamicweb.Items.ItemFieldOptionsEdit.Forms.SqlSourceForm = Class.create(Dynamicweb.Items.ItemFieldOptionsEdit.Forms.BaseForm, {
    initialize: function ($super, id, parent, model) {
        $super(id, parent, model);
        this.nameFields = $('SqlNameFields');
        this.valueFields = $('SqlValueFields');
        this.queryString = this.el.select('textarea.sql-query-string')[0];
        this.btnValidate = this.el.select('input.sql-execute-btn')[0];

        this.isModelNew = this.model.QueryString === null || this.model.QueryString.trim() === '';

        this.queryString.on('blur', this.onQueryStringFocusLeave.bind(this));

        this.nameFields.on('change', (function (event, element) {
            this.onNameFieldsChange(element.value);
        }).bind(this));
        
        this.valueFields.on('change', (function(event, element) {
            this.onValueFieldsChange(element.value);
        }).bind(this));

        this.btnValidate.on('click', (function() {
            this.execute();
        }).bind(this));

        this.el.on('keydown', this.onKeyDown.bind(this));

        this.load(this.bind.bind(this));
    },
    
    load: function (callback) {

        if (!this.isModelNew) {
            var data = JSON.parse(this.preloadData);
            var queryFields = JSON.parse(data.QueryFields);

            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.nameFields, queryFields);
            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.valueFields, queryFields);
        } 

        if (typeof(callback) !== "undefined") {
            callback();
        }
    },
    
    bind: function () {

        this.queryString.value = this.model.QueryString || '';
        this.nameFields.value = this.model.NameField || '';
        this.valueFields.value = this.model.ValueField || '';
                
        this.completeInitialize();
    },
          
    onNameFieldsChange: function (value) {
        if (this.canChangeValue()) {
            this.model.NameField = value.trim();
        }
    },

    onValueFieldsChange: function (value) {
        if (this.canChangeValue()) {
            this.model.ValueField = value.trim();
        }
    },
    
    onQueryStringChange: function (value) {
        if (this.canChangeValue()) {
            this.model.QueryString = value.trim();
        }
    },
 
    onQueryStringFocusLeave: function (event, element) {
        var newText = element.value.replace(/\s+/g, '').toLowerCase();
        var original = this.model.QueryString.replace(/\s+/g, '').toLowerCase();

        if ((newText === original)) {
            return;
        }

        if (!this.isModelNew) {
            if (!confirm(this.parent.get_terminology()['ExecuteQuery'])) {
                element.value = this.model.QueryString;
                return;
            }
        }

        if (this.queryString.value.trim() !== '') {
            this.execute();
        }
    },
    
    onKeyDown: function(event, element) {
        if (!this.visible) {
            return;
        }

        if (event.keyCode === 13 && event.ctrlKey) {
            this.execute();
        }
    },

    execute: function (callback) {
        this.onQueryStringChange(this.queryString.value);
        this.onNameFieldsChange('');
        this.onValueFieldsChange('');
        
        this.nameFields.length = 1;
        this.valueFields.length = 1;

        var onSuccess = function (response) {
            var onError = (function() {
                alert(this.parent.get_terminology()['InvalidQuery']);
                this.queryString.focus();
            }).bind(this);

            if (response.responseText === '') {
                onError();
                return;
            }
            
            var fields = JSON.parse(response.responseText);

            if (typeof (fields) === "undefined" || fields.length <= 1) {
                onError();
                return;
            }

            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.nameFields, fields);
            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.valueFields, fields);

            if (typeof (callback) !== 'undefined') {
                callback();
            }
        };

        this.request({ Action: 'GetQueryFields', QueryString: this.queryString.value }, onSuccess.bind(this), true);
    }
});

Dynamicweb.Items.ItemFieldOptionsEdit.Forms.ItemTypeSourceForm = Class.create(Dynamicweb.Items.ItemFieldOptionsEdit.Forms.BaseForm, {
    initialize: function ($super, id, parent, model) {
        $super(id, parent, model);

        this.nameFields = $('ItemNameFields');
        this.valueFields = $('ItemValueFields');
        this.itemTypes = $('ItemItemTypes');
        this.areas = $('ItemSourceAreas');
        this.page = $('ItemTypeSourcePage');
        this.pageInput = $('Link_ItemTypeSourcePage');
        this.pageInput.readOnly = true;
        this.includeParagrpahItems = $('ItemSourceParagraphs');
        this.includeChildItems = $('ItemSourceChilds');

        this.isModelNew = this.model.ItemSystemName === null || this.model.ItemSystemName.trim() === '';

        this.nameFields.on('change', (function(event, element) {
            this.onNameFieldsChange(element.value);
        }).bind(this));
        
        this.valueFields.on('change', (function(event, element) {
            this.onValueFieldsChange(element.value);
        }).bind(this));

        this.itemTypes.on('change', (function (event, element) {
            this.onItemTypeChange(element.value);
        }).bind(this));
        
        this.areas.on('change', (function (event, element) {
            this.onAreasChange(element.value);
        }).bind(this));
        
        this.includeParagrpahItems.on('change', (function(event, element) {
            this.onParagraphsChange(element.checked);
        }).bind(this));
        
        this.includeChildItems.on('change', (function (event, element) {
            this.onChildItemsChange(element.checked);
        }).bind(this));
        
        this.el.on('change', 'input[type="radio"][name="item-source-type"]', (function (event, element) {
            this.onItemSourceTypeChange(element.value);
        }).bind(this));

        this.load(this.bind.bind(this));
    },
    
    load: function (callback) {
        if (!this.isModelNew) {
            var data = JSON.parse(this.preloadData);
            var areas = JSON.parse(data.Areas);
            var itemTypes = JSON.parse(data.ItemTypes);
            var itemFields = JSON.parse(data.ItemFields);

            if (data.Page) {
                var page = JSON.parse(data.Page);
                this.page.value = page.Id;
                this.pageInput.value = page.Name;
            }

            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.areas, areas, this.onAreasChange.bind(this));
            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.itemTypes, itemTypes, this.onAreasChange.bind(this));
            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.nameFields, itemFields, this.onNameFieldsChange.bind(this));
            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.valueFields, itemFields, this.onValueFieldsChange.bind(this));

            if (typeof(callback) !== "undefined") {
                callback();
            }

        } else {
            this.getItemTypes((function () {
                this.getAreas(callback.bind(this));
            }).bind(this));
        }
    },

    getItemTypes: function (callback) {
        var onSuccess = function (response) {
            var data = JSON.parse(response.responseText);

            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.itemTypes, data);

            if (typeof (callback) !== "undefined") {
                callback();
            }
        };

        this.parent.request({ Action: 'GetItemTypes' }, onSuccess.bind(this));
    },

    getAreas: function (callback) {
        var onSuccess = function (response) {
            var data = JSON.parse(response.responseText);

            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.areas, data);

            if (typeof (callback) !== "undefined") {
                callback();
            }
        };

        this.parent.request({ Action: 'GetAreas' }, onSuccess.bind(this));
    },

    bind: function () {
        var itemSourceSelector;
        this.includeParagrpahItems.checked = this.model.IncludeParagraphs || false;
        this.includeChildItems.checked = this.model.IncludeChilds || false;
        this.itemTypes.value = this.model.ItemSystemName || '';
        this.nameFields.value = this.model.NameField || '';
        this.valueFields.value = this.model.ValueField || '';
        this.areas.value = this.model.ItemSourceType === 1 ? this.model.ItemSourceId : '';

        var sourceType = this.model.ItemSourceType > 0 ? this.model.ItemSourceType : 1;
        itemSourceSelector = this.el.select('input[type="radio"][name="item-source-type"][value="' + sourceType + '"]')[0];
        itemSourceSelector.checked = true;
        this.onItemSourceTypeChange(itemSourceSelector.value);
        this.completeInitialize();
    },
    
    save: function ($super, callback) {
        if (this.model.ItemSourceType === 2) {
            var sourceId = parseInt(this.page.value.replace(/Default.aspx\?Id=/i, ''));
            if (!isNaN(sourceId)) {
                this.model.ItemSourceId = sourceId;   
            }
        }
        
        $super(callback);
    },

    onItemSourceTypeChange: function (value) {
        if (value === '1') {
            this.pageInput.disable();
            this.areas.enable();
            this.onChildItemsChange(false);
            this.includeChildItems.checked = false;
            this.includeChildItems.disable();
        }
        else if (value === '2') {
            this.areas.disable();
            this.pageInput.enable();
            this.includeChildItems.enable();
        }
        else if (value === '3') {
            this.pageInput.disable();
            this.areas.disable();
            this.onChildItemsChange(false);
            this.includeChildItems.checked = false;
            this.includeChildItems.disable();
        }
        else if (value === '4') {
            this.areas.disable();
            this.pageInput.disable();
            this.includeChildItems.enable();
        }

        if (this.canChangeValue()) {
            this.model.ItemSourceType = parseInt(value);
        }
    },

    onItemTypeChange: function (value, callback) {
        if (this.canChangeValue()) {
            this.model.ItemSystemName = value;
        }

        var onSuccess = function (response) {
            var fields = JSON.parse(response.responseText);

            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.nameFields, fields, this.onNameFieldsChange.bind(this));
            Dynamicweb.Items.ItemFieldOptionsEdit.FillDropdawn(this.valueFields, fields, this.onValueFieldsChange.bind(this));

            if (typeof(callback) !== 'undefined') {
                callback(value);
            }
        };

        this.parent.request({ Action: 'GetItemFields', SelectedItemType: value }, onSuccess.bind(this));
    },
    
    onNameFieldsChange: function (value) {
        if (this.canChangeValue()) {
            this.model.NameField = value;
        }
    },

    onValueFieldsChange: function (value) {
        if (this.canChangeValue()) {
            this.model.ValueField = value;
        }
    },
    
    onAreasChange: function (value) {
        if (this.canChangeValue()) {
            this.model.ItemSourceId = parseInt(value);
        }
    },

    onParagraphsChange: function (value) {
        if (this.canChangeValue()) {
            this.model.IncludeParagraphs = value;
        }
    },
    
    onChildItemsChange: function (value) {
        if (this.canChangeValue()) {
            this.model.IncludeChilds = value;
        }
    }
});