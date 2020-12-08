/* +++++ Represents a Grid row type +++++ */

var EditableGridRowType = {
    /* Header row */
    header: 1,

    /* Data row */
    dataRow: 2,

    /* Footer row */
    footer: 3
}

/* +++++ Represents a Grid row navigator +++++ */

var EditableGridNavigator = function (gridObject, eventHandlers) {
    this.grid = gridObject;
    this.eventHandlers = eventHandlers;

    if (!this.eventHandlers)
        this.eventHandlers = {};

    this._elementRow = null;
    this._elementIndex = -1;
    this._elementSelector = '';

    /* TODO: event supported only by MSIE */
    $(document.body).observe('focusin', this.focusEvent.bind(this));
}

/* Event: fired when page element receives focus */
EditableGridNavigator.prototype.focusEvent = function (event) {
    var elm = Event.element(event);
    var elements = null;
    var row = this.grid.findContainingRow(elm);

    this._elementRow = null;
    this._elementIndex = -1;
    this._elementSelector = '';

    /* Retrieving element information */
    if (row) {
        this._elementRow = row;
        this._elementSelector = this.buildSelector(elm);

        if (this._elementSelector.length > 0) {
            elements = row.element.select(this._elementSelector);

            for (var i = 0; i < elements.length; i++) {
                if (elements[i] == elm) {
                    this._elementIndex = i;
                    break;
                }
            }
        }
    }
}

/* Builds CSS selector based on the specified element */
EditableGridNavigator.prototype.buildSelector = function (element) {
    var ret = '';
    var inputType = element.readAttribute('type');

    if (!inputType)
        inputType = '';

    if (element.tagName.toLowerCase() == 'input' &&
        inputType.toLowerCase() != 'hidden') {

        ret = 'input[type="' + inputType + '"]'
    }

    return ret;
}

/* Navigates to the next grid gow */
EditableGridNavigator.prototype.navigateDown = function () {
    if (this._elementRow)
        this.navigateToRow(this._elementRow.rowIndex + 1);
}

/* Navigates to the previous grid gow */
EditableGridNavigator.prototype.navigateUp = function () {
    if (this._elementRow)
        this.navigateToRow(this._elementRow.rowIndex - 1);
}

/* Navigates to the grid gow specified by row index */
EditableGridNavigator.prototype.navigateToRow = function (rowIndex) {
    var allRows = null;
    var targetRow = null;
    var elements = null;

    if (this._elementIndex != -1 && this._elementSelector.length > 0) {
        allRows = this.grid.rows.getAll();

        if (allRows.length > 0 && rowIndex >= 0 && rowIndex < allRows.length) {
            targetRow = allRows[rowIndex];

            elements = targetRow.element.select(this._elementSelector);
            if (elements.length > 0) {
                /* Executing 'beforeNavigate' event */
                if (typeof (this.eventHandlers.beforeNavigate) == 'function')
                    this.eventHandlers.beforeNavigate(this._elementRow, targetRow);

                /* Moving focus */
                elements[this._elementIndex].focus();

                /* Executing 'afterNavigate' event */
                if (typeof (this.eventHandlers.afterNavigate) == 'function')
                    this.eventHandlers.afterNavigate(this._elementRow, targetRow);
            }
        }
    }
}


/* +++++ Represents a single Grid row +++++ */

var EditableGridRow = function (rowID, rowElement, isSelected, gridID) {
    this.ID = rowID;
    this.element = rowElement;
    this.isSelected = isSelected;
    this.rowType = null;
    this.rowIndex = -1;
    this.gridID = '';

    if (this.element) {

        if (!gridID) {
            gridID = EditableGridCache.getGridIdByElement(this.element);
        }

        this.gridID = gridID;

        this.rowType = EditableGridRow.getRowType(this.element);
        this.rowIndex = EditableGridRow.getRowIndex(this.element, gridID);
    }
}

/* Retrieves the Grid row by specified DOM table row */
EditableGridRow.fromElement = function (element, rowID, gridID) {
    var ret = null;

    if (element) {
        if (!rowID)
            rowID = element.readAttribute('__rowID');

        ret = new EditableGridRow(rowID, element,
            element.readAttribute('__selected') == 'true', gridID);
    }

    return ret;
}

