// Global variables
var urlParameters;
var windowOnResize;

var OrderListPanelClientID;
var PrintPreviewPanelClientID;
var orderStateListClientID;

// Action
var actionHidden;
var orderIDsHidden;
var deleteSingleConfirmText;
var deleteMultiConfirmText;

// Print
var printMultiConfirmText;
var printMoreThanMaxOrdersText;
var orderCount;
var maxNumberOfOrdersToPrint;

var createRmaConfirmationText;

var orderListHelp;

// Set List height
window.onload = function () {
    var deferredStretchedContainerRecalc = dwGlobal.debounce(function () {
        resizeContentPane("ListContent", "OrderListRibbon");
    }, 200);
    window.onresize = deferredStretchedContainerRecalc
    Ribbon.add_stateChanged(deferredStretchedContainerRecalc);
    window.onresize();
    var forms = document.getElementsByTagName('form');
    for (var i = 0; i < forms.length; i++) {
        var frm = forms[i];
        var onEnterPressHandler = frm.getAttribute("data-onpress-enter-handler");
        frm.onkeypress = function (event) {
            if (event.keyCode == 13 && event.target.type.toLowerCase() !== "textarea") {
                event.preventDefault();
                var isEnterHandled = false;
                if (onEnterPressHandler && window[onEnterPressHandler]) {
                    isEnterHandled = window[onEnterPressHandler](event, frm);
                }
                if (!isEnterHandled) {
                    this.submit();
                }
            }
        }
    };
}


function helpOL() {
    orderListHelp();
}


function PerformAction(action) {
    var rows = getSelectedOrders();
    if (rows.length == 0)
        return;

    // Set order ids
    orderIDsHidden.value = '';
    for (var i = 0; i < rows.length; i++)
        orderIDsHidden.value += (i > 0 ? ',' : '') + rows[i];

    // Set Action
    actionHidden.value = action;

    // Clear selection
    clearSelectedRows();

    // Submit
    List._submitForm('List');
}

function deleteOrder() {
    var selectedRows = getSelectedOrders();

    var confirmText;
    if (selectedRows.length == 1)
        confirmText = deleteSingleConfirmText.replace('%%', selectedRows[0]);
    else
        confirmText = deleteMultiConfirmText.replace('%%', selectedRows.length);

    if (confirm(confirmText))
        PerformAction('DeleteOrders');
}
function createRma(confirmationText) {
    var selectedRows = getSelectedOrders();
    if (selectedRows.length == 1) {
        location.href = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomRma_Edit.aspx?OrderID=" + selectedRows;

    }       //create RMA for row confirmText = deleteSingleConfirmText.replace('%%', selectedRows[0]);
    else {
        confirm(confirmationText);

    }
}

function setOrderState(orderState) {
    $('SelectedOrderStateID').value = orderState;
    PerformAction('SetOrderState');
}

function exportOrder() {
    alert("export");
}

function showOrder(shopId) {
    viewOrder(ContextMenu.callingItemID, null, shopId);
}

function viewOrder(orderID, fullEdit, shopId) {
    if (!!fullEdit) {
        parent.document.location.href = '/Admin/Module/eCom_Catalog/dw7/Edit/EcomOrder_Edit.aspx?Caller=usermanagement&ID=' + orderID;
    }
    if (getInternetExplorerVersion() > 7) {
        var ids = $('List_body').select('tr[itemid]').invoke('getAttribute', 'itemid').join(',');
        $('orderIds').value = ids;
    }
    var orderType = "";
    if ($F("isQuotes") == "True") orderType = "&OrderType=quotes";
    else if ($F("isRecurringOrders") == "True") orderType = "&OrderType=recurringorders";
    else if ($F("IsLedgerEntries") == "True") orderType = "&OrderType=LedgerEntries";
    else if ($F("IsCarts") == "True") orderType = "&OrderType=Cart";

    var shopIdParam = "";
    if (typeof shopId == "string" && shopId.length > 0) {
        shopIdParam = "&ShopId=" + shopId;
    }

    theForm.action = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomOrder_Edit.aspx?ID=" + orderID + orderType + shopIdParam;
    theForm.__VIEWSTATE.value = "";
    theForm.submit();
}

function getInternetExplorerVersion()
    // Returns the version of Internet Explorer or a 10
    // (indicating the use of another browser).
{
    var rv = -1; // Return value assumes failure.
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null)
            rv = parseFloat(RegExp.$1);
    }
    else rv = 10;
    return rv;
}

function printOrder(orderId) {
    urlParameters = "orderIds=" + orderId;
    reloadPrintPreview();
    showPrintPreview();
}

