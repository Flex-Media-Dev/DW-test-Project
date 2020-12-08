var backend = {
    init: function (options) {
        this.isDefaultConditionParameters = options.isDefaultConditionParameters || true;
        this.isDefaultSortByParameters = options.isDefaultSortByParameters || true;
        this.options = options;

        ReturnSettings();
        togglePagedQueriesOptionsVisibility();

        toggleQueryParameters($("IndexQuery").value);
    },

    save: function (close) {
        var feedNameInput = document.getElementById('FeedName');
        if (!feedNameInput.value) {
            var errorMessage = this.options && this.options.terminology && this.options.terminology.invalidName ? this.options.terminology.invalidName : "Please specify the name.";
            dwGlobal.showControlErrors(feedNameInput, errorMessage);
            return false;
        }

        new overlay("__ribbonOverlay").show();

        this.beforeParagraphSave();
        $('Cmd').value = "save" + (close ? "andclose" : "");
        document.forms.Form1.submit();
    },

    cancel: function () {
        if (this.options && this.options.closeAction) {
            Action.Execute(this.options.closeAction);
        } else {
            location = "/Admin/Blank.aspx";
        }
    },

    beforeParagraphSave: function () {
        var parameters = null;
        var sortByParams = null;
        var querySelector = document.getElementById("IndexQuery");
        var query = querySelector[querySelector.selectedIndex];
        if (query.value) {
            var conditionsList = Dynamicweb.Ajax.ControlManager.get_current().findControl("QueryConditions");
            parameters = conditionsList.get_dataSource();
            var sortByList = Dynamicweb.Ajax.ControlManager.get_current().findControl("QuerySortByParams");
            sortByParams = sortByList.get_dataSource();

            sortByParams.sort(function (a, b) {
                if (a.get_id() > b.get_id()) {
                    return 1;
                }
                if (a.get_id() < b.get_id()) {
                    return -1;
                }

                return 0;
            });
        }
        storeIndexQueryInfo(parameters, sortByParams);
    },

    indexQueryChanged: function () {
        var querySelector = document.getElementById("IndexQuery");
        var query = querySelector[querySelector.selectedIndex];
        if (!query.value) {
            hideQueryParameters();
        }

        loadQueryInfo("GetQueryInfo", query.value, function (responseText) {
            var info = JSON.parse(responseText);
            fillQueryInfo(info, {
                fetchParameters: true,
                fetchSortBy: true
            });
            toggleQueryParameters(!!query.value);
        });
    }

};

function ReturnSettings() {
    var obj = document.forms.Form1.FeedSource;
    GetSettings(obj);
    //for (var i = 0; i < obj.length; i++) {
    //    if (obj[i].checked) {
    //        GetSettings(obj[i]);
    //    }
    //}
}

function GetSettings(obj) {
    //switch (obj.value) {
    //    case "Groups":
    //        document.getElementById('ProductListBox').style.display = 'block';
    //        document.getElementById('ChannelsContainer').style.display = 'none';
    //        document.getElementById('ProductIndexBox').style.display = 'none';

    //        break;
    //    case "Channels":
    //        document.getElementById('ProductListBox').style.display = "none";
    //        document.getElementById('ProductIndexBox').style.display = 'none';
    //        document.getElementById('ChannelsContainer').style.display = 'block';

    //        break;
    //    case "Index":
            document.getElementById('ProductListBox').style.display = 'none';
            document.getElementById('ChannelsContainer').style.display = 'none';
            document.getElementById('ProductIndexBox').style.display = 'block';

    //        break;
    //    default:
    //        //Nothing	
    //}
}

function checkDisplayCachingExpiration(checkbox) {
    var expInput = document.getElementById("FrontendCachingExpiration");
    if (checkbox.checked && (expInput.value == "" || expInput.value == "0"))
        expInput.value = "1";
}

