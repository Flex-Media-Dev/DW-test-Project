function dataLoaded(data, dataOptions) {
    dataOptions = dataOptions || {};
    //get data from serverver into named variables
    var selectedSourceTable = data[0];
    var selectedDestinationTable = data[1];
    var conditionals = data[2];
    var sourceTableColumns = data[3];
    var destinationTableColumns = data[4];
    var columnMappings = data[5];
    var divName = data[6];
    var fnScriptingValuesUpdate = dataOptions.scriptingValuesUpdate;
    var fnStoreScriptingData = dataOptions.storeScriptingData;
    var mappingName = "mapping" + data[7];
    var mappingId = data[7];
    var schemaIsActive = data[8];
    destinationTableKeyColumns[mappingId] = data[9];
    tableScriptClasses[mappingId] = data[10];
    var options = data[11];   
    optionsData[mappingId] = options;

    //Find the div for current talble mapping
    var currentDiv = document.getElementById(divName + "div");
    currentDiv.innerHTML = "";
    var currentMappingDiv = document.getElementById("columnMappings" + divName);
    currentMappingDiv.innerHTML = "";
    if(document.getElementById("activeMapping").value != divName)
        currentMappingDiv.style.display = "none";
    else
        currentDiv.style.background = "#f5f5f5";

    var sourceSelector = 'sourceTable' + mappingName;
    var destinationSelector = 'destinationTable' + mappingName;
    //add hidden field, that tells if the mapping has been deleted.

    currentDiv.appendChild(createInput("hidden", mappingName + "deleted", mappingName + "deleted", "false", ""));


    //add source and destination table dropdowns
    var cd = new Array();
    cd[0] = conditionals;
    cd[1] = sourceTableColumns;
    conditionalsData[mappingId] = cd;    
    var sourceSelect = CreateTablePicker(sourceTables, selectedSourceTable, 'sourceTable' + mappingName, "doCallback('" + divName + "', { selectedSourceTable: document.getElementById('" + sourceSelector + "').value, selectedDestinationTable: document.getElementById('" + destinationSelector + "').value }, dataLoaded);", "sourceTablePicker std");
    var sourceTableSelectDiv = document.createElement("div");

    sourceTableSelectDiv.className = "SourceTableSelectorDiv";
    sourceTableSelectDiv.appendChild(sourceSelect);
    currentDiv.appendChild(sourceTableSelectDiv);
    var destinationSelect = CreateTablePicker(destinationTables, selectedDestinationTable, 'destinationTable' + mappingName, "doCallback('" + divName + "', { selectedSourceTable: document.getElementById('" + sourceSelector + "').value, selectedDestinationTable: document.getElementById('" + destinationSelector + "').value }, dataLoaded)", "destinationTablePicker std");
    var destinationTableSelectDiv = document.createElement("div");
    destinationTableSelectDiv.className = "DestinationTableSelectorDiv";
    destinationTableSelectDiv.appendChild(destinationSelect);
    currentDiv.appendChild(destinationTableSelectDiv);
    //add "add" and "delete" buttons
    currentDiv.appendChild(createIconButton('', '', 'border-left', "setupEditConditionalDialog('" + mappingId + "');", 'fa fa-pencil', 'Edit conditionals'));
    if (tableScriptClasses[mappingId].length > 0) {
        var selected = false;
        for (var i = 0; i < tableScriptClasses[mappingId].length; i++) {
            if (!selected) {
                selected = tableScriptClasses[mappingId][i][2];
            }
        }

        if (selected) {
            currentDiv.appendChild(createIconButton('', '', '', "showTableScriptingDialog('" + mappingId + "');", 'fa fa-plus-square', 'Edit Scripting'));
        } else {
            currentDiv.appendChild(createIconButton('', '', '', "showTableScriptingDialog('" + mappingId + "');", 'fa fa-pencil-square', 'Add Scripting'));
        }
    }

    currentDiv.appendChild(createIconButton('', '', '', "showKeysDialog('" + mappingId + "');", 'fa fa-key', 'Set keys'));
    var addSourceButton = createAddSourceButton(mappingId);
    if(schemaIsActive == "False") {
        addSourceButton.classList.add("disabled")
        addSourceButton.onclick = function() { return false; };
    }
    currentDiv.appendChild(addSourceButton);

    if (options[0]) {
        currentDiv.appendChild(createIconButton('', '', '', "showOptionsDialog('" + mappingId + "', '" + selectedDestinationTable + "');", 'fa fa-cog', 'Set options'));
    }

    currentDiv.appendChild(CreateDeleteButton(divName + "div", mappingName));
    var clearfix = document.createElement("div");
    clearfix.className = "clearfix";
    currentDiv.appendChild(clearfix);
    var allMappingsActive = true;
    var sourceColumnSelect = createColumnSelector(sourceTableColumns);
    var destinationColumnSelect = createColumnSelector(destinationTableColumns);
    var disablePKRow = !!dataOptions.importKey;
    currentDiv.appendChild(createInput("hidden", "ImportKeySelector", "ImportKeySelector", dataOptions.importKey || ""));
    var createMappingRowFn = function (rowId, isNewRow) {
        var rowColumnMapping = null;
        if (isNewRow) {
            rowColumnMapping = ["", "", "true", rowId, "None", "", "false", false];
        } else {
            rowColumnMapping = columnMappings[rowId];
        }
        var isPrimaryKey = rowColumnMapping[7];
        var isPrimaryKeyRow = disablePKRow && isPrimaryKey;
        CreateColumnMappingPicker(sourceTableColumns, destinationTableColumns, rowColumnMapping, mappingName, mappingId, sourceColumnSelect.cloneNode(true), destinationColumnSelect.cloneNode(true), currentMappingDiv, divName, isPrimaryKeyRow, fnScriptingValuesUpdate, fnStoreScriptingData);
        var idSeed = mappingName + "columnMapping" + rowColumnMapping[3];
        if (rowColumnMapping[2] == "false") {
            allMappingsActive = false;
        }
        else
            $(idSeed + "Active").checked = true;
        document.getElementById(idSeed + "Active").onclick = function () { setCheckAll(); };

    };
    var maxRowId = 0;
    for (var i = 0; i < columnMappings.length; i++) {
        var row = columnMappings[i];
        var rowId = parseInt(row[3]);
        if (rowId > maxRowId) {
            maxRowId = rowId;
        }
        createMappingRowFn(i);
    }

    setCheckAll();

    var rowsCount = maxRowId;
    var rowsCountEl = createInput("hidden", "RowsCount", "RowsCount", rowsCount);
    currentDiv.appendChild(rowsCountEl);    
    return {
        addNewMappingRow: function () {
            rowsCount++;
            rowsCountEl.value = rowsCount
            createMappingRowFn(rowsCount, true);
        }
    };
}
function CreateColumnMappingPicker(sourceTableColumns, destinationTableColumns, columnMapping, mappingName, mappingId, sourceColumn, destinationColumn, currentDiv, classForCheckboxes, isPrimaryKeyRow, fnScriptingValuesUpdate, fnStoreScriptingData) {
    var idSeed = mappingName + "columnMapping" + columnMapping[3];
    var isActive = columnMapping[2];

    var div = document.createElement("div");

    var sourceColumnDiv = document.createElement("div");
    sourceColumnDiv.className = "selectedSourceColumnDiv";
    sourceColumnDiv.appendChild(sourceColumn);
    var destinationColumnDiv = document.createElement("div");
    destinationColumnDiv.className = "selectedDestinationColumnDiv";
    destinationColumnDiv.appendChild(destinationColumn);
    div.setAttribute("id", idSeed + "div");
    div.className = "columnMappingDiv";
    var input = document.createElement('input');
    input.setAttribute("type", "checkbox");
    input.name = idSeed + "Active";
    input.classList.add("checkbox");
    input.classList.add("ColumnMappingSelectedCheckbox");
    input.classList.add("ColumnMappingSelectedCheckbox" + classForCheckboxes);
    input.value = "on";
    input.id = idSeed + "Active";
    if (isPrimaryKeyRow) {
        input.setAttribute("disabled", "disabled");
        div.appendChild(createInput("hidden", idSeed + "PK", idSeed + "PK", "true"));
    }
    input.onclick = "setCheckAll()";
    div.appendChild(input);
    if(isActive == "true")
        input.checked = 'true';
    var label = document.createElement('label');
    label.setAttribute("for", idSeed + "Active");
    div.appendChild(label);
    div.appendChild(sourceColumnDiv);
    div.appendChild(destinationColumnDiv);

    var scriptButton = document.createElement("span");
    scriptButton.classList.add("input-group-addon");
    scriptButton.classList.add("border-left");
    scriptButton.classList.add("addScripting" + mappingId);
    if (isPrimaryKeyRow) {
        scriptButton.classList.add("disabled");
    }
    scriptButton.id = "addScripting" + mappingId;
    var columnMappingId = columnMapping[3];
    var scriptingValues = {
        mappingId: mappingId,
        columnMappingId: columnMappingId,
        scriptingType: columnMapping[4],
        scriptingValue: columnMapping[5],
        scriptingValueForInsert: columnMapping[6]
    };
    scriptButton.onclick = function () {
        if (fnScriptingValuesUpdate) {
            fnScriptingValuesUpdate(scriptingValues);
        }
        showScriptingDialog(scriptingValues.mappingId, scriptingValues.columnMappingId, scriptingValues.scriptingType, scriptingValues.scriptingValue, scriptingValues.scriptingValueForInsert);
        return false;
    };
    
    var scriptButtonIcon = document.createElement('i');
    scriptButton.appendChild(scriptButtonIcon);
    div.appendChild(createInput("hidden", idSeed + "deleted", idSeed + "deleted", "false", ""));
    div.appendChild(scriptButton);
    var deleteButton = createIconButton("", "", isPrimaryKeyRow ? "disabled" : "", "columnMappingDelete('" + idSeed + "div', '" + idSeed + "deleted');", 'fa fa-remove color-danger', 'Delete column mapping');
    div.appendChild(deleteButton);
    var clearfix = document.createElement("div");
    clearfix.className = "clearfix";
    div.appendChild(clearfix);
    currentDiv.appendChild(div);
    if (columnMapping[4] == 'Constant') {
        columnMapping[0] = "None";//Set source column selector to None when Constant condition is used
    }

    updateColumnSelector(sourceColumn, columnMapping[0], 'selectedSourceColumn', idSeed);
    updateColumnSelector(destinationColumn, columnMapping[1], 'selectedDestinationColumn', idSeed);
    updateScriptingState(mappingId, columnMappingId, columnMapping[4]);
    if (isPrimaryKeyRow) {
        sourceColumn.setAttribute("disabled", "disabled");
        setBackgroundColorForRowWithCondition(sourceColumn, destinationColumn);
    }
    if (columnMapping[4] == 'Constant') {
        if (fnStoreScriptingData) {
            fnStoreScriptingData(scriptingValues.mappingId, scriptingValues.columnMappingId, div, scriptingValues.scriptingValue, scriptingValues.scriptingType, scriptingValues.scriptingValueForInsert); // Set scripting data to form
        }
    }
    return div;
}

