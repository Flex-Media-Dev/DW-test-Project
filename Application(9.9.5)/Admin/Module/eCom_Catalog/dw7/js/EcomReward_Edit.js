if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.eCommerce) == 'undefined') {
    Dynamicweb.eCommerce = new Object();
}

if (typeof (Dynamicweb.eCommerce.Loyalty) == 'undefined') {
    Dynamicweb.eCommerce.Loyalty = new Object();
}

Dynamicweb.eCommerce.Loyalty.Reward = function () { };

Dynamicweb.eCommerce.Loyalty.Reward.selectedRow = null;

Dynamicweb.eCommerce.Loyalty.Reward.rewardUsage = false;
Dynamicweb.eCommerce.Loyalty.Reward.deleteRewardMessage = '';
Dynamicweb.eCommerce.Loyalty.Reward.popUp = null;
Dynamicweb.eCommerce.Loyalty.Reward.confirmDeleteMessage = '';
Dynamicweb.eCommerce.Loyalty.Reward.errorPointsMessage = '';
Dynamicweb.eCommerce.Loyalty.Reward.ErrorEmptyRuleName = "Name can't be empty!"

Dynamicweb.eCommerce.Loyalty.Reward.showUsage = function () {
    dialog.show("UsageDialog");
};

Dynamicweb.eCommerce.Loyalty.Reward.deleteReward = function () {
    if (confirm(this.deleteRewardMessage)) {
        document.getElementById('Form1').DeleteButton.click();
    }
};

Dynamicweb.eCommerce.Loyalty.Reward.save = function (close) {
    if (this.validate()) {
        document.getElementById("Close").value = close ? 1 : 0;
        document.getElementById('Form1').SaveButton.click();
    }
};

Dynamicweb.eCommerce.Loyalty.Reward.validate = function () {
    var isValid = true;
    var el = $("NameStr");    
    var name = el.value;
    if (name.length == 0) {
        var err = $("errNameStr");
        err.style.display = "";
        el.focus();
        isValid = false;
    }
    var elem = document.getElementById("errType")
    if (!(document.getElementById("rFixed").checked || document.getElementById("rPercent").checked)) {
        elem.style.color = "red";
        elem.style.display = "block";
        isValid = false;
    }
    else {
        elem.style.color = "black";
        elem.style.display = "none";
    }
    return isValid;
};

Dynamicweb.eCommerce.Loyalty.Reward.rFixed_CheckedChanged =  function () {
    var fixed = document.getElementById("rFixed").checked
    var percents = document.getElementById("rPercent").checked

    var eFix = document.getElementsByClassName("fix")
    var ePercent = document.getElementsByClassName("percent")
    var fixClass = "fix" + (fixed ? "" : " hidden");
    var percentClass = "percent" + (percents ? "" : " hidden");
    for (var i = 0; i < (eFix ? eFix.length : 0) ; i++) {
        eFix[i].className = fixClass;
    }
    for (var i = 0; i < (ePercent ? ePercent.length : 0) ; i++) {
        ePercent[i].className = percentClass;
    }
    var focusElem = function (elemId) {
        var elem = document.getElementById(elemId);
        elem.focus();
        if (elem.select) {
            elem.select();
        }
    };
    if (fixed) {
        addNumericRestriction("pointsNum", this.errorPointsMessage);
        document.getElementById("pointsPercent").removeAttribute('valregex');
        focusElem("pointsNum");
    } else if (percents) {
        document.getElementById("pointsNum").removeAttribute('valregex');
        addNumericRestriction("pointsPercent", this.errorPointsMessage);
        focusElem("pointsPercent");
    }
};

$(document).observe('dom:loaded', function () {
    Dynamicweb.eCommerce.Loyalty.Reward.rFixed_CheckedChanged()
    window.focus(); // for ie8-ie9 
    document.getElementById('NameStr').focus();

});

function g_initDefaultVoucherCodeValEditor(editor, meta) {
    var cnt = document.getElementById(editor.get_id());
    var orderFieldType1 = $("OrderFieldType1");
    var orderFieldType2 = $("OrderFieldType2");
    var fieldVal1 = $("orderFieldVal2");
    var fieldVal2 = $("orderFieldVal3");
    var orderFieldSelect = $("OrderField_Editor");
    var ce = {
        container: function () {
            return cnt;
        },
        val: function (obj, undef) {
            var ofv = orderFieldSelect.getValue();
            if (obj === undef) {
                if (ofv == 2) {
                    return {
                        fieldType: orderFieldType1.checked ? 1 : 2,
                        fieldVal: orderFieldType1.checked ? fieldVal1.getValue() : fieldVal2.getValue()
                    };
                } else {
                    return {
                        fieldType: 1,
                        fieldVal: ""
                    };
                }
            } else {
                if (!obj || obj === "") {
                    obj = {
                        fieldType: 1,
                        fieldVal: ""
                    };
                }
                if (obj.fieldType == 1) {
                    orderFieldType1.checked = true;
                    orderFieldType2.checked = false;
                    fieldVal1.setValue(obj.fieldVal);
                } else if (obj.fieldType == 2) {
                    orderFieldType1.checked = false;
                    orderFieldType2.checked = true;
                    fieldVal2.setValue(obj.fieldVal);
                }
            }
        }
    }
    return ce;
};

function orderFieldsOptionchanged() {
    var orderFieldSelect = $("OrderField_Editor");
    var parentContainer = orderFieldSelect.up("div.editor-container");
    var orderFieldValueDiv = parentContainer.next("div.editor-container");
    var defaultVoucherCodeValDiv = orderFieldValueDiv.next("div.editor-container");
    var orderFieldType2 = $("OrderFieldType1");
    var orderFieldType3 = $("OrderFieldType2");
    var fieldVal1 = $("OrderFieldValue_Editor");
    var fieldVal2 = $("orderFieldVal2");
    var fieldVal3 = $("orderFieldVal3");
    var index = orderFieldSelect.getValue() || "1";
    if (index == "1") {
        orderFieldValueDiv.hide();
        defaultVoucherCodeValDiv.hide();
    } else if (index == "2") {
        orderFieldValueDiv.hide();
        if (orderFieldType2.checked || !orderFieldType2.checked && !orderFieldType3.checked) {
            orderFieldVal2.show();
            orderFieldVal3.hide();
        } else if (orderFieldType3.checked) {
            orderFieldVal3.show();
            orderFieldVal2.hide();
        }
        defaultVoucherCodeValDiv.show();
    } else {
        orderFieldValueDiv.show();
        defaultVoucherCodeValDiv.hide();
    }
}

Dynamicweb.Ajax.ControlManager.get_current().add_controlReady('Rules', function (control) {
    var validationFn = function (sender, args) {
        var ruleName = args.row.get_propertyValue("Name").trim();
        if (ruleName.length == 0) {
            alert(Dynamicweb.eCommerce.Loyalty.Reward.ErrorEmptyRuleName);
            args.cancel = true;
        }
    }
    control.add_rowCreating(validationFn);
    control.add_rowUpdating(validationFn);
    control.add_editDataBinded(function () {
        orderFieldsOptionchanged();
    });

    var orderFieldSelect = $("OrderField_Editor");
    var orderFieldType1 = $("OrderFieldType1");
    var orderFieldType2 = $("OrderFieldType2");
    orderFieldSelect.on("change", orderFieldsOptionchanged);
    orderFieldType1.on("change", orderFieldsOptionchanged);
    orderFieldType2.on("change", orderFieldsOptionchanged);
});



