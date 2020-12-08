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

Dynamicweb.Controls.OMC.VisitsList = function () {
    /// <summary>Represents a list of visits.</summary>

    this._list = '';
    this._container = '';
    this._isReady = false;
    this._initialized = false;
    this._terminology = {};
    this._locationData = {};
    this._knownCompanies = [];
    this._excludeKnownCompanies = false;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.get_container = function () {
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

Dynamicweb.Controls.OMC.VisitsList.prototype.set_container = function (value) {
    /// <summary>Sets the reference to DOM element that contains all the UI.</summary>
    /// <param name="value">The reference to DOM element that contains all the UI.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.add_ready = function (callback) {
    /// <summary>Adds a callback that is executed when the control is ready.</summary>
    /// <param name="callback">a callback that is executed when the control is ready.</param>

    callback = callback || function () { }

    if (this.get_isReady()) {
        callback(this, {});
    } else {
        $(document).observe('dom:loaded', function () { { callback(this, {}); } });
    }
}

Dynamicweb.Controls.OMC.VisitsList.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return this._terminology;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.get_knownCompanies = function () {
    /// <summary>Gets the list of company names in the Management Center under the "General -> Known companies" section.</summary>

    return this._knownCompanies;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.set_knownCompanies = function (value) {
    /// <summary>Sets the list of company names in the Management Center under the "General -> Known companies" section.</summary>
    /// <param name="value">The list of company names in the Management Center under the "General -> Known companies" section.</param>

    this._knownCompanies = value;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.get_excludeKnownCompanies = function () {
    /// <summary>Gets value indicating whether to exclude (in this case, fade out) known companies.</summary>

    return this._excludeKnownCompanies;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.set_excludeKnownCompanies = function (value) {
    /// <summary>Sets value indicating whether to exclude (in this case, fade out) known companies.</summary>
    /// <param name="value">Value indicating whether to exclude (in this case, fade out) known companies.</param>

    this._excludeKnownCompanies = value;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.get_isReady = function () {
    /// <summary>Gets value indicating whether control is ready to perform actions.</summary>

    return this._isReady;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.get_list = function () {
    /// <summary>Gets the name of the corresponding list control.</summary>

    return this._list;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.set_list = function (value) {
    /// <summary>Sets the name of the corresponding list control.</summary>
    /// <param name="value">The name of the corresponding list control.</param>

    this._list = value;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.updateLocation = function (onComplete) {
    /// <summary>Updates the information about the ISP for all rows in a list.</summary>
    /// <param name="onComplete">Callback that is called when the location lookup is finished.</param>

    var self = this;
    var columns = null;
    var ipString = '';
    var rowActive = false;
    var pendingTimeoutID = null;
    var ip = this._ipAddresses();
    var knownProviders = self.get_knownCompanies();

    onComplete = onComplete || function () { }

    this._locationData = {};

    var getLocationColumn = function () {
        var tag = '';
        var cells = [];
        var rows = null;
        var currentCell = 0;

        if (columns == null) {
            columns = [];
            rows = $$('tr.listRow');

            if (rows && rows.length) {
                for (var i = 0; i < rows.length; i++) {
                    cells = rows[i].childNodes;

                    if (cells && cells.length) {
                        currentCell = 0;
                        for (var j = 0; j < cells.length; j++) {
                            tag = (cells[j].nodeName || cells[j].tagName).toLowerCase();

                            if (tag == 'td') {
                                /* Second cell - ISP information */
                                if (currentCell == 3) {
                                    columns[columns.length] = cells[j];
                                    break;
                                } else {
                                    currentCell += 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        return columns;
    }

    var updateColumnContent = function (content) {
        var column = getLocationColumn();

        if (column && column.length) {
            for (var i = 0; i < column.length; i++) {
                if (typeof (content) != 'undefined') {
                    if (typeof (content) == 'string') {
                        column[i].innerHTML = content;
                    } else {
                        column[i].innerHTML = '';
                        column[i].appendChild(content);
                    }
                } else {
                    column[i].innerHTML = '';
                }
            }
        }
    }

    if (ip && ip.length) {
        for (var i = 0; i < ip.length; i++) {
            ipString += ip[i];
            if (i < (ip.length - 1)) {
                ipString += ',';
            }
        }

        pendingTimeoutID = setTimeout(function () {
            updateColumnContent('<span class="location-pending">' + self.get_terminology()['Pending'] + '</span>');
        }, 350);

        Dynamicweb.Ajax.doPostBack({
            url: '/Admin/Module/OMC/Task.ashx?Name=GetLocation&timestamp=' + (new Date()).getTime(),
            explicitMode: true,
            parameters: { IP: ipString },
            onComplete: function (transport) {
                var geo = {};
                var row = null;
                var data = null;
                var column = null;
                var ipAddress = '';
                var response = transport.responseText;

                if (pendingTimeoutID) {
                    clearTimeout(pendingTimeoutID);
                    pendingTimeoutID = null;
                }

                updateColumnContent('');

                if (response && response.length) {
                    try {
                        data = response.evalJSON();
                    } catch (ex) { }

                    if (data && data.location && data.location.length) {
                        for (var i = 0; i < data.location.length; i++) {
                            geo = {
                                isp: data.location[i].ISP || data.location[i].isp,
                                countryCode: data.location[i].CountryCode || data.location[i].countryCode,
                                countryName: data.location[i].CountryName || data.location[i].countryName,
                                ipAddress: data.location[i].IPAddress || data.location[i].ipAddress,
                                domain: data.location[i].Domain || data.location[i].domain,
                                latitude: data.location[i].Latitude || data.location[i].latitude,
                                longitude: data.location[i].Longitude || data.location[i].longitude,
                                region: data.location[i].Region || data.location[i].region,
                                city: data.location[i].City || data.location[i].city,
                                zip: data.location[i].Zip || data.location[i].zip,
                                company: data.location[i].Company || data.location[i].company
                            }

                            self._locationData[geo.ipAddress] = geo;
                        }

                        column = getLocationColumn();

                        if (column && column.length) {
                            for (var i = 0; i < column.length; i++) {
                                row = $(column[i].parentNode || column[i].parentElement);
                                ipAddress = row.readAttribute('data-ipaddress');

                                if (ipAddress && ipAddress.length && self._locationData[ipAddress]) {
                                    column[i].innerHTML = '';
                                    column[i].appendChild(self._formatLocationElement(self._locationData[ipAddress].countryCode, self._locationData[ipAddress].company));

                                    if (self.get_excludeKnownCompanies()) {
                                        for (var j = 0; j < knownProviders.length; j++) {
                                            rowActive = self._locationData[ipAddress].isp.toLowerCase() != knownProviders[j].toLowerCase() &&
                                            self._locationData[ipAddress].isp.toLowerCase().indexOf(knownProviders[j].toLowerCase()) < 0;

                                            if (!rowActive) {
                                                row.addClassName('listRowDisabled');
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        onComplete();
                    }
                } else {
                    onComplete();
                }
            }
        });
    } else {
        onComplete();
    }
}

Dynamicweb.Controls.OMC.VisitsList.prototype._formatLocationElement = function (code, name) {
    /// <summary>Formats the given country and returns the DOM element that contains country information.</summary>
    /// <param name="code">Country code.</param>
    /// <param name="name">ISP name.</param>
    /// <private />

    var ret = null;
    var img = null;
    var self = this;
    var container = null;
    var nameContainer = null;

    if (code != null || name != null) {
        if (name && name.length) {
            ret = this._update(new Element('span'), this._nonEmpty(code.toString()));

            if (code && code.length) {
                container = new Element('div', { 'class': 'omc-leads-list-country' });

                img = new Element('span', { 'class': 'omc-leads-list-country-code' });
                img.setStyle({ 'backgroundImage': 'url(\'/Admin/Images/Flags/Small/flag_' + code + '.png\')' });

                container.appendChild(img);

                nameContainer = this._update(new Element('a', {
                    'class': 'omc-leads-list-country-name',
                    'title': this.get_terminology()['ViewLocation'],
                    'href': 'javascript:void(0);'
                }), this._nonEmpty(name));

                container.appendChild(nameContainer);

                Event.observe(nameContainer, 'click', function (e) {
                    var ipAddress = '';
                    var location = null;
                    var elm = $(Event.element(e));
                    var row = elm.up('.listRow');
                    var position = { top: Event.pointerY(e), left: Event.pointerX(e) }

                    if (row) {
                        ipAddress = row.readAttribute('data-ipaddress');
                        if (ipAddress && ipAddress.length && self._locationData[ipAddress]) {
                            location = self._locationData[ipAddress];
                        }
                    }

                    Dynamicweb.Controls.OMC.LeadsList.InfoBox.get_current().set_visitor({
                        get_location: function () { return location; },
                        get_id: function () { return -1; }
                    });

                    Dynamicweb.Controls.OMC.LeadsList.InfoBox.get_current().show({ position: position });
                });


                ret = container;
            }
        } else {
            ret = this._update(new Element('span'), this._nonEmpty(code.toString()));
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.VisitsList.prototype._ipAddresses = function () {
    /// <summary>Gets the list of distinct IP-addresses parsed from the list rows.</summary>
    /// <private />

    var ip = '';
    var ret = [];
    var field = '';
    var added = {};
    var rows = $$('tr.listRow');

    if (rows && rows.length) {
        for (var i = 0; i < rows.length; i++) {
            ip = $(rows[i]).readAttribute('data-ipaddress');
            if (ip && ip.length) {
                field = 'f_' + (ip.replace(/\./gi, '_'));
                if (!added[field]) {
                    added[field] = ip;
                    ret[ret.length] = ip;
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.VisitsList.prototype._update = function (elm, content) {
    /// <summary>Updates element content.</summary>
    /// <param name="elm">DOM element whose content to update.</param>
    /// <param name="content">New element content.</param>
    /// <private />

    if (elm) {
        elm.innerHTML = content;
    }

    return elm;
}

Dynamicweb.Controls.OMC.VisitsList.prototype._nonEmpty = function (v) {
    /// <summary>Ensures that the given value is not empty. Otherwise returns a whitespace HTML entity.</summary>
    /// <param name="v">Value to examine.</param>

    var ret = v;

    if (v == null || v.toString().length == 0) {
        ret = '&nbsp;';
    }

    return ret;
}

Dynamicweb.Controls.OMC.VisitsList.prototype.initialize = function () {
    /// <summary>Initializes the instance.</summary>

    if (!this._initialized) {
        this.updateLocation();
        
        this._initialized = true;
    }
}

Dynamicweb.Controls.OMC.VisitsList.prototype.updateContentForSelectedVisit = function (periodTo) {
    /// <summary>Shows visits that were before the selected visit.</summary>
    var query = parent.OMC.MasterPage.get_current().get_query();

    var re = new RegExp("([?|&])PeriodToFullTime=.*?(&|$)", "i");    
    if (query.match(re)) {
        query = query.replace(re, '$1' + "PeriodToFullTime=" + encodeURIComponent(periodTo) + '$2');
    }
    else {
        query += "&PeriodToFullTime=" + encodeURIComponent(periodTo);
    }

    parent.OMC.MasterPage.get_current().set_query(query);
    parent.OMC.MasterPage.get_current().set_section(parent.OMC.Section.Basic);
}