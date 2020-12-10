/*!
 * Pikaday
 *
 * Copyright © 2014 David Bushell | BSD & MIT license | https://github.com/dbushell/Pikaday
 * MAV: Changes made to "show" and "hide" to affect the wrapper html aswell.
 * MAV: adjustPosition rewritten
 */
(function (root, factory) {
    'use strict';
    root.Pikaday = factory();
}(this, function () {
    'use strict';
    /**
     * feature detection and helper functions
     */
    var hasMoment = false,

    hasEventListeners = !!window.addEventListener,

    document = window.document,

    sto = window.setTimeout,

    addEvent = function (el, e, callback, capture) {
        if (hasEventListeners) {
            el.addEventListener(e, callback, !!capture);
        } else {
            el.attachEvent('on' + e, callback);
        }
    },

    removeEvent = function (el, e, callback, capture) {
        if (hasEventListeners) {
            el.removeEventListener(e, callback, !!capture);
        } else {
            el.detachEvent('on' + e, callback);
        }
    },

    fireEvent = function (el, eventName, data) {
        var ev;

        if (document.createEvent) {
            ev = document.createEvent('HTMLEvents');
            ev.initEvent(eventName, true, false);
            ev = extend(ev, data);
            el.dispatchEvent(ev);
        } else if (document.createEventObject) {
            ev = document.createEventObject();
            ev = extend(ev, data);
            el.fireEvent('on' + eventName, ev);
        }
    },

    trim = function (str) {
        return str.trim ? str.trim() : str.replace(/^\s+|\s+$/g, '');
    },

    hasClass = function (el, cn) {
        return (' ' + el.className + ' ').indexOf(' ' + cn + ' ') !== -1;
    },

    addClass = function (el, cn) {
        if (!hasClass(el, cn)) {
            el.className = (el.className === '') ? cn : el.className + ' ' + cn;
        }
    },

    removeClass = function (el, cn) {
        el.className = trim((' ' + el.className + ' ').replace(' ' + cn + ' ', ' '));
    },

    isArray = function (obj) {
        return (/Array/).test(Object.prototype.toString.call(obj));
    },

    isDate = function (obj) {
        return (/Date/).test(Object.prototype.toString.call(obj)) && !isNaN(obj.getTime());
    },

    isWeekend = function (date) {
        var day = date.getDay();
        return day === 0 || day === 6;
    },

    isLeapYear = function (year) {
        // solution by Matti Virkkunen: http://stackoverflow.com/a/4881951
        return year % 4 === 0 && year % 100 !== 0 || year % 400 === 0;
    },

    getDaysInMonth = function (year, month) {
        return [31, isLeapYear(year) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
    },

    setToStartOfDay = function (date) {
        if (isDate(date)) date.setHours(0, 0, 0, 0);
    },

    compareDates = function (a, b) {
        // weak date comparison (use setToStartOfDay(date) to ensure correct result)
        return a.getTime() === b.getTime();
    },

    extend = function (to, from, overwrite) {
        var prop, hasProp;
        for (prop in from) {
            hasProp = to[prop] !== undefined;
            if (hasProp && typeof from[prop] === 'object' && from[prop] !== null && from[prop].nodeName === undefined) {
                if (isDate(from[prop])) {
                    if (overwrite) {
                        to[prop] = new Date(from[prop].getTime());
                    }
                }
                else if (isArray(from[prop])) {
                    if (overwrite) {
                        to[prop] = from[prop].slice(0);
                    }
                } else {
                    to[prop] = extend({}, from[prop], overwrite);
                }
            } else if (overwrite || !hasProp) {
                to[prop] = from[prop];
            }
        }
        return to;
    },

    adjustCalendar = function (calendar) {
        if (calendar.month < 0) {
            calendar.year -= Math.ceil(Math.abs(calendar.month) / 12);
            calendar.month += 12;
        }
        if (calendar.month > 11) {
            calendar.year += Math.floor(Math.abs(calendar.month) / 12);
            calendar.month -= 12;
        }
        return calendar;
    },

    /**
     * defaults and localisation
     */
    defaults = {

        // bind the picker to a form field
        field: null,

        // automatically show/hide the picker on `field` focus (default `true` if `field` is set)
        bound: undefined,

        // position of the datepicker, relative to the field (default to bottom & left)
        // ('bottom' & 'left' keywords are not used, 'top' & 'right' are modifier on the bottom/left position)
        position: 'bottom left',

        // automatically fit in the viewport even if it means repositioning from the position option
        reposition: true,

        // the default output format for `.toString()` and `field` value
        format: 'YYYY-MM-DD',

        // the initial date to view when first opened
        defaultDate: null,

        // make the `defaultDate` the initial selected value
        setDefaultDate: false,

        // first day of week (0: Sunday, 1: Monday etc)
        firstDay: 0,

        // the default flag for moment's strict date parsing
        formatStrict: false,

        // the minimum/earliest date that can be selected
        minDate: null,
        // the maximum/latest date that can be selected
        maxDate: null,

        // number of years either side, or array of upper/lower range
        yearRange: 10,

        // show week numbers at head of row
        showWeekNumber: false,

        // used internally (don't config outside)
        minYear: 0,
        maxYear: 9999,
        minMonth: undefined,
        maxMonth: undefined,

        startRange: null,
        endRange: null,

        isRTL: false,

        // Additional text to append to the year in the calendar title
        yearSuffix: '',

        // Render the month after year in the calendar title
        showMonthAfterYear: false,

        // Render days of the calendar grid that fall in the next or previous month
        showDaysInNextAndPreviousMonths: false,

        // how many months are visible
        numberOfMonths: 1,

        // when numberOfMonths is used, this will help you to choose where the main calendar will be (default `left`, can be set to `right`)
        // only used for the first display or when a selected date is not visible
        mainCalendar: 'left',

        // Specify a DOM element to render the calendar in
        container: undefined,

        // internationalization
        i18n: {
            previousMonth: 'Previous Month',
            nextMonth: 'Next Month',
            months: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            weekdays: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
            weekdaysShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
        },

        // Theme Classname
        theme: null,

        // callback function
        onSelect: null,
        onOpen: null,
        onClose: null,
        onDraw: null
    },

    /**
     * templating functions to abstract HTML rendering
     */
    renderDayName = function (opts, day, abbr) {
        day += opts.firstDay;
        while (day >= 7) {
            day -= 7;
        }
        return abbr ? opts.i18n.weekdaysShort[day] : opts.i18n.weekdays[day];
    },

    renderDay = function (opts) {
        var arr = [];
        if (opts.isEmpty) {
            if (opts.showDaysInNextAndPreviousMonths) {
                arr.push('is-outside-current-month');
            } else {
                return '<td class="is-empty"></td>';
            }
        }
        if (opts.isDisabled) {
            arr.push('is-disabled');
        }
        if (opts.isToday) {
            arr.push('is-today');
        }
        if (opts.isSelected) {
            arr.push('is-selected');
        }
        if (opts.isInRange) {
            arr.push('is-inrange');
        }
        if (opts.isStartRange) {
            arr.push('is-startrange');
        }
        if (opts.isEndRange) {
            arr.push('is-endrange');
        }
        return '<td data-day="' + opts.day + '" class="' + arr.join(' ') + '">' +
                 '<button class="pika-button pika-day" type="button" ' +
                    'data-pika-year="' + opts.year + '" data-pika-month="' + opts.month + '" data-pika-day="' + opts.day + '">' +
                        opts.day +
                 '</button>' +
               '</td>';
    },

    renderWeek = function (d, m, y) {
        // Lifted from http://javascript.about.com/library/blweekyear.htm, lightly modified.
        var onejan = new Date(y, 0, 1),
            weekNum = Math.ceil((((new Date(y, m, d) - onejan) / 86400000) + onejan.getDay() + 1) / 7);
        return '<td class="pika-week">' + weekNum + '</td>';
    },

    renderRow = function (days, isRTL) {
        return '<tr>' + (isRTL ? days.reverse() : days).join('') + '</tr>';
    },

    renderBody = function (rows) {
        return '<tbody>' + rows.join('') + '</tbody>';
    },

    renderHead = function (opts) {
        var i, arr = [];
        if (opts.showWeekNumber) {
            arr.push('<th></th>');
        }
        for (i = 0; i < 7; i++) {
            arr.push('<th scope="col"><abbr title="' + renderDayName(opts, i) + '">' + renderDayName(opts, i, true) + '</abbr></th>');
        }
        return '<thead><tr>' + (opts.isRTL ? arr.reverse() : arr).join('') + '</tr></thead>';
    },

    renderTitle = function (instance, c, year, month, refYear) {
        var i, j, arr,
            opts = instance._o,
            isMinYear = year === opts.minYear,
            isMaxYear = year === opts.maxYear,
            html = '<div class="pika-title">',
            monthHtml,
            yearHtml,
            prev = true,
            next = true;

        for (arr = [], i = 0; i < 12; i++) {
            arr.push('<option value="' + (year === refYear ? i - c : 12 + i - c) + '"' +
                (i === month ? ' selected="selected"' : '') +
                ((isMinYear && i < opts.minMonth) || (isMaxYear && i > opts.maxMonth) ? 'disabled="disabled"' : '') + '>' +
                opts.i18n.months[i] + '</option>');
        }
        monthHtml = '<div class="pika-label">' + opts.i18n.months[month] + '<select class="pika-select pika-select-month" tabindex="-1">' + arr.join('') + '</select></div>';

        if (isArray(opts.yearRange)) {
            i = opts.yearRange[0];
            j = opts.yearRange[1] + 1;
        } else {
            i = year - opts.yearRange;
            j = 1 + year + opts.yearRange;
        }

        for (arr = []; i < j && i <= opts.maxYear; i++) {
            if (i >= opts.minYear) {
                arr.push('<option value="' + i + '"' + (i === year ? ' selected="selected"' : '') + '>' + (i) + '</option>');
            }
        }
        yearHtml = '<div class="pika-label">' + year + opts.yearSuffix + '<select class="pika-select pika-select-year" tabindex="-1">' + arr.join('') + '</select></div>';

        if (opts.showMonthAfterYear) {
            html += yearHtml + monthHtml;
        } else {
            html += monthHtml + yearHtml;
        }

        if (isMinYear && (month === 0 || opts.minMonth >= month)) {
            prev = false;
        }

        if (isMaxYear && (month === 11 || opts.maxMonth <= month)) {
            next = false;
        }

        if (c === 0) {
            html += '<button class="pika-prev' + (prev ? '' : ' is-disabled') + '" type="button"' + (next ? '' : ' disabled') + '>' + opts.i18n.previousMonth + '</button>';
        }
        if (c === (instance._o.numberOfMonths - 1)) {
            html += '<button class="pika-next' + (next ? '' : ' is-disabled') + '" type="button"' + (next ? '' : ' disabled') + '>' + opts.i18n.nextMonth + '</button>';
        }

        return html += '</div>';
    },

    renderTable = function (opts, data) {
        return '<table cellpadding="0" cellspacing="0" class="pika-table">' + renderHead(opts) + renderBody(data) + '</table>';
    },

    /**
     * Pikaday constructor
     */
    Pikaday = function (options) {
        var self = this,
            opts = self.config(options);

        self._onMouseDown = function (e) {
            if (!self._v) {
                return;
            }
            e = e || window.event;
            var target = e.target || e.srcElement;
            if (!target) {
                return;
            }

            if (!hasClass(target, 'is-disabled') && !hasClass(target.parentNode, 'is-disabled')) {
                if (hasClass(target, 'pika-button') && !hasClass(target, 'is-empty')) {
                    self.setDate(new Date(target.getAttribute('data-pika-year'), target.getAttribute('data-pika-month'), target.getAttribute('data-pika-day')));
                    //if (opts.bound) {
                    sto(function () {
                        self.hide();
                    }, 100);
                    //}
                }
                else if (hasClass(target, 'pika-prev')) {
                    self.prevMonth();
                }
                else if (hasClass(target, 'pika-next')) {
                    self.nextMonth();
                }
            }
            if (!hasClass(target, 'pika-select') && !hasClass(target, 'pika-wrapper')) {
                // if this is touch event prevent mouse events emulation
                if (e.preventDefault) {
                    e.preventDefault();
                } else {
                    e.returnValue = false;
                    return false;
                }
            } else {
                self._c = true;
            }
        };

        self._onChange = function (e) {
            e = e || window.event;
            var target = e.target || e.srcElement;
            if (!target) {
                return;
            }
            if (hasClass(target, 'pika-select-month')) {
                self.gotoMonth(target.value);
            }
            else if (hasClass(target, 'pika-select-year')) {
                self.gotoYear(target.value);
            }
        };

        self._onInputChange = function (e) {
            var date;

            if (e.firedBy === self) {
                return;
            }
            if (hasMoment) {
                date = moment(opts.field.value, opts.format, opts.formatStrict);
                date = (date && date.isValid()) ? date.toDate() : null;
            }
            else {
                date = new Date(Date.parse(opts.field.value));
            }
            if (isDate(date)) {
                self.setDate(date);
            }
            if (!self._v) {
                self.show();
            }
        };

        if (!options.disabled) {
            self._onInputFocus = function () {
                self.show();
            };

            self._onInputClick = function () {
                self.show();
            };
        }

        self._onInputBlur = function () {
            // IE allows pika div to gain focus; catch blur the input field
            var pEl = document.activeElement;
            do {
                if (hasClass(pEl, 'pika-single')) {
                    return;
                }
            }
            while ((pEl = pEl.parentNode));

            if (!self._c) {
                self._b = sto(function () {
                    self.hide();
                }, 50);
            }
            self._c = false;
        };

        self._onClick = function (e) {
            var target = e.target || e.srcElement,
                pEl = target;
            if (!target) {
                return;
            }
            if (!hasEventListeners && hasClass(target, 'pika-select')) {
                if (!target.onchange) {
                    target.setAttribute('onchange', 'return;');
                    addEvent(target, 'change', self._onChange);
                }
            }
            do {
                if (hasClass(pEl, 'pika-wrapper') || pEl === opts.trigger || hasClass(pEl, 'pika-button')) {
                    return;
                }
            }
            while ((pEl = pEl.parentNode));
            if (self._v && target !== opts.trigger && pEl !== opts.trigger) {
                self.hide();
            }
        };

        self.el = document.createElement('div');
        self.el.className = 'pika-single' + (opts.isRTL ? ' is-rtl' : '') + (opts.theme ? ' ' + opts.theme : '');

        addEvent(self.el, 'mousedown', self._onMouseDown, true);
        addEvent(self.el, 'touchend', self._onMouseDown, true);
        addEvent(self.el, 'change', self._onChange);

        if (opts.field) {
            if (opts.container) {
                opts.container.appendChild(self.el);
            } else if (opts.bound) {
                document.body.appendChild(self.el);
            } else {
                opts.field.parentNode.insertBefore(self.el, opts.field.nextSibling);
            }
            addEvent(opts.field, 'change', self._onInputChange);

            if (!opts.defaultDate) {
                if (hasMoment && opts.field.value) {
                    opts.defaultDate = moment(opts.field.value, opts.format).toDate();
                } else {
                    opts.defaultDate = new Date(Date.parse(opts.field.value));
                }
                opts.setDefaultDate = true;
            }
        }

        var defDate = opts.defaultDate;

        if (isDate(defDate)) {
            if (opts.setDefaultDate) {
                self.setDate(defDate, true);
            } else {
                self.gotoDate(defDate);
            }
        } else {
            self.gotoDate(new Date());
        }

        //if (opts.bound) {
        this.hide();
        //self.el.className += ' is-bound';
        addEvent(opts.trigger, 'click', self._onInputClick);
        addEvent(opts.trigger, 'focus', self._onInputFocus);
        addEvent(opts.trigger, 'blur', self._onInputBlur);
        //} else {
        //    this.show();
        //}
    };

    /**
     * public Pikaday API
     */
    Pikaday.prototype = {

        options: null,
        /**
         * configure functionality
         */
        config: function (options) {
            if (!this._o) {
                this._o = extend({}, defaults, true);
            }

            this.options = options;
            var opts = extend(this._o, options, true);

            opts.isRTL = !!opts.isRTL;

            opts.field = (opts.field && opts.field.nodeName) ? opts.field : null;

            opts.theme = (typeof opts.theme) === 'string' && opts.theme ? opts.theme : null;

            opts.bound = !!(opts.bound !== undefined ? opts.field && opts.bound : opts.field);

            opts.trigger = (opts.trigger && opts.trigger.nodeName) ? opts.trigger : opts.field;

            opts.disableWeekends = !!opts.disableWeekends;

            opts.disableDayFn = (typeof opts.disableDayFn) === 'function' ? opts.disableDayFn : null;

            var nom = parseInt(opts.numberOfMonths, 10) || 1;
            opts.numberOfMonths = nom > 4 ? 4 : nom;

            if (!isDate(opts.minDate)) {
                opts.minDate = false;
            }
            if (!isDate(opts.maxDate)) {
                opts.maxDate = false;
            }
            if ((opts.minDate && opts.maxDate) && opts.maxDate < opts.minDate) {
                opts.maxDate = opts.minDate = false;
            }
            if (opts.minDate) {
                this.setMinDate(opts.minDate);
            }
            if (opts.maxDate) {
                this.setMaxDate(opts.maxDate);
            }

            if (isArray(opts.yearRange)) {
                var fallback = new Date().getFullYear() - 10;
                opts.yearRange[0] = parseInt(opts.yearRange[0], 10) || fallback;
                opts.yearRange[1] = parseInt(opts.yearRange[1], 10) || fallback;
            } else {
                opts.yearRange = Math.abs(parseInt(opts.yearRange, 10)) || defaults.yearRange;
                if (opts.yearRange > 100) {
                    opts.yearRange = 100;
                }
            }

            return opts;
        },

        /**
         * return a formatted string of the current selection (using Moment.js if available)
         */
        toString: function (format) {
            return !isDate(this._d) ? '' : hasMoment ? moment(this._d).format(format || this._o.format) : this._d.toDateString();
        },

        /**
         * return a Moment.js object of the current selection (if available)
         */
        getMoment: function () {
            return hasMoment ? moment(this._d) : null;
        },

        /**
         * set the current selection from a Moment.js object (if available)
         */
        setMoment: function (date, preventOnSelect) {
            if (hasMoment && moment.isMoment(date)) {
                this.setDate(date.toDate(), preventOnSelect);
            }
        },

        /**
         * return a Date object of the current selection
         */
        getDate: function () {
            return isDate(this._d) ? new Date(this._d.getTime()) : null;
        },

        /**
         * set the current selection
         */
        setDate: function (date, preventOnSelect) {
            if (!date) {
                this._d = null;

                if (this._o.field) {
                    this._o.field.value = '';
                    fireEvent(this._o.field, 'change', { firedBy: this });
                }

                return this.draw();
            }
            if (typeof date === 'string') {
                date = new Date(Date.parse(date));
            }
            if (!isDate(date)) {
                return;
            }

            var min = this._o.minDate,
                max = this._o.maxDate;

            if (isDate(min) && date < min) {
                date = min;
            } else if (isDate(max) && date > max) {
                date = max;
            }

            this._d = new Date(date.getTime());
            this.gotoDate(this._d);

            if (this._o.field) {
                this._o.field.value = this.toString();
                fireEvent(this._o.field, 'change', { firedBy: this });
            }
            if (!preventOnSelect && typeof this._o.onSelect === 'function') {
                this._o.onSelect.call(this, this.getDate());
            }
        },

        /**
         * change view to a specific date
         */
        gotoDate: function (date) {
            var newCalendar = true;

            if (!isDate(date)) {
                return;
            }

            if (this.calendars) {
                var firstVisibleDate = new Date(this.calendars[0].year, this.calendars[0].month, 1),
                    lastVisibleDate = new Date(this.calendars[this.calendars.length - 1].year, this.calendars[this.calendars.length - 1].month, 1),
                    visibleDate = date.getTime();
                // get the end of the month
                lastVisibleDate.setMonth(lastVisibleDate.getMonth() + 1);
                lastVisibleDate.setDate(lastVisibleDate.getDate() - 1);
                newCalendar = (visibleDate < firstVisibleDate.getTime() || lastVisibleDate.getTime() < visibleDate);
            }

            if (newCalendar) {
                this.calendars = [{
                    month: date.getMonth(),
                    year: date.getFullYear()
                }];
                if (this._o.mainCalendar === 'right') {
                    this.calendars[0].month += 1 - this._o.numberOfMonths;
                }
            }

            this.adjustCalendars();
        },

        adjustCalendars: function () {
            this.calendars[0] = adjustCalendar(this.calendars[0]);
            for (var c = 1; c < this._o.numberOfMonths; c++) {
                this.calendars[c] = adjustCalendar({
                    month: this.calendars[0].month + c,
                    year: this.calendars[0].year
                });
            }
            this.draw();
        },

        gotoToday: function () {
            this.gotoDate(new Date());
        },

        /**
         * change view to a specific month (zero-index, e.g. 0: January)
         */
        gotoMonth: function (month) {
            if (!isNaN(month)) {
                this.calendars[0].month = parseInt(month, 10);
                this.adjustCalendars();
            }
        },

        nextMonth: function () {
            this.calendars[0].month++;
            this.adjustCalendars();
        },

        prevMonth: function () {
            this.calendars[0].month--;
            this.adjustCalendars();
        },

        /**
         * change view to a specific full year (e.g. "2012")
         */
        gotoYear: function (year) {
            if (!isNaN(year)) {
                this.calendars[0].year = parseInt(year, 10);
                this.adjustCalendars();
            }
        },

        /**
         * change the minDate
         */
        setMinDate: function (value) {
            setToStartOfDay(value);
            this._o.minDate = value;
            this._o.minYear = value.getFullYear();
            this._o.minMonth = value.getMonth();
            this.draw();
        },

        /**
         * change the maxDate
         */
        setMaxDate: function (value) {
            setToStartOfDay(value);
            this._o.maxDate = value;
            this._o.maxYear = value.getFullYear();
            this._o.maxMonth = value.getMonth();
            this.draw();
        },

        setStartRange: function (value) {
            this._o.startRange = value;
        },

        setEndRange: function (value) {
            this._o.endRange = value;
        },

        /**
         * refresh the HTML
         */
        draw: function (force) {
            if (!this._v && !force) {
                return;
            }
            var opts = this._o,
                minYear = opts.minYear,
                maxYear = opts.maxYear,
                minMonth = opts.minMonth,
                maxMonth = opts.maxMonth,
                html = '';

            if (this._y <= minYear) {
                this._y = minYear;
                if (!isNaN(minMonth) && this._m < minMonth) {
                    this._m = minMonth;
                }
            }
            if (this._y >= maxYear) {
                this._y = maxYear;
                if (!isNaN(maxMonth) && this._m > maxMonth) {
                    this._m = maxMonth;
                }
            }

            for (var c = 0; c < opts.numberOfMonths; c++) {
                html += '<div class="pika-lendar">' + renderTitle(this, c, this.calendars[c].year, this.calendars[c].month, this.calendars[0].year) + this.render(this.calendars[c].year, this.calendars[c].month) + '</div>';
            }

            this.el.innerHTML = html;

            if (opts.bound) {
                if (opts.field.type !== 'hidden') {
                    sto(function () {
                        opts.trigger.focus();
                    }, 1);
                }
            }

            if (typeof this._o.onDraw === 'function') {
                this._o.onDraw(this);
            }
        },

        adjustPosition: function () {
            var wrapper = document.getElementById("pika-wrapper");
            adjustElementToOtherElement(wrapper, this._o.trigger);
        },

        /**
         * render HTML for a particular month
         */
        render: function (year, month) {
            var opts = this._o,
                now = new Date(),
                days = getDaysInMonth(year, month),
                before = new Date(year, month, 1).getDay(),
                data = [],
                row = [];
            setToStartOfDay(now);
            if (opts.firstDay > 0) {
                before -= opts.firstDay;
                if (before < 0) {
                    before += 7;
                }
            }
            var previousMonth = month === 0 ? 11 : month - 1,
                nextMonth = month === 11 ? 0 : month + 1,
                yearOfPreviousMonth = month === 0 ? year - 1 : year,
                yearOfNextMonth = month === 11 ? year + 1 : year,
                daysInPreviousMonth = getDaysInMonth(yearOfPreviousMonth, previousMonth);
            var cells = days + before,
                after = cells;
            while (after > 7) {
                after -= 7;
            }
            cells += 7 - after;
            for (var i = 0, r = 0; i < cells; i++) {
                var day = new Date(year, month, 1 + (i - before)),
                    isSelected = isDate(this._d) ? compareDates(day, this._d) : false,
                    isToday = compareDates(day, now),
                    isEmpty = i < before || i >= (days + before),
                    dayNumber = 1 + (i - before),
                    monthNumber = month,
                    yearNumber = year,
                    isStartRange = opts.startRange && compareDates(opts.startRange, day),
                    isEndRange = opts.endRange && compareDates(opts.endRange, day),
                    isInRange = opts.startRange && opts.endRange && opts.startRange < day && day < opts.endRange,
                    isDisabled = (opts.minDate && day < opts.minDate) ||
                                 (opts.maxDate && day > opts.maxDate) ||
                                 (opts.disableWeekends && isWeekend(day)) ||
                                 (opts.disableDayFn && opts.disableDayFn(day));

                if (isEmpty) {
                    if (i < before) {
                        dayNumber = daysInPreviousMonth + dayNumber;
                        monthNumber = previousMonth;
                        yearNumber = yearOfPreviousMonth;
                    } else {
                        dayNumber = dayNumber - days;
                        monthNumber = nextMonth;
                        yearNumber = yearOfNextMonth;
                    }
                }

                var dayConfig = {
                    day: dayNumber,
                    month: monthNumber,
                    year: yearNumber,
                    isSelected: isSelected,
                    isToday: isToday,
                    isDisabled: isDisabled,
                    isEmpty: isEmpty,
                    isStartRange: isStartRange,
                    isEndRange: isEndRange,
                    isInRange: isInRange,
                    showDaysInNextAndPreviousMonths: opts.showDaysInNextAndPreviousMonths
                };

                row.push(renderDay(dayConfig));

                if (++r === 7) {
                    if (opts.showWeekNumber) {
                        row.unshift(renderWeek(i - before, month, year));
                    }
                    data.push(renderRow(row, opts.isRTL));
                    row = [];
                    r = 0;
                }
            }
            return renderTable(opts, data);
        },

        isVisible: function () {
            return this._v;
        },

        show: function () {
            if (!this._v) {
                var calendars = document.getElementsByClassName("pika-single");
                if (calendars.length > 0) {
                    for (var i = 0; i < calendars.length - 1; i++) {
                        addClass(calendars[i], 'is-hidden');
                    }
                }
                var wrapper = document.getElementById("pika-wrapper");
                removeClass(this.el, 'is-hidden');
                removeClass(wrapper, 'is-hidden');
                this._v = true;
                this.draw();
                addEvent(document, 'click', this._onClick);
                this.adjustPosition();
                if (typeof this._o.onOpen === 'function') {
                    this._o.onOpen.call(this);
                }
            }
        },

        hide: function () {
            var v = this._v;
            if (v !== false) {
                removeEvent(document, 'click', this._onClick);
                var wrapper = document.getElementById("pika-wrapper");
                wrapper.style.position = 'static'; // reset
                wrapper.style.left = 'auto';
                wrapper.style.top = 'auto';
                addClass(wrapper, 'is-hidden');
                addClass(this.el, 'is-hidden');
                this._v = false;
                if (v !== undefined && typeof this._o.onClose === 'function') {
                    this._o.onClose.call(this);
                }
            }
        },

        /**
         * GAME OVER
         */
        destroy: function () {
            this.hide();
            removeEvent(this.el, 'mousedown', this._onMouseDown, true);
            removeEvent(this.el, 'touchend', this._onMouseDown, true);
            removeEvent(this.el, 'change', this._onChange);
            if (this._o.field) {
                removeEvent(this._o.field, 'change', this._onInputChange);
                if (this._o.bound) {
                    removeEvent(this._o.trigger, 'click', this._onInputClick);
                    removeEvent(this._o.trigger, 'focus', this._onInputFocus);
                    removeEvent(this._o.trigger, 'blur', this._onInputBlur);
                }
            }
            if (this.el.parentNode) {
                this.el.parentNode.removeChild(this.el);
            }
        }

    };

    return Pikaday;
}));

function adjustElementToOtherElement(repositionElement, targetElement) {
    var pEl, width, height, viewportWidth, viewportHeight, scrollTop, left, top, clientRect, actionBarHeight = 0;
    repositionElement.style.position = 'absolute';
    pEl = targetElement;

    //targetElement.parentNode.appendChild(repositionElement);

    width = repositionElement.offsetWidth;
    height = repositionElement.offsetHeight;
    viewportWidth = window.innerWidth || document.documentElement.clientWidth;
    viewportHeight = window.innerHeight || document.documentElement.clientHeight;
    scrollTop = window.pageYOffset || pEl.scrollTop;//document.body.scrollTop || document.documentElement.scrollTop;
    if (typeof document.getElementsByClassName("floating-actionbar")[0] !== 'undefined') {
        actionBarHeight = document.getElementsByClassName("floating-actionbar")[0].offsetHeight;
    }
    if (typeof pEl.getBoundingClientRect === 'function') {
        clientRect = pEl.getBoundingClientRect();
        left = clientRect.left;
        top = clientRect.bottom + scrollTop;
    } else {//fallback for older browsers
        left = pEl.offsetLeft;
        top = pEl.offsetTop + pEl.offsetHeight;
        while (pEl != null) {
            left += pEl.offsetLeft;
            top += pEl.offsetTop;
            pEl = pEl.parent;
        }
    }

    if ((left + width > viewportWidth)) {
        left = left - width + targetElement.offsetWidth;
    }
    if ((top + height + actionBarHeight > viewportHeight + scrollTop) &&
        (top - height - targetElement.offsetHeight - actionBarHeight > 0)) {
        top = top - height - targetElement.offsetHeight;
    }
    repositionElement.style.left = left + 'px';
    repositionElement.style.top = top + 'px';
}
function pikaTrim(str) {
    return str.trim ? str.trim() : str.replace(/^\s+|\s+$/g, '');
}
function pikaHasClass(el, cn) {
    return (' ' + el.className + ' ').indexOf(' ' + cn + ' ') !== -1;
}
function pikaRemoveClass(el, cn) {
    el.className = pikaTrim((' ' + el.className + ' ').replace(' ' + cn + ' ', ' '));
}
function pikaAddClass(el, cn) {
    if (!pikaHasClass(el, cn)) {
        el.className = (el.className === '') ? cn : el.className + ' ' + cn;
    }
}
function hideIfClickOutsideMyBounds(self, e) {
    e = e || window.event;
    var target = e.target || e.srcElement,
        pEl = target;
    if (!target) {
        return;
    }
    if (!hasEventListeners && pikaHasClass(target, 'pika-select')) {
        if (!target.onchange) {
            target.setAttribute('onchange', 'return;');
            addEvent(target, 'change', self._onChange);
        }
    }
    do {
        if (pikaHasClass(pEl, 'pika-wrapper') || pEl === opts.trigger || pikaHasClass(pEl, 'pika-button')) {
            return;
        }
    }
    while ((pEl = pEl.parentNode));
    if (self._v && target !== opts.trigger && pEl !== opts.trigger) {
        self.hide();
    }
}
//Reposition the calendar and timepicker outside the funky nested dom-elements.
function fixPikaWrapperPositionInDOM() {
    var wrapper = document.getElementById("pika-wrapper");
    if (wrapper) {
        var parent = wrapper.parentNode;
        while (parent !== null && parent.tagName !== 'BODY') {
            parent = parent.parentNode;
        }
        if (parent != null) {
            parent.appendChild(wrapper);
            var wrapperTime = document.getElementById("pika-wrapper-time");
            parent.appendChild(wrapperTime);
        }
    }
}
fixPikaWrapperPositionInDOM();
/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.UIControls) == 'undefined') {
    Dynamicweb.UIControls = new Object();
}
/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.UIControls.DatePicker = function () {
    this.dict = {};
    this.defaultDates = {};
    this.names = [];
    var datepicker = this;
    function SetupPikaTime() {
        var wrapper = document.getElementById("pika-wrapper");
        var timeWrapper = document.getElementById("pika-wrapper-time");
        var pikaHour = document.getElementById("pika-hour");
        var pikaMinute = document.getElementById("pika-minute");
        var pikaTimeCurrentName = document.getElementById("pika-time-currentName");

        //Update time of the calendar-control
        function pikaUpdateTime() {
            var currentName = pikaTimeCurrentName.value;
            if (currentName !== "" && typeof (currentName) !== 'undefined') {
                var hours = parseInt(pikaHour.value);
                var minutes = parseInt(pikaMinute.value);
                if (!isNaN(hours) && !isNaN(minutes)) {
                    var currentDate = datepicker.GetDate(currentName);
                    if (currentDate === null) {
                        currentDate = new Date();
                    }
                    currentDate.setMinutes(minutes);
                    currentDate.setHours(hours);
                    var picker = datepicker.dict[currentName];
                    datepicker.UpdateCalenderDateFields(picker, currentDate, currentName);

                    picker.onChangeCallback(currentName, currentDate);
                }
            }
        }
        //OnChange event
        function setupOnTimeChange(element) {
            element.onchange = function () {
                if (element.value === "") {
                    element.value = 0;
                }
                pikaUpdateTime();
            }
        }
        setupOnTimeChange(pikaHour);
        setupOnTimeChange(pikaMinute);

        //KeyUp / KeyDown events
        function SetupEventListeners(inputField, callback) {
            var currentValue;
            inputField.onkeydown = function () {
                currentValue = inputField.value;
            }
            inputField.onkeyup = function () {
                if (inputField.value !== currentValue) {
                    callback();
                }
            }
            inputField.onpaste = function () {
                callback();
            }
        }
        SetupEventListeners(pikaHour, pikaUpdateTime);
        SetupEventListeners(pikaMinute, pikaUpdateTime);

        //Click outside the div -> close
        window.onclick = function (e) {
            pikaAddClass(timeWrapper, "is-hidden");
            pikaTimeCurrentName.value = "";
        };
        //stop closure of div, if the div is the target
        timeWrapper.onclick = function (event) {
            event.stopPropagation();
        };
    }
    SetupPikaTime();
}

