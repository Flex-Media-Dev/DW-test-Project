// @see http://stackoverflow.com/a/2308157/2380601
if (typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function () {
        return this.replace(/^\s+|\s+$/g, '');
    }
}

var productMenu = new Object();

productMenu.init = function (shopId, groupId, langId, allProducts, pcm) {
    this._shopId = shopId;
    this._groupId = groupId;
    this._refreshingGroups = '';
    this._langId = langId;
    this._allProducts = allProducts;
    this._pcm = pcm;
    this._showAssortmentsNotice = false;
    this._warningAssortmentsMessage = '';
    this._queryId = null;
}

productMenu.getCallerParam = function () {
    var caller = "";
    if (this._pcm) {
        caller = "&caller=PIM";
    }
    return caller;
}

productMenu.onContextMenuView = function (sender, arg) {
    var view = "common";

    var rows = List.getSelectedRows("ProductList");

    if (!rows || rows.size() == 0) {
        rows = [List.getRowByID('ProductList', arg.callingID)];
    }

    var shopID = '';
    rows.each(function (row) {
        if (view != "ungroup") {
            if (row.hasClassName('row-ungrouped')) {
                view = "ungroup";
            }
        }
        var noassortments = row.readAttribute("noassortments");
        if (!!noassortments) {
            productMenu._showAssortmentsNotice = true;
        }
    });

    return view;
}

productMenu.getStateForDeleteAction = function (sender, arg) {
    if (!isDeleteActionEnabled) {
        return "";
    }
    var rows = List.getSelectedRows("ProductList");
    if (!rows || rows.size() == 0) {
        rows = [List.getRowByID('ProductList', ContextMenu.callingID)];
    }
    if (isDeleteActionEnabled(rows)) {
        return "";
    }
    return "disabled";
}

productMenu.selectedProducts = function () {
    var selectedValues = '';
    var rows = List.getSelectedRows("ProductList");

    if (rows && rows.size() > 0) {
        rows.each(function (row) {
            selectedValues += row.readAttribute('itemid') + ";";
        });
        selectedValues = selectedValues.substring(0, selectedValues.length - 1);
    }
    else {
        selectedValues = ContextMenu.callingItemID || null;
    }

    return selectedValues;
}

productMenu.editProduct = function () {
    if (productMenu._allProducts) {
        allProducts.editProduct(null, ContextMenu.callingItemID);
    } else if (this._pcm) {
        new overlay("__ribbonOverlay").show();
        var location = "/Admin/Module/eCom_Catalog/dw7/PIM/PimProduct_Edit.aspx?ID=" + ContextMenu.callingItemID + "&GroupId=" + this._groupId;
        if (this._queryId) {
            location += "&queryId=" + this._queryId
        }
        document.location.href = location;
    } else {
        editProduct(null, ContextMenu.callingItemID);
    }
}

productMenu.copyProduct = function () {
    this._copyFromList = true;    
    window.open("/Admin/Module/eCom_Catalog/dw7/Lists/EcomGroupSelector.aspx?CMD=GetGroupIdForCopy&MasterShopID=" + this._shopId + "&MasterGroupID=" + this._groupId + "&SetLanguageID=" + this._langId + this.getCallerParam(), "", "displayWindow,width=460,height=400,scrollbars=no");
}

productMenu.copyProductsToGroup = function (groupId) {
    if (!this._copyFromList) {
        return;
    }

    var selectedValues = productMenu.selectedProducts();
    if (!selectedValues) {
        return;
    }

    var queryId = "";
    if (Dynamicweb && Dynamicweb.PIM && Dynamicweb.PIM.BulkEdit) {
        var bulkEditInstance = Dynamicweb.PIM.BulkEdit.get_current();

        if (bulkEditInstance._queryId) {
            queryId = bulkEditInstance._queryId;
        }
    }
    
    var copyProducts = function () {
        new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ProductList.CopyProducts&ToGroupID=" + groupId + "&FromGroupId=" + this._groupId + "&copyGroupRelation=" + this._pcm + "&QueryId=" + queryId, {
            method: 'post',
            parameters: {
                prodCollection: selectedValues
            },
            onSuccess: function (transport) {
                if (transport.responseText == "true") {
                    alert(productMenu._successCopyMessage);
                }
                else {
                    alert(productMenu._failureCopyMessage + transport.responseText);
                }
                productMenu.redirect();
            }
        });
    }

    productMenu._refreshingGroups = groupId;
    if (this._pcm) {
        new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ProductList.CopyProductsWithCkeck&ToGroupID=" + groupId + "&FromGroupId=" + this._groupId + "&copyGroupRelation=" + this._pcm + "&QueryId=" + queryId, {
            method: 'post',
            parameters: {
                prodCollection: selectedValues
            },
            onSuccess: function (transport) {
                if (transport.responseText == "true") {
                    alert(productMenu._successCopyMessage);
                    productMenu.redirect();
                }
                else if (transport.responseText == "false") {
                    var message = productMenu._confirmCopyFromNonPromaryGroup || "Current group is not primary. Product will be related to this group during related groups copying.";
                    if (Dynamicweb && Dynamicweb.PIM && Dynamicweb.PIM.BulkEdit) {
                        Dynamicweb.PIM.BulkEdit.get_current().showConfirmMessage(message, function () {
                            copyProducts();
                        });
                    } else {
                        if (confirm(message)) {
                            copyProducts();
                        }
                    }
                }
                else {
                    alert(productMenu._failureCopyMessage + transport.responseText);
                    productMenu.redirect();
                }
            }
        });
    } else {
        copyProducts();
    }
}

