var sorter;

Event.observe(window, 'load', function() {
    var priceRe = /\d+\.?\d+/g;
    Position.includeScrollOffsets = true;
    sorter = new DWSortable('items',
        { id: function(s) { return ("" + s.children[1].innerHTML).toLowerCase(); },
            name: function(s) { return ("" + s.children[2].innerHTML).toLowerCase(); },
            stock: function(s) { return 1 * s.children[3].innerHTML; },
            price: function(s) { return 1 * ("" + s.children[4].innerHTML).replace(/,/g, '.').match(/\d+\.?\d+/g)[0] || 0; }
        },
        null,
        '^Product_(.*)$'
    );

    // resize hack
    var s = Dynamicweb.Controls.StretchedContainer.getInstance('SortingContainer');
    s.add_afterSetHeight(function(sender, e) {
        e.set_height(e.get_height() - 55);
    });
    s.setHeight();
});


function save() {
    new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/ProductListSort.aspx", {
        method: 'post',
        parameters: {
            "GroupID": $F("GroupID"),
            "FromPIM": $F("FromPIM"),
            "Products": Sortable.sequence('items').join(','),
            "Save": "save"
        },
        onSuccess: cancel
    });
}

function cancel() {
    if ($F("FromPIM") == "True") 
        window.location.href = "/Admin/Module/eCom_Catalog/dw7/PIM/PimProductList.aspx?GroupID=" + $F("GroupID");
    else
        window.location.href = "/Admin/Module/eCom_Catalog/dw7/ProductList.aspx?restore=1&GroupID=" + $F("GroupID");
}

/* Retrieves containing row by its child element */
function findContainingRow(element) {
    var ret = null;

    if (element) {
        element = $(element);

        if (element.descendantOf($("items"))) {
            while (element) {
                if ((element.tagName + '').toLowerCase() == 'li') {
                    ret = element;
                    break;
                } else {
                    if (typeof (element.up) == 'function')
                        element = element.up();
                    else
                        break;
                }
            }
        }
    }

    return ret;
}

function handleCheckboxes(link) {
    var row = findContainingRow(link);
    row.toggleClassName("selected");

}

function moveToTop() {
    moveRow(1);
}

function moveToBottom(prefix) {
    moveRow(-1, prefix);
}

function moveRow(direction) {
    var sequence = Sortable.sequence('items');
    var selectedItems = $$('ul li.selected');
    var selectedItemsArray = [];

    for (var i = 0; i < selectedItems.length; i++) {
        var element = selectedItems[i].id.replace("Product_", "");
        var index = sequence.indexOf(element);
        sequence.splice(index, 1);
        selectedItemsArray.push(element);
    }

    if (direction < 0) {
        for (var i = 0; i < selectedItemsArray.length; i++) {
            sequence.push(selectedItemsArray[i]);
        }
        return Sortable.setSequence('items', sequence);
    } else {
        for (var i = 0; i < sequence.length; i++) {
            selectedItemsArray.push(sequence[i]);
        }
        return Sortable.setSequence('items', selectedItemsArray);
    }
}

