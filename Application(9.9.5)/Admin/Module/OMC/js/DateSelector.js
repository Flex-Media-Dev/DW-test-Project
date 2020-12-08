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

Dynamicweb.Controls.OMC.DateSelectorCulture = function (params) {
    /// <summary>Provides culture-sensitive information for the DateSelector control.</summary>
    /// <param name="params">Initialization parameters.</param>

    this._firstDayOfWeek = 'monday';

    if (params) {
        if (typeof (params.firstDayOfWeek) != 'undefined') {
            this.set_firstDayOfWeek(params.firstDayOfWeek);
        }
    }
}

Dynamicweb.Controls.OMC.DateSelectorCulture.prototype.get_firstDayOfWeek = function () {
    /// <summary>Gets the first day of week.</summary>

    return this._firstDayOfWeek;
}

Dynamicweb.Controls.OMC.DateSelectorCulture.prototype.set_firstDayOfWeek = function (value) {
    /// <summary>Sets the first day of week.</summary>
    /// <param name="value">First day of week.</param>

    this._firstDayOfWeek = (value && value.length) ? value.toLowerCase() : 'monday';
}

Dynamicweb.Controls.OMC.DateSelector = function () {
    /// <summary>Represents a date selector.</summary>

    this._selectedDate = null;
    this._selectedDateControl = null;
    this._selectedHourControl = null;
    this._selectedMinuteControl = null;
    this._defaultDateFormat = 'dd-MM-yyyy';
    this._dateFormat = 'dd-MM-yyyy';
    this._allowEmpty = false;
    this._formatter = null;
    this._calendar = null;
    this._culture = null;
    this._currentPeriodOnly = false;
    this._offset = null;
    this._includeTime = false;
}

/* Inheritance */
Dynamicweb.Controls.OMC.DateSelector.prototype = new Dynamicweb.Ajax.Control();

/* ++++++ Global utility object ++++++ */

// Represents a global utility object.
Dynamicweb.Controls.OMC.DateSelector.Global = new Object();
Dynamicweb.Controls.OMC.DateSelector.Global._terminology = {};
Dynamicweb.Controls.OMC.DateSelector.Global._offset = null;

Dynamicweb.Controls.OMC.DateSelector.Global.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return Dynamicweb.Controls.OMC.DateSelector.Global._terminology;
}

Dynamicweb.Controls.OMC.DateSelector.Global.get_offset = function () {
    /// <summary>Gets the global calendar offset.</summary>

    return Dynamicweb.Controls.OMC.DateSelector.Global._offset;
}

Dynamicweb.Controls.OMC.DateSelector.Global.set_offset = function (value) {
    /// <summary>Sets the global calendar offset.</summary>
    /// <param name="value">The global calendar offset.</param>

    Dynamicweb.Controls.OMC.DateSelector.Global._offset = value;
}

/* ++++++ End: Global utility object ++++++ */

/* ++++++ Date calendar ++++++ */

Dynamicweb.Controls.OMC.DateSelector.Calendar = function (container) {
    /// <summary>Represents a calendar.</summary>
    /// <param name="container">A reference to DOM element that holds calendar output.</param>

    this._handle = null;
    this._container = null;
    this._containerID = container;

    this._selectedDate = new Date();
    this._currentDate = new Date();
    this._allowEmpty = false;
    this._minDate = null;
    this._maxDate = null;
    this._culture = null;
    this._currentPeriodOnly = false;
    this._offset = null;

    this._dateChanged = [];
    this._monthChanged = [];
}

