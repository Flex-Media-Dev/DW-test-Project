if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.Global = function () { }

Dynamicweb.Items.Global.isValidSystemName = function (name) {
    var ret = false;

    if (name && name.length) {
        ret = !!name.test(/^[0-9a-zA-Z_]$/gi); // Checking for allowed characters

        if (ret) {
            ret = name.indexOf('_') != 0; // Checking for leading underscores
        }
    }

    return ret;
}

Dynamicweb.Items.Global.makeSystemName = function (name) {
    var ret = name;

    if (ret && ret.length) {
        ret = ret.replace(/[^0-9a-zA-Z_\s]/gi, '_'); // Replacing non alphanumeric characters with underscores
        while (ret.indexOf('_') == 0) ret = ret.substr(1); // Removing leading underscores

        ret = ret.replace(/\s+/g, ' '); // Replacing multiple spaces with single ones
        ret = ret.replace(/\s([a-z])/g, function (str, g1) { return g1.toUpperCase(); }); // Camel Casing
        ret = ret.replace(/\s/g, '_'); // Removing spaces

        if (ret.length > 1) ret = ret.substr(0, 1).toUpperCase() + ret.substr(1); else ret = ret.toUpperCase();
    }

    return ret;
}

Dynamicweb.Items.Global.sortingDialogSelectOption = function (selectedOption, fieldId) {
    var oldSelected = Dynamicweb.Items.Global._getSortinDialogSelectedOption(fieldId);
    if (oldSelected) {
        oldSelected.setAttribute("class", "list-dialog-columns-item");
    }
    selectedOption.setAttribute("class", "list-dialog-columns-item-selected");
}

Dynamicweb.Items.Global._getSortinDialogSelectedOption = function (fieldId) {
    return document.getElementById(fieldId + '_sortingDialog').querySelector(".list-dialog-columns-item-selected");
}

Dynamicweb.Items.Global.sortingDialogMoveOption = function (fieldId, moveUp) {
    var selected = Dynamicweb.Items.Global._getSortinDialogSelectedOption(fieldId);
    if (moveUp) {
        Element.insert(selected, { after: selected.previousSiblings()[0] });
    } else {
        Element.insert(selected, { before: selected.nextSiblings()[0] });
    }
}

Dynamicweb.Items.Global.openSortingDialog = function (fieldId) {
    //set checked
    var itemOptions = document.getElementsByName(fieldId);
    var dialogContainer = document.getElementById(fieldId + '_sortingDialog');
    for (i = 0; i < itemOptions.length; i++) {
        var itemOption = itemOptions[i];
        var dialogOption = dialogContainer.querySelector('.list-dialog-columns input[type="checkbox"][value="' + itemOption.value + '"]');
        dialogOption.checked = itemOption.checked;
    }
    dialog.show(fieldId + '_sortingDialog');
}

Dynamicweb.Items.Global.closeSortingDialog = function (fieldId) {
    //set sorting
    var dialogOptions = document.getElementById(fieldId + '_sortingDialog').querySelectorAll('.list-dialog-columns input[type="checkbox"]');
    for (i = 0; i < dialogOptions.length; i++) {
        var dialogOption = dialogOptions[i];
        var itemOption = document.querySelector('.item-field-value-container input[type="checkbox"][name="' + fieldId + '"][value="' + dialogOption.value + '"]');
        itemOption.checked = dialogOption.checked;
        var optionContainer = itemOption.parentNode;
        optionContainer.parentNode.appendChild(optionContainer);
    }
    dialog.hide(fieldId + '_sortingDialog');
}

/* Item list editor */

Dynamicweb.Items.ListItem = function () {
    this._el = null;
    this._listId = '';
    this._pageId = '';
    this._areaId = '';
    this._dialog = null;
    this._itemType = '';
    this._fields = [];
    this._terminology = {};
    this._sortIndexes = [];
    this._updateSortIndexes = false;
    this._sortBy = '';
    this._sortOrderAscending = true;
    this._askConfirmation = false;
    this._minNumber = 0;
    this._maxNumber = 0;
    this._pagedList = false;
    this._pageCount = 1;
    this._totalItems = 1;
}