/* Retrieves a row type for specified Grid row */
EditableGridRow.getRowType = function (row) {
    var ret = EditableGridRowType.dataRow;
    var classNames = null;

    if (typeof (row.setEnableHighlighting) != 'undefined')
        ret = row.rowType;
    else {
        classNames = row.readAttribute('class');

        if (classNames) {
            if (classNames.indexOf('header') >= 0)
                ret = EditableGridRowType.header;
            else if (classNames.indexOf('footer') >= 0)
                ret = EditableGridRowType.footer;
        }
    }

    return ret;
}

/* Retrieves the 0-based index of the specified row. */
EditableGridRow.getRowIndex = function (row, gridId) {
    var ret = -1;
    var elm = row;
    var siblings = [];

    if (typeof (row.setEnableHighlighting) != 'undefined') {
        elm = row.element;
        ret = row.rowIndex;
    }
    else {
        if (gridId) {
            var hIndex = EditableGridCache.getRowIndex(gridId, elm.id);
            if (hIndex != null) {
                return hIndex;
            }
        }
    }

    if (ret < 0) {
        siblings = $(elm).previousSiblings();
        ret = siblings.length - 1;

        if (siblings.length > 1 &&
            EditableGridRow.getRowType(siblings[siblings.length - 1]) == EditableGridRowType.header) {

            ret--;
        }
    }

    if (gridId) {
        EditableGridCache.setRowIndex(gridId, elm.id, ret);
    }

    return ret;
}

/* Determines whether specified Grid rows are equals */
EditableGridRow.equals = function (row1, row2) {
    var r1 = row1, r2 = row2;

    if (typeof (r1.element) != 'undefined') r1 = r1.element;
    if (typeof (r2.element) != 'undefined') r2 = r2.element;

    return ($(r1).readAttribute('__rowID') ==
        $(r2).readAttribute('__rowID'));
}

/* Retrieves the row control by its ID */
EditableGridRow.prototype.findControl = function (controlID) {
    var ret = null;

    if (this.element) {
        ret = $(this.element).select('*[id$="' + controlID + '"]');
        if (ret && ret.length > 0)
            ret = ret[0];
    }

    return ret;
}

/* Changes the 'Highlighted' state of a row */
EditableGridRow.prototype.setHighlighted = function (isHighlighted) {
    var row = this.element;

    /* The element is not a table row - searching in parent nodes */
    while (row.tagName.toLowerCase() != 'tr')
        row = row.up();

    /* Highlighting a row with a custom color (if provided) */

    if (isHighlighted) {
        if (!row.hasClassName('selectedRow')) {
            row.addClassName('selectedRow');
            row.removeClassName('highlightRow');
        }
    } else {
        if (!row.hasClassName('highlightRow')) {
            row.removeClassName('selectedRow');
            row.addClassName('highlightRow');
        }
    }
}

/* Changes higlighting feature availability for current row */
EditableGridRow.prototype.setEnableHighlighting = function (enabled) {
    var className = 'highlightRow';

    if (enabled && !this.isSelected) {
        if (!this.element.hasClassName(className))
            this.element.addClassName(className);
    } else {
        if (this.element.hasClassName(className))
            this.element.removeClassName(className);
    }
}

/* Changes the 'Selected' state for a current row */
EditableGridRow.prototype.setSelected = function (isSelected) {
    var row = this.element;

    if (row.tagName.toLowerCase() == 'td')
        row = row.up();

    if (row && row.tagName.toLowerCase() == 'tr') {
        row.writeAttribute('__selected', (isSelected ? 'true' : 'false'));
        this.isSelected = isSelected;
        this.setHighlighted(isSelected);
    }
}



/* +++++ Represents a Grid row collection +++++ */

var EditableGridRowCollection = function (containerID) {
    this.containerID = containerID;
}

/* Retrieves all Grid rows */
EditableGridRowCollection.prototype.getAll = function () {
    var returnRows = [];
    var rows = $(this.containerID).select('tr[__rowID]');

    if (rows && rows.length > 0) {
        for (var i = 0; i < rows.length; i++)
            returnRows[returnRows.length] = EditableGridRow.fromElement(rows[i], null, this.containerID);
    }

    return returnRows;
}

