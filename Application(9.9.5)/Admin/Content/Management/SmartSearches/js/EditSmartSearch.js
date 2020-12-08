/* ++++++ Registering namespace ++++++ */

if (typeof (SmartSearch) == 'undefined') {
    var SmartSearch = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

SmartSearch.EditSmartSearch = function () {
    /// <summary>Represents a profile edit page.</summary>

    this._terminology = {};
    this._initialized = false;
    this._expression = null;
    this._id = null;
    this._helpLang = null;

    this._nameId = null;
    this._viewFieldsId = null;
    this._isPreview = false;
    this._calledFrom = "";
    this._isPopup = false;
    this._previewPreffixId = null;

    this._saveUrl = "";
    this._saveAndCloseUrl = "";
    this._cancelUrl = "";
    this._preViewUrl = "";
}

SmartSearch.EditSmartSearch._instance = null;

SmartSearch.EditSmartSearch.get_current = function () {
    if (!SmartSearch.EditSmartSearch._instance) {
        SmartSearch.EditSmartSearch._instance = new SmartSearch.EditSmartSearch();
    }

    return SmartSearch.EditSmartSearch._instance;
};

SmartSearch.EditSmartSearch.prototype.set_RedirectUrls = function (saveUrl, saveAndCloseUrl, cancelUrl, preViewUrl) {
    /// <summary>Sets the refirect urls.</summary>

    this._saveUrl = saveUrl;
    this._saveAndCloseUrl = saveAndCloseUrl;
    this._cancelUrl = cancelUrl;
    this._preViewUrl = preViewUrl;
}

SmartSearch.EditSmartSearch.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object that holds all localized strings.</summary>

    if (!this._terminology) {
        this._terminology = {};
    }

    return this._terminology;
}

