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

Dynamicweb.Controls.OMC.ValidationList = function () {
    /// <summary>Represents a list of visits.</summary>

    this._list = '';
    this._container = '';
    this._isReady = false;
    this._initialized = false;
    this._terminology = {};
    this._locationData = {};
    this._knownCompanies = [];
    this._excludeKnownCompanies = false;
    this._uniqueID = '';
}

Dynamicweb.Controls.OMC.ValidationList.prototype.initialize = function () {
    /// <summary>Initializes the instance.</summary>

    if (!this._initialized) {
        this._initialized = true;
    }
}

Dynamicweb.Controls.OMC.ValidationList.prototype.updateProgress = function (onComplete, progressValue, isUserGroupEditMode) {
    /// <summary>Loads additional users/groups that are not displayed by default into the list.</summary>
    /// <param name="params">Method parameters.</param>

    var self = this;
    var callback = onComplete || function () { }

    this._isBusy = true;
    $('lookupForwardMessage').innerText = 'Please wait ... ' + progressValue + '%';

    var url = '/Admin/Module/OMC/Emails/ValidateEmail.aspx?cache=' + new Date().getTime();

    new Ajax.Request(url,
        {
            method: 'get',
            parameters: {
                eventArgument: 'GetStatus:',
                progress: progressValue,
                UserGroupEditMode: isUserGroupEditMode
            },
            onSuccess: function (transport) {
                self._isBusy = false;
                if (transport.responseText.indexOf('complete') == -1) {
                    if (transport.responseText.indexOf('progressValue') != -1) {
                        progressValue = transport.responseText.split('=')[1];
                    }
                    setTimeout(function() {
                        self.updateProgress(null, progressValue, isUserGroupEditMode);
                    }, 3000);
                } else {
                    self.showList(null, true, isUserGroupEditMode);
                    callback([]);
                }
            }
        });
}

Dynamicweb.Controls.OMC.ValidationList.prototype.showList = function (onComplete, isLookupFinished, isUserGroupEditMode) {
    /// <summary>Loads additional users/groups that are not displayed by default into the list.</summary>
    /// <param name="params">Method parameters.</param>

    var self = this;
    var callback = onComplete || function () { }
    var argument = isLookupFinished ? 'ShowList:' : 'Discover:';

    this._isBusy = true;

    Dynamicweb.Ajax.doPostBack({
        eventTarget: self.get_uniqueID(),
        eventArgument: argument,
        onComplete: function (transport) {
            self._isBusy = false;
            if (isLookupFinished) {
                $('lookupForward').hide();
                $('vValidationList_divValidationList').innerHTML = transport.responseText;
            } else {
                var progressValue = 0;
                if (transport.responseText.indexOf('progressValue') != -1) {
                    progressValue = transport.responseText.split('=')[1];
                } else {
                    progressValue = 0;
                }
                self.updateProgress(onComplete, progressValue, isUserGroupEditMode)
                callback([]);
            }
        }
    });
}

Dynamicweb.Controls.OMC.ValidationList.prototype.saveEmail = function (onComplete, recipientId) {
    /// <summary>Loads additional users/groups that are not displayed by default into the list.</summary>
    /// <param name="params">Method parameters.</param>
    var emailAddress = $('emailInput_' + recipientId).value;
    var self = this;
    var callback = onComplete || function () { }

    this._isBusy = true;

    var o = new overlay("lookupForward");
    o.show();

    Dynamicweb.Ajax.doPostBack({
        eventTarget: self.get_uniqueID(),
        eventArgument: 'SaveEmail:' + emailAddress +",ID:"+recipientId,
        onComplete: function (transport) {
            self._isBusy = false;
            o.hide();
            $('vValidationList_divValidationList').innerHTML = transport.responseText;
            callback([]);
        }
    });
}

Dynamicweb.Controls.OMC.ValidationList.prototype.resendEmail = function (onComplete, recipientId) {
    /// <summary>Loads additional users/groups that are not displayed by default into the list.</summary>
    /// <param name="params">Method parameters.</param>
    var emailAddress = $('emailInput_' + recipientId).value;
    var self = this;
    var callback = onComplete || function () { }

    this._isBusy = true;

    var o = new overlay("lookupForward");
    o.show();

    Dynamicweb.Ajax.doPostBack({
        eventTarget: self.get_uniqueID(),
        eventArgument: 'ResendEmail:' + emailAddress + ",ID:" + recipientId,
        onComplete: function (transport) {
            self._isBusy = false;
            o.hide();
            $('vValidationList_divValidationList').innerHTML = transport.responseText;
            callback([]);
        }
    });
}

