var pageList = {
    pageId: 0,
    areaId: 0,
    parentPageId: 0,
    overlayId: 'PleaseWait',

    initialize: function (pageId, areaId, parentPageId) {
        this.pageId = pageId;
        this.areaId = areaId;
        this.parentPageId = parentPageId;
    },

    onListRowContextView: function () {
        var ret = [];
        var row = List.getRowByID('List1', ContextMenu.callingItemID);
        if (row) {
            var permissionLevel = parseInt(row.getAttribute('PermissionLevel'));
            ret[0] = "PageShow";

            if (permissionLevel >= PermissionLevels.Read) {
                ret[ret.length] = 'PageEdit';
                ret[ret.length] = 'PageProperty';
            }
            if (permissionLevel >= PermissionLevels.Edit) {
                var hasSubpages = !!row.getAttribute('HasSubpages');
                if (hasSubpages) {
                    ret[ret.length] = 'PageSort';
                }
            }
            if (permissionLevel >= PermissionLevels.Create) {
                ret[ret.length] = 'PageNew';

                var splitTest = !!row.getAttribute('SplitTest');
                if (!splitTest) {
                    ret[ret.length] = 'PageCopy';
                    ret[ret.length] = 'PageCopyHere';
                }
            }
            if (permissionLevel >= PermissionLevels.Delete) {
                ret[ret.length] = 'PageMove';
                ret[ret.length] = 'PageRemove';
            }
            if (permissionLevel >= PermissionLevels.All) {
                ret[ret.length] = 'PagePermissions';
            }
        }

        return ret;
    },

    showPage: function (pageId) {
        if (!pageId || isNaN(pageId)) {
            pageId = this.pageId;
        }

        window.open("/Default.aspx?ID=" + pageId + "&Purge=True");
    },

    editPage: function (pageId) {
        if (pageId) {
            this.showWait();
            location = "/Admin/Content/ParagraphList.aspx?PageID=" + pageId;
        }
    },

    createPage: function (pageId) {
        if (!pageId || isNaN(pageId)) {
            pageId = this.pageId;
        }

        this.showWait();
        location = "/Admin/Content/Items/Editing/PageTypeSelect.aspx?ID=0&ParentPageID=" + pageId + "&AreaID=" + this.areaId;
    },

    deletePage: function (pageId) {
        if (!pageId || isNaN(pageId)) {
            return;
        }

        this.executeRequest("/Admin/Content/Page/PageList.aspx?CMD=GetDeleteAction&PageID=" + pageId);
    },

    movePage: function (pageId) {
        if (!pageId || isNaN(pageId)) {
            return;
        }

        this.executeRequest("/Admin/Content/Page/PageList.aspx?CMD=GetMoveAction&PageID=" + pageId);
    },

    copyPage: function (pageId) {
        if (!pageId || isNaN(pageId)) {
            return;
        }

        this.executeRequest("/Admin/Content/Page/PageList.aspx?CMD=GetCopyAction&PageID=" + pageId);
    },

    copyHerePage: function (pageId) {
        if (!pageId || isNaN(pageId)) {
            return;
        }

        this.executeRequest("/Admin/Content/Page/PageList.aspx?CMD=GetCopyHereAction&PageID=" + pageId);
    },

    showPermissions: function (pageId) {
        if (!pageId || isNaN(pageId)) {
            return;
        }

        this.executeRequest("/Admin/Content/Page/PageList.aspx?CMD=GetPermissionsAction&PageID=" + pageId);
    },

    sortPage: function (pageId) {
        this.showWait();
        location = "/Admin/Content/Page/PageSort.aspx?ParentPageID=" + pageId + "&AreaID=" + this.areaId + "&SelectedPageID=0";
    },

    cancel: function () {
        if (this.parentPageId > 0) {
            location = "/Admin/Content/ParagraphList.aspx?PageID=" + this.parentPageId;
        }
        else {
            location = "/Admin/Blank.aspx";
        }
    },

    switchToItem: function () {
        this.showWait();
        location = "/Admin/Content/Items/Editing/ItemEdit.aspx?PageID=" + this.pageId;
    },

    switchToParagraphs: function () {
        this.showWait();
        location = "/Admin/Content/ParagraphList.aspx?PageID=" + this.pageId + "&mode=viewparagraphs";
    },

    showProperties: function (pageId) {
        this.showWait();
        pageId = pageId || this.pageId;

        location = "/Admin/Content/Page/PageEdit.aspx?ID=" + pageId;
    },

    showWait: function () {
        new overlay(this.overlayId).show();
    },

    hideWait: function () {
        new overlay(this.overlayId).hide();
    },

    executeRequest: function (url) {
        var self = this;
        new Ajax.Request(url, {
            onCreate: function () {
                self.showWait();
            },
            onSuccess: function (response) {
                if (response.status == 200 && response.responseText.length > 0) {
                    Action.Execute(JSON.parse(response.responseText));
                }
            },
            onComplete: function () {
                self.hideWait();
            }
        });
    }
}