if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.ParagraphSettings = function () {
    var self = this;

    self._itemFields = {};
    self._areaId = 0;
    self._pageId = 0;
    self._paragraphId = 0;
    self._pageTypes = 2;
    self._expression = null;
    self._pageList = undefined;
    self._itemList = undefined;
    self._namedItemList = undefined;
    self._translations = {};
    self._includeParagraphs = null;
    self._isInitialized = false;
}

Dynamicweb.Items.ParagraphSettings._instance = null;

Dynamicweb.Items.ParagraphSettings.get_current = function () {
    if (!Dynamicweb.Items.ParagraphSettings._instance) {
        Dynamicweb.Items.ParagraphSettings._instance = new Dynamicweb.Items.ParagraphSettings();
    }

    return Dynamicweb.Items.ParagraphSettings._instance;
}

Dynamicweb.Items.ParagraphSettings.prototype.request = function (options) {
    var self = this;

    if (!options) {
        return;
    }

    if (!options.params && !options.params.action) {
        return;
    }

    options.params.AreaId = self.get_areaId();
    options.params.PageId = self.get_pageId();
    options.params.Id = self.get_paragraphId();
    options.params.ItemType = self.get_itemType();
    options.params.IsAjax = true;

    new Ajax.Request('/Admin/Module/ItemPublisher/ItemPublisher_Edit.aspx', {
        method: 'POST',
        parameters: options.params,
        onCreate: function () {
            if (self._overlay) {
                self._overlay.show();
            }
        },
        onSuccess: function (transport) {
            var json;

            if (transport.responseText.isJSON()) {
                json = transport.responseText.evalJSON();
            }

            if (options.callback) {
                options.callback(transport.responseText, json);
            }
        },
        onFailure: function () {
            alert(self.get_translation('Error'));
        },
        onComplete: function () {
            if (self._overlay) {
                setTimeout(function () {
                    self._overlay.hide();
                }, 250);

            }
        }
    });
}

Dynamicweb.Items.ParagraphSettings.prototype.get_itemType = function () {
    var ret = '';
    var itemType = document.getElementsByName('ItemType')[0];

    if (itemType) {
        if (itemType.selectedIndex >= 0 && !itemType.disabled && itemType.options.length > 0) {
            ret = itemType.options[itemType.selectedIndex].value;
        }
    }

    return ret;
}

Dynamicweb.Items.ParagraphSettings.prototype.get_areaId = function () {
    return this._areaId;
}

Dynamicweb.Items.ParagraphSettings.prototype.set_areaId = function (value) {
    this._areaId = parseInt(value, 10);

    if (isNaN(this._areaId) || this._areaId == null || this._areaId < 0) {
        this._areaId = 0;
    }
}

Dynamicweb.Items.ParagraphSettings.prototype.get_pageId = function () {
    return this._pageId;
}

Dynamicweb.Items.ParagraphSettings.prototype.set_pageId = function (value) {
    this._pageId = parseInt(value, 10);

    if (isNaN(this._pageId) || this._pageId == null || this._pageId < 0) {
        this._pageId = 0;
    }
}

Dynamicweb.Items.ParagraphSettings.prototype.get_paragraphId = function () {
    return this._paragraphId;
}

Dynamicweb.Items.ParagraphSettings.prototype.set_paragraphId = function (value) {
    this._paragraphId = parseInt(value);

    if (isNaN(this._paragraphId) || this._paragraphId == null || this._paragraphId < 0) {
        this._paragraphId = 0;
    }
}

Dynamicweb.Items.ParagraphSettings.prototype.get_pageTypes = function () {
    return this._pageTypes;
}

Dynamicweb.Items.ParagraphSettings.prototype.set_pageTypes = function (value) {
    this._pageTypes = parseInt(value);
}