Dynamicweb.Controls.OMC.ValidationList.prototype.clearEmail = function (onComplete, recipientId) {
    /// <summary>Loads additional users/groups that are not displayed by default into the list.</summary>
    /// <param name="params">Method parameters.</param>
    var self = this;
    var callback = onComplete || function () { }

    this._isBusy = true;

    if(parent.OMC != null)
    {
        var exclEl = parent.OMC.MasterPage.get_current().get_contentWindow().$('RecipientsExcluded')
        var excluded = exclEl.value;

        if(excluded.indexOf(',') != -1 || excluded.length != 0)
            excluded += "," + recipientId;
        else if(excluded.length == 0)
            excluded = recipientId;

        exclEl.value = excluded;
    }

    Dynamicweb.Ajax.doPostBack({
        eventTarget: self.get_uniqueID(),
        eventArgument: 'ClearEmail:' + recipientId,
        onComplete: function (transport) {
            self._isBusy = false;
            $('vValidationList_divValidationList').innerHTML = transport.responseText;
            callback([]);
        }
    });
}

Dynamicweb.Controls.OMC.ValidationList.prototype.removePermission = function (onComplete, recipientId) {
    /// <summary>Loads additional users/groups that are not displayed by default into the list.</summary>
    /// <param name="params">Method parameters.</param>
    var self = this;
    var callback = onComplete || function () { }

    this._isBusy = true;

    if(parent.OMC != null)
    {
        var exclEl = parent.OMC.MasterPage.get_current().get_contentWindow().$('RecipientsExcluded')
        if (exclEl) {
            var excluded = exclEl.value;

            if (excluded.indexOf(',') != -1 || excluded.length != 0)
                excluded += "," + recipientId;
            else if (excluded.length == 0)
                excluded = recipientId;

            exclEl.value = excluded;
        }
    }

    var o = new overlay("lookupForward");
    o.show();
  
    Dynamicweb.Ajax.doPostBack({
        eventTarget: self.get_uniqueID(),
        eventArgument: 'RemovePermission:' + recipientId,
        onComplete: function (transport) {
            self._isBusy = false;
            o.hide();
            $('vValidationList_divValidationList').innerHTML = transport.responseText;
            callback([]);
        }
    });
}

Dynamicweb.Controls.OMC.ValidationList.prototype.removeUser = function (onComplete, recipientId) {
    /// <summary>Loads additional users/groups that are not displayed by default into the list.</summary>
    /// <param name="params">Method parameters.</param>
    var self = this;
    var callback = onComplete || function () { }

    this._isBusy = true;

    if (parent.OMC != null) {
        var exclEl = parent.OMC.MasterPage.get_current().get_contentWindow().$('RecipientsExcluded')
        if (exclEl) {
            var excluded = exclEl.value;

            if (excluded.indexOf(',') != -1 || excluded.length != 0)
                excluded += "," + recipientId;
            else if (excluded.length == 0)
                excluded = recipientId;

            exclEl.value = excluded;
        }
    }

    var o = new overlay("lookupForward");
    o.show();

    Dynamicweb.Ajax.doPostBack({
        eventTarget: self.get_uniqueID(),
        eventArgument: 'RemoveUser:' + recipientId,
        onComplete: function (transport) {
            self._isBusy = false;
            o.hide();
            $('vValidationList_divValidationList').innerHTML = transport.responseText;
            callback([]);
        }
    });
}

Dynamicweb.Controls.OMC.ValidationList.prototype.saveAndClose = function (onComplete) {
    /// <summary>Loads additional users/groups that are not displayed by default into the list.</summary>
    /// <param name="params">Method parameters.</param>

    //parent.hide('ValidationEmailDialog');
    //parent.hide('pwDialog');
}


Dynamicweb.Controls.OMC.ValidationList.prototype.get_uniqueID = function () {
    /// <summary>Gets the unique identifier of this control.</summary>

    return this._uniqueID || '';
}

Dynamicweb.Controls.OMC.ValidationList.prototype.set_uniqueID = function (value) {
    /// <summary>Sets the unique identifier of this control.</summary>
    /// <param name="value">Unique identifier of this control.</param>
    this._uniqueID = value;
}

