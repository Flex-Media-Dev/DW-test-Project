var _srcId = null;
var _txtSysName = null;
var formName = null;
var currentConn = null;
var currentTable = null;
var nextRowType = null;
var doRefresh = false;
var problemRows = new Array;
var isFirstTime = true;

function FieldSettingsPosition() {
    var bodyHeight = document.body.clientHeight;
    var RibbonHeight = $("Ribbon").offsetHeight;
    var FieldSettingsHeight = $("FieldSettings").offsetHeight;
    var FieldsListHeight = bodyHeight - RibbonHeight - FieldSettingsHeight;
    
    $("FieldsList").style.height = FieldsListHeight + 'px';
}

function save() {
    if (CommitForm()) {
        var params = isView ? "VIEW" : "MANUAL"
        document.getElementById('Form1').action = "EditForm.aspx?ID=" + formId + "&CMD=SAVE_FORM&OnSave=Nothing&PARAMS=" + params;
        document.getElementById('Form1').submit();
    }
}

function saveAndClose() {
    if (CommitForm()) {
        var params = isView ? "VIEW" : "MANUAL"
        document.getElementById('Form1').action = "EditForm.aspx?ID=" + formId + "&CMD=SAVE_FORM&OnSave=Close&PARAMS=" + params;
        document.getElementById('Form1').submit();
    }
}

function cancel() {
    document.getElementById('Form1').target = '';
    document.getElementById('Form1').action = "EditForm.aspx?CMD=CANCEL";
    document.getElementById('Form1').submit();
}

function cancelSettings() {
    if ((formName.length == 0 && $F("Name").length == 0) || (currentTable.length == 0 && $F("formTables").length == 0)) {
        cancel();
    }else{
        $("Name").value = formName;
        $("fConnection").selectedValue = currentConn;
        if (isView) {
            $("formTables").value = currentTable;
        }else{
            $("formTables").selectedValue = currentTable;
        }
        
        dialog.hide("Settings");
    }
}

function doInit() {
    //document.body.style.height = parent.getContentFrameHeight() - 1 + 'px';
    //setContentHeight(280);
    
    FieldSettingsPosition();
    window.onresize = FieldSettingsPosition;
    
    $("fConnection").onchange();
    if (isView) $("formTables").onchange();
    
    if ($F("Name") == "") {
        openSettings();
    }else{
        try {
            formName = $F("Name");
            currentConn = $F("fConnection");
            currentTable = $F("formTables");
        } catch (e) {}
    }

    // Set the onCompleted event
    dwGrid_formFields.onRowAddedCompleted = function(row) {
        var labelBox = row.findControl("fLabel");
        labelBox.focus();
        this.toggleRowSelection(row);
        handleRowSelected(labelBox);
        CommitPrevSettings(_srcId);
        PopulateNextSettings(labelBox.id.replace('Label', 'Settings'));
    };
}

function help() {
    window.open('http://manual.net.dynamicweb.dk/Default.aspx?ID=1&m=keywordfinder&keyword=modules.datamanagement.general.form.edit&LanguageID=' + helpLang, 'dw_help_window', 'location=no,directories=no,menubar=no,toolbar=yes,top=0,width=1024,height=' + (screen.availHeight-100) + ',resizable=yes,scrollbars=yes');
}

function openSettings() {
    try {
        if (currentConn == null || currentTable == null) doRefresh = true;
        formName = $F("Name");
        currentConn = $F("fConnection");
        currentTable = $F("formTables");
    } catch (e){}

    dialog.show('Settings');
}

function formPreview() {
    alert("not implemented.");
}

function CommitForm() {
    CommitPrevSettings(_srcId);
    if ($("Name").value.length == 0) {
        alert(txtNoName);
        dialog.show("Settings")
        $("Name").focus();
        
        return false;
    }

    if (validateSystemNames()) {
        alert(txtSysNotUnique);
        $(problemRows[0]).focus();
        
        return false;
    }
    
    return true;
}

function ShowFormSettings(srcId, ddlTypes, txtSysName) {
    $("FieldSettings").className = "formFieldSettings";
    
    nextRowType = $(ddlTypes).value;
    $(ddlTypes).onchange();

    CommitPrevSettings(_srcId);
    PopulateNextSettings(srcId);
    
    isFirstTime = false;
    _srcId = srcId;
}

