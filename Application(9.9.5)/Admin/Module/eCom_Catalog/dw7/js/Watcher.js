/// <reference path="/Admin/Filemanager/Upload/js/EventsManager.js" />

/* Creating a namespace (if needed) */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

/* Stores the global instance of the Watcher */
var _watcherInstance = null;

Dynamicweb.Watcher = function() {
    /// <summary>Initializes new instance of a class.</summary>

    this._events = new EventsManager();

    /* Indicates whether XHR "send" hook has been created */
    this._xhrHookCreated = false;

    /* Indicates whether FCKeditor "complete" callback hook has been created */
    this._fckHookCreated = false;

    /* Provides consistent execution of the "track" method when also tracking structure changes  */
    this._isProcessing = false;

    /* Interval ID of the tracking function */
    this._trackIntervalID = -1;

    /* Stores value indicating whether to track structure changes */
    this._trackStructureChanges = true;

    /* Occurs when new XHR request is initiated (has been sent) */
    this._events.registerEvent('xhrInitiated');

    /* Occurs when an IFRAME has finished loading */
    this._events.registerEvent('frameLoaded');

    /* Occurs when any form field has been modified */
    this._events.registerEvent('fieldModified');

    /* Occurs when any activity has been registered */
    this._events.registerEvent('activityRegistered');
}

Dynamicweb.Watcher.getInstance = function() {
    /// <summary>Retrieves the instance of the Watcher.</summary>

    if (_watcherInstance == null) {
        _watcherInstance = new Dynamicweb.Watcher();
    }

    return _watcherInstance;
}

Dynamicweb.Watcher.raiseEvent = function(name, args) {
    /// <summary>Raises specified event.</summary>
    /// <param name="name">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var w = null;
    var handlerName = '';

    if (name && name.length > 1) {
        handlerName = '_on' + name.substr(0, 1).toUpperCase() + name.substr(1);
        
        if (!args) {
            args = {};
        }

        try {
            w = Dynamicweb.Watcher.getInstance();

            if (w && typeof (w[handlerName]) == 'function') {
                w[handlerName](args);
                w._onActivityRegistered(name, args);
            }
        } catch (ex) { }
    }
}

Dynamicweb.Watcher.prototype.get_trackStructureChanges = function() {
    /// <summary>Gets value indicating whether to automatically track structure changes.</summary>

    return this._trackStructureChanges;
}

Dynamicweb.Watcher.prototype.set_trackStructureChanges = function(value) {
    /// <summary>Sets value indicating whether to automatically track structure changes.</summary>
    /// <param name="value">Value indicating whether to automatically track structure changes.</param>

    var oldValue = this._trackStructureChanges;

    this._trackStructureChanges = value;

    if (oldValue != value) {
        if (value) {
            this._startTrackingChanges();
        } else if (this._trackIntervalID) {
            clearInterval(this._trackIntervalID);
        }
    }
}

Dynamicweb.Watcher.prototype.start = function() {
    /// <summary>Initiates watching process.</summary>
    
    this.track();

    if (this.get_trackStructureChanges()) {
        this._startTrackingChanges();
    }
}

Dynamicweb.Watcher.prototype.track = function(elements) {
    /// <summary>Starts tracking changes for a given elements.</summary>
    /// <param name="elements">Elements to track changes for.</param>

    var tag = '';
    var fields = [], frames = [];
    var inputs = null, selects = null, textareas = null;

    /* Creating XHR "send" hook */
    if (!this._xhrHookCreated) {
        XMLHttpRequest.prototype._send = XMLHttpRequest.prototype.send;
        XMLHttpRequest.prototype.send = function(data) {
            Dynamicweb.Watcher.raiseEvent('xhrInitiated', { request: this });
            XMLHttpRequest.prototype._send.apply(this, [data]);
        }

        this._xhrHookCreated = true;
    }

    /* Creating "FCKeditor - complete" callback hook */
    if (!this._fckHookCreated) {
        if (typeof (FCKeditor_OnComplete) != 'undefined') {
            _FCKeditor_OnComplete = FCKeditor_OnComplete;
        }

        FCKeditor_OnComplete = function(editor) {
            var w = Dynamicweb.Watcher.getInstance();

            if (w) {
                w.trackFCKeditor(editor);
            }

            if (typeof (_FCKeditor_OnComplete) != 'undefined') {
                _FCKeditor_OnComplete(editor);
            }
        }

        this._fckHookCreated = true;
    }

    if (!elements) {
        elements = document.body;
    }

    if (elements && !this._isProcessing) {
        this._isProcessing = true;

        if (typeof (elements.length) != 'undefined') {
            for (var i = 0; i < elements.length; i++) {
                tag = this._tag(elements[i]);

                if (tag == 'input' || tag == 'select') {
                    fields.push({ tag: tag, element: elements[i] });
                } else if (name == 'iframe') {
                    frames.push(elements[i]);
                }
            }
        } else if (elements.ownerDocument) {
            inputs = elements.ownerDocument.getElementsByTagName('input');
            selects = elements.ownerDocument.getElementsByTagName('select');
            textareas = elements.ownerDocument.getElementsByTagName('textarea');

            fields = this._toArray(inputs).concat(this._toArray(selects).concat(this._toArray(textareas)));
            frames = elements.ownerDocument.getElementsByTagName('iframe');
        }

        this.trackFields(fields);
        this.trackFrames(frames);

        this._isProcessing = false;
    }
}

