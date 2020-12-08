var validationGroups = new Array();
function ValidationGroup(id, name, fields) {
    this.Id = id;
    this.Name = name;
    this.Fields = fields;
}

function ValidationField(id, isChecked, niceName, errorMessage, rules) {
    this.Id = id;
    this.IsChecked = isChecked;
    this.NiceName = niceName;
    this.ErrorMessage = errorMessage;
    this.Rules = rules;
}

function addNewValidationGroup(validationGroupID) {
    if (validationGroupID == '') {
        alert(document.getElementById('Translate_Please_select_a_validation_group').innerHTML);
        return;
    }

    for (var i = 0; i < validationGroups.length; i++) {
        if (validationGroups[i].Id == validationGroupID) {
            alert(document.getElementById('Translate_The_selected_validation_group_is_already_added').innerHTML);
            return;
        }
    }

    new Ajax.Request('/Admin/Module/eCom_CartV2/eCom_CartV2_Edit.aspx?GetValidationGroupAJAX=' + validationGroupID, {
        onSuccess: function(response) {
            addValidationGroup(eval('(' + response.responseText + ')'));
        }
    });
}

function addValidationGroup(group) {
    validationGroups.push(group);

    var parentDiv = document.getElementById('ValidationContainer');
    var newDiv = document.createElement('div');
    parentDiv.appendChild(newDiv);
    newDiv.id = 'ValidationGroup' + group.Id;
    var table = document.createElement('table');
    newDiv.appendChild(table);

    // Hidden field
    hiddenSettingNames[group.Id] = new Array();

    // Header 1
    var row = table.insertRow(table.rows.length);
    var cell = row.insertCell(row.cells.length);
    cell.colSpan = 3;
    
    // 'Check none'-image
    cell.appendChild(createIcon('fa fa-remove color-danger btn btn-flat m-l-5', "deleteValiationGroup('" + group.Id + "');", 'Remove'));
    
    // Delete-image 
    cell.appendChild(createIcon('fa fa-check-square-o color-success btn btn-flat m-l-5', "checkAllValidations('" + group.Id + "');", 'Check_all_fields'));
    
    // Name of the group
    var nameSpan = document.createElement('span');
    nameSpan.style.fontWeight = 'bold';
    nameSpan.innerHTML = group.Name;
    nameSpan.style.paddingLeft = '3px';
    cell.appendChild(nameSpan);
    
    var hiddenCheck = newElement('input', { type: 'checkbox', name: 'ValidationGroups', value: group.Id });
    cell.appendChild(hiddenCheck);
    hiddenCheck.checked = true;
    hiddenCheck.style.display = 'none';

    // Header 2
    row = table.insertRow(table.rows.length);
    row.insertCell(row.cells.length);
    row.insertCell(row.cells.length).innerHTML = document.getElementById('Translate_Field').innerHTML;
    row.insertCell(row.cells.length).innerHTML = document.getElementById('Translate_ErrorMessage').innerHTML;

    for (var i = 0; i < group.Fields.length; i++) {
        
    
        var field = group.Fields[i];
        row = table.insertRow(table.rows.length);

        // Check
        var checkCell = row.insertCell(row.cells.length);
        var check = newElement('input', { type: 'checkbox', name: 'SelectedValidations', value: field.Id });
        checkCell.appendChild(check);
        check.checked = field.IsChecked;

        // Name
        var nameCell = row.insertCell(row.cells.length);
        nameCell.innerHTML = field.NiceName;
        nameCell.style.cursor = 'pointer';
        nameCell.style.paddingRight = '10px';
        nameCell.style.width = '144px';
        nameCell.onclick = new Function("var ruleRow = document.getElementById('Rules" + field.Id + "'); ruleRow.style.display = ruleRow.style.display == 'none' ? 'table-cell' : 'none'; ");

        // ErrorMessage
        var errorMsgCell = row.insertCell(row.cells.length);
        var errorMsg = document.createElement('input');
        errorMsgCell.appendChild(errorMsg);
        errorMsg.type = 'text';
        errorMsg.name = 'ErrorMessage_' + field.Id;
        errorMsg.value = field.ErrorMessage;
        errorMsg.id = errorMsg.name;
        errorMsg.className = 'std';
        
        addHidden(group.Id, errorMsg.name, '', false, true);

        // Extra row showing rules
        row = table.insertRow(table.rows.length);
        row.insertCell(row.cells.length);
        var ruleCell = row.insertCell(row.cells.length);
        ruleCell.colSpan = 2;
        var ruleBox = document.getElementById('RuleBox').getElementsByTagName('fieldset')[0].cloneNode(true);
        var ruleSpan = ruleBox.getElementsByTagName('span')[0];
        for (var j = 0; j < field.Rules.length; j++)
            ruleSpan.innerHTML += field.Rules[j] + '<br />';
        ruleCell.appendChild(ruleBox);
        ruleCell.style.display = 'none';
        ruleCell.id = 'Rules' + field.Id;

    }
}

function deleteValiationGroup(groupID) {
    clearHidden(groupID);
    var div = document.getElementById('ValidationGroup' + groupID);
    var parentDiv = document.getElementById('ValidationContainer')
    parentDiv.removeChild(div);

    var index = -1;
    for (var i = 0; i < validationGroups.length; i++) {
        if (validationGroups[i].Id == groupID) {
            index = i;
            break;
        }
    }
    if (index >= 0)
        validationGroups.splice(index, 1);
            
}

function checkAllValidations(groupID) {
    var div = document.getElementById('ValidationGroup' + groupID);
    var inputs = div.getElementsByTagName('input');
    var isAllChecked = true;
    for (var i = 0; i < inputs.length; i++) {
        if (inputs[i].name == 'SelectedValidations' && !inputs[i].checked) {
            isAllChecked = false;
            break;
        }
    }
    for (var i = 0; i < inputs.length; i++) {
        if (inputs[i].name == 'SelectedValidations') {
            inputs[i].checked = !isAllChecked;
        }
    }
}





// IE8 compatibality: IE8 cannot create elements the same way as other browsers
function newElement(type,att,evts,appendToObj){
        var elem;
        if(isNameQuirk() && att.name != null){
          elem = document.createElement('<' + type + ' name="' + att.name + '">');
        }
        else{
          elem = document.createElement(type);
        }
        for(var prop in att){
          elem.setAttribute(prop,att[prop]);
        }
        if(evts){
          for(var evt in evts){
            elem[evt] = evts[evt];
          }
        }
        if(appendToObj){
          appendToObj.appendChild(elem);
        }
        return elem;
      }
      function isNameQuirk(){
        var elem1 = document.createElement("div");
        var elem2 = document.createElement("input");
        elem2.type = "hidden";
        elem2.name = "testName";
        elem1.appendChild(elem2);
        var isQuirk = (elem1.innerHTML.indexOf("test") == -1);
        isNameQuirk = function() {return isQuirk;}
        return isNameQuirk();
      }