Dynamicweb.Items.ListItem.initialize = function (parameters) {
    var listItem = new Dynamicweb.Items.ListItem();
    listItem._el = $(parameters.listId + 'Container');
    listItem._dialog = parameters.popup;
    listItem._itemType = parameters.itemType;
    listItem._instantSave = parameters.instantSave;
    listItem._itemListId = parameters.itemListId;
    listItem._isDraft = parameters.isDraft;
    listItem._listId = parameters.listId;
    listItem._pageId = parameters.pageId;
    listItem._areaId = parameters.areaId;
    listItem._fields = parameters.fields;
    listItem._sortBy = parameters.sortBy;
    listItem._sortOrderAscending = parameters.sortOrderAscending;
    listItem._minNumber = parseInt(parameters.minNumber) || 0;
    listItem._maxNumber = parseInt(parameters.maxNumber) || 0;
    listItem._filteredItems = parameters.hideItems || [];
    listItem._filteredItems = parameters.hideItems || [];
    listItem._pagedList = parameters.pagedList;
    listItem._pageCount = parseInt(parameters.pageCount) || 1;
    listItem._totalItems = parseInt(parameters.totalItems) || 1;

    listItem._sortIndexes = $$('#' + parameters.listId + 'Container tr[itemid]').collect(function (e) {
        e.writeAttribute('ID', parameters.listId + '_' + e.identify()); //fix sorting http://madrobby.github.io/scriptaculous/sortable-serialize/
        var itemId = e.readAttribute('itemID');
        if (listItem._filteredItems.indexOf(itemId) > -1) {
            e.hide();
        }
        return itemId;
    });

    var filter = $("ItemRelationListFilterSearchText_" + parameters.listId);
    if (filter) {
        filter.observe('keyup', function () { listItem.filterListItems(); });

        var searchButton = $(parameters.listId + "_FilterSearch");
        if (searchButton) {
            searchButton.observe('click', function () { listItem.filterListItems(); });
        }
    }

    var sortMenu = $('SortingMenu:' + parameters.listId);
    if (sortMenu) {
        var sortAsc = $(sortMenu).select('a#hrefSortingMenuSortAscending')[0];
        if (sortAsc) {
            $(sortAsc).writeAttribute('onclick', '');
            $(sortAsc).observe('click', function (event) {
                event.preventDefault();
                var columnIndex = parseInt(ContextMenu.callingID);
                listItem.sortColumn(columnIndex, true);
            });
        }

        var sortDesc = $(sortMenu).select('a#hrefSortingMenuSortDescending')[0];
        if (sortDesc) {
            $(sortDesc).writeAttribute('onclick', '');
            $(sortDesc).writeAttribute('href', 'javascript:void(0);');
            $(sortDesc).observe('click', function (event) {
                event.preventDefault();
                var columnIndex = parseInt(ContextMenu.callingID);
                listItem.sortColumn(columnIndex, false);
            });
        }
    }

    var list = $(parameters.listId + '_body');
    if (list) {
        list.observe('click', function (e) {
            var itemId = '';
            var elm = Event.element(e);
            var row = elm.up('tr.listRow');

            if (row != null) {
                if (row.hasClassName('been_dragged')) {
                    row.removeClassName('been_dragged');
                    if (row.hasClassName('being_dragged')) return;
                }
                if (row.hasClassName('draft-removed')) return;
                itemId = $(row).readAttribute('itemID');
            }

            if (elm.tagName.toLowerCase() == 'i') {
                if ($(elm).hasClassName('cmd-delete')) {
                    listItem.delRow(row);
                } else {
                    listItem.editClick(itemId);
                }
            } else if (itemId) {
                listItem.editClick(itemId);
            }
        });
    }

    var ctrlAddButton = $(parameters.listId + '_addButton');
    if (ctrlAddButton) {
        ctrlAddButton.observe('click', function (e) {
            listItem.addClick("List");
        });
    }
    ctrlAddButton = $(parameters.listId + '_addPageButton');
    if (ctrlAddButton) {
        ctrlAddButton.observe('click', function (e) {
            listItem.addClick("Page");
        });
    }
    ctrlAddButton = $(parameters.listId + '_addParagraphButton');
    if (ctrlAddButton) {
        ctrlAddButton.observe('click', function (e) {
            listItem.addClick("Paragraph");
        });
    }

    var ctrlSelector = $(parameters.listId + '_Selector');
    if (ctrlSelector) {
        ctrlSelector.onchange = (function (e) {
            return listItem.onItemEntrySelect(this);
        }).bind();
    }

    if (!listItem._sortBy) {
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

        Position.includeScrollOffsets = true;

        Sortable.create(parameters.listId + '_body', {
            tag: 'tr',
            only: 'listRow',
            onUpdate: function () {
                listItem.onListChanged();
            }
        });

        Draggables.addObserver({
            onStart: function (eventName, draggable, event) {
                var a = $(draggable.element);
                a.addClassName('being_dragged');
            },
            onEnd: function (eventName, draggable, event) {
                var a = $(draggable.element);
                a.removeClassName('being_dragged');
                if (a && a.hasClassName('hover')) a.addClassName('been_dragged');
            }
        });

        list.select("tr.listRow").each(function (a) {
            Event.observe(a, 'mouseover', function (event) {
                this.addClassName('hover');
            });
            Event.observe(a, 'mouseout', function (event) {
                this.removeClassName('hover');
            });
        });
    }

    var form = $('MainForm') || $('ParagraphForm') || $('EditGroupForm') || $('EditUserForm') || document.forms[0];

    window.document.observe('General:DocumentOnSave', (function (event) {
        listItem._askConfirmation = false;

        // parameters.itemListId is NaN for old ItemListEditor
        if (listItem._updateSortIndexes && isNaN(parameters.itemListId)) {
            listItem.request({
                params: {
                    AjaxAction: 'UpdateSortIndexes',
                    Caller: parameters.listId,
                    ItemID: listItem._sortIndexes.join(',')
                }
            })
        }
        listItem.commitChanges(form, listItem._sortIndexes);
    }));

    window.addEventListener('beforeunload', function (e) {
        if (listItem._askConfirmation && !listItem._instantSave) {
            listItem._askConfirmation = false;
            e.returnValue = listItem.get_terminology()['NotSavedWarningMessage'];
            return e.returnValue
        }
    });

    window.addEventListener('unload', function () {
        listItem.request({
            params: {
                AjaxAction: 'CleanListItemCache',
                Caller: parameters.listId,
                ItemID: listItem._sortIndexes.join(',')
            }
        });
    });

    return listItem;
}