Dynamicweb.Items.ParagraphSettings.prototype.get_listSourceType = function () {
    var ret = '';
    var listSourceTypes = document.getElementsByName('ListSourceType');

    for (var i = 0; i < listSourceTypes.length; i++) {
        if (listSourceTypes[i].checked) {
            ret = listSourceTypes[i].value;
            break;
        }
    }

    return ret;
}

Dynamicweb.Items.ParagraphSettings.prototype.get_translation = function (key) {
    return this._translations[key] || '';
}

Dynamicweb.Items.ParagraphSettings.prototype.set_translation = function (key, value) {
    this._translations[key] = value;
}

Dynamicweb.Items.ParagraphSettings.prototype.initialize = function (params) {
    var self = this,
        itemFieldsListAll,
        itemFieldsAll,
        listSourceTypes,
        onChanged,
        listViewContainer;
    
    if (self._isInitialized) {
        return;
    }

    window["paragraphEvents"].setBeforeSave(self.onSave.bind(self));

    listSourceTypes = document.getElementsByName('ListSourceType');
    onChanged = function () { self.onListSourceTypeChanged(self.get_listSourceType()); };
    listViewContainer = $$('table[data-view="ListViewMode"]')[0];
    
    self._includeParagraphs = new Dynamicweb.Items.Checkbox('IncludeParagraphItems');
    self._includeParagraphs.initialize();

    self._includeChildren = new Dynamicweb.Items.Checkbox('IncludeAllChildItems');
    self._includeChildren.initialize();

    self._includeInheritedItems = new Dynamicweb.Items.Checkbox('IncludeInheritedItems');
    self._includeInheritedItems.initialize();

    self._showSecurityItems = new Dynamicweb.Items.Checkbox('ShowSecurityItems');
    self._showSecurityItems.initialize();

    self._pageList = new Dynamicweb.Items.PageList({
        id: 'ListSourcePage',
        areaID: this.get_areaId(),
        pageTypes: this.get_pageTypes()
    });
    self._pageList.initialize();

    self._itemList = new Dynamicweb.Items.ItemList({
        id: 'SourceItemEntries',
        areaID: this.get_areaId(),
        module: self
    });
    self._itemList.initialize();

    self._namedItemList = params.namedItemList;
    document.getElementById("NamedListPageID").value = params.namedListPage.id;
    document.getElementById("NamedListPageIdText").value = params.namedListPage.title;

    self._itemFieldsValue = $('ItemFieldsSelected');
    self._itemFieldsListValue = $('ItemFieldsListSelected');

    self._overlay = new overlay('ParagraphEditModuleOverlay');

    document.on('change', 'input[data-type="number"]', function (event, element) {
        var value,
            defValue,
            minValue,
            maxValue,
            parseValue = function (v, def) {
                v = parseInt(v, 10);

                if (def && typeof (def) !== 'number') {
                    def = parseValue(def);
                }

                if (isNaN(v) || v == null || v <= 0) {
                    v = def || 1;
                }

                return v;
            },
            getValue = function (from) {
                var el, result = NaN;

                if (from) {
                    if (from.startsWith('#')) {
                        el = $$(from)[0];

                        if (el && el.value) {
                            result = parseValue(el.value);
                        }
                    } else {
                        result = parseValue(from);
                    }
                }

                return result;
            };

        defValue = getValue(element.readAttribute("data-default-value"));
        minValue = getValue(element.readAttribute("data-min-value"));
        maxValue = getValue(element.readAttribute("data-max-value"));
        value = parseValue(element.value, defValue);

        if ((!isNaN(minValue) && minValue >= value) || (!isNaN(maxValue) && maxValue <= value)) {
            value = defValue;
        }

        element.value = value.toString();
    });

    document.on('change', 'input[data-model="ListViewMode"]', function (event, element) {
        var initinalClassName = listViewContainer.readAttribute('data-class'),
            partialClassName = element.value;

        listViewContainer.writeAttribute("class", 'formsTable ' + initinalClassName + '-' + partialClassName.toLowerCase());
    });

    Event.observe(document.getElementsByName('ItemType')[0], 'change', function (e) {
        var elm = Event.element(e);
        self.updateFieldDependentInputs(elm.options[elm.selectedIndex].value);
    });

    Event.observe($('AllowEditing'), 'click', function (e) {
        var elm = Event.element(e);
        self.onAllowEditingToggle(elm);
    });
    
    for (var i = 0; i < listSourceTypes.length; i++) {
        Event.observe(listSourceTypes[i], 'click', onChanged);
        Event.observe(listSourceTypes[i], 'change', onChanged);
    }

    self.onListSourceTypeChanged(self.get_listSourceType());
    self.updateFieldDependentInputs(self.get_itemType());

    document.on('change', 'input[name="ItemFields"], input[name="ItemFieldsList"]', function (e) {
        self.onItemFieldsToggle(e.target);
    });

    self.onItemFieldsToggle($$('input[name="ItemFields"]:checked')[0]);
    self.onItemFieldsToggle($$('input[name="ItemFieldsList"]:checked')[0]);

    self._isInitialized = true;
}

