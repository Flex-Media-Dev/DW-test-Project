var problemRows = new Array;
var _settingsID = null;

function handleRowChange(settingsID) {
    savePreviousSettings(_settingsID);
    loadNextSettings(settingsID);

    _settingsID = settingsID;
}

function savePreviousSettings(settingsID) {
    if (settingsID == null || $(settingsID) == null)
        return;

    var settings = eval('(' + $F(settingsID) + ')');

    settings.OptionsDataType = $(optionsDataTypeID).options[$(optionsDataTypeID).selectedIndex].value;
    settings.OptionsKeys = [];
    settings.OptionsValues = [];
    var optionRows = dwGrid_SystemFieldOptions.rows.getAll();
    for (var i = 0; i < optionRows.length; i++) {
        settings.OptionsKeys[i] = optionRows[i].findControl("SystemFieldOptionKey").value;
        settings.OptionsValues[i] = optionRows[i].findControl("SystemFieldOptionValue").value;
    }

    $(settingsID).value = Object.toJSON(settings);
}

function loadNextSettings(settingsID) {
    var settings = eval('(' + $F(settingsID) + ')');

    // Set data type
    for (var i = 0; i < $(optionsDataTypeID).options.length; i++) {
        if ($(optionsDataTypeID).options[i].value == settings.OptionsDataType) {
            $(optionsDataTypeID).selectedIndex = i;
            break;
        }
    }

    // Set data type disabled if necessary
    $("OptionsDataType").disabled = settings.isEdit;

    // Add options to grid
    dwGrid_SystemFieldOptions.deleteRows(dwGrid_SystemFieldOptions.rows.getAll());

    for (var i = 0; i < settings.OptionsKeys.length; i++) {
        optionRowValues[i] = [settings.OptionsKeys[i], settings.OptionsValues[i]];
    }
    if (settings.OptionsKeys.length > 0)
        dwGrid_SystemFieldOptions.addRow();
}

function handleTypeChange(obj) {
    if (eval('(' + $F(_settingsID) + ')').OptionsKeys.length > 0) {
        $("options").show();
        return;
    }

    if (obj && obj.options) {
        for (var i = 0; i < typesWithOptions.length; i++) {
            if (typesWithOptions[i] == obj.options[obj.selectedIndex].value) {
                $("options").show();
                return;
            }
        }
    }
    $("options").hide();
}

function handleRowSelected(obj, gridID) {
    var grid = eval('dwGrid_' + gridID);
    var row = grid.findContainingRow(obj)
    if (row) {
        grid.rows.setSelected(false);
        row.setSelected(true);

        var types = row.findControl("SystemFieldTypeDrop")
        try {
            handleTypeChange(types);
        } catch (e) { }
    }

    var rows = grid.rows.getAll();
    for (var i = 0; i < rows.length; i++) {
        var currentRow = rows[i];
        if (currentRow.isSelected) {
            currentRow.findControl('buttons').style.visibility = "visible";
        } else {
            currentRow.findControl('buttons').style.visibility = "hidden";
        }
    }
}

function deleteSelectedRowFields(obj) {
    var row = dwGrid_SystemFieldsList.findContainingRow(obj);
    dwGrid_SystemFieldsList.deleteRows([row]);
    $("options").hide();
}

function deleteSelectedRowOptions() {
    var row = dwGrid_SystemFieldOptions.rows.getSelected();
    dwGrid_SystemFieldOptions.deleteRows(row);
}

function save() {
    savePreviousSettings(_settingsID);
    if (ValidateSystemNames()) {
        alert(txtSysNotUnique);
        $(problemRows[0]).focus();
    } else {
        $("DoSave").value = "True"
        SubmitForm();
    }
}

function cancel() {
    $("DoSave").value = "False"
    SubmitForm();
}

function SubmitForm() {
    $("form1").submit();
}

function help() {
    window.open('http://manual.net.dynamicweb.dk/Default.aspx?ID=1&m=keywordfinder&keyword=administration.managementcenter.systemFields&LanguageID=' + helpLang, 'dw_help_window', 'location=no,directories=no,menubar=no,toolbar=yes,top=0,width=1024,height=' + (screen.availHeight - 100) + ',resizable=yes');
}

function ValidateSystemNames() {
    var rows = dwGrid_SystemFieldsList.rows.getAll();
    var validatedRows = new Array;
    var emptyRows = new Array;
    var hasTrouble = false;

    problemRows.length = 0;
    for (var i = 0; i < rows.length; i++) {
        var txtSysName = rows[i].findControl("SystemFieldSystemNameText");
        var hiddenSysName = rows[i].findControl("SystemFieldSystemName");
        if (hiddenSysName.value.length == 0) {
            var fLbl = rows[i].findControl("SystemFieldName");
            if (txtSysName.value.length == 0) {
                if (fLbl.value.length == 0) {
                    emptyRows.push(rows[i]);
                } else {
                    hasTrouble = true;
                    problemRows.push(txtSysName.id);
                }
            } else if (validatedRows.indexOf(txtSysName.value.toLowerCase()) != -1) {
                hasTrouble = true;
                problemRows.push(txtSysName.id);
            } else if (MakeSystemName(txtSysName.value) == "") {
                hasTrouble = true;
                problemRows.push(txtSysName.id);
                //                    } else if (MakeSystemName(fLbl.value) != "") {
                //                        txtSysName.value = MakeSystemName(fLbl.value);
                //                        validatedRows.push(txtSysName.value);
            } else {
                validatedRows.push(txtSysName.value.toLowerCase());
            }
        } else {
            validatedRows.push(txtSysName.value.toLowerCase());
        }
    }
    dwGrid_SystemFieldsList.deleteRows(emptyRows); //Remove all empty rows from the Grid.
    return hasTrouble;
}

function ValidateSystemName(obj) {
    var sysName = MakeSystemName(obj.value);
    if (sysName == "") {
        var row = dwGrid_SystemFieldsList.findContainingRow(obj);
        var nameBox = row.findControl("SystemFieldName");
        obj.value = MakeSystemName(nameBox.value);
    } else {
        obj.value = sysName
    }
}

function MakeSystemName(label) {
    //Reuse the system name identifier control function of EditForm
    var result;
    var url = "/Admin/Module/DataManagement/Form/EditForm.aspx?AJAXCMD=VALIDATE_SYS_NAME&tableName=" + $("TableName").value + "&label=" + label + "&timestamp=" + (new Date()).getTime();
    new Ajax.Request(url, {
        asynchronous: false,
        method: 'get',
        onSuccess: function (request) {
            result = request.responseText;
        }
    });

    return result;
}

function HandleKeyDown(e, obj, gridID) {
    // Check if [TAB] or [ENTER] was pressed
    var grid = eval("dwGrid_" + gridID);
    if (!e.shiftKey && (e.keyCode == 9 || e.keyCode == 13)) {
        var allRows = grid.rows.getAll();
        var lastRow = allRows[allRows.length - 1];
        var thisRow = grid.findContainingRow(obj);

        var isLastRow = (thisRow.ID == lastRow.ID);

        if (isLastRow) {
            grid.addRow();
        }
    }
}
