function recursivelyTickCheckBoxes(elementId) {
    var element = document.getElementById(elementId); //checkbox
    var checkboxContainer = element.parentNode.parentNode.parentNode; //closest groupbox parent            
    var checkedOrNot = ':checked';

    if (element.checked) {
        checkedOrNot = ':not(:checked)';
    }
    var query = '[type="checkbox"]:not(:disabled)' + checkedOrNot;
    var descendants = checkboxContainer.querySelectorAll(query);
    for (i = 0; i < descendants.length; ++i) {
        descendants[i].checked = element.checked;
    }

    allowTransfer();
    allowExport();
}

function clickedDataItemCheckbox(element) {
    allowTransfer(element);
    allowExport(element);
}

function allowTransfer(element) {
    if (document.getElementById("cmdTransfer")) {
        if (element && element.checked) {
            Toolbar.setButtonIsDisabled("cmdTransfer", false);
        }
        else {
            Toolbar.setButtonIsDisabled("cmdTransfer", document.querySelector('[type="checkbox"][name="dataItem"]:checked') == null);
        }
    }
}
function allowExport(element) {
    if (document.getElementById("cmdExport")) {
        if (element && element.checked) {
            Toolbar.setButtonIsDisabled("cmdExport", false);
        }
        else {
            Toolbar.setButtonIsDisabled("cmdExport", document.querySelector('[type="checkbox"][name="dataItem"]:checked') == null);
        }
    }
}
function SubmitFormWithAction(actionValue) {
    var deploymentAction = document.getElementById("deploymentAction");
    deploymentAction.value = actionValue;
    document.getElementById("dataGroupForm").submit();
}
function CompareButtonClicked() {
    SubmitFormWithAction("Compare");
}
function SelectButtonClicked() {
    SubmitFormWithAction("Select");
}
function TransferButtonClicked() {
    SubmitFormWithAction("Transfer");
}
function ExportButtonClicked() {
    document.getElementById("packageName").value = document.getElementById("exportDefaultName").value;
    dialog.show("ExportPackageDialog");
}
function exportSelected() {
    showOverlay("deploymentOverlay");
    SubmitFormWithAction("Export");
}

function Cancel() {
    var dataGroupId = document.getElementById("dataGroupId");
    location.href = "DeploymentConfiguration.aspx?dataGroupId=" + dataGroupId.value;
}
function showComparisonDetails(dataGroupId, dataItemTypeId, dataItemId) {
    var destinationId = document.getElementById('destinationId').value;
    dialog.show("ComparisonDetailsDialog", '/Admin/Content/Management/Deployment/ComparisonDetails.aspx?dataGroupId=' + encodeURIComponent(dataGroupId) + '&dataItemTypeId=' + encodeURIComponent(dataItemTypeId) + '&dataItemId=' + encodeURIComponent(dataItemId) + '&destinationId=' + encodeURIComponent(destinationId));
}
function filterDataGroupsClicked(filter) {
    document.querySelectorAll("tr.comparison-" + filter.value).forEach(
        function (row) {
            row.classList.toggle("hidden");
            var checkbox = row.querySelector("input");
            if (checkbox && !checkbox.disabled) {
                checkbox.name = filter.checked ? "dataItem" : "";
            }
        }
    );
    allowTransfer();
    allowExport();
}
