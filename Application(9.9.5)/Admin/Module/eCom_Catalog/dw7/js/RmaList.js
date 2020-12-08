function enableResetButton() {
    Ribbon.enableButton('ButtonReset');
}
function ResetFilters() {
    if (typeof shopId === "undefined")
    location = 'RmaList.aspx?ResetFilters=True';
    else {
        location = 'RmaList.aspx?ResetFilters=True&shopid=' + shopId;
    } 
}
function rowSelected() {
    if (getSelectedRows().length > 0) {
        Ribbon.enableButton('ButtonDelete');
        Ribbon.enableButton('ButtonChangeState');
    } else {
        Ribbon.disableButton('ButtonDelete');
        Ribbon.disableButton('ButtonChangeState');
    }
}

function getSelectedRows() {
    var rows = new Array;
    
    // The item that is right clicked
    if (ContextMenu.callingItemID != null) rows[0] = ContextMenu.callingItemID;
    
    // The selected items in the list (will overwrite the right clicked item if any exists)
    var selectedRows = List.getSelectedRows('ListOfRmas');
    if (selectedRows.length > 0) {
        for (var i = 0; i < selectedRows.length; i++) {
            rows[i] = selectedRows[i].attributes['itemid'].value;
        }
    }
    return rows;
}

function deleteRmas() {
    if (getSelectedRows().length = 0)
        return false;
    var selectedRows = List.getSelectedRows('ListOfRmas');
    for (var i = 0; i < selectedRows.length; i++)
        selectedRmas.value += (i > 0 ? ',' : '') + selectedRows[i].id;
    clearSelectedRows();
    action.value = "delete";

    List._submitForm('List');
}

function setSelectedRows() {
    selectedRmas = "";
    var selectedRows = List.getSelectedRows('ListOfRmas');
    for (var i = 0; i < selectedRows.length; i++)
        selectedRmas.value += (i > 0 ? ',' : '') + selectedRows[i].id;
    clearSelectedRows();

}


// Unchecks all rows
function clearSelectedRows() {
    var rows = List.getSelectedRows('List');
    for (var i = 0; i < rows.length; i++)
        List.setRowSelected("List", rows[i], false);
}

function changeState() {

    if (getSelectedRows().length = 0)
        return false;
    var selectedRows = List.getSelectedRows('listOfRmas');
    for (var i = 0; i < selectedRows.length; i++)
        selectedRmas.value += (i > 0 ? ',' : '') + selectedRows[i].id;
    clearSelectedRows();
    action.value = "setState";

    List._submitForm('List');
}

//function help(){
//		<%=Dynamicweb.Gui.Help("", "ecom.rma", "en") %>
//}

function resizeContentPane(contentPaneID, ribbonBarID) {
    var ribbonHeight;
    if (ribbonBarID != undefined && $(ribbonBarID) != null)
        ribbonHeight = $(ribbonBarID).offsetHeight;
    else
        ribbonHeight = 0;

    if (contentPaneID != undefined && $(contentPaneID) != null) {
        var contentPaneHeight = (document.body.clientHeight - ribbonHeight);
        if (contentPaneHeight < 0) {
            contentPaneHeight = 1;
        }

        var screenContainerPadding = 32; // 16*2
        if (document.getElementsByClassName("screen-container").length > 0) {
            contentPaneHeight -= screenContainerPadding;
        }

        $(contentPaneID).style.height = contentPaneHeight + 'px';
    }
}
