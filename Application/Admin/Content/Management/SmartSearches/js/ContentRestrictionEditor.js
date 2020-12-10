/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

if (typeof (Dynamicweb.Controls.OMC) == 'undefined') {
    Dynamicweb.Controls.OMC = new Object();
}

if (typeof (OMC) == 'undefined') {
    var OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Controls.OMC.ContentRestrictionEditor = function () {
    /// <summary>Represents a content restriction editor.</summary>

    this._container = null;
    this._initialized = false;
    this._presetDropDown = null;
    this._cache = {};
    this._terminology = {};
    this._lastError = '';
    this._hasPresets = false;
    this._isUsingPreset = false;
    this._evaluationType = 0;
    this._applyMode = 0;
    this._presets = [];
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.ProfileData = function (params) {
    /// <summary>Represents a profile data.</summary>
    /// <param name="params">Initialization parameters.</param>

    this._reference = '';

    if (params) {
        if (typeof (params.reference) != 'undefined') {
            this.set_reference(params.reference);
        }
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.ProfileData.prototype.get_reference = function () {
    /// <summary>Gets profile reference.</summary>

    return this._reference;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.ProfileData.prototype.set_reference = function (value) {
    /// <summary>Sets profile reference.</summary>
    /// <param name="value">Profile reference.</param>

    this._reference = value;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData = function (params) {
    /// <summary>Represents a preset data.</summary>
    /// <param name="params">Initialization parameters.</param>

    this._name = '';
    this._evaluationType = 0;
    this._applyMode = 0;
    this._profiles = [];

    if (params) {
        if (typeof (params.name) != 'undefined') {
            this.set_name(params.name);
        }

        if (typeof (params.evaluationType) != 'undefined') {
            this.set_evaluationType(params.evaluationType);
        }

        if (typeof (params.applyMode) != 'undefined') {
            this.set_applyMode(params.applyMode);
        }

        if (typeof (params.profiles) != 'undefined' && params.profiles.length) {
            for (var i = 0; i < params.profiles.length; i++) {
                if (params.profiles[i]) {
                    if (typeof (params.profiles[i].get_reference) == 'function') {
                        this._profiles[this._profiles.length] = params.profiles[i];
                    } else {
                        this._profiles[this._profiles.length] = new Dynamicweb.Controls.OMC.ContentRestrictionEditor.ProfileData(params.profiles[i]);
                    }
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData.prototype.get_name = function () {
    /// <summary>Gets preset name.</summary>

    return this._name;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData.prototype.set_name = function (value) {
    /// <summary>Sets preset name.</summary>
    /// <param name="value">Preset name.</param>

    this._name = value;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData.prototype.get_evaluationType = function () {
    /// <summary>Gets evaluation type.</summary>

    return this._evaluationType;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData.prototype.set_evaluationType = function (value) {
    /// <summary>Sets evaluation type.</summary>
    /// <param name="value">Evaluation type.</param>

    this._evaluationType = value || 0;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData.prototype.get_applyMode = function () {
    /// <summary>Gets apply mode.</summary>

    return this._applyMode;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData.prototype.set_applyMode = function (value) {
    /// <summary>Sets apply mode.</summary>
    /// <param name="value">Apply mode.</param>

    this._applyMode = value || 0;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData.prototype.get_profiles = function () {
    /// <summary>Gets preset profiles.</summary>

    return this._profiles;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData.prototype.set_profiles = function (value) {
    /// <summary>Sets preset profiles.</summary>
    /// <param name="value">Preset profiles.</param>

    this._profiles = value || 0;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_container = function () {
    /// <summary>Gets the reference to DOM element that contains all the UI.</summary>

    var ret = null;

    if (this._container != null) {
        if (typeof (this._container) == 'string') {
            ret = $(this._container);
            if (ret) {
                this._container = ret;
            }
        } else {
            ret = this._container;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.set_container = function (value) {
    /// <summary>Sets the reference to DOM element that contains all the UI.</summary>
    /// <param name="value">The reference to DOM element that contains all the UI.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_presetDropDown = function () {
    /// <summary>Gets the reference to "Preset" drop-down list control.</summary>

    var ret = null;

    if (this._presetDropDown) {
        if (typeof (this._presetDropDown) == 'string') {
            try {
                ret = eval(this._presetDropDown);
            } catch (ex) { }

            if (ret) {
                this._presetDropDown = ret;
            }
        } else {
            ret = this._presetDropDown;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.set_presetDropDown = function (value) {
    /// <summary>Sets the reference to "Preset" drop-down list control.</summary>
    /// <param name="value">The reference to "Preset" drop-down list control.</param>

    this._presetDropDown = value;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_choice = function () {
    /// <summary>Gets the current action type.</summary>

    var ret = '';

    if (this._cache.actionType && this._cache.actionType.value && this._cache.actionType.value.length) {
        ret = this._cache.actionType.value.toLowerCase();
    }

    return ret;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_lastError = function () {
    /// <summary>Gets the last error.</summary>

    return this._lastError;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.set_lastError = function (value) {
    /// <summary>Sets the last error.</summary>
    /// <param name="value">Last error.</param>

    this._lastError = value;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_hasPresets = function () {
    /// <summary>Gets value indicating whether at least one preset is available.</summary>

    return this._hasPresets;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.set_hasPresets = function (value) {
    /// <summary>Sets value indicating whether at least one preset is available.</summary>
    /// <param name="value">Value indicating whether at least one preset is available.</param>

    this._hasPresets = value;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_isUsingPreset = function () {
    /// <summary>Gets value indicating whether "Preset" section must be preselected.</summary>

    return this._isUsingPreset;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.set_isUsingPreset = function (value) {
    /// <summary>Sets value indicating whether "Preset" section must be preselected.</summary>
    /// <param name="value">Value indicating whether "Preset" section must be preselected.</param>

    this._isUsingPreset = value;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_evaluationType = function () {
    /// <summary>Gets evaluation type.</summary>

    return this._evaluationType;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.set_evaluationType = function (value) {
    /// <summary>Sets evaluation type.</summary>
    /// <param name="value">Evaluation type.</param>

    this._evaluationType = value;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_applyMode = function () {
    /// <summary>Gets apply mode.</summary>

    return this._applyMode;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.set_applyMode = function (value) {
    /// <summary>Sets apply mode.</summary>
    /// <param name="value">Apply mode.</param>

    this._applyMode = value || 0;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_selectedProfiles = function () {
    /// <summary>Gets the the list of selected profiles.</summary>

    var ret = [];
    var profileComponents = [];
    var profiles = this._cache.selectedProfiles.value.split(',');

    if (profiles && profiles.length) {
        for (var i = 0; i < profiles.length; i++) {
            if (profiles[i] && profiles[i].length) {
                if (profiles[i].indexOf('$') > 0) {
                    profileComponents = profiles[i].split('$');

                    if (profileComponents != null && profileComponents.length > 1) {
                        ret[ret.length] = { reference: profileComponents[0], applyMode: parseInt(profileComponents[1]) };
                        if (isNaN(ret[ret.length - 1].applyMode) || ret[ret.length - 1].applyMode == null) {
                            ret[ret.length - 1].applyMode = 0;
                        }
                    } else {
                        ret[ret.length] = { reference: profiles[i], applyMode: 0 };
                    }
                } else {
                    ret[ret.length] = { reference: profiles[i], applyMode: 0 };
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_isReady = function () {
    /// <summary>Gets value indicating whether control is ready to perform actions.</summary>

    return this._initialized;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return this._terminology;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.get_presets = function () {
    /// <summary>Gets the collection of preset data.</summary>

    return this._presets;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.set_presets = function (value) {
    /// <summary>Sets the collection of preset data.</summary>
    /// <param name="value">The collection of preset data.</param>

    this._presets = value || [];
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.add_ready = function (callback) {
    /// <summary>Adds a callback that is executed when the control is ready.</summary>
    /// <param name="callback">a callback that is executed when the control is ready.</param>

    callback = callback || function () { }

    $(document).observe('dom:loaded', function () { { callback(this, {}); } });
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.addPresetData = function (data) {
    /// <summary>Adds the given preset data to the preset data collection.</summary>
    /// <param name="data">Preset data.</param>

    if (data) {
        this.get_presets()[this.get_presets().length] = new Dynamicweb.Controls.OMC.ContentRestrictionEditor.PresetData(data);
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.onSelectedPresetChanged = function (sender, args) {
    /// <summary>Handles ddPresets "selectedIndexChanged" event.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var preset = null;
    var profiles = [];
    var presetName = '';
    var presetProfiles = [];
    var innerContainer = null;
    
    if (args && args.item) {
        innerContainer = $(args.item).select('span');
        if (innerContainer && innerContainer.length) {
            presetName = innerContainer[0].innerHTML;
        } else {
            presetName = args.item.innerHTML;
        }

        if (presetName && presetName.length) {
            presetName = presetName.replace(/\n/g, '');
            presetName = presetName.replace(/^\s\s*/, '').replace(/\s\s*$/, '');

            if (presetName && presetName.length) {
                preset = this.findPresetData(presetName);
                if (preset) {
                    presetProfiles = preset.get_profiles();
                    if (presetProfiles && presetProfiles.length) {
                        for (var i = 0; i < presetProfiles.length; i++) {
                            profiles[profiles.length] = presetProfiles[i].get_reference();
                        }
                    }

                    this.updateFormState({ evaluationType: preset.get_evaluationType(), applyMode: preset.get_applyMode(), profiles: profiles });
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.findPresetData = function (presetName) {
    /// <summary>Finds preset data by preset name.</summary>
    /// <param name="presetName">Preset name.</param>

    var ret = null;
    var presets = [];

    if (presetName && presetName.length) {
        presets = this.get_presets();
        if (presets && presets.length) {
            for (var i = 0; i < presets.length; i++) {
                if (presets[i].get_name() == presetName) {
                    ret = presets[i];
                    break;
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.initialize = function () {
    /// <summary>Initializes the object instance.</summary>

    var self = this;

    var changeRowActive = function (combobox, etalonVal) {
        self.updateRowState(combobox, etalonVal);
    }

    var changeComboState = function (combobox, isVisible) {
        self.updateComboState(combobox, isVisible);
    }

    var profileSelectionChanged = function (e, clicked) {
        var idx = 0;
        var val = '';
        var row = null;
        var isSelected = false;
        var elm = Event.element(e);

        if (typeof (elm.options) == 'undefined' || !clicked) {
            for (idx = 0; idx < self._cache.choiceCreateProfiles.length; idx++) {
                if (self._cache.choiceCreateProfiles[idx].id == elm.id)
                    break;
            }

            changeRowActive(elm, self._cache.etalonProfiles[idx]);

            if (typeof (elm.options) != 'undefined') {
                val = elm.options[elm.selectedIndex].value;
                isSelected = val != '';

                if (!isSelected) {
                    for (var i = 0; i < elm.options.length; ++i) {
                        if (elm.options[i].value != '') {
                            val = elm.options[i].value;
                            break;
                        }
                    }
                }
            } else if (typeof (elm.checked) != 'undefined') {
                isSelected = !!elm.checked;
                val = elm.value;
            }

            if (isSelected) {
                self.selectProfile(val, clicked ? 0 : (val && val.length ? 1 : 2));
            } else {
                self.deselectProfile(val);
            }
        }
    }

    if (!this._initialized) {
        this._initializeCache();

        if (this._cache.choiceNotActive) {
            Event.observe(this._cache.choiceNotActive, 'click', function (e) { self.choose('notActive'); });
        }

        if (this._cache.choicePreset) {
            Event.observe(this._cache.choicePreset, 'click', function (e) { self.choose('preset'); });
        }

        if (this._cache.choiceCreate) {
            Event.observe(this._cache.choiceCreate, 'click', function (e) { self.choose('create'); });
        }

        if (this._cache.choiceCreateProfiles && this._cache.choiceCreateProfiles.length) {
            for (var i = 0; i < this._cache.choiceCreateProfiles.length; i++) {
                Event.observe(this._cache.choiceCreateProfiles[i], 'click', function (e) { profileSelectionChanged(e, true); });
                Event.observe(this._cache.choiceCreateProfiles[i], 'change', function (e) { profileSelectionChanged(e, false); });
            }
        }

        if (this._cache.choiceCreateSelectAll) {
            Event.observe(this._cache.choiceCreateSelectAll, 'click', function (e) {
                var val = '';
                var isCheckbox = false;

                for (var i = 0; i < self._cache.choiceCreateProfiles.length; i++) {
                    changeComboState(self._cache.choiceCreateProfiles[i], true);
                    changeRowActive(self._cache.choiceCreateProfiles[i], self._cache.etalonProfiles[i]);

                    if (typeof (self._cache.choiceCreateProfiles[i].options) != 'undefined') {
                        val = self._cache.choiceCreateProfiles[i].options[self._cache.choiceCreateProfiles[i].selectedIndex].value;
                    } else if (typeof (self._cache.choiceCreateProfiles[i].value) != 'undefined') {
                        val = self._cache.choiceCreateProfiles[i].value;
                        isCheckbox = true;
                    }

                    self.selectProfile(val, isCheckbox ? 0 : (val && val.length ? 1 : 2));
                }
            });
        }

        if (this._cache.choiceCreateUnSelectAll) {
            Event.observe(this._cache.choiceCreateUnSelectAll, 'click', function (e) {
                for (var i = 0; i < self._cache.choiceCreateProfiles.length; i++) {
                    changeComboState(self._cache.choiceCreateProfiles[i], false);
                    changeRowActive(self._cache.choiceCreateProfiles[i], self._cache.etalonProfiles[i]);
                }

                self._cache.selectedProfiles.value = '';
            });
        }

        if (this._cache.choicePreset) {
            setTimeout(function () {
                var isAllItemsHides = true;
                
                for (var i = 0; i < self._cache.etalonProfiles.length; i++) {
                    if (self._cache.etalonProfiles[i] != '') {
                        isAllItemsHides = false;
                        break;
                    }
                }

                if (self.get_presetDropDown().get_allItems().length <= 1 && !self.get_hasPresets()) {
                    self._cache.choicePreset.disabled = true;
                    self._cache.choicePresetContainer.addClassName('omc-restrict-edit-disabled');
                }

                if (isAllItemsHides) self.choose('notActive');
                else if (self.get_isUsingPreset()) self.choose('preset');
                else if (self._cache.etalonProfiles.length == 0) self.choose('notActive');
                else self.choose('create');

            }, 100);
        }

        if (this._cache.newPresetText) {
            Event.observe(this._cache.newPresetText, 'keydown', function (e) {
                if (e.keyCode == 13 || e.which == 13 || e.charCode == 13) {
                    Event.stop(e);
                }
            });
        }

        this.updateFormState({ evaluationType: this.get_evaluationType(), applyMode: this.get_applyMode(), profiles: this.get_selectedProfiles() });

        this._initialized = true;
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.updateComboState = function (combobox, isVisible) {
    /// <summary>Updates "Visibility" drop-down list state.</summary>
    /// <param name="combobox">Referencing drop-down list.</param>
    /// <param name="isVisible">Value indicating whether the referencing profile is visible.</param>

    if (combobox) {
        if (typeof (combobox.options) != 'undefined') {
            for (var i = 0; i < combobox.options.length; ++i) {
                if ((isVisible && combobox.options[i].value != '') || (!isVisible && combobox.options[i].value == '')) {
                    combobox.selectedIndex = i;
                    break;
                }
            }
        } else if (typeof (combobox.checked) != 'undefined') {
            combobox.checked = !!isVisible;
        }
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.updateRowState = function (combobox, etalonVal) {
    /// <summary>Updates profile row state.</summary>
    /// <param name="checkbox">Referencing checkbox.</param>

    var val = '';
    var row = null;

    if (combobox && etalonVal != null) {
        row = $(combobox).up('li');

        if (typeof (combobox.options) != 'undefined') {
            val = combobox.options[combobox.selectedIndex].value;
        } else if (typeof (combobox.checked) != 'undefined') {
            val = combobox.checked ? combobox.value : '';
        }

        if (val != etalonVal) {
            row.addClassName('omc-restrict-edit-profile-selected');
        } else {
            row.removeClassName('omc-restrict-edit-profile-selected');
        }
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.updateFormState = function (state) {
    /// <summary>Updates form state.</summary>
    /// <param name="state">Form state.</param>

    var val = '';
    var reference = '';
    var checkedRows = 0;
    var stateProfiles = {};

    if (state) {
        if (this._cache.evaluationTypeRecognized) this._cache.evaluationTypeRecognized.checked = state.evaluationType == 0;
        if (this._cache.evaluationTypePrimary) this._cache.evaluationTypePrimary.checked = state.evaluationType == 1;

        if (this._cache.applyModeShow) this._cache.applyModeShow.checked = state.applyMode == 1;
        if (this._cache.applyModeHide) this._cache.applyModeHide.checked = state.applyMode == 2;

        if (this._cache.applyModeShow && this._cache.applyModeHide && !this._cache.applyModeShow.checked && !this._cache.applyModeHide.checked) {
            this._cache.applyModeShow.checked = true;
        }

        if (state.profiles) {
            for (var i = 0; i < state.profiles.length; i++) {
                if (typeof (state.profiles[i]) != 'undefined') {
                    if (typeof (state.profiles[i].reference) != 'undefined') {
                        reference = state.profiles[i].reference;
                    } else {
                        reference = state.profiles[i];
                    }
                }

                stateProfiles[reference] = true;

                for (var j = 0; j < this._cache.choiceCreateProfiles.length; j++) {
                    if (typeof (this._cache.choiceCreateProfiles[j].options) != 'undefined') {
                        for (var k = 0; k < this._cache.choiceCreateProfiles[j].options.length; k++) {
                            val = this._cache.choiceCreateProfiles[j].options[k].value;

                            if (val && val.length) {
                                break;
                            }
                        }
                    } else if (typeof (this._cache.choiceCreateProfiles[j].value) != 'undefined') {
                        val = this._cache.choiceCreateProfiles[j].value;
                    }

                    if (val == reference) {
                        this.updateComboState(this._cache.choiceCreateProfiles[j], true);
                        checkedRows += 1;
                        break;
                    }
                }
            }

            for (var i = 0; i < this._cache.choiceCreateProfiles.length; i++) {
                if ((typeof (this._cache.choiceCreateProfiles[i].value) != 'undefined' && !stateProfiles[this._cache.choiceCreateProfiles[i].value]) ||
                    (typeof (this._cache.choiceCreateProfiles[i].options) != 'undefined' && !stateProfiles[this._cache.choiceCreateProfiles[i].options[this._cache.choiceCreateProfiles[i].selectedIndex].value])) {

                    this.updateComboState(this._cache.choiceCreateProfiles[i], false);
                }
            }

            for (var i = 0; i < this._cache.etalonProfiles.length; i++) {
                if (typeof (this._cache.choiceCreateProfiles[i].options) != 'undefined') {
                    val = this._cache.choiceCreateProfiles[i].options[this._cache.choiceCreateProfiles[i].selectedIndex].value;
                } else if (typeof (this._cache.choiceCreateProfiles[i].checked) != 'undefined') {
                    val = this._cache.choiceCreateProfiles[i].checked ? this._cache.choiceCreateProfiles[i].value : '';
                }

                this._cache.etalonProfiles[i] = val;
                this.updateRowState(this._cache.choiceCreateProfiles[i], val);
            }
        }
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.selectProfile = function (reference, applyMode) {
    /// <summary>Selects the given profile.</summary>
    /// <param name="referece">Profile referece.</param>
    /// <param name="applyMode">Apply mode.</param>

    var val = '';
    var profiles = null;
    var commitProfile = false;
    var isExistingProfile = false;

    if (reference && reference.length) {
        if (typeof (applyMode) == 'undefined' || applyMode == null) {
            applyMode = 0;
        }

        profiles = this.get_selectedProfiles();

        if (!profiles || !profiles.length) {
            profiles = [{ reference: reference, applyMode: applyMode}];
            commitProfile = true;
        } else {
            for (var i = 0; i < profiles.length; i++) {
                if (profiles[i].reference == reference) {
                    isExistingProfile = true;
                    break;
                }
            }

            if (!isExistingProfile) {
                profiles[profiles.length] = { reference: reference, applyMode: applyMode };
                commitProfile = true;
            }
        }

        if (commitProfile) {
            for (var i = 0; i < profiles.length; i++) {
                val += (profiles[i].reference + '$' + profiles[i].applyMode);
                if (i < (profiles.length - 1)) {
                    val += ',';
                }
            }

            this._cache.selectedProfiles.value = val;
        }
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.deselectProfile = function (reference) {
    /// <summary>Deselectes the given profile.</summary>
    /// <param name="referece">Profile referece.</param>

    var val = '';
    var profiles = null;
    var newProfiles = [];

    if (reference && reference.length) {
        profiles = this.get_selectedProfiles();

        if (profiles && profiles.length) {
            for (var i = 0; i < profiles.length; i++) {
                if (profiles[i].reference != reference) {
                    newProfiles[newProfiles.length] = { reference: profiles[i].reference, applyMode: profiles[i].applyMode };
                }
            }

            if (newProfiles.length) {
                for (var i = 0; i < newProfiles.length; i++) {
                    val += (newProfiles[i].reference + '$' + newProfiles[i].applyMode);
                    if (i < (newProfiles.length - 1)) {
                        val += ',';
                    }
                }
            }

            this._cache.selectedProfiles.value = val;
        }
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.choose = function (type) {
    /// <summary>Switches user's choice to specified one.</summary>
    /// <param name="type">User's choice.</param>

    this._cache.actionType.value = type;

    if (type == 'notActive') {
        this._cache.choiceNotActive.checked = true;
        this._cache.choicePreset.checked = false;
        this._cache.choiceCreate.checked = false;

        this.get_presetDropDown().set_isEnabled(false);

        for (var i = 0; i < this._cache.choiceCreateProfiles.length; i++) {
            this._cache.choiceCreateProfiles[i].disabled = true;
        }

        if (this._cache.choiceCreateSelectAll) {
            this._cache.choiceCreateSelectAll.disabled = true;
        }

        if (this._cache.choiceCreateUnSelectAll) {
            this._cache.choiceCreateUnSelectAll.disabled = true;
        }

        if (this._cache.newPresetText) {
            this._cache.newPresetText.disabled = true;
        }

        if (this._cache.evaluationTypeRecognized) this._cache.evaluationTypeRecognized.disabled = true;
        if (this._cache.evaluationTypePrimary) this._cache.evaluationTypePrimary.disabled = true;

        if (this._cache.applyModeShow) this._cache.applyModeShow.disabled = true;
        if (this._cache.applyModeHide) this._cache.applyModeHide.disabled = true;

        this._cache.choicePresetContent.addClassName('omc-restrict-edit-disabled');
        this._cache.choiceCreateContent.addClassName('omc-restrict-edit-disabled');
    }
    else if (type == 'preset' && !this._cache.choicePreset.disabled) {
        this._cache.choiceNotActive.checked = false;
        this._cache.choicePreset.checked = true;
        this._cache.choiceCreate.checked = false;

        this.get_presetDropDown().set_isEnabled(true);

        for (var i = 0; i < this._cache.choiceCreateProfiles.length; i++) {
            this._cache.choiceCreateProfiles[i].disabled = true;
        }

        if (this._cache.choiceCreateSelectAll) {
            this._cache.choiceCreateSelectAll.disabled = true;
        }

        if (this._cache.choiceCreateUnSelectAll) {
            this._cache.choiceCreateUnSelectAll.disabled = true;
        }

        if (this._cache.newPresetText) {
            this._cache.newPresetText.disabled = true;
        }

        if (this._cache.evaluationTypeRecognized) this._cache.evaluationTypeRecognized.disabled = true;
        if (this._cache.evaluationTypePrimary) this._cache.evaluationTypePrimary.disabled = true;

        if (this._cache.applyModeShow) this._cache.applyModeShow.disabled = true;
        if (this._cache.applyModeHide) this._cache.applyModeHide.disabled = true;

        this._cache.choicePresetContent.removeClassName('omc-restrict-edit-disabled');
        this._cache.choiceCreateContent.addClassName('omc-restrict-edit-disabled');

        this.onSelectedPresetChanged(this.get_presetDropDown(), { item: this.get_presetDropDown().get_selectedItem() });
    } else if (type == 'create' && !this._cache.choiceCreate.disabled) {
        this._cache.choiceNotActive.checked = false;
        this._cache.choicePreset.checked = false;
        this._cache.choiceCreate.checked = true;

        this.get_presetDropDown().set_isEnabled(false);
        for (var i = 0; i < this._cache.choiceCreateProfiles.length; i++) {
            this._cache.choiceCreateProfiles[i].disabled = false;
        }

        if (this._cache.choiceCreateSelectAll) {
            this._cache.choiceCreateSelectAll.disabled = false;
        }

        if (this._cache.choiceCreateUnSelectAll) {
            this._cache.choiceCreateUnSelectAll.disabled = false;
        }

        if (this._cache.newPresetText) {
            this._cache.newPresetText.disabled = false;
        }

        if (this._cache.evaluationTypeRecognized) this._cache.evaluationTypeRecognized.disabled = false;
        if (this._cache.evaluationTypePrimary) this._cache.evaluationTypePrimary.disabled = false;

        if (this._cache.applyModeShow) this._cache.applyModeShow.disabled = false;
        if (this._cache.applyModeHide) this._cache.applyModeHide.disabled = false;

        this._cache.choicePresetContent.addClassName('omc-restrict-edit-disabled');
        this._cache.choiceCreateContent.removeClassName('omc-restrict-edit-disabled');
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.validate = function (onComplete) {
    /// <summary>Validates user input.</summary>
    /// <param name="onComplete">Callback which is called when validation completes.</param>

    onComplete = onComplete || function () { }

    onComplete(true);
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.save = function () {
    /// <summary>Saves user input.</summary>

    this._postBack();
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype.openProfileEdit = function () {
    /// <summary>Opens the profile edit page.</summary>

    if (confirm(this.get_terminology()['DiscardChangesConfirm'])) {
        if (top && top['left'] && typeof (top['left'].omc) == 'function') {
            top['left'].omc('NewProfile');
        }
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype._postBack = function () {
    /// <summary>Performs a postback.</summary>
    /// <private />

    if (typeof (__doPostBack) == 'function') {
        __doPostBack(this._cache.postBackActivator.name, '');
    } else {
        this._cache.postBackActivator.click();
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor.prototype._initializeCache = function () {
    /// <summary>Initializes object cache.</summary>
    /// <private />

    var container = $(document.body);

    this._cache = {};

    this._cache.choiceNotActiveContainer = $(container.select('.omc-restrict-edit-not-active')[0]);
    this._cache.choicePresetContainer = $(container.select('fieldset.omc-restrict-edit-choice-preset')[0]);
    this._cache.choiceCreateContainer = $(container.select('fieldset.omc-restrict-edit-choice-create')[0]);
    this._cache.choiceNotActive = $(container.select('.omc-restrict-edit-not-active input')[0]);
    this._cache.choicePreset = $(container.select('fieldset.omc-restrict-edit-choice-preset input')[0]);
    this._cache.choiceCreate = $(container.select('fieldset.omc-restrict-edit-choice-create input')[0]);
    this._cache.choicePresetContent = $(container.select('fieldset.omc-restrict-edit-choice-preset div.omc-restrict-edit-choice-content')[0]);
    this._cache.choiceCreateContent = $(container.select('fieldset.omc-restrict-edit-choice-create div.omc-restrict-edit-choice-content')[0]);

    this._cache.choiceCreateSelectAll = $(container.select('a.omc-restrict-edit-visibility-show-all')[0]);
    this._cache.choiceCreateUnSelectAll = $(container.select('a.omc-restrict-edit-visibility-hide-all')[0]);

    this._cache.actionType = $(container.select('input.omc-restrict-edit-actiontype')[0]);
    this._cache.postBackActivator = $(container.select('input.omc-restrict-edit-postback')[0]);

    this._cache.choiceCreateProfiles = container.select('div.omc-restrict-edit-profile-visibility select').concat(container.select('div.omc-restrict-edit-profile-visibility input[type="checkbox"]'));

    this._cache.selectedProfiles = $(container.select('input.omc-restrict-edit-profiles')[0]);

    this._cache.newPresetText = $(container.select('input.omc-restrict-edit-newpreset')[0]);

    this._cache.evaluationTypeRecognized = $(container.select('.omc-restrict-evaluationtype-recognized input')[0]);
    this._cache.evaluationTypePrimary = $(container.select('.omc-restrict-evaluationtype-primary input')[0]);

    this._cache.applyModeShow = $(container.select('.omc-restrict-applymode-show input')[0]);
    this._cache.applyModeHide = $(container.select('.omc-restrict-applymode-hide input')[0]);

    this._cache.etalonProfiles = new Array(this._cache.choiceCreateProfiles.length);

    for (var i = 0; i < this._cache.etalonProfiles.length; i++) {
        this._cache.etalonProfiles[i] = '';
    }
}

Dynamicweb.Controls.OMC.ContentRestrictionEditor._listDataExchange = function (sender, args) {
    /// <summary>Occurs when the data between currently selected list item and the box template needs to be exchanged.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event argument.</param>
    /// <private />

    var f = null;

    if (args.dataSource && args.dataDestination) {
        f = typeof (args.dataSource.innerText) != 'undefined' ? args.dataSource.innerText : args.dataSource.textContent;
        args.dataDestination.innerHTML = '<span class="omc-restrict-edit-list-item">' + f + '</span>';
    }
}