function printOrders() {
    urlParameters = "";
    var rowCount = 0;
    var rows = getSelectedOrders();
    if (rows.length > 0) {
        var orderIDs = '';
        for (var i = 0; i < rows.length; i++) {
            orderIDs += (i > 0 ? ',' : '') + rows[i];
        }
        urlParameters = "orderIds=" + orderIDs;
        rowCount = rows.length;
    } else {
        urlParameters = "orderIds=";
        rowCount = orderCount;
    }

    var numOrdersToPrint = rowCount;
    if (numOrdersToPrint > maxNumberOfOrdersToPrint)
        numOrdersToPrint = maxNumberOfOrdersToPrint;

    var confirmText = printMultiConfirmText.replace('%%', numOrdersToPrint);
    if (rowCount > maxNumberOfOrdersToPrint)
        confirmText += '\n' + printMoreThanMaxOrdersText.replace('%%', rowCount);

    if (rowCount == 1 || confirm(confirmText)) {
        reloadPrintPreview();
        showPrintPreview();
    }
}

function processPrinting() {
    window.open("/Admin/Module/eCom_Catalog/dw7/PrintPopup.aspx", "Print");
}

function showPrintPreview() {
    //Set size of PrintContent div
    $(OrderListPanelClientID).hide();
    $(PrintPreviewPanelClientID).show();
    windowOnResize = window.onresize;
    window.onresize = function () { resizeContentPane("PrintContent", "PrintRibbon"); }
    window.onresize();
}

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

function closePrintPreview() {
    queryString.init(location.href);
    var isPrint = queryString.get("print");
    var caller = queryString.get("Caller");

    if (caller && caller == "usermanagement") {
        location.href = "/Admin/Module/Usermanagement/Main.aspx?Action=ViewOrders&UserID=" + queryString.get("AccessUserId");
        return;
    }
    else if (isPrint && isPrint == "true") {
        viewOrder(queryString.get("printOrderId"));
        return;
    }

    $(OrderListPanelClientID).show();
    $(PrintPreviewPanelClientID).hide();
    window.onresize = windowOnResize;
    //clearSelectedRows(); 9197
}

function reloadPrintPreview() {
    var currentTemplate = $('FM_PrintTemplate').value;

    var url = '/Admin/Module/eCom_Catalog/dw7/PrintOrders.aspx?' + urlParameters + '&template=' + currentTemplate + '&timestamp=' + new Date().getTime();

    showPrintDiv('PrintLoading');
    new Ajax.Request(url, {
        onSuccess: function (response) {

            // Update div        
            $('PrintContent').innerHTML = response.responseText;

            // Show div
            showPrintDiv('PrintContent');
        },

        onFailure: function () {
            showPrintDiv('PrintError');
        }
    });

}

function showPrintDiv(divName) {
    var divs = ['PrintLoading', 'PrintContent', 'PrintError'];
    for (var i = 0; i < divs.length; i++) {
        var div = $(divs[i]);
        if (div) div.style.display = divs[i] == divName ? 'block' : 'none';
    }
}

function getSelectedOrders() {
    var rows = new Array;

    // The item that is right clicked
    if (ContextMenu.callingItemID != null) rows[0] = ContextMenu.callingItemID;

    // The selected items in the list (will overwrite the right clicked item if any exists)
    var selectedRows = List.getSelectedRows('List');
    if (selectedRows.length > 0) {
        for (var i = 0; i < selectedRows.length; i++) {
            rows[i] = selectedRows[i].attributes['itemid'].value;
        }
    }

    return rows;
}

function checkDeleteSelectedOrders() {
    var selectedOrders = getSelectedOrders();
    var rowsArray = List.getAllRows('List').filter(item => selectedOrders.includes(item.attributes['itemid'].value));
    return checkDeleteOrders(rowsArray);
}

function checkDeleteOrder(orderId) {
    var rowsArray = List.getAllRows('List').filter(item => item.attributes['itemid'].value == orderId);
    return checkDeleteOrders(rowsArray);
}

function checkDeleteOrders(rowsArray) {
    var ordersCanBeDeleted = false;

    if (rowsArray.length > 0) {
        ordersCanBeDeleted = true;

        for (var i = 0; i < rowsArray.length; i++) {
            if (!ordersCanBeDeleted) break;

            var deleteAttribute = rowsArray[i].attributes['data-order-can-be-deleted'];
            if (deleteAttribute) {
                ordersCanBeDeleted = ordersCanBeDeleted && (deleteAttribute.value == 'true');
            } else {
                ordersCanBeDeleted = false;
            }
        }
    }

    return ordersCanBeDeleted;
}

// Unchecks all rows
function clearSelectedRows() {
    var rows = List.getSelectedRows('List');
    for (var i = 0; i < rows.length; i++)
        List.setRowSelected("List", rows[i], false);
}



