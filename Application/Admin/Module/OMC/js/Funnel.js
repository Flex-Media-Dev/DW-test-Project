/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

if (typeof (Dynamicweb.Controls.Charts) == 'undefined') {
    Dynamicweb.Controls.Charts = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Controls.Charts.FunnelRenderContext = function (portions) {
    /// <summary>Represents a funnel render context.</summary>
    /// <param name="portions">An array of funnel portions.</param>

    var val = 0;

    this._total = 0;
    this._containerID = '';
    this._container = null;
    this._portions = portions;

    if (!this._portions) {
        this._portions = [];
    }

    if (this._portions && this._portions.length) {
        for (var i = 0; i < this._portions.length; i++) {
            val = this._portions[i].get_value().get_value();

            if (val > this._total) {
                this._total = val;
            }
        }
    }
}

Dynamicweb.Controls.Charts.FunnelRenderContext.prototype.get_total = function () {
    /// <summary>Gets the total number of visits that are subject if this funnel filtering.</summary>

    return this._total;
}

Dynamicweb.Controls.Charts.FunnelRenderContext.prototype.get_portions = function () {
    /// <summary>Gets the list of all funnel portions.</summary>

    return this._portions;
}

Dynamicweb.Controls.Charts.FunnelRenderContext.prototype.get_container = function () {
    /// <summary>Gets the container whether the funnel must be populated.</summary>

    if (!this._container) {
        this._container = $(this._containerID);
    }

    return this._container;
}

Dynamicweb.Controls.Charts.FunnelRenderContext.prototype.get_expectedWidth = function () {
    /// <summary>Gets the expected width of the funnel area.</summary>

    return ((100 * this.get_portions().length) + (55 * (this.get_portions().length - 1)));
}

Dynamicweb.Controls.Charts.FunnelRenderContext.prototype.getPercentage = function (portion, refPortion) {
    /// <summary>Calculates the percentage for the given portion.</summary>
    /// <param name="portion">Portion to calculate percentage for.</param>
    /// <param name="refPortion">Referenced portion representing 100% value.</param>

    var ret = 0;
    var value = 0;
    var total = this._total;

    if (portion && typeof (portion.get_value) == 'function') {
        value = portion.get_value().get_value();

        if (refPortion != null) {
            total = refPortion.get_value().get_value();
        }

        if (total == 0 && value == 0) {
            ret = 100;
        } else if (total > 0) {
            ret = value * 100 / total;

            if (ret < 0) {
                ret = 0;
            } else if (ret > 100) {
                ret = 100;
            }

            if (ret > 0 && ret < 1) {
                if (ret < 0.1) {
                    ret = ret.toFixed(2);
                } else {
                    ret = ret.toFixed(1);
                }
            } else {
                ret = parseInt(ret, 10);
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.Charts.FunnelRenderContext.create = function (chart) {
    /// <summary>Initializes the funnel render context by using the given chart settings.</summary>
    /// <param name="chart">Chart settings.</param>

    var ret = null;
    var data = null;
    var rows = null;
    var value = null;
    var portions = [];
    var columns = null;
    var origEnableComplexValues = false;

    if (chart && typeof (chart.get_data) == 'function') {
        data = chart.get_data();

        if (typeof (data.get_isEmpty) == 'function') {
            if (!data.get_isEmpty()) {
                rows = data.get_rows();
                columns = data.get_columns();
                origEnableComplexValues = data.get_enableComplexValues();

                if (columns.length >= 2) {
                    data.set_enableComplexValues(true);

                    for (var i = 0; i < rows.length; i++) {
                        value = rows[i].getValue(1);

                        if (value != null) {
                            value = new Dynamicweb.Controls.Charts.FunnelPortionValue(value.get_value(), value.get_annotation());
                            portions[portions.length] = new Dynamicweb.Controls.Charts.FunnelPortion(value, rows[i].getValue(0).get_value());
                        }
                    }

                    data.set_enableComplexValues(origEnableComplexValues);
                }
            }
        }
    }

    ret = new Dynamicweb.Controls.Charts.FunnelRenderContext(portions);

    if (chart != null && typeof (chart.get_container) == 'function') {
        ret._containerID = chart.get_container();
    }

    return ret;
}

Dynamicweb.Controls.Charts.FunnelPortion = function (value, label) {
    /// <summary>Represents a funnel portion.</summary>
    /// <param name="value">Funnel portion value.</param>
    /// <param name="label">Funnel portion label.</param>

    this._value = null;
    this._label = '';

    this.set_value(value);
    this.set_label(label);
}

Dynamicweb.Controls.Charts.FunnelPortion.prototype.get_label = function () {
    /// <summary>Gets the funnel portion label.</summary>

    return this._label;
}

Dynamicweb.Controls.Charts.FunnelPortion.prototype.set_label = function (value) {
    /// <summary>Sets the funnel portion label.</summary>
    /// <param name="value">Funnel portion label.</param>

    this._label = value;
}

Dynamicweb.Controls.Charts.FunnelPortion.prototype.get_value = function () {
    /// <summary>Gets the funnel portion value.</summary>

    return this._value;
}

Dynamicweb.Controls.Charts.FunnelPortion.prototype.set_value = function (value) {
    /// <summary>Sets the funnel portion value.</summary>
    /// <param name="value">Funnel portion value.</param>

    if (value == null) {
        this._value = null;
    } else if (typeof (value.get_value) != 'function') {
        this._value = null;
        Dynamicweb.Controls.Charts.error('Funnel portion value must be of type "Dynamicweb.Controls.Charts.FunnelPortionValue".');
    } else {
        this._value = value;
    }
}

Dynamicweb.Controls.Charts.FunnelPortionValue = function (value, annotation) {
    /// <summary>Represents a funnel portion value.</summary>

    this._value = 0;
    this._annotation = null;

    this.set_value(value);
    this.set_annotation(annotation);
}

Dynamicweb.Controls.Charts.FunnelPortionValue.prototype.get_annotation = function () {
    /// <summary>Gets the portion value annotation.</summary>

    if (this._annotation == null || (typeof (this._annotation) == 'string' && !this._annotation.length)) {
        if (this._value != null) {
            this._annotation = this._value.toString();
        }
    }

    return this._annotation;
}

Dynamicweb.Controls.Charts.FunnelPortionValue.prototype.set_annotation = function (value) {
    /// <summary>Gets the portion value annotation.</summary>

    this._annotation = value;

    if (value && typeof (value) == 'string' && value.indexOf('{') == 0 && value.lastIndexOf('}') == value.length - 1) {
        try {
            this._annotation = eval('(' + this._annotation + ')');
        } catch (ex) { }
    }
}

Dynamicweb.Controls.Charts.FunnelPortionValue.prototype.get_annotationType = function () {
    /// <summary>Gets the annotation type.</summary>

    var ret = 'undefined';
    var annotation = this.get_annotation();

    if (annotation != null) {
        ret = typeof (annotation);
    }

    return ret;
}

Dynamicweb.Controls.Charts.FunnelPortionValue.prototype.get_value = function () {
    /// <summary>Gets the actual value of the funnel portion.</summary>

    return this._value;
}

Dynamicweb.Controls.Charts.FunnelPortionValue.prototype.set_value = function (value) {
    /// <summary>Sets the actual value of the funnel portion.</summary>
    /// <param name="value">The actual value of the funnel portion.</param>

    this._value = parseFloat(value);

    if (isNaN(this._value) || this._value == null || this._value < 0) {
        this._value = 0;
    }

    // Omitting fractional part, if possible
    if (this._value == parseInt(value, 10)) {
        this._value = parseInt(value, 10);
    }
}

Dynamicweb.Controls.Charts.Funnel = function () {
    /// <summary>Represents a funnel chart.</summary>

    this._loaded = false;
    this._callbacks = [];
    this._groupSeparator = ',';
    this._decimalSeparator = ',';
}

Dynamicweb.Controls.Charts.Funnel.prototype.get_groupSeparator = function () {
    /// <summary>Gets the group separator.</summary>

    return this._groupSeparator;
}

Dynamicweb.Controls.Charts.Funnel.prototype.set_groupSeparator = function (value) {
    /// <summary>Sets the group separator.</summary>
    /// <param name="value">Group separator.</param>

    this._groupSeparator = value;
}

Dynamicweb.Controls.Charts.Funnel.prototype.get_decimalSeparator = function () {
    /// <summary>Gets the decimal separator.</summary>

    return this._decimalSeparator;
}

Dynamicweb.Controls.Charts.Funnel.prototype.set_decimalSeparator = function (value) {
    /// <summary>Sets the decimal separator.</summary>
    /// <param name="value">Decimal separator.</param>

    this._decimalSeparator = value;
}

Dynamicweb.Controls.Charts.Funnel.prototype.load = function (callback) {
    /// <summary>Initializes Google Charts API.</summary>
    /// <param name="callback">Callback function to be executed when load completes.</summary>

    var self = this;

    setTimeout(function () {
        self._loaded = true;
        self._callbacks[self._callbacks.length] = callback;

        for (var i = 0; i < self._callbacks.length; i++) {
            try {
                self._callbacks[i]();
            } catch (ex) { }
        }
    }, 500);
}

Dynamicweb.Controls.Charts.Funnel.prototype.add_loadComplete = function (callback) {
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

Dynamicweb.Controls.Charts.Funnel.prototype.render = function (c) {
    /// <summary>Renders specified chart.</summary>
    /// <param name="c">Chart to draw.</param>

    var self = this;
    var context = null;
    var args = { chart: c, renderer: self };
    var getErrorArgs = function (message) {
        return {
            chart: c,
            renderer: self,
            message: message
        };
    }

    if (c) {
        this.set_groupSeparator(c.get_options().get('groupSeparator'));
        this.set_decimalSeparator(c.get_options().get('decimalSeparator'));

        context = Dynamicweb.Controls.Charts.FunnelRenderContext.create(c);

        if (context != null && context.get_portions().length > 0) {
            this.renderFunnel(context);
            c.notify('renderComplete', args);
        } else {
            c.notify('empty', args);
        }
    }
}

Dynamicweb.Controls.Charts.Funnel.prototype.renderFunnel = function (context) {
    /// <summary>Renders funnel chart.</summary>
    /// <param name="context">Funnel render context.</param>

    var outer = null;
    var result = null;
    var wrapper = null;
    var container = null;

    if (context) {
        container = context.get_container();

        if (container) {
            container.update('');

            wrapper = this.createElement('div', {
                'class': 'funnel',
                'style': 'width: ' + context.get_expectedWidth() + 'px'
            });

            result = this.createElement('div', {
                'class': 'funnel-result'
            });

            outer = this.createElement('ul', {
                'class': 'funnel-portions'
            });

            wrapper.appendChild(outer);
            wrapper.appendChild(this.createElement('div', { 'class': 'funnel-clear' }));
            wrapper.appendChild(result);

            container.appendChild(wrapper);
        }

        for (var i = 0; i < context.get_portions().length; i++) {
            this.renderFunnelPortion(context, i, outer);
        }

        this.renderFunnelResult(context, result);
    }
}

Dynamicweb.Controls.Charts.Funnel.prototype.renderFunnelResult = function (context, container) {
    /// <summary>Renders funnel result.</summary>
    /// <param name="context">Funnel render context.</param>
    /// <param name="container">DOM element that the result must be rendered into.</param>

    var width = 0;
    var fields = [];
    var outer = null;
    var portion = null;
    var annotation = null;
    var containerWidth = 0;
    var portionValue = null;

    if (context && container) {
        width = context.get_expectedWidth();
        portion = context.get_portions()[context.get_portions().length - 1];

        if (portion) {
            portionValue = portion.get_value();
            annotation = portionValue.get_annotation();

            if (annotation != null) {
                outer = this.createElement('div', {
                    'class': 'funnel-result-box'
                });

                if (portionValue.get_annotationType() == 'string') {
                    outer.appendChild(this.createElement('div', {
                        'class': 'funnel-result-literal'
                    }));
                } else {
                    for (var i = 0; i < annotation.fields.length; i++) {
                        fields[fields.length] = this.createElement('div', {
                            'class': 'funnel-result-field' + (i == annotation.fields.length - 1 ? ' funnel-result-field-last' : '')
                        }, [
                            this.createElement('span', {
                                'class': 'funnel-result-field-label'
                            }, annotation.fields[i].label),

                            this.createElement('span', {
                                'class': 'funnel-result-field-value'
                            }, annotation.fields[i].value)
                        ]);
                    }

                    if (fields.length) {
                        fields[fields.length] = this.createElement('div', { 'class': 'funnel-clear' });
                    }

                    for (var i = 0; i < fields.length; i++) {
                        outer.appendChild(fields[i]);
                    }
                }

                container.appendChild(outer);

                containerWidth = outer.getWidth();

                container.setStyle({
                    'marginLeft': ((width - containerWidth) / 2) + 'px'
                });
            }
        }
    }
}

Dynamicweb.Controls.Charts.Funnel.prototype.renderFunnelPortion = function (context, index, container) {
    /// <summary>Renders funnel portion.</summary>
    /// <param name="context">Funnel render context.</param>
    /// <param name="index">Zero-based index of a current funnel portion.</param>
    /// <param name="container">DOM element that the portion must be rendered into.</param>

    var barHeight = 0;
    var portion = null;
    var barMaxHeight = 0;
    var portionValue = null;
    var nextPercentage = '';
    var isLastPortion = false;
    var nextPercentagePadding = 0;

    if (context && container) {
        portion = context.get_portions()[index];
        isLastPortion = index == (context.get_portions().length - 1);

        if (portion) {
            portionValue = portion.get_value();
            barHeight = parseInt(context.getPercentage(portion), 10) * 2;
            barMaxHeight = (parseInt(context.getPercentage(context.get_portions()[0]), 10) * 2) + 48;

            if (context.get_total() == 0) {
                barHeight = 5;
            }

            if (portionValue) {
                container.appendChild(this.createElement('li', {
                    'class': 'funnel-portion'
                }, [
                    this.createElement('div', {
                        'class': 'funnel-portion-bar-container',
                        'style': 'height: ' + barMaxHeight + 'px'
                    }, [
                            this.createElement('h4', {
                                'class': 'funnel-portion-annotation',
                                'style': 'bottom: ' + (barHeight) + 'px'
                            }, this.formatNumber(isLastPortion ? portionValue.get_value() : portionValue.get_annotation())),

                            this.createElement('div', {
                                'class': 'funnel-portion-bar',
                                'style': 'height: ' + barHeight + 'px'
                            })
                    ]),

                    this.createElement('p', {
                        'class': 'funnel-portion-name'
                    }, portion.get_label())
                ]));

                if (!isLastPortion) {
                    nextPercentage = context.getPercentage(context.get_portions()[index + 1], portion).toString();

                    /* Applying decimal separator according to the current culture */
                    nextPercentage = nextPercentage.replace(/,/g, '#');
                    nextPercentage = nextPercentage.replace(/\./g, '#');
                    nextPercentage = nextPercentage.replace(/\s/g, '#');
                    nextPercentage = nextPercentage.replace(/#/g, this.get_decimalSeparator());

                    if (nextPercentage.length > 2) {
                        if (nextPercentage.length == 4) {
                            nextPercentagePadding = 8;
                        } else if (nextPercentage.length == 3) {
                            nextPercentagePadding = 11;
                        } else {
                            nextPercentagePadding = 10;
                        }
                    } else if (nextPercentage.length > 1) {
                        nextPercentagePadding = 13;
                    } else {
                        nextPercentagePadding = 17;
                    }

                    nextPercentage = nextPercentage + '%';

                    container.appendChild(this.createElement('li', {
                        'class': 'funnel-portion-separator'
                    }, [
                        this.createElement('div', {
                            'class': 'funnel-portion-separator-next',
                            'style': 'padding-left: ' + nextPercentagePadding + 'px'
                        }, nextPercentage)
                    ]));
                }
            }
        }
    }
}

Dynamicweb.Controls.Charts.Funnel.prototype.createElement = function (tagName, attributes, content) {
    /// <summary>Creates new DOM element.</summary>
    /// <param name="tagName">Tag name.</param>
    /// <param name="attributes">Attributes.</param>
    /// <param name="content">Content.</param>

    var ret = new Element(tagName, attributes);

    if (content) {
        if (typeof (content) == 'string') {
            ret.update(content);
        } else if (content.length) {
            for (var i = 0; i < content.length; i++) {
                if (content[i]) {
                    ret.appendChild(content[i]);
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.Charts.Funnel.prototype.formatNumber = function (number) {
    /// <summary>Formats the given number.</summary>
    /// <param name="number">Number to format.</param>

    var n = 0;
    var ret = '0';
    var digits = [];
    var reversed = '';
    var separator = this.get_groupSeparator();

    n = parseInt(number, 10);

    if (n != null && !isNaN(n)) {
        ret = n.toString();

        for (var i = ret.length - 1; i >= 0; i--) {
            reversed += ret.charAt(i);
        }

        reversed = reversed.replace(/(\d{3})/g, '$1' + separator);

        if (reversed.slice(-separator.length) == separator)
            reversed = reversed.slice(0, -separator.length);

        ret = '';

        for (var i = reversed.length - 1; i >= 0; i--) {
            ret += reversed.charAt(i);
        }
    } else if (number != null) {
        ret = number.toString();
    }

    return ret;
}