function CommitPrevSettings(srcId) {
    if (srcId == null || $(srcId) == null)
        return;

    var field = eval('(' + $F(srcId) + ')');

    if (!$("dataTypes").disabled) {
        field.DataType = $("dataTypes").options[$("dataTypes").selectedIndex].text;
        field.DataTypeValue = $("dataTypes").options[$("dataTypes").selectedIndex].value;
    }
    field.DefaultValue = $F("defaultValue");
    field.OptionType = $F("optionSourceType");
    field.OptionDataListID = $F("listDataSources");
    field.OptionKeyField = $F("keyField");
    field.OptionValueField = $F("valueField");
    field.MaxLength = $F("maxLength");
    field.Width = $F("fieldWidth");
    field.Height = $F("fieldHeight");
    if (!isFirstTime) {
        field.Active = $("fieldActive").checked ? "True" : "False";
    }
    else {
        isFirstTime = false;
    }
     field.ValidationValue = $F("validationValue");

    var row = dwGrid_formFields.findContainingRow(srcId);
    var fieldType = row.findControl("fTypes").value
    if (checkboxTypeCode == fieldType) {
        field.Checked = $("fieldSetChecked").value == "selected" ? "True" : "False";
    }
    
    if (field.ID <= 0) {
        var sysNameBox = row.findControl("fSystemname");
        var labelBox = row.findControl("fLabel");
        if (labelBox.value != "" && sysNameBox.value == "") {
            sysNameBox.value = MakeSystemName(labelBox.value);
        }
        if (sysNameBox.value != "" && MakeSystemName(sysNameBox.value) != sysNameBox.value) {
            sysNameBox.value = MakeSystemName(sysNameBox.value);
        }
        
    }

    var str = Object.toJSON(field);
    $(srcId).value = str;
    
    _srcId = srcId
}

function PopulateNextSettings(srcId) {
    var dataTypeLocked = false;
    var field = eval('(' + $F(srcId) + ')');
    
    for (var i = 0; i < $("dataTypes").length; i++) {
        if ($("dataTypes").options[i].value == field.DataTypeValue) {
            $("dataTypes").selectedIndex = i;
        }
    }

    dataTypeLocked = field.ID > 0;
    $("dataTypes").disabled = dataTypeLocked;
    $("ddlTypes").style.display = (dataTypeLocked ? 'none' : '');
    $("dataType").style.display = (dataTypeLocked ? '' : 'none');

    if (dataTypeLocked) {
        $("dataType").update($("dataTypes").options[$("dataTypes").selectedIndex].text);
    }

    $("defaultValue").value = field.DefaultValue;
    $("optionSourceType").value = field.OptionType;
    $("listDataSources").value = field.OptionDataListID;
    $("maxLength").value = field.MaxLength;
    $("fieldWidth").value = field.Width;
    $("fieldHeight").value = field.Height;
    $("fieldActive").checked = field.Active == "True" ? true : false;
    $("validationValue").value = field.ValidationValue;

    var fieldType = dwGrid_formFields.findContainingRow(srcId).findControl("fTypes").value
    nextRowType = fieldType;
    if (hasOptions.indexOf(fieldType) != -1) {
        var optionID = dwGrid_formFields.findContainingRow(srcId).ID;
        var isRadio = fieldType == radioTypeCode ? true : false;
        fillDefaultValueSelector(field.DefaultValue, getOptions(optionID), isRadio);
        $("optionSourceTypeRow").show();
        changeOptionSourceType({ value: field.OptionType });
        fillOptionDataListFields(field.OptionDataListID);
        $("keyField").value = field.OptionKeyField;
        $("valueField").value = field.OptionValueField;
    } else {
        $("optionSourceTypeRow").hide();
    }
    if (checkboxTypeCode == fieldType) {
        $("fieldSetChecked").value = field.Checked == "True" ? "selected" : "clear";
    }
    
    if (textFieldTypeCode == fieldType) {
        $("maxLengthRow").show();
    }else{
        $("maxLengthRow").hide();
    }

    if (textAreaTypeCode == fieldType) {
        $("widthContainer").innerText = txtColumns;
        $("heightContainer").innerText = txtRows;
    } else {
        $("widthContainer").innerText = txtWidth;
        $("heightContainer").innerText = txtHeight;
    }
}