/* Retrieves Grid row by specified row ID */
EditableGridRowCollection.prototype.getRowByID = function (rowID) {
    var ret = null;
    var matches = $(this.containerID).select('tr[__rowID="' + rowID + '"]');

    if (matches && matches.length > 0)
        ret = EditableGridRow.fromElement(matches[0], rowID, this.containerID);

    return ret;
}

/* Changes the 'Selected' state of all Grid rows */
EditableGridRowCollection.prototype.setSelected = function (areSelected) {
    var rows = this.getSelected(!areSelected);

    for (var i = 0; i < rows.length; i++) {
        rows[i].setSelected(areSelected);
    }
}

/* Retrieves all Grid rows with the specified 'Selected' state */
EditableGridRowCollection.prototype.getSelected = function (selectedState) {
    var state = (typeof (selectedState) != 'undefined' ? (selectedState ? 'true' : 'false') : 'true');
    var matches = $(this.containerID).select('tr[__selected="' + state + '"]');
    var ret = [];

    if (matches && matches.length > 0) {
        for (var i = 0; i < matches.length; i++)
            ret[ret.length] = EditableGridRow.fromElement(matches[i], null, this.containerID);
    }

    return ret;
}

/* Enables rows highlighting */
EditableGridRowCollection.prototype.enableHighlighting = function () {
    this.setEnableHighlighting(true);
}

/* Disables rows highlighting */
EditableGridRowCollection.prototype.disableHighlighting = function () {
    this.setEnableHighlighting(false);
}

/* Changes higlighting feature availability for all Grid rows */
EditableGridRowCollection.prototype.setEnableHighlighting = function (enabled) {
    var rows = this.getAll();

    for (var i = 0; i < rows.length; i++)
        rows[i].setEnableHighlighting(enabled);
}


/* +++++ Supports rows sorting +++++ */

var EditableGridSortable = function (tableID) {
    this.tableID = tableID;
    this.tableObj = $(this.tableID);

    this.dragObject = null;
    this.mouseOffset = null;

    this.oldY = 0;
}

/* Retrieves the position of the specified DOM element */
EditableGridSortable.prototype.getPosition = function (elm) {
    var left = 0, top = 0;

    if (elm.offsetHeight == 0)
        elm = elm.firstChild;

    while (elm.offsetParent) {
        left += elm.offsetLeft;
        top += elm.offsetTop;
        elm = elm.offsetParent;
    }

    left += elm.offsetLeft;
    top += elm.offsetTop;

    return { x: left, y: top };
}

/* Retrieves the mouse offset position for specified DOM element */
EditableGridSortable.prototype.getMouseOffset = function (target, event) {
    var docPosition = this.getPosition(target);

    return { x: Event.pointerX(event) - docPosition.x, y: Event.pointerY(event) - docPosition.y };
}

/* Makes specified row draggable */
EditableGridSortable.prototype.makeDraggable = function (row) {
    row.observe('mousedown', this.dragStartEvent.bind(this));
}

/* Event: fired then dragging is initialized */
EditableGridSortable.prototype.dragStartEvent = function (event) {
    var elm = Event.element(event);
    var rows = new EditableGridRowCollection(this.tableID);
    var canDrag = true;

    while (elm.tagName.toLowerCase() != 'tr') {
        if (elm.tagName.toLowerCase() == 'td') {
            canDrag = elm.readAttribute('__nodrag') != 'true';
        }

        elm = elm.up();
        if (!elm) break;
    }

    if (elm && canDrag) {
        this.dragObject = elm;
        this.mouseOffset = this.getMouseOffset(elm, event);
    } else {
        this.dragObject = null;
    }
}

/* Finds drop target by specified Y-corrdinate */
EditableGridSortable.prototype.findDropTargetRow = function (y) {
    var rows = new EditableGridRowCollection(this.tableID);
    var tableRows = rows.getAll();
    var ret = null;

    for (var i = 0; i < tableRows.length; i++) {
        var row = tableRows[i].element;
        var rowY = this.getPosition(row).y;
        var rowHeight = parseInt(row.offsetHeight) / 2;

        if (row.offsetHeight == 0) {
            rowY = this.getPosition(row.firstChild).y;
            rowHeight = parseInt(row.firstChild.offsetHeight) / 2;
        }

        if ((y > (rowY - rowHeight)) && (y < (rowY + rowHeight))) {
            ret = row;
            break;
        }
    }

    return ret;
}

