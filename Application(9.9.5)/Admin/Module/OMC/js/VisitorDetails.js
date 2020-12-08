/* ++++++ Registering namespace ++++++ */

if (typeof (OMC) == 'undefined') {
    var OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

OMC.Section = {
    /// <summary>Basic information.</summary>
    Basic: 1,

    /// <summary>Location.</summary>
    Location: 2,

    /// <summary>Referrer.</summary>
    Referrer: 3,

    /// <summary>Extranet.</summary>
    Extranet: 4,

    /// <summary>Pages visited.</summary>
    PageVisits: 5,

    /// <summary>Files downloaded.</summary>
    FileDownloads: 6,

    /// <summary>Cart.</summary>
    Cart: 7,

    /// <summary>Visits.</summary>
    Visits: 8,

    /// <summary>Profiles.</summary>
    Profiles: 9,

    /// <summary>Advertising.</summary>
    Advertising: 10,

    /// <summary>Send lead as email.</summary>
    SendEmail: 11,

    /// <summary>About this page.</summary>
    About: 12,

    getName: function (v) {
        /// <summary>Returns the name of a given enumaration value.</summary>
        /// <param name="v">Value.</param>

        var ret = '';

        for (var prop in OMC.Section) {
            if (OMC.Section[prop] == v) {
                ret = prop;
                break;
            }
        }

        return ret;
    }
};

OMC.MasterPage = function () {
    /// <summary>Represents a master page of the "Visitor details" page.</summary>

    this._auth = '';
    this._controlID = null;
    this._cache = null;
    this._visitorID = '';
    this._orderID = '';
    this._query = '';
    this._contentReadyCallbacks = [];
    this._UIReadyCallbacks = [];
    this._progressSizeAdjusted = false;
    
    this._sectionMappings = [
        { url: 'Basic.aspx', section: OMC.Section.Basic },
        { url: 'Location.aspx', section: OMC.Section.Location },
        { url: 'Referrer.aspx', section: OMC.Section.Referrer },
        { url: 'Extranet.aspx', section: OMC.Section.Extranet },
        { url: 'PageVisits.aspx', section: OMC.Section.PageVisits },
        { url: 'FileDownloads.aspx', section: OMC.Section.FileDownloads },
        { url: 'Cart.aspx', section: OMC.Section.Cart },
        { url: 'Profiles.aspx', section: OMC.Section.Profiles },
        { url: 'Advertising.aspx', section: OMC.Section.Advertising },
        { url: 'Visits.aspx', section: OMC.Section.Visits },
        { url: 'EmailLeadList.aspx', section: OMC.Section.SendEmail },
        { url: 'About.aspx', section: OMC.Section.About }
    ];
}

OMC.MasterPage._instance = null;

OMC.MasterPage.get_current = function () {
    /// <summary>Gets the current instance of the master page.</summary>
    /// <returns>The current instnace of the master page.</returns>

    if (OMC.MasterPage._instance == null) {
        OMC.MasterPage._instance = new OMC.MasterPage();
    }

    return OMC.MasterPage._instance;
}

OMC.MasterPage.prototype.get_section = function () {
    /// <summary>Gets the current active section.</summary>
    
    return this.determineSection(this.get_contentUrl());
}

OMC.MasterPage.prototype.set_section = function (section, params) {
    /// <summary>Sets the current active section.</summary>
    /// <param name="params">Method params</param>
    var url = '';
    var baseUrl = '/Admin/Module/OMC/Leads/Details/';
    var query = this.get_query();

    // If method has parameter fullPeriod == 1, then remove PeriodToFullTime parameter from query
    if ((params) && (params['fullPeriod'] == 1)) {
        var re = new RegExp("([?|&])PeriodToFullTime=.*?(&|$)", "i");
        if (query.match(re)) {
            query = query.replace(re, '');
        }
    }

    for (var i = 0; i < this._sectionMappings.length; i++) {
        if (this._sectionMappings[i].section == section) {
            url = this._sectionMappings[i].url;
            break;
        }
    }

    this.markSectionActive(section);

    if (url && url.length) {
        url = baseUrl + url;
        url += (section != 7) ? '?ID=' + encodeURIComponent(this.get_visitorID()) : '?ID=' + encodeURIComponent(this.get_orderID());
        url += ('&' + query);
        url += ('&' + this.get_auth());

        this.set_contentUrl(url);
    }
}

OMC.MasterPage.prototype.get_query = function () {
    /// <summary>Gets the query part that represents the filters to be applied to each section.</summary>

    return this._query;
}

OMC.MasterPage.prototype.set_query = function (value) {
    /// <summary>Sets the query part that represents the filters to be applied to each section.</summary>
    /// <param name="value">The query part that represents the filters to be applied to each section.</param>

    this._query = value;
}

OMC.MasterPage.prototype.get_controlID = function () {
    /// <summary>Gets the ID of the corresponding ASP.NET page.</summary>

    return this._controlID;
}

OMC.MasterPage.prototype.set_controlID = function (value) {
    /// <summary>Sets the ID of the corresponding ASP.NET page.</summary>
    /// <param name="value">An ID of the corresponding ASP.NET page.</param>

    this._controlID = value;
}

OMC.MasterPage.prototype.get_visitorID = function () {
    /// <summary>Gets the ID of the current visitor.</summary>

    return this._visitorID;
}

OMC.MasterPage.prototype.set_visitorID = function (value) {
    /// <summary>Sets the ID of the current visitor.</summary>
    /// <param name="value">The ID of the current visitor.</param>

    this._visitorID = value;
}

OMC.MasterPage.prototype.get_orderID = function () {
    /// <summary>Gets the ID of the current visitor.</summary>

    return this._orderID;
}

OMC.MasterPage.prototype.set_orderID = function (value) {
    /// <summary>Gets the ID of the current visitor.</summary>

    this._orderID = value;
}

OMC.MasterPage.prototype.get_auth = function () {
    /// <summary>Gets the authentication token in case of anonymous access.</summary>

    return this._auth;
}

OMC.MasterPage.prototype.set_auth = function (value) {
    /// <summary>Sets the authentication token in case of anonymous access.</summary>
    /// <param name="value">The authentication token in case of anonymous access.</param>

    this._auth = value;
}

OMC.MasterPage.prototype.get_contentTitle = function () {
    /// <summary>Gets the title of the currently loaded content page.</summary>

    return this.get_contentReady() ? this.get_cache().entryTitle.innerHTML : '';
}

OMC.MasterPage.prototype.set_contentTitle = function (value) {
    /// <summary>Sets the title of the currently loaded content page.</summary>
    /// <param name="value">The title of the currently loaded content page.</param>

    this.get_cache().entryTitle.innerHTML = value;
}

OMC.MasterPage.prototype.get_contentTitleIsVisible = function () {
    /// <summary>Gets value indicating whether content title is visible.</summary>

    return this.get_cache().entryTitle.style.display != 'none';
}

OMC.MasterPage.prototype.set_contentTitleIsVisible = function (value) {
    /// <summary>Sets value indicating whether content title is visible.</summary>
    /// <param name="value">Value indicating whether content title is visible.</param>

    this.get_cache().entryTitle.style.display = (!!value ? 'block' : 'none');
}

OMC.MasterPage.prototype.get_cache = function () {
    /// <summary>Gets the cache object.</summary>

    if (!this._cache) {
        this._initializeCache();
    }

    return this._cache;
}

OMC.MasterPage.prototype.get_contentUrl = function () {
    /// <summary>Gets content Url.</summary>

    return this.get_cache().frame.readAttribute('src');
}

OMC.MasterPage.prototype.set_contentUrl = function (value) {
    /// <summary>Sets content URL.</summary>
    /// <param name="value">Content URL.</summary>

    this.navigate(value);
}

OMC.MasterPage.prototype.add_contentReady = function (callback) {
    /// <summary>Registers new event handler for "content ready" event.</summary>
    /// <param name="callback">Event handler.</param>

    if (callback) {
        this._contentReadyCallbacks[this._contentReadyCallbacks.length] = callback;
    }
}

OMC.MasterPage.prototype.add_ready = function (callback) {
    /// <summary>Registers new event handler for "ready" event.</summary>
    /// <param name="callback">Event handler.</param>

    if (callback) {
        this._UIReadyCallbacks[this._UIReadyCallbacks.length] = callback;
    }
}

OMC.MasterPage.prototype.markSectionActive = function (section) {
    /// <summary>Marks the given section as active.</summary>
    /// <param name="section">Section to mark.</param>

    var attr = '';
    var link = null;
    var links = $$('ul.visitor-details-navigation a');
    var lis = $$('ul.visitor-details-navigation li');
    var name = (OMC.Section.getName(section) || '').toLowerCase();

    for (var i = 0; i < links.length; i++) {
        link = $(links[i]);
        li = $(lis[i]);
        attr = (link.readAttribute('data-section') || '').toLowerCase();

        if (attr == name) {
            li.addClassName('navigation-active');
        } else {
            li.removeClassName('navigation-active');
        }
    }
}

OMC.MasterPage.prototype.determineSection = function (url) {
    /// <summary>Determines the section by examining the given URL.</summary>
    /// <param name="url">Content URL.</param>

    var ret = null;

    if (url && url.length) {
        url = url.toLowerCase();

        for (var i = 0; i < this._sectionMappings.length; i++) {
            if (url.indexOf(this._sectionMappings[i].url.toLowerCase()) > 0) {
                ret = this._sectionMappings[i].section;
                break;
            }
        }
    }

    return ret;
}

OMC.MasterPage.prototype.navigate = function (url, params) {
    /// <summary>Loads the content frame with the content from the given URL.</summary>
    /// <param name="url">Content URL.</param>
    /// <param name="params">Method parameters.</param>

    if (!params) {
        params = {};
    }

    this.set_contentTitle('');
    this.set_contentTitleIsVisible(false);

    if (url) {
        /* Clearing callbacks */
        this._contentReadyCallbacks = [];
        this._UIReadyCallbacks = [];

        this.get_cache().frame.writeAttribute('src', url);
        this._setContentIsVisible(false);
    }
}

OMC.MasterPage.prototype.initialize = function (onComplete) {
    /// <summary>Initializes the master page.</summary>
    /// <param name="onComplete">Callback that fires when initialization process completes.</param>

    var self = this;

    onComplete = onComplete || function () { }

    this._initializeCache();

   setTimeout(function() {
        self.autoSize();

        window.onresize = function () {
            self.autoSize();
        }

        // Callback behaviour is reserved (in case of loading some resources/APIs asynchronously)
        onComplete();
    }, 100);
}

OMC.MasterPage.prototype.autoSize = function () {
    /// <summary>Adjusts height according to current window height.</summary>

    var bodyHeight = 0;
    var contentTitleHeight = 0;

    if (this.get_contentTitleIsVisible()) {
        contentTitleHeight = 26;
    }

    bodyHeight = this.get_cache().body.getHeight();

    this.get_cache().frame.style.height = (bodyHeight - contentTitleHeight - 1) + 'px';
}

OMC.MasterPage.prototype.dispose = function () {
    /// <summary>Purges all cached data.</summary>

    this._cache = null;

    if (typeof (Dynamicweb.Utilities) != 'undefined') {
        Dynamicweb.Utilities.ResizeHandle.disposeAll();
    }
}

OMC.MasterPage.prototype.contentLoaded = function () {
    /// <summary>Fires when master page content finished loading.</summary>

    var self = this;

    this._setContentIsVisible(true);

    setTimeout(function () {
        for (var i = 0; i < self._contentReadyCallbacks.length; i++) {
            try {
                self._contentReadyCallbacks[i](self, {});
            } catch (ex) { }
        }
    }, 10);

    setTimeout(function () {
        self.autoSize();
        self._notify('ready', {});
    }, 100);
}

OMC.MasterPage.prototype._setContentIsVisible = function (isVisible) {
    /// <summary>Changes the content frame's "visible" state.</summary>
    /// <param name="isVisible">Indicates whether content frame is visible.</param>
    /// <private />

    var width = 0;
    var containerWidth = 0;

    this.get_cache().entryContainer.setStyle({ display: (isVisible ? '' : 'none') });
    this.get_cache().loadingIndicator.setStyle({ display: (isVisible ? 'none' : ''), left: '0px' });

    if (!isVisible && !this._progressSizeAdjusted) {
        width = this.get_cache().loadingIndicatorText.getWidth();
        containerWidth = this.get_cache().loadingIndicatorContainer.getWidth();

        if (width < containerWidth / 2) {
            this.get_cache().loadingIndicatorContainer.setStyle({ 'marginLeft': (parseInt((containerWidth - width) / 2) + 10) + 'px' });
        }

        this._progressSizeAdjusted = true;
    }
}

OMC.MasterPage.prototype._notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>
    /// <private />

    var callbacks = [];
    var callbackException = null;

    if (eventName && eventName.length) {
        if (eventName.toLowerCase() == 'contentready') {
            callbacks = this._contentReadyCallbacks;
        } else if (eventName.toLowerCase() == 'ready') {
            callbacks = this._UIReadyCallbacks;
        }

        if (callbacks && callbacks.length) {
            if (typeof (args) == 'undefined' || args == null) {
                args = {};
            }

            for (var i = 0; i < callbacks.length; i++) {
                callbackException = null;

                try {
                    callbacks[i](this, args);
                } catch (ex) {
                    callbackException = ex;
                }

                /* Preventing "Unable to execute code from freed script" errors to raise */
                if (callbackException && callbackException.number != -2146823277) {
                    this.error(callbackException.toString());
                }
            }
        }
    }
}

OMC.MasterPage.prototype.error = function (message) {
    /// <summary>Displays an error message.</summary>
    /// <param name="message">Error message.</param>

    var er = null;

    if (typeof (Error) != 'undefined') {
        er = new Error();

        er.message = message;
        er.description = message;

        throw (er);
    } else {
        throw (message);
    }
}

OMC.MasterPage.prototype._initializeCache = function () {
    /// <summary>Initializes cache objects.</summary>

    this._cache = {};

    this._cache.entryTitle = $('entryTitle');
    this._cache.entryContainer = $('entryContainer');
    this._cache.loadingIndicator = $('cellContentLoading');
    this._cache.loadingIndicatorText = $($$('#cellContentLoading .omc-loading-container-text')[0]);
    this._cache.loadingIndicatorContainer = $($$('#cellContentLoading .omc-loading-container')[0]);
    this._cache.frame = $('ContentFrame');
    this._cache.body = $(document.body);
}