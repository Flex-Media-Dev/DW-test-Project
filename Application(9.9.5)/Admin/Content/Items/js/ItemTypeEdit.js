if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = {};
}

Dynamicweb.Items.ItemTypeEdit = function () {
    this._base = '';
    this._category = '';
    this._name = '';
    this._systemName = '';
    this._description = '';
    this._isCodeFirst = false;
    this._fieldForTitle = '';
    this._layout = {};
    this._terminology = {};
    this._currentSettings = {};
    this._currentSettingsTarget = null;
    this._currentGroup = null;
    this._editorTypes = null;

    this._tempLayout = {};
    this._autoId = 0;
    this._optionsDialogId = null;
    this._defaultEditorType = '';
    this._listItemEditorType = '';
    this._advancedSettingsIsDirty = false;

    this._canEditItemSystemName = false;
    this._canEditGroupSystemName = false;
    this._canEditFieldSystemName = false;

    this._preventClick = false;
    this._canEditDefaultValue = false;
    this._fieldSystemNameTimer = null;
    this._askConfirmation = false;
    this._isDialogOpened = false;

    this._isFileManagerInitialized = false;
    this._icon = '';
    this._iconColor = '';
};

Dynamicweb.Items.ItemTypeEdit._instance = null;

Dynamicweb.Items.ItemTypeEdit.get_current = function () {
    if (!Dynamicweb.Items.ItemTypeEdit._instance) {
        Dynamicweb.Items.ItemTypeEdit._instance = new Dynamicweb.Items.ItemTypeEdit();
    }

    return Dynamicweb.Items.ItemTypeEdit._instance;
};

Dynamicweb.Items.ItemTypeEdit.reloadPageTree = function (ret) {    
    Dynamicweb.Items.ItemTypeEdit.get_current().disable_Confirmation();
    if (ret.warning) {
        parent.Action.Execute(ret.warning, {});
    }
    var ancestorsIds = ret.treeAncestors.slice();
    if (ret.close) { // duplicate top node for executing two actions on it: refresh and select
        ancestorsIds.push(ret.treeAncestors[0]);
    }
    dwGlobal.getSettingsNavigator().expandAncestors(ancestorsIds, ret.treeAncestors, true);
};

Dynamicweb.Items.ItemTypeEdit.prototype.get_terminology = function () {
    return this._terminology;
};

Dynamicweb.Items.ItemTypeEdit.prototype.set_systemNameLength = function (value) {
    this._maxSystemNameLength = value;
};

Dynamicweb.Items.ItemTypeEdit.prototype.set_item = function (value) {
    this._name = value.Name;
    this._systemName = value.SystemName;
    this._description = value.Description;
    this._isCodeFirst = value.IsCodeFirst;
};

Dynamicweb.Items.ItemTypeEdit.prototype.set_base = function (value) {
    this._base = value;
};

Dynamicweb.Items.ItemTypeEdit.prototype.get_base = function () {
    return this._base;
};

Dynamicweb.Items.ItemTypeEdit.prototype.set_category = function (value) {
    if (typeof (value) === 'undefined') {
        return;
    }

    if (!this._category) {
        this._category = $('txCategory');
    }

    this._category.value = value;
};

Dynamicweb.Items.ItemTypeEdit.prototype.get_category = function () {
    if (!this._category) {
        this._category = $('txCategory');
    }

    return this._category.value;
};

Dynamicweb.Items.ItemTypeEdit.prototype.set_fieldForTitle = function (value) {
    if (typeof (value) === 'undefined') {
        return;
    }

    $('txFieldForTitle').value = value;
    this._fieldForTitle = value;
};

Dynamicweb.Items.ItemTypeEdit.prototype.get_optionsDialogId = function () {
    return this._optionsDialogId;
};

Dynamicweb.Items.ItemTypeEdit.prototype.set_optionsDialogId = function (value) {
    this._optionsDialogId = value;
};

Dynamicweb.Items.ItemTypeEdit.prototype.get_canEditDefaultValue = function () {
    return this._canEditDefaultValue;
};

Dynamicweb.Items.ItemTypeEdit.prototype.set_canEditDefaultValue = function (value) {
    this._canEditDefaultValue = !!value;
};

Dynamicweb.Items.ItemTypeEdit.prototype.get_layout = function () {
    return this._layout;
};

Dynamicweb.Items.ItemTypeEdit.prototype.set_layout = function (value) {
    var token = '';
    var name = null;
    var totalFields = 0;
    var f = $('Layout');
    this._layout = value;
    var fieldToToken = {};
    this._tempLayout = {};
    if (this._layout) {
        f.value = Object.toJSON(this._layout);

        // Converting layout object to a flat list
        if (this._layout.Groups) {
            for (var i = 0; i < this._layout.Groups.length; i++) {
                if (this._layout.Groups[i].Fields) {
                    for (var j = 0; j < this._layout.Groups[i].Fields.length; j++) {
                        token = this._newToken();

                        this._tempLayout[token] = {
                            group: this._layout.Groups[i].SystemName,
                            position: j
                        };

                        // Maintaining the relationship between existing fields and new tokens
                        fieldToToken[this._layout.Groups[i].Fields[j].SystemName] = token;

                        totalFields += 1;
                    }
                }
            }
        }

        if (totalFields > 0) {
            var arrLi = this._get_ItemFields();
            for (var i = 0; i < arrLi.length; i++) {
                name = this._getSystemNameFieldValue(arrLi[i]);
                if (name && name.length) {
                    token = fieldToToken[name];

                    if (token && token.length) {
                        this._getLayoutTokenField(arrLi[i]).value = token;
                    }
                }
            }
        }
    } else {
        f.value = '';
        this._layout = {};

    }
};

Dynamicweb.Items.ItemTypeEdit.prototype._get_ItemGroups = function () {
    var items = $$('ul[id="items"] > li');

    return items;
};

Dynamicweb.Items.ItemTypeEdit.prototype._get_ItemFields = function () {
    var items = $$('ul[id="items"] ul li');

    return items;
};

Dynamicweb.Items.ItemTypeEdit.prototype.set_DialogOpenedState = function () {
    var self = this;
    self._isDialogOpened = true;
    setTimeout(function () { self._isDialogOpened = false; }, 500);
};

Dynamicweb.Items.ItemTypeEdit.prototype.enable_Confirmation = function () {
    this._askConfirmation = true;
};

Dynamicweb.Items.ItemTypeEdit.prototype.disable_Confirmation = function () {
    this._askConfirmation = false;
};

Dynamicweb.Items.ItemTypeEdit.prototype.dialogER_Okaction = function () {
    this.enable_Confirmation();
    dialog.hide('dlgEditRestrictions');
};

