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

Dynamicweb.Controls.OMC.WeekOverviewCulture = function (params) {
    /// <summary>Provides culture-sensitive information for the WeekOverview control.</summary>
    /// <param name="params">Initialization parameters.</param>

    this._firstDayOfWeek = 'monday';

    if (params) {
        if (typeof (params.firstDayOfWeek) != 'undefined') {
            this.set_firstDayOfWeek(params.firstDayOfWeek);
        }
    }
}

Dynamicweb.Controls.OMC.WeekOverviewCulture.prototype.get_firstDayOfWeek = function () {
    /// <summary>Gets the first day of week.</summary>

    return this._firstDayOfWeek;
}

Dynamicweb.Controls.OMC.WeekOverviewCulture.prototype.set_firstDayOfWeek = function (value) {
    /// <summary>Sets the first day of week.</summary>
    /// <param name="value">First day of week.</param>

    this._firstDayOfWeek = (value && value.length) ? value.toLowerCase() : 'monday';
}

Dynamicweb.Controls.OMC.WeekOverviewSelection = function (startDate, endDate, culture) {
    /// <summary>Represents a selection within WeekOverview control.</summary>
    /// <param name="startDate">Start date.</param>
    /// <param name="endDate">End date.</param>
    /// <param name="culture">Culture settings.</param>

    var temp = null;
    var end = endDate;
    var start = startDate;

    if (!start || typeof (start.getTime) != 'function') start = new Date();
    if (!end || typeof (end.getTime) != 'function') end = start;

    this._culture = culture;

    if (!this._culture || typeof (this._culture.get_firstDayOfWeek) != 'function') {
        this._culture = new Dynamicweb.Controls.OMC.WeekOverviewCulture();
    }

    end = new Date(end.getFullYear(), end.getMonth(), end.getDate(), 23, 59, 59, 999);
    start = new Date(start.getFullYear(), start.getMonth(), start.getDate(), 0, 0, 0, 0);

    if (start.getTime() > end.getTime()) {
        tmp = new Date(start.getTime());
        start = new Date(end.getTime());
        end = new Date(tmp.getTime());
    }

    this._startDate = start;
    this._endDate = end;
    this._week = null;
    this._days = null;
    this._postedValueDateFormat = 'dd-MM-yyyy';

    if (start.getFullYear() != end.getFullYear() || Dynamicweb.Controls.OMC.WeekOverviewSelection.getWeekOfYear(start, this._culture) != Dynamicweb.Controls.OMC.WeekOverviewSelection.getWeekOfYear(end, this._culture)) {
        if (start.getFullYear() != end.getFullYear() || start.getMonth() != end.getMonth() || (start.getMonth() != 0 && start.getMonth() != 11) || Math.abs(start.getDay() - end.getDay()) > 2) {
            Dynamicweb.Ajax.Control.error('Start date and end date represent different weeks or different years. Both start date and end date must be within the same year as well as the same week of the year.');    
        }
        
        this._endDate = this._startDate;
    }
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.current = function (culture) {
    /// <summary>Gets the selection that corresponds to the current day.</summary>
    /// <param name="culture">Target culture.</param>

    return new Dynamicweb.Controls.OMC.WeekOverviewSelection(new Date(), null, culture);
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.firstDayOfWeek = function (weekNumber, culture) {
    /// <summary>Gets the selection that corresponds to the first day of the given week.</summary>
    /// <param name="weekNumber">Week number.</param>
    /// <param name="culture">Target culture.</param>

    var selection = null;
    var startDate = null;
    var targetDate = null;
    var dtNow = new Date();
    var curSelection = null;

    if (weekNumber <= 0) {
        weekNumber = 1;
    }

    startDate = new Date(dtNow.getTime());

    if (Dynamicweb.Controls.OMC.WeekOverviewSelection.getWeekOfYear(startDate, culture) != weekNumber) {
        startDate = new Date(dtNow.getFullYear(), 0, 1);

        do {
            if (startDate.getFullYear() != dtNow.getFullYear()) {
                break;
            } else {
                if (Dynamicweb.Controls.OMC.WeekOverviewSelection.getWeekOfYear(startDate, culture) == weekNumber) {
                    targetDate = startDate;
                    break;
                } else {
                    startDate = Dynamicweb.Controls.OMC.WeekOverview._nextWeek(startDate);
                }
            }
        } while (true);
    }

    if (targetDate == null) {
        targetDate = dtNow;
    } 

    curSelection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(targetDate, null, culture);
    while (curSelection.get_days()[0] != culture.get_firstDayOfWeek()) {
        targetDate = Dynamicweb.Controls.OMC.WeekOverview._previousDay(targetDate);
        curSelection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(targetDate, targetDate, culture);
    }

    targetDate = curSelection.get_startDate();
    selection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(targetDate, null, culture);

    return selection;
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.getWeekOfYear = function (timestamp, culture) {
    /// <summary>Gets year week number for a given date.</summary>
    /// <param name="timestamp">Target date.</param>
    /// <param name="culture">Target culture.</param>

    var ret = -1;
    var dt = null;
    var yearStart = null;
    var accumulate = null, accumulateLY = null;

    /* +++
        Thanks to http://www.onlineconversion.com/day_week_number.htm 
     ---*/

    var y2k = function (number) {
        return (number < 1000) ? number + 1900 : number;
    }

    var makeArray = function () {
        this[0] = makeArray.arguments.length;

        for (i = 0; i < makeArray.arguments.length; i++) {
            this[i + 1] = makeArray.arguments[i];
        }
    }

    var leafYear = function (year) {
        year = y2k(year);
        return (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) ? true : false;
    }

    var getJulian = function (day, month, year) {
        return (LeapYear(year) ? (day + accumulateLY[month]) : (day + accumulate[month]));
    }

    var getWeekUs = function (day, month, year) {
        var ret = 1;
        var prevOffset = 0;
        var prevNewYear = 0;
        var offset = 0, dayNum = 0;
        var when = null, newYear = null;

        year = y2k(year);

        when = new Date(year, month, day);
        newYear = new Date(year, 0, 1);

        offset = 7 + 1 - newYear.getDay();

        dayNum = ((Date.UTC(y2k(year), when.getMonth(), when.getDate(), 0, 0, 0) - Date.UTC(y2k(year), 0, 1, 0, 0, 0)) / 1000 / 60 / 60 / 24) + 1;
        ret = Math.floor((dayNum - offset + 14) / 7);

        return ret;
    }

    var getWeek = function (dt) {
        var dayNum = 0;
        var ret = 0, day = 0;
        var nYear = 0, nDay = 0;
        var prevYear = 0, prevDay = 0;
        var newYear = new Date(dt.getFullYear(), 0, 1);

        var isLeapYear = function (year) {
            return new Date(year, 2 - 1, 29).getDate() == 29;
        }

        day = newYear.getDay() - 1;
        day = (day >= 0 ? day : day + 7);
        dayNum = Math.floor((dt.getTime() - newYear.getTime() - (dt.getTimezoneOffset() - newYear.getTimezoneOffset()) * 60000) / 86400000) + 1;

        if (day < 4) {
            ret = Math.floor((dayNum + day - 1) / 7) + 1;
            if (ret > 52) {
                nYear = new Date(dt.getFullYear() + 1, 0, 1);

                nDay = nYear.getDay() - 1;
                nDay = nDay >= 0 ? nDay : nDay + 7;

                ret = nDay < 4 ? 1 : 53;
            }
        }
        else {
            ret = Math.floor((dayNum + day - 1) / 7);
            if (ret == 0) {
                prevYear = new Date(dt.getFullYear() - 1, 0, 1);

                prevDay = prevYear.getDay() - 1;
                prevDay = (prevDay >= 0 ? prevDay : prevDay + 7);

                if (prevDay == 3 || (isLeapYear(prevYear.getFullYear()) && prevDay == 2)) {
                    ret = 53;
                } else {
                    ret = 52;
                }
            }
        }

        return ret;
    }

    accumulate = new makeArray(0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334);
    accumulateLY = new makeArray(0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335);

    if (!culture || typeof (culture.get_firstDayOfWeek) != 'function') {
        culture = Dynamicweb.Controls.OMC.WeekOverviewCulture();
    }

    if (timestamp && typeof (timestamp.getTime) == 'function') {
        if (culture.get_firstDayOfWeek() != 'sunday') {
            ret = getWeek(timestamp);
        } else {
            ret = getWeekUs(timestamp.getDate(), timestamp.getMonth(), timestamp.getYear());
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.parse = function (data, culture) {
    /// <summary>Parses the week overview selection from the given literal string.</summary>
    /// <param name="data">String to parse from.</param>
    /// <param name="culture">Target culture.</param>

    var ret = null;
    var range = [];
    var start = null, end = null;

    var parseDate = function (str) {
        var result = null;
        var dateComponents = [];

        var removePadding = function (num) {
            var ret = num.toString();

            if (ret.indexOf('0') == 0 && ret.length > 1) {
                ret = ret.substr(1);
            }

            return ret;
        }

        if (str && str.length) {
            dateComponents = str.split('-');
            if (dateComponents && dateComponents.length > 2) {
                result = new Date(parseInt(removePadding(dateComponents[2])) || 1, 
                    parseInt(removePadding(dateComponents[1])) - 1 || 0, parseInt(removePadding(dateComponents[0])) || 1);
            }
        }

        return result;
    }

    if (data && data.length) {
        if (!culture || typeof (culture.get_firstDayOfWeek) != 'function') {
            culture = new Dynamicweb.Controls.OMC.WeekOverviewCulture();
        }

        range = data.split(',');
        if (range && range.length) {
            start = parseDate(range[0]);
            if (start) {
                if (range.length > 1) {
                    end = parseDate(range[1]);
                }

                ret = new Dynamicweb.Controls.OMC.WeekOverviewSelection(start, end, culture);
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.prototype.get_culture = function () {
    /// <summary>Gets the culture information.</summary>

    return this._culture;
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.prototype.get_startDate = function () {
    /// <summary>Gets the start date.</summary>

    return this._startDate;
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.prototype.get_endDate = function () {
    /// <summary>Gets the end date.</summary>

    return this._endDate;
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.prototype.get_week = function () {
    /// <summary>Gets the year week number.</summary>

    if (this._week == null) {
        this._week = Dynamicweb.Controls.OMC.WeekOverviewSelection.getWeekOfYear(this.get_startDate(), this.get_culture());
    }

    return this._week;
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.prototype.get_days = function () {
    /// <summary>Gets the list of days that fall within the given selection.</summary>

    var day = null;
    var self = this;
    var start = null;
    var prevDay = null;
    var daysToNames = null;

    var containsDay = function (days, checkDay) {
        var ret = false;

        if (days && days.length) {
            for (var i = 0; i < days.length; i++) {
                if (days[i] == checkDay) {
                    ret = true;
                    break;
                }
            }
        }

        return ret;
    }

    var getDayFromMonday = function (dt) {
        var result = dt.getDay() || 7;

        if (self.get_culture().get_firstDayOfWeek() == 'monday') result -= 1;
        else if (self.get_culture().get_firstDayOfWeek() == 'sunday' && result == 7) result = 0;

        return result;
    }

    if (this._days == null) {
        if (this.get_culture().get_firstDayOfWeek() == 'monday') {
            daysToNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        } else if (this.get_culture().get_firstDayOfWeek() == 'sunday') {
            daysToNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        }

        this._days = [];

        start = this.get_startDate();

        do {
            day = getDayFromMonday(start);

            if ((Dynamicweb.Controls.OMC.WeekOverviewSelection.getWeekOfYear(start, this.get_culture()) !=
                Dynamicweb.Controls.OMC.WeekOverviewSelection.getWeekOfYear(this.get_endDate(), this.get_culture())) ||
                (prevDay != null && prevDay > day)) {

                break;
            } else {
                if (day >= 0 && day < daysToNames.length) {
                    if (!containsDay(this._days, daysToNames[day].toLowerCase())) {
                        this._days[this._days.length] = daysToNames[day].toLowerCase();
                    }
                }

                prevDay = day;
                start = Dynamicweb.Controls.OMC.WeekOverview._nextDay(start);
            }
        } while (getDayFromMonday(start) <= getDayFromMonday(this.get_endDate()));
    }

    return this._days;
}

Dynamicweb.Controls.OMC.WeekOverviewSelection.prototype.toString = function () {
    /// <summary>Returns a string representation of the current selection.</summary>

    var end = this.get_endDate();
    var start = this.get_startDate();

    var withZero = function (num) {
        var result = num.toString();

        if (result.length < 2) {
            if (!result.length) {
                result = '00';
            } else {
                result = '0' + result;
            }
        }

        return result;
    }

    return withZero(start.getDate()) + '-' + withZero(start.getMonth() + 1) + '-' + withZero(start.getFullYear()) + ',' +
        withZero(end.getDate()) + '-' + withZero(end.getMonth() + 1) + '-' + withZero(end.getFullYear());
}

Dynamicweb.Controls.OMC.WeekOverview = function () {
    /// <summary>Represents a week overview control.</summary>

    this._culture = null;
    this._selection = null;
    this._dayTitleFormat = '';
    this._dayDetailsFormat = '';
    this._currentPeriodOnly = true;
    this._shiftPressed = false;
    this._stickToSelection = null;
    this._widthCalculationTimeout = null;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype = new Dynamicweb.Ajax.Control();

/* ++++++ Global utility object ++++++ */

// Represents a global utility object.
Dynamicweb.Controls.OMC.WeekOverview.Global = new Object();
Dynamicweb.Controls.OMC.WeekOverview.Global._terminology = {};

Dynamicweb.Controls.OMC.WeekOverview.Global.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return Dynamicweb.Controls.OMC.WeekOverview.Global._terminology;
}

Dynamicweb.Controls.OMC.WeekOverview.Global.translateDay = function (qualifier) {
    /// <summary>Returns a translated message for day.</summary>
    /// <param name="qualifier">Day qualifier.</param>

    return Dynamicweb.Controls.OMC.WeekOverview.Global._translate('Days', qualifier);
}

Dynamicweb.Controls.OMC.WeekOverview.Global.translateShortMonth = function (qualifier) {
    /// <summary>Returns a translated message for short month.</summary>
    /// <param name="qualifier">Short month qualifier.</param>

    return Dynamicweb.Controls.OMC.WeekOverview.Global._translate('MonthsShort', qualifier);
}

Dynamicweb.Controls.OMC.WeekOverview.Global._translate = function (key, qualifier) {
    /// <summary>Returns a translated message for the given item within the given collection.</summary>
    /// <param name="key">Collection key.</param>
    /// <param name="qualifier">Item qualifier.</param>
    /// <private />

    var ret = '';
    var days = Dynamicweb.Controls.OMC.WeekOverview.Global.get_terminology()[key];

    if (typeof (qualifier) == 'number') {
        if (qualifier >= 0 && qualifier < days.length) {
            ret = days[qualifier].value;
        }
    } else if (typeof (qualifier) == 'string') {
        qualifier = qualifier.toLowerCase();

        for (var i = 0; i < days.length; i++) {
            if (days[i].name == qualifier) {
                ret = days[i].value;
                break;
            }
        }
    }

    return ret;
}

/* ++++++ End: Global utility object ++++++ */

Dynamicweb.Controls.OMC.WeekOverview.prototype.get_dayTitleFormat = function () {
    /// <summary>Gets the format of the message that is displayed when the user places the mouse over the week day.</summary>

    return this._dayTitleFormat;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.set_dayTitleFormat = function (value) {
    /// <summary>Sets the format of the message that is displayed when the user places the mouse over the week day.</summary>
    /// <param name="value">The format of the message that is displayed when the user places the mouse over the week day.</param>

    this._dayTitleFormat = value;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.get_dayDetailsFormat = function () {
    /// <summary>Gets the format that is used to display day details (month and date).</summary>

    return this._dayDetailsFormat;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.set_dayDetailsFormat = function (value) {
    /// <summary>Sets the format that is used to display day details (month and date).</summary>
    /// <param name="value">The format that is used to display day details (month and date).</param>

    this._dayDetailsFormat = value;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.get_currentPeriodOnly = function () {
    /// <summary>Gets value indicating whether to prohibit user from selecting days that are in the future.</summary>

    return this._currentPeriodOnly;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.set_currentPeriodOnly = function (value) {
    /// <summary>Sets value indicating whether to prohibit user from selecting days that are in the future.</summary>
    /// <param name="value">Value indicating whether to prohibit user from selecting days that are in the future.</param>

    var nowDate = new Date();

    this._currentPeriodOnly = !!value;

    if (this._initialized) {
        if (this.get_selection().get_endDate().getFullYear() > nowDate.getFullYear() ||
            (this.get_selection().get_endDate().getFullYear() == nowDate.getFullYear() && this.get_selection().get_endDate().getMonth() > nowDate.getMonth()) ||
            (this.get_selection().get_endDate().getFullYear() == nowDate.getFullYear() && this.get_selection().get_endDate().getMonth() == nowDate.getMonth() && this.get_selection().get_endDate().getDate() > nowDate.getDate())) {

            this._updateSelection(Dynamicweb.Controls.OMC.WeekOverviewSelection.current(this.get_culture()), false);
        }

        this._updateWeekdaysMeta(this.get_selection());
    }
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.get_culture = function () {
    /// <summary>Gets the culture information.</summary>

    return this._culture;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.set_culture = function (value) {
    /// <summary>Sets the culture information.</summary>
    /// <param name="value">The culture information.</param>

    this._culture = value;

    if (!value || typeof (value.get_firstDayOfWeek) != 'function') {
        this._culture = new Dynamicweb.Controls.OMC.WeekOverviewCulture();
    }
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.get_selection = function () {
    /// <summary>Gets the current selection.</summary>

    if (this._selection == null) {
        if (typeof (this.get_state().selection) != 'undefined') {
            this._selection = Dynamicweb.Controls.OMC.WeekOverviewSelection.parse(this.get_state().selection.value, this.get_culture());
        }
    }

    return this._selection;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.set_selection = function (value) {
    /// <summary>Sets the current selection.</summary>
    /// <param name="value">Current selection.</param>

    this._updateSelection(value, true);
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.add_selectionChanged = function (handler) {
    /// <summary>Registers new handler which is executed when selection changes.</summary>
    /// <param name="handler">Handler to register.</param>

    this.addEventHandler('selectionChanged', handler);
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.add_weekChanged = function (handler) {
    /// <summary>Registers new handler which is executed when current week changes.</summary>
    /// <param name="handler">Handler to register.</param>

    this.addEventHandler('weekChanged', handler);
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.nextWeek = function () {
    /// <summary>Moves the overview to a next week.</summary>

    this._changeWeek(1, true);
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.previousWeek = function () {
    /// <summary>Moves the overview to a previous week.</summary>

    this._changeWeek(-1, true);
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.today = function () {
    /// <summary>Changes the selection to be todays date.</summary>

    this.set_selection(new Dynamicweb.Controls.OMC.WeekOverviewSelection(new Date(), null, this.get_culture()));
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;
    var selection = null;

    /* Initializing cache */
    if (this.get_container()) {
        this.get_state().nextWeekButton = this.get_container().select('a.week-overview-navigate-forward');
        this.get_state().prevWeekButton = this.get_container().select('a.week-overview-navigate-back');
        this.get_state().weekdays = this.get_container().select('div.week-overview-days ul.week-overview-days-list li a');
        this.get_state().weekdaysList = $(this.get_container().select('div.week-overview-days ul.week-overview-days-list')[0]);
        this.get_state().selection = $(this.get_container().select('input.week-overview-selection')[0]);

        /* Navigation between weeks can be disabled so that's why there is a check */
        if (this.get_state().nextWeekButton && this.get_state().nextWeekButton.length) this.get_state().nextWeekButton = $(this.get_state().nextWeekButton[0]); else this.get_state().nextWeekButton = null;
        if (this.get_state().prevWeekButton && this.get_state().prevWeekButton.length) this.get_state().prevWeekButton = $(this.get_state().prevWeekButton[0]); else this.get_state().prevWeekButton = null;
    }

    this.add_propertyChanged(function (sender, args) {
        if (args.name == 'isEnabled') {
            if (args.value) {
                self.get_container().removeClassName('week-overview-disabled');
            } else {
                self.get_container().addClassName('week-overview-disabled');
            }
        }
    });

    if (typeof (this.get_state().selection) != 'undefined') {
        if (this.get_state().weekdaysList) {
            Event.observe(this.get_state().weekdaysList, 'click', function (e) {
                if (self._shiftPressed) {
                    Event.stop(e);
                }
            });

            Event.observe(this.get_state().weekdaysList, 'mousedown', function (e) {
                var t = '';
                var target = Event.element(e);

                var tagName = function (node) {
                    return (node != null ? (typeof (node.nodeName) != 'undefined' ? node.nodeName : node.tagName) : '').toLowerCase();
                }

                t = tagName(target);

                if (t && t.length) {
                    if (t != 'a') {
                        target = $(target).up('.week-overview-day-link');
                        if (target) {
                            t = tagName(target);
                        }
                    }

                    if (t == 'a' && self._canUpdateSelectionFromNode(target)) {
                        self._updateSelectionFromNode(target, true);
                        if (self._shiftPressed) {
                            Event.stop(e);
                        }
                    }
                }
            });
        }

        if (this.get_state().prevWeekButton) {
            Event.observe(this.get_state().prevWeekButton, 'mousedown', function (e) {
                var target = Event.element(e);

                if (self._canChangeWeekFromNode(target)) {
                    self._changeWeek(-1, true);
                }
            });
        }

        if (this.get_state().nextWeekButton) {
            Event.observe(this.get_state().nextWeekButton, 'mousedown', function (e) {
                var target = Event.element(e);

                if (self._canChangeWeekFromNode(target)) {
                    self._changeWeek(1, true);
                }
            });
        }
    }

    Event.observe(document.body, 'keydown', function (e) {
        var code = (typeof (e.keyCode) != 'undefined' ? e.keyCode : (typeof (e.charCode) != 'undefined' ? e.charCode : e.which));

        if (code == 16) {
            self._shiftPressed = true;
        }
    });

    Event.observe(document.body, 'keyup', function (e) {
        var code = (typeof (e.keyCode) != 'undefined' ? e.keyCode : (typeof (e.charCode) != 'undefined' ? e.charCode : e.which));

        if (code == 16) {
            self._shiftPressed = false;
        }

    });

    /* Updating selection */
    selection = Dynamicweb.Controls.OMC.WeekOverviewSelection.parse(this.get_state().selection.value, this.get_culture());

    this._updateSelection(selection, false);
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.onSelectionChanged = function (e) {
    /// <summary>Fires "selectionChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.raiseEvent('selectionChanged', e);
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.onWeekChanged = function (e) {
    /// <summary>Fires "weekChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.raiseEvent('weekChanged', e);
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.formatDayAndWeek = function (selection, defaultValue) {
    /// <summary>Formats day title message.</summary>
    /// <param name="selection">Current selection.</param>
    /// <param name="defaultValue">Default value.</param>

    var day = '';
    var ret = defaultValue;

    if (selection && this.get_dayTitleFormat() && this.get_dayTitleFormat().length) {
        day = selection.get_days()[0];
        if (day && day.length) {
            ret = this.get_dayTitleFormat();

            ret = ret.replace('{Day}', Dynamicweb.Controls.OMC.WeekOverview.Global.translateDay(day));
            ret = ret.replace('{Week}', selection.get_week());
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype.formatDayAndMonth = function (selection, defaultValue) {
    /// <summary>Formats day and month.</summary>
    /// <param name="selection">Current selection.</param>
    /// <param name="defaultValue">Default value.</param>

    var day = '';
    var dt = null;
    var ret = defaultValue;

    if (selection && this.get_dayDetailsFormat() && this.get_dayDetailsFormat().length) {
        dt = selection.get_startDate();

        ret = this.get_dayDetailsFormat();

        ret = ret.replace('{Month}', Dynamicweb.Controls.OMC.WeekOverview.Global.translateShortMonth(dt.getMonth()));
        ret = ret.replace('{Day}', dt.getDate());
    }

    return ret;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype._updateWeekdaysMeta = function (selection) {
    /// <summary>Updates weekdays metadata.</summary>
    /// <param name="selection">New selection.</param>
    /// <private />

    var self = this;
    var link = null;
    var details = null;
    var firstDay = null;
    var containerWidth = 0;
    var linkSelection = null;
    var nowDate = new Date();
    var isBackAllowed = true;
    var isForwardAllowed = true;

    var isFuture = function (sel) {
        return sel.get_endDate().getFullYear() > nowDate.getFullYear() ||
            (sel.get_endDate().getFullYear() == nowDate.getFullYear() && sel.get_endDate().getMonth() > nowDate.getMonth()) ||
            (sel.get_endDate().getFullYear() == nowDate.getFullYear() && sel.get_endDate().getMonth() == nowDate.getMonth() && sel.get_endDate().getDate() > nowDate.getDate());
    }

    if (!selection || typeof (selection.get_days) != 'function') {
        selection = this.get_selection();
    }

    if (!selection || typeof (selection.get_days) != 'function') {
        selection = Dynamicweb.Controls.OMC.WeekOverviewSelection.current(this.get_culture());
    }

    if (selection && typeof (selection.get_days) == 'function' && typeof (this.get_state().weekdays) != 'undefined') {
        firstDay = selection.get_startDate();

        linkSelection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(firstDay, firstDay, this.get_culture());
        while (linkSelection.get_days()[0] != this.get_culture().get_firstDayOfWeek()) {
            firstDay = Dynamicweb.Controls.OMC.WeekOverview._previousDay(firstDay);
            linkSelection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(firstDay, firstDay, this.get_culture());
        }

        for (var i = 0; i < this.get_state().weekdays.length; i++) {
            link = $(this.get_state().weekdays[i]);
            details = link.select('span.week-overview-day-details')[0];

            link.writeAttribute('data-weekday', linkSelection.get_days()[0]);
            link.writeAttribute('data-selection', linkSelection.toString());

            link.writeAttribute('title', this.formatDayAndWeek(linkSelection, link.readAttribute('title')));
            details.innerHTML = this.formatDayAndMonth(linkSelection, '');

            if (this.get_currentPeriodOnly()) {
                if (isFuture(linkSelection)) {
                    link.addClassName('week-overview-day-notallowed');

                    if (i == 0) isBackAllowed = false;
                    else if (i == this.get_state().weekdays.length - 1) isForwardAllowed = false;
                } else {
                    link.removeClassName('week-overview-day-notallowed');

                    if (i == 0) isBackAllowed = true;
                    else if (i == this.get_state().weekdays.length - 1) isForwardAllowed = true;
                }
            } else {
                link.removeClassName('week-overview-day-notallowed');

                if (i == 0) isBackAllowed = true;
                else if (i == this.get_state().weekdays.length - 1) isForwardAllowed = true;
            }

            linkSelection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(Dynamicweb.Controls.OMC.WeekOverview._nextDay(linkSelection.get_startDate()), null, this.get_culture());
        }

        if (this.get_state().prevWeekButton) {
            if (isBackAllowed) {
                this.get_state().prevWeekButton.removeClassName('week-overview-navigate-back-notallowed');
            } else {
                this.get_state().prevWeekButton.addClassName('week-overview-navigate-back-notallowed');
            }
        }

        if (this.get_state().nextWeekButton) {
            if (isForwardAllowed) {
                /* Edge case - first day of week next week is in future - can't go to next week */
                if (this.get_currentPeriodOnly() && isFuture(linkSelection)) {
                    this.get_state().nextWeekButton.addClassName('week-overview-navigate-forward-notallowed');
                } else {
                    this.get_state().nextWeekButton.removeClassName('week-overview-navigate-forward-notallowed');
                }
            } else {
                this.get_state().nextWeekButton.addClassName('week-overview-navigate-forward-notallowed');
            }
        }
    }

    /* Reseting the "width" styles of the container so we can get its actual width */
    this.get_container().setStyle({ 'width': 'auto' });

    /* Setting width by the timeout - needs some time at first calculation */
    if (this._widthCalculationTimeout) {
        clearTimeout(this._widthCalculationTimeout);
        this._widthCalculationTimeout = null;
    }

    this._widthCalculationTimeout = setTimeout(function () {
        var containerWidth = 0;

        /* Getting the actual width */
        containerWidth = self.get_container().getWidth();

        /* Updating the width of the container to prevent buttons from moving down when there is not enough space for entire control */
        if (containerWidth > 0) {
            self.get_container().setStyle({ 'width': containerWidth + 'px' });
        }
    }, 100);
}

Dynamicweb.Controls.OMC.WeekOverview.prototype._updateSelectionFromNode = function (node, notifyClients) {
    /// <summary>Updates selection by using metadata of the given DOM node.</summary>
    /// <param name="node">DOM node.</param>
    /// <param name="notifyClients">Indicates whether fire notification that the selection has been changed.</param>
    /// <private />

    var val = '';
    var selection = null;
    var currentSelection = null;

    if (node) {
        val = $(node).readAttribute('data-selection');
        if (val && val.length) {
            currentSelection = this.get_selection();
            selection = Dynamicweb.Controls.OMC.WeekOverviewSelection.parse(val, this.get_culture());

            if (this._stickToSelection != null) {
                currentSelection = this._stickToSelection;
            }

            if (this._shiftPressed) {
                if (selection.get_endDate().getTime() < currentSelection.get_startDate().getTime()) {
                    selection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(selection.get_endDate(), currentSelection.get_endDate(), this.get_culture());
                } else if (selection.get_startDate().getTime() > currentSelection.get_endDate().getTime()) {
                    selection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(currentSelection.get_startDate(), selection.get_startDate(), this.get_culture());
                }
            } 

            if (selection) {
                this._updateSelection(selection, notifyClients);
            }
        }
    }
}

Dynamicweb.Controls.OMC.WeekOverview.prototype._canUpdateSelectionFromNode = function (node) {
    /// <summary>Determines whether current selection can be updated with the value from the current day node.</summary>
    /// <param name="node">Day node.</param>
    /// <private />

    var ret = this._canUpdateSelection();

    if (ret && node) {
        ret = !$(node).hasClassName('week-overview-day-notallowed');
    }

    return ret;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype._canChangeWeekFromNode = function (node) {
    /// <summary>Determines whether user can change the current week.</summary>
    /// <param name="node">Paging button.</param>
    /// <private />

    var ret = this._canChangeWeek();

    if (ret && node) {
        node = $(node);
        ret = !node.hasClassName('week-overview-navigate-back-notallowed') && !node.hasClassName('week-overview-navigate-forward-notallowed');
    }

    return ret;
}

Dynamicweb.Controls.OMC.WeekOverview.prototype._canUpdateSelection = function () {
    /// <summary>Determines whether current selection can be updated according to the state of the control.</summary>
    /// <private />

    return this.get_isEnabled();
}

Dynamicweb.Controls.OMC.WeekOverview.prototype._canChangeWeek = function () {
    /// <summary>Determines whether user can change the current week.</summary>
    /// <private />

    return this.get_isEnabled();
}

Dynamicweb.Controls.OMC.WeekOverview.prototype._changeWeek = function (direction, notifyClients) {
    /// <summary>Changes the current week.</summary>
    /// <param name="direction">Change direction.</param>
    /// <param name="notifyClients">Indicates whether fire notification that the selection has been changed.</param>
    /// <private />

    var firstDay = null;
    var selection = null;
    var newSelection = null;

    if (this._canChangeWeek()) {
        selection = this.get_selection();

        if (!selection || typeof (selection.get_startDate) != 'function') {
            selection = Dynamicweb.Controls.OMC.WeekOverviewSelection.current();
        }

        firstDay = selection.get_startDate();
        newSelection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(firstDay, firstDay, this.get_culture());
        while (newSelection.get_days()[0] != this.get_culture().get_firstDayOfWeek()) {
            firstDay = Dynamicweb.Controls.OMC.WeekOverview._previousDay(firstDay);
            newSelection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(firstDay, firstDay, this.get_culture());
        }

        if (direction < 0) {
            firstDay = Dynamicweb.Controls.OMC.WeekOverview._previousDay(firstDay);
        } else {
            firstDay = Dynamicweb.Controls.OMC.WeekOverview._nextWeek(firstDay);
        }

        newSelection = new Dynamicweb.Controls.OMC.WeekOverviewSelection(firstDay, firstDay, this.get_culture());
        if (notifyClients) {
            this.onWeekChanged({ direction: direction < 0 ? 'back' : 'forward' });
        }

        this._updateSelection(newSelection, true);
    }
}

Dynamicweb.Controls.OMC.WeekOverview.prototype._updateSelection = function (selection, notifyClients) {
    /// <summary>Updates the current selection.</summary>
    /// <param name="selection">New selection.</param>
    /// <param name="notifyClients">Indicates whether fire notification that the selection has been changed.</param>
    /// <private />

    var d = '';
    var link = null;
    var cell = null;

    var dayInSelection = function (selection, day) {
        var days = [];
        var result = false;

        if (day && day.length && selection && typeof (selection.get_days) == 'function') {
            days = selection.get_days();
            for (var i = 0; i < days.length; i++) {
                if (day == days[i]) {
                    result = true;
                    break;
                }
            }
        }

        return result;
    }

    this._updateWeekdaysMeta(selection);

    if (this._canUpdateSelection()) {
        this._selection = selection;

        if (!this._selection) {
            this._stickToSelection = null;
        } else if (this._selection.get_days().length == 1) {
            this._stickToSelection = this._selection;
        }

        if (typeof (this.get_state()) != 'undefined') {
            for (var i = 0; i < this.get_state().weekdays.length; i++) {
                link = $(this.get_state().weekdays[i]);
                cell = link.up('li.week-overview-day-container');

                d = link.readAttribute('data-weekday');

                if (dayInSelection(selection, d)) {
                    cell.addClassName('week-overview-selected');
                } else {
                    cell.removeClassName('week-overview-selected');
                }
            }
        }

        if (notifyClients) {
            this.onSelectionChanged({ selection: selection });
        }
    }
}

Dynamicweb.Controls.OMC.WeekOverview._nextDay = function (timestamp) {
    /// <summary>Changes the given timestamp to be the next day and returns the new timestamp.</summary>
    /// <param name="timestamp">Original timestamp.</param>

    var ret = new Date(timestamp.getTime() + 86400000);

    if (timestamp.getDate() == ret.getDate()) {
        ret = new Date(ret.getTime() + (3600000 * Math.abs(24 - ret.getHours())));
    }

    return ret;
}

Dynamicweb.Controls.OMC.WeekOverview._previousDay = function (timestamp) {
    /// <summary>Changes the given timestamp to be the previous day and returns the new timestamp.</summary>
    /// <param name="timestamp">Original timestamp.</param>

    var ret = new Date(timestamp.getTime() - 86400000);

    if (timestamp.getDate() == ret.getDate()) {
        ret = new Date(ret.getTime() - (3600000 * ret.getHours()));
    }

    return ret;
}

Dynamicweb.Controls.OMC.WeekOverview._nextWeek = function (timestamp) {
    /// <summary>Changes the given timestamp to be the same day in the next week and returns the new timestamp.</summary>
    /// <param name="timestamp">Original timestamp.</param>

    var currentDay = 0;
    var ret = new Date(timestamp.getTime() + (86400000 * 7));

    if (timestamp.getDay() != ret.getDay()) {
        currentDay = ret.getDay();

        do {
            ret = new Date(ret.getTime() + 3600000);
        } while (currentDay == ret.getDay());
    }

    return ret;
}

Dynamicweb.Controls.OMC.WeekOverview._previousWeek = function (timestamp) {
    /// <summary>Changes the given timestamp to be the same day in the previous week and returns the new timestamp.</summary>
    /// <param name="timestamp">Original timestamp.</param>

    var currentDay = 0;
    var ret = new Date(timestamp.getTime() - (86400000 * 7));

    if (timestamp.getDay() != ret.getDay()) {
        currentDay = ret.getDay();

        do {
            ret = new Date(ret.getTime() - 3600000);
        } while (currentDay == ret.getDay());
    }

    return ret;
}