Dynamicweb.UIControls.DatePicker._instance = null;

Dynamicweb.UIControls.DatePicker.get_current = function () {
    if (!Dynamicweb.UIControls.DatePicker._instance) {
        Dynamicweb.UIControls.DatePicker._instance = new Dynamicweb.UIControls.DatePicker();
    }
    return Dynamicweb.UIControls.DatePicker._instance;
}

Dynamicweb.UIControls.DatePicker.prototype.initPickaday = function (name, startYear, endYear, strCurrentDate, weekDaysArr, monthsArr, onChange, setDefaultDateValue, disabled) {
    var currentDate;
    var hiddenDateElement = document.getElementById(name + "_datepicker");
    // value stars with @Code in smartsearch rules type of date
    if (hiddenDateElement.value !== "" && !hiddenDateElement.value.toString().toLowerCase().startsWith("@code")) {
        currentDate = new Date(hiddenDateElement.value);
    } else if (strCurrentDate === "") {
        currentDate = new Date();
        if (isNaN(currentDate)) {
            currentDate = new Date(hiddenDateElement.value.replace(/-/g, '/'));
        }
    } else {
        currentDate = new Date(strCurrentDate);
    }
    if (currentDate.getFullYear() === 2999) {
        currentDate = new Date();
    }
    if (typeof getMonthNames !== "undefined") {
        monthsArr = getMonthNames();
    }
    if (typeof getDayNames !== "undefined") {
        weekDaysArr = getDayNames();
    }
    var datepickerControl = this;
    var picker = new Pikaday(
    {
        field: hiddenDateElement,
        firstDay: 1,
        defaultDate: currentDate,
        setDefaultDate: setDefaultDateValue !== false,
        minDate: new Date(startYear, 0, 1),
        maxDate: new Date(endYear, 11, 31),
        showWeekNumber: true,
        onSelect: function (date) {
            datepickerControl.UpdateCalenderDateFieldsUsingLabelAsTime(picker, date, name);
            picker.hide();
            picker.onChangeCallback(name, date);
        },
        yearRange: [startYear, endYear],
        i18n: {
            previousMonth: '<i class="md md-keyboard-arrow-left pika-prev"></i>',
            nextMonth: '<i class="md md-keyboard-arrow-right pika-next"></i>',
            months: monthsArr,
            weekdays: weekDaysArr,
            weekdaysShort: getDayNamesShort(weekDaysArr),
        },
        /*remove this to show datepicker on input-click*/
        container: document.getElementById('container'),
        bound: false,
        trigger: document.getElementById(name + "_calendar_btn"),
        disabled: disabled === true
    });

    picker.onChangeCallback = (onChange && typeof (onChange) === "function") ? onChange : function () { };

    this.SetupCalendarHead(picker);
    function getDayNamesShort(days) {
        var daysShort = [];
        for (var i = 0; i < days.length; i++) {
            daysShort.push(days[i].substring(0, 1));
        }
        return daysShort;
    }
    return picker;
}

