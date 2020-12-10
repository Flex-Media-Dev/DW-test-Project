/// <reference path="queryString.js" />
/// <reference path="hotkeys.js" />

Hotkeys.excludeInputsAndTextArea = false;
Hotkeys.bind("ctrl+s", function () {
    $("btnSaveProduct").onclick();
});


var Tabs = {
    tab: function (aciveID) {
        for (var i = 1; i < 16; i++) {
            if ($("Tab" + i)) {
                $("Tab" + i).style.display = "none";
            }
        }
        if ($("Tab" + aciveID)) {
            $("Tab" + aciveID).style.display = "";
        }
    }
}

var _tabNum = null;
var _tabName = null;
var _onloaded = null;

function ribbonTab(name, num, onloaded) {
    _onloaded = onloaded;
    _tabNum = num;
    _tabName = name;

    Tabs.tab(num); 
    TabLoader(name);

    $('Tab').value = num;
    $('TabName').value = name;
}

function checkTab(name, num, onloaded) {
    if (_tabNum != num) {
        ribbonTab(name, num, onloaded);
    }
    else {
        onloaded();
    }
}

function submitCurrentTab() {
    ProductEdit.save();
}

function cancel() {
    ProductEdit.cancel();
}

function isVariantProduct() {
    queryString.init(location.href);
    var variantId = queryString.get("VariantID");

    return variantId && variantId.length > 0
}

function startProductWizard() {
    StartWizard('PRODUCT', _groupId);
}

function help() {
}

function addRelatedGroup(event) {
    ContextMenu.show(event, 'GroupsContext', '', '', 'BottomRight');
}

var _invalidControls = new Hash();

function checkRequired(sender, args) {
    var ctrl = sender.controltovalidate;
    var val = args.Value;
    if (!val || val.trim().length == 0) {
        _invalidControls.set(ctrl, false);
        args.IsValid = false;
    }
    else {
        _invalidControls.unset(ctrl);
        args.IsValid = true;
    }

    showInfobar(sender);
}

function showInfobar(sender) {
    var ctrl = $("validationSummaryInfo");
    if (_invalidControls.size() == 0) {
        ctrl.addClassName("pe-hidden");
    }
    else {
        ctrl.removeClassName("pe-hidden");
    }
}

function productTypeChanged(item, permissionOptions) {
    if (!permissionOptions || permissionOptions.PartListPermission >= PermissionLevels.Read) {
        Ribbon.enableButton('RibbonPartsListsButton');
    }
    if (!permissionOptions || permissionOptions.VariantPermission >=  PermissionLevels.Read) {
        Ribbon.enableButton('RibbonVariantsButton');
    }
    if (!permissionOptions || permissionOptions.StockPermission >=  PermissionLevels.Read) {
        Ribbon.enableButton('RibbonStockButton');
    }
    if (!permissionOptions || permissionOptions.VatGroupPermission >=  PermissionLevels.Read) {
        Ribbon.enableButton('RibbonVATGroupsButton');
    }
    if (!permissionOptions || permissionOptions.DiscountPermission >=  PermissionLevels.Read) {
        Ribbon.enableButton('RibbonDiscountsButton');
    }
    if (!permissionOptions || permissionOptions.PricePermission >=  PermissionLevels.Read) {
        Ribbon.enableButton('RibbonPricesButton');
    }
    document.getElementById("stockDefaultUnitRow").style.display = "";

    var val = item.value;

    if (val == "0") {
        Ribbon.disableButton('RibbonPartsListsButton');
    }
    else if (val == "1") {
        Ribbon.disableButton('RibbonPartsListsButton');
        Ribbon.disableButton('RibbonVariantsButton');
        Ribbon.disableButton('RibbonStockButton');
        document.getElementById("stockDefaultUnitRow").style.display = "none";
    }
    else if (val == "2") {
        document.getElementById("stockDefaultUnitRow").style.display = "none";
    }
    else if (val == "3") {
        Ribbon.disableButton('RibbonPartsListsButton');
        Ribbon.disableButton('RibbonVariantsButton');
        Ribbon.disableButton('RibbonStockButton');
        Ribbon.disableButton('RibbonVATGroupsButton');
        Ribbon.disableButton('RibbonDiscountsButton');
        Ribbon.disableButton('RibbonPricesButton');
        document.getElementById("stockDefaultUnitRow").style.display = "none";
    }
}

String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, "");
}

var alwaysDisabledButtons = null;