var EditableGridCache = {

    rowsIndex: new Hash(),

    getGridIdByElement: function (element) {
        return element.parentElement.parentElement.id;
    },

    setRowIndex: function (gridId, rowId, index) {
        EditableGridCache.rowsIndex.set(gridId + rowId, index);
    },

    getRowIndex: function (gridId, rowId) {
        var index = EditableGridCache.rowsIndex.get(gridId + rowId);
        if (index === undefined) {
            return null;
        }
        return index;
    },

    clearRowIndex: function () {
        EditableGridCache.rowsIndex = new Hash();
    }
}

/* +++++ Represents an editable grid +++++ */

var EditableGrid = function (gridID, requestID) {
    this.gridID = gridID;
    this.requestID = requestID;
    this.hasHeader = false;
    this.hasFooter = false;
    this.headerRow = null;
    this.footerRow = null;
    this.notFoundRow = null;
    this.isBusy = false;

    this.rows = new EditableGridRowCollection(this.gridID);
    this.sortables = new EditableGridSortable(this.gridID);
    this.navigator = null;

    this.state = {
        currentRowID: null,
        rowIDs: null
    }

    this.permissions = {
        canAddRows: false,
        canDeleteRows: false,
        canSortRows: false,
        enableSmartNavigation: false
    }

    this._highlightingEnabled = true;
    this._loadingTimeout = -1;

    this.onRowAddedCompleted = null;
    this.onRowsDeletedCompleted = null;
    this.onMouseMoving = null;
}

/* Initializes Grid control */
EditableGrid.prototype.initialize = function (permissions) {
    if ($(this.gridID)) {
        this.headerRow = this.getHeader();
        this.hasHeader = this.headerRow != null;
        this.footerRow = this.getFooter();
        this.hasFooter = this.footerRow != null;
        this.notFoundRow = this.getNotFoundRow();

        this.state.currentRowID = $(this.gridID + '_maxRowID');
        this.state.rowIDs = $(this.gridID + '_rowIDs');

        if (permissions)
            this.permissions = permissions;

        this.initializeRows();

        if (this.permissions.canDeleteRows || this.permissions.enableSmartNavigation)
            $(document.body).observe('keydown', this.keyDownEvent.bind(this));

        if (this.permissions.canSortRows) {
            $(document.body).observe('mousemove', this.mouseMoveEvent.bind(this));
            $(document.body).observe('mouseup', this.mouseUpEvent.bind(this));
            $(document.body).observe('selectstart', function (event) {
                if (event.element().tagName.toLowerCase() != 'input') {
                    Event.stop(event);
                }
            });
        }

        if (this.permissions.enableSmartNavigation)
            this.navigator = new EditableGridNavigator(this);
    }
}

/* Initializes Grid rows */
EditableGrid.prototype.initializeRows = function () {
    var rows = this.rows.getAll();
    var footer = null;

    for (var i = 0; i < rows.length; i++) {
        this.initializeSingleRow(rows[i]);
    }

    if (this.permissions.canAddRows) {
        if (this.hasFooter)
            this.footerRow.element.observe('click', this.addRow.bind(this));
    }
}

/* Initializes single Grid row */
EditableGrid.prototype.initializeSingleRow = function (row) {
    row.setEnableHighlighting(true);

    if (this.permissions.canDeleteRows) {
        row.element.childElements().each(function (e) { e.setAttribute('tabindex', '0'); });
        row.element.observe('mousedown', this.toggleRowSelectionEvent.bind(this));
    }

    if (this.permissions.canSortRows)
        this.sortables.makeDraggable(row.element);
}

/* Retrieves containing row by its child element */
EditableGrid.prototype.findContainingRow = function (element) {
    var ret = null;

    if (element) {
        element = $(element);

        if (element.descendantOf(this.gridID)) {
            while (element) {
                if ((element.tagName + '').toLowerCase() == 'tr' && $(element).readAttribute('__rowID')) {
                    ret = EditableGridRow.fromElement(element, null, this.gridID);
                    break;
                } else {
                    if (typeof (element.up) == 'function')
                        element = element.up();
                    else
                        break;
                }
            }
        }
    }

    return ret;
}

