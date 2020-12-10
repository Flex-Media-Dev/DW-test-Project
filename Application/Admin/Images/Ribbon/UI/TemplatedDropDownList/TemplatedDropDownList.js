/* Represents a collection of event handlers for a specified event */
var ControlEventHandlerCollection = function(eventName) {
    this.name = eventName;
    this.handlers = [];
}

/* Adds new handler to a collection */
ControlEventHandlerCollection.prototype.addHandler = function(handler) {
    if (!this.handlers)
        this.handlers = [];

    if (this.indexOf(handler) < 0) {
        this.handlers[this.handlers.length] = handler;
    }
}

/* Removes handler from the collection */
ControlEventHandlerCollection.prototype.removeHandler = function(handler) {
    var index = this.indexOf(handler);
    var newList = [];

    if (index != -1) {
        for (var i = 0; i < this.handlers.length; i++) {
            if (i != index)
                newList[newList.length] = this.handlers[i];
        }

        this.handlers = newList;
    }
}

/* Retrieves a 0-based index of a specified handler in a collection */
ControlEventHandlerCollection.prototype.indexOf = function(handler) {
    var ret = -1;

    if (this.handlers && this.handlers.length > 0) {
        for (var i = 0; i < this.handlers.length; i++) {
            if (this.handlers[i] == handler) {
                ret = i;
                break;
            }
        }
    }

    return ret;
}

/* Represents a control events list */
var ControlEvents = function() {
    this.allEvents = [];
}

/* Adds new handler to the list */
ControlEvents.prototype.addHandler = function(eventName, f) {
    if (typeof (this.allEvents[eventName]) == 'undefined')
        this.allEvents[eventName] = new ControlEventHandlerCollection(eventName);

    this.allEvents[eventName].addHandler(f);
}

/* Removes specified handler from the list */
ControlEvents.prototype.removeHandler = function(eventName, f) {
    this.allEvents[eventName].removeHandler(f);
}

/* Fires all event handler for a specified event */
ControlEvents.prototype.notify = function(eventName, sender, args) {
    if (this.isHandled(eventName)) {
        for (var i = 0; i < this.allEvents[eventName].handlers.length; i++) {
            if (typeof (this.allEvents[eventName].handlers[i]) == 'function')
                this.allEvents[eventName].handlers[i](sender, args);
        }
    }
}

/* Determinse whether specified event is handled (has at leas one event handler attached) */
ControlEvents.prototype.isHandled = function(eventName) {
    var ret = typeof (this.allEvents[eventName]) != 'undefined';

    if (ret) {
        ret = this.allEvents[eventName].handlers.length > 0;
    }

    return ret;
}

/* Represents a templated drop-down list */
var TemplatedDropDownList = function (controlID) {
    this.controlID = controlID;
    this._events = new ControlEvents();
    this._components = {};
    this._instanceInitialized = false;
}

/* Gets or sets a value indicating whether global initializing has been accomplished */
TemplatedDropDownList._initialized = false;

/* Creates new instance (or retrieves already created one) of an object */
TemplatedDropDownList.createInstance = function (controlID) {
    var obj = null;

    try {
        obj = eval('dd_' + controlID);
    } catch (ex) { }

    if (obj == null) {
        obj = new TemplatedDropDownList(controlID);
        window['dd_' + controlID] = obj;
    }

    return obj;
}

/* Collapses all page drop-down lists */
TemplatedDropDownList.collapseAll = function() {
    var controls = $$('div.dropDownArea');

    if (controls && controls.length > 0) {
        for (var i = 0; i < controls.length; i++) {
            TemplatedDropDownList.createInstance(controls[i].id).collapse();
        }
    }
}

/* Globally initializes drop-down lists (needs to be called only once) */
TemplatedDropDownList.initialize = function () {
    var listHeight = 0;
    var dropDownLists = null;

    if (!TemplatedDropDownList._initialized) {
        dropDownLists = $$('div.dropDownArea');

        /* 
        PVO: Setting calcuated height for all drop-down containers - this prevents content under the drop-down list
        to shift few pixels up (and down) when expanding (collapsing) drop-down list 
        */

        if (dropDownLists != null && dropDownLists.length > 0) {
            for (var i = 0; i < dropDownLists.length; i++) {
                listHeight = $(dropDownLists[i]).getHeight();
                if (listHeight <= 0) {
                    listHeight = 18;
                }

                dropDownLists[i].style.height = listHeight + 'px';
            }
        }

        TemplatedDropDownList._handleScrolling();

        Event.observe(document, 'mousedown', TemplatedDropDownList._conditionalHide);

        Event.observe(window, 'resize', function () {
            var dd = null;
            var pos = null;

            if (dropDownLists != null && dropDownLists.length > 0) {
                for (var i = 0; i < dropDownLists.length; i++) {
                    dd = TemplatedDropDownList.createInstance(dropDownLists[i].id);

                    if (dd && dd.get_isExpanded()) {
                        dd.updatePosition();
                    }
                }
            }
        });

        TemplatedDropDownList._initialized = true;
    }
}

