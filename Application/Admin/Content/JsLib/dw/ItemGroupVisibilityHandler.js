if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.GroupVisibilityRule = function () {
    this._groupsWithVisibility = {};
    this._visibilitySettings = {
        VisibilityRules: [],
        Groups: [],
        Fields: []
    };
};

Dynamicweb.Items.GroupVisibilityRule._instance = null;

Dynamicweb.Items.GroupVisibilityRule.get_current = function () {
    if (!Dynamicweb.Items.GroupVisibilityRule._instance) {
        Dynamicweb.Items.GroupVisibilityRule._instance = new Dynamicweb.Items.GroupVisibilityRule();
    }
    return Dynamicweb.Items.GroupVisibilityRule._instance;
};

Dynamicweb.Items.GroupVisibilityRule.prototype.get_rules = function () {
    return this._visibilitySettings['VisibilityRules'];
};

Dynamicweb.Items.GroupVisibilityRule.prototype.set_rules = function (value) {
    this._visibilitySettings['VisibilityRules'] = value;
};

Dynamicweb.Items.GroupVisibilityRule.prototype.get_groupsWithVisibility = function () {
    return this._groupsWithVisibility;
}

Dynamicweb.Items.GroupVisibilityRule.prototype.set_groupsWithVisibility = function (value) {
    this._groupsWithVisibility = value;
}

Dynamicweb.Items.GroupVisibilityRule.prototype.get_visibilitySettings = function () {
    return this._visibilitySettings;
}

Dynamicweb.Items.GroupVisibilityRule.prototype.set_visibilitySettings = function (value) {
    this._visibilitySettings = value;
}

Dynamicweb.Items.GroupVisibilityRule.prototype.getVisibility = function (value, rule) {
    /// <summary>Gets visibility as boolean value is based on a comparison of input parameters</summary>
    /// <param name="value">Current control value to be compared</param>
    /// <param name="rule">An object, containing visibility parameters</param>

    var result = true;

    switch (rule.VisibilityCondition) {
        case "0": {
            result = (value == rule.VisibilityConditionValue)         //EqualTo
            break;
        }
        case "5": {
            result = (value != rule.VisibilityConditionValue)         //NotEqualTo
            break;
        }
    };

    return result;
};

Dynamicweb.Items.GroupVisibilityRule.prototype.getRuleByField = function (field) {
    /// <summary>Gets needed rule from all rules based on visibility field name</summary>
    /// <param name="field">Visibility field name</param>

    var result = [];
    var rules = this.get_rules();
    for (var i = 0; i < rules.length; i++) {
        if (rules[i].VisibilityField == field) {
            result.push(rules[i]);
        };
    };
    return result;
};



Dynamicweb.Items.GroupVisibilityRule.prototype.getGroupsVisibilityByName = function (name) {
    /// <summary>Gets visibility of group by it's name</summary>
    /// <param name="name">Group name</param>

    var result = false;
    var groups = this.get_visibilitySettings()['Groups'];

    for (var i = 0; i < groups.length; i++) {
        if (groups[i].GroupName == name) {
            result = !groups[i].IsVisible;
        };
    };
    return result;
};

Dynamicweb.Items.GroupVisibilityRule.prototype.initGroupVisibilityParamenters = function (rules) {
    /// <summary>Initialising class property, i.e. set name and hidden parameters for all groups, whichones can be hidden</summary>

    var self = this;
    var groupsVisibility = {};

    for (var i = 0; i < rules.length; i++) {
        var targetGroupName = rules[i].VisibilityTargetGroup;
        groupsVisibility[targetGroupName] = { name: targetGroupName };
        groupsVisibility[targetGroupName].hidden = self.getGroupsVisibilityByName(targetGroupName);
        self.set_groupsWithVisibility(groupsVisibility);
    };
};

Dynamicweb.Items.GroupVisibilityRule.prototype.initVisibility = function (groups) {
    /// <summary>Sets visibility for all groups, executes when class is initialising</summary>

    var self = this;
    var i = groups.length - 1;
    while (i >= 0) {
        if (groups[i].GroupName != "General") {
            self.setGroupVisibility(groups[i].IsVisible, groups[i].GroupName);
        };
        i--;
    };
};

Dynamicweb.Items.GroupVisibilityRule.prototype.getIsMasterGroupShown = function (name) {
    /// <summary>Checks if group, which has field visibility based on, is hidden</summary>
    /// <param name="name">Group name</param>

    var self = this;
    var result;

    var rules = this.get_rules();
    for (var i = 0; i < rules.length; i++) {
        if (rules[i].VisibilityTargetGroup == name) {
            result = rules[i].Group != "General" ? self.get_groupsWithVisibility()[rules[i].Group].visibility : true;
        };
    };
    return result;
};

