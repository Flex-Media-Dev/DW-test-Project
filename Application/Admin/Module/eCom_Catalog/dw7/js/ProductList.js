function productListSorting() {
    theForm.action = "/Admin/Module/eCom_Catalog/dw7/ProductListSort.aspx?GroupID=" + _groupId;
    theForm.__VIEWSTATE.value = "";
    theForm.submit();
}

function createMultipleProducts() {
    theForm.action = "ProductListEditing.aspx?GroupID=" + _groupId;
    theForm.__VIEWSTATE.value = "";
    theForm.submit();
}

function productListEditing() {
    var ids = $('ProductList_body').select('tr[itemid]' +(List.getSelectedRows('ProductList').length > 0? '.selected':'')).invoke('getAttribute', 'itemid').join(',');
    $('productIds').value = ids;

    theForm.action = "ProductListEditing.aspx?GroupID=" + _groupId;
    theForm.__VIEWSTATE.value = "";
    theForm.submit();
}

function editProduct(e, productId) {
    if (e != null) {
        var t = $(e.srcElement || e.target);
        if (t.tagName == "IMG" && t.id.indexOf("img_") == 0) {
            return;
        }
    }

    var url = "edit/EcomProduct_Edit.aspx?ID=" + productId + "&GroupID=" + _groupId;
    document.location.href = url;
}

function newGroup() {
    theForm.action = "edit/EcomGroup_Edit.aspx?ParentID=" + _groupId + "&ShopID=";
    theForm.__VIEWSTATE.value = "";
    theForm.submit();
}

function editGroup() {
    var url = "edit/EcomGroup_Edit.aspx?ID=" + _groupId;
    url += document.location.href.indexOf("preview") == -1 ? "" : (document.location.href.indexOf("preview=on") == -1 ? "&preview=off" : "&preview=on");    
    document.location.href = url;
}

function newProduct() {
    var url = "edit/EcomProduct_Edit.aspx?GroupID=" + _groupId;
    document.location.href = url;
}

function startProductWizard() {
    StartWizard('PRODUCT', _groupId);
}

function gotoVariant(prodId, groupID, variantId, found) {
    var variantPage = "/Admin/Module/eCom_Catalog/dw7/edit/EcomProduct_Edit.aspx?ID=" + prodId + "&GroupID=" + groupID + "&VariantID=" + variantId + "&Found=" + found + "&ecom7master=hidden&updateSimpleVariant=true";

    if (variantPage != "") {
        document.getElementById('VariantDialogFrame').src = variantPage;
        dialog.show('VariantDialog');
    }
}

function closeVariantDialog() {
    dialog.hide('VariantDialog');
    var frame = document.getElementById('VariantDialogFrame');
    if (frame) {
        frame.src = '';
    }
}

function isDeleteActionEnabled(rows) {
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].hasClassName('action-delete-disabled')) {
            return false;
        }
    }
    return true;
}

function productSelected(row) {
    var rows = List.getSelectedRows('ProductList');

    if (typeof (Ribbon) == "object") {
        if (rows.length > 0) {
            if (isDeleteActionEnabled(rows)) {
                Ribbon.enableButton('cmdDelete');
            }
            else {
                Ribbon.disableButton('cmdDelete');
            }
            if (!disableDelocalize) {
                Ribbon.enableButton('cmdDelocalize');
                Ribbon.enableButton('cmdLocalize');
            }

        }
        else {
            Ribbon.disableButton('cmdDelete');
            if (!disableDelocalize) {
                Ribbon.disableButton('cmdDelocalize');
                Ribbon.disableButton('cmdLocalize');
            }
        }
    }
}

function tryDelocalize(submitCallback) {
    return tryConfirm(document.getElementById('spDelocalizeMsg').innerHTML, submitCallback);
}

function tryDelete(submitCallback) {
    productMenu.deleteProduct(function () {
        if (typeof (WaterMark) != 'undefined') {
            WaterMark.hideAll();
        }
    });
}

function tryConfirm(msg, onSuccess) {
    var ret = true;

    ret = confirm(msg);

    if (ret) {
        if (typeof (WaterMark) != 'undefined') {
            WaterMark.hideAll();
        }

        if (!onSuccess) {
            document.forms[0].submit();
        } else {
            onSuccess();
        }
    }

    return ret;
}

function showDialog(params) {
    /// <summary>Brings up the pop-up window.</summary>
    /// <param name="params">Parameters that control the look&feel of the pop-up window..</param>

    if (!params) {
        params = {}
    }

    if (params.control) {
        if (params.url) {
            params.control.set_contentUrl(params.url);
        }

        if (params.title) {
            params.control.set_title(params.title);
        }

        params.control.show();
    }
}