Dynamicweb.Items.ListItem.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Items.ListItem.prototype.commitChanges = function (form, itemIds) {
    var hidden = null;
    var hiddens = document.getElementsByName(this._listId);
    if (hiddens.length > 0) {
        hidden = hiddens[0];
    }
    else {
        hidden = document.createElement('input');
        hidden.type = 'hidden';
        hidden.name = this._listId;
        form.appendChild(hidden);
    }

    if (isNaN(this._itemListId)) {
        hidden.value = itemIds.join(',');
    }
    else {
        var itemList = {
            Id: this._itemListId,
            ItemIds: itemIds
        }
        hidden.value = Object.toJSON(itemList);
    }
}

Dynamicweb.Items.ListItem.prototype.addClick = function (itemSourse) {
    if (this._maxNumber > 0 && this._maxNumber <= this._el.select('tr[itemid]').length) {
        alert(this.get_terminology()['MaximumNumberMessage']);
        return;
    }

    if (itemSourse == "Page")
        this.addStructureItem(false);
    else if (itemSourse == "Paragraph")
        this.addStructureItem(true);
    else
        this.addListItem();
}

Dynamicweb.Items.ListItem.prototype.openListItemDialog = function (itemId, isNew, disableSave, sort) {
    var model = {
        PageId: this._pageId,
        ListId: this._listId,
        ItemType: this._itemType,
        IsDraft: this._isDraft,
        ItemID: itemId,
        IsNew: isNew,
        DisableSave: disableSave,
        Sort: sort,
        SortBy: this._sortBy,
        SortOrderAscending: this._sortOrderAscending,
        ItemListID: this._itemListId
    };
    var url = "/Admin/Content/Items/Editing/ItemListEdit.aspx?ItemID={ItemID}&New={IsNew}&DisableSave={DisableSave}&Sort={Sort}&PageId={PageId}&Caller={ListId}&ItemType={ItemType}&IsDraft={IsDraft}";
    if (this._sortBy) {
        url += "&SortBy={SortBy}&SortOrderAscending={SortOrderAscending}";
    }
    if (this._instantSave && !isNaN(this._itemListId)) {
        url += "&InstantSave=true&ItemListID={ItemListID}";
        url = Action.Transform(url, model, true);
        location = url;
    } else {
        Action.Execute({ Name: "OpenDialog", Url: url }, model);
    }
};

Dynamicweb.Items.ListItem.prototype.addListItem = function () {
    var pageNumberHidden = $('PageNumber');
    this.openListItemDialog("new_" + (new Date).getTime(), true, (this._pagedList && pageNumberHidden && pageNumberHidden.value != this._pageCount), (this._pagedList && this._pageCount > 0 ? this._totalItems + 1 : this._sortIndexes.length));
}

Dynamicweb.Items.ListItem.prototype.addStructureItem = function (showParagraphs) {
    var self = this;
    var selector = $(this._listId + '_Selector');

    var callback = function (options, model) {
        if (showParagraphs) {
            selector.writeAttribute('data-paragraph-id', model.ParagraphID);
            selector.writeAttribute('data-page-id', model.PageID);
        } else {
            selector.writeAttribute('data-page-id', model.Selected);
            selector.writeAttribute('data-paragraph-id', "");
        }
        selector.writeAttribute((showParagraphs ? 'data-paragraph-itemtype' : 'data-page-itemtype'), self._itemType);
        selector.onchange();
    }

    var dlgAction = createLinkDialog(showParagraphs ? LinkDialogTypes.Paragraph : LinkDialogTypes.Page, ['ItemTypesPermittedForChoosing=' + this._itemType], callback);

    Action.Execute(dlgAction);
}

Dynamicweb.Items.ListItem.prototype.editClick = function (itemId) {
    this.openListItemDialog(itemId, false, false, this._sortIndexes.indexOf(itemId));
}

Dynamicweb.Items.ListItem.prototype.request = function (options) {
    var self = this;

    if (!options || !options.params || !options.params.AjaxAction) {
        return;
    }

    options.params.ItemType = self._itemType;
    options.params.IsAjax = true;

    new Ajax.Request('/Admin/Content/Items/Editing/ItemListEdit.aspx', {
        method: 'POST',
        parameters: options.params,
        onCreate: function () {
            if (self._overlay) {
                self._overlay.show();
            }
        },
        onSuccess: function (transport) {
            var json;

            if (transport.responseText.isJSON()) {
                json = transport.responseText.evalJSON();
            }

            if (options.callback) {
                options.callback(transport.responseText, json);
            }
        },
        onFailure: function () {
            alert(self.get_translation('Error'));
        },
        onComplete: function () {
            if (self._overlay) {
                setTimeout(function () { self._overlay.hide(); }, 250);
            }
        }
    });
}


Dynamicweb.Items.ListItem.prototype.onItemEntrySelect = function (element) {
    var self = this, el = element;
    var itemType = el.readAttribute('data-page-itemtype') || el.readAttribute('data-paragraph-itemtype');
    if (this._itemType != itemType) {
        return { closeMenu: false };
    }

    if (el) {
        self.request({
            params: {
                AjaxAction: 'SaveStructureItem',
                ItemEntryPageId: el.readAttribute('data-page-id'),
                ItemEntryParagraphId: el.readAttribute('data-paragraph-id'),
                Caller: self._listId,
                SortBy: self._sortBy,
                SortOrderAscending: self._sortOrderAscending
            },
            callback: function (responseText, json) {
                var error = '';

                if (json) {
                    error = json.Error || '';
                } else {
                    error = self.get_translation['Error'];
                }

                if (!error) {
                    // clear data for further transferring
                    el.writeAttribute('data-page-id', '');
                    el.writeAttribute('data-page-name', '');
                    el.writeAttribute('data-page-itemtype', '');
                    el.writeAttribute('data-paragraph-id', '');
                    el.writeAttribute('data-paragraph-name', '');

                    self.addRow(json["Id"].Value, json);
                } else {
                    alert(error);
                }
            }
        });
    }
}

