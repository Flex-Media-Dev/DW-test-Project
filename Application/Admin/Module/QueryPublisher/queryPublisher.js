var backend = {

    initialisation: function () {
        window["paragraphEvents"].setBeforeSave(backend.beforeParagraphSave);

        SelectionBox.setNoDataLeft("selectFacets");
        SelectionBox.setNoDataRight("selectFacets");
        backend.serializeFacets();
    },

    indexQueryChanged: function () {
        var querySelector = document.getElementById("ddlQuerySelect");
        var query = querySelector[querySelector.selectedIndex];
        if (!query.value) {
            hideQueryParameters();
        }
        backend.loadQueryInfo("GetQueryInfo", function (responseText) {
            document.getElementById("selectionBoxContainer").innerHTML = responseText;
            SelectionBox.setNoDataLeft("selectFacets");
            SelectionBox.setNoDataRight("selectFacets");
            backend.serializeFacets();
            var info = JSON.parse($("query-info").innerHTML);
            backend.fillQueryInfo(info, {
                fetchParameters: true,
                fetchSortBy: true
            });
        });
    },

    serializeFacets: function () {
        var facets = SelectionBox.getElementsRightAsArray("selectFacets");
        var values = "";

        for (var i = 0; i < facets.length; i++) {
            if (i > 0)
                values += ",";
            values += facets[i];
        }

        document.getElementById("facets").value = values;
    },

    beforeParagraphSave: function () {
        var parameters = null;
        var sortByParams = null;
        var querySelector = document.getElementById("ddlQuerySelect");
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
        backend.storeIndexQueryInfo(parameters, sortByParams);
    },

    loadQueryInfo: function (cmd, fn) {
        var paragraphId = $("ParagraphID").value;
        var pageId = $("ParagraphPageID").value;
        var moduleName = $("ModuleSystemName").value;
        var querySelector = document.getElementById("ddlQuerySelect");
        var query = querySelector[querySelector.selectedIndex];
        var queryValue = encodeURIComponent(query.value);

        var url = "/Admin/Module/QueryPublisher/QueryPublisher_edit.aspx?ID=" + paragraphId + "&PageID=" + pageId + "&ParagraphModuleSystemName=" + moduleName + "&cmd=" + cmd + "&query=" + queryValue;
        new Ajax.Request(url, {
            method: 'get',
            onSuccess: function (response) {
                fn(response.responseText);
            }
        });
    },

    loadJsonQueryInfo: function (cmd, fn) {
        backend.loadQueryInfo(cmd, function (responseText) {
            var info = JSON.parse(responseText);
            fn(info);
        });
    },

    loadDefaultQueryParameters: function () {
        backend.loadJsonQueryInfo("GetDefaultQueryConditions", function (obj) {
            backend.fillQueryInfo(obj, {
                fetchParameters: true
            });
        });
    },

    loadDefaultQuerySortBy: function () {
        backend.loadJsonQueryInfo("GetDefaultQueryConditions", function (obj) {
            backend.fillQueryInfo(obj, {
                fetchSortBy: true
            });
        });
    },

    fillQueryInfo: function (info, options) {
        if (options.fetchParameters) {
            var conditionsList = Dynamicweb.Ajax.ControlManager.get_current().findControl("QueryConditions");
            conditionsList.set_dataSource(info.parameters);
            backend.isDefaultConditionParameters = info.isDefaultParameters;
            let p = conditionsList.get_pager();
            p.set_current(1);
            p.fireClickEvent();

            // Parameter to check
            let parameterToCheckList = document.getElementById("ParameterToSpellCheck");
            parameterToCheckList.innerHTML = "";
            let emptyOption = document.createElement('option');
            emptyOption.value = "";
            emptyOption.innerHTML = "";
            parameterToCheckList.appendChild(emptyOption);
            info.parameters.each(function (item) {
                let opt = document.createElement('option');
                opt.value = item.properties.Name;
                opt.innerHTML = item.properties.Name;
                parameterToCheckList.appendChild(opt);
            });
        }
        if (options.fetchSortBy) {
            var sortByList = Dynamicweb.Ajax.ControlManager.get_current().findControl("QuerySortByParams");
            sortByList.get_columns()[0].editor.set_options(info.sortByFieldNames);
            sortByList.set_dataSource(info.sortBy);
            backend.isDefaultSortByParameters = info.isDefaultSortBy;
            let p = sortByList.get_pager();
            p.set_current(1);
            p.fireClickEvent();

            // Field to check

            let fieldToCheckList = document.getElementById("FieldToSpellCheck");
            fieldToCheckList.innerHTML = "";
            let emptyOption = document.createElement('option');
            emptyOption.value = "";
            emptyOption.innerHTML = "";
            fieldToCheckList.appendChild(emptyOption);
            info.sortByFieldNames.each(function (item) {
                let opt = document.createElement('option');
                opt.value = item.value;
                opt.innerHTML = item.text;
                fieldToCheckList.appendChild(opt);
            });
        }
    },

    storeIndexQueryInfo: function (queryConditions, sortByParams) {
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
        if (!backend.isDefaultConditionParameters || isModified(queryConditions)) {
            condParameters = [];
            queryConditions.each(function (item) {
                if (item.get_state() != "Deleted") {
                    condParameters.push(item.get_properties());
                }
            });
        }

        $$("input[name=QueryConditions]")[0].value = toJson(condParameters);

        var orderParameters = null;
        if (!backend.isDefaultSortByParameters || isModified(sortByParams)) {
            orderParameters = [];
            sortByParams.each(function (item) {
                if (item.get_state() != "Deleted") {
                    orderParameters.push(item.get_properties());
                }
            });
        }
        $$("input[name=QuerySortByParams]")[0].value = toJson(orderParameters);
    }

}