Dynamicweb.Items.ParagraphSettings.prototype.onSave = function () {
    //this.get_expression().commitChanges();
    this.onRuleCombinationChanged($('RulesCombinationOr').checked ? 1 : 2);
    document.getElementById('ItemRulesEditor_DataXML').value = this.get_expression().toXml();
}

Dynamicweb.Items.ParagraphSettings.prototype.onItemFieldsToggle = function (element) {
    var id = element.readAttribute('id'),
        name = element.readAttribute('name'),
        option = id.replace(name, '').toLowerCase(),
        selectionBoxId = name + 'Selector',
        wrapperId = selectionBoxId + 'Wrapper';

    if (option === 'all') {
        $(wrapperId).hide();
        SelectionBox.selectionRemoveAll(selectionBoxId);
    } else if (option === 'selected') {
        SelectionBox.selectionAddAll(selectionBoxId);
        $(wrapperId).show();
    }
}

Dynamicweb.Items.ParagraphSettings.prototype.updateFieldDependentInputs = function (itemType, onComplete) {
    var self = this,
        inputs = [
            { id: 'ListOrderBy', type: 'dropdown' },
            { id: 'ListSecondOrderBy', type: 'dropdown' },
            { id: 'ItemFieldsSelector', type: 'selection-box' },
            { id: 'ItemFieldsListSelector', type: 'selection-box'}
        ];

    inputs.each(function (input) { self.beginUpdateFieldDependentInput(input); });

    this.getItemFields(itemType, function (fields) {
        inputs.each(function (input) { self.updateFieldDependentInput(input, fields);});

        inputs.each(function (input) { self.endUpdateFieldDependentInput(input); });

        (onComplete || function () { })();
    });

    this.onNamedListPageChanged();

    var expression = this.get_expression();
    if (expression) {
        expression.set_ruleFieldsProvider( function (onComplete) {
            self.loadRuleFields(itemType, onComplete);
        });
        expression.reloadRules();
    }

}

Dynamicweb.Items.ParagraphSettings.prototype.beginUpdateFieldDependentInput = function (input) {
    var ids = [];

    if (input.type === 'selection-box') {
        ids.push(input.id + '_lstLeft');
        ids.push(input.id + '_lstRight');
    } else {
        ids.push(input.id);
    }

    ids.each(function (id) {
        var control = document.getElementById(id)
        if (control) {
            control.disabled = true;
        }
    });
}

Dynamicweb.Items.ParagraphSettings.prototype.endUpdateFieldDependentInput = function (input) {
    var ids = [],
        type = input.type,
        id = input.id;

    if (type === 'selection-box') {
        ids.push(id + '_lstLeft');
        ids.push(id + '_lstRight');
    } else {
        ids.push(id);
    }

    ids.each(function (val) {
        var control = document.getElementById(val),
            disabled = true;
        if (control && control.options) {
            disabled = control.options.length == 0;
            if (type === 'selection-box') {
                if (disabled) {
                    if (val === id + '_lstLeft') {
                        SelectionBox.setNoDataLeft(id);
                    } else {
                        SelectionBox.setNoDataRight(id);
                    }
                }
            }

            control.disabled = disabled;
        }
    });
}