/* Adds new handler to a 'DataExchange' event handles list */
TemplatedDropDownList.prototype.add_dataExchange = function(f) {
    this._events.addHandler('DataExchange', f);
}

/* Removes specified handler from the 'DataExchange' event handlers list */
TemplatedDropDownList.prototype.remove_dataExchange = function(f) {
    this._events.removeHandler('DataExchange', f);
}

/* Adds new handler to a 'SelectedIndexChanged' event handles list */
TemplatedDropDownList.prototype.add_selectedIndexChanged = function(f) {
    this._events.addHandler('SelectedIndexChanged', f);
}

/* Removes specified handler from the 'SelectedIndexChanged' event handlers list */
TemplatedDropDownList.prototype.remove_selectedIndexChanged = function(f) {
    this._events.removeHandler('SelectedIndexChanged', f);
}
/* Adds new handler to a 'ExpandedStateChanged' event handles list */
TemplatedDropDownList.prototype.add_expandedStateChanged = function(f) {
    this._events.addHandler('ExpandedStateChanged', f);
}

/* Removes specified handler from the 'ExpandedStateChanged' event handlers list */
TemplatedDropDownList.prototype.remove_expandedStateChanged = function(f) {
    this._events.removeHandler('ExpandedStateChanged', f);
}

TemplatedDropDownList.prototype.initializeInstance = function (force) {
    var ctrl = null;
    var elementStyle = '';

    if (!this._instanceInitialized || force) {
        ctrl = $(this.controlID);
        
        if (ctrl) {
            elementStyle = ctrl.readAttribute('style');

            if (elementStyle.length > 0) {
                if (elementStyle.lastIndexOf(';') != (elementStyle.length - 1)) {
                    elementStyle += ';';
                }

                elementStyle = elementStyle.replace(/height:[^;]+;/gi, '');
                ctrl.writeAttribute('style', elementStyle);
            }

            ctrl.style.height = ctrl.getHeight() + 'px';
        }

        this._instanceInitialized = true;
    }
}

/* Fires specified event */
TemplatedDropDownList.prototype.fireEvent = function(eventName, args) {
    this._events.notify(eventName, this, args);
}

/* Expands drop-down list */
TemplatedDropDownList.prototype.expand = function() {
    this.set_isExpanded(true);
}

/* Collapses drop-down list */
TemplatedDropDownList.prototype.collapse = function() {
    this.set_isExpanded(false);
}

/* Toggles 'Expanded' state of the drop-down list */
TemplatedDropDownList.prototype.toggleExpanded = function() {
    this.set_isExpanded(!this.get_isExpanded());
}

/* Adjusts the position of the drop-down list items container to be under the selection box */
TemplatedDropDownList.prototype.updatePosition = function() {
    var pos = this.get_dropDownPosition();
    this.set_dropDownPosition(pos.left, pos.top);
}

/* Gets value indicating whether drop-down list is expanded */
TemplatedDropDownList.prototype.get_isExpanded = function() {
    return this.get_itemsContainer().getStyle('display') != 'none';
}

/* Sets value indicating whether drop-down list is expanded */
TemplatedDropDownList.prototype.set_isExpanded = function (value) {
    var itemsContainer = null;

    if (this.get_isEnabled()) {
        itemsContainer = this.get_itemsContainer();

        if (!value) {
            this.get_expander().removeClassName('expanderActive');
            this.get_boxContainer().removeClassName('dropDownActive');

            itemsContainer.hide();
        } else {
            this.get_expander().addClassName('expanderActive');
            this.get_boxContainer().addClassName('dropDownActive');

            itemsContainer.show();

            this.updatePosition();
            this._updateDisabledItems();
        }

        this.fireEvent('ExpandedStateChanged', null);
    }
}

/* Gets value indicating whether drop-down list is enabled */
TemplatedDropDownList.prototype.get_isEnabled = function() {
    return !this.get_boxContainer().hasClassName('dropDownDisabled');
}

