var FieldOptionsList = function () { }

FieldOptionsList.EnforceUniqueValues = false;

FieldOptionsList.deleteRow = function(link) {
    var optionName = '';
    var row = dwGrid_optionsGrid.findContainingRow(link);

    if (row) {
        optionName = row.findControl('txName').value;

        if (!optionName || optionName.length == 0)
            optionName = '[' + FieldOptionsList._message('message-not-specified') + ']';

        if (confirm(FieldOptionsList._message('message-delete-row').replace('%%', optionName))) {
            dwGrid_optionsGrid.deleteRows([row]);
        }
    }
}

FieldOptionsList._message = function (className) {
    var ret = '';
    var container = null;

    if (className) {
        container = $$('.' + className);
        if (container != null && container.length > 0) {
            ret = container[0].innerHTML;
        }
    }

    return ret;
}

FieldOptionsList.validate = function() {
    var validationSuccessful = true;
    var errorClassName = 'has-error';
    var valuesCollection = [];
    var rows = dwGrid_optionsGrid.rows.getAll(); 

    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];

        row.element.querySelectorAll("td").forEach(function (td) {
            td.classList.remove(errorClassName);
        });

        var nameControl = row.findControl('txName');
        var tdNameControl = nameControl.closest('td');
        var valueControl = row.findControl('txValue');
        var tdValueControl = valueControl.closest('td');

        if (!nameControl.value) {
            validationSuccessful = false;
            tdNameControl.classList.add(errorClassName);
        } else if (this.EnforceUniqueValues) {
            if (valuesCollection.includes(valueControl.value)) {
                validationSuccessful = false;
                tdValueControl.classList.add(errorClassName);
            } else {
                valuesCollection.push(valueControl.value);
            }
        }   
    }

    return validationSuccessful;
}