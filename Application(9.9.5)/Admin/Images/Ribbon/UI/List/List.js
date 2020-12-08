/// <reference path="../StretchedContainer/StretchedContainer.js" />

var __stretchers = [];

var List = {
    addLoadEvent: function (func) {
        if (window.addEventListener) {
            window.addEventListener('load', func, false);
        } else if (window.attachEvent) {
            window.attachEvent('onload', func);
        }
    },

    addResizeEvent: function (func) {
        if (window.addEventListener) {
            window.addEventListener('resize', func, false);
        } else if (window.attachEvent) {
            window.attachEvent('onresize', func);
        }
    },

    sortAscending: function (controlID, columnIndex) {
        List.sort(controlID, columnIndex, List.SortDirection.Ascending);
    },

    sortDescending: function (controlID, columnIndex) {
        List.sort(controlID, columnIndex, List.SortDirection.Descending);
    },

    sort: function (controlID, columnIndex, direction) {
        if (typeof (WaterMark) != 'undefined')
            WaterMark.hideAll();

        if (typeof (__doPostBack) == 'function') {
            __doPostBack(controlID, 'Sorting:' + parseInt(columnIndex) +
                ':' + parseInt(direction));
        }
    },

    removeSorting: function (controlID) {
        if (typeof (WaterMark) != 'undefined')
            WaterMark.hideAll();

        if (typeof (__doPostBack) == 'function') {
            __doPostBack(controlID, 'RemoveSorting');
        }
    },

    showContextMenu: function (e, contextId, NodeID) {
        var t = $(e.srcElement || e.target);
        if ($("ColumnSelector:" + NodeID) && t.up('thead')) {
            return ContextMenu.show(e, "ColumnSelector:" + NodeID, contextId, '', t.closest && t.closest(".modal-body") ? "BottomRightRelative" : undefined);
        }
        else if (contextId != '') {
            return ContextMenu.show(e, contextId, NodeID);
        }
    },

    changeColumn: function (controlId, columnId) {
        if (typeof (WaterMark) != 'undefined')
            WaterMark.hideAll();

        if (typeof (__doPostBack) == 'function') {
            __doPostBack(controlId, 'ColumnSelector:' + columnId);
        }
    },

    dialogSelectedControlId: '',
    dialogSelectedColumnId: '',

    columnsDialog: function (controlId) {
        dialog.show("columnSelectorDialog_" + controlId);

        if (List.dialogSelectedControlId == '' && List.dialogSelectedColumnId == '') {
            var container = $("dialog_" + controlId + "_container");
            var columns = container.getElementsBySelector("input");
            if (columns && columns.length > 0) {
                var col = columns[0];
                var columnId = col.getAttribute('customdata');

                List.dialogSelectedControlId = controlId;
                List.dialogSelectedColumnId = columnId;

                var span = $("dialog_" + controlId + "_name_" + columnId);
                span.parentElement.addClassName("list-dialog-columns-item-selected");
            }
        }
    },

    get_stretchers: function () {
        return __stretchers;
    },

    registerStretcher: function (stretcher) {
        if (!__stretchers) {
            __stretchers = [];
        }

        if (stretcher) {
            __stretchers[__stretchers.length] = stretcher;
        }
    },

    cancelColumnSelectorDialog: function (controlId) {
        dialog.hide("columnSelectorDialog_" + controlId);
    },

    dialogUpdateColumns: function (uniqueId, controlId) {
        var container = $("dialog_" + controlId + "_container");

        var data = $("dialog_" + controlId + "_data");
        var columns = container.getElementsBySelector("input");
        for (var i = 0; i < columns.length; i++) {
            var col = columns[i];
            data.value = data.value + col.getAttribute('customdata') + "|" + (col.checked ? "on" : "off") + "%"
        }

        if (typeof (WaterMark) != 'undefined')
            WaterMark.hideAll();

        if (typeof (__doPostBack) == 'function') {
            __doPostBack(uniqueId, 'ColumnSelectorDialog:' + controlId);
        }
    },

    dialogSelectColumn: function (controlId, columnId) {
        var old = $("dialog_" + List.dialogSelectedControlId + "_name_" + List.dialogSelectedColumnId);
        if (old) {
            old.parentElement.removeClassName('list-dialog-columns-item-selected');
        }

        var span = $("dialog_" + controlId + "_name_" + columnId);
        span.parentElement.addClassName("list-dialog-columns-item-selected");

        List.dialogSelectedControlId = controlId;
        List.dialogSelectedColumnId = columnId;
    },

    dialogUpClick: function () {
        var row = $("dialog_" + List.dialogSelectedControlId + "_row_" + List.dialogSelectedColumnId);

        var prevRows = row.previousSiblings();
        var prevRow = prevRows[0];

        Element.insert(row, { after: prevRow });
    },

    dialogDownClick: function () {
        var row = $("dialog_" + List.dialogSelectedControlId + "_row_" + List.dialogSelectedColumnId);

        var prevRows = row.nextSiblings();
        var prevRow = prevRows[0];

        Element.insert(row, { before: prevRow });
    },

    dialogShowClick: function () {
        var item = $("dialog_" + List.dialogSelectedControlId + "_item_" + List.dialogSelectedColumnId);
        item.checked = true;
    },

    dialogHideClick: function () {
        var item = $("dialog_" + List.dialogSelectedControlId + "_item_" + List.dialogSelectedColumnId);
        item.checked = false;
    },

    sortInternal: function (controlID, direction) {
        var columnIndex = parseInt(ContextMenu.callingID);
        List.sort(controlID, columnIndex, direction);
    },

    gotoPage: function (controlID, pageNumber) {
        if (typeof (WaterMark) != 'undefined')
            WaterMark.hideAll();

        if (typeof (__doPostBack) == 'function') {
            __doPostBack(controlID, 'PageIndexChanged:' + pageNumber);
        }
    },

    _submitForm: function (controlID, eventArgument) {
        if (typeof (WaterMark) != 'undefined')
            WaterMark.hideAll();

        if (typeof (__doPostBack) == 'function') {
            __doPostBack(controlID, eventArgument);
        }
    },

    setWidth: function () {
        var container = $('ListTableContainer');
        var containerStyle = container.readAttribute('style');
        var needToSetHeight = true;

        if (containerStyle != null) {
            needToSetHeight = containerStyle.indexOf('height') < 0;
        }

        if (needToSetHeight) {
            if (document.getElementById("tree1")) {
                document.getElementById("ListTableContainer").style.height = (document.getElementById("tree1").offsetHeight - 2);
            } else {
                try {
                    document.getElementById("ListTableContainer").style.height = (document.documentElement.offsetHeight - 53) + 'px';
                } catch (e) { }
            }
        }
        //alert(document.getElementById("ListTable").scrollHeight);
        //document.getElementById("ListTable").style.width = (document.documentElement.offsetWidth - 23);
        if (document.getElementById("ListTableContainer").offsetHeight < document.getElementById("ListTable").scrollHeight) {
            document.getElementById("ListTable").style.width = (document.documentElement.offsetWidth - 23);
        }
        else {
            document.getElementById("ListTable").style.width = "100%"
        }
        //alert(document.getElementById("ListTable").offsetHeight);

        List.alignColumns();
    },

    alignColumns: function () {
        var lists = $$('#ListTable');
        var columns = null;
        var width = '';

        /* Checking all lists placed on a page */
        if (lists && lists.length > 0) {
            for (var i = 0; i < lists.length; i++) {

                /* Retrieving header columns */
                columns = lists[i].select('tr[class="header"] > td');
                if (columns && columns.length > 1) {
                    for (var j = 0; j < columns.length; j++) {
                        width = columns[j].getStyle('width');

                        /* Checking whether column width is fixed */
                        if (!width || width == '' || width.indexOf('%') > 0) {
                            /* width is not fixed - exiting */
                            break;
                        } else {
                            /* all columns are fixed-width - stretching the last one */
                            if (j == columns.length - 1) {
                                columns[j].setStyle({ 'width': '100%' });
                            }
                        }
                    }
                }
            }
        }
    },

    myResize: function () {
        setTimeout(List.setWidth, 50);
    },

    expand: function (controlID, rowID, evt) {
        RowsLoader.expand(controlID, rowID);

        /* If it's an event preventing it from bubbling */
        if (evt) {
            if (typeof (evt.cancelBubble) != 'undefined')
                evt.cancelBubble = true;
            else if (typeof (evt.stopPropagation) == 'function')
                evt.stopPropagation();
        }
    },

    /* Changes the 'selected' state of the specified row within the specified List control. */
    setRowSelected: function (controlID, row, selected, evt) {
        var checkbox = null;
        var checkAll = null;

        row = $(row);
        checkbox = row.select('input[type="checkbox"]');

        /* Changing the 'checked' state of the checkbox which corresponds to the row */
        if (checkbox && checkbox.length > 0) {
            checkbox = checkbox[0];
            if (checkbox.disabled) return;
            checkbox.checked = selected;
        }

        /* Changing row style */
        if (!selected) {
            row.removeClassName('selected');

            checkAll = $('chk_all_' + controlID);
            if (checkAll) {
                /* Row has been deselected. Clearing 'Select all' checkbox state */
                checkAll.checked = false;
            }
        } else {
            row.addClassName('selected');
        }


        if (typeof (ContextMenu) != 'undefined')
            ContextMenu.hide();

        /* If it's an event preventing it from bubbling */
        if (evt) {
            if (typeof (evt.cancelBubble) != 'undefined')
                evt.cancelBubble = true;
            else if (typeof (evt.stopPropagation) == 'function')
                evt.stopPropagation();
        }
    },

    /* Changes the 'selected' state of all rows within specified List control. */
    setAllSelected: function (controlID, selected) {
        var rows = $$('tbody[id="' + controlID + '_body_stretch"] > tr.listRow');

        if (!rows || rows.length == 0) {
            rows = $$('tbody[id="' + controlID + '_body"] > tr.listRow');
        }

        if (rows) {
            for (var i = 0; i < rows.length; i++) {
                this.setRowSelected(controlID, rows[i], selected);
            }
        }
    },

    /* Finds List row which contains specified element. */
    getContainingRow: function (element) {
        var ret = null;

        element = $(element);
        ret = element.up('tr[itemid]');
        if (!ret) {
            ret = element.up('tr[id]');
            if (!ret || ret.id.indexOf('row') != 0) {
                ret = element.up('tr');
            }
        }

        return ret;
    },

    /* Retrieves selected rows from the specified list */
    getSelectedRows: function (controlID) {
        var ret = [];
        var rows = this.getAllRows(controlID);
        var checkbox = null;

        if (rows) {
            for (var i = 0; i < rows.length; i++) {
                checkbox = rows[i].select('input[type="checkbox"]');
                if (checkbox && checkbox.length > 0 && checkbox[0].checked) {
                    ret[ret.length] = rows[i];
                }
            }
        }

        return ret;
    },

    /* Determines whether specified row is selected */
    rowIsSelected: function (row) {
        var ret = false;
        var checkbox = null;

        if (row) {
            checkbox = row.select('input[type="checkbox"]');

            if (checkbox && checkbox.length > 0) {
                ret = checkbox[0].checked;
            }
        }

        return ret;
    },

    /* Retrieves all list rows */
    getAllRows: function (controlID) {
        var list = $$('tbody[id="' + controlID + '_body_stretch"]');
        var ret = null;

        if (!list || list.length == 0) {
            list = $$('tbody[id="' + controlID + '_body"]');
        }

        if (list && list.length > 0) {
            list = list[0];
            ret = list.select('tr[itemid]');
            if (!ret || ret.length == 0) {
                ret = list.select('tr[id]');
                if (ret && ret.length > 0) {
                    if (ret[0].id.indexOf('row') != 0)
                        ret = null;
                } else {
                    ret = list.select('tr');
                }
            }
        }

        return ret;
    },

    getRowByID: function (controlID, rowID) {
        var ret = null;

        if (rowID.indexOf('row') < 0)
            rowID = 'row' + rowID;

        ret = $$('tbody[id="' + controlID + '_body_stretch"] > tr[id="' + rowID + '"]');

        if (!ret || ret.length == 0) {
            ret = $$('tbody[id="' + controlID + '_body"] > tr[id="' + rowID + '"]');
        }

        if (ret && ret.length > 0)
            ret = ret[0];

        return ret;
    },

    CollapseFilters: function () {
        // duration of effect
        var time = 0.4;

        if ($('filtersDiv').style.display == 'none') {
            // Uncollapse
            Effect.BlindDown('filtersDiv', { duration: time });
            setTimeout("$('FilterCollapseImage').className = 'fa fa-chevron-down'", time * 1000);
            setTimeout("$('FilterCollapseImage').title = $('CollapseText').value;", time * 1000);
            $('IsCollapsed').value = 'False';
        } else {
            // Collapse
            Effect.BlindUp('filtersDiv', { duration: time });
            setTimeout("$('FilterCollapseImage').className = 'fa fa-chevron-up';", time * 1000);
            setTimeout("$('FilterCollapseImage').title = $('UnCollapseText').value;", time * 1000);
            $('IsCollapsed').value = 'True';
        }
    },

    BlinkCollapseButton: function () {
        if ($('DoBlinkCollapseButton') && $('DoBlinkCollapseButton').value == 'True')
            setTimeout("Effect.Pulsate('collapseFiltersCell', { duration: 1, from: 0.3, pulses: 3 });", 200);
    }
}

