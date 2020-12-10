/* Namespace definition */

if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

if (typeof (Dynamicweb.Controls.Tree) == 'undefined') {
    Dynamicweb.Controls.Tree = new Object();
}

/* End: Namespace definition */

Dynamicweb.Controls.Tree.DragDropPermission = {
    /// <summary>Represents drag and drop permission for the tree (tree node).</summary>

    Allow: 1,
    /// <summary>Allow specified drag and drop operation.</summary>

    Deny: 2,
    /// <summary>Disallow specified drag and drop operation.</summary>

    Inherit: 3,
    /// <summary>Permissions must be inherited.</summary>

    parse: function(str) {
        /// <summary>Parses drag and drop permission from the string.</summary>
        /// <param name="str">String to parse.</param>

        var ret = null;
        var intValue = 0;

        if (str && typeof (str) == 'string') {
            ret = Dynamicweb.Controls.Tree.DragDropPermission[str];

            if (ret && typeof (ret) != 'undefined') {
                intValue = parseInt(ret);

                if (isNaN(intValue) || intValue <= 0) {
                    ret = null;
                }
            }
        } else if (typeof (str) == 'number') {
            ret = str;
        }

        if (!ret) {
            ret = Dynamicweb.Controls.Tree.DragDropPermission.Inherit;
        }

        return ret;
    },

    getName: function(value) {
        /// <summary>Converts specified permission to its string representation.</summary>
        /// <param name="value">Value to convert.</param>

        var intValue = 0;
        var ret = 'Inherit';

        intValue = parseInt(value);
        if (!isNaN(value) && value > 0) {
            for (var prop in Dynamicweb.Controls.Tree.DragDropPermission) {
                if (Dynamicweb.Controls.Tree.DragDropPermission[prop] == intValue) {
                    ret = prop;
                    break;
                }
            }
        }

        return ret;
    }
}

Dynamicweb.Controls.Tree.DragDropEventArgs = function(source, event) {
    /// <summary>Provides data for the all drag and drop events.</summary>
    /// <param name="source">Source node.</param>
    /// <param name="event">Event object.</param>

    this._source = source;
    this._event = event;
    this._target = null;
}

Dynamicweb.Controls.Tree.DragDropEventArgs.prototype.get_source = function() {
    /// <summary>Gets the node which is being dragged.</summary>
    
    return this._source;
}

Dynamicweb.Controls.Tree.DragDropEventArgs.prototype.get_event = function() {
    /// <summary>Gets inner event object instance which corresponds to the current event.</summary>
    
    return this._event;
}

Dynamicweb.Controls.Tree.DragDropEventArgs.prototype.get_target = function() {
    /// <summary>Gets the node which represents a drop target.</summary>

    return this._target;
}

Dynamicweb.Controls.Tree.DragDropEventArgs.prototype.set_target = function(value) {
    /// <summary>Sets the node which represents a drop target.</summary>
    /// <param name="value">Drop target.</param>
    
    this._target = value;
}

Dynamicweb.Controls.Tree.DragDropSettings = function(settings) {
    /// <summary>Represents drag and drop settings.</summary>
    /// <param name="settings">Initial settings.</param>

    this._settings = settings;

    if (!this._settings) {
        this._settings = {}
    }
}

Dynamicweb.Controls.Tree.DragDropSettings.prototype.error = function(message) {
    /// <summary>Sends an error to the client.</summary>
    /// <param name="message">Error message.</param>

    var er = null;

    if (typeof (Error) != 'undefined') {
        er = new Error();

        er.message = message;
        er.description = message;

        throw er;
    } else {
        throw message;
    }
}

Dynamicweb.Controls.Tree.DragDropSettings.prototype.get_allowDrag = function() {
    /// <summary>Gets value indicating whether drag operation is allowed.</summary>

    if (typeof (this._settings.allowDrag) == 'string') {
        this._settings.allowDrag = Dynamicweb.Controls.Tree.DragDropPermission.parse(this._settings.allowDrag);
    }

    return this._settings.allowDrag;
}

Dynamicweb.Controls.Tree.DragDropSettings.prototype.set_allowDrag = function(value) {
    /// <summary>Sets value indicating whether drag operation is allowed.</summary>
    /// <param name="value">Value indicating whether drag operation is allowed.</param>
    
    this._settings.allowDrag = Dynamicweb.Controls.Tree.DragDropPermission.parse(value);
}

