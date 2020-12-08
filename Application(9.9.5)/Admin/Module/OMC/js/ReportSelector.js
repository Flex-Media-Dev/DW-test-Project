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

Dynamicweb.Controls.OMC.ReportSelector = function () {
    /// <summary>Represents a report selector.</summary>

    this._container = null;
    this._state = {};
}

Dynamicweb.Controls.OMC.ReportSelector.prototype.get_tree = function () {
    /// <summary>Gets the reference to the report tree.</summary>

    var ret = null;

    if (typeof (t) != 'undefined' && t != null) {
        ret = t;
    }

    return ret;
}

Dynamicweb.Controls.OMC.ReportSelector.prototype.get_container = function () {
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

Dynamicweb.Controls.OMC.ReportSelector.prototype.set_container = function (value) {
    /// <summary>Sets the reference to DOM element that contains all the UI.</summary>
    /// <param name="value">The reference to DOM element that contains all the UI.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.ReportSelector.prototype.add_ready = function (callback) {
    /// <summary>Registers new callback which is executed when the page is loaded.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }
    
    Event.observe(document, 'dom:loaded', function () {
        callback(this, {});
    });
}

Dynamicweb.Controls.OMC.ReportSelector.prototype.onNodeClick = function (sender, e) {
    /// <summary>Handles node click.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="e">Event arguments.</param>

    var node = null;
    var checkbox = null;

    if (e && e.nodeID) {
        checkbox = this.get_container().select('input[data-node-id="' + e.nodeID + '"]')[0];

        if (checkbox) {
            checkbox.checked = !checkbox.checked;
        }

        if (this.get_tree()) {
            node = this.get_tree().getNodeByID(e.nodeID);
        }
    }

    this.onSelectionChanged(this, {
        tree: this.get_tree(),
        node: node,
        checkbox: checkbox
    });
}

Dynamicweb.Controls.OMC.ReportSelector.prototype.onSelectionChanged = function (sender, e) {
    /// <summary>Occurs when selection changes.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="e">Event arguments.</param>

    if (e) {
        // Parameters are being shifted when passed from Tree control (because of the wrong usage of the "call" method).
        // Rearranging parameters...

        if (!e.checkbox && e.node && typeof (e.node.checked) != 'undefined') {
            e.checkbox = e.node;
        }

        if (e.tree && typeof (e.tree.pid) != 'undefined') {
            e.node = e.tree;
            e.tree = this.get_tree();
        }
    }

    if (e && e.node && e.checkbox) {
        if (e.checkbox.checked) {
            this._addToRequest(e.node.itemID);
        } else {
            this._removeFromRequest(e.node.itemID);
        }
    }
}

Dynamicweb.Controls.OMC.ReportSelector.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;

    this.get_container().select('input[type="checkbox"]').each(function (element) {
        $(element).observe('click', function (e) {
            if (self.get_tree()) {
                self.get_tree().afterNodeChecked(parseInt(Event.element(e).readAttribute('data-node-id'), 10));
            }
        });
    });

    this._state = {};
    this._state.request = this.get_container().select('.report-selector-request-item')[0];
}

Dynamicweb.Controls.OMC.ReportSelector.prototype.compareTreeNodes = function (x, y) {
    /// <summary>Compares two tree nodes.</summary>
    /// <param name="x">First node ID.</param>
    /// <param name="y">Second node ID.</param>
    /// <returns>Comparison result.</returns>

    var ret = 0;
    var n1 = null, n2 = null;
    var tree = this.get_tree();
    var icon1 = '', icon2 = '';

    if (x != y) {
        n1 = tree.aNodesIndex.selectById(x);
        n2 = tree.aNodesIndex.selectById(y);

        if (n1 && n2) {
            icon1 = n1.icon.toLowerCase();
            icon2 = n2.icon.toLowerCase();

            if (icon1.indexOf('folder.png') > 0 && icon2.indexOf('folder.png') < 0) {
                ret = -1;
            } else if (icon2.indexOf('folder.png') > 0 && icon1.indexOf('folder.png') < 0) {
                ret = 1;
            } else {
                ret = n1.name.localeCompare(n2.name);
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.ReportSelector.prototype._addToRequest = function (id) {
    /// <summary>Adds specified report to the request.</summary>
    /// <param name="id">Report ID.</param>
    /// <private />

    var found = false;
    var components = [];

    if (id && id.length) {
        if (this._state.request.value && this._state.request.value.length) {
            components = this._state.request.value.split(':');
        }

        if (components && components.length) {
            for (var i = 0; i < components.length; i++) {
                if (components[i].toLowerCase() == id.toLowerCase()) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                this._state.request.value += (':' + id);
            }
        } else {
            this._state.request.value = id;
        }
    }
}

Dynamicweb.Controls.OMC.ReportSelector.prototype._removeFromRequest = function (id) {
    /// <summary>Removes specified report from the request.</summary>
    /// <param name="id">Report ID.</param>
    /// <private />

    var val = '';
    var found = false;
    var components = [];
    var newComponents = [];

    if (id && id.length) {
        components = this._state.request.value.split(':');

        if (components && components.length) {
            for (var i = 0; i < components.length; i++) {
                if (components[i].toLowerCase() != id.toLowerCase()) {
                    newComponents[newComponents.length] = components[i];
                }
            }

            for (var i = 0; i < newComponents.length; i++) {
                val += newComponents[i];

                if (i < (newComponents.length - 1)) {
                    val += ':';
                }
            }

            this._state.request.value = val;
        }
    }
}