/* Sets value indicating whether drop-down list is enabled */
TemplatedDropDownList.prototype.set_isEnabled = function(value) {
    if (!value) {
        this.get_boxContainer().addClassName('dropDownDisabled');
    } else {
        this.get_boxContainer().removeClassName('dropDownDisabled');
    }
}

/* Gets currently selected 0-based item index */
TemplatedDropDownList.prototype.get_selectedItemIndex = function() {
    return parseInt(this.get_selectedItemIndexField().value);
}

/* Sets currently selected 0-based item index */
TemplatedDropDownList.prototype.set_selectedItemIndex = function(value) {
    this.selectItem(value);
}

/* Gets currently selected item */
TemplatedDropDownList.prototype.get_selectedItem = function() {
    var ret = null;
    var items = this.get_allItems();
    var selectedItemIndex = this.get_selectedItemIndex();

    if (items && items.length > 0 && selectedItemIndex >= 0 && selectedItemIndex < items.length) {
        ret = items[selectedItemIndex];
    }

    return ret;
}

/* Selects an item by specified 0-based item index */
TemplatedDropDownList.prototype.selectItem = function (itemIndex) {
    var allItems = this.get_allItems();
    var previousItemIndex = parseInt(this.get_selectedItemIndexField().value);
    var dataSource = null;
    var dataDestination = this.get_selectedItemContainer();

    if (allItems != null && allItems.length > 0 && allItems[itemIndex] != null && !$(allItems[itemIndex]).hasClassName('dw-list-item-disabled')) {
        if (previousItemIndex >= 0 && previousItemIndex < allItems.length) {
            $(allItems[previousItemIndex]).removeClassName('listItemSelected');

            if (itemIndex >= 0 && itemIndex < allItems.length) {
                $(allItems[itemIndex]).addClassName('listItemSelected')
                dataSource = $(allItems[itemIndex])

                this.get_selectedItemIndexField().value = itemIndex;

                this.fireEvent('SelectedIndexChanged',
                    {
                        previousItemIndex: previousItemIndex,
                        itemIndex: itemIndex,
                        item: $(allItems[itemIndex])
                    });


                if (this._events.isHandled('DataExchange')) {
                    this.fireEvent('DataExchange',
                        {
                            dataSource: dataSource,
                            dataDestination: dataDestination
                        });
                } else {
                    while (dataDestination.firstChild)
                        dataDestination.removeChild(dataDestination.firstChild);

                    for (var i = 0; i < dataSource.childNodes.length; i++) {
                        dataDestination.appendChild(dataSource.childNodes[i].cloneNode(true));
                    }
                }
            }
        }
    }
}

/* Gets the <div> element containing drop-down list items */
TemplatedDropDownList.prototype.get_itemsContainer = function() {
    if(this._components.itemsContainer == null) 
        this._components.itemsContainer = $(this.get_controlElement().select('div.dropDownItems')[0]);
        
    return this._components.itemsContainer;
}

/* Gets the <span> element containing drop-down list selection */
TemplatedDropDownList.prototype.get_selectedItemContainer = function() {
    if (this._components.selectedItemContainer == null)
        this._components.selectedItemContainer = $(this.get_controlElement().select('span.selectedItemPlaceholder')[0]);

    return this._components.selectedItemContainer;
}

/* Gets the <span> element containing drop-down list expander */
TemplatedDropDownList.prototype.get_expander = function() {
    if (this._components.expander == null)
        this._components.expander = $(this.get_boxContainer().select('span.expander')[0]);

    return this._components.expander;
}

/* Gets the <a> element containing drop-down selection box */
TemplatedDropDownList.prototype.get_boxContainer = function() {
    if (this._components.boxContainer == null)
        this._components.boxContainer = $(this.get_controlElement().select('a.dropDown')[0]);

    return this._components.boxContainer;
}

/* Gets the <div> element containing drop-down list */
TemplatedDropDownList.prototype.get_controlElement = function() {
    if(this._components.controlElement == null)
        this._components.controlElement = $(this.controlID);
        
    return this._components.controlElement;
}

