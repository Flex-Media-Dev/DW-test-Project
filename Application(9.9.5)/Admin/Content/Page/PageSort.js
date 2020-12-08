function getSortPage($, options) {
    var opts = options;
    var colIndxByName = {
        name: 1,
        created: 2,
        updated: 3
    };
    return {
        init: function () {
            this._progressBar = new overlay('actionOverlay');
            $(".list-group-item .sort-col").on("click", function () {
                var colName = $(this).data("col-name");
                var idx = colIndxByName[colName];
                if (!idx) {
                    return;
                }
                var cols = $(this).closest(".list-group-item");
                var desc = $(this).hasClass("active") && cols.hasClass("up");
                cols.find(".sort-col").removeClass("active");
                cols.removeClass("up down").addClass(desc ? "down" : "up");
                $(this).addClass("active");

                var itemsCnt = $("#items");
                var items = itemsCnt.find("li");
                items.detach();
                var rows = items.sort(function (a, b) {
                    var x = $($(a).children()[idx]).text();
                    var y = $($(b).children()[idx]).text();
                    var res = ((x < y) ? -1 : ((x > y) ? 1 : 0));
                    if (desc) {
                        res *= -1;
                    }
                    return res;
                });
                rows.each(function f(idx, item) {
                    itemsCnt.append($(item));
                });
            });
            Position.includeScrollOffsets = true;
            Sortable.create("items", {
                onUpdate: function (element) {}
            });
        },

        save: function () {
            this._saveHandler(false);
        },

        saveAndClose: function () {
            this._saveHandler(true);
        },

        cancel: function () {
            this._goToHome();
        },

        _goToHome: function() {
            location = '/Admin/Blank.aspx';
        },
        
        _saveHandler: function (redirect) {
            var self = this;
            self._progressBar.show();
            $.post("/Admin/Content/Page/PageSort.aspx", {
                "ParentPageID": opts.parentPageId,
                "AreaID": opts.areaId,
                "Pages": Sortable.sequence('items').join(','),
                "Save": "save",
                dataType: "json"
            }, function (res) {
                eval(res);
                self._progressBar.hide();
                if (redirect) {
                    self._goToHome();
                } else {
                    self._updateSortingColumn();
                }
            });
        },

        _updateSortingColumn: function () {
            for (i = 0; i < Sortable.sequence('items').length; i++) {
                $("#items > li > span.C3")[i].innerHTML = i+1;
            }
        }

    };
}