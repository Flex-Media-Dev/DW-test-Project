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

Dynamicweb.Controls.OMC.ProfileDynamicsEditor = function (options) {
    /// <summary>Represents a profile dynamics editor.</summary>

    this._container = null;
    this._initialized = false;
    this._presetDropDown = null;
    this._cache = {};
    this._terminology = {};
    this._lastError = '';
    this._hasPresets = false;
    this._isUsingPreset = false;
    this._sliders = [];
    this._presets = [];
    this._options = options;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.ProfileData = function (params) {
    /// <summary>Represents a profile data.</summary>
    /// <param name="params">Initialization parameters.</param>

    this._reference = '';
    this._growth = 0;

    if (params) {
        if (typeof (params.reference) != 'undefined') {
            this.set_reference(params.reference);
        }

        if (typeof (params.growth) != 'undefined') {
            this.set_growth(params.growth);
        }
    }
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.ProfileData.prototype.get_reference = function () {
    /// <summary>Gets profile reference.</summary>

    return this._reference;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.ProfileData.prototype.set_reference = function (value) {
    /// <summary>Sets profile reference.</summary>
    /// <param name="value">Profile reference.</param>

    this._reference = value;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.ProfileData.prototype.get_growth = function () {
    /// <summary>Gets profile gworth.</summary>

    return this._growth;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.ProfileData.prototype.set_growth = function (value) {
    /// <summary>Sets profile gworth.</summary>
    /// <param name="value">Profile gworth.</param>

    this._growth = value;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.PresetData = function (params) {
    /// <summary>Represents a preset data.</summary>
    /// <param name="params">Initialization parameters.</param>

    this._name = '';
    this._profiles = [];

    if (params) {
        if (typeof (params.name) != 'undefined') {
            this.set_name(params.name);
        }

        if (typeof (params.profiles) != 'undefined' && params.profiles.length) {
            for (var i = 0; i < params.profiles.length; i++) {
                if (params.profiles[i]) {
                    if (typeof (params.profiles[i].get_reference) == 'function') {
                        this._profiles[this._profiles.length] = params.profiles[i];
                    } else {
                        this._profiles[this._profiles.length] = new Dynamicweb.Controls.OMC.ProfileDynamicsEditor.ProfileData(params.profiles[i]);
                    }
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.PresetData.prototype.get_name = function () {
    /// <summary>Gets preset name.</summary>

    return this._name;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.PresetData.prototype.set_name = function (value) {
    /// <summary>Sets preset name.</summary>
    /// <param name="value">Preset name.</param>

    this._name = value;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.PresetData.prototype.get_profiles = function () {
    /// <summary>Gets preset profiles.</summary>

    return this._profiles;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.PresetData.prototype.set_profiles = function (value) {
    /// <summary>Sets preset profiles.</summary>
    /// <param name="value">Preset profiles.</param>

    this._profiles = value || 0;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.hasPermission = function (permissionLevel) {
    /// <summary>Gets the reference to DOM element that contains all the UI.</summary>
    return permissionLevel <= this._options.permissionLevel;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_container = function () {
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

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.set_container = function (value) {
    /// <summary>Sets the reference to DOM element that contains all the UI.</summary>
    /// <param name="value">The reference to DOM element that contains all the UI.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_presetDropDown = function () {
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

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.set_presetDropDown = function (value) {
    /// <summary>Sets the reference to "Preset" drop-down list control.</summary>
    /// <param name="value">The reference to "Preset" drop-down list control.</param>

    this._presetDropDown = value;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_choice = function () {
    /// <summary>Gets the current action type.</summary>

    var ret = '';

    if (this._cache.actionType && this._cache.actionType.value && this._cache.actionType.value.length) {
        ret = this._cache.actionType.value.toLowerCase();
    }

    return ret;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_lastError = function () {
    /// <summary>Gets the last error.</summary>

    return this._lastError;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.set_lastError = function (value) {
    /// <summary>Sets the last error.</summary>
    /// <param name="value">Last error.</param>

    this._lastError = value;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_sliders = function () {
    /// <summary>Gets the list of available sliders.</summary>

    var obj = null;
    var ret = this._sliders;
    var evaluationFailed = false;

    if (ret && ret.length) {
        if (typeof (ret[0]) == 'string') {
            for (var i = 0; i < ret.length; i++) {
                try {
                    obj = eval(ret[i]);
                } catch (ex) { }

                if (obj) {
                    ret[i] = obj;
                } else {
                    evaluationFailed = true;
                    break;
                }
            }

            if (!evaluationFailed) {
                this._sliders = ret;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.set_sliders = function (value) {
    /// <summary>Sets the list of available sliders.</summary>
    /// <param name="value">The list of available sliders.</param>

    this._sliders = value;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_hasPresets = function () {
    /// <summary>Gets value indicating whether at least one preset is available.</summary>

    return this._hasPresets;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.set_hasPresets = function (value) {
    /// <summary>Sets value indicating whether at least one preset is available.</summary>
    /// <param name="value">Value indicating whether at least one preset is available.</param>

    this._hasPresets = value;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_isUsingPreset = function () {
    /// <summary>Gets value indicating whether "Preset" section must be preselected.</summary>

    return this._isUsingPreset;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.set_isUsingPreset = function (value) {
    /// <summary>Sets value indicating whether "Preset" section must be preselected.</summary>
    /// <param name="value">Value indicating whether "Preset" section must be preselected.</param>

    this._isUsingPreset = value;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_isReady = function () {
    /// <summary>Gets value indicating whether control is ready to perform actions.</summary>

    return this._initialized;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return this._terminology;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.get_presets = function () {
    /// <summary>Gets the collection of preset data.</summary>

    return this._presets;
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.set_presets = function (value) {
    /// <summary>Sets the collection of preset data.</summary>
    /// <param name="value">The collection of preset data.</param>

    this._presets = value || [];
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.add_ready = function (callback) {
    /// <summary>Adds a callback that is executed when the control is ready.</summary>
    /// <param name="callback">a callback that is executed when the control is ready.</param>

    callback = callback || function () { }

    $(document).observe('dom:loaded', function () { { callback(this, {}); } });
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.addPresetData = function (data) {
    /// <summary>Adds the given preset data to the preset data collection.</summary>
    /// <param name="data">Preset data.</param>

    if (data) {
        this.get_presets()[this.get_presets().length] = new Dynamicweb.Controls.OMC.ProfileDynamicsEditor.PresetData(data);
    }
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.onSelectedPresetChanged = function (sender, args) {
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
                            profiles[profiles.length] = { reference: presetProfiles[i].get_reference(), growth: presetProfiles[i].get_growth() };
                        }
                    }

                    this.updateFormState({ profiles: profiles });
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.findPresetData = function (presetName) {
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


Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.initialize = function () {
    /// <summary>Initializes the object instance.</summary>

    var self = this;

    if (!this._initialized) {
        this._initializeCache();

        if (this._cache.choicePreset) {
            Event.observe(this._cache.choicePreset, 'click', function (e) { self.choose('preset'); });
        }

        if (this._cache.choiceCreate) {
            Event.observe(this._cache.choiceCreate, 'click', function (e) { self.choose('create'); });
        }

        if (this._cache.choicePreset) {
            setTimeout(function () {
                if (self.get_presetDropDown().get_allItems().length <= 1 && !self.get_hasPresets()) {
                    self.choose('create');
                    self._cache.choicePreset.disabled = true;
                    self._cache.choicePresetContainer.addClassName('omc-dynamics-edit-disabled');
                } else {
                    if (self.get_isUsingPreset()) {
                        self.choose('preset');
                    } else {
                        self.choose('create');
                    }
                }
            }, 100);
        }

        if (this._cache.newPresetText) {
            Event.observe(this._cache.newPresetText, 'keydown', function (e) {
                if (e.keyCode == 13 || e.which == 13 || e.charCode == 13) {
                    Event.stop(e);
                }
            });
        }

        this._initialized = true;
    }
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.updateFormState = function (state) {
    /// <summary>Updates form state.</summary>
    /// <param name="state">Form state.</param>

    var checkedRows = 0;
    var stateProfiles = {};
    var sliders = this.get_sliders();

    if (state) {
        if (state.profiles) {
            for (var i = 0; i < state.profiles.length; i++) {
                stateProfiles[state.profiles[i].reference] = true;

                for (var j = 0; j < sliders.length; j++) {
                    if (sliders[j].get_tag() == state.profiles[i].reference) {
                        sliders[j].set_selectedValue(state.profiles[i].growth);

                        break;
                    }
                }
            }

            for (var i = 0; i < sliders.length; i++) {
                if (!stateProfiles[sliders[j].get_tag()]) {
                    sliders[i].set_selectedValue(0);
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.choose = function (type) {
    /// <summary>Switches user's choice to specified one.</summary>
    /// <param name="type">User's choice.</param>

    var sliders = this.get_sliders();
    this._cache.actionType.value = type;
    var editAllowed = this.hasPermission(PermissionLevels.Edit);
    if (type == 'preset' && !this._cache.choicePreset.disabled) {
        this._cache.choicePreset.checked = true;
        this._cache.choiceCreate.checked = false;

        this.get_presetDropDown().set_isEnabled(editAllowed);

        if (this._cache.newPresetText) {
            this._cache.newPresetText.disabled = true;
        }

        this._cache.choicePresetContent.removeClassName('omc-dynamics-edit-disabled');
        this._cache.choiceCreateContent.addClassName('omc-dynamics-edit-disabled');

        for (var i = 0; i < sliders.length; i++) {
            sliders[i].set_isEnabled(false);
        }

        this.onSelectedPresetChanged(this.get_presetDropDown(), { item: this.get_presetDropDown().get_selectedItem() });
    } else if (type == 'create' && !this._cache.choiceCreate.disabled) {
        this._cache.choicePreset.checked = false;
        this._cache.choiceCreate.checked = true;

        this.get_presetDropDown().set_isEnabled(false);

        if (this._cache.newPresetText) {
            this._cache.newPresetText.disabled = !this.hasPermission(PermissionLevels.Create);
        }

        this._cache.choicePresetContent.addClassName('omc-dynamics-edit-disabled');
        this._cache.choiceCreateContent.removeClassName('omc-dynamics-edit-disabled');

        for (var i = 0; i < sliders.length; i++) {
            sliders[i].set_isEnabled(editAllowed);
        }
    }
    if (!editAllowed) {
        this._cache.choicePreset.disabled = true;
        this._cache.choiceCreate.disabled = true;
    } 
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.validate = function (onComplete) {
    /// <summary>Validates user input.</summary>
    /// <param name="onComplete">Callback which is called when validation completes.</param>

    onComplete = onComplete || function () { }

    onComplete(true);
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.save = function () {
    /// <summary>Saves user input.</summary>

    this._postBack();
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype.openProfileEdit = function () {
    /// <summary>Opens the profile edit page.</summary>

    if (confirm(this.get_terminology()['DiscardChangesConfirm'])) {
        if (top && top['left'] && typeof (top['left'].omc) == 'function') {
            top['left'].omc('NewProfile');
        }
    }
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype._postBack = function () {
    /// <summary>Performs a postback.</summary>
    /// <private />

    if (typeof (__doPostBack) == 'function') {
        __doPostBack(this._cache.postBackActivator.name, '');
    } else {
        this._cache.postBackActivator.click();
    }
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor.prototype._initializeCache = function () {
    /// <summary>Initializes object cache.</summary>
    /// <private />

    var container = $(document.body);

    this._cache = {};
    this._cache.choicePresetContainer = $(container.select('#presetContainer')[0]);
    this._cache.choiceCreateContainer = $(container.select('#createContainer')[0]);
    this._cache.choicePreset = $(container.select('#rbPreset')[0]);
    this._cache.choiceCreate = $(container.select('#rbCreate')[0]);
    this._cache.choicePresetContent = $(container.select('#presetContainer')[0]);
    this._cache.choiceCreateContent = $(container.select('#createContainer')[0]);

    this._cache.actionType = $(container.select('input.omc-dynamics-edit-actiontype')[0]);
    this._cache.postBackActivator = $(container.select('input.omc-dynamics-edit-postback')[0]);

    this._cache.newPresetText = $(container.select('input.omc-dynamics-edit-newpreset')[0]);
}

Dynamicweb.Controls.OMC.ProfileDynamicsEditor._listDataExchange = function (sender, args) {
    /// <summary>Occurs when the data between currently selected list item and the box template needs to be exchanged.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event argument.</param>
    /// <private />

    var f = null;

    if (args.dataSource && args.dataDestination) {
        f = typeof (args.dataSource.innerText) != 'undefined' ? args.dataSource.innerText : args.dataSource.textContent;
        args.dataDestination.innerHTML = '<span class="omc-dynamics-edit-list-item">' + f + '</span>';
    }
}