function togglePagedQueriesOptionsVisibility(isVisible) {
    var chk = null, row = null;

    if (typeof (isVisible) == 'undefined' || isVisible == null) {
        chk = document.getElementById('chkPagedQueries');
        if (chk != null) {
            isVisible = chk.checked;
        }
    }

    row = document.getElementById('rowForcePagedQueries');
    if (row) {
        row.style.display = isVisible ? '' : 'none';
    }
}

function loadQueryInfo(cmd, queryValue, fn) {
    var url = "/Admin/Module/eCom_Catalog/dw7/Feeds/FeedEdit.aspx?cmd=" + cmd + "&query=" + encodeURIComponent(queryValue) + "&FeedId=" + document.getElementById("FeedIdHidden").value;
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function (response) {
            fn(response.responseText);
        }
    });
}

function loadJsonQueryInfo(cmd, queryValue, fn) {
    loadQueryInfo(cmd, queryValue, function (responseText) {
        var info = JSON.parse(responseText);
        fn(info);
    });
}

function fillQueryInfo(info, options) {
    if (options.fetchParameters) {
        var conditionsList = Dynamicweb.Ajax.ControlManager.get_current().findControl("QueryConditions");
        conditionsList.set_dataSource(info.parameters);
        backend.isDefaultConditionParameters = info.isDefaultParameters;
        var p = conditionsList.get_pager();
        p.set_current(1);
        p.fireClickEvent();
    }
    if (options.fetchSortBy) {
        var sortByList = Dynamicweb.Ajax.ControlManager.get_current().findControl("QuerySortByParams");
        sortByList.get_columns()[0].editor.set_options(info.sortByFieldNames);
        sortByList.set_dataSource(info.sortBy);
        backend.isDefaultSortByParameters = info.isDefaultSortBy;
        var p = sortByList.get_pager();
        p.set_current(1);
        p.fireClickEvent();
    }
}

function loadDefaultQueryParameters() {
    var querySelector = document.getElementById("IndexQuery");
    var query = querySelector[querySelector.selectedIndex];
    loadJsonQueryInfo("GetDefaultQueryConditions", query.value, function (obj) {
        fillQueryInfo(obj, {
            fetchParameters: true
        });
    });
}

function loadDefaultSortByParams() {
    var querySelector = document.getElementById("IndexQuery");
    var query = querySelector[querySelector.selectedIndex];
    loadJsonQueryInfo("GetDefaultQuerySortByParams", query.value, function (obj) {
        fillQueryInfo(obj, {
            fetchSortBy: true
        });
    });
}

function toggleQueryParameters(showParams) {
    if (showParams) {
        $$(".query-props-group").invoke("removeClassName", "hide");
    } else {
        $$(".query-props-group").invoke("addClassName", "hide");
    }
}

function hideQueryParameters() {
    toggleQueryParameters(false);
}

function storeIndexQueryInfo(queryConditions, sortByParams) {
    var isModified = function (col) {
        return col && col.any(function (item) {
            return item.get_state() != "Clean";
        });
    };
    var toJson = function (obj) {
        var altJson = Object.toJSON(obj);
        var regex = new RegExp("\"", "g");
        altJson = altJson.replace(regex, "&quot;");
        return altJson;
    };

    var condParameters = null;
    if (queryConditions != null) {
        condParameters = [];
        queryConditions.each(function (item) {
            if (item.get_state() != "Deleted") {
                condParameters.push(item.get_properties());
            }
        });
    }
    $$("input[name=QueryConditions]")[0].value = condParameters && condParameters.length > 0 ? toJson(condParameters) : "";


    var orderParameters = null;
    if (!backend.isDefaultSortByParameters || isModified(sortByParams)) {
        orderParameters = [];
        sortByParams.each(function (item) {
            if (item.get_state() != "Deleted") {
                orderParameters.push(item.get_properties());
            }
        });
    }

    $$("input[name=QuerySortByParams]")[0].value = orderParameters ? toJson(orderParameters) : "";

}
