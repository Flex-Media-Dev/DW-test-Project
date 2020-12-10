var ThumbnailView = function () {
    this.enabled = false;
}
ThumbnailView.prototype.selectAllFiles = function (selected) {
    var rows = $$('.listRow .fm_column_thumbnail');
    if (rows) {
        for (var i = 0; i < rows.length; i++) {
            this.setRowSelected(rows[i], selected);
        }
    }
}
ThumbnailView.prototype.setRowSelected = function (row, selected) {
    var checkbox = null;
    var checkAll = null;
    row = $(row);
    checkbox = row.select('input[type="checkbox"]');
    /* Changing row style */
    if (!selected) {
        row.removeClassName('selected');
        checkAll = $('chk_all_Files');
        if (checkAll) {
            /* Row has been deselected. Clearing 'Select all' checkbox state */
            checkAll.checked = false;
        }
    } else {
        row.addClassName('selected');
    }
    /* Changing the 'checked' state of the checkbox which corresponds to the row */
    if (checkbox && checkbox.length > 0) {
        checkbox = checkbox[0];
        checkbox.checked = selected;
    }
    if (typeof (ContextMenu) != 'undefined')
        ContextMenu.hide();
}

ThumbnailView.prototype.getSelectedRows = function () {
    var ret = [];
    var rows = $$('tbody[id="Files_body"] > tr.listRow > td > div.fm_column_thumbnail');
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
}
ThumbnailView.prototype.rowIsSelected = function (rowID) {
    if (rowID.indexOf('row') < 0)
        rowID = 'row' + rowID;
    var row = $$('tbody[id="Files_body"] > tr.listRow > td > div.fm_column_thumbnail[id="' + rowID + '"]');
    var ret = false;
    var checkbox = null;
    if (row && row.length > 0) {
        checkbox = row[0].select('input[type="checkbox"]');
        if (checkbox && checkbox.length > 0) {
            ret = checkbox[0].checked;
        }
    }

    return ret;
}

ThumbnailView.prototype.onRowSelected = function () {
    // Use enable or disable    
    var rows = this.getSelectedRows();
    var enable = rows.length > 0
    if (enable) {
        ContextMenu.callingItemID = rows[0].readAttribute('itemID');
        ContextMenu.callingID = rows[0].readAttribute('id');
    }
    __page.checkToolbarButtons(rows, ContextMenu.callingItemID);
}