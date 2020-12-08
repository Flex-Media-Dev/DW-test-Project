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

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Controls.OMC.MarketingConfiguration = function (personalizeTitle, addProfilePointsTitle) {
    /// <summary>Represents a marketing configuration.</summary>

    this.dialogId = '';
    this._container = '';    

    this._settings = [
        { type: 'ContentRestriction', baseUrl: '/Admin/Module/OMC/Profiles/ContentRestrictionEdit.aspx', title: personalizeTitle, width: 550 },
        { type: 'ProfileDynamics', baseUrl: '/Admin/Module/OMC/Profiles/ProfileDynamicsEdit.aspx', title: addProfilePointsTitle, width: 800, height: 415 }
    ]
}

Dynamicweb.Controls.OMC.MarketingConfiguration.prototype.get_container = function () {
    /// <summary>Gets the identifier of the DOM element associated with this control.</summary>

    return this._container;
}

Dynamicweb.Controls.OMC.MarketingConfiguration.prototype.set_container = function (value) {
    /// <summary>Sets the identifier of the DOM element associated with this control.</summary>
    /// <param name="value">The identifier of the DOM element associated with this control.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.MarketingConfiguration.prototype.set_hostingWindow = function (value) {
    /// <summary>Sets the id of dialog control that should hold the UI for the settings.</summary>
    /// <param name="value">The id of dialog control that should hold the UI for the settings.</param>

    this.dialogId = value;
}

Dynamicweb.Controls.OMC.MarketingConfiguration.prototype.add_ready = function (callback) {
    /// <summary>Registers new callback which is executed when the page is loaded.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }
    Event.observe(document, 'dom:loaded', function () {
        callback(this, {});
    });
}

Dynamicweb.Controls.OMC.MarketingConfiguration.prototype.registerSettings = function (settings) {
    /// <summary>Registers a new settings type.</summary>
    /// <param name="settings">Settings object.</param>

    if (settings && settings.type && settings.type.length) {
        this.unregisterSettings(settings.type);
        this._settings[this._settings.length] = settings;
    }
}

Dynamicweb.Controls.OMC.MarketingConfiguration.prototype.unregisterSettings = function (type) {
    /// <summary>Unregisters the existing settings.</summary>
    /// <param name="type">Settings type.</param>

    var newSettings = [];

    if (type && type.length) {
        for (var i = 0; i < this._settings.length; i++) {
            if (this._settings[i].type.toLowerCase() != type.toLowerCase()) {
                newSettings[newSettings.length] = this._settings[i];
            }
        }

        this._settings = newSettings;
    }
}

Dynamicweb.Controls.OMC.MarketingConfiguration.prototype.getSettings = function (type) {
    /// <summary>Returns settings of the given type.</summary>
    /// <param name="type">Settings type.</param>

    var ret = null;

    if (type && type.length) {
        for (var i = 0; i < this._settings.length; i++) {
            if (this._settings[i].type.toLowerCase() == type.toLowerCase()) {
                ret = this._settings[i];
                break;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.MarketingConfiguration.prototype.openSettings = function (type, params) {
    /// <summary>Opens the settings dialog.</summary>
    /// <param name="type">Settings type.</param>
    /// <param name="params">Additional parameters.</param>
    
    var url = '';
    var queryParams = [];
    var settings = this.getSettings(type);

    params = params || {};

    if (settings) {
        url = settings.baseUrl || '';

        if (params.baseUrl) {
            url = params.baseUrl;
        }

        if (params.data) {
            for (var prop in params.data) {
                if (typeof (params.data[prop]) != 'function') {
                    queryParams[queryParams.length] = prop + '=' + encodeURIComponent(params.data[prop]);
                }
            }

            if (queryParams.length) {
                if (url.indexOf('?') < 0) {
                    url += '?';
                }

                for (var i = 0; i < queryParams.length; i++) {
                    url += queryParams[i];
                    if (i < (queryParams.length - 1)) {
                        url += '&';
                    }
                }
            }
        }

        dialog.show(this.dialogId, url);
        if(settings && settings.title && settings.title != ''){
            dialog.setTitle(this.dialogId, settings.title);
        }        
    }
}

Dynamicweb.Controls.OMC.MarketingConfiguration.prototype.initialize = function () {
    /// <summary>Initializes the object.</summary>

    if (!this._initialized) {
        this._initialized = true;
    }
}