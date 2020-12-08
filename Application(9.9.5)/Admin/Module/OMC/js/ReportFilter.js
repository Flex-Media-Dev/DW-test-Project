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

Dynamicweb.Controls.OMC.SequenceRenderer = function (data) {
    /// <summary>Represents a filter renderer that outputs a list of distinct values.</summary>
    /// <param name="data">Renderer data.</param>

    this._data = data;
    this._filter = null;
    this._selectedValues = [];
}

Dynamicweb.Controls.OMC.SequenceRenderer.prototype.get_filter = function () {
    /// <summary>Gets the reference to filter object that manages this renderer.</summary>

    return this._filter;
}

Dynamicweb.Controls.OMC.SequenceRenderer.prototype.set_filter = function (value) {
    /// <summary>Sets the reference to filter object that manages this renderer.</summary>
    /// <param name="value">The reference to filter object that manages this renderer.</param>

    this._filter = value;
}

Dynamicweb.Controls.OMC.SequenceRenderer.prototype.get_selectedValues = function () {
    /// <summary>Gets the list of values submitted for this filter.</summary>

    var selected = null;

    selected = this.get_filter().all('.omc-filter-options ul li input');

    if (selected && selected.length) {
        this._selectedValues = [];

        for (var i = 0; i < selected.length; i++) {
            if (selected[i].checked) {
                this._selectedValues[this._selectedValues.length] = selected[i].value;
            }
        }
    }

    return this._selectedValues || [];
}

Dynamicweb.Controls.OMC.SequenceRenderer.prototype.set_selectedValues = function (value) {
    /// <summary>Sets the list of values submitted for this filter.</summary>
    /// <param name="value">The list of values submitted for this filter.</param>

    this._selectedValues = value || [];
}

Dynamicweb.Controls.OMC.SequenceRenderer.prototype.render = function (params) {
    /// <summary>Render the filter.</summary>
    /// <param name="params">Additional rendering parameters.</param>

    var self = this;
    var list = null;
    var label = null;
    var input = null;
    var rendered = 0;
    var isString = '';
    var element = null;
    var optionLabel = '';
    var optionValue = null;
    var hasSelected = false;
    var options = this._data || [];
    var noData = this.get_filter().first('.omc-filter-empty');
    var resultsContainer = this.get_filter().first('.omc-filter-options');

    var attr = function (e, a, v) {
        Dynamicweb.Controls.OMC.ReportFilter.Global.setAttribute(e, a, v);
    }

    var isSelected = function (val) {
        var ret = false;
        var values = self._selectedValues;

        if (values && values.length) {
            for (var i = 0; i < values.length; i++) {
                if (values[i] == val) {
                    ret = true;
                    break;
                }
            }
        }

        return ret;
    }

    if (!params) {
        params = {};
    }

    if (resultsContainer) {
        resultsContainer.hide();
        resultsContainer.update('');

        if (options && options.length) {
            list = document.createElement('UL');

            for (var i = 0; i < options.length; i++) {
                optionLabel = typeof (options[i].label) == 'undefined' ? options[i] : options[i].label;
                optionValue = typeof (options[i].value) == 'undefined' ? options[i] : options[i].value;

                isString = typeof (optionValue) == 'string';
                if (typeof (optionValue) != 'undefined' && optionValue != null && ((isString && optionValue.length) || !isString)) {
                    element = document.createElement('LI');

                    input = document.createElement('INPUT');
                    input.id = this.get_filter().get_factID() + optionValue;

                    if (this.get_filter().get_allowMultiSelect()) {
                        input.type = 'checkbox';
                    } else {
                        input.type = 'radio';
                    }

                    input.name = this.get_filter().get_factID();
                    input.value = optionValue;

                    if (this.get_filter().get_allowMultiSelect()) {
                        input.checked = isSelected(optionValue);
                    } else if (!hasSelected) {
                        input.checked = isSelected(optionValue);
                        if (input.checked) {
                            hasSelected = true;
                        }
                    }

                    if (input.checked) {
                        attr(input, 'checked', 'checked');
                    }

                    $(input).observe('click', function (e) {
                        var t = Event.element(e);

                        /* Fixing problems with tracking form state via "innerHTML" */
                        attr(t, 'checked', t.checked ? 'checked' : null);
                    });

                    label = document.createElement('LABEL');
                    $(label).writeAttribute('for', input.id);
                    label.appendChild(document.createTextNode(optionLabel));

                    element.appendChild(input);
                    element.appendChild(label);

                    list.appendChild(element);

                    rendered += 1;
                }
            }

            if (rendered > 0) {
                resultsContainer.appendChild(list);

                if (!this.get_filter().get_autoLoad() || this.get_filter().get_isActive() || !!params.forceActive) {
                    resultsContainer.show();
                }

                if (noData) {
                    noData.hide();
                }
            } else if (noData) {
                noData.show();
            }
        } else if (noData) {
            noData.show();
        }
    } else if (noData) {
        noData.show();
    }
}

Dynamicweb.Controls.OMC.LabelRenderer = function (label) {
    /// <summary>Represents a filter renderer that outputs a static label.</summary>
    /// <param name="label">Label to output.</param>

    this._label = label;
    this._filter = null;
    this._selectedValues = [ 'Applied' ];
}

Dynamicweb.Controls.OMC.LabelRenderer.prototype.get_label = function () {
    /// <summary>Gets the label to be displayed.</summary>

    return this._label;
}