function updateScriptingState(mappingId, columnMappingId, scriptType) {
    var divEl = document.getElementById(`mapping${mappingId}columnMapping${columnMappingId}div`);
    var scriptButtonEl = divEl.querySelector(`.addScripting${mappingId}`);
    var scriptButtonIconEl = scriptButtonEl.querySelector('i');
    var sourceColumnEl = divEl.querySelector('.selectedSourceColumn');
    var destinationColumnEl = divEl.querySelector('.selectedDestinationColumn');
    scriptType = scriptType.toLowerCase();
    if (scriptType === 'none') {
        scriptButtonEl.setAttribute("title", "Add Scripting");
        scriptButtonIconEl.setAttribute('class', 'fa fa-code');
        setBackgroundColorForRowWithCondition(sourceColumnEl, destinationColumnEl, true);
    } else {
        scriptButtonEl.setAttribute("title", "Edit Scripting");
        scriptButtonIconEl.setAttribute('class', 'fa fa-pencil');
        setBackgroundColorForRowWithCondition(sourceColumnEl, destinationColumnEl, false);
    }
    if (scriptType == 'constant') {
        sourceColumnEl.selectedIndex = 0;
        sourceColumnEl.setAttribute("disabled", "true");
    } else {
        sourceColumnEl.removeAttribute("disabled");
    }
}

