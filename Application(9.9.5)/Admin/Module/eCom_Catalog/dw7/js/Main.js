var _eCom_tree = null;
var _eCom_master = null;

var eCommerce = new Object();

PermissionLevels = {
    PermissionLevelNone: 1,
    PermissionLevelRead: 4,
    PermissionLevelEdit: 20,
    PermissionLevelCreate: 84,
    PermissionLevelDelete: 340,
    PermissionLevelAll: 1364,
}

eCommerce.MasterPage = function() {
    this.controlID = '';
    this._cache = {};
    this._terminology = {};

    this._events = new EventsManager();

    this._events.registerEvent('contentReady');

    this._isBusy = false;
}

eCommerce.MasterPage.getInstance = function() {
    if (_eCom_master == null) {
        _eCom_master = new eCommerce.MasterPage();
    }

    return _eCom_master;
}

eCommerce.MasterPage.prototype.get_terminology = function ()
{
    if (!this._terminology)
        this._terminology = {};

    return this._terminology;
}

eCommerce.MasterPage.prototype.initialize = function (controlID) {
    var obj = this;

    this.controlID = controlID;
    this.initializeCache();

    eCommerce.ResizeHandle.attach({
        handleID: 'sliderHandle',
        contentID: 'cellTree',
        minimumSize: 200,
        maximumSize: 450
    });

    //this.stretchTreeContent();

    Event.observe(window, 'resize', function () {
        if (Dynamicweb && Dynamicweb.Controls && Dynamicweb.Controls.StretchedContainer) {
            if (Dynamicweb.Controls.StretchedContainer.get_documentSizeChanged()) {
                obj.stretchTreeContent();
            }
        }
    });

    eCommerce.SystemTree.getInstance().initialize();

    this.notify('contentReady');
}

eCommerce.MasterPage.prototype.add_contentReady = function(handler) {
    this._events.addHandler('contentReady', handler);
}

eCommerce.MasterPage.prototype.notify = function(eventName, args) {
    this._events.notify(eventName, this, args);
}

eCommerce.MasterPage.prototype.initializeCache = function() {
    this._cache = {};

    this._cache.body = $(document.body);
    this._cache.tree = $($$('div.tree')[0]);
    this._cache.accordion = $($$('div.accordion')[0]);
    this._cache.accordionContainer = $('accordionContainer');
    this._cache.treeTitleOffset = $('treeEndMarker').cumulativeOffset();
}

eCommerce.MasterPage.prototype.dispose = function() {
    eCommerce.ResizeHandle.disposeAll();
}

eCommerce.MasterPage.onAccordionContextMenuView = function (sender, arg) {
    return arg.callingID;
}

eCommerce.MasterPage.onAccordionContextMenu = function (sender, arg) {
    window.open('/Admin/Default.aspx?accordionAction=' + arg);
    return false;
}

eCommerce.MasterPage.prototype.stretchTreeContent = function() {
    //var accordionHeight = this._cache.accordion.getHeight();
    //var containerHeight = this._cache.body.getHeight() - this._cache.treeTitleOffset.top - accordionHeight;
    var containerHeight = this._cache.body.getHeight()
    if (containerHeight > 0) {
        this._cache.tree.style.height = (containerHeight - 75) + 'px';
        //this._cache.accordionContainer.style.top = (containerHeight + this._cache.treeTitleOffset.top - 1) + 'px';
    }
}

eCommerce.MasterPage.prototype.get_isBusy = function() {
    /// <summary>Gets value indicating whether page is processing some kind of background action.</summary>

    return this._isBusy;
}

eCommerce.MasterPage.prototype.set_isBusy = function(value) {
    /// <summary>Sets value indicating whether page is processing some kind of background action.</summary>
    /// <param name="value">Value indicating whether page is processing some kind of background action.</param>

    this._isBusy = value;

    if (value) {
        document.body.style.cursor = 'progress';
    } else {
        document.body.style.cursor = 'auto';
    }
}

eCommerce.SystemTree = function(innerTree) {
    this._isCollapsed = false;
    this.innerTree = innerTree;

    this._infos = new Hash();
    
    var collapsed = this._getCookieValue("TreeShopIsCollapsed");
    if (collapsed == "true")
        this.toggleCollapse(collapsed);
}

eCommerce.SystemTree.getInstance = function() {
    if (_eCom_tree == null) {
        _eCom_tree = new eCommerce.SystemTree(eval('t'));
    }

    return _eCom_tree;
}

eCommerce.SystemTree.prototype.get_isCollapsed = function() {
    /// <summary>Gets value indicating whether tree is collapsed.</summary>

    return this._isCollapsed;
}

eCommerce.SystemTree.prototype.getInfo = function(nodePath) {
    /// <summary>Gets the custom information associated with the specified node.</summary>
    /// <param name="nodePath">Target node path.</param>

    return this._infos.get(nodePath);
}

eCommerce.SystemTree.prototype.setInfo = function(nodePath, info) {
    /// <summary>Associates the custom information with the specified node.</summary>
    /// <param name="nodePath">Target node path.</param>
    /// <param name="info">Information to be associated with the specified node.</param>

    this._infos.set(nodePath, info);
}

