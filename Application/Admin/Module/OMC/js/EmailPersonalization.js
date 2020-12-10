if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Page) == 'undefined') {
    Dynamicweb.Page = new Object();
}

Dynamicweb.Page.Personalization = function () {
    this._pageId = 0;
    this._terminology = {};
    this._segmentSections = [];
}

Dynamicweb.Page.Personalization._instance = null;

Dynamicweb.Page.Personalization.get_current = function () {
    if (!Dynamicweb.Page.Personalization._instance) {
        Dynamicweb.Page.Personalization._instance = new Dynamicweb.Page.Personalization();
    }

    return Dynamicweb.Page.Personalization._instance;
}

Dynamicweb.Page.Personalization.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Page.Personalization.prototype.set_pageID = function (pageID) {
    this._pageId = pageID;
}

Dynamicweb.Page.Personalization.prototype.get_pageID = function () {
    return this._pageId;
}

Dynamicweb.Page.Personalization.prototype.initialize = function () {
    var self = this;

    var cells = $$('td.cell-show-as');
    for (var i = 0; i < cells.length; i++) {
        Event.observe(cells[i], 'click', function (e) {
            self.clickShowAsCell(this);
        });
    }

    cells = $$('td.cell-segment');
    for (var i = 0; i < cells.length; i++) {
        Event.observe(cells[i], 'click', function (e) {
            self.clickSegmentCell(this);
        });
    }

    var tblHeadObj = $("ListTable").tHead;
    for (var h = 0; h < tblHeadObj.rows.length; h++) {
        var row = tblHeadObj.rows[h];
        if (row.cells.length > this._segmentSections.length + 2) {
            for (var i = 0; i < this._segmentSections.length; i++) {
                var segmentID = self._segmentSections[i];
                var menuCell = row.cells[i + 2].down("tr").insertCell(-1);
                menuCell.innerHTML = '<a href="javascript:void(0);" class="columnMenu"><img style="margin-bottom: -3px" src="/Admin/Images/Ribbon/UI/List/column_menu.png" border="0"></a>';
                Event.observe(menuCell, 'click', self.showSegmentContextMenu.curry(segmentID));
            }
        }
    }
}

Dynamicweb.Page.Personalization.prototype.clickShowAsCell = function (td) {
    var tr = td.up("tr");
    var elm = td.down("span");
    var isDefault = elm.hasClassName("md-check");
    tr.toggleClassName("show");
    if (isDefault) {
        elm.removeClassName('md-check')
        elm.removeClassName('color-success')
        elm.addClassName('md-close')
        elm.addClassName('color-danger')
    } else {
        elm.removeClassName('md-close')
        elm.removeClassName('color-danger')
        elm.addClassName('md-check')
        elm.addClassName('color-success')
    }
    isDefault = !isDefault

    for (var i = 2; i < tr.cells.length; i++) {
        var cell = tr.cells[i];
        if (cell.hasClassName('selected')) {
            cell.removeClassName('selected');
        }
        if (cell.down()) {
            cell.down().className = "md md-close color-danger";
        }
    }
}

Dynamicweb.Page.Personalization.prototype.clickSegmentCell = function (elm) {
    elm.toggleClassName("selected");
    var tr = elm.up("tr");
    if (tr.cells.length > 1) {        
        if (elm.hasClassName('selected')) {
            elm.down().className = "md md-check color-success";
        } else {
            elm.down().className = "md md-close color-danger";
        }
    }
}

Dynamicweb.Page.Personalization.prototype.openWindow = function (url, windowName, width, height, onPopupClose) {
    if (window.showModalDialog) {
        var returnValue = window.showModalDialog(url, windowName, 'dialogHeight:' + height + 'px; dialogWidth:' + width + 'px;');
        if (onPopupClose) {
            onPopupClose(returnValue);
        }
        return returnValue;
    }
    else {
        if (onPopupClose) {
            var self = this;
            window[windowName + "_modalDialogOk"] = function () {
                onPopupClose.apply(self, arguments);
            }
        }
        var popupWnd = window.open(url, windowName, 'status=0,toolbar=0,menubar=0,resizable=0,directories=0,titlebar=0,modal=yes,width=' + width + ',height=' + height);
    }

}

Dynamicweb.Page.Personalization.prototype.addSegment = function () {    
    var self = this;
    Action.Execute({
        Name: "OpenDialog",
        Url: "/admin/users/dialogs/selectusergroup?mode=4",
        OnSelected: {
            Name: "ScriptFunction",
            Function: function (opts, model) {
                if (model.length > 0) {
                    var id = model[0].Selected;
                    var name = model[0].SelectedName;
                    self.addSegmentWithID(id, name);
                }
            }
        }
    });
}

