/* Creating a namespace (if needed) */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

/* Provides methods to work with AJAX. */
Dynamicweb.Ajax = {};

Dynamicweb.Ajax.Lazy = function (value) {
    /// <summary>Represents a lazy load wrapper around the given object.</summary>
    /// <param name="value">Data to be lazy loaded.</param>

    this._value = value;
};

Dynamicweb.Ajax.Lazy.prototype.get_value = function () {
    /// <summary>Lazy loads the associated value.</summary>

    var ret = null;

    if (this._value) {
        if (typeof (this._value) == 'string') {
            if (this._value.indexOf('#') == 0) {
                ret = document.getElementById(this._value.substr(1));
            } else {
                try {
                    if (!ret) {
                        ret = eval(this._value);
                    }
                } catch (ex) { }
            }

            if (ret) {
                this._value = ret;
            }
        } else {
            ret = this._value;
        }
    }

    return ret;
};

Dynamicweb.Ajax.Hash = function (data) {
    /// <summary>Represents a hash.</summary>

    this._object = data;

    if (this._object) {
        if (typeof (this._object.keys) == 'function') {
            if (typeof (this._object._object) != 'undefined') {
                this._object = this._object._object;
            } else if (typeof (data.toObject) == 'function') {
                this._object = data.toObject();
            }
        }
    } else {
        this._object = {};
    }
};

Dynamicweb.Ajax.Hash.prototype.set = function (key, value) {
    /// <summary>Associates the given key with the given value.</summary>
    /// <param name="key">Item key.</param>
    /// <param name="value">Item value.</param>

    return this._object[key] = value;
};

Dynamicweb.Ajax.Hash.prototype.get = function (key) {
    /// <summary>Gets the value associated with the given key.</summary>
    /// <param name="key">Item key.</param>

    return typeof (this._object[key]) != 'function' ? this._object[key] : null;
};

Dynamicweb.Ajax.Hash.prototype.unset = function (key) {
    /// <summary>Removes the item with the given key.</summary>
    /// <param name="key">Item key.</param>

    var ret = this.get(key);

    delete this._object[key];

    return ret;
};

Dynamicweb.Ajax.Hash.prototype.keys = function () {
    /// <summary>Returns all hash keys.</summary>

    var ret = [];

    for (var key in this._object) {
        if (typeof (this._object[key]) != 'function') {
            ret[ret.length] = key;
        }
    }

    return ret;
};

Dynamicweb.Ajax.Hash.prototype.values = function () {
    /// <summary>Returns all hash values.</summary>

    var ret = [];

    for (var key in this._object) {
        if (typeof (this._object[key]) != 'function') {
            ret[ret.length] = this._object[key];
        }
    }

    return ret;
};

Dynamicweb.Ajax.Hash.prototype.toObject = function () {
    /// <summary>Converts the given hash to object.</summary>

    var ret = {};
    var keys = this.keys();

    for (var i = 0; i < keys.length; i++) {
        ret[keys[i]] = this.get(keys[i]);
    }

    return ret;
};

Dynamicweb.Ajax.Hash.prototype.merge = function (other) {
    /// <summary>Merges the given hash with other hash.</summary>
    /// <param name="other">Another hash.</param>

    var keys = [];
    var obj = null;
    var found = false;

    if (other) {
        if (typeof (other._object) != 'undefined') {
            obj = other._object;
        } else {
            obj = other;
        }

        if (obj) {
            keys = this.keys();

            for (var key in obj) {
                if (typeof (obj[key]) != 'function') {
                    found = false;

                    for (var i = 0; i < keys.length; i++) {
                        if (keys[i] == key) {
                            found = true;
                            break;
                        }
                    }

                    if (!found) {
                        this._object[key] = obj[key];
                    }
                }
            }
        }
    }

    return this;
};

Dynamicweb.Ajax.Hash.prototype.update = function (other) {
    /// <summary>Updates the current hash with data from the other hash.</summary>
    /// <param name="other">Another hash.</param>

    var obj = null;

    if (other) {
        if (typeof (other._object) != 'undefined') {
            obj = other._object;
        } else {
            obj = other;
        }

        if (obj) {
            for (var key in obj) {
                if (typeof (obj[key]) != 'function') {
                    this._object[key] = obj[key];
                }
            }
        }
    }
};

Dynamicweb.Ajax.DocumentModel = function () {
    /// <summary>Represents a document model.</summary>
};

Dynamicweb.Ajax.DocumentModel.prototype.get_viewEngine = function () {
    /// <summary>Gets the view engine of the current document.</summary>

    return '';
};

Dynamicweb.Ajax.DocumentModel.prototype.css = function (element, propertyName, propertyValue) {
    /// <summary>Gets or sets CSS property value.</summary>
    /// <param name="element">DOM element.</param>
    /// <param name="propertyName">CSS property name.</param>
    /// <param name="propertyValue">CSS property value.</param>

    return null;
};

Dynamicweb.Ajax.DocumentModel.prototype.getElementById = function (id) {
    /// <summary>Returns DOM element by its Id.</summary>
    /// <param name="id">An Id of the DOM element.</param>

    return null;
};

Dynamicweb.Ajax.DocumentModel.prototype.getElementsBySelector = function (selector, context) {
    /// <summary>Returns all DOM element that matches the given selector.</summary>
    /// <param name="selector">CSS selector.</param>
    /// <param name="context">Selection context. If ommitted, the whole document will be used as a context.</param>

    return [];
};

Dynamicweb.Ajax.DocumentModel.prototype.find = function (element, selector) {
    return [];
};

Dynamicweb.Ajax.DocumentModel.prototype.createRequest = function (url, params) {
    /// <summary>Initiates a new AJAX request.</summary>
    /// <param name="url">Target URL.</param>
    /// <param name="params">Request paramters.</param>
    /// <returns>Request object.</returns>

    return null;
};

Dynamicweb.Ajax.DocumentModel.prototype.extend = function (element) {
    /// <summary>Extends the given element.</summary>
    /// <param name="element">Element to extend.</param>

    return $(element);
};

Dynamicweb.Ajax.DocumentModel.prototype.attribute = function (element, name, value) {
    /// <summary>Gets or sets element attribute.</summary>
    /// <param name="element">Target DOM element.</param>
    /// <param name="name">Attribute name.</param>
    /// <param name="value">Attribute value.</param>

    return '';
};

Dynamicweb.Ajax.DocumentModel.prototype.removeAttribute = function (element, name) {
    /// <summary>Removes element attribute.</summary>
    /// <param name="element">Target DOM element.</param>
    /// <param name="name">Attribute name.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.subscribe = function (element, eventName, selector, handler) {
    /// <summary>Subscribes to the given event.</summary>
    /// <param name="element">Target element.</param>
    /// <param name="eventName">Event name.</param>
    /// <param name="handler">Event handler.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.unsubscribe = function (element, eventName, handler) {
    /// <summary>Unsubscribes from the given event.</summary>
    /// <param name="element">Target element.</param>
    /// <param name="eventName">Event name.</param>
    /// <param name="handler">Event handler.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.serializeForm = function (form) {
    /// <summary>Serializes the given form data to object.</summary>
    /// <param name="form">Form to serialize.</param>

    return null;
};

Dynamicweb.Ajax.DocumentModel.prototype.hasClass = function (element, className) {
    /// <summary>Unsubscribes from the given event.</summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">The class name to search for.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.addClass = function (element, className) {
    /// <summary>Adds the specified class(es) to each of the set of matched elements.</summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">One or more space-separated classes to be added to the class attribute of each matched element.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.removeClass = function (element, className) {
    /// <summary>Remove a single class, multiple classes, or all classes from each element in the set of matched elements.</summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">One or more space-separated classes to be removed from the class attribute of each matched element.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.toggleClass = function (element, className) {
    /// <summary>
    /// Add or remove one or more classes from each element in the set of matched elements, 
    /// depending on either the class's presence or the value of the switch argument.
    /// </summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">One or more class names (separated by spaces) to be toggled for each element in the matched set.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.hide = function (element) {
    /// <summary>Hide the element.</summary>
    /// <param name="element">The element to hide.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.show = function (element) {
    /// <summary>Display the element.</summary>
    /// <param name="element">The element to display.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.clone = function (element, deep) {
    /// <summary>Returns a duplicate of element.</summary>
    /// <param name="element">The element to copy.</param>
    /// <param name="deep">Whether to clone element's descendants as well.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.height = function (element, value) {
    /// <summary>Gets or sets the current computed height specified element.</summary>
    /// <param name="element">The element to be tested.</param>
    /// <param name="value">Value to set.</param>
};

Dynamicweb.Ajax.DocumentModel.prototype.width = function (element, value) {
    /// <summary>Gets or sets the current computed width specified element.</summary>
    /// <param name="element">The element to be tested.</param>
    /// <param name="value">Value to set.</param>

};

Dynamicweb.Ajax.DocumentModel.prototype.parent = function (element, selector) {
    /// <summary>Gets the parent of each element in the current set of matched elements, optionally filtered by a selector.</summary>
    /// <param name="element">The element to be tested.</param>
    /// <param name="value">Selector. Optional.</param>

};

