/* Namespace definition */

if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

/* End: Namespace definition */

/* Constructor */

Dynamicweb.Controls.StretchedContainer = function(containerID) {
    /// <summary>Represents a container which is automatically stretched.</summary>
    /// <param name="containerID">An ID of the container.</param>

    this._container = null;
    this._containerID = containerID;
    this._properties = null;
    this._events = new EventsManager();
    this._anchorObject = null;
    this._cache = {}
    this._stretchModeChanged = true;

    if (!this._containerID) {
        this.error('Argument has not been specified: containerID.');
    }

    // Occurs before the container is stretched.
    this._events.registerEvent('beforeStretch');

    // Occurs after the container is stretched.
    this._events.registerEvent('afterStretch');

    // Occurs after the height of the container has been calculated.
    this._events.registerEvent('afterSetHeight');

    // Occurs after the anchor element has been selected.
    this._events.registerEvent('afterSelectAnchor');
}

/* End: Constructor */

/* Enumerations */

Dynamicweb.Controls.StretchedContainer.StretchMode = {
    /// <summary>Represents stretch mode.</summary>
    
    VerticalOnly: 1,
    /// <summary>Stretch vertically.</summary>

    HorizontalOnly: 2,
    /// <summary>Stretch horizontally.</summary>

    Fill: 3
    /// <summary>Stretch both vertically and horizontally.</summary>
}

Dynamicweb.Controls.StretchedContainer.ScrollMode = {
    /// <summary>Represents scroll mode.</summary>
    
    VerticalOnly: 1,
    /// <summary>Only vertical scroll bars are allowed.</summary>

    HorizontalOnly: 2,
    /// <summary>Only horizontal scroll bars are allowed.</summary>

    Auto: 3,
    /// <summary>Both vertical and horizontal scroll bars are allowed.</summary>

    Hidden: 4
    /// <summary>Do not show the scroll bars.</summary>
}

/* End: Enumerations */

/* End: Event arguments objects */

Dynamicweb.Controls.StretchedContainer.BeforeStretchEventArgs = function() {
    /// <summary>Provides data for the "beforeStretch" event.</summary>
    
    this._cancel = false;
}

Dynamicweb.Controls.StretchedContainer.BeforeStretchEventArgs.prototype.get_cancel = function() {
    /// <summary>Gets value indicating whether to cancel container stretching.</summary>
    
    return this._cancel;
}

Dynamicweb.Controls.StretchedContainer.BeforeStretchEventArgs.prototype.set_cancel = function(value) {
    /// <summary>Sets value indicating whether to cancel container stretching.</summary>
    /// <param name="value">Value indicating whether to cancel container stretching.</param>
    
    this._cancel = value;
}

Dynamicweb.Controls.StretchedContainer.AfterSetHeightEventArgs = function() {
    /// <summary>Provides data for the "afterSetHeight" event.</summary>
    
    this._height = 0;
}

Dynamicweb.Controls.StretchedContainer.AfterSetHeightEventArgs.prototype.get_height = function() {
    /// <summary>Gets the height of the container.</summary>
    
    return this._height;
}

Dynamicweb.Controls.StretchedContainer.AfterSetHeightEventArgs.prototype.set_height = function(value) {
    /// <summary>Sets the height of the container.</summary>
    /// <param name="value">The height of the container.</param>
    
    this._height = value;
}

Dynamicweb.Controls.StretchedContainer.AfterSelectAnchorEventArgs = function() {
    /// <summary>Provides data for the "afterSelectAnchor" event.</summary>
    
    this._anchor = null;
}

Dynamicweb.Controls.StretchedContainer.AfterSelectAnchorEventArgs.prototype.get_anchor = function() {
    /// <summary>Gets the element which defines how to stretch the container.</summary>
        
    return this._anchor;
}

