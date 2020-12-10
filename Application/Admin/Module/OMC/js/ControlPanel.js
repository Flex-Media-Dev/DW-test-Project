/* ++++++ Registering namespace ++++++ */

if (typeof (OMC) == 'undefined') {
    var OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

OMC.ControlPanel = function () {
    /// <summary>Represents a control panel controller.</summary>

    this._originalOnSave = null;
    this._usernameField = '';
    this._passwordField = '';
    this._accountSelector = null;
    this._accountField = null;
    this._accountDiscovery = null;
    this._pleaseWaitMessage = '';
    this._originalButtonText = '';
    this._originalAccountSelectorState = false;
}

OMC.ControlPanel._instance = null;

OMC.ControlPanel.getInstance = function () {
    /// <summary>Gets the current instance of the control panel controller.</summary>
    /// <returns>The current instnace of the control panel controller.</returns>

    if (OMC.ControlPanel._instance == null) {
        OMC.ControlPanel._instance = new OMC.ControlPanel();
    }

    return OMC.ControlPanel._instance;
}

OMC.ControlPanel.prototype.get_accountSelector = function () {
    /// <summary>Gets the ID of the account selector (drop-down list).</summary>

    return this._accountSelector;
}

OMC.ControlPanel.prototype.set_accountSelector = function (value) {
    /// <summary>Sets the ID of the account selector (drop-down list).</summary>
    /// <param name="value">The ID of the account selector (drop-down list).</param>

    this._accountSelector = value;
}

OMC.ControlPanel.prototype.get_pleaseWaitMessage = function () {
    /// <summary>Gets the "Please wait" message.</summary>

    return this._pleaseWaitMessage;
}

OMC.ControlPanel.prototype.set_pleaseWaitMessage = function (value) {
    /// <summary>Sets the "Please wait" message.</summary>
    /// <param name="value">The "Please wait" message.</param>

    this._pleaseWaitMessage = value;
}

OMC.ControlPanel.prototype.get_usernameField = function () {
    /// <summary>Gets the ID of the username field.</summary>

    return this._usernameField;
}

OMC.ControlPanel.prototype.set_usernameField = function (value) {
    /// <summary>Sets the ID of the username field.</summary>
    /// <param name="value">The ID of the username field.</param>

    this._usernameField = value;
}

OMC.ControlPanel.prototype.get_passwordField = function () {
    /// <summary>Gets the ID of the password field.</summary>

    return this._passwordField;
}

OMC.ControlPanel.prototype.set_passwordField = function (value) {
    /// <summary>Sets the ID of the password field.</summary>
    /// <param name="value">The ID of the password field.</param>

    this._passwordField = value;
}

OMC.ControlPanel.prototype.get_accountField = function () {
    /// <summary>Gets the ID of the account field (hidden field).</summary>

    return this._accountField;
}

OMC.ControlPanel.prototype.set_accountField = function (value) {
    /// <summary>Sets the ID of the account field (hidden field).</summary>
    /// <param name="value">The ID of the account field (hidden field).</param>

    this._accountField = value;
}

OMC.ControlPanel.prototype.get_accountDiscovery = function () {
    /// <summary>Gets the ID of the account discovery activator (button).</summary>

    return this._accountDiscovery;
}

OMC.ControlPanel.prototype.set_accountDiscovery = function (value) {
    /// <summary>Sets the ID of the account discovery activator (button).</summary>
    /// <param name="value">The ID of the account field (hidden field).</param>

    this._accountDiscovery = value;
}

OMC.ControlPanel.prototype.get_isLoadingAccounts = function () {
    /// <summary>Gets value indicating whether the form is in a state of loading a list of Google Analytics accounts.</summary>

    return document.getElementById(this.get_accountDiscovery()).disabled;
}

OMC.ControlPanel.prototype.set_isLoadingAccounts = function (value) {
    /// <summary>Sets value indicating whether the form is in a state of loading a list of Google Analytics accounts.</summary>
    /// <param name="value">Value indicating whether the form is in a state of loading a list of Google Analytics accounts.</param>

    value = !!value;
    var cmd = document.getElementById(this.get_accountDiscovery());
    var selector = document.getElementById(this.get_accountSelector());

    if ((value && !this.get_isLoadingAccounts()) || (!value && this.get_isLoadingAccounts())) {
        document.getElementById(this.get_usernameField()).disabled = value;
        document.getElementById(this.get_passwordField()).disabled = value;

        cmd.disabled = value;

        if (value) {
            this._originalButtonText = cmd.value;
            cmd.value = this.get_pleaseWaitMessage();

            this._originalAccountSelectorState = selector.disabled;
            selector.disabled = true;
        } else {
            cmd.value = this._originalButtonText;
            this._originalButtonText = '';

            selector.disabled = this._originalAccountSelectorState;
        }
    }
}

OMC.ControlPanel.prototype.initialize = function () {
    /// <summary>Initializes the object.</summary>

    var self = this;
    var selector = null;
    var settingsPage = null;
    var accountField = null;

    if (this.get_accountField()) {
        selector = document.getElementById(this.get_accountSelector());
        accountField = document.getElementById(this.get_accountField().id);

        if (selector) {
            selector.disabled = true;
        }

        Event.observe(document.getElementById(this.get_usernameField()), 'keyup', function (e) { self.updateDiscoveryButtonState(); });
        Event.observe(document.getElementById(this.get_passwordField()), 'keyup', function (e) { self.updateDiscoveryButtonState(); });
        Event.observe(document.getElementById(this.get_usernameField()), 'blur', function (e) { self.updateDiscoveryButtonState(); });
        Event.observe(document.getElementById(this.get_passwordField()), 'blur', function (e) { self.updateDiscoveryButtonState(); });
        Event.observe(selector, 'change', function (e) { self.updateSelectedAccount(); });

        Event.observe(document.getElementById(this.get_accountDiscovery()), 'click', function (e) {
            var opt = null;
            var group = null;
            var cmd = Event.element(e);
            var selector = document.getElementById(self.get_accountSelector());

            Event.stop(e);

            if (!cmd.disabled) {
                self.set_isLoadingAccounts(true);

                self.loadAccounts(function (accounts) {
                    self.set_isLoadingAccounts(false);

                    selector.disabled = false;

                    if (accounts && accounts.length > 0) {
                        while (selector.firstChild) {
                            selector.removeChild(selector.firstChild);
                        }

                        for (var i = 0; i < accounts.length; i++) {
                            if (accounts[i].profiles && accounts[i].profiles.length) {
                                group = document.createElement('optgroup');

                                group.label = accounts[i].name;

                                for (var j = 0; j < accounts[i].profiles.length; j++) {
                                    opt = document.createElement('option');

                                    opt.text = accounts[i].profiles[j].title;
                                    opt.value = accounts[i].profiles[j].tableID;
                                    opt.innerHTML = accounts[i].profiles[j].title;

                                    group.appendChild(opt);
                                }

                                selector.appendChild(group);
                            }
                        }

                        if (accountField.value && accountField.value.length) {
                            for (var i = 0; i < selector.options.length; i++) {
                                if (accountField.value.toLowerCase() == selector.options[i].value.toLowerCase()) {
                                    selector.selectedIndex = i;
                                    break;
                                }
                            }
                        }

                        self.updateSelectedAccount();
                    }
                });
            }
        });

        this.updateDiscoveryButtonState();
    }

    if (typeof (SettingsPage) != 'undefined') {
        settingsPage = SettingsPage.getInstance();

        if (settingsPage) {
            this._originalOnSave = settingsPage.onSave;
            settingsPage.onSave = function () {
                OMC.ControlPanel.getInstance().save(function () {
                    if (OMC.ControlPanel.getInstance()._originalOnSave) {
                        OMC.ControlPanel.getInstance()._originalOnSave();
                    }
                });
            }
        }
    }
}

OMC.ControlPanel.prototype.save = function (onComplete) {
    /// <summary>Saves the control panel settings.</summary>
    /// <param name="onComplete">A callback that is fired upon the completion.</param>

    var p = null;
    var markForDeletion = [];
    var indicator = document.getElementById('SaveEmailProfiles');

    onComplete = onComplete || function () { }

    if (indicator) {
        indicator.value = 'True';
    }

    Dynamicweb.Ajax.doPostBack({
        filters: {
            field: function (f) {
                var result = !!$(f).up('div.omc-control-panel-serverform-container');

                if (result) {
                    markForDeletion[markForDeletion.length] = f;
                }

                return result;
            }
        },
        onComplete: function () {
            if (markForDeletion && markForDeletion.length) {
                for (var i = 0; i < markForDeletion.length; i++) {
                    if (markForDeletion[i]) {
                        p = markForDeletion[i].parentNode || markForDeletion[i].parentElement;
                        if (p) {
                            p.removeChild(markForDeletion[i]);
                            markForDeletion[i] = null;
                        }
                    }
                }
            }

            $$('.omc-control-panel-conditional-hide').each(function (elm) {
                $(elm).hide();
            });

            markForDeletion = null;

            onComplete();
        }
    });
}

OMC.ControlPanel.prototype.onEngagementEnabledChanged = function (isEnabled) {
    /// <summary>Occurs when the "Enabled" state of the engagement index calculation feature has changed.</summary>
    /// <param name="isEnabled">Value indicating whether engagement index calculation is enabled.</param>

    var chkCalculateOnPageLoad = document.getElementById('chkSynchronousCall');

    if (chkCalculateOnPageLoad) {
        chkCalculateOnPageLoad.disabled = !isEnabled;
    }
}

OMC.ControlPanel.prototype.updateDiscoveryButtonState = function () {
    /// <summary>Updates the "disabled" state of the "Browse..." button.</summary>

    var cmd = document.getElementById(this.get_accountDiscovery());
    var txUsername = document.getElementById(this.get_usernameField());
    var txPassword = document.getElementById(this.get_passwordField());

    cmd.disabled = !txUsername.value || !txUsername.value.length || !txPassword.value || !txPassword.value.length;
}

OMC.ControlPanel.prototype.updateSelectedAccount = function () {
    /// <summary>Updates selected account hidden field.</summary>

    var selector = document.getElementById(this.get_accountSelector());
    var accountIDField = document.getElementById(this.get_accountField().id);
    var accountTitleField = document.getElementById(this.get_accountField().title);

    if (!selector.disabled && selector.selectedIndex >= 0 && selector.selectedIndex < selector.options.length) {
        accountIDField.value = selector.options[selector.selectedIndex].value;
        accountTitleField.value = selector.options[selector.selectedIndex].text;
    }
}

OMC.ControlPanel.prototype.loadAccounts = function (onComplete) {
    /// <summary>Updates the "disabled" state of the "Browse..." button.</summary>

    var url = '/Admin/Module/OMC/Management/Reports.aspx?GetAccounts=True';

    onComplete = onComplete || function () { }

    url += '&Username=' + encodeURIComponent(document.getElementById(this.get_usernameField()).value);
    url += '&Password=' + encodeURIComponent(document.getElementById(this.get_passwordField()).value);

    new Ajax.Request(url, {
        onSuccess: function (transport) {
            var data = null;
            
            try {
                data = eval('(' + transport.responseText + ')');
            } catch (ex) { }

            if (data && data.accounts) {
                onComplete(data.accounts);
            } else {
                onComplete([]);
            }
        },

        onFailure: function (transport) {
            onComplete([]);
        }
    });
}