Dynamicweb.Items.ParagraphSettings.prototype.updateFieldDependentInput = function (input, fields, onSelected) {
    var self = this,
        id = input.id,
        type = input.type,
        control = null,
        visible,
        selected,
        inArray = function (ar, v) {
            var ret = false;

            for (var i = 0; i < ar.length; i++) {
                if (ar[i] == v) {
                    ret = true;
                    break;
                }
            }

            return ret;
        },
        getIndex = function (obj, v) {
            return obj ? obj[v] : -1;;
        },
        addOption = function (e, f) {
            var o = document.createElement('option');
            o.text = f.Name;
            o.value = f.SystemName;

            e.options[e.options.length] = o;
        };

    if (type === 'selection-box') {
        control = {
            left: document.getElementById(id + '_lstLeft'),
            right: document.getElementById(id + '_lstRight')
        };

        if (!control.left || !control.right) {
            return;
        }

        control.left.options.length = 0;
        control.right.options.length = 0;

        visible = fields.findAll(function (field) { return inArray(field.Visible, id) && !inArray(field.Selected, id); });
        selected = fields.findAll(function (field) { return inArray(field.Visible, id) && inArray(field.Selected, id); });

        if (selected && selected.length > 0) {
            selected = selected.sortBy(function (field) { return getIndex(field.Indexes, id); });
        }

        visible.each(function (field) {
            addOption(control.left, field);
        });

        selected.each(function (field) {
            addOption(control.right, field);
        });
        
        if (self['on' + id + 'Change']) {
            control.left.disabled = false;
            control.right.disabled = false;
            self['on' + id + 'Change'].call(self);
        }
    } else {
        control = document.getElementById(id);

        if (!control) {
            return;
        }

        control.options.length = 0;

        fields.each(function (field) {
            if (inArray(field.Visible, id)) {
                var o = document.createElement('option');

                o.text = field.Name;
                o.value = field.SystemName;
                o.selected = inArray(field.Selected, id);

                control.options[control.options.length] = o;
            }
        });
    }
}

Dynamicweb.Items.ParagraphSettings.prototype.getItemFields = function (itemType, onComplete) {
    var self = this;

    onComplete = onComplete || function () { };

    if (this._itemFields[itemType] && typeof (this._itemFields[itemType].length) != 'undefined') {
        onComplete(this._itemFields[itemType]);
    } else {
        this.loadItemFields(itemType, function (fields) {
            self._itemFields[itemType] = fields;

            onComplete(fields);
        });
    }
}

Dynamicweb.Items.ParagraphSettings.prototype.loadItemFields = function (itemType, onComplete) {
    var url = '/Admin/Module/ItemPublisher/ItemPublisher_Edit.aspx?cmd=GetItemFields';

    new Ajax.Request(url, {
        method: 'get',
        parameters: {
            ID: this.get_paragraphId(),
            PageID: this.get_pageId(),
            ItemType: encodeURIComponent(itemType),
            nocache: new Date().getTime()
        },
        onComplete: function (transport) {
            var fields = [];

            if (transport && transport.responseText) {
                try {
                    fields = transport.responseText.evalJSON();
                } catch (ex) { }

                if (!fields) {
                    fields = [];
                }
            }

            onComplete(fields);
        }
    });
}

Dynamicweb.Items.ParagraphSettings.prototype.get_expression = function () {
    /// <summary>Gets the reference to expression editor control.</summary>

    var obj = null;
    var ret = this._expression;

    if (ret) {
        if (typeof (ret) == 'string') {
            try {
                obj = eval(ret);
            } catch (ex) { }

            if (obj) {
                ret = obj;
                this._expression = obj;
            }
        }
    }

    return ret;
}