Dynamicweb.UIControls.DatePicker.prototype.IsNotSet = function (prefix) {
    var fNotSet = document.getElementById(prefix + '_notSet');
    if (fNotSet) {
        return fNotSet.value.toLowerCase() === 'true';
    }
    return false;
}

Dynamicweb.UIControls.DatePicker.prototype.GetDate = function (name) {
    if (this.IsNotSet(name)) return null;
    var hiddenDateElement = document.getElementById(name + "_calendar");
    if (hiddenDateElement.value === "") return null;
    var currentDate = new Date(hiddenDateElement.value);
    //ie
    

    if (hiddenDateElement.value !== "" && !hiddenDateElement.value.toString().toLowerCase().startsWith("@code")) {
        currentDate = new Date(hiddenDateElement.value);
        if (isNaN(currentDate)) {
            currentDate = new Date(hiddenDateElement.value.replace(/-/g, '/'));
        }
    } else {
        currentDate = new Date();
    }

    return currentDate;
}

Dynamicweb.UIControls.DatePicker.prototype.SetDate = function (name, date, preventOnSelect) {
    if (typeof date === 'undefined' || date === null) {
        this.ClearDate(name);
        return;
    }
    var picker = this.dict[name];
    var currentDate = picker.getDate();
    var dateNotSet = this.IsNotSet(name);
    if (dateNotSet || currentDate.getFullYear() !== date.getFullYear() || currentDate.getMonth() !== date.getMonth() || currentDate.getDate() !== date.getDate() || currentDate.getHours() !== date.getHours() || currentDate.getMinutes() !== date.getMinutes()) {

        var fNotSet = document.getElementById(name + '_notSet');
        if (fNotSet != null) {
            fNotSet.value = "False";
        }

        picker.setDate(date, preventOnSelect);
    }

    var postbackDate = document.getElementById("DatePicker_" + name);
    var hiddenDateElement = document.getElementById(name + "_calendar");
    var dateString = "";
    if (date !== null) {
        var strMinutes = date.getMinutes() < 9 ? "0" + date.getMinutes() : date.getMinutes();
        var strHours = date.getHours() < 9 ? "0" + date.getHours() : date.getHours();
        var strDate = date.getDate() < 9 ? "0" + date.getDate() : date.getDate();
        dateString = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + strDate + " " + strHours + ":" + strMinutes; ///yyyy-MM-dd HH:mm
    }    
    var isChanged = false;
    if (hiddenDateElement.value != dateString) {
        isChanged = true;
    }
    hiddenDateElement.value = dateString;   
    if (isChanged) {
        var labelButton = document.getElementById(name + "_label");
        if (labelButton != null && labelButton.onchange != null) {
            labelButton.onchange();
        }        
    }   
}