function createColumnSelector(TableColumns) {
    var sourceColumn = document.createElement("select");
    sourceColumn.className = "std";
    sourceColumn.options[0] = new Option("None", "-1");

    for (j = 0; j < TableColumns.length; j++) {
        var tableColumn = TableColumns[j];
        var option = null;
        if (typeof tableColumn === 'object' && tableColumn.label && tableColumn.value) {
            option = new Option(tableColumn.label, tableColumn.value);
        } else {
            option = new Option(tableColumn, tableColumn);
        }
        sourceColumn.options[sourceColumn.options.length] = option;
    }
    return sourceColumn
}

function updateColumnSelector(sourceColumnSelector, selectedColumn, classname, idSeed) {
    sourceColumnSelector.className = classname + " std";
    sourceColumnSelector.id = idSeed + classname;
    sourceColumnSelector.setAttribute('name', idSeed + classname);
    for(var k = 0; k < sourceColumnSelector.options.length; k++) {

        if (sourceColumnSelector.options[k].value.toLowerCase() == selectedColumn.toLowerCase()) {
            sourceColumnSelector.selectedIndex = k;
            sourceColumnSelector.options[k].setAttribute("selected", "true");
            k = sourceColumnSelector.options.length;
        }
    }
}

function setupEditConditionalDialog(mappingId) {
    let list = document.getElementById('editConditionalsDiv');
    list.innerHTML = "";
    $('currentMapping').value = mappingId;
    let conditionalsColumns = conditionalsData[mappingId][1];
    let conditionals = conditionalsData[mappingId][0];
    for (let i = 0; i < conditionals.length; i++) {
        let rowId = conditionals[i][3];
        let isEdit = true;
        let conditionColumn = conditionals[i][1];
        let conditionOperator = conditionals[i][2];
        let conditionValue = conditionals[i][0];
        insertConditionalRow(list, conditionalsColumns, isEdit, rowId, conditionColumn, conditionOperator, conditionValue)
    }
    stopConfirmation();
    dialog.show('editConditionals');
}