/* Event: fired when mouse is moving */
EditableGrid.prototype.mouseMoveEvent = function (event) {
    if (this.sortables.dragObject) {
        var elm = Event.element(event);
        var y = Event.pointerY(event) - this.sortables.mouseOffset.y;
        var gridRow = null;

        if (this._highlightingEnabled) {
            this.rows.disableHighlighting();
            this._highlightingEnabled = false;
        }

        if (elm.tagName.toLowerCase() == 'td')
            elm = elm.up();

        if (elm.tagName.toLowerCase() == 'tr' && EditableGridRow.equals(elm, this.sortables.dragObject) &&
            !elm.hasClassName('draggableRow')) {

            elm.addClassName('draggableRow');

            gridRow = EditableGridRow.fromElement(elm, null, this.gridID);
            if (gridRow)
                gridRow.setSelected(false);
        }

        if (y != this.sortables.oldY) {
            var movingDown = y > this.sortables.oldY;
            var currentRow = null;

            this.sortables.oldY = y;
            currentRow = this.sortables.findDropTargetRow(y);

            if (currentRow) {
                /* Swapping table rows */
                if (movingDown && this.sortables.dragObject != currentRow) {
                    this.sortables.dragObject.parentNode.insertBefore(this.sortables.dragObject, currentRow.nextSibling);
                } else if (!movingDown && this.sortables.dragObject != currentRow) {
                    this.sortables.dragObject.parentNode.insertBefore(this.sortables.dragObject, currentRow);
                }

                /* Fire onMouseMoving event if it is a functino */
                if (typeof (this.onMouseMoving) == 'function') {
                    this.onMouseMoving();
                }
            }
        }
    }
}

/* Event: fired when mouse button is depressed */
EditableGrid.prototype.mouseUpEvent = function (event) {
    var referenceRow = null;
    var targetRowIndex = 0;
    var referenceRowIndex = 0;

    if (this.sortables.dragObject) {

        EditableGridCache.clearRowIndex();
        var allRows = this.rows.getAll();

        targetRowIndex = EditableGridRow.getRowIndex(this.sortables.dragObject);
        referenceRowIndex = targetRowIndex - 1;

        if (referenceRowIndex >= 0 && referenceRowIndex < allRows.length) {
            referenceRow = allRows[referenceRowIndex];
        }

        this.moveRowID(this.sortables.dragObject, referenceRow);

        $(this.sortables.dragObject).removeClassName('draggableRow');
        this.sortables.dragObject = null;
    }

    this.rows.enableHighlighting();
    this._highlightingEnabled = true;
}

/* Event: fired when user toggles Grid row selection (mousedown on a table row) */
EditableGrid.prototype.toggleRowSelectionEvent = function (event) {
    var elm = Event.element(event);
    var row = null;

    while (elm.tagName.toLowerCase() != 'tr') {
        elm = elm.up();
        if (!elm) break
    }

    if (elm) {
        row = this.rows.getRowByID(elm.readAttribute('__rowID'));
        if (row)
            this.toggleRowSelection(row);
    }
}

/* Event: fired when user presses some button on the keyboard */
EditableGrid.prototype.keyDownEvent = function (event) {
    switch (event.keyCode) {
        /* If 'Delete' key is pressed removing selected rows */ 
        case 46:
            if (this.permissions.canDeleteRows && event.element().tagName.toLowerCase() == 'td') {
                this.deleteRows();
            }
            break;
        /* 'Up' or 'Down' arrow is pressed */ 
        case 38:
        case 40:
            if (this.permissions.enableSmartNavigation) {
                if (event.keyCode == 38)
                    this.navigateUp();
                else
                    this.navigateDown();
            }
            break;
    }
}

/* Retrieves Grid header row */
EditableGrid.prototype.getHeader = function () {
    return EditableGridRow.fromElement($(this.gridID + '_' + this.gridID + '_header'), null, this.gridID);
}

/* Retrieves Grid footer row */
EditableGrid.prototype.getFooter = function () {
    return EditableGridRow.fromElement($(this.gridID + '_' + this.gridID + '_footer'), null, this.gridID);
}

/* Retrieves Grid 'Not found' row */
EditableGrid.prototype.getNotFoundRow = function () {
    return EditableGridRow.fromElement($(this.gridID + '_' + this.gridID + '_noRows'), null, this.gridID);
}