Dynamicweb.Controls.StretchedContainer.AfterSelectAnchorEventArgs.prototype.set_anchor = function(value) {
    /// <summary>Sets the element which defines how to stretch the container.</summary>
    /// <param name="value">The element which defines how to stretch the container.</param>
    
    this._anchor = value;
}

/* End: Event arguments objects */

/* Static fields */

Dynamicweb.Controls.StretchedContainer.__forms = [];

/* End: Static fields */

/* Static methods */

Dynamicweb.Controls.StretchedContainer.get_documentSizeChanged = function() {
    /// <summary>Gets value indicating whether size of the document has been changed during the resize operation.</summary>
    
    var ret = false;
    var previousSize = null;

    if (document && document.body) {
        previousSize = Dynamicweb.Controls.StretchedContainer.Cache.get_previousDocumentSize();

        if (previousSize) {
            ret = document.body.clientWidth != previousSize.width ||
                document.body.clientHeight != previousSize.height;
        }
    }

    return ret;
}

/*Dynamicweb.Controls.StretchedContainer.update*/

Dynamicweb.Controls.StretchedContainer.getInstances = function () {
    /// <summary>Gets references to all containers defined on the page.</summary>

    var ret = [];
    var containers = Dynamicweb.Controls.StretchedContainer.Cache.get_containerElements();

    if (containers && containers.length > 0) {
        for (var i = 0; i < containers.length; i++) {
            var container = Dynamicweb.Controls.StretchedContainer.getInstance(containers[i].id);
            if (container) {
                ret[ret.length] = container;
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.StretchedContainer.finalizeAll = function() {
    /// <summary>Executes "finalize" method for all containers defined on the page.</summary>
    
    var containers = Dynamicweb.Controls.StretchedContainer.getInstances();

    if (containers && containers.length > 0) {
        for (var i = 0; i < containers.length; i++) {
            containers[i].finalize();
        }
    }
}

Dynamicweb.Controls.StretchedContainer.stretchAll = function() {
    /// <summary>Executes "stretch" method for all containers defined on the page.</summary>
    
    var containers = Dynamicweb.Controls.StretchedContainer.getInstances();

    if (containers && containers.length > 0) {
        for (var i = 0; i < containers.length; i++) {
            containers[i].stretch();
        }
    }
}

Dynamicweb.Controls.StretchedContainer.getInstance = function(controlID) {
    /// <summary>Gets a reference to a specific container.</summary>
    /// <param name="controlID">An ID (or ClientID) of the container.</param>
    
    var ret = null;
    var element = null;
    var objName = null;
    var body = $(document.body);

    if (controlID) {
        element = $(controlID);

        if (!element) {
            element = body.select('*[id$="' + controlID + '"]');
            if (element && element.length > 0) {
                element = element[0];
            }
        }
        
        if(element) {
            objName = 'sContainer_' + element.id;
            
            ret = window[objName];
            
            if(!ret) {
                ret = new Dynamicweb.Controls.StretchedContainer(element.id);
                window[objName] = ret;

                if (ret) {
                    ret.initialize();
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.StretchedContainer.attachEvent = function(obj, eventName, handler) {
    /// <summary>Attaches specified event hander to a specified event on a specified object.</summary>
    /// <param name="obj">Target object.</param>
    /// <param name="eventName">Name of the event (without the "on" prefix).</param>
    /// <param name="handler">Event handler.</param>

    if (obj.attachEvent) {
        obj.attachEvent('on' + eventName, handler);
    } else if (obj.addEventListener) {
        obj.addEventListener(eventName, handler, false);
    }
}

/* End: Static methods */

/* Properties */

Dynamicweb.Controls.StretchedContainer.prototype.get_containerElement = function() {
    /// <summary>Gets a reference to a DOM element which represents a container.</summary>

    if (!this._container) {
        this._container = $(this._containerID);
        if (!this._container) {
            this.error('Container with specified ID ("' + this._containerID + '") can not be found.');
        }
    }

    return this._container;
}

Dynamicweb.Controls.StretchedContainer.prototype.get_stretchMode = function() {
    /// <summary>Gets a stretch mode.</summary>
    
    var ret = null;

    if (this._properties.stretchMode == null) {
        ret = Dynamicweb.Controls.StretchedContainer.StretchMode.Fill;
    } else {
        ret = Dynamicweb.Controls.StretchedContainer.StretchMode[this._properties.stretchMode];
    }

    return ret;
}

Dynamicweb.Controls.StretchedContainer.prototype.set_stretchMode = function(value) {
    /// <summary>Sets a stretch mode.</summary>
    /// <param name="value">Stretch mode.</param>
    
    for (var prop in Dynamicweb.Controls.StretchedContainer.StretchMode) {
        if (Dynamicweb.Controls.StretchedContainer.StretchMode[prop] == value) {
            this._properties.stretchMode = prop;
            this._stretchModeChanged = true;
            break;
        }
    }

    this.stretch();
}

Dynamicweb.Controls.StretchedContainer.prototype.get_scrollMode = function() {
    /// <summary>Gets a scroll mode.</summary>

    var ret = null;

    if (this._properties.scrollMode == null) {
        ret = Dynamicweb.Controls.StretchedContainer.ScrollMode.Auto;
    } else {
        ret = Dynamicweb.Controls.StretchedContainer.ScrollMode[this._properties.scrollMode];
    }

    return ret;
}

Dynamicweb.Controls.StretchedContainer.prototype.set_scrollMode = function(value) {
    /// <summary>Sets a scroll mode.</summary>
    /// <param name="value">Scroll mode.</param>

    var propValue = -1;
    var overflowStyle = 'auto';
    var container = this.get_containerElement();

    for (var prop in Dynamicweb.Controls.StretchedContainer.ScrollMode) {
        if (Dynamicweb.Controls.StretchedContainer.ScrollMode[prop] == value) {
            this._properties.scrollMode = prop;
            propValue = Dynamicweb.Controls.StretchedContainer.ScrollMode[prop];

            container.style.overflow = container.style.overflowX = container.style.overflowY = 'visible';

            if (propValue == Dynamicweb.Controls.StretchedContainer.ScrollMode.Hidden) {
                container.style.overflow = 'hidden';
            } else {
                container.style.overflow = 'auto';

                if (propValue == Dynamicweb.Controls.StretchedContainer.ScrollMode.HorizontalOnly) {
                    container.style.overflowY = 'hidden';
                    container.style.overflowX = 'auto';
                } else if (propValue == Dynamicweb.Controls.StretchedContainer.ScrollMode.VerticalOnly) {
                    container.style.overflowX = 'hidden';
                    container.style.overflowY = 'auto';
                }
            }

            break;
        }
    }

    this.stretch();
}

Dynamicweb.Controls.StretchedContainer.prototype.get_anchor = function () {
    /// <summary>Gets a reference to a DOM element which defines the bounds of the container.</summary>

    var obj = null;
    var args = null;

    if (this._properties.anchor == null) {
        this._properties.anchor = '';
    }

    if (!this._anchorObject) {
        try {
            if (this._properties.anchor == 'parent') {
                obj = this.get_containerElement().up();
            } else {
                obj = eval(this._properties.anchor);
            }
        } catch (ex) {
            obj = $(document.body).select(this._properties.anchor);
            if (obj && obj.length > 0) {
                obj = obj[0];
            } else {
                obj = document.getElementById(this._properties.anchor);
            }
        }

        args = new Dynamicweb.Controls.StretchedContainer.AfterSelectAnchorEventArgs();

        args.set_anchor(obj);
        this.notify('afterSelectAnchor', args);
        obj = args.get_anchor();

        this._anchorObject = obj;
    }

    return this._anchorObject;
}

Dynamicweb.Controls.StretchedContainer.prototype.set_anchor = function(value) {
    /// <summary>Sets a reference to a DOM element which defines the bounds of the container.</summary>
    /// <param name="value">A reference to a DOM element which defines the bounds of the container.</param>

    if (typeof (value) != 'string') {
        value = '';
    }

    this._properties.anchor = value;
    this._anchorObject = null;

    this.stretch();
}

/* End: Properties */

/* Instance methods */

Dynamicweb.Controls.StretchedContainer.prototype.add_beforeStretch = function(handler) {
    /// <summary>Registers new event handler for "beforeStretch" event.</summary>
    /// <param name="handler">Event handler.</param>
    
    this._events.addHandler('beforeStretch', handler);
}

Dynamicweb.Controls.StretchedContainer.prototype.add_afterStretch = function(handler) {
    /// <summary>Registers new event handler for "afterStretch" event.</summary>
    /// <param name="handler">Event handler.</param>

    this._events.addHandler('afterStretch', handler);
}

Dynamicweb.Controls.StretchedContainer.prototype.add_afterSetHeight = function(handler) {
    /// <summary>Registers new event handler for "afterSetHeight" event.</summary>
    /// <param name="handler">Event handler.</param>

    this._events.addHandler('afterSetHeight', handler);
}

Dynamicweb.Controls.StretchedContainer.prototype.add_afterSelectAnchor = function(handler) {
    /// <summary>Registers new event handler for "afterSelectAnchor" event.</summary>
    /// <param name="handler">Event handler.</param>

    this._events.addHandler('afterSelectAnchor', handler);
}

Dynamicweb.Controls.StretchedContainer.prototype.notify = function(eventName, args) {
    /// <summary>Notifies all subscribers about the specified event.</summary>
    /// <param name="eventName">Name of the event.</param>
    /// <param name="args">Event arguments.</param>

    this._events.notify(eventName, this, args);
}

Dynamicweb.Controls.StretchedContainer.prototype.stretch = function() {
    /// <summary>Stretches the container.</summary>

    var mode = this.get_stretchMode();
    var elm = this.get_containerElement();
    var args = new Dynamicweb.Controls.StretchedContainer.BeforeStretchEventArgs();

    this.notify('beforeStretch', args);

    if (!args.cancel) {
        if (this._stretchModeChanged) {
            elm.className = 'stretchedContainer';

            if (mode == Dynamicweb.Controls.StretchedContainer.StretchMode.HorizontalOnly) {
                elm.className += ' stretchedContainer_h';
            } else if (mode == Dynamicweb.Controls.StretchedContainer.StretchMode.VerticalOnly) {
                elm.className += ' stretchedContainer_v';
            } else if (mode == Dynamicweb.Controls.StretchedContainer.StretchMode.Fill) {
                elm.className += ' stretchedContainer_f';
            }

            this._stretchModeChanged = false;
        }
        this.setHeight();
    }
}

Dynamicweb.Controls.StretchedContainer.prototype.setHeight = function () {
    /// <summary>Sets the height of the container.</summary>

    var a = null;
    var height = 0;
    var args = null;
    var self = this;
    var parent = null;
    var selfOffset = null;
    var viewportHeight = 0;
    var elementOffset = null;
    var elementSetting = null;
    var elm = this.get_containerElement();
    var get_offsets = function (elt) {
        var element = $(elt);
        var sentinel = true;
        var SelfOffset = null;
        var offsetHeight = null;

        while (sentinel) {
            if (element.parentNode) {
                element = element.parentNode;
                if (element.style) {
                    if (element.style.display == "none") {
                        element.style.display = "inline";
                        SelfOffset = self.offset(elt);
                        offsetHeight = elt.offsetHeight;
                        element.style.display = "none";
                        sentinel = false;
                    }
                }
            } else {
                SelfOffset = self.offset(elt);
                offsetHeight = elt.offsetHeight;
                sentinel = false;
            }
        }

        return {
            self_offset: SelfOffset,
            offset_height: offsetHeight
        };
    };

    if (this.get_stretchMode() == Dynamicweb.Controls.StretchedContainer.StretchMode.HorizontalOnly) {
        elm.style.height = 'auto';
    } else {
        selfOffset = get_offsets(elm).self_offset;
        elementSetting = this._properties.anchor.toLowerCase();

        if (this._containerID == 'Files_stretcher') {
            a = this.get_anchor();
            var offsets = get_offsets(a);
            elementOffset = offsets.self_offset;
            elementOffset = this.offset(a);
            height = elementOffset.top + offsets.offset_height - selfOffset.top - $$(".BottomInformation").first().getHeight();
        } else if (elementSetting == 'document' || elementSetting == 'body' || elementSetting == 'window') {
            viewportHeight = document.viewport.getHeight();

            if (viewportHeight <= 0) {
                /* Viewport dimensions might be unavailable on page load (IE) - trying document body directly */
                viewportHeight = $(document.body).getHeight();
            }

            height = viewportHeight - selfOffset.top;
        } else if (elementSetting == 'parent') {
            parent = elm.up();

            if (!parent) {
                parent = document.viewport;
            }

            height = parent.offsetHeight - selfOffset.top;
        } else {
            a = this.get_anchor();
            var offsets = get_offsets(a);
            elementOffset = offsets.self_offset;
            height = elementOffset.top + offsets.offset_height - selfOffset.top;
        }

        args = new Dynamicweb.Controls.StretchedContainer.AfterSetHeightEventArgs();
        args.set_height(height);
        args.elem = elm;

        this.notify('afterSetHeight', args);

        if (args.get_height() >= 0) {
            elm.style.height = (args.get_height() - 18) + 'px';
        }
    }

    this.notify('afterStretch', {});
}

Dynamicweb.Controls.StretchedContainer.prototype.error = function(message) {
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

Dynamicweb.Controls.StretchedContainer.prototype.loadProperties = function() {
    /// <summary>Loads control properties from the hidden field.</summary>

    var field = this.get_containerElement().select('input.stretchedContainer_properties');

    if (field && field.length > 0) {
        field = field[0];

        try {
            var val = field.value.replace(/&quot;/gi, '"')
            this._properties = val.evalJSON();
        } catch (ex) { }
    }

    if (!this._properties) {
        this._properties = {}
    }
}

Dynamicweb.Controls.StretchedContainer.prototype.saveProperties = function() {
    /// <summary>Saves control properties into the hidden field.</summary>
    
    var field = this.get_containerElement().select('input.stretchedContainer_properties');

    if (field && field.length > 0) {
        field = field[0];
        field.value = Object.toJSON(this._properties).replace(/\"/gi, '&quot;');
    }
}

Dynamicweb.Controls.StretchedContainer.prototype.offset = function(element) {
    /// <summary>Gets the offset (relative to the document) of the specified element.</summary>
    /// <param name="element">Element to retrieve an offset for.</param>
    
    return element.cumulativeOffset();
}

Dynamicweb.Controls.StretchedContainer.prototype.initialize = function() {
    /// <summary>Initializes control.</summary>

    var form = null;
    var formInitialized = false;

    this.loadProperties();

    form = this.get_containerElement().up('form');
    if (form) {
        form = $(form);

        if (!form.id) {
            form.id = 'form_' + (new Date).getTime();
        }

        for (var i = 0; i < Dynamicweb.Controls.StretchedContainer.__forms.length; i++) {
            if (Dynamicweb.Controls.StretchedContainer.__forms[i].id == form.id) {
                formInitialized = Dynamicweb.Controls.StretchedContainer.__forms[i].isInitialized;
                break;
            }
        }

        if (!formInitialized) {
            form.observe('submit', function(event) {
                Dynamicweb.Controls.StretchedContainer.finalizeAll();
            });

            Dynamicweb.Controls.StretchedContainer.__forms[Dynamicweb.Controls.StretchedContainer.__forms.length] = {
                id: form.id,
                isInitialized: true
            }
        }
    }
}

Dynamicweb.Controls.StretchedContainer.prototype.finalize = function() {
    /// <summary>Finalizes control's live cycle.</summary>
    
    this.saveProperties();
}

/* End: Instance methods */

/* Cache */

Dynamicweb.Controls.StretchedContainer.__cache = null;

Dynamicweb.Controls.StretchedContainer.Cache = function() {
    /// <summary>Represents a temporary storage which is used for the fast access to the DOM.</summary>
}

Dynamicweb.Controls.StretchedContainer.Cache.initialize = function() {
    /// <summary>Initializes the cache.</summary>

    Dynamicweb.Controls.StretchedContainer.Cache.reset();

    if (!Dynamicweb.Controls.StretchedContainer.__cache.containerElements) {
        Dynamicweb.Controls.StretchedContainer.__cache.containerElements = $(document.body).select('.stretchedContainer');
    }
    
    Dynamicweb.Controls.StretchedContainer.Cache.get_previousDocumentSize();
}

Dynamicweb.Controls.StretchedContainer.Cache.reset = function() {
    /// <summary>Clears the cache.</summary>
    
    Dynamicweb.Controls.StretchedContainer.__cache = {}
}

Dynamicweb.Controls.StretchedContainer.Cache.get_containerElements = function() {
    /// <summary>Gets references to a DOM elements that corresponds to all containers.</summary>
    
    if (!Dynamicweb.Controls.StretchedContainer.__cache.containerElements) {
        Dynamicweb.Controls.StretchedContainer.Cache.initialize();
    }

    return Dynamicweb.Controls.StretchedContainer.__cache.containerElements;
}

Dynamicweb.Controls.StretchedContainer.Cache.get_previousDocumentSize = function() {
    /// <summary>Gets document size (previous state before resize).</summary>

    var width, height;

    if (!Dynamicweb.Controls.StretchedContainer.__cache.previousDocumentSize) {
        width = document.body.clientWidth;
        height = document.body.clientHeight;

        Dynamicweb.Controls.StretchedContainer.__cache.previousDocumentSize = {
            width: width,
            height: height
        }
    }

    return Dynamicweb.Controls.StretchedContainer.__cache.previousDocumentSize;
}

Dynamicweb.Controls.StretchedContainer.Cache.set_previousDocumentSize = function(value) {
    /// <summary>Sets document size (previous state before resize).</summary>

    Dynamicweb.Controls.StretchedContainer.__cache.previousDocumentSize = value;
}

Dynamicweb.Controls.StretchedContainer.Cache.updatePreviousDocumentSize = function() {
    if (Dynamicweb.Controls.StretchedContainer.__cache.updateSizeTimeoutID) {
        clearTimeout(Dynamicweb.Controls.StretchedContainer.__cache.updateSizeTimeoutID);
    }

    Dynamicweb.Controls.StretchedContainer.__cache.updateSizeTimeoutID = setTimeout(function() {
        Dynamicweb.Controls.StretchedContainer.Cache.set_previousDocumentSize(null);
        Dynamicweb.Controls.StretchedContainer.Cache.get_previousDocumentSize();
    }, 200);
}

/* End: Cache */

Event.observe(document, 'dom:loaded', function () {
    Dynamicweb.Controls.StretchedContainer.Cache.initialize();
    
    Dynamicweb.Controls.StretchedContainer.attachEvent(window, 'resize', function() {
        if (Dynamicweb.Controls.StretchedContainer.get_documentSizeChanged()) {
            Dynamicweb.Controls.StretchedContainer.stretchAll();
            Dynamicweb.Controls.StretchedContainer.Cache.updatePreviousDocumentSize();

        }
    });

    Dynamicweb.Controls.StretchedContainer.stretchAll();
});
