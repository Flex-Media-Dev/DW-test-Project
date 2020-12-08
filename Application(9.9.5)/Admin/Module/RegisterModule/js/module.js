

var module = {
    addModule: function () {
        window.location.href = "edit.aspx";
    },

    edit: function (moduleId) {
        window.location.href = "edit.aspx?id=" + moduleId;
    },

    editClick: function () {
        this.edit(ContextMenu.callingItemID);
    },

    deleteClick: function () {
        del(ContextMenu.callingItemID);
    }
}