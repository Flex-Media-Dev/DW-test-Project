var favoriteEdit = {
    theForm: null,
    listId: 0,
    mode: '',
    isGroupFavorite: false,

    initialize: function (form, listId, mode, isGroupFavorite) {
        this.theForm = form;
        this.listId = listId;
        this.mode = mode;
        this.isGroupFavorite = isGroupFavorite;
    },

    cancel: function () {
        let url = "FavoriteProducts.aspx?ID=" + this.listId + (this.isGroupFavorite ? "&Type=group" : "");
        if (this.mode === "New" || this.mode === "Edit") {
            url = "FavoriteLists.aspx" + (this.isGroupFavorite ? "?Type=group" : "");
        }

        document.location.href = url;
    },

    save: function () {
        if (this.validate()) {
            this.submitCommand("Save");
        }
    },

    saveAndClose: function () {
        if (this.validate()) {
            this.submitCommand("SaveAndClose");
        }
    },

    validate: function () {
        var v = UserID_CustomSelector_CustomSelector.get_value();
        if (v.value === '') {
            dwGlobal.showControlErrors("UserID_CustomSelector", "Required");
            return false;
        }
        else {
            dwGlobal.hideControlErrors("UserID_CustomSelector");
            return true;
        }
    },

    submitCommand: function (cmd) {
        this.theForm.Cmd.value = cmd;
        this.theForm.submit();
    },
};