function ChangeFieldType(item, id) {
    if (hasOptions.indexOf(item.value) != -1) {
        $("Tab2_head").style.display = "inline";
        $("defaultValueSelector").style.display = "block";
        $("defaultValue").style.display = "none";

        var row = dwGrid_formFields.findContainingRow(item);
        var optionsField = row.findControl("fOptions");
        var options = eval('(' + $F(optionsField) + ')');
        
        var optionsHeight = $("DW_Newsletter_tableTab").getHeight(); //DW_Newsletter_tableTab is the hardcoded id of the table, in TabControl.vb

        $("options").style.height = optionsHeight;
        $("optionsFrame").src = "FormOptionsGrid.aspx?rowId=" + (EditableGridRow.getRowIndex(row) + 1) + "&getOptions=True";

        options.WasShown = "True";
        var str = Object.toJSON(options);
        optionsField.value = str;
    }else{
        var hideTab = false;
        var resetDefaultValue = false;
        if (item.value != nextRowType && hasOptions.indexOf(nextRowType) != -1) {
            if (!confirm(txtNoOptionsOnNewType1 + "\n" + txtNoOptionsOnNewType2 + "\n"  +txtNoOptionsOnNewType3)) {
                item.value = nextRowType;
                hideTab = false;
            }else{
                hideTab = true;
                resetDefaultValue = true;
            }
        }else{
            hideTab = true;
        }

        if (hideTab) {
            $("Tab1_head").onclick();
            $("Tab2_head").style.display = "none";
            $("defaultValueSelector").style.display = "none";
            $("defaultValue").style.display = "inline";
            if (resetDefaultValue) {$("defaultValue").value = "";}
        }
    }
    
    if (item.value == checkboxTypeCode) {
        $("setCheckedTR").style.display = "table-row";
    }else{
        $("setCheckedTR").style.display = "none";
    }
}

function validateSystemNames() {
    var rows = dwGrid_formFields.rows.getAll();
    var validatedRows = new Array;
    var emptyRows = new Array;
    var hasTrouble = false;

    problemRows.length = 0;
    for (var i = 0; i < rows.length; i++) {
        var txtSysName = rows[i].findControl("fSystemname");
        if (txtSysName.value.length == 0) {
            var fLbl = rows[i].findControl("fLabel");
            var fReq = rows[i].findControl("fRequired");
            var fDesc = rows[i].findControl("fDescription");
            
            if (fLbl.value.length == 0 && fReq.checked == false && fDesc.value.length == 0) {
                emptyRows.push(rows[i]);
            }else{
                hasTrouble = true;
                problemRows.push(txtSysName.id);
            }
        }else if (validatedRows.indexOf(txtSysName.value) != -1) {
            hasTrouble = true;
            problemRows.push(txtSysName.id);
        }else if (MakeSystemName(txtSysName.value) == "") {
            hasTrouble = true;
            problemRows.push(txtSysName.id);
        }else{
            validatedRows.push(txtSysName.value);
        }
    }
    dwGrid_formFields.deleteRows(emptyRows); //Remove all empty rows from the Grid.
    return hasTrouble;
}

function updateGrid() {
    if ($F("Name").length > 0) {
        if (isView) {
            if (currentConn == null) doRefresh = true;
            if (currentTable == null) doRefresh = true;
            if (currentConn != $("fConnection").value) doRefresh = true;
            try {if (currentTable != $("formTables").value) doRefresh = true;} catch (e){}
            
            if (doRefresh) {
                doRefresh = false;
                dwGrid_formFields.deleteRows(dwGrid_formFields.rows.getAll());
                document.getElementById('Form1').action = "EditForm.aspx?CMD=FILL_GRID&ID=" + formId;
                document.getElementById('Form1').submit();
            }else{
                dialog.hide("Settings");
            }
        }else{
            if (!isEdit) {
                if ($("formTables").value.length == 0) {
                    alert(txtNoTableName);
                    $("formTables").focus();
                }else{
                    var result = checkTable("EditForm.aspx?AJAXCMD=CHECK_TABLE&ID=" + formId + 
                                            "&connId=" + $("fConnection").value.split(",")[0] + 
                                            "&dbName=" + $("fConnection").value.split(",")[1] + 
                                            "&tableName=" + $("formTables").value + 
                                            "&isView=" + isView + 
                                            "&timestamp=" + (new Date).getTime());

                    if (result) {
                        updateTable();
                        dialog.hide("Settings");
                    }else{
                        $("formTables").focus();
                    }
                }
            }else{
                dialog.hide("Settings");
            }
        }
    }else{
        alert(txtNoName);
    }
}