/* Moves focus to the next row */
EditableGrid.prototype.navigateDown = function () {
    if (this.permissions.enableSmartNavigation && this.navigator)
        this.navigator.navigateDown();
}

/* Moves focus to the previous row */
EditableGrid.prototype.navigateUp = function () {
    if (this.permissions.enableSmartNavigation && this.navigator)
        this.navigator.navigateUp();
}

/* Adds new row to the Grid */
EditableGrid.prototype.addRow = function () {
    if (typeof (this.onRowAdding) == 'function' && this.onRowAdding()) {
        return;
    }

    if (!this.isBusy) {
        this._loadingTimeout = setTimeout(this.toggleLoading.bind(this, true), 1000);

        this.isBusy = true;

        Dynamicweb.Ajax.doPostBack({
            explicitMode: true,
            eventTarget: this.requestID,
            eventArgument: 'AddNewRow:' + this.state.currentRowID.value,
            onComplete: this.rowAddedEvent.bind(this)
        });
    }
}

/* Event: fired when row is ready to be added to the Grid */
EditableGrid.prototype.rowAddedEvent = function (response) {
    var allRows = null;
    var html = '', js = '';
    var maxRow = parseInt(this.state.currentRowID.value);
    var contentTypes = this.splitContent(response.responseText + '');

    if (this._loadingTimeout != -1)
        clearTimeout(this._loadingTimeout);

    this.isBusy = false;
    this.toggleLoading(false);

    html = contentTypes[0];
    js = contentTypes[1];

    if (html.length > 0) {
        maxRow += 1;

        this.state.currentRowID.value = maxRow;
        this.state.rowIDs.value += (maxRow + '*,');

        if (this.hasFooter) {
            this.notFoundRow.element.hide();
            this.footerRow.element.insert({ before: html });
            if (js.length > 0) {
                js.evalScripts();

                if (typeof (ValidatorOnLoad) != 'undefined') {
                    try {
                        ValidatorOnLoad();
                    } catch (ex) { }
                }
            }

            allRows = this.rows.getAll();

            /* Initializing new row */
            if (allRows.length > 0) {
                this.initializeSingleRow(allRows[allRows.length - 1]);
            }

            /* Fires onRowAddedCompleted event */
            if (typeof (this.onRowAddedCompleted) == 'function') {
                this.onRowAddedCompleted(allRows[allRows.length - 1]);
            }

        }
    }
}

/* Deletes all selected rows from the Grid */
EditableGrid.prototype.deleteRows = function (rows) {
    var deleteBySelected = (rows == null);
    var firstRowIndex = -1;
    var allRows = null;

    if (deleteBySelected)
        rows = this.rows.getSelected();

    if (rows.length > 0) {
        firstRowIndex = rows[0].rowIndex;

        for (var i = 0; i < rows.length; i++) {
            rows[i].element.remove();

            this.state.rowIDs.value = this.state.rowIDs.value.replace(rows[i].ID + '*,', '');
            this.state.rowIDs.value = this.state.rowIDs.value.replace(rows[i].ID + ',', '');

            if (this.state.rowIDs.value.length == 0)
                this.notFoundRow.element.show();
            else {
                if (this.permissions.enableSmartNavigation && deleteBySelected) {
                    if (firstRowIndex > -1) {
                        allRows = this.rows.getAll();

                        if (allRows.length > 0) {
                            if ((allRows.length - 1) >= firstRowIndex)
                                this.toggleRowSelection(allRows[firstRowIndex]);
                            else
                                this.toggleRowSelection(allRows[allRows.length - 1]);
                        }
                    }
                }
            }

            EditableGridCache.clearRowIndex();

            /* Fires onRowsDeletedCompleted event */
            if (typeof (this.onRowsDeletedCompleted) == 'function') {
                this.onRowsDeletedCompleted(rows);
            }
        }
    }
}

