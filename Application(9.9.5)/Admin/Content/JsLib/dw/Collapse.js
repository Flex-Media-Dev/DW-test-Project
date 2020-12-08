var _tree = null;
var _master = null;
var _keyCache = null

var Tree = new Object();

Tree.MasterPage = function() {
    this.controlID = '';
    this._cache = {};

    this._events = new EventsManager();

    this._events.registerEvent('contentReady');
}

Tree.MasterPage.getInstance = function() {
    if (_master == null) {
        _master = new Tree.MasterPage();
    }

    return _master;
}

Tree.SystemTree = function(innerTree) {
    this._isCollapsed = false;
    this.innerTree = innerTree;

    this._infos = new Hash();

    var collapsed = this._getCookieValue(_keyCache);
    if (collapsed == "true")
        this.toggleCollapse(collapsed);
}

Tree.SystemTree.getInstance = function() {
    if (_tree == null) {
        _tree = new Tree.SystemTree(eval('t'));
    }

    return _tree;
}

Tree.SystemTree.prototype.get_isCollapsed = function() {
    /// <summary>Gets value indicating whether tree is collapsed.</summary>

    return this._isCollapsed;
}

Tree.SystemTree.prototype.toggleCollapse = function (forceCollapse) {
    /// <summary>Toggles the "Collapsed" state of the tree.</summary>

    var stretchers = null;
    var elm = null, f = null;
    var toggleElements;

    alert("collapse");

    if (!top.document.getElementById("MainFrame") && $("accordion1")) {
        toggleElements = [
            { selector: 'cellTreeCollapsed', onExpand: function () { this.hide(); }, onCollapse: function () { this.show(); } },
            { selector: 'treeContainer', onExpand: function () { this.show(); }, onCollapse: function () { this.hide(); } },
            { selector: 'cellContent', onExpand: function () { this.removeClassName("tree-collapsed"); }, onCollapse: function () { this.addClassName("tree-collapsed"); } },
        ];
    }
    else {
        toggleElements = [
            { selector: 'cellTreeCollapsed', onExpand: function () { this.hide(); }, onCollapse: function () { this.show(); } },
            { selector: 'treeContainer', onExpand: function () { this.show(); }, onCollapse: function () { this.hide(); } },
            { selector: 'accordion1', onExpand: function () { this.show(); }, onCollapse: function () { this.hide(); } },
            { selector: 'cellContent', onExpand: function () { this.removeClassName("tree-collapsed"); }, onCollapse: function () { this.addClassName("tree-collapsed"); } },
        ];
    }

    if (typeof forceCollapse != "undefined")
        this._isCollapsed = forceCollapse;
    else
        this._isCollapsed = !this._isCollapsed;

    for (var i = 0; i < toggleElements.length; i++) {
        elm = $(toggleElements[i].selector);

        if (elm) {
            if (elm.length > 0) {
                elm = $(elm[0]);
            }

            if (this._isCollapsed) {
                f = toggleElements[i].onCollapse;
            } else {
                f = toggleElements[i].onExpand;
            }

            f.apply(elm);
        }
    }

    if (typeof (List) != 'undefined') {
        stretchers = List.get_stretchers();
        if (stretchers && stretchers.length > 0) {
            for (var i = 0; i < stretchers.length; i++) {
                stretchers[i].adjustSize();
            }
        }
    }

    this._createCookie(_keyCache, this._isCollapsed);
}

Tree.SystemTree.prototype._createCookie = function (name, value, days) {
    var dt = null;
    var expires = '';

    if (days) {
        dt = new Date();
        dt.setTime(dt.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = '; expires=' + dt.toGMTString();
    }

    var domain = document.domain;
    if (domain.indexOf("www.") == 0) {
        domain = domain.substring(4, domain.length);
    }
    document.cookie = name + '=' + value + expires + '; path=/; domain=' + domain
}

Tree.SystemTree.prototype._getCookieValue = function (name) {
    var ret = null;
    var cookieItem = null;
    var nameEq = name + '=';
    var cookies = document.cookie.split(';');

    for (var i = 0; i < cookies.length; i++) {
        cookieItem = cookies[i];

        while (cookieItem.charAt(0) == ' ') {
            cookieItem = cookieItem.substring(1, cookieItem.length);
        }

        if (cookieItem.indexOf(nameEq) == 0) {
            ret = cookieItem.substring(nameEq.length, cookieItem.length);
            break;
        }
    }
    return ret;
}