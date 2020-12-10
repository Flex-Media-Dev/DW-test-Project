function productListEditingInit() {
    window.focus(); // for ie8-ie9

    Dynamicweb.Ajax.add_beforeRequest(function (sender, args) {
        args.get_parameters().set('productColumns', $(hiddenProductColumns).value);
    });

    dwGrid_productFields.onRowAddedCompleted = productList_OnAddRow;

    addTabIndex($('gridcontainer'), true);
}

function productListAddRow() {
    dwGrid_productFields.addRow();
}

function productList_OnAddRow(row) {
    addTabIndex(row.element, true);
}

var tabIndex = 0;
function addTabIndex(container, selectFirst) {
    var fields = container.select('td');
    for (var i = 0; i < fields.length; i++) {
        var td = fields[i];
        if (!!td.className && td.className != "hiddencell") {
            for (var j = 0; j < td.children.length; j++) {
                var ctrl = td.children[j];
                ctrl.setAttribute("tabindex", ++tabIndex);
                if (selectFirst && !ctrl.value) {
                    selectFirst = false;
                    ctrl.focus();
                }
            }
        }
    }
}

function cancel() {
    window.location = "ProductList.aspx?GroupID=" + _groupId + "&restore=true";
}

function help() {
}


//validation
function checkRequired(sender, args) {
    var val = args.Value;
    if (!val || val.trim().length == 0) {
        markControl(sender, false);
        args.IsValid = false;
        return;
    }

    markControl(sender, true);
    args.IsValid = true;
}

function checkInteger(sender, args) {

    var val = args.Value;
    var isnum = val.length = 0 || (!isNaN(val) && Math.round(val) == val);
    if (!isnum) {
        markControl(sender, false);
        args.IsValid = false;
        return;
    }

    markControl(sender, true);
    args.IsValid = true;
}

function checkDecimal(sender, args) {

    var val = args.Value;

    val = val.replace(/[',']+/g, ".");
    var isnum = val.length = 0 || !isNaN(val);

    if (!isnum) {
        markControl(sender, false);
        args.IsValid = false;
        return;
    }

    markControl(sender, true);
    args.IsValid = true;
}

function markControl(sender, isValid) {
    var ctrl = $(sender.controltovalidate);
    if (isValid) {
        ctrl.removeClassName("invalidcell");
    }
    else {
        ctrl.addClassName("invalidcell");
        ctrl.focus();
    }
}

String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, "");
}

function deleteThisRow(obj) {
    var cur_row = dwGrid_productFields.findContainingRow(obj);
    if (cur_row.element.getElementsByClassName("variable-product-minus").length > 0 || cur_row.element.getElementsByClassName("variable-product-plus").length) {
        var delete_elements = document.getElementsByClassName(getProductID(cur_row.element));
        for (var i = delete_elements.length - 1; i >= 0 ; i--) {
            deleteRow(dwGrid_productFields.findContainingRow(delete_elements[i]));
        }
    }
    else if (cur_row.element.getElementsByClassName("bottom-variant").length > 0) {
        var changed_elements = document.getElementsByClassName(getProductID(cur_row.element));
        if (changed_elements.length == 2) {
            var headElement = changed_elements[0];
            headElement.removeClassName("variable-product-minus");
            headElement.addClassName("non-variant-product");
            headElement.attributes.removeNamedItem("onclick");
        }
        else {
            var upElement = changed_elements[changed_elements.length - 2];
            upElement.removeClassName("variant");
            upElement.addClassName("bottom-variant");
        }
        deleteRow(cur_row);
    }
    else {
        deleteRow(cur_row);
    }
}

function getProductID(row) {
    var cell = row.getElementsByClassName("prod-id")[0];
    for (var i = 0; i < cell.classList.length; i++) {
        if (~cell.classList[i].indexOf("PROD")) {
            return cell.classList[i];
        }
    }
}

function deleteRow(row) {
    for (var i = Page_Validators.length - 1; i >= 0; i--)
        if (Page_Validators[i].id.indexOf(row.element.id) == 0)
            Page_Validators.splice(i, 1);
    dwGrid_productFields.deleteRows([row]);
}

function handleRowSelected(obj) {
    row = dwGrid_productFields.findContainingRow(obj);
    if (row)
        try {
            var rows = dwGrid_productFields.rows.getAll();
            for (var i = 0; i < rows.length; i++) {
                var currentRow = rows[i];
                var actionId = currentRow.element.id + "_DeleteAction";
                if (currentRow.rowIndex == row.rowIndex) {
                    currentRow.findControl(actionId).style.visibility = "visible";
                } else {
                    currentRow.findControl(actionId).style.visibility = "hidden";
                }
            }
        } catch (e) {

        }
}

function ExpandTree(obj) {
    var cur_row = dwGrid_productFields.findContainingRow(obj);
    var elements = document.getElementsByClassName(getProductID(cur_row.element));

    var collapse = elements[0].attributes.getNamedItem("__collapse").value == 'false' ? 'true' : 'false';
    elements[0].children[0].removeClassName(collapse == 'true' ? "fa fa-caret-down" : "fa fa-caret-right");
    elements[0].children[0].addClassName(collapse == 'true' ? "fa fa-caret-right" : "fa fa-caret-down");
    elements[0].attributes.getNamedItem("__collapse").value = collapse;

    for (var i = 1 ; i < elements.length; i++) {
        elements[i].parentNode.style.display = elements[i].parentNode.style.display == 'none' ? 'table-row' : 'none';
    }
}