var steps = new Array();

function Step(name, template, templatePath, isCheckout) {
    this.Name = name;
    this.Template = template;
    this.TemplatePath = templatePath;
    this.IsCheckout = isCheckout;
}

function editStep(stepIndex) {
    var step = steps[stepIndex];
    $('StepIndex').value = stepIndex;
    $('StepName').value = step.Name;
    
    // Check if the template exists in the dropdown
    var dropdown = document.getElementById('FM_StepTemplate');
    var exists = false;
    for (var i = 0; i < dropdown.options.length; i++)
        if (dropdown.options[i].value == step.Template) {
            dropdown.selectedIndex = i;
            $('StepTemplate_path').value = step.TemplatePath;
            exists = true;
            break;
        }
    
    if (!exists) {
        dropdown.selectedIndex = 0;
        $('StepTemplate_path').value = '';
    }

    // Show or hide the template selector
    document.getElementById('StepEditTemplateRow').style.display = step.IsCheckout ? 'none' : 'table-row';

    // Show the dialog
    dialog.show('EditStepDialog');
}

function saveStepEdit() {
    var step = steps[$('StepIndex').value];
    step.Name = $('StepName').value;
    step.Template = $('FM_StepTemplate').value;
    step.TemplatePath = $('StepTemplate_path').value;
    updateSteps();         
    dialog.hide('EditStepDialog');
}

function deleteStep(stepIndex) {
    steps.splice(stepIndex, 1);
    updateSteps();
    dialog.hide('EditStepDialog');
}

function addNewStep() {
    steps.push(new Step('Step ' + (steps.length + 1), '', '', false));
    updateSteps();
    editStep(steps.length - 1);
}

function updateSteps() {

    // Check if a checkout step exists
    var checkoutExists = false;
    for(var i = 0; i < steps.length; i++)
        if (steps[i].IsCheckout) {
            checkoutExists = true;
            break;
        }
        if (!checkoutExists)
            steps.push(new Step('Checkout', '', '', true, true, '', '', '', ''));

    // Clear table
    var table = document.getElementById('StepsTable');
    while (table.rows.length > 0)
        table.deleteRow(0);

    // Clear hidden values
    clearHidden('Steps');

    // Add each step
    for (i = 0; i < steps.length; i++) {
        var step = steps[i];
        
        // Add to hidden save values
        addHidden('Steps', 'Step' + (i + 1) + 'Name', step.Name);
        if (step.IsCheckout) {
            addHidden('Steps', 'Step' + (i + 1) + 'Template', '');
            addHidden('Steps', 'Step' + (i + 1) + 'Template_path', '', true);
            addHidden('Steps', 'Step' + (i + 1) + 'IsCheckout', true);
        } else {
            addHidden('Steps', 'Step' + (i + 1) + 'Template', step.Template);
            addHidden('Steps', 'Step' + (i + 1) + 'Template_path', step.TemplatePath, true);
            addHidden('Steps', 'Step' + (i + 1) + 'IsCheckout', false);
        }

        // Add to table
        var row = table.insertRow(table.rows.length);
        row.id = 'StepsRow' + i;
        row.insertCell(row.cells.length).innerHTML = table.rows.length + ':';
        row.insertCell(row.cells.length).innerHTML = step.Name.length > 0 ? step.Name : document.getElementById('Translate_Unnamed').innerHTML;
        
        var editIcon = document.createElement('i');
        editIcon.className = "fa fa-pencil btn btn-flat m-l-5";
        editIcon.title = "Edit";
        editIcon.onclick = new Function("editStep(" + i + ")");

        row.insertCell(row.cells.length).appendChild(editIcon);

        if (step.IsCheckout) {
            row.insertCell(row.cells.length);
        } else {
            var deleteIcon = document.createElement('i');
            deleteIcon.className = "fa fa-remove color-danger btn btn-flat m-l-5";
            deleteIcon.title = "Delete";
            deleteIcon.onclick = new Function("deleteStep(" + i + ")");

            row.insertCell(row.cells.length).appendChild(deleteIcon);
        }
    }
    
    // Make table draggable
    if (steps.length >= 2) {
        var dragAndDropTable = new TableDnD();
        dragAndDropTable.init($('StepsTable'));
        dragAndDropTable.onDrop = function(table, row) {
            // Find old index
            var oldIndex = row.id.substring('StepsRow'.length, row.id.length) * 1;

            // Find new index
            var newIndex = 0;
            for (; ; newIndex++)
                if (table.tBodies[0].rows[newIndex].id == row.id)
                break;

            if (oldIndex == newIndex)
                return;

            // Apply new sort
            var direction = newIndex > oldIndex ? 1 : -1
            for (var i = oldIndex; i != newIndex; i += direction) {
                var temp = steps[i];
                steps[i] = steps[i + direction];
                steps[i + direction] = temp;
            }
            
            // Update
            updateSteps();
            dialog.hide('EditStepDialog');
        }
    }

}    