Dynamicweb.UIControls.DatePicker.prototype.ClearDate = function (prefix) {
    var fLabel = document.getElementById(prefix + '_label');
    var fNotSet = document.getElementById(prefix + '_notSet');
    var picker = this.dict[prefix];
    if (fNotSet) {
        if (typeof picker !== 'undefined') {
            picker.setDate(new Date());
        }
        var isChanged = fNotSet.value != 'True';
        var resetDate = null;
        if (this.defaultDates[prefix] !== "")
            resetDate = new Date(this.defaultDates[prefix]);        
        if (resetDate) {
            this.SetDate(prefix, resetDate);
        }
        fNotSet.value = 'True';
        if (fLabel) {
            fLabel.innerHTML = document.getElementById('DWCalendarNotSetString').value;
            if (isChanged) {
                if (fLabel.onchange) {
                    fLabel.onchange();
                }
            }
        }        
    }
    picker.onChangeCallback();
}

Dynamicweb.UIControls.DatePicker.prototype.UpdateCalendarDate = function (date, name) {
    if (date.getFullYear() === 2999) {
        this.ClearDate(name);
    } else {
        var picker = this.dict[name];
        this.UpdateCalenderDateFields(picker, date, name);
    }
}

Dynamicweb.UIControls.DatePicker.prototype.UpdateCalenderDateFieldsUsingLabelAsTime = function (picker, date, name) {
    var hiddendate = this.GetDate(name);
    if (hiddendate !== null) {
        date.setMinutes(hiddendate.getMinutes());
        date.setHours(hiddendate.getHours());
    }
    this.UpdateCalenderDateFields(picker, date, name);
}