productMenu.redirect = function () {
    if (productMenu._allProducts) {
        document.location.href = "/admin/Module/eCom_Catalog/dw7/allProducts.aspx?psearch=" + $("products_search").value +
        "&ppagenumber=" + $("products_pagenumber").value +
        "&ppagesize=" + $("products_pagesize").value;
    } else if (this._pcm) {
        var location = "/Admin/Module/eCom_Catalog/dw7/PIM/PimProductList.aspx?GroupId=" + this._groupId;
        if (this._queryId) {
            location += "&queryId=" + this._queryId
        }
        document.location.href = location;
    } else {
        var refreshingGroups = "";
        if (productMenu._refreshingGroups) refreshingGroups = "&refreshingGroups=" + productMenu._refreshingGroups;
        document.location.href = "/admin/Module/eCom_Catalog/dw7/ProductList.aspx?GroupID=" + productMenu._groupId + refreshingGroups;
    }
}

productMenu.moveProduct = function () {
    if (this._showAssortmentsNotice) {
        alert(this._warningAssortmentsMessage);
    }

    this._moveFromList = true;
    window.open("/Admin/Module/eCom_Catalog/dw7/Lists/EcomGroupSelector.aspx?CMD=PickFromListGroup&MasterShopID=" + this._shopId + "&MasterGroupID=" + this._groupId + "&SetLanguageID=" + this._langId + this.getCallerParam(), "", "displayWindow,width=460,height=400,scrollbars=no");
}

productMenu.moveMultipleProducts = function () {
    if (this._showAssortmentsNotice) {
        alert(this._warningAssortmentsMessage);
    }

    this._moveFromList = true;
    window.open("/Admin/Module/eCom_Catalog/dw7/Lists/EcomGroupSelector.aspx?CMD=PickFromListGroup&MasterGroupID=" + this._groupId + "&SetLanguageID=" + this._langId + this.getCallerParam(), "", "displayWindow,width=460,height=400,scrollbars=no");
}

productMenu.attachMultipleProducts = function () {
    if (this._showAssortmentsNotice) {
        alert(this._warningAssortmentsMessage);
    }

    this._moveFromList = true;
    window.open("/Admin/Module/eCom_Catalog/dw7/Lists/EcomGroupSelector.aspx?CMD=PickFromListGroupForAttach&MasterGroupID=" + this._groupId + "&SetLanguageID=" + this._langId + this.getCallerParam(), "", "displayWindow,width=460,height=400,scrollbars=no");
}

productMenu.detachProduct = function () {
    if (!confirm(this._detachMessage)) {
        return;
    }

    this._moveFromList = true;

    if (this._groupId === '') {
        window.open("/Admin/Module/eCom_Catalog/dw7/Lists/EcomGroupSelector.aspx?CMD=GetGroupIdForRemove&MasterShopID=" + this._shopId + "&MasterGroupID=" + this._groupId + "&SetLanguageID=" + this._langId + this.getCallerParam(), "", "displayWindow,width=460,height=400,scrollbars=no");
    } else {
        this.doDetachMultipleProducts(this._groupId);
    }
}

productMenu.doMoveMultipleProducts = function (groupId) {
    if (!this._moveFromList) {
        return;
    }

    var selectedValues = productMenu.selectedProducts();
    if (!selectedValues) {
        return;
    }

    var queryId = "";
    if (Dynamicweb && Dynamicweb.PIM && Dynamicweb.PIM.BulkEdit) {
        var bulkEditInstance = Dynamicweb.PIM.BulkEdit.get_current();

        if (bulkEditInstance._queryId) {
            queryId = bulkEditInstance._queryId;
        }
    }

    new overlay("__ribbonOverlay").show();    
    productMenu._refreshingGroups = groupId;
    new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ProductList.MoveMultipleProductsFormList&ToGroupID=" + groupId + "&FromGroupID=" + this._groupId + "&QueryId=" + queryId, {
        method: 'post',
        parameters: {
            prodCollection: selectedValues
        },
        onSuccess: function (transport) {
            if (transport.responseText == "yes") {
                productMenu.redirect();
            }
        },
        onFailure: function () {
            new overlay("__ribbonOverlay").hide();
        }
    });
}