function changeOptionSourceType(item) {
    if (item.value == '0') {
        $("options").style.display = "block";
        $("optionSource").style.display = "none";
    }
    else {
        $("options").style.display = "none";
        $("optionSource").style.display = "block";
    }
}

function reloadOptionDataList(item) {
    fillOptionDataListFields(item.value);
}

function fillOptionDataListFields(viewID) {
    var lstKeyFields = document.getElementById("keyField");
    var lstValueFields = document.getElementById("valueField");
    lstKeyFields.options.length = 0;
    lstValueFields.options.length = 0;
    if(viewID == '0') return;

    var result;
    var url = "EditForm.aspx?AJAXCMD=GET_LIST_FIELDS&ID=" + formId +
                "&viewID=" + viewID +
                "&timestamp=" + (new Date).getTime();
    new Ajax.Request(url, {
        asynchronous: false,
        method: 'get',

        onSuccess: function (request) {
            result = request.transport.responseText;
        }
    });
    var fields = eval('(' + result + ')').fields;
    for (var i = 0; i < fields.length; i++) {
        var listItem = fields[i]
        lstKeyFields.options.add(new Option(listItem, listItem));
        lstValueFields.options.add(new Option(listItem, listItem));
    }
}

function reloadTables() {
        ajaxLoader("EditForm.aspx?AJAXCMD=FILL_TABLES&ID=" + formId + 
                   "&connId=" + $("fConnection").value.split(",")[0] + 
                   "&dbName=" + $("fConnection").value.split(",")[1] + 
                   "&tableName=" + $("hiddenTableName").value + 
                   "&isView=" + isView + 
                   "&timestamp=" + (new Date).getTime(),
                   "tableDropdown");
        if (isView)
            $("formTables").onchange();
    }

function updateTable() {
    $("hiddenTableName").value = $("formTables").value;
}

function handleOptions(rows) {
    var fieldRow = dwGrid_formFields.findContainingRow(_srcId);
    var optionsField = fieldRow.findControl("fOptions");
    var keys = "";
    var values = "";
    
    $("defaultValueSelector").length = 0;
    
    if (fieldRow.findControl("fTypes").value == radioTypeCode) {
        $("defaultValueSelector").options.add(new Option(radioNoneSelectedText,""));
    }
    
    var options = eval('(' + optionsField.value + ')');
    
    for (var i = 0; i < rows.length; i++) {
        var key = rows[i].findControl("oKey").value;
        var value = rows[i].findControl("oValue").value;
        
        if (i == 0) {
            keys = key;
            values = value;
        }else{
            keys += "|" + key;
            values += "|" + value;
        }
        
        $("defaultValueSelector").options.add(new Option(key,value));

    }
    $("defaultValueSelector").onchange();

    options.Keys = keys.gsub(",", "<replaced>;</replaced>");
    options.Values = values.gsub(",", "<replaced>;</replaced>");
    options.WasShown = "True";
    
    var str = Object.toJSON(options);
    optionsField.value = str;
}

function setDefaultValue(selector) {
    $("defaultValue").value = selector.value;
}

function fillDefaultValueSelector(defaultValue, options, isRadio) {
    $("defaultValueSelector").length = 0;

    if (isRadio) {
        $("defaultValueSelector").options.add(new Option(radioNoneSelectedText,""));
    }
    
    var keys = options.Keys.split("|");
    var values = options.Values.split("|");
    
    for (var i = 0; i < keys.length; i++) {
        var option = new Option(keys[i].gsub("<replaced>;</replaced>", ","),values[i].gsub("<replaced>;</replaced>", ","));
        if (values[i].gsub("<replaced>;</replaced>", ",") == defaultValue) {option.selected = true;}
        $("defaultValueSelector").options.add(option)
    }
}

