// The ID of the ValidationConfigurator control
var controlID;
var ruleDropDownOrder = new Array()
var ruleDropDownDictionary = new Array();
var andOrDropDownDictionary = new Array();
var ruleUseParameter = new Array();
var validationFieldTypeDictionary = new Array();
var ruleTranslated;
var parametersTranslated;
var notEmptyErrorMsg;

function addValidation() {
    addValidationWithParams('', '', '', true, 'and', '', "true");
}

function addValidationWithParams(validationID, fieldName, fieldSystemName, doAddFirstRule, andOrSelected, preffix, allowEdit) {
    var div = document.getElementById(controlID + "ValidationDiv");
    var hiddenStyle
    if (allowEdit.toLowerCase() != 'true') {
        hiddenStyle = "display: none;"; 
    } else {
        hiddenStyle = "";
    }
    if (fieldSystemName == '') {
        var dropDown = document.getElementById(controlID + 'Dropdown');
        fieldName = dropDown.options[dropDown.selectedIndex].text;

        fieldSystemName = dropDown.value;
        preffix = "others"
        if (fieldSystemName.indexOf("EcomOrderVoucherCode") > 0) {
            preffix = "vauchers"
        }
        else if (fieldSystemName.indexOf("EcomOrderGiftCardCode") > 0) {
            preffix = "gift-card"
        }
        if (fieldSystemName == '')
            return;
    }

    var validationCount = getValidationCount();

    var id = controlID + '_' + validationCount;
    
    div.innerHTML += '<div ID="' + id + '_div">' +
                        '<br /><br />' +
                        '<div>' +
                            '<legend class="gbTitle pull-left">' + fieldName + '</legend>' +
                            '<div class="btn pull-left" style="margin-top:4px;"><i class="fa fa-remove color-danger" style="' + hiddenStyle + '" onclick="deleteValidation(' + validationCount + ');"></i></div>' +
                        '</div><div class="clearfix"></div>' +
                        getAndOrDropDown(id + "_andOrDropDown", andOrSelected, allowEdit) +
                        '<div>' +
                            '<table ID="ValidationTable_' + validationCount + '" rules="rows" class="table table-striped">' +
                                '<tr class="header">' +
                                    '<td>' + ruleTranslated + '</td>' +
                                    '<td>' + parametersTranslated + '</td>' +
                                    '<td style="width:20px"><div class="btn"><i class="fa fa-plus-square color-success" onclick="addRule(' + validationCount + ', \'' + preffix + '\');"></i></div></td>' +
                                '</tr>' +
                            '</table>' +
                            '<input type="hidden" name="' + id + '_fieldSystemName" id="' + id + '_fieldSystemName" value="' + fieldSystemName + '" />' +
                            '<input type="hidden" name="' + id + '_ruleCounter" id="' + id + '_ruleCounter" value="0" />' +
                            '<input type="hidden" name="' + id + '_trueRuleCounter" id="' + id + '_trueRuleCounter" value="0" />' +
                            '<input type="hidden" name="' + id + '_valID" id="' + id + '_valID" value="' + validationID + '" />' +
                            '<input type="hidden" name="' + id + '_valType" id="' + id + 'valType" value="' + validationFieldTypeDictionary[fieldSystemName] + '" />' +
                        '</div>' +
                        '<small class="help-block error" id="' + id + '_errorMsg"></small>' +
                    '</div>';
                        
    incValidationCount();
    
    // Add the first rule
    if (doAddFirstRule)
        addRule(validationCount, preffix);
}

function addRule(validationIndex, preffix) {
    addRuleWithParams(validationIndex, '', '', '', preffix, "true");
}