Dynamicweb.Items.ListItem.prototype.addRow = function (itemId, itemEntry) {
    if (this._pagedList && this._pageCount > 0 && List) {
        var pageNumberHidden = $('PageNumber');
        var pageSizeHidden = $('PageSize');
        this._totalItems++;
        if ((pageNumberHidden && pageNumberHidden.value != this._pageCount) || (pageSizeHidden && this._totalItems > pageSizeHidden.value)) {
            List.gotoPage('', ((this._totalItems - 1) % pageSizeHidden.value == 0 ? this._pageCount + 1 : this._pageCount));
        }
    }
    var self = this;
    var caller = this._listId + '_body'; // FldList_body
    var cellsCount = 0;
    var maxColWidth = 0;

    var tbl = $(caller);
    var rowCount = tbl.rows.length;
    var row = tbl.insertRow(rowCount);
    if (this._instantSave && !isNaN(this._itemListId)) {
        itemId = itemEntry.Id.Value;
    }
    row.id = itemId;
    row.setAttribute("itemID", itemId);
    row.setAttribute("style", "cursor:pointer;");
    row.setAttribute("class", "listRow");

    if (this._sortIndexes.indexOf(itemId) >= 0) {
        alert(this.get_terminology()['ItemAlreadyPresentMessage']);
        return;
    }

    this._sortIndexes.push(itemId);

    maxColWidth = Math.max(80, Math.floor((600) / this._fields.length) - 10);
    this._fields.forEach(function (field) {
        var cell = row.insertCell(cellsCount++);
        var output = self.renderCell(itemEntry[field], maxColWidth);
        cell.update(output);
        cell.setAttribute("style", "width: auto");
    });
    var cellDelete = row.insertCell(cellsCount++);
    cellDelete.update('<i alt="Delete" title="Delete" class="cmd-delete fa fa-remove color-danger" style="cursor:pointer;"></i>');
    cellDelete.setAttribute("align", "center");

    if (this._isDraft) {
        row.addClassName("draft-added");
        var cellState = row.insertCell(cellsCount++);
        cellState.update('<i class="fa fa-file-text-o color-retracted"></i>');
        cellState.setAttribute("align", "center");
    }

    row.insertCell(cellsCount++);

    var infobar = $('InfoBar_' + this._listId);
    if (infobar) {
        var infoRow = infobar.up('tr');
        if (infoRow) infoRow.parentNode.removeChild(infoRow);

        // realign headers
        var stretcherId = this._listId + '_stretcher';
        var stretchers = List.get_stretchers();
        stretchers.forEach(function (s) {
            if (s._stretcherID == stretcherId) {
                s._initializeCache();
                s._alignHeaderCells();
            }
        });
    }

    if (this._sortBy) {
        var currentPosition = tbl.rows.length - 1;
        var rowPosition = parseInt(itemEntry["Sort"].Value);
        if (currentPosition != rowPosition) {
            this.moveRow(tbl, row, rowPosition);
        }
    }
    else {
        Sortable.create(this._listId + '_body', {
            tag: 'tr', only: 'listRow', onUpdate: function () {
                self.onListChanged();
            }
        });
    }
    this.onListChanged();
}

Dynamicweb.Items.ListItem.prototype.editRow = function (itemId, itemEntry) {
    var self = this;
    var caller = this._listId + '_body';
    var cellsCount = 0;
    var maxColWidth = 0;

    var tbl = $(caller);
    var row = tbl.down('tr[itemID=' + itemId + ']');
    if (row) {
        var cells = row.select('td');
        maxColWidth = Math.max(80, Math.floor((600) / this._fields.length) - 10);
        this._fields.forEach(function (field) {
            var cell = cells[cellsCount++];
            var output = self.renderCell(itemEntry[field], maxColWidth);
            cell.update(output);
        });

        if (this._isDraft && row.hasClassName("draft-approved")) {
            row.addClassName("draft-edited");
            row.removeClassName("draft-approved");
            var cellState = cells[cells.length - 2];
            cellState.update('<i class="md md-mode-edit color-retracted"></i>');
            cellState.setAttribute("align", "center");
        }

        if (this._sortBy) {
            var currentPosition = this._sortIndexes.indexOf(itemId) + 1;
            var rowPosition = parseInt(itemEntry["Sort"].Value);
            if (currentPosition != rowPosition) {
                this.moveRow(tbl, row, rowPosition);
            }
        }
        this._askConfirmation = true;
    }
}

Dynamicweb.Items.ListItem.prototype.renderCell = function (itemField, maxColWidth) {
    var output = "";
    var doc = Dynamicweb.Ajax.Document.get_current();
    var collHelper = Dynamicweb.Utilities.CollectionHelper;
    var stringHelper = Dynamicweb.Utilities.StringHelper;
    var imageExtensions = ['.bmp', '.emf', '.exif', '.gif', '.guid', '.icon', '.jpeg', '.jpg', '.png', '.tiff', '.wmf'];

    if (itemField) {
        if (itemField.Type === 'Dynamicweb.Content.Items.Editors.FileEditor, Dynamicweb' && collHelper.any(imageExtensions, function (extension) { return itemField.Value.indexOf(extension) > -1; })) {
            let isFocalImage = itemField.Value.indexOf("?") > -1;
            let image = isFocalImage ? itemField.Value.replace("?", "&") : itemField.Value;
            let crop = isFocalImage ? '7' : '5';
            output = '<div class="item-list-editor-list-cell img" style="max-width:' + maxColWidth + 'px;"><img src="/Admin/Public/GetImage.ashx?fmImage_path=' + image + '&Format=jpg&Width=32&Height=32&Crop=' + crop + '" title="' + stringHelper.fileName(image) + '" /></div>';
        } else {
            output = '<div class="item-list-editor-list-cell" style="max-width:' + maxColWidth + 'px;">' + doc.stripTags(doc.decodeTags(itemField.Caption)) + '</div>';
        }
    }

    return output;
}