SmartSearch.EditSmartSearch.prototype.get_expression = function () {
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

SmartSearch.EditSmartSearch.prototype.set_expression = function (value) {
    /// <summary>Sets the reference to expression editor control.</summary>
    /// <param name="value">The reference to expression editor control.</param>

    this._expression = value;
}

SmartSearch.EditSmartSearch.prototype.initialize = function (id, helpLang, isPreview, isPopup, previewPreffixId, nameId, viewFieldsInputId ) {
    /// <summary>Initializes the object.</summary>

    //debugger

    var self = this;
    var binder = null;

    this._id = id;
    this._helpLang = helpLang;

    this._nameId = nameId;
    this._viewFieldsId = viewFieldsInputId;
    this._previewPreffixId = previewPreffixId;

    this._isPopup = isPopup;
    this._isPreview = isPreview;

    if (!this._initialized) {
        binder = new Dynamicweb.UIBinder(this.get_expression());

        binder.bindMethod('onSelectionChanged', [{ elements: [], action: function (sender, args) {
            var buttons = Ribbon;
            var hasCombinationComponentsSelected = false;
            var selection = args.parameters[0] ? args.parameters[0].selection : null;

            var canGroup = function () {
                //debugger
                var result = false;
                var combination = null;
                var combinationIDs = [];
                var hasRootCombination = false;
                var combinationsInvolved = new Hash();

                for (var i = 0; i < selection.length; i++) {
                    combination = self.get_expression().get_tree().owningCombination(selection[i].node.get_id());
                    if (combination) {
                        combinationsInvolved.set(combination.get_id(), combination);
                    } else {
                        hasRootCombination = true;
                    }
                }

                combinationIDs = combinationsInvolved.keys();

                result = hasRootCombination;
                /*if (combinationIDs.length <= 1) {
                if (combinationIDs.length == 0) {
                result = true;
                } else if (!hasRootCombination) {
                if (combinationsInvolved.get(combinationIDs[0]).get_components().length == selection.length) {
                result = true;
                } else {
                result = self.get_expression().get_tree().combinationDepth(combinationIDs[0]) <= 1;
                }
                }
                }*/

                return result;
            };

            if (selection && selection.length) {
                buttons.enableButton('cmdRemove_selected');

                if (selection.length > 1 && canGroup()) {
                    buttons.enableButton('cmdAll_must_apply');
                    buttons.enableButton('cmdAny_must_apply');
                } else {
                    buttons.disableButton('cmdAll_must_apply');
                    buttons.disableButton('cmdAny_must_apply');
                }

                for (var i = 0; i < selection.length; i++) {
                    if (self.get_expression().get_tree().owningCombination(selection[i].node.get_id())) {
                        hasCombinationComponentsSelected += true;
                        break;
                    }
                }

                if (hasCombinationComponentsSelected) {
                    buttons.enableButton('cmdUngroup');
                } else {
                    buttons.disableButton('cmdUngroup');
                }
            } else {
                buttons.disableButton('cmdRemove_selected');
                buttons.disableButton('cmdAll_must_apply');
                buttons.disableButton('cmdAny_must_apply');
                buttons.disableButton('cmdUngroup');
            }

            buttons.enableButton('cmd_Preview');
        }
        }]);

        setTimeout(function () {
            var name = document.getElementById(self._nameId);

            if (name) {
                try {
                    var buttons = Ribbon;

                    buttons.deactivateButton('cmdAll_must_apply');
                    buttons.disableButton('cmdRemove_selected');
                    buttons.disableButton('cmdAll_must_apply');
                    buttons.disableButton('cmdAny_must_apply');
                    buttons.disableButton('cmdUngroup');

                    name.focus();
                } catch (ex) { }
            }

            self._showPreview(self.get_previewMode());

        }, 200);

        this._initialized = true;
    }
}

SmartSearch.EditSmartSearch.prototype._showPreview = function (isPreview) {
    /// <summary>Show preview.</summary>   

    var treePreviewState = false;    

    if (isPreview || treePreviewState) {
        location.href = this.get_preViewUrl();
    }

}

SmartSearch.EditSmartSearch.prototype.preview = function () {
    /// <summaryPreview the smart search.</summary>

    if (!this.get_previewMode()) {
        if (confirm(this.get_terminology()['ConfirmPreview'])) {
            this.set_previewMode(true);
            this.save(false);
        }
        else {
            this._showPreview(false);
        }
    }
    else {
        this.set_previewMode(false);
        this._showPreview(this.get_previewMode());
    }
}

SmartSearch.EditSmartSearch.prototype.help = function () {
    /// <summaryPreview the smart search.</summary>
    window.open('http://manual.net.dynamicweb.dk/Default.aspx?ID=1&m=keywordfinder&keyword=smartsearches&LanguageID=' + this._helpLang, 'dw_help_window', 'location=no,directories=no,menubar=no,toolbar=yes,top=0,width=1024,height=' + (screen.availHeight - 100) + ',resizable=yes,scrollbars=yes');
}

SmartSearch.EditSmartSearch.prototype.removeSelected = function () {
    /// <summary>Removes the currently selected nodes from the tree.</summary>

    var ids = [];
    var selection = [];

    if (this.get_expression()) {
        selection = this.get_expression().get_tree().selection();

        if (selection && selection.length) {
            for (var i = 0; i < selection.length; i++) {
                ids[ids.length] = selection[i].node.get_id();
            }

            this.get_expression().get_tree().removeRange(ids);
        }
    }
}

SmartSearch.EditSmartSearch.prototype.groupSelected = function (operator) {
    /// <summary>Groups the currently selected nodes with the specified combine operator.</summary>
    /// <param name="operator">Combine operator.</param>

    var ids = [];
    var selection = [];

    if (this.get_expression()) {
        selection = this.get_expression().get_tree().selection();

        for (var i = 0; i < selection.length; i++) {
            ids[ids.length] = selection[i].node.get_id();
        }

        operator = parseInt(operator);

        if (operator == null || isNaN(operator) || operator < 0) {
            operator = 2; /* AND */
        }

        operator = Dynamicweb.Controls.SmartSearch.SmartSearchRulesEditor.CombineMethod.parse(operator);

        this.get_expression().get_tree().combine(ids, operator);
        this.get_expression().clearSelection();
    }
}

SmartSearch.EditSmartSearch.prototype.ungroupSelected = function () {
    /// <summary>Removes the grouping from the currently selected nodes.</summary>

    this.groupSelected(0);
}

SmartSearch.EditSmartSearch.prototype.validateData = function () {
    /// <summary>Validates the form.</summary>
    var result = false;

    var name = document.getElementById(this._nameId);

    if (name) {
        result = (name.value.length > 0);
        if (!result) alert(this.get_terminology()['EmptyName']);
    }

    var viewFields = document.getElementById(this._viewFieldsId);
    
    return result;
}

SmartSearch.EditSmartSearch.prototype.get_previewMode = function () {
    /// <summary>Get value indicates if preview mode enabled.</summary>
    return this._isPreview;
}

SmartSearch.EditSmartSearch.prototype.set_previewMode = function (isPreview) {
    /// <summary>Set preview mode.</summary>
    this._isPreview = isPreview;
}


SmartSearch.EditSmartSearch.prototype.get_preViewUrl = function () {
    /// <summary>Get save url.</summary>
    var d = new Date();
    var result = this._preViewUrl + "&" + d.getTime();
    return result;
}

SmartSearch.EditSmartSearch.prototype.get_SaveUrl = function (closeWindow) {
    /// <summary>Get save url.</summary>
    var result = closeWindow ? this._saveAndCloseUrl : this._saveUrl;
    result += (result.indexOf("?") != -1 ? "&ID=" : "?ID=") + this._id;

    if (!closeWindow && this.get_previewMode()) {
        result = result.replace("&preview=off", "");
        result += "&preview=on";
    }

    return result;
}

SmartSearch.EditSmartSearch.prototype.save = function (closeWindow) {
    /// <summary>Saves the profile.</summary>
    /// <param name="closeWindow">Value indicating whether to close the form after profile has been saved.</param>

    /* Validating input */
    if (this.validateData()) {
        //var expressionXml = self.get_expression().toXml();

        /* First, disabling the buttons indicating that the operating is being performed */

        Ribbon.disableButton('cmdSave');
        Ribbon.disableButton('cmdSaveAndClose');
        Ribbon.disableButton('cmdCancel');

        var form = this.get_formInstance();

        this.get_expression().commitChanges();

        form.target = '';
        form.action = this.get_SaveUrl(closeWindow);
        form.submit();
    }
}

SmartSearch.EditSmartSearch.prototype.saveAndClose = function () {
    /// <summary>Saves the profile and closes the form.</summary>

    this.save(true);
}

SmartSearch.EditSmartSearch.prototype.get_formInstance = function () {
    /// <summary>Get web form instance.</summary>
    var result = null;

    if (document && document.forms && document.forms.length > 0)
        result = document.forms[0];

    return result;
}

SmartSearch.EditSmartSearch.prototype.cancel = function () {
    /// <summary>Discards any changes and closes the form.</summary>
    window.location = this._cancelUrl;    
}