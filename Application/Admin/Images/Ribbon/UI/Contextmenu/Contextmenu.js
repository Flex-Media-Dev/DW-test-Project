var __cm_view_triggers = [];

var ContextMenu = {

    callingID: null,
    callingItemID: null,
    callingControlID: null,

    // private attributes
    menuElement: null,

    setup: function () {
        //document.oncontextmenu = ContextMenu.show;
        document.onclick = ContextMenu.hide;
        document.oncontextmenu = ContextMenu.hide;
    },

    // private method. Shows context menu
    show: function (e, contextId, NodeID, NodeItemID, Position, positionTarget, controlID) {

        var trigger = null;
        var canDisplayMenu = true;

        if (e.ctrlKey == true) {
            e.returnValue = true;
            return true;
        }

        ContextMenu.hide();

        ContextMenu.callingID = NodeID;
        ContextMenu.callingItemID = NodeItemID;
        ContextMenu.callingControlID = controlID;

        if (contextId == "undefined") {
            return false;
        }

        var menuElementId = contextId;

        if (menuElementId) {
            var topPos = 0;
            var leftPos = 0;
            var onShow = document.getElementById(contextId + '_onShow');

            trigger = ContextMenuViewTrigger.getInstance(contextId);
            if (trigger) {
                canDisplayMenu = trigger.execute({ e: e, callingID: NodeID, callingItemID: NodeItemID, callingControlID: controlID });
            }

            if (canDisplayMenu) {
                ContextMenu.menuElement = document.getElementById(menuElementId);
                ContextMenu.menuElement.style.display = 'block';
                ContextMenu.collapse(ContextMenu.menuElement);

                var btns = ContextMenu.get_buttons(menuElementId);

                if (btns != null) {
                    for (i = 0; i < btns.length; i++) {
                        var ael = document.getElementById('href' + btns[i].id);

                        if (ael != null && ael.hasAttribute('ongetstate')) {
                            var res = ael.getAttribute('ongetstate');

                            if (res != '') {
                                var state = eval(res);

                                if (state == 'disabled')
                                    ael.className = 'button-disabled';
                                else
                                    ael.className = '';
                            }
                        }
                    }
                }

                var documentHeight = 0;
                if (document.documentElement.clientHeight)
                    documentHeight = document.documentElement.clientHeight;
                if (documentHeight == 0 && document.body.clientHeight)
                    documentHeight = document.body.clientHeight;

                var documentWidth = 0;
                if (document.documentElement.clientWidth)
                    documentWidth = document.documentElement.clientWidth;
                if (documentWidth == 0 && document.body.clientWidth)
                    documentWidth = document.body.clientWidth;

                if (typeof (Position) != 'undefined' && Position.top != null && Position.left != null) {
                    topPos = Position.top;
                    leftPos = Position.left;
                } else if (typeof (Position) == 'function') {
                    var pos = Position(e, documentWidth, documentHeight);
                    topPos = pos.top;
                    leftPos = pos.left;
                } else if (Position == 'BottomRightRelative') {
                    var elm = ContextMenu.getSrcPosition(e, positionTarget);
                    topPos = elm.y + elm.elm.offsetHeight;
                    leftPos = ContextMenu.getMousePosition(e).x;
                    if (elm.elm.closest) {
                        let modalBody = elm.elm.closest(".modal-body");
                        if (modalBody) {
                            leftPos = elm.x - modalBody.offsetLeft + 1;
                            documentWidth = modalBody.clientWidth;
                            documentHeight = modalBody.clientHeight;
                        }
                        if (ContextMenu.menuElement.offsetHeight + topPos > documentHeight) {
                            topPos -= ContextMenu.menuElement.offsetHeight;
                        }

                        if (ContextMenu.menuElement.offsetWidth + leftPos > documentWidth) {
                            leftPos -= ((ContextMenu.menuElement.offsetWidth + leftPos) - documentWidth);
                        }
                    }
                } else if (Position == 'BottomRight') {
                    var elm = ContextMenu.getSrcPosition(e, positionTarget);
                    topPos = elm.y + elm.elm.offsetHeight;
                    leftPos = elm.x + elm.elm.offsetWidth - ContextMenu.menuElement.offsetWidth + 1;
                } else if (Position == 'BottomLeft') {
                    var elm = ContextMenu.getSrcPosition(e, positionTarget);
                    topPos = elm.y + elm.elm.offsetHeight;
                    leftPos = elm.x;
                } else if (Position == 'TopRight') {
                    var elm = ContextMenu.getSrcPosition(e, positionTarget);
                    topPos = elm.y;
                    leftPos = elm.x + elm.elm.offsetWidth - ContextMenu.menuElement.offsetWidth + 1;
                } else if (Position == 'TopLeft') {
                    var elm = ContextMenu.getSrcPosition(e, positionTarget);
                    topPos = elm.y;
                    leftPos = elm.x;
                } else {
                    var m = ContextMenu.getMousePosition(e);
                    var s = ContextMenu.getScrollPosition(e);

                    topPos = m.y + s.y;
                    leftPos = m.x + s.x;

                    if (ContextMenu.menuElement.offsetHeight + topPos > documentHeight) {
                        //alert(ContextMenu.menuElement.offsetHeight);
                        topPos -= ContextMenu.menuElement.offsetHeight;
                    }

                    if (ContextMenu.menuElement.offsetWidth + leftPos > documentWidth) {
                        //alert(ContextMenu.menuElement.offsetHeight);
                        leftPos -= ((ContextMenu.menuElement.offsetWidth + leftPos) - documentWidth);
                    }
                }

                if (leftPos < 0)
                    leftPos = 0;

                if (topPos < 0)
                    topPos = 0;

                //Fix bug in firefox on mac
                if (navigator.userAgent.indexOf("Mac") != -1 && navigator.userAgent.indexOf("Firefox") != -1) {
                    ContextMenu.menuElement.style.left = (leftPos - 5) + 'px';
                    ContextMenu.menuElement.style.top = (topPos - 5) + 'px';
                }
                else {
                    ContextMenu.menuElement.style.left = leftPos + 'px';
                    ContextMenu.menuElement.style.top = topPos + 'px';
                }


                ContextMenu._attr(ContextMenu.menuElement, 'context_id', contextId);

                // Removed because it didn't work. -LDE May 29th 2009			
                //			if (ContextMenu.menuElement.offsetHeight > (documentHeight - ContextMenu.menuElement.offsetTop - 100)) {
                //				ContextMenu.menuElement.style.height = (documentHeight - ContextMenu.menuElement.offsetTop - 100) + 'px';
                //				ContextMenu.menuElement.style.overflow = "auto";
                //				ContextMenu.menuElement.style.width = (ContextMenu.menuElement.offsetWidth - 17) + 'px';
                //			}
                //			alert(ContextMenu.menuElement.offsetHeight);
                //			alert(ContextMenu.menuElement.offsetTop);
                //			alert(documentHeight);

                /* Executing 'OnShow' event handler */

                if (onShow && onShow.value.length > 0) {
                    eval(onShow.value);
                }
            }

            e.cancelBubble = true;
            return false;
        }
    },


    // private method. Hides context menu
    hide: function () {
        var contextId = '';
        var onHide = null;

        if (ContextMenu.menuElement) {
            if (window.navigator.userAgent.indexOf('MSIE 8.0') > 0) {
                ContextMenu.menuElement.style.left = -1000;
            }
            else {
                ContextMenu.menuElement.style.display = 'none';
            };

            contextId = ContextMenu._attr(ContextMenu.menuElement, 'context_id');

            if (contextId) {
                onHide = document.getElementById(contextId + '_onHide');
                if (onHide && onHide.value.length > 0) {
                    eval(onHide.value);
                }
            }
        }
    },


    // private method. Returns mouse position
    getMousePosition: function (e) {
        e = e ? e : window.event;
        var position = {
            'x': e.clientX,
            'y': e.clientY
        }

        return position;
    },

    getSrcPosition: function (e, positionTarget) {
        e = e ? e : window.event;

        var obj = positionTarget;
        if (!obj) {
            obj = e.srcElement ? e.srcElement : e.target;
        }
        var elem = obj;
        var curleft = 0;
        var curtop = 0;
        if (obj.offsetParent) {
            do {
                curleft += obj.offsetLeft;
                curtop += obj.offsetTop;
                obj = obj.offsetParent;
                if (obj && (obj.classList.contains("modal-body") || obj.classList.contains("boxbody"))) {
                    obj = null;
                }
            } while (obj);
        }
        var position = {
            'elm': elem,
            'x': curleft,
            'y': curtop
        }
        return position;
    },

    // private method. Get document scroll position
    getScrollPosition: function () {

        var x = 0;
        var y = 0;

        if (typeof (window.pageYOffset) == 'number') {
            x = window.pageXOffset;
            y = window.pageYOffset;
        } else if (document.documentElement && (document.documentElement.scrollLeft || document.documentElement.scrollTop)) {
            x = document.documentElement.scrollLeft;
            y = document.documentElement.scrollTop;
        } else if (document.body && (document.body.scrollLeft || document.body.scrollTop)) {
            x = document.body.scrollLeft;
            y = document.body.scrollTop;
        }

        var position = {
            'x': x,
            'y': y
        }

        return position;
    },

    expand: function (item) {
        if (item == null || item.parentNode == null || item.parentNode.parentNode == null)
            return;
        var current = item.parentNode;
        ContextMenu.collapse(current.parentNode, current);
        var submenu = ContextMenu.getSubMenu(current);
        if (submenu != null)
            ContextMenu.collapse(submenu);
        var next = item;
        while ((next = next.nextSibling) != null) {
            if (next.style && next.style.display == 'none' && next.className == 'submenu') {
                ContextMenu.showSubMenu(item.parentNode, next);
                break;
            }
        }
    },

    getSubMenu: function (parent) {
        if (parent == null || parent.childNodes.length == 0) return null;
        for (var i = 0; i < parent.childNodes.length; i++) {
            var item = parent.childNodes[i];
            if (item.className == 'submenu')
                return item;
        }
        return null;
    },

    showSubMenu: function (parent, item) {
        if (parent == null || item == null) return;

        ContextMenu.collapse(item);
        var leftPos = (parent.offsetWidth > 0 ? parent.offsetWidth : parent.parentNode.offsetWidth);
        var topPos = parent.offsetTop > 1 && parent.offsetTop > parent.offsetHeight ? parent.offsetTop : -1;

        var documentHeight = document.body.clientHeight;
        var documentWidth = document.body.clientWidth;

        if ((parseInt(parent.offsetParent.style.left) + leftPos*2 + 4) > documentWidth)
            leftPos = -leftPos - 4;
        else
            leftPos += 4;

        var height = parent.offsetHeight * item.childNodes.length;
        if (topPos + height > documentHeight)
            topPos = documentHeight - height;

        item.style.left = leftPos + 'px';
        item.style.top = topPos + 'px';
        item.style.position = 'absolute';
        item.style.display = 'block';
    },

    collapse: function (parent, current) {
        if (parent == null || parent.childNodes == null || parent.childNodes.length == 0) return;
        for (var i = 0; i < parent.childNodes.length; i++) {
            var item = parent.childNodes[i];
            if ((current == null || item.id != current.id) && item.tagName && item.style.display != 'none') {
                if (item.className == 'submenu') {
                    item.style.display = 'none';
                    item.style.position = 'relative';
                }
                ContextMenu.collapse(item, current);
            }
        }
    },

    set_isChecked: function (menuID, buttonID, isChecked) {
        var cmd = $$('div[id="' + menuID + '"] img[id="cmImg_' + buttonID + '"]');

        if (cmd != null && cmd.length > 0) {
            cmd = $(cmd[0]);

            if (isChecked) {
                if (!cmd.hasClassName('checked')) {
                    cmd.addClassName('checked');
                }

                cmd.removeClassName('icon');
                cmd.src = '/Admin/Images/Ribbon/UI/Contextmenu/BtnSelected.gif';
            } else {
                if (!cmd.hasClassName('icon')) {
                    cmd.addClassName('icon');
                }

                cmd.removeClassName('checked');
                cmd.src = cmd.readAttribute('_src');
            }
        }
    },

    get_isChecked: function (menuID, buttonID) {
        var ret = false;
        var cmd = $$('div[id="' + menuID + '"] img[id="cmImg_' + buttonID + '"]');

        if (cmd != null && cmd.length > 0) {
            cmd = cmd[0];
            ret = $(cmd).hasClassName('checked');
        }

        return ret;
    },

    get_buttons: function (menuID) {
        /// <summary>Returns a list of all menu buttons.</summary>
        /// <param name="menuID">An ID of the menu.</param>

        var ret = [];
        var menu = null;
        var items = null;

        if (menuID && menuID.length) {
            items = document.querySelectorAll('div[id="' + menuID + '"] > span[class~="container"] > span');
            if (items && items.length) {
                for (var i = 0; i < items.length; i++) {
                    if (items[i].querySelectorAll('a[class="divider"]').length == 0) {
                        ret[ret.length] = items[i];
                    }
                }
            }
        }

        return ret;
    },

    _attr: function (element, attrName, attrValue) {
        var ret = '';

        if (element) {
            if (typeof (attrValue) != 'undefined') {
                ret = element;

                if (element.setAttribute) {
                    element.setAttribute(attrName, attrValue);
                } else if (element.writeAttribute) {
                    element.writeAttribute(attrName, attrValue);
                }
            } else {
                if (element.getAttribute) {
                    ret = element.getAttribute(attrName);
                } else if (element.readAttribute) {
                    ret = element.readAttribute(attrName);
                }

                if (typeof (ret) != 'string') {
                    ret = '';
                }
            }
        }

        return ret;
    }
}