Dynamicweb.Items.ListItem.prototype.moveRow = function (tbl, row, index) {
    var rowCount = tbl.rows.length - 1;
    if (index <= rowCount) {
        row.remove();
        if (index == rowCount) {
            tbl.rows[index - 1].insert({ after: row });
        }
        else {
            tbl.rows[index].insert({ before: row });
        }
    }

    this.onListChanged();
}

Dynamicweb.Items.ListItem.prototype.delRow = function (row) {
    var self = this;
    if (confirm(this.get_terminology()['DeleteFieldConfirm'])) {
        if (row) {
            if (this._isDraft && !row.hasClassName("draft-added")) {
                var cells = row.select('td');
                row.setAttribute("class", "listRow draft-removed");
                var cellState = cells[cells.length - 2];
                cellState.update('<i class="md md-delete color-retracted"></i>');
                cellState.setAttribute("align", "center");
            }
            else {
                row.parentNode.removeChild(row);
            }
            this.onRowDeleted(row.readAttribute("itemid"));

            var refreshList = null;
            var pageNumberHidden = $('PageNumber');
            var pageSizeHidden = $('PageSize');
            if (self._pagedList && List && pageNumberHidden && pageSizeHidden) {
                this._totalItems--;
                if (self._pageCount > 1) {
                    if (this._totalItems % pageSizeHidden.value == 0 && self._pageCount != 1) {
                        refreshList = function () {
                            List.gotoPage('', pageNumberHidden.value - 1);
                        };
                    } else if (pageNumberHidden.value != 1) {
                        refreshList = function () {
                            location.reload();
                        };
                    }
                }
            }

            if (this._instantSave) {
                if (!isNaN(this._itemListId)) {
                    this.request({
                        params: {
                            AjaxAction: 'SaveDeletedItem',
                            ItemListID: this._itemListId,
                            ItemID: row.readAttribute("itemID")
                        },
                        callback: refreshList
                    })
                }
            } else if (refreshList) {
                refreshList();
            }
        }
    }
}

Dynamicweb.Items.ListItem.prototype.onRowDeleted = function (itemId) {
    if (itemId.startsWith('new_')) {
        this.onListChanged();
    }
    else {
        var index = this._sortIndexes.indexOf(itemId);
        this._sortIndexes[index] = "delete_" + this._sortIndexes[index];
        this.onListChanged();
    }
}

Dynamicweb.Items.ListItem.prototype.onListChanged = function () {
    this._askConfirmation = true;
    this._updateSortIndexes = true;
    var deletedIndexes = [];
    for (let i = 0; i < this._sortIndexes.length; i++) {
        if (this._sortIndexes[i].startsWith('delete_')) {
            deletedIndexes.push(this._sortIndexes[i]);
        }
    }
    this._sortIndexes = this._el.select('tr[itemid]').collect(function (e) { return e.readAttribute('itemid'); });
    this.toggleNoDataMessage(this._sortIndexes.length <= 0);

    $(this._listId).value = this._sortIndexes && this._sortIndexes.length > 0 ? this._sortIndexes.length : ''; // Store length of rows - used in validation
    if (this._isDraft) {
        for (let i = 0; i < deletedIndexes.length; i++) {
            var deletedItemId = deletedIndexes[i].substring('delete_'.length);
            var index = this._sortIndexes.indexOf(deletedItemId);
            this._sortIndexes[index] = "delete_" + deletedItemId;
        }
    }
    else {
        for (let i = 0; i < deletedIndexes.length; i++) {
            this._sortIndexes.push(deletedIndexes[i]);
        }
    }
}

Dynamicweb.Items.ListItem.prototype.toggleNoDataMessage = function (showMessage) {
    var infoBar = $("CustomInfobar_" + this._listId);
    if (infoBar) {
        if (showMessage) {
            infoBar.removeClassName("hidden");
        } else {
            infoBar.addClassName("hidden");
        }
    }
}

Dynamicweb.Items.ListItem.prototype.filterListItems = function () {
    var searchString = $("ItemRelationListFilterSearchText_" + this._listId).value;
    var rows = $(this._listId + "_body").childElements();

    rows.each(function (row) {
        var showRow = true;
        if (searchString.length > 0) {
            var rowColumns = row.childElements();
            showRow = false;

            for (i = 0; i < rowColumns.length - 2; i++) {
                var columnText = rowColumns[i].innerText;
                var foundText = new RegExp(searchString, "i").exec(columnText);
                if (foundText) {
                    showRow = true;
                    break;
                }
            }
        }

        if (!showRow) {
            $(row).setStyle({ display: "none" });
        } else {
            $(row).setStyle({ display: "" });
        }
    });
}

