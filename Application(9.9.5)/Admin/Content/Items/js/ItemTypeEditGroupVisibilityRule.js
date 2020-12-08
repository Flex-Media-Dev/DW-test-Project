if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
};

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
};

if (typeof (Dynamicweb.Controls.RulesEditor) == 'undefined') {
    Dynamicweb.Controls.RulesEditor = new Object();
};

VisibilityRule = function () {
    this._itemType = null;
    this._rules = null;
    this._currentRule = null;
    this._currentType = null;
    this._currentCondition = null;
    this._currentConditionValue = null;
    this._terminology = {};
};

VisibilityRule.prototype.get_itemType = function () {
    return this._itemType;
};

VisibilityRule.prototype.set_itemType = function (value) {
    this._itemType = value;
};

VisibilityRule.prototype.get_currentRule = function () {
    return this._currentRule ? this._currentRule : null;
};

VisibilityRule.prototype.set_currentRule = function (value) {
    this._currentRule = value;
};

VisibilityRule.prototype.get_currentType = function () {
    return this._currentType ? this._currentType : null;
};

VisibilityRule.prototype.set_currentType = function (value) {
    this._currentType = value;
};

VisibilityRule.prototype.get_currentCondition = function () {
    return this._currentCondition ? this._currentCondition : null;
};

VisibilityRule.prototype.set_currentCondition = function (value) {
    this._currentCondition = value;
};

VisibilityRule.prototype.get_currentConditionValue = function () {    
    return this._currentConditionValue ? this._currentConditionValue : '';
};

VisibilityRule.prototype.set_currentConditionValue = function (value) {
    this._currentConditionValue = value;
};

VisibilityRule.prototype.get_terminology = function () {
    return this._terminology;
};

VisibilityRule.prototype.set_terminology = function (value) {
    this._terminology = value;
};

VisibilityRule.Rules = function (fieldNames, fieldTypes) {

    this._fieldNames = fieldNames;
    this._fieldTypes = fieldTypes;
};

VisibilityRule.Rules.prototype.get_fieldNames = function () {

    return this._fieldNames;
};

VisibilityRule.Rules.prototype.set_fieldNames = function (value) {
    
    this._fieldNames = value;
};

VisibilityRule.Rules.prototype.get_fieldTypes = function () {

    return this._fieldTypes;
};

VisibilityRule.Rules.prototype.set_fieldTypes = function (value) {

    this._fieldTypes = value;
};

VisibilityRule.Rules.prototype.add_fieldName = function (fieldName) {

    this._fieldNames.push(fieldName);
};

VisibilityRule.Rules.prototype.add_fieldType = function (fieldType) {

    this._fieldTypes.push(fieldType);
};

VisibilityRule.prototype.set_existingValues = function (field, type, condition, conditionValue) {
    /// <summary>Sets values to controls and class properties</summary>
    /// <param name="field">Visibility field name</param>
    /// <param name="type">Type of values related to control</param>
    /// <param name="condition">Visibility condition operator</param>
    /// <param name="conditionValue">Value to compare with</param>

    if (!field || field == '0') {
        document.getElementById('visibility-rule-field').value = '';
        $("GroupVisibilityCondition").style.display = "none";
        $("GroupVisibilityConditionValue").style.display = "none";
    } else {
        $("GroupVisibilityCondition").style.display = "";
        $("GroupVisibilityConditionValue").style.display = "";
        this.set_currentRule(field);
        if (type) this._updateCurrentType(type);
        this.set_currentCondition(condition);
        this.set_currentConditionValue(conditionValue);
        document.getElementById('visibility-rule-field').value = field;
    };
};

