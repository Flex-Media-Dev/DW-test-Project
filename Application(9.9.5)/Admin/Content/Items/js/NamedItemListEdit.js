if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.NamedListItemEdit = function () {
    this._terminology = {};
    this._page = [];
    this._list = null;
    this._sort = null;
}

Dynamicweb.Items.NamedListItemEdit._instance = null;

Dynamicweb.Items.NamedListItemEdit.get_current = function () {
    if (!Dynamicweb.Items.NamedListItemEdit._instance) {
        Dynamicweb.Items.NamedListItemEdit._instance = new Dynamicweb.Items.NamedListItemEdit();
    }

    return Dynamicweb.Items.NamedListItemEdit._instance;
}

Dynamicweb.Items.NamedListItemEdit.prototype.initialize = function () {
    var self = this;

    // Set List height
    window.onload = window.onresize = function () {
        var ribbonHeight = 0;
        if ($('Ribbon')) {
            ribbonHeight = $('Ribbon').offsetHeight;
        }

        if ($('content')) {
            var contentPaneHeight = (document.body.clientHeight - ribbonHeight - 3);
            if (contentPaneHeight < 0) {
                contentPaneHeight = 1;
            }

            //$('content').style.height = contentPaneHeight + 'px';
        }
    }

    if (this._list) {
        var controlid = this._list + "_body";
        var tblHeadObj = $(controlid).up("table").tHead;
        var row = tblHeadObj.rows[0];
        var sortIndex = this._sort ? parseInt(this._sort.by) : -1;


        for (var i = 0; i < row.cells.length - 2; i++) {
            var menuLink = row.cells[i].down("a.columnMenu");
            menuLink.removeAttribute("onclick");
            Event.observe(menuLink, 'click', self.showSortContextMenu.curry(i));
        }

        if (List) {
            var gotoPageFN = List.gotoPage;
            List.gotoPage = function (controlId, pageNumber) {
                gotoPageFN(controlId, pageNumber)
                self.pageIndexChanged(pageNumber);
            }
        }
    }
}

Dynamicweb.Items.NamedListItemEdit.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Items.NamedListItemEdit.prototype.get_page = function () {
    return this._page;
}

Dynamicweb.Items.NamedListItemEdit.prototype.set_page = function (value) {
    this._page = value;
}

Dynamicweb.Items.NamedListItemEdit.prototype.set_list = function (value) {
    this._list = value;
}

Dynamicweb.Items.NamedListItemEdit.prototype.set_sort = function (value) {
    this._sort = value;
}

Dynamicweb.Items.NamedListItemEdit.prototype.close = function () {
    this.saveSorting();
    location = '/Admin/Content/Page/PageEdit.aspx?ID=' + this.get_page().id;
}

Dynamicweb.Items.NamedListItemEdit.prototype.showAddNamedItemListDialog = function () {
    dialog.show('AddNamedItemListDialog');
}

Dynamicweb.Items.NamedListItemEdit.prototype.addNamedItemList = function () {
    var name = $('NamedListName');
    var itemType = $('NamedListItemType');
    if (!name.value || !name.value.length) {
        try {
            name.focus();
        } catch (ex) { }
        alert(this.get_terminology()['EmptyName']);
        return;
    } else if (!itemType.value || !itemType.value.length) {
        try {
            itemType.focus();
        } catch (ex) { }
        alert(this.get_terminology()['EmptyItemType']);
        return;
    }
    for (var i = 0; i < $('lstNamedItemLists').length; i++) {
        if ($('lstNamedItemLists').options[i].text == name.value) {
            alert(this.get_terminology()['NameShouldBeUnique']);
            return;
        }
    }

    dialog.hide('AddNamedItemListDialog');

    this.executeCommand("CreateNewList");
}

Dynamicweb.Items.NamedListItemEdit.prototype.loadNamedList = function () {
    this.saveSorting();

    this.executeCommand("Load");
}

Dynamicweb.Items.NamedListItemEdit.prototype.showSortContextMenu = function (segmentID, e) {
    return ContextMenu.show(e, 'SortingContextMenu', segmentID, '', 'BottomRightRelative');
}

Dynamicweb.Items.NamedListItemEdit.prototype.sortAscending = function () {
    $('SortIndex').value = ContextMenu.callingID;
    $('SortOrder').value = "asc";
    this.executeCommand("SortList");
}

Dynamicweb.Items.NamedListItemEdit.prototype.sortDescending = function () {
    $('SortIndex').value = ContextMenu.callingID;
    $('SortOrder').value = "desc";
    this.executeCommand("SortList");
}

Dynamicweb.Items.NamedListItemEdit.prototype.pageIndexChanged = function (pageNumber) {
    if (this._sort) {
        $('SortIndex').value = this._sort.by;
        $('SortOrder').value = this._sort.order;
    }
    $('PageNumber').value = pageNumber;
    this.executeCommand("pageIndexChanged");
}

Dynamicweb.Items.NamedListItemEdit.prototype.executeCommand = function (cmd) {
    $('cmd').value = cmd;
    $('MainForm').submit();
}

Dynamicweb.Items.NamedListItemEdit.prototype.deleteItemList = function (cmd) {
    if (confirm(this.get_terminology()['ConfirmDeleteList'])) {
        this.executeCommand("DeleteList");
    }
}

Dynamicweb.Items.NamedListItemEdit.prototype.saveSorting = function () {
    var self = this;

    // Fire event to handle save sorting
    window.document.fire("General:DocumentOnSave");

    var hidden = null;
    var hiddens = document.getElementsByName(this._list);
    if (hiddens.length > 0) {
        hidden = hiddens[0];
    }
    if (hidden && hidden.value) {
        var params = {
            IsAjax: true,
            AjaxAction: 'UpdateSortIndexes',
            ItemListId: JSON.parse(hidden.value).Id,
            PageNumber: $('PageNumber').value,
            PageSize: $('PageSize').value
        }
        params[this._list] = hidden.value;
        new Ajax.Request('/Admin/Content/Items/Editing/NamedItemListEdit.aspx', {
            method: 'POST',
            parameters: params
        });    
    }
}