Dynamicweb.Items.ListItem.prototype.sortColumn = function (columnIndex, sortAsc) {
    // Sorts the list by column.
    // int columnIndex - index of the column.
    // bool sortAsc - direction of the sort: true - ASC; false - DESC.

    var rows = $(this._listId + "_body").childElements();
    var reverse = sortAsc ? 1 : -1;

    rows.sort(function (a, b) {
        return reverse * (a.cells[columnIndex].innerText.trim().localeCompare(b.cells[columnIndex].innerText.trim()));
    });

    for (var i = 0; i < rows.length; ++i) {
        $(this._listId + "_body").appendChild(rows[i]);
    }
}

/* Google font editor */

Dynamicweb.Items.GoogleFont = function () {
    this._key = '';
    this._selectedFontHiddenId = '';
    this._selectedFontPreviewSpanId = '';
    this._selectedFontStyleId = '';
    this._editButtonId = '';
    this._dialogId = '';
    this._variantSelectorId = '';
    this._fontsPageContainerId = '';
    this._filterId = '';
    this._searchButtonId = '';
    this._nothingFoundInfoId = '';
    this._filterText = '';
    this._terminology = null;
    this._filteredCollection = null;
    this.pager = null;
}

Dynamicweb.Items.GoogleFont.initialize = function (parameters) {
    var googleFont = new Dynamicweb.Items.GoogleFont();
    googleFont._key = parameters.key;
    googleFont._selectedFontHiddenId = parameters.selectedFontHiddenId;
    googleFont._selectedFontPreviewSpanId = parameters.selectedFontPreviewSpanId;
    googleFont._selectedFontStyleId = parameters.selectedFontStyleId;
    googleFont._editButtonId = parameters.editButtonId;
    googleFont._dialogId = parameters.dialogId;
    googleFont._variantSelectorId = parameters.variantSelectorId;
    googleFont._fontsPageContainerId = parameters.fontsPageContainerId;
    googleFont._filterId = parameters.filterId;
    googleFont._searchButtonId = parameters.searchButtonId;
    googleFont._nothingFoundInfoId = parameters.nothingFoundInfoId;
    googleFont._terminology = parameters.terminology;

    if (!window.googleFontsMeta || Object.keys(window.googleFontsMeta).length < 1) {
        console.log("Font list is empty!");
        alert(googleFont._terminology.errorMessage);
        return googleFont;
    }

    googleFont.pager = Dynamicweb.Items.GoogleFont.Pager.initialize($(parameters.dialogId).select("div.list-pagination")[0]);
    googleFont.pager.refresh(1, googleFont.pager._lastPage);

    Event.observe($(googleFont._editButtonId), "click", function () {
        googleFont.showFontSelector();
    });

    Event.observe($(googleFont._searchButtonId), "click", function () {
        googleFont.filterFonts($(googleFont._filterId).value);
    });

    Event.observe($(googleFont.pager._toStart), "click", function () {
        googleFont.showPage(1);
    });

    Event.observe($(googleFont.pager._previous), "click", function () {
        googleFont.showPage(googleFont.pager._currentPage - 1);
    });

    Event.observe($(googleFont.pager._next), "click", function () {
        googleFont.showPage(googleFont.pager._currentPage + 1);
    });

    Event.observe($(googleFont.pager._toEnd), "click", function () {
        googleFont.showPage(googleFont.pager._lastPage);
    });

    Event.observe($(googleFont._variantSelectorId), "change", function () {
        if ($("DefaultFontWeight")) {
            $("DefaultFontWeight").value = this.value;
        }
    });

    dialog.set_okButtonOnclick(googleFont._dialogId, function () {
        var selected = $(googleFont._fontsPageContainerId).select("div.google-font-preview.selected")[0];
        if (!selected) {
            return;
        }

        var selectedFont = window.googleFontsMeta[$(selected).readAttribute("data-font-key")];
        if (selectedFont) {
            $(googleFont._selectedFontHiddenId).value = selectedFont.Family;
            $(googleFont._selectedFontPreviewSpanId).innerText = selectedFont.Family;
            $(googleFont._variantSelectorId).innerHTML = '';

            if ($("DefaultFontName")) {
                $("DefaultFontName").value = selectedFont.Family;
            }

            var fileKey = selectedFont.Files['regular'] ? 'regular' : Object.keys(selectedFont.Files)[0];
            var style = $(googleFont._selectedFontStyleId);

            var css = '@font-face { font-family: "' + selectedFont.Family + '"; font-weight: ' + fileKey + '; src: url(\'' + selectedFont.Files[fileKey] + '?' + selectedFont.Version + '\'); }\n';
            css += 'span#' + googleFont._selectedFontPreviewSpanId + ' { font-family: "' + selectedFont.Family + '"; }'

            if (style.styleSheet) {
                style.styleSheet.cssText = css;
            } else {
                if (style.hasChildNodes()) {
                    for (var i = 0; i < style.childNodes.length; i++) {
                        style.childNodes[i].remove();
                    }
                }

                style.appendChild(document.createTextNode(css));
            }

            var capitalize = function (string) {
                return string.charAt(0).toUpperCase() + string.slice(1);
            }

            for (var i = 0; i < selectedFont.Variants.length; i++) {
                var variant = selectedFont.Variants[i];
                var matches = /(\d+)([a-zA-Z]*)/.exec(variant);
                var fontStyleText = '';

                if (matches && matches.length == 3) {
                    var fontBold = parseInt(matches[1]);
                    var boldName = '';
                    if (matches[2].length > 0) {
                        fontStyleText = capitalize(matches[2]);
                    }

                    if (fontBold) {
                        if (fontBold < 200) {
                            boldName = googleFont._terminology.thin
                        } else if (fontBold < 300) {
                            boldName = googleFont._terminology.extraLight
                        } else if (fontBold < 400) {
                            boldName = googleFont._terminology.light
                        } else if (fontBold < 500) {
                            boldName = googleFont._terminology.regular
                        } else if (fontBold < 600) {
                            boldName = googleFont._terminology.medium
                        } else if (fontBold < 700) {
                            boldName = googleFont._terminology.semiBold
                        } else if (fontBold < 800) {
                            boldName = googleFont._terminology.bold
                        } else if (fontBold >= 800) {
                            boldName = googleFont._terminology.black
                        }
                    }

                    fontStyleText = boldName + ' ' + fontBold + ' ' + fontStyleText;
                    fontStyleText = fontStyleText.trim();
                } else {
                    fontStyleText = capitalize(variant);
                }

                var option = document.createElement("option");
                option.innerText = fontStyleText;
                option.value = variant;

                $(googleFont._variantSelectorId).appendChild(option);
            }
        }
    });

    return googleFont;
}