Dynamicweb.Ajax.DocumentModel.createModel = function () {
    /// <summary>Creates new document model.</summary>

    var ret = null;

    if (typeof (jQuery) != 'undefined') {
        ret = new Dynamicweb.Ajax.jQueryDocumentModel();
    } else if (typeof (Prototype) != 'undefined') {
        ret = new Dynamicweb.Ajax.PrototypeDocumentModel();
    } else {
        Dynamicweb.Ajax.error('Cannot create document model. To enable document model include either jQuery or Prototype on the page.');
    }

    return ret;
};

Dynamicweb.Ajax.jQueryDocumentModel = function () {
    /// <summary>Represents a document model based on jQuery document intrepretation.</summary>
};
(function ($) {
    /* Inheritance */
    Dynamicweb.Ajax.jQueryDocumentModel.prototype = new Dynamicweb.Ajax.DocumentModel();

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.get_viewEngine = function () {
        /// <summary>Gets the view engine of the current document.</summary>

        var ret = '';

        if (jQuery.browser.webkit) {
            ret = 'webkit';
        } else if (jQuery.browser.safari) {
            ret = 'safari';
        } else if (jQuery.browser.opera) {
            ret = 'opera';
        } else if (jQuery.browser.msie) {
            ret = 'ie';
        } else if (jQuery.browser.mozilla) {
            ret = 'gecko';
        }

        return ret;
    };
    Dynamicweb.Ajax.jQueryDocumentModel.prototype.css = function (element, propertyName, propertyValue) {
        return $(element).css(propertyName, propertyValue);
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.getElementById = function (id) {
        /// <summary>Returns DOM element by its Id.</summary>
        /// <param name="id">An Id of the DOM element.</param>

        var ret = null;
        var elements = $('#' + id);

        if (elements && elements.length > 0) {
            ret = elements[0];
        }

        return ret;
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.getElementsBySelector = function (selector, context) {
        /// <summary>Returns all DOM element that matches the given selector.</summary>
        /// <param name="selector">CSS selector.</param>
        /// <param name="context">Selection context. If ommitted, the whole document will be used as a context.</param>

        if (!context) {
            context = document.body;
        }

        return $(context).find(selector);
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.find = function (element, selector) {
        return $(element).find(selector);
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.createRequest = function (url, params) {
        /// <summary>Initiates a new AJAX request.</summary>
        /// <param name="url">Target URL.</param>
        /// <param name="params">Request paramters.</param>
        /// <returns>Request object.</returns>

        var data = {};

        if (!params) params = {};

        if (params.parameters) {
            if (typeof (params.parameters.toObject) == 'function') {
                data = params.parameters.toObject();
            } else {
                data = params.parameters;
            }
        }

        return $.ajax(url, {
            type: params.method,
            data: data,
            beforeSend: params.onCreate || function () { },
            success: params.onSuccess || function () { },
            error: params.onError || function () { },
            complete: params.onComplete || function () { }
        });
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.attribute = function (element, name, value) {
        /// <summary>Gets or sets element attribute.</summary>
        /// <param name="element">Target DOM element.</param>
        /// <param name="name">Attribute name.</param>
        /// <param name="value">Attribute value.</param>

        var ret = '';

        if (typeof (value) == 'undefined') {
            ret = $(element).attr(name);
        } else {
            $(element).attr(name, value);
            ret = value;
        }

        return ret;
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.removeAttribute = function (element, name) {
        /// <summary>Removes element attribute.</summary>
        /// <param name="element">Target DOM element.</param>
        /// <param name="name">Attribute name.</param>

        $(element).removeAttr(name);
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.subscribe = function (element, eventName, selector, handler) {
        /// <summary>Subscribes to the given event.</summary>
        /// <param name="element">Target element.</param>
        /// <param name="eventName">Event name.</param>
        /// <param name="selector">A selector string to filter the descendants of the selected elements that trigger the event. 
        /// If the selector is null or omitted, the event is always triggered when it reaches the selected element.</param>
        /// <param name="handler">Event handler.</param>

        var target = element,
            childrenSelector,
            eventHandler;

        if (handler) {
            childrenSelector = selector;
            eventHandler = handler;
        } else {
            childrenSelector = '';
            eventHandler = selector;
        }

        eventHandler = function (event) {
            if (handler && typeof handler === 'function') {
                handler.call(this, event, $(this));
            }
        };

        if (eventName && eventName.length) {
            if (eventName == 'ready') {
                target = document;
            }

            if (childrenSelector) {
                $(element).on(eventName, childrenSelector, eventHandler);
            } else {
                $(element).on(eventName, eventHandler);
            }
        }
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.unsubscribe = function (element, eventName, handler) {
        /// <summary>Unsubscribes from the given event.</summary>
        /// <param name="element">Target element.</param>
        /// <param name="eventName">Event name.</param>
        /// <param name="handler">Event handler.</param>

        var target = element;

        handler = handler || function () { };

        if (eventName && eventName.length) {
            if (eventName == 'ready') {
                target = document;
            }

            $(target).unbind(eventName, handler);
        }
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.serializeForm = function (form) {
        /// <summary>Serializes the given form data to object.</summary>
        /// <param name="form">Form to serialize.</param>

        var serializeObject = function (element) {
            var ret = {};
            var arr = $(element).serializeArray();

            $.each(arr, function () {
                if (typeof (ret[this.name]) != 'undefined') {
                    if (!ret[this.name].push) {
                        ret[this.name] = [ret[this.name]];
                    }

                    ret[this.name].push(this.value || '');
                } else {
                    ret[this.name] = this.value || '';
                }
            });

            return ret;
        }

        return serializeObject(form);
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.hasClass = function (element, className) {
        /// <summary>Unsubscribes from the given event.</summary>
        /// <param name="element">The value to be tested.</param>
        /// <param name="className">The class name to search for.</param>

        return $(element).hasClass(className);
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.addClass = function (element, className) {
        /// <summary>Adds the specified class(es) to each of the set of matched elements.</summary>
        /// <param name="element">The value to be tested.</param>
        /// <param name="className">One or more space-separated classes to be added to the class attribute of each matched element.</param>

        $(element).addClass(className);
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.removeClass = function (element, className) {
        /// <summary>Remove a single class, multiple classes, or all classes from each element in the set of matched elements.</summary>
        /// <param name="element">The value to be tested.</param>
        /// <param name="className">One or more space-separated classes to be removed from the class attribute of each matched element.</param>

        $(element).removeClass(className);
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.toggleClass = function (element, className) {
        /// <summary>
        /// Add or remove one or more classes from each element in the set of matched elements, 
        /// depending on either the class's presence or the value of the switch argument.
        /// </summary>
        /// <param name="element">The value to be tested.</param>
        /// <param name="className">One or more class names (separated by spaces) to be toggled for each element in the matched set.</param>

        $(element).toggleClass(className);
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.hide = function (element) {
        /// <summary>Hide the element.</summary>
        /// <param name="element">The element to hide.</param>

        $(element).hide();
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.show = function (element) {
        /// <summary>Display the element.</summary>
        /// <param name="element">The element to display.</param>

        $(element).show();
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.clone = function (element, deep) {
        /// <summary>Returns a duplicate of element.</summary>
        /// <param name="element">The element to copy.</param>
        /// <param name="deep">Whether to clone element's descendants as well.</param>

        return $(element).clone(deep)[0];
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.height = function (element, value) {
        /// <summary>Gets or sets the current computed height specified element.</summary>
        /// <param name="element">The element to be tested.</param>
        /// <param name="value">Value to set.</param>

        if (typeof value !== 'undefined') {
            result = $(element).height(value);
        } else {
            result = $(element).height();
        }

        return result
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.width = function (element, value) {
        /// <summary>Gets or sets the current computed width specified element.</summary>
        /// <param name="element">The element to be tested.</param>
        /// <param name="value">Value to set.</param>

        var result;

        if (typeof value !== 'undefined') {
            result = $(element).width(value);
        } else {
            result = $(element).width();
        }

        return result;
    };

    Dynamicweb.Ajax.jQueryDocumentModel.prototype.parent = function (element, selector) {
        /// <summary>Gets the parent of each element in the current set of matched elements, optionally filtered by a selector.</summary>
        /// <param name="element">The element to be tested.</param>
        /// <param name="value">Selector. Optional.</param>
        return $(element).parent(selector);
    };
})(window.jQuery);

Dynamicweb.Ajax.PrototypeDocumentModel = function () {
    /// <summary>Represents a document model based on Prototype document intrepretation.</summary>
};

/* Inheritance */
Dynamicweb.Ajax.PrototypeDocumentModel.prototype = new Dynamicweb.Ajax.DocumentModel();

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.get_viewEngine = function () {
    /// <summary>Gets the view engine of the current document.</summary>

    var ret = '';

    if (Prototype.Browser.WebKit) {
        ret = 'webkit';
    } else if (Prototype.Browser.MobileSafari) {
        ret = 'safari';
    } else if (Prototype.Browser.Opera) {
        ret = 'opera';
    } else if (Prototype.Browser.IE) {
        ret = 'ie';
    } else if (Prototype.Browser.Gecko) {
        ret = 'gecko';
    }

    return ret;
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.css = function (element, propertyName, propertyValue) {
    var result;

    if (typeof propertyValue !== 'undefined') {
        result = element.setStyle(propertyName, propertyValue);
    } else {
        result = element.getStyle(propertyName);
    }

    return result;
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.getElementById = function (id) {
    /// <summary>Returns DOM element by its Id.</summary>
    /// <param name="id">An Id of the DOM element.</param>

    return $(id);
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.getElementsBySelector = function (selector, context) {
    /// <summary>Returns all DOM element that matches the given selector.</summary>
    /// <param name="selector">CSS selector.</param>
    /// <param name="context">Selection context. If ommitted, the whole document will be used as a context.</param>

    var ret = [];
    var extended = null;

    if (!context) {
        context = document.body;
    }

    extended = this.extend(context);
    if (extended) {
        ret = extended.select(selector);
    }

    return ret;
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.find = function (element, selector) {
    return $(element).select(selector);
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.createRequest = function (url, params) {
    /// <summary>Initiates a new AJAX request.</summary>
    /// <param name="url">Target URL.</param>
    /// <param name="params">Request paramters.</param>
    /// <returns>Request object.</returns>

    var parameters = {};

    if (!params) params = {};

    if (params.parameters) {
        if (typeof (params.parameters.toObject) == 'function') {
            parameters = params.parameters.toObject();
        } else {
            parameters = params.parameters;
        }
    }

    if (!params) params = {};

    return new Ajax.Request(url, {
        method: params.method,
        parameters: parameters,
        onCreate: params.onCreate || function () { },
        onSuccess: params.onSuccess || function () { },
        onError: params.onError || function () { },
        onComplete: params.onComplete || function () { }
    });
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.attribute = function (element, name, value) {
    /// <summary>Gets or sets element attribute.</summary>
    /// <param name="element">Target DOM element.</param>
    /// <param name="name">Attribute name.</param>
    /// <param name="value">Attribute value.</param>

    var ret = '';
    var extended = this.extend(element);

    if (extended) {
        if (typeof (value) == 'undefined') {
            ret = extended.readAttribute(name);
        } else {
            extended.writeAttribute(name, value);
            ret = value;
        }
    }

    return ret;
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.removeAttribute = function (element, name) {
    /// <summary>Removes element attribute.</summary>
    /// <param name="element">Target DOM element.</param>
    /// <param name="name">Attribute name.</param>

    Element.writeAttribute(element, name, false)
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.subscribe = function (element, eventName, selector, handler) {
    /// <summary>Subscribes to the given event.</summary>
    /// <param name="element">Target element.</param>
    /// <param name="eventName">Event name.</param>
    /// <param name="handler">Event handler.</param>

    var target = element,
        childrenSelector,
        eventHandler;

    if (handler) {
        childrenSelector = selector;
        eventHandler = handler;
    } else {
        childrenSelector = '';
        eventHandler = selector;
    }

    eventHandler = eventHandler || function () { }

    if (eventName && eventName.length) {
        if (eventName == 'ready') {
            target = document;
            eventName = 'dom:loaded';
            Event.observe(target, eventName, eventHandler);
        } else {
            if (childrenSelector) {
                Event.on(target, eventName, childrenSelector, eventHandler);
            } else {
                Event.observe(target, eventName, function (event) {
                    eventHandler(event, this);
                });
            }
        }
    }
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.unsubscribe = function (element, eventName, handler) {
    /// <summary>Unsubscribes from the given event.</summary>
    /// <param name="element">Target element.</param>
    /// <param name="eventName">Event name.</param>
    /// <param name="handler">Event handler.</param>

    var target = element;

    handler = handler || function () { }

    if (eventName && eventName.length) {
        if (eventName == 'ready') {
            target = document;
            eventName = 'dom:loaded';
        }

        Event.stopObserving(target, eventName, handler);
    }
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.hasClass = function (element, className) {
    /// <summary>Unsubscribes from the given event.</summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">The class name to search for.</param>

    return Element.hasClassName(element, className);
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.addClass = function (element, className) {
    /// <summary>Adds the specified class(es) to each of the set of matched elements.</summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">One or more space-separated classes to be added to the class attribute of each matched element.</param>

    Element.addClassName(element, className);
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.removeClass = function (element, className) {
    /// <summary>Remove a single class, multiple classes, or all classes from each element in the set of matched elements.</summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">One or more space-separated classes to be removed from the class attribute of each matched element.</param>

    Element.removeClassName(element, className);
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.toggleClass = function (element, className) {
    /// <summary>
    /// Add or remove one or more classes from each element in the set of matched elements, 
    /// depending on either the class's presence or the value of the switch argument.
    /// </summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">One or more class names (separated by spaces) to be toggled for each element in the matched set.</param>

    Element.toggleClassName(element, className);
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.hide = function (element) {
    /// <summary>Hide the element.</summary>
    /// <param name="element">The element to hide.</param>

    Element.hide(element);
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.show = function (element) {
    /// <summary>Display the element.</summary>
    /// <param name="element">The element to display.</param>

    Element.show(element);
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.clone = function (element, deep) {
    /// <summary>Returns a duplicate of element.</summary>
    /// <param name="element">The element to copy.</param>
    /// <param name="deep">Whether to clone element's descendants as well.</param>

    return Element.clone(element, deep);
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.height = function (element, value) {
    /// <summary>Gets or sets the current computed height specified element.</summary>
    /// <param name="element">The element to be tested.</param>
    /// <param name="value">Value to set.</param>

    var result;

    if (typeof value !== 'undefined') {
        result = element.setStyle({
            'height': value
        });
    } else {
        result = element.getHeight();
    }

    return result;
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.width = function (element, value) {
    /// <summary>Gets or sets the current computed width specified element.</summary>
    /// <param name="element">The element to be tested.</param>
    /// <param name="value">Value to set.</param>

    var result;

    if (typeof value !== 'undefined') {
        result = element.setStyle({
            'width': value
        });
    } else {
        result = element.getWidth();
    }

    return result;
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.serializeForm = function (form) {
    /// <summary>Serializes the given form data to object.</summary>
    /// <param name="form">Form to serialize.</param>

    var ret = null;
    var extended = this.extend(form);

    if (extended) {
        ret = form.serialize(true);
    }

    return ret;
};

Dynamicweb.Ajax.PrototypeDocumentModel.prototype.parent = function (element, selector) {
    /// <summary>Gets the parent of each element in the current set of matched elements, optionally filtered by a selector.</summary>
    /// <param name="element">The element to be tested.</param>
    /// <param name="value">Selector. Optional.</param>
    return Element.up(element, selector);
};

Dynamicweb.Ajax.Document = function () {
    /// <summary>Represents the current document.</summary>

    this._model = null;

    if (Dynamicweb.Ajax.Document._instance) {
        Dynamicweb.Ajax.error('Only one instance of the document is allowed. Use "Dynamicweb.Ajax.Document.get_current" to get this instance.');
    } else {
        this._model = Dynamicweb.Ajax.DocumentModel.createModel();
    }
};

Dynamicweb.Ajax.Document._instance = null;

Dynamicweb.Ajax.Document.get_current = function () {
    /// <summary>Gets the current document.</summary>

    if (!Dynamicweb.Ajax.Document._instance) {
        Dynamicweb.Ajax.Document._instance = new Dynamicweb.Ajax.Document();
    }

    return Dynamicweb.Ajax.Document._instance;
};

Dynamicweb.Ajax.Document.prototype.get_model = function () {
    /// <summary>Gets the associated document model.</summary>

    if (!this._model) {
        this._model = Dynamicweb.Ajax.DocumentModel.createModel();
    }

    return this._model;
};

Dynamicweb.Ajax.Document.prototype.get_viewEngine = function () {
    /// <summary>Gets the view engine of the current document.</summary>

    return this.get_model().get_viewEngine();
};

Dynamicweb.Ajax.Document.prototype.set_model = function (value) {
    /// <summary>Sets the associated document model.</summary>
    /// <param name="value">Document model.</param>

    this._model = value;

    if (this._model && typeof (this._model.getElementsBySelector) != 'function') {
        this._model = null;
    }
};

Dynamicweb.Ajax.Document.prototype.css = function (element, propertyName, propertyValue) {
    return this.get_model().css(element, propertyName, propertyValue);
};

Dynamicweb.Ajax.Document.prototype.getElementById = function (id) {
    /// <summary>Returns DOM element by its Id.</summary>
    /// <param name="id">An Id of the DOM element.</param>

    return this.get_model().getElementById(id);
};

Dynamicweb.Ajax.Document.prototype.getElementsBySelector = function (selector, context) {
    /// <summary>Returns all DOM element that matches the given selector.</summary>
    /// <param name="selector">CSS selector.</param>
    /// <param name="context">Selection context. If ommitted, the whole document will be used as a context.</param>

    return this.get_model().getElementsBySelector(selector, context);
};

Dynamicweb.Ajax.Document.prototype.find = function (element, selector) {
    return this.get_model().find(element, selector);
};

Dynamicweb.Ajax.Document.prototype.createRequest = function (url, params) {
    /// <summary>Initiates a new AJAX request.</summary>
    /// <param name="url">Target URL.</param>
    /// <param name="params">Request paramters.</param>
    /// <returns>Request object.</returns>

    return this.get_model().createRequest(url, params);
};

Dynamicweb.Ajax.Document.prototype.attribute = function (element, name, value) {
    /// <summary>Gets or sets element attribute.</summary>
    /// <param name="element">Target DOM element.</param>
    /// <param name="name">Attribute name.</param>
    /// <param name="value">Attribute value.</param>

    return this.get_model().attribute(element, name, value);
};

Dynamicweb.Ajax.Document.prototype.removeAttribute = function (element, name) {
    /// <summary>Removes element attribute.</summary>
    /// <param name="element">Target DOM element.</param>
    /// <param name="name">Attribute name.</param>

    return this.get_model().removeAttribute(element, name);
};

Dynamicweb.Ajax.Document.prototype.createElement = function (tagName, attributes) {
    /// <summary>Creates new element.</summary>
    /// <param name="tagName">Element tag name.</param>
    /// <param name="attributes">Element attributes.</param>
    /// <returns>Newly created element.</returns>

    var ret = null;

    if (!tagName || !tagName.length) {
        tagName = 'span';
    }

    ret = document.createElement(tagName);

    if (attributes) {
        for (var name in attributes) {
            if (typeof (attributes[name]) != 'function') {
                this.attribute(ret, name, attributes[name]);
            }
        }
    }

    return ret;
};

Dynamicweb.Ajax.Document.prototype.decodeTags = function (content) {
    if (content && typeof content === 'string') {
        var element = document.createElement('div');
        // strip script/html tags
        content = content.replace(/<script[^>]*>([\S\s]*?)<\/script>/gmi, '');
        content = content.replace(/<\/?\w(?:[^"'>]|"[^"]*"|'[^']*')*>/gmi, '');
        element.innerHTML = content;
        content = element.textContent;
        element.textContent = '';
    }

    return content;
};

Dynamicweb.Ajax.Document.prototype.stripTags = function (content) {
    var ret = content.replace(/<\w+(\s+("[^"]*"|'[^']*'|[^>])+)?>|<\/\w+>/gi, '');
    ret = ret.replace(/<.*/g, '');
    return ret;
};

Dynamicweb.Ajax.Document.prototype.stripScripts = function (content) {
    /// <summary>Removes all references to SCRIPT tags from the given HTML content.</summary>
    /// <param name="content">HTML content to process.</param>

    var ret = content;

    if (ret && ret.length) {
        ret = ret.replace(new RegExp('<script[^>]*>([\\S\\s]*?)<\/script>', 'img'), '');
    }

    return ret;
};

Dynamicweb.Ajax.Document.prototype.extractScripts = function (content) {
    /// <summary>Extracts all references to SCRIPT tags from the given HTML content.</summary>
    /// <param name="content">HTML content to process.</param>

    var ret = [];
    var match = null;
    var matches = [];
    var matchAll = null;
    var matchOne = null;
    var pattern = '<script[^>]*>([\\S\\s]*?)<\/script>';

    if (content && content.length) {
        matchOne = new RegExp(pattern, 'im');
        matchAll = new RegExp(pattern, 'img');

        matches = (content.match(matchAll) || []);
        for (var i = 0; i < matches.length; i++) {
            match = matches[i].match(matchOne) || ['', ''];
            if (match[1] && match[1].length) {
                ret[ret.length] = match[1];
            }
        }
    }

    return ret;
};

Dynamicweb.Ajax.Document.prototype.evalScripts = function (content, context) {
    var scripts = this.extractScripts(content),
        i,
        len = scripts.length;

    context || (context = window);

    for (i = 0; i < len; i += 1) {
        eval.call(context, scripts[i]);
    }
};

Dynamicweb.Ajax.Document.prototype.htmlEncode = function (str) {
    return String(str)
            .replace(/&/g, '&amp;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');
};

Dynamicweb.Ajax.Document.prototype.subscribe = function (element, eventName, selector, handler) {
    /// <summary>Subscribes to the given event.</summary>
    /// <param name="element">Target element.</param>
    /// <param name="eventName">Event name.</param>
    /// <param name="handler">Event handler.</param>

    this.get_model().subscribe(element, eventName, selector, handler);
};

Dynamicweb.Ajax.Document.prototype.unsubscribe = function (element, eventName, handler) {
    /// <summary>Unsubscribes from the given event.</summary>
    /// <param name="element">Target element.</param>
    /// <param name="eventName">Event name.</param>
    /// <param name="handler">Event handler.</param>

    this.get_model().unsubscribe(element, eventName, handler);
};

Dynamicweb.Ajax.Document.prototype.serializeForm = function (form) {
    /// <summary>Serializes the given form data to object.</summary>
    /// <param name="form">Form to serialize.</param>

    return this.get_model().serializeForm(form);
};

Dynamicweb.Ajax.Document.prototype.extend = function (element) {
    /// <summary>Extends the given element.</summary>
    /// <param name="element">Element to extend.</param>

    return this.get_model().extend(element);
};

Dynamicweb.Ajax.Document.prototype.hasClass = function (element, className) {
    /// <summary>Unsubscribes from the given event.</summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">The class name to search for.</param>

    return this.get_model().hasClass(element, className);
};

Dynamicweb.Ajax.Document.prototype.addClass = function (element, className) {
    /// <summary>Adds the specified class(es) to each of the set of matched elements.</summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">One or more space-separated classes to be added to the class attribute of each matched element.</param>

    this.get_model().addClass(element, className);
};

Dynamicweb.Ajax.Document.prototype.removeClass = function (element, className) {
    /// <summary>Remove a single class, multiple classes, or all classes from each element in the set of matched elements.</summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">One or more space-separated classes to be removed from the class attribute of each matched element.</param>

    this.get_model().removeClass(element, className);
};

Dynamicweb.Ajax.Document.prototype.toggleClass = function (element, className) {
    /// <summary>
    /// Add or remove one or more classes from each element in the set of matched elements, 
    /// depending on either the class's presence or the value of the switch argument.
    /// </summary>
    /// <param name="element">The value to be tested.</param>
    /// <param name="className">One or more class names (separated by spaces) to be toggled for each element in the matched set.</param>

    this.get_model().toggleClass(element, className);
};

Dynamicweb.Ajax.Document.prototype.hide = function (element) {
    /// <summary>Hide the element.</summary>
    /// <param name="element">The element to hide.</param>

    this.get_model().hide(element);
};

Dynamicweb.Ajax.Document.prototype.show = function (element) {
    /// <summary>Display the element.</summary>
    /// <param name="element">The element to display.</param>

    this.get_model().show(element);
};

Dynamicweb.Ajax.Document.prototype.clone = function (element, deep) {
    /// <summary>Returns a duplicate of element.</summary>
    /// <param name="element">The element to copy.</param>
    /// <param name="deep">Whether to clone element's descendants as well.</param>

    return this.get_model().clone(element, deep || false);
};

Dynamicweb.Ajax.Document.prototype.height = function (element, value) {
    /// <summary>Gets or sets the current computed height specified element.</summary>
    /// <param name="element">The element to be tested.</param>
    /// <param name="value">Value to set.</param>

    return this.get_model().height(element, value);
};

Dynamicweb.Ajax.Document.prototype.width = function (element, value) {
    /// <summary>Gets or sets the current computed width specified element.</summary>
    /// <param name="element">The element to be tested.</param>
    /// <param name="value">Value to set.</param>

    return this.get_model().width(element, value);
};

Dynamicweb.Ajax.Document.prototype.parent = function (element, selector) {
    /// <summary>Gets the parent of each element in the current set of matched elements, optionally filtered by a selector.</summary>
    /// <param name="element">The element to be tested.</param>
    /// <param name="value">Selector. Optional.</param>
    return this.get_model().parent(element, selector);
};

Dynamicweb.Ajax.Control = function () {
    /// <summary>Represents a control.</summary>

    this.reset();
};

Dynamicweb.Ajax.Control.error = function (message) {
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
};

Dynamicweb.Ajax.Control.prototype.get_container = function () {
    /// <summary>Gets the reference to DOM element holding control's contents.</summary>

    if (this._container == null || typeof (this._container) == 'string') {
        this._container = Dynamicweb.Ajax.Document.get_current().getElementById(this._containerID);
    }

    return this._container;
};

Dynamicweb.Ajax.Control.prototype.set_container = function (value) {
    /// <summary>Sets the reference to DOM element holding control's contents.</summary>
    /// <param name="value">The reference to DOM element holding control's contents.</param>

    this._container = value;

    if (typeof (value) == 'string') {
        this._containerID = value;
    } else {
        this._containerID = '';
    }
};

Dynamicweb.Ajax.Control.prototype.get_associatedControlID = function () {
    /// <summary>Gets the unique identifier of the ASP.NET control that is associated with this client object.</summary>

    return this._associatedControlID;
};

Dynamicweb.Ajax.Control.prototype.set_associatedControlID = function (value) {
    /// <summary>Sets the unique identifier of the ASP.NET control that is associated with this client object.</summary>
    /// <param name="value">The unique identifier of the ASP.NET control that is associated with this client object.</param>

    this._associatedControlID = value;
};

Dynamicweb.Ajax.Control.prototype.get_state = function () {
    /// <summary>Gets the control state.</summary>

    if (!this._state) {
        this._state = {};
    }

    return this._state;
};

Dynamicweb.Ajax.Control.prototype.get_terminology = function () {
    /// <summary>Gets the control terminology.</summary>

    if (!this._terminology) {
        this._terminology = {};
    }

    return this._terminology;
};

Dynamicweb.Ajax.Control.prototype.get_isEnabled = function () {
    /// <summary>Gets value indicating whether control is enabled.</summary>

    return this._isEnabled;
};

Dynamicweb.Ajax.Control.prototype.set_isEnabled = function (value) {
    /// <summary>Gets value indicating whether control is enabled.</summary>

    this._isEnabled = !!value;
};

Dynamicweb.Ajax.Control.prototype.get_tag = function () {
    /// <summary>Gets the custom information associated with this control.</summary>

    return this._tag;
};

Dynamicweb.Ajax.Control.prototype.set_tag = function (value) {
    /// <summary>Sets the custom information associated with this control.</summary>
    /// <param name="value">The custom information associated with this control.</param>

    this._tag = value;
};

Dynamicweb.Ajax.Control.prototype.get_isReady = function () {
    /// <summary>Gets value indicating whether control is initialized and is ready to accept user input.</summary>

    return this._initialized;
};

Dynamicweb.Ajax.Control.prototype.add_ready = function (handler) {
    /// <summary>Registers new handler which is executed when the page is loaded.</summary>
    /// <param name="handler">Handler to register.</param>

    Dynamicweb.Ajax.ControlManager.get_current().add_contentReady(handler);
};

Dynamicweb.Ajax.Control.prototype.add_propertyChanged = function (handler) {
    /// <summary>Registers new handler which is executed when control property changes its value.</summary>
    /// <param name="handler">Handler to register.</param>

    this.addEventHandler('propertyChanged', handler);
};

Dynamicweb.Ajax.Control.prototype.register = function (params) {
    /// <summary>Registers control on a page.</summary>
    /// <param name="params">Registration parameters.</param>

    this.reset();

    if (params) {
        if (typeof (params.container) != 'undefined') {
            this.set_container(params.container);
        }

        if (typeof (params.associatedControl) != 'undefined') {
            this.set_associatedControlID(params.associatedControl);
        }
    }
};

Dynamicweb.Ajax.Control.prototype.reset = function () {
    /// <summary>Resets control state.</summary>

    this._containerID = '';
    this._container = null;
    this._associatedControlID = null;
    this._isEnabled = true;
    this._tag = '';
    this._binder = null;
    this._state = null;
    this._terminology = null;
    this._postedField = null;

    this._handlers = {
        propertyChanged: []
    };
};

Dynamicweb.Ajax.Control.prototype.initializeComponent = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;

    if (!this._initialized) {
        this._binder = new Dynamicweb.Observable(this);
        this._binder.add_propertyChanged(function (sender, args) {
            self.onPropertyChanged(args);
        });

        this.set_isEnabled(this.get_isEnabled());

        if (typeof (this.initialize) == 'function') {
            this.initialize();
        }

        this._initialized = true;

        Dynamicweb.Ajax.ControlManager.get_current().onControlReady(this);
    }
};

Dynamicweb.Ajax.Control.prototype.onPropertyChanged = function (e) {
    /// <summary>Raises "propertyChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.raiseEvent('propertyChanged', e);
};

Dynamicweb.Ajax.Control.prototype.addEventHandler = function (eventName, handler) {
    /// <summary>Registers a new handler for a given event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="handler">Event handler.</param>

    if (eventName && eventName.length && handler && typeof (handler) == 'function') {
        if (typeof (this._handlers[eventName]) == 'undefined') {
            this._handlers[eventName] = [];
        }

        this._handlers[eventName][this._handlers[eventName].length] = handler;
    }
};

Dynamicweb.Ajax.Control.prototype.removeEventHandler = function (eventName, handler) {
    /// <summary>De-registers a handler for a given event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="handler">Event handler.</param>

    var i, max, handlers;

    if (eventName && eventName.length && handler && typeof (handler) == 'function') {
        if (typeof (this._handlers[eventName]) == 'undefined') {
            return;
        }

        handlers = this._handlers[eventName];
        max = handlers.length;

        for (i = 0; i < max; i += 1) {
            if (handlers[i] === handler) {
                handlers.pop(i);
                break;
            }
        }
    }
};

Dynamicweb.Ajax.Control.prototype.removeEventHandler = function (eventName, handler) {
    /// <summary>De-registers a handler for a given event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="handler">Event handler.</param>

    var i, max, handlers;

    if (eventName && eventName.length && handler && typeof (handler) == 'function') {
        if (typeof (this._handlers[eventName]) == 'undefined') {
            return;
        }

        handlers = this._handlers[eventName];
        max = handlers.length;

        for (i = 0; i < max; i += 1) {
            if (handlers[i] === handler) {
                handlers.pop(i);
                break;
            }
        }
    }
}

Dynamicweb.Ajax.Control.prototype.raiseEvent = function (eventName, args) {
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
                    if (typeof (callbackException.message) != 'undefined') {
                        Dynamicweb.Ajax.Control.error(callbackException.message);
                    } else {
                        Dynamicweb.Ajax.Control.error(callbackException.toString());
                    }
                }
            }
        }
    }
};

Dynamicweb.Ajax.ControlManager = function () {
    /// <summary>Represents a control manager.</summary>

    if (Dynamicweb.Ajax.ControlManager._instante) {
        Dynamicweb.Ajax.error('Only one instance of control manager is allowed. Use "Dynamicweb.Ajax.ControlManager.get_current" to get the current instance.');
    }

    this._initialized = false;
    this._idCounter = {};

    this._callbacks = {
        contentReady: [],
        controlReady: [function (sender, args) {
            var id = args.get_associatedControlID().toLowerCase(),
                self = arguments.callee,
                controls = self['controls'],
                control, i, len;

            if (!controls) {
                return;
            }

            control = controls[id];

            if (!control || !control.callbacks) {
                return;
            }

            control.self = args;
            control.isReady = true;
            len = control.callbacks.length;

            for (i = 0; i < len; i += 1) {
                control.callbacks[i].call(this, args);
            }
        }]
    }
};

Dynamicweb.Ajax.ControlManager._instante = null;

Dynamicweb.Ajax.ControlManager.get_current = function () {
    /// <summary>Gets the current instance of the control manager.</summary>

    if (!Dynamicweb.Ajax.ControlManager._instante) {
        Dynamicweb.Ajax.ControlManager._instante = new Dynamicweb.Ajax.ControlManager();
    }

    return Dynamicweb.Ajax.ControlManager._instante;
};

Dynamicweb.Ajax.ControlManager.prototype.add_contentReady = function (callback) {
    /// <summary>Registers a new callback that is fired when the content of the page is ready.</summary>
    /// <param name="callback">Callback to register.</param>

    if (document.loaded) {
        (callback || function () { })(this, {});
    } else {
        this._callbacks.contentReady[this._callbacks.contentReady.length] = (callback || function () { });
    }
};

Dynamicweb.Ajax.ControlManager.prototype.remove_contentReady = function (callback) {
    /// <summary>Deregisters a new callback that is fired when the content of the page is ready.</summary>
    /// <param name="callback">Callback to deregister.</param>

    var newCallbacks = [];

    if (callback) {
        for (var i = 0; i < this._callbacks.contentReady.length; i++) {
            if (this._callbacks.contentReady[i] != callback) {
                newCallbacks[newCallbacks.length] = this._callbacks.contentReady[i];
            }
        }

        this._callbacks.contentReady = newCallbacks;
    }
};

Dynamicweb.Ajax.ControlManager.prototype.add_controlReady = function (id, callback) {
    /// <summary>Registers a new callback that is fired when the control with specified ID is ready.</summary>
    /// <param name="id">Control ID.</param>
    /// <param name="callback">Callback to register.</param>

    var func = this._callbacks.controlReady[0],
        controls = func['controls'];

    id = id.toLowerCase();

    if (!controls) {
        controls = {};
        func['controls'] = controls;
    }

    control = controls[id];

    if (!control) {
        control = {
            callbacks: [],
            isReady: false,
            args: null
        };

        controls[id] = control;
    }

    if (control.isReady) {
        callback.call(this, control.self);
    } else {
        control.callbacks.push(callback);
    }
};

Dynamicweb.Ajax.ControlManager.prototype.remove_controlReady = function (id, callback) {
    /// <summary>Deregisters a new callback that is fired when the control with specified ID is ready.</summary>
    /// <param name="id">Control ID.</param>
    /// <param name="callback">Callback to register.</param>

    var func = this._callbacks.controlReady[0],
        controls = func['controls'],
        newCallbacks = [],
        i, len;

    id = id.toLowerCase();

    if (!controls) {
        return;
    }

    control = controls[id];

    if (!control && !control.callbacks) {
        return;
    }

    len = control.callbacks.length;

    for (i = 0; i < len; i += 1) {
        if (control.callbacks[i] != callback) {
            newCallbacks[newCallbacks.length] = control.callbacks[i];
        }
    }

    control.callbacks = newCallbacks;
};

Dynamicweb.Ajax.ControlManager.prototype.clear_contentReady = function () {
    /// <summary>Deregisters all callbacks that are fired when the content of the page is ready.</summary>

    this._callbacks.contentReady = [];
};

Dynamicweb.Ajax.ControlManager.prototype.onContentReady = function (args) {
    /// <summary>Raises "contentReady" event.</summary>
    /// <param name="args">Event arguments.</param>

    this.notify('contentReady', args);
};

Dynamicweb.Ajax.ControlManager.prototype.onControlReady = function (args) {
    /// <summary>Raises "controlReady" event.</summary>
    /// <param name="args">Event arguments.</param>

    this.notify('controlReady', args);
};

Dynamicweb.Ajax.ControlManager.prototype.generateControlID = function (prefix) {
    /// <summary>Generates a unique identifier for the given control.</summary>
    /// <param name="prefix">Identifier prefix.</param>

    var ret = '';

    prefix = (prefix && prefix.length) ? prefix : 'control';

    if (typeof (this._idCounter[prefix]) != 'number') {
        this._idCounter[prefix] = 0;
    }

    ret = prefix + '_' + this._idCounter[prefix];
    this._idCounter[prefix] += 1;

    return ret;
};

Dynamicweb.Ajax.ControlManager.prototype.notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];
    var callbackException = null;

    if (eventName && eventName.length) {
        callbacks = this._callbacks[eventName];

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
                    if (typeof (callbackException.message) != 'undefined') {
                        Dynamicweb.Ajax.error(callbackException.message);
                    } else {
                        Dynamicweb.Ajax.error(callbackException.toString());
                    }
                }
            }
        }
    }
};

Dynamicweb.Ajax.ControlManager.prototype.initialize = function () {
    /// <summary>Initializes the control manager.</summary>

    var self = this;

    if (!this._initialized) {
        Dynamicweb.Ajax.Document.get_current().subscribe(document, 'ready', function () {
            self.onContentReady({});
            self.clear_contentReady();
        });

        this._initialized = true;
    }
};

Dynamicweb.Ajax.ControlManager.prototype.findControl = function (id) {
    /// <summary>Finds control by its Id.</summary>
    /// <param name="id">Full or partial control Id.</param>

    var ret = null;
    var instance = '';
    var controls = null;

    if (id && id.length) {
        controls = Dynamicweb.Ajax.Document.get_current().getElementsBySelector('.ajax-rich-control');

        if (controls && controls.length) {
            for (var i = 0; i < controls.length; i++) {
                instance = Dynamicweb.Ajax.Document.get_current().attribute(controls[i], 'data-control-instance');
                if (instance && instance.length && (instance.toLowerCase() == id.toLowerCase() || instance.indexOf(id + '_') == 0)) {
                    try {
                        ret = eval(instance);
                    } catch (ex) { }

                    break;
                }
            }
        }
    }

    return ret;
};

/* Initializing the control */
Dynamicweb.Ajax.ControlManager.get_current().initialize();

Dynamicweb.Ajax.ResourceLoader = function () {
    /// <summary>Represents a resource loader for asynchronously rendered controls.</summary>

    this._cache = [];
};

Dynamicweb.Ajax.ResourceLoader._instance = null;

Dynamicweb.Ajax.ResourceLoader.get_current = function () {
    /// <summary>Gets the current instance of the resource loader.</summary>
    /// <returns>The current instnace of the resource loader.</returns>

    if (Dynamicweb.Ajax.ResourceLoader._instance == null) {
        Dynamicweb.Ajax.ResourceLoader._instance = new Dynamicweb.Ajax.ResourceLoader();
    }

    return Dynamicweb.Ajax.ResourceLoader._instance;
}

Dynamicweb.Ajax.ResourceLoader.prototype.remove = function (content, onlyScripts) {
    /// <summary>Removes any references to JavaScript/CSS files from the given HTML content.</summary>
    /// <param name="content">HTML content.</param>
    /// <param name="onlyScripts">Value indicating whether to remove only JavaScript content references and leave CSS references untouched.</param>
    /// <returns>HTML content without any references to JavaScript/CSS files.</returns>

    var ret = '';
    var jsPattern = /<script[^>]+src="(.+?)".+?>/gi;
    var stylePattern = /<link[^>]+href="(.+)"+\s\/>/gi;

    if (content && content.length) {
        ret = content;

        ret = ret.replace(jsPattern, '');

        if (!onlyScripts) {
            ret = ret.replace(stylePattern, '');
        }
    }

    return ret;
};

Dynamicweb.Ajax.ResourceLoader.prototype.parse = function (content) {
    /// <summary>Parses resource objects from the given HTML content.</summary>
    /// <param name="content">HTML content.</param>
    /// <returns>A list of resource objects.</returns>

    var ret = [];
    var js = null, style = null;
    var jsPattern = /<script[^>]+src="(.+?)".+?>/gi;
    var stylePattern = /<link[^>]+href="(.+)"+\s\/>/gi;

    if (content) {
        while ((style = stylePattern.exec(content)) != null) {
            ret.push({ url: style[1], type: 'css' });
        }

        while ((js = jsPattern.exec(content)) != null) {
            ret.push({ url: js[1], type: 'js' });
        }
    }

    return ret;
}

Dynamicweb.Ajax.ResourceLoader.prototype.load = function (resources, onComplete) {
    /// <summary>Asynchronously embeds given resources into the page.</summary>
    /// <param name="resources">An array of resource objects.</param>
    /// <param name="onComplete">Function to be called when all resources are loaded.</param>

    onComplete = onComplete || function () { }

    var self = this;
    var styles = [];
    var scripts = [];

    if (resources) {
        for (var i = 0; i < resources.length; i++) {
            if (resources[i].type == 'css') {
                styles.push(resources[i].url);
            } else if (resources[i].type == 'js') {
                scripts.push(resources[i].url);
            }
        }

        self._loadInner(styles, 'css', function () {
            self._loadInner(scripts, 'js', function () {
                setTimeout(function () {
                    onComplete();
                }, 100);
            });
        });
    }
}

Dynamicweb.Ajax.ResourceLoader.prototype._loadInner = function (resources, type, onComplete) {
    /// <summary>Asynchronously embeds given resources into the page.</summary>
    /// <param name="resources">An array of resource URLs.</param>
    /// <param name="type">Content type of each resource.</param>
    /// <param name="onComplete">Function to be called when all resources are loaded.</param>
    /// <private />

    var head = null;
    var self = this;
    var queue = null;
    var newResources = [];

    onComplete = onComplete || function () { }

    if ((type == 'css' && Dynamicweb.Ajax.Document.get_current().get_viewEngine() != 'ie') || (!resources || !resources.length)) {
        onComplete();
    } else {
        for (var i = 0; i < resources.length; i++) {
            if (!this._isLoaded(resources[i])) {
                newResources.push(resources[i]);
            }
        }

        if (newResources.length) {
            head = document.getElementsByTagName('head')[0];

            queue = new Dynamicweb.Utilities.RequestQueue();

            for (var i = 0; i < newResources.length; i++) {
                queue.add(this, self._fetch, [newResources[i], type, function (url, content) {
                    var resourceNode = null;

                    if (url) {
                        if (content) {
                            if (type == 'js') {
                                resourceNode = Dynamicweb.Ajax.Document.get_current().createElement('script', { 'type': 'text/javascript' });
                                resourceNode.appendChild(document.createTextNode(content));
                            } else if (type == 'css') {
                                resourceNode = Dynamicweb.Ajax.Document.get_current().createElement('style', { 'type': 'text/css' });

                                if (resourceNode.styleSheet) {
                                    resourceNode.styleSheet.cssText = content;
                                } else {
                                    resourceNode.appendChild(document.createTextNode(content));
                                }
                            }

                            head.appendChild(resourceNode);
                        }

                        if (!self._cache) {
                            self._cache = [];
                        }

                        self._cache.push(url.toLowerCase());
                    }

                    if (!queue.next()) {
                        onComplete();
                    }
                }]);
            }

            queue.executeAll();
        } else {
            onComplete();
        }
    }
}

Dynamicweb.Ajax.ResourceLoader.prototype._fetch = function (url, type, onComplete) {
    /// <summary>Loads contents of the given file via AJAX request.</summary>
    /// <param name="url">URL of the file.</param>
    /// <param name="type">Content type.</param>
    /// <param name="onComplete">Function to be called when file is loaded.</param>
    /// <private />

    var elm = null;
    var head = null;

    onComplete = onComplete || function () { }

    if (url) {
        if (!this._isLoaded(url)) {
            if (Dynamicweb.Ajax.Document.get_current().get_viewEngine() == 'ie') {
                head = document.getElementsByTagName('head')[0];

                if (head) {
                    if (type == 'css') {
                        elm = Dynamicweb.Ajax.Document.get_current().createElement('link', { 'rel': 'stylesheet', 'type': 'text/css', 'href': url });
                    } else if (type == 'js') {
                        elm = Dynamicweb.Ajax.Document.get_current().createElement('script', { 'type': 'text/javascript', 'src': url });
                    }

                    if (elm) {
                        var re = new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})");

                        if (re.exec(navigator.userAgent) != null)
                            onComplete(url, '');
                        else {
                            elm.onreadystatechange = function () {
                                if (this.readyState == 'complete' || this.readyState == 'loaded')
                                    onComplete(url, '');
                            }
                        }
                    }

                    head.appendChild(elm);
                }
            } else {
                Dynamicweb.Ajax.Document.get_current().createRequest(url, {
                    method: 'get',
                    onComplete: function (transport) { onComplete(url, transport.responseText); },
                    onError: function (transport) { onComplete(url, ''); }
                });
            }
        } else {
            onComplete('', '');
        }
    } else {
        onComplete(url, '');
    }
}

Dynamicweb.Ajax.ResourceLoader.prototype._isLoaded = function (resource) {
    /// <summary>Determines whether specified resource already embedded into the page.</summary>
    /// <param name="resource">Resource to check for.</param>
    /// <returns>Value indicating whether specified resource already embedded into the page.</returns>
    /// <private />

    var ret = false;

    if (resource) {
        if (this._cache && this._cache.length) {
            resource = resource.toLowerCase();

            for (var i = 0; i < this._cache.length; i++) {
                if (this._cache[i] == resource) {
                    ret = true;
                    break;
                }
            }
        }
    } else {
        ret = true;
    }

    return ret;
}

Dynamicweb.Ajax.DataLoader = function () {
    /// <summary>Represents a data loader.</summary>
}

Dynamicweb.Ajax.DataLoader._dataCallbacks = new Dynamicweb.Ajax.Hash();

Dynamicweb.Ajax.DataLoader.load = function (params) {
    /// <summary>Performs asynchronous operation of loading data from the server.</summary>
    /// <param name="params">Load parameters.</param>
    /// <remarks></remarks>

    var ticket = '';
    var requestParams = {};

    params = params || {};

    if (params.target && params.onComplete) {
        ticket = Dynamicweb.Ajax.DataLoader.registerDataCallback(params.onComplete, params.onError);

        if (ticket) {
            requestParams.DataCallbackTicket = ticket;
            if (params.parameters) {
                for (var prop in params.parameters) {
                    if (typeof (prop) != 'function') {
                        requestParams[prop] = params.parameters[prop];
                    }
                }
            }

            if (params.plainText) {
                requestParams['DataCallbackIsTextual'] = 'True';
            }

            Dynamicweb.Ajax.doPostBack({
                url: params.url || '',
                eventTarget: params.target,
                eventArgument: params.argument || '',
                parameters: requestParams,
                explicitMode: true,
                onComplete: function (transport, requestObject) {
                    var responseContentType = null;
                    if (requestObject && requestObject.getResponseHeader) {
                        responseContentType = requestObject.getResponseHeader("Content-Type");
                    } else if (requestObject && requestObject.getHeader) {
                        responseContentType = requestObject.getHeader("Content-Type");
                    }
                    responseContentType = responseContentType || "";
                    if (params.plainText || responseContentType.length && responseContentType.toLowerCase().indexOf('text/plain') >= 0) {
                        Dynamicweb.Ajax.DataLoader.dispatchResults(ticket, transport.responseText, { plainText: true });
                    }

                    // The JavaScript content will be avaluated automatically sinte it's type is "application/javascript".
                }
            });
        }
    }
}

Dynamicweb.Ajax.DataLoader.registerDataCallback = function (onComplete, onError) {
    /// <summary>Registers new data callbacks that is executed when data arrives from the server.</summary>
    /// <param name="onComplete">Callback that is executed on successfull transfer.</param>
    /// <param name="onError">Callback that is executed on error.</param>
    /// <returns>Callback ticket.</returns>

    var ret = Math.random().toString(16).slice(2);

    Dynamicweb.Ajax.DataLoader._dataCallbacks.set(ret, { onComplete: onComplete, onError: onError });

    return ret;
}

Dynamicweb.Ajax.DataLoader.dispatchResults = function (ticket, results, params) {
    /// <summary>Serves results that are arrived from the server.</summary>
    /// <param name="ticket">Callback ticket.</param>
    /// <param name="results">Data results.</param>
    /// <param name="params">Additional response parameters.</param>

    var exception = null;
    var callback = Dynamicweb.Ajax.DataLoader._dataCallbacks.get(ticket);

    if (!params) {
        params = {};
    }

    if (callback && callback.onComplete) {
        try {
            callback.onComplete(results, params);
        } catch (ex) { exception = ex; }

        Dynamicweb.Ajax.DataLoader._dataCallbacks.unset(ticket);

        if (exception) {
            Dynamicweb.Ajax.error(exception.message);
        }
    }
}

Dynamicweb.Ajax.DataLoader.dispatchError = function (ticket, errorObject) {
    /// <summary>Notifies about server exception.</summary>
    /// <param name="ticket">Callback ticket.</param>
    /// <param name="errorObject">Object that contains error information.</param>

    var callback = Dynamicweb.Ajax.DataLoader._dataCallbacks.get(ticket);

    if (callback && callback.onError) {
        try {
            callback.onError(errorObject);
        } catch (ex) { }

        Dynamicweb.Ajax.DataLoader._dataCallbacks.unset(ticket);
    }
}

/* Stores event handlers associated with 'beforeRequest' event. */
Dynamicweb.Ajax._beforeRequest = [];

/* Provides data for 'beforeRequest' event. */
Dynamicweb.Ajax.BeforeRequestArgs = function (eventTarget, eventArgument, parameters) {
    this._eventTarget = eventTarget;
    this._eventArgument = eventArgument;
    this._parameters = parameters;
}

/* Gets event target. */
Dynamicweb.Ajax.BeforeRequestArgs.prototype.get_eventTarget = function () {
    return this._eventTarget;
}

/* Gets event argument. */
Dynamicweb.Ajax.BeforeRequestArgs.prototype.get_eventArgument = function () {
    return this._eventArgument;
}

/* Gets request parameters. */
Dynamicweb.Ajax.BeforeRequestArgs.prototype.get_parameters = function () {
    return this._parameters;
}

/* Retrieves a JSON object from the server */
Dynamicweb.Ajax.getObject = function (url, params) {
    var callback = null;

    if (!params) {
        params = {};
    }

    callback = params.onComplete || function () { };

    if (url) {
        Dynamicweb.Ajax.Document.get_current().createRequest(url, {
            method: 'get',
            onComplete: function (transport) {
                var json = null;

                if (transport && transport.responseText) {
                    try {
                        json = transport.responseText.evalJSON();
                    } catch (ex) { json = null; }
                }

                callback(json);
            }
        });
    } else {
        Dynamicweb.Ajax.error('The request can not be performed: Target URL is not specified.');
    }
}

/* Holds the current control ticket */
Dynamicweb.Ajax._currentControlTicket = null;

Dynamicweb.Ajax.get_currentControlTicket = function () {
    /// <summary>Gets the current control ticket.</summary>

    return Dynamicweb.Ajax._currentControlTicket;
}

Dynamicweb.Ajax.renderControl = function (ticket, params) {
    /// <summary>Renders specified control asynchronously.</summary>
    /// <param name="ticket">Control ticket.</param>
    /// <param name="params">Rendering parameters.</param>

    var c = null;
    var url = '';
    var scripts = [];
    var rendered = null;
    var container = null;
    var onComplete = null;
    var onAfterLoad = null;
    var onBeforeLoad = null;
    var onAfterRender = null;
    var onBeforeRender = null;
    var getLoadedComponents = null;
    var onAfterLoadResources = null;
    var onBeforeLoadResources = null;

    if (!params) params = {};

    container = params.container;
    url = params.url || Dynamicweb.Ajax.getHref();

    /* Event handlers */
    onComplete = params.onComplete || function () { }
    onAfterLoad = params.onAfterLoad || function () { }
    onBeforeLoad = params.onBeforeLoad || function () { }
    onAfterRender = params.onAfterRender || function () { }
    onBeforeRender = params.onBeforeRender || function () { }
    onAfterLoadResources = params.onAfterLoadResources || function () { }
    onBeforeLoadResources = params.onBeforeLoadResources || function () { }

    /* Returns a comma-separated list of all loaded components */
    getLoadedComponents = function () {
        var result = '';
        var loadedComponents = [];

        loadedComponents[loadedComponents.length] = 'ajax';
        loadedComponents[loadedComponents.length] = 'uistyles';

        if (typeof (Prototype) != 'undefined') loadedComponents[loadedComponents.length] = 'prototype';
        if (typeof (jQuery) != 'undefined') loadedComponents[loadedComponents.length] = 'jquery';
        if (typeof (Dynamicweb.Observable) != 'undefined') loadedComponents[loadedComponents.length] = 'observable';
        if (typeof (Dynamicweb.Utilities) != 'undefined') loadedComponents[loadedComponents.length] = 'utilities';

        for (var i = 0; i < loadedComponents.length; i++) {
            result += loadedComponents[i];
            if (i < (loadedComponents.length - 1)) {
                result += ',';
            }
        }

        return result;
    }

    /* Occurs when all control resources are loaded */
    rendered = function (content) {
        try {
            /* Extracting all scripts from the content */
            scripts = Dynamicweb.Ajax.Document.get_current().extractScripts(content);

            for (var i = 0; i < scripts.length; i++) {
                if (scripts[i] && scripts[i].length) {
                    /* Executing script in the global scope */
                    if (window.execScript) {
                        ret = window.execScript(scripts[i]);
                    } else {
                        ret = window.eval(scripts[i]);
                    }
                }
            }
        } catch (ex) {
            Dynamicweb.Ajax.error(ex);
        }

        /* Firing "afterLoadResources" event */
        onAfterLoadResources();

        /* Manually notifying controls that the content is ready */
        Dynamicweb.Ajax.ControlManager.get_current().onContentReady();
        Dynamicweb.Ajax.ControlManager.get_current().clear_contentReady();

        /* Displaying the container */
        if (c) c.style.display = '';

        Dynamicweb.Ajax._currentControlTicket = '';

        onComplete(container, content);
    }

    if (ticket && container) {
        Dynamicweb.Ajax._currentControlTicket = ticket;

        if (typeof (container) == 'string') {
            c = Dynamicweb.Ajax.Document.get_current().extend(Dynamicweb.Ajax.Document.get_current().getElementById(container));
        } else {
            c = Dynamicweb.Ajax.Document.get_current().extend(container);
        }

        if (c) {
            /* Hiding the container */
            c.innerHTML = '';
            c.style.display = 'none';

            /* Specifying control ticket via URL */
            url += ((url.indexOf('?') > 0 ? '&' : '?') + 'RenderControlTicket=' + ticket);
            url += ('&RenderControlExcludes=' + getLoadedComponents());

            /* Firing "beforeLoad" event */
            onBeforeLoad();

            Dynamicweb.Ajax.Document.get_current().createRequest(url, {
                method: 'get',
                onComplete: function (transport) {
                    /* Firing "afterLoad" event */
                    onAfterLoad();

                    /* Firing "afterLoad" event */
                    onBeforeRender();

                    /* 
                    Setting content HTML:
                    1. Removing references to JavaScript/CSS files (will be loaded by resource loader). CSS references needs to be preserved for non-IE browsers.
                    2. Removing any SCRIPT blocks (scripts will be evaluated when all dependencies are satisfied - after all external resources are loaded).
                    */

                    c.innerHTML = Dynamicweb.Ajax.Document.get_current().stripScripts(Dynamicweb.Ajax.ResourceLoader.get_current().remove(transport.responseText,
                        Dynamicweb.Ajax.Document.get_current().get_viewEngine() != 'ie'));

                    /* Firing "afterRender" event */
                    onAfterRender();

                    /* Firing "beforeLoadResources" event */
                    onBeforeLoadResources();

                    /* Loading control resources */
                    Dynamicweb.Ajax.ResourceLoader.get_current().load(Dynamicweb.Ajax.ResourceLoader.get_current().parse(transport.responseText),
                        function () { rendered(transport.responseText); });
                }
            });
        } else {
            onComplete(container, '');
        }
    } else {
        onComplete(container, '');
    }
}

Dynamicweb.Ajax.htmlEncode = function (html) {
    /// <summary>HTML encodes the given string.</summary>
    /// <param name="html">String to encode.</param>

    var ret = html || '';

    ret = ret.replace(/&/g, '&amp;');
    ret = ret.replace(/</g, '&lt;');
    ret = ret.replace(/>/g, '&gt;');
    ret = ret.replace(/"/g, '&quot;');

    return ret;
}

Dynamicweb.Ajax.htmlDecode = function (html) {
    /// <summary>HTML encodes the given string.</summary>
    /// <param name="html">String to encode.</param>

    var ret = html || '';

    ret = ret.replace(/&lt;/g, '<');
    ret = ret.replace(/&gt;/g, '>');
    ret = ret.replace(/&amp;/g, '&');
    ret = ret.replace(/&quot;/g, '"');

    return ret;
}

/* Posts back the current form */
Dynamicweb.Ajax.doPostBack = function (params) {
    var url = '';
    var data = null;
    var form = null;
    var args = null;
    var filters = {};
    var requestObject = null;
    var onComplete = function () { }
    var hasWaterMarks = (typeof (WaterMark) != 'undefined');

    if (!params)
        params = {}

    if (params.filters) {
        filters = params.filters;
    }

    if (document.forms.length == 0) {
        Dynamicweb.Ajax.error('The postback call can not be performed: page does not contain any forms.');
    } else {
        form = Dynamicweb.Ajax.Document.get_current().extend(document.forms[0]);

        if (hasWaterMarks) {
            WaterMark.hideAll();
        }

        if (params.explicitMode) {
            data = new Dynamicweb.Ajax.Hash();
        } else {
            data = Dynamicweb.Ajax._filterPostData(form, new Dynamicweb.Ajax.Hash(Dynamicweb.Ajax.Document.get_current().serializeForm(form)), filters.field);
        }

        if (hasWaterMarks) WaterMark.showAll();
        if (params.eventTarget != null) data.set('__EVENTTARGET', params.eventTarget);
        if (params.eventArgument != null) data.set('__EVENTARGUMENT', params.eventArgument);
        if (params.parameters != null) data = data.merge(params.parameters);
        if (params.onComplete != null) onComplete = params.onComplete;

        args = new Dynamicweb.Ajax.BeforeRequestArgs(params.eventTarget, params.eventArgument, data);

        Dynamicweb.Ajax._notify('beforeRequest', args);

        data = args.get_parameters();

        if (params.url && params.url.length) {
            url = params.url;
        } else {
            url = Dynamicweb.Ajax.getHref();
        }

        requestObject = Dynamicweb.Ajax.Document.get_current().createRequest(url, {
            method: 'post',
            parameters: data,
            onComplete: function (transport) { onComplete(transport, requestObject); }
        });
    }
}

/* Registers new event handler for 'beforeRequest' event */
Dynamicweb.Ajax.add_beforeRequest = function (callback) {
    if (!Dynamicweb.Ajax._beforeRequest) {
        Dynamicweb.Ajax._beforeRequest = [];
    }

    Dynamicweb.Ajax._beforeRequest[Dynamicweb.Ajax._beforeRequest.length] = callback;
}

/* Retrieves the URI of the current page */
Dynamicweb.Ajax.getHref = function () {
    var ret = location.href;
    var hashIndex = ret.indexOf('#');

    if (hashIndex >= 0)
        ret = ret.substring(0, hashIndex);

    var questionIndex = ret.indexOf('?');
    if (questionIndex > 0) {
        ret = ret + '&';
    }
    else {
        ret = ret + '?';
    }

    ret = ret + 'timestamp=' + (new Date()).getTime();

    return ret;
}

/* Notifies the client about an error  */
Dynamicweb.Ajax.error = function (message) {
    var er = null;

    if (typeof (Error) != 'undefined') {
        alert(message);
        er = new Error();
        alert(er.stack);
        return;


        //er.message = message;
        //er.description = message;

        //throw (er);

    } else {
        throw (message);
    }
}

/* Notifies clients about specified event. */
Dynamicweb.Ajax._notify = function (eventName, args) {
    if (eventName == 'beforeRequest') {
        Dynamicweb.Ajax._evaluate(Dynamicweb.Ajax._beforeRequest, args);
    }
}

/* Evaluates a set of callback functions */
Dynamicweb.Ajax._evaluate = function (callbacks, args) {
    if (callbacks && callbacks.length > 0) {
        for (var i = 0; i < callbacks.length; i++) {
            if (typeof (callbacks[i]) != 'undefined') {
                callbacks[i](this, args);
            }
        }
    }
}

/* Filters post collection of the specified form by removing elements that don't need to be posted (buttons) */
Dynamicweb.Ajax._filterPostData = function (form, data, filter) {
    var keys = [];
    var ret = null;
    var elements = null;
    var selectors = ['input[type="submit"]', 'button', 'input[type="image"]'];

    if (form && data) {
        ret = data;

        for (var i = 0; i < selectors.length; i++) {
            ret = Dynamicweb.Ajax._removeFormElements(Dynamicweb.Ajax.Document.get_current().getElementsBySelector(selectors[i], form), ret);
        }
    }

    if (ret && filter) {
        keys = ret.keys();
        for (var i = 0; i < keys.length; i++) {
            elements = document.getElementsByName(keys[i]);
            if (elements && elements.length) {
                if (!filter(elements[0])) {
                    ret.unset(keys[i]);
                }
            }
        }
    }

    return ret;
}

/* Removes specified elements' entries from the post collection */
Dynamicweb.Ajax._removeFormElements = function (elements, data) {
    var ret = null;
    var identity = '';

    if (data) {
        ret = data;

        if (elements && elements.length > 0) {
            for (var i = 0; i < elements.length; i++) {
                identity = Dynamicweb.Ajax.Document.get_current().attribute(elements[i], 'name');

                if (identity && identity.length > 0) {
                    ret.unset(identity);
                }
            }
        }
    }

    return ret;
}