function insertConditionalRow(list, conditionalsColumns, isEdit, rowId, conditionColumnVal, conditionOperatorVal, conditionValue) {
    let conditionDiv = document.createElement("div");
    conditionDiv.setAttribute("id", "conditionDiv" + rowId);
    conditionDiv.setAttribute("style", "margin-bottom:10px;");
    conditionDiv.className = "conditional-row clearfix";
    if (!isEdit) {
        conditionDiv.className += " new-row"
    }
    let conditionData = document.createElement("div");
    conditionData.className = "conditional-data pull-left"
    conditionDiv.appendChild(conditionData);

    let conditionColumn = document.createElement("select");
    conditionColumn.setAttribute("name", "conditionColumn" + rowId);
    conditionColumn.className = "std condition-column";
    conditionColumn.setAttribute("style", "width:200px;margin-right:3px;");

    for (let j = 0; j < conditionalsColumns.length; j++) {
        let column = conditionalsColumns[j];
        if (column == conditionColumnVal) {
            conditionColumn.options[conditionColumn.options.length] = new Option(column, column, false, true);
        } else {
            conditionColumn.options[conditionColumn.options.length] = new Option(column, column, false);
        }
    }
    conditionData.appendChild(conditionColumn);

    var conditionOperator = document.createElement("select");
    conditionOperator.setAttribute("name", "conditionOperator" + rowId);
    conditionOperator.className = "std condition-operator";
    conditionOperator.setAttribute("style", "width:100px;margin-right:3px;");
    conditionOperator.options[conditionOperator.options.length] = new Option("=", "EqualTo", false);
    conditionOperator.options[conditionOperator.options.length] = new Option("<", "LessThan", false);
    conditionOperator.options[conditionOperator.options.length] = new Option(">", "GreaterThan", false);
    conditionOperator.options[conditionOperator.options.length] = new Option("<>", "DifferentFrom", false);
    conditionOperator.options[conditionOperator.options.length] = new Option("Contains", "Contains", false);
    conditionOperator.options[conditionOperator.options.length] = new Option("In", "In", false);
    conditionOperator.value = conditionOperatorVal || "EqualTo";
    conditionData.appendChild(conditionOperator);

    conditionData.appendChild(createInput("text", "condition" + rowId, "", conditionValue || "", "", "condition", "", "std condition-value", "width:270px;margin-right:3px;"));
    if (isEdit) {
        conditionDiv.appendChild(createIconButton("", "Delete", 'border-left', "$('conditionDiv" + rowId + "').hide(); $('conditionDeleted" + rowId + "').value='true';", 'fa fa-remove color-danger', 'Delete'));
        conditionDiv.appendChild(createInput("hidden", "conditionDeleted" + rowId, "conditionDeleted" + rowId, "", ""));
    }
    else {
        let delRowFn = function () {
            conditionDiv.parentNode.removeChild(conditionDiv);
        };
        conditionDiv.appendChild(createIconButton('', 'Delete', 'border-left', delRowFn, 'fa fa-remove color-danger', 'Delete'));
    }
    list.appendChild(conditionDiv);
}