Dynamicweb.Controls.OMC.LabelRenderer.prototype.set_label = function (value) {
    /// <summary>Sets the label to be displayed.</summary>
    /// <param name="value">The label to be displayed.</param>

    this._label = value;
}

Dynamicweb.Controls.OMC.LabelRenderer.prototype.get_filter = function () {
    /// <summary>Gets the reference to filter object that manages this renderer.</summary>

    return this._filter;
}

Dynamicweb.Controls.OMC.LabelRenderer.prototype.set_filter = function (value) {
    /// <summary>Sets the reference to filter object that manages this renderer.</summary>
    /// <param name="value">The reference to filter object that manages this renderer.</param>

    this._filter = value;
}

Dynamicweb.Controls.OMC.LabelRenderer.prototype.get_selectedValues = function () {
    /// <summary>Gets the list of values submitted for this filter.</summary>
    
    return this._selectedValues;
}

Dynamicweb.Controls.OMC.LabelRenderer.prototype.set_selectedValues = function (value) {
    /// <summary>Sets the list of values submitted for this filter.</summary>
    /// <param name="value">The list of values submitted for this filter.</param>

    /* Setter has no effect - filter is always applied */
}

Dynamicweb.Controls.OMC.LabelRenderer.prototype.render = function (params) {
    /// <summary>Render the filter.</summary>
    /// <param name="params">Additional rendering parameters.</param>

    var resultsContainer = this.get_filter().first('.omc-filter-options');

    if (!params) {
        params = {};
    }

    if (resultsContainer) {
        resultsContainer.innerHTML = '';
        resultsContainer.appendChild(new Element('div', { 'class': 'omc-filter-label' }).update(this.get_label()));

        if (!this.get_filter().get_autoLoad() || this.get_filter().get_isActive() || !!params.forceActive) {
            resultsContainer.style.display = '';
        }
    }
}

Dynamicweb.Controls.OMC.FreeTextRenderer = function (defaultValue) {
    /// <summary>Represents a filter renderer that outputs a text field.</summary>
    /// <param name="defaultValue">Default value.</param>

    this._filter = null;
    this._selectedValues = [];

    if (defaultValue) {
        this._selectedValues = [ defaultValue ];
    }
}

Dynamicweb.Controls.OMC.FreeTextRenderer.prototype.get_filter = function () {
    /// <summary>Gets the reference to filter object that manages this renderer.</summary>

    return this._filter;
}

Dynamicweb.Controls.OMC.FreeTextRenderer.prototype.set_filter = function (value) {
    /// <summary>Sets the reference to filter object that manages this renderer.</summary>
    /// <param name="value">The reference to filter object that manages this renderer.</param>

    this._filter = value;
}

Dynamicweb.Controls.OMC.FreeTextRenderer.prototype.get_selectedValues = function () {
    /// <summary>Gets the list of values submitted for this filter.</summary>

    var input = this.get_filter().first('.omc-filter-options input');

    if (input) {
        this._selectedValues = [input.value];
    }

    return this._selectedValues || [];
}

Dynamicweb.Controls.OMC.FreeTextRenderer.prototype.set_selectedValues = function (value) {
    /// <summary>Sets the list of values submitted for this filter.</summary>
    /// <param name="value">The list of values submitted for this filter.</param>

    var input = this.get_filter().first('.omc-filter-options input');

    if (value && value.length) {
        this._selectedValues = value;
    } else {
        this._selectedValues = [];
    }

    if (input) {
        input.value = this._selectedValues[0];
    }
}

Dynamicweb.Controls.OMC.FreeTextRenderer.prototype.render = function (params) {
    /// <summary>Render the filter.</summary>
    /// <param name="params">Additional rendering parameters.</param>

    var input = null;
    var value = (this.get_selectedValues() || [])[0] || '';
    var resultsContainer = this.get_filter().first('.omc-filter-options');

    var attr = function (e, a, v) {
        Dynamicweb.Controls.OMC.ReportFilter.Global.setAttribute(e, a, v);
    }

    if (!params) {
        params = {};
    }

    if (resultsContainer) {
        resultsContainer.innerHTML = '';

        input = new Element('input', { 'type': 'text', 'class': 'std omc-filter-freetext' });
        input.value = value;

        attr(input, 'value', value);

        $(input).observe('keypress', function (e) {
            var t = Event.element(e);

            /* Fixing problems with tracking form state via "innerHTML" */
            attr(t, 'value', t.value);
        });

        resultsContainer.appendChild(input);

        if (!this.get_filter().get_autoLoad() || this.get_filter().get_isActive() || !!params.forceActive) {
            resultsContainer.style.display = '';
        }
    }
}

Dynamicweb.Controls.OMC.RangeRenderer = function (lowerBound, upperBound) {
    /// <summary>Represents a filter renderer that outputs a two text fields representing a range.</summary>
    /// <param name="lowerBound">Lower bound.</param>
    /// <param name="upperBound">Upper bound.</param>

    this._filter = null;
    this._selectedValues = [];

    if (lowerBound || upperBound) {
        this._selectedValues = ['', ''];
        if (lowerBound) {
            this._selectedValues[0] = lowerBound;
        }

        if (upperBound) {
            this._selectedValues[1] = upperBound;
        }
    }
}

Dynamicweb.Controls.OMC.RangeRenderer.prototype.get_filter = function () {
    /// <summary>Gets the reference to filter object that manages this renderer.</summary>

    return this._filter;
}