VisibilityRule.prototype._getItemFields = function (currentGroup) {
    /// <summary>Gets all item fields and creates rules dropdown</summary>
    /// <param name="currentGroup">Html element, which represent group with all child elements</param>

    self = this;

    if (document.getElementById('visibility-rule-field')) {
        result = document.getElementById('visibility-rule-field');
        result.innerHTML = '';
    } else {
        result = document.createElement('select');
        result.id = 'visibility-rule-field';
        result.className = 'std rule-field';
    };
    itemType = this._itemType;
    var rules = new VisibilityRule.Rules([], []);
    var groups = itemType._get_ItemGroups();

    result.appendChild(new Option(self.get_terminology()['None'], '', true));
    rules.add_fieldName(self.get_terminology()['None']);
    rules.add_fieldType('');

    groups.each(function (group) {
        if (group != currentGroup) {
            var optgroup = document.createElement("optgroup");
            for (var i = 0; i < group.select('.inner.field-system-name').length; i++) {
                var rowSettings = JSON.parse(group.select('.field-advanced-settings')[i].value);
                if (self._fieldConfirmed(rowSettings.Type)) {
                    if (!optgroup.label) {
                        optgroup.label = itemType._getNameGroupValue(group);
                    };
                    optgroup.appendChild(new Option(rowSettings.Name, rowSettings.SystemName, false, (rowSettings.SystemName == self.get_currentRule())));
                    rules.add_fieldName(rowSettings.SystemName);
                    rules.add_fieldType(rowSettings.Type);
                };
            };
        result.appendChild(optgroup);
        }
    });
    

    if (!this.get_currentType()) {
        this._updateCurrentType(!this.get_currentRule() ? rules.get_fieldTypes()[0] : VisibilityRule._getTypeByName(this.get_currentRule()));
    }

    if (!this.get_currentRule()) {
        this.set_currentRule(rules.get_fieldNames()[0]);
    };
    this._rules = rules;

    Event.observe(result, 'change', function (e) {
        var el = Event.element(e);
        self.set_currentRule(el.value);
        self._updateCurrentType(VisibilityRule._getTypeByName(self._getCurrentTypeName()));
        self.set_currentConditionValue(self._getDefaultValue(VisibilityRule._getTypeByName(self._getCurrentTypeName())));
        if (el.value != '' && el.value != '0') {
            self.set_currentCondition(null);
            self._createConditionDropDown();
            self._createValueCtrl();
            $("GroupVisibilityCondition").style.display = "";
            $("GroupVisibilityConditionValue").style.display = "";
        } else {
            $("GroupVisibilityCondition").style.display = "none";
            $("GroupVisibilityConditionValue").style.display = "none";
        };
    });

    result.className = "std visibility-control";
    return result;
};

VisibilityRule.prototype._updateCurrentType = function (type) {
    /// <summary>Updates hidden field with current type</summary>
    /// <param name="type">Type of values used for current rule</param>

    var result;
    this.set_currentType(type);

    if (document.getElementById('visibility-rule-condition-value-type')) {
        result = document.getElementById('visibility-rule-condition-value-type');
        result.value = type;
    } else {
        result = document.createElement('input');
        result.type = "hidden";
        result.id = 'visibility-rule-condition-value-type';
        result.value = type;
        document.getElementById("GroupVisibilityField").appendChild(result);
    };
};

VisibilityRule.prototype._createConditionDropDown = function () {
    /// <summary>Creates a "Condition" drop-down list.</summary>

    var self = this;
    var result = null;
    if (document.getElementById('visibility-rule-condition')) {
        result = document.getElementById('visibility-rule-condition');
        result.innerHTML = '';
    } else {
        result = document.createElement('select');
        result.id = 'visibility-rule-condition';
        result.className = 'std rule-condition';
    };

    var items = this._getConditionItems(this._itemType, VisibilityRule._getTypeByName(this._getCurrentTypeName()));
    items.each(function (item) {
        result.appendChild(new Option(item.get_text(), item.get_value(), false, (item.get_value() == self.get_currentCondition())));
    });

    if (!this.get_currentCondition()) {
        this.set_currentCondition(items[0].get_value());
    };

    Event.observe(result, 'change', function (e) {
        var el = Event.element(e);
        self.set_currentCondition(el.value);
        self._createValueCtrl();
    });

    result.className = "std visibility-control";
    return result;
};

VisibilityRule.prototype._getCurrentTypeName = function () {
    /// <summary>Gets type name based on rules property of class and current selected value of rules dropdown</summary>

    return this._rules.get_fieldTypes()[document.getElementById('visibility-rule-field').selectedIndex];
};

VisibilityRule._getTypeByName = function (typeName) {
    /// <summary>Gets Dynamicweb.Controls.RulesEditor.CtrlType based on given type Name</summary>
    /// <param name="typeName">Field type name</param>

    result = null;
    switch (typeName) {
        case "Dynamicweb.Content.Items.Editors.TextEditor, Dynamicweb":
            result = Dynamicweb.Controls.RulesEditor.CtrlType.TextBox;
            break;
        case "Dynamicweb.Content.Items.Editors.CheckboxEditor, Dynamicweb":
            result = Dynamicweb.Controls.RulesEditor.CtrlType.BooleanCtrl;
            break;
        case "Dynamicweb.Content.Items.Editors.DropDownListEditor`1, Dynamicweb":
        case "Dynamicweb.Content.Items.Editors.RadioButtonListEditor`1, Dynamicweb":
            result = Dynamicweb.Controls.RulesEditor.CtrlType.DropDownList;
            break;
        default:
            result = Dynamicweb.Controls.RulesEditor.CtrlType.TextBox;
            break;
    }

    return result;
};