Dynamicweb.Page.Personalization.prototype.addSegmentWithID = function (segmentID, segmentName) {
    var self = this;

    if (this._segmentSections.indexOf(segmentID) > -1) {
        return;
    }
    this._segmentSections.push(segmentID);
    var cellIndex = this._segmentSections.length + 1;

    var tblHeadObj = $("ListTable").tHead;
    for (var h = 0; h < tblHeadObj.rows.length; h++) {
        var newCell = tblHeadObj.rows[h].insertCell(cellIndex);
        newCell.className = 'columnCell';
        newCell.style.cssText = 'white-space: nowrap;min-width: 40px;';
        newCell.innerHTML = '<table cellspacing="0" cellpadding="0" border="0" style="width: 100%; height: 18px;"><tbody><tr><td><span class="pipe" style="float:left;"><img src="/Admin/Images/x.gif"></span>&nbsp;' + segmentName + '</td></tr></tbody></table>';

        var menuCell = newCell.down("tr").insertCell(-1);
        menuCell.innerHTML = '<a href="javascript:void(0);" class="columnMenu"><img style="margin-bottom: -3px" src="/Admin/Images/Ribbon/UI/List/column_menu.png" border="0"></a>';
        Event.observe(menuCell, 'click', function (e) {
            self.showSegmentContextMenu(segmentID, e);
        });
    }

    var tblBodyObj = $("ListTable").tBodies[0];
    for (var i = 0; i < tblBodyObj.rows.length; i++) {
        var newCell = tblBodyObj.rows[i].insertCell(cellIndex);
        newCell.className = 'cell-segment';
        newCell.align = 'center';
        
        var defaultElm = tblBodyObj.rows[i].down(1);
        if (defaultElm && !defaultElm.hasClassName('show')) {
            newCell.innerHTML = '<span class="md md-close color-danger" />';
        } else {
            newCell.innerHTML = '<span class="md md-check color-success" />';
        }        
        Event.observe(newCell, 'click', function (e) {
            self.clickSegmentCell(this);
        });
    }
}

Dynamicweb.Page.Personalization.prototype.delSegment = function (segmentID) {
    var cellIndex = this._segmentSections.indexOf(segmentID);
    if (cellIndex > -1) {
        this._segmentSections.splice(cellIndex, 1);

        cellIndex += 2;
        var allRows = $("ListTable").rows;
        for (var i = 0; i < allRows.length; i++) {
            if (allRows[i].cells.length > cellIndex) {
                allRows[i].deleteCell(cellIndex);
            }
        }
    }
}

Dynamicweb.Page.Personalization.prototype.showSegmentContextMenu = function (segmentID, e) {
    return ContextMenu.show(e, 'SegmentContextMenu', segmentID, '', 'BottomRight');
}

Dynamicweb.Page.Personalization.prototype.selectSegment = function (segmentID) {
    var cellIndex = this._segmentSections.indexOf(segmentID);
    if (cellIndex > -1) {
        cellIndex += 2;

        var allRows = $("ListTable").rows;
        for (var i = 0; i < allRows.length; i++) {
            var cell = allRows[i].cells[cellIndex];
            if (!allRows[i].hasClassName('show')) {
                if (!cell.hasClassName('selected')) {
                    cell.addClassName('selected');
                }
            }
            else {
                if (cell.hasClassName('selected')) {
                    cell.removeClassName('selected');
                }
            }
        }
    }
}

Dynamicweb.Page.Personalization.prototype.deselectSegment = function (segmentID) {
    var cellIndex = this._segmentSections.indexOf(segmentID);
    if (cellIndex > -1) {
        cellIndex += 2;

        var allRows = $("ListTable").rows;
        for (var i = 0; i < allRows.length; i++) {
            var cell = allRows[i].cells[cellIndex];
            if (allRows[i].hasClassName('show')) {
                if (!cell.hasClassName('selected')) {
                    cell.addClassName('selected');
                }
            }
            else {
                if (cell.hasClassName('selected')) {
                    cell.removeClassName('selected');
                }
            }
        }
    }
}

Dynamicweb.Page.Personalization.prototype.saveSegments = function () {
    var self = this;
    var segments = [];

    var tblBodyObj = $("ListTable").tBodies[0];
    for (var i = 0; i < tblBodyObj.rows.length; i++) {
        var segment = {};
        var row = tblBodyObj.rows[i];

        segment.Id = row.readAttribute("itemid");
        segment.Show = row.hasClassName("show");
        segment.Sections = [];
        for (var j = 0; j < self._segmentSections.length; j++) {
            segment.Sections.push(row.cells[j + 2].hasClassName("selected"));
        }

        segments.push(segment);
    }

    new Ajax.Request("/Admin/Module/OMC/Emails/EmailPersonalization.aspx", {
        method: 'post',
        parameters: {
            AJAX: 'SaveSegments',
            PageID: self.get_pageID(),
            Segments: JSON.stringify(segments),
            Sections: JSON.stringify(self._segmentSections)
        }
    });

}