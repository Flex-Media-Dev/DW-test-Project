function setCaptureDialog() {
    var CaptureInfo_Split = $('CaptureInfo_Split');
    var CaptureInfo_Captured = $('CaptureInfo_Captured');
    var CaptureInfo_Captured_Success = $('CaptureInfo_Captured_Success');
    var CaptureInfo_Captured_Failure = $('CaptureInfo_Captured_Failure');
    var CaptureInfo_NotCaptured = $('CaptureInfo_NotCaptured');
    var CaptureInfo_NotSupported = $('CaptureInfo_NotSupported');
    var CaptureButton = $('CaptureButton');

    
    if (orderCaptureSupported) {
        if (orderCaptureState == 'NotCaptured') {
            CaptureInfo_Captured.hide();
            CaptureInfo_NotCaptured.show();
            CaptureInfo_NotSupported.hide();
            CaptureButton.disabled = false;
        } else {
            CaptureInfo_Captured.show();
            CaptureInfo_NotCaptured.hide();
            CaptureInfo_NotSupported.hide();
            if (orderCaptureState == 'Success') {
                CaptureInfo_Split.hide();
                CaptureInfo_Captured_Success.show();
                CaptureInfo_Captured_Failure.hide();
                CaptureButton.disabled = true;
                $('sectionAction').hide();
            } 
            else if (orderCaptureState == 'Split') {
                CaptureInfo_Split.show();
                CaptureInfo_Captured_Success.hide();
                CaptureInfo_Captured_Failure.hide();
                CaptureButton.disabled = false;
                $('chkPartialCapture').checked = true;
            }
            else {
                CaptureInfo_Split.hide();
                CaptureInfo_Captured_Success.hide();
                CaptureInfo_Captured_Failure.show();
                CaptureButton.disabled = false;
            }
        }
        if (orderPartialCaptureSupported) {
            if (orderCaptureState != 'Success') {
                $('tblCapturePartial').show();
                togglePartialCapture();
            }
            if (orderCaptureState != 'NotCaptured') {
                $('sectionHistory').show();
            }
        }
    }
    else {
        CaptureInfo_Split.hide();
        CaptureInfo_Captured.hide();
        CaptureInfo_NotCaptured.hide();
        CaptureInfo_NotSupported.hide();
        CaptureButton.disabled = true;
    }

    $('Capture_Date').innerHTML = orderCaptureInfoDate;
    $('Capture_Message').innerHTML = orderCaptureMessage;
}

function togglePartialCapture() {
    if ($('chkPartialCapture').checked) {
        $('rowCaptureAmount').show();
        $('rowFinalCapture').show();
    }
    else {
        $('rowCaptureAmount').hide();
        $('rowFinalCapture').hide();
    }
}

function addHistory(msgDate, msgText, msgAmount) {
    var table = $('tblCaptureHistory');
    if (table) {
        var row = table.insertRow(0);
        var cell1 = row.insertCell(0);
        cell1.innerHTML = msgDate;
        var cell2 = row.insertCell(1);
        cell2.innerHTML = msgText;
        var cell3 = row.insertCell(2);
        cell3.innerHTML = msgAmount;
    }
}

function Capture() {
    // Show loading gif
    $('Capture_Loading').show();
    $('CaptureInfo').hide();
    $('CaptureButton').disabled = true;

    var captureAmount = 0;
    var finalCapture = false;
    var splitAmount = false;
    if (orderPartialCaptureSupported) {
        splitAmount = $('chkPartialCapture').checked;
        captureAmount = $('txtCaptureAmount').value;
        finalCapture = $('chkFinalCapture').checked;
    }

    new Ajax.Request('OrderCapture.aspx?AJAX=Capture', {
        parameters: {
            CaptureOrderID: orderID,
            CaptureAmount: captureAmount,
            FinalCapture: finalCapture,
            SplitAmount: splitAmount
        },
        onSuccess: function (response) {

            // Get values from response
            var jsonObj = response.responseText.evalJSON();
            orderCaptureState = jsonObj.orderCaptureState;
            orderCaptureInfoDate = jsonObj.orderCaptureInfoDate;
            orderCaptureMessage = jsonObj.orderCaptureMessage;
            if (jsonObj.orderCaptureAmount) {
                $('txtCaptureAmount').value = jsonObj.orderCaptureAmount;
            }
            if (jsonObj.orderCaptureHistoryMsg) {
                addHistory(jsonObj.orderCaptureInfoDate, jsonObj.orderCaptureHistoryMsg, jsonObj.orderCaptureHistoryAmount);
            }
            // Set the dialog values
            setCaptureDialog();
        },

        onFailure: function () {
            alert('Something went wrong!');
        },

        onComplete: function () {
            // Hide the loading div again
            $('Capture_Loading').hide();
            $('CaptureInfo').show();
        }

    });

}