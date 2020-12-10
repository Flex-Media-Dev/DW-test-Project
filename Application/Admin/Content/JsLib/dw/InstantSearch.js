/* ++++++ Registering namespace ++++++ */

if (typeof (Dynamicweb) == 'undefined') {
	var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Frontend) == 'undefined') {
	Dynamicweb.Frontend = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

/* ++++++ Supply functionality +++++++ */

Dynamicweb.Frontend.Hashtable = function () {
	/// <summary>Represents a hashtable.</summary>

	this._data = {};
}

Dynamicweb.Frontend.Hashtable.prototype.get_data = function () {
	/// <summary>Gets the underlying data object.</summary>

	return this._data;
}

Dynamicweb.Frontend.Hashtable.prototype.get = function (name) {
	/// <summary>Gets the value of the item with the given name.</summary>
	/// <param name="name">Name of the item.</param>

	return this._data[name];
}

Dynamicweb.Frontend.Hashtable.prototype.contains = function (name) {
	/// <summary>Determines whether specified item exists within the hashtable.</summary>
	/// <param name="name">Name of the item.</param>

	var item = null;
	var ret = false;

	if (name) {
		item = this.get(name);
		ret = item != null;
		if (ret && typeof (item.toLowerCase) != 'undefined') {
			ret = item.length > 0;
		}
	}

	return ret;
}

Dynamicweb.Frontend.Hashtable.prototype.set = function (name, value) {
	/// <summary>Sets the given value for the item with the given name.</summary>
	/// <param name="name">Name of the item.</param>
	/// <param name="value">Item value.</param>

	this._data[name] = value;
}

Dynamicweb.Frontend.Hashtable.prototype.merge = function (another) {
	/// <summary>Merges contents of the current object with contents from another object.</summary>
	/// <param name="another">Another object.</param>

	var data = null;

	if (another) {
		if (typeof (another.get_data) == 'function') {
			data = another.get_data();
		} else {
			data = another;
		}

		for (var name in another) {
			if (typeof (another[name]) != 'function' && !this._data[name]) {
				this.set(name, another[name]);
			}
		}
	}
}

Dynamicweb.Frontend.Document = function () {
	/// <summary>Provides methods and properties to interact with the current DOM document object.</summary>
}

Dynamicweb.Frontend.Document.Current = new Dynamicweb.Frontend.Document();

Dynamicweb.Frontend.Document._offset = function () {
	/// <private />
	/// <summary>Supply functionality for computing element offsets.</summary>
	/// <remarks>Implementation is taken from the jQuery project code.</remarks>
}

Dynamicweb.Frontend.Document._offset.initialize = function () {
	/// <summary>Initializes offset.</summary>

	var body = document.body;
	var container = document.createElement('div');
	var boxContainer = document.createElement('div');
	var innerDiv = null, checkDiv = null, table = null, td = null;
	var bodyMarginTop = parseFloat(jQuery.css(body, 'marginTop')) || 0;
	var html = '<div style="position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;"><div></div></div>' +
			'<table style="position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;" cellpadding="0" cellspacing="0"><tr><td></td></tr></table>';

	Dynamicweb.Frontend.Document.Current.style(container, {
		position: 'absolute',
		top: '0px',
		left: '0px',
		margin: '0px',
		border: '0px',
		width: '1px',
		height: '1px',
		visibility: 'hidden'
	});

	container.innerHTML = html;

	boxContainer.style.width = boxContainer.style.paddingLeft = '1px';

	body.appendChild(boxContainer);
	body.insertBefore(container, body.firstChild);

	Dynamicweb.Frontend.Document._offset.boxModel = (boxContainer.offsetWidth === 2);

	innerDiv = container.firstChild;
	checkDiv = innerDiv.firstChild;
	td = innerDiv.nextSibling.firstChild.firstChild;

	Dynamicweb.Frontend.Document._offset.doesNotAddBorder = (checkDiv.offsetTop !== 5);
	Dynamicweb.Frontend.Document._offset.doesAddBorderForTableAndCells = (td.offsetTop === 5);

	checkDiv.style.position = 'fixed';
	checkDiv.style.top = '20px';

	Dynamicweb.Frontend.Document._offset.supportsFixedPosition = (checkDiv.offsetTop === 20 || checkDiv.offsetTop === 15);
	checkDiv.style.position = checkDiv.style.top = '';

	innerDiv.style.overflow = 'hidden';
	innerDiv.style.position = 'relative';

	Dynamicweb.Frontend.Document._offset.subtractsBorderForOverflowNotVisible = (checkDiv.offsetTop === -5);
	Dynamicweb.Frontend.Document._offset.doesNotIncludeMarginInBodyOffset = (body.offsetTop !== bodyMarginTop);

	body.removeChild(container);
	body.removeChild(boxContainer);
	body = container = innerDiv = checkDiv = table = td = null;

	Dynamicweb.Frontend.Document._offset.initialize = function () { };
}

Dynamicweb.Frontend.Document._offset.getWindow = function (doc) {
	/// <summary>Gets the hosting window object of the specified document.</summary>
	/// <param name="doc">Document object.</param>

	var ret = null;

	if (doc) {
		if (typeof (doc.setInterval) != 'undefined') {
			ret = doc;
		} else if (doc.nodeType == 9) {
			ret = doc.defaultView || doc.parentWindow;
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document._offset.offset = function (elm) {
	/// <summary>Computes offset for a given element.</summary>
	/// <param name="elm">Element to compute offset for.</param>

	var box = null;
	var elem = elm;
	var ret = { top: 0, left: 0 };
	var doc = null, docElem = null;
	var rtable = /^t(?:able|d|h)$/i;
	var scrollTop = null, scrollLeft = null;
	var defaultView = null, prevComputedStyle = null;
	var body = null, win = null, clientTop = null, clientLeft = null;
	var offsetParent = null, prevOffsetParent = null, computedStyle = null;

	if ('getBoundingClientRect' in document.documentElement) {
		if (elem && elem !== elem.ownerDocument.body) {
			try {
				box = elem.getBoundingClientRect();
			} catch (e) { }

			doc = elem.ownerDocument;
			docElem = doc.documentElement;

			body = doc.body;
			win = Dynamicweb.Frontend.Document._offset.getWindow(doc);

			clientTop = docElem.clientTop || body.clientTop || 0;
			clientLeft = docElem.clientLeft || body.clientLeft || 0;
			scrollTop = (win.pageYOffset || Dynamicweb.Frontend.Document._offset.boxModel && docElem.scrollTop || body.scrollTop);
			scrollLeft = (win.pageXOffset || Dynamicweb.Frontend.Document._offset.boxModel && docElem.scrollLeft || body.scrollLeft);
			ret.top = box.top + scrollTop - clientTop;
			ret.left = box.left + scrollLeft - clientLeft;
		}
	} else {
		Dynamicweb.Frontend.Document._offset.initialize();

		offsetParent = elem.offsetParent, prevOffsetParent = elem;
		doc = elem.ownerDocument, computedStyle, docElem = doc.documentElement;
		body = doc.body, defaultView = doc.defaultView;
		prevComputedStyle = defaultView ? defaultView.getComputedStyle(elem, null) : elem.currentStyle;
		ret.top = elem.offsetTop, ret.left = elem.offsetLeft;

		while ((elem = elem.parentNode) && elem !== body && elem !== docElem) {
			if (Dynamicweb.Frontend.Document._offset.supportsFixedPosition && prevComputedStyle.position === 'fixed') {
				break;
			}

			computedStyle = defaultView ? defaultView.getComputedStyle(elem, null) : elem.currentStyle;
			ret.top -= elem.scrollTop;
			ret.left -= elem.scrollLeft;

			if (elem === offsetParent) {
				ret.top += elem.offsetTop;
				ret.left += elem.offsetLeft;

				if (Dynamicweb.Frontend.Document._offset.doesNotAddBorder &&
										!(Dynamicweb.Frontend.Document._offset.doesAddBorderForTableAndCells && rtable.test(elem.nodeName))) {

					ret.top += parseFloat(computedStyle.borderTopWidth) || 0;
					ret.left += parseFloat(computedStyle.borderLeftWidth) || 0;
				}

				prevOffsetParent = offsetParent;
				offsetParent = elem.offsetParent;
			}

			if (Dynamicweb.Frontend.Document._offset.subtractsBorderForOverflowNotVisible && computedStyle.overflow !== 'visible') {
				ret.top += parseFloat(computedStyle.borderTopWidth) || 0;
				ret.left += parseFloat(computedStyle.borderLeftWidth) || 0;
			}

			prevComputedStyle = computedStyle;
		}

		if (prevComputedStyle.position === 'relative' || prevComputedStyle.position === 'static') {
			ret.top += body.offsetTop;
			ret.left += body.offsetLeft;
		}

		if (Dynamicweb.Frontend.Document._offset.supportsFixedPosition && prevComputedStyle.position === 'fixed') {
			ret.top += Math.max(docElem.scrollTop, body.scrollTop);
			ret.left += Math.max(docElem.scrollLeft, body.scrollLeft);
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.get_url = function () {
	/// <summary>Gets the current URL.</summary>
	/// <returns>Current URL.</returns>

	var ret = location.href;
	var hashIndex = ret.indexOf('#');

	if (hashIndex >= 0)
		ret = ret.substring(0, hashIndex);

	// Adding a parameter that should prevent the page from being cached
	ret += ((ret.indexOf('?') > 0 ? '&' : '?') + 't=' + (new Date().getTime()));

	return ret;
}

Dynamicweb.Frontend.Document.prototype.get_isIE = function () {
	/// <summary>Gets value indicating whether page is loaded in Microsoft Internet Explorer.</summary>
	/// <returns>Value indicating whether page is loaded in Microsoft Internet Explorer.</returns>

	var ret = false;

	if (typeof (Prototype) != 'undefined') {
		ret = Prototype.Browser.IE;
	} else if (typeof (jQuery) != 'undefined') {
		ret = jQuery.browser.msie;
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.error = function (message) {
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

Dynamicweb.Frontend.Document.prototype.tag = function (elm) {
	/// <summary>Gets the tag name of the given element.</summary>
	/// <param name="elm">Element to examine.</param>

	var ret = '';

	if (elm) {
		if (elm.tagName) {
			ret = elm.tagName;
		} else if (elm.nodeName) {
			ret = elm.nodeName;
		} else if (elm.length && elm.length > 0) {
			ret = this.tag(elm[0]);
		}

		if (ret) {
			ret = ret.toLowerCase();
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.element = function (o) {
	/// <summary>Returns an instance of the extended DOM element either by its ID or by its reference.</summary>
	/// <param name="o">Either an element ID or the reference to an element.</param>

	var ret = null;

	if (typeof (o) == 'string') {
		if (typeof (jQuery) != 'undefined') {
			ret = jQuery('#' + o);
		} else if (typeof (Prototype) != 'undefined') {
			ret = $(o);
		}
	} else {
		if (typeof (jQuery) != 'undefined') {
			ret = jQuery(o);
		} else {
			ret = $(o);
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.id = function (o) {
	/// <summary>Returns an ID of the given element.</summary>
	/// <param name="o">Either an element ID or the reference to an element.</param>

	var ret = null;

	if (typeof (o) == 'string') {
		ret = o;
	} else {
		if (o.id) {
			ret = o.id;
		} else if (o.length && o.length > 0) {
			ret = o[0].id;
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.addClass = function (elm, className) {
	/// <summary>Adds new CSS class to the given element.</summary>
	/// <param name="className">Name of the CSS class.</param>

	elm = this.element(elm);

	if (elm) {
		if (elm.addClassName) {
			elm.addClassName(className);
		} else if (elm.addClass) {
			elm.addClass(className);
		}
	}
}

Dynamicweb.Frontend.Document.prototype.removeClass = function (elm, className) {
	/// <summary>Removes existing CSS class from the given element.</summary>
	/// <param name="className">Name of the CSS class.</param>

	elm = this.element(elm);

	if (elm) {
		if (elm.removeClassName) {
			elm.removeClassName(className);
		} else if (elm.removeClass) {
			elm.removeClass(className);
		}
	}
}

Dynamicweb.Frontend.Document.prototype.hasClass = function (elm, className) {
	/// <summary>Determines whether the given CSS class is defined on a given element.</summary>
	/// <param name="elm">Element.</param>
	/// <param name="className">Name of the CSS class.</param>

	var ret = false;

	elm = this.element(elm);

	if (elm) {
		if (elm.hasClassName) {
			ret = elm.hasClassName(className);
		} else if (elm.hasClass) {
			ret = elm.hasClass(className);
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.attribute = function (elm, name, value) {
	/// <summary>Gets or sets given attribute on a given element.</summary>
	/// <param name="elm">Element to examine.</param>
	/// <param name="name">Attribute name.</param>
	/// <param name="name">Attribute value (can be ommited).</param>

	var ret = '';
	var e = this.element(elm);

	if (name) {
		if (typeof (value) == 'undefined') {
			if (e.attr) {
				ret = e.attr(name);
			} else if (e.readAttribute) {
				ret = e.readAttribute(name);
			} else if (e.getAttribute) {
				ret = e.getAttribute(name);
			}
		} else {
			ret = value;

			if (e.attr) {
				e.attr(name, value);
			} else if (e.writeAttribute) {
				e.writeAttribute(name, value);
			} else if (e.setAttribute) {
				e.setAttribute(name, value);
			}
		}
	}

	if (typeof (ret) == 'undefined') {
		ret = '';
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.offset = function (elm) {
	/// <sumary>Returns cumulative offset for a given element (left, top).</sumary>
	/// <param name="elm">Element to examine.</param>

	var ret = { top: 0, left: 0 };

	elm = this.element(elm);

	if (elm) {
		if (typeof (Prototype) != 'undefined') {
			// Using jQuery implementation for Prototype (there are some problems in its own implementation).
			ret = Dynamicweb.Frontend.Document._offset.offset(elm);
		} else if (elm.offset) {
			ret = elm.offset();
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.width = function (elm) {
	/// <sumary>Gets or sets the width (in pixels) of the given element.</sumary>
	/// <param name="elm">Element to examine.</param>
	/// <param name="value">Width (can be ommited).</param>

	return this.dimension(elm, 'Width', value);
}

Dynamicweb.Frontend.Document.prototype.height = function (elm, value) {
	/// <sumary>Gets or sets the height (in pixels) of the given element.</sumary>
	/// <param name="elm">Element to examine.</param>
	/// <param name="value">Height (can be ommited).</param>

	return this.dimension(elm, 'Height', value);
}

Dynamicweb.Frontend.Document.prototype.dimension = function (elm, dimension, value) {
	/// <sumary>Gets or sets the specified dimension (in pixels) of the given element.</sumary>
	/// <param name="elm">Element to examine.</param>
	/// <param name="dimension">Dimension name.</param>
	/// <param name="value">Dimension value (can be ommited).</param>

	var ret = 0;
	var style = null;
	var domElement = null;

	elm = this.element(elm);
	if (elm) {
		domElement = elm;
		if (elm.length && elm.length > 0) {
			domElement = elm[0];
		}

		if (typeof (value) == 'undefined') {
			ret = domElement['offset' + dimension];
		} else {
			style = new Object();
			style[dimension.toLowerCase()] = parseInt(value) + 'px';

			this.style(domElement, style);
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.select = function (context, selector) {
	/// <sumary>Takes a CSS selector and returns an array of descendants of element that match its.</sumary>
	/// <param name="context">Context node.</param>
	/// <param name="selector">CSS selector.</param>

	var ret = [];

	if (context && selector) {
		if (context.find) {
			ret = context.find(selector);
		} else if (context.select) {
			ret = context.select(selector);
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.next = function (context, selector) {
	/// <sumary>Returns element's following sibling that matches specified CSS selector.</sumary>
	/// <param name="context">Context node.</param>
	/// <param name="selector">CSS selector (optional).</param>

	var ret = null;

	context = this.element(context);

	if (context && context.next) {
		ret = context.next(selector);
		if (ret != null && ret.length && ret.length > 0) {
			ret = ret[0];
		}
	}

	if (ret && typeof (ret.length) != 'undefined' && ret.length == 0) {
		ret = null;
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.previous = function (context, selector) {
	/// <sumary>Returns element's previous sibling that matches specified CSS selector.</sumary>
	/// <param name="context">Context node.</param>
	/// <param name="selector">CSS selector (optional).</param>

	var ret = null;

	context = this.element(context);

	if (context) {
		if (context.prev) {
			ret = context.prev(selector);
		} else if (context.previous) {
			ret = context.previous(selector);
		}

		if (ret != null && ret.length && ret.length > 0) {
			ret = ret[0];
		}
	}

	if (ret && typeof (ret.length) != 'undefined' && ret.length == 0) {
		ret = null;
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.up = function (context, selector, multipleLevels) {
	/// <sumary>Returns element's first ancestor that matches specified CSS selector.</sumary>
	/// <param name="context">Context node.</param>
	/// <param name="selector">CSS selector (optional).</param>
	/// <param name="multipleLevels">Indicates whether to traverse up multiple levels.</param>

	var ret = null;

	context = this.element(context);

	if (context) {
		if (context.is && context.is(selector)) {
			ret = context;
		} else if (context.match && context.match(selector)) {
			ret = context;
		}

		if (!ret) {
			if (context.up) {
				ret = context.up(selector);
			} else if (context.parent) {
				ret = !!multipleLevels ? context.parents(selector) : context.parent(selector);
				if (ret != null && ret.length && ret.length > 0) {
					ret = this.element(ret[0]);
				}
			}
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.down = function (context, selector) {
	/// <sumary>Returns element's first descendant that matches specified CSS selector.</sumary>
	/// <param name="context">Context node.</param>
	/// <param name="selector">CSS selector (optional).</param>

	var ret = null;

	context = this.element(context);

	if (context) {
		if (context.down) {
			ret = context.down(selector);
		} else if (context.children) {
			ret = context.children(selector);
			if (ret != null && ret.length && ret.length > 0) {
				ret = this.element(ret[0]);
			}
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.style = function (elm, properties) {
	/// <sumary>Gets or sets element style(s).</sumary>
	/// <param name="elm">Element ot examine.</param>
	/// <param name="properties">Either a name of the style (to retrieve) or an object containing styles to be set.</param>

	var ret = '';

	elm = this.element(elm);

	if (elm) {
		if (typeof (properties) == 'string') {
			if (elm.getStyle) {
				ret = elm.getStyle(properties);
			} else if (elm.css) {
				ret = elm.css(properties);
			}
		} else {
			if (elm.setStyle) {
				elm.setStyle(properties);
			} else if (elm.css) {
				elm.css(properties);
			}
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.clone = function (elm, deep) {
	/// <sumary>Clones specified element.</sumary>
	/// <param name="elm">Element ot clone.</param>
	/// <param name="deep">Indicates whether deep cloning should be performed.</param>

	var ret = null;

	elm = this.element(elm);
	if (elm) {
		ret = elm.clone(!!deep);
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.append = function (elm, content) {
	/// <sumary>Appends specified content as a child of the given element.</sumary>
	/// <param name="elm">Element ot append content to.</param>
	/// <param name="content">Content to be appended.</param>

	elm = this.element(elm);

	if (elm) {
		if (elm.appendChild) {
			elm.appendChild(content);
		} else if (elm.append) {
			elm.append(content);
		}
	}
}

Dynamicweb.Frontend.Document.prototype.observe = function (elm, eventName, callback) {
	/// <sumary>Registers new event handler for a given event using a given element as a target.</sumary>
	/// <param name="elm">Event target.</param>
	/// <param name="eventName">Event name.</param>
	/// <param name="callback">Event callback.</param>

	if (elm && eventName && callback) {
		if (typeof (Event) != 'undefined' && Event.observe) {
			Event.observe(elm, eventName, callback);
		} else {

			if (!elm.bind) {
				try {
					elm = this.element(elm);
				} catch (ex) { }
			}

			if (elm.bind) {
				elm.bind(eventName, callback);
			}
		}
	}
}

Dynamicweb.Frontend.Document.prototype.stopObserving = function (elm, eventName, callback) {
	/// <sumary>Unregisters specified event handler for a given event using a given element as a target.</sumary>
	/// <param name="elm">Event target.</param>
	/// <param name="eventName">Event name.</param>
	/// <param name="callback">Event callback.</param>

	if (elm && eventName && callback) {
		if (typeof (Event) != 'undefined' && Event.stopObserving) {
			Event.stopObserving(elm, eventName, callback);
		} else {
			if (!elm.unbind) {
				try {
					elm = this.element(elm);
				} catch (ex) { }
			}

			if (elm.unbind) {
				elm.unbind(eventName, callback);
			}
		}
	}
}

Dynamicweb.Frontend.Document.prototype.eventTarget = function (e) {
	/// <sumary>Retrieves event target information from the given event.</sumary>
	/// <param name="e">Event object.</param>

	var ret = null;

	if (e) {
		if (typeof (Event) != 'undefined' && Event.element) {
			ret = Event.element(e);
		} else {
			ret = e.target;
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.stopEvent = function (e) {
	/// <sumaryPrevents the event from bubbling up the DOM tree.</sumary>
	/// <param name="e">Event object.</param>

	if (e) {
		if (typeof (Event) != 'undefined' && Event.stop) {
			Event.stop(e);
		} else if (e.stopPropagation) {
			e.stopPropagation();
		}
	}
}

Dynamicweb.Frontend.Document.prototype.ready = function (callback) {
	/// <summary>Fires when DOM document object is loaded.</summary>
	/// <param name="callback">Function to be called when DOM document object is loaded.</param>

	Dynamicweb.Frontend.InstantSearch._checkFramework();

	if (typeof (Event) != 'undefined' && Event.observe) {
		this.element(document).observe('dom:loaded', callback);
	} else if (this.element(document).ready) {
		this.element(document).ready(callback);
	}
}

Dynamicweb.Frontend.Document.prototype.text = function (elm) {
	/// <summary>Gets inner text for the given element.</summary>
	/// <param name="elm">Element to examine.</param>

	var ret = '';

	if (elm) ret = elm.innerText ? elm.innerText : elm.textContent;
	if (!ret) ret = '';

	return ret;
}


Dynamicweb.Frontend.Document.prototype.html = function (elm, value) {
	/// <summary>Gets or sets inner HTML for the given element.</summary>
	/// <param name="elm">Element to examine.</param>
	/// <param name="value">Inner HTML (can be ommited).</param>

	var ret = '';

	if (elm) {
		if (typeof (jQuery) != 'undefined') {
			if (typeof (value) == 'undefined') {
				ret = this.element(elm).html();
			} else {
				ret = value;
				this.element(elm).html(value);
			}
		} else {
			if (typeof (value) == 'undefined') {
				ret = elm.innerHTML;
			} else {
				ret = value;
				elm.innerHTML = value;
			}
		}
	}

	if (!ret) {
		ret = '';
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.value = function (elm, val) {
	/// <summary>Gets or sets the value of the given element.</summary>
	/// <param name="elm">Element to examine.</param>
	/// <param name="val">Element value.</param>

	var ret = '';
	var tag = '';
	var type = '';
	var selection = [];
	var extended = null;
	var domElement = null;

	if (elm) {
		tag = this.tag(elm);
		extended = this.element(elm);

		if (extended.length && extended.length > 0) {
			domElement = extended[0];
		} else {
			domElement = extended;
		}

		if (typeof (val) == 'undefined') {
			if (tag == 'input') {
				type = this.attribute(domElement, 'type');
				if (type == 'button' || type == 'submit') {
					selection[0] = this.attribute(extended, 'value');
				} else if (type == 'image') {
					selection[0] = this.attribute(extended, 'src');
				} else {
					selection[0] = domElement.value;
				}
			} else if (tag == 'select') {
				if (domElement.options && domElement.options.length > 0) {
					if (domElement.multiple) {
						for (var i = 0; i < domElement.options.length; i++) {
							if (domElement.options[i].selected) {
								selection[selection.length] = domElement.options[i].value;
							}
						}
					} else if (domElement.selectedIndex >= 0 && domElement.selectedIndex < domElement.options.length) {
						selection[0] = domElement.options[domElement.selectedIndex].value;
					}
				}
			} else if (tag == 'textarea' || tag == 'button') {
				selection[0] = Dynamicweb.Frontend.Document.Current.text(domElement);
			}
		} else {
			if (tag == 'input') {
				type = this.attribute(domElement, 'type');

				if (type == 'button' || type == 'submit') {
					this.attribute(extended, 'value', val);
				} else if (type == 'image') {
					this.attribute(extended, 'src', val);
				} else {
					domElement.value = val;
				}
			} else if (tag == 'select') {
				if (domElement.options && domElement.options.length > 0) {
					for (var i = 0; i < domElement.options.length; i++) {
						if (domElement.options[i].value == val) {
							domElement.options[i].selected = true;
							if (!domElement.multiple) {
								break;
							}
						}
					}
				}
			} else if (tag == 'textarea' || tag == 'button') {
				this.html(domElement, val);
			}
		}
	}

	for (var i = 0; i < selection.length; i++) {
		if (selection[i]) {
			ret += selection[i];
			if (i < (selection.length - 1)) {
				ret += ',';
			}
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.data = function (elm, params) {
	/// <summary>Gets or sets custom information on an element.</summary>
	/// <param name="elm">Element to examine.</param>
	/// <param name="params">Additional parameters.</param>
	/// <remarks>
	///			Available parameters:
	///					1. "value" - custom information to be set on an element (object).
	///					2. "suffix" - additional suffix to be applied to the attribute name.
	/// </remarks>

	var id = '';
	var data = {};
	var ret = new Object();
	var attr = 'data-dw';

	if (!params) params = {};

	if (elm) {
		id = this.id(elm);

		if (id) {
			if (!window._elementData) {
				window._elementData = new Dynamicweb.Frontend.Hashtable();
			}

			if (typeof (params.suffix) != 'undefined') {
				attr += ('-' + params.suffix);
			}

			data = window._elementData.get(id);
			if (typeof (params.value) == 'undefined') {
				if (data) {
					ret = data.get(attr);
				}

				if (ret == null) {
					ret = new Object();
				}
			} else {
				ret = params.value;
				if (data == null) {
					data = new Dynamicweb.Frontend.Hashtable();
				}

				data.set(attr, params.value);
				window._elementData.set(id, data);
			}
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.serializeForm = function (form) {
	/// <summary>Serializes specified form into JSON.</summary>
	/// <param name="form">Form to serialize.</param>

	var ret = {};
	var formArray = [];

	form = this.element(form);

	if (form) {
		if (form.serializeArray) {
			formArray = form.serializeArray();
			jQuery.each(formArray, function () {
				if (ret[this.name]) {
					if (!ret[this.name].push) {
						ret[this.name] = [ret[this.name]];
					}

					ret[this.name].push(this.value || '');
				} else {
					ret[this.name] = this.value || '';
				}
			});
		} else if (form.serialize) {
			ret = form.serialize(true);
		}
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.deserialize = function (str) {
	/// <summary>Returns an instance of an object based on the corresponding JSON representation.</summary>
	/// <param name="str">JSON string to perform deserialization from.</param>

	var ret = new Object();

	if (str && typeof (str) == 'string') {
		try {
			if (str.evalJSON) {
				ret = str.evalJSON();
			} else if (typeof (jQuery) != 'undefined' && jQuery.parseJSON) {
				ret = jQuery.parseJSON(str);
			}
		} catch (ex) { }
	}

	return ret;
}

Dynamicweb.Frontend.Document.prototype.postAsync = function (url, params) {
	/// <summary>Performs async POST request.</summary>
	/// <param name="params">Request parameters.</param>

	if (!params) params = {};

	if (!params.parameters) params.parameters = {};
	if (!params.onComplete) params.onComplete = function () { }

	if (url) {
		if (typeof (Ajax) != 'undefined' && Ajax.Request) {
			new Ajax.Request(url, {
				method: 'post',
				parameters: params.parameters,
				onComplete: params.onComplete
			});
		} else if (jQuery.ajax) {
			jQuery.ajax({
				type: 'POST',
				url: url,
				data: params.parameters,
				complete: params.onComplete
			});
		}
	}
}

Dynamicweb.Frontend.SuggestionBox = function (e, attachTo) {
	/// <summary>Represents a suggestion box.</summary>
	/// <param name="e">Either a reference to the box container or the container identifier.</param>
	/// <param name="attachTo">Either a reference to the target textbox or the textbox identifier.</param>

	this._e = Dynamicweb.Frontend.Document.Current.element(e);
	this._attachTo = Dynamicweb.Frontend.Document.Current.element(attachTo);
	this._data = [];
	this._current = null;
	this._query = '';

	this._itemTemplate = null;
	this._emptyListTemplate = null;
}

Dynamicweb.Frontend.SuggestionBox.prototype.get_container = function () {
	/// <summary>Gets the reference to a box container.</summary>

	return this._e;
}

Dynamicweb.Frontend.SuggestionBox.prototype.get_isVisible = function () {
	/// <summary>Gets value indicating whether suggestion box is visible.</summary>

	return Dynamicweb.Frontend.Document.Current.style(this.get_container(), 'display').toLowerCase() != 'none';
}

Dynamicweb.Frontend.SuggestionBox.prototype.get_itemTemplate = function () {
	/// <summary>Gets the item template.</summary>

	return this._itemTemplate;
}

Dynamicweb.Frontend.SuggestionBox.prototype.set_itemTemplate = function (value) {
	/// <summary>Sets the item template.</summary>
	/// <param name="value">Item template.</param>

	this._itemTemplate = value;
}

Dynamicweb.Frontend.SuggestionBox.prototype.get_emptyListTemplate = function () {
	/// <summary>Gets the "empty list" template.</summary>

	return this._emptyListTemplate;
}

Dynamicweb.Frontend.SuggestionBox.prototype.set_emptyListTemplate = function (value) {
	/// <summary>Sets the "empty list" template.</summary>
	/// <param name="value">"Empty list" template.</param>

	this._emptyListTemplate = value;
}

Dynamicweb.Frontend.SuggestionBox.prototype.get_query = function () {
	/// <summary>Gets the user query that corresponds to the list of currently loaded suggestions.</summary>

	return this._query;
}

Dynamicweb.Frontend.SuggestionBox.prototype.set_query = function (value) {
	/// <summary>Sets the user query that corresponds to the list of currently loaded suggestions.</summary>
	/// <param name="value">The user query that corresponds to the list of currently loaded suggestions.</param>

	this._query = value;
}

Dynamicweb.Frontend.SuggestionBox.prototype.get_current = function () {
	/// <summary>Gets the currently selected item.</summary>

	return this._current;
}

Dynamicweb.Frontend.SuggestionBox.prototype.set_current = function (value) {
	/// <summary>Sets the currently selected item.</summary>
	/// <param name="value">Currently selected item.</param>

	if (value) {
		if (!Dynamicweb.Frontend.Document.Current.hasClass(value, 'dw-suggestion-item')) {
			value = Dynamicweb.Frontend.Document.Current.up(value, '.dw-suggestion-item', true);
		}
	}

	if (this._current != null) {
		Dynamicweb.Frontend.Document.Current.removeClass(this._current, 'dw-suggestion-item-active');
	}

	this._current = value;
	if (this._current != null) {
		Dynamicweb.Frontend.Document.Current.addClass(this._current, 'dw-suggestion-item-active');
	}
}

Dynamicweb.Frontend.SuggestionBox.prototype.get_attachTo = function () {
	/// <summary>Gets the target textbox.</summary>

	return this._attachTo;
}

Dynamicweb.Frontend.SuggestionBox.prototype.set_attachTo = function (value) {
	/// <summary>Sets the target textbox.</summary>
	/// <param name="value">Target textbox.</param>

	this._attachTo = value;
}

Dynamicweb.Frontend.SuggestionBox.prototype.get_data = function () {
	/// <summary>Gets the collection of suggested queries.</summary>

	if (!this._data) {
		this._data = [];
	}

	return this._data;
}

Dynamicweb.Frontend.SuggestionBox.prototype.populateResults = function (value, onItemDataBound, onBeforeRender) {
	/// <summary>Populates the list of suggested queries.</summary>
	/// <param name="value">Data to be populated.</summary>
	/// <param name="onItemDataBound">Callback which is fired when data item is bound to the item template.</summary>
	/// <param name="onBeforeRender">Callback which is fired before rendering data.</summary>

	var self = this;
	var item = null;
	var c = this.get_container();
	var extendedSuggestions = false;

	if (onBeforeRender) {
		var args = { data: value };
		onBeforeRender(this, args);
		if (args.data) {
			value = args.data;
		}
	}

	this._data = value;

	if (!this._data) {
		this._data = [];
	}

	onItemDataBound = onItemDataBound || function () { }

	Dynamicweb.Frontend.Document.Current.html(c, '');

	if (this._data.length == 0) {
		// No items in the list - displaying "Empty list" template
		if (this.get_emptyListTemplate()) {
			Dynamicweb.Frontend.Document.Current.append(c, Dynamicweb.Frontend.Document.Current.clone(this.get_emptyListTemplate(), true));
		}
	} else if (this.get_itemTemplate()) {
		extendedSuggestions = this._data[0].ID && this._data[0].ID.length;

		// Populating items
		for (var i = 0; i < this._data.length; i++) {
			item = Dynamicweb.Frontend.Document.Current.clone(this.get_itemTemplate(), true);

			Dynamicweb.Frontend.Document.Current.html(item, extendedSuggestions ? this._data[i].Name : this._data[i]);

			if (extendedSuggestions) {
				Dynamicweb.Frontend.Document.Current.attribute(item, 'data-suggestion-text', this._data[i].Name);
			}

			Dynamicweb.Frontend.Document.Current.observe(item, 'click', function (e) {
				self.set_current(Dynamicweb.Frontend.Document.Current.eventTarget(e));

				// Updating the textbox value and hiding the suggestion box
				self.updateTextboxValue();
				self.hide();

				if (Dynamicweb.Frontend.InstantSearchSettings.Global.getIsEnabled(self.get_attachTo(), 'search')) {
					Dynamicweb.Frontend.InstantSearch._onInstantSearchWrapper(e, self.get_attachTo());
				}
			});

			Dynamicweb.Frontend.Document.Current.observe(item, 'mouseover', function (e) {
				// Marking targe telement as current
				self.set_current(Dynamicweb.Frontend.Document.Current.eventTarget(e));
			});

			Dynamicweb.Frontend.Document.Current.observe(item, 'mouseout', function (e) {
				var target = Dynamicweb.Frontend.Document.Current.eventTarget(e);

				if (!Dynamicweb.Frontend.Document.Current.up(target, '.dw-suggestion-item', true)) {
					// Clearing previous selection
					self.set_current(null);
				}
			});

			onItemDataBound(this, { template: item, data: this._data[i] });

			Dynamicweb.Frontend.Document.Current.append(c, item);
		}
	}
}

Dynamicweb.Frontend.SuggestionBox._ie_timeoutID = 0;
Dynamicweb.Frontend.SuggestionBox._ie_dimension = {
	width: document.documentElement.clientWidth,
	height: document.documentElement.clientHeight
};

Dynamicweb.Frontend.SuggestionBox.prototype.show = function () {
	/// <summary>Shows the suggestion box.</summary>

	var offset = null;
	var c = this.get_container();
	var elm = this.get_attachTo();

	var onResize = function (e) {
		// IE fires 'resize' event even when any content within the entire window has changed its size.
		// We only need to track the changing of the size for the window itself.
		if (e.type == 'resize' && Dynamicweb.Frontend.Document.Current.get_isIE()) {
			if (Dynamicweb.Frontend.SuggestionBox._ie_timeoutID) {
				clearTimeout(Dynamicweb.Frontend.SuggestionBox._ie_timeoutID);
			}

			Dynamicweb.Frontend.SuggestionBox._ie_timeoutID = setTimeout(function () {
				if (Dynamicweb.Frontend.SuggestionBox._ie_dimension.width != document.documentElement.clientWidth ||
						Dynamicweb.Frontend.SuggestionBox._ie_dimension.height != document.documentElement.clientHeight) {

					Dynamicweb.Frontend.SuggestionBox.hideAll();

					Dynamicweb.Frontend.SuggestionBox._ie_dimension = {
						width: document.documentElement.clientWidth,
						height: document.documentElement.clientHeight
					};
				}
			}, 10);
		} else {
			Dynamicweb.Frontend.SuggestionBox.hideAll();
		}
	}

	var onClick = onResize;
	onResize._dimensions = { width: document.body.clientWidth, height: document.body.clientHeight };

	if (c && elm) {
		// No need to display the suggestion box if there is no content
		if (Dynamicweb.Frontend.Document.Current.html(c).length > 0) {
			Dynamicweb.Frontend.Document.Current.stopObserving(window, 'resize', onResize);
			Dynamicweb.Frontend.Document.Current.stopObserving(document.body, 'click', onClick);

			// Hiding suggestion box when the window is getting resized
			Dynamicweb.Frontend.Document.Current.observe(window, 'resize', onResize);

			// Hiding suggestion box when user clicks anywhere on the page
			Dynamicweb.Frontend.Document.Current.observe(document.body, 'click', onClick);

			offset = Dynamicweb.Frontend.Document.Current.offset(elm);

			if (offset) {
				Dynamicweb.Frontend.Document.Current.style(c, {
					display: 'block',
					position: 'absolute',
					'z-index': '999',
					left: offset.left + 'px',
					top: offset.top + Dynamicweb.Frontend.Document.Current.height(elm) - 1 + 'px'
				});
			}
		}
	}
}

Dynamicweb.Frontend.SuggestionBox.prototype.tryNavigate = function (code) {
	/// <summary>Performs navigation using mouse pointers (if possible).</summary>
	/// <param name="code">Key code which declares what kind of navigation should be performed.</param>
	/// <returns>Value indicating whether navigation succeeded.</returns>

	var ret = true;
	var item = null;

	if (this.get_isVisible()) {
		if (code == 40) {
			item = this.next();
		} else if (code == 38) {
			item = this.previous();
		} else {
			ret = false;
		}

		this.set_current(item);
		if (ret && item == null) {
			if (this.get_attachTo()) {
				this.updateTextboxValue(this.get_query());
			}
		} else {
			this.updateTextboxValue();
		}
	} else {
		ret = false;
	}

	return ret;
}

Dynamicweb.Frontend.SuggestionBox.prototype.next = function () {
	/// <summary>Gets the next current item in tne list.</summary>
	/// <returns>The next current item in the list. If this was the last item then "null" is returned. If the current item is "null" the first item is returned.</returns>

	var ret = null;
	var items = null;

	if (this.get_current() == null) {
		items = Dynamicweb.Frontend.Document.Current.select(this.get_container(), '.dw-suggestion-item');
		if (items != null) {
			ret = items[0];
		}
	} else {
		ret = Dynamicweb.Frontend.Document.Current.next(this.get_current(), '.dw-suggestion-item');
	}

	return ret;
}

Dynamicweb.Frontend.SuggestionBox.prototype.previous = function () {
	/// <summary>Gets the previous current item in tne list.</summary>
	/// <returns>The previous current item in the list. If this was the first item then "null" is returned. If the current item is "null" the last item is returned.</returns>

	var ret = null;
	var items = null;

	if (this.get_current() == null) {
		items = Dynamicweb.Frontend.Document.Current.select(this.get_container(), '.dw-suggestion-item');
		if (items != null) {
			ret = items[items.length - 1];
		}
	} else {
		ret = Dynamicweb.Frontend.Document.Current.previous(this.get_current(), '.dw-suggestion-item');
	}

	return ret;
}

Dynamicweb.Frontend.SuggestionBox.prototype.hide = function () {
	/// <summary>Hides the suggestion box.</summary>
	var c = this.get_container();

	if (c) {
		Dynamicweb.Frontend.Document.Current.style(c, { display: 'none' });
	}
}

Dynamicweb.Frontend.SuggestionBox.prototype.updateTextboxValue = function (value) {
	/// <summary>Updates the value of the associated textbox using either the given value or the currently selected item.</summary>
	/// <param name="value">Textbox value (can be ommited).</param>

	var currentText = '';
	var c = this.get_current();
	var textbox = this.get_attachTo();

	if (textbox) {
		if (typeof (value) != 'undefined') {
			Dynamicweb.Frontend.Document.Current.value(textbox, value);
		} else if (c) {
			currentText = Dynamicweb.Frontend.Document.Current.attribute(c, 'data-suggestion-text');

			Dynamicweb.Frontend.Document.Current.value(textbox, currentText && currentText.length ?
				currentText : Dynamicweb.Frontend.Document.Current.text(c));
		}

		try {
			textbox.focus();
		} catch (ex) { }
	}
}

Dynamicweb.Frontend.SuggestionBox.prototype._getTemplate = function (selector) {
	/// <private />
	/// <summary>Gets the template specified by the given CSS rule.</summary>
	/// <param name="selector">CSS rule used to locate the template.</param>
	/// <returns>A DOM element representing specified template.</returns>

	var ret = null;
	var c = this.get_container();

	if (c) {
		ret = Dynamicweb.Frontend.Document.Current.down(c, selector);
		if (ret) {
			ret = Dynamicweb.Frontend.Document.Current.clone(ret, true);
		}
	}

	return ret;
}

Dynamicweb.Frontend.SuggestionBox.retrieve = function (id, attachTo) {
	/// <summary>Creates new (or retrieves existing) suggestion box.</summary>
	/// <param name="id">An ID of the container.</param>
	/// <param name="attachTo">Target textbox (can be ommited if retrieving existing suggestion box).</param>
	/// <returns>A reference to either a new or existing suggestion box.</returns>

	id = id ? id.toString() : '';

	if (!window._suggestionBoxes) {
		window._suggestionBoxes = [];
	}

	if (!window._suggestionBoxes[id]) {
		// Initializing new instance
		window._suggestionBoxes[id] = new Dynamicweb.Frontend.SuggestionBox(id, attachTo);

		// Initializing templates
		window._suggestionBoxes[id].set_itemTemplate(window._suggestionBoxes[id]._getTemplate('.dw-suggestion-item'));
		window._suggestionBoxes[id].set_emptyListTemplate(window._suggestionBoxes[id]._getTemplate('.dw-no-suggestions'));
	}

	return window._suggestionBoxes[id];
}

Dynamicweb.Frontend.SuggestionBox.retrieveAll = function () {
	/// <summary>Retrieves a list of all existing suggestion boxes.</summary>
	/// <returns>A list of all existing suggestion boxes.</returns>

	if (!window._suggestionBoxes) {
		window._suggestionBoxes = [];
	}

	return window._suggestionBoxes;
}

Dynamicweb.Frontend.SuggestionBox.hideAll = function () {
	/// <summary>Hides all currently visible suggestion boxes.</summary>

	var boxes = Dynamicweb.Frontend.SuggestionBox.retrieveAll();

	for (var id in boxes) {
		if (boxes[id] && typeof (boxes[id].hide) == 'function') {
			boxes[id].hide();
		}
	}
}

Dynamicweb.Frontend.SearchResultItemTemplate = function (id) {
	/// <summary>Represents a search result template.</summary>
	/// <param name="id">An ID of the template container.</param>

	this._container = Dynamicweb.Frontend.Document.Current.element(id);
	this._isVisible = true;

	if (this._container) {
		this._container = Dynamicweb.Frontend.Document.Current.clone(this._container, true);
		this._cleanContainer = Dynamicweb.Frontend.Document.Current.clone(this._container, true);
	}
}

Dynamicweb.Frontend.SearchResultItemTemplate.prototype.reset = function () {
	/// <summary>Resets the template.</summary>

	this._container = Dynamicweb.Frontend.Document.Current.clone(this._cleanContainer, true);
}

Dynamicweb.Frontend.SearchResultItemTemplate.prototype.get_container = function () {
	/// <summary>Gets the template container.</summary>

	return this._container;
}

Dynamicweb.Frontend.SearchResultItemTemplate.prototype.get_isVisible = function () {
	/// <summary>Gets value indicating that the current instance of the template is visible.</summary>

	return this._isVisible;
}

Dynamicweb.Frontend.SearchResultItemTemplate.prototype.set_isVisible = function (value) {
	/// <summary>Sets value indicating that the current instance of the template is visible.</summary>

	this._isVisible = !!value;
}

Dynamicweb.Frontend.SearchResultItemTemplate.prototype.field = function (name, value) {
	/// <summary>Gets or sets the value for a given field.</summary>
	/// <param name="name">Field name.</param>
	/// <param name="value">Field value.</param>

	var ret = '';
	var elm = null;

	if (name) {
		name = name.toLowerCase();

		elm = Dynamicweb.Frontend.Document.Current.select(this.get_container(), '.dw-search-result-' + name);
		if (elm != null && elm.length > 0) {
			elm = Dynamicweb.Frontend.Document.Current.element(elm[0]);

			if (Dynamicweb.Frontend.Document.Current.tag(elm) == 'a') {
				if (typeof (value) == 'undefined') {
					ret = Dynamicweb.Frontend.Document.Current.attribute(elm, 'href');
				} else {
					ret = value;
					Dynamicweb.Frontend.Document.Current.attribute(elm, 'href', ret);
				}
			} else if (Dynamicweb.Frontend.Document.Current.tag(elm) == 'img') {
				if (typeof (value) == 'undefined') {
					ret = Dynamicweb.Frontend.Document.Current.attribute(elm, 'src');
				} else {
					ret = value;
					Dynamicweb.Frontend.Document.Current.attribute(elm, 'src', ret);
				}
			} else if (Dynamicweb.Frontend.Document.Current.tag(elm) == 'input') {
				if (typeof (value) == 'undefined') {
					ret = Dynamicweb.Frontend.Document.Current.attribute(elm, 'value');
				} else {
					ret = value;
					Dynamicweb.Frontend.Document.Current.attribute(elm, 'value', ret);
				}
			} else {
				if (typeof (value) == 'undefined') {
					ret = Dynamicweb.Frontend.Document.Current.text(elm);
				} else {
					ret = value;
					Dynamicweb.Frontend.Document.Current.html(elm, ret);
				}
			}
		}
	}

	return ret;
}

Dynamicweb.Frontend.SearchResultsContainer = function (id) {
	/// <summary>Represents a search results container.</summary>
	/// <param name="id">An ID of the container.</param>

	var item = null;

	this._query = '';
	this._data = [];
	this._container = Dynamicweb.Frontend.Document.Current.element(id);
	this._itemTemplate = null;
	this._emptyListTemplate = null;

	if (this._container) {
		item = Dynamicweb.Frontend.Document.Current.select(this.get_container(), '.dw-search-result');
		if (item != null && item.length > 0) {
			this._itemTemplate = new Dynamicweb.Frontend.SearchResultItemTemplate(item[0]);
		}

		item = Dynamicweb.Frontend.Document.Current.select(this.get_container(), '.dw-no-results');
		if (item != null && item.length > 0) {
			this._emptyListTemplate = Dynamicweb.Frontend.Document.Current.clone(item[0], true);
			Dynamicweb.Frontend.Document.Current.style(this._emptyListTemplate, { display: 'block' });
		}
	}
}

Dynamicweb.Frontend.SearchResultsContainer.prototype.get_query = function () {
	/// <summary>Gets the last query submitted by the user.</summary>

	return this._query;
}

Dynamicweb.Frontend.SearchResultsContainer.prototype.set_query = function (value) {
	/// <summary>Sets the last query submitted by the user.</summary>
	/// <param name="value">The last query submitted by the user.</param>

	this._query = value;
}

Dynamicweb.Frontend.SearchResultsContainer.prototype.get_container = function () {
	/// <summary>Gets the results container.</summary>

	return this._container;
}

Dynamicweb.Frontend.SearchResultsContainer.prototype.get_itemTemplate = function () {
	/// <summary>Gets the item template.</summary>

	return this._itemTemplate;
}

Dynamicweb.Frontend.SearchResultsContainer.prototype.set_itemTemplate = function (value) {
	/// <summary>Sets the item template.</summary>
	/// <param name="value">Item template.</param>

	this._itemTemplate = value;
}

Dynamicweb.Frontend.SearchResultsContainer.prototype.get_emptyListTemplate = function () {
	/// <summary>Gets the "empty list" template.</summary>

	return this._emptyListTemplate;
}

Dynamicweb.Frontend.SearchResultsContainer.prototype.set_emptyListTemplate = function (value) {
	/// <summary>Sets the "empty list" template.</summary>
	/// <param name="value">"Empty list" template.</param>

	this._emptyListTemplate = value;
}

Dynamicweb.Frontend.SearchResultsContainer.prototype.get_data = function () {
	/// <summary>Gets the list of currently displayed search results.</summary>

	if (!this._data) this._data = [];

	return this._data;
}

Dynamicweb.Frontend.SearchResultsContainer.prototype.populateResults = function (value, onItemDataBound, onBeforeRender) {
	/// <summary>Populates the list of search results.</summary>
	/// <param name="value">Data to be populated.</summary>
	/// <param name="onItemDataBound">Callback which is fired when data item is bound to the item template.</summary>
	/// <param name="onBeforeRender">Callback which is fired before rendering data.</summary>

	var args = null;
	var item = null;
	var c = this.get_container();

	onItemDataBound = onItemDataBound || function () { }

	if (c) {
		Dynamicweb.Frontend.Document.Current.html(c, '');

		if (onBeforeRender) {
			var args = { data: value };
			onBeforeRender(this, args);
			if (args.data) {
				value = args.data;
			}
		}

		this._data = value;

		if (this._data && this._data.length > 0) {
			for (var i = 0; i < this._data.length; i++) {
				this.get_itemTemplate().reset();

				for (var prop in this._data[i]) {
					this.get_itemTemplate().field(prop, this._data[i][prop]);
				}

				Dynamicweb.Frontend.Document.Current.style(this.get_itemTemplate().get_container(), { display: 'block' });

				args = { template: this.get_itemTemplate(), data: this._data[i] };

				onItemDataBound(this, args);

				if (args.template.get_isVisible()) {
					Dynamicweb.Frontend.Document.Current.append(c, args.template.get_container());
				}
			}
		} else if (this.get_emptyListTemplate()) {
			Dynamicweb.Frontend.Document.Current.append(c, Dynamicweb.Frontend.Document.Current.clone(this.get_emptyListTemplate(), true));
		}
	}
}

Dynamicweb.Frontend.SearchResultsContainer.retrieve = function (id) {
	/// <summary>Creates new (or retrieves existing) search results container.</summary>
	/// <param name="id">An ID of the results container.</param>
	/// <returns>A reference to either a new or existing search results container.</returns>

	id = id ? id.toString() : '';

	if (!window._searchContainers) {
		window._searchContainers = [];
	}

	if (!window._searchContainers[id]) {
		// Initializing new instance
		window._searchContainers[id] = new Dynamicweb.Frontend.SearchResultsContainer(id);
	}

	return window._searchContainers[id];
}

/* ++++++ End: Supply functionality ++++++ */

Dynamicweb.Frontend.InstantSearchSettings = function () {
	/// <summary>Provides access to the instant search settings.</summary>

	this._pageID = 0;
	this._paragraphID = 0;
	this._delay = 250;
	this._isEnabled = {};
}

Dynamicweb.Frontend.InstantSearchSettings.Global = new Dynamicweb.Frontend.InstantSearchSettings();

Dynamicweb.Frontend.InstantSearchSettings.prototype.get_pageID = function () {
	/// <summary>Gets an ID of the page to send XHR request to.</summary>

	return this._pageID;
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.set_pageID = function (value) {
	/// <summary>Sets an ID of the page to send XHR request to.</summary>
	/// <param name="value">An ID of the page to send XHR request to.</param>

	this._pageID = value;
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.get_url = function () {
	/// <summary>Gets the custom URL to send all XHR requests to.</summary>

	return this._url;
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.set_url = function (value) {
	/// <summary>Gets the custom URL to send all XHR requests to.</summary>
	/// <param name="value">The custom URL to send all XHR requests to.</param>

	this._url = value;
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.get_paragraphID = function () {
	/// <summary>Gets an ID of the paragraph to send XHR request to.</summary>

	return this._paragraphID;
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.set_paragraphID = function (value) {
	/// <summary>Sets an ID of the paragraph to send XHR request to.</summary>
	/// <param name="value">An ID of the paragraph to send XHR request to.</param>

	this._paragraphID = value;
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.get_delay = function () {
	/// <summary>Gets the number of milliseconds to wait before performing any XNR requests.</summary>

	return this._delay;
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.set_delay = function (value) {
	/// <summary>Sets the number of milliseconds to wait before performing any XNR requests.</summary>
	/// <param name="value">The number of milliseconds to wait before performing any XNR requests.</param>

	this._delay = value;
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.load = function (params) {
	/// <summary>Loads settings from the specified object.</summary>
	/// <param name="params">Object to load settings from.</param>

	if (!params) params = {};

	if (typeof (params.pageID) != 'undefined') this.set_pageID(parseInt(params.pageID));
	if (typeof (params.paragraphID) != 'undefined') this.set_paragraphID(parseInt(params.paragraphID));
	if (typeof (params.delay) != 'undefined') this.set_delay(parseInt(params.delay));
	if (typeof (params.url) != 'undefined') this.set_url(params.url);
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.setIsEnabled = function (e, name, isEnabled) {
	/// <summary>Sets value indicating whether specified functionality is enabled on a given element.</summary>
	/// <param name="e">Either a reference to an element or an element ID.</param>
	/// <param name="name">Name of the functionality.</param>
	/// <param name="isEnabled">Indicates whether functionality is enabled.</param>

	var tmp = [];
	var id = Dynamicweb.Frontend.Document.Current.id(e);

	isEnabled = !!isEnabled;

	if (id && name) {
		if (!this._isEnabled) {
			this._isEnabled = {};
		}

		if (!this._isEnabled[name]) {
			this._isEnabled[name] = [];
		}

		if (isEnabled && !this.getIsEnabled(e, name)) {
			this._isEnabled[name][this._isEnabled[name].length] = id;
		} else if (!isEnabled && this.getIsEnabled(e, name)) {
			for (var i = 0; i < this._isEnabled[name].length; i++) {
				if (this._isEnabled[name][i] != id) {
					tmp[tmp.length] = this._isEnabled[name][i];
				}
			}

			this._isEnabled[name] = tmp;
		}
	}
}

Dynamicweb.Frontend.InstantSearchSettings.prototype.getIsEnabled = function (e, name) {
	/// <summary>Gets value indicating whether specified functionality is enabled on a given element.</summary>
	/// <param name="e">Either a reference to an element or an element ID.</param>
	/// <param name="name">Name of the functionality.</param>

	var ret = false;
	var id = Dynamicweb.Frontend.Document.Current.id(e);

	if (id && name) {
		if (!this._isEnabled) {
			this._isEnabled = {};
		}

		if (this._isEnabled[name] && this._isEnabled[name].length) {
			for (var i = 0; i < this._isEnabled[name].length; i++) {
				if (this._isEnabled[name][i] == id) {
					ret = true;
					break;
				}
			}
		}
	}

	return ret;
}

Dynamicweb.Frontend.InstantSearch = function () {
	/// <summary>Represents a text filter with advanced search capabilities (keyword suggestions and instant search).</summary>
}

Dynamicweb.Frontend.InstantSearch.QueryEventArgs = function () {
	/// <summary>Prodives information about the search query being made.</summary>

	this._value = '';
	this._cancel = false;
}

Dynamicweb.Frontend.InstantSearch.QueryEventArgs.prototype.get_value = function () {
	/// <summary>Gets the query value.</summary>

	return this._value;
}

Dynamicweb.Frontend.InstantSearch.QueryEventArgs.prototype.set_value = function (value) {
	/// <summary>Sets the query value.</summary>
	/// <param name="value">The query value.</param>

	this._value = value;
}

Dynamicweb.Frontend.InstantSearch.QueryEventArgs.prototype.get_cancel = function () {
	/// <summary>Gets value indicating whether to cancel the further execution.</summary>

	return this._cancel;
}

Dynamicweb.Frontend.InstantSearch.QueryEventArgs.prototype.set_cancel = function (value) {
	/// <summary>Sets value indicating whether to cancel the further execution.</summary>
	/// <param name="value">Value indicating whether to cancel the further execution.</param>

	this._cancel = !!value;
}

Dynamicweb.Frontend.InstantSearch.setup = function (params) {
	/// <summary>Initializes global settings.</summary>

	Dynamicweb.Frontend.InstantSearch._checkFramework();
	Dynamicweb.Frontend.InstantSearchSettings.Global.load(params);
}

Dynamicweb.Frontend.InstantSearch.warmUp = function (params) {
	/// <summary>Performs system warm-up.</summary>
	/// <param name="params">Additional parameters that are not required though.</param>
	/// <remarks>
	///			Optional parameters:
	///					1. "pageID" - ID of the page with eCom module attached to it.
	///					2. "paragraphID" - ID of the paragraph with eCom module attached to it.
	///					3. "onComplete" - callback which is fired when the warm-up process finishes.
	/// </remarks>

	var url = null;
	var data = null;
	var callback = function () { }

	if (params == null || typeof (params) == 'undefined') params = {};
	if (!params.pageID) params.pageID = Dynamicweb.Frontend.InstantSearchSettings.Global.get_pageID();
	if (!params.paragraphID) params.paragraphID = Dynamicweb.Frontend.InstantSearchSettings.Global.get_paragraphID();

	callback = params.onComplete || function () { }

	if (params.url) {
		url = params.url;
	} else if (Dynamicweb.Frontend.InstantSearchSettings.Global.get_url()) {
		url = Dynamicweb.Frontend.InstantSearchSettings.Global.get_url();
	} else {
		url = Dynamicweb.Frontend.Document.Current.get_url();
	}

	data = new Dynamicweb.Frontend.Hashtable();

	// Collecting the data that will be submitted
	data.set('ID', params.pageID);
	data.set('PID', params.paragraphID);
	data.set('InstantSearchType', 'WarmUp');

	// Sending a request
	Dynamicweb.Frontend.Document.prototype.postAsync(url, {
		parameters: data.get_data(),
		onComplete: function (transport) { callback(transport); }
	});
}

Dynamicweb.Frontend.InstantSearch.setEnableSuggestions = function (e, isEnabled, params) {
	/// <summary>Either enables or disables keyword suggestion functionality for the given textbox.</summary>
	/// <param name="e">Either a reference to a DOM element or an identifier of the textbox.</param>
	/// <param name="isEnabled">Indicates whether keyword suggestion functionality should be enabled.</param>
	/// <param name="params">Additional parameters (only taken into consideration if "isEnabled" is set to "true").</param>
	/// <remarks>
	///			Required parameters:
	///					1. "pageID" - ID of the page with eCom module attached to it.
	///					2. "paragraphID" - ID of the paragraph with eCom module attached to it.
	///					3. "boxID" - an ID of the suggestion box.
	///			Optional parameters:
	///					1. "delay" - number of milliseconds to wait before suggesting anything. Default is 250.
	///					2. "triggerID" - an ID of the control which triggers the suggestions box to appear.
	///					3. "progressID" - an ID of an element to be visible during performing the call to the server.
	///					4. "onComplete" - callback which is fired when data becomes available.
	///					5. "onBeforeQuery" - callback which is fired before querying the server.
	///					6. "onBeforeRender" - callback which is fired before rendering data.
	///					7. "onItemDataBound" - callback which is fired after the data item is bound to the corresponding item template.
	/// </remarks>

	var elm = null;
	var eventName = '';
	var eventTarget = null;

	Dynamicweb.Frontend.InstantSearch._checkFramework();

	elm = Dynamicweb.Frontend.Document.Current.element(e);
	eventTarget = elm;

	if (params && params.triggerID) {
		eventTarget = Dynamicweb.Frontend.Document.Current.element(params.triggerID);
		Dynamicweb.Frontend.Document.Current.attribute(eventTarget, 'data-dwtriggers', Dynamicweb.Frontend.Document.Current.id(elm));
	}

	eventName = Dynamicweb.Frontend.InstantSearch._getChangeEvent(eventTarget);

	if (elm) {
		if (Dynamicweb.Frontend.Document.Current.tag(elm).toLowerCase() != 'input' || Dynamicweb.Frontend.Document.Current.attribute(elm, 'type').toLowerCase() != 'text') {
			Dynamicweb.Frontend.Document.Current.error('Suggested queries can only be enabled on the existing textbox element.');
		} else {
			// Unregistering event handler
			Dynamicweb.Frontend.Document.Current.stopObserving(eventTarget, eventName, Dynamicweb.Frontend.InstantSearch._onSuggestWrapper);

			// Marking functionality as enabled (disabled) for a given element
			Dynamicweb.Frontend.InstantSearchSettings.Global.setIsEnabled(elm, 'suggest', isEnabled);
			if (params && params.triggerID) {
				Dynamicweb.Frontend.InstantSearchSettings.Global.setIsEnabled(params.triggerID, 'suggest', isEnabled);
			}

			if (isEnabled) {
				// Setting up default parameters
				if (params) {
					if (!params.delay || params.delay < 0) {
						params.delay = Dynamicweb.Frontend.InstantSearchSettings.Global.get_delay();
					}
				}

				// Persisting custom information
				Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { value: params, suffix: 'suggest' });

				// Registering event handler
				Dynamicweb.Frontend.Document.Current.observe(eventTarget, eventName, Dynamicweb.Frontend.InstantSearch._onSuggestWrapper);
			}
		}
	}
}

Dynamicweb.Frontend.InstantSearch.setEnableInstantSearch = function (e, isEnabled, params) {
	/// <summary>Either enables or disables instant search functionality for the given textbox.</summary>
	/// <param name="e">Either a reference to a DOM element or an identifier of the textbox.</param>
	/// <param name="isEnabled">Indicates whether instant search functionality should be enabled.</param>
	/// <param name="params">Additional parameters (only taken into consideration if "isEnabled" is set to "true").</param>
	/// <remarks>
	///			Required parameters:
	///					1. "pageID" - an ID of the page with eCom module attached to it.
	///					2. "paragraphID" - an ID of the paragraph with eCom module attached to it.
	///					3. "contentID" - an ID of the results container.
	///			Optional parameters:
	///					1. "delay" - number of milliseconds to wait before requesting anything. Default is 250.
	///					2. "triggerID" - an ID of the control which triggers the suggestions box to appear.
	///					3. "progressID" - an ID of an element to be visible during performing the call to the server.
	///					4. "onComplete" - callback which is fired when data becomes available.
	///					5. "onBeforeQuery" - callback which is fired before querying the server.
	///					6. "onBeforeRender" - callback which is fired before rendering data.
	///					7. "onItemDataBound" - callback which is fired after the data item is bound to the corresponding item template.
	/// </remarks>

	var elm = null;
	var eventName = '';
	var eventTarget = null;

	Dynamicweb.Frontend.InstantSearch._checkFramework();

	elm = Dynamicweb.Frontend.Document.Current.element(e);
	eventTarget = elm;

	if (params && params.triggerID) {
		eventTarget = Dynamicweb.Frontend.Document.Current.element(params.triggerID);
		Dynamicweb.Frontend.Document.Current.attribute(eventTarget, 'data-dwtriggers', Dynamicweb.Frontend.Document.Current.id(elm));
	}

	eventName = Dynamicweb.Frontend.InstantSearch._getChangeEvent(eventTarget);

	if (elm) {
		// Unregistering event handler
		Dynamicweb.Frontend.Document.Current.stopObserving(eventTarget, eventName, Dynamicweb.Frontend.InstantSearch._onInstantSearchWrapper);

		// Marking functionality as enabled (disabled) for a given element
		Dynamicweb.Frontend.InstantSearchSettings.Global.setIsEnabled(elm, 'search', isEnabled);

		if (isEnabled) {
			// Setting up default parameters
			if (params) {
				if (!params.delay || params.delay < 0) {
					params.delay = Dynamicweb.Frontend.InstantSearchSettings.Global.get_delay();
				}
			}

			// Persisting custom information
			Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { value: params, suffix: 'search' });

			// Registering event handler
			Dynamicweb.Frontend.Document.Current.observe(eventTarget, eventName, Dynamicweb.Frontend.InstantSearch._onInstantSearchWrapper);
		}
	}
}

Dynamicweb.Frontend.InstantSearch.suggest = function (textbox, params) {
	/// <summary>Triggers keyword suggestion on a given textbox.</summary>
	/// <param name="textbox">A reference to a DOM element representing a textbox.</param>
	/// <param name="params">Additional parameters.</param>
	/// <remarks>
	///			Additional parameters:
	///					1. "onComplete" - fires when the suggestion process is finished.
	///					2. "onBeforeRender" - callback which is fired before rendering data.
	///					3. "onItemDataBound" - fires after the data item is bound to the corresponding item template.
	///					4. "onBeforeQuery" - callback which is fired before querying the server.
	/// </remarks>

	var val = '';
	var url = null;
	var box = null;
	var form = null;
	var data = null;
	var self = this;
	var groupID = '';
	var elmName = '';
	var elm = textbox;
	var callback = null;
	var queryArgs = null;
	var onComplete = null;
	var canProcess = false;
	var elementParams = null;
	var onBeforeQuery = null;
	var onBeforeRender = null;
	var onItemDataBound = null;
	var itemDataBoundCallback = null;

	if (!params) params = {};

	callback = params.onComplete || function () { };
	itemDataBoundCallback = params.onItemDataBound || function () { };

	onComplete = callback;
	onBeforeRender = params.onBeforeRender || function () { };
	onItemDataBound = itemDataBoundCallback;
	onBeforeQuery = params.onBeforeQuery || function () { };

	if (elm) {
		// Retrieving custom information
		elementParams = Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { suffix: 'suggest' });
		if (!elementParams) elementParams = {};

		// Setting up global event handler (if defined)
		if (typeof (elementParams.onComplete) == 'function') {
			onComplete = function (sender, args) {
				callback(sender, args);
				elementParams.onComplete(sender, args);
			}
		}

		if (typeof (elementParams.onBeforeRender) == 'function') {
			onBeforeRender = function (sender, args) {
				elementParams.onBeforeRender(sender, args);
			}
		}

		if (typeof (elementParams.onItemDataBound) == 'function') {
			onItemDataBound = function (sender, args) {
				itemDataBoundCallback(sender, args);
				elementParams.onItemDataBound(sender, args);
			}
		}

		if (typeof (elementParams.onBeforeQuery) == 'function') {
			onBeforeQuery = function (sender, args) {
				elementParams.onBeforeQuery(sender, args);
			}
		}

		// Creating a suggestion box
		box = Dynamicweb.Frontend.SuggestionBox.retrieve(elementParams.boxID, Dynamicweb.Frontend.Document.Current.id(elm));
		val = Dynamicweb.Frontend.Document.Current.value(elm);

		// To prevent submitting the same value again and again
		if (Dynamicweb.Frontend.InstantSearch._stateChanged(elm, 'suggest') && elementParams.boxID) {
			canProcess = true;

			elementParams.value = val
			Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { value: elementParams, suffix: 'suggest' });

			// If there was a previously typed query then checking whether we can generate more suggestions.
			// If the previous query returned no suggestions and the current query starts with the previous query then
			// previous query won't generate any suggestions as well.

			/* *** PVO 13/04/2011: Disabled due to issues with products from multiple contexts. ***
			if (box && box.get_query()) {
			canProcess = (box.get_data() != null &&
			box.get_data().length > 0) || val.indexOf(box.get_query()) < 0;
			}
			*/
		}

		if (val && canProcess) {
			data = new Dynamicweb.Frontend.Hashtable();

			if (elementParams.url) {
				url = elementParams.url;
			} else if (Dynamicweb.Frontend.InstantSearchSettings.Global.get_url()) {
				url = Dynamicweb.Frontend.InstantSearchSettings.Global.get_url();
			} else {
				url = Dynamicweb.Frontend.Document.Current.get_url();
			}

			elmName = Dynamicweb.Frontend.Document.Current.attribute(elm, 'name');

			// Collecting the data that will be submitted
			data.set('ID', elementParams.pageID ? elementParams.pageID : Dynamicweb.Frontend.InstantSearchSettings.Global.get_pageID());
			data.set('PID', elementParams.paragraphID ? elementParams.paragraphID : Dynamicweb.Frontend.InstantSearchSettings.Global.get_paragraphID());

			data.set('o', 'json');
			data.set('InstantSearchType', 'Suggest');
			data.set('Caller', elmName);

			groupID = Dynamicweb.Frontend.InstantSearch._queryParam('GroupID');
			if (groupID) {
				data.set('GroupID', groupID);
			}

			// Setting custom request parameters
			if (elementParams.request) {
				for (var name in elementParams.request) {
					data.set(name, elementParams.request[name]);
				}
			}

			// If the textbox is placed inside a form then we will submit those form values as well
			form = Dynamicweb.Frontend.Document.Current.up(elm, 'form');
			if (form != null) data.merge(Dynamicweb.Frontend.Document.Current.serializeForm(form));

			if (!data.contains(elmName))
				data.set(elmName, Dynamicweb.Frontend.Document.Current.value(elm));

			queryArgs = new Dynamicweb.Frontend.InstantSearch.QueryEventArgs();

			queryArgs.set_value(data.get(elmName));
			queryArgs.set_cancel(false);

			onBeforeQuery(this, queryArgs);

			if (!queryArgs.get_cancel()) {
				// Allowing to override the queryable value from callback
				data.set(elmName, queryArgs.get_value());

				if (elementParams.progressID) {
					Dynamicweb.Frontend.Document.Current.style(elementParams.progressID, { display: 'block' });
				}

				// Submitting the form
				Dynamicweb.Frontend.Document.prototype.postAsync(url, {
					parameters: data.get_data(),
					onComplete: function (transport) {
						var response = Dynamicweb.Frontend.Document.Current.deserialize(transport.responseText);

						if (elementParams.progressID) {
							Dynamicweb.Frontend.Document.Current.style(elementParams.progressID, { display: 'none' });
						}

						// We've got something to suggest - displaying the suggestion box
						if (response) {
							if (box) {
								box.set_query(val);
								box.populateResults(response.Data, onItemDataBound, onBeforeRender);
								box.show();
							}

							onComplete(this, { executed: true, data: response.Data, extensionData: self._convertExtensionData(response.ExtensionData) });
						} else {
							onComplete(this, { executed: true, data: [], extensionData: self._convertExtensionData(response.ExtensionData) });
						}
					}
				});
			} else {
				onComplete(this, { executed: false, data: [], extensionData: {} });
			}
		} else {
			onComplete(this, { executed: false, data: [], extensionData: {} });
		}
	} else {
		onComplete(this, { executed: false, data: [], extensionData: {} });
	}
}

Dynamicweb.Frontend.InstantSearch.search = function (elm, params) {
	/// <summary>Triggers instant search on a given element.</summary>
	/// <param name="elm">A reference to a DOM element which triggers instant search.</param>
	/// <param name="params">Additional parameters.</param>
	/// <remarks>
	///			Additional parameters:
	///					1. "onComplete" - fires when the search process is finished.
	///					2. "onBeforeRender" - callback which is fired before rendering data.
	///					3. "onItemDataBound" - fires after the data item is bound to the corresponding item template.
	///					4. "onBeforeQuery" - callback which is fired before querying the server.
	/// </remarks>

	var val = '';
	var url = null;
	var form = null;
	var data = null;
	var self = this;
	var groupID = '';
	var elmName = '';
	var isForm = false;
	var results = null;
	var callback = null;
	var queryArgs = null;
	var onComplete = null;
	var canProcess = false;
	var elementParams = null;
	var onBeforeQuery = null;
	var onBeforeRender = null;
	var onItemDataBound = null;
	var itemDataBoundCallback = null;

	if (!params) params = {};

	callback = params.onComplete || function () { };
	itemDataBoundCallback = params.onItemDataBound || function () { };

	onComplete = callback;
	onBeforeRender = params.onBeforeRender || function () { };
	onItemDataBound = itemDataBoundCallback;
	onBeforeQuery = params.onBeforeQuery || function () { };

	if (elm) {
		isForm = (Dynamicweb.Frontend.Document.Current.tag(elm) == 'form');

		// Retrieving custom information
		elementParams = Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { suffix: 'search' });
		if (!elementParams) elementParams = {};

		// Setting up global event handlers (if defined)
		if (typeof (elementParams.onComplete) == 'function') {
			onComplete = function (sender, args) {
				callback(sender, args);
				elementParams.onComplete(sender, args);
			}
		}

		if (typeof (elementParams.onBeforeRender) == 'function') {
			onBeforeRender = function (sender, args) {
				elementParams.onBeforeRender(sender, args);
			}
		}

		if (typeof (elementParams.onItemDataBound) == 'function') {
			onItemDataBound = function (sender, args) {
				itemDataBoundCallback(sender, args);
				elementParams.onItemDataBound(sender, args);
			}
		}

		if (typeof (elementParams.onBeforeQuery) == 'function') {
			onBeforeQuery = function (sender, args) {
				elementParams.onBeforeQuery(sender, args);
			}
		}

		// Creating a search results container
		results = Dynamicweb.Frontend.SearchResultsContainer.retrieve(elementParams.contentID);
		val = Dynamicweb.Frontend.Document.Current.value(elm);

		// To prevent submitting the same value again and again
		if (Dynamicweb.Frontend.InstantSearch._stateChanged(elm, 'search') && elementParams.contentID) {
			canProcess = true;

			elementParams.value = val;
			Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { value: elementParams, suffix: 'search' });

			// If there was a previously typed query then checking whether we can generate more search results.
			// If the previous query returned no search results and the current query starts with the previous query then
			// previous query won't generate any search results as well.

			/* *** PVO 13/04/2011: Disabled due to issues with products from multiple contexts. ***
			if (results && results.get_query()) {
			canProcess = (results.get_data() != null &&
			results.get_data().length > 0) || val.indexOf(results.get_query()) < 0;
			}
			*/
		}

		if ((val || isForm) && canProcess) {
			data = new Dynamicweb.Frontend.Hashtable()

			if (elementParams.url) {
				url = elementParams.url;
			} else if (Dynamicweb.Frontend.InstantSearchSettings.Global.get_url()) {
				url = Dynamicweb.Frontend.InstantSearchSettings.Global.get_url();
			} else {
				url = Dynamicweb.Frontend.Document.Current.get_url();
			}

			elmName = Dynamicweb.Frontend.Document.Current.attribute(elm, 'name');

			// Collecting the data that will be submitted
			data.set('ID', elementParams.pageID ? elementParams.pageID : Dynamicweb.Frontend.InstantSearchSettings.Global.get_pageID());
			data.set('PID', elementParams.paragraphID ? elementParams.paragraphID : Dynamicweb.Frontend.InstantSearchSettings.Global.get_paragraphID());

			data.set('o', 'json');
			data.set('InstantSearchType', 'Search');

			groupID = Dynamicweb.Frontend.InstantSearch._queryParam('GroupID');
			if (groupID) {
				data.set('GroupID', groupID);
			}

			if (elmName) {
				data.set('Caller', elmName);
			}

			// Setting custom request parameters
			if (elementParams.request) {
				for (var name in elementParams.request) {
					data.set(name, elementParams.request[name]);
				}
			}

			// If the textbox is placed inside a form then we will submit those form values as well
			form = Dynamicweb.Frontend.Document.Current.up(elm, 'form');
			if (form != null) data.merge(Dynamicweb.Frontend.Document.Current.serializeForm(form));

			if (!data.contains(elmName) && elmName)
				data.set(elmName, Dynamicweb.Frontend.Document.Current.value(elm));

			queryArgs = new Dynamicweb.Frontend.InstantSearch.QueryEventArgs();

			queryArgs.set_value(data.get(elmName));
			queryArgs.set_cancel(false);

			onBeforeQuery(this, queryArgs);

			if (!queryArgs.get_cancel()) {
				// Allowing to override the queryable value from callback
				data.set(elmName, queryArgs.get_value());

				if (elementParams.progressID) {
					Dynamicweb.Frontend.Document.Current.style(elementParams.progressID, { display: 'block' });
				}

				// Submitting the form
				Dynamicweb.Frontend.Document.prototype.postAsync(url, {
					parameters: data.get_data(),
					onComplete: function (transport) {
						var response = Dynamicweb.Frontend.Document.Current.deserialize(transport.responseText);

						if (elementParams.progressID) {
							Dynamicweb.Frontend.Document.Current.style(elementParams.progressID, { display: 'none' });
						}

						// We've got something to suggest - displaying the suggestion box
						if (response) {
							if (results) {
								results.set_query(val);
								results.populateResults(response.Data, onItemDataBound, onBeforeRender);
							}

							onComplete(this, { executed: true, data: response.Data, extensionData: self._convertExtensionData(response.ExtensionData) });
						} else {
							onComplete(this, { executed: true, data: [], extensionData: self._convertExtensionData(response.ExtensionData) });
						}
					}
				});
			} else {
				onComplete(this, { executed: false, data: [], extensionData: {} });
			}
		} else {
			onComplete(this, { executed: false, data: [], extensionData: {} });
		}
	} else {
		onComplete(this, { executed: false, data: [], extensionData: {} });
	}
}

Dynamicweb.Frontend.InstantSearch._onSuggestWrapper = function (e) {
	/// <private />
	/// <summary>Fires when user types anything into the textbox.</summary>
	/// <param name="e">Event object.</param>

	var box = null;
	var triggers = '';
	var timeoutID = 0;
	var params = null;
	var navigated = false;
	var elm = Dynamicweb.Frontend.Document.Current.eventTarget(e);

	if (elm) {
		triggers = Dynamicweb.Frontend.Document.Current.attribute(elm, 'data-dwtriggers');
		if (triggers) {
			elm = Dynamicweb.Frontend.Document.Current.element(triggers);
		}

		if (elm) {
			// Retrieving custom information
			params = Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { suffix: 'suggest' });
			if (!params) params = {};

			// Hiding suggestion box
			box = Dynamicweb.Frontend.SuggestionBox.retrieve(params.boxID, Dynamicweb.Frontend.Document.Current.id(elm));
			if (box) {
				navigated = box.tryNavigate(e.keyCode);
				if (!navigated) {
					box.hide();
				}
			}

			// Clearing the timeout if it has been set earlier
			timeoutID = parseInt(params.timeoutID);
			if (timeoutID) {
				clearTimeout(timeoutID);
			}

			if (!navigated) {
				// Delaying the appearance of the suggestion box
				timeoutID = setTimeout(function () {
					Dynamicweb.Frontend.InstantSearch.suggest(elm);
				}, parseInt(params.delay));
			}

			// Persisting custom information
			params.timeoutID = timeoutID;
			Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { value: params, suffix: 'suggest' });
		}
	}
}

Dynamicweb.Frontend.InstantSearch._onInstantSearchWrapper = function (e, target) {
	/// <private />
	/// <summary>Fires when user types anything into the textbox.</summary>
	/// <param name="e">Event object.</param>
	/// <param name="target">Custom event target.</param>

	var tagName = '';
	var triggers = '';
	var timeoutID = 0;
	var params = null;
	var elm = Dynamicweb.Frontend.Document.Current.eventTarget(e);

	if (target) {
		elm = target;
	}

	if (elm) {
		tagName = Dynamicweb.Frontend.Document.Current.tag(elm);
		if (tagName == 'form' || (tagName == 'input' && Dynamicweb.Frontend.Document.Current.attribute(elm, 'type') == 'submit')) {
			Dynamicweb.Frontend.Document.Current.stopEvent(e);
		}

		if (!target) {
			triggers = Dynamicweb.Frontend.Document.Current.attribute(elm, 'data-dwtriggers');
			if (triggers) {
				elm = Dynamicweb.Frontend.Document.Current.element(triggers);
			}
		}

		// Retrieving custom information
		params = Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { suffix: 'search' });
		if (!params) params = {};

		// Clearing the timeout if it has been set earlier
		timeoutID = parseInt(params.timeoutID);
		if (timeoutID) {
			clearTimeout(timeoutID);
		}

		// Delaying the execution of the instant search
		timeoutID = setTimeout(function () {
			Dynamicweb.Frontend.InstantSearch.search(elm);
		}, parseInt(params.delay));

		// Persisting custom information
		params.timeoutID = timeoutID;
		Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { value: params, suffix: 'search' });
	}
}

Dynamicweb.Frontend.InstantSearch._stateChanged = function (elm, action) {
	/// <private />
	/// <summary>Determines whether state of the given element has been changed.</summary>
	/// <param name="elm">Element to examine.</param>
	/// <param name="action">Type of the instant search action (either "suggest" or "search").</param>

	var ret = true;
	var tagType = '';
	var tagName = '';
	var params = null;

	if (elm && action) {
		tagName = Dynamicweb.Frontend.Document.Current.tag(elm);
		tagType = Dynamicweb.Frontend.Document.Current.attribute(elm, 'type');

		// It's quite hard to track the "changed" state of the entire form so it's always "changed"
		if (tagName == 'form' || tagName == 'button') {
			ret = true;
		} else if (tagName == 'input' && (tagType == 'button' || tagType == 'submit')) {
			ret = true;
		} else {
			// Retrieving custom information
			params = Dynamicweb.Frontend.Document.Current.data(Dynamicweb.Frontend.Document.Current.id(elm), { suffix: action });

			if (params && typeof (params.value) != 'undefined') {
				ret = params.value.toLowerCase() != Dynamicweb.Frontend.Document.Current.value(elm).toLowerCase();
			}
		}
	}

	return ret;
}

Dynamicweb.Frontend.InstantSearch._getChangeEvent = function (elm) {
	/// <private />
	/// <summary>Retrieves an appropriate event that corresponds to "changed" state of the given element.</summary>
	/// <param name="elm">Element to examine.</param>

	var ret = '';
	var tag = '';
	var type = '';

	if (elm) {
		tag = Dynamicweb.Frontend.Document.Current.tag(elm).toLowerCase();
		if (tag == 'input') {
			type = Dynamicweb.Frontend.Document.Current.attribute(elm, 'type').toLowerCase();
			if (type == 'text' || type == 'password') {
				ret = 'keyup';
			} else {
				ret = 'click';
			}
		} else if (tag == 'select' || tag == 'textarea') {
			ret = 'change';
		} else if (tag == 'form') {
			ret = 'submit';
		} else {
			ret = 'click';
		}
	}

	return ret;
}

Dynamicweb.Frontend.InstantSearch._queryParam = function (name) {
	/// <private />
	/// <summary>Returns a query-string parameter value.</summary>
	/// <param name="name">Parameter name.</param>

	var ret = '';
	var rx = null;
	var results = null;

	if (name) {
		name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
		rx = new RegExp("[\\?&]" + name + "=([^&#]*)");

		results = rx.exec(window.location.href);
		if (results != null)
			ret = decodeURIComponent(results[1].replace(/\+/g, " "));
	}

	return ret;
}

Dynamicweb.Frontend.InstantSearch._checkFramework = function () {
	/// <private />
	/// <summary>Checks whether Prototype or jQuery is included and if not, throws an exception.</summary>

	if (typeof (Prototype) == 'undefined' && typeof (jQuery) == 'undefined') {
		Dynamicweb.Frontend.Document.Current.error('Either Prototype or jQuery is required for the instant search to work.');
	} else if (typeof (Prototype) != 'undefined' && typeof (jQuery) != 'undefined') {
		Dynamicweb.Frontend.Document.Current.error('Prototype and jQuery cannot be used at the same time with the instant search.');
	}
}

Dynamicweb.Frontend.InstantSearch._convertExtensionData = function (data) {
	/// <private />
	/// <summary>Converts the extension data array to an object.</summary>
	/// <param name="data">Extension data to convert.</param>

	var ret = {};
	var name = '';

	if (data && data.length) {
		for (var i = 0; i < data.length; i++) {
			if (data[i] != null && data[i].Name != null) {
				name = data[i].Name.toString();
				if (name.length > 0) {
					if (name.length == 1) {
						name = name.toLowerCase();
					} else {
						name = name.substr(0, 1).toLowerCase() + name.substr(1);
					}

					ret[name] = data[i].Value;
				}
			}
		}
	}

	return ret;
}
