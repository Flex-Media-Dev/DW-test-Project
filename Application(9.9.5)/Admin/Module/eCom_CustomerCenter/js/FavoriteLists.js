var favoriteList = {
    action: '',
    selectedList: null,
    deleteQuestion: '',
    isGroupFavorite: false,

    showProducts: function (listId) {
        listId = listId || ContextMenu.callingItemID;

        let url = "FavoriteProducts.aspx?ID=" + listId + (this.isGroupFavorite ? "&Type=group" : "");
        document.location.href = url;
    },

    addNew: function () {
        let url = "FavoriteEdit.aspx?ID=0&Mode=New" + (this.isGroupFavorite ? "&Type=group" : "");
        document.location.href = url;
    },

    edit: function (listId) {
        listId = listId || ContextMenu.callingItemID;

        let url = "FavoriteEdit.aspx?ID=" + listId + "&Mode=Edit" + (this.isGroupFavorite ? "&Type=group" : "");
        document.location.href = url;
    },

    copy: function () {
        let listId = ContextMenu.callingItemID;

        let url = "FavoriteLists.aspx?Action=GetInfo&SelectedList=" + listId + (this.isGroupFavorite ? "&Type=group" : "");

        fetch(url, {
            method: 'GET'
        }).then(function (response) {
            if (response.status >= 200 && response.status < 300) {
                return response.text();
            }
            else {
                var error = new Error(response.statusText);
                error.response = response;
                throw error;
            }
        }).then(function (response) {
            let list = JSON.parse(response);
            document.getElementById("OriginalListName").innerHTML = list.Name;
            document.getElementById("OriginalListProducts").innerHTML = list.ProductsCount;
            document.getElementById("FavoriteListName").value = list.Name;
            UserSelectorCopyToUsers.ClearUsers();
            dwGlobal.hideControlErrors("UserSelectorDivCopyToUsers");

            dialog.show('CopyDialog');
        }).catch(function (error) {
            console.log('There has been a problem with your fetch operation: ' + error.message);
            alert(error.message);
        });
    },

    copyComplete: function () {
        if (!this.validate()) return;

        let listId = ContextMenu.callingItemID;

        this.action.value = "copy";
        this.selectedList.value = listId;
        List._submitForm('FavoriteListMenu');
    },

    delete: function () {
        let listId = ContextMenu.callingItemID;

        if (!confirm(this.deleteQuestion)) return false;

        this.action.value = "delete";
        this.selectedList.value = listId;
        List._submitForm('FavoriteListMenu');
    },

    validate: function () {
        let v = UserSelectorCopyToUsers.GetValue();
        if (v === '') {
            dwGlobal.showControlErrors("UserSelectorDivCopyToUsers", "Required");
            return false;
        }
        else {
            dwGlobal.hideControlErrors("UserSelectorDivCopyToUsers");
            return true;
        }
    }
};