Dynamicweb.Items.ParagraphSettings.prototype.set_expression = function (value) {
    /// <summary>Sets the reference to expression editor control.</summary>
    /// <param name="value">The reference to expression editor control.</param>
    this._expression = value;
}

Dynamicweb.Items.ParagraphSettings.prototype.onRuleCombinationChanged = function (operator) {
    /// <summary>Groups the currently selected nodes with the specified combine operator.</summary>
    /// <param name="operator">Combine operator.</param>

    var ids = [];
    var selection = [];

    if (this.get_expression()) {
        selection = this.get_expression().get_tree()._nodes;

        for (var i = 0; i < selection.length; i++) {
            ids[ids.length] = selection[i].get_id();
        }

        operator = parseInt(operator);

        if (operator == null || isNaN(operator) || operator < 0) {
            operator = 2; /* AND */
        }

        operator = Dynamicweb.Controls.RulesEditor.CombineMethod.parse(operator);

        this.get_expression().get_tree().breakCombination(ids);
        this.get_expression().get_tree().combine(ids, operator);
        this.get_expression().clearSelection();
    }
}

Dynamicweb.Items.ParagraphSettings.prototype.loadRuleFields = function (itemType, onComplete) {
    var url = '/Admin/Module/ItemPublisher/ItemPublisher_Edit.aspx?IsAjax=true&AjaxAction=LoadRules';

    new Ajax.Request(url, {
        method: 'get',
        parameters: {
            ItemType: itemType,
            nocache: new Date().getTime(),
            PageId: this.get_pageId(),
            AreaId: this.get_areaId()
        },
        onComplete: function (transport) {
            var fields = null;

            if (transport && transport.responseJSON) {
                try {
                    fields = transport.responseJSON;  
                } catch (ex) { }
            }

            onComplete(fields);
        }
    });
}

Dynamicweb.Items.ParagraphSettings.prototype.onListSourceTypeChanged = function (sourceType) {
    var self = this,
        f = null,
        inputs = [],
        fields = $$('.list-source-type');

    sourceType = (sourceType || '').toLowerCase();

    for (var i = 0; i < fields.length; i++) {
        f = $(fields[i]);
        if (f.hasClassName('list-source-type-' + sourceType)) f.show();
        else f.hide();
    }

    self._includeChildren.disabled((sourceType == 'area' || sourceType == 'selfarea' || sourceType === 'itementry' || sourceType === 'itementries' || sourceType === 'namedlist'));
    if (self._includeChildren.disabled() && self._isInitialized) {
        self._includeChildren.checked(false);
    }

    self._includeInheritedItems.disabled(sourceType === 'itementry' || sourceType === 'itementries' || sourceType === 'namedlist');
    if (self._includeInheritedItems.disabled() && self._isInitialized) {
        self._includeInheritedItems.checked(false);
    }

    self._includeParagraphs.disabled(sourceType === 'itementry' || sourceType === 'itementries' || sourceType === 'namedlist');
    if (self._includeParagraphs.disabled() && self._isInitialized) {
        self._includeParagraphs.checked(false);
    }
    
    self._showSecurityItems.disabled(sourceType === 'itementry' || sourceType === 'itementries' || sourceType === 'namedlist');
    if (self._showSecurityItems.disabled() && self._isInitialized) {
        self._showSecurityItems.checked(false);
    }
    
    if (sourceType === 'itementry') {
        $$('.list-settings').invoke('hide');
    } else {
        $$('.list-settings').invoke('show');
    }
    
    if (sourceType === 'itementry' || sourceType === 'itementries') {
        $$('.filtering-settings').invoke('hide');
    } else {
        $$('.filtering-settings').invoke('show');
    }
}

Dynamicweb.Items.ParagraphSettings.prototype.onAllowEditingToggle = function (chkAllowEditing) {
    if (chkAllowEditing.checked) $('errorMessages').show();
    else $('errorMessages').hide();
}