Dynamicweb.UIControls.DatePicker.prototype.UpdateCalenderDateFields = function (picker, date, name) {
    var target = document.getElementById(name + "_label");
    var dayName = picker.options.i18n.weekdays[date.getDay()].substring(0, 3); //Fri etc.
    var monthName = picker.options.i18n.months[date.getMonth()].substring(0, 3); //Jun etc
    var dateNumber = date.getDate();
    var strMinutes = date.getMinutes() < 9 ? "0" + date.getMinutes() : date.getMinutes();
    var strHours = date.getHours() < 9 ? "0" + date.getHours() : date.getHours();
    var btnTime = document.getElementById(name + "_calendar_time_btn");
    var useTime = btnTime !== null;
    var strDate = date.getDate() < 9 ? "0" + date.getDate() : date.getDate();
    var dateStr = dayName + ", " + strDate + " " + monthName + " " + date.getFullYear();//Wed, 13 Jan 2016 00:00
    if (useTime) {
        dateStr = dateStr + " " + strHours + ":" + strMinutes; //Wed, 13 Jan 2016 00:00
    }
    target.innerText = dateStr;

    this.SetDate(name, date, true);
}

Dynamicweb.UIControls.DatePicker.prototype.SetupCalendarHead = function (picker) {
    var date = picker.getDate();
    var fullYear = date.getFullYear();
    var monthName = picker.options.i18n.months[date.getMonth()].substring(0, 3);
    var dayName = picker.options.i18n.weekdays[date.getDay()].substring(0, 3);
    document.getElementById("datepicker-year").innerText = fullYear;
    document.getElementById("datepicker-date").innerText = dayName + ", " + monthName + " " + date.getDate();
}