productMenu.doAttachMultipleProducts = function (groupId) {
    if (!this._moveFromList) {
        return;
    }
    
    var selectedValues = productMenu.selectedProducts();    
    if (!selectedValues) {
        return;
    }

    var queryId = "";
    if (Dynamicweb && Dynamicweb.PIM && Dynamicweb.PIM.BulkEdit) {
        var bulkEditInstance = Dynamicweb.PIM.BulkEdit.get_current();

        if (bulkEditInstance._queryId) {
            queryId = bulkEditInstance._queryId;
        }
    }

    new overlay("__ribbonOverlay").show();
    productMenu._refreshingGroups = groupId;
    new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ProductList.AttachMultipleProductsFormList&ToGroupID=" + groupId + "&QueryId=" + queryId, {
        method: 'post',
        parameters: {
            prodCollection: selectedValues
        },
        onSuccess: function (transport) {
            if (transport.responseText == "yes") {
                productMenu.redirect();
            }
        },
        onFailure: function () {
            new overlay("__ribbonOverlay").hide();
        }
    });
}

productMenu.doDetachMultipleProducts = function (groupId) {
    var that = this;
    var selectedValues = productMenu.selectedProducts();
    if (!selectedValues) {
        return;
    }

    try {
        showOverlay("ProductsLayout");
    } catch (ex) { }

    productMenu._refreshingGroups = groupId;
    new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ProductList.DetachMultipleProductsFormList&FromGroupID=" + groupId, {
        method: 'post',
        parameters: {
            prodCollection: selectedValues
        },
        onSuccess: function (transport) {
            if (transport.responseText !== "yes") {
                alert(that._failureDetachMessage);
            }

            productMenu.redirect();
        },
        onFailure: function (transport) {
            alert(that._failureDetachMessage);
            productMenu.redirect();
        }
    });
}

productMenu.deleteProduct = function (before, after) {
    var that = this;
    if (productMenu.getStateForDeleteAction() == "disabled") {
        return;
    }
    var selectedValues = productMenu.selectedProducts();
    if (!selectedValues) {
        return;
    }

    var invoke = function (func) {
        if (typeof (func) !== 'undefined') {
            func();
        }
    };

    var check = function (callback) {

        invoke(before);

        new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ProductList.CheckForGroups", {
            method: 'post', 
            parameters: {
                prodCollection: selectedValues,
            },
            onSuccess: function (transport) {
                var msg = transport.responseText.toString().trim().toLowerCase();
                var confirmMsg = '';

                if (msg === 'true') {
                    confirmMsg = that._deleteMessage2;
                } else {
                    confirmMsg = that._deleteMessage;
                }

                if (confirm(confirmMsg)) {
                    invoke(function () { callback(after); });
                }
            }
        });
    };

    var del = function (callback) {
        var groupId = "";
        var queryId = "";
        if (Dynamicweb && Dynamicweb.PIM && Dynamicweb.PIM.BulkEdit) {
            var bulkEditInstance = Dynamicweb.PIM.BulkEdit.get_current();

            if (bulkEditInstance._queryId) {
                queryId = bulkEditInstance._queryId;
            } else {
                groupId = bulkEditInstance._groupId;
            }
        } else {
            groupId = that._groupId;
        }

        new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ProductList.DeleteMultipleProductsFormList&GroupID=" + groupId + "&QueryId=" + queryId, {
            method: 'post',
            parameters: {
                prodCollection: selectedValues,
            },
            onSuccess: function (transport) {
                var msg = transport.responseText.toString().trim().toLowerCase();
                if (msg !== '') {
                    alert(transport.responseText);
                } else {
                    productMenu.redirect();
                }

                invoke(callback);
            }
        });
    };

    check(del);
}

productMenu._markProductRowAsActive = function (rowEl, rowStateEl, newState) {
    var oldState = rowStateEl.getAttribute('data-active') == 'true';
    if (oldState == newState) return;

    if (rowEl.getStyle('color').length > 0) {
        rowEl.setStyle({ color: newState ? 'black' : 'red' });
    }

    rowStateEl.setAttribute('data-active', newState);
    rowStateEl.setAttribute('class', rowStateEl.getAttribute("data-css-state-active-" + newState));

    var breadcrumbActiveCount = document.getElementById("breadcrumbActiveCount");
    if (breadcrumbActiveCount) {
        var count = parseInt(breadcrumbActiveCount.innerHTML);
        count += newState ? 1 : -1;
        breadcrumbActiveCount.innerHTML = count;
    }
}

