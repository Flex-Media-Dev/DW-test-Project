

var news = {

    filters: null,

    listControl: {
        callingItem: function () {
            var item = ContextMenu.callingItemID;
            return eval("(" + item + ")");
        },

        contextMenuView: function (sender, args) {
            var row = news.listControl.callingItem();

            if (row.active) {
                ret = 'active';
            }
            else {
                ret = 'unactive';
            }

            if (!row.archive) {
                ret += "_arc"
            }
            else {
                ret += "_unarc"
            }

            if (row.related) {
                ret = "related"
            }

            return ret;
        },

        getSelectedItems: function () {
            var itemsIds = news.listControl.getMergedSelectedItems();

            if (itemsIds == null) {
                itemsIds = news.listControl.callingItem().id;
            }

            return itemsIds;
        },

        getMergedSelectedItems: function () {

            var prevstr = $('selectedItems').value;
            var selectedrows = List.getSelectedRows('List1');

            if (prevstr.length == 0 && selectedrows.length == 0) {
                return null;
            }
            else if (prevstr.length > 0 && selectedrows.length == 0) {
                var allitems = eval(prevstr);
                return allitems.join(",");
            }
            else if (prevstr.length == 0 && selectedrows.length >= 0) {
                var ids = [];
                for (var i = 0; i < selectedrows.length; i++) {

                    var info = selectedrows[i].readAttribute('itemid')
                    if (info != null) {
                        var item = eval("(" + info + ")");
                        ids.push(item.id);
                    }
                }
                return ids.join(",");
            }
            else if (prevstr.length > 0 && selectedrows.length > 0) {
                var allitems = eval(prevstr);
                var allrows = $('showitems').value.split(',');

                for (i = 0; i < allrows.length; i++) {
                    var id = parseInt(allrows[i]);
                    var idx = allitems.indexOf(id)
                    if (idx >= 0) {
                        allitems.splice(idx, 1); //remove item
                    }
                }

                for (var i = 0; i < selectedrows.length; i++) {

                    var info = selectedrows[i].readAttribute('itemid')
                    if (info != null) {
                        var item = eval("(" + info + ")");
                        allitems.push(item.id);
                    }
                }

                return allitems.join(",");
            }
            return null;
        },

        disableRelatedRows: function () {
            var rows = List.getAllRows('List1');

            if (rows) {
                for (var i = 0; i < rows.length; i++) {
                    var info = rows[i].readAttribute('itemid');
                    if (info != null) {
                        var item = eval("(" + info + ")");
                        if (item.related) {
                            var checkbox = rows[i].select('input[type="checkbox"]');
                            if (checkbox && checkbox.length > 0) {
                                checkbox[0].disabled = true;
                            }
                        }
                    }
                }
            }
        }
    },

    contentSubsClick: function (categoryId, status) {
        var newsIds = this.listControl.getSelectedItems();
        this.contentSubs(newsIds, categoryId, status);
    },

    contentSubs: function (newsId, categoryId, status) {

        var qs = Object.toQueryString({
            'cmd': 'contentSubs_news',
            newsIds: newsId,
            categoryId: categoryId,
            status: status,
            filters: news.filters
        });

        main.openInContentFrame("OperationHandler.aspx?" + qs);
    },

    archiveClick: function (categoryId, status, isArchive) {
        var newsIds = this.listControl.getSelectedItems();
        this.archive(newsIds, categoryId, status, isArchive);
    },

    archive: function (newsId, categoryId, status, isArchive) {

        var qs = Object.toQueryString({
            'cmd': 'archive_news',
            newsIds: newsId,
            categoryId: categoryId,
            status: status,
            archive: isArchive,
            filters: news.filters
        });

        main.openInContentFrame("OperationHandler.aspx?" + qs);
    },

    activateClick: function (categoryId, status, isActivate) {
        var newsIds = this.listControl.getSelectedItems();
        this.activate(newsIds, categoryId, status, isActivate);
    },

    activate: function (newsId, categoryId, status, isActivate) {

        var qs = Object.toQueryString({
            'cmd': 'activate_news',
            newsIds: newsId,
            categoryId: categoryId,
            status: status,
            activate: isActivate,
            filters: news.filters
        });

        main.openInContentFrame("OperationHandler.aspx?" + qs);
    },

    edit: function (newsId, categoryId, status) {

        var qs = Object.toQueryString({
            id: newsId,
            categoryId: categoryId,
            status: status,
            filters: news.filters
        });

        main.openInContentFrame("News_edit.aspx?" + qs);
    },

    editOMC: function (newsId, categoryId, status) {

        var qs = Object.toQueryString({
            id: newsId,
            categoryId: categoryId,
            status: status,
            filters: news.filters
        });

        main.openInContentFrame("News_edit.aspx?openOMC=true&" + qs);
    },


    editClick: function (categoryId, status) {
        var newsId = this.listControl.callingItem().id;
        this.edit(newsId, categoryId, status);
    },

    add: function (categoryId, status) {
        news.edit(0, categoryId, status);
    },

    addClick: function (status) {
        var categoryId = ContextMenu.callingItemID;
        news.edit(0, categoryId, status);
    },

    all: function () {

        var qs = Object.toQueryString({
            filters: news.filters
        });

        main.openInContentFrame("News_all.aspx?" + qs);
    },

    list: function (categoryId, status) {

        var qs = Object.toQueryString({
            categoryId: categoryId,
            status: status,
            filters: news.filters
        });

        main.openInContentFrame("News_list.aspx?" + qs);
    },

    remove: function (newsId, categoryId, status) {
        if (main.confirmDelete()) {

            var qs = Object.toQueryString({
                'cmd': 'delete_news',
                newsIds: newsId,
                categoryId: categoryId,
                status: status,
                filters: news.filters
            });

            main.openInContentFrame("OperationHandler.aspx?" + qs);
        }
    },

    copy: function (newsId, currentCategoryId, currentStatus, targetCategoryId, targetStatus) {

        var qs = Object.toQueryString({
            'cmd': 'copy_news',
            newsIds: newsId,
            currentCategoryId: currentCategoryId,
            currentStatus: currentStatus,
            targetCategoryId: targetCategoryId,
            targetStatus: targetStatus,
            filters: news.filters
        });

        main.openInContentFrame("OperationHandler.aspx?" + qs);
    },

    move: function (newsId, currentCategoryId, currentStatus, targetCategoryId, targetStatus) {

        var qs = Object.toQueryString({
            'cmd': 'move_news',
            newsIds: newsId,
            currentCategoryId: currentCategoryId,
            currentStatus: currentStatus,
            targetCategoryId: targetCategoryId,
            targetStatus: targetStatus,
            filters: news.filters
        });

        main.openInContentFrame("OperationHandler.aspx?" + qs);
    },

    openCopyDialog: function (newsId, categoryId, status) {

        var qs = Object.toQueryString({
            'cmd': 'copy_news',
            newsId: newsId,
            categoryId: categoryId,
            status: status,
            filters: news.filters
        });

        window.open("Tree.aspx?" + qs, "_new", "width=220,height=375,resizable=yes,scrollbars=yes,toolbar=no,location=no,directories=no,status=no,top=155,left=202");
    },

    openMoveDialog: function (newsId, categoryId, status) {

        var qs = Object.toQueryString({
            'cmd': 'move_news',
            newsId: newsId,
            categoryId: categoryId,
            status: status,
            filters: news.filters
        });

        window.open("Tree.aspx?" + qs, "_new", "width=220,height=375,resizable=yes,scrollbars=yes,toolbar=no,location=no,directories=no,status=no,top=155,left=202");
    },

    deleteClick: function (categoryId, status) {
        var newsIds = this.listControl.getSelectedItems();
        this.remove(newsIds, categoryId, status);
    },

    copyClick: function (categoryId, status) {
        var newsIds = this.listControl.getSelectedItems();
        this.openCopyDialog(newsIds, categoryId, status);
    },

    moveClick: function (categoryId, status) {
        var newsIds = this.listControl.getSelectedItems();
        this.openMoveDialog(newsIds, categoryId, status);
    }
}