Dynamicweb.Items.ParagraphSettings.prototype.onItemEntrySelect = function (element) {
    var self = this, el = element;
    var itemType = el.readAttribute('data-page-itemtype') || el.readAttribute('data-paragraph-itemtype');
    if (this.get_itemType() != itemType) {
        return { closeMenu: false };
    }

    if (self._itemList) {
        self.request({
            params: {
                AjaxAction: 'ValidateItemEntry',
                ItemEntryPageId: element.readAttribute('data-page-id'),
                ItemEntryParagraphId: element.readAttribute('data-paragraph-id'),
            },
            callback: function(responseText, json) {
                var error = '';
                
                if (json) {
                    error = json.Error || '';
                } else {
                    error = self.get_translation['Error'];
                }

                if (!error) {
                    // clear data for further transferring
                    el.writeAttribute('data-page-id', '');
                    el.writeAttribute('data-page-name', '');
                    el.writeAttribute('data-page-itemtype', '');
                    el.writeAttribute('data-paragraph-id', '');
                    el.writeAttribute('data-paragraph-name', '');
                    el.writeAttribute('data-paragraph-itemtype', '');

                    // must be checked for paragraphs for permission checking.
                    self._includeParagraphs.checked(json.StructureType === 1);
                    self._itemList.add(json.Id, json.Title);
                } else {
                    alert(error);
                }
            }
        });
    }
}

Dynamicweb.Items.ParagraphSettings.prototype.onItemFieldsListChange = function () {
    this.onSelectionBoxChange('ItemFieldsListSelector', this._itemFieldsListValue);
}

Dynamicweb.Items.ParagraphSettings.prototype.onItemFieldsChange = function () {
    this.onSelectionBoxChange('ItemFieldsSelector', this._itemFieldsValue);
}

Dynamicweb.Items.ParagraphSettings.prototype.onSelectionBoxChange = function (selectionBoxId, storage) {
    var values = SelectionBox.getElementsRightAsArray(selectionBoxId);
    storage.value = values.toString();
}

Dynamicweb.Items.ParagraphSettings.prototype.selectNamedListPage = function () {
    var self = this;

    var callback = function (options, model) {
        document.getElementById("NamedListPageID").value = model.Selected;
        document.getElementById("NamedListPageIdText").value = model.SelectedPageName;
        self.onNamedListPageChanged();
    }

    var dlgAction = createLinkDialog(LinkDialogTypes.Page, [], callback);

    Action.Execute(dlgAction);

    return self;
}

Dynamicweb.Items.ParagraphSettings.prototype.onNamedListPageChanged = function () {
    var pageId = document.getElementById("NamedListPageID").value;
    var url = '/Admin/Module/ItemPublisher/ItemPublisher_Edit.aspx?cmd=GetNamedLists';
    var namedListCtrl = $('TargetNamedList');
    var selectedValue = namedListCtrl.value || this._namedItemList;
    namedListCtrl.options.length = 0;

    new Ajax.Request(url, {
        method: 'get',
        parameters: {
            PageID: pageId,
            ItemType: encodeURIComponent(this.get_itemType()),
            nocache: new Date().getTime()
        },
        onComplete: function (transport) {
            var fields = [];

            if (transport && transport.responseText) {
                try {
                    fields = transport.responseText.evalJSON();
                } catch (ex) { }

                if (!fields) {
                    fields = [];
                }
            }
            namedListCtrl.innerHTML = "";
            fields.each(function (field) {
                var o = document.createElement('option');
                o.text = field.Name;
                o.value = field.Id;
                if (o.value == selectedValue) {
                    o.selected = true;
                }

                namedListCtrl.options[namedListCtrl.options.length] = o;
            });
        }
    });
}