// This is executed when a preset is selected in the preset dropdown
function setDatePreset() {
    var fromDatePrefix = 'FromDateFilter:DateSelector';
    var toDatePrefix = 'ToDateFilter:DateSelector';
    var presetFilter = document.getElementById('List:DatePresetFilter');
    var preset = presetFilter.value;
    var datepicker = Dynamicweb.UIControls.DatePicker.get_current();

    var today = new Date();
    today.setHours(0, 0, 0, 0);

    presetFilter.setAttribute("disableReseting", true);

    if (preset == 'All_Time') {
        datepicker.ClearDate(fromDatePrefix)
        datepicker.ClearDate(toDatePrefix)
    } else if (preset == 'Today') {
        datepicker.UpdateCalendarDate(today, fromDatePrefix);
        datepicker.UpdateCalendarDate(today, toDatePrefix);
    } else if (preset == 'Last_Week') {
        var lastWeek = new Date()
        lastWeek.setHours(0, 0, 0, 0);
        lastWeek.setTime(lastWeek.getTime() - 1000 * 60 * 60 * 24 * 6);
        datepicker.UpdateCalendarDate(lastWeek, fromDatePrefix);
        datepicker.UpdateCalendarDate(today, toDatePrefix);
    } else if (preset == 'Last_Month') {
        var lastMonth = new Date()
        lastMonth.setHours(0, 0, 0, 0);
        let month = lastMonth.getMonth() - 1;
        if (month == -1)
            lastMonth.setFullYear(lastMonth.getFullYear() - 1, 11);
        else
            lastMonth.setMonth(month)
        datepicker.UpdateCalendarDate(lastMonth, fromDatePrefix);
        datepicker.UpdateCalendarDate(today, toDatePrefix);
    } else if (preset == 'Last_6_Months') {
        var last6Months = new Date()
        last6Months.setHours(0, 0, 0, 0);
        let month = last6Months.getMonth() - 6;
        if (month < 0)
            last6Months.setFullYear(last6Months.getFullYear() - 1, month + 12);
        else
            last6Months.setMonth(month)
        datepicker.UpdateCalendarDate(last6Months, fromDatePrefix);
        datepicker.UpdateCalendarDate(today, toDatePrefix);
    } else if (preset == 'Last_Year') {
        var lastYear = new Date()
        lastYear.setHours(0, 0, 0, 0);
        lastYear.setFullYear(lastYear.getFullYear() - 1);
        datepicker.UpdateCalendarDate(lastYear, fromDatePrefix);
        datepicker.UpdateCalendarDate(today, toDatePrefix);
    }

    presetFilter.removeAttribute("disableReseting");
}

// Reset preset filter selection
function resetDatePreset() {
    var presetFilter = document.getElementById('List:DatePresetFilter');

    if (presetFilter && !presetFilter.hasAttribute("disableReseting") && presetFilter.value != '')
        presetFilter.selectedIndex = 0;
}

function ResetFilters() {
    var res = location.search;
    while (res.indexOf('ResetFilters=True') >= 0 || res.indexOf('ResetFilters=False') >= 0 || res.indexOf('&&') >= 0 || res.indexOf('?&') >= 0) {
        res = res.replace('ResetFilters=True', '')
        res = res.replace('ResetFilters=False', '')
        res = res.replace('&&', '')
        res = res.replace('?&', '?')
    }
    res += (res.indexOf('?') < 0) ? '?' : '&';
    location = location.pathname + res + 'ResetFilters=True';
}

function SaveCollapseState(isCollapsed) {
    new Ajax.Request('/Admin/Module/eCom_Catalog/dw7/OrderList.aspx?AJAX=' + (isCollapsed ? 'FiltersCollapsed' : 'FiltersUnCollapsed'));
}

function enableResetButton() {
    Ribbon.enableButton('ButtonReset');
}

function captureOrders() {
    var rows = getSelectedOrders();

    if (rows.length > 1 && confirm("You are about to capture " + rows.length + " order(s). This action is not possible to undo.\nAre you sure you wish to continue?")) {
        var ids = "";
        for (var i = 0; i < rows.length; i++) {
            if (ids.length > 0)
                ids += ",";
            ids += rows[i];
        }
        //Maybe this should be a Dialog control instead.
        window.open("/Admin/Module/eCom_Catalog/dw7/OrderBulkCapture.aspx?IDs=" + ids, "BulkCapture");
    }
    else if (rows.length == 1) {
        var url = '/Admin/Module/eCom_Catalog/dw7/OrderCapture.aspx?ID=' + rows[0];
        var dialogFrame = document.getElementById("CaptureDialogFrame");
        dialogFrame.writeAttribute('src', url);
        dialog.show("CaptureDialog");
    }
}

function createShippingDocuments() {
    var rows = getSelectedOrders()
    orderIDs = rows.join(',');

    if (confirm("You are about to create shipping documents for " + rows.length + " order(s). This action is not possible to undo.\nAre you sure you wish to continue?")) {
        window.open("/Admin/Module/eCom_Catalog/dw7/CreateShippingDocuments.aspx?orderIDs=" + encodeURIComponent(orderIDs), "PrintShippingDocuments");
    }
}

function setupWizardShow() {
    dialog.show('SetupWizardDialog');
    document.getElementById("SetupWizardDialogFrame").src = "/Admin/Module/eCom_Catalog/dw7/Wizard/SetupWizard.aspx";
}

function setupWizardHide() {
    dialog.hide('SetupWizardDialog');
}