Dynamicweb.Controls.OMC.RangeRenderer.prototype.set_filter = function (value) {
    /// <summary>Sets the reference to filter object that manages this renderer.</summary>
    /// <param name="value">The reference to filter object that manages this renderer.</param>

    this._filter = value;
}

Dynamicweb.Controls.OMC.RangeRenderer.prototype.get_selectedValues = function () {
    /// <summary>Gets the list of values submitted for this filter.</summary>

    var lowerBound = this.get_filter().first('.omc-filter-options input.omc-filter-range-lower');
    var upperBound = this.get_filter().first('.omc-filter-options input.omc-filter-range-upper');

    if (lowerBound || upperBound) {
        this._selectedValues = ['', ''];

        if (lowerBound) {
            this._selectedValues[0] = lowerBound.value;
        }

        if (upperBound) {
            this._selectedValues[1] = upperBound.value;
        }
    }

    return this._selectedValues || [];
}

Dynamicweb.Controls.OMC.RangeRenderer.prototype.set_selectedValues = function (value) {
    /// <summary>Sets the list of values submitted for this filter.</summary>
    /// <param name="value">The list of values submitted for this filter.</param>

    var lowerBound = this.get_filter().first('.omc-filter-options input.omc-filter-range-lower');
    var upperBound = this.get_filter().first('.omc-filter-options input.omc-filter-range-upper');

    if (value && value.length) {
        this._selectedValues = value;
    } else {
        this._selectedValues = [];
    }

    if (lowerBound) {
        lowerBound.value = this._selectedValues[0];
    }

    if (upperBound) {
        upperBound.value = this._selectedValues[1];
    }
}