/* ---------------------------- ContextMenuViewTrigger class ---------------------------- */

var ContextMenuViewTrigger = function (params) {
    /// <summary>Initializes a new instance of a class.</summary>
    /// <param name="params">Object parametes.</param>

    this._menuID = '';
    this._views = [];
    this._onSelectView = null;
    this._dividers = null;

    if (params) {
        if (params.menuID) {
            this._menuID = params.menuID;
        }
    }
}

ContextMenuViewTrigger.getInstance = function (menuID) {
    /// <summary>Retrieves an instance of the trigger for the specified context-menu.</summary>
    /// <param name="menuID">An ID of the associated context-menu.</param>

    if (!__cm_view_triggers) {
        __cm_view_triggers = [];
    }

    if (menuID) {
        if (!__cm_view_triggers[menuID]) {
            __cm_view_triggers[menuID] = new ContextMenuViewTrigger({ menuID: menuID });
        }
    }

    return __cm_view_triggers[menuID];
}

ContextMenuViewTrigger.prototype.get_menuID = function () {
    /// <summary>Gets an ID of the associated context-menu.</summary>

    return this._menuID;
}

ContextMenuViewTrigger.prototype.add_selectView = function (callback) {
    /// <summary>Registers the "selectView" event callback.</summary>
    /// <param name="callback">Callback to register.</param>

    this._onSelectView = callback;
}

