function changeAmountDisabledState(disabled) {
    $('RefundAmount').disabled = disabled;
}

function validateAmount() {
    var form = document.getElementById("RefundDialog");
    var refundTypeElement = form.elements["RefundType"];
    if (!refundTypeElement || refundTypeElement.value != "FullRefund") {
        var amount = parseFloat($('RefundAmount').value.replace(',', '.'));
        if (amount <= 0.00) {
            showValidationMessage('must be more than zero');
            return false;
        }
        var maxAmount = parseFloat($('MaxRefundAmount').value.replace(',', '.'));

        if (amount > maxAmount) {
            showValidationMessage('must be less or equal ' + maxAmount);
            return false;
        }
    }
    return true;
}

function showValidationMessage(message) {
    var info = getValidationInfoBlick();
    info.innerText = message;
}

function getValidationInfoBlick() {
    var info = $('helpRefundAmount')
    if (!info) {
        var input = $('RefundAmount');
        input.up('.form-group').className = 'form-group has-error';
        info = document.createElement("small");
        info.id = 'helpRefundAmount';
        info.className = "help-block error";
        input.parentElement.appendChild(info);
    }
    return info;
}