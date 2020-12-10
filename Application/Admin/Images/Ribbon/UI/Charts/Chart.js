/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

/* ++++++ Supply functionality +++++++ */

Dynamicweb.Controls.Charts = new Object();
Dynamicweb.Controls.Charts._engines = new Hash();

Dynamicweb.Controls.Charts.get_engines = function () {
    /// <summary>Gets the current charts engine.</summary>

    return Dynamicweb.Controls.Charts._engines;
}

Dynamicweb.Controls.Charts.registerEngine = function (engine) {
    /// <summary>Registers new chart engine.</summary>
    /// <param name="engine">Chart engine to register.</param>

    var obj = null;

    if (engine) {
        if (!Dynamicweb.Controls.Charts._engines.get(engine)) {
            try {
                obj = eval('new ' + engine + '();');
            } catch (ex) { }

            if (obj != null) {
                Dynamicweb.Controls.Charts._engines.set(engine, obj);
                if (typeof (obj.load) != 'undefined') {
                    obj.load();
                }
            }
        }
    }
}

Dynamicweb.Controls.Charts.error = function (message) {
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

/* ++++++ END: Supply functionality +++++++ */

Dynamicweb.Controls.Charts.GoogleChartEngine = function () {
    /// <summary>Represents a chart engine that uses Google Visualization API.</summary>

    this._loaded = false;
    this._callbacks = [];
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.load = function (callback) {
    /// <summary>Initializes Google Charts API.</summary>
    /// <param name="callback">Callback function to be executed when load completes.</summary>

    callback = callback || function () { }

    var self = this;
    var onComplete = function () {
        self._loaded = true;
        self._callbacks[self._callbacks.length] = callback;
        for (var i = 0; i < self._callbacks.length; i++) {
            try {
                self._callbacks[i]();
            } catch (ex) { }
        }
    }
    
    if (!this._loaded) {
        if (typeof (google) == 'undefined') {
            Dynamicweb.Controls.Charts.error('Google charts requires Google AJAX API.');
        } else {
            google.charts.load('45', { packages: ['corechart', 'annotatedtimeline', 'gauge', 'geomap', 'intensitymap', 'motionchart', 'orgchart', 'table', 'treemap', 'imagechart']  });
            google.charts.setOnLoadCallback(function () { onComplete(); });
                     
        }
    } else {
        onComplete();
    }
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.add_loadComplete = function (callback) {
    /// <summary>Registers new callback function to be execute upon completion of the engine load process.</summary>
    /// <param name="callback">Callback function.</summary>

    callback = callback || function () { }

    if (this._loaded) {
        try {
            callback();
        } catch (ex) { }
    } else {
        this._callbacks[this._callbacks.length] = callback;
    }
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.render = function (c) {
    /// <summary>Renders specified chart.</summary>
    /// <param name="c">Chart to draw.</param>

    var self = this;
    var data = null;
    var options = {};
    var chart = null;
    var drawError = false;
    var imageChartUrl = '';
    var args = { chart: c, renderer: self };
    var getErrorArgs = function (message) { return { chart: c, renderer: self, message: message }; }

    if (c) {
        options = c.get_options().toObject();

        if (!options) {
            options = {};
        }

        options.title = c.get_title();
        options.width = c.get_width() - 5;
        options.height = c.get_height() - 5;

        chart = this.createChartObject(c);

        if (chart) {
            google.visualization.events.addListener(chart, 'error', function (errorObject) {
                c.notify('error', getErrorArgs(errorObject.message));
            });

            if (!c.get_isCompatibleRendering() || this.isCompatibleChartType(c.get_type())) {
                google.visualization.events.addListener(chart, 'ready', function () {
                    if (!document.getElementById(c.get_container()).firstChild) {
                        c.notify('empty', args);
                    }

                    c.notify('renderComplete', args);
                });

                this.fetchData(c, function (data) {
                    if (data) {
                        try {
                            chart.draw(data, options);
                        } catch (ex) {
                            drawError = true;
                            c.notify('error', getErrorArgs(ex.toString()));
                        }

                        /* IE doesn't render table contents unless you use paging/reapply filters - fixing that */
                        if (!drawError && Prototype.Browser.IE && c.get_type() && c.get_type().toLowerCase() == 'table') {
                            setTimeout(function () {
                                try {
                                    chart.draw(data, options);
                                } catch (ex) {
                                    c.notify('error', getErrorArgs(ex.toString()));
                                }
                            }, 10);
                        }
                    } else {
                        c.notify('empty', args);
                    }
                });
            } else {
                options = this.getImageChartOptions(c, options);

                this.fetchData(c, function (data) {
                    if (data) {
                        try {
                            chart.draw(data, options);
                        } catch (ex) {
                            c.notify('error', getErrorArgs(ex.toString()));
                        }

                        if (typeof (chart.getImageUrl) == 'function') {
                            imageChartUrl = chart.getImageUrl();

                            if (!imageChartUrl) {
                                imageChartUrl = '';
                            }

                            imageChartUrl = imageChartUrl.replace(/"/g, '%22')

                            c.set_lastOutput('<img src="' + imageChartUrl + '" border="0" />');
                        }
                    } else {
                        c.notify('empty', args);
                    }
                });
            }
        } else {
            c.notify('error', getErrorArgs('Unsupported chart type.'));
        }
    }
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.isCompatibleChartType = function (t) {
    /// <summary>Returns value indicating whether the given chart type is compatible with all device types.</summary>
    /// <param name="t">Chart type.</param>

    return (t || '').toString().toLowerCase() == 'table';
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.createChartObject = function (c) {
    /// <summary>Returns Google Visualization object for the corresponding chart object.</summary>
    /// <param name="c">Chart object.</param>

    var elm = null;
    var ret = null;
    var type = null;
    
    try {
        if (c) {
            elm = c.get_isEmulatedRendering() ? document.createElement('div') : document.getElementById(c.get_container());

            if (elm) {
                elm.style.display = '';

                type = c.get_type().toLowerCase();

                if (!c.get_isCompatibleRendering() || this.isCompatibleChartType(type)) {
                    if (type == 'table') ret = new google.visualization.Table(elm);
                    else if (type == 'treemap') ret = new google.visualization.TreeMap(elm);
                    else if (type == 'sparkline') ret = new google.visualization.ImageSparkLine(elm);
                    else if (type == 'scatter') ret = new google.visualization.ScatterChart(elm);
                    else if (type == 'pie') ret = new google.visualization.PieChart(elm);
                    else if (type == 'org') ret = new google.visualization.OrgChart(elm);
                    else if (type == 'motion') ret = new google.visualization.MotionChart(elm);
                    else if (type == 'line') ret = new google.visualization.LineChart(elm);
                    else if (type == 'intensitymap') ret = new google.visualization.IntensityMap(elm);
                    else if (type == 'geomap') ret = new google.visualization.GeoMap(elm);
                    else if (type == 'gauge') ret = new google.visualization.Gauge(elm);
                    else if (type == 'column') ret = new google.visualization.ColumnChart(elm);
                    else if (type == 'bar') ret = new google.visualization.BarChart(elm);
                    else if (type == 'area') ret = new google.visualization.AreaChart(elm);
                    else if (type == 'annotatedtimeline') ret = new google.visualization.AnnotatedTimeLine(elm);
                } else {
                    ret = new google.visualization.ImageChart(elm);
                }
            }
        }
    } catch (ex) { }

    return ret;
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.getImageChartOptions = function (c, options) {
    /// <summary>Returns an options for an image chart.</summary>
    /// <param name="c">Chart object.</param>
    /// <param name="c">Default chart options.</param>

    var type = null;
    var ret = options;

    if (!ret) {
        ret = {};
    }

    type = c.get_type().toLowerCase();

    if (type == 'scatter') ret.cht = 's';
    else if (type == 'pie') ret.cht = 'p';
    else if (type == 'line') ret.cht = 'lc';
    else if (type == 'sparkline') ret.cht = 'ls';
    else if (type == 'intensitymap' || type == 'geomap') { ret.cht = 't'; ret.chtm = 'world'; }
    else if (type == 'column') ret.cht = 'bvg';
    else if (type == 'bar') ret.cht = 'bhg';

    ret.showCategoryLabels = false;

    return ret;
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.fetchData = function (c, onComplete) {
    /// <summary>Retrieves chart data.</summary>
    /// <param name="c">Chart object.</param>
    /// <param name="onComplete">Callback to be executed when data is retrieved.</param>

    onComplete = onComplete || function () { }

    if (c) {
        if (c.get_data()) {
            onComplete(this.convertData(c.get_type(), c.get_data()));
        } else {
            onComplete(null);
        }
    } else {
        onComplete(null);
    }
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.convertData = function (chartType, data) {
    /// <summary>Converts specified DataTable object to its quivalent google.visualization.DataTable object.</summary>
    /// <param name="chartType">Chart type.</param>
    /// <param name="data">DataTable object to convert.</param>

    var rows = null;
    var columns = null;
    var ret = new google.visualization.DataTable();

    if (this._validateChartData(chartType, data)) {
        if (data && !data.get_isEmpty()) {
            rows = data.get_rows();
            columns = data.get_columns();

            for (var i = 0; i < columns.length; i++) {
                ret.addColumn(this.tryConvertColumnType(chartType, i, columns[i].get_type()), columns[i].get_label(), columns[i].get_id());
            }

            ret.addRows(rows.length);
            for (var i = 0; i < rows.length; i++) {
                for (var j = 0; j < columns.length; j++) {
                    ret.setValue(i, j, this.tryConvertValue(chartType, j, rows[i].getValue(j)));
                }
            }
        }
    } else {
        ret = null;
    }

    return ret;
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.tryConvertValue = function (chartType, columnIndex, value) {
    /// <summary>Tries to convert the given value to appropriate type that is required by the given chart type on the given column.</summary>
    /// <param name="chartType">Chart type.</param>
    /// <param name="columnIndex">Zero-based column index.</param>
    /// <param name="value">Original value.</param>
    /// <returns>Either the converted value or original value (if it cannot be converted).</returns>

    var ret = value;

    if (chartType) {
        chartType = chartType.toLowerCase();

        if (chartType == 'area' || chartType == 'column' || chartType == 'bar' || chartType == 'pie') {
            if (columnIndex == 0 && typeof (value) != 'string') {
                ret = (value != null) ? value.toString() : '';
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype.tryConvertColumnType = function (chartType, columnIndex, columnType) {
    /// <summary>Tries to convert the given column type to appropriate type that is required by the given chart type.</summary>
    /// <param name="chartType">Chart type.</param>
    /// <param name="columnIndex">Zero-based column index.</param>
    /// <param name="columnType">Original column type.</param>
    /// <returns>Either the converted column type or original column type (if it cannot be converted).</returns>

    var ret = columnType;

    if (chartType && columnType && typeof(columnType) == 'string') {
        chartType = chartType.toLowerCase();

        if (chartType == 'area' || chartType == 'column' || chartType == 'bar' || chartType == 'pie') {
            if (columnIndex == 0 && columnType.toLowerCase() != 'string') {
                ret = 'string';
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.Charts.GoogleChartEngine.prototype._validateChartData = function (chartType, data) {
    /// <summary>Validates chart data and returns value indicating whether dat acan be converted and displayed on the chart.</summary>
    /// <param name="chartType">Chart type.</param>
    /// <param name="data">Data table representing chart data.</param>

    var ret = true;

    if (chartType && data) {
        chartType = chartType.toLowerCase();
        if (chartType == 'area' || chartType == 'line') {
            ret = data.get_columns().length > 1;
        }
    } else {
        ret = false;
    }

    return ret;
}

Dynamicweb.Controls.Charts.DataRowValue = function (value, annotation) {
    /// <summary>Represents a data row value.</summary>
    /// <param name="value">Actual row value.</param>
    /// <param name="annotation">Row value annotation.</param>

    this._value = value;
    this._annotation = annotation;
}

Dynamicweb.Controls.Charts.DataRowValue.prototype.get_value = function () {
    /// <summary>Gets actual row value.</summary>

    return this._value;
}

Dynamicweb.Controls.Charts.DataRowValue.prototype.set_value = function (value) {
    /// <summary>Sets actual row value.</summary>
    /// <param name="value">Actual row value.</param>

    this._value = value;
}

Dynamicweb.Controls.Charts.DataRowValue.prototype.get_annotation = function () {
    /// <summary>Gets actual row value.</summary>

    return this._annotation;
}

Dynamicweb.Controls.Charts.DataRowValue.prototype.set_annotation = function (value) {
    /// <summary>Sets row value annotation.</summary>
    /// <param name="value">Row value annotation.</param>

    this._annotation = value;
}

Dynamicweb.Controls.Charts.DataRow = function (table, values) {
    /// <summary>Represents a data row.</summary>
    /// <param name="table">Existing data table to attach data row to.</param>

    var isTable = (typeof (table) != 'undefined');

    if (isTable) {
        isTable = typeof (table.newRow) == 'function';
    }

    if (!isTable)
        Dynamicweb.Controls.Charts.error('A data row must be attached to existing data table.  Use "DataTable.newRow" to create new row.');
    else {
        this._values = [];
        this._table = table;

        if (values && values.length) {
            this._values = values;
        }
    }
}

Dynamicweb.Controls.Charts.DataRow.prototype.getValue = function (c) {
    /// <summary>Gets the value of the specified cell.</summary>
    /// <param name="c">Either a reference to existing table column or a zero-based index of the column.</param>

    var index = -1;
    var ret = null;
    var val = null;
    var targetColumn = null;
    var columns = this._table.get_columns();

    if (typeof (c) != 'undefined') {
        if (typeof (c.get_type) != 'undefined') {
            targetColumn = c;
            for (var i = 0; i < columns.length; i++) {
                if (columns[i].equals(targetColumn)) {
                    index = i;
                    break;
                }
            }
        } else {
            index = Math.abs(parseInt(c));
        }

        if (!isNaN(index) && index >= 0 && index < columns.length) {
            ret = this._values[index];

            if (Dynamicweb.Controls.Charts.DataRow.isComplexValue(ret)) {
                if (!this._table.get_enableComplexValues()) {
                    ret = ret.get_value();
                }
            } else {
                if (this._table.get_enableComplexValues()) {
                    val = ret;

                    ret = new Dynamicweb.Controls.Charts.DataRowValue();

                    ret.set_value(val);
                    ret.set_annotation(val);
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.Charts.DataRow.prototype.setValue = function (c, value) {
    /// <summary>Sets the value of the specified cell.</summary>
    /// <param name="c">Either a reference to existing table column or a zero-based index of the column.</param>
    /// <param name="value">Cell value.</param>

    var index = -1;
    var ret = null;
    var val = null;
    var curLength = 0;
    var targetColumn = null;
    var columns = this._table.get_columns();

    if (typeof (c) != 'undefined') {
        if (typeof (c.get_type) != 'undefined') {
            targetColumn = c;
            for (var i = 0; i < columns.length; i++) {
                if (columns[i].equals(targetColumn)) {
                    index = i;
                    break;
                }
            }
        } else {
            index = Math.abs(parseInt(c));
        }

        if (!isNaN(index) && index >= 0 && index < columns.length) {
            if (index > (this.values.length - 1)) {
                curLength = this.values.length;
                for (var i = curLength; i <= curLength + (index - curLength); i++) {
                    this._values[i] = null;
                }
            }

            if (Dynamicweb.Controls.Charts.DataRow.isComplexValue(value)) {
                if (!this._table.get_enableComplexValues()) {
                    this._values[index] = value.get_value();
                }
            } else {
                if (this._table.get_enableComplexValues()) {
                    val = value;

                    value = new Dynamicweb.Controls.Charts.DataRowValue();

                    value.set_value(val);
                    value.set_annotation(val);

                    this._values[index] = value;
                }
            }
        }
    }
}

Dynamicweb.Controls.Charts.DataRow.isComplexValue = function (value) {
    /// <summary>Determines whether the given value is a complex value.</summary>
    /// <param name="value">Value to examine.</param>

    var ret = false;

    if (value != null && typeof (value.get_annotation) == 'function') {
        ret = true;
    }

    return ret;
}

Dynamicweb.Controls.Charts.DataColumn = function (table, type, label, id) {
    /// <summary>Represents a data column.</summary>
    /// <param name="type">Column type.</param>
    /// <param name="label">Column label.</param>
    /// <param name="id">Column identifier.</param>

    this._table = table;
    this._type = type;
    this._label = label;
    this._id = id;

    var isTable = (typeof (table) != 'undefined');

    if (isTable) {
        isTable = typeof (table.newColumn) == 'function';
    }

    if (!isTable)
        Dynamicweb.Controls.Charts.error('A data column must be attached to existing data table. Use "DataTable.newColumn" to create new column.');

}

Dynamicweb.Controls.Charts.DataColumn.prototype.get_type = function() {
    /// <summary>Gets column type.</summary>

    return this._type || 'string';
}

Dynamicweb.Controls.Charts.DataColumn.prototype.set_type = function(value) {
    /// <summary>Sets column type.</summary>
    /// <param name="value">Column type.</param>

    this._type = value;
}

Dynamicweb.Controls.Charts.DataColumn.prototype.get_label = function() {
    /// <summary>Gets column label.</summary>

    return this._label || '';
}

Dynamicweb.Controls.Charts.DataColumn.prototype.set_label = function(value) {
    /// <summary>Sets column label.</summary>
    /// <param name="value">Column label.</param>

    this._label = value;
}

Dynamicweb.Controls.Charts.DataColumn.prototype.get_id = function() {
    /// <summary>Gets column identifier.</summary>

    return this._id || '';
}

Dynamicweb.Controls.Charts.DataColumn.prototype.set_id = function(value) {
    /// <summary>Sets column identifier.</summary>
    /// <param name="value">Column identifier.</param>

    this._id = value;
}

Dynamicweb.Controls.Charts.DataColumn.prototype.equals = function(other) {
    /// <summary>Determines whether current column equals to another one.</summary>
    /// <param name="other">Another column.</param>
    /// <returns>Value indicating whether current column equals to another one.</returns>

    var ret = false;

    if (other && typeof(other.get_label) != 'undefined') {
        ret = (this.get_type() + this.get_label() + this.get_id()).toLowerCase() == 
            (other.get_type() + other.get_label() + other.get_id()).toLowerCase();
    }

    return ret;
}

Dynamicweb.Controls.Charts.DataTable = function () {
    /// <summary>Represents a data table.</summary>

    this._columns = [];
    this._rows = [];
    this._enableComplexValues = false;
}

Dynamicweb.Controls.Charts.DataTable.prototype.get_enableComplexValues = function () {
    /// <summary>Gets value indicating whether table row values must be represented as a complex values.</summary>

    return this._enableComplexValues;
}

Dynamicweb.Controls.Charts.DataTable.prototype.set_enableComplexValues = function (value) {
    /// <summary>Sets value indicating whether table row values must be represented as a complex values.</summary>
    /// <param name="value">Value indicating whether table row values must be represented as a complex values.</param>

    this._enableComplexValues = !!value;
}

Dynamicweb.Controls.Charts.DataTable.prototype.get_columns = function() {
    /// <summary>Gets a collection of table columns.</summary>

    return this._columns;
}

Dynamicweb.Controls.Charts.DataTable.prototype.get_rows = function() {
    /// <summary>Gets a collection of table rows.</summary>

    return this._rows;
}

Dynamicweb.Controls.Charts.DataTable.prototype.get_isEmpty = function () {
    /// <summary>Gets value indicating whether this data table is empty.</summary>

    return this.get_rows().length == 0;
}

Dynamicweb.Controls.Charts.DataTable.prototype.newRow = function(values) {
    /// <summary>Creates new data row.</summary>
    /// <param name="values">An array containing row values.</param>

    return new Dynamicweb.Controls.Charts.DataRow(this, values);
}

Dynamicweb.Controls.Charts.DataTable.prototype.empty = function () {
    /// <summary>Removes all rows from the table.</summary>

    this._rows = [];
}

Dynamicweb.Controls.Charts.DataTable.prototype.clear = function () {
    /// <summary>Removes all rows and all columns from the table.</summary>

    this._rows = [];
    this._columns = [];
}

Dynamicweb.Controls.Charts.DataTable.prototype.newColumn = function (type, label, id) {
    /// <summary>Creates new data row.</summary>
    /// <param name="type">Column type.</param>
    /// <param name="label">Column label.</param>
    /// <param name="id">Column identifier.</param>

    return new Dynamicweb.Controls.Charts.DataColumn(this, type, label, id);
}


Dynamicweb.Controls.Charts.DataQuery = function () {
    /// <summary>Represents chart data query.</summary>

    this._criteria = new Hash();

    this._specialCharactersPatterns = [
        { pattern: /\\/g, replacement: '\\' },
        { pattern: /:/g, replacement: '\:' },
        { pattern: /,/g, replacement: '\,' }
    ];
}

Dynamicweb.Controls.Charts.DataQuery.prototype.get_isEmpty = function () {
    /// <summary>Gets value indicating whether query contains items.</summary>

    var ret = true;
    var keys = this._criteria.keys();

    if (keys && keys.length) {
        ret = false;
    }

    return ret;
}

Dynamicweb.Controls.Charts.DataQuery.prototype.get_item = function (name) {
    /// <summary>Gets the query criterion with the given name.</summary>
    /// <param name="name">Criterion name.</param>

    return (name && name.length) ? (this._criteria.get(name) || '') : '';
}

Dynamicweb.Controls.Charts.DataQuery.prototype.set_item = function (name, value) {
    /// <summary>Sets the query criterion with the given name.</summary>
    /// <param name="name">Criterion name.</param>
    /// <param name="value">Criterion value.</param>

    if (name && name.length) {
        this._criteria.set(name, value);
    }
}

Dynamicweb.Controls.Charts.DataQuery.prototype.remove = function (name) {
    /// <summary>Removes criterion with the given name from the current query.</summary>
    /// <param name="name">Criterion name.</param>

    if (name && name.length) {
        this._criteria.unset(name);
    }
}

Dynamicweb.Controls.Charts.DataQuery.prototype.clear = function () {
    /// <summary>Removes all criteria from the current query.</summary>
    
    this._criteria = new Hash();
}

Dynamicweb.Controls.Charts.DataQuery.prototype.serialize = function () {
    /// <summary>Serialized the current query to string.</summary>

    var ret = '';
    var value = '';
    var keys = this._criteria.keys();

    if (keys && keys.length) {
        for (var i = 0; i < keys.length; i++) {
            value = this.get_item(keys[i]);

            if (value && value.length) {
                for (var j = 0; j < this._specialCharactersPatterns.length; j++) {
                    value = value.replace(this._specialCharactersPatterns[j].pattern,
                    this._specialCharactersPatterns[j].replacement);
                }
            }

            if (value.indexOf(' ') >= 0) {
                value = ('"' + value + '"');
            }

            ret += (keys[i] + ':' + value);
            if (i < (keys.length - 1)) {
                ret += ',';
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.Charts.Chart = function (engineName) {
    /// <summary>Represents a chart.</summary>
    /// <param name="engineName">The name of the chart engine to use.</param>

    this._container = '';
    this._width = 0;
    this._height = 0;
    this._title = '';
    this._data = null;
    this._type = '';
    this._options = new Hash();
    this._engineName = engineName;
    this._associatedControlID = '';
    this._noDataMessage = '';
    this._errorMessage = '';
    this._callbackAdded = false;
    this._lastError = '';
    this._isCompatibleRendering = false;
    this._isEmulatedRendering = false;
    this._lastOutput = '';

    this._events = {
        empty: [],
        error: [],
        renderComplete: []
    }

    if (!this._engineName) {
        this._engineName = 'Dynamicweb.Controls.Charts.GoogleChartEngine';
    }

    Dynamicweb.Controls.Charts.registerEngine(this._engineName);

    this._engine = null;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_container = function () {
    /// <summary>Gets the identifier of the DOM element that holds chart output.</summary>

    return this._container;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_container = function (value) {
    /// <summary>Sets the identifier of the DOM element that holds chart output.</summary>
    /// <param name="value">An identifier of the DOM element that holds chart output.</param>

    this._container = value;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_emptyMessage = function () {
    /// <summary>Get the message that is displayed when there is nothing to show on a chart.</summary>

    return this._emptyMessage;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_emptyMessage = function (value) {
    /// <summary>Set the message that is displayed when there is nothing to show on a chart.</summary>
    /// <param name="value">The message that is displayed when there is nothing to show on a chart.</param>

    this._emptyMessage = value;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_errorMessage = function () {
    /// <summary>Set the message that is displayed when there was an error during render process.</summary>

    return this._errorMessage;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_errorMessage = function (value) {
    /// <summary>Set the message that is displayed when there was an error during render process.</summary>
    /// <param name="value">The message that is displayed when there was an error during render process.</param>

    this._errorMessage = value;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_associatedControlID = function () {
    /// <summary>Gets the unique identifier of the ASP.NET control that is associated with this client object.</summary>

    return this._associatedControlID;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_associatedControlID = function (value) {
    /// <summary>Sets the unique identifier of the ASP.NET control that is associated with this client object.</summary>
    /// <param name="value">The unique identifier of the ASP.NET control that is associated with this client object.</param>

    this._associatedControlID = value;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_options = function () {
    /// <summary>Gets additional chart options.</summary>

    return this._options;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_width = function () {
    /// <summary>Gets the width of chart area.</summary>

    return this._width;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_width = function (value) {
    /// <summary>Sets the width of chart area.</summary>
    /// <param name="value">The width of the chart area.</param>

    this._width = parseInt(value);

    if (isNaN(this._width) || this._width < 0) {
        this._width = 0;
    }
}

Dynamicweb.Controls.Charts.Chart.prototype.get_height = function () {
    /// <summary>Gets the height of chart area.</summary>

    return this._height;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_height = function (value) {
    /// <summary>Sets the height of chart area.</summary>
    /// <param name="value">The height of the chart area.</param>

    this._height = parseInt(value);

    if (isNaN(this._height) || this._height < 0) {
        this._height = 0;
    }
}

Dynamicweb.Controls.Charts.Chart.prototype.get_title = function() {
    /// <summary>Gets chart title.</summary>

    return this._title;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_title = function(value) {
    /// <summary>Sets chart title.</summary>
    /// <param name="value">Chart title.</param>

    this._title = value || '';
}

Dynamicweb.Controls.Charts.Chart.prototype.get_data = function() {
    /// <summary>Gets the data to be displayed in the chart.</summary>

    return this._data;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_data = function(value) {
    /// <summary>Sets the data to be displayed in the chart.</summary>
    /// <param name="value">The data to be displayed in the chart.</param>

    this._data = value;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_lastError = function () {
    /// <summary>Gets the error message occured since the last chart data load procedure.</summary>

    return this._lastError;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_type = function () {
    /// <summary>Gets chart type.</summary>

    return this._type;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_type = function (value) {
    /// <summary>Sets chart type.</summary>
    /// <param name="value">Chart type.</param>

    this._type = value || '';
}

Dynamicweb.Controls.Charts.Chart.prototype.get_engine = function () {
    /// <summary>Gets an instance of chart engine associated with this chart.</summary>

    if (!this._engine) {
        this._engine = Dynamicweb.Controls.Charts.get_engines().get(this._engineName);
    }

    return this._engine;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_isCompatibleRendering = function () {
    /// <summary>Gets value indicating whether maximum device compatibility must be used when rendering a chart.</summary>

    return this._isCompatibleRendering;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_isCompatibleRendering = function (value) {
    /// <summary>Sets value indicating whether maximum device compatibility must be used when rendering a chart.</summary>
    /// <param name="value">Value indicating whether maximum device compatibility must be used when rendering a chart.</param>

    this._isCompatibleRendering = value;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_isEmulatedRendering = function () {
    /// <summary>Gets value indicating whether chart rendering must be emulated meaning that the chart will be recreated but changes will not be displayed.</summary>

    return this._isEmulatedRendering;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_isEmulatedRendering = function (value) {
    /// <summary>Sets value indicating whether chart rendering must be emulated meaning that the chart will be recreated but changes will not be displayed.</summary>
    /// <param name="value">Value indicating whether chart rendering must be emulated meaning that the chart will be recreated but changes will not be displayed.</param>

    this._isEmulatedRendering = value;
}

Dynamicweb.Controls.Charts.Chart.prototype.get_lastOutput = function () {
    /// <summary>Gets the output (string) of a last chart rendering.</summary>

    return this._lastOutput;
}

Dynamicweb.Controls.Charts.Chart.prototype.set_lastOutput = function (value) {
    /// <summary>Sets the output (string) of a last chart rendering.</summary>

    this._lastOutput = value;
}

Dynamicweb.Controls.Charts.Chart.prototype.loadData = function (params) {
    /// <summary>Performs asynchronous operation of loading chart data.</summary>
    /// <param name="params">Load parameters.</param>
    /// <remarks>
    /// </remarks>

    var self = this;
    var requestParams = {};

    params = params || {};

    if (params.query && typeof (params.query.serialize) == 'function') {
        if (!params.query.get_isEmpty()) {
            requestParams.ChartQuery = params.query.serialize();
        }
    }

    // Clearing previous error
    this._lastError = '';

    Dynamicweb.Ajax.DataLoader.load({
        target: this.get_associatedControlID(),
        parameters: requestParams,
        onComplete: function (results) {
            var data = null, annotations = null;
            
            if (params.onComplete) {
                if (results) {
                    data = results.data;
                    annotations = results.annotations;
                }

                params.onComplete(data, annotations);
            }
        },
        onError: function (errorObject) {
            var msg = null;
            var c = $(self.get_container());

            if (errorObject) {
                msg = errorObject.message;
            }

            self.set_data(null);
            self._lastError = (msg && msg.length) ? msg : 'Unexpected error.';

            if (c) {
                c.update('');
                self._showEmpty('dw-chart-error', self.get_errorMessage(), errorObject);

                if (params.onComplete) {
                    params.onComplete();
                }
            }
        }
    });
}

Dynamicweb.Controls.Charts.Chart.prototype.add_ready = function (callback) {
    /// <summary>Registers new callback function to be executed when chart is ready to be rendered.</summary>
    /// <param name="callback">Callback function.</param>

    var self = this;
    var e = this.get_engine();

    if (typeof (callback) != 'function') {
        callback = function () { }
    }

    if (e && typeof (e.add_loadComplete) != 'undefined') {
        e.add_loadComplete(function () { callback(self, {}); });
    }
}

Dynamicweb.Controls.Charts.Chart.prototype.add_empty = function (callback) {
    /// <summary>Registers new callback function to be executed when there is no data to be rendered on a chart.</summary>
    /// <param name="callback">Callback function.</param>

    this._events.empty.push(callback);
}

Dynamicweb.Controls.Charts.Chart.prototype.add_error = function (callback) {
    /// <summary>Registers new callback function to be executed when there was an error rendering the chart.</summary>
    /// <param name="callback">Callback function.</param>

    this._events.error.push(callback);
}

Dynamicweb.Controls.Charts.Chart.prototype.add_renderComplete = function (callback) {
    /// <summary>Registers new callback function to be executed when char has been rendered.</summary>
    /// <param name="callback">Callback function.</param>

    this._events.renderComplete.push(callback);
}

Dynamicweb.Controls.Charts.Chart.prototype.notify = function (eventName, args) {
    /// <summary>Notifies subscribers about the specific event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];

    if (eventName) {
        if (!args) args = {};

        eventName = eventName.toLowerCase();

        if (eventName == 'empty') {
            callbacks = this._events.empty;
        } else if (eventName == 'error') {
            callbacks = this._events.error;
        } else if (eventName == 'rendercomplete') {
            callbacks = this._events.renderComplete;
        }

        if (callbacks && callbacks.length) {
            for (var i = 0; i < callbacks.length; i++) {
                try {
                    callbacks[i](this, args);
                } catch (ex) { }
            }
        }
    }
}

Dynamicweb.Controls.Charts.Chart.prototype.draw = function () {
    /// <summary>Draws the chart.</summary>

    var self = this;
    var engine = this.get_engine();
    var container = $(this.get_container());
    var isEmpty = !this.get_data() || this.get_data().get_isEmpty();

    this.set_lastOutput('');

    if (!isEmpty && engine && typeof (engine.render) != 'undefined') {
        if (!this._callbackAdded) {
            this.add_empty(function (sender, args) { self._showEmpty('dw-chart-empty', self.get_emptyMessage(), null); });
            this.add_error(function (sender, args) { self._showEmpty('dw-chart-error', self.get_errorMessage(), args); });

            this._callbackAdded = true;
        }

        /* Settings dimensions explicitly on the container */
        if (container) {
            container.setStyle({ 'width': this.get_width() + 'px', 'height': this.get_height() + 'px' });
        }

        engine.render(this);
    } else {
        if (this.get_lastError() && this.get_lastError().length) {
            // Manually firing event handler to display "Chart error" message
            this._showEmpty('dw-chart-error', this.get_errorMessage(), { message: this.get_lastError() });
        } else {
            // Manually firing event handler to display "No data" message
            this._showEmpty('dw-chart-empty', this.get_emptyMessage(), null);
        }
    }
}

Dynamicweb.Controls.Charts.Chart.prototype._showEmpty = function (cssClass, message, args) {
    /// <summary>Displays a message on an empty chart surface.</summary>
    /// <param name="cssClass">CSS class to apply to the message container.</param>
    /// <param name="message">Message to display.</param>
    /// <param name="args">Event arguments.</param>
    /// <private />

    var padding = 0;
    var msg = message;
    var errorMessage = '';
    var outerContainer = null;
    var innerContainer = null;
    var emptyContainer = null;
    var emptyContainerHeight = 0;
    var container = $(this.get_container());

    if (container) {
        container.update('');

        if (args && args.message) {
            errorMessage = args.message;

            errorMessage = errorMessage.replace(/^Error:\s*/gi, '');
            errorMessage = errorMessage.replace(/\.*$/g, '');

            msg += ': "' + errorMessage + '"';
        }

        outerContainer = new Element('div', { 'class': 'dw-chart-message-outer' });
        innerContainer = new Element('div', { 'class': 'dw-chart-message-inner' });
        emptyContainer = new Element('div', { 'class': cssClass }).update(msg);

        innerContainer.appendChild(emptyContainer);
        outerContainer.appendChild(innerContainer);
        container.appendChild(outerContainer);

        outerContainer.setStyle({ width: this.get_width() + 'px', height: this.get_height() + 'px' });

        emptyContainerHeight = emptyContainer.getHeight() +
            parseInt(emptyContainer.getStyle('paddingTop')) +
            parseInt(emptyContainer.getStyle('marginTop'));

        if (isNaN(emptyContainerHeight) || emptyContainerHeight <= 0) {
            emptyContainerHeight = 32;
        }

        padding = parseInt((this.get_height() / 2));
        if (isNaN(padding) || padding < 0) {
            padding = 0;
        }
        
        innerContainer.setStyle({ 'paddingTop': (padding - parseInt(emptyContainerHeight / 2) || 0) + 'px' });
    }
}