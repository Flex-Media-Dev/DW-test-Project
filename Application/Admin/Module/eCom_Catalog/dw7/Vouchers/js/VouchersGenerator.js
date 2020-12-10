var vouchersGenerator = {
    PostbackForm: function (listID) {
        if (!(!isNaN(parseInt($("numberOfVouchers").value)) && isFinite($("numberOfVouchers").value))) {
            showMessage(onlyNumbersAreAccepted);
            return false;
        }
        if (parseInt($("numberOfVouchers").value) > 50000) {
            showMessage(maxNumberOfVouchersExceededWarning);  //Not possible to generate more than 50000 vouchers at a time
            return false;
        }
        if (parseInt($("numberOfVouchers").value) < 1) {
            showMessage(minNumberOfVauchers);
            return false;
        }
        
        $('formmode').value = 'GenerateVouchers';
        $('form2').request({
            onComplete: function (transport) {
                showMessage(vouchersCreated);
                vouchersManagerMain.showVouchersList(listID);
            }
        });
        return true;
    },

    GetNumberOfUsers: function () {
        $('formmode').value = 'CalculateNumberOfUsers';
        $('form2').request({
            onComplete: function (transport) {
                $("numberOfVouchers").value = transport.responseText;
            }
        });
    },

    openGenerateVouchers: function () {
        dialog.show('vouchersGeneratorDialog');
        window.focus(); // for ie8-ie9 
        document.getElementById('numberOfVouchers').focus();
    }, 

    GenerateVouchers: function () {
        if (this.PostbackForm(ListID)) {
            var generatorOverlay = new overlay("GeneratorOverlay");
            generatorOverlay.show();
        }
    }
}