function getOptions(rowId) {
    var row = dwGrid_formFields.rows.getRowByID(rowId);
    var optionsField = row.findControl("fOptions");
    var options = eval('(' + optionsField.value + ')');
    return distributeOptionsByIDs(options);
}

function distributeOptionsByIDs(options) {
    var id = '';
    var ret = options;
    var keys = [], values = [];
    var newKeys = '', newValues = '';

    if (ret && ret.Keys && ret.Values) {
        keys = ret.Keys.split('|') || [];
        values = ret.Values.split('|') || [];

        for (var i = 0; i < keys.length; i++) {
            id = getOptionID(keys[i]);
            if (id) {
                newKeys += keys[i].replace(id + ':', '');

                for (var j = 0; j < values.length; j++) {
                    if (getOptionID(values[j]) == id) {
                        newValues += values[j].replace(id + ':', '');
                        break;
                    }
                }

                if (i < (keys.length - 1)) {
                    newKeys += '|';
                    newValues += '|';
                }
            }
        }

        ret.Keys = newKeys;
        ret.Values = newValues;
    }

    return ret;
}

function getOptionID(optionText) {
    var ret = '';
    var separatorIndex = 0;

    if (optionText) {
        separatorIndex = optionText.indexOf(':');
        if (separatorIndex > 0) {
            ret = optionText.substr(0, separatorIndex);
        }
    }

    return ret;
}

function ajaxLoader(url, divId) {
    new Ajax.Updater(divId, url, {
        asynchronous: false,
        evalScripts: true,
        method: 'get',

        onSuccess: function(request) {
            $(divId).update(request.responseText);
            updateTable();
        }
    });
}

function checkTable(url) {
    var result;
    new Ajax.Request(url, {
        asynchronous: false,
        method: 'get',
        onSuccess: function(request) {
            if (request.responseText == "ok") {
                result = true;
            }else if (request.responseText == "error") {
                alert(txtCreateFailed);
                result = false;
            }else{
                alert(txtTableExists);
                result = false;
            }
        }
    });
    return result;
}

function MakeSystemName(label) {
    if (!isView) {
        var result;
        var url = "EditForm.aspx?AJAXCMD=VALIDATE_SYS_NAME&tableName=" + $("hiddenTableName").value + "&label=" + label + "&timestamp=" + (new Date()).getTime();
        new Ajax.Request(url, {
            asynchronous: false,
            method: 'get',
            onSuccess: function(request) {
                result = request.responseText;
            }
        });

        return result;
    } else {
        return label;
    }
}

function HandleKeyDown(e, obj) {
    // Check if [TAB] or [ENTER] was pressed
    if (!e.shiftKey && (e.keyCode == 9 || e.keyCode == 13)) {
        var allRows = dwGrid_formFields.rows.getAll();
        var lastRow = allRows[allRows.length - 1];
        var thisRow = dwGrid_formFields.findContainingRow(obj);
        
        var isLastRow = (thisRow.ID == lastRow.ID);
        
        if (isLastRow) {
            dwGrid_formFields.addRow();
        }
    }
}

function checkInput(box) {
    if (box.value == "0") {
        box.value = "";
    }
}

function checkOutput(box) {
    if (box.value == "") {
        box.value = "0";
    }
}

function setContentHeight(heightReduction) {
    //heightReduction: Reduce the height of the content div by this value. For an increase in height
    //pass a value < 0 e.g. -100 for an increase in height by 100px.
    $("content").style.height = parent.getContentFrameHeight() - 1 - $("Ribbon").getHeight() - heightReduction + 'px';
}

function deleteThisRow(obj) {
    var row = dwGrid_formFields.findContainingRow(obj);
    dwGrid_formFields.deleteRows([row]);
}

function handleRowSelected(obj) {
    row = dwGrid_formFields.findContainingRow(obj);
    if (row)
        try {
            var rows = dwGrid_formFields.rows.getAll();
            for (var i = 0; i < rows.length; i++) {
                var currentRow = rows[i];
                if (currentRow.isSelected) {
                    currentRow.findControl('buttons').style.visibility = "visible";
                } else {
                    currentRow.findControl('buttons').style.visibility = "hidden";
                }
            }
        } catch (e) {

        }
}
