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

Dynamicweb.Controls.OMC.FactSelector = function (controlID) {
    /// <summary>Represents fact selector.</summary>
    /// <param name="controlID">The unique identifier of the ASP.NET control that is associated with this client object.</param>

    this._associatedControlID = controlID;
    this._autoLoad = false;
    this._provider = '';
    this._selector = null;
    this._container = '';
    this._computedFactTitle = '';
    this._unextractableFactTitle = '';
    this._droppablesInitialized = false;
    this._dropboxWidth = 0;
    this._lastSource = null;
    this._currentDroppable = null;
    this._cancelClickEvent = null;
    this._draggableContainer = null;
    this._factNodes = null;
    this._facts = null;
    this._initialized = false;
    this._loadedFacts = {};
    this._isDragging = false;

    this._prevSelection = 0;
    this._resetFactsMessage = '';
    this._invalidSetupMessage = '';

    this._providerChanged = [];
    this._isInitialLoad = true;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_factNodes = function () {
    /// <summary>Gets the list of all fact nodes.</summary>
    
    if (this._factNodes == null) {
        this._factNodes = $($(this.get_container()).select('.fact-container')[0]).select('li.fact');
    }

    if (this._factNodes == null) {
        this._factNodes = [];
    }

    return this._factNodes;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_invalidSetupMessage = function () {
    /// <summary>Gets the error message for invalid table setup.</summary>

    return this._invalidSetupMessage;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.set_invalidSetupMessage = function (value) {
    /// <summary>Gets the error message for invalid table setup.</summary>
    /// <param name="value">The error message for invalid table setup.</param>

    this._invalidSetupMessage = value;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_resetFactsMessage = function () {
    /// <summary>Gets the message that is displayed when the user tries to change the provider and there is at least one fact has been selected.</summary>

    return this._resetFactsMessage;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.set_resetFactsMessage = function (value) {
    /// <summary>Sets the message that is displayed when the user tries to change the provider and there is at least one fact has been selected.</summary>
    /// <param name="value">The message to display.</param>

    this._resetFactsMessage = value;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_facts = function () {
    /// <summary>Gets the list of all currently loaded facts mapped to their IDs.</summary>

    if (!this._facts) {
        this._facts = new Hash();
    }

    return this._facts;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_computedFactTitle = function () {
    /// <summary>Gets the title for computed fact.</summary>

    return this._computedFactTitle;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.set_computedFactTitle = function (value) {
    /// <summary>Sets the title for computed fact.</summary>
    /// <param name="value">The title for computed fact.</param>

    this._computedFactTitle = value;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_unextractableFactTitle = function () {
    /// <summary>Gets the title for unextractable fact.</summary>

    return this._unextractableFactTitle;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.set_unextractableFactTitle = function (value) {
    /// <summary>Sets the title for unextractable fact.</summary>
    /// <param name="value">The title for unextractable fact.</param>

    this._unextractableFactTitle = value;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_container = function () {
    /// <summary>Gets the identifier of the DOM element associated with this control.</summary>

    if (!this._container) {
        this._container = $$('input[name="' + this.get_associatedControlID() + '"]');
        if (this._container && this._container.length) {
            this._container = this._container[0].id;
        }
    }

    return this._container;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.set_container = function (value) {
    /// <summary>Sets the identifier of the DOM element associated with this control.</summary>
    /// <param name="value">The identifier of the DOM element associated with this control.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_dropboxWidth = function () {
    /// <summary>Gets the width of the dropbox area.</summary>

    return this._dropboxWidth;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.set_dropboxWidth = function (value) {
    /// <summary>Sets the width of the dropbox area.</summary>
    /// <param name="value">The the width of the dropbox area.</param>

    this._dropboxWidth = parseInt(value, 10);

    if (isNaN(this._dropboxWidth) || this._dropboxWidth < 0) {
        this._dropboxWidth = 0;
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_autoLoad = function () {
    /// <summary>Gets value indicating whether fact list must be loaded upon the page load.</summary>

    return this._autoLoad;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.set_autoLoad = function (value) {
    /// <summary>Sets value indicating whether fact list must be loaded upon the page load.</summary>
    /// <param name="value">Value indicating whether fact list must be loaded upon the page load.</param>

    this._autoLoad = !!value;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_provider = function () {
    /// <summary>Gets the currently selected provider.</summary>

    return this._provider;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.set_provider = function (value) {
    /// <summary>Sets the currently selected provider.</summary>
    /// <summary>Currently selected provider.</summary>

    this._provider = value;

    if (!this._selector) {
        this._selector = $(this.get_container()).select('select');
        if (this._selector && this._selector.length) {
            this._selector = this._selector[0];
        }

        if (this._selector) {
            for (var i = 0; i < this._selector.length; i++) {
                if (this._selector.options[i].value == this._provider) {
                    this._selector.selectedIndex = i;
                    break;
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_isEmpty = function () {
    /// <summary>Gets value indicating whether no facts has been selected in any area.</summary>

    var ret = true;

    if (this.getSelectedFacts('ColumnLabels').length) {
        ret = false;
    } else if (this.getSelectedFacts('RowLabels').length) {
        ret = false;
    } else if (this.getSelectedFacts('Values').length) {
        ret = false;
    } else if (this.getSelectedFacts('Filters').length) {
        ret = false;
    }

    return ret;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.providerChanged = function () {
    /// <summary>Occurs when provider has been changed.</summary>

    var self = this;

    if (!this._selector) {
        this._selector = $(this.get_container()).select('select');
        if (this._selector && this._selector.length) {
            this._selector = this._selector[0];
        }
    }

    if (this._selector) {
        if (this._ensureChangeSelection()) {
            this._prevSelection = this._selector.selectedIndex;
            this._provider = this._selector.options[this._selector.selectedIndex].value;

            this.load();
        } else {
            this._selector.selectedIndex = this._prevSelection;
        }
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.get_associatedControlID = function () {
    /// <summary>Gets the unique identifier of the ASP.NET control that is associated with this client object.</summary>

    return this._associatedControlID;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.set_associatedControlID = function (value) {
    /// <summary>Sets the unique identifier of the ASP.NET control that is associated with this client object.</summary>
    /// <param name="value">The unique identifier of the ASP.NET control that is associated with this client object.</param>

    this._associatedControlID = value;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.load = function (provider, onComplete) {
    /// <summary>Loads fact list for a given provider.</summary>
    /// <param name="onComplete">Callback to be executed when load completes.</param>
    /// <param name="provider">Provider identity.</param>

    var self = this;
    var callback = null;
    var initializing = this._isInitialLoad;
    var p = provider || this.get_provider();
    var noData = $($(this.get_container()).select('.fact-selector-empty')[0]);
    var loadingData = $($(this.get_container()).select('.fact-selector-loading')[0]);

    onComplete = onComplete || function () { }

    callback = function (results) {
        self._loadedFacts[p] = results;

        loadingData.hide();

        self.render(results);

        setTimeout(function () {
            self.notify('providerChanged', { provider: p, initializing: initializing });
        }, 50);

        self._isInitialLoad = false;

        onComplete(results);
    }

    if (p) {
        if (this._loadedFacts[p]) {
            callback(this._loadedFacts[p]);
        } else {
            Dynamicweb.Ajax.DataLoader.load({ target: this.get_associatedControlID(), argument: p, onComplete: callback });

            noData.hide();
            loadingData.show();
        }
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.initialize = function (onComplete) {
    /// <summary>Initializes the instance.</summary>

    onComplete = onComplete || function () { }

    if (!this._initialized) {
        setTimeout(function () {
            onComplete();
        }, 50);
        this._initialized = true;
    } else {
        onComplete();
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.render = function (facts) {
    /// <summary>Populates the given list of facts.</summary>
    /// <param name="facts">Facts to populate.</param>

    var self = this;
    var fact = null;
    var group = null;
    var subGroup = null;
    var draggableCss = '';
    var automaticFilters = [];
    var subGroupContainer = null;
    var container = $($(this.get_container()).select('.fact-container')[0]);
    var noData = $($(this.get_container()).select('.fact-selector-empty')[0]);

    noData.show();
    container.hide();

    if (facts != null && facts.length > 0) {
        container.innerHTML = '';
        this._factNodes = null;

        for (var i = 0; i < facts.length; i++) {
            subGroup = new Element('ul', { 'class': 'facts' });
            group = new Element('ul', { 'class': 'fact-category' });
            subGroupContainer = new Element('li', { 'class': 'fact-category-name' }).update(facts[i].name);

            subGroupContainer.appendChild(subGroup);
            group.appendChild(subGroupContainer);

            for (var j = 0; j < facts[i].facts.length; j++) {
                this.get_facts().set(facts[i].facts[j].uniqueID, facts[i].facts[j]);

                draggableCss = 'fact-draggable';
                if (!facts[i].facts[j].isExtractable) {
                    draggableCss = 'fact-draggable-unextractable';
                } else if (facts[i].facts[j].isComputed) {
                    draggableCss = 'fact-draggable-computed';
                }

                if (!!facts[i].facts[j].isAutomatic) {
                    automaticFilters[automaticFilters.length] = facts[i].facts[j].uniqueID;
                }

                fact = new Element('li', { 'class': 'fact' + (!facts[i].facts[j].isExtractable ? ' fact-unextractable' : (facts[i].facts[j].isComputed ? ' fact-computed' : '')) +
                    ' ' + draggableCss, 'id': facts[i].facts[j].uniqueID
                }).update(facts[i].facts[j].name);

                if (!facts[i].facts[j].isExtractable) {
                    fact.writeAttribute('title', this.get_unextractableFactTitle());
                } else if (facts[i].facts[j].isComputed) {
                    fact.writeAttribute('title', this.get_computedFactTitle());
                }

                Event.observe(fact, 'mousedown', function (e) { self._isDragging = true; });
                Event.observe(fact, 'mouseup', function (e) { self._isDragging = false; });
                Event.observe(fact, 'selectstart', function (e) {
                    Event.stop(e);

                    e.cancelBubble = true;
                    return false;
                });

                subGroup.appendChild(fact);
            }

            group.appendChild(subGroup);
            container.appendChild(group);
        }

        noData.hide();
        container.show();

        this._initializeDraggables();

        if (this.get_isEmpty() && automaticFilters.length) {
            for (var i = 0; i < automaticFilters.length; i++) {
                this.addFact('Filters', automaticFilters[i], true);
            }
        }
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.findFact = function (name) {
    /// <summary>Finds the first fact that matches the given name.</summary>
    /// <param name="name">Local name of the fact.</param>
    /// <returns>Found fact or null (</returns>

    var keys = [];
    var ret = null;
    
    if (name) {
        if (typeof (name) == 'string') {
            ret = this.get_facts().get(name);
            if (!ret) {
                name = name.toLowerCase();
                keys = this.get_facts().keys();

                if (keys && keys.length) {
                    for (var i = 0; i < keys.length; i++) {
                        if (keys[i].toLowerCase().lastIndexOf(name) == keys[i].length - name.length) {
                            ret = this.get_facts().get(keys[i]);
                            break;
                        }
                    }
                }
            }
        } else if (typeof (name.uniqueID) != 'undefined') {
            ret = name;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.addFact = function (area, fact, silentMode) {
    /// <summary>Adds new fact to the given area.</summary>
    /// <param name="area">Target area.</param>
    /// <param name="fact">Source fact.</param>
    /// <param name="silentMode">Indicates whether to silently skip adding a fact if the operation is refused for any reason.</param>

    var f = fact;
    var values = [];
    var rowLabels = [];
    var canAdd = false;
    var columnLabels = [];
    var isExistingFact = false;
    var existingFacts = this.getSelectedFacts(area);
    var areaField = document.getElementById(this.get_container() + '_' + area + '_Value');
    
    if (area) {
        if (typeof (fact) == 'string') {
            f = this.get_facts().get(fact);
        }

        if (f) {
            /* In case of new facts */
            this.get_facts().set(f.uniqueID, f);

            if (existingFacts != null && existingFacts.length) {
                canAdd = true;

                for (var i = 0; i < existingFacts.length; i++) {
                    if (existingFacts[i].uniqueID == f.uniqueID) {
                        isExistingFact = true;
                        canAdd = false;
                        break;
                    }
                }
            } else {
                canAdd = true;
            }
            
            if (canAdd) {
                values = this.getSelectedFacts('Values');
                rowLabels = this.getSelectedFacts('RowLabels');
                columnLabels = this.getSelectedFacts('ColumnLabels');

                if (area == 'RowLabels' || area == 'ColumnLabels') {
                    canAdd = existingFacts.length == 0;
                    if (canAdd) {
                        if (area == 'RowLabels') {
                            canAdd = values.length <= 1 || columnLabels.length == 0;
                        } else if (area == 'ColumnLabels') {
                            canAdd = values.length <= 1;
                        }
                    }
                } else if (area == 'Values') {
                    if (existingFacts.length > 0) {
                        if (rowLabels.length > 0) {
                            canAdd = columnLabels.length == 0;
                        } else if (columnLabels.length > 0) {
                            canAdd = rowLabels.length == 0;
                        }

                        if (canAdd) {
                            canAdd = existingFacts.length < 5;
                        }
                    }

                    if (canAdd && (rowLabels.length > 0 || columnLabels.length > 0)) {
                        if (rowLabels.length > 0) {
                            for (var i = 0; i < rowLabels.length; i++) {
                                if (rowLabels[i].uniqueID == f.uniqueID) {
                                    canAdd = false;
                                    break;
                                }
                            }
                        }

                        if (canAdd && columnLabels.length > 0) {
                            canAdd = existingFacts.length == 0;

                            if (canAdd) {
                                for (var i = 0; i < columnLabels.length; i++) {
                                    if (columnLabels[i].uniqueID == f.uniqueID) {
                                        canAdd = false;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (area == 'Filters') {
                    canAdd = existingFacts.length < 5;
                }
            }

            if (canAdd) {
                this.renderSelectedFact(area, f);

                if (areaField) {
                    if (areaField.value && areaField.value.length) {
                        areaField.value += ',';
                    }

                    areaField.value += f.uniqueID;
                }
            } else if (typeof (silentMode) == 'undefined' || !silentMode) {
                if (!isExistingFact) {
                    alert(this.get_invalidSetupMessage());
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.removeFact = function (area, fact) {
    /// <summary>Removes specified fact from the given area.</summary>
    /// <param name="area">Target area.</param>
    /// <param name="fact">Source fact.</param>

    var f = fact;
    var facts = null;
    var newFacts = [];
    var newValue = '';
    var factRow = document.getElementById(fact + '_' + area);
    var areaField = document.getElementById(this.get_container() + '_' + area + '_Value');

    if (area) {
        if (typeof (fact) == 'string') {
            f = this.get_facts().get(fact);
        }

        if (f) {
            if (factRow) {
                $(factRow).next(0).remove();
                $(factRow).remove();
            }

            if (areaField && areaField.value) {
                facts = areaField.value.split(',');
                if (facts != null && facts.length) {
                    for (var i = 0; i < facts.length; i++) {
                        if (facts[i] != f.uniqueID) {
                            newFacts[newFacts.length] = facts[i];
                        }
                    }

                    for (var i = 0; i < newFacts.length; i++) {
                        newValue += newFacts[i];
                        if (i < (newFacts.length - 1)) {
                            newValue += ',';
                        }
                    }

                    areaField.value = newValue;
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.getSelectedFacts = function (area) {
    /// <summary>Returns the list of facts placed into the given area.</summary>
    /// <param name="area">Target area.</param>

    var f = null;
    var ret = [];
    var facts = null;
    var areaField = document.getElementById(this.get_container() + '_' + area + '_Value');

    if (areaField) {
        facts = areaField.value.split(',');
        if (facts != null && facts.length) {
            for (var i = 0; i < facts.length; i++) {
                f = this.get_facts().get(facts[i]);
                if (f) {
                    ret[ret.length] = f;
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.FactSelector.prototype._ensureChangeSelection = function () {
    /// <summary>Ensures that the user is about changing the provider even if there are some facts already selected.</summary>
    /// <private />

    var ret = true;
    var facts = null;
    var nonEmptyAreas = [];
    var hasSelectedFacts = false;
    var areas = ['ColumnLabels', 'RowLabels', 'Values', 'Filters'];

    for (var i = 0; i < areas.length; i++) {
        facts = this.getSelectedFacts(areas[i]);
        if (facts && facts.length) {
            if (!hasSelectedFacts) {
                hasSelectedFacts = true;
            }

            nonEmptyAreas[nonEmptyAreas.length] = { area: areas[i], facts: facts };
        }
    }

    if (hasSelectedFacts) {
        ret = !!confirm(this.get_resetFactsMessage());
        if (ret) {
            for (var i = 0; i < nonEmptyAreas.length; i++) {
                for (var j = 0; j < nonEmptyAreas[i].facts.length; j++) {
                    this.removeFact(nonEmptyAreas[i].area, nonEmptyAreas[i].facts[j].uniqueID);
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.FactSelector.prototype._initializeDraggables = function () {
    /// <summary>Performs initialization of the draggable objects.</summary>
    /// <private />

    var self = this;
    var facts = this.get_factNodes();

    if (facts != null && facts.length) {
        for (var i = 0; i < facts.length; i++) {
            new Draggable(self._getDraggableContainer(), {
                revert: true,
                handle: facts[i],
                delay: 200,

                starteffect: function () { },
                endeffect: function () { },

                onStart: function (draggable, event) {
                    var elm = draggable.element;
                    var textContainer = elm.select('.fact-draggable-content');

                    if (self._isDraggableFact(draggable)) {
                        if (textContainer && textContainer.length > 0) {
                            textContainer = textContainer[0];

                            if (typeof (draggable.handle.innerText) != 'undefined') {
                                textContainer.innerHTML = draggable.handle.innerText;
                            } else if (typeof (draggable.handle.textContent) != 'undefined') {
                                textContainer.innerHTML = draggable.handle.textContent;
                            }

                            elm.className = 'fact-draggable-container ' + draggable.handle.className;
                        }

                        elm.style.display = 'block';
                        self._lastSource = draggable.handle;

                        document.body.style.cursor = 'url(\'/Admin/Images/Ribbon/UI/Tree/img/grab.cur\'), move';
                    }
                },

                onDrag: function (draggable, event) {
                    var elm = draggable.element;

                    /* 
                    +++ overriding draggable's offset and position +++ 
                    This is required in order to make the draggable element follow the mouse pointer.
                    */
                    draggable.offset = [1, 8];
                    elm.style.left = 0;
                    elm.style.top = 0;
                },

                onEnd: function (draggable, event) {
                    var elm = draggable.element;

                    elm.style.display = 'none';
                    document.body.style.cursor = 'auto';

                    self._currentDroppable = null;

                    /* There is a "click" event which if fired after the "mouseup" event (in IE only) - we need to cancel that */
                    self._cancelClickEvent = true;

                    self._isDragging = false;
                }
            });
        }
    }

    if (!this._droppablesInitialized) {
        /* Canceling "selectstart" event (making drag'n'drop look prettier) */
        Event.observe(document.body, 'selectstart', function (evt) {
            if (self._isDragging) {
                Event.stop(event);
                event.cancelBubble = true;

                return false;
            }
        });

        /* Droppables patch - includes scroll offsets */
        Droppables.isAffected = function (point, element, drop) {
            return (
          (drop.element != element) &&
          ((!drop._containers) ||
            this.isContained(element, drop)) &&
          ((!drop.accept) ||
            (Element.classNames(element).detect(
              function (v) { return drop.accept.include(v) }))) &&
          Position.withinIncludingScrolloffsets(drop.element, point[0], point[1]));
        }

        this._initializeDroppable('ColumnLabels', 'fact-draggable');
        this._initializeDroppable('RowLabels', 'fact-draggable');
        this._initializeDroppable('Values', ['fact-draggable', 'fact-draggable-computed']);
        this._initializeDroppable('Filters', ['fact-draggable', 'fact-draggable-unextractable']);

        this._droppablesInitialized = true;
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype._initializeDroppable = function (idSuffix, acceptClass) {
    /// <summary>Initializes droppable area.</summary>
    /// <param name="idSuffix">ID suffix.</param>
    /// <param name="acceptClass">A list of CSS classes that are accepted by this droppable.</param>
    /// <private />

    var id = '';
    var self = this;

    if (idSuffix) {
        id = this.get_container() + '_' + idSuffix + '_Outer';
        if (document.getElementById(id)) {
            Droppables.add(id, {
                accept: acceptClass,
                hoverclass: 'fact-dropbox-drop',

                onHover: function (draggable, droppable) {
                    self._currentDroppable = droppable;
                },

                onDrop: function (draggable, droppable, event) {
                    self._factDropped(self._lastSource, droppable, event, idSuffix);
                }
            });
        }
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype._isDraggableFact = function (draggable) {
    /// <summary>Determines whether specified draggable object represents a draggable fact.</summary>
    /// <param name="draggable">Draggable object.</param>
    /// <private />

    return draggable.handle && draggable.handle.className && draggable.handle.className.indexOf('fact-draggable') >= 0;
}

Dynamicweb.Controls.OMC.FactSelector.prototype._getDraggableContainer = function () {
    /// <summary>Returns draggable object.</summary>
    /// <private />

    var self = this;

    if (!this._draggableContainer) {
        this._draggableContainer = document.getElementById(this.get_container() + '_draggableContainer');

        if (Prototype.Browser.IE) {
            Event.stopObserving(document.body, 'click', self._onClick);
            Event.observe(document.body, 'click', self._onClick.bindAsEventListener(self));
        }
    }

    return this._draggableContainer;
}

Dynamicweb.Controls.OMC.FactSelector.prototype._onClick = function (event) {
    /// <summary>Internal member. Handles "click" event of a document's body.</summary>
    /// <param name="event">Event data.</param>
    /// <private />

    var ret = true;
    var element = Event.element(event);

    /* Do we need to cancel this event ? */
    if (this._cancelClickEvent) {
        /* If the source element is not our drag handle then we won't cancel any more "click" events */
        if (!(element.id == this._getDraggableContainer().id ||
            element.up('.fact-draggable-container'))) {

            this._cancelClickEvent = false;
        }

        /* Canceling event */
        Event.stop(event);
        event.cancelBubble = true;
        ret = false;
    }

    return ret;
}

Dynamicweb.Controls.OMC.FactSelector.prototype._factDropped = function (draggable, droppable, evt, area) {
    /// <summary>Occurs when the fact has been dropped to the corresponding drop box.</summary>
    /// <param name="draggable">Draggable object.</param>
    /// <param name="droppable">Droppable object.</param>
    /// <param name="evt">Event object.</param>
    /// <param name="area">ID of the target area.</param>
    /// <private />

    var container = this._getDraggableContainer();
    var fact = this.get_facts().get(draggable.id);

    container.className = 'fact-draggable-container';

    if (this._allowDrop(area, fact)) {
        this.addFact(area, fact);
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.renderSelectedFact = function (boxID, fact) {
    /// <summary>Renders new selected fact.</summary>
    /// <param name="boxID">Target area.</param>
    /// <param name="fact">Source fact.</param>
    /// <private />

    var width = 0;
    var row = null;
    var self = this;
    var title = null;
    var deleteButton = null;
    var box = document.getElementById(this.get_container() + '_' + boxID);

    if (box && fact) {
        /* In case of new facts */
        this.get_facts().set(fact.uniqueID, fact);

        width = this.get_dropboxWidth();

        if (width <= 0) {
            width = $(box).getWidth();
        } 

        row = new Element('div', { 'id': fact.uniqueID + '_' + boxID, 'class': 'fact-area-row ' + (!fact.isExtractable ? 'fact-unextractable' : (fact.isComputed ? 'fact-computed' : 'fact')) });
        title = new Element('div', { 'class': 'fact-area-row-title' }).update(fact.name);
        deleteButton = new Element('div', { 'class': 'fact-area-row-delete' });

        title.setStyle({ 'width': width - 40 + 'px' });

        row.appendChild(title);

        Event.observe(deleteButton, 'click', function () {
            self.removeFact(boxID, fact.uniqueID);
        });

        row.appendChild(deleteButton);

        box.appendChild(row);
        box.appendChild(new Element('div', { 'class': 'provider-clear' }));
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype._allowDrop = function (boxID, fact) {
    /// <summary>Determines whether specified fact can be dropped into specified box.</summary>
    /// <param name="boxID">Target area.</param>
    /// <param name="fact">Source fact.</param>
    /// <private />

    return true;
}

Dynamicweb.Controls.OMC.FactSelector.prototype.add_ready = function (callback) {
    /// <summary>Registers new callback which is executed when the page is loaded.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }
    Event.observe(document, 'dom:loaded', function () {
        callback(this, {});
    });
}

Dynamicweb.Controls.OMC.FactSelector.prototype.add_providerChanged = function (callback) {
    /// <summary>Registers new callback which is executed when user changes report provider.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback) {
        this._providerChanged[this._providerChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.FactSelector.prototype.notify = function (eventName, args) {
    /// <summary>Notifies clients about specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];

    if (eventName) {
        if (!args) {
            args = {};
        }

        eventName = eventName.toLowerCase();
        if (eventName == 'providerchanged') {
            callbacks = this._providerChanged;
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