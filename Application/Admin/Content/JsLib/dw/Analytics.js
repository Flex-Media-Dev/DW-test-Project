if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Analytics) == 'undefined') {
    Dynamicweb.Analytics = new Object();
}

Dynamicweb.Analytics._trackerInstance = null;

Dynamicweb.Analytics.Tracker = function () {
    /// <summary>Represents a client-side object that is responsible for tracking visits.</summary>

    this._sessionID = '';
    this._pageID = 0;
    this._areaID = 0;
    this._engagement = null;
};

Dynamicweb.Analytics.Tracker.get_current = function () {
    /// <summary>Gets the current instance of the tracker.</summary>

    if (!Dynamicweb.Analytics._trackerInstance) {
        Dynamicweb.Analytics._trackerInstance = new Dynamicweb.Analytics.Tracker();
    }

    return Dynamicweb.Analytics._trackerInstance;
};

Dynamicweb.Analytics.Tracker.prototype.get_sessionID = function () {
    /// <summary>Gets the current ASP.NET session identifier.</summary>

    return this._sessionID;
};

Dynamicweb.Analytics.Tracker.prototype.set_sessionID = function (value) {
    /// <summary>Sets the current ASP.NET session identifier.</summary>
    /// <param name="value">The current ASP.NET session identifier.</param>

    this._sessionID = value;
};

Dynamicweb.Analytics.Tracker.prototype.get_pageID = function () {
    /// <summary>Gets the current page ID.</summary>

    return parseInt(this._pageID) || 0;
};

Dynamicweb.Analytics.Tracker.prototype.set_pageID = function (value) {
    /// <summary>Sets the current page ID.</summary>
    /// <param name="value">The current page ID.</param>

    this._pageID = value;
};

Dynamicweb.Analytics.Tracker.prototype.get_areaID = function () {
    /// <summary>Gets the current area ID.</summary>

    return parseInt(this._areaID) || 0;
};

Dynamicweb.Analytics.Tracker.prototype.set_areaID = function (value) {
    /// <summary>Sets the current area ID.</summary>
    /// <param name="value">The current area ID.</param>

    this._areaID = value;
};

Dynamicweb.Analytics.Tracker.prototype.get_engagement = function () {
    /// <summary>Gets the engagement index.</summary>

    return this._engagement;
};

Dynamicweb.Analytics.Tracker.prototype.set_engagement = function (value) {
    /// <summary>Sets the engagement index.</summary>
    /// <param name="value">The engagement index.</param>

    this._engagement = value;
};

Dynamicweb.Analytics.Tracker.prototype.get_screenWidth = function () {
    /// <summary>Gets the width (in pixels) of the client device's screen.</summary>

    return typeof (window.screen.width) != 'undefined' ? (parseInt(window.screen.width) || 0) : 0;
};

Dynamicweb.Analytics.Tracker.prototype.get_screenHeight = function () {
    /// <summary>Gets the height (in pixels) of the client device's screen.</summary>

    return typeof (window.screen.height) != 'undefined' ? (parseInt(window.screen.height) || 0) : 0;
};

Dynamicweb.Analytics.Tracker.prototype.get_colorDepth = function () {
    /// <summary>Gets the color depth of the client device's screen.</summary>

    return typeof (window.screen.colorDepth) != 'undefined' ? (parseInt(window.screen.colorDepth) || 0) : 0;
};

Dynamicweb.Analytics.Tracker.prototype.get_referrer = function () {
    /// <summary>Gets the referrer URI.</summary>

    return typeof (document.referrer) != 'undefined' ? document.referrer.toString() : '';
};

Dynamicweb.Analytics.Tracker.prototype.get_language = function () {
    /// <summary>Gets the language of the visit's user agent.</summary>

    return typeof (window.navigator.language) != 'undefined' ? window.navigator.language : '';
};

Dynamicweb.Analytics.Tracker.prototype.add_contentReady = function (callback) {
    /// <summary>Registers a new callback that is fired then the page content is loaded.</summary>
    /// <param name="callback">Callback to be executed.</param>

    var f = null;

    if (callback && typeof (callback) == 'function') {
        f = function () { callback(this, {}); }

        if (typeof (document.addEventListener) != 'undefined') {
            document.addEventListener('DOMContentLoaded', f, false);
        } else if (typeof (window.attachEvent) != 'undefined') {
            window.attachEvent('onload', f);
        }
    }
};

Dynamicweb.Analytics.Tracker.prototype.set_parameters = function (params) {
    /// <summary>Sets tracker paremters.</summary>
    /// <param name="params">An object representing tracker parameters.</param>

    if (params) {
        if (typeof (params.sessionID) != 'undefined') {
            this.set_sessionID(params.sessionID);
        }

        if (typeof (params.pageID) != 'undefined') {
            this.set_pageID(params.pageID);
        }

        if (typeof (params.areaID) != 'undefined') {
            this.set_areaID(params.areaID);
        }

        if (typeof (params.engagement) != 'undefined') {
            this.set_engagement(params.engagement);
        }
    }
};