/* Calendar state */
Dynamicweb.Controls.OMC.DateSelector.Calendar._state = { mouseDownAttached: false };

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_container = function () {
    /// <summary>Gets the reference to DOM element that holds calendar output.</summary>

    if (!this._container) {
        if (this._containerID) {
            if (typeof (this._containerID) == 'string') {
                this._container = document.getElementById(this._containerID);
            } else {
                this._container = this._containerID;
            }

            if (this._container) {
                this._container = $(this._container);
            }
        }
    }

    return this._container;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_offset = function () {
    /// <summary>Gets the initial calendar offset.</summary>

    return this._offset;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.set_offset = function (value) {
    /// <summary>Sets the initial calendar offset.</summary>
    /// <param name="value">The initial calendar offset.</param>

    this._offset = value;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_handle = function () {
    /// <summary>Gets the reference to DOM element that represents a handle for this calendar.</summary>

    return this._handle;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.set_handle = function (value) {
    /// <summary>Sets the reference to DOM element that represents a handle for this calendar.</summary>
    /// <param name="value">The reference to DOM element that represents a handle for this calendar.</param>

    if (value) {
        if (typeof (value) == 'string') {
            this._handle = document.getElementById(value);
        } else {
            this._handle = value;
        }
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_culture = function () {
    /// <summary>Gets the culture information.</summary>

    return this._culture;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.set_culture = function (value) {
    /// <summary>Sets the culture information.</summary>
    /// <param name="value">The culture information.</param>

    this._culture = value;

    if (!value || typeof (value.get_firstDayOfWeek) != 'function') {
        this._culture = new Dynamicweb.Controls.OMC.DateSelectorCulture();
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_currentPeriodOnly = function () {
    /// <summary>Gets value indicating whether to prohibit user from selecting days that are in the future.</summary>

    return this._currentPeriodOnly;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.set_currentPeriodOnly = function (value) {
    /// <summary>Sets value indicating whether to prohibit user from selecting days that are in the future.</summary>

    this._currentPeriodOnly = !!value;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_selectedDate = function () {
    /// <summary>Gets the currently selected date.</summary>

    return this._selectedDate;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.set_selectedDate = function (value) {
    /// <summary>Sets the currently selected date.</summary>
    /// <param name="value">The currently selected date.</param>

    this._selectedDate = this.get_allowEmpty ? value : (value || new Date());

    if (this.get_isVisible()) {
        this.refresh();
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_currentDate = function () {
    /// <summary>Gets the date representing the current calendar state.</summary>

    if (!this._currentDate) {
        this._currentDate = new Date();
    }

    return this._currentDate;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.set_currentDate = function (value) {
    /// <summary>Sets the date representing the current calendar state.</summary>
    /// <param name="value">The date representing the current calendar state.</param>

    this._currentDate = value || new Date();

    if (this.get_isVisible()) {
        this.refresh();
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_allowEmpty = function () {
    return this._allowEmpty;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.set_allowEmpty = function (value) {
    this._allowEmpty = value;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_minDate = function () {
    /// <summary>Gets the minimum allowed date.</summary>

    return this._minDate;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.set_minDate = function (value) {
    /// <summary>Sets the minimum allowed date.</summary>
    /// <param name="value">The minimum allowed date..</param>

    this._minDate = value;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_maxDate = function () {
    /// <summary>Gets the maximum allowed date.</summary>

    return this._maxDate;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.set_maxDate = function (value) {
    /// <summary>Sets the maximum allowed date.</summary>
    /// <param name="value">The maximum allowed date..</param>

    this._maxDate = value;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.get_isVisible = function () {
    /// <summary>Gets value indicating whether calendar is visible.</summary>

    var ret = false;

    if (this.get_container()) {
        ret = (this.get_container().getStyle('display') + '').toLowerCase() != 'none';
    }
    
    return ret;
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.add_dateChanged = function (callback) {
    /// <summary>Registers a new callback function that is fired when the user changes the currently selected date.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback) {
        this._dateChanged[this._dateChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.add_monthChanged = function (callback) {
    /// <summary>Registers a new callback function that is fired when the user changes the currently selected month.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback) {
        this._monthChanged[this._monthChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.notify = function (eventName, args) {
    /// <summary>Motifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];

    if (eventName && eventName.length) {
        eventName = eventName.toLowerCase();

        if (eventName == 'datechanged') {
            callbacks = this._dateChanged;
        } else if (eventName == 'monthchanged') {
            callbacks = this._monthChanged;
        }

        if (callbacks && callbacks.length) {
            for (var i = 0; i < callbacks.length; i++) {
                if (callbacks[i]) {
                    try {
                        callbacks[i](this, args);
                    } catch (ex) { }
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.show = function () {
    /// <summary>Shows the calendar.</summary>

    var h = null;
    var offsetElement = null;
    var width = null;
    var offset = null;
    var top = 0, left = 0;
    var additionalOffset = this.get_offset();

    if (!Dynamicweb.Controls.OMC.DateSelector.Calendar._state.mouseDownAttached) {
        Event.observe(document.body, 'mousedown', Dynamicweb.Controls.OMC.DateSelector.Calendar._onDocumentMouseDown);
        Dynamicweb.Controls.OMC.DateSelector.Calendar._state.mouseDownAttached = true;
    }

    if (this.get_container()) {
        Dynamicweb.Controls.OMC.DateSelector.Calendar.hideAll();

        if (this.get_handle()) {
            h = $(this.get_handle());

            width = h.getWidth();
            offset = this.cumulativeOffset(h);

            top = offset.top;
            left = offset.left + width + 2;
        }

        if (additionalOffset == null) {
            additionalOffset = Dynamicweb.Controls.OMC.DateSelector.Global.get_offset();
        }

        if (additionalOffset != null) {
            top += additionalOffset.top;
            left += additionalOffset.left;
            if (!!additionalOffset.offsetElementId) {
                offsetElement = $(additionalOffset.offsetElementId);
                if (!!offsetElement) {
                    top -= offsetElement.scrollTop;
                }
            }
            if (!!additionalOffset.AlignToElementId) {
                offsetElement = $(additionalOffset.AlignToElementId);
                if (!!offsetElement) {
                    var elOffset = offsetElement.cumulativeOffset();
                    top += offsetElement.offsetHeight;
                    left = elOffset.left + additionalOffset.left;
                }
            }
        }

        this.get_container().setStyle({
            'position': 'absolute',
            'zIndex': '5',
            'top': top + 'px',
            'left': left + 'px'
        });

        this.get_container().show();

        this.refresh();
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.hide = function () {
    /// <summary>Hides the calendar.</summary>

    if (this.get_container()) {
        this.get_container().hide();
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.refresh = function () {
    /// <summary>Refreshes the calendar by redrawing it.</summary>

    var html = '';
    var self = this;
    var totalDays = 0;
    var currentDay = 0;
    var headerHtml = '';
    var totalCells = 42;
    var dateString = '';
    var isToday = false;
    var isFuture = false;
    var firstWeekDay = 0;
    var totalDaysPrev = 0;
    var today = new Date();
    var isSelected = false;
    var hasFutureDays = false;
    var selDate = this.get_selectedDate();
    var currentDate = this.get_currentDate();
    var allowBackward = true, allowForward = true;
    var allowBackward2x = true, allowForward2x = true;
    var dsGlobal = Dynamicweb.Controls.OMC.DateSelector.Global;
    var startDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);

    if (this.get_minDate()) {
        if (this.get_minDate().getFullYear() > startDate.getFullYear()) {
            allowBackward = allowBackward2x = false;
        } else if (this.get_minDate().getFullYear() == startDate.getFullYear() && (this.get_minDate().getMonth() >= startDate.getMonth())) {
            allowBackward = allowBackward2x = false;
        }

        if (selDate && allowBackward2x) {
            allowBackward2x = (selDate.getFullYear() - this.get_minDate().getFullYear()) > 0;
        }
    }

    if (this.get_maxDate()) {
        if (this.get_maxDate().getFullYear() < startDate.getFullYear()) {
            allowForward = allowForward2x = false;
        } else if (this.get_maxDate().getFullYear() == startDate.getFullYear() && (this.get_maxDate().getMonth() <= startDate.getMonth())) {
            allowForward = allowForward2x = false;
        }

        if (selDate && allowForward2x) {
            allowForward2x = (this.get_maxDate().getFullYear() - selDate.getFullYear()) > 0;
        }
    }

    if (this.get_container()) {
        this.get_container().innerHTML = '';

        firstWeekDay = startDate.getDay();
        totalDays = this._daysInMonth(startDate.getMonth(), startDate.getFullYear());
        totalDaysPrev = this._daysInMonth(startDate.getMonth() - 1 < 0 ? 0 : startDate.getMonth() - 1,
            startDate.getMonth() - 1 < 0 ? startDate.getFullYear() - 1 : startDate.getFullYear());

        if (firstWeekDay == 0) {
            firstWeekDay = 7;
        }

        if (this.get_culture().get_firstDayOfWeek() == 'sunday') {
            for (var i = 0; i < 7; i++) {
                html += '<th>' + dsGlobal.get_terminology()['DaysShort'][i == 0 ? 6 : i - 1] + '</th>';
            }
        } else {
            for (var i = 0; i < 7; i++) {
                html += '<th>' + dsGlobal.get_terminology()['DaysShort'][i] + '</th>';
            }
        }

        html += '</tr>';

        for (var i = 1; i <= parseInt(totalCells / 7); i++) {
            html += '<tr class="date-selector-calendar-day">';

            for (var j = 1; j <= 7; j++) {
                isToday = false;
                isFuture = false;
                isSelected = false;
                currentDay = (j + (7 * (i - 1))) - firstWeekDay + 1;

                if (this.get_culture().get_firstDayOfWeek() == 'sunday') {
                    currentDay -= 1;
                }

                if (this.get_selectedDate()) {
                    isSelected = currentDay == this.get_selectedDate().getDate();
                    if (isSelected) {
                        isSelected = this.get_currentDate().getMonth() == this.get_selectedDate().getMonth() &&
                            this.get_currentDate().getFullYear() == this.get_selectedDate().getFullYear();
                    }
                }

                if (!isSelected) {
                    isToday = currentDay == today.getDate();
                    if (isToday) {
                        isToday = currentDate.getMonth() == today.getMonth() &&
                            currentDate.getFullYear() == today.getFullYear();
                    }
                }

                isFuture = (currentDate.getFullYear() > today.getFullYear() ||
                    (currentDate.getFullYear() == today.getFullYear() && currentDate.getMonth() > today.getMonth()) ||
                    (currentDate.getFullYear() == today.getFullYear() && currentDate.getMonth() == today.getMonth() && currentDay > today.getDate()));

                if (isFuture) {
                    hasFutureDays = true;
                }

                if (isSelected) {
                    html += '<td class="date-selector-calendar-current">';
                } else if (isToday) {
                    html += '<td class="date-selector-calendar-today">';
                } else if (currentDay <= 0 || currentDay > totalDays || (this.get_currentPeriodOnly() && isFuture)) {
                    html += '<td class="date-selector-calendar-hidden">';
                } else {
                    html += '<td>';
                }

                if (currentDay <= 0) {
                    html += '<a href="javascript:void(0);"><span>' + (totalDaysPrev + currentDay) + '</span></a>';
                } else if (currentDay > totalDays) {
                    html += '<a href="javascript:void(0);"><span>' + (currentDay - totalDays) + '</span></a>';
                } else if (this.get_currentPeriodOnly() && isFuture) {
                    html += '<a href="javascript:void(0);"><span>' + currentDay + '</span></a>';
                } else {
                    dateString = currentDay + '-' + startDate.getMonth() + '-' + startDate.getFullYear();
                    html += '<a href="javascript:void(0);" data-date="' + dateString + '"><span>' + currentDay + '</span></a>';
                }

                html += '</td>';
            }

            html += '</tr>';
        }
        if (this.get_allowEmpty()) {
            html += '<tr class="date-selector-calendar-day never">';
            if (this.get_selectedDate() == null) {
                html += '<td colspan="7" class="date-selector-calendar-current">';
            }
            else {
                html += '<td colspan="7">';
            }
            html += '<a href="javascript:void(0);" data-date="never">'
            html += '<span class="date-selector-calendar-never">' + dsGlobal.get_terminology()['Never'] + '</span>';
            html += '</a></td></tr>';
        }
        html += '</table>';
        html += '</div>';

        if (allowForward && this.get_currentPeriodOnly()) {
            allowForward = !hasFutureDays;
        }

        headerHtml += '<div class="date-selector-calendar-outer">';

        headerHtml += '<ul class="date-selector-calendar-month-list">';
        headerHtml += '<li class="date-selector-calendar-navleft2x"><a' + (allowBackward2x ? '' : ' class="date-selector-calendar-nav-notallowed"') + ' href="javascript:void(0);">&nbsp;</a></li>';
        headerHtml += '<li class="date-selector-calendar-navleft"><a' + (allowBackward ? '' : ' class="date-selector-calendar-nav-notallowed"') + ' href="javascript:void(0);">&nbsp;</a></li>';
        headerHtml += '<li class="date-selector-calendar-month">';
        headerHtml += '<span class="date-selector-calendar-month-m">' + dsGlobal.get_terminology()['Months'][this.get_currentDate().getMonth()] + '</span>,&nbsp;';
        headerHtml += '<span class="date-selector-calendar-month-y">' + this.get_currentDate().getFullYear() + '</span>';
        headerHtml += '</li>';
        headerHtml += '<li class="date-selector-calendar-navright"><a' + (allowForward ? '' : ' class="date-selector-calendar-nav-notallowed"') + ' href="javascript:void(0);">&nbsp;</a></li>';
        headerHtml += '<li class="date-selector-calendar-navright2x"><a' + (allowForward2x ? '' : ' class="date-selector-calendar-nav-notallowed"') + ' href="javascript:void(0);">&nbsp;</a></li>';
        headerHtml += '</ul>';
        headerHtml += '<div class="date-selector-clear"></div>';

        headerHtml += '<table class="date-selector-calendar" cellspacing="0" cellpadding="0" border="0">';
        headerHtml += '<tr class="date-selector-calendar-weekdays">';

        html = headerHtml + html;

        this.get_container().innerHTML = html;

        Event.observe(this.get_container().getElementsByTagName('ul')[0], 'click', function (e) {
            var listItem = null;
            var changeDate = false;
            var currentDate = null;
            var elm = $(Event.element(e));
            var y = null, m = null, d = null;
            var tag = (elm.tagName || elm.nodeName).toLowerCase();

            if (tag == 'a') {
                currentDate = self.get_currentDate();

                y = currentDate.getFullYear();
                m = currentDate.getMonth();

                listItem = elm.up();

                if (!elm.hasClassName('date-selector-calendar-nav-notallowed')) {
                    if (listItem) {
                        if (listItem.hasClassName('date-selector-calendar-navleft')) {
                            m -= 1;
                            if (m < 0) {
                                m = 11;
                                y -= 1;
                            }

                            changeDate = true;
                        } else if (listItem.hasClassName('date-selector-calendar-navright')) {
                            m += 1;
                            if (m > 11) {
                                m = 0;
                                y += 1;
                            }

                            changeDate = true;
                        } else if (listItem.hasClassName('date-selector-calendar-navleft2x')) {
                            y -= 1;
                            changeDate = true;
                        } else if (listItem.hasClassName('date-selector-calendar-navright2x')) {
                            y += 1;
                            changeDate = true;
                        }
                    }
                }

                if (changeDate) {
                    self.notify('monthChanged', { month: m, year: y });

                    d = self._daysInMonth(m, y);

                    currentDate = new Date(y, m, d);
                    self.set_currentDate(currentDate);
                }

                Event.stop(e);
            }
        });

        Event.observe(this.get_container().getElementsByTagName('table')[0], 'click', function (e) {
            var dt = '';
            var attr = null;
            var dtObj = null;
            var elm = $(Event.element(e));
            var tag = (elm.tagName || elm.nodeName).toLowerCase();

            if (tag == 'a' || tag == 'span') {
                if (tag == 'span') {
                    elm = elm.up();
                }

                attr = elm.readAttribute('data-date');
                if (attr && attr.length) {
                    Event.stop(e);

                    dt = attr.split('-');
                    if (dt && dt.length) {
                        if (self.get_allowEmpty() && dt.length == 1) { // dt[0] == "never"
                            dtObj = null;
                        }
                        else {
                            dtObj = new Date(parseInt(dt[2], 10), parseInt(dt[1], 10), parseInt(dt[0], 10));
                        }

                        self.hide();

                        self.notify('dateChanged', { selectedDate: dtObj });
                        self._selectedDate = dtObj;
                    }
                }
            }
        });
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.hideAll = function () {
    /// <summary>Hides all calendars.</summary>

    var p = null;
    var outers = $$('.date-selector-calendar-outer');

    if (outers && outers.length) {
        for (var i = 0; i < outers.length; i++) {
            p = outers[i].parentNode || outers[i].parentElement;
            if (p) {
                p.style.display = 'none';
            }
        }
    }
}

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype.cumulativeOffset = function (element) {
    return element.cumulativeOffset();
};

Dynamicweb.Controls.OMC.DateSelector.Calendar.prototype._daysInMonth = function (month, year) {
    /// <summary>Returns the number of days in the given month.</summary>
    /// <param name="month">Month number.</param>
    /// <param name="year">Year number.</param>
    /// <private />

    return 32 - new Date(year, month, 32).getDate();
}

Dynamicweb.Controls.OMC.DateSelector.Calendar._onDocumentMouseDown = function (e) {
    /// <summary>Occurs when the user presses the mouse anywhere in the document.</summary>
    /// <param name="e">Event arguments.</param>
    /// <private />

    var elm = $(Event.element(e));

    if (!elm.up('.date-selector-calendar-outer')) {
        Dynamicweb.Controls.OMC.DateSelector.Calendar.hideAll();
    }
};

/* ++++++ End: Date calendar ++++++ */

/* ++++++ Date formatter ++++++ */

Dynamicweb.Controls.OMC.DateSelector.DateFormatter = function (format) {
    /// <summary>Represents a date formatter.</summary>
    /// <param name="format">Date format.</param>

    this._format = format || '';
    this._index = 0;
    this._tokens = null;

    this._evaluators = [
        { token: 'd', materialize: function (date) { return date.getDate().toString(); } },
        { token: 'dd', materialize: function (date) { var d = date.getDate(); return (d < 10) ? ('0' + d) : d.toString(); } },
        { token: 'h', materialize: function (date) { var h = date.getHours() + 1; if (h > 12) h -= 12; return h.toString(); } },
        { token: 'hh', materialize: function (date) { var h = date.getHours() + 1; if (h > 12) h -= 12; return (h < 10) ? ('0' + h) : h.toString(); } },
        { token: 'H', materialize: function (date) { return date.getHours().toString(); } },
        { token: 'HH', materialize: function (date) { var h = date.getHours(); return (h < 10) ? ('0' + h) : h.toString(); } },
        { token: 'm', materialize: function (date) { return date.getMinutes().toString(); } },
        { token: 'mm', materialize: function (date) { var m = date.getMinutes(); return (m < 10) ? ('0' + m) : m.toString(); } },
        { token: 'M', materialize: function (date) { return (date.getMonth() + 1).toString(); } },
        { token: 'MM', materialize: function (date) { var m = date.getMonth() + 1; return (m < 10) ? ('0' + m) : m.toString(); } },
        { token: 's', materialize: function (date) { return date.getSeconds().toString(); } },
        { token: 'ss', materialize: function (date) { var s = date.getSeconds(); return (s < 10) ? ('0' + s) : s.toString(); } },
        { token: 'yy', materialize: function (date) { var y = date.getFullYear(); return y.toString().substr(2); } },
        { token: 'yyyy', materialize: function (date) { return date.getFullYear().toString(); } }
    ];
}

Dynamicweb.Controls.OMC.DateSelector.DateFormatter.prototype.get_format = function () {
    /// <summary>Gets the date format.</summary>

    return this._format;
}

Dynamicweb.Controls.OMC.DateSelector.DateFormatter.prototype.set_format = function (value) {
    /// <summary>Sets the date format.</summary>
    /// <param name="value">Date format.</param>

    var val = (value && typeof (value) == 'string') ? value : '';

    if (val != this._format) {
        this._format = val;
        this._tokens = null;
    }
}

Dynamicweb.Controls.OMC.DateSelector.DateFormatter.prototype.format = function (date) {
    /// <summary>Formats the given date.</summary>
    /// <param name="date">Date to format.</param>

    var ret = '';
    var evaluator = null;

    if (date && typeof (date.getTime) == 'function') {
        if (this._tokens == null || !this._tokens.length) {
            this._tokens = this._tokenize();
        }

        if (this._tokens != null && this._tokens.length) {
            for (var i = 0; i < this._tokens.length; i++) {
                evaluator = null;

                for (var j = 0; j < this._evaluators.length; j++) {
                    if (this._evaluators[j].token == this._tokens[i]) {
                        evaluator = this._evaluators[j];
                        break;
                    }
                }

                if (evaluator) {
                    ret += evaluator.materialize(date);
                } else {
                    ret += this._tokens[i];
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.DateSelector.DateFormatter.prototype._tokenize = function () {
    /// <summary>Tokenizes the current date format.</summary>
    /// <private />

    var ret = [];
    var token = null;

    this._index = 0;

    if (!this.get_format() || typeof (this.get_format()) != 'string') {
        this.set_format('');
    }

    if (this.get_format().length) {
        do {
            token = this._nextToken();
            if (!token) {
                break;
            } else {
                ret[ret.length] = token;
            }
        } while (true);
    }

    return ret;
}

Dynamicweb.Controls.OMC.DateSelector.DateFormatter.prototype._nextToken = function () {
    /// <summary>Returns the next token or null if no more tokens can be retrieved.</summary>
    /// <private />

    var code = 0;
    var ret = null;
    var token = '';
    var isAlpha = false;
    var wasAlpha = false;
    var format = this.get_format() || '';
    var bounds = [
        { from: 'A'.charCodeAt(), to: 'Z'.charCodeAt() },
        { from: 'a'.charCodeAt(), to: 'z'.charCodeAt() }
    ];

    if (this._index < format.length) {
        for (var i = this._index; i < format.length; i++) {
            code = format.charCodeAt(i);
            isAlpha = (code >= bounds[0].from && code <= bounds[0].to) ||
                (code >= bounds[1].from && code <= bounds[1].to);

            if (isAlpha) {
                if (!wasAlpha) {
                    if (token.length > 0) {
                        break;
                    } else {
                        wasAlpha = true;
                    }
                }

                token += format.charAt(i);
            } else {
                if (wasAlpha) {
                    break;
                } else {
                    token += format.charAt(i);
                }
            }
        }

        this._index = i;
    }

    ret = token;

    return ret;
}

/* ++++++ End: Date formatter ++++++ */

Dynamicweb.Controls.OMC.DateSelector.prototype.get_formatter = function () {
    /// <summary>Gets the object that is responsible for formatting the selected date according to the current format.</summary>

    if (this._formatter == null) {
        this._formatter = new Dynamicweb.Controls.OMC.DateSelector.DateFormatter(this.get_dateFormat());
    }

    return this._formatter;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_calendar = function () {
    /// <summary>Gets the reference to associated calendar object.</summary>

    if (this._calendar == null && this.get_container() != null) {
        this._calendar = new Dynamicweb.Controls.OMC.DateSelector.Calendar(this.get_container().select('.date-selector-calendar')[0]);
        this._calendar.set_culture(this.get_culture());
        this._calendar.set_currentPeriodOnly(this.get_currentPeriodOnly());
    }

    return this._calendar;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return Dynamicweb.Controls.OMC.DateSelector.Global.terminology;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_culture = function () {
    /// <summary>Gets the culture information.</summary>

    return this._culture;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.set_culture = function (value) {
    /// <summary>Sets the culture information.</summary>
    /// <param name="value">The culture information.</param>

    this._culture = value;

    if (!value || typeof (value.get_firstDayOfWeek) != 'function') {
        this._culture = new Dynamicweb.Controls.OMC.DateSelectorCulture();
    }
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_currentPeriodOnly = function () {
    /// <summary>Gets value indicating whether to prohibit user from selecting days that are in the future.</summary>

    return this._currentPeriodOnly;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.set_currentPeriodOnly = function (value) {
    /// <summary>Sets value indicating whether to prohibit user from selecting days that are in the future.</summary>

    this._currentPeriodOnly = !!value;

    if (this._currentPeriodOnly && this.get_selectedDate() && this.get_selectedDate().getTime() > new Date().getTime()) {
        this.set_selectedDate(new Date(), true);
    }
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_dateFormat = function () {
    /// <summary>Gets the date format.</summary>

    return this._dateFormat;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.set_dateFormat = function (value) {
    /// <summary>Sets the date format.</summary>
    /// <param name="value">The date format.</param>

    this._dateFormat = value;
    this.get_formatter().set_format(value);
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_allowEmpty = function () {
    return this._allowEmpty;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.set_allowEmpty = function (value) {
    this._allowEmpty = value;

    if (this.get_calendar() != null) {
        this.get_calendar().set_allowEmpty(value);
    }
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_offset = function () {
    /// <summary>Gets the initial calendar offset.</summary>

    return this._offset;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.set_offset = function (value) {
    /// <summary>Sets the initial calendar offset.</summary>
    /// <param name="value">The initial calendar offset.</param>

    this._offset = value;

    if (this.get_calendar() != null) {
        this.get_calendar().set_offset(value);
    }
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_includeTime = function () {
    /// <summary>Gets value indicating whether user can choose time.</summary>

    return this._includeTime;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.set_includeTime = function (value) {
    /// <summary>Sets value indicating whether user can choose time.</summary>
    /// <param name="value">Value indicating whether user can choose time.</param>

    this._includeTime = !!value;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_selectedHour = function () {
    /// <summary>Gets the selected hour.</summary>

    var ret = 0;

    if (this.get_includeTime() && this.get_selectedHourControl()) {
        ret = parseInt(this.get_selectedHourControl().value);

        if (isNaN(ret) || ret == null || ret < 0) {
            ret = 0;
        } else if (ret > 23) {
            ret = 23;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.set_selectedHour = function (value, notifyClients) {
    /// <summary>Gets the selected hour.</summary>
    /// <param name="value">Selected hour.</param>

    if (typeof (notifyClients) == 'undefined' || notifyClients == null) {
        notifyClients = true;
    }

    if (this.get_includeTime() && this.get_selectedHourControl()) {
        value = parseInt(value);

        if (isNaN(value) || value == null || value < 0) {
            value = 0;
        } else if (value > 23) {
            value = 23;
        }

        value = value.toString();

        if (value.length < 2) {
            value = '0' + value;
        }

        this.get_selectedHourControl().value = value.toString();

        if (notifyClients) {
            this.raiseEvent('dateChanged', { selectedDate: this.get_selectedDate() });
        }
    }
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_selectedMinute = function () {
    /// <summary>Gets the selected minute.</summary>

    var ret = 0;

    if (this.get_includeTime() && this.get_selectedMinuteControl()) {
        ret = parseInt(this.get_selectedMinuteControl().value);

        if (isNaN(ret) || ret == null || ret < 0) {
            ret = 0;
        } else if (ret > 59) {
            ret = 59;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.set_selectedMinute = function (value, notifyClients) {
    /// <summary>Gets the selected minute.</summary>
    /// <param name="value">Selected minute.</param>

    if (typeof (notifyClients) == 'undefined' || notifyClients == null) {
        notifyClients = true;
    }

    if (this.get_includeTime() && this.get_selectedMinuteControl()) {
        value = parseInt(value);

        if (isNaN(value) || value == null || value < 0) {
            value = 0;
        } else if (value > 59) {
            value = 59;
        }

        value = value.toString();

        if (value.length < 2) {
            value = '0' + value;
        }

        this.get_selectedMinuteControl().value = value;

        if (notifyClients) {
            this.raiseEvent('dateChanged', { selectedDate: this.get_selectedDate() });
        }
    }
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_selectedDate = function () {
    /// <summary>Gets the currently selected date.</summary>

    var ret = this.get_allowEmpty() ? null : new Date();
    var hour = 0, minute = 0;

    if (this.get_selectedDateControl() && this._selectedDate != null) {
        ret = this._selectedDate;

        if (!this.get_selectedDateControl().value.length) {
            this.get_selectedDateControl().value = this.formatDate(this._selectedDate, this.get_dateFormat());
        }

        if (this.get_includeTime()) {
            hour = this.get_selectedHour();
            minute = this.get_selectedMinute();

            ret = new Date(ret.getFullYear(), ret.getMonth(), ret.getDate(), hour, minute, 0, 0);
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.set_selectedDate = function (value, notifyClients) {
    /// <summary>Sets the currently selected date.</summary>
    /// <param name="value">The currently selected date.</param>
    /// <param name="notifyClients">Indicates whether to notify clients about the fact that the date has been updated.</param>

    var strValue = '';

    if (typeof (notifyClients) == 'undefined' || notifyClients == null) {
        notifyClients = true;
    }

    if (this.get_allowEmpty() || (value != null && typeof (value.getTime) == 'function')) {
        this._selectedDate = value;
        if (value != null) {
            strValue = this.formatDate(value, this.get_dateFormat());
        }

        if (this.get_selectedDateControl()) {
            this.get_selectedDateControl().value = strValue;

            if (!this.get_isReady()) {
                this.initialize();
            }

            this.get_state().label.innerHTML = strValue;
        }
    }

    if (this.get_calendar() != null) {
        this.get_calendar().set_currentDate(this.get_selectedDate());
        this.get_calendar().set_selectedDate(this.get_selectedDate());
    }

    if (notifyClients) {
        this.raiseEvent('dateChanged', { selectedDate: this.get_selectedDate() });
    }
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_selectedDateControl = function () {
    /// <summary>Gets the reference to DOM element representing a selected date value holder.</summary>

    if (!this._selectedDateControl && this.get_container() && this.get_container().id) {
        this._selectedDateControl = this.get_container().select('input.date-selector-date');
        if (this._selectedDateControl && this._selectedDateControl.length) {
            this._selectedDateControl = this._selectedDateControl[0];
        }
    }

    return this._selectedDateControl;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_selectedHourControl = function () {
    /// <summary>Gets the reference to DOM element representing a selected hour value holder.</summary>

    if (!this._selectedHourControl && this.get_container() && this.get_container().id) {
        this._selectedHourControl = this.get_container().select('input.date-selector-time-hour');
        if (this._selectedHourControl && this._selectedHourControl.length) {
            this._selectedHourControl = this._selectedHourControl[0];
        }
    }

    return this._selectedHourControl;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.get_selectedMinuteControl = function () {
    /// <summary>Gets the reference to DOM element representing a selected minute value holder.</summary>

    if (!this._selectedMinuteControl && this.get_container() && this.get_container().id) {
        this._selectedMinuteControl = this.get_container().select('input.date-selector-time-minute');
        if (this._selectedMinuteControl && this._selectedMinuteControl.length) {
            this._selectedMinuteControl = this._selectedMinuteControl[0];
        }
    }

    return this._selectedMinuteControl;
}

Dynamicweb.Controls.OMC.DateSelector.prototype.add_dateChanged = function (handler) {
    /// <summary>Registers new handler which is executed when selected date changes.</summary>
    /// <param name="handler">Handler to register.</param>

    this.addEventHandler('dateChanged', handler);
}

Dynamicweb.Controls.OMC.DateSelector.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;
    var clicked = function (e) {
        Event.stop(e);

        if (self.get_calendar() && self.get_isEnabled()) {
            self.get_calendar().set_currentDate(self.get_selectedDate());
            self.get_calendar().set_selectedDate(self.get_selectedDate());
        }

        self.get_calendar().show();
    }

    this.add_propertyChanged(function (sender, args) {
        if (args.name == 'isEnabled') {
            if (self.get_container()) {
                if (args.value) {
                    self.get_container().removeClassName('date-selector-disabled');
                } else {
                    self.get_container().addClassName('date-selector-disabled');
                }

                if (self.get_includeTime()) {
                    if (self.get_selectedHourControl()) {
                        self.get_selectedHourControl().disabled = !args.value;
                    }

                    if (self.get_selectedMinuteControl()) {
                        self.get_selectedMinuteControl().disabled = !args.value;
                    }
                }
            }
        }
    });

    this.get_state().label = $($(this.get_container()).select('.date-selector-label')[0]);
    this.get_state().button = $($(this.get_container()).select('.date-selector-button')[0]);

    Event.observe(this.get_state().label, 'click', clicked);
    Event.observe(this.get_state().button, 'click', clicked);

    if (this.get_includeTime()) {
        if (this.get_selectedHourControl()) {
            Event.observe(this.get_selectedHourControl(), 'blur', function (e) { self.set_selectedHour(Event.element(e).value); });
            Event.observe(this.get_selectedHourControl(), 'paste', function (e) { self.set_selectedHour(Event.element(e).value); });
        }

        if (this.get_selectedMinuteControl()) {
            Event.observe(this.get_selectedMinuteControl(), 'blur', function (e) { self.set_selectedMinute(Event.element(e).value); });
            Event.observe(this.get_selectedMinuteControl(), 'paste', function (e) { self.set_selectedMinute(Event.element(e).value); });
        }
    }

    this.get_calendar().set_handle(this.get_state().button);

    this.get_calendar().add_dateChanged(function (sender, args) {
        self.set_selectedDate(args.selectedDate);
    });
}

Dynamicweb.Controls.OMC.DateSelector.prototype.formatDate = function (date, format) {
    /// <summary>Formats the given date according to the given format and returns date string.</summary>
    /// <param name="date">Date to format.</param>
    /// <param name="format">Date format.</param>

    var ret = '';
    var prevFormat = '';
    var dateToFormat;

    if (!format || !format.length) {
        format = this._defaultDateFormat;
    }

    if (date === null || (!date && typeof (date.getTime) !== 'function')) {
        if (!this.get_allowEmpty()) {
            dateToFormat = new Date();
        }
    } else {
        dateToFormat = date;
    }

    prevFormat = this.get_formatter().get_format();
    this.get_formatter().set_format(format);

    ret = this.get_formatter().format(dateToFormat);
    this.get_formatter().set_format(prevFormat);

    return ret;
}