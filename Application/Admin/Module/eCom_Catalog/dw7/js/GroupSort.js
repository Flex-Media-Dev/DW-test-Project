var sorter;

Event.observe(window, 'load', function() {
    Position.includeScrollOffsets = true;
    sorter = new DWSortable('items',
        { name: function(s) { return s.children[1].innerHTML; } },
        null,
        /^[^_\-](?:[A-Za-z0-9\-]*)[_](.*)$/
    );

    // resize hack
    var s = Dynamicweb.Controls.StretchedContainer.getInstance('SortingContainer');
    s.add_afterSetHeight(function(sender, e) {
        e.set_height(e.get_height() - 55);
    });
    s.setHeight();
});


function save() {
    new Ajax.Request("", {
        method: 'post',
        parameters: {
            "Groups": Sortable.sequence('items').join(','),
            "Save": "save"
        },
        onSuccess: cancel
    });
}

function cancel(response) {
    if (response && response.responseText) {
        var json = JSON.parse(response.responseText);
        if (json) {
            Action.Execute(json);
            return;
        }
    }

    if ($F("FromPIM") === "True") {
        if (closeActionParams) {
            Action.Execute(closeActionParams);
            return;
        }
        window.location.href = "/Admin/Module/eCom_Catalog/dw7/PIM/PimProductList.aspx?GroupID=" + $F("group");
    }
    else
        window.location.href = "/Admin/Module/eCom_Catalog/dw7/ProductList.aspx?GroupID=" + $F("group") + "&path=" + encodeURIComponent($F("path"));
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

function moveToBottom() {
    moveRow(-1);
}

function moveRow(direction) {
    var sequence = Sortable.sequence('items');
    var selectedItems = $$('ul li.selected');
    var selectedItemsArray = [];

    for (var i = 0; i < selectedItems.length; i++) {
        var element = selectedItems[i].id.replace("Group_", "");
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

function sortRowsAscending() {
    sorter.sortedBy = '';
    sorter.sortBy('name');
}

function sortRowsDescending() {
    sorter.sortedBy = 'name';
    sorter.sortBy('name');
}
