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

Dynamicweb.Controls.OMC.EmailNotificationEditor = function () {
    /// <summary>Represents an email notifications editor (details view).</summary>

    this._container = null;
    this._initialized = false;
    this._profileDropDown = null;
    this._recipientsList = null;
    this._isEnabled = true;

    this._cache = {};
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.get_container = function () {
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

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.set_container = function (value) {
    /// <summary>Sets the reference to DOM element that contains all the UI.</summary>
    /// <param name="value">The reference to DOM element that contains all the UI.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.get_isEnabled = function () {
    /// <summary>Gets value indicating whether control is enabled.</summary>

    return this._isEnabled;
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.set_isEnabled = function (value) {
    /// <summary>Sets value indicating whether control is enabled.</summary>
    /// <param name="value">Value indicating whether control is enabled.</param>

    this._isEnabled = !!value;

    this._cache.nameElement.disabled = !this._isEnabled;

    this.get_recipientsList().set_isEnabled(this._isEnabled);
    this.get_profileDropDown().set_isEnabled(this._isEnabled);
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.get_profileDropDown = function () {
    /// <summary>Gets the reference to "Profile" drop-down list control.</summary>
    
    var ret = null;

    if (this._profileDropDown) {
        if (typeof (this._profileDropDown) == 'string') {
            try {
                ret = eval(this._profileDropDown);
            } catch (ex) { }

            if (ret) {
                this._profileDropDown = ret;
            }
        } else {
            ret = this._profileDropDown;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.set_profileDropDown = function (value) {
    /// <summary>Sets the reference to "Profile" drop-down list control.</summary>
    /// <param name="value">The reference to "Profile" drop-down list control.</param>

    this._profileDropDown = value;
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.get_recipientsList = function () {
    /// <summary>Gets the reference to "Recipients" list control.</summary>

    var ret = null;

    if (this._recipientsList) {
        if (typeof (this._recipientsList) == 'string') {
            try {
                ret = eval(this._recipientsList);
            } catch (ex) { }

            if (ret) {
                this._recipientsList = ret;
            }
        } else {
            ret = this._recipientsList;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.set_recipientsList = function (value) {
    /// <summary>Sets the reference to "Recipients" list control.</summary>
    /// <param name="value">The reference to "Recipients" list control.</param>

    this._recipientsList = value;
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.add_ready = function (callback) {
    /// <summary>Adds a callback that is executed when the control is ready.</summary>
    /// <param name="callback">a callback that is executed when the control is ready.</param>

    callback = callback || function () { }

    $(document).observe('dom:loaded', function () { { callback(this, {}); } });
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.save = function () {
    /// <summary>Submits changes without validating them.</summary>

    if (typeof (__doPostBack) == 'function') {
        __doPostBack(this._cache.okButton.name, '');
    } else {
        this._cache.okButton.click();
    }
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.cancel = function () {
    /// <summary>Discards changes.</summary>

    if (typeof (__doPostBack) == 'function') {
        __doPostBack(this._cache.cancelButton.name, '');
    } else {
        this._cache.cancelButton.click();
    }
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.validate = function (params, onComplete) {
    /// <summary>Validates the input parameters and notifies about the validation result through the callback.</summary>
    /// <param name="params">Validation parameters.</param>
    /// <param name="onComplete">Callback that is fired when the validation results become available.</param>
    var recipients = [];
    var validated = null;
    var requestParams = {};
    var selectedItem = null;
    var validationResult = { isValid: false, errors: [] };
    var emailPattern = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

    params = params || {};
    onComplete = onComplete || function () { }

    validated = function (result) {
        onComplete(result);
    }

    if (!this._cache.nameElement.value.length) {
        validationResult.errors[validationResult.errors.length] = { field: 'name', reason: 'empty' };
    }

    if (params.forceProfileSelection) {
        selectedItem = this.get_profileDropDown().get_selectedItem();
        if (!selectedItem || !$(selectedItem).previous()) {
            validationResult.errors[validationResult.errors.length] = { field: 'profile', reason: 'empty' };
        }
    }

    recipients = this.get_recipientsList().get_values();

    if (!recipients.length) {
        validationResult.errors[validationResult.errors.length] = { field: 'recipients', reason: 'empty' };
    } else if (!params.skipInvalidRecipients) {
        for (var i = 0; i < recipients.length; i++) {
            if (!recipients[i].match(emailPattern)) {
                validationResult.errors[validationResult.errors.length] = { field: 'recipients', reason: 'invalid' };
                break;
            }
        }
    }

    if (validationResult.errors.length) {
        validated(validationResult);
    } else {
        validationResult.isValid = true;
        validated(validationResult);        
    }
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype.initialize = function () {
    /// <summary>Initializes the object instance.</summary>

    if (!this._initialized) {
        this._initializeCache();

        this._initialized = true;
    }
}

Dynamicweb.Controls.OMC.EmailNotificationEditor.prototype._initializeCache = function () {
    /// <summary>Initializes the cache.</summary>
    /// <private />

    this._cache = {};
    
    if (this.get_container()) {
        this._cache.idElement = $(this.get_container().select('span.omc-notifications-edit-prop-id input')[0]);
        this._cache.nameElement = $(this.get_container().select('input.omc-notifications-edit-prop-name')[0]);
        this._cache.okButton = $(this.get_container().select('.omc-notifications-edit-save-activator')[0]);
        this._cache.cancelButton = $(this.get_container().select('.omc-notifications-edit-cancel-activator')[0]);
    }
}

Dynamicweb.Controls.OMC.EmailNotificationEditor._listDataExchange = function (sender, args) {
    /// <summary>Occurs when the data between currently selected list item and the box template needs to be exchanged.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event argument.</param>
    /// <private />

    var f = null;

    if (args.dataSource && args.dataDestination) {
        f = typeof (args.dataSource.innerText) != 'undefined' ? args.dataSource.innerText : args.dataSource.textContent;
        args.dataDestination.innerHTML = '<span class="omc-notifications-edit-list-item">' + f + '</span>';
    }
}

Dynamicweb.Controls.OMC.EmailNotificationSelector = function () {
    /// <summary>Represents an email notifications selector (details view).</summary>

    this._container = null;
    this._initialized = false;
    this._notificationDropDown = null;
    this._isEnabled;
}

Dynamicweb.Controls.OMC.EmailNotificationSelector.prototype.get_isEnabled = function () {
    /// <summary>Gets value indicating whether control is enabled.</summary>

    return this._isEnabled;
}

Dynamicweb.Controls.OMC.EmailNotificationSelector.prototype.set_isEnabled = function (value) {
    /// <summary>Sets value indicating whether control is enabled.</summary>
    /// <param name="value">Value indicating whether control is enabled.</param>

    this._isEnabled = !!value;
    this.get_notificationDropDown().set_isEnabled(this._isEnabled);
}

Dynamicweb.Controls.OMC.EmailNotificationSelector.prototype.get_container = function () {
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

Dynamicweb.Controls.OMC.EmailNotificationSelector.prototype.set_container = function (value) {
    /// <summary>Sets the reference to DOM element that contains all the UI.</summary>
    /// <param name="value">The reference to DOM element that contains all the UI.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.EmailNotificationSelector.prototype.get_notificationDropDown = function () {
    /// <summary>Gets the reference to "Notification" drop-down list control.</summary>

    var ret = null;

    if (this._notificationDropDown) {
        if (typeof (this._notificationDropDown) == 'string') {
            try {
                ret = eval(this._notificationDropDown);
            } catch (ex) { }

            if (ret) {
                this._notificationDropDown = ret;
            }
        } else {
            ret = this._notificationDropDown;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.EmailNotificationSelector.prototype.set_notificationDropDown = function (value) {
    /// <summary>Sets the reference to "Notification" drop-down list control.</summary>
    /// <param name="value">The reference to "Notification" drop-down list control.</param>

    this._notificationDropDown = value;
}

Dynamicweb.Controls.OMC.EmailNotificationSelector.prototype.add_ready = function (callback) {
    /// <summary>Adds a callback that is executed when the control is ready.</summary>
    /// <param name="callback">a callback that is executed when the control is ready.</param>

    callback = callback || function () { }

    $(document).observe('dom:loaded', function () { { callback(this, {}); } });
}

Dynamicweb.Controls.OMC.EmailNotificationSelector.prototype.initialize = function () {
    /// <summary>Initializes the object instance.</summary>

    if (!this._initialized) {
        this._initialized = true;
    }
}

Dynamicweb.Controls.OMC.EmailNotificationSelector.prototype.validate = function (params, onComplete) {
    /// <summary>Validates the input parameters and notifies about the validation result through the callback.</summary>
    /// <param name="params">Validation parameters.</param>
    /// <param name="onComplete">Callback that is fired when the validation results become available.</param>

    var validated = null;
    var selectedItem = null;
    var validationResult = { isValid: false, errors: [] };

    params = params || {};
    onComplete = onComplete || function () { }

    validated = function (result) {
        onComplete(result);
    }
    
    if (params.forceNotificationSelection) {
        selectedItem = this.get_notificationDropDown().get_selectedItem();
        if (!selectedItem || !$(selectedItem).previous()) {
            validationResult.errors[validationResult.errors.length] = { field: 'notification', reason: 'empty' };
        } else {
            validationResult.isValid = true;
        }
    } else {
        validationResult.isValid = true;
    }

    validated(validationResult);
}

Dynamicweb.Controls.OMC.EmailNotificationList = function () {
    /// <summary>Represents an email notifications list.</summary>

    this._cache = {};
    this._terminology = {};
    this._container = null;
    this._initialized = false;
}

Dynamicweb.Controls.OMC.EmailNotificationList.prototype.get_container = function () {
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

Dynamicweb.Controls.OMC.EmailNotificationList.prototype.set_container = function (value) {
    /// <summary>Sets the reference to DOM element that contains all the UI.</summary>
    /// <param name="value">The reference to DOM element that contains all the UI.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.EmailNotificationList.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return this._terminology;
}

Dynamicweb.Controls.OMC.EmailNotificationList.prototype.add_ready = function (callback) {
    /// <summary>Adds a callback that is executed when the control is ready.</summary>
    /// <param name="callback">a callback that is executed when the control is ready.</param>

    callback = callback || function () { }

    $(document).observe('dom:loaded', function () { { callback(this, {}); } });
}

Dynamicweb.Controls.OMC.EmailNotificationList.prototype.editRow = function (id) {
    /// <summary>Executes the "Edit" action on a given row.</summary>
    /// <param name="id">Row id.</param>

    this._executeAction('Edit', id);
}

Dynamicweb.Controls.OMC.EmailNotificationList.prototype.deleteRow = function (id) {
    /// <summary>Executes the "Delete" action on a given row.</summary>
    /// <param name="id">Row id.</param>

    this._executeAction('Delete', id);

    return true;
}

Dynamicweb.Controls.OMC.EmailNotificationList.prototype.deleteRowConfirm = function (id) {
    /// <summary>Executes the "Delete" action on a given row with asking the user first if he wants to execute the action.</summary>
    /// <param name="id">Row id.</param>

    var ret = false;
    var msg = this.get_terminology()['DeleteConfirm'];

    if (typeof (ContextMenu) != 'undefined') {
        ContextMenu.hide();
    }

    ret = confirm(msg);

    if (ret) {
        this._executeAction('Delete', id);
    }

    return ret;
}

Dynamicweb.Controls.OMC.EmailNotificationList.prototype.initialize = function () {
    /// <summary>Initializes the object instance.</summary>

    var self = this;

    if (!this._initialized) {
        this._initializeCache();

        if (this.get_container()) {
            this.get_container().select('img.omc-notifications-list-delete').each(function (elm) {
                Event.observe(elm, 'click', function (e) {
                    self.deleteRowConfirm($(Event.element(e)).readAttribute('data-id'));
                    Event.stop(e);
                });
            });
        }

        this._initialized = true;
    }
}

Dynamicweb.Controls.OMC.EmailNotificationList.prototype._executeAction = function (actionType, actionArgument) {
    /// <summary>Performs the postback with the given action parameters.</summary>
    /// <param name="actionType">Action type.</param>
    /// <param name="actionArgument">Action argument.</param>
    /// <private />

    this._cache.actionType.value = actionType;
    this._cache.actionArgument.value = actionArgument;

    if (typeof (__doPostBack) == 'function') {
        __doPostBack(this._cache.actionActivator.name, '');
    } else {
        this._cache.actionActivator.click();
    }
}

Dynamicweb.Controls.OMC.EmailNotificationList.prototype._initializeCache = function () {
    /// <summary>Initializes object cache.</summary>
    /// <private />

    this._cache = {};

    if (this.get_container()) {
        this._cache.actionType = $(this.get_container().select('input.omc-notifications-list-action')[0]);
        this._cache.actionArgument = $(this.get_container().select('input.omc-notifications-list-argument')[0]);
        this._cache.actionActivator = $(this.get_container().select('input.omc-notifications-list-action-activator')[0]);
    }
}

OMC.ReturningVisitorNotificationManager = function () {
    /// <summary>Represents a notification manager for "Returning visitors" notifications.</summary>

    this._selector = null;
    this._editor = null;
    this._initialized = false;
    this._terminology = {};
    this._cache = {};
    this._dialog = null;
    this._lastError = null;
    this._isReady = false;
}

OMC.ReturningVisitorNotificationManager._instance = null;

OMC.ReturningVisitorNotificationManager.get_current = function () {
    /// <summary>Gets the current instance of the manager.</summary>

    if (!OMC.ReturningVisitorNotificationManager._instance) {
        OMC.ReturningVisitorNotificationManager._instance = new OMC.ReturningVisitorNotificationManager();
    }

    return OMC.ReturningVisitorNotificationManager._instance;
}

OMC.ReturningVisitorNotificationManager.prototype.get_choice = function () {
    /// <summary>Gets the current action type.</summary>

    var ret = '';

    if (this._cache.actionType && this._cache.actionType.value && this._cache.actionType.value.length) {
        ret = this._cache.actionType.value.toLowerCase();
    }

    return ret;
}

OMC.ReturningVisitorNotificationManager.prototype.get_isReady = function () {
    /// <summary>Gets value indicating whether control is ready to perform actions.</summary>

    return this._isReady;
}

OMC.ReturningVisitorNotificationManager.prototype.get_visitors = function () {
    /// <summary>Gets the array of target visitor IDs.</summary>

    var ret = [];

    if (this._cache.actionVisitors && this._cache.actionVisitors.value && this._cache.actionVisitors.value.length) {
        ret = this._cache.actionVisitors.value.split(',');
    }

    return ret;
}

OMC.ReturningVisitorNotificationManager.prototype.set_visitors = function (value) {
    /// <summary>Sets the array of target visitor IDs.</summary>
    /// <param name="value">The array of target visitor IDs.</param>

    var val = '';

    if (this._cache.actionVisitors) {
        if (value) {
            if (typeof (value) == 'string') {
                val = value;
            } else if (value.length) {
                for (var i = 0; i < value.length; i++) {
                    val += value[i];
                    if (i < (value.length - 1)) {
                        val += ',';
                    }
                }
            }
        }

        this._cache.actionVisitors.value = val;

        if (this.get_dialog()) {
            var okBtn = parent.dialog.get_okButton(this.get_dialog());
            if (okBtn) {
                okBtn.disabled = !val || !val.length;
            }
        }
    }
}

OMC.ReturningVisitorNotificationManager.prototype.get_lastError = function () {
    /// <summary>Gets the string that explains the last error.</summary>

    var key = '';
    var ret = '';

    if (this._lastError) {
        if (typeof (this._lastError) == 'string') {
            ret = this._lastError;
        } else {
            key = this._lastError.field + '_' + this._lastError.reason;
            ret = this.get_terminology()[key];

            if (ret == null) {
                ret = '';
            }
        }
    }

    return ret;
}

OMC.ReturningVisitorNotificationManager.prototype.get_dialog = function () {
    /// <summary>Gets the reference to dialog element that hosts the form.</summary>

    if (!this._dialog) {
        if (parent) {
            var frame = window.frameElement;
            var container = $(frame).up('div.sidebox');
            this._dialog = container;
        }
    }

    return this._dialog;
}

OMC.ReturningVisitorNotificationManager.prototype.set_dialog = function (value) {
    /// <summary>Sets the reference to dialog element  that hosts the form.</summary>

    var self = this;

    this._dialog = value;

    if (this._dialog) {
        parent.dialog.set_okButtonOnclick(value, function () {
            if (self._cache.choiceAttach || self._cache.choiceCreate || self._cache.recipientsEdit) {
                self.validate(function (isValid) {
                    if (isValid) {
                        self.save();
                    } else {
                        alert(self.get_lastError());
                    }
                });
            }
        });
    }
}

OMC.ReturningVisitorNotificationManager.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return this._terminology;
}

OMC.ReturningVisitorNotificationManager.prototype.get_selector = function () {
    /// <summary>Gets the notification selector control.</summary>

    var ret = null;

    if (this._selector) {
        if (typeof (this._selector) == 'string') {
            try {
                ret = eval(this._selector);
            } catch (ex) { }

            if (ret) {
                this._selector = ret;
            }
        } else {
            ret = this._selector;
        }
    }

    return ret;
}

OMC.ReturningVisitorNotificationManager.prototype.set_selector = function (value) {
    /// <summary>Sets the notification selector control.</summary>
    /// <param name="value">Notification selector control.</param>

    this._selector = value;
}

OMC.ReturningVisitorNotificationManager.prototype.get_editor = function () {
    /// <summary>Gets the notification editor control.</summary>

    var ret = null;

    if (this._editor) {
        if (typeof (this._editor) == 'string') {
            try {
                ret = eval(this._editor);
            } catch (ex) { }

            if (ret) {
                this._editor = ret;
            }
        } else {
            ret = this._editor;
        }
    }

    return ret;
}

OMC.ReturningVisitorNotificationManager.prototype.set_editor = function (value) {
    /// <summary>Sets the notification editor control.</summary>
    /// <param name="value">Notification editor control.</param>

    this._editor = value;
}

OMC.ReturningVisitorNotificationManager.prototype.add_ready = function (callback) {
    /// <summary>Adds a callback that is executed when the control is ready.</summary>
    /// <param name="callback">a callback that is executed when the control is ready.</param>

    callback = callback || function () { }

    if (this.get_isReady()) {
        callback(this, {});
    } else {
        $(document).observe('dom:loaded', function () { { callback(this, {}); } });
    }
}

OMC.ReturningVisitorNotificationManager.prototype.openControlPanel = function () {
    // <summary>Navigates to control panel.</summary>

    var frame = null;
    var w = window.top;
    var url = '/Admin/Module/OMC/OMC_Cpl.aspx';

    if (w.frames && w.frames.length) {
        for (var i = 0; i < w.frames.length; i++) {
            if (w.frames[i].name && w.frames[i].name.toLowerCase() == 'right') {
                frame = w.frames[i];
                break;
            }
        }
    } else {
        frame = w;
    }

    if (frame && confirm(this.get_terminology()['control_panel_confirm'])) {
        frame.location.href = url;
    }
}

OMC.ReturningVisitorNotificationManager.prototype.validate = function (onComplete) {
    /// <summary>Validates the input.</summary>
    /// <param name="onComplete">Function that is called when the validation result becomes available.</param>

    var self = this;

    onComplete = onComplete || function () { }
    if (this.get_choice() == 'attach') {
        this.get_selector().validate({ forceNotificationSelection: true }, function (results) {
            if (!results.isValid) {
                self._lastError = results.errors[0];
            }

            onComplete(results.isValid);
        });
    } else {
        this.get_editor().validate({ forceProfileSelection: true, skipInvalidRecipients: false }, function (results) {
            if (!results.isValid) {
                self._lastError = results.errors[0];
            }

            onComplete(results.isValid);
        });
    }
}

OMC.ReturningVisitorNotificationManager.prototype.save = function () {
    /// <summary>Saves user input.</summary>

    this._postBack();
}

OMC.ReturningVisitorNotificationManager.prototype.initialize = function (initializeHostingWindow) {
    /// <summary>Initializes the object.</summary>
    /// <param name="initializeHostingWindow">Indicates whether to try to automatically assign hosting window.</param>

    var w = null;
    var self = this;
    var hasContent = true;

    if (!this._initialized) {
        hasContent = !$(document.body).select('.omc-notifications-empty').length;

        if (this.get_dialog()) {
            var okBtn = parent.dialog.get_okButton(this.get_dialog());
            if (okBtn) {
                okBtn.disabled = !hasContent;
            }
        }

        if (hasContent) {
            this._initializeCache();

            if (this._cache.choiceAttach) {
                Event.observe(this._cache.choiceAttach, 'click', function (e) { self.choose('attach'); });
            }

            if (this._cache.choiceCreate) {
                Event.observe(this._cache.choiceCreate, 'click', function (e) { self.choose('create'); });
            }

            if (this._cache.choiceAttach) {
                setTimeout(function () {
                    if (self.get_selector().get_notificationDropDown().get_allItems().length <= 1) {
                        self.choose('create');
                        self._cache.choiceAttach.disabled = true;
                        self._cache.choiceAttachContainer.addClassName('omc-notifications-attach-disabled');
                    } else if (self.get_selector().get_notificationDropDown().get_allItems().length == self.get_editor().get_profileDropDown().get_allItems().length) {
                        self.choose('attach');
                        //always enable creating new notifications
                        //self._cache.choiceCreate.disabled = true;
                        //self._cache.choiceCreateContainer.addClassName('omc-notifications-attach-disabled');
                    } else {
                        self.choose('attach');
                    }
                }, 100);
            }

            $(document.body).select('img.omc-notifications-visitors-delete').each(function (elm) {
                Event.observe(elm, 'click', function (e) {
                    var visitorID = $(Event.element(e)).readAttribute('data-id');

                    if (confirm(self.get_terminology()['exclude_visitor'])) {
                        self._cache.actionType.value = 'Exclude';
                        self._cache.actionVisitors.value = visitorID;

                        self._postBack();
                    }

                    Event.stop(e);
                });
            });
        }

        self._isReady = true;
        self._initialized = true;

        if (initializeHostingWindow) {
            if (parent) {
                var frame = window.frameElement;
                var container = $(frame).up('div.sidebox');
                this.set_dialog(container);
            }
        }
    }
}

OMC.ReturningVisitorNotificationManager.prototype.choose = function (type) {
    /// <summary>Switches user's choice to specified one.</summary>
    /// <param name="type">User's choice.</param>

    this._cache.actionType.value = type;

    if (type == 'attach' && !this._cache.choiceAttach.disabled) {
        this._cache.choiceAttach.checked = true;
        this._cache.choiceCreate.checked = false;

        this.get_selector().set_isEnabled(true);
        this.get_editor().set_isEnabled(false);

        this._cache.choiceAttachContent.removeClassName('omc-notifications-attach-disabled');
        this._cache.choiceCreateContent.addClassName('omc-notifications-attach-disabled');
    } else if (type == 'create' && !this._cache.choiceCreate.disabled) {
        this._cache.choiceAttach.checked = false;
        this._cache.choiceCreate.checked = true;

        this.get_selector().set_isEnabled(false);
        this.get_editor().set_isEnabled(true);

        this._cache.choiceAttachContent.addClassName('omc-notifications-attach-disabled');
        this._cache.choiceCreateContent.removeClassName('omc-notifications-attach-disabled');
    }
}

OMC.ReturningVisitorNotificationManager.prototype._postBack = function () {
    /// <summary>Performs a postback.</summary>
    /// <private />

    if (typeof (__doPostBack) == 'function') {
        __doPostBack(this._cache.postBackActivator.name, '');
    } else {
        this._cache.postBackActivator.click();
    }
}

OMC.ReturningVisitorNotificationManager.prototype._initializeCache = function () {
    /// <summary>Initializes object cache.</summary>
    /// <private />

    var container = $(document.body);

    this._cache = {};

    this._cache.choiceAttachContainer = $(container.select('fieldset.omc-notifications-attach-choice-attach')[0]);
    this._cache.choiceCreateContainer = $(container.select('fieldset.omc-notifications-attach-choice-create')[0]);
    this._cache.choiceAttach = $(container.select('fieldset.omc-notifications-attach-choice-attach input')[0]);
    this._cache.choiceCreate = $(container.select('fieldset.omc-notifications-attach-choice-create input')[0]);
    this._cache.choiceAttachContent = $(container.select('fieldset.omc-notifications-attach-choice-attach div.omc-notifications-attach-choice-content')[0]);
    this._cache.choiceCreateContent = $(container.select('fieldset.omc-notifications-attach-choice-create div.omc-notifications-attach-choice-content')[0]);

    this._cache.recipientsEdit = $(container.select('div.omc-notifications-edit-visitors div.omc-notifications-attach-choice-content')[0]);

    this._cache.actionType = $(container.select('input.omc-notifications-attach-actiontype')[0]);
    this._cache.actionVisitors = $(container.select('input.omc-notifications-attach-actionvisitors')[0]);
    this._cache.postBackActivator = $(container.select('input.omc-notifications-attach-postback')[0]);
}