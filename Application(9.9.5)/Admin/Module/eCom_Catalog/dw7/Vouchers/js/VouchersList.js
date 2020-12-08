var vouchersList = {

    contentFrame: function () {
        return document.getElementById("ContentFrame");
    },

    downloadVouchersCSV: function (listId) {
        window.location = "VouchersList.aspx?cmd=ExportToCSV&ListID=" + listId;
    },

    deleteVouchers: function (listId) {
        var selectedVouchersArr = List.getSelectedRows("vouchersList")

        if (selectedVouchersArr.length == 0) {
            alert("No vouchers are selected!");
            return;
        }

        var confirmMessage = "Delete selected vouchers?";
        if (confirm(confirmMessage)) {

            // string with selected vouchers IDs in the format: '1','2','3'
            var selectedVouchersStr = ""
            for (var i = 0; i < selectedVouchersArr.length; i++) {
                if (i != 0) {
                    selectedVouchersStr += ",";
                }
                selectedVouchersStr += selectedVouchersArr[i].attributes.itemid.value;
            }

            window.location = "VouchersActions.ashx?cmd=DeleteVouchers&listId=" + listId + "&Vouchers=" + selectedVouchersStr;
        }
    },

    deleteListRibbon: function (ListId) {
        var confirmMessage = "Delete current List?\n \nWARNING!\nAll posts in the list will be deleted!";

        if (confirm(confirmMessage)) {
            window.location = "VoucherList.ashx?cmd=DeleteList&ListID=" + ListId;
        }
    },

    activateList: function (ListId) {
        if (ListId == 0 || ListId == null) {
            ListId = ContextMenu.callingItemID;
        }
        window.location = "VouchersList.aspx?cmd=ActivateList&ListID=" + ListId + "&State=true";
    },

    deactivateList: function (ListId) {
        if (ListId == 0 || ListId == null) {
            ListId = ContextMenu.callingItemID;
        }
        window.location = "VouchersList.aspx?cmd=ActivateList&ListID=" + ListId + "&State=false";
    },

    viewOrder: function (orderID) {
        top.right.location = '/Admin/Module/eCom_Catalog/dw7/Edit/EcomOrder_Edit.aspx?ID=' + orderID;
    },

    callingItem: function () {
        var item = ContextMenu.callingItemID;
        return eval("(" + item + ")");
    },

    contextMenuView: function (sender, args) {
        /// <summary>Determines the contents of the context-menu.</summary>
        /// <param name="sender">Event sender.</param>
        /// <param name="args">Event arguments.</param>

        var ret = '';
        //            var row = null;
        //            var activeRows = 0;

        //            row = List.getRowByID('categoriesList', args.callingID);

        //            if (row.readAttribute('__active') == 'true') {
        //                ret = 'deactivate_cat';
        //            } else {
        ret = 'activate_cat';
        //            }
        return ret;
    },

    openInContentFrame: function (url) {
        url = this.makeUrlUnique(url);
        var cf = window.parent.document.getElementById("ContentFrame");
        if (cf) {
            cf.src = url;
        }
        else if (window.opener) {
            window.opener.location.href = url; //open in opener window
        }
        else {
            window.location.href = url; //reload current window
        }
    },
        
    // Add vouchers
    openAddVouchers: function() {
        dialog.show('vouchersDialog');
        window.focus(); // for ie8-ie9 
        document.getElementById('voucherCode').focus();
    },

    AddVouchers: function () {
        $('formmode').value = 'AddVouchers';
        var addVouchersOverlay = new overlay("AddVouchersOverlay");
        addVouchersOverlay.show();

        $('form2').request({
            onComplete: function (data) {
                addVouchersOverlay.hide();
                var result = JSON.parse(data.responseText);
                if (result) {
                    if (result.validationMessage) {
                        showMessage(result.validationMessage);
                    }
                    if (result.close) {                        
                        vouchersManagerMain.showVouchersList(ListID);
                    }
                } else {
                    vouchersManagerMain.showVouchersList(ListID);
                }
            }
        });
    },

    // Send mails
    openSendMails: function () {
        dialog.show('vouchersSendMailsDialog');
        window.focus(); // for ie8-ie9
        document.getElementById('VoucherSenderName').focus();
    },

    SendMails: function () {
        $('formmode').value = 'SendMails';
        var mailOverlay = new overlay("MailOverlay");
        mailOverlay.show();

        $('form2').request({
            onComplete: function (data) {
                mailOverlay.hide();

                var responseObject = JSON.parse(data.responseText);
                if (responseObject) {
                    if (responseObject.validationMessage) {
                        showMessage(responseObject.validationMessage);
                    }
                    if (responseObject.close) {
                        vouchersManagerMain.showVouchersList(ListID);
                    }
                } else {
                    vouchersManagerMain.showVouchersList(ListID);
                }
            }
        });
    },

}
