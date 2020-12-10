var sorter;

Event.observe(window, 'load', function () {
    Position.includeScrollOffsets = true;
    sorter = new DWSortable('items',
        { name: function (s) { return s.children[1].innerHTML; } }
    );

    // resize hack
    var s = Dynamicweb.Controls.StretchedContainer.getInstance('SortingContainer');
    s.add_afterSetHeight(function (sender, e) {
        e.set_height(e.get_height() - 55);
    });
    s.setHeight();
});

function save() {
    new Ajax.Request("/Admin/Module/newsv2/category_sort.aspx", {
        method: 'post',
        parameters: {
            "categories": Sortable.sequence('items').join(','),
            "Save": "save"
        },
        onSuccess: function () {
            category.list();
            main.reloadTree();
        }
    });
}