ContextMenuViewTrigger.prototype.remove_selectView = function () {
    /// <summary>Unregisters the "selectView" event callback.</summary>

    this._onSelectView = null;
}

ContextMenuViewTrigger.prototype.addView = function (name, buttons) {
    /// <summary>Adds new view.</summary>
    /// <param name="name">Name of the view.</param>
    /// <param name="buttons">An array of buttons IDs to be visible when the view is applied.</param>

    if (!this._views)
        this._views = [];

    this._views[name] = buttons;
}

ContextMenuViewTrigger.prototype.removeView = function (name) {
    /// <summary>Removes specified view.</summary>
    /// <param name="name">Name of the view.</param>

    if (!this._views)
        this._views = [];

    this._views[name] = null;
}

ContextMenuViewTrigger.prototype.hasView = function (name) {
    /// <summary>Determines whether specified view is defined.</summary>
    /// <param name="name">Name of the view.</param>

    var ret = false;

    if (this._views) {
        ret = this._views[name] != null;
    }

    return ret;
}

ContextMenuViewTrigger.prototype.getView = function (name) {
    /// <summary>Gets specified view.</summary>
    /// <param name="name">Name of the view.</param>

    var ret = null;

    if (this._views) {
        ret = this._views[name];
    }

    return ret;
}

