
function showSetValueDialog(fieldType, fieldId, rowId) {
    fieldType = fieldType || ContextMenu.callingItemID;
    fieldId = fieldId || ContextMenu.callingID;
    var container = document.getElementById("editorsContainer");
    var editor = Dynamicweb.PIM.BulkEdit.get_current()._setEditorsVisibility(container, fieldId);
    var currentField = rowId ? document.getElementById(rowId + fieldId) : null;
    var currentFieldValue = currentField ? currentField.value : "";
    switch (fieldType) {
        case "EditorText":
            const editorWrapper = new EditorWrapper('EditorTextFieldEditor');
            editorWrapper.setData(currentFieldValue);
            break;
        case "DateTime":
        case "Date":
            setDateField(Dynamicweb.PIM.BulkEdit.get_current()[fieldType + "FieldEditorId"]);
            break;
        case "Select":
            editor.value = currentField ? currentField.value : editor.options[0].value;
            break;
        case "Link":
            document.getElementById("Link_" + editor.id).value = currentFieldValue;
        default:
            editor.value = currentFieldValue;
    }
    document.getElementById("currentProductRow").value = rowId || "";
    document.getElementById("currentFieldType").value = fieldType || "Text";
    document.getElementById("currentFieldId").value = fieldId || "";
    dialog.show('SetValueDialog');
};

function updateFieldValues() {
    var fieldType = document.getElementById("currentFieldType").value;
    var self = Dynamicweb.PIM.BulkEdit.get_current();
    var editorcontainer = null;
    var editorsContainer = document.getElementById("editorsContainer");
    for (var i = 0; i < editorsContainer.children.length; i++) {
        var container = editorsContainer.children[i];
        if (container.tagName === "DIV") {
            if (!!self._getFieldsGridEditor(fieldType, container)) {
                editorcontainer = container;
                break;
            }
        }
    }
    if (!editorcontainer) {
        editorcontainer = editorsContainer.firstElementChild;
    }

    var updatedValue = self._getEditorValue(editorcontainer, fieldType);

    var visibleRowIds = null;
    var rowId = document.getElementById("currentProductRow").value;
    if (rowId) {
        visibleRowIds = [rowId];
    } else if (listHasFilter()) {
        visibleRowIds  = getRows(true).map(function (row) { return row.getAttribute("data-product-id") + "_;_" + row.getAttribute("data-variant-id") + "_;_" + row.getAttribute("data-language-id") + "_;_" });
    }
    var definitions = self._controlDefinitions.filter(function (definition, index) {
        if (visibleRowIds != null && !visibleRowIds.some(function (rowId) { return definition.controlId.indexOf(rowId) == 0; })) {
            return false
        }
        let id = document.getElementById("currentFieldId").value;
        switch (definition.controlType) {
            case "EditorText":
                id += "_editor";
                break;
            case "DateTime":
            case "Date":
                id += "_label";
                break;
        }
        return self._controlIdEndsWith(definition.controlId, "_" + id);
    });
    for (var i = 0; i < definitions.length; i++) {
        var definition = definitions[i];
        var controlId = definition.controlId;
        var setAdditionalElements = null;
        switch (definition.controlType) {
            case "EditorText":
                controlId = controlId.substring(0, controlId.length - "_editor".length);
                break;
            case "DateTime":
            case "Date":
                controlId = controlId.substring(0, controlId.length - "_label".length) + "_calendar";
                setAdditionalElements = function () {
                    setDateField(controlId, updatedValue);
                    return false;
                }
                break;
            case "Link":
                setAdditionalElements = function () {
                    document.getElementById(controlId.substring("Link_".length)).value = updatedValue;
                    return true;
                }
                break;
            case "MultiSelectList":
                setAdditionalElements = function () {
                    var selector = document.getElementById(controlId);
                    for (var i = 0; i < selector.options.length; i++) {
                        selector.options[i].selected = updatedValue.indexOf(selector.options[i].value) != -1;
                    }
                    if (selector.dwSelector) {
                        selector.dwSelector.select(updatedValue);
                    }
                    return false;
                }
                break;
        }
        var fieldControl = document.getElementById(controlId);
        var fieldContainder = fieldControl.closest(".field-container");
        if (fieldContainder.classList.contains("master-has-variants")) {
            continue;
        }
        if (setAdditionalElements != null) {
            if (!setAdditionalElements()) {
                continue;
            }
        }
        fieldControl.value = updatedValue;
    }

    document.getElementById("FocusedFieldId").value = "";
    dialog.hide('SetValueDialog');
};

function setDateField(controlId, updatedValue) {
    var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
    if (Dynamicweb.PIM.BulkEdit.prototype._controlIdEndsWith(controlId, "_calendar")) {
        controlId = controlId.substring(0, controlId.length - "_calendar".length)
    }
    var val = updatedValue ? new Date(updatedValue) : null;
    datepicker.SetDate(controlId, val);
    if (val) {
        datepicker.UpdateCalendarDate(val, controlId);
    }
}

function sortAsc() {
    sortRows(1);
    hideByQuerySelector(".column-header-adornment.sorting-adornment");
    document.getElementById(ContextMenu.callingID + "_ASC").classList.remove("hidden");
}

function sortDesc() {
    sortRows(-1);
    hideByQuerySelector(".column-header-adornment.sorting-adornment");
    document.getElementById(ContextMenu.callingID + "_DESC").classList.remove("hidden");
}

function hideByQuerySelector(querySelector) {
    var elementsToHide = document.querySelectorAll(querySelector);
    for (i = 0; i < elementsToHide.length; ++i) {
        elementsToHide[i].classList.add("hidden");
    }
}