/* Changes the row IDs state by moving the target row ID in front of the reference row ID */
EditableGrid.prototype.moveRowID = function (targetRow, referenceRow) {
    var ids = this.state.rowIDs.value;
    var firstID = '', secondID = '';

    if (targetRow != null) {
       
        firstID = this.getRowIDValue(targetRow);

        ids = ids.replace(firstID, '');

        if (referenceRow == null) {
            ids = firstID + ids;
        } else {
            secondID = this.getRowIDValue(referenceRow);
            ids = ids.replace(secondID, secondID + firstID);
        }

        this.state.rowIDs.value = ids;
    }
}

/* Retrieves Grid row ID represented as part of a state value */
EditableGrid.prototype.getRowIDValue = function (row) {
    var ret = '';

    if (typeof (row.rowType) == 'undefined')
        row = EditableGridRow.fromElement(row, null, this.gridID);

    ret = row.ID + '*,';
    if (this.state.rowIDs.value.indexOf(ret) < 0)
        ret = row.ID + ',';

    return ret;
}

/* Toggles 'Loading' dialog visibility */
EditableGrid.prototype.toggleLoading = function (show) {
    if (show) {
        $(this.gridID + '_footerImg').show();
        $(this.gridID + '_footerText').hide();
    } else {
        $(this.gridID + '_footerImg').hide();
        $(this.gridID + '_footerText').show();
    }
}

/* Toggles row 'Selected' state on a specified row */
EditableGrid.prototype.toggleRowSelection = function (row) {
    var rowSelected = row.isSelected;

    this.rows.setSelected(false);
    row.setSelected(!rowSelected);
}

/* Retrieves a calling URL to be used in AJAX requests */
EditableGrid.prototype.getHref = function () {
    var ret = location.href;
    var hashIndex = ret.indexOf('#');

    if (hashIndex >= 0)
        ret = ret.substring(0, hashIndex);

    return ret;
}

/* Ensures that specified validators are defined on a page */
EditableGrid.prototype.ensureValidators = function (ids) {
    var ctrl = null;

    if (ids && ids.length > 0) {
        for (var i = 0; i < ids.length; i++) {
            if (!document.getElementById(ids[i])) {
                ctrl = document.createElement('span');

                ctrl.id = ids[i];
                ctrl.style.display = 'none';

                document.body.appendChild(ctrl);
            }
        }
    }
}

/* Registers specified validator controls (if they aren't registered already) */
EditableGrid.prototype.registerValidators = function (controls) {
    if (typeof (Page_Validators) != 'undefined') {
        if (controls && controls.length > 0) {
            for (var i = 0; i < controls.length; i++) {
                if (controls[i] != null) {
                    if (!this.hasValidator(controls[i])) {
                        Page_Validators[Page_Validators.length] = controls[i];
                    }
                }
            }
        }
    }
}

/* Gets value indicating whether specified validator is registered */
EditableGrid.prototype.hasValidator = function (control) {
    var ret = false;

    if (typeof (Page_Validators) != 'undefined') {
        if (control != null) {
            for (var i = 0; i < Page_Validators.length; i++) {
                if (Page_Validators[i].id == control.id) {
                    ret = true;
                    break;
                }
            }
        }
    }

    return ret;
}

/* Retrieves an array containing two elemens. The first one - actual HTML content, the second one - Javascript code block */
EditableGrid.prototype.splitContent = function (response) {
    var ret = ['', ''];
    var startIndex = -1, endIndex = -1;
    var scriptStart = '<!--#script#', scriptEnd = '#script#-->';

    if (typeof (response) != 'undefined' && response.length > 0) {
        startIndex = response.indexOf(scriptStart);
        endIndex = response.indexOf(scriptEnd);

        if (startIndex >= 0 && endIndex >= 0 && startIndex < endIndex) {
            if (startIndex == 0) {
                ret[0] = response.substr(endIndex + scriptEnd.length);
            } else if (endIndex + scriptEnd.length == response.length) {
                ret[0] = response.substr(0, startIndex);
            }

            ret[1] = response.substr(startIndex + scriptStart.length,
                endIndex - (scriptStart.length + startIndex));
        } else {
            ret[0] = response;
        }

        if (ret[1].length > 0) {
            ret[1] = '<script>' + ret[1] + '</script>';
        }
    }

    return ret;
}

EditableGrid.prototype.gotoPage = function (controlID, pageNumber) {
    if (typeof (__doPostBack) == 'function') {
        __doPostBack(controlID, 'PageIndexChanged:' + pageNumber);
    }
}