function newConditionRow() {
    let mappingId = document.getElementById('currentMapping').value;
    let list = document.getElementById('editConditionalsDiv');
    let rowId = "_new_" + (list.querySelectorAll(".conditional-row").length + 1).toString();
    let conditionalsColumns = conditionalsData[mappingId][1];
    insertConditionalRow(list, conditionalsColumns, false, rowId);
    return false;
}

function collectNewConditionsRows() {
    let storageEl = document.getElementById('new-conditions');
    let list = document.getElementById('editConditionalsDiv');
    let newRows = list.querySelectorAll('.conditional-row.new-row');
    let items = [];
    for (let i = 0; i < newRows.length; i++) {
        let row = newRows[i];
        items.push({
            Column: row.querySelector('.condition-column').value,
            Operator: row.querySelector('.condition-operator').value,
            Value: row.querySelector('.condition-value').value,
        });
    };
    storageEl.value = JSON.stringify(items);
}

function showKeysDialog(mappingId) {
    $('currentMapping').value = mappingId;
    var keyColumns = destinationTableKeyColumns[mappingId];
    var leng = keyColumns.length;
    $('selectKeyColumns').innerHTML = "";

    for (var i = 0; i < leng; i++) {
        var column = keyColumns[i]
        var input = document.createElement('input');
        input.setAttribute("type", "checkbox");
        input.value = "True";
        input.name = column[0] + "IsKey";
        input.className = 'checkbox';
        if (column[1]=="True")
            input.checked = 'true';
        input.id = column[0] + "IsKey";
        $('selectKeyColumns').appendChild(input);
        var label = document.createElement('label');
        label.innerHTML = column[0];
        label.className = 'm-b-5';
        label.setAttribute("for", column[0] + "IsKey");
        $('selectKeyColumns').appendChild(label);
        $('selectKeyColumns').appendChild(document.createElement("br"));
    }
    stopConfirmation();
    dialog.show('selectKeys');
}

var optionsData = new Array();

function showOptionsDialog(mappingId, selectedDestinationTable) {
    $('currentMapping').value = mappingId;

    var showWarning = optionsData[mappingId][1];
    var warningBar = $('InfoBar_OptionsWarningBar');
    if (warningBar != null) {
        if (showWarning) {
            warningBar.show();
        } else {
            warningBar.hide();
        }
    }

    $$('#OptionsProviderTitle input[type=checkbox]').each(function (el) {
        el.checked = false;
    });

    var fieldset = $('OptionsProviderTitle').down();
    if (fieldset != null) {
        var titleEl = fieldset.down('.gbTitle');
        if (titleEl != null) {
            titleEl.innerHTML = selectedDestinationTable;
        }
    }

    var options = optionsData[mappingId][2];    
    for (i = 0; i < options.length; i++) {
        var optionName = options[i][0];
        var optionValue = options[i][1];

        var el = $(optionName);
        if (el != null) {
            el.checked = optionValue == 'true';
        }
    }
        
    stopConfirmation();
    dialog.show('SelectOptions');
}

function CreateTablePicker(tableList, selectedTable, id, callbackFunction, classname) {
    var result = document.createElement("select");
    result.className = classname;
    result.id = id;
    result.setAttribute('name', id);

    result.onchange = function() { eval(callbackFunction) };

    for(i = 0; i < tableList.length; i++) {
        var table = tableList[i];

        if (table.toLowerCase() == selectedTable.toLowerCase()) {
                result.options[result.options.length] = new Option(table, table, false, true);
        }
        else {
            result.options[result.options.length] = new Option(table, table);
        }
    }
    return result;
}

