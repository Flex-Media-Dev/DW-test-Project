Dynamicweb.Controls.OMC.RecognitionExpressionEditor.error = function (message) {
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

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager = function () {
    /// <summary>Represents a component manager.</summary>

    this._idCounter = {};
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager._instance = null;

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager.get_current = function () {
    /// <summary>Gets the current instance of the control manager.</summary>

    if (!Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager._instance) {
        Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager._instance = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager();
    }

    return Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager._instance;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager.prototype.generateComponentID = function (prefix) {
    /// <summary>Generates a unique identifier for the component.</summary>
    /// <param name="prefix">Identifier prefix.</param>

    var ret = '';

    prefix = (prefix && prefix.length) ? prefix : 'component';

    if (typeof (this._idCounter[prefix]) != 'number') {
        this._idCounter[prefix] = 0;
    }

    ret = prefix + '_' + this._idCounter[prefix];
    this._idCounter[prefix] += 1;

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Enumeration = {
    /// <summary>Represents an enumeration.</summary>

    extend: function (o) {
        /// <summary>Extends the given object with methods from enumeration object.</summary>
        /// <param name="o">Target object.</param>

        if (o) {
            for (var m in this) {
                o[m] = this[m];
            }
        }
    },

    parse: function (v) {
        /// <summary>Parses the enumeration from the given value.</summary>
        /// <param name="v">Either a string or a number representing enumeration value.</param>
        /// <returns>Enumeration value.</returns>

        var name = '';
        var ret = null;

        if (typeof (v) != 'undefined') {
            if (typeof (v) == 'number') {
                name = this.getName(v);
            } else if (typeof (v) == 'string') {
                name = this.camelCaseField(v);
            }

            if (name && name.length) {
                ret = this[name];
            }
        }

        return ret;
    },

    getName: function (v) {
        /// <summary>Returns the enumeration field name that corresponds to the given value.</summary>
        /// <param name="v">Enumeration value.</param>
        /// <returns>Enumeration field name.</returns>

        var ret = '';

        if (typeof (v) != 'undefined') {
            v = parseInt(v);
            if (v != null && !isNaN(v)) {
                for (var f in this) {
                    if (typeof (this[f]) != 'function' && this[f] == v) {
                        ret = f;
                        break;
                    }
                }
            }
        }

        return ret;
    },

    getNames: function () {
        /// <summary>Returns the array of all item names within this enumeration.</summary>

        var ret = [];

        for (var f in this) {
            if (typeof (this[f]) != 'function') {
                ret[ret.length] = f;
            }
        }

        return ret;
    },

    getValues: function () {
        /// <summary>Returns the array of all item values within this enumeration.</summary>

        var ret = [];

        for (var f in this) {
            if (typeof (this[f]) != 'function') {
                ret[ret.length] = this[f];
            }
        }

        return ret;
    },

    camelCaseField: function (str) {
        /// <summary>Normalizes the given enumeration field name by lowercasing the first letter.</summary>
        /// <param name="str">Field name to normalize.</param>
        /// <returns>Normalized field name.</returns>
        /// <private />

        var ret = '';

        if (typeof (str) != 'undefined') {
            ret = str.toString();
            if (ret && ret.length > 1) {
                ret = ret.substr(0, 1).toLowerCase() + ret.substr(1);
            }
        }

        return ret;
    },

    pascalCaseField: function (str) {
        /// <summary>Normalizes the given enumeration field name by uppercasing the first letter.</summary>
        /// <param name="str">Field name to normalize.</param>
        /// <returns>Normalized field name.</returns>
        /// <private />

        var ret = '';

        if (typeof (str) != 'undefined') {
            ret = str.toString();
            if (ret && ret.length > 1) {
                ret = ret.substr(0, 1).toUpperCase() + ret.substr(1);
            }
        }

        return ret;
    }
};

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon = function () {
    /// <summary>Represents a balloon.</summary>

    this._title = '';
    this._markup = null;
    this._target = null;
    this._content = null;
    this._hideTimeout = null;
    this._contentChanged = true;
    this._isUserInteracting = false;
    this._id = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager.get_current().generateComponentID('balloon');

    this._handlers = {
        positionChanged: []
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.add_positionChanged = function (callback) {
    /// <summary>Registers new callback which is executed when the position of the balloon changes.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }

    this._handlers.positionChanged[this._handlers.positionChanged.length] = callback;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.get_id = function () {
    /// <summary>Gets the unique identifier of the balloon.</summary>

    return this._id;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.get_isUserInteracting = function () {
    /// <summary>Gets value indicating whether user is interacting with the content of the balloon.</summary>

    return this._isUserInteracting;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.get_title = function () {
    /// <summary>Gets the balloon title.</summary>

    return this._title;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.set_title = function (value) {
    /// <summary>Sets the balloon title.</summary>
    /// <param name="value">Balloon title.</param>

    this._title = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.get_target = function () {
    /// <summary>Gets the target element.</summary>

    return this._target;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.set_target = function (value) {
    /// <summary>Sets the target element.</summary>
    /// <param name="value">Target element.</param>

    this._target = $(value);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.get_content = function () {
    /// <summary>Gets the content of the balloon.</summary>

    var ret = null;

    if (this._content) {
        if (typeof (this._content) == 'string') {
            ret = '';

            if (this._markup) {
                ret = this._markup.content.innerHTML;
            }
        } else if (this._markup) {
            ret = this._markup.content;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.set_content = function (value) {
    /// <summary>Sets the content of the balloon.</summary>
    /// <param name="value">The content of the balloon.</param>

    this._content = value;
    this._contentChanged = true;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.get_isVisible = function () {
    /// <summary>Gets value indicating whether balloon is visible.</summary>

    var ret = false;

    this._ensureLayout();

    if (this._markup.container) {
        ret = (this._markup.container.getStyle('display') || '') != 'none';
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.set_isVisible = function (value) {
    /// <summary>Sets value indicating whether balloon is visible.</summary>
    /// <param name="value">Value indicating whether balloon is visible.</param>

    if (!!value) {
        this.show();
    } else {
        this.hide();
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.show = function () {
    /// <summary>Shows the balloon.</summary>

    this._ensureLayout();

    if (this._markup.container) {
        this._markup.container.show();
        
        this.update();
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.hide = function () {
    /// <summary>Hides the balloon.</summary>

    this._ensureLayout();

    if (this._markup.container) {
        this._markup.container.hide();
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.update = function () {
    /// <summary>Updates the state of the balloon.</summary>

    this._ensureLayout();

    if (this.get_isVisible()) {
        this.updateContent();
        this.updatePosition();
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.updatePosition = function () {
    /// <summary>Updates the position of the balloon.</summary>

    var selfWidth = 0;
    var borderWidth = 38;
    var contentWidth = 0;
    var t = this.get_target();
    var scroll = { top: 0, left: 0 };
    var offset = { top: 0, left: 0 };
    var position = { left: 0, top: 0 };
    var dimensions = { width: 0, height: 0 };

    this._ensureLayout();

    if (t && this._markup) {
        dimensions = t.getDimensions();
        offset = t.viewportOffset();
        scroll = $(document.body).cumulativeScrollOffset();

        $(this._markup.container).setStyle({ 'width': 'auto' });

        selfWidth = $(this._markup.container).getWidth();
        contentWidth = $(this._markup.content).getWidth();

        /* Special case when the container width is too narrow to expose borders */
        if (selfWidth - contentWidth < borderWidth) {
            selfWidth += (borderWidth - (selfWidth - contentWidth));
        }

        position.top = (offset.top + scroll.top) + 3;
        position.left = (offset.left + scroll.left) - selfWidth + dimensions.width + 18;

        if (Prototype.Browser.Gecko) {
            position.left -= 1;
            position.top -= 2;
        }

        this._markup.container.setStyle({
            'top': position.top + 'px',
            'left': position.left + 'px',
            'width': selfWidth + 'px'
        });

        this.onPositionChanged({ position: position });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.updateContent = function () {
    /// <summary>Updates the content of the balloon.</summary>

    this._ensureLayout();

    if (this._markup) {
        if (this._content && this._contentChanged) {
            this._contentChanged = false;
            this._markup.content.innerHTML = '';

            if (typeof (this._content) == 'string') {
                this._markup.content.innerHTML = this._content;
            } else {
                this._markup.content.appendChild(this._content);
            }
        }

        this._markup.title.innerHTML = this.get_title();
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.onPositionChanged = function (e) {
    /// <summary>Fires "positionChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('positionChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype.notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];
    var callbackException = null;

    if (eventName && eventName.length) {
        callbacks = this._handlers[eventName];

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
                    this.error(callbackException.message);
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon.prototype._ensureLayout = function () {
    /// <summary>Ensures that the markup for the balloon has been created.</summary>
    /// <private />

    var tip = null;
    var row = null;
    var self = this;
    var table = null;
    var content = null;
    var container = null;
    var titleTable = null;
    var contentCell = null;
    var titleContent = null;
    var titleTableContainer = null;

    if (!this._markup) {
        this._markup = {};

        container = new Element('div', { 'id': 'markup_' + this.get_id(), 'class': 'recognition-editor-balloon' });
        container.setStyle({ 'display': 'none' });

        /* Title */
        titleTableContainer = new Element('div', { 'class': 'recognition-editor-balloon-title-container' });
        titleTable = new Element('table', { 'class': 'recognition-editor-balloon-title' });

        titleTable.writeAttribute('cellspacing', '0');
        titleTable.writeAttribute('cellpadding', '0');
        titleTable.writeAttribute('border', '0');

        row = new Element('tr');
        titleContent = new Element('span');
        contentCell = new Element('td', { 'class': 'recognition-editor-balloon-title-tm', 'valign': 'top' });

        contentCell.appendChild(titleContent);

        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-title-tl', 'valign': 'top' }).update('&nbsp;'));
        row.appendChild(contentCell);
        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-title-tr', 'valign': 'top' }).update('&nbsp;'));

        titleTable.appendChild(row);

        titleTableContainer.appendChild(titleTable);
        titleTableContainer.appendChild(new Element('div', { 'class': 'recognition-editor-balloon-clear' }));
        container.appendChild(titleTableContainer);

        /* Main grid */
        table = new Element('table', { 'class': 'recognition-editor-balloon-grid' });

        table.writeAttribute('cellspacing', '0');
        table.writeAttribute('cellpadding', '0');
        table.writeAttribute('border', '0');

        /* Top cells - tl (top left), tm (top middle), tr, (top right) */
        row = new Element('tr');

        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-grid-tl' }).update('&nbsp;'));
        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-grid-tm' }).update('&nbsp;'));
        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-grid-tr' }).update('&nbsp;'));

        table.appendChild(row);

        /* Middle cells - ml (middle left), mm (middle middle), mr, (middle right) */

        row = new Element('tr');
        content = new Element('div', { 'class': 'recognition-editor-balloon-content' });
        contentCell = new Element('td', { 'class': 'recognition-editor-balloon-grid-mm' });

        contentCell.appendChild(content);

        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-grid-ml' }).update('&nbsp;'));
        row.appendChild(contentCell);
        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-grid-mr' }).update('&nbsp;'));

        table.appendChild(row);

        /* Bottom cells - bl (bottom left), bm (bottom middle), br, (bottom right) */
        row = new Element('tr');

        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-grid-bl' }).update('&nbsp;'));
        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-grid-bm' }).update('&nbsp;'));
        row.appendChild(new Element('td', { 'class': 'recognition-editor-balloon-grid-br' }).update('&nbsp;'));

        table.appendChild(row);

        container.appendChild(table);

        Event.observe(container, 'mouseover', function (e) {
            if (self._hideTimeout) {
                clearTimeout(self._hideTimeout);
                self._hideTimeout = null;
            }

            self._isUserInteracting = true;
        });

        Event.observe(container, 'mouseout', function (e) {
            if (self._hideTimeout) {
                clearTimeout(self._hideTimeout);
                self._hideTimeout = null;
            }

            self._hideTimeout = setTimeout(function () {
                self._isUserInteracting = false;
                self.hide();
            }, 100);
        });

        this._markup.title = titleContent;
        this._markup.content = content;
        this._markup.container = container;

        this._markup.content.innerHTML = '';

        document.body.appendChild(container);
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Operator = {
    /// <summary>Represents a rule constraint operator.</summary>

    equals: 0,
    /// <summary>Equals.</summary>

    greaterThan: 1,
    /// <summary>Greater than.</summary>

    lessThan: 2,
    /// <summary>Less than.</summary>

    greaterThanOrEqualTo: 3,
    /// <summary>Greater than or equal to.</summary>

    lessThanOrEqualTo: 4,
    /// <summary>Less than or equal to.</summary>

    notEqualTo: 5,
    /// <summary>Not equal to.</summary>

    contains: 6,
    /// <summary>Contains.</summary>

    doesNotContain: 7,
    /// <summary>Does not contain.</summary>

    startsWith: 8,
    /// <summary>Starts with.</summary>

    doesNotStartWith: 9,
    /// <summary>Does not start with.</summary>

    endsWith: 10,
    /// <summary>Ends with.</summary>

    doesNotEndWith: 11,
    /// <summary>Does not end with.</summary>

    inRange: 12,
    /// <summary>In range.</summary>

    doesNotInRange: 13
    /// <summary>Does not in range.</summary>
};

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Enumeration.extend(Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Operator);

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod = {
    /// <summary>Represents a combine method for expression tree nodes.</summary>

    none: 0,
    /// <summary>Do not combine expression nodes meaning that they will evaluate individually.</summary>

    or: 1,
    /// <summary>Combine nodes using logical OR.</summary>

    and: 2
    /// <summary>Combine nodes using logical AND.</summary>
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Enumeration.extend(Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod);

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint = function () {
    /// <summary>Represents a recognition rule constraint.</summary>

    this._operator = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Operator.equals;
    this._value = null;
    this._data = null;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint.prototype.get_operator = function () {
    /// <summary>Gets the constraint operator.</summary>

    return this._operator;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint.prototype.set_operator = function (value) {
    /// <summary>Sets the constraint operator.</summary>
    /// <param name="value">Constraint operator.</param>

    this._operator = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Operator.parse(value);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint.prototype.get_value = function () {
    /// <summary>Gets the constraint value.</summary>

    return this._value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint.prototype.set_value = function (value) {
    /// <summary>Sets the constraint value.</summary>
    /// <param name="value">Constraint value.</param>

    this._value = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint.prototype.get_data = function () {
    /// <summary>Gets the constraint data.</summary>

    return this._data;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint.prototype.set_data = function (value) {
    /// <summary>Sets the constraint data.</summary>
    /// <param name="value">Constraint data.</param>

    this._data = null;

    if (typeof (value) != 'undefined' && value != null) {
        this._data = new Hash(value);
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint.prototype.load = function (data) {
    /// <summary>Replaces the state of the current object with the state of the given one.</summary>
    /// <param name="data">New state.</param>

    if (data) {
        if (typeof (data.get_operator) == 'function') {
            this.set_operator(data.get_operator());
            this.set_value(data.get_value());
            this.set_data(data.get_data());
        } else {
            this.set_operator(data.operator);
            this.set_value(data.value);
            this.set_data(data.data);

            if (this.get_value() == null && typeof (data.defaultValue) != 'undefined') {
                this.set_value(data.defaultValue);
            }
        }
    } else {
        this.set_operator(Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Operator.equals);
        this.set_value(null);
        this.set_data(null);
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule = function () {
    /// <summary>Represents a recognition rule.</summary>

    this._id = '';
    this._name = '';
    this._type = '';
    this._description = '';
    this._operators = [];
    this._constraint = null;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.get_id = function () {
    /// <summary>Gets the unique identifier of the rule.</summary>

    return this._id;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.set_id = function (value) {
    /// <summary>Sets the unique identifier of the rule.</summary>
    /// <param name="value">The unique identifier of the rule.</param>

    this._id = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.get_name = function () {
    /// <summary>Gets the rule name.</summary>

    return this._name;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.set_name = function (value) {
    /// <summary>Sets the rule name.</summary>
    /// <param name="value">The rule name.</param>

    this._name = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.get_type = function () {
    /// <summary>Gets the assembly-qualified name of the CLR type that corresponds to this rule.</summary>

    return this._type;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.set_type = function (value) {
    /// <summary>Sets the assembly-qualified name of the CLR type that corresponds to this rule.</summary>
    /// <param name="value">The assembly-qualified name of the CLR type that corresponds to this rule.</param>

    this._type = value;
}


Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.get_description = function () {
    /// <summary>Gets the rule description.</summary>

    return this._description;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.set_description = function (value) {
    /// <summary>Sets the rule description.</summary>
    /// <param name="value">The rule description.</param>

    this._description = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.get_operators = function () {
    /// <summary>Gets the rule operators.</summary>
    return this._operators;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.set_operators = function (value) {
    /// <summary>Sets the rule operators.</summary>
    /// <param name="value">The rule supported operators.</param>

    this._operators = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.get_constraint = function () {
    /// <summary>Gets the rule constraint.</summary>

    return this._constraint;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.set_constraint = function (value) {
    /// <summary>Sets the rule constraint.</summary>
    /// <param name="value">The rule constraint.</param>

    this._constraint = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule.prototype.load = function (data) {
    /// <summary>Replaces the state of the current object with the state of the given one.</summary>
    /// <param name="data">New state.</param>

    var constraint = null;
    var dataConstraint = null;


    if (data) {
        if (typeof (data.get_id) == 'function') {
            dataConstraint = data.get_constraint();

            this.set_id(data.get_id());
            this.set_name(data.get_name());
            this.set_type(data.get_type());
            this.set_description(data.get_description());
            this.set_operators(data.get_operators());
        } else {
            dataConstraint = data.constraint;

            this.set_id(data.id);
            this.set_name(data.name);
            this.set_type(data.type);
            this.set_description(data.description);
            this.set_operators(data.operators);
        }

        if (dataConstraint != null) {
            constraint = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint();
            constraint.load(dataConstraint);

            this.set_constraint(constraint);
        } else {
            this.set_constraint(null);
        }
    } else {
        this.set_id('');
        this.set_name('');
        this.set_description('');
        this.set_constraint(null);
        this.set_operators([]);
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeComponentComparator = function () {
    /// <summary>Represents an expression tree component comparator.</summary>
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeComponentComparator.prototype.compare = function (c1, c2) {
    /// <summary>Compares two expression tree components and returns the interer value representing a result of the comparison.</summary>
    /// <param name="c1">First component.</param>
    /// <param name="c1">Second component.</param>

    return (c1 == c2) ? 0 : -1;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeSerializer = function () {
    /// <summary>Represents an expression tree serializer.</summary>
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeSerializer.prototype.toXml = function (tree) {
    /// <summary>Serializes the tree to XML string.</summary>
    /// <param name="tree">Tree to serialize.</param>

    var components = [];
    var ret = '<?xml version="1.0" encoding="utf-8"?>';

    if (tree && typeof (tree.get_components) == 'function') {
        components = tree.get_components();
    }

    if (components && components.length) {
        ret += '<recognition>';
        ret += this._serializeGroup(tree);
        ret += '</recognition>';
    } else {
        ret += '<recognition />';
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeSerializer.prototype._serializeGroup = function (group) {
    /// <summary>Serializes the given expression group to XML.</summary>
    /// <param name="group">Group to serialize.</param>
    /// <private />

    var ret = '';
    var rule = null;
    var combine = '';
    var operator = '';
    var components = [];
    var constraint = null;
    var isTreeObject = false;

    if (group) {
        components = group.get_components();
        isTreeObject = typeof (group.get_points) == 'undefined';

        if (components && components.length) {
            if (typeof (group.get_method) == 'function') {
                combine = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.getName(group.get_method());
                combine = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Enumeration.pascalCaseField(combine);
            } else {
                combine = 'None';
            }

            if (!isTreeObject) {
                ret += '<group combine="' + combine + '" points="' + group.get_points() + '">';
            }

            for (var i = 0; i < components.length; i++) {
                if (typeof (components[i].get_method) == 'function') {
                    ret += this._serializeGroup(components[i]);
                } else if (typeof (components[i].get_rule) == 'function') {
                    rule = components[i].get_rule();
                    constraint = rule.get_constraint();

                    ret += '<rule type="' + rule.get_type() + '"';

                    if (isTreeObject) {
                        ret += ' points="' + components[i].get_points() + '"';
                    }

                    ret += '>';

                    if (constraint != null) {
                        ret += '<constraint';

                        if (constraint.get_operator() != null) {
                            operator = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Operator.getName(constraint.get_operator());
                            operator = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Enumeration.pascalCaseField(operator);

                            ret += ' operator="' + operator + '"';
                        }

                        if (constraint.get_value() != null) {
                            ret += ' value="' + constraint.get_value() + '"';
                            ret += ' type="System.String"';
                        }

                        ret += ' />';
                    }

                    ret += '</rule>';
                }
            }

            if (!isTreeObject) {
                ret += '</group>';
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeSerializer.prototype.fromXml = function (xml) {
    /// <summary>Deserializes the tree from XML string.</summary>
    /// <param name="xml">XML string.</param>

    var tag = '';
    var ret = null;
    var doc = null;
    var children = [];

    if (xml && xml.length) {
        doc = Try.these(
            function () { return new DOMParser().parseFromString(xml, 'text/xml'); },
            function () {
                var xmlDom = new ActiveXObject('Microsoft.XMLDOM');
                xmlDom.loadXML(xml);

                return xmlDom;
            });

        if (doc) {
            doc = doc.documentElement;
            children = typeof (doc.childNodes) != 'undefined' ? doc.childNodes : doc.childElements;

            if (children && children.length) {
                ret = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTree();

                for (var i = 0; i < children.length; i++) {
                    tag = (children[i].tagName || children[i].nodeName).toLowerCase();

                    if (tag == 'group') {
                        this._deserializeGroup(children[i], ret);
                    } else if (tag == 'rule') {
                        this._deserializeNode(children[i], ret);
                    }
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeSerializer.prototype._deserializeGroup = function (data, appendTo) {
    /// <summary>Deserializes the given expression group.</summary>
    /// <param name="data">Group to deserialize.</param>
    /// <param name="appendTo">Parent group to append to.</param>
    /// <private />

    var tag = '';
    var group = null;
    var children = [];

    if (data && appendTo) {
        group = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup();

        group.set_method(Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.parse(this._deserializedReadAttribute(data, 'combine')));
        group.set_points(this._deserializedReadAttribute(data, 'points'));

        children = typeof (data.childNodes) != 'undefined' ? data.childNodes : data.childElements;
        if (children && children.length) {
            for (var i = 0; i < children.length; i++) {
                tag = (children[i].tagName || children[i].nodeName).toLowerCase();

                if (tag == 'group') {
                    this._deserializeGroup(children[i], group);
                } else if (tag == 'rule') {
                    this._deserializeNode(children[i], group);
                }
            }
        }

        if (group.get_count() > 0) {
            appendTo.add(group);
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeSerializer.prototype._deserializeNode = function (data, appendTo) {
    /// <summary>Deserializes the given expression node.</summary>
    /// <param name="data">Node to deserialize.</param>
    /// <param name="appendTo">Parent group to append to.</param>
    /// <private />

    var tag = '';
    var node = null;
    var rule = null;
    var constraint = null;
    var constraintNode = null;

    if (data && appendTo) {
        rule = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule();
        node = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeNode();

        rule.set_type(this._deserializedReadAttribute(data, 'type'));

        if (typeof (appendTo.set_method) == 'undefined') {
            node.set_points(this._deserializedReadAttribute(data, 'points'));
        }

        /* The following information is not available and should be filled out by calling code */
        rule.set_id('');
        rule.set_name('');
        rule.set_description('');

        constraintNode = data.firstChild;
        if (constraintNode) {
            tag = constraintNode.tagName || constraintNode.nodeName;
            if (tag == 'constraint') {
                constraint = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint();

                constraint.set_operator(Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Operator.parse(this._deserializedReadAttribute(constraintNode, 'operator')));
                constraint.set_value(this._deserializedReadAttribute(constraintNode, 'value'));

                /* The following information is not available and should be filled out by calling code */
                constraint.set_data(null);
            }
        }

        rule.set_constraint(constraint);
        node.set_rule(rule);

        appendTo.add(node);
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeSerializer.prototype._deserializedReadAttribute = function (node, name) {
    /// <summary>Reads the value of the given attribute.</summary>
    /// <param name="node">Target node.</param>
    /// <param name="name">Attribute name.</param>
    /// <private />

    var ret = '';
    var attr = null;

    if (node && name && name.length) {
        if (node.attributes) {
            try {
                attr = node.attributes.getNamedItem(name);
                if (attr && typeof (attr.value) != 'undefined') {
                    ret = attr.value;
                }
            } catch (ex) { }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup = function () {
    /// <summary>Represents an expression tree group.</summary>

    this._method = null;
    this._points = 0;
    this._components = [];
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.get_count = function () {
    /// <summary>Gets the total number of elements within the group.</summary>

    return this._components.length;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.get_method = function () {
    /// <summary>Gets the combine method for this group.</summary>

    return this._method;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.set_method = function (value) {
    /// <summary>Sets the combine method for this group.</summary>
    /// <param name="value">The combine method for this group.</param>

    this._method = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.parse(value) ||
        Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.none;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.get_points = function () {
    /// <summary>Gets the number of points that is given to the user for satisfying all the rules within this group (applied only if combine method is set).</summary>

    return this._points;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.set_points = function (value) {
    /// <summary>Sets the number of points that is given to the user for satisfying all the rules within this group (applied only if combine method is set).</summary>
    /// <param name="value">The number of points that is given to the user for satisfying all the rules within this group (applied only if combine method is set).</param>

    this._points = parseInt(value);

    if (this._points == null || isNaN(this._points) || this._points < 0) {
        this._points = 0;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.get_components = function () {
    /// <summary>Gets group contents.</summary>

    return this._components;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.add = function (component) {
    /// <summary>Adds new component to the group.</summary>
    /// <param name="component">Component to add.</param>

    this._components[this._components.length] = component;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.remove = function (component) {
    /// <summary>Removes the given component from the group.</summary>
    /// <param name="component">Component to remove.</param>

    var newComponents = [];
    var index = this.indexOf(component);

    if (index >= 0 && index < this._components.length) {
        for (var i = 0; i < this._components.length; i++) {
            if (i != index) {
                newComponents[newComponents.length] = this._components[i];
            }
        }

        this._components = newComponents;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.clear = function () {
    /// <summary>Removes all components from the group.</summary>

    this._components = [];
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup.prototype.indexOf = function (component) {
    /// <summary>Returns a zero-based index of the given component within the components collection of -1 if the component cannot be found.</summary>
    /// <param name="component">Component to search for.</param>

    var ret = -1;
    var comparator = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeComponentComparator();

    for (var i = 0; i < this._components; i++) {
        if(comparator.compare(this._components[i], component) == 0) {
            ret = i;
            break;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeNode = function () {
    /// <summary>Represents an expression tree node.</summary>

    this._rule = null;
    this._points = 0;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeNode.prototype.get_rule = function () {
    /// <summary>Gets the associated recognition rule.</summary>

    return this._rule;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeNode.prototype.set_rule = function (value) {
    /// <summary>Sets the associated recognition rule.</summary>
    /// <param name="value">The associated recognition rule.</param>

    this._rule = value;

    if (this._rule == null || typeof (this._rule.get_constraint) != 'function') {
        this._rule = null;
        Dynamicweb.Controls.OMC.RecognitionExpressionEditor.error('Expression tree node must be associated with valid recognition rule.');
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeNode.prototype.get_points = function () {
    /// <summary>Gets the number of points that is given to the user for satisfying all the rules within this group (applied only if the node is not part of the combined group).</summary>

    return this._points;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeNode.prototype.set_points = function (value) {
    /// <summary>Sets the number of points that is given to the user for satisfying all the rules within this group (applied only if the node is not part of the combined group).</summary>
    /// <param name="value">The number of points that is given to the user for satisfying all the rules within this group (applied only if the node is not part of the combined group).</param>

    this._points = parseInt(value);

    if (this._points == null || isNaN(this._points) || this._points < 0) {
        this._points = 0;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTree = function () {
    /// <summary>Represents an expression tree.</summary>

    this._components = [];
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTree.prototype.get_count = function () {
    /// <summary>Gets the total number of elements within the group.</summary>

    return this._components.length;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTree.prototype.get_components = function () {
    /// <summary>Gets tree contents.</summary>

    return this._components;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTree.prototype.add = function (component) {
    /// <summary>Adds new component to the tree.</summary>
    /// <param name="component">Component to add.</param>

    this._components[this._components.length] = component;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTree.prototype.remove = function (component) {
    /// <summary>Removes the given component from the tree.</summary>
    /// <param name="component">Component to remove.</param>

    var newComponents = [];
    var index = this.indexOf(component);

    if (index >= 0 && index < this._components.length) {
        for (var i = 0; i < this._components.length; i++) {
            if (i != index) {
                newComponents[newComponents.length] = this._components[i];
            }
        }

        this._components = newComponents;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTree.prototype.clear = function () {
    /// <summary>Removes all components from the tree.</summary>

    this._components = [];
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTree.prototype.indexOf = function (component) {
    /// <summary>Returns a zero-based index of the given component within the components collection of -1 if the component cannot be found.</summary>
    /// <param name="component">Component to search for.</param>

    var ret = -1;
    var comparator = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeComponentComparator();

    for (var i = 0; i < this._components; i++) {
        if (comparator.compare(this._components[i], component) == 0) {
            ret = i;
            break;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode = function () {
    /// <summary>Represents a tree node.</summary>

    this._id = 0;
    this._isSelected = false;
    this._rule = '';
    this._constraintOperator = null;
    this._constraintValue = null;
    this._order = 0;
    this._points = 0;

    this._handlers = {
        stateChanged: [],
        selectedChanged: [],
        ruleChanged: [],
        constraintOperatorChanged: [],
        constraintValueChanged: [],
        orderChanged: [],
        pointsChanged: []
    };
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.get_id = function () {
    /// <summary>Gets the node ID.</summary>

    return this._id;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.set_id = function (value) {
    /// <summary>Sets the node ID.</summary>
    /// <param name="value">Node ID.</param>

    this._id = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.get_isSelected = function () {
    /// <summary>Gets value indicating whether node is selected.</summary>

    return !!this._isSelected;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.set_isSelected = function (value) {
    /// <summary>Sets value indicating whether node is selected.</summary>
    /// <param name="value">Value indicating whether node is selected.</param>

    var origValue = !!this._isSelected;

    value = !!value;
    this._isSelected = value;

    if (origValue != value) {
        this.onSelectedChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'selected', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.get_rule = function () {
    /// <summary>Gets the ID of the associated rule.</summary>

    return this._rule;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.set_rule = function (value) {
    /// <summary>Sets the ID of the associated rule.</summary>
    /// <param name="value">The ID of the associated rule.</param>

    var origValue = this._rule;

    this._rule = value;

    if (origValue != value) {
        this.onRuleChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'rule', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.get_constraintOperator = function () {
    /// <summary>Gets the constraint operator.</summary>

    return this._constraintOperator;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.set_constraintOperator = function (value) {
    /// <summary>Sets the constraint operator.</summary>
    /// <param name="value">The constraint operator.</param>

    var origValue = this._constraintOperator;

    this._constraintOperator = value;

    if (origValue != value) {
        this.onConstraintOperatorChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'constraintOperator', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.get_constraintValue = function () {
    /// <summary>Gets the constraint value.</summary>

    return this._constraintValue;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.set_constraintValue = function (value) {
    /// <summary>Sets the constraint value.</summary>
    /// <param name="value">The constraint value.</param>

    var origValue = this._constraintValue;

    this._constraintValue = value;

    if (origValue != value) {
        this.onConstraintValueChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'constraintValue', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.get_order = function () {
    /// <summary>Gets the sort order.</summary>

    return this._order;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.set_order = function (value) {
    /// <summary>Sets the sort order.</summary>
    /// <param name="value">The sort order.</param>

    var origValue = this._order;

    this._order = value;

    if (origValue != value) {
        this.onOrderChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'order', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.get_points = function () {
    /// <summary>Gets the amount of points that is associated with this node.</summary>

    return this._points;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.set_points = function (value) {
    /// <summary>Sets the amount of points that is associated with this node.</summary>
    /// <param name="value">The amount of points that is associated with this node.</param>

    var origValue = this._points;

    this._points = value;

    if (origValue != value) {
        this.onPointsChanged({ oldValue: origValue, newValue: value });
        this.onStateChanged({ name: 'points', oldValue: origValue, newValue: value });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.add_stateChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the state of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.stateChanged[this._handlers.stateChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.add_selectedChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the "Selected" state of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.selectedChanged[this._handlers.selectedChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.add_ruleChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the associated rule of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.ruleChanged[this._handlers.ruleChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.add_constraintOperatorChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the constraint operator of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.constraintOperatorChanged[this._handlers.constraintOperatorChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.add_constraintValueChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the constraint value of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.constraintValueChanged[this._handlers.constraintValueChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.add_orderChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the order of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.orderChanged[this._handlers.orderChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.add_pointsChanged = function (callback) {
    /// <summary>Registers a new callback that is executed when the points amount of the tree node changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.pointsChanged[this._handlers.pointsChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.onStateChanged = function (e) {
    /// <summary>Raises "stateChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('stateChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.onSelectedChanged = function (e) {
    /// <summary>Raises "selectedChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('selectedChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.onRuleChanged = function (e) {
    /// <summary>Raises "ruleChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('ruleChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.onConstraintOperatorChanged = function (e) {
    /// <summary>Raises "constraintOperatorChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('constraintOperatorChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.onConstraintValueChanged = function (e) {
    /// <summary>Raises "constraintValueChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('constraintValueChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.onOrderChanged = function (e) {
    /// <summary>Raises "orderChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('orderChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.onPointsChanged = function (e) {
    /// <summary>Raises "pointsChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('pointsChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.load = function (data, silent) {
    /// <summary>Replaces the state of the current object with the state of the given one.</summary>
    /// <param name="data">New state.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>

    if (data) {
        if (typeof (data.get_rule) != 'undefined') {
            if (!silent) {
                this.set_isSelected(data.get_isSelected());
                this.set_rule(data.get_rule());
                this.set_constraintOperator(data.get_constraintOperator());
                this.set_constraintValue(data.get_constraintValue());
                this.set_order(data.get_order());
                this.set_points(data.get_points());
            } else {
                this._isSelected = data.get_isSelected();
                this._rule = data.get_rule();
                this._constraintOperator = data.get_constraintOperator();
                this._constraintValue = data.get_constraintValue();
                this._order = data.get_order();
                this._points = data.get_points();
            }
        } else {
            if (!silent) {
                this.set_isSelected(data.isSelected);
                this.set_rule(data.rule);
                this.set_constraintOperator(data.constraintOperator);
                this.set_constraintValue(data.constraintValue);
                this.set_order(data.order);
                this.set_points(data.points);
            } else {
                this._isSelected = !!data.isSelected;
                this._rule = data.rule;
                this._constraintOperator = data.constraintOperator;
                this._constraintValue = data.constraintValue;
                this._order = data.order;
                this._points = data.points;
            }
        }
    } else {
        this._isSelected = false;
        this._rule = '';
        this._constraintOperator = null;
        this._constraintValue = null;
        this._order = 0;
        this._points = 0;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode.prototype.notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];
    var callbackException = null;

    if (eventName && eventName.length) {
        callbacks = this._handlers[eventName];

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
                    Dynamicweb.Controls.OMC.RecognitionExpressionEditor.error(callbackException.message);
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination = function () {
    /// <summary>Represents a combination of tree nodes.</summary>

    this._id = null;
    this._components = [];
    this._componentsHash = new Hash();
    this._method = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.and;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.isCombination = function (id) {
    /// <summary>Determines whether the given ID references to another combination.</summary>
    /// <param name="id">ID to examine.</param>

    var ret = false;

    if (id && id.length) {
        ret = id.indexOf('(') == 0 && id.lastIndexOf(')') == (id.length - 1);
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.containsNode = function (combinationID, nodeID) {
    /// <summary>Gets value indicating whether given combination contains the given node.</summary>
    /// <param name="combinationID">An ID of the combination.</param>
    /// <param name="nodeID">An ID of the tree node.</param>

    var ret = false;

    if (combinationID && combinationID.length && nodeID && nodeID.length) {
        ret = combinationID.indexOf('(' + nodeID + ',') >= 0 ||
            combinationID.indexOf(',' + nodeID + ',') >= 0 ||
            combinationID.indexOf(',' + nodeID + ')') >= 0;
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.parseComponents = function (id) {
    /// <summary>Parses the list of components by using the given combination ID.</summary>
    /// <param name="id">Combination id to examine.</param>

    var ret = [];
    var component = '';
    var components = [];
    var nestedComponentDepth = 0;

    if (id && id.length) {
        if (Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.isCombination(id)) {
            id = id.substr(1, id.length - 2);

            for (var i = 0; i < id.length; i++) {
                if (id[i] == ',') {
                    if (nestedComponentDepth == 0) {
                        if (component && component.length) {
                            ret[ret.length] = component;
                            component = '';
                        }
                    } else {
                        component += id[i];
                    }
                } else if (id[i] == '(') {
                    nestedComponentDepth += 1;
                    component += id[i];
                } else if (id[i] == ')') {
                    nestedComponentDepth -= 1;
                    component += id[i];

                    if (nestedComponentDepth <= 0) {
                        nestedComponentDepth = 0;

                        ret[ret.length] = component;
                        component = '';
                    }
                } else {
                    component += id[i];
                }
            }

            if (component && component.length) {
                ret[ret.length] = component;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.prototype.get_id = function () {
    /// <summary>Gets the unique identifier of this combination.</summary>

    this._id = '(';

    for (var i = 0; i < this._components.length; i++) {
        if (this._components[i]) {
            if (typeof (this._components[i]) == 'string') {
                this._id += this._components[i];
            } else if (typeof (this._components[i].get_id) == 'function') {
                this._id += this._components[i].get_id();
            }

            if (i < (this._components.length - 1)) {
                this._id += ',';
            }
        }
    }

    this._id += ')';

    return this._id;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.prototype.get_components = function () {
    /// <summary>Gets the list of tree components (nodes and child combinations) that are part of this combination.</summary>

    return this._components;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.prototype.get_componentsDistribution = function () {
    /// <summary>Gets an object that contains information about all the components of this combination (on all levels) and their distribution across nested combinations.</summary>

    var parsedNodes = {};
    var ret = { nodes: [], map: new Hash() };

    var processComponents = function (id) {
        var existingComponents = [];
        var components = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.parseComponents(id);

        if (components && components.length) {
            for (var i = 0; i < components.length; i++) {
                if (!ret.map.get(id)) {
                    ret.map.set(id, []);
                }

                existingComponents = ret.map.get(id);
                existingComponents[existingComponents.length] = components[i];
                ret.map.set(id, existingComponents);

                if (!Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.isCombination(components[i])) {
                    if (!parsedNodes[components[i]]) {
                        parsedNodes[components[i]] = true;
                        ret.nodes[ret.nodes.length] = components[i];
                    }
                } else {
                    processComponents(components[i]);
                }
            }
        }
    }

    processComponents(this.get_id());

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.prototype.get_method = function () {
    /// <summary>Gets the combine method.</summary>

    return this._method;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.prototype.set_method = function (value) {
    /// <summary>Sets the combine method.</summary>
    /// <param name="value">Combine method.</param>

    this._method = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.prototype.add = function (component) {
    /// <summary>Adds new component to the combination.</summary>
    /// <param name="component">Component to add.</param>

    var id = '';
    var pattern =  /[a-zA-Z0-9_]+/gi;

    if (component && !this.contains(component)) {
        if (typeof (component) == 'string') {
            id = component;
        } else if (typeof (component.get_id) == 'function') {
            id = component.get_id();
        }

        /* Preventing empty sub-combinations to be added */
        if(id && id.length && pattern.test(id)) {
            this._components[this._components.length] = component;
            this._componentsHash.set(id, true);
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.prototype.remove = function (component) {
    /// <summary>Removes the given component from the combination.</summary>
    /// <param name="component">Component to remove.</param>

    var matches = false;
    var newComponents = [];
    var componentIdentity = '';

    if (component) {
        if (typeof (component) == 'string') {
            componentIdentity = component;
        } else if (typeof (component.get_id) == 'function') {
            componentIdentity = component.get_id();
        }

        this._componentsHash.unset(componentIdentity);

        for (var i = 0; i < this._components.length; i++) {
            if (this._components[i]) {
                if (typeof (this._components[i]) == 'string') {
                    matches = (this._components[i] == componentIdentity);
                } else if (typeof (this._components[i].get_id) == 'function') {
                    matches = (this._components[i].get_id() == componentIdentity);
                }

                if (!matches) {
                    newComponents[newComponents.length] = this._components[i];
                }
            }
        }

        this._components = newComponents;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.prototype.contains = function (component) {
    /// <summary>Determines whether combination contains the given component.</summary>
    /// <param name="value">Component to search for.</param>

    var ret = false;
    var matches = false;
    var componentIdentity = '';

    if (component) {
        if (typeof (component) == 'string') {
            componentIdentity = component;
        } else if (typeof (component.get_id) == 'function') {
            componentIdentity = component.get_id();
        }

        ret = !!this._componentsHash.get(componentIdentity);
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.prototype.sortComponents = function (sorting) {
    /// <summary>Sorts components according to the given sorting rules and returns the sorted version.</summary>
    /// <param name="sorting">A hash that contains the sort number for each component.</param>

    var ret = [];
    var keys = [];

    var sortValue = function (component) {
        var result = 0;
        var componentIdentity = '';

        if (typeof (component) == 'string') {
            componentIdentity = component;
        } else if (typeof (component.get_id) == 'function') {
            componentIdentity = component.get_id();
        }

        if (componentIdentity) {
            result = sorting.get(componentIdentity);
            if (result == null || isNaN(result) || result < 0) {
                result = 0;
            }
        }

        return result;
    }

    for (var i = 0; i < this._components.length; i++) {
        ret[ret.length] = this._components[i];
    }

    if (sorting && typeof (sorting.keys) == 'function') {
        keys = sorting.keys();
        for (var i = 0; i < ret.length; i++) {
            for (var j = 0; j < keys.length; j++) {
                if (Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.containsNode(ret[i], keys[j])) {
                    sorting.set(ret[i], sorting.get(keys[j]));
                }
            }
        }

        ret.sort(function (c1, c2) {
            return sortValue(c1) - sortValue(c2);
        });
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeConverter = function () {
    /// <summary>Represents a tree converter.</summary>

    this._tree = null;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeConverter.prototype.toExpression = function (tree) {
    /// <summary>Converts the given tree to recognition expression.</summary>
    /// <param name="tree">Tree to convert.</param>

    var rootNodes = [];
    var combination = null;
    var topCombinations = new Hash();
    var ret = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTree();

    if (tree != null && typeof (tree.root) == 'function') {
        this._tree = tree;

        /* Getting a list of root nodes */
        rootNodes = this._tree.root();

        if (rootNodes && rootNodes.length) {
            for (var i = 0; i < rootNodes.length; i++) {
                /* Checking whether node is part of a combination */
                if (!this._tree.isCombined(rootNodes[i].node.get_id())) {
                    /* This is "free" node - simply adding it to the group */
                    ret.add(this._createNode(rootNodes[i].node));
                } else {
                    /* Getting the reference to outer most combination */
                    combination = this._tree.topOwningCombination(rootNodes[i].node.get_id());

                    /* Checking whether we already processed this combination */
                    if (!topCombinations.get(combination.get_id())) {
                        topCombinations.set(combination.get_id(), true);

                        /* Recursively adding groups */
                        this._addGroupsRecursive(ret, combination);
                    }
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeConverter.prototype.fromExpression = function (expression, onNodeCreate) {
    /// <summary>Loads the tree from the given recognition expression.</summary>
    /// <param name="expression">Recognition expression.</param>
    /// <param name="onNodeCreate">Callback that is called when the new node is created.</param>

    var nodes = [];
    var combinations = [];
    var combination = null;
    var combinationsInfos = [];
    var combinationComponents = [];
    var ret = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree('imported');

    onNodeCreate = onNodeCreate || function () { }

    var collectNodesRecursive = function (parent) {
        var n = null;
        var result = [];
        var combo = null;
        var comboComponents = [];
        var components = parent.get_components();

        for (var i = 0; i < components.length; i++) {
            if (typeof (components[i].get_rule) == 'function') {
                n = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode();

                n.set_id(ret.generateNodeID());
                n.set_isSelected(false);

                if (components[i].get_rule()) {
                    n.set_rule(components[i].get_rule().get_id());
                }

                if (components[i].get_rule().get_constraint()) {
                    n.set_constraintOperator(components[i].get_rule().get_constraint().get_operator());
                    n.set_constraintValue(components[i].get_rule().get_constraint().get_value());
                }

                n.set_points(components[i].get_points());

                if (typeof (parent.get_points) == 'function') {
                    n.set_points(parent.get_points());
                }

                n.set_order(0);

                onNodeCreate(n, components[i]);

                nodes[nodes.length] = n;
                result[result.length] = n.get_id();
            } else if (typeof (components[i].get_components) == 'function') {
                combo = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination();

                comboComponents = collectNodesRecursive(components[i]);

                for (var j = 0; j < comboComponents.length; j++) {
                    combo.add(comboComponents[j]);
                }

                result[result.length] = combo.get_id();
                combinationsInfos[combinationsInfos.length] = { id: combo.get_id(), method: components[i].get_method() };
            }
        }

        return result;
    }

    if (expression && typeof (expression.get_components) == 'function') {
        collectNodesRecursive(expression);

        ret.appendRange(nodes, null);

        for (var i = 0; i < combinationsInfos.length; i++) {
            combination = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination();

            combination.set_method(combinationsInfos[i].method);
            combinationComponents = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.parseComponents(combinationsInfos[i].id);

            for (var j = 0; j < combinationComponents.length; j++) {
                combination.add(combinationComponents[j]);
            }

            combinations[combinations.length] = combination;
        }

        ret._combinations = combinations;
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeConverter.prototype._addGroupsRecursive = function (parent, combination) {
    /// <summary>Recursively adds groups to the given parent group.</summary>
    /// <param name="parent">Parent group.</param>
    /// <param name="combination">Corresponding tree node combination.</param>

    var n = null;
    var group = null;
    var components = [];
    var distribution = null;
    var sorting = new Hash();

    if (parent && combination) {
        distribution = combination.get_componentsDistribution();

        if (distribution && distribution.nodes && distribution.nodes.length) {
            group = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeGroup();

            group.set_method(combination.get_method());
            group.set_points(this._tree.node(distribution.nodes[0]).get_points());

            for (var i = 0; i < distribution.nodes.length; i++) {
                sorting.set(distribution.nodes[i], this._tree.node(distribution.nodes[i]).get_order());
            }

            components = combination.sortComponents(sorting);

            for (var i = 0; i < components.length; i++) {
                if (!Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination.isCombination(components[i])) {
                    group.add(this._createNode(this._tree.node(components[i])));
                } else {
                    this._addGroupsRecursive(group, this._tree.combination(components[i]));
                }
            }

            parent.add(group);
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeConverter.prototype._createNode = function (n) {
    /// <summary>Creates an expression node from the given tree node.</summary>
    /// <param name="n">Reference to tree node.</param>

    var ret = null;
    var rule = null;
    var constraint = null;

    if (!n || typeof (n.get_id) != 'function') {
        Dynamicweb.Controls.OMC.RecognitionExpressionEditor.error('Unable to create an expression tree node from non-existant tree node.');
    } else {
        rule = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule();
        ret = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeNode();
        constraint = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.RuleConstraint();

        constraint.set_operator(n.get_constraintOperator());
        constraint.set_value(n.get_constraintValue());

        /* The following information is not available and should be filled out by calling code */
        constraint.set_data(null);

        rule.set_id(n.get_rule());

        /* The following information is not available and should be filled out by calling code */
        rule.set_name('');
        rule.set_type('');
        rule.set_description('');

        rule.set_constraint(constraint);

        ret.set_rule(rule);
        ret.set_points(n.get_points());
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree = function (id) {
    /// <summary>Represents a tree.</summary>
    /// <param name="id">Optional. Identifier of the tree.</param>

    this._id = id;
    this._nodes = [];                   // index -> node
    this._combinations = [];            // An array of combinations
    this._nodeIdentityIndex = {};       // node ID -> node index
    this._childToParentRelation = {};   // node ID -> parent node ID
    this._parentToChildRelation = {};   // node ID -> array of child node IDs
    this._isSilent = false;

    this._handlers = {
        update: [],
        afterNodeAppend: [],
        afterNodeRemove: [],
        selectionChanged: [],
        totalPointsChanged: []
    };
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.get_id = function () {
    /// <summary>Gets the identifier of the tree.</summary>

    return this._id;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.get_size = function () {
    /// <summary>Gets the total number of nodes within the tree.</summary>

    return this._nodes.length;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.get_isSilent = function () {
    /// <summary>Gets value indicating whether all events are disabled and won't be fired.</summary>

    return this._isSilent;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.set_isSilent = function (value) {
    /// <summary>Sets value indicating whether all events are disabled and won't be fired.</summary>
    /// <param name="value">Value indicating whether all events are disabled and won't be fired.</param>

    this._isSilent = !!value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.toExpression = function (tree) {
    /// <summary>Converts the given tree to recognition expression.</summary>
    /// <param name="tree">Tree to convert.</param>

    return new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeConverter().toExpression(this);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.fromExpression = function (expression, onNodeCreate) {
    /// <summary>Loads the tree from the given recognition expression.</summary>
    /// <param name="expression">Recognition expression.</param>
    /// <param name="onNodeCreate">Callback that is called when the new node is created.</param>

    this.copyFrom(new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeConverter().fromExpression(expression, onNodeCreate));
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.copyFrom = function (tree) {
    /// <summary>Copies data from the given tree to the current one.</summary>
    /// <param name="tree">Tree to copy data from.</param>

    var self = this;
    var originalIsSilent = this.get_isSilent();

    this.set_isSilent(true);

    this.clear();

    if (tree && typeof (tree.root) == 'function') {
        this._nodes = tree._nodes;
        this._combinations = tree._combinations;
        this._nodeIdentityIndex = tree._nodeIdentityIndex;
        this._childToParentRelation = tree._childToParentRelation;
        this._parentToChildRelation = tree._parentToChildRelation;

        for (var i = 0; i < this._nodes.length; i++) {
            this._nodes[i].add_stateChanged(function (sender, args) { self.onUpdate({ type: 'node', parameters: args }); });
            this._nodes[i].add_selectedChanged(function (sender, args) { self.onSelectionChanged({ selection: self.selection(null, true) }); });
            this._nodes[i].add_pointsChanged(function (sender, args) { self.onTotalPointsChanged({ points: self.totalPoints() }); });
        }
    }

    this.set_isSilent(originalIsSilent);

    this.onUpdate({ type: 'structure' });
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.clear = function () {
    /// <summary>Removes all nodes from the tree and clears the internal state.</summary>

    this._nodes = [];
    this._combinations = [];
    this._nodeIdentityIndex = {};
    this._childToParentRelation = {};
    this._parentToChildRelation = {};

    this.onUpdate({ type: 'structure' });
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.root = function () {
    /// <summary>Returns the list of root nodes.</summary>

    var ret = [];
    var nodeIndex = -1;
    var nodes = this._parentToChildRelation['root'];

    if (nodes && nodes.length) {
        for (var i = 0; i < nodes.length; i++) {
            nodeIndex = this._nodeIdentityIndex[nodes[i]];

            if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                ret[ret.length] = { index: nodeIndex, node: this._nodes[nodeIndex] }
            }
        }
    }

    this._sort(ret);

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.combine = function (nodes, method) {
    /// <summary>Combines the given nodes using the given combine method.</summary>
    /// <param name="nodes">The list of node IDs/child combinations.</param>
    /// <param name="method">Combine method.</param>

    var points = 0;
    var self = this;
    var topNode = '';
    var nodeIndex = -1;
    var combined = false;
    var combination = null;
    var originalSilent = false;
    var existingCombinationCount = 0;
    var existingCombinationIndex = -1;
    var originalExistingCombinationID = '';

    /* Finds the ID of the top node as seen in the tree hierarchy */
    var topNodeID = function () {
        var prev = [];
        var result = '';
        var nodesCount = 0;
        var minNodesCount = 65536;

        /* Returns a list of previous siblings of the given node */
        var prevSiblings = function (n) {
            var nodeID = '';
            var innerResult = [];
            var siblings = self.siblings(n);

            if (siblings && siblings.length) {
                if (typeof (n) == 'string') {
                    nodeID = n;
                } else if (typeof (n.get_id) == 'function') {
                    nodeID = n.get_id();
                }

                if (nodeID && nodeID.length) {
                    for (var i = 0; i < siblings.length; i++) {
                        /* Nodes are already sorted so we just loop through until we reach our node */
                        if (siblings[i].node.get_id() != nodeID) {
                            innerResult[innerResult.length] = siblings[i].node;
                        } else {
                            break;
                        }
                    }
                }
            }

            return innerResult;
        }

        /* Returns the total number of child nodes (including all children of children on all levels) */
        var childrenCount = function (n) {
            var innerResult = 0;
            var children = self.children(n);

            if (children && children.length) {
                innerResult += children.length;
                for (var i = 0; i < children.length; i++) {
                    innerResult += childrenCount(children[i].node);
                }
            }

            return innerResult;
        }

        if (nodes && nodes.length) {
            for (var i = 0; i < nodes.length; i++) {
                nodesCount = 0;
                prev = prevSiblings(nodes[i]);

                nodesCount += prev.length;
                if (prev.length) {
                    for (var j = 0; j < prev.length; j++) {
                        nodesCount += childrenCount(prev[j]);
                    }
                }

                /* Finding a node with a minimum number of "previous" nodes */
                if (nodesCount < minNodesCount) {
                    minNodesCount = nodesCount;
                    result = nodes[i];
                }
            }
        }

        if (typeof (result) != 'string' && typeof (result.get_id) == 'function') {
            result = result.get_id();
        }

        return result;
    }

    var modifyParentCombinationsRecursive = function (oldComponent, newComponent) {
        var originalCombinationID = '';

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(oldComponent)) {
                originalCombinationID = self._combinations[i].get_id();

                self._combinations[i].remove(oldComponent);
                self._combinations[i].add(newComponent);

                modifyParentCombinationsRecursive(originalCombinationID, self._combinations[i].get_id());

                break;
            }
        }
    }

    if (nodes && nodes.length) {
        if (method < 0) {
            method = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.and;
        }

        /* Checking whether we need to break existing combination instead of creating/editing one */
        if (method == Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.none) {
            this.breakCombination(nodes);
        } else {
            /* First, checking whether all nodes are part of the same existing combination */
            for (var i = 0; i < this._combinations.length; i++) {
                existingCombinationCount = 0;

                for (var j = 0; j < nodes.length; j++) {
                    if (this._combinations[i].contains(nodes[j])) {
                        existingCombinationCount += 1;
                    } else {
                        break;
                    }
                }

                if (existingCombinationCount == nodes.length) {
                    existingCombinationIndex = i;
                    break;
                }
            }

            /* All nodes are part of one existing combination - simply changing method (if needed) */
            if (existingCombinationIndex >= 0 && existingCombinationCount == this._combinations[existingCombinationIndex].get_components().length) {
                if (this._combinations[existingCombinationIndex].get_method() != method) {
                    this._combinations[existingCombinationIndex].set_method(method);
                    combined = true;
                }
            } else {
                topNode = topNodeID();
                nodeIndex = this._nodeIdentityIndex[topNode];
                if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                    points = this._nodes[nodeIndex].get_points();
                }

                originalSilent = this.get_isSilent();
                this.set_isSilent(true);

                for (var i = nodes.length - 1; i >= 0; i--) {
                    if (nodes[i] != topNode) {
                        this.move(nodes[i], this._childToParentRelation[topNode], topNode);
                        nodeIndex = this._nodeIdentityIndex[nodes[i]];
                        if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                            this._nodes[nodeIndex].set_points(points);
                        }
                    }
                }

                this.set_isSilent(originalSilent);

                combination = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNodeCombination();

                combination.set_method(method);
                for (var i = 0; i < nodes.length; i++) {
                    combination.add(nodes[i]);
                }

                this._combinations[this._combinations.length] = combination;

                if (existingCombinationIndex >= 0) {
                    originalExistingCombinationID = this._combinations[existingCombinationIndex].get_id();

                    for (var i = 0; i < nodes.length; i++) {
                        this._combinations[existingCombinationIndex].remove(nodes[i]);
                    }

                    this._combinations[existingCombinationIndex].add(this._combinations[this._combinations.length - 1].get_id());
                    modifyParentCombinationsRecursive(originalExistingCombinationID, this._combinations[existingCombinationIndex].get_id());
                }

                combined = true;
            }
        }
    }

    if (combined) {
        this.onUpdate({ type: 'structure' });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.breakCombination = function (nodes, moveNodes) {
    /// <summary>Removes the combinations from the given nodes.</summary>
    /// <param name="nodes">The list of node IDs.</param>
    /// <param name="moveNodes">Value indicating whether to move nodes within the tree according to other combinations.</param>

    var self = this;
    var oldOrder = -1;
    var newOrder = -1;
    var nodeIndex = -1;
    var childIndex = -1;
    var newChildren = [];
    var nodeParent = null;
    var nodeFound = false;
    var moveNodeIndex = -1;
    var newCombinations = [];
    var keepCombinations = [];
    var minComponentOrder = 0;
    var newCombinationID = '';
    var processedCombinations = [];
    var combinationComponents = [];
    var breakFullCombinations = [];
    var children = this.children(null);
    var modifiedParentCombinations = [];

    /* Merges two arrays */
    var mergeResults = function (result1, result2) {
        var result = [];
        var found = false;

        if (result1 && result1.length) {
            for (var i = 0; i < result1.length; i++) {
                result[result.length] = result1[i];
            }
        }

        if (result2 && result2.length) {
            for (var i = 0; i < result2.length; i++) {
                found = false;

                for (var j = 0; j < result.length; j++) {
                    if (result[j] == result2[i]) {
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    result[result.length] = result2[i];
                }
            }
        }

        return result;
    }

    /* Substracts one array from another one */
    var substractResults = function (result1, result2) {
        var result = [];
        var found = false;

        if (result1 && result1.length) {
            if (result2 && result2.length) {
                for (var i = 0; i < result1.length; i++) {
                    found = false;

                    for (var j = 0; j < result2.length; j++) {
                        if (result1[i] == result2[j]) {
                            found = true;
                            break;
                        }
                    }

                    if (!found) {
                        result[result.length] = result1[i];
                    }
                }
            } else {
                result = result1;
            }
        }

        if (!result) {
            result = [];
        }

        return result;
    }

    /* Gets the nearly (or completely) empty combination indexes from the given list of combination indexes */
    var nearlyEmptyCombinations = function (targetCombinations) {
        var result = [];

        if (targetCombinations && targetCombinations.length) {
            for (var i = 0; i < targetCombinations.length; i++) {
                if (targetCombinations[i] >= 0 && targetCombinations[i] < self._combinations.length) {
                    if (self._combinations[targetCombinations[i]].get_components().length <= 1) {
                        result[result.length] = targetCombinations[i];
                    }
                }
            }
        }

        return result;
    }

    /* Reduces the number of combinations by removing nearly (or completely) empty combinations */
    var reduceParentCombinations = function (targetCombinations) {
        var newCombinations = [];
        var combinationFound = false;
        var allCombinationsIndexes = [];
        var nearlyEmpty = nearlyEmptyCombinations(targetCombinations);

        while (nearlyEmpty.length > 0) {
            newCombinations = [];
            allCombinationsIndexes = [];

            for (var i = 0; i < self._combinations.length; i++) {
                combinationFound = false;

                for (var j = 0; j < nearlyEmpty.length; j++) {
                    if (i == nearlyEmpty[j]) {
                        combinationFound = true;
                        break;
                    }
                }

                if (!combinationFound) {
                    newCombinations[newCombinations.length] = self._combinations[i];
                    allCombinationsIndexes[allCombinationsIndexes.length] = i;
                }
            }

            self._combinations = newCombinations;
            nearlyEmpty = nearlyEmptyCombinations(allCombinationsIndexes);
        }
    }

    var modifyParentCombinationsRecursive = function (oldComponent, newComponent) {
        var result = [];
        var originalCombinationID = '';

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(oldComponent)) {
                originalCombinationID = self._combinations[i].get_id();

                self._combinations[i].remove(oldComponent);
                self._combinations[i].add(newComponent);

                result[result.length] = i;
                result = mergeResults(result, modifyParentCombinationsRecursive(originalCombinationID, self._combinations[i].get_id()));

                break;
            }
        }

        return result;
    }

    if (nodes && nodes.length) {
        for (var i = 0; i < this._combinations.length; i++) {
            processedCombinations[i] = { combination: i, id: this._combinations[i].get_id(), isAffected: false, nodes: [] };

            /* Distributing nodes by combinations */
            for (var j = 0; j < nodes.length; j++) {
                if (this._combinations[i].contains(nodes[j])) {
                    processedCombinations[i].isAffected = true;
                    processedCombinations[i].nodes[processedCombinations[i].nodes.length] = nodes[j];
                }
            }
        }

        for (var i = 0; i < nodes.length; i++) {
            breakFullCombinations[breakFullCombinations.length] = nodes[i];
        }

        for (var i = 0; i < processedCombinations.length; i++) {
            /* Checking whether we have nearly empty combinations (the ones that will have only one element after reduction and therefore are not valid) */
            if (processedCombinations[i].isAffected && (processedCombinations[i].nodes.length == (this._combinations[processedCombinations[i].combination].get_components().length - 1))) {
                for (var j = 0; j < processedCombinations[i].nodes.length; j++) {
                    nodeFound = false;

                    for (var k = 0; k < breakFullCombinations.length; k++) {
                        if (breakFullCombinations[k] == processedCombinations[i].nodes[j]) {
                            nodeFound = true;
                            break;
                        }
                    }

                    if (!nodeFound) {
                        breakFullCombinations[breakFullCombinations.length] = processedCombinations[i].nodes[j];
                    }
                }
            }
        }

        if (breakFullCombinations.length != nodes.length) {
            this.breakCombination(breakFullCombinations);
        } else {
            for (var i = 0; i < processedCombinations.length; i++) {
                /* Removing nodes from the corresponding combinations */
                if (processedCombinations[i].isAffected) {
                    for (var j = 0; j < processedCombinations[i].nodes.length; j++) {
                        this._combinations[processedCombinations[i].combination].remove(processedCombinations[i].nodes[j]);
                    }

                    /* This combination is still not empty (contains more then one element) - it will be kept */
                    if (this._combinations[processedCombinations[i].combination].get_components().length > 1) {
                        keepCombinations[keepCombinations.length] = processedCombinations[i].combination;
                    }

                    newCombinationID = this._combinations[processedCombinations[i].combination].get_id();
                    if (this._combinations[processedCombinations[i].combination].get_components().length == 1) {
                        newCombinationID = this._combinations[processedCombinations[i].combination].get_components()[0];
                    }

                    /* Modifying parent combinations */
                    modifiedParentCombinations = mergeResults(modifiedParentCombinations,
                        modifyParentCombinationsRecursive(processedCombinations[i].id, newCombinationID));
                } else {
                    keepCombinations[keepCombinations.length] = processedCombinations[i].combination;
                }
            }

            /* Reducing the amount of parent combinations */
            if (modifiedParentCombinations.length) {
                reduceParentCombinations(modifiedParentCombinations);
            }

            if (this._combinations.length) {
                if (keepCombinations.length != this._combinations.length) {
                    /* All combinations must be removed */
                    if (keepCombinations.length == 0) {
                        this._combinations = [];
                    } else {
                        newCombinations = [];

                        for (var i = 0; i < keepCombinations.length; i++) {
                            if (this._combinations[keepCombinations[i]]) {
                                newCombinations[newCombinations.length] = this._combinations[keepCombinations[i]];
                            }
                        }

                        this._combinations = newCombinations;
                    }
                }
            }

            if (typeof (moveNodes) == 'undefined' || moveNodes == null || !!moveNodes) {
                if (children.length) {
                    moveNodeIndex = children.length - 1;

                    for (var i = children.length - 1; i >= 0; i--) {
                        if (!this.owningCombination(children[i].node.get_id())) {
                            moveNodeIndex = (i - 1);
                        } else {
                            break;
                        }
                    }

                    if (moveNodeIndex < 0) {
                        moveNodeIndex = 0;
                    }

                    for (var i = 0; i < nodes.length; i++) {
                        this.move(nodes[i], null, children[moveNodeIndex].node.get_id());
                    }
                }
            }

            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.combinationDepth = function (id) {
    /// <summary>Gets the number representing the amount of combinations that this node is a part of.</summary>
    /// <param name="id">Node ID.</param>

    var ret = 0;
    var self = this;
    var closestCombinationID = '';

    var collectParentCombinationsCount = function (combinationID) {
        var ret = 0;

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(combinationID)) {
                ret += collectParentCombinationsCount(self._combinations[i].get_id()) + 1;
                break;
            }
        }

        return ret;
    }

    for (var i = 0; i < this._combinations.length; i++) {
        if (this._combinations[i].contains(id)) {
            closestCombinationID = this._combinations[i].get_id();
            break;
        }
    }

    if (closestCombinationID && closestCombinationID.length) {
        ret = collectParentCombinationsCount(closestCombinationID) + 1;
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.moveToCombination = function (id, combination) {
    /// <summary>Moves the given node to the different combination.</summary>
    /// <param name="id">Node ID.</param>
    /// <param name="combination">Combination reference.</param>

    var points = 0;
    var self = this;
    var nodeIndex = -1;
    var canProcess = true;
    var combinationIndex = -1;
    var combinationNodes = null;
    var originalCombinationID = '';
    var originalIsSilent = this.get_isSilent();

    var modifyParentCombinationsRecursive = function (oldComponent, newComponent) {
        var originalCombinationID = '';

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(oldComponent)) {
                originalCombinationID = self._combinations[i].get_id();

                self._combinations[i].remove(oldComponent);
                self._combinations[i].add(newComponent);

                modifyParentCombinationsRecursive(originalCombinationID, self._combinations[i].get_id());

                break;
            }
        }
    }

    var conditionalBreakCombination = function () {
        var result = true;
        var comboIndex = getCombinationIndex(combination);

        if (comboIndex >= 0 && comboIndex < self._combinations.length) {
            if (self._combinations[comboIndex].contains(id) && self._combinations[comboIndex].get_components().length < 3) {
                result = false;
            }
        }

        if (result) {
            self.breakCombination([id], false);
        }

        return result;
    }

    var getCombinationIndex = function (ref) {
        var result = -1;
        var refComboID = '';

        if (ref != null) {
            if (typeof (ref) == 'string') {
                refComboID = ref;
            } else if (typeof (ref.get_id) == 'function') {
                refComboID = ref.get_id();
            } else if (typeof (ref) == 'number') {
                result = ref;
            }

            if (result < 0 && refComboID && refComboID.length) {
                for (var i = 0; i < self._combinations.length; i++) {
                    if (self._combinations[i].get_id() == refComboID) {
                        result = i;
                        break;
                    }
                }
            }
        }

        return result;
    }

    if (id && id.length) {
        this.set_isSilent(true);

        canProcess = conditionalBreakCombination();

        this.set_isSilent(originalIsSilent);

        if (canProcess) {
            if (combination != null) {
                combinationIndex = getCombinationIndex(combination);

                if (combinationIndex >= 0 && combinationIndex < this._combinations.length) {
                    combinationNodes = this._combinations[combinationIndex].get_componentsDistribution().nodes;
                    if (combinationNodes && combinationNodes.length) {
                        nodeIndex = this._nodeIdentityIndex[combinationNodes[0]];
                        if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                            points = this._nodes[nodeIndex].get_points();
                        }
                    }

                    nodeIndex = this._nodeIdentityIndex[id];
                    if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                        this.set_isSilent(true);
                        this._nodes[nodeIndex].set_points(points);
                        this.set_isSilent(originalIsSilent);
                    }

                    originalCombinationID = this._combinations[combinationIndex].get_id();

                    this._combinations[combinationIndex].add(id);

                    modifyParentCombinationsRecursive(originalCombinationID, this._combinations[combinationIndex].get_id());
                }

                this.onUpdate({ type: 'structure' });
            }
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.combination = function (id) {
    /// <summary>Returns the tree node combination by its ID.</summary>
    /// <param name="id">Combination ID.</param>

    var ret = null;

    if (id && id.length) {
        for (var i = 0; i < this._combinations.length; i++) {
            if (this._combinations[i].get_id() == id) {
                ret = this._combinations[i];
                break;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.topOwningCombination = function (id) {
    /// <summary>Returns the reference to the top owning combination of the given node.</summary>
    /// <param name="id">Node ID.</param>

    var ret = null;
    var self = this;
    var combinationIndex = -1;

    var parentCombinationIndexRecursive = function (component) {
        var result = -1;
        var parentResult = -1;

        for (var i = 0; i < self._combinations.length; i++) {
            if (self._combinations[i].contains(component)) {
                result = i;
                parentResult = parentCombinationIndexRecursive(self._combinations[i].get_id());

                if (parentResult >= 0) {
                    result = parentResult;
                }

                break;
            }
        }

        return result;
    }

    combinationIndex = parentCombinationIndexRecursive(id);
    if (combinationIndex >= 0 && combinationIndex < this._combinations.length) {
        ret = this._combinations[combinationIndex];
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.owningCombination = function (id) {
    /// <summary>Returns the reference to the owning combination of the given node.</summary>
    /// <param name="id">Node ID.</param>

    var ret = null;

    if (id && id.length) {
        for (var i = 0; i < this._combinations.length; i++) {
            if (this._combinations[i].contains(id)) {
                ret = this._combinations[i];
                break;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.isCombined = function (id) {
    /// <summary>Returns value indicating whether the given node is part of any combination.</summary>
    /// <param name="id">Node ID.</param>

    var ret = false;

    for (var i = 0; i < this._combinations.length; i++) {
        if (this._combinations[i].contains(id)) {
            ret = true;
            break;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.moveUp = function (id) {
    /// <summary>Moves the given node one position up in the tree hierarchy.</summary>
    /// <param name="id">Node ID.</param>

    var children = [];
    var parent = null;
    var nodeOrder = -1;
    var nodeIndex = -1;
    var childIndex = -1;
    var siblings = null;
    var newChildren = [];
    var combination = null;
    var changeOrder = false;
    var isFirstChild = false;
    var parentOfParent = null;
    var selfCombination = null;
    var originalIsSilent = false;
    var previousSiblingIndex = -1;

    nodeIndex = this._nodeIdentityIndex[id];

    if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
        /* Saving the order of the node (will use it later) */
        nodeOrder = this._nodes[nodeIndex].get_order();

        /* Getting the ID of the parent node */
        parent = this._childToParentRelation[id];

        /* First, determining if it's a first child node of its parent */
        siblings = this.siblings(id);

        /* Checking for first child */
        if (siblings && siblings.length) {
            isFirstChild = siblings[0].node.get_id() == id;
        }

        if (isFirstChild) {
            /* Parent can't be null in case of first child = can't move the top node further up */
            if (parent != null) {
                /* Moving to the parent of parent */
                parentOfParent = this._childToParentRelation[parent];

                /* Attaching to a new node */
                this._childToParentRelation[id] = parentOfParent;

                /* Removing relation to the old parent node */
                if (this._parentToChildRelation[parent]) {
                    /* Collecting new children */
                    for (var i = 0; i < this._parentToChildRelation[parent].length; i++) {
                        if (this._parentToChildRelation[parent][i] != id) {
                            newChildren[newChildren.length] = this._parentToChildRelation[parent][i];
                        }
                    }

                    /* Changing the sort oder */
                    for (var i = 0; i < newChildren.length; i++) {
                        childIndex = this._nodeIdentityIndex[newChildren[i]];

                        if (this._nodes[childIndex].get_order() > nodeOrder) {
                            this._nodes[childIndex]._order -= 1;
                        }
                    }

                    /* Commited new children of the old parent */
                    this._parentToChildRelation[parent] = newChildren;
                }

                /* Might be a new root node */
                if (parentOfParent == null) {
                    parentOfParent = 'root';
                }

                if (!this._parentToChildRelation[parentOfParent]) {
                    this._parentToChildRelation[parentOfParent] = [];
                }

                /* Adding new children to the new parent */
                this._parentToChildRelation[parentOfParent][this._parentToChildRelation[parentOfParent].length] = id;

                /* Changing the sort order (the last sibling) */
                this._nodes[nodeIndex]._order = this.children(parentOfParent).length - 1;

                this.onUpdate({ type: 'structure' });
            }
        } else {
            nodeOrder -= 1;
            changeOrder = true;
            children = this.children(parent);

            /* Retrieving the index of the previous sibling */
            for (var i = 0; i < children.length; i++) {
                if (this._nodes[children[i].index].get_order() == nodeOrder && children[i].node.get_id() != id) {
                    previousSiblingIndex = children[i].index;
                    break;
                }
            }

            /* Examining the previous sibling's combination (if it's within the combination) */
            if (previousSiblingIndex >= 0) {
                selfCombination = this.owningCombination(id);
                combination = this.owningCombination(this._nodes[previousSiblingIndex].get_id());

                if (combination) {
                    /* Nodes are part of different combinations */
                    if (selfCombination == null || selfCombination.get_id() != combination.get_id()) {
                        changeOrder = false;

                        originalIsSilent = this.get_isSilent();
                        this.set_isSilent(true);

                        /* 
                        By moving this node up it will be a prt of different combination. 
                        Don't change the sort order, simply changing the combination. 
                        */
                        if (selfCombination) {
                            this.breakCombination([id], false);
                        }

                        this.moveToCombination(id, combination);

                        this.set_isSilent(originalIsSilent);
                    }
                }
            }

            if (changeOrder) {
                for (var i = 0; i < children.length; i++) {
                    /* Moving the previous sibling down (increasing sort order) */
                    if (this._nodes[children[i].index].get_order() == nodeOrder && children[i].node.get_id() != id) {
                        this._nodes[children[i].index]._order += 1;

                        break;
                    }
                }

                /* Moving one position up (by simply changing the sort order) */
                this._nodes[nodeIndex]._order = nodeOrder;

                /* Taking combinations into account (moving to combination) */
                if (previousSiblingIndex >= 0) {
                    combination = this.owningCombination(this._nodes[previousSiblingIndex].get_id());

                    if (combination) {
                        originalIsSilent = this.get_isSilent();
                        this.set_isSilent(true);

                        this.moveToCombination(id, combination);

                        this.set_isSilent(originalIsSilent);
                    }
                }
            }

            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.moveDown = function (id) {
    /// <summary>Moves the given node one position down in the tree hierarchy.</summary>
    /// <parm name="id">Node ID.</param>

    var self = this;
    var children = [];
    var parent = null;
    var nodeOrder = -1;
    var nodeIndex = -1;
    var siblings = null;
    var newChildren = [];
    var combination = null;
    var isLastChild = false;
    var changeOrder = false;
    var parentOfParent = null;
    var nextSiblingIndex = -1;
    var selfCombination = null;
    var originalIsSilent = false;

    nodeIndex = this._nodeIdentityIndex[id];

    var finalizeMove = function (tryChangeCombination) {
        if ((typeof (tryChangeCombination) == 'undefined' || tryChangeCombination == null || !!tryChangeCombination) && nextSiblingIndex >= 0) {
            combination = self.owningCombination(self._nodes[nextSiblingIndex].get_id());

            if (combination) {
                originalIsSilent = self.get_isSilent();
                self.set_isSilent(true);

                self.moveToCombination(id, combination);

                self.set_isSilent(originalIsSilent);
            }
        }

        self.onUpdate({ type: 'structure' });
    }

    if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
        /* Saving the order of the node (will use it later) */
        nodeOrder = this._nodes[nodeIndex].get_order();

        /* Getting the ID of the parent node */
        parent = this._childToParentRelation[id];

        /* First, determining if it's a last child node of its parent */
        siblings = this.siblings(id);

        if (siblings && siblings.length) {
            isLastChild = siblings[siblings.length - 1].node.get_id() == id;
        }

        if (isLastChild) {
            /* Parent can't be null in case of last child = can't move the bottom node further down */
            if (parent != null) {
                /* Moving to the parent of parent */
                parentOfParent = this._childToParentRelation[parent];
                children = this.children(parentOfParent);

                /* Attaching to a new node */
                this._childToParentRelation[id] = parentOfParent;

                /* Removing relation to the old parent node */
                if (this._parentToChildRelation[parent]) {
                    /* Collecting new children */
                    for (var i = 0; i < this._parentToChildRelation[parent].length; i++) {
                        if (this._parentToChildRelation[parent][i] != id) {
                            newChildren[newChildren.length] = this._parentToChildRelation[parent][i];
                        }
                    }

                    /* Commited new children of the old parent */
                    this._parentToChildRelation[parent] = newChildren;
                }

                /* Might be a new root node */
                if (parentOfParent == null) {
                    parentOfParent = 'root';
                }

                if (!this._parentToChildRelation[parentOfParent]) {
                    this._parentToChildRelation[parentOfParent] = [];
                }

                /* Adding new children to the new parent */
                this._parentToChildRelation[parentOfParent][this._parentToChildRelation[parentOfParent].length] = id;

                /* Changing the sort order (the first sibling) */
                this._nodes[nodeIndex]._order = 0;

                /* Moving all other siblings one position down */
                for (var i = 0; i < children.length; i++) {
                    if (i == 0) {
                        nextSiblingIndex = children[i].index;
                    }

                    this._nodes[children[i].index]._order += 1;
                }

                finalizeMove();
            }
        } else {
            nodeOrder += 1;
            changeOrder = true;
            children = this.children(parent);

            /* Retrieving the index of the next sibling */
            for (var i = 0; i < children.length; i++) {
                if (this._nodes[children[i].index].get_order() == nodeOrder && children[i].node.get_id() != id) {
                    nextSiblingIndex = children[i].index;
                    break;
                }
            }

            /* Examining the next sibling's combination (if it's within the combination) */
            if (nextSiblingIndex >= 0) {
                selfCombination = this.owningCombination(id);
                combination = this.owningCombination(this._nodes[nextSiblingIndex].get_id());

                if (combination) {
                    /* Nodes are part of different combinations */
                    if (selfCombination == null || selfCombination.get_id() != combination.get_id()) {
                        changeOrder = false;

                        originalIsSilent = this.get_isSilent();
                        this.set_isSilent(true);

                        /* 
                        By moving this node down it will be a prt of different combination. 
                        Don't change the sort order, simply changing the combination. 
                        */
                        if (selfCombination) {
                            this.breakCombination([id], false);
                        }

                        this.moveToCombination(id, combination);

                        this.set_isSilent(originalIsSilent);
                    }
                } else if (selfCombination) {
                    changeOrder = false;

                    /* 
                    Sibling is part of any combinations but the target node is.
                    Don't change the sort order, simply breaking the combination.
                    */
                    this.breakCombination([id], false);

                    finalizeMove(false);
                }
            }

            if (changeOrder) {
                for (var i = 0; i < children.length; i++) {
                    /* Moving the next sibling up (decreasing sort order) */
                    if (this._nodes[children[i].index].get_order() == nodeOrder && children[i].node.get_id() != id) {
                        this._nodes[children[i].index]._order -= 1;

                        nextSiblingIndex = children[i].index;

                        break;
                    }
                }

                /* Moving one position down (by simply changing the sort order) */
                this._nodes[nodeIndex]._order = nodeOrder;
            }

            finalizeMove();
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.move = function (node, newParent, refNode) {
    /// <summary>Moves the node from one location to another.</summary>
    /// <param name="node">Node to move.</param>
    /// <param name="newParent">New parent node.</param>
    /// <param name="refNode">Node to place the target node after.</param>

    var self = this;
    var oldOrder = 0;
    var children = [];
    var nodeOrder = 0;
    var nodeIndex = -1;
    var orderDelta = 0;
    var childIndex = 0;
    var newChildren = [];
    var oldParent = null;
    var refNodeIndex = -1;
    var appendToRelation = null;

    var finalizeMove = function (modifyCombination) {
        var originalSilent = false;
        var refNodeCombination = null;

        if (refNode && modifyCombination) {
            originalSilent = self.get_isSilent();

            self.set_isSilent(true);

            refNodeCombination = self.owningCombination(refNode);
            self.moveToCombination(node, refNodeCombination);

            self.set_isSilent(originalSilent);
        }

        self.onUpdate({ type: 'structure' });
    }

    if (node) {
        /* Normalizing input parameters */
        if (typeof (node) != 'string' && typeof (node.get_id) == 'function') node = node.get_id();
        if (newParent && typeof (newParent) != 'string' && typeof (newParent.get_id) == 'function') newParent = newParent.get_id();
        if (refNode != null && typeof (refNode) != 'string' && typeof (refNode.get_id) == 'function') refNode = refNode.get_id();

        nodeIndex = this._nodeIdentityIndex[node];
        if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
            if (this._childToParentRelation[node] == newParent) {
                /* The old and the new parent node is the same node */
                if (refNode) {
                    /* Reference node specified - chaing the sort order */
                    refNodeIndex = this._nodeIdentityIndex[refNode];
                    if (refNodeIndex >= 0 && refNodeIndex < this._nodes.length) {
                        children = this.children(newParent);
                        orderDelta = this._nodes[refNodeIndex].get_order() - this._nodes[nodeIndex].get_order();

                        if (orderDelta < 0) {
                            /* Moving node up */
                            for (var i = 0; i < children.length; i++) {
                                if (children[i].node.get_id() == node) {
                                    break;
                                } else if (children[i].node.get_order() > this._nodes[refNodeIndex].get_order()) {
                                    this._nodes[children[i].index]._order += 1;
                                }
                            }
                        } else {
                            /* Moving node down */
                            for (var i = 0; i < children.length; i++) {
                                if (children[i].node.get_id() != node && children[i].node.get_order() > this._nodes[nodeIndex].get_order()) {
                                    if (children[i].node.get_order() <= this._nodes[refNodeIndex].get_order()) {
                                        this._nodes[children[i].index]._order -= 1;
                                    } else {
                                        /*this._nodes[children[i].index]._order += 1;*/
                                        break;
                                    }
                                }
                            }
                        }

                        /* Changing the sort order and finalizing the move process (firing notifications) */
                        this._nodes[nodeIndex]._order = this._nodes[refNodeIndex]._order + 1;

                        finalizeMove(false);
                    }
                }
            } else {
                appendToRelation = newParent;
                children = this.children(newParent);
                oldParent = this._childToParentRelation[node];
                oldOrder = this._nodes[nodeIndex].get_order();

                /* Determining new sort order and the reference node */
                if (children && children.length) {
                    nodeOrder = children.length - 1;

                    if (!refNode) {
                        refNode = children[0].node.get_id();
                    }
                }

                if (!newParent || !newParent.length) appendToRelation = 'root';
                if (!oldParent || !oldParent.length) oldParent = 'root';
                if (!this._parentToChildRelation[appendToRelation]) this._parentToChildRelation[appendToRelation] = [];

                this._nodes[nodeIndex]._order = nodeOrder;

                /* Attaching node to a new parent */
                this._childToParentRelation[node] = newParent;
                this._parentToChildRelation[appendToRelation][this._parentToChildRelation[appendToRelation].length] = node;

                /* Removing relations to old parent */
                if (this._parentToChildRelation[oldParent]) {
                    if (this._parentToChildRelation[oldParent].length <= 1) {
                        this._parentToChildRelation[oldParent] = [];
                    } else {
                        for (var i = 0; i < this._parentToChildRelation[oldParent].length; i++) {
                            if (this._parentToChildRelation[oldParent][i] != node) {
                                newChildren[newChildren.length] = this._parentToChildRelation[oldParent][i];
                            }
                        }

                        this._parentToChildRelation[oldParent] = newChildren;

                        /* Changing the sort order */
                        for (var i = 0; i < newChildren.length; i++) {
                            childIndex = this._nodeIdentityIndex[newChildren[i]];
                            if (childIndex >= 0 && childIndex < this._nodes.length) {
                                if (this._nodes[childIndex].get_order() > oldOrder) {
                                    this._nodes[childIndex]._order -= 1;
                                }
                            }
                        }
                    }
                }

                finalizeMove(true);
            }
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.node = function (id) {
    /// <summary>Returns the reference to a tree node by its ID.</summary>
    /// <param name="id">Node ID.</param>

    var ret = null;
    var nodeIndex = this._nodeIdentityIndex[id];

    if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
        ret = this._nodes[nodeIndex];
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.nodes = function (ids) {
    /// <summary>Returns the list of nodes with given IDs.</summary>
    /// <param name="ids">Node IDs.</param>

    var ret = [];
    var nodeIndex = -1;

    if (ids && ids.length) {
        for (var i = 0; i < ids.length; i++) {
            nodeIndex = this._nodeIdentityIndex[ids[i]];
            if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                ret[ret.length] = { index: nodeIndex, node: this._nodes[nodeIndex] };
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.children = function (parent) {
    /// <summary>Returns a list of all top-level child nodes of a given node.</summary>
    /// <param name="parent">Parent node ID.</param>

    var ret = [];
    var children = [];
    var nodeIndex = -1;

    if (parent != null && (typeof (parent) != 'string' && typeof (parent.get_id) == 'function')) {
        parent = parent.get_id();
    }

    if (!parent || !parent.length) {
        parent = 'root';
    }

    if (this._parentToChildRelation[parent] && this._parentToChildRelation[parent].length) {
        children = this._parentToChildRelation[parent];

        for (var i = 0; i < children.length; i++) {
            nodeIndex = this._nodeIdentityIndex[children[i]];
            if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
                ret[ret.length] = { index: nodeIndex, node: this._nodes[nodeIndex] };
            }
        }
    }

    this._sort(ret);

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.selection = function (parent, recursive) {
    /// <summary>Gets all selected nodes of the given parent node.</summary>
    /// <param name="parent">An ID of the parent node. If omitted, the selection within the entire tree will be retrieved.</param>
    /// <param name="recusrive">Value indicating whether to recursively collect all child selected nodes of the given parent. Only takes effect if parent node is specified.</param>

    return this._collectSelection(parent, recursive);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.setSelection = function (parent, selected, recursive) {
    /// <summary>Changes the "selected" mode of the given tree nodes.</summary>
    /// <param name="parent">An ID of the parent node. If omitted, the selection within the entire tree will be retrieved.</param>
    /// <param name="selected">Value indicating whether nodes are selected.</param>
    /// <param name="recusrive">Value indicating whether to recursively collect all child selected nodes of the given parent. Only takes effect if parent node is specified.</param>

    var originalSilent = this.get_isSilent();

    this.set_isSilent(true);
    this._collectSetSelection(parent, selected, recursive);
    this.set_isSilent(originalSilent);

    this.onSelectionChanged({ selection: this.selection(null, true) });
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.siblings = function (node) {
    /// <summary>Returns a list of all siblings of a given node, including the given node.</summary>
    /// <param name="parent">Node reference.</param>

    var ret = [];
    var parentID = this._childToParentRelation[node];

    if (parentID == null) {
        ret = this.root();
    } else {
        ret = this.children(parentID);
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.firstChild = function (parent) {
    /// <summary>Gets the reference to first child of the given parent node.</summary>
    /// <param name="parent">Parent node ID.</param>

    var ret = null;
    var children = this.children(parent);

    if (children && children.length) {
        ret = { index: children[0].index, node: children[0].node };
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.lastChild = function (parent) {
    /// <summary>Gets the reference to last child of the given parent node.</summary>
    /// <param name="parent">Parent node ID.</param>

    var ret = null;
    var children = this.children(parent);

    if (children && children.length) {
        ret = { index: children[children.length - 1].index, node: children[children.length - 1].node };
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.clearChildren = function (parent) {
    /// <summary>Removes all child nodes of the given parent node.</summary>
    /// <param name="parent">An ID of the parent node.</param>

    var nodeIDs = [];
    var children = this.children(parent);

    if (children && children.length) {
        for (var i = 0; i < children.length; i++) {
            nodeIDs[nodeIDs.length] = children[i].node.get_id();
        }

        this.removeRange(nodeIDs);
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.append = function (node, appendTo) {
    /// <summary>Adds new node to the tree.</summary>
    /// <param name="node">Node to add.</param>
    /// <param name="appendTo">An ID of the parent node.</param>

    this._append(node, appendTo, false);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.appendRange = function (nodes, appendTo) {
    /// <summary>Adds given list of nodes to the tree.</summary>
    /// <param name="nodes">Nodes to add.</param>
    /// <param name="appendTo">An ID of the parent node.</param>

    this._appendRange(nodes, appendTo, false);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.remove = function (nodeID) {
    /// <summary>Removes the given node from the tree.</summary>
    /// <param name="nodeID">Node ID.</param>

    this._remove(nodeID, false);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.removeRange = function (nodes) {
    /// <summary>Removes the given list of nodes from the tree.</summary>
    /// <param name="nodes">A list of node IDs to remove.</param>

    this._removeRange(nodes, false);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.add_update = function (callback) {
    /// <summary>Registers a new callback that is executed when the tree updates.</summary>

    if (callback && typeof (callback) == 'function') {
        this._handlers.update[this._handlers.update.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.add_afterNodeAppend = function (callback) {
    /// <summary>Registers a new callback that is executed after tree node has been added.</summary>

    if (callback && typeof (callback) == 'function') {
        this._handlers.afterNodeAppend[this._handlers.afterNodeAppend.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.add_afterNodeRemove = function (callback) {
    /// <summary>Registers a new callback that is executed when after tree node has been removed.</summary>

    if (callback && typeof (callback) == 'function') {
        this._handlers.afterNodeRemove[this._handlers.afterNodeRemove.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.add_selectionChanged = function (callback) {
    /// <summary>Registers a new callback that is executed after tree selection changes.</summary>

    if (callback && typeof (callback) == 'function') {
        this._handlers.selectionChanged[this._handlers.selectionChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.add_totalPointsChanged = function (callback) {
    /// <summary>Registers a new callback that is executed whenever the total amount of points changes.</summary>

    if (callback && typeof (callback) == 'function') {
        this._handlers.totalPointsChanged[this._handlers.totalPointsChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.onUpdate = function (e) {
    /// <summary>Raises "update" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('update', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.onAfterNodeAppend = function (e) {
    /// <summary>Raises "afterNodeAppend" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('afterNodeAppend', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.onAfterNodeRemove = function (e) {
    /// <summary>Raises "afterNodeRemove" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('afterNodeRemove', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.onSelectionChanged = function (e) {
    /// <summary>Raises "selectionChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('selectionChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.onTotalPointsChanged = function (e) {
    /// <summary>Raises "totalPointsChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('totalPointsChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];
    var callbackException = null;

    if (!this.get_isSilent()) {
        if (eventName && eventName.length) {
            callbacks = this._handlers[eventName];

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
                        Dynamicweb.Controls.OMC.RecognitionExpressionEditor.error(callbackException.message);
                    }
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.totalPoints = function () {
    /// <summary>Calculates the total amount of points that the current expression can evaluate to.</summary>

    var ret = 0;
    var firstNode = null;
    var combination = null;
    var combinationID = '';
    var distribution = null;
    var rootNodes = this.root();
    var processedCombinations = new Hash();

    for (var i = 0; i < rootNodes.length; i++) {
        combination = this.topOwningCombination(rootNodes[i].node.get_id());
        if (!combination) {
            ret += rootNodes[i].node.get_points();
        } else {
            combinationID = combination.get_id();

            if (!processedCombinations.get(combinationID)) {
                processedCombinations.set(combinationID, true);

                distribution = combination.get_componentsDistribution();
                if (distribution && distribution.nodes && distribution.nodes.length) {
                    firstNode = this.node(distribution.nodes[0]);
                    if (firstNode) {
                        ret += firstNode.get_points();
                    }
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype.generateNodeID = function () {
    /// <summary>Generates the unique numeric identifier.</summary>

    var prefix = this.get_id();

    if (typeof (prefix) == 'undefined' || typeof (prefix) != 'string') {
        prefix = '';
    } else {
        prefix = prefix + '_';
    }

    return Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ComponentManager.get_current().generateComponentID(prefix + 'node');
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype._append = function (node, appendTo, silent) {
    /// <summary>Adds new node to the tree.</summary>
    /// <param name="node">Node to add.</param>
    /// <param name="appendTo">An ID of the parent node.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>
    /// <private />

    var n = null;
    var nodeID = 0;
    var self = this;
    var nodeIndex = -1;
    var childrenMap = [];
    var appendToIndex = -1;
    var appendToRelation = appendTo;

    if (node) {
        if (typeof (node.id) == 'string') {
            nodeID = node.id;
        } else if (typeof (node.get_id) == 'function') {
            nodeID = node.get_id();
        }

        if (!nodeID || !nodeID.length) {
            nodeID = this.generateNodeID();
        }

        childrenMap = this.children(appendTo);
        n = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeNode();

        n.load(node, true);
        n.set_id(nodeID);
        n._order = childrenMap.length;
        n.add_stateChanged(function (sender, args) { self.onUpdate({ type: 'node', parameters: args }); });

        nodeIndex = this._nodes.length;

        this._nodes[nodeIndex] = n;
        this._nodeIdentityIndex[nodeID] = nodeIndex;
        this._childToParentRelation[nodeID] = appendTo;

        if (!appendTo || !appendTo.length) {
            appendToRelation = 'root';
        }

        if (!this._parentToChildRelation[appendToRelation]) {
            this._parentToChildRelation[appendToRelation] = [];
        }

        this._parentToChildRelation[appendToRelation][this._parentToChildRelation[appendToRelation].length] = nodeID;

        this._parentToChildRelation[nodeID] = [];

        n.add_selectedChanged(function (sender, args) {
            self.onSelectionChanged({ selection: self.selection(null, true) });
        });

        n.add_pointsChanged(function (sender, args) {
            self.onTotalPointsChanged({ points: self.totalPoints() });
        });

        if (!silent) {
            this.onAfterNodeAppend({ nodes: [this._nodes[nodeIndex]] });
            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype._appendRange = function (nodes, appendTo, silent) {
    /// <summary>Adds the given range of nodes to the tree.</summary>
    /// <param name="nodes">Nodes to add.</param>
    /// <param name="appendTo">An ID of the parent node.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>
    /// <private />

    var target = null;
    var targetNodes = [];

    if (nodes && nodes.length) {
        for (var i = 0; i < nodes.length; i++) {
            this._append(nodes[i], appendTo, true);
        }

        target = this.nodes(nodes);

        for (var i = 0; i < target.length; i++) {
            targetNodes[targetNodes.length] = target[i].node;
        }

        if (!silent) {
            this.onAfterNodeAppend({ nodes: targetNodes });
            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype._remove = function (nodeID, silent) {
    /// <summary>Removes the given node from the tree.</summary>
    /// <param name="nodeID">Node ID.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>
    /// <private />

    var node = null;
    var parentID = '';
    var children = [];
    var newNodes = [];
    var nodeIndex = -1;
    var nodeOrder = -1;
    var affectedIDs = [];
    var siblingsMap = [];
    var newChildren = [];

    if (typeof (this._nodeIdentityIndex[nodeID]) != 'undefined' && this._nodeIdentityIndex[nodeID] != null) {
        nodeIndex = this._nodeIdentityIndex[nodeID];

        if (nodeIndex >= 0 && nodeIndex < this._nodes.length) {
            node = this._nodes[nodeIndex];

            for (var i = 0; i < this._nodes.length; i++) {
                if (this._nodes[i].get_id() != nodeID) {
                    newNodes[newNodes.length] = this._nodes[i];
                } else {
                    nodeOrder = this._nodes[i].get_order();
                }

                if (i > nodeIndex) {
                    affectedIDs[affectedIDs.length] = this._nodes[i].get_id();
                }
            }

            if (typeof (this._childToParentRelation[nodeID]) != 'undefined') {
                parentID = this._childToParentRelation[nodeID];
                if (!parentID || !parentID.length) {
                    parentID = 'root';
                }

                if (this._parentToChildRelation[parentID]) {
                    for (var i = 0; i < this._parentToChildRelation[parentID].length; i++) {
                        if (this._parentToChildRelation[parentID][i] != nodeID) {
                            newChildren[newChildren.length] = this._parentToChildRelation[parentID][i];
                        }
                    }

                    this._parentToChildRelation[parentID] = newChildren;
                }
            }

            for (var childID in this._childToParentRelation) {
                if (typeof (this._childToParentRelation[childID]) != 'function' && this._childToParentRelation[childID] == nodeID) {
                    children[children.length] = childID;
                }
            }

            this._nodes = newNodes;

            delete this._nodeIdentityIndex[nodeID];
            delete this._parentToChildRelation[nodeID];

            for (var i = 0; i < affectedIDs.length; i++) {
                this._nodeIdentityIndex[affectedIDs[i]] -= 1;
            }

            for (var i = 0; i < children.length; i++) {
                this._remove(children[i], true);
            }

            siblingsMap = this.siblings(nodeID);

            if (siblingsMap && siblingsMap.length) {
                for (var i = 0; i < siblingsMap.length; i++) {
                    if (this._nodes[siblingsMap[i].index].get_order() > nodeOrder) {
                        this._nodes[siblingsMap[i].index]._order -= 1;
                    }
                }
            }

            this.breakCombination([nodeID]);

            if (!silent) {
                this.onAfterNodeRemove({ nodes: [node] });
                this.onUpdate({ type: 'structure' });
            }
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype._removeRange = function (nodes, silent) {
    /// <summary>Removes the given range of nodes from the tree.</summary>
    /// <param name="nodes">Nodes to remove.</param>
    /// <param name="silent">Indicates whether to prohibit any events from firing.</param>
    /// <private />

    var target = null;
    var targetNodes = [];

    if (nodes && nodes.length) {
        target = this.nodes(nodes);

        for (var i = 0; i < target.length; i++) {
            targetNodes[targetNodes.length] = target[i].node;
        }

        for (var i = 0; i < nodes.length; i++) {
            this._remove(nodes[i], true);
        }

        if (!silent) {
            this.onAfterNodeRemove({ nodes: targetNodes });
            this.onUpdate({ type: 'structure' });
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype._collectSelection = function (parent, recursive) {
    /// <summary>Collects selected tree nodes.</summary>
    /// <param name="parent">Parent node ID.</param>
    /// <param name="recursive">Value indicating whether to recursively collect all child nodes that are selected.</param>
    /// <private />

    var ret = [];
    var root = [];
    var children = [];
    var collected = [];

    if (parent && parent.length) {
        children = this.children(parent);

        if (children && children.length) {
            for (var i = 0; i < children.length; i++) {
                if (children[i].node.get_isSelected()) {
                    ret[ret.length] = children[i];
                }

                if (recursive) {
                    collected = this._collectSelection(children[i].node.get_id(), true);
                    if (collected && collected.length) {
                        for (var j = 0; j < collected.length; j++) {
                            ret[ret.length] = collected[j];
                        }
                    }
                }
            }
        }
    } else {
        root = this.root();
        if (root && root.length) {
            for (var i = 0; i < root.length; i++) {
                if (root[i].node.get_isSelected()) {
                    ret[ret.length] = root[i];
                }

                if (recursive) {
                    collected = this._collectSelection(root[i].node.get_id(), true);
                    if (collected && collected.length) {
                        for (var j = 0; j < collected.length; j++) {
                            ret[ret.length] = collected[j];
                        }
                    }
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype._collectSetSelection = function (parent, selected, recursive) {
    /// <summary>Changes the "selected" mode of the given tree nodes.</summary>
    /// <param name="parent">An ID of the parent node. If omitted, the selection within the entire tree will be retrieved.</param>
    /// <param name="selected">Value indicating whether nodes are selected.</param>
    /// <param name="recusrive">Value indicating whether to recursively collect all child selected nodes of the given parent. Only takes effect if parent node is specified.</param>
    /// <private />

    var root = [];
    var children = [];

    selected = !!selected;

    if (parent && parent.length) {
        children = this.children(parent);

        if (children && children.length) {
            for (var i = 0; i < children.length; i++) {
                children[i].node.set_isSelected(selected);
                if (recursive) {
                    this._collectSetSelection(children[i].node.get_id(), selected, true);
                }
            }
        }
    } else {
        root = this.root();

        if (root && root.length) {
            for (var i = 0; i < root.length; i++) {
                root[i].node.set_isSelected(selected);
                if (recursive) {
                    this._collectSetSelection(root[i].node.get_id(), selected, true);
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree.prototype._sort = function (items) {
    /// <summary>Sorts the given array.</summary>
    /// <param name="items">Items to sort.</param>
    /// <private />

    var sortValue = function (item) {
        var ret = 0;

        if (typeof (item) == 'number') {
            ret = item;
        } else if (typeof (item.node) != 'undefined' && typeof (item.node.get_order) == 'function') {
            ret = item.node.get_order();
        }

        return ret;
    }

    items.sort(function (n1, n2) {
        return sortValue(n1) - sortValue(n2);
    });
}
