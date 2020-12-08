var favoriteProducts = {
    theForm: null,
    listId: 0,
    deleteAction: null,
    isGroupFavorite: false,

    initialize: function (form, listId, deleteAction, isGroupFavorite) {
        this.theForm = form;
        this.listId = listId;
        this.deleteAction = deleteAction;
        this.isGroupFavorite = isGroupFavorite;
    },

    cancel: function () {
        document.location.href = "FavoriteLists.aspx" + (this.isGroupFavorite ? "?Type=group" : "");
    },

    addProduct: function () {
        var caller = "parent.favoriteProducts.theForm.NewProductIds";
        var url = "/Admin/Module/Ecom_Catalog/dw7/edit/EcomGroupTree.aspx?CMD=ShowProd&caller=" + caller + "&RelgrpID=0";
        dialog.show('AddProductDialog', url);
    },

    showAddProductDialog: function () {
        dialog.show('AddProductBySCUDialog');
    },

    addProductBySKU: function () {
        dialog.hide('AddProductBySCUDialog');
        this.submitCommand("AddProductsBySCU");
    },

    edit: function () {
        let url = "FavoriteEdit.aspx?ID=" + this.listId + (this.isGroupFavorite ? "&Type=group" : "");
        document.location.href = url;
    },

    submitCommand: function (cmd) {
        this.theForm.Cmd.value = cmd;
        this.theForm.submit();
    },

    productSelected: function () {
        if (List && List.getSelectedRows('FavoriteList').length > 0) {
            Toolbar.setButtonIsDisabled('cmdDelete', false);
        } else {
            Toolbar.setButtonIsDisabled('cmdDelete', true);
        }
    },

    delete: function (evt) {
        evt.stopPropagation();
        let rows = List.getSelectedRows('FavoriteList');
        let ids = [];

        if (rows.length > 0) {
            for (var i = 0; i < rows.length; i++) {
                ids.push(rows[i].readAttribute("itemid"));
            }
        }
        this.theForm.FavoriteIds.value = ids.toString();

        Action.Execute(this.deleteAction, {
            ids: ids
        });
    },
};