function showScriptingDialog(mappingId, columnMappingId, scriptingType, scriptingValue, scriptingValueForInsert) {
    $('currentMapping').value = mappingId;
    $('currentColumnMapping').value = columnMappingId;
    $('scriptValue').value = scriptingValue;
    scriptingType = scriptingType.toLowerCase();
    if (scriptingType === "none")
        $('scriptType').selectedIndex = 0;
    else if (scriptingType === "append")
        $('scriptType').selectedIndex = 1;
    else if (scriptingType === "prepend")
        $('scriptType').selectedIndex = 2;
    else if (scriptingType === "constant")
        $('scriptType').selectedIndex = 3;
    if ($('checkScriptValueForInsert') != null) {
        $('checkScriptValueForInsert').checked = (scriptingValueForInsert != null && scriptingValueForInsert.toLowerCase() == 'true') ? true : false;
        toggleScriptTypeSelection();
    }    
    stopConfirmation();
    dialog.show('editScripting');
}

function setBackgroundColorForRowWithCondition(sourceColumn, destinationColumn, initialState) {
    if (sourceColumn != null && destinationColumn != null) {
        if (initialState) {
            sourceColumn.setAttribute("style", "");
            destinationColumn.setAttribute("style", "");
        }
        else {
            sourceColumn.setAttribute("style", "background-color:#FFF8DC;");
            destinationColumn.setAttribute("style", "background-color:#FFF8DC;");
        }
    }
}

function columnMappingDelete(divId, deletedHiddenId) {
    $(divId).style.display = "none";
    $(deletedHiddenId).value = "true";
    return false;
}

function tableMappingDelete(divName, mappingName) {
    if(confirm('Are you sure you want to delete selected table mapping?')) {
        $(divName).style.display = "none";
        $(divName).value = "true";
        $(mappingName + "deleted").value = "true";
    }
}

function createAddSourceButton(mappingId) {
    return createIconButton('AddTable' + mappingId, '', '', "addTabletoDestionation('" + mappingId + "');", 'fa fa-sitemap', 'Add source table to destination');
}

function addTabletoDestionation(mappingId) {
    stopConfirmation();
    $("form1").appendChild(createInput("hidden", "mappingToAddtableFromMappingTo", "mappingToAddtableFromMappingTo", mappingId, ""));
    $("action").value = "addTableToDestinationSchema";
    $("form1").submit();
    stopConfirmation();
}

function CreateDeleteButton(divName, mappingName) {
    return createIconButton('', '', '', "tableMappingDelete('" + divName + "','" + mappingName + "');", 'fa fa-remove color-danger', 'Delete table mapping');
}

function doCallback(divId, params, onCompleteFunction, argument) {
    if(typeof (argument) == 'undefined') {
        var arg = { target: divId, onComplete: onCompleteFunction, parameters: params }
    }
    else {
        var arg = { target: divId, onComplete: onCompleteFunction, parameters: params, argument: argument }
    }
    Dynamicweb.Ajax.DataLoader.load(arg);
}

function createIconButton(id, name, className, onClick, iconClass, title) {
    var button = document.createElement('span');    
    if (id) button.setAttribute('id', id);
    if (name) button.setAttribute('name', name);
    button.classList.add("input-group-addon");
    if (className) button.classList.add(className);
    if (onClick) {
        if (Dynamicweb.Utilities.TypeHelper.isFunction(onClick)) {
            button.onclick = onClick;
        } else {
            button.onclick = function () { eval(onClick); return false };
        }
    }
    if (title) button.setAttribute('title', title);

    iconClass = iconClass || 'fa fa-gear';

    var icon = document.createElement('i');
    icon.setAttribute('class', iconClass);

    button.appendChild(icon);

    return button;
}

function createInput(type, name, id, value, onClick, className, style) {
    return createInput(type, name, id, value, onClick, "", "", className, style);
}

function createInput(type, name, id, value, onClick, src, alt, className, style) {
    var input = document.createElement('input');
    input.type = type;
    input.setAttribute('name', name);

    if(id && id != "" && id != undefined)
        input.id = id;
    if(value != "" && value != undefined)
        input.setAttribute('value', value);
    if (className != "" && className != undefined)
        input.setAttribute('class', className);
    if (onClick != "" && onClick != undefined)
        input.onclick = function() { eval(onClick); return false; };
    if (src != "" && src != undefined)
        input.setAttribute('src', src);
    if (style != "" && style != undefined)
        input.setAttribute('style', style);
    if (alt != "" && alt != undefined)
        input.setAttribute('title', alt);
    return input;
}