Dynamicweb.Items.GoogleFont.prototype.showFontSelector = function () {
    this._filterText = '';
    this.showPage(this.pager._currentPage);
    dialog.show(this._dialogId);
}

Dynamicweb.Items.GoogleFont.prototype.showPage = function (pageNumber) {
    var source = this._filteredCollection || window.googleFontsMeta;

    var fontCount = Object.keys(source).length;
    var pageCount = Math.floor(fontCount / this.pager._pageSize) || 1;

    if (!pageNumber || pageNumber < 1 || pageNumber > pageCount) {
        pageNumber = 1;
    }

    $(this._fontsPageContainerId).select("div.google-font-preview").each(Element.hide);
    this.pager.refresh(pageNumber, pageCount);

    var firstItemIndex = pageNumber * this.pager._pageSize - this.pager._pageSize;
    var lastItemIndex = pageNumber * this.pager._pageSize - 1;
    var i = 0;

    for (var key in source) {
        if (!source.hasOwnProperty(key)) {
            continue;
        }
        if (i < firstItemIndex || i > lastItemIndex) {
            i++;
            continue;
        }

        var elementKey = key + "_" + this._key;
        var elem = $(elementKey);
        if (elem) {
            elem.show();
            i++;
            continue;
        }

        // create new font element
        var font = source[key];
        var fileKey = font.Files['regular'] ? 'regular' : Object.keys(font.Files)[0];

        var head = document.head || document.getElementsByTagName('head')[0];
        var style = document.createElement('style');
        style.type = 'text/css';
        var css = '@font-face { font-family: "' + font.Family + '"; font-weight: ' + fileKey + '; src: url(\'' + font.Files[fileKey] + '?' + font.Version + '\'); }\n';
        css += '#' + elementKey + "-previrew" + ' { font-family: "' + font.Family + '"; }'

        if (style.styleSheet) {
            style.styleSheet.cssText = css;
        } else {
            style.appendChild(document.createTextNode(css));
        }
        head.appendChild(style);

        var fontElement = document.createElement('div');
        fontElement.id = elementKey;
        fontElement.setAttribute("data-font-key", key);
        fontElement.className = 'google-font-preview';

        var self = this;
        fontElement.observe('click', function () {
            self.onFontClick(this);
        });

        var fontName = document.createElement('div');
        fontName.className = "font-name";
        fontName.innerText = font.Family;

        var fontStylesCount = document.createElement('div');
        fontStylesCount.className = "font-styles-count";
        fontStylesCount.innerText = font.Variants.length + ' style' + (font.Variants.length > 1 ? 's' : '');

        var preview = document.createElement('div');
        preview.setAttribute('contenteditable', 'true');
        preview.className = "font-editable-area";
        preview.id = elementKey + "-previrew";
        preview.innerText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam blandit arcu a massa malesuada, rutrum.';

        fontElement.appendChild(fontName);
        fontElement.appendChild(fontStylesCount);
        fontElement.appendChild(preview);
        document.getElementById(this._fontsPageContainerId).appendChild(fontElement);

        i++;
    }
}

Dynamicweb.Items.GoogleFont.prototype.filterFonts = function (searchText) {
    this._filterText = searchText;
    if (this._filterText.length < 1) {
        $(this._nothingFoundInfoId).style.display = 'none';
        this._filteredCollection = null;
        this.pager.show();
        this.showPage(1);
        return;
    }

    this._filteredCollection = new Object();
    var searchString = this._filterText.toLowerCase();
    for (var key in window.googleFontsMeta) {
        if (!window.googleFontsMeta.hasOwnProperty(key)) {
            continue;
        }
        if (window.googleFontsMeta[key].Family.toLowerCase().indexOf(searchString) != -1) {
            this._filteredCollection[key] = window.googleFontsMeta[key];
        }
    }

    if (Object.keys(this._filteredCollection).length > 0) {
        this.pager.show();
        $(this._nothingFoundInfoId).style.display = 'none';
    } else {
        this.pager.hide();
        $(this._nothingFoundInfoId).style.display = '';
    }

    this.showPage(1);
}

Dynamicweb.Items.GoogleFont.prototype.onFontClick = function (element) {
    $(this._fontsPageContainerId).select("div.google-font-preview.selected").each(function (elem) {
        $(elem).removeClassName("selected");
    });

    $(element).addClassName("selected");
}

/* Google font pager */

