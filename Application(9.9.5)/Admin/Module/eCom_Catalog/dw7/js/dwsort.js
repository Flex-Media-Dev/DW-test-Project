/**
* Helper class for sortable lists.
*
* @items container for sortable items.
* @comparators hash map for order comparators {columnId: function(item) {}}.
* @onUpdate update action.
*/
function DWSortable(items, comparators, onUpdate, format) {
    var that = this;
    this.sortedBy = "";
    this.items = $(items || 'items');
    this.comparators = $H(comparators);
    this.onUpdate = onUpdate || function() { }    
    this.format = format;

    if (format != null) {
        Sortable.create(this.items, { onUpdate: function () { that.onUpdate(); }, format: that.format });
    }
    else {
        Sortable.create(this.items, { onUpdate: function () { that.onUpdate(); } });
    }
}

DWSortable.prototype.sortBy = function(field) {
    var dir = this.sort(this.comparators.get(field), field);
    this.hideSortMarks();
    Element.show(field + (dir ? "_down" : "_up"));
    this.onUpdate();
}

DWSortable.prototype.sort = function(comparator, field) {
    var desc = this.sortedBy == field;
    this.sortedBy = desc ? "" : field;
    var rows = this.items.childElements().sortBy(comparator);
    if (desc) rows.reverse();

    this.updateItems(rows);
    return desc;
}

DWSortable.prototype.updateItems = function(rows) {
    var i = this.items;
    while (i.hasChildNodes())
        i.removeChild(i.firstChild);
    rows.each(function f(e) { i.appendChild(e) });
}

DWSortable.prototype.hideSortMarks = function() {
    this.comparators.keys().each(function(e) {
        $(e + "_down").hide();
        $(e + "_up").hide();
    });
}