List.addLoadEvent(List.BlinkCollapseButton)

List.Stretcher = function (stretcherID, params) {
    this._stretcherID = stretcherID;
    this._stretcherObject = null;
    this._params = params;
    this._cache = {};
    this._isInitialized = false;

    if (!this._params) {
        this._params = {}
    }
}

List.Stretcher.prototype.get_stretcherObject = function () {
    if (!this._stretcherObject) {
        this._stretcherObject = Dynamicweb.Controls.StretchedContainer.getInstance(this._stretcherID);
    }

    return this._stretcherObject;
}

List.Stretcher.prototype.initialize = function () {
    var obj = this;
    var container = this.get_stretcherObject();

    if (this._isInitialized)
        return;

    if (container) {
        this._initializeCache();

        container.add_afterSetHeight(function (sender, args) {
            if (obj._params.showPaging) {
                args.set_height(args.get_height() - 22);
            }
        });

        container.add_afterSelectAnchor(function (sender, args) {
            var container = sender.get_containerElement().up('div.list');

            if (container) {
                args.set_anchor($(container).up());
            }
        });

        container.add_afterStretch(function (sender, args) {
            obj.adjustSize();
        });

        this._isInitialized = true;
    }
}

List.Stretcher.prototype.adjustSize = function () {
    this._alignHeaderCells();
}