Dynamicweb.Items.GoogleFont.Pager = function () {
    this._currentPage = 1;
    this._pageSize = 6;
    this._lastPage = 1;
    this._toStart = '';
    this._previous = '';
    this._next = '';
    this._toEnd = '';
    this._currentPageText = '';
    this._lastPageText = '';
    this._pagerContainer = null;
}

Dynamicweb.Items.GoogleFont.Pager.initialize = function (pagerDiv, pageSize) {
    var pager = new Dynamicweb.Items.GoogleFont.Pager();
    pager._pageSize = pageSize || 6;
    pager._lastPage = Math.floor(Object.keys(window.googleFontsMeta).length / this._pageSize);
    pager._toStart = $(pagerDiv).select("div.go-to-start")[0];
    pager._previous = $(pagerDiv).select("div.previous")[0];
    pager._next = $(pagerDiv).select("div.next")[0];
    pager._toEnd = $(pagerDiv).select("div.go-to-end")[0];
    pager._currentPageText = $(pagerDiv).select("span.current-page")[0];
    pager._lastPageText = $(pagerDiv).select("span.last-page")[0];
    pager._pagerContainer = $(pagerDiv);
    pager.refresh();

    return pager;
}

Dynamicweb.Items.GoogleFont.Pager.prototype.refresh = function (currentPage, pageCount) {
    if (currentPage) {
        this._currentPage = currentPage;
    }
    this._currentPageText.innerText = this._currentPage;

    if (pageCount) {
        this._lastPage = pageCount;
    }
    this._lastPageText.innerText = this._lastPage;

    if (this._currentPage == 1) {
        $(this._toStart).addClassName("disabled");
        $(this._previous).addClassName("disabled");
    } else {
        $(this._toStart).removeClassName("disabled");
        $(this._previous).removeClassName("disabled");
    }

    if (this._currentPage == this._lastPage) {
        $(this._toEnd).addClassName("disabled");
        $(this._next).addClassName("disabled");
    } else {
        $(this._toEnd).removeClassName("disabled");
        $(this._next).removeClassName("disabled");
    }
}

Dynamicweb.Items.GoogleFont.Pager.prototype.show = function () {
    this._pagerContainer.style.display = '';
}

Dynamicweb.Items.GoogleFont.Pager.prototype.hide = function () {
    this._pagerContainer.style.display = 'none';
}

function getEditorsInstances(container) {
    let list = [];
    if (typeof (CKEDITOR) == "undefined") {
        return list;
    }
    for (let instanceName in CKEDITOR.instances) {
        let el = document.getElementById(instanceName);
        while (el != container && el != document.body) {
            el = el.parentNode;
        }
        if (el == container) {
            list.push(CKEDITOR.instances[instanceName]);
        }
    }
    return list;
}

function destroyEditors(editors) {
    let promises = [];
    editors.forEach((instance) => {
        if (instance.status == "ready") {
            instance.destroy(true);
        } else {
            promises.push(new Promise((resolve, error) => {
                instance.on("instanceReady", () => {
                    instance.destroy(true);
                    resolve();
                });
            }));
        }
    });
    return promises;
}

function reInitEditors(editors) {
    editors.forEach((instance) => {
        let fn = window["editor-init-" + instance.name + "_fn"];
        if (typeof (fn) == "function") {
            fn();
        }
    });
}

//tabs
window.addEventListener("load", (event) => {
    let mainBlock = document.getElementById('General_fieldSet');
    if (mainBlock == null || mainBlock.parentNode == null) {
        return;
    }
    mainBlock = mainBlock.parentNode;
    let ckEditors = getEditorsInstances(mainBlock);
    Promise.all(destroyEditors(ckEditors)).then(() => {
        mainBlock.querySelectorAll('.js-field-group').forEach((table) => {
            let tabs = [];
            table.querySelectorAll('.js-tab-content').forEach((tabContent) => {
                if (tabContent.closest('.js-field-group') == table) {
                    let tabName = tabContent.getAttribute('data-tabname');
                    let tr = tabContent.closest('.js-tab-tr');
                    table.parentNode.insertBefore(tabContent, table);
                    tr.remove();
                    tabs.push(tabName);
                }
            });
            if (tabs.length > 0) {
                let tabsList = document.createElement("div");
                tabsList.className = "tabs-list";
                table.parentNode.insertBefore(tabsList, table.parentNode.firstChild.nextElementSibling);
                tabs.forEach((tabName) => {
                    let tabLabel = document.createElement("div");
                    tabLabel.className = "tabs-list__label";
                    tabLabel.setAttribute('data-tabname', tabName);
                    tabLabel.innerText = tabName;
                    tabLabel.addEventListener('click', (event) => {
                        table.parentNode.childElements().forEach((child) => {
                            if (child.classList.contains('js-tab-content')) {
                                child.classList.remove('active');
                                if (child.getAttribute('data-tabname') == tabName) {
                                    child.classList.add('active');
                                }
                            }
                        });
                        tabsList.querySelectorAll('.tabs-list__label').forEach((tab) => {
                            tab.classList.remove('active');
                            if (tab.getAttribute('data-tabname') == tabName) {
                                tab.classList.add('active');
                            }
                        });
                    });
                    tabsList.appendChild(tabLabel);
                });
                tabsList.firstChild.classList.add('active');
                table.parentNode.querySelector('.js-tab-content[data-tabname="' + tabsList.firstChild.getAttribute('data-tabname') + '"]').classList.add('active');
                table.parentNode.classList.add('tab-fieldset');
            }
        });
        reInitEditors(ckEditors);
    });
});