var sorter;

Event.observe(window, 'load', function () {
    sorter = new DWSortable('items',
        {
            name: function (s) {
                return ("" + s.children[1].innerHTML).toLowerCase();
            },
            username: function (s) {
                return ("" + s.children[2].innerHTML).toLowerCase();
            },
            email: function (s) {
                return ("" + s.children[3].innerHTML).toLowerCase();
            },
            address: function (s) {
                return ("" + s.children[4].innerHTML).toLowerCase();
            }
        });
});

    function save() {
    new Ajax.Request("/Admin/Module/Usermanagement/ListUsersSorting.aspx", {
        method: 'post',
        parameters: {
            "GroupID": $F("GroupID"),
            "Users": Sortable.sequence('items').join(','),
            "Save": "save"
        },
        onSuccess: cancel
    });
}

function cancel() {
    document.location = '/Admin/Module/Usermanagement/ListUsers.aspx?GroupID=' + $F("GroupID");
}