VisibilityRule.prototype._getConditionItems = function (itemType, ctrlType) {
    /// <summary>Gets items for condition dropdown</summary>
    /// <param name="itemType">Name of control type</param>
    /// <param name="ctrlType">Represent type as Dynamicweb.Controls.RulesEditor.CtrlType</param>

    var result = new Array();
    var conditionalTypes = new Array();

    switch (eval(ctrlType)) {
        case Dynamicweb.Controls.RulesEditor.CtrlType.TextBox:
        case Dynamicweb.Controls.RulesEditor.CtrlType.DropDownList:
        case Dynamicweb.Controls.RulesEditor.CtrlType.BooleanCtrl:
            conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.equals);
            conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.notEqualTo);
            break;
    }

    if (conditionalTypes.length > 0) {
        var term = '';
        var names = Dynamicweb.Controls.RulesEditor.Operator.getNames();

        for (var i = 0; i < conditionalTypes.length; i++) {
            term = this.get_terminology()[Dynamicweb.Controls.RulesEditor.Enumeration.pascalCaseField(names[(conditionalTypes[i])])];
            result.push(new Dynamicweb.Controls.RulesEditor.ListItem(term, conditionalTypes[i]));
        };
    };

    return result;
};

VisibilityRule.prototype._createValueCtrlByRule = function (val, onChange) {
    /// <summary>Creates inner value control</summary>
    /// <param name="val">The value that will be displayed in the control</param>
    /// <param name="onChange">Function which handles onChange event of control</param>

    var result = null;
    var self = this;
        
    var ctrlId = "visibility-rule-condition-value";
    
    switch (VisibilityRule._getTypeByName(this._getCurrentTypeName())) {
        case Dynamicweb.Controls.RulesEditor.CtrlType.TextBox:
            result = new Dynamicweb.Controls.RulesEditor.TextBoxCtrl(ctrlId, val, onChange);
            break;

        case Dynamicweb.Controls.RulesEditor.CtrlType.DropDownList:
            result = new Dynamicweb.Controls.RulesEditor.TextBoxCtrl(ctrlId, val, onChange);
            break;

        case Dynamicweb.Controls.RulesEditor.CtrlType.BooleanCtrl:
            result = new Dynamicweb.Controls.RulesEditor.BooleanCtrl(ctrlId, val, onChange);
            break;
    };
    result.className = "std visibility-control";
    result.style.width = "";
    return result;
};

VisibilityRule.prototype._createValueCtrl = function () {
    /// <summary>Begins create value control</summary>

    var result = null;
    var self = this;

    var currentValue = this.get_currentConditionValue() || this._getDefaultValue(VisibilityRule._getTypeByName(this._getCurrentTypeName()));
    
    var divContainer = null;
    if (document.getElementById('outer-visibility-rule-condition-value')) {
        divContainer = document.getElementById('outer-visibility-rule-condition-value');
        divContainer.innerHTML = '';
    } else {
        divContainer = document.createElement('div');
        divContainer.id = 'outer-visibility-rule-condition-value';
    };
    divContainer.style.display = "block";       

    var ctrl = self._createValueCtrlByRule(currentValue, function (e) {
        self.set_currentConditionValue(e);
    });

    if (!self.get_currentConditionValue()) {
        self.set_currentConditionValue(ctrl.value);
    };

    divContainer.appendChild(ctrl);        

    result = divContainer;
    

    return result;
};

VisibilityRule.prototype._getDefaultValue = function (controlType) {
    /// <summary>Gets dafault control value based on control type</summary>
    /// <param name="field">Represent type as Dynamicweb.Controls.RulesEditor.CtrlType</param>

    var result = "";

    if (controlType && isFinite(controlType)) {
        switch (controlType) {
            case Dynamicweb.Controls.RulesEditor.CtrlType.TextBox:
            case Dynamicweb.Controls.RulesEditor.CtrlType.DropDownList:
                result = "";
                break;

            case Dynamicweb.Controls.RulesEditor.CtrlType.BooleanCtrl:
                result = "0";
                break;

            default:
                result = "";
                break;
        }
    }

    return result;
};

VisibilityRule.prototype._fieldConfirmed = function (type) {
    /// <summary>Checks if given field type is allowed for constructing visibility rules on it</summary>
    /// <param name="type">Field type name</param>

    switch (type) {
        case "Dynamicweb.Content.Items.Editors.TextEditor, Dynamicweb":
        case "Dynamicweb.Content.Items.Editors.CheckboxEditor, Dynamicweb":
        case "Dynamicweb.Content.Items.Editors.DropDownListEditor`1, Dynamicweb":
        case "Dynamicweb.Content.Items.Editors.RadioButtonListEditor`1, Dynamicweb":
            return true;
            break;
        default: return false;
    }
};