List.Stretcher.prototype._initializeCache = function () {
    var container = null;
    var obj = this.get_stretcherObject();

    this._cache = {};

    if (obj) {
        container = obj.get_containerElement();

        if (container) {
            this._cache.testElement = new Element('div');
            this._cache.hiddenRowCells = container.select('tr.header > td');
            // this._cache.topRowCells = container.select('tr.listRow:first-of-type > td');
            // ^^^ does not work in ff 3.5,3.6 (tfs #4600) using this vvv
            var rows = container.select('tr.listRow');
            var cells = [];
            for (var i = 0; i < rows.length; i++) {
                if (!$(rows[i]).hasClassName("InternalHeaderRow")) {
                    cells = rows[i].select('td');
                    break;
                }
            }
            this._cache.topRowCells = cells; //rows.length > 0 ? rows[0].select('td') : [];

            this._cache.headerCells = container.up('div.list').select('thead > tr.header > td');
        }
    }
}

List.Stretcher.prototype._alignHeaderCells = function () {
    var cellWidth = 0, widthValue = '';
    var headerCells = [], topRowCells = [];

    if (this._cache.headerCells && this._cache.headerCells.length > 0) {
        if (this._cache.hiddenRowCells && this._cache.hiddenRowCells.length <= this._cache.headerCells.length) {
            if (this._cache.topRowCells && this._cache.topRowCells.length > 0 && this._cache.topRowCells.length <= this._cache.headerCells.length) {
                for (var i = 0; i < this._cache.hiddenRowCells.length; i++) {
                    if (i != this._cache.hiddenRowCells.length - 1) {
                        widthValue = this._cache.topRowCells[i].style.width;

                        if (!widthValue) {
                            widthValue = 'auto';
                        }
                        widthValue = widthValue.toLowerCase();

                        if (widthValue.indexOf('px') > 0) {
                            cellWidth = parseInt(widthValue.replace('px', ''));
                        } else {
                            this._cache.hiddenRowCells[i].appendChild(this._cache.testElement);
                            cellWidth = this._cache.testElement.offsetWidth;
                            this._cache.hiddenRowCells[i].removeChild(this._cache.testElement)
                        }

                        this._cache.headerCells[i].style.width = cellWidth + 'px';
                    }
                }
            }
        }
    }
}

