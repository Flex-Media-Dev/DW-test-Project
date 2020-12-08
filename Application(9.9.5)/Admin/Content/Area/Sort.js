contextAreaActive = true;
contextAreaName = "";
close = false;

function setContextArea(currentState, name) {
    contextAreaActive = (currentState == 'False' ? false : true);
    contextAreaName = name;
}

function sort_init() {
    Position.includeScrollOffsets = true;
    Sortable.create("items", {
        handles: $$('#items .drag-holder')
    });

    $$(".language-list").each(function (el) {
        Sortable.create(el);
    });
}


function sortSave(close) {
    this.close = close;
    var sortedAreasIds = $$(".sort-area").zip(function (tuple) {
        return tuple[0].readAttribute("data-area-id");
    });
    console.log(sortedAreasIds);
    new Ajax.Request("/Admin/Content/Area/List.aspx", {
        method: 'get',
        parameters: {
            "sort": sortedAreasIds.join(','),
            "dt": new Date().getTime()
        },
        onComplete: function (transport) {
            var nav = dwGlobal.getContentNavigator();
            if (nav != null) {
                nav.refreshRootSelector();
            }
            if (parent.left) parent.left.location.reload(true); // From Conext -> page tree            
            else if (parent.parent && parent.parent.left) parent.parent.left.location.reload(true); // From Modules
            if (this.close) {
                location = "List.aspx";
            }
        }
    });
}