function save() {
    stopConfirmation();
    $("action").value = 'save';
    $("form1").submit();
    stopConfirmation();
}
function showColumnMappings(divId, mappingId) {

    if(document.getElementById(divId + "div").style.display != "none") {
        hideCurrentColumnMappings();
        document.getElementById(document.getElementById("activeMapping").value + "div").style.background = "white";
        document.getElementById("activeMapping").value = divId;
        document.getElementById("activeMappingID").value = mappingId;
        var newSelection = document.getElementById("columnMappings" + divId);
        newSelection.style.display = "inline";

        document.getElementById(divId + "div").style.background = "#f5f5f5";
        setCheckAll();
    }
    else {
        if(document.getElementById("activeMapping").value == divId)
            hideCurrentColumnMappings();
    }
}

function hideCurrentColumnMappings() {
    var currentSelection = document.getElementById("columnMappings" + document.getElementById("activeMapping").value);
    currentSelection.style.display = "none";
}

function setCheckAll() {
    $('checkAllCheckbox').checked = true;
    $$("input.ColumnMappingSelectedCheckbox" + document.getElementById("activeMapping").value).each(function (checkbox) {
        if (!checkbox.getAttribute("disabled") && checkbox.display != "none" && checkbox.checked == false) {
            $('checkAllCheckbox').checked = false;
        }
    });

    //if all checkboxes for current tablemapping are checked, check checkall, otherwise uncheck it
}

function saveAndClose() {
    stopConfirmation();
    $("action").value = 'saveAndClose';
    $("form1").submit();
    stopConfirmation();
}

function cancel() {
    stopConfirmation();
    $("action").value = 'cancel';
    $("form1").submit();
    stopConfirmation();
}

function addTableMapping() {
    stopConfirmation();
    $("action").value = 'addTableMapping';
    $("form1").submit();
    stopConfirmation();
}

function showAddAdapterDialog(caption, adapterNumber) {    
    stopConfirmation();
    if (caption != null) {
        dialog.setTitle("AddAdapterDialog", caption);
    }
    if (adapterNumber != null) {        
        dialog.show("AddAdapterDialog", "/Admin/Module/IntegrationV2/AddAdapter.aspx?id=" + adapterNumber);
    }
    else {
        dialog.show("AddAdapterDialog", "/Admin/Module/IntegrationV2/AddAdapter.aspx");
    }
}

function submitAdapter() {
    var frame = document.getElementById("AddAdapterDialogFrame");
    var frameDoc = (frame.contentWindow || frame.contentDocument);
    if (frameDoc.document) frameDoc = frameDoc.document;
    if (frame.contentWindow.isValid != null && !frame.contentWindow.isValid()) {
        return false;
    }
    frameDoc.getElementById("form1").submit();
}

function showWait() {
    var o = new overlay('forward');
    o.show();
}
function deleteAdapter(id) {
    stopConfirmation();    
    showWait();
    $("form1").appendChild(createInput("hidden", "adapterId", "adapterId", id, ""));
    $("action").value = 'deleteAdapter';
    $("form1").submit();
    stopConfirmation();
}

function SaveAndRun() {
    removeUnloadEvent();
    $("action").value = 'SaveAndRun';
    $("form1").submit();
}

function hideSourceDialog() {
    dialog.hide('SourceEditDialog');
}

function hideDestinationDialog() {
    dialog.hide('DestinationEditDialog');
}

function hideNotificationSettingsDialog() {
    dialog.hide('NotificationSettingsDialog');
}

var conditionalsData = new Array();
var destinationTableKeyColumns = new Array();
function toggleActiveSelection() {
    if($('checkAllCheckbox').checked == true) {
        $$("input.ColumnMappingSelectedCheckbox" + document.getElementById("activeMapping").value).each(function(checkbox) {
            if(checkbox.display != "none")
                checkbox.checked = true;
        });
    }
    else {
        $$("input.ColumnMappingSelectedCheckbox" + document.getElementById("activeMapping").value).each(function(checkbox) {
            if(checkbox.display != "none")
                checkbox.checked = false;
        });
    }
}