ContextMenuViewTrigger.prototype.enableViewByName = function (name) {
    /// <summary>Enables specified view by its name.</summary>
    /// <param name="name">Name of the view.</param>

    return this.enableViewByButtonsIDs(this.getView(name));
}

ContextMenuViewTrigger.prototype.enableViewByButtonsIDs = function (buttons) {
    /// <summary>Enables specified view by provided button IDs.</summary>
    /// <param name="buttons">An array of button IDs to be shown.</param>

    var ret = false;
    var menuItems = null;
    var item = null;

    if (buttons && buttons.length > 0) {
        ret = true;
        menuItems = $$('div[id="' + this.get_menuID() + '"] > span[class~="container"] > span');

        /* Showing dividers */
        var dividers = this._getDividers()
        for (var i = 0; i < dividers.length; i++) {
            $(dividers[i]).show();
        }

        if (menuItems && menuItems.length > 0) {
            for (var i = 0; i < menuItems.length; i++) {
                item = menuItems[i];

                /* Showing button */
                if ((this._findIndex(buttons, item.id) >= 0)) {
                    /* Tracking all visible items (buttons & dividers) */
                    item.show();
                }
                else {
                    item.hide();
                }
            }

            /* Hiding unnecessary dividers */
            this._hideDividers();
        }
    }

    return ret;
}