Dynamicweb.Watcher.prototype.trackFields = function(fields) {
    /// <summary>Starts tracking changes for a given form fields.</summary>
    /// <param name="fields">Form fields to track changes for.</param>

    var tp = '';
    var self = this;
    var tag = '', element = null;

    if (fields && fields.length > 0) {
        for (var i = 0; i < fields.length; i++) {
            if (fields.tag && fields.element) {
                tag = fields.tag;
                element = fields.element;
            } else {
                tag = this._tag(fields[i]);
                element = fields[i];
            }

            tp = this._attribute(element, 'type');

            if (tp != 'hidden' && tp != 'submit') {
                if (!this._isMarked(element)) {
                    this._mark(element);

                    if (tag != 'select') {
                        this._event(element, 'click', function(e) { self._fieldModified(e, true); });
                        this._event(element, 'keyup', function(e) { self._fieldModified(e); });
                    } else {
                        this._event(element, 'change', function(e) { self._fieldModified(e); });
                    }
                }
            }
        }
    }
}

Dynamicweb.Watcher.prototype.trackFrames = function(frames) {
    /// <summary>Starts tracking changes for a given frames.</summary>
    /// <param name="frames">Frames fields to track changes for.</param>

    var wnd = null;
    var self = this;

    if (frames && frames.length > 0) {
        for (var i = 0; i < frames.length; i++) {
            if (!this._isMarked(frames[i])) {
                /* Handling FCKEditor frames as form fields - they will be processed once they are loaded */
                if (frames[i].src.indexOf('ckeditor.htm') < 0) {
                    this._mark(frames[i]);
                    this._event(frames[i], 'load', function(e) { self._frameLoaded(e); });
                }
            }
        }
    }
}

Dynamicweb.Watcher.prototype.trackFCKeditor = function(editorFrame) {
    /// <summary>Starts tracking changes for a FCKEditor frame.</summary>
    /// <param name="editorFrame">FCKEditor frame to track changes for.</param>

    var t = '';
    var wnd = null;
    var self = this;

    if (editorFrame) {
        t = this._tag(editorFrame);

        if (t != 'iframe' && editorFrame.EditorWindow) {
            editorFrame = editorFrame.EditorWindow.parent;
        }
    }

    if (editorFrame) {
        if (!this._isMarked(editorFrame)) {
            this._mark(editorFrame);

            wnd = editorFrame.window ? editorFrame.window : editorFrame.contentWindow;

            if (wnd.FCK && wnd.FCK.EditingArea) {
                /* Registering a "keyup" event handler on the editing area BODY element (since it's editable) */
                this._event(wnd.FCK.EditingArea.Document, 'keyup', function(e) { self._fieldModified(e); });
            }
        }
    }
}

Dynamicweb.Watcher.prototype.add_xhrInitiated = function(handler) {
    /// <summary>Registers new event handler for "xhrInitiated" event.</summary>
    /// <param name="handles">Event handler.</param>

    this._events.addHandler('xhrInitiated', handler);
}

Dynamicweb.Watcher.prototype.add_fieldModified = function(handler) {
    /// <summary>Registers new event handler for "fieldModified" event.</summary>
    /// <param name="handles">Event handler.</param>

    this._events.addHandler('fieldModified', handler);
}

Dynamicweb.Watcher.prototype.add_frameLoaded = function(handler) {
    /// <summary>Registers new event handler for "frameLoaded" event.</summary>
    /// <param name="handles">Event handler.</param>

    this._events.addHandler('frameLoaded', handler);
}

Dynamicweb.Watcher.prototype.add_activityRegistered = function(handler) {
    /// <summary>Registers new event handler for "activityRegistered" event.</summary>
    /// <param name="handles">Event handler.</param>

    this._events.addHandler('activityRegistered', handler);
}



Dynamicweb.Watcher.prototype._startTrackingChanges = function() {
    /// <summary>Starts tracking structure changes.</summary>
    /// <private />
    
    var self = this;

    this._trackIntervalID = setInterval(function() {
        self.track();
    }, 500);
}

Dynamicweb.Watcher.prototype._fieldModified = function(e, clicked) {
    /// <summary>Fired when form field is modified.</summary>
    /// <param name="e">Event object.</param>
    /// <param name="clicked">Value indicating whether "click" event occured.</param>
    /// <private />

    var tp = '';

    tp = this._attribute(e.element, 'type');

    if (!clicked || (tp == 'checkbox' || tp == 'radio')) {
        setTimeout(function() {
            Dynamicweb.Watcher.raiseEvent('fieldModified', { element: e.element });
        }, 10);
    }
}

Dynamicweb.Watcher.prototype._frameLoaded = function(e) {
    /// <summary>Fired when frame has finished loading.</summary>
    /// <param name="e">Event object.</param>
    /// <private />

    Dynamicweb.Watcher.raiseEvent('frameLoaded', { element: e.element });
}