Dynamicweb.Controls.Tree.DragDropSettings.prototype.get_allowDrop = function() {
    /// <summary>Gets value indicating whether drop operation is allowed.</summary>

    if (typeof (this._settings.allowDrop) == 'string') {
        this._settings.allowDrop = Dynamicweb.Controls.Tree.DragDropPermission.parse(this._settings.allowDrop);
    }
    
    return this._settings.allowDrop;
}

Dynamicweb.Controls.Tree.DragDropSettings.prototype.set_allowDrop = function(value) {
    /// <summary>Sets value indicating whether drop operation is allowed.</summary>
    /// <param name="value">Value indicating whether drop operation is allowed.</param>
    
    this._settings.allowDrop = Dynamicweb.Controls.Tree.DragDropPermission.parse(value);
}

Dynamicweb.Controls.Tree.DragDropSettings.prototype.get_allowAutoExpand = function() {
    /// <summary>Sets value indicating whether to expand the node when the draggable is placed over it.</summary>

    if (typeof (this._settings.allowAutoExpand) == 'string') {
        this._settings.allowAutoExpand = Dynamicweb.Controls.Tree.DragDropPermission.parse(this._settings.allowAutoExpand);
    }

    return this._settings.allowAutoExpand;
}

Dynamicweb.Controls.Tree.DragDropSettings.prototype.set_allowAutoExpand = function(value) {
    /// <summary>Sets value indicating whether to expand the node when the draggable is placed over it.</summary>
    /// <param name="value">Value indicating whether to expand the node when the draggable is placed over it.</param>

    this._settings.allowAutoExpand = Dynamicweb.Controls.Tree.DragDropPermission.parse(value);
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings = function(settings) {
    /// <summary>Represents extended drag and drop settings.</summary>
    /// <param name="settings">Initial settings.</param>

    this._events = new EventsManager();
    this._settings = new Dynamicweb.Controls.Tree.DragDropSettings(settings);
    
    /* Inheritance */
    for (var prop in this._settings) {
        if (prop != '_settings') {
            this[prop] = this._settings[prop];
        }
    }

    /* Occurs when drag operation is initiated. */
    this._events.registerEvent('dragStart');

    /* Occurs when drag source moves over drop target. */
    this._events.registerEvent('dragOver');

    /* Occurs when drop operation is occured. */
    this._events.registerEvent('drop');

    /* Occurs when drag operation is finished. */
    this._events.registerEvent('dragEnd');

    /* Attaching events */
    if (settings) {
        if (settings.dragStart) {
            this.add_dragStart(settings.dragStart);
        }

        if (settings.dragOver) {
            this.add_dragOver(settings.dragOver);
        }

        if (settings.drop) {
            this.add_drop(settings.drop);
        }

        if (settings.dragEnd) {
            this.add_dragEnd(settings.dragEnd);
        }
    }
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings.prototype.add_dragStart = function(handler) {
    /// <summary>Registers new event handler for "dragStart" event.</summary>
    /// <param name="handler">Event handler.</param>
    
    this._events.addHandler('dragStart', handler);
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings.prototype.add_dragOver = function(handler) {
    /// <summary>Registers new event handler for "dragOver" event.</summary>
    /// <param name="handler">Event handler.</param>

    this._events.addHandler('dragOver', handler);
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings.prototype.add_drop = function(handler) {
    /// <summary>Registers new event handler for "drop" event.</summary>
    /// <param name="handler">Event handler.</param>

    this._events.addHandler('drop', handler);
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings.prototype.add_dragEnd = function(handler) {
    /// <summary>Registers new event handler for "dragEnd" event.</summary>
    /// <param name="handler">Event handler.</param>

    this._events.addHandler('dragEnd', handler);
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings.prototype.onDragStart = function(element, event) {
    /// <summary>Handles more generic "dragStart" event.</summary>
    /// <param name="element">Source element.</param>
    /// <param name="event">Event object.</param>

    var args = new Dynamicweb.Controls.Tree.DragDropEventArgs(element, event);

    this.notify('dragStart', args);
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings.prototype.onDragOver = function(source, target) {
    /// <summary>Handles more generic "dragOver" event.</summary>
    /// <param name="source">Source element.</param>
    /// <param name="target">Target element.</param>

    var args = new Dynamicweb.Controls.Tree.DragDropEventArgs(source, null);
    
    args.set_target(target);

    this.notify('dragOver', args);
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings.prototype.onDrop = function(source, target, event) {
    /// <summary>Handles more generic "drop" event.</summary>
    /// <param name="source">Source element.</param>
    /// <param name="target">Target element.</param>

    var args = new Dynamicweb.Controls.Tree.DragDropEventArgs(source, event);

    args.set_target(target);

    this.notify('drop', args);
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings.prototype.onDragEnd = function(element, event) {
    /// <summary>Handles more generic "dragEnd" event.</summary>
    /// <param name="element">Source element.</param>
    /// <param name="event">Event object.</param>

    var args = new Dynamicweb.Controls.Tree.DragDropEventArgs(element, event);

    this.notify('dragEnd', args);
}

Dynamicweb.Controls.Tree.DragDropExtendedSettings.prototype.notify = function(eventName, args) {
    /// <summary>Notifies all subscribers about the specified event.</summary>
    /// <param name="eventName">Name of the event.</param>
    /// <param name="args">Event arguments.</param>

    this._events.notify(eventName, this, args);
}

Dynamicweb.Controls.Tree.DragDropManager = function(treeObject) {
    /// <summary>Represents drag and drop manager.</summary>

    this._treeObject = treeObject;
    this._draggables = [];
    this._currentDroppable = null;
    this._lastSource = null;
    this._lastTarget = null;

    this._expandTimeoutID = null;
    this._tooltipTimeoutID = null;
    this._expandNodeID = null;
    this._dragHandle = null;
    this._tooltip = null;
    this._cancelClickEvent = false;
    this._droppablesPatchApplied = false;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.get_treeObject = function() {
    /// <summary>Gets a reference to underlying tree object.</summary>
    
    return this._treeObject;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.get_lastDragSource = function() {
    /// <summary>Gets the last drag source (not a handle).</summary>

    return this._lastSource;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.get_lastDropTarget = function() {
    /// <summary>Gets the last drop target.</summary>

    return this._lastTarget;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.set_treeObject = function(value) {
    /// <summary>Sets an instance of "dTree" object.</summary>
    /// <param name="value">An instance of "dTree" object.</param>
    
    this._treeObject = value;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.registerAll = function() {
    /// <summary>Enables drag and drop functionality for all nodes.</summary>

    var obj = this.get_treeObject();

    if (obj) {
        this.register(obj.aNodes);
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.register = function(range) {
    /// <summary>Enables drag and drop functionality for specified range of nodes.</summary>
    /// <param name="range">Specifies the range of nodes to be initialized.</param>

    if (!this._droppablesPatchApplied) {
        this._droppablesPatchApplied = true;

        /* Droppables patch - includes scroll offsets */

        Droppables.isAffected = function(point, element, drop) {
            return (
          (drop.element != element) &&
          ((!drop._containers) ||
            this.isContained(element, drop)) &&
          ((!drop.accept) ||
            (Element.classNames(element).detect(
              function(v) { return drop.accept.include(v) }))) &&
          Position.withinIncludingScrolloffsets(drop.element, point[0], point[1]));
        }
    }

    if (range && range.length > 0) {
        this.get_dragHandle();

        for (var i = 0; i < range.length; i++) {
            if (this.allowsDrag(range[i]) && !this._getDraggable(range[i])) {
                this._createDraggable(range[i]);
            }

            if (this.allowsDrop(range[i])) {
                this._createDroppable(range[i]);
            }
        }
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.unregisterAll = function() {
    /// <summary>Disables drag and drop functionality for all nodes.</summary>
    
    var obj = this.get_treeObject();

    if (obj) {
        this.unregister(obj.aNodes);
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.unregister = function(range) {
    /// <summary>Disables drag and drop functionality for specified range of nodes.</summary>
    /// <param name="range">Specifies the range of nodes to be initialized.</param>

    if (range && range.length > 0) {
        for (var i = 0; i < range.length; i++) {
            this._deleteDraggable(range[i]);
            this._deleteDroppable(range[i]);
        }
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.showTooltip = function(node, text, transition) {
    /// <summary>Shows the tooltip over the given node.</summary>
    /// <param name="node">Node over which to show the tooltip.</param>
    /// <param name="text">Tooltip text.</param>
    /// <param name="transition">(Optional) Specifies transition parameters (".showDuration", ".hideDuration"). Defaults are { 0.0, 1.0 }.</param>

    var handle = null;
    var offset = null;
    var tooltip = this.get_tooltip();
    var n = this._getNodeObject(node);
    var showDuration = 0.2, hideDuration = 0.4;
    
    if (n && tooltip) {
        handle = this.nodeHandle(n);

        if (handle) {
            if (this._tooltipTimeoutID) {
                clearTimeout(this._tooltipTimeoutID);
            }

            if (transition) {
                if (transition.showDuration != null) {
                    showDuration = transition.showDuration;
                }

                if (transition.hideDuration != null) {
                    hideDuration = transition.hideDuration;
                }
            }

            offset = $(handle).cumulativeOffset();

            tooltip.innerHTML = text;
            tooltip.hide();
            tooltip.setStyle({ left: (offset.left + 5) + 'px', top: (offset.top + 10) + 'px' });

            if (showDuration > 0.0) {
                tooltip.appear({ duration: showDuration });
            } else {
                tooltip.show();
            }

            this._tooltipTimeoutID = setTimeout(function() {
                if (hideDuration > 0.0) {
                    tooltip.fade({ duration: hideDuration });
                } else {
                    tooltip.hide();
                }
            }, 2000);
        }
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.allowsDrag = function(node) {
    /// <summary>Determines whether node accepts drag operation.</summary>
    /// <param name="node">Node to examine.</param>

    return this._getPermission('get_allowDrag', node);
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.allowsDrop = function(node) {
    /// <summary>Determines whether node accepts drop operation.</summary>
    /// <param name="node">Node to examine.</param>
    
    return this._getPermission('get_allowDrop', node);
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.allowsAutoExpand = function(node) {
    /// <summary>Determines whether node can be automatically expanded when draggable is placed over it.</summary>
    /// <param name="node">Node to examine.</param>
    
    return this._getPermission('get_allowAutoExpand', node);
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.nodeHandle = function(node) {
    /// <summary>Retrieves the node handle which can be used both by droppables and draggables.</summary>
    /// <param name="node>Node to retrieve the handle for (object reference or an ID of the node).</param>

    var ret = null;
    var n = this._getNodeObject(node);

    if (n) {
        ret = document.getElementById('dtn' + n.id + '_name');
    }

    return ret;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.get_dragHandle = function() {
    /// <summary>Gets an element which follows mouse pointer when drag operation takes place.</summary>

    var elm = null;
    var elementID = this.get_treeObject().obj + '_drag';


    if (!this._dragHandle) {
        this._dragHandle = $(elementID);

        if (!this._dragHandle) {
            elm = new Element('span', { id: elementID, 'class': 'treeDragBoxOuter' }).setStyle({ display: 'none' });

            elm.update('<span class="shadowContainer"><span class="shadowLayer1"><span class="shadowLayer2">' +
                '<span class="shadowLayer3"><span class="shadowContent"><span class="treeDragBox">' +
                '<span class="treeDragBoxHandle"></span><span class="treeDragBoxText"></span></span></span></span></span></span></span>');

            document.body.insertBefore(elm, document.body.firstChild);

            if (Prototype.Browser.IE) {
                Event.stopObserving(document.body, 'click', this._onClick);
                Event.observe(document.body, 'click', this._onClick.bindAsEventListener(this));
            }

            this._dragHandle = elm;
        }
    }

    return this._dragHandle;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.set_dragHandle = function(value) {
    /// <summary>Sets an element which follows mouse pointer when drag operation takes place.</summary>
    /// <param name="value">Drag handle.</param>
    
    this._dragHandle = value;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.get_tooltip = function() {
    /// <summary>Gets the DOM element which is used to display tooltips over nodes.</summary>

    var elm = null;
    var elementID = this.get_treeObject().obj + '_dropTooltip';

    if (!this._tooltip) {
        this._tooltip = $(elementID);

        if (!this._tooltip) {
            elm = new Element('span', { id: elementID, 'class': 'treeDropTooltip' }).setStyle({ 'display': 'none' });

            document.body.insertBefore(elm, document.body.firstChild);

            this._tooltip = elm;
        }
    }

    return this._tooltip;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype.set_tooltip = function(value) {
    /// <summary>Sets the DOM element which is used to display tooltips over nodes.</summary>
    /// <param name="value">Tooltip element.</param>
    
    this._tooltip = value;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._getPermission = function(name, node) {
    /// <summary>Internal member. Retrieves the value of the specified permission for the specified node.</summary>
    /// <param name="name">Name of the permission.</param>
    /// <param name="node">Target node.</param>
    /// <private />
    
    var ret = false;
    var parent = null;
    var propValue = -1;
    var tree = this.get_treeObject();
    var settings = null, treeSettings = null;

    if (name && node) {
        settings = node.get_dragDropSettings();
        treeSettings = tree.get_dragDropSettings();

        if (settings && typeof (settings[name]) != 'undefined') {
            propValue = settings[name]();

            if (propValue != Dynamicweb.Controls.Tree.DragDropPermission.Deny) {
                if (propValue == Dynamicweb.Controls.Tree.DragDropPermission.Allow) {
                    ret = true;
                } else if (propValue == Dynamicweb.Controls.Tree.DragDropPermission.Inherit) {
                    if (node.pid >= 0 && tree) {
                        for (var i = 0; i < tree.aNodes.length; i++) {
                            if (tree.aNodes[i].id == node.pid) {
                                parent = tree.aNodes[i];
                                break;
                            }
                        }

                        if (parent) {
                            ret = this._getPermission(name, parent);
                        }
                    } else {
                        if (treeSettings && typeof (treeSettings[name]) != 'undefined') {
                            ret = treeSettings[name]() ==
                                    Dynamicweb.Controls.Tree.DragDropPermission.Allow;
                        }
                    }
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._getDraggable = function(node) {
    /// <summary>Internal member. Retrieves Draggable object associated with specified node.</summary>
    /// <param name="node">Target node.</param>
    /// <private />

    var ret = null;

    if (!this._draggables) {
        this._draggables = [];
    }

    if (node) {
        for (var i = 0; i < this._draggables.length; i++) {
            if (this._draggables[i].nodeID == node.id) {
                ret = this._draggables[i].draggable;
                break;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._createDraggable = function(node) {
    /// <summary>Internal member. Associates new Draggable for the specified node.</summary>
    /// <param name="node">Target node.</param>
    /// <private />

    var self = this;
    var draggable = null;
    var elementID = null;
    var obj = this.get_treeObject();

    if (node) {
        elementID = this.get_dragHandle().id;

        if (document.getElementById(elementID)) {
            draggable = new Draggable(elementID, {
                revert: true,
                handle: this.nodeHandle(node),
                delay: 200,

                starteffect: function() { },
                endeffect: function() { },

                onStart: function(draggable, event) {
                    var elm = draggable.element;
                    var textContainer = elm.select('.treeDragBoxText');

                    if (textContainer && textContainer.length > 0) {
                        textContainer = textContainer[0];

                        if (typeof (draggable.handle.innerText) != 'undefined') {
                            textContainer.innerHTML = draggable.handle.innerText;
                        } else if (typeof (draggable.handle.textContent) != 'undefined') {
                            textContainer.innerHTML = draggable.handle.textContent;
                        }
                    }

                    elm.style.display = 'block';
                    self._lastSource = draggable.handle;

                    document.body.style.cursor = 'url(\'/Admin/Images/Ribbon/UI/Tree/img/grab.cur\'), move';

                    obj.get_dragDropSettings().onDragStart(draggable.handle, event);
                },

                onDrag: function(draggable, event) {
                    var elm = draggable.element;

                    /* 
                        +++ overriding draggable's offset and position +++ 
                        This is required in order to make the draggable element follow the mouse pointer.
                    */
                    draggable.offset = [1, 8];
                    elm.style.left = 0;
                    elm.style.top = 0;
                },

                onEnd: function(draggable, event) {
                    var elm = draggable.element;

                    elm.style.display = 'none';
                    document.body.style.cursor = 'auto';

                    self._currentDroppable = null;

                    /* There is a "click" event which if fired after the "mouseup" event (in IE only) - we need to cancel that */
                    self._cancelClickEvent = true;
                    obj.get_dragDropSettings().onDragEnd(self.get_lastDragSource(), event);
                }
            });

            if (!this._draggables) {
                this._draggables = [];
            }

            this._draggables[this._draggables.length] = { nodeID: node.id, draggable: draggable }
        }
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._deleteDraggable = function(node) {
    /// <summary>Internal member. Deletes existing Draggable for the specified node.</summary>
    /// <param name="node">Target node.</param>
    /// <private />

    var newList = [];

    if (!this._draggables) {
        this._draggables = [];
    }

    if (node) {
        for (var i = 0; i < this._draggables.length; i++) {
            if (this._draggables[i].nodeID == node.id) {
                Draggables.unregister(this._draggables[i].draggable);

                this._draggables[i] = null;
            } else {
                newList[newList.length] = this._draggables[i];
            }
        }

        this._draggables = newList;
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._createDroppable = function(node) {
    /// <summary>Internal member. Associates new Droppable for the specified node.</summary>
    /// <param name="node">Target node.</param>
    /// <private />

    var self = this;
    var obj = this.get_treeObject();
    var element = this.nodeHandle(node);

    if (node) {
        if (element) {
            Droppables.add(element.id, {
                hoverclass: 'treeDropTarget',

                onHover: function(draggable, droppable) {
                    self._currentDroppable = droppable;
                    self._tryExpandCurrentNode();

                    obj.get_dragDropSettings().onDragOver(self.get_lastDragSource(), droppable);
                },

                onDrop: function(draggable, droppable, event) {
                    self._lastTarget = droppable;
                    obj.get_dragDropSettings().onDrop(self.get_lastDragSource(), droppable, event);
                }
            });
        }
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._deleteDroppable = function(node) {
    /// <summary>Internal member. Deletes existing Droppable for the specified node.</summary>
    /// <param name="node">Target node.</param>
    /// <private />

    var obj = this.get_treeObject();
    
    if (node) {
        Droppables.remove(this.nodeHandle(node));
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._tryExpandCurrentNode = function() {
    /// <summary>Internal member. If possible, registers a function which (by timeout) expands current droppable (node).</summary>
    /// <private />
    
    var tree = null;
    var nodeID = 0;
    var self = this;
    var canRegisterExpand = false;
    var clearCurrentExpand = true;

    /* Do we still have a current droppable ? */
    if (this._currentDroppable) {
        tree = this.get_treeObject();
        nodeID = parseInt($(this._currentDroppable).readAttribute('nodeID'));
        
        /* Does the node allow to be auto-expanded ? */
        if (this.allowsAutoExpand(tree.getNodeByID(nodeID))) {
            clearCurrentExpand = false;

            /* Function call has been already registered ... */
            if (this._expandTimeoutID) {
                /* ... but for the different node - clearing the timeout */
                if (this._expandNodeID != nodeID) {
                    clearTimeout(this._expandTimeoutID);
                    this._expandTimeoutID = 0;

                    canRegisterExpand = true;
                }
            } else {
                canRegisterExpand = true;
            }

            /* Registering function call */
            if (canRegisterExpand) {
                this._expandNodeID = nodeID;
                this._expandTimeoutID = setTimeout(function() {
                    self._expandCurrentNode();
                }, 500);
            }
        }
    }

    if (clearCurrentExpand && this._expandTimeoutID) {
        clearTimeout(this._expandTimeoutID);
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._expandCurrentNode = function() {
    /// <summary>Internal member. Expands current droppable (node).</summary>
    /// <private />
    
    var n = null;
    var childrenLoaded = false;
    var nodeID = this._expandNodeID;
    var tree = this.get_treeObject();

    if (this._currentDroppable) {
        if ($(this._currentDroppable).hasClassName('treeDropTarget')) {
            if (nodeID) {
                n = tree.getNodeByID(nodeID);

                if (n) {
                    if (!n._io && n._hc) {
                        for (var i = 0; i < tree.aNodes.length; i++) {
                            if (tree.aNodes[i].pid == nodeID) {
                                childrenLoaded = true;
                                break;
                            }
                        }

                        if (childrenLoaded) {
                            tree.o(nodeID);
                        } else {
                            tree.ajax_loadNodes(nodeID);
                        }
                    }
                }
            }
        }
    }
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._getNodeObject = function(node) {
    /// <summary>Internal member. Retrieves node object.</summary>
    /// <param name="node">an ID of the node OR the reference to the node.</param>
    /// <private />
    
    var ret = node;

    if (node) {
        if (typeof (node) == 'number' || typeof (node) == 'string') {
            ret = this.get_treeObject().getNodeByID(parseInt(node));
        }
    }

    return ret;
}

Dynamicweb.Controls.Tree.DragDropManager.prototype._onClick = function(event) {
    /// <summary>Internal member. Handles "click" event of a document's body.</summary>
    /// <param name="event">Event data.</param>
    /// <private />
    
    var ret = true;
    var element = Event.element(event);

    /* Do we need to cancel this event ? */
    if (this._cancelClickEvent) {
        /* If the source element is not our drag handle then we won't cancel any more "click" events */
        if (!(element.id == this.get_dragHandle().id ||
            element.up('.treeDragBoxOuter'))) {

            this._cancelClickEvent = false;
        }

        /* Canceling event */
        Event.stop(event);
        event.cancelBubble = true;
        ret = false;
    }

    return ret;
}