//legacy-support
function DWClearDate(prefix) {
    // Set 'not set' value
    var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
    datepicker.ClearDate(prefix);
}

function SetupCalendarOnfocus(name, startYear, endYear, strCurrentDate, defaultDateStr, weekDays, months, onChange, setDefaultDateValue, disabled) {
    var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
    datepicker.defaultDates[name] = defaultDateStr;
    datepicker.names.push(name);
    if (typeof datepicker.dict[name] === 'undefined') {
        var picker = datepicker.initPickaday(name, startYear, endYear, strCurrentDate, weekDays, months, onChange, setDefaultDateValue, disabled);
        datepicker.dict[name] = picker;
    }
    if (name === "ValidFrom_Editor") {
        var t = datepicker.dict["ValidFrom_Editor"];
        console.log(t.getDate());
    }
    var pikaTimeCurrentName = document.getElementById("pika-time-currentName");
    var button = document.getElementById(name + "_calendar_btn");
    var labelButton = document.getElementById(name + "_label");
    if (disabled !== true) {
        button.onclick = labelButton.onclick = function(event) {
            var timeWrapper = document.getElementById("pika-wrapper-time");
            pikaAddClass(timeWrapper, "is-hidden");
            pikaTimeCurrentName.value = "";
            for (var i = 0; i < datepicker.names.length; i++) {
                var fetchedName = datepicker.names[i];
                var current = datepicker.dict[fetchedName];
                if (typeof current !== 'undefined') {
                    current.hide();
                }
            }
            datepicker.SetupCalendarHead(datepicker.dict[name]);
            datepicker.dict[name].show();
            event.stopPropagation();
            event.preventDefault();
        };
    } else {
        button.classList.add("disabled");
        labelButton.classList.add("disabled");
    }
    
    //UI button
    var buttonTime = document.getElementById(name + "_calendar_time_btn");
    if (buttonTime !== null) {
        if (disabled !== true) {
            buttonTime.onclick = function (event) {
                for (var i = 0; i < datepicker.names.length; i++) {
                    datepicker.dict[datepicker.names[i]].hide();
                }
                var timeWrapper = document.getElementById("pika-wrapper-time");
                pikaRemoveClass(timeWrapper, "is-hidden");
                var pikaTimeCurrentName = document.getElementById("pika-time-currentName");
                var pikaHour = document.getElementById("pika-hour");
                var pikaMinute = document.getElementById("pika-minute");
                adjustElementToOtherElement(timeWrapper, this);
                var picker = datepicker.dict[name];
                pikaTimeCurrentName.value = name;
                var currentDate = datepicker.GetDate(name);
                if (currentDate === null) {
                    pikaHour.value = 0;
                    pikaMinute.value = 0;
                } else {
                    pikaHour.value = currentDate.getHours();
                    pikaMinute.value = currentDate.getMinutes();
                }
                event.stopPropagation();
            };
        } else {
            button.classList.add("disabled");
        }
    }
}