Dynamicweb.Controls.OMC.RangeRenderer.prototype.render = function (params) {
    /// <summary>Render the filter.</summary>
    /// <param name="params">Additional rendering parameters.</param>

    var html = '';
    var values = this.get_selectedValues() || [];
    var resultsContainer = this.get_filter().first('.omc-filter-options');

    var attr = function (e, a, v) {
        Dynamicweb.Controls.OMC.ReportFilter.Global.setAttribute(e, a, v);
    }

    if (!params) {
        params = {};
    }

    if (resultsContainer) {
        resultsContainer.innerHTML = '';

        if (!values[0]) {
            values[0] = '';
        }

        if (!values[1]) {
            values[1] = '';
        }

        html = '<div class="omc-range">';
        html += '<table border="0" cellspacing="0" cellpadding="0">';
        html += '<tr>';
        html += '<td>';
        html += '<input type="text" class="std omc-filter-range-lower" value="' + values[0].replace(/"/gi, '&quot;') + '" />';
        html += '</td>';
        html += '<td>&nbsp;&ndash;&nbsp;</td>';
        html += '<td>';
        html += '<input type="text" class="std omc-filter-range-upper" value="' + values[1].replace(/"/gi, '&quot;') + '" />';
        html += '</td>';
        html += '</tr>';
        html += '</table>';
        html += '</div>';

        resultsContainer.innerHTML = html;

        resultsContainer.select('input').each(function (i) {
            $(i).observe('keypress', function (e) {
                var t = Event.element(e);

                /* Fixing problems with tracking form state via "innerHTML" */
                attr(t, 'value', t.value);
            });
        });

        if (!this.get_filter().get_autoLoad() || this.get_filter().get_isActive() || !!params.forceActive) {
            resultsContainer.style.display = '';
        }
    }
}

Dynamicweb.Controls.OMC.DropDownRenderer = function (data) {
    /// <summary>Represents a filter renderer that outputs a drop-down list.</summary>
    /// <param name="data">Renderer data.</param>

    this._data = data;
    this._filter = null;
    this._selectedValues = [];
}

Dynamicweb.Controls.OMC.DropDownRenderer.prototype.get_filter = function () {
    /// <summary>Gets the reference to filter object that manages this renderer.</summary>

    return this._filter;
}

Dynamicweb.Controls.OMC.DropDownRenderer.prototype.set_filter = function (value) {
    /// <summary>Sets the reference to filter object that manages this renderer.</summary>
    /// <param name="value">The reference to filter object that manages this renderer.</param>

    this._filter = value;
}

Dynamicweb.Controls.OMC.DropDownRenderer.prototype.get_selectedValues = function () {
    /// <summary>Gets the list of values submitted for this filter.</summary>

    var dropDown = null;

    dropDown = this.get_filter().first('.omc-filter-options select');

    if (dropDown) {
        this._selectedValues = [];

        if (dropDown.selectedIndex >= 0 && dropDown.selectedIndex < dropDown.options.length) {
            this._selectedValues[0] = dropDown.options[dropDown.selectedIndex].value;
        }
    }

    return this._selectedValues || [];
}

Dynamicweb.Controls.OMC.DropDownRenderer.prototype.set_selectedValues = function (value) {
    /// <summary>Sets the list of values submitted for this filter.</summary>
    /// <param name="value">The list of values submitted for this filter.</param>

    this._selectedValues = value || [];
}

Dynamicweb.Controls.OMC.DropDownRenderer.prototype.render = function (params) {
    /// <summary>Render the filter.</summary>
    /// <param name="params">Additional rendering parameters.</param>

    var list = null;
    var item = null;
    var options = this._data || [];
    var selectedValue = this._selectedValues[0];
    var noData = this.get_filter().first('.omc-filter-empty');
    var resultsContainer = this.get_filter().first('.omc-filter-options');
    
    var attr = function (e, a, v) {
        Dynamicweb.Controls.OMC.ReportFilter.Global.setAttribute(e, a, v);
    }

    if (!params) {
        params = {};
    }

    if (resultsContainer) {
        resultsContainer.hide();
        resultsContainer.update('');

        if (options && options.length) {
            list = new Element('select', { 'class': 'std omc-dropdown' });

            for (var i = 0; i < options.length; i++) {
                item = new Element('option');

                item.writeAttribute('value', options[i].value);
                item.innerHTML = options[i].label;

                if (selectedValue == options[i].value) {
                    attr(item, 'selected', 'selected');
                }

                $(list).observe('change', function (e) {
                    var t = Event.element(e);
                    var sel = t.options[t.selectedIndex].value;

                    t.select('option').each(function (i) {
                        /* Fixing problems with tracking form state via "innerHTML" */
                        attr(i, 'selected', i.value == sel ? 'selected' : null);
                    });
                });

                list.appendChild(item);
            }

            resultsContainer.appendChild(list);

            if (!this.get_filter().get_autoLoad() || this.get_filter().get_isActive() || !!params.forceActive) {
                resultsContainer.show();
            }

        } else if (noData) {
            noData.show();
        }
    } else if (noData) {
        noData.show();
    }
}

Dynamicweb.Controls.OMC.YesNoRenderer = function () {
    /// <summary>Renders a radio button list that contains three options - "Yes", "No" and "Not specified".</summary>

    this._filter = null;
    this._selectedValue = null;
}

Dynamicweb.Controls.OMC.YesNoRenderer.prototype.get_filter = function () {
    /// <summary>Gets the reference to filter object that manages this renderer.</summary>

    return this._filter;
}

Dynamicweb.Controls.OMC.YesNoRenderer.prototype.set_filter = function (value) {
    /// <summary>Sets the reference to filter object that manages this renderer.</summary>
    /// <param name="value">The reference to filter object that manages this renderer.</param>

    this._filter = value;
}

Dynamicweb.Controls.OMC.YesNoRenderer.prototype.get_selectedValues = function () {
    /// <summary>Gets the list of values submitted for this filter.</summary>

    var selected = this.get_filter().all('.omc-filter-options ul li input');;

    if (selected && selected.length) {
        this._selectedValue = '';

        for (var i = 0; i < selected.length; i++) {
            if (selected[i].checked) {
                this._selectedValue = selected[i].value.toLowerCase();
                break;
            }
        }
    }

    return [ this._selectedValue ];
}

Dynamicweb.Controls.OMC.YesNoRenderer.prototype.set_selectedValues = function (value) {
    /// <summary>Sets the list of values submitted for this filter.</summary>
    /// <param name="value">The list of values submitted for this filter.</param>

    this._selectedValue = '';

    if (value && value.length) {
        if (typeof (value[0]) != 'undefined' && value[0] != null) {
            if (typeof (value[0]) == 'string') {
                this._selectedValue = (value[0].toLowerCase() == 'true' || value[0].toLowerCase() == '1') ? 'true' : 'false';
            } else if (typeof (value[0]) == 'number') {
                this._selectedValue = value[0] != 0 ? 'true' : 'false';
            } else {
                this._selectedValue = !!value[0] ? 'true' : 'false';
            }
        }
    }
}

Dynamicweb.Controls.OMC.YesNoRenderer.prototype.render = function (params) {
    /// <summary>Render the filter.</summary>
    /// <param name="params">Additional rendering parameters.</param>

    var self = this;
    var list = null;
    var label = null;
    var input = null;
    var element = null;
    var hasSelected = false;
    var noData = this.get_filter().first('.omc-filter-empty');
    var resultsContainer = this.get_filter().first('.omc-filter-options');

    var attr = function (e, a, v) {
        Dynamicweb.Controls.OMC.ReportFilter.Global.setAttribute(e, a, v);
    }

    var options = [
        { text: Dynamicweb.Controls.OMC.ReportFilter.Global.getString('NotSpecified'), value: '' },
        { text: Dynamicweb.Controls.OMC.ReportFilter.Global.getString('Yes'), value: 'true' },
        { text: Dynamicweb.Controls.OMC.ReportFilter.Global.getString('No'), value: 'false' }
    ];

    if (!params) {
        params = {};
    }

    if (resultsContainer) {
        resultsContainer.hide();
        resultsContainer.update('');

        list = document.createElement('UL');

        for (var i = 0; i < options.length; i++) {
            element = document.createElement('LI');

            input = document.createElement('INPUT');
            input.id = this.get_filter().get_factID() + options[i].value;
            input.type = 'radio';
            input.name = this.get_filter().get_factID();
            input.value = options[i].value;

            if (!hasSelected) {
                input.checked = options[i].value.toLowerCase() ==
                    this._selectedValue.toLowerCase();

                if (input.checked) {
                    hasSelected = true;
                }
            }

            if (input.checked) {
                attr(input, 'checked', 'checked');
            }

            $(input).observe('click', function (e) {
                var t = Event.element(e);
                var items = t.up('ul').select('input');

                for (var i = 0; i < items.length; i++) {
                    /* Fixing problems with tracking form state via "innerHTML" */
                    attr(items[i], 'checked', items[i].value == t.value ? 'checked' : null);
                }
            });

            label = document.createElement('LABEL');
            $(label).writeAttribute('for', input.id);
            label.appendChild(document.createTextNode(options[i].text));

            element.appendChild(input);
            element.appendChild(label);

            list.appendChild(element);
        }

        resultsContainer.appendChild(list);

        if (!this.get_filter().get_autoLoad() || this.get_filter().get_isActive() || !!params.forceActive) {
            resultsContainer.show();
        }

        if (noData) {
            noData.hide();
        }
    } else if (noData) {
        noData.show();
    }
}

Dynamicweb.Controls.OMC.DateRangeRenderer = function (dateFrom, dateTo) {
    /// <summary>Represents date range filter renderer.</summary>
    /// <param name="dateFrom">A reference to "From date" date selector control.</param>
    /// <param name="dateTo">A reference to "To date" date selector control.</param>

    this._dateFromID = dateFrom;
    this._dateToID = dateTo;

    this._dateFrom = null;
    this._dateTo = null;

    this._filter = null;
    this._selectedValue = null;
}

Dynamicweb.Controls.OMC.DateRangeRenderer.prototype.get_filter = function () {
    /// <summary>Gets the reference to filter object that manages this renderer.</summary>

    return this._filter;
}

Dynamicweb.Controls.OMC.DateRangeRenderer.prototype.set_filter = function (value) {
    /// <summary>Sets the reference to filter object that manages this renderer.</summary>
    /// <param name="value">The reference to filter object that manages this renderer.</param>

    this._filter = value;
}

Dynamicweb.Controls.OMC.DateRangeRenderer.prototype.get_dateFrom = function () {
    /// <summary>Gets the reference to "From date" date selector control.</summary>

    if (!this._dateFrom && this._dateFromID) {
        if (typeof (this._dateFromID) == 'string') {
            try {
                this._dateFrom = eval(this._dateFromID);
            } catch (ex) { }
        } else {
            this._dateFrom = this._dateFromID;
        }

        if (this._dateFrom) {
            this._dateFromID = null;
        }
    }

    return this._dateFrom;
}

Dynamicweb.Controls.OMC.DateRangeRenderer.prototype.get_dateTo = function () {
    /// <summary>Gets the reference to "To date" date selector control.</summary>

    if (!this._dateTo && this._dateToID) {
        if (typeof (this._dateToID) == 'string') {
            try {
                this._dateTo = eval(this._dateToID);
            } catch (ex) { }
        } else {
            this._dateTo = this._dateToID;
        }

        if (this._dateTo) {
            this._dateToID = null;
        }
    }

    return this._dateTo;
}

Dynamicweb.Controls.OMC.DateRangeRenderer.prototype.get_selectedValues = function () {
    /// <summary>Gets the list of values submitted for this filter.</summary>

    var ret = [];
    var defaultDate = '01-01-1970';
    
    if (this.get_dateFrom()) {
        ret[0] = this.get_dateFrom().formatDate(this.get_dateFrom().get_selectedDate(), this.get_dateFrom().get_dateFormat());
    } else {
        ret[0] = defaultDate;
    }

    if (this.get_dateTo()) {
        ret[1] = this.get_dateTo().formatDate(this.get_dateTo().get_selectedDate(), this.get_dateTo().get_dateFormat());
    } else {
        ret[1] = defaultDate;
    }

    return ret;
}

Dynamicweb.Controls.OMC.DateRangeRenderer.prototype.set_selectedValues = function (value) {
    /// <summary>Sets the list of values submitted for this filter.</summary>
    /// <param name="value">The list of values submitted for this filter.</param>

    var dtFrom = null, dtTo = null;

    if (value && value.length > 0) {
        dtFrom = value[0];
        if (value.length > 1) {
            dtTo = value[1];
        }
        
        if (this.get_dateFrom() && dtFrom) {
            if (typeof (dtFrom.getTime) == 'function') {
                this.get_dateFrom().set_selectedDate(dtFrom);
            } else if (typeof (dtFrom) == 'string') {
                if (dtFrom.indexOf('new Date(') == 0) {
                    this.get_dateFrom().set_selectedDate(eval(dtFrom));
                } else {
                    this.get_dateFrom().set_selectedDate(this._parseDate(dtFrom));
                }
            }
        }

        if (this.get_dateTo() && dtTo) {
            if (typeof (dtTo.getTime) == 'function') {
                this.get_dateTo().set_selectedDate(dtTo);
            } else if (typeof (dtTo) == 'string') {
                if (dtTo.indexOf('new Date(') == 0) {
                    this.get_dateTo().set_selectedDate(eval(dtTo));
                } else {
                    this.get_dateTo().set_selectedDate(this._parseDate(dtTo));
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.DateRangeRenderer.prototype.render = function (params) {
    /// <summary>Render the filter.</summary>
    /// <param name="params">Additional rendering parameters.</param>

    if (!params) {
        params = {};
    }

    // Rendering takes place server-side.
}

Dynamicweb.Controls.OMC.DateRangeRenderer.prototype._parseDate = function (dateString) {
    /// <summary>Parses the given date from the given date string.</summary>
    /// <param name="dateString">Date string.</param>
    /// <private />

    var rx = null;
    var ret = null;
    var match = null;
    var pattern = '^([0-9]{1,2})-([0-9]{1,2})-([0-9]{4})$';

    if (dateString && typeof (dateString) == 'string') {
        rx = new RegExp(pattern, 'gi');
        match = rx.exec(dateString);

        if (match) {
            ret = new Date(parseInt(match[3], 10) || 1970,
                Math.abs(parseInt(match[2], 10) - 1) || 0, parseInt(match[1], 10) || 1);
        } else {
            ret = new Date(dateString);
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ReportFilter = function (controlID) {
    /// <summary>Represents report filter.</summary>
    /// <param name="controlID">The unique identifier of the ASP.NET control that is associated with this client object.</param>

    this._associatedControlID = controlID;
    this._container = null;
    this._factID = '';
    this._allowMultiSelect = false;
    this._width = 300;
    this._height = 150;
    this._headingHeight = 16;
    this._initialized = false;
    this._optionsLoaded = false;
    this._loadingTimeoutID = 0;
    this._fixedDimensions = false;
    this._renderer = null;
    this._selectedValues = [];
    this._autoLoad = false;
    this._isActive = false;
    this._forceActiveOnRender = false;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_associatedControlID = function () {
    /// <summary>Gets the unique identifier of the ASP.NET control that is associated with this client object.</summary>

    return this._associatedControlID;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_associatedControlID = function (value) {
    /// <summary>Sets the unique identifier of the ASP.NET control that is associated with this client object.</summary>
    /// <param name="value">The unique identifier of the ASP.NET control that is associated with this client object.</param>

    this._associatedControlID = value;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_container = function () {
    /// <summary>Gets the identifier of the DOM element associated with this control.</summary>

    return this._container;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_container = function (value) {
    /// <summary>Sets the identifier of the DOM element associated with this control.</summary>
    /// <param name="value">The identifier of the DOM element associated with this control.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_renderer = function () {
    /// <summary>Gets an object that is responsible for rendering the filter.</summary>

    return this._renderer;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_renderer = function (value) {
    /// <summary>Sets an object that is responsible for rendering the filter.</summary>
    /// <param name="value">An object that is responsible for rendering the filter.</param>

    this._renderer = value;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_fixedDimensions = function () {
    /// <summary>Gets value indicating filter have a constant width and height no matter how many options it contains.</summary>

    return this._fixedDimensions;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_fixedDimensions = function (value) {
    /// <summary>Sets value indicating filter have a constant width and height no matter how many options it contains.</summary>
    /// <param name="value">Value indicating filter have a constant width and height no matter how many options it contains.</param>

    this._fixedDimensions = !!value;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_factID = function () {
    /// <summary>Gets the unique identifier of the target fact.</summary>

    return this._factID;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_factID = function (value) {
    /// <summary>Sets the unique identifier of the target fact.</summary>
    /// <param name="value">The unique identifier of the target fact.</param>

    this._factID = value;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_autoLoad = function () {
    /// <summary>Gets value indicating whether to load filter options on page load.</summary>

    return this._autoLoad;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_autoLoad = function (value) {
    /// <summary>Sets value indicating whether to load filter options on page load.</summary>
    /// <param name="value">Value indicating whether to load filter options on page load.</param>

    this._autoLoad = !!value;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_isInitialized = function () {
    /// <summary>Gets value indicating whether control has been initialized.</summary>

    return this._initialized;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_optionsLoaded = function () {
    /// <summary>Gets value indicating whether filter options has been populated.</summary>

    return this._optionsLoaded;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_hasOptions = function () {
    /// <summary>Gets value indicating whether there are any options available for the filter.</summary>

    var ret = false;

    if (this.get_isInitialized() && this.get_optionsLoaded()) {
        ret = this.first('.omc-filter-options').descendants().length > 0;
    }

    return ret;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_selectedValues = function () {
    /// <summary>Gets the list of values submitted for this filter.</summary>
    
    if (this.get_isInitialized() && this.get_isActive() && this.get_renderer()) {
        this._selectedValues = this.get_renderer().get_selectedValues();
    }

    if (!this._selectedValues) {
        this._selectedValues = [];
    }

    return this._selectedValues;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_selectedValues = function (value) {
    /// <summary>Sets the list of values submitted for this filter.</summary>
    /// <param name="value">The list of values submitted for this filter.</param>

    this._selectedValues = value || [];

    if (this.get_renderer()) {
        this.get_renderer().set_selectedValues(value);
    }
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_isActive = function () {
    /// <summary>Gets value indicating whether filter is active.</summary>

    var ret = false;
    var noData = this.first('.omc-filter-empty');
    var options = this.first('.omc-filter-options');

    if (options) {
        ret = options.getStyle('display') != 'none';
    }

    if (!ret && noData) {
        ret = noData.getStyle('display') != 'none';
    }

    return ret;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_isActive = function (value) {
    /// <summary>Sets value indicating whether filter is active.</summary>
    /// <param name="value">Value indicating whether filter is active.</param>

    var lnk = this.first('.omc-filter-trigger');
    var noData = this.first('.omc-filter-empty');
    var options = this.first('.omc-filter-options');

    var linkStatus = function (isVisible) {
        if (lnk) {
            if (isVisible) {
                lnk.addClassName('omc-filter-trigger-expanded');
                lnk.removeClassName('omc-filter-trigger-collapsed');
            } else {
                lnk.addClassName('omc-filter-trigger-collapsed');
                lnk.removeClassName('omc-filter-trigger-expanded');
            }
        }
    }

    this._forceActiveOnRender = !!value;

    if (value) {
        linkStatus(true);

        if (this.get_optionsLoaded()) {
            if (this.get_hasOptions()) {
                if (options) {
                    options.show();
                }
            } else if (noData) {
                noData.show();
            }

        } else if (!this.get_autoLoad()) {
            this.reloadOptions();
        }
    } else {
        linkStatus(false);

        if (options) {
            options.hide();
        }

        if (noData) {
            noData.hide();
        }
    }
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_allowMultiSelect = function () {
    /// <summary>Gets value indicating whether user can select multiple options at a time.</summary>

    return this._allowMultiSelect;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_allowMultiSelect = function (value) {
    /// <summary>Sets value indicating whether user can select multiple options at a time.</summary>
    /// <param name="value">Value indicating whether user can select multiple options at a time.</param>

    this._allowMultiSelect = !!value;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_width = function () {
    /// <summary>Gets the width of the control (in pixels).</summary>

    return this._width;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_width = function (value) {
    /// <summary>Sets the width of the control (in pixels).</summary>
    /// <param name="value">The width of the control (in pixels).</param>

    this._width = parseInt(value) || 300;

    if (this.get_isInitialized()) {
        this.refresh();
    }
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.get_height = function () {
    /// <summary>Gets the height of the control (in pixels).</summary>

    return this._height;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.set_height = function (value) {
    /// <summary>Sets the height of the control (in pixels).</summary>
    /// <param name="value">The height of the control (in pixels).</param>

    this._height = parseInt(value) || 150;

    if (this.get_isInitialized()) {
        this.refresh();
    }
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.add_ready = function (callback) {
    /// <summary>Registers new callback which is executed when the page is loaded.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }
    Event.observe(document, 'dom:loaded', function () {
        callback(this, {});
    });
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    if (!this._initialized) {
        this._initialized = true;
    }
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.refresh = function () {
    /// <summary>Updates the visual representation of the control.</summary>

    var children = [];
    var paddingTop = 0;
    var optionsHeight = 0;
    var container = $(this.get_container());
    var noData = this.first('.omc-filter-empty');
    var options = this.first('.omc-filter-options');
    var loadingData = this.first('.omc-filter-loading');
    var containerHeight = this.get_height() - this._headingHeight;

    if (container) {
        paddingTop = parseInt(containerHeight / 2 - 10);

        container.setStyle({ 'width': this.get_width() + 'px' });

        if (options) {
            children = options.childElements();
            if (children && children.length) {
                optionsHeight = $(children[0]).getHeight();
            }

            if (optionsHeight > containerHeight || this.get_fixedDimensions()) {
                options.setStyle({ 'height': containerHeight + 'px', 'border': '1px solid #dddddd' });
            } else {
                options.setStyle({ 'height': 'auto', 'border': '1px solid #ffffff', 'overflow': 'hidden' });
            }
        }

        if (noData) {
            if (this.get_fixedDimensions()) {
                noData.removeClassName('omc-filter-empty-left');
            } else {
                noData.addClassName('omc-filter-empty-left');
            }

            if (this.get_fixedDimensions()) {
                noData.setStyle({ 'height': (containerHeight - paddingTop) + 'px', 'paddingTop': paddingTop + 'px' });
            } else {
                noData.setStyle({ 'height': 'auto', 'paddingTop': '0px' });
            }

            noData.setStyle({ 'border': '1px solid ' + (this.get_fixedDimensions() ? '#dddddd' : '#ffffff') });
        }

        if (loadingData && this.get_fixedDimensions()) {
            loadingData.setStyle({ 'height': (containerHeight - paddingTop) + 'px', 'paddingTop': paddingTop + 'px' });
        }
    }
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.reloadOptions = function (onComplete) {
    /// <summary>Reloads filter options.</summary>
    /// <param name="onComplete">Callback to be executed when options are loaded and populated.</param>

    var self = this;
    var noData = this.first('.omc-filter-empty');
    var loadingData = this.first('.omc-filter-loading');

    onComplete = onComplete || function () { }

    this._optionsLoaded = false;

    if (!this.get_fixedDimensions()) {
        loadingData = this.first('.omc-filter-loading-img');
    }

    Dynamicweb.Ajax.DataLoader.load({
        target: this.get_associatedControlID(),
        argument: this.get_factID(),
        onComplete: function (results, resultParams) {
            self.onOptionsLoaded(results, resultParams, onComplete);
        }
    });

    if (noData) {
        noData.hide();
    }

    if (loadingData) {
        if (this._loadingTimeoutID) {
            clearTimeout(this._loadingTimeoutID);
            this._loadingTimeoutID = null;
        }

        this._loadingTimeoutID = setTimeout(function () {
            loadingData.show();
        }, 300);
    }
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.onOptionsLoaded = function (results, resultParams, onComplete) {
    /// <summary>Populates filter options according to the data that came from the server.</summary>
    /// <param name="results">Results.</param>
    /// <param name="resultParams">Meta information about the results.</param>
    /// <param name="onComplete">Callback to be executed when options are loaded and populated.</param>

    var valuesSet = false;
    var resultsContainer = null;
    var originalSelectedValues = null;
    var noData = this.first('.omc-filter-empty');
    var loadingData = this.first('.omc-filter-loading');

    if (!this.get_fixedDimensions()) {
        loadingData = this.first('.omc-filter-loading-img');
    }

    onComplete = onComplete || function () { }

    this._optionsLoaded = true;

    if (this._loadingTimeoutID) {
        clearTimeout(this._loadingTimeoutID);
        this._loadingTimeoutID = null;
    }

    if (loadingData) {
        loadingData.hide();
    }

    if (results) {
        if (typeof (results.render) == 'function') {
            this.attachRenderer(results);

            if (this.get_renderer()) {
                this.get_renderer().set_selectedValues(this.get_selectedValues());
            }

            this.get_renderer().render({ forceActive: this.get_autoLoad() && this._forceActiveOnRender });
        } else if (resultParams && resultParams.plainText) {
            resultsContainer = this.first('.omc-filter-options');

            if (resultsContainer) {
                originalSelectedValues = this.get_selectedValues();

                Dynamicweb.Controls.OMC.ReportFilter.Current = this;

                resultsContainer.innerHTML = '<div>' + results + '</div>';
                resultsContainer.show();

                this._globalEvalScripts(results);

                if (this.get_renderer()) {
                    /* Special case for date range renderer - only setting values when they're valid */
                    if (typeof (this.get_renderer().get_dateFrom) == 'function') {
                        if (originalSelectedValues && originalSelectedValues.length > 1) {
                            if (originalSelectedValues[0] && originalSelectedValues[0].length &&
                                        originalSelectedValues[1] && originalSelectedValues[1]) {

                                valuesSet = true;
                                this.get_renderer().set_selectedValues(originalSelectedValues);
                            }
                        }
                    } else {
                        valuesSet = true;
                        this.get_renderer().set_selectedValues(originalSelectedValues);
                    }

                    if (!valuesSet) {
                        this.get_renderer().set_selectedValues(this.get_selectedValues());
                    }
                }

                Dynamicweb.Controls.OMC.ReportFilter.Current = null;
            }
        }
    } else {
        noData.show();
    }

    this.refresh();

    onComplete();
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.attachRenderer = function (renderer) {
    /// <summary>Attaches the given renderer to the current filter.</summary>
    /// <param name="renderer">Renderer to attach.</param>

    this.set_renderer(renderer);

    if (this.get_renderer()) {
        this.get_renderer().set_filter(this);
    }
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.first = function (selector) {
    /// <summary>Returns the first extended element matching the given CSS selector.</summary>
    /// <param name="selector">CSS selector.</param>
    /// <returns>The first extended element matching the given CSS selector.</returns>

    var ret = null;
    var elements = null;
    var c = $(this.get_container());

    if (selector && c) {
        elements = c.select(selector);
        if (elements && elements.length) {
            ret = $(elements[0]);
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype.all = function (selector) {
    /// <summary>Returns all extended elements matching the given CSS selector.</summary>
    /// <param name="selector">CSS selector.</param>
    /// <returns>All extended elemenst matching the given CSS selector.</returns>

    var ret = [];
    var elements = null;
    var c = $(this.get_container());

    if (selector && c) {
        elements = c.select(selector);
        if (elements && elements.length) {
            for (var i = 0; i < elements.length; i++) {
                ret[ret.length] = $(elements[i]);
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ReportFilter.prototype._globalEvalScripts = function (content) {
    /// <summary>Evaluates all scripts from the given string in a global context.</summary>
    /// <param name="content">Content to process.</param>
    /// <private />

    var self = this;

    if (content) {
        content.extractScripts(content).map(function (script) { self._globalEval(script); });
    }
}

Dynamicweb.Controls.OMC.ReportFilter.prototype._globalEval = function (script) {
    /// <summary>Evaluates a script in a global context.</summary>
    /// <param name="script">Script to evaluate.</param>
    /// <remarks>Taken from jQuery 1.6.1.</remarks>
    /// <private />

    if (script && script.length) {
        (window.execScript || function (script) {
            window['eval'].call(window, script);
        })(script);
    }
}

Dynamicweb.Controls.OMC.ReportFilter.Global = function () {
    /// <summary>Provides a set of common globally available methods.</summary>
}

Dynamicweb.Controls.OMC.ReportFilter.Global._terminology = [];

Dynamicweb.Controls.OMC.ReportFilter.Global.localize = function (key, translation) {
    /// <summary>Registers localized version of the given string.</summary>
    /// <param name="key">Key that identifies the localized string.</param>
    /// <param name="translation">Translation.</param>

    if (!Dynamicweb.Controls.OMC.ReportFilter.Global._terminology) {
        Dynamicweb.Controls.OMC.ReportFilter.Global._terminology = [];
    }

    if (key && key.length) {
        Dynamicweb.Controls.OMC.ReportFilter.Global._terminology[key] = translation;
    }
}

Dynamicweb.Controls.OMC.ReportFilter.Global.getString = function (key) {
    /// <summary>Returns translation for the given key.</summary>
    /// <param name="key">Key that identifies the localized string.</param>

    var ret = '';

    if (key && key.length) {
        if (Dynamicweb.Controls.OMC.ReportFilter.Global._terminology) {
            ret = Dynamicweb.Controls.OMC.ReportFilter.Global._terminology[key];
        }

        if (!ret) {
            ret = '';
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ReportFilter.Global.setAttribute = function (e, a, v) {
    /// <summary>Sets or removes an attribute on an element.</summary>
    /// <param name="e">DOM element.</param>
    /// <param name="a">Attribute name.</param>
    /// <param name="v">Attribute value. Ommit to remove the attribute.</param>

    if (e) {
        if (typeof (v) == 'undefined' || v == null) {
            if (e.removeAttribute) {
                e.removeAttribute(a);
            }
        } else {
            if (e.setAttribute) {
                e.setAttribute(a, v);
            } else if (e.writeAttribute) {
                e.writeAttribute(a, v);
            }
        }
    }
}