Dynamicweb.Analytics.Tracker.prototype.trackVisit = function () {
    /// <summary>Sends an asynchronous request to the server to add (or update) the record for the current visit.</summary>

    this._send(this._buildTrackerURI());
};

Dynamicweb.Analytics.Tracker.prototype._buildTrackerURI = function () {
    /// <summary>Returns a URI used to track the current visit.</summary>
    /// <returns>A URI used to track the current visit.</returns>
    /// <private />

    var ret = '';

    ret = '/Admin/Public/Stat2.aspx?SessionID=' + encodeURIComponent(this.get_sessionID());

    ret += '&PageID=' + encodeURIComponent(this.get_pageID().toString());
    ret += '&AreaID=' + encodeURIComponent(this.get_areaID().toString());
    ret += '&width=' + encodeURIComponent(this.get_screenWidth().toString());
    ret += '&height=' + encodeURIComponent(this.get_screenHeight().toString());
    ret += '&col=' + encodeURIComponent(this.get_colorDepth().toString());
    ret += '&referrer=' + encodeURIComponent(this.get_referrer());
    ret += '&async=true';

    if (this.get_language()) {
        ret += '&lan=' + encodeURIComponent(this.get_language());
    }

    if (this.get_engagement() != null) {
        ret += '&engagement=' + this.get_engagement();
    }

    return ret;
};

Dynamicweb.Analytics.Tracker.prototype._send = function (uri) {
    /// <summary>Sends a request to a server.</summary>
    /// <private />

    var node = null;
    var isNewNode = false;
    var embedScript = false;
    var scriptID = 'DwTrackScript';
    var domain = document.domain || '';
    var request = this._createRequestObject();

    var attribute = function (elm, attribute, value) {
        if (elm.writeAttribute) {
            elm.writeAttribute(attribute, value);
        } else if (elm.setAttribute) {
            elm.setAttribute(attribute, value);
        }
    }

    if (uri && uri.length) {
        if (domain && domain.length) {
            domain = (document.location.protocol + '//' + domain + document.location.port + '/').toLowerCase();
        }

        if (!request) {
            embedScript = true;
        } else if (uri.indexOf('http://') == 0 || uri.indexOf('https://') == 0) {
            embedScript = uri.toLowerCase().indexOf(domain) != 0;
        }

        /* Forced to embed script due to security issues in IE with zones */
        embedScript = true;

        if (!embedScript) {
            request.open('GET', uri, true);
            request.send(null);
        } else {
            node = document.getElementById(scriptID);

            if (!node) {
                isNewNode = true;

                node = document.createElement('script');

                attribute(node, 'id', scriptID);
                attribute(node, 'async', 'true');
                attribute(node, 'type', 'text/javascript');
            }

            attribute(node, 'src', uri);

            if (isNewNode) {
                var s = document.getElementsByTagName('script')[0];
                s.parentNode.insertBefore(node, s);
            }
        }
    }
};

Dynamicweb.Analytics.Tracker.prototype._createRequestObject = function () {
    /// <summary>Returns an instance of the XMLHttpRequest object.</summary>
    /// <returns>An instance of the XMLHttpRequest object.</returns>
    /// <private />

    var ret = null;

    if (typeof (XMLHttpRequest) != 'undefined') {
        ret = new XMLHttpRequest();
    } else if (typeof (ActiveXObject) != 'undefined') {
        try {
            ret = new ActiveXObject('Microsoft.XMLHTTP');
        } catch (ex) { }

        if (!ret) {
            try {
                ret = new ActiveXObject('Msxml2.XMLHTTP.6.0');
            } catch (ex) { }

            if (!ret) {
                try {
                    ret = new ActiveXObject('Msxml2.XMLHTTP.3.0');
                } catch (ex) { }
            }
        }
    }

    return ret;
};

Dynamicweb.Analytics.Tracker.prototype._isIE = function () {
    /// <summary>Returns value indicating whether visit's user agent is of Microsoft Internet Explorer family.</summary>
    /// <returns>Value indicating whether visit's user agent is of Microsoft Internet Explorer family.</returns>
    /// <private />

    return typeof (window.attachEvent) != 'undefined' ||
        window.navigator.userAgent.toLowerCase().indexOf('msie') >= 0;
};

(function (w, n) {

    var tr = Dynamicweb.Analytics.Tracker.get_current();
    tr.set_parameters({ sessionID: w[n].sessionID, pageID: w[n].pageID, areaID: w[n].areaID, engagement: w[n].engagement });
    tr.trackVisit();

})(window, 'analytics');