List.SortDirection = {
    Ascending: 1,
    Descending: 2
}

/* Represents a helper class for ajax-enabled rows expanding */
var RowsLoader = new Object();
var __loaded_rows = [];

/* Expands specified row of the specified list control */
RowsLoader.expand = function (controlID, rowID) {
    RowsLoader.toggle(rowID);

    if (!RowsLoader.rowLoaded(rowID)) {
        Dynamicweb.Ajax.doPostBack({
            eventTarget: controlID,
            eventArgument: rowID,

            onComplete: function (response) {
                var childsContent = $('cInner_' + rowID);

                RowsLoader.setRowLoaded(rowID);

                if (childsContent) {
                    childsContent.removeClassName('dis');
                    childsContent.update(response.responseText);
                }
            }
        });
    }
}

/* Retrieves page calling URL */
RowsLoader.getHref = function () {
    var ret = location.href;
    var hashIndex = ret.indexOf('#');

    if (hashIndex >= 0)
        ret = ret.substring(0, hashIndex);

    return ret;
}

/* Determines whether specified row is expanded */
RowsLoader.rowLoaded = function (rowID) {
    var ret = false;

    if (__loaded_rows && __loaded_rows.length > 0) {
        ret = (__loaded_rows[rowID + ''] == true);
    }

    return ret;
}

/* Marks specified row as loaded */
RowsLoader.setRowLoaded = function (rowID) {
    if (!__loaded_rows)
        __loaded_rows = [];

    __loaded_rows[rowID + ''] = true;
}

/* Toggles 'Processing' indication */
RowsLoader.toggleLoading = function (controlID, show) {
    var loadingImg = $(controlID + '_loading');
    if (loadingImg) {
        show ? loadingImg.show() : loadingImg.hide();
    }
}

/* Toggles child rows visibility */
RowsLoader.toggle = function (rowID) {
    var childsRow = $("c_" + rowID);
    var img = $("img_" + rowID);

    if (childsRow) {
        if (img)
            img.writeAttribute('class', (childsRow.visible() ? 'fa fa-caret-right' : 'fa fa-caret-down'));

        childsRow.toggle();
    }
}

//List.addLoadEvent(List.setWidth);
//List.addResizeEvent(List.myResize);