Dynamicweb.Watcher.prototype._mark = function(element) {
    /// <summary>Marks specified element as watcher subject.</summary>
    /// <param name="element">Element to mark.</param>
    /// <private />

    this._attribute(element, '_watching', '1');
}

Dynamicweb.Watcher.prototype._isMarked = function(element) {
    /// <summary>Gets value indicating whether specified element is marked as watcher subject.</summary>
    /// <param name="element">Element to examine.</param>
    /// <private />

    return this._attribute(element, '_watching').length > 0;
}

Dynamicweb.Watcher.prototype._event = function(element, name, callback, remove) {
    /// <summary>Registers (or unregisters) an event handler.</summary>
    /// <param name="element">Target element.</param>
    /// <param name="name">Event name.</param>
    /// <param name="callback">Event handler.</param>
    /// <param name="remove">Optional. Value indicating whether to unregister specified event handler.</param>
    /// <private />

    var listener = null;

    if (element && name && callback) {
        listener = function(e) {
            var evt = e ? e : window.event;

            evt.element = evt.target ? evt.target : evt.srcElement;
            
            callback(evt);
        }

        if (!remove) {
            if (element.attachEvent) {
                element.attachEvent('on' + name, listener);
            } else if (element.addEventListener) {
                element.addEventListener(name, listener, false);
            }
        } else {
            if (element.detachEvent) {
                element.detachEvent('on' + name, listener);
            } else if (element.removeEventListener) {
                element.removeEventListener(name, listener);
            }
        }
    }
}

Dynamicweb.Watcher.prototype._attribute = function(element, name, value) {
    /// <summary>Gets (or sets) specified attribute on a specified element.</summary>
    /// <param name="element">Target element.</param>
    /// <param name="name">Attribute name.</param>
    /// <param name="value">Optional. Attribute value.</param>
    /// <private />

    var ret = '';

    if (element && name) {
        if (!value) {
            if (element.getAttribute) {
                ret = element.getAttribute(name);
            } else if (element.readAttribute) {
                ret = element.readAttribute(name);
            }
        } else {
            if (element.setAttribute) {
                element.setAttribute(name, value);
            } else if (element.writeAttribute) {
                element.writeAttribute(name, value);
            }
        }
    }

    if (ret == null)
        ret = '';

    return ret;
}

Dynamicweb.Watcher.prototype._toArray = function(list) {
    /// <summary>Converts specified list to Array object.</summary>
    /// <param name="list">List to convert.</param>
    /// <private />

    var ret = [];

    if (list && list.length) {
        for (var i = 0; i < list.length; i++) {
            ret.push(list[i]);
        }
    }
    
    return ret;
}

Dynamicweb.Watcher.prototype._tag = function(element) {
    /// <summary>Gets the tag name of the specified element.</summary>
    /// <param name="element">Element to examine.</param>
    /// <private />

    var ret = '';

    if (element) {
        if (element.tagName) {
            ret = element.tagName;
        } else if (element.nodeName) {
            ret = element.nodeName;
        }
    }

    return ret.toLowerCase();
}

Dynamicweb.Watcher.prototype._param = function(queryString, name) {
    /// <summary>Gets the query-string parameter value.</summary>
    /// <param name="queryString">Query-string.</param>
    /// <param name="name">Parameter name.</param>
    /// <private />

    var ret = '';
    var param = '';
    var sepIndex = -1;
    var paramIndex = -1;

    if (queryString && name) {
        param = name + '=';
        paramIndex = queryString.indexOf(param);
        if (paramIndex >= 0) {
            queryString = queryString.substr(paramIndex + param.length);
            sepIndex = queryString.indexOf('&');
            if (sepIndex < 0) {
                ret = queryString;
            } else {
                ret = queryString.substr(0, sepIndex);
            }
        }
    }

    return ret;
}

Dynamicweb.Watcher.prototype._notify = function(eventName, args) {
    /// <summary>Notifies subscribers about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>
    /// <private />

    this._events.notify(eventName, this, args);
}

Dynamicweb.Watcher.prototype._onXhrInitiated = function(args) {
    /// <summary>Raises "xhrInitiated" event.</summary>
    /// <param name="args">Event arguments.</param>
    /// <private />

    this._notify('xhrInitiated', args);
}

Dynamicweb.Watcher.prototype._onFieldModified = function(args) {
    /// <summary>Raises "fieldModified" event.</summary>
    /// <param name="args">Event arguments.</param>
    /// <private />

    this._notify('fieldModified', args);
}

Dynamicweb.Watcher.prototype._onFrameLoaded = function(args) {
    /// <summary>Raises "frameLoaded" event.</summary>
    /// <param name="args">Event arguments.</param>
    /// <private />

    this._notify('frameLoaded', args);
}

Dynamicweb.Watcher.prototype._onActivityRegistered = function(type, args) {
    /// <summary>Raises "activityRegistered" event.</summary>
    /// <param name="type">Event type.</param>
    /// <param name="args">Event arguments.</param>
    /// <private />

    this._notify('activityRegistered', {type: type, arguments: args});
}