function checkSelectAllIfNeeded() {
    if(this.checked) {
        $(this.parentNode).siblings().each(function(mainCheck) { if(mainCheck.type == "checkbox") mainCheck.checked = true; });
        $(this.parentNode).siblings().each(function(item) {
            $(item).childElements().each(function(child) {
                if(child.type == "checkbox" && child.checked == false)
                    $(child.parentNode).siblings().each(function(mainCheck) { if(mainCheck.type == "checkbox") mainCheck.checked = false; });
            });
        });
    }
    else
        $(this.parentNode).siblings().each(function(mainCheck) { if(mainCheck.type == "checkbox") mainCheck.checked = false; });
}

function activateButtons() {
    TableMappingCount = TableMappingCount - 1;
    if(TableMappingCount == 0) {
        $('addTableMapping').removeClassName('disabled');
    }
}

function tableAddColumnMapping() {
    stopConfirmation();
    var mappingid = document.getElementById("activeMappingID").value;
    $("form1").appendChild(createInput("hidden", "mappingToAddColumnMappingTo", "mappingToAddColumnMappingTo", mappingid, ""));
    $("action").value = "addColumnMapping";
    $("form1").submit();
    stopConfirmation();
}

function tableRemoveColumnMapping() {
    stopConfirmation();
    var mappingid = document.getElementById("activeMappingID").value;
    $("form1").appendChild(createInput("hidden", "mappingToRemoveColumnMappingTo", "mappingToRemoveColumnMappingTo", mappingid, ""));
    $("action").value = "removeColumnMapping";
    $("form1").submit();
    stopConfirmation();
}

function addColumnMapping() {
    stopConfirmation();
    var mappingId = document.getElementById("activeMappingID").value;
    $('currentMapping').value = mappingId;
    dialog.show('addColumnDialog');
}

function showSourceDestinationSettingsDialog(dialogId, url) {
    var frame = document.getElementById(dialogId + "Frame");
    if (frame && frame.src) {
        dialog.show(dialogId);
    } else {
        dialog.show(dialogId, url);
    }
}

function showErrorsDialog() {
    stopConfirmation();
    dialog.show('showErrorsDlg');
}

var tableScriptClasses = new Array();
function showTableScriptingDialog(mappingId) {
    $('currentMapping').value = mappingId;
    $('editTableScriptingDiv').innerHTML = "";

    var select = document.createElement("select");
    select.className = "std";
    select.id = "tableScripting" + mappingId;
    select.setAttribute('name', "tableScripting" +mappingId);
    select.options[0] = new Option("None", "none");

    for (var i = 0; i < tableScriptClasses[mappingId].length; i++) {
        if (tableScriptClasses[mappingId][i][2] == true) {
            select.options[select.options.length] = new Option(tableScriptClasses[mappingId][i][1], tableScriptClasses[mappingId][i][0], false, true);
        } else {
            select.options[select.options.length] = new Option(tableScriptClasses[mappingId][i][1], tableScriptClasses[mappingId][i][0], false);
        }
    }

    $('editTableScriptingDiv').appendChild(select);
    stopConfirmation();
    dialog.show('editTableScripting');
}


var queue = new Dynamicweb.Utilities.RequestQueue();

function beginLoadData(controlID, onComplete) {
    Dynamicweb.Ajax.DataLoader.load({
        target: controlID,
        argument: '',
        onComplete: function(data) {
            dataLoaded(data);
            onComplete(data);
        }
    });
}

function addToQueue(id) {
    queue.add(window, beginLoadData, [id, function() { queue.next(); } ]);
}

$(document).observe("dom:loaded", function() {
    queue.executeAll();
});

var askConfirmation = false;
function stopConfirmation() {
    askConfirmation = false;
}

function enableConfirmation(){
    askConfirmation = true;
}

window.onbeforeunload = function() {
    if (askConfirmation) {
        return "This page is asking you to confirm that you want to leave - data you have entered may not be saved.";
    }
};

function removeUnloadEvent() {
    window.onbeforeunload = null;
}

function toggleScriptTypeSelection() {
    var scriptType = $('scriptType');
    if (scriptType != null && $('checkScriptValueForInsertDiv') != null) {
        var selectedValue = scriptType.options[scriptType.selectedIndex].value;
        if (selectedValue != null && selectedValue.toLowerCase() == 'constant') {
            $('checkScriptValueForInsertDiv').show();
        } else {
            $('checkScriptValueForInsertDiv').hide();
        }
    }    
}