function sortRows(direction) {
    var fieldType = ContextMenu.callingItemID;
    var fieldId = ContextMenu.callingID;
    var tableBody = document.querySelector('#productsContainer>tbody');
    var itemsArr = getRows();
    itemsArr.sort(function (a, b) {
        var valA = getRowValue(a, fieldId);
        var valB = getRowValue(b, fieldId);
        switch (fieldType) {
            case "Integer":
                valA = parseInt(valA);
                valB = parseInt(valB);
                break;
            case "Double":
                valA = parseFloat(valA);
                valB = parseFloat(valB);
                break;
            case "Date":
            case "DateTime":
                valA = Date.parse(valA);
                valB = Date.parse(valB);
                break;
        }
        return valA == valB ? 0 : direction * (valA > valB ? 1 : -1);
    });

    for (i = 0; i < itemsArr.length; ++i) {
        tableBody.appendChild(itemsArr[i]);
    }
}

function getRows(onlyVisible) {
    var list = document.getElementById('productsContainer');
    var rowSelector = ".row:not(.header-row)"
    if (!!onlyVisible) {
        rowSelector += ":not(.hidden)"
    }
    var rowItems = list.querySelectorAll(rowSelector);
    var rows = [];
    for (var i = 0; i < rowItems.length; i++) {
        rows.push(rowItems[i]);
    }
    return rows;
}

function getRowValue(row, controlId) {
    var fieldType = ContextMenu.callingItemID;
    var controlSelector = controlId;
    switch (fieldType) {
        case "Date":
        case "DateTime":
            controlSelector += "_calendar"
            break;
    }
    if (fieldType == "Select") {
        var selector = row.querySelector("[id$='" + controlSelector + "']");
        return selector.options[selector.selectedIndex].text;
    }
    return row.querySelector("[id$='" + controlSelector + "']").value;
}

function showReplaceDialog() {
    document.getElementById("SearchValue").value = '';
    document.getElementById("ReplacementValue").value = '';
    dialog.show('ReplaceDialog');
}

function replaceValues() {
    var fieldId = ContextMenu.callingID;
    var searchValueElement = document.getElementById("SearchValue");
    var searchValue = searchValueElement.value;
    if (!searchValue) {
        dwGlobal.showControlErrors(searchValueElement, "Cannot be empty")
    } else {
        var replacement = document.getElementById("ReplacementValue").value;   
        var gridRows = getRows();
        for (i = 0; i < gridRows.length; ++i) {
            var gridRow = gridRows[i];
            var rowInput = gridRow.querySelector("[id$='" + fieldId + "']");
            rowInput.value = rowInput.value.replace(new RegExp(searchValue, 'g'), replacement);
        }
        document.getElementById("FocusedFieldId").value = "";
        dialog.hide('ReplaceDialog');
    }
}

function showFilteringDialog() {
    document.getElementById("FilterText").value = '';
    dialog.show('FilterDialog');
}

function listHasFilter() {
    return document.querySelector(".column-header-adornment.filtering-adornment:not(.hidden)") != null;
}

function filterRows() {
    var fieldId = ContextMenu.callingID;
    hideByQuerySelector(".column-header-adornment.filtering-adornment");
    var textFilter = document.getElementById("FilterText").value;    
    document.getElementById(ContextMenu.callingID + "_Filter").classList.remove("hidden");    

    var gridRows = getRows();
    for (i = 0; i < gridRows.length; ++i) {
        var gridRow = gridRows[i];
        var rowValue = getRowValue(gridRow, fieldId);
        if ((!!textFilter && rowValue.indexOf(textFilter) >= 0) || (!textFilter && !rowValue)) {
            gridRow.classList.remove("hidden");
        } else {
            gridRow.classList.add("hidden");
        }
    }

    dialog.hide('FilterDialog');
}

function onGridContextMenuView() {    
    var view = '';
    var fieldType = ContextMenu.callingItemID;
    if (!document.getElementById(ContextMenu.callingID + "_Filter").classList.contains("hidden")) {
        view = 'filtering';
    }
    if (!document.getElementById(ContextMenu.callingID + "_ASC").classList.contains("hidden") || !document.getElementById(ContextMenu.callingID + "_DESC").classList.contains("hidden")) {
        view = view ? 'filteringAndSorting' : 'sorting';
    }
    if (fieldType == "Text" || fieldType == "EditorText" || fieldType ==  "TextLong") {
        view += 'Replace';
    }
    return view || 'common';
}

function removeFiltering() {
    hideByQuerySelector(".column-header-adornment.filtering-adornment");
    var gridRows = getRows();
    for (i = 0; i < gridRows.length; ++i) {
        var gridRow = gridRows[i];
        gridRow.classList.remove("hidden");
    }
}

function removeSorting() {
    var tableBody = document.querySelector('#productsContainer>tbody');
    hideByQuerySelector(".column-header-adornment.sorting-adornment");
    var itemsArr = getRows();
    itemsArr.sort(function (a, b) {
        return a.getAttribute("data-original-sorting") - b.getAttribute("data-original-sorting");
    });

    for (i = 0; i < itemsArr.length; ++i) {
        tableBody.appendChild(itemsArr[i]);
    }
}

function setButtonsTooltip(menuId, disabledButtonTooltip) {
    var menu = document.getElementById(menuId);
    menu.querySelectorAll("a.button-disabled").forEach(function (button) {
        button.title = disabledButtonTooltip;
    });
}