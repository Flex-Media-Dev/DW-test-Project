var backend = {
    patterns: null,
    index: 1,

    setBeforeSave: function() {
        window["paragraphEvents"].setBeforeSave(backend.beforeParagraphSave);
    },

    initPatternImages: function (json) {
        var arrStr = $('ImagePatternInit').value;
        if (arrStr != null && arrStr != '') {
            var arr = eval(arrStr);
            backend.patterns = arr;
        }

        if (arr == null || arr.count == 0) {
            return;
        }

        backend.patterns.each(function (item) {
            item.key = backend.index;
            backend.createPattern(item, backend.index);
            backend.index++;
        });
    },

    beforeParagraphSave: function () {
        if (backend.patterns) {
            backend.patterns.each(function (item) {
                var key = item.key;

                item.name = $('ImagePatternName' + key).value;
                item.pattern = $('ImagePattern' + key).value;
                item.width = $('ImagePatternWidth' + key).value;
                item.height = $('ImagePatternHeight' + key).value;
            });

            var altJson = Object.toJSON(backend.patterns);

            var regex = new RegExp("\"", "g");
            altJson = altJson.replace(regex, "&quot;"); //because method in paragraph save replace " to string.Empty :(

            $('AltImagePatterns').value = altJson;
        }
        var parameters = null;
        var sortByParams = null;
        var querySelector = document.getElementById("IndexQuery");
        var query = querySelector[querySelector.selectedIndex];
        if (query.value) {
            var conditionsList = Dynamicweb.Ajax.ControlManager.get_current().findControl("QueryConditions");
            parameters = conditionsList.get_dataSource();
            var sortByList = Dynamicweb.Ajax.ControlManager.get_current().findControl("QuerySortByParams");
            sortByParams = sortByList.get_dataSource();

            sortByParams.sort(function(a, b) {
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

    createPatternAuto: function () {
        if (backend.patterns == null) {
            backend.patterns = new Array();
        }

        var item = {
            'key': backend.index,
            'name': 'Alt_' + backend.index,
            'pattern': '',
            'width': '',
            'height': ''
        };

        backend.patterns.push(item);

        backend.createPattern(item, backend.index);
        backend.index++;
    },

    createPattern: function (item, index) {
        $('AlternativePictureHeader').style.display = '';

        var clone = $('AlternativePicture').clone(true);

        clone.id = clone.id + index;
        clone.style.display = "";

        backend.setInput(clone, "ImagePatternName", item.name, index);
        backend.setInput(clone, "ImagePattern", item.pattern, index);
        backend.setInput(clone, "ImagePatternWidth", item.width, index);
        backend.setInput(clone, "ImagePatternHeight", item.height, index);

        var imgDelete = clone.select('#imagePatternDelete')[0];
        imgDelete.id = imgDelete.id + index;
        imgDelete.writeAttribute({ 'key': index });

        $('imagePatternBottom').insert({ 'before': clone });
    },

    setInput: function (row, id, value, index) {
        var newId = id + index;

        var input = row.select('#' + id)[0];
        input.id = newId;
        input.name = newId;
        input.value = value;
    },

    toggleSearchInSubfolders: function () {
        document.getElementById('PatternsWarningContainer').style.display = $("ImageSearchInSubfolders").checked ? 'block' : 'none';
    },

    addPattern: function () {
        backend.createPatternAuto();
    },

    deleteImage: function (img) {
        var index = 0;
        var key;
        var imgkey = img.readAttribute('key');
        backend.patterns.each(function (item) {
            if (item.key == imgkey) {
                key = item.key;
                throw $break;
            }
            index++;
        });

        backend.patterns.splice(index, 1);

        $('AlternativePicture' + key).remove();

        if (backend.patterns.length == 0) {
            $('AlternativePictureHeader').style.display = 'none';
        }
    }
};

function loadQueryInfo(cmd, queryValue, fn) {
    var paragraphId = $("ParagraphID").value;
    var pageId = $("ParagraphPageID").value;
    var moduleName = $("ModuleSystemName").value;
    var url = "/Admin/Module/eCom_Catalog/eCom_Catalog_Edit.aspx?ID=" + paragraphId + "&PageID=" + pageId + "&ParagraphModuleSystemName=" + moduleName + "&cmd=" + cmd + "&query=" + encodeURIComponent(queryValue);
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
        var p = sortByList.get_pager();
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
