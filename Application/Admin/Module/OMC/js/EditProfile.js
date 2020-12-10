function EditProfilePage(opts) {
    var options = opts;

    var hasValue = function (el) {
        return el && !!el.value;
    };

    var getExpressionEditor = function (exprEditorId) {
        var obj = window[exprEditorId];
        return obj;
    };

    var invalidNameCharacters = ['"', '<', '>', '|', '/', ':'];
    var containsInvalidNameCharacters = function (value) {
        value = value || "";
        for (var i = 0; i < invalidNameCharacters.length; i++) {
            for (var j = 0; j < value.length; j++) {
                if (invalidNameCharacters[i] == value[j]) {
                    return true;
                }
            }
        }
        return false;
    }

    var buttons = Ribbon;

    var updateFormValues = function (data, frm) {
        frm = frm || document.forms[0];
        for (var key in data) {
            var el = document.getElementById(key);
            if (!el) {
                var input = document.createElement("input");
                input.setAttribute("type", "hidden");
                input.name = key;
                frm.appendChild(input);
                el = input;
            }
            el.value = typeof data[key] === "object" ? JSON.stringify(data[key]) : data[key];
        }
        return frm;
    }

    var api = {
        initialize: function (opts) {
            var self = this;
            self.options = opts;
            self.expressionEditor = getExpressionEditor(self.options.ids.expressionEditor);
            var binder = new Dynamicweb.UIBinder(self.expressionEditor);
            binder.bindMethod('onSelectionChanged', [{
                elements: [],
                action: function (sender, args) {
                    var hasCombinationComponentsSelected = false;
                    var selection = args.parameters[0] ? args.parameters[0].selection : null;

                    var canGroup = function () {
                        var result = false;
                        var combination = null;
                        var combinationIDs = [];
                        var hasRootCombination = false;
                        var combinationsInvolved = new Hash();

                        for (var i = 0; i < selection.length; i++) {
                            combination = self.expressionEditor.get_tree().owningCombination(selection[i].node.get_id());
                            if (combination) {
                                combinationsInvolved.set(combination.get_id(), combination);
                            } else {
                                hasRootCombination = true;
                            }
                        }

                        combinationIDs = combinationsInvolved.keys();

                        if (combinationIDs.length <= 1) {
                            if (combinationIDs.length == 0) {
                                result = true;
                            } else if (!hasRootCombination) {
                                if (combinationsInvolved.get(combinationIDs[0]).get_components().length == selection.length) {
                                    result = true;
                                } else {
                                    result = self.expressionEditor.get_tree().combinationDepth(combinationIDs[0]) <= 3;
                                }
                            }
                        }

                        return result;
                    }

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
                            if (self.expressionEditor.get_tree().owningCombination(selection[i].node.get_id())) {
                                hasCombinationComponentsSelected = true;
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
                }
            }]);
        },

        help: showHelp,

        cancel: function () {
            Action.Execute(options.actions.cancel);
        },

        validate: function (onComplete) {
            dwGlobal.hideAllControlsErrors();
            var self = this;
            var profileName = document.getElementById("txName");
            if (!hasValue(profileName)) {
                dwGlobal.showControlErrors(profileName, self.options.labels.emptyName);
                profileName.focus();
                onComplete(false);
            } else if (containsInvalidNameCharacters(profileName.value)) {
                dwGlobal.showControlErrors(profileName, self.options.labels.invalidNameCharacters.replace('%%', '\'' + invalidNameCharacters.join(' ') + '\''));
                profileName.focus();
                onComplete(false);
            } else if (!self.expressionEditor.get_totalPoints() && self.expressionEditor.get_expressionRows().length) {
                alert(self.options.labels.emptyExpressionPoints);
                onComplete(false);
            } else {
                var act = self.options.actions.checkExistingName;
                act.OnSuccess.Function = function () {
                    onComplete(true);
                };
                act.OnFail.Function = function () {
                    dwGlobal.showControlErrors(profileName, self.options.labels.existingName);
                    profileName.focus();
                    onComplete(false);
                };
                Action.Execute(act, {
                    profileId: self.options.profileId,
                    name: profileName.value
                });
            }
        },

        save: function (closeWindow) {
            var self = this;
            buttons.disableButton('cmdSave');
            buttons.disableButton('cmdSave_and_close');

            self.validate(function (isValid) {
                if (isValid) {
                    var expressionXml = self.expressionEditor.toXml();
                    updateFormValues({
                        "cmdSubmit": "save",
                        "CloseOnSave": (!!closeWindow).toString(),
                        "OriginalProfileID": self.options.profileId,
                        "ExpressionXml": expressionXml
                    });
                    var cmd = document.getElementById("cmdSubmit");
                    cmd.click();
                } else {
                    buttons.enableButton('cmdSave');
                    buttons.enableButton('cmdSave_and_close');
                }
            });

        },

        removeSelected: function () {
            var selection = this.expressionEditor.get_tree().selection();
            var ids = [];
            if (selection && selection.length) {
                for (var i = 0; i < selection.length; i++) {
                    ids.push(selection[i].node.get_id());
                }

                this.expressionEditor.get_tree().removeRange(ids);
            }
        },

        groupSelected: function (operator) {
            var selection = this.expressionEditor.get_tree().selection();
            var ids = [];

            for (var i = 0; i < selection.length; i++) {
                ids.push(selection[i].node.get_id());
            }

            operator = parseInt(operator);

            if (operator == null || isNaN(operator) || operator < 0) {
                operator = 2; /* AND */
            }

            operator = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.parse(operator);

            this.expressionEditor.get_tree().combine(ids, operator);
            this.expressionEditor.clearSelection();
        },

        ungroupSelected: function () {
            this.groupSelected(0);
        }
    };

    api.initialize(options);
    return api;
}