ContextMenuViewTrigger.prototype.execute = function (callbackParams) {
    /// <summary>Executes trigger.</summary>
    /// <param name="callbackParams">Parameters to be passed to the "selectView" event handler.</param>
    /// <returns>Value indicating whether context-menu can be shown.</returns>

    var v = null;
    var ret = true;

    if (!callbackParams) {
        callbackParams = {};
    }

    if (typeof (this._onSelectView) == 'function') {
        v = this._onSelectView(this, callbackParams);
        if (v != null) {
            if (this._isString(v)) {
                ret = this.enableViewByName(v);
            } else if (this._isArray(v)) {
                ret = this.enableViewByButtonsIDs(v);
            }
        }
    }

    return ret;
}

ContextMenuViewTrigger.prototype._getDividers = function (itemId) {
    if (this._dividers === null || this._dividers === undefined) {
        this._dividers = $(this._menuID).select('div[class="divider"]')
    }

    if (itemId === null || itemId === undefined) {
        return this._dividers;
    }
    else {
        var result = [];

        for (var i = 0; i < this._dividers.length; i++) {
            if (this._dividers[i].readAttribute('data-for') === itemId) {
                result[result.length] = this._dividers[i];
            }
        }

        return result;
    }
}

ContextMenuViewTrigger.prototype._hideDividers = function () {
    /// <summary>Hides unnecessary dividers among the list of visible items.</summary>
    /// <param name="visibleItems">Items to examine.</param>

    var index = 0;
    var menu = $(this._menuID).getElementsBySelector('span.container');
    menu = $(menu)[0].childElements();

    // remove hidden elements 
    var length = menu.length;
    for (var i = 0; i < length; i++) {
        if (!$(menu[i - index]).visible()) {
            menu.splice(i - index, 1);
            index++;
        }
    }

    // remove dividers from start
    while ($(menu[0]).readAttribute('class') === 'divider') {
        $(menu[0]).hide();
        menu.shift();
    }

    // remove deviders from end
    index = menu.length - 1;
    while (index > 0 && $(menu[index]).readAttribute('class') == 'divider') {
        $(menu[index]).hide();
        menu.pop();
        index--;
    }

    // remove double dividers from body
    for (var i = 1; i < menu.length - 1; i++) {
        if ($(menu[i]).readAttribute('class') === 'divider' && $(menu[i + 1]).readAttribute('class') === 'divider') {
            $(menu[i]).hide();
        }
    }
}

ContextMenuViewTrigger.prototype._findIndex = function (list, element) {
    /// <summary>Finds index of the specified element in the list.</summary>
    /// <param name="list">List to search in.</param>
    /// <param name="element">Element whose index to retrieve.</param>

    var ret = -1;

    if (list && typeof (list) != 'undefined') {
        for (var i = 0; i < list.length; i++) {
            if (list[i] == element) {
                ret = i;
                break;
            }
        }
    }

    return ret;
}

ContextMenuViewTrigger.prototype._getClassName = function (obj) {
    /// <summary>Gets the name of the class of the given object.</summary>
    /// <param name="obj">Object to examine.</param>

    var ret = '';

    if (obj) {
        ret = Object.prototype.toString.call(obj).match(/^\[object\s(.*)\]$/)[1];
    }

    return ret;
}

ContextMenuViewTrigger.prototype._isArray = function (obj) {
    /// <summary>Determines whether specified object is a string.</summary>
    /// <param name="obj">Object to examine.</param>

    return this._getClassName(obj).toLowerCase() == 'array';
}

ContextMenuViewTrigger.prototype._isString = function (obj) {
    /// <summary>Determines whether specified object is an array.</summary>
    /// <param name="obj">Object to examine.</param>

    return this._getClassName(obj).toLowerCase() == 'string';
}

ContextMenu.setup();