Dynamicweb.Items.ItemTypeEdit.prototype.initialize = function () {
    var self = this,
        allAreasOption,
        structureTypeRule,
        structureTypeRuleParagraph,
        moduleRule,
        moduleRuleInput,
        moduleRuleLabel,
        moduleRuleContainer,
        pageViewSelectContainer,
        areaRules,
        editorTypesJSON;
    var toggleModuleRuleCheckbox = function (show) {
        if (show) {
            moduleRuleContainer.show();
        } else {
            moduleRuleInput.checked = false;
            moduleRuleContainer.hide();
        }
    };
    var togglePageViewSelect = function (show) {
        if (show) {
            pageViewSelectContainer.show();
        } else {
            pageViewSelectContainer.hide();
        }
    };

    //+ 'all' toggling
    areaRules = $$('ul.area-restriction-rule li input');
    allAreasOption = areaRules.find(function (e) {
        return e.value.strip() === '*';
    });

    if (allAreasOption && !allAreasOption.disabled) {
        if (allAreasOption.checked) {
            areaRules.each(function (e) {
                e.disabled = e.value.strip() !== '*';
            });
        }

        allAreasOption.on('click', function (ev, el) {
            areaRules.each(function (e) {
                if (e.value.strip() !== '*') {
                    e.disabled = el.checked;
                }
            });
        });
    }
    //-

    structureTypeRule = $$('ul.structure-type-restriction-rule')[0];

    //+ 'Page default view' checkbox handling
    structureTypeRulePage = structureTypeRule.select('li')[1];
    structureTypeRulePage.on('change', 'input[type="checkbox"]', function (event, element) {
        if (element.value === 'Pages') {
            togglePageViewSelect(element.checked);
        }
    });
    pageViewSelectContainer = $('pageViewSelectContainer')
    togglePageViewSelect(structureTypeRulePage.select('input[type="checkbox"]')[0].checked);
    //-


    //+ 'Allow module attachment' checkbox handling
    structureTypeRuleParagraph = structureTypeRule.select('li')[2];
    structureTypeRuleParagraph.on('change', 'input[type="checkbox"]', function (event, element) {
        if (element.value === 'Paragraphs') {
            toggleModuleRuleCheckbox(element.checked);
        }
    });

    moduleRule = $$('ul.module-attachment-restriction-rule li')[0];
    moduleRuleInput = moduleRule.select('input[type="checkbox"]')[0];
    moduleRuleLabel = moduleRule.select('label')[0];

    moduleRuleContainer = $('paragraphViewSelectContainer');
    var valueCell = moduleRuleContainer.cells[1];
    valueCell.appendChild(moduleRuleInput);
    valueCell.appendChild(moduleRuleLabel);
    moduleRule.remove();

    toggleModuleRuleCheckbox(structureTypeRuleParagraph.select('input[type="checkbox"]')[0].checked);
    //-

    editorTypesJSON = $$('.editor-types-json')[0];
    if (editorTypesJSON && editorTypesJSON.value.isJSON()) {
        self._editorTypes = editorTypesJSON.value.evalJSON().evalJSON();
    }

    if (!this._isCodeFirst) {
        this._initSortables();
        Draggables.addObserver({
            onEnd: function (eventName, draggable, event) {
                if (draggable.element.hasClassName("item-field")) {
                    var pos = Dynamicweb.Items.ItemTypeEdit.get_current().get_rowPosition(draggable.element);
                    Dynamicweb.Items.ItemTypeEdit.get_current().updateLayout({
                        row: draggable.element,
                        group: pos.group,
                        position: pos.position
                    });
                }

                Dynamicweb.Items.ItemTypeEdit.get_current()._preventClick = true;
                setTimeout(function () { Dynamicweb.Items.ItemTypeEdit.get_current()._preventClick = false; }, 200);
                Dynamicweb.Items.ItemTypeEdit.get_current().enable_Confirmation();
            }
        });

        // Fix: Prototype includes scroll offsets 
        Position.includeScrollOffsets = true;

        // Fix: https://prototype.lighthouseapp.com/projects/8887/tickets/322-sortablecreate-breaks-onclick-in-ie9
        Draggables.activate = function (draggable) {
            if (draggable.options.delay) {
                this._timeout = setTimeout(function () {
                    Draggables._timeout = null;
                    // window.focus();
                    Draggables.activeDraggable = draggable;
                }.bind(this), draggable.options.delay);
            } else {
                // window.focus();
                this.activeDraggable = draggable;
            }
        }

        Event.observe($('param-editortype'), 'change', function (e) {
            self._validateFieldDefaultValue();
            self._onFieldTypeChanged();
        });

        this._icon = $("SmallIcon").value;
        this._iconColor = $("IconColor").value;

        Event.observe($('dlgIconSettings').select('#IconColorSelect')[0], 'change', function (e) {
            var newColor = e.target.value;
            var newColorClassName = e.target.options[e.target.selectedIndex].className;
            var iconBlocks = $('dlgIconSettings').select("div.icon-block");
            iconBlocks.forEach(function (block) {
                var classes = block.select('i')[0].classList;
                if (classes.length > 3 || newColorClassName === "") {
                    classes.remove(classes[classes.length - 1]);
                }
                if (newColorClassName !== "") {
                    classes.add(newColorClassName);
                }
            });
            self._iconColor = newColor;
        });

        var iconBlocks = $('dlgIconSettings').select("div.icon-block");
        iconBlocks.forEach(function (block) {
            Event.observe(block, 'click', function (e) {
                $('dlgIconSettings').select('div[class="icon-block selected"]')[0].className = "icon-block";
                this.classList.add("selected")
                self._icon = this.select('span')[0].textContent;
                self.selectIcon();
            });
        });
        
        Event.observe($('IconSearch'), 'keyup', function (e) {
            var searchText = e.target.value.toLowerCase();
            iconBlocks.forEach(function (block) {
                if (!searchText || block.select('span')[0].textContent.toLowerCase().indexOf(searchText) > -1) {
                    block.show();
                } else {
                    block.hide();
                }
            });
        });

        // Autocompletion for category field
        new Ajax.Autocompleter('txCategory', 'txCategoryAutocompleteMenu', '/Admin/Content/Items/ItemTypes/ItemTypeEdit.aspx?AJAX=CategoryAutocompletion', {
            indicator: 'txCategoryAutocompleteIndicator'
        });

        $('edit-options-activator').observe('click', function () {
            var url = '/Admin/Content/Items/ItemTypes/ItemFieldOptionsEdit.aspx?';

            url += 'ItemType=' + encodeURIComponent(self._systemName);
            url += '&ItemField=' + encodeURIComponent(self._currentSettings.SystemName);
            url += '&ItemFieldToken=' + encodeURIComponent(self._currentSettings.Token);

            dialog.show(self.get_optionsDialogId(), url);
        });

        $('validate-defaultvalue-activator').observe('click', function () {
            self._validateFieldDefaultValue();
        });

        $('insert-regex-activator').observe('click', function (e) {
            var lnk = Event.element(e);

            if (!lnk.hasClassName('activator-disabled')) {
                dialog.show('dlgRegularExpressions');
            }
        });

        /* Auto-open "General settings" dialog if it's a new item type */
        if (!this._systemName || !this._systemName.length) {
            setTimeout(function () {
                self.openGeneralSetting();
            }, 150);
        }

        window.onbeforeunload = (function () {
            if (this._askConfirmation && !this._isDialogOpened) {
                this._askConfirmation = false;
                setTimeout(function () {
                        var screenLoader = document.getElementById("screenLoaderOverlay");
                        if (screenLoader) {
                            screenLoader.style.display = "none";
                        }
                    }, 150);
                return this.get_terminology()['NotSavedWarningMessage'];
            }
        }).bind(this);
    } // End of if(!this._isCodeFirst)
};

Dynamicweb.Items.ItemTypeEdit.chooseRegexp = function () {
    var field = $('param-validationexpression').value = $$('input[name=ChooseRegexp]:checked')[0].value;
    dialog.hide('dlgRegularExpressions');
}

Dynamicweb.Items.ItemTypeEdit.showItemListParameterOptions = function (itemFieldValue) {
    var self = Dynamicweb.Items.ItemTypeEdit.get_current();
    var url = '/Admin/Content/Items/ItemTypes/ItemFieldListOptionsEdit.aspx?';

    url += 'ItemType=' + encodeURIComponent(self._systemName);
    url += '&ItemField=' + encodeURIComponent(self._currentSettings.SystemName);
    url += '&ItemFieldToken=' + encodeURIComponent(self._currentSettings.Token);
    url += '&ItemFieldValue=' + encodeURIComponent($(itemFieldValue).value);

    dialog.show(self.get_optionsDialogId(), url);
};