Dynamicweb.Items.PageList = function(options) {
    var self = this;

    self._id = options.id;
    self._el = $(self._id + '_Control');
    self._list = self._el.select('td.list-source-type-page-content ul')[0];
    self._buttons = self._el.select('td.list-source-type-page-toolbar ul')[0];
    self._pageSelector = $(self._id + '_Selector');
    self._valuesStorage = $(self._id);
    self._values = [];
    self._areaID = options.areaID;
    self._pageTypes = options.pageTypes;
    self._selected = undefined;
    self._isEnabled = true;
    self._isInitialized = false;
    self._enumerateList = function (callback) {
        var i, length;
        
        if (!callback) {
            return;
        }

        length = self._list.children.length;

        for (i = 0; i < length; i += 1) {
            callback.apply(self, [self._list.children[i]]);
        }
    };
    self._updateValues = function () {
        var id;
        self._values.length = 0;
        self._enumerateList(function (el) {
            id = el.readAttribute('data-value');
            
            if (id) {
                self._values.push(id);
            }
        });

        self._valuesStorage.value = self._values.join(',');
    };
    self._onDisable = function () {
        var i, childCount = self._list.children.length - 1;

        for (i = childCount; i >= 0; i--) {
            self._list.children[i].remove(0);
        }

        self._updateValues();
    };
    self._onClick = function(event, element) {
        if (!self._isEnabled) {
            return;
        }

        var action = self[element.readAttribute('data-action')];

        if (action) {
            action.apply(self, [element]);
        }
    };
}

Dynamicweb.Items.PageList.prototype.select = function (sender) {
    var self = this;

    var callback = function (options, model) {
            self.add(model.Selected, model.SelectedPageName);
    }

    var dlgAction = createLinkDialog(LinkDialogTypes.Page, ['TypesPermittedForChoosing=' + self._pageTypes], callback);

    Action.Execute(dlgAction);    
    
    return self;
}

Dynamicweb.Items.PageList.prototype.add = function (id, name) {
    var self = this, page;
    
    if (!id || !name) {
        return;
    }
    
    if (self._values.any(function (value) { return value === id; })) {
        return;
    }

    page = new Element('li');
    page.writeAttribute('data-value', id);
    page.writeAttribute('data-action', 'selected');
    page.innerHTML = name;
    self._list.appendChild(page);
    self._updateValues();

    return self;
}

Dynamicweb.Items.PageList.prototype.remove = function (sender) {
    var self = this, length;

    if (!self._selected) {
        return;
    }
    
    self._list.removeChild(self.selected());
    length = self._list.children.length;

    self._selected = undefined;
    if (length > 0) {
        self.selected(self._list.children[length - 1]);
    }

    self._updateValues();

    return self;
}

Dynamicweb.Items.PageList.prototype.selected = function (value) {
    var self = this;
    if (value && value['nodeName'] && value['nodeName'].toLocaleLowerCase() === 'li') {
        self._list.select('li').each(function (i) {
            i.removeClassName('selected');
        });

        value.addClassName('selected');
        self._selected = value;
    }
    
    return self._selected;
}

Dynamicweb.Items.PageList.prototype.initialize = function () {
    var self = this;
    if (!self._isInitialized) {
        self._list.on('click', 'li', self._onClick);
        self._buttons.on('click', 'a', self._onClick);
        self._updateValues();

        self._isInitialized = true;
    }

    return self;
}

// Item entries list control

