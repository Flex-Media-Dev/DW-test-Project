/// <reference path="/Admin/Images/Ribbon/UI/List/List.js"/>

function Order(orderID) {
    this.orderID = orderID;
    this.captureState = '';
    this.isCaptured = false;
    this.isCaptureSupported = true;
    this.isAttemptedCaptured = false;
    this.columns = new Object;
}

var moreOrders = true;
var allOrdersCount = 0;
var allNotSupported = 0;
var allAlreadyCaptured = 0;
var allAttemptedCaptured = 0;
var successfulCaptures = 0;

var orderList = new Array;

function showList() {
    //Flip divs
    $("ListPanel").show();
    $("CapturingPanel").hide();
}

function startCapture() {
    $("ListPanel").hide();
    $("CapturingPanel").show();

    var rows = List.getAllRows('List1');
    allOrdersCount = rows.length;
    for (var i = 0; i < rows.length; i++) {
        var order = new Order;
        var cols = rows[i].select("td");
        order.orderID = cols[0].innerHTML;
        order.columns = cols;

        if (cols[1].innerHTML == orderStateCaptured) {
            cols[1].innerHTML = '<img src="/Admin/Images/Ribbon/Icons/Small/Check_grey.png" alt="" /> ' + orderStateAlreadyCaptured;
            order.isCaptured = true;
            allAlreadyCaptured++;
        }
        if (cols[1].innerHTML == orderStateNotSupported) {
            cols[1].innerHTML = '<img src="/Admin/Images/Icons/Alert_Small.gif" alt="" /> ' + orderStateNotSupported;
            order.isCaptureSupported = false;
            allNotSupported++;
        }

        if (order.isCaptureSupported && !order.isCaptured) {
            orderList.push(order);
        } else {
            allAttemptedCaptured++;
            reportCount();
        }
    }

    moreOrders = orderList.length > 0;
        
    captureNext();
}

function reportCount() {
    $("CounterPanel").innerHTML = orderCaptureCounter.replace("%%", allAttemptedCaptured).replace("&&", allOrdersCount);
}

function Capture(order) {
    allAttemptedCaptured++;
    reportCount();

    new Ajax.Request('OrderBulkCapture.aspx?AJAX=Capture&CaptureOrderID=' + order.orderID, {
        onSuccess: function(response) {
            var orderCaptureState;
            
            try {
                // Get values from response
                var jsonObj = response.responseText.evalJSON();
                orderCaptureState = jsonObj.orderCaptureState;
            } catch(e) {
                orderCaptureState = 'Failed';
            } 

            // Set the order values
            setComplete(order, orderCaptureState || 'Failed');
        },

        onFailure: function() {
            //alert('Something went wrong!');
            order.isCaptured = false;
        },

        onComplete: function() {
            captureNext();
        }

    });
}

function setComplete(order, captureState) {
    order.isAttemptedCaptured = true;
    order.captureState = captureState;
    if (captureState == "Success") {
        order.isCaptured = true;
        order.columns[1].innerHTML = '<img src="/Admin/Images/Ribbon/Icons/Small/Check.png" alt="" /> ' + orderStateCaptured;
        successfulCaptures++;
    } else {
        order.columns[1].innerHTML = '<img src="/Admin/Images/Icons/Delete_Small.gif" alt="" /> ' + orderStateFailed;
    }

    for (var i = 0; i < orderList.length; i++) {
        if (!orderList[i].isAttemptedCaptured) {
            moreOrders = true;
            break;
        } else
            moreOrders = false;
    }
}

function captureNext() {
    if (moreOrders) {
        var order;
        for (var i = 0; i < orderList.length; i++)
            if (!orderList[i].isAttemptedCaptured) {
            order = orderList[i];
            break;
        }
        Capture(order);
    } else {
        showList();
        alert(orderCaptureStatus.replace("%%", successfulCaptures).replace("&&", orderList.length).replace("##", orderList.length - successfulCaptures).replace("!!", allNotSupported).replace("??", allAlreadyCaptured));
    }
    
}