/* Gets the 'x' and 'y' coordinates of the drop-down list items container */
TemplatedDropDownList.prototype.get_dropDownPosition = function () {
    var ret = { left: 0, top: 0 };
    var viewportOffsets = document.viewport.getScrollOffsets();
    var containerWidth = this.get_itemsContainer().getWidth()
    var offset = this.get_controlElement().cumulativeOffset();
    var scrollOffsets = this.get_controlElement().cumulativeScrollOffset();
    var documentWidth = document.viewport.getWidth();
    var deltaTop = 0, deltaLeft = 0;
    
    if (offset) {
        deltaTop = scrollOffsets.top - viewportOffsets.top;
        if (deltaTop < 0) {
            deltaTop = 0;
        }

        deltaLeft = scrollOffsets.left - viewportOffsets.left;
        if (deltaLeft < 0) {
            deltaLeft = 0;
        }

        ret.left = offset.left - deltaLeft;
        ret.top = offset.top + this.get_boxContainer().getHeight() - 1 - deltaTop;


        /*ret.left = offset.left;
        ret.top = offset.top + this.get_boxContainer().getHeight() - 1;*/
    }

    return ret;
}

/* Sets the 'x' and 'y' coordinates of the drop-down list items container */
TemplatedDropDownList.prototype.set_dropDownPosition = function(x, y) {
    this.get_itemsContainer().setStyle({ 'top': (y + 'px'), 'left': (x + 'px') });
}

/* Retrieves all drop-down list items */
TemplatedDropDownList.prototype.get_allItems = function() {
    if (this._components.allItems == null)
        this._components.allItems = this.get_itemsContainer().select('li');

    return this._components.allItems;
}

/* Gets the <input> element that holds currently selected 0-based item index */
TemplatedDropDownList.prototype.get_selectedItemIndexField = function() {
    if (this._components.selectedItemIndexField == null)
        this._components.selectedItemIndexField = $(this.get_controlElement().select('input.currentSelectedIndex')[0]);

    return this._components.selectedItemIndexField;
}

TemplatedDropDownList.prototype._updateDisabledItems = function () {
    /// <summary>Updates the visual state of disabled items.</summary>
    /// <private />

    var item = null;
    var disabled = [];
    var items = this.get_allItems();

    if (items && items.length) {
        for (var i = 0; i < items.length; i++) {
            item = $(items[i]);
            disabled = item.select('.dw-list-item-disabled');

            if (disabled && disabled.length) {
                item.addClassName('dw-list-item-disabled');
                for (var i = 0; i < disabled.length; i++) {
                    $(disabled[i]).removeClassName('dw-list-item-disabled');
                }
            }
        }
    }
}

/* private: Registers 'onscroll' event handler (which collapses drop-down lists) 
 on all parent DIVs and SPANs of all page drop-down lists */
TemplatedDropDownList._handleScrolling = function() {
    var dropDownLists = $$('div.dropDownArea');
    var parent = null;
    var processedElements = [];
    var canProcess = true;
    var tag = '';

    if (dropDownLists != null && dropDownLists.length > 0) {
        /* first, registering event handler for window and document objects */
        Event.observe(window, 'scroll', TemplatedDropDownList._conditionalHide);
        Event.observe(document, 'scroll', TemplatedDropDownList._conditionalHide);

        for (var i = 0; i < dropDownLists.length; i++) {
            parent = $(dropDownLists[i]).up();

            /* traversing up the DOM tree */
            while (parent != null) {
                tag = (parent.tagName + '').toLowerCase();

                /* are we on the top ? */
                if (tag != 'body') {
                    /* only looking for DIVs and SPANs */
                    if (tag == 'div' || tag == 'span') {
                        /* Determining whether this element has been processed already */
                        for (var j = 0; j < processedElements.length; j++) {
                            canProcess = processedElements[j] != parent;
                            if (!canProcess)
                                break;
                        }

                        if (canProcess) {
                            /* registering event listener */
                            processedElements[processedElements.length] = parent;
                            Event.observe(parent, 'scroll', TemplatedDropDownList._conditionalHide);
                        } else break;
                    }

                    /* moving up */
                    parent = $(parent).up();
                } else break;
            }
        }
    }
}

/* private: collapses all drop-down lists if the event occured outside any of them */
TemplatedDropDownList._conditionalHide = function(event) {
    var elm = $(Event.element(event));

    if (!elm || typeof (elm.hasClassName) != 'function' ||
                    !$(elm).hasClassName('dropDownItems')) {

        TemplatedDropDownList.collapseAll();
    }
}

/* +++ Global event handlers +++ */

if (window.attachEvent) {
    window.attachEvent('onload', function() {
        TemplatedDropDownList.initialize();
    });
} else if (window.addEventListener) {
    window.addEventListener('load', function() {
        TemplatedDropDownList.initialize();
    }, false);
}