Dynamicweb.Items.ItemList = function (options) {
    var self = this;

    self._id = options.id;
    self._areaID = options.areaID;
    self._module = options.module;
    self._el = $(self._id + '_Control');
    self._list = self._el.select('td.list-source-type-itementries-content ul')[0];
    self._buttons = self._el.select('td.list-source-type-itementries-toolbar ul')[0];
    self._itemSelector = $(self._id + '_Selector');
    self._valuesStorage = $(self._id);
    self._values = [];
    self._selected = undefined;
    self._isEnabled = true;
    self._isInitialized = false;

    if (self._itemSelector) {
        self._itemSelector.onchange = (function (e) {
            return self._module.onItemEntrySelect(this);
        }).bind();
    }
    self._enumerateList = function (callback) {
        var i, length;

        if (!callback) {
            return;
        }

        length = self._list.children.length;

        for (i = 0; i < length; i += 1) {
            callback.apply(self, [self._list.children[i]]);
        }
    };
    self._updateValues = function () {
        var id;
        self._values.length = 0;
        self._enumerateList(function (el) {
            id = el.readAttribute('data-value');

            if (id) {
                self._values.push(id);
            }
        });

        self._valuesStorage.value = self._values.join(',');
    };
    self._onDisable = function () {
        var i, childCount = self._list.children.length - 1;

        for (i = childCount; i >= 0; i--) {
            self._list.children[i].remove(0);
        }

        self._updateValues();
    };
    self._onClick = function (event, element) {
        if (!self._isEnabled) {
            return;
        }

        var action = self[element.readAttribute('data-action')];

        if (action) {
            action.apply(self, [element]);
        }
    };
}

Dynamicweb.Items.ItemList.prototype.select = function (el) {
    var self = this;

    var callback = function (options, model) {
        self.add(model.ParagraphItemID || model.SelectedPageItemId, model.ParagraphName || model.SelectedPageName);
    }
    var dlgAction = createLinkDialog(el.readAttribute('data-type') == "paragraph" ? LinkDialogTypes.Paragraph : LinkDialogTypes.Page, ['ItemTypesPermittedForChoosing='+ self._module.get_itemType()], callback);

    Action.Execute(dlgAction);
}

Dynamicweb.Items.ItemList.prototype.add = function (id, name) {
    var self = this, item;

    if (!id || !name) {
        return;
    }

    if (self._values.any(function (value) { return value === id; })) {
        return;
    }

    item = new Element('li');
    item.writeAttribute('data-value', id);
    item.writeAttribute('data-action', 'selected');
    item.innerHTML = name;
    self._list.appendChild(item);
    self._updateValues();

    return self;
}

Dynamicweb.Items.ItemList.prototype.remove = function (sender) {
    var self = this, length;

    if (!self._selected) {
        return;
    }

    self._list.removeChild(self.selected());
    length = self._list.children.length;

    self._selected = undefined;
    if (length > 0) {
        self.selected(self._list.children[length - 1]);
    }

    self._updateValues();

    return self;
}

Dynamicweb.Items.ItemList.prototype.selected = function (value) {
    var self = this;
    if (value && value['nodeName'] && value['nodeName'].toLocaleLowerCase() === 'li') {
        self._list.select('li').each(function (i) {
            i.removeClassName('selected');
        });

        value.addClassName('selected');
        self._selected = value;
    }

    return self._selected;
}

Dynamicweb.Items.ItemList.prototype.initialize = function () {
    var self = this;
    if (!self._isInitialized) {
        self._list.on('click', 'li', self._onClick);
        self._buttons.on('click', 'a', self._onClick);
        self._updateValues();

        self._isInitialized = true;
    }

    return self;
}

Dynamicweb.Items.Checkbox = function (id) {
    /// <summary>Allows to save disabled checkboxes.</summary>  
    var self = this;

    self._id = id;
    self._isInitialized = false;
    self._controls = {
        wrapper: $(id + '_Control'),
        view: $(id + '_View'),
        value: $(id)
    };
}

Dynamicweb.Items.Checkbox.prototype.disabled = function (value) {
    var self = this;
    
    if (typeof (value) === 'boolean') {
        self._controls.view.disabled = value;
    }

    return self._controls.view.disabled;
}

Dynamicweb.Items.Checkbox.prototype.checked = function (value) {
    var self = this;
    
    if (typeof (value) === 'boolean') {
        self._controls.view.checked = value;
        self._controls.value.value = value;
    }

    return self._controls.view.checked;
}

Dynamicweb.Items.Checkbox.prototype.initialize = function() {
    var self = this;
    
    if (self._isInitialized) {
        return;
    }

    self._controls.view.on('change', function() {
        self._controls.value.value = self._controls.view.checked;
    });

    self._isInitialized = true;
}