function addRuleWithParams(validationIndex, ruleID, ruleSystemName, params, preffix, allowEdit) {
    var ruleCount = getRuleCount(validationIndex);
    var idPrefix = controlID + '_' + validationIndex + '_' + ruleCount;
    if (allowEdit.toLowerCase() != 'true') {
        hiddenStyle = "display: none;";
    } else {
        hiddenStyle = "";
    }
    
    var row = document.getElementById('ValidationTable_' + validationIndex).insertRow(-1);
    row.insertCell(-1).innerHTML = getRuleDropDown(validationIndex, ruleCount, ruleSystemName, preffix, allowEdit) +
                                 '<input type="hidden" id="' + idPrefix + '_ruleID" name="' + idPrefix + '_ruleID" value="' + ruleID + '" />' + 
                                 '<input type="hidden" id="' + idPrefix + '_ruleSystemName" name="' + idPrefix + '_ruleSystemName" value="' + ruleSystemName + '" />';
    row.insertCell(-1).innerHTML = '<input type="text" id="' + idPrefix + '_params" name="' + idPrefix + '_params" value="' + params + '" size="50" class="std" />';
    row.insertCell(-1).innerHTML = '<div class="btn"><i class="fa fa-remove color-danger" style="' + hiddenStyle + '" onclick="deleteRule(' + validationIndex + ', ' + ruleCount + ');"></i></div>';
    row.id = idPrefix + "_row";
    
    updateParamsTextbox(validationIndex, ruleCount, document.getElementById(idPrefix + "_ruleSelector").value, allowEdit);
    incRuleCount(validationIndex);
    updateAndOr(validationIndex);
}

function deleteRule(validationIndex, ruleIndex) {
    var ruleID = document.getElementById(controlID + '_' + validationIndex + '_' + ruleIndex + '_ruleID').value
    if (ruleID != '') {
        deletedRules = document.getElementById(controlID + "_deletedRules");
        deletedRules.value = deletedRules.value + ruleID + ' ';
    }

    var table = document.getElementById('ValidationTable_' + validationIndex);
    for (var i = 0; i < table.rows.length; i++) {
        var row = table.rows[i];
        if (row.id == controlID + '_' + validationIndex + '_' + ruleIndex + "_row") {
            table.deleteRow(row.rowIndex);
            decRuleCount(validationIndex);
            updateAndOr(validationIndex);
            return;
        }
    }
}

function updateAndOr(validationIndex) {
    var andOrDropDown = document.getElementById(controlID + '_' + validationIndex + '_andOrDropDown').parentElement.parentElement;
    
    if (getTrueRuleCount(validationIndex) > 1)
        andOrDropDown.style.display = '';
    else
        andOrDropDown.style.display = 'none';
}
function updateParamsTextbox(validationIndex, ruleIndex, ruleSystemName, allowEdit) {
    var useParameter = ruleUseParameter[ruleSystemName];
    var textbox = document.getElementById(controlID + '_' + validationIndex + '_' + ruleIndex + '_params')
    if (useParameter) {
        textbox.style.display = '';
        textbox.disabled = allowEdit.toLowerCase() != 'true';
    } else {
        textbox.style.display = 'none';
    }

    document.getElementById(controlID + '_' + validationIndex + '_' + ruleIndex + '_ruleSystemName').value = ruleSystemName;
}

function deleteValidation(validationIndex) {
    var valID = document.getElementById(controlID + '_' + validationIndex + '_valID').value
    if (valID != '') {
        deletedValidations = document.getElementById(controlID + "_deletedValidations");
        deletedValidations.value = deletedValidations.value + valID + ' ';
    }

    removeElementById(controlID + '_' + validationIndex + '_div');
}

function removeElementById(elemId) {
    var elem = document.getElementById(elemId);
    if (elem.parentNode) {
        elem.parentNode.removeChild(elem);
    }
}

