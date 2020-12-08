
var bulk = {

    items: new Array(),

    registerItem: function (rowId) {
        bulk.items.push(rowId);

        $('currentEdit').value = bulk.items.join(",")
    }
}