/* Toggles saving buttons activity state */
function toggleRibbonButtons(enable) {

    var init = false;
    if (!alwaysDisabledButtons) {
        alwaysDisabledButtons = new Hash();
        init = true;
    }

    toggleRibbonButton('btnSaveProduct', enable, init);
    toggleRibbonButton('btnSaveAndCloseProduct', enable, init);
    toggleRibbonButton('btnCancel', enable, init);
    toggleRibbonButton('RibbonBarButton1', enable, init);
    toggleRibbonButton('RibbonBarButton2', enable, init);
    toggleRibbonButton('cmdOptimize', enable, init);

    toggleRibbonButton('btnMarketingSaveProduct', enable, init);
    toggleRibbonButton('btnMarketingSaveAndCloseProduct', enable, init);
    toggleRibbonButton('btnMarketingCancel', enable, init);
    toggleRibbonButton('btnMarketingDelete', enable, init);
    toggleRibbonButton('cmdMarketingComments', enable, init);
    toggleRibbonButton('cmdMarketingOptimize', enable, init);

    toggleRibbonButton('btnPeriodSaveProduct', enable, init);
    toggleRibbonButton('btnPeriodSaveAndCloseProduct', enable, init);
    toggleRibbonButton('btnPeriodCancel', enable, init);
    toggleRibbonButton('btnPeriodDelete', enable, init);
    toggleRibbonButton('cmdPeriodComments', enable, init);
    toggleRibbonButton('cmdPeriodOptimize', enable, init);

    toggleRibbonButton('RibbonBasicButton', enable, init);
    toggleRibbonButton('RibbonDescrButton', enable, init);
    toggleRibbonButton('RibbonMediaButton', enable, init);

    toggleRibbonButton('RibbonRelatedGroupsButton', enable, init);
    toggleRibbonButton('RibbonRelatedProdButton', enable, init);
    toggleRibbonButton('RibbonVariantsButton', enable, init);
    toggleRibbonButton('RibbonFieldsButton', enable, init);
    toggleRibbonButton('RibbonPartsListsButton', enable, init);
    toggleRibbonButton('RibbonMwButton', enable, init);
    toggleRibbonButton('RibbonPricesButton', enable, init);
    toggleRibbonButton('RibbonUnitButton', enable, init);
    toggleRibbonButton('RibbonStockButton', enable, init);
    toggleRibbonButton('RibbonDiscountsButton', enable, init);
    toggleRibbonButton('RibbonDelocalizeButton', enable, init);
    toggleRibbonButton('cmdlangSelector', enable, init);
}

function toggleRibbonButton(buttonId, enable, init) {

    if (init) {
        if (!Ribbon.buttonIsEnabled(buttonId)) {

            if (buttonId != 'btnSaveProduct' && buttonId != 'btnSaveAndCloseProduct' && buttonId != 'btnMarketingSaveProduct' && buttonId != 'btnMarketingSaveAndCloseProduct' && buttonId != 'btnPeriodSaveProduct' && buttonId != 'btnPeriodSaveAndCloseProduct')
            {
                alwaysDisabledButtons.set(buttonId, true);
            }
        }
    }

    if (alwaysDisabledButtons.get(buttonId)) {
        return;
    }

    if (enable) {
        Ribbon.enableButton(buttonId);
    }
    else {
        Ribbon.disableButton(buttonId);
    }
}

function onDetailLoadError(img) {
    img.style.display = "none";
    img.previousElementSibling.style.display = "";
}

var fckEditors = new Hash(); //all avalable fck editors
var fckTimer;

function FCKeditor_OnComplete(editorInstance) {
    fckEditors.set(editorInstance.Name, true); //editor has been loaded
}

function waitForFCK() {

    fckTimer = setInterval(function () {

        var values = fckEditors.values();
        var loaded = true;
        for (i = 0; i < values.length; i++) {
            loaded = loaded && values[i];
        }

        if (loaded) {
            toggleRibbonButtons(true);

            if (fckTimer) {
                clearInterval(fckTimer);
            }
        }

    }, 1000);
}

var descrTimer;

function loadDescriptionTab() {
	toggleRibbonButtons(true);
}

function getFieldByID (field) {
    var ret = document.getElementById(field);

    if (!ret) {
        var elements = document.getElementsByName(field);

        if (elements != null && elements.length) {
            ret = elements[0];
        }
    }
    return ret;
}