function getRuleDropDown(validationIndex, ruleIndex, selectedSystemName, preffix, allowEdit) {
    if (allowEdit.toLowerCase() != 'true') {
        disabledParam = "disabled='true'";
    } else {
        disabledParam = "";
    }
    var id = controlID + '_' + validationIndex + '_' + ruleIndex + '_ruleSelector';
    var html = '<select id="' + id + '" name="' + id + '" onchange="updateParamsTextbox(' + validationIndex + ', ' + ruleIndex + ', this.value, \'' + allowEdit + '\')" class="std" ' + disabledParam + ' >';
    
    preffix += '-'; 
    selectedSystemName = preffix + selectedSystemName;
    
    var ruleSystemName = '', ruleNiceName = '';
    for (var i = 0; i < ruleDropDownOrder.length; i++) {
            ruleSystemName = ruleDropDownOrder[i];
            ruleNiceName = ruleDropDownDictionary[ruleSystemName];

            if (ruleSystemName.indexOf(preffix) != -1) {
                html += '<option ' + disabledParam + ' value="' + ruleSystemName + '"';
                if (ruleSystemName == selectedSystemName)
                    html += ' selected="selected"';
                html += '>' + ruleNiceName + '</option>';
            }
    }
    html += '</select>';
    return html;
}
function getAndOrDropDown(id, selected, allowEdit) {
    if (allowEdit.toLowerCase() != 'true') {
        disabledParam = "disabled='true'";
    } else {
        disabledParam = "";
    }
    var html = '<div class="form-group" style="display:none"><label class="control-label">Rule</label><div class="form-group-input"><select ' + disabledParam + ' id="' + id + '" name="' + id + '" class="std">', key = '';
    var keys = ['and', 'or'];

    for (var i=0; i < keys.length; i++) {
        key = keys[i];
        html += '<option ' + disabledParam + ' value="' + key + '"';
        if (key == selected)
            html += ' selected="selected"';
        html += '>' + andOrDropDownDictionary[key] + '</option>';
    }
    html += '</select></div></div>';
    return html;
}

function getRuleCount(validationIndex) {
    return document.getElementById(controlID + '_' + validationIndex + '_ruleCounter').value
}
function getTrueRuleCount(validationIndex) {
    return document.getElementById(controlID + '_' + validationIndex + '_trueRuleCounter').value
}
function incRuleCount(validationIndex) {
    var ruleCounterHidden = document.getElementById(controlID + '_' + validationIndex + '_ruleCounter')
    ruleCounterHidden.value = parseInt(ruleCounterHidden.value) + 1;
    
    var trueRuleCounterHidden = document.getElementById(controlID + '_' + validationIndex + '_trueRuleCounter')
    trueRuleCounterHidden.value = parseInt(trueRuleCounterHidden.value) + 1;
}
function decRuleCount(validationIndex) {
    var trueRuleCounterHidden = document.getElementById(controlID + '_' + validationIndex + '_trueRuleCounter')
    trueRuleCounterHidden.value = parseInt(trueRuleCounterHidden.value) - 1;
}

function getValidationCount() {
    return document.getElementById(controlID + '_validationCounter').value
}
function incValidationCount() {
    var validationCounterHidden = document.getElementById(controlID + '_validationCounter')
    validationCounterHidden.value = parseInt(validationCounterHidden.value) + 1;
}

function validateParameters() {
    var success = true;
    for (var valIndex = 0; valIndex < getValidationCount(); valIndex++) {
        var errorDiv = document.getElementById(controlID + '_' + valIndex + '_errorMsg');
        if (errorDiv) { // validation is avalable
            errorDiv.innerHTML = '';
            for (var ruleIndex = 0; ruleIndex < getRuleCount(valIndex); ruleIndex++) {
                var ruleIDPrefix = controlID + '_' + valIndex + '_' + ruleIndex;
                var systemName = document.getElementById(ruleIDPrefix + '_ruleSystemName');
                if (systemName) { //rule is avalable
                    if (ruleUseParameter[systemName.value]) {
                        var ruleParam = document.getElementById(ruleIDPrefix + '_params').value;
                        if (ruleParam.length == '') {
                            errorDiv.innerHTML = notEmptyErrorMsg;
                            success = false;
                        }
                    }
                }
            }
        }
    }
    return success;
}