eCommerce.SystemTree.prototype.toggleCollapse = function(forceCollapse) {
    /// <summary>Toggles the "Collapsed" state of the tree.</summary>

    var stretchers = null;
    var elm = null, f = null;

    var toggleElements = [
        { selector: 'cellTreeCollapsed', onExpand: function() { this.hide(); }, onCollapse: function() { this.show(); } },
        { selector: 'cellTree', onExpand: function() { this.show(); }, onCollapse: function() { this.hide(); } },
        { selector: 'treeEndMarker', onExpand: function() { this.show(); }, onCollapse: function() { this.hide(); } },
        { selector: 'sliderHandle', onExpand: function () { this.show(); }, onCollapse: function () { this.hide(); } },
        { selector: 'cellContent', onExpand: function () { this.removeClassName("tree-collapsed"); }, onCollapse: function () { this.addClassName("tree-collapsed"); } },
    ];

    if (typeof forceCollapse != "undefined")
        this._isCollapsed = forceCollapse;
    else
        this._isCollapsed = !this._isCollapsed;

    for (let i = 0; i < toggleElements.length; i++) {
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

    if (!this._isCollapsed) {
        eCommerce.MasterPage.getInstance().stretchTreeContent();
    }

    if (typeof (List) != 'undefined') {
        stretchers = List.get_stretchers();
        if (stretchers && stretchers.length > 0) {
            for (let i = 0; i < stretchers.length; i++) {
                stretchers[i].adjustSize();
            }
        }
    }

    this._createCookie("TreeShopIsCollapsed", this._isCollapsed);
}

eCommerce.SystemTree.prototype.setShopFilter = function(shopID) {
    if (this.innerTree) {
        this.innerTree.clearCookie();
    }

    this._createCookie('TreeShopFilterApplied', 'True');
    this._createCookie('TreeShopFilter', shopID);

    location.href = location.href;
}

eCommerce.SystemTree.prototype.getShopFilter = function() {
    var ret = this._getCookieValue('TreeShopFilter');

    if (ret == null) {
        ret = '';
    }

    return ret;
}

eCommerce.SystemTree.prototype.get_showAllShops = function() {
    return this.getShopFilter().toLowerCase() == 'all';
}

eCommerce.SystemTree.prototype.nodeClick = function(nodePath, nodeID, action, resetTreeState) {
    var arg = '';

    if (typeof (action) == 'function') {
        action(nodePath);
    } else if (typeof (action) == 'string') {
        if (action.indexOf('javascript:') == 0) {
            eval(action.replace('javascript:', ''));
        } else {
            this._createCookie('TreeNodePath', nodePath, 30);
            this._createCookie('TreeNavigateUrl', encodeURI(action), 30);

            if (resetTreeState) {
                this._createCookie('TreeResetStateRequested', 'True');
            }

            if (this.innerTree) {
                this.setSelectedNode(nodePath);
            }

            if (['SALESDISCOUNTS', 'LOYALTYPOINTS', 'VOUCHERS', 'GIFTCARDS', 'FAVORITELISTS/user_favoritelist', 'FAVORITELISTS/group_favoritelist'].indexOf(nodePath.substring(1)) >= 0) {
                this.openScreen(action);
            } else if (nodePath.indexOf('/ORDERDISCOUNTS') == 0) {
            		this.openScreen(action, true);
            } else {
                location.href = action;
            }
        }
    }
}

eCommerce.SystemTree.prototype.openScreen = function (path, hidePadding) {
    document.getElementById('slave-content').addClassName('hidden');
    var frame = document.getElementById('ecom-main-iframe');
    var frameDoc = frame.contentDocument || frame.contentWindow.document;
    var screenLoader = frameDoc.getElementById("screenLoaderOverlay");
    if (!screenLoader) {
        var cnt = frameDoc.body;
        if (cnt) {
            var overlayHtml = '<div class="overlay-container" id="screenLoaderOverlay"><div class="overlay-panel"><i class="fa fa-refresh fa-3x fa-spin"></i></div></div> ';
            cnt.insertAdjacentHTML("afterbegin", overlayHtml);
        }
    } else {
        screenLoader.style.display = "block";
    }
    frame.removeClassName('hidden');
    frame.src = path;
    frame.onload = function () {
        if (!hidePadding) {
            document.querySelector('#cellContent > .screen-container').classList.add("open-screen-padding");
        } else {
            document.querySelector('#cellContent > .screen-container').classList.remove("open-screen-padding");
        }
        if (screenLoader && screenLoader.style){
        	screenLoader.style.display = "none";
        }
    }
}

eCommerce.SystemTree.prototype.setSelectedNode = function (path) {
    this._createCookie('TreeNavigateToNode', encodeURIComponent(path));
}

eCommerce.SystemTree.prototype.findNode = function(itemID) {
    var ret = null;

    if (this.innerTree) {
        for (var i = 0; i < this.innerTree.aNodes.length; i++) {
            if (this.innerTree.aNodes[i].itemID == itemID) {
                ret = this.innerTree.aNodes[i];
                break;
            }
        }
    }

    return ret;
}

eCommerce.SystemTree.prototype.getTrailingID = function(nodeID) {
    var n = null;
    var ret = '';
    var components = [];

    if (this.innerTree) {
        n = this.innerTree.getNodeByID(nodeID);

        if (n) {
            ret = n.itemID;

            if (ret.indexOf('/') >= 0) {
                components = ret.split('/');

                if (components.length > 0) {
                    ret = components[components.length - 1];
                }
            }
        }
    }

    return ret;
}

eCommerce.SystemTree.prototype._createCookie = function(name, value, days) {
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

eCommerce.SystemTree.prototype._getCookieValue = function(name) {
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

eCommerce.SystemTree.prototype.markNode = function(nodePath) {
    var n = null;
    
    if (nodePath && this.innerTree) {
        n = this.findNode(nodePath);

        if (n) {
            this.innerTree.ajax_markNode(n.id, true);
            if (this.innerTree.getChildren(n.id).length == 0) {
                this.innerTree.ajax_setNoChildren(n.id);
            }
        }

        if (this.innerTree.config.useCookies) {
            this.innerTree.updateCookie();
        }
    }
}


eCommerce.SystemTree.prototype.markNodesAsLoaded = function(nodeIDs) {
    if (nodeIDs && nodeIDs.length > 0) {
        if (this.innerTree) {
            for (var i = 0; i < nodeIDs.length; i++) {
                this.innerTree.ajax_markNode(nodeIDs[i], true);
            }

            if (this.innerTree.config.useCookies)
                this.innerTree.updateCookie();
        }
    }
}

eCommerce.SystemTree.prototype.initialize = function() {
    var self = this;
    var settings = null;

    if (this.innerTree) {
        settings = this.innerTree.get_dragDropSettings();

        if (settings) {
            settings.add_dragStart(function (sender, args) {
                ContextMenu.hide();
            });

            settings.add_drop(function (sender, args) {
                var pos = null;
                var contextMenuID = '';
                var scrollOffset = null;
                var sourceNodeID = parseInt(args.get_source().readAttribute('NodeID'));
                var targetNodeID = parseInt(args.get_target().readAttribute('NodeID'));

                contextMenuID = self._pickUpDropContextMenuID(sourceNodeID, targetNodeID);

                if (contextMenuID.length > 0) {
                    pos = args.get_target().cumulativeOffset();
                    scrollOffset = args.get_target().cumulativeScrollOffset();

                    if (scrollOffset) {
                        pos.left -= scrollOffset.left;
                        pos.top -= scrollOffset.top;
                    }

                    if (pos.left < 0) pos.left = 0;
                    if (pos.top < 0) pos.top = 0;
                    setTimeout(() => {
                        ContextMenu.show(args.get_event(), contextMenuID, targetNodeID, sourceNodeID + ':' + targetNodeID, { left: pos.left, top: pos.top + 14 });
                    }, 100);
                } else {
                    self.innerTree.get_dragDropManager().showTooltip(targetNodeID,
                        $('spUnableToDrop').innerHTML);
                }
            });
        }
    }
}

eCommerce.SystemTree.prototype.onDropMenuVisibilityChanged = function(isVisible) {
    var target = this.innerTree.get_dragDropManager().get_lastDropTarget();

    if (target) {
        if (isVisible) {
            target.addClassName('eComNodeHighlighted');
        } else {
            target.removeClassName('eComNodeHighlighted');
        }
    }
}

eCommerce.SystemTree.prototype.onDropMenuAction = function(action) {
    var ids = [];
    var self = this;
    var params = null;
    var targetLevel = -1;
    var canContinue = true;
    var sourceParentNodeID = -1;
    var sourceID = null, targetID = null;
    var sourceNodeID = -1, targetNodeID = -1;
    if (ContextMenu.callingItemID) {
    	ids = ContextMenu.callingItemID.split(':');
    }
    ContextMenu.hide();

    if (action != null && typeof (action) == 'string') {
        
            if (ids && ids.length > 1) {
                sourceNodeID = parseInt(ids[0]);
                targetNodeID = parseInt(ids[1]);

                sourceID = this.getTrailingID(sourceNodeID);
                targetID = this.getTrailingID(targetNodeID);

                params = {
                    Action: action,
                    SourceID: sourceID,
                    TargetID: targetID
                };

                if (action.toLowerCase() == 'movetogroup') {

                    if (this.innerTree) {
                        targetLevel = this.innerTree.getNodeLevel(targetNodeID);

                        if ((this.get_showAllShops() && targetLevel == 2) || (!this.get_showAllShops() && targetLevel == 1)) {
                            canContinue = confirm($('spMoveToShop').innerHTML);
                        }

                        if (canContinue) {
                            for (var i = 0; i < this.innerTree.aNodes.length; i++) {
                                if (this.innerTree.aNodes[i].id == sourceNodeID) {
                                    sourceParentNodeID = this.innerTree.aNodes[i].pid;
                                    break;
                                }
                            }
                        }
                    }

                    if (sourceParentNodeID > 0) {
                        params.SourceParentID = this.getTrailingID(sourceParentNodeID);
                    }
                }

                if (canContinue) {
                    eCommerce.MasterPage.getInstance().set_isBusy(true);
                    this.updateGroup(params, function(status) {
                        var code = null;
                        var targetNode = null;

                        eCommerce.MasterPage.getInstance().set_isBusy(false);

                        if (status && status.statusCode && typeof (status.statusCode) == 'string') {
                            code = status.statusCode.toLowerCase();

                            if (code != 'unchanged') {
                                if (code == 'success') {
                                    targetNode = self.innerTree.getNodeByID(targetNodeID);

                                    self._createCookie('TreeResetStateRequested', 'True');
                                    self.setSelectedNode(targetNode.itemID + '/' + params.SourceID);

                                    location.href = '/Admin/Module/eCom_Catalog/dw7/ProductList.aspx?GroupID=' + params.SourceID;
                                } else {
                                    alert(status.message);
                                }
                            }
                        }
                    });
                }
            }
        
    }
}

eCommerce.SystemTree.prototype.updateGroup = function(params, onUpdated) {
    if (params) {
        new Ajax.Request('/Admin/Module/eCom_Catalog/dw7/edit/GroupHandler.aspx?t=' + (new Date().getTime()), {
            method: 'get',
            parameters: params,
            evalJSON: true,
            onComplete: function(transport) {
                if (typeof (onUpdated) != 'undefined') {
                    onUpdated(transport.responseJSON);
                }
            }
        });
    }
}

eCommerce.SystemTree.prototype._pickUpDropContextMenuID = function(sourceNodeID, targetNodeID) {
    var ret = '';
    var sourceParent = null, targetParent = null;

    if (!eCommerce.MasterPage.getInstance().get_isBusy()) {
        if (this._canShowDropContextMenu(sourceNodeID, targetNodeID)) {
            ret = 'GroupDropMenuMove';

            if (!this.get_showAllShops()) {
                if (this.innerTree.getNodeLevel(targetNodeID) != 1) {
                    if (this.innerTree.getNodeLevel(sourceNodeID) > 2) {
                        ret = 'GroupDropMenu';
                    }
                }
            } else {
                if (this.innerTree.getNodeLevel(sourceNodeID) > 3) {
                    sourceParent = this.innerTree.getParent(sourceNodeID, 2);
                    targetParent = this.innerTree.getParent(targetNodeID, 2);

                    if (sourceParent != null && targetParent != null) {
                        if (sourceParent.id == targetParent.id) {
                            ret = 'GroupDropMenu';
                        }
                    }
                }
            }
        }
    }

    return ret;

}

eCommerce.SystemTree.prototype._canShowDropContextMenu = function(sourceNodeID, targetNodeID) {
    var ret = false;

    if (sourceNodeID != targetNodeID) {
        if (this.innerTree) {
            ret = !this.innerTree.isParent(targetNodeID, sourceNodeID);
            if (ret) {
                ret = !this.innerTree.isDirectParent(sourceNodeID, targetNodeID);
            }
        }
    }

    return ret;
}

eCommerce.SystemTree.prototype.refreshTree = function () {
    location.href = location.href;
}

eCommerce.ResizeHandleDirection = {
    Vertical: 1,
    Horizontal: 2
}

eCommerce.ResizeHandle = function(content, direction) {
    this.content = content;
    this.direction = direction;
    this.prevCoordinates = null;

    this.minimumSize = 0;
    this.maximumSize = 300;
}

eCommerce.ResizeHandle._handleIDs = [];
eCommerce.ResizeHandle._activeHandle = null;
eCommerce.ResizeHandle._globalEventsHandled = false;

eCommerce.ResizeHandle.attach = function(params) {
    var body = null;
    var handle = null;
    var content = null;
    var handleObj = null;
    var minSize = 0, maxSize = 450;
    var direction = eCommerce.ResizeHandleDirection.Horizontal;

    if (params) {
        if (params.direction) {
            direction = params.direction;
        }

        if (typeof (params.minimumSize) != 'undefined') {
            minSize = params.minimumSize;
        }

        if (typeof (params.maximumSize) != 'undefined') {
            maxSize = params.maximumSize;
        }

        if (params.handleID && params.contentID) {
            if (!eCommerce.ResizeHandle.isAttached(params.handleID)) {
                handle = $(params.handleID);
                content = $(params.contentID);

                if (handle && content) {
                    handleObj = new eCommerce.ResizeHandle(content, direction);

                    handleObj.minimumSize = minSize;
                    handleObj.maximumSize = maxSize;

                    eCommerce.ResizeHandle._handleIDs[eCommerce.ResizeHandle._handleIDs.length] = params.handleID;
                    eCommerce.ResizeHandle.set_handleObject(handle, handleObj);

                    Event.observe(handle, 'mousedown', function(event) {
                        eCommerce.ResizeHandle._setEnableSelection(false);
                        eCommerce.ResizeHandle._activeHandle = eCommerce.ResizeHandle.get_handleObject(Event.element(event));
                    });

                    if (!eCommerce.ResizeHandle._globalEventsHandled) {
                        body = $(document.body);

                        if (body) {
                            Event.observe(body, 'mousemove', function(event) {
                                var delta = 0;
                                var dimension = 0;
                                var coordinates = {};

                                if (eCommerce.ResizeHandle._activeHandle != null) {
                                    coordinates = {
                                        x: Event.pointerX(event),
                                        y: event.pointerY(event)
                                    }

                                    if (eCommerce.ResizeHandle._activeHandle.content != null) {
                                        if (!eCommerce.ResizeHandle._activeHandle.prevCoordinates) {
                                            eCommerce.ResizeHandle._activeHandle.prevCoordinates = {
                                                x: coordinates.x,
                                                y: coordinates.y
                                            }

                                            body.style.cursor = 'e-resize';
                                            if (typeof (ContextMenu) != 'undefined') {
                                                ContextMenu.hide();
                                            }
                                        } else {
                                            if (eCommerce.ResizeHandle._activeHandle.direction == eCommerce.ResizeHandleDirection.Vertical) {
                                                dimension = eCommerce.ResizeHandle._activeHandle.content.style.height;
                                                delta = coordinates.y - eCommerce.ResizeHandle._activeHandle.prevCoordinates.y;
                                            } else {
                                                dimension = eCommerce.ResizeHandle._activeHandle.content.style.width;
                                                delta = coordinates.x - eCommerce.ResizeHandle._activeHandle.prevCoordinates.x;
                                            }

                                            if (dimension != null && dimension.length > 0) {
                                                dimension = parseInt(dimension.replace(/px/gi, ''));

                                                if (!isNaN(dimension)) {
                                                    dimension += delta;

                                                    if (dimension >= eCommerce.ResizeHandle._activeHandle.minimumSize && dimension <= eCommerce.ResizeHandle._activeHandle.maximumSize) {
                                                        if (eCommerce.ResizeHandle._activeHandle.direction == eCommerce.ResizeHandleDirection.Vertical) {
                                                            eCommerce.ResizeHandle._activeHandle.content.style.height = dimension + 'px';
                                                        } else {
                                                            eCommerce.ResizeHandle._activeHandle.content.style.width = dimension + 'px';
                                                        }

                                                        eCommerce.ResizeHandle._activeHandle.prevCoordinates = coordinates;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            });

                            Event.observe(body, 'mouseup', function(event) {
                                eCommerce.ResizeHandle._setEnableSelection(true);

                                if (eCommerce.ResizeHandle._activeHandle != null) {
                                    eCommerce.ResizeHandle._activeHandle.prevCoordinates = null;
                                    eCommerce.ResizeHandle._activeHandle = null;
                                }

                                body.style.cursor = 'auto';
                            });
                        }

                        eCommerce.ResizeHandle._globalEventsHandled = true;
                    }
                }
            }
        }
    }
}

eCommerce.ResizeHandle.detach = function(handleID) {
    eCommerce.ResizeHandle.set_handleObject(handleID, null);
}

eCommerce.ResizeHandle.isAttached = function(handleID) {
    var ret = false;

    if (eCommerce.ResizeHandle._handleIDs) {
        for (var i = 0; i < eCommerce.ResizeHandle._handleIDs.length; i++) {
            if (eCommerce.ResizeHandle._handleIDs == handleID) {
                ret = true;
                break;
            }
        }
    }

    return ret;
}

eCommerce.ResizeHandle.disposeAll = function() {
    if (eCommerce.ResizeHandle._handleIDs) {
        for (var i = 0; i < eCommerce.ResizeHandle._handleIDs.length; i++) {
            eCommerce.ResizeHandle.detach(eCommerce.ResizeHandle._handleIDs[i]);
        }
    }
}

eCommerce.ResizeHandle.get_handleObject = function(handle) {
    var ret = null;

    if (typeof (handle) == 'string') {
        handle = $(handle);
    }

    if (handle) {
        ret = handle.__resizeHandler;
    }

    return ret;
}

eCommerce.ResizeHandle.set_handleObject = function(handle, handleObj) {
    if (typeof (handle) == 'string') {
        handle = $(handle);
    }

    if (handle) {
        handle.__resizeHandler = handleObj;
    }
}

eCommerce.ResizeHandle._setEnableSelection = function(isEnabled) {
    var useMozillaApproach = typeof (document.body.style.MozUserSelect) != 'undefined';

    if (isEnabled) {
        if (useMozillaApproach) {
            document.body.style.MozUserSelect = '';
        } else {
            Event.stopObserving(document.body, 'selectstart', eCommerce.ResizeHandle._disableSelection);
        }
    } else {
        if (useMozillaApproach) {
            document.body.style.MozUserSelect = 'none';
        } else {
            Event.observe(document.body, 'selectstart', eCommerce.ResizeHandle._disableSelection);
        }
    }
}

eCommerce.ResizeHandle._disableSelection = function(event) {
    event.cancelBubble = true;
    Event.stop(event);
    return false;
}

eCommerce.callingGroupID = function() {
    var shopID = eCommerce.callingShopID();
    var nodePath = ContextMenu.callingItemID;

    if (nodePath.indexOf('/') < 0) {
        return;
    }

    var components = nodePath.split('/');
    var groupId;

    if (components.length > 0) {
        groupId = components[components.length - 1];
    }

    if (groupId == shopID) {
        groupId = '';
    }

    return groupId;
}

eCommerce.callingShopID = function() {
    var ret = '';
    var components = [];
    var nodePath = ContextMenu.callingItemID;
    var tree = eCommerce.SystemTree.getInstance();

    if (tree.get_showAllShops()) {
        if (nodePath.lastIndexOf('/') > 0) {
            components = nodePath.split('/');
            if (components != null && components.length > 2) {
                ret = components[2];
            }
        }
    } else {
        ret = tree.getShopFilter();
    }

    return ret;
}

eCommerce.newProduct = function() {
    eCommerce.updateTreeAfterContextMenu();

    var url = "/admin/module/ecom_catalog/dw7/edit/EcomProduct_Edit.aspx?GroupID=" + eCommerce.callingGroupID();
    document.location.href = url;
}

eCommerce.appendProduct = function() {
    eCommerce.updateTreeAfterContextMenu();
    window.open("/admin/module/ecom_catalog/dw7/edit/EcomGroupTree.aspx?CMD=ShowProdGroupList&AppendType=AppendProduct&MasterGroupID=" + eCommerce.callingGroupID(), "", "displayWindow,width=460,height=400,scrollbars=no");
}

eCommerce.sortProducts = function() {
    eCommerce.updateTreeAfterContextMenu();

    var url = "/Admin/Module/eCom_Catalog/dw7/ProductListSort.aspx?GroupID=" + eCommerce.callingGroupID();
    document.location.href = url;
}

eCommerce.editGroup = function() {
    eCommerce.updateTreeAfterContextMenu();

    var url = "/admin/module/ecom_catalog/dw7/Edit/EcomGroup_Edit.aspx?ID=" + eCommerce.callingGroupID();
    document.location.href = url;
}

eCommerce.newGroup = function() {
    eCommerce.updateTreeAfterContextMenu();

    var url = "/admin/module/ecom_catalog/dw7/Edit/EcomGroup_Edit.aspx?shopID=" + eCommerce.callingShopID() + "&parentID=" + eCommerce.callingGroupID();
    document.location.href = url;
}

eCommerce.appendGroup = function() {
    eCommerce.updateTreeAfterContextMenu();
    window.open("/admin/module/ecom_catalog/dw7/Edit/EcomGroupTree.aspx?CMD=ShowGroup&AppendType=AppendGroup&MasterGroupID=" + eCommerce.callingGroupID() + "&MasterShopID=" + eCommerce.callingShopID(), "", "displayWindow,width=460,height=400,scrollbars=no");
}

eCommerce.deleteGroup = function () {
    if (eCommerce.getStateForDeleteAction() == "disabled") {
        return false;
    }
    var cur = document.body.style.cursor;
    document.body.style.cursor = 'wait';
    new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=ShopCheckForProducts&groupID=" + eCommerce.callingGroupID() + "&shopID=" + eCommerce.callingShopID(), {
        method: 'get',
        onSuccess: function(transport) {
            document.body.style.cursor = cur;
            var alertmsg = transport.responseText;
            if (confirm(alertmsg)) {
                var url = "/admin/module/ecom_catalog/dw7/Edit/EcomGroup_Edit.aspx?ID=" + eCommerce.callingGroupID() + "&deleteGroup=1";
                document.location.href = url;
            }
        },
        onComplete: function(transport) {
            document.body.style.cursor = cur;
        }
    });
}

eCommerce.getStateForDeleteAction = function () {
    var node = eCommerce.SystemTree.getInstance().findNode(ContextMenu.callingItemID);
    if (node.additionalCssClass.lastIndexOf("action-delete-disabled") > -1)
        return 'disabled';
    else
        return 'enabled';
}

eCommerce.permissions = function (cmd) {
    var id = '';
    var page = '';
    var info = null;
    var nodeName = "";
    var permCmd = 'GROUP';
    var showBasic = false;
    var node = eCommerce.SystemTree.getInstance().findNode(ContextMenu.callingItemID);

    if (node) {
        nodeName = node.name;
    }

    if (cmd) {
        permCmd = cmd;
    }

    /* Displaying permission window for orders */
    if (permCmd.toLowerCase() == 'orders') {
        showBasic = true;

        /* Trying to retrieve node-specific information */
        info = eCommerce.SystemTree.getInstance().getInfo(ContextMenu.callingItemID);
        if (info != null && info.nodeRowID) {
            /* We've got a database row ID specified - this is an "Orders" node (which resides in a root) */
            permCmd = 'ORDERS';
            id = info.nodeRowID;
        } else {
            /* This is a orders node which references to a specific shop */
            permCmd = 'SHOPORDER';
            id = eCommerce.callingShopID();
        }
    }
    else if (permCmd.toLowerCase() == 'quotes') {
        showBasic = true;

        /* Trying to retrieve node-specific information */
        info = eCommerce.SystemTree.getInstance().getInfo(ContextMenu.callingItemID);
        if (info != null && info.nodeRowID) {
            /* We've got a database row ID specified - this is an "Orders" node (which resides in a root) */
            permCmd = 'QUOTES';
            id = info.nodeRowID;
        } else {
            /* This is a orders node which references to a specific shop */
            permCmd = 'SHOPQUOTE';
            id = eCommerce.callingShopID();
        }
    }
    else if (permCmd.toLowerCase() == 'recurringorders') {
        showBasic = true;
        info = eCommerce.SystemTree.getInstance().getInfo(ContextMenu.callingItemID);
        if (info != null && info.nodeRowID) {
            permCmd = 'RECURRINGORDERS';
            id = info.nodeRowID;
        } else {
            permCmd = 'SHOPRECURRINGORDER';
            id = eCommerce.callingShopID();
        }
    }
    else if (permCmd.toLowerCase() == 'rmas') {
        showBasic = true;
        info = eCommerce.SystemTree.getInstance().getInfo(ContextMenu.callingItemID);
        if (info != null && info.nodeRowID) {
            permCmd = 'RMAS';
            id = info.nodeRowID;
        } else {
            permCmd = 'SHOPRMA';
            id = eCommerce.callingShopID();
        }
    }
    else if (permCmd.toLowerCase() == 'ledgerentries') {
        showBasic = true;
        info = eCommerce.SystemTree.getInstance().getInfo(ContextMenu.callingItemID);
        if (info != null && info.nodeRowID) {
            permCmd = 'LEDGERENTRIES';
            id = info.nodeRowID;
        } else {
            permCmd = 'SHOPLEDGERENTRIES';
            id = eCommerce.callingShopID();
        }
    }

    page = '/admin/module/ecom_catalog/dw7/Edit/EcomPermission.aspx?CMD=' + permCmd;

    if (permCmd.toLowerCase() == 'shop') {
        id = eCommerce.callingShopID();
    } else if (id.length == 0) {
        id = eCommerce.callingGroupID();
    }

    page += '&ID=' + id;
    if (showBasic) {
        page += '&Basic=True';
    }
    eCommerce.startPermissions(nodeName, page, id, permCmd);
};

// This method is used only for virtual nodes(not shop/group) which all have id started from slash('/')
// E.g. /DASHBOARD
//      /GROUPS/ASSORTMENTS
eCommerce.newPermissions = function (cmd) {
    var itemId = '0';
    var itemCmd = ContextMenu.callingItemID.replace(new RegExp('/', 'g'), '_');
    if (itemCmd.indexOf(';') > 0) {
        // Fix assortment ids
        itemCmd = itemCmd.substring(0, itemCmd.indexOf(';'));
    }

    eCommerce.startPermissions('', '', itemId, itemCmd);
};

eCommerce.startPermissions = function (nodeName, page, id, permCmd) {
    var newTitle = eCommerce.MasterPage.getInstance().get_terminology()['PermissionsDialogTitle'] + nodeName;

    if (permissiondialogAction.Id === "NewShopPermissionsDialog") {
        var permissionName = '';
        var permissionSubName = '';
        if (permCmd.toLowerCase() === "group") {
            permissionName = "ProductGroup";
            id = ContextMenu.callingItemID.substring("/GROUPS/".length);
        }
        else if (permCmd.toLowerCase() === "shop") {
            permissionName = "Shop";
        }
        else {
            if (id !== '0') permCmd = ContextMenu.callingItemID.replace(new RegExp('/', 'g'), '_');
            id = '0';
            var virtualParents = ContextMenu.callingItemID.split('/');
            while (virtualParents.length > 2) {
                virtualParents.pop();
                id = "PermissionNode" + virtualParents.join("_") + "/" + id;
            }
            if (permCmd.toLowerCase() === "_groups") permissionName = "Shop";
            else permissionName = "PermissionNode" + permCmd;
            permissionSubName = "VirtualNode";
        }

        permissiondialogAction.PermissionKey = id;
        permissiondialogAction.PermissionName = permissionName;
        permissiondialogAction.PermissionSubName = permissionSubName;
        permissiondialogAction.PermissionTitle = newTitle;
        permissiondialogAction.ManagementArea = "Ecommerce";
    }
    else {
        try {
            page += "&NodeName=" + encodeURIComponent(nodeName);
        } catch (e) { console.log(e); }
        permissiondialogAction.Url = page;
        permissiondialogAction.Title = newTitle;
    }

    Action.Execute(permissiondialogAction);
};

eCommerce.onSelectGroupContextView = function () {
    var ret = [];
    var tree = eCommerce.SystemTree.getInstance();
    var node = tree.findNode(ContextMenu.callingItemID);

    if (node) {
        var permissionLevel = node.additionalattributes['PermissionLevel'];

        if (permissionLevel >= PermissionLevels.PermissionLevelCreate) {
            ret[ret.length] = 'cmdNewGroup';
            ret[ret.length] = 'cmdNewSubgroupButton';
            ret[ret.length] = 'cmdNewProductButton';
            ret[ret.length] = 'cmdAttachSubgroup';
            ret[ret.length] = 'cmdAttachProducts';
        }
        if (permissionLevel >= PermissionLevels.PermissionLevelDelete) {
            ret[ret.length] = 'cmdDeleteGroup';
        }
        if (permissionLevel >= PermissionLevels.PermissionLevelAll) {
            ret[ret.length] = 'cmdGroupPermissions';
        }
        if (permissionLevel >= PermissionLevels.PermissionLevelEdit) {
            ret[ret.length] = 'cmdEditGroup';
            ret[ret.length] = 'cmdEditGroup2';
            ret[ret.length] = 'cmdSortProducts';
        }
    }
    return ret;
}

eCommerce.groupsMenuOnShow = function () {
    var tree = eCommerce.SystemTree.getInstance();
    tree.innerTree.s(ContextMenu.callingID);
}

eCommerce.onSelectAssortmentContextView = function () {
    var ret = [];
    var tree = eCommerce.SystemTree.getInstance();
    var node = tree.findNode(ContextMenu.callingItemID);

    if (node) {
        var permissionLevel = node.additionalattributes['PermissionLevel'];
        ret[0] = 'cmdRebuildAssortment';

        if (permissionLevel >= PermissionLevels.PermissionLevelCreate) {
            ret[ret.length] = 'cmdAddAssortment';
        }
        if (permissionLevel >= PermissionLevels.PermissionLevelDelete) {
            ret[ret.length] = 'cmdDeleteAssortment';
        }
        if (permissionLevel >= PermissionLevels.PermissionLevelAll) {
            ret[ret.length] = 'cmdAssortmentPermissions';
        }
        if (permissionLevel >= PermissionLevels.PermissionLevelEdit) {
            ret[ret.length] = 'cmdEditAssortment';
            ret[ret.length] = 'cmdEditAssortment2';
            ret[ret.length] = 'cmdAssortmentAttachShop';
            ret[ret.length] = 'cmdAssortmentAttachGroup';
            ret[ret.length] = 'cmdAssortmentAttachProduct';
        }
    }

    return ret;
}

eCommerce.updateTreeAfterContextMenu = function(selectedPath) {
    var p = selectedPath;
    var tree = eCommerce.SystemTree.getInstance();

    if (!p) {
        p = ContextMenu.callingItemID;
    }

    tree.setSelectedNode(p);
}

eCommerce.newShop = function() {
    eCommerce.editShop('');
}

eCommerce.onSelectShopContextView = function(sender, args) {
    var ret = [];
    var tree = eCommerce.SystemTree.getInstance();
    var node = tree.findNode(ContextMenu.callingItemID);

    if (node) {
        var permissionLevel = node.additionalattributes['PermissionLevel'];

        if (permissionLevel >= PermissionLevels.PermissionLevelCreate) ret[ret.length] = 'cmdNewGroup';
        if (permissionLevel >= PermissionLevels.PermissionLevelDelete) ret[ret.length] = 'cmdDeleteShop';
        if (permissionLevel >= PermissionLevels.PermissionLevelAll) ret[ret.length] = 'cmdShopPermissions';
        if (permissionLevel >= PermissionLevels.PermissionLevelEdit) {
            ret[ret.length] = 'cmdEditShop';

            var info = tree.getInfo(args.callingItemID);
            if (info) {
                if (info.topGroupsCount > 1) ret[ret.length] = 'cmdSortShopGroups';
            }
        }
    }
    return ret;
}

eCommerce.editShop = function(shopID) {
    ContextMenu.hide();
    eCommerce.updateTreeAfterContextMenu();
    eCommerce.SystemTree.getInstance().openScreen('/Admin/Module/eCom_Catalog/dw7/Edit/EcomShop_Edit.aspx?ID=' + shopID, true);    
}

eCommerce.deleteShop = function (shopID, forceDelete) {
    if (eCommerce.getStateForDeleteAction() == "disabled") {
        return false;
    }

    var canProcess = false;
    var msg = '', msgID = 'spDeleteShopEmpty';
    var info = eCommerce.SystemTree.getInstance().getInfo('/GROUPS/' + shopID);

    ContextMenu.hide();

    if (!forceDelete) {
        if (info) {
            if (info.topGroupsCount > 0) {
                msgID = 'spDeleteShop';
            }
        }

        msg = $(msgID).innerHTML;

        msg = msg.replace(/<br>/gi, '\n');
        msg = msg.replace(/<br \/>/gi, '\n');
        msg = msg.replace(/\\n\\n/gi, '\n');

        canProcess = confirm(msg);
    } else {
        canProcess = true;
    }

    if (canProcess) {
        eCommerce.updateTreeAfterContextMenu();
        location.href = '/Admin/Module/eCom_Catalog/dw7/Edit/EcomShop_Edit.aspx?deleteShop=1&ID=' + shopID;
    }
}

eCommerce.sortShopGroups = function(shopID) {
    var nodePath = '/GROUPS/' + shopID;

    ContextMenu.hide();
    eCommerce.updateTreeAfterContextMenu(nodePath + '/' + shopID + '_Sort');

    location.href = '/Admin/Module/eCom_Catalog/dw7/GroupSort.aspx?shop=' + shopID + '&path=' + nodePath;
}

eCommerce.AddAssortment = function ()
{
    location.href = '/Admin/module/eCom_Catalog/dw7/edit/EcomAssortment_Edit.aspx';
}

eCommerce.EditAssortment = function ()
{
    var tree = eCommerce.SystemTree.getInstance();
    var node = tree.findNode(ContextMenu.callingItemID);
    var id = node.itemID.replace('/GROUPS/ASSORTMENTS/', '');
    tree.nodeClick(ContextMenu.callingItemID, node.id, '/Admin/module/eCom_Catalog/dw7/edit/EcomAssortment_Edit.aspx?CMD=EDIT_ASSORTMENT&ID=' + id);
}

eCommerce.RebuildAssortment = function ()
{
    var isAssortmentRebuiltRunning = false;
    var tree = eCommerce.SystemTree.getInstance();
    var node = tree.findNode(ContextMenu.callingItemID);
    
    if (node) {
        isAssortmentRebuiltRunning = node.additionalattributes['IsAssortmentRebuiltRunning'];
    }
    if (isAssortmentRebuiltRunning) {
        return;
    }
    
    var id = node.itemID.replace('/GROUPS/ASSORTMENTS/', '');
    new Ajax.Request('/Admin/module/eCom_Catalog/dw7/edit/EcomAssortment_Edit.aspx?CMD=BUILD_ASSORTMENT&ID=' + id, {
        method: 'get'
    });    
}

eCommerce.DeleteAssortment = function ()
{
    var tree = eCommerce.SystemTree.getInstance();
    var node = tree.findNode(ContextMenu.callingItemID);
    if (!node) {
        return;
    }
    var id = node.itemID.replace('/GROUPS/ASSORTMENTS/', '');
    var hasRelation = node.additionalattributes['HasRelation'];
    var userAssotiated = node.additionalattributes['HasUserAssotiated'];

    var str1 = hasRelation == true ? eCommerce.MasterPage.getInstance().get_terminology()['AssortDelConfirmText1'] : '';
    var str2 = userAssotiated == true ? eCommerce.MasterPage.getInstance().get_terminology()['AssortDelConfirmText2'] : '';
    var str3 = eCommerce.MasterPage.getInstance().get_terminology()['AssortDelConfirmText3'];

    if ((hasRelation || userAssotiated) && !confirm(str1 + str2 + str3)) {
        return;
    }

    location.href = '/Admin/module/eCom_Catalog/dw7/edit/EcomAssortment_Edit.aspx?CMD=DELETE_ASSORTMENT&ID=' + id;
}

eCommerce.AttachShop = function (assortId)
{
    var id;
    var rtmSelected;
    var tree = eCommerce.SystemTree.getInstance();
    var node = tree.findNode(ContextMenu.callingItemID);
    
    if(assortId)
    {
        var itemAdded = document.getElementById('ShopAdded');

        id = assortId;
        rtmSelected = itemAdded.value;
    }
    else
    {
        id = node.itemID.replace('/GROUPS/ASSORTMENTS/', '');
    }

    if(!id)
    {
        alert(eCommerce.MasterPage.getInstance().get_terminology()['AssortmentSaveWarning']);
        return;
    }

    var win = window.open('/Admin/module/ecom_catalog/dw7/edit/EcomGroupTree.aspx?CMD=AttachShop&AssortmentID=' + id + (assortId ? '&clientedit=true&rtmSelected=' + rtmSelected : '&clientedit=false'), '', 'displayWindow,width=460,height=400,scrollbars=no');  
}

eCommerce.OnAssortmentShopSelected = function (inst)
{
    var t = inst.getTree();
    var checkedNodes = t.getCheckedNodes();
    var delTitle = eCommerce.MasterPage.getInstance().get_terminology()['AssortDelButtonText'];

    for(i = 0; i < checkedNodes.length; i++)
    {
        var node = checkedNodes[i];
        var item = decodeURIComponent(node.itemID).evalJSON();
        var id = item.nodeId;
        var itemAdded = document.getElementById('ShopAdded');
        var itemAddedArr = itemAdded.value.split(',');
        var exists = false;

        for(n = 0; n < itemAddedArr.length; n++)
        {
            if(itemAddedArr[i] == id)
            {
                exists = true;
                break;
            }
        }

        if(!exists)
        {
            var tbl = document.getElementById('DWRowLineTable_S_').getElementsByTagName('tbody')[0];
            var html = "<tr id=DWRowLineTR_S_" + id + " class=OutlookItem style='height:25px;'>";

            html += "<td><input type=hidden id=SHP_ID_" + id + " name=SHP_ID_" + id + " value='-1'><span>" + node.name + "</span></td>";
            html += "<td align=center><a href=javascript:eCommerce.DetachShop('" + id + "');><i class='fa fa-remove color-danger' align=absmiddle title='" + delTitle + "' name=delDWRow border=0></i></a></td></tr>";

            tbl.innerHTML += html;

            if(itemAdded.value != '')
                itemAdded.value += ',';

            itemAdded.value += id;
        }
    }
}

eCommerce.DetachShop = function (shpid)
{
    var tbl = document.getElementById('DWRowLineTable_S_').getElementsByTagName('tbody')[0];
    var index = document.getElementById('DWRowLineTR_S_' + shpid).rowIndex;
    var shopRemoved = document.getElementById('ShopRemoved');
    var shpRel = document.getElementById('SHP_ID_' + shpid)
    var itemAdded = document.getElementById('ShopAdded');

    if(shpRel.value != -1)
    {
        if(shopRemoved.value != '')
            shopRemoved.value += ',';

        shopRemoved.value += shpid;
    }

    itemAdded.value = itemAdded.value.replace(shpid, '');
    tbl.deleteRow(index);
}

eCommerce.AttachGroup = function (assortId)
{
    var id;
    var rtmSelected;
    var tree = eCommerce.SystemTree.getInstance();
    var node = tree.findNode(ContextMenu.callingItemID);
    
    if(assortId)
    {
        var itemAdded = document.getElementById('GroupAdded');

        id = assortId;
        rtmSelected = itemAdded.value;
    }
    else
    {
        id = node.itemID.replace('/GROUPS/ASSORTMENTS/', '');
    }

    if(!id)
    {
        alert(eCommerce.MasterPage.getInstance().get_terminology()['AssortmentSaveWarning']);
        return;
    }

    var win = window.open('/Admin/module/ecom_catalog/dw7/edit/EcomGroupTree.aspx?CMD=AttachGroup&AssortmentID=' + id + (assortId ? '&clientedit=true&rtmSelected=' + rtmSelected : '&clientedit=false'), '', 'displayWindow,width=460,height=400,scrollbars=no');
}

eCommerce.OnAssortmentGroupSelected = function(inst, groupid, groupname)
{
    var delTitle = eCommerce.MasterPage.getInstance().get_terminology()['AssortDelButtonText'];

    if(inst == null)
    {
        var tbl = document.getElementById('DWRowLineTable_G_').getElementsByTagName('tbody')[0];
        var html = "<tr id=DWRowLineTR_G_" + groupid + " class=OutlookItem style='height:25px;'>";
        var itemAdded = document.getElementById('GroupAdded');
        var itemAddedArr = itemAdded.value.split(',');
        var exists = false;

        for(n = 0; n < itemAddedArr.length; n++)
        {
            if(itemAddedArr[n] == groupid)
            {
                exists = true;
                break;
            }
        }

        if(!exists)
        {
            html += "<td><input type=hidden id=GRP_ID_" + groupid + " name=GRP_ID_" + groupid + " value='-1'><span>" + groupname + "</span></td>";
            html += "<td align=center><a href=javascript:eCommerce.DetachGroup('" + groupid + "');><i class='fa fa-remove color-danger' title='" + delTitle + "' name=delDWRow border=0></i></a></td></tr>";

            tbl.innerHTML += html;

            if(itemAdded.value != '')
                itemAdded.value += ',';

            itemAdded.value += groupid;
        }
    }
    else
    {
        var t = inst.getTree();
        var checkedNodes = t.getCheckedNodes();

        for(i = 0; i < checkedNodes.length; i++)
        {
            var node = checkedNodes[i];
            var item = decodeURIComponent(node.itemID).evalJSON();
            var id = item.nodeId;
            var tbl = document.getElementById('DWRowLineTable_G_').getElementsByTagName('tbody')[0];
            var html = "<tr id=DWRowLineTR_G_" + id + " class=OutlookItem style='height:25px;'>";
            var itemAdded = document.getElementById('GroupAdded');
            var itemAddedArr = itemAdded.value.split(',');
            var exists = false;

            for(n = 0; n < itemAddedArr.length; n++)
            {
                if(itemAddedArr[n] == id)
                {
                    exists = true;
                    break;
                }
            }

            if(!exists)
            {
                html += "<td><input type=hidden id=GRP_ID_" + id + " name=GRP_ID_" + id + " value='-1'><span>" + node.name + "</span></td>";
                html += "<td align=center><a href=javascript:eCommerce.DetachGroup('" + id + "');><i class='fa fa-remove color-danger' align=absmiddle title='" + delTitle + "' name=delDWRow border=0></i></a></td></tr>";

                tbl.innerHTML += html;

                if(itemAdded.value != '')
                    itemAdded.value += ',';

                itemAdded.value += id;
            }
        }
    }
}

eCommerce.DetachGroup = function (grpid)
{
    var tbl = document.getElementById('DWRowLineTable_G_').getElementsByTagName('tbody')[0];
    var index = document.getElementById('DWRowLineTR_G_' + grpid).rowIndex;
    var groupRemoved = document.getElementById('GroupRemoved');
    var grpRel = document.getElementById('GRP_ID_' + grpid)
    var itemAdded = document.getElementById('GroupAdded');

    if(grpRel.value!=-1)
    {
        if(groupRemoved.value != '')
            groupRemoved.value += ',';
        
        groupRemoved.value += grpid;
    }

    itemAdded.value = itemAdded.value.replace(grpid, '');
    tbl.deleteRow(index);
}

eCommerce.AttachProduct = function (assortId)
{
    var id;
    var rtmSelected;
    var tree = eCommerce.SystemTree.getInstance();
    var node = tree.findNode(ContextMenu.callingItemID);
    
    if(assortId)
    {
        var itemAdded = document.getElementById('ProdAdded');

        id = assortId;
        rtmSelected = itemAdded.value;
    }
    else
    {
        id = node.itemID.replace('/GROUPS/ASSORTMENTS/', '');
    }

    if(!id)
    {
        alert(eCommerce.MasterPage.getInstance().get_terminology()['AssortmentSaveWarning']);
        return;
    }

    var win = window.open('/Admin/module/ecom_catalog/dw7/edit/EcomGroupTree.aspx?CMD=ShowProdGroupList&AppendType=AppendProduct&AssortmentID=' + id + (assortId ? '&clientedit=true&rtmSelected=' + rtmSelected : '&clientedit=false'), '', 'displayWindow,width=460,height=400,scrollbars=no');
}

eCommerce.OnAssortmentProdSelected = function (inst, arrStr)
{
    var delTitle = eCommerce.MasterPage.getInstance().get_terminology()['AssortDelButtonText'];
    var items = [];
    var tbl = document.getElementById('DWRowLineTable_P_').getElementsByTagName('tbody')[0];
    var itemAdded = document.getElementById('ProdAdded');
    var itemAddedArr = itemAdded.value.split(',');

    if(inst == null)
    {        
        var arrProducts = arrStr.evalJSON();

        for(i = 0; i < arrProducts.length; i++)
        {
            var productProps = arrProducts[i];

            var product = new Object();

            product.id = productProps.id;
            product.varId = productProps.variantID;
            product.name = productProps.name;
            items[i] = product;
        }
    }
    else
    {
        var t = inst.getTree();
        var checkedNodes = t.getCheckedNodes();

        for(i = 0; i < checkedNodes.length; i++)
        {
            var node = checkedNodes[i];
            var item = decodeURIComponent(node.itemID).evalJSON();
            var product = new Object();

            product.id = item.nodeId;
            product.varId = item.variantId;
            product.name = node.name;
            items[i] = product;
        }
    }

    for(i = 0; i < items.length; i++)
    {
        var product = items[i];
        var prodKey = product.id + ":" + product.varId;
        var exists = false;

        for(n = 0; n < itemAddedArr.length; n++)
        {
            if(itemAddedArr[i] == prodKey)
            {
                exists = true;
                break;
            }
        }

        if(!exists)
        {
            var html = "<tr id=DWRowLineTR_P_" + prodKey + " class=OutlookItem style='height:25px;'>";

            html += "<td><input type=hidden id=PRD_ID_" + prodKey + " name=PRD_ID_" + prodKey + " value='-1'><span>" + product.name + "</span></td>";
            html += "<td align=center><a href=javascript:eCommerce.DetachProduct('" + prodKey + "');><i class='fa fa-remove color-danger' align=absmiddle title='" + delTitle + "' name=delDWRow border=0></i></a></td></tr>";

            tbl.innerHTML += html;

            if(itemAdded.value != '')
                itemAdded.value += ',';

            itemAdded.value += prodKey;
        }
    }
}

eCommerce.DetachProduct = function (prdid)
{
    var tbl = document.getElementById('DWRowLineTable_P_').getElementsByTagName('tbody')[0];
    var index = document.getElementById('DWRowLineTR_P_' + prdid).rowIndex;
    var prodRemoved = document.getElementById('ProdRemoved');
    var prdRel = document.getElementById('PRD_ID_' + prdid)
    var itemAdded = document.getElementById('ProdAdded');

    if(prdRel.value != -1)
    {
        if(prodRemoved.value != '')
            prodRemoved.value += ',';

        prodRemoved.value += prdid;
    }

    itemAdded.value = itemAdded.value.replace(prdid, '');
    tbl.deleteRow(index);
}