Dynamicweb.Items.ItemTypeEdit.onRichSelectChanged = function (value, e, controlId) {
    if (controlId === 'Item_type') {
        var sortBy = $('Sort_by');
        if (sortBy) {
            var selected = sortBy.value;
            while (sortBy.options.length > 1) {
                sortBy.options.remove(sortBy.options.length - 1);
            }

            var url = "/Admin/Content/Items/ItemTypes/ItemTypeEdit.aspx?AJAX=LoadItemTypeFields";
            new Ajax.Request(url, {
                parameters: {
                    SystemName: value
                },
                onSuccess: function (transport) {
                    try {
                        var jsonObj = transport.responseText ? transport.responseText.evalJSON() : {};
                        var errorMessage = jsonObj.ErrorMessage;
                        if (!errorMessage) {
                            if (jsonObj.Fields) {
                                jsonObj.Fields.forEach(function (f) {
                                    var opt = document.createElement('option');
                                    opt.value = f.Value;
                                    opt.innerHTML = f.Name;
                                    sortBy.appendChild(opt);
                                });
                                sortBy.value = selected;
                            }
                        } else {
                            alert(errorMessage);
                        }
                    } catch (e) {
                        alert(e);
                    }
                },
                onFailure: function () {
                    alert('Something went wrong!');
                }
            });
        }
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype._onFieldTypeChanged = function (isInherited) {
    var self = this;
    var ctrl = $('param-editortype');
    var allowChooseExpression = false;
    var opt = $(ctrl.options[ctrl.selectedIndex]);

    isInherited || (isInherited = false);

    $('edit-options-activator').setStyle({
        'display': opt.hasClassName('field-type-list') && !opt.hasClassName('field-type-list-editable') ? 'block' : 'none'
    });

    $('AdvDialog_DataSettings').setStyle({
        'display': (opt.value == "Dynamicweb.Content.Items.Editors.ItemTypeEditor, Dynamicweb") ? 'none' : 'block'
    });
    $('AdvDialog_ValidationSettings').setStyle({
        'display': (opt.value == "Dynamicweb.Content.Items.Editors.ItemTypeEditor, Dynamicweb") ? 'none' : 'block'
    });

    allowChooseExpression = opt.hasClassName('field-type-plain');

    $('param-validationexpression').disabled = !allowChooseExpression || isInherited || this._isCodeFirst;

    if (allowChooseExpression) {
        $('insert-regex-activator').removeClassName('disabled');
        $('insert-regex-activator').removeClassName('activator-disabled');
        $('insert-regex-image').removeClassName('activator-disabled');
    }
    else {
        $('insert-regex-activator').addClassName('disabled');
        $('insert-regex-activator').addClassName('activator-disabled');
        $('insert-regex-image').addClassName('activator-disabled');
    }

    updateParameters(ctrl, 'div_Dynamicweb.Content.Items.Editors.Editor_parameters', 'ConfigurableEditorAddin');
};

Dynamicweb.Items.ItemTypeEdit.prototype._initSortables = function () {
    Sortable.create('items', { tag: 'li', dropOnEmpty: true });

    var groups = this._get_ItemGroups();
    var groupNames = [];
    for (var i = 0; i < groups.length; i++) {
        var name = this._getSystemNameGroupValue(groups[i]);
        groupNames[i] = 'fields_' + name;
    }

    for (var i = 0; i < groupNames.length; i++) {
        Sortable.create(groupNames[i], { tag: 'li', containment: groupNames, dropOnEmpty: true });
    }

};

Dynamicweb.Items.ItemTypeEdit.prototype.get_rowPosition = function (row) {
    var fieldsUL = row.parentElement;
    var groupRow = fieldsUL.parentElement;

    var pos = 1;
    var fields = fieldsUL.childElements();
    for (i = 0; i < fields.length; i++) {
        if (fields[i] == row) {
            pos = i + 1;
            break;
        }
    }

    return {
        group: this._getSystemNameGroupValue(groupRow),
        position: pos
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.openGeneralSetting = function () {
    this.set_DialogOpenedState();
    var name = $('txName'),
        systemName = $('txSystemName'),
        description = $('txDescription'),
        category = $('txCategory'),
        fieldForTitle = $('ddFieldForTitle'),
        title = $('txTitle'),
        base = $('txBase');

    name.value = this._name;
    systemName.value = this._systemName;
    description.value = this._description;
    base.value = this._base;

    if (this._isCodeFirst) {
        name.disable();
        systemName.disable();
        description.disable();
        category.disable();
        fieldForTitle.disable();
        title.disable();
        base.disable();
        $('pageViewSelect').disable();
        $('cbIncludeInUrlIndex').disable();
    }

    var generalRestrictionsTable = $('general-restrictions-row').select('table')[0];
    generalRestrictionsTable.setStyle({
        'border-spacing': '0px'
    });

    this._fillFields(this._fieldForTitle);

    dialog.show('dlgGeneralSettings');

    try {
        $('txName').focus();
    } catch (ex) { }
};

Dynamicweb.Items.ItemTypeEdit.prototype._fillFields = function (selectedItem) {
    var dd = $('ddFieldForTitle');
    dd.options.length = 0;
    dd.options[0] = new Option("", "");

    var self = this;
    var arrLi = this._get_ItemFields();
    arrLi.each(function (f) {
        var name = self._getNameFieldValue(f);
        var systemName = self._getSystemNameFieldValue(f);
        dd.options[dd.options.length] = new Option(name, systemName, systemName == selectedItem, systemName == selectedItem);
    });
};

Dynamicweb.Items.ItemTypeEdit.prototype.validateCategory = function (callback) {
    var self = this,
        url = '/Admin/Content/Items/ItemTypes/ItemTypeEdit.aspx',
        parameters = {
            AJAX: 'CategoryValidation',
            Category: this.get_category()
        };

    new Ajax.Request(url, {
        parameters: parameters,
        onSuccess: function (transport) {
            var obj, errorMsg = '';

            if (transport.responseText.isJSON()) {
                obj = transport.responseText.evalJSON();

                if (obj.Error) {
                    errorMsg = obj.Error;
                } else if (obj.Category) {
                    self.set_category(obj.Category.FullName);
                }
            } else {
                errorMsg = self.get_terminology()['UknownError'];
            }

            if (errorMsg) {
                alert(errorMsg);
            } else if (callback) {
                callback();
            }
        }
    });
};

Dynamicweb.Items.ItemTypeEdit.prototype.validateItem = function (isDialogOK) {
    var ret = true;
    var name = $('txName');
    var systemName = $('txSystemName');
    var fieldForTitle = $('txFieldForTitle');
    var title = $('txTitle');
    var nativeFields = Dynamicweb.Utilities.CollectionHelper.where(this._get_ItemFields(), function (i) { return !i.hasClassName('inherited'); });

    if (!name.value || !name.value.length) {
        try {
            if (!isDialogOK) dialog.show('dlgGeneralSettings');
            name.focus();
        } catch (ex) { }
        ret = false;
        if (isDialogOK) alert(this.get_terminology()['EmptyName']);
    } else if (!systemName.value || !systemName.value.length) {
        try {
            if (!isDialogOK) dialog.show('dlgGeneralSettings');
            systemName.focus();
        } catch (ex) { }
        ret = false;
        if (isDialogOK) alert(this.get_terminology()['EmptySystemName']);
    } else if (systemName.value.length > this._maxSystemNameLength) {
        try {
            if (!isDialogOK) dialog.show('dlgGeneralSettings');
            systemName.focus();
        } catch (ex) { }
        ret = false;
        if (isDialogOK) alert(this.get_terminology()['TooLongSystemName']);
    } else if (!isDialogOK && !nativeFields.length) {
        ret = false;
        alert(this.get_terminology()['EmptyFields']);
    }

    if (ret && title.value) {
        var re = new RegExp("{{([0-9a-zA-Z_]+)}}");
        var m = re.exec(title.value);
        if (m != null) {
            var regexFieldName = m[1];
            var isFieldExist = false;
            var arrLi = this._get_ItemFields();
            for (var i = 0; i < arrLi.length; i++) {
                var fieldSystemName = this._getSystemNameFieldValue(arrLi[i]);
                if (fieldSystemName == regexFieldName) { isFieldExist = true; }
            }
            if (!isFieldExist) {
                ret = false;
                alert(this.get_terminology()['NoSuchField']);
                if (!isDialogOK) this.openGeneralSetting();
            }
        }
    }

    if (ret) {
        // Check that item of list type doesn't contain fields of list type
        var limitToRestriction = $$('#general-restrictions-row input:checkbox[value=ItemList]');
        if (limitToRestriction.length > 0) {
            if (limitToRestriction[0].checked) {
                var arrLi = this._get_ItemFields();
                for (var i = 0; i < arrLi.length; i++) {
                    var advancedSettingsField = this._getAdvancedSettingsField(arrLi[i]);
                    if (advancedSettingsField) {
                        var fieldSettings = eval('(' + advancedSettingsField.value + ')');
                        if (fieldSettings.Type.indexOf(this._listItemEditorType) == 0) {
                            ret = false;
                            alert(this.get_terminology()['ItemListInList']);
                            if (!isDialogOK) dialog.show('dlgGeneralSettings');
                            break;
                        }
                    }
                }
            }
        }
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype.saveGeneralSettings = function () {
    var self = this, func;

    self.enable_Confirmation();

    if (!self.validateItem(true)) {
        return;
    }
    self.set_fieldForTitle($('ddFieldForTitle').value);

    if (!self._canEditItemSystemName) {
        self._name = $('txName').value;
        self._description = $('txDescription').value;

        func = function () {
            dialog.hide('dlgGeneralSettings');
        };
    } else {
        func = function () {
            var url = "/Admin/Content/Items/ItemTypes/ItemTypeEdit.aspx?ValidateItem=true",
                parameters = {
                    SystemName: $('txSystemName').value
                };

            new Ajax.Request(url, {
                parameters: parameters,
                onSuccess: function (transport) {
                    try {
                        var jsonObj = transport.responseText.evalJSON();
                        var errorMessage = jsonObj.ErrorMessage;
                        if (!errorMessage) {
                            self._name = $('txName').value;
                            self._systemName = $('txSystemName').value;
                            self._description = $('txDescription').value;
                            self._base = $('txBase').value;
                            $('Inherits').value = self._base;

                            self._get_ItemFields().select(function (f) { return !f.hasClassName('inherited'); }).each(function (f) {
                                var settings = self._getAdvancedSettings(f);

                                if (settings) {
                                    settings.parent = self._systemName;
                                    self._setAdvancedSettings(f, settings);
                                }
                            });

                            dialog.hide('dlgGeneralSettings');
                        } else {
                            alert(Dynamicweb.Items.ItemTypeEdit.get_current().get_terminology()['SystemNameShouldBeUnique']);
                        }
                    } catch (e) {
                        alert(e);
                    }
                },
                onFailure: function () {
                    alert('Something went wrong!');
                }
            });
        };
    }

    self.validateCategory(func);
};

Dynamicweb.Items.ItemTypeEdit.prototype.save = function (close) {
    var self = this;
    this.disable_Confirmation();
    $('txName').value = this._name;
    $('txSystemName').value = this._systemName;
    $('txDescription').value = this._description;
    if (this.validateItem(false)) {
        this.commitLayout();
        this.commitAdvancedSettings();
        $('Save').value = 'true';
        $('Close').value = (!!close).toString();
        $('cmdSave').disable();
        $('cmdSaveAndClose').disable();

        Dynamicweb.Items.ItemTypeEdit.show_overlay();
        $('MainForm').request({
            onComplete: function (response) {
                if (200 == response.status && response.responseJSON) {
                    var ret = response.responseJSON;
                    Dynamicweb.Items.ItemTypeEdit.reloadPageTree(ret);
                }
                else {
                    Dynamicweb.Items.ItemTypeEdit.hide_overlay();
                    alert(self.get_terminology()['UknownError']);
                }
            }
        });
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.cancel = function () {
    location.href = "ItemTypeList.aspx";
};

Dynamicweb.Items.ItemTypeEdit.prototype.add_field = function (groupName) {
    this.set_DialogOpenedState();
    this._currentSettingsTarget = null;

    dialog.setTitle('dlgAdvanced', this.get_terminology()['EditAdvancedSettings']);
    dialog.show('dlgAdvanced');
    try {
        $("param-name").focus();
    } catch (ex) { }

    this._currentSettings = {
        Token: this._newOptionsToken(),
        Name: '',
        SystemName: '',
        Type: this._defaultEditorType,
        GroupName: groupName,
        NewField: true,
        Parent: this._systemName
    };
    this.initializeAdvancedSettings(this._currentSettings);
};

Dynamicweb.Items.ItemTypeEdit.prototype.add_group = function () {
    this.set_DialogOpenedState();
    this.openGroupSettings();
};

Dynamicweb.Items.ItemTypeEdit.prototype.openGroupSettings = function (link) {
    if (this._isCodeFirst) {
        $("GroupName").disable();
        $("GroupSystemName").disable();
        $("GroupCollapsibleState").disable();
    }

    var visibilityRule = new VisibilityRule();
    visibilityRule.set_terminology(VisibilityRuleTerminology);
    visibilityRule.set_itemType(this);
    var isGeneralGroup = false;
    if (link) {
        if (this._getSystemNameGroupValue(this.findContainingRow(link)) == "General") {
            isGeneralGroup = true;
            document.getElementById("visibilitySettingsTab").style.display = "none";
        } else {
            document.getElementById("visibilitySettingsTab").style.display = "";
        };
    } else {
        document.getElementById("visibilitySettingsTab").style.display = "";
    };

    if (!isGeneralGroup) {
        $("GroupVisibilityField").appendChild(visibilityRule._getItemFields(this.findContainingRow(link)));
    };

    if (link) {
        if (this._preventClick) return;
        this._canEditGroupSystemName = false;
        this._currentGroup = this.findContainingRow(link);
        $("GroupName").value = this._getNameGroupValue(this._currentGroup);
        $("GroupSystemName").value = this._getSystemNameGroupValue(this._currentGroup);
        $("GroupCollapsibleState").value = this._getCollapsibleGroupValue(this._currentGroup);
        $("GroupSystemName").disable();

        if (!isGeneralGroup) {
            visibilityRule.set_existingValues(this._getVisibilityFieldGroupValue(this._currentGroup), this._getVisibilityConditionValueGroupValueType(this._currentGroup), this._getVisibilityConditionGroupValue(this._currentGroup), this._getVisibilityConditionValueGroupValue(this._currentGroup));
        };
    }
    else {
        this._currentGroup = null;
        $("GroupName").value = "";
        $("GroupSystemName").value = "";
        $("GroupSystemName").enable();
        $("GroupCollapsibleState").value = "0";
        $("GroupVisibilityCondition").style.display = "none";
        $("GroupVisibilityConditionValue").style.display = "none";
    }

    if (!isGeneralGroup) {
        $("GroupVisibilityCondition").appendChild(visibilityRule._createConditionDropDown());
        $("GroupVisibilityConditionValue").appendChild(visibilityRule._createValueCtrl());
    };

    dialog.show('dlgGroupSetting');
    try {
        $("GroupName").focus();
    } catch (ex) { }

};

Dynamicweb.Items.ItemTypeEdit.prototype.validateGroup = function () {
    var ret = false;
    var name = $("GroupName").value;
    var systemName = $("GroupSystemName").value.toLowerCase();

    if (!name || !name.length) {
        try {
            $("GroupName").focus();
        } catch (ex) { }

        alert(this.get_terminology()['EmptyName']);
    }
    else if (!systemName || !systemName.length) {
        try {
            $("GroupSystemName").focus();
        } catch (ex) { }

        alert(this.get_terminology()['EmptySystemName']);
    }
    else ret = true;

    if (ret && this._canEditGroupSystemName) {
        // SystemField can be edited only for new field
        var arrLi = this._get_ItemGroups();
        for (var i = 0; i < arrLi.length; i++) {
            var sn = this._getSystemNameGroupValue(arrLi[i]).toLowerCase();
            if (sn == systemName) {
                ret = false;
                alert(this.get_terminology()['SystemNameShouldBeUnique']);
                break;
            }
        }
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype.init_group = function () {
    if (!this.validateGroup()) return;

    var name = $("GroupName").value;
    var systemName = $("GroupSystemName").value;
    var collapse = $("GroupCollapsibleState").value;

    var isGeneral = (systemName == "General");
    if (!isGeneral) {
        var visibilityField = $("visibility-rule-field").value;
        var VisibilityCondition = $("visibility-rule-condition").value;
        var VisibilityConditionValueType = $("visibility-rule-condition-value-type").value;
        var VisibilityConditionValue = $("visibility-rule-condition-value").value;
    };
    if (this._currentGroup) {
        this._setNameGroupValue(this._currentGroup, name);
        this._setCollapsibleGroupValue(this._currentGroup, collapse);

        if (!isGeneral) {
            this._setVisibilityFieldGroupValue(this._currentGroup, visibilityField);
            this._setVisibilityConditionGroupValue(this._currentGroup, VisibilityCondition);
            this._setVisibilityConditionValueGroupValueType(this._currentGroup, VisibilityConditionValueType);
            this._setVisibilityConditionValueGroupValue(this._currentGroup, VisibilityConditionValue);
        };
    }
    else {
        var newGroup = $('newGroupTemplate').innerHTML;
        newGroup = newGroup.replace("__NewGroup__", name).replace(new RegExp("__NewGroupSystemName__", "g"), systemName);
        newGroup = newGroup.replace(new RegExp("__NewGroupCollapsible__", "g"), collapse);

        newGroup = newGroup.replace(new RegExp("__NewVisibilityField__", "g"), visibilityField);
        newGroup = newGroup.replace(new RegExp("__NewVisibilityCondition__", "g"), VisibilityCondition);
        newGroup = newGroup.replace(new RegExp("__NewVisibilityConditionValueType__", "g"), VisibilityConditionValueType);
        newGroup = newGroup.replace(new RegExp("__NewVisibilityConditionValue__", "g"), VisibilityConditionValue);

        $('items').insert(newGroup);
    }

    dialog.hide('dlgGroupSetting');
    this._initSortables();
    this.enable_Confirmation();
};

Dynamicweb.Items.ItemTypeEdit.showRestrictions = function () {
    Dynamicweb.Items.ItemTypeEdit.get_current().set_DialogOpenedState();
    dialog.show('dlgEditRestrictions');
};

Dynamicweb.Items.ItemTypeEdit.prototype.onAdvancedSettingsKeyPressed = function (e) {
    var code = typeof (e.keyCode) != 'undefined' ? e.keyCode : e.charCode;

    if (code == 13) { // Enter
        this.saveAdvancedSettings();
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.onAfterEditItemName = function (input) {
    if (input && input.value && input.value.length) {

        var systemName = $('txSystemName');
        if (systemName && (!systemName.value || !systemName.value.length)) {
            this._canEditItemSystemName = true;
        }

        if (this._canEditItemSystemName) {
            systemName.value = Dynamicweb.Items.Global.makeSystemName(input.value);
        }
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.onAfterEditGroupName = function (input) {
    if (input && input.value && input.value.length) {

        var systemName = $('GroupSystemName');
        if (systemName && (!systemName.value || !systemName.value.length)) {
            this._canEditGroupSystemName = true;
        }

        if (this._canEditGroupSystemName) {
            systemName.value = Dynamicweb.Items.Global.makeSystemName(input.value);
        }
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.onAfterEditFieldName = function (input) {
    var self = this;

    if (input && input.value && input.value.length) {

        var systemName = $('param-systemname');
        if (systemName && (!systemName.value || !systemName.value.length)) {
            this._canEditFieldSystemName = true;
        }

        if (this._canEditFieldSystemName) {
            systemName.value = Dynamicweb.Items.Global.makeSystemName(input.value);

            if (this._fieldSystemNameTimer) {
                clearTimeout(this._fieldSystemNameTimer);
                this._fieldSystemNameTimer = null;
            }

            this._fieldSystemNameTimer = setTimeout(function () {
                self._validateFieldSystemName(systemName.value, function (newSystemName) {
                    systemName.value = newSystemName;
                });
            }, 500);
        }
    }
}

Dynamicweb.Items.ItemTypeEdit.prototype.onAfterEditSystemName = function (input) {
    if (input) {
        input.value = Dynamicweb.Items.Global.makeSystemName(input.value);
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.onAfterSelectBase = function (select) {
    this._base = select.value;
};

/* Retrieves containing row by its child element */
Dynamicweb.Items.ItemTypeEdit.prototype.findContainingRow = function (element) {
    var ret = null;

    if (element) {
        element = $(element);

        if (element.descendantOf($("items"))) {
            while (element) {
                if ((element.tagName + '').toLowerCase() == 'li') {
                    ret = element;
                    break;
                } else {
                    if (typeof (element.up) == 'function')
                        element = element.up();
                    else
                        break;
                }
            }
        }
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype.openAdvancedSettings = function (link) {
    this.set_DialogOpenedState();
    if (this._preventClick) return;

    var name = null;
    var row = this.findContainingRow(link);

    if (row) {
        name = this._getNameFieldValue(row) || "?";

        this._currentSettingsTarget = this._getAdvancedSettingsField(row);
        if (this._currentSettingsTarget) {
            this._currentSettings = eval('(' + this._currentSettingsTarget.value + ')');
            if (!this._currentSettings) this._currentSettings = {};
        }

        if (name.length > 43) name = name.substring(0, 40) + "...";
        dialog.setTitle('dlgAdvanced', this.get_terminology()['EditAdvancedSettings'] + ': ' + name);

        this.initializeAdvancedSettings(this._currentSettings);

        dialog.show('dlgAdvanced');
        try {
            $("param-name").focus();
        } catch (ex) { }
        $('SystemNameOrigin').value = $('param-systemname').value
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.initializeAdvancedSettings = function (settings) {
    var token = '';
    var totalFields = 0;
    var selectedPosition = 0;
    var groupName = '';
    var max = 0, i;
    var layoutLabels = $$('.layout-field-label');
    var editorTypesList = $('param-editortype');
    var dialog = $('dlgAdvanced');
    if (!dialog) return;
    var inheritanceInfo = dialog.select('#InfoBar_InheritanceInfo')[0];
    var inheritanceInfoContainer = inheritanceInfo.select('.alert-container')[0];
    var infoHTML = '';
    var disable = function () {
        dialog.select('input, select, textarea').invoke('disable');
    };
    var enable = function () {
        dialog.select('input, select, textarea').invoke('enable');
    };
    var toggleInfo = function (show) {
        if (show) {
            inheritanceInfo.removeClassName('hidden');
        } else {
            inheritanceInfo.addClassName('hidden');
        }
    };

    if (editorTypesList && this._editorTypes.Groups) {

        max = editorTypesList.childNodes.length - 1;

        for (i = max; 0 <= i; i -= 1) {
            editorTypesList.childNodes[i].remove();
        }

        this._editorTypes.Groups.each(function (g) {
            var addGroup = false, optGrp = document.createElement('optgroup');
            optGrp.writeAttribute('label', g.Name);

            g.Editors.each(function (f) {
                var addOption = false;

                if (settings.NewField) {
                    addOption = f.BaseType.strip() !== "Dynamicweb.Content.Items.Editors.ItemListEditor, Dynamicweb";
                } else if (f.BaseType.strip() === settings.BaseType.strip()) {
                    addOption = true;
                }

                if (addOption) {
                    addGroup = true;
                    var option = document.createElement('option');
                    option.writeAttribute('value', f.Type);
                    option.innerHTML = f.Name;
                    option.addClassName(f.CssClass.join(' '));

                    optGrp.appendChild(option);
                }
            });

            if (addGroup) {
                editorTypesList.appendChild(optGrp);
            }
        });
    }

    this.resetAdvancedSettings();

    if (!settings) settings = this._currentSettings;

    if (!settings.Token) {
        settings.Token = this._newOptionsToken();
    }

    if (settings.IsInherited) {
        disable();
        infoHTML = '<span>' + this.get_terminology()['InheritedField'];
        infoHTML += '<a href="/Admin/Content/Items/ItemTypes/ItemTypeEdit.aspx?SystemName=' + settings.Parent + '"><strong> ' + settings.Parent + '.</strong></a></span>';
        var alertIcon = inheritanceInfoContainer.select('i')[0].outerHTML;
        inheritanceInfoContainer.innerHTML = alertIcon + ' ' + infoHTML;
    } else if (this._isCodeFirst) {
        disable();
    } else {
        enable();
    }

    toggleInfo(settings.IsInherited);

    $('param-token').value = settings.Token || '';
    $('param-name').value = settings.Name;
    $('param-systemname').value = settings.SystemName;
    $('param-description').value = settings.Description || '';
    $('param-parent').value = settings.Parent || '';

    if (!settings.NewField) {
        $('param-systemname').disable();
    } else {
        $('param-systemname').enable();
    }

    editorTypesList.value = settings.Type;

    $('paramRequired').checked = !!settings.Required;
    $('param-validationexpression').value = settings.ValidationExpression || '';
    $('param-errormessage').value = settings.ErrorMessage || '';
    $('param-defaultvalue').value = settings.DefaultValue || '';
    $('paramExcludefromsearch').checked = !!settings.IsExcludedFromSearch;


    $('param-defaultvalue').disabled = (!settings.NewField && !this.get_canEditDefaultValue()) || settings.IsInherited || this._isCodeFirst;

    if (this._currentSettingsTarget && this._tempLayout) {
        token = this._getLayoutTokenField(this.findContainingRow($(this._currentSettingsTarget))).value;

        if (token.length && this._tempLayout[token]) {
            groupName = this._tempLayout[token].group;
            selectedPosition = this._tempLayout[token].position;

            for (token in this._tempLayout) {
                if (typeof (this._tempLayout[token]) != 'function') {
                    if (this._tempLayout[token].group == groupName) {
                        totalFields += 1;
                    }
                }
            }
        }
    }
    else {
        // New field
        if (settings.GroupName) groupName = settings.GroupName;
    }

    groupName = this._fillGroups(groupName);
    this._updatePositionList(groupName, totalFields, selectedPosition);

    // put editor configuration in session
    var self = this;

    new Ajax.Request("ItemTypeEdit.aspx", {
        method: 'get',
        parameters: {
            AJAX: 'LoadEditorConfiguration',
            EditorConfiguration: settings.EditorConfiguration,
            PreventCaching: new Date().getTime()
        },
        onComplete: function (transport) {
            self._onFieldTypeChanged(settings.IsInherited);
        }
    });
};

Dynamicweb.Items.ItemTypeEdit.prototype.resetAdvancedSettings = function () {
    $('param-name').value = '';
    $('param-systemname').value = '';
    $('param-description').value = '';
    $('param-editortype').value = '';
    $('paramRequired').checked = false;
    $('param-validationexpression').value = '';
    $('param-errormessage').value = '';
    $('param-defaultvalue').value = '';

    $('param-systemname').enable();

    this._canEditFieldSystemName = false;
};

Dynamicweb.Items.ItemTypeEdit.prototype.validateField = function (onValid) {
    var name = $("param-name");
    var systemName = $("param-systemname");

    // additional server-side validation
    // put to callback to synchonize 
    this._validateFieldSystemName(systemName.value, (function (newSystemName) {
        var isValid = false;

        if (!name.value || !name.value.length) {
            Dynamicweb.Items.ItemTypeEdit.Focus($("param-name"), this.get_terminology()['EmptyName']);
        }
        else if (systemName.value !== newSystemName) {
            Dynamicweb.Items.ItemTypeEdit.Focus($("param-systemname"), this.get_terminology()['ReservedSystemName']);

        } else if (!systemName.value || !systemName.value.length) {
            Dynamicweb.Items.ItemTypeEdit.Focus($("param-systemname"), this.get_terminology()['EmptySystemName']);
        }
        else if (systemName.value && systemName.value.toLowerCase() == 'url') {
            Dynamicweb.Items.ItemTypeEdit.Focus($("param-systemname"), this.get_terminology()['ReservedSystemName_URL']);
        }
        else {
            isValid = true;
        }

        if (isValid && $('SystemNameOrigin').value !== newSystemName) {
            var arrLi = this._get_ItemFields();
            for (var i = 0; i < arrLi.length; i++) {
                var sn = this._getSystemNameFieldValue(arrLi[i]).toLowerCase();
                if (sn == systemName.value.toLowerCase()) {
                    isValid = false;
                    alert(this.get_terminology()['SystemNameShouldBeUnique']);
                    break;
                }
            }
        }

        // Validate field extensibility parameters
        if ($("param-editor-configuration").style.display != "none") {
            var fieldItemType = $$("#param-editor-configuration input#Item_type");
            if (fieldItemType && fieldItemType.length > 0) {
                var fieldType = $F($('param-editortype'));
                if (fieldType != 'Dynamicweb.Content.Items.Editors.ItemRelationListEditor, Dynamicweb') {
                    if (fieldItemType[0].value == this._systemName) {
                        isValid = false;
                        alert(this.get_terminology()['RecursiveReference']);
                    }
                }
            }
        }

        if (isValid) {
            if (typeof (onValid) === 'function') {
                onValid();
            }
        }
    }).bind(this));
};

Dynamicweb.Items.ItemTypeEdit.prototype._validateFieldDefaultValue = function () {
    var type = $('param-editortype');
    var defaultValue = $('param-defaultvalue');
    var isRequired = $('paramRequired');

    if (defaultValue.value && defaultValue.value.length || isRequired) {
        new Ajax.Request('/Admin/Content/Items/ItemTypes/ItemTypeEdit.aspx?ValidateField=true', {
            parameters: {
                EditorType: type.value,
                DefaultValue: defaultValue.value,
                IsRequired: isRequired.checked
            },
            onComplete: function (transport) {
                var o = null;

                if (transport != null && transport.responseText != null) {
                    try {
                        o = transport.responseText.evalJSON();
                    } catch (ex) { }

                    if (o && o.defaultValue != null) {
                        defaultValue.value = o.defaultValue;
                    }
                }
            }
        });
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype._validateFieldSystemName = function (systemName, onComplete) {
    /// <summary>Validates the system name of the given field.</summary>
    /// <param name="systemName">System name of the field.</param>
    /// <param name="onComplete">A callback that is called when validation completes.</param>

    onComplete = onComplete || function () { };

    if (systemName && systemName.length) {
        new Ajax.Request('/Admin/Content/Items/ItemTypes/ItemTypeEdit.aspx?ValidateField=true', {
            parameters: {
                ItemType: this._systemName,
                SystemName: systemName,
                Base: this._base
            },
            onComplete: function (transport) {
                var o = null;

                if (transport && transport.responseText) {
                    try {
                        o = transport.responseText.evalJSON();
                    } catch (ex) { }
                }

                onComplete(o && o.systemName ? o.systemName : systemName);
            }
        });
    } else {
        onComplete('');
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.saveAdvancedSettings = function (settings, params) {
    var parent = $('param-parent').value;

    if (parent && parent === this._systemName) {
        this.enable_Confirmation();
        this.validateField((function () {
            if (!settings) settings = this._currentSettings;
            if (!params) params = {};
            if (!this._currentSettingsTarget) {
                this._initNewField($('ddGroup').value);
                if (settings) settings.NewField = true;
            }

            var friendlyEditorName = "";

            if (this._currentSettingsTarget && settings) {
                settings.Token = $('param-token').value;
                settings.Name = $('param-name').value;
                settings.SystemName = $('param-systemname').value;
                settings.Description = $('param-description').value;
                settings.Type = $('param-editortype').value;
                settings.Required = $('paramRequired').checked;
                settings.ValidationExpression = $('param-validationexpression').value;
                settings.ErrorMessage = $('param-errormessage').value;
                settings.DefaultValue = $('param-defaultvalue').value;
                settings.IsExcludedFromSearch = $('paramExcludefromsearch').checked;
                friendlyEditorName = $('param-editortype').options[$('param-editortype').selectedIndex].innerHTML;

                var closeDialog = function () {
                    if (typeof (params.close) == 'undefined' || params.close == null || params.close) {
                        $('SystemNameOrigin').value = "";
                        dialog.hide('dlgAdvanced');
                    }
                };

                // editor configuration
                if ($("param-editor-configuration").style.display == "none") {
                    settings.EditorConfiguration = "";
                    this._updateSettings(friendlyEditorName, settings);
                    closeDialog();
                }
                else {
                    var self = this;
                    var formElements = $$('#param-editor-configuration .editor-parameter');
                    var richControls = $$('#param-editor-configuration .ajax-rich-control .editor-parameter [name]');
                    var formInputElements = $$('#param-editor-configuration input:not(.editor-parameter)');
                    var serializedElements = Form.serializeElements(formElements.concat(formInputElements).concat(richControls), true)

                    new Ajax.Request("ItemTypeEdit.aspx?AJAX=SaveEditorConfiguration&ItemType=" + this._systemName, {
                        method: 'post',
                        parameters: $H(serializedElements),
                        onComplete: function (response) {
                            var evaluatedResponse = null;
                            if (response && response.responseText) {
                                try {
                                    evaluatedResponse = response.responseText.evalJSON();
                                } catch (ex) { }
                            }

                            if (evaluatedResponse && evaluatedResponse.fieldIsRecursive == "True") {
                                if (settings.NewField) {
                                    var fieldList = $('fields_' + $('ddGroup').value);
                                    var arrLi = fieldList.childElements();
                                    var row = arrLi[arrLi.length - 1];
                                    row.remove();
                                    self._currentSettingsTarget = null;
                                }
                                alert(self.get_terminology()['RecursiveReference']);
                                return;
                            }

                            settings.EditorConfiguration = response.responseText;
                            self._updateSettings(friendlyEditorName, settings);
                            closeDialog();
                        }
                    });
                }
            }

        }).bind(this));
    } else {
        dialog.hide('dlgAdvanced');
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype._updateSettings = function (friendlyEditorName, settings) {
    this._currentSettingsTarget.value = Object.toJSON(settings);
    var containingRow = this.findContainingRow(this._currentSettingsTarget);
    this.updateField(containingRow, settings, friendlyEditorName);

    this.updateLayout({
        row: containingRow,
        group: $('ddGroup').value,
        position: parseInt($('ddPosition').getValue()) || 1
    }, true);
};

Dynamicweb.Items.ItemTypeEdit.prototype._initNewField = function (groupSystemName) {
    var newField = $('newFieldTemplate').innerHTML;

    var fieldList = $('fields_' + groupSystemName);
    if (fieldList) {
        fieldList.insert(newField);

        var arrLi = fieldList.childElements();
        var row = arrLi[arrLi.length - 1];
        this._currentSettingsTarget = this._getAdvancedSettingsField(row);

        this._initSortables();
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.updateField = function (row, settings, friendlyEditorName) {
    if (row) {
        this._setNameFieldValue(row, settings.Name);
        this._setSystemNameFieldValue(row, settings.SystemName);
        this._setTypeFieldValue(row, friendlyEditorName);
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.updateLayout = function (params, changeRowPosition) {
    var token = null;

    if (!params) params = {};

    if (params.row && params.group && params.group.length) {
        token = this._getLayoutTokenField(params.row);

        if (!token.value || !token.value.length) {
            token.value = this._newToken();
        }

        if (changeRowPosition) {
            var layout = this._tempLayout[token.value];
            if (layout) this.updateRowPosition(params.row, layout.group, params.group, layout.position, params.position - 1);
            else this.updateRowPosition(params.row, null, params.group, -1, params.position - 1);
        }


        this._tempLayout[token.value] = {
            group: params.group,
            position: params.position - 1
        };
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.updateRowPosition = function (row, oldGroup, newGroup, oldPosition, newPosition) {
    if (oldGroup != newGroup || oldPosition != newPosition) {
        var newParent = $('fields_' + newGroup);
        if (newParent) {
            if (!oldGroup || oldPosition < 0) row.remove();

            var childs = newParent.childElements();
            if (!childs || childs.length <= newPosition)
                newParent.insert(row);
            else
                newParent.insertBefore(row, childs[newPosition]);
        }
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.commitLayout = function () {
    var f = $('Layout');
    var layout = this.convertLayout();

    if (layout.Groups) {
        f.value = Object.toJSON(layout);
    } else {
        f.value = '';
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.commitAdvancedSettings = function () {
    var f = $('AdvancedSettings');
    var ids = [];

    var arrLi = this._get_ItemFields();
    for (var i = 0; i < arrLi.length; i++) {
        var advancedSettingsField = this._getAdvancedSettingsField(arrLi[i]);
        if (advancedSettingsField) {
            ids[ids.length] = advancedSettingsField.value;
        }
    }

    f.value = "[" + ids + "]";
};

Dynamicweb.Items.ItemTypeEdit.prototype.convertLayout = function (allowEmptyFields) {
    var ret = {};
    var row = null;
    var group = {};
    var layout = {};
    var groups = [];
    var fields = {};
    var rows = null;
    var name = null;
    var fieldName = '';
    var totalFields = 0;
    var tokenToName = {};
    var sortedFields = [];
    var systemName = null;
    var tokenField = null;
    var tokenToField = {};
    var fieldGroupKey = '';
    var groupsProcessed = {};
    var groupSystemName = '';
    var fieldSystemName = '';

    if (this._tempLayout) {
        var arrLi = this._get_ItemFields();

        // Mapping layout tokens to field system names
        for (var i = 0; i < arrLi.length; i++) {
            row = arrLi[i];
            tokenField = this._getLayoutTokenField(row);

            if (tokenField && tokenField.value && tokenField.value.length) {
                name = this._getNameFieldValue(row);
                systemName = this._getSystemNameFieldValue(row);

                if (systemName && systemName.length) {
                    tokenToField[tokenField.value] = systemName;
                } else if (allowEmptyFields) {
                    tokenToField[tokenField.value] = '';
                }

                if (name && name.length) {
                    tokenToName[tokenField.value] = name;
                } else if (allowEmptyFields) {
                    tokenToName[tokenField.value] = '';
                }
            }
        }

        for (var token in tokenToField) {
            if (typeof (tokenToField[token]) != 'function' && typeof (this._tempLayout[token]) != 'undefined') {
                fieldName = tokenToName[token];
                fieldSystemName = tokenToField[token];
                groupSystemName = this._tempLayout[token].group;

                if (!groupsProcessed[groupSystemName]) {
                    groupsProcessed[groupSystemName] = true;

                    groups[groups.length] = {
                        Name: this._getNameGroupValue(this.findContainingRow($('fields_' + groupSystemName))),
                        CollapsibleState: this._getCollapsibleGroupValue(this.findContainingRow($('fields_' + groupSystemName))),
                        SystemName: groupSystemName,
                        VisibilityField: this._getVisibilityFieldGroupValue(this.findContainingRow($('fields_' + groupSystemName))),
                        VisibilityCondition: this._getVisibilityConditionGroupValue(this.findContainingRow($('fields_' + groupSystemName))),
                        VisibilityConditionValueType: this._getVisibilityConditionValueGroupValueType(this.findContainingRow($('fields_' + groupSystemName))),
                        VisibilityConditionValue: this._getVisibilityConditionValueGroupValue(this.findContainingRow($('fields_' + groupSystemName)))
                    };
                }

                fieldGroupKey = groupSystemName;

                if (!fields[fieldGroupKey]) {
                    fields[fieldGroupKey] = [];
                }

                fields[fieldGroupKey][fields[fieldGroupKey].length] = {
                    Name: fieldName || fieldSystemName || '',
                    SystemName: fieldSystemName,
                    Position: this._tempLayout[token].position
                };

                totalFields += 1;
            }
        }

        if (totalFields > 0) {
            layout.Groups = [];

            for (var i = 0; i < groups.length; i++) {
                fieldGroupKey = groups[i].SystemName;

                if (fields[fieldGroupKey]) {
                    group = groups[i];
                    group.Fields = [];

                    sortedFields = fields[fieldGroupKey].sort(function (x, y) {
                        return x.Position - y.Position;
                    });

                    for (var j = 0; j < sortedFields.length; j++) {
                        group.Fields[group.Fields.length] = {
                            Name: sortedFields[j].Name,
                            CollapsibleState: sortedFields[j].CollapsibleState,
                            SystemName: sortedFields[j].SystemName
                        };
                    }

                    layout.Groups[layout.Groups.length] = group;
                }
            }
        }
    }

    ret = layout;

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype.deleteField = function (link, confirmed) {
    var token = null;
    var optionName = '';
    var groupName = '', position = -1;
    var row = this.findContainingRow(link);

    if (row) {
        if (confirmed || confirm(this.get_terminology()['DeleteFieldConfirm'])) {
            if (this._tempLayout) {
                token = this._getLayoutTokenField(row).value;

                if (token && token.length) {
                    groupName = this._tempLayout[token].group.toLowerCase();
                    position = this._tempLayout[token].position;

                    delete this._tempLayout[token];
                }

                for (token in this._tempLayout) {
                    if (typeof (this._tempLayout[token]) != 'function') {
                        if (this._tempLayout[token].group.toLowerCase() == groupName) {
                            if (this._tempLayout[token].position > position) {
                                this._tempLayout[token].position -= 1;
                            }
                        }
                    }
                }
            }

            row.remove();
            this.enable_Confirmation();
        }
    }

};

Dynamicweb.Items.ItemTypeEdit.prototype._getAdvancedSettingsField = function (row) {
    var ret = null;

    if (row) {
        ret = $(row).select('.field-advanced-settings')[0];
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._getAdvancedSettings = function (row) {
    var ret,
        settingsField = this._getAdvancedSettingsField(row);

    if (settingsField) {
        ret = JSON.parse(settingsField.value);
    }


    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._setAdvancedSettings = function (row, settings) {
    var ret,
        settingsField;

    if (settings) {
        settingsField = this._getAdvancedSettingsField(row);

        if (settingsField) {
            settingsField.value = JSON.stringify(settings);
        }
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._getNameFieldValue = function (row) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.field-name')[0];
        if (field) ret = field.innerHTML;
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._setNameFieldValue = function (row, value) {
    var field = null;

    if (row) {
        field = $(row).select('.field-name')[0];
        if (field) field.innerHTML = value;
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype._getSystemNameFieldValue = function (row) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.field-system-name')[0];
        if (field) ret = field.innerHTML;
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._setSystemNameFieldValue = function (row, value) {
    var field = null;

    if (row) {
        field = $(row).select('.field-system-name')[0];
        if (field) field.innerHTML = value;
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype._setTypeFieldValue = function (row, value) {
    var field = null;

    if (row) {
        field = $(row).select('.field-editor-type')[0];
        if (field) field.innerHTML = value;
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype._getNameGroupValue = function (row) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-name')[0];
        if (field) ret = field.innerHTML;
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._setNameGroupValue = function (row, value) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-name')[0];
        if (field) field.innerHTML = value;
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._getSystemNameGroupValue = function (row) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-system-name')[0];
        if (field) ret = field.value;
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._setCollapsibleGroupValue = function (row, value) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-collapsible')[0];
        if (field) field.value = value;
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._getCollapsibleGroupValue = function (row) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-collapsible')[0];
        if (field) ret = field.value;
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._getVisibilityFieldGroupValue = function (row) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-visibility-field')[0];
        if (field) {
            ret = field.value;
        };
    };

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._setVisibilityFieldGroupValue = function (row, value) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-visibility-field')[0];
        if (field) {
            field.value = value;
        } else {
            var result = document.createElement('input');
            result.type = 'hidden';
            result.className = 'group-visibility-field';
            result.value = value;
            $(row).appendChild(result);
        };
    };

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._getVisibilityConditionGroupValue = function (row) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-visibility-condition')[0];
        if (field) {
            ret = field.value;
        };
    };

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._setVisibilityConditionGroupValue = function (row, value) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-visibility-condition')[0];
        if (field) {
            field.value = value;
        } else {
            var result = document.createElement('input');
            result.type = 'hidden';
            result.className = 'group-visibility-condition';
            result.value = value;
            $(row).appendChild(result);
        };
    };

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._getVisibilityConditionValueGroupValueType = function (row) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-visibility-condition-value-type')[0];
        if (field) {
            ret = field.value;
        };
    };

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._setVisibilityConditionValueGroupValueType = function (row, value) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-visibility-condition-value-type')[0];
        if (field) {
            field.value = value;
        } else {
            var result = document.createElement('input');
            result.type = 'hidden';
            result.className = 'group-visibility-condition-value-type';
            result.value = value;
            $(row).appendChild(result);
        };
    };

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._getVisibilityConditionValueGroupValue = function (row) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-visibility-condition-value')[0];
        if (field) {
            ret = field.value;
        };
    };
    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._setVisibilityConditionValueGroupValue = function (row, value) {
    var ret = null;
    var field = null;

    if (row) {
        field = $(row).select('.group-visibility-condition-value')[0];
        if (field) {
            field.value = value;
        } else {
            var result = document.createElement('input');
            result.type = 'hidden';
            result.className = 'group-visibility-condition-value';
            result.value = value;
            $(row).appendChild(result);
        };
    };

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._getLayoutTokenField = function (row) {
    var ret = null;

    if (row) {
        ret = $(row).select('.layout-token')[0];
        if (!ret) {
            ret = document.createElement('input');
            ret.type = 'hidden';
            ret.className = 'layout-token';

            row.appendChild(ret);
        }
    }

    return ret;
};

Dynamicweb.Items.ItemTypeEdit.prototype._fillGroups = function (selectedItem) {
    var dd = $('ddGroup');

    dd.options.length = 0;
    /*
    if (typeof (selectedItem) == 'undefined' || selectedItem == null || selectedItem < 0) {
    selectedItem = count - 1;
    }
    */
    var groups = this._get_ItemGroups();
    for (var i = 0; i < groups.length; i++) {
        var name = this._getNameGroupValue(groups[i]);
        var systemName = this._getSystemNameGroupValue(groups[i]);
        if (name && name.length) {
            if (!selectedItem) selectedItem = systemName;
            dd.options[dd.options.length] = new Option(name, systemName, systemName == selectedItem, systemName == selectedItem);
        }
    }

    return selectedItem;
};

Dynamicweb.Items.ItemTypeEdit.prototype._fillPositions = function (count, selectedItem) {
    var dd = $('ddPosition');

    dd.options.length = 0;

    if (typeof (selectedItem) == 'undefined' || selectedItem == null || selectedItem < 0) {
        selectedItem = count - 1;
    }

    for (var i = 0; i < count; i++) {
        dd.options[dd.options.length] = new Option((i + 1).toString(), (i + 1).toString(), i == selectedItem, i == selectedItem);
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype._updatePositionList = function (groupName, totalFields, selectedPosition) {
    var token = null;

    if (typeof (totalFields) != 'undefined' && totalFields != null && totalFields > 0) {
        this._fillPositions(totalFields, selectedPosition);
    } else {
        totalFields = 1;
        selectedPosition = 0;

        if (this._tempLayout) {
            if (groupName && groupName.length) {
                groupName = groupName.toLowerCase();
                for (token in this._tempLayout) {
                    if (typeof (this._tempLayout[token]) != 'function') {
                        if (this._tempLayout[token].group.toLowerCase() == groupName) {
                            totalFields += 1;
                        }
                    }
                }

                if (totalFields > 1) {
                    selectedPosition = totalFields - 1;
                }
            }
        }

        this._fillPositions(totalFields, selectedPosition);
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype._newToken = function () {
    return new Date().getTime().toString() + (++this._autoId).toString();
};

Dynamicweb.Items.ItemTypeEdit.prototype._newOptionsToken = function () {
    return new Date().getTime().toString();
};

Dynamicweb.Items.ItemTypeEdit.prototype._reload = function (params) {
    var url = location.origin + location.pathname;

    url += '?' + params.join('&');

    location.href = url;
};

Dynamicweb.Items.ItemTypeEdit.prototype.toggleAllSelected = function (addClass) {
    var selectedClassName = "selected";

    var items = $$('ul[id="items"] ul input[type="checkbox"]');
    for (var i = 0; i < items.length; i++) {
        var row = this.findContainingRow(items[i]);
        if (row && !row.hasClassName('inherited')) {
            items[i].checked = addClass;
            if (addClass) {
                if (!row.hasClassName(selectedClassName)) row.addClassName(selectedClassName);
            }
            else {
                if (row.hasClassName(selectedClassName)) row.removeClassName(selectedClassName);
            }
        }

    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.handleCheckboxes = function (link) {
    var row = this.findContainingRow(link);
    row.toggleClassName("selected");
};

Dynamicweb.Items.ItemTypeEdit.prototype.deleteSelectedFields = function () {
    ContextMenu.hide();
    if (!confirm(this.get_terminology()['DeleteSelectedFieldsConfirm'])) return;

    var items = $$('ul[id="items"] ul li.selected');
    for (var i = 0; i < items.length; i++) {
        this.deleteField(items[i], true);
    }
};

Dynamicweb.Items.ItemTypeEdit.prototype.selectIcon = function () {    
    $("ItemTypeIcon").className = $('dlgIconSettings').select('div[class="icon-block selected"]')[0].select('i')[0].className;
    $("ItemTypeIcon").title = $("ItemTypeIcon").className;
    $("SmallIcon").value = this._icon;
    $("IconColor").value = this._iconColor;

    if (this._icon == "None") {
        $("ItemTypeIcon").style.display = "none";
    } else {
        $("ItemTypeIcon").style.display = "";
    }

    dialog.hide('dlgIconSettings');
};

Dynamicweb.Items.ItemTypeEdit.onContextMenuView = function (sender, arg) {
    var view = "common";
    var row = Dynamicweb.Items.ItemTypeEdit.get_current().findContainingRow(arg.callingID);

    var items = $$('ul[id="items"] ul li.selected');
    if (items.length > 1) {
        if (row) {
            if (row.hasClassName("selected")) {
                view = "selection";
            }
        }
        else {
            view = "mixed";
        }
    } else {
        if (row) {
            if (row.hasClassName('inherited')) {
                view = 'readonly';
            }
        }
    }

    return view;
};

// Called from ConfigurableEditorAddin
Dynamicweb.Items.ItemTypeEdit.onEditorChanges = function () {
    var parameterdiv = $("div_Dynamicweb.Content.Items.Editors.Editor_parameters");
    if (parameterdiv && parameterdiv.innerHTML.length > 300)
        $("param-editor-configuration").show();
    else
        $("param-editor-configuration").hide();

    var folderCtrl = $("FLDM_Base_directory");
    if (folderCtrl) {
        folderCtrl.onchange = function () { folderCtrl.removeClassName('error'); };
    }
};

Dynamicweb.Items.ItemTypeEdit.Focus = function (obj, message) {
    try {
        obj.focus();
    } catch (e) {

    }

    if (typeof (message) === 'string') {
        alert(message);
    }
};

Dynamicweb.Items.ItemTypeEdit.show_overlay = function () {    
    over = new overlay('ItemTypeEditOverlay');
    over.show();
};

Dynamicweb.Items.ItemTypeEdit.hide_overlay = function (timeout, callback) {
    timeout = timeout || 1;
    callback = callback || function () { };

    setTimeout(function () {
        over = new overlay('ItemTypeEditOverlay');
        over.hide();
        callback();
    }, timeout);

};

Dynamicweb.Items.ItemTypeEdit.show_usage = function () {
    var self = Dynamicweb.Items.ItemTypeEdit.get_current();
    location.href = '/Admin/Content/Items/ItemTypes/ItemTypeUsage.aspx?ItemType=' + self._systemName;
};