var ProductEdit = {
    isDirty: false,

    suppressBeforeUnload: false,

    terminology: {},

    Marketing: null,

    validation_result: null,

    get_validation: function () {
        if (!this._validation) {
            this._validation = new Dynamicweb.Validation.ValidationManager();
        }
        return this._validation;
    },

    validate: function (validateID) {
        var context = { manager: this.get_validation() };
        var validators = this.get_validation().get_validators();
        var validationErrors = "";
        if (validators && validators.length) {
            for (var i = 0; i < validators.length; i++) {
                if (validators[i].get_target() == validateID || !validateID) {
                    Dynamicweb.Validation.setFocusToValidateField = (validationErrors.length == 0);
                    var res = validators[i].beginValidate(context, ProductEdit.field_validation_error)
                    if (!res.isValid)
                    {
                        if (validationErrors == "") {
                            validationErrors += res.errorMessage;
                        }
                    }
                    var elem = document.getElementById("asterisk_"+validators[i].get_target().replace("ctl00_ContentHolder_", ""))
                    if (elem) {
                        if (res.isValid) {
                            elem.classList.add("hide-error");
                        } else {
                            elem.classList.remove("hide-error");
                        }
                    }
                }
            }
        }
        if (!validateID && validationErrors != "")
            alert(validationErrors);
        return (validationErrors.length == 0);
    },

    field_validation_error: function(result)
    {
        return result;
    },

    initialization: function () {
        var self = this;

        window.onbeforeunload = function (e) {
            if (self.isDirty && !self.suppressBeforeUnload) {
                (e || window.event).returnValue = self.terminology.unsavedChanges;
                return self.terminology.unsavedChanges;
            }
        };
        this.initProductCategoryFields();
        this.initializeImageBlocks();
    },

    openContentRestrictionDialog: function (productID, variantID, languageID) {
        this.Marketing.openSettings('ContentRestriction', { data: { ItemType: 'Product', ItemID: productID + '.' + variantID + '.' + languageID, Type: 'Reorder'} });
    },

    openProfileDynamicsDialog: function (productID, variantID, languageID) {
        this.Marketing.openSettings('ProfileDynamics', { data: { ItemType: 'Product', ItemID: productID + '.' + variantID + '.' + languageID } });
    },

    save: function (close) {
        this.suppressBeforeUnload = true;
        queryString.init(location.href);
        queryString.remove("Tab");
        queryString.remove("TabName");
        aspForm.action = queryString.toString();
    },

    cancel: function () {
        var back = $("backUrl").value;
        if (back.length > 0) {
            window.location.href = back;
        }
        else if (isVariantProduct()) {
            top.close();
        }
        else {
            window.location.href = "../ProductList.aspx?GROUPID=" + _groupId + "&restore=true";
        }
    },

    initProductCategoryFields: function () {
        initCategoryFieldsInheritanceUI(document.body);
    },

    mediaDetailsValidator: function (mediaType) {
        if (mediaType == "ProductDetailsImages" && $('ProductDetailDataUrl'))
            return $('ProductDetailDataUrl').select("input[type=text][value]").length > 0;
        else if (mediaType == "ProductDetailsText" && $('ProductDetailDataTxt'))
            return $('ProductDetailDataTxt').select("textarea[value]").length > 0;
        else 
            return true;
    },

    idExistValidator: function (id) {
        var productId = document.getElementById(id).value;
        var validationCompleted = false;
        var valid = true;
        if (productId){
            var over = new overlay('ProductEditOverlay');
            new Ajax.Request('/Admin/Module/eCom_Catalog/dw7/Edit/EcomProduct_Edit.aspx', {
                method: 'GET',
                asynchronous: false,
                parameters: {
                    'IsAjax': true,
                    'CMD': 'CheckProductId',
                    'ID': productId
                },
                onCreate: function () {
                    over.show();
                },
                onSuccess: function (transport) {
                    if (transport.responseText) {
                        var responceJson = JSON.parse(transport.responseText);
                        if (responceJson && responceJson.valid == true) {
                            valid = true;
                        } else {
                            valid = false;
                        }
                    } else {
                        valid = false;
                    }
                },
                onFailure: function () {
                    valid = false;
                },
                onComplete: function () {
                    validationCompleted = true;
                    setTimeout(function () {
                        over.hide();
                    }, 100);
                }
            });
        }
        return valid;
    },

    initializeImageBlocks: function () {
        var self = this;
        var container = document.getElementById("DocumentsGroupBox");
        Dynamicweb.ProductImageBlocks.get_current().initialize({
            container: container,
            enableVideoPreview: true,
            previewPdfDialogTitle: self.terminology["PreviewPdfDialogTitle"]
        });
    }
}