Dynamicweb.Items.GroupVisibilityRule.prototype.setGroupVisibility = function (visibility, targetGroup, isDependent) {
    /// <summary>Sets style.display on target group</summary>
    /// <param name="visibility">Bool value group visibility based on</param>
    /// <param name="targetGroup">Group visibility to apply</param>
    /// <param name="isDependent">indicates if function executes for group dependent on "master" group field</param>

    var target = document.getElementById(targetGroup + "_fieldSet")
    if (target) {
        if (visibility) {
            target.style.display = "";
        } else {
            target.style.display = "none";
        };
    };
    var currentGroupWithVisibility = this.get_groupsWithVisibility()[targetGroup];
    if (currentGroupWithVisibility) {
        if (!isDependent) currentGroupWithVisibility.visibility = visibility;
        currentGroupWithVisibility.hidden = !visibility;
    };
    this.setDependentGroupsVisibility(visibility, targetGroup);
};

Dynamicweb.Items.GroupVisibilityRule.prototype.setDependentGroupsVisibility = function (visibility, targetGroup) {
    /// <summary>Checks if group visibility applied on has visibility rules based on it's fields</summary>
    /// <param name="visibility">Bool value group visibility based on</param>
    /// <param name="targetGroup">Group visibility to apply</param>

    var self = this;
    rules = this.get_visibilitySettings()['VisibilityRules'];

    for (var i = 0; i < rules.length; i++) {
        if (rules[i].Group == targetGroup) {
            if (visibility) {
                if (self.get_groupsWithVisibility()[rules[i].VisibilityTargetGroup].visibility) {
                    self.setGroupVisibility(visibility, rules[i].VisibilityTargetGroup, true);
                };
            } else {
                self.setGroupVisibility(visibility, rules[i].VisibilityTargetGroup, true);
            };
        };
    };
};



Dynamicweb.Items.GroupVisibilityRule.prototype.add = function (visibilitySettings) {
    /// <summary>Set up settings and groups visibility</summary>
    var self = this;
    var vs = this.get_visibilitySettings();
    vs.VisibilityRules = vs.VisibilityRules.concat(visibilitySettings.VisibilityRules||[]);
    vs.Groups = vs.Groups.concat(visibilitySettings.Groups||[]);
    vs.Fields = vs.Fields.concat(visibilitySettings.Fields||[]);
    

    var rules = visibilitySettings['VisibilityRules'];
    self.initGroupVisibilityParamenters(rules);
    
    var hasDropDownCondition = false;
    var visibilityUpdate = function (e, val) {
        val = val === undefined? e.target.value : val;
        if (val && typeof val === "string") {
            val = decodeURIComponent(val);
        }
        var boundRules = self.getRuleByField(e.target.name);
        for (var i = 0; i < boundRules.length; i++) {
            self.setGroupVisibility(self.getVisibility(val, boundRules[i]), boundRules[i].VisibilityTargetGroup);
        };
    };

    for (var i = 0; i < rules.length; i++) {
        var visibilityCtrl = document.getElementsByName(rules[i].VisibilityField);
        switch (visibilityCtrl[0].type) {
            case "text":
                visibilityCtrl[0].onkeyup = visibilityUpdate;
                break;
            case "select-one":
                visibilityCtrl[0].onchange = visibilityUpdate;
                break;
            case "hidden":
                hasDropDownCondition = true;
                break;
            case "radio":
                for (var j = 0; j < visibilityCtrl.length; j++) {
                    visibilityCtrl[j].onclick = visibilityUpdate;
                }
                break;
            case "checkbox": 
                visibilityCtrl[0].onclick = function (e) {visibilityUpdate(e, e.target.checked);};
                break;
        }
    }
    if (hasDropDownCondition) {
        RichSelect.onItemSelect = function (value, e, controlId) {
            var boundRules = self.getRuleByField(controlId);
            for (var i = 0; i < boundRules.length; i++) {
                if (self.getIsMasterGroupShown(boundRules[i].VisibilityTargetGroup)) {
                    self.setGroupVisibility(self.getVisibility(value, boundRules[i]), boundRules[i].VisibilityTargetGroup);
                };
            };
        };
    };
    var groups = visibilitySettings.Groups;
    self.initVisibility(groups);
};

Dynamicweb.Items.GroupVisibilityRule.prototype.filterValidators = function (validationRules) {
    /// <summary>Filtering of the validators basing on checking if group containing field to validate is hidden</summary>
    var self = this;
    var isVisible = function (el) {
        return el.offsetWidth > 0 && el.offsetHeight > 0;
    };

    
    var validation = new Dynamicweb.Validation.ValidationManager();
    var fields = self.get_visibilitySettings()['Fields'];
    for (var i = 0; i < validationRules._validators.length; i++) {
        var validator = validationRules._validators[i];
        for (var j = 0; j < fields.length; j++) {
            var field = fields[j];
            if (validator._target == field.Id) {
                var gel = document.getElementById(field.Group + "_fieldSet");
                if (gel && isVisible(gel)) {
                    validation._validators.push(validator);
                }
                break;
            }
        }
    }
    return validation;
};