productMenu.activateProduct = function () {
    var selectedValues = productMenu.selectedProducts();
    if (!selectedValues) {
        return;
    }

    var groupId = "";
    var queryId = "";
    if (Dynamicweb && Dynamicweb.PIM && Dynamicweb.PIM.BulkEdit) {
        var bulkEditInstance = Dynamicweb.PIM.BulkEdit.get_current();

        if (bulkEditInstance._queryId) {
            queryId = bulkEditInstance._queryId;
        } else {
            groupId = bulkEditInstance._groupId;
        }
    }

    if (queryId) {
        new overlay("__ribbonOverlay").show();
    }
    new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ProductList.ActivateProducts&prodCollection=" + selectedValues + "&ts=" + productMenu.ts() + "&GroupId=" + groupId + "&QueryId=" + queryId, {
        method: 'get',
        onSuccess: function (transport) {
            if (transport.responseText == "yes") {
                if (queryId) {
                    location.reload();
                }
                var prods = selectedValues.split(";");
                prods.each(function (p) {
                    var row = productMenu.getRowByItemID("ProductList", p);
                    var imgIcon = document.getElementById('img' + p);
                    productMenu._markProductRowAsActive(row, imgIcon, true);
                });
                productMenu.clearSelectedRows();
            }
        },
        onFailure: function () {
            new overlay("__ribbonOverlay").hide();
        }
    });
}

productMenu.deactivateProduct = function () {
    var selectedValues = productMenu.selectedProducts();
    if (!selectedValues) {
        return;
    }

    var groupId = "";
    var queryId = "";
    if (Dynamicweb && Dynamicweb.PIM && Dynamicweb.PIM.BulkEdit) {
        var bulkEditInstance = Dynamicweb.PIM.BulkEdit.get_current();

        if (bulkEditInstance._queryId) {
            queryId = bulkEditInstance._queryId;
        } else {
            groupId = bulkEditInstance._groupId;
        }
    }

    if (queryId) {
        new overlay("__ribbonOverlay").show();
    }
    new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ProductList.DeActivateProducts&prodCollection=" + selectedValues + "&ts=" + productMenu.ts() + "&GroupId=" + groupId + "&QueryId=" + queryId, {
        method: 'get',
        onSuccess: function (transport) {
            if (transport.responseText == "yes") {
                if (queryId) {
                    location.reload();
                }
                var prods = selectedValues.split(";");
                prods.each(function (p) {
                    var row = productMenu.getRowByItemID("ProductList", p);
                    var imgIcon = document.getElementById('img' + p);
                    productMenu._markProductRowAsActive(row, imgIcon, false);
                });
                productMenu.clearSelectedRows();
            }
        },
        onFailure: function () {
            new overlay("__ribbonOverlay").hide();
        }
    });
}

productMenu.activateDeactivateProductByIcon = function (prodID) {
    var groupId = "";
    var queryId = "";

    var imgIcon = document.getElementById('img' + prodID);
    var activateProducts = (imgIcon.getAttribute('data-active') != 'true');

    if (Dynamicweb && Dynamicweb.PIM && Dynamicweb.PIM.BulkEdit) {
        var bulkEditInstance = Dynamicweb.PIM.BulkEdit.get_current();

        if (bulkEditInstance._queryId) {
            queryId = bulkEditInstance._queryId;
            new overlay("__ribbonOverlay").show();
        } else {
            groupId = bulkEditInstance._groupId;
        }
    } else {
        groupId = _groupId;
    }

    var cmd = activateProducts ? "ProductList.ActivateProducts" : "ProductList.DeActivateProducts";
    new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=" + cmd + "&prodCollection=" + prodID + "&ts=" + productMenu.ts() + "&GroupId=" + groupId + "&QueryId=" + queryId, {
        method: 'get',
        onSuccess: function (transport) {
            if (transport.responseText == "yes") {
                if (queryId) {
                    location.reload();
                }
                var row = productMenu.getRowByItemID("ProductList", prodID);
                productMenu._markProductRowAsActive(row, imgIcon, activateProducts);
            }
        },
        onFailure: function () {
            new overlay("__ribbonOverlay").hide();
        }
    });
}

productMenu.ts = function () {
    // Timestamp to prevent getting a cached result when calling Ajax page
    var d = new Date();
    return d.getHours().toString() + d.getMinutes().toString() + d.getSeconds().toString() + d.getMilliseconds().toString();
}

productMenu.getRowByItemID = function (controlID, itemID) {
    var ret = null;

    ret = $$('tbody[id="' + controlID + '_body_stretch"] > tr[itemid="' + itemID + '"]');

    if (!ret || ret.length == 0) {
        ret = $$('tbody[id="' + controlID + '_body"] > tr[itemid="' + itemID + '"]');
    }

    if (ret && ret.length > 0)
        ret = ret[0];

    return ret;
}

productMenu.clearSelectedRows = function () {
    List.setAllSelected('ProductList', false);
}
