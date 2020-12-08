var notificationList = {
    showProduct: function (productId, variantId) {
        queryString.init(location.pathname);
        queryString.remove("selectedLangID");

        var backUrl = escape(queryString.toString());

        var url = "edit/EcomProduct_Edit.aspx?ID=" + encodeURIComponent(productId) + (variantId ? "&VariantID=" + variantId : "") + "&backUrl=" + backUrl;
        document.location.href = url;
    },

    showUser: function (userId) {
        queryString.init(location.pathname);
        queryString.remove("selectedLangID");

        var backUrl = escape(queryString.toString());

        var url = "/Admin/Module/Usermanagement/Main.aspx?UserId=" + userId + "&backUrl=" + backUrl;
        document.location.href = url;
    },

    delete: function () {
        if (Toolbar.buttonIsDisabled("cmdDelete") || !confirm(this.deleteQuestion)) return false;

        var rows = List.getSelectedRows('NotificationList');
        if (rows.length == 0)
            return false;

        this.selectedRows.value = "";
        for (var i = 0; i < rows.length; i++)
            this.selectedRows.value += (i > 0 ? ',' : '') + rows[i].attributes['itemid'].value;

        this.action.value = "delete";
        List._submitForm('List');
    },

    onSelectRow: function () {
        var disable = List.getSelectedRows('NotificationList').length == 0;
        Toolbar.setButtonIsDisabled("cmdDelete", disable)
    }
};

notificationList.action = null;
notificationList.selectedRows = null;
notificationList.deleteQuestion = "";