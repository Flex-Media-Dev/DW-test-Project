/// <reference path="TreeDragDrop.js" />

var Tree = {
    rightClick: function (fEvent) {
        var e = (window.event) ? window.event : fEvent;

        if (e) {
            if (e.ctrlKey == true) {
                e.returnValue = true;
                return true;
            } else {
                return false;
            }
        }
    },

    onToolbarButtonEvent: function (sender, args) {
        /// <summary>Handles tree's toolbar buttons events.</summary>
        /// <param name="sender">Event sender.</param>
        /// <param name="args">Event arguments.</param>

        if (sender) {
            if (!args) {
                args = {};
            }

            if (args.type == 'mouseover' || args.type == 'mouseout' || args.type == 'mousedown') {
                sender.src = args.icon;
            }
        }
    }
}

//var treeResizeFunction = Tree.myResize;
//Tree.addResizeEvent(treeResizeFunction);


/*--------------------------------------------------|
| dTree 2.05 | www.destroydrop.com/javascript/tree/ |
|---------------------------------------------------|
| Copyright (c) 2002-2003 Geir Landrö               |
|                                                   |
| This script can be used freely as long as all     |
| copyright messages are intact.                    |
|                                                   |
| Updated: 17.04.2003                               |
| Extended: 30.09.2008 By Dynamicweb Software       |
|--------------------------------------------------*/

// Node object
function Node(id, pid, name, url, contextId, title, target, icon, iconOpen, iconClose, open, itemID, hasChildren, disabled, onDoubleClick, dragDrop, additionalCssClass, checkable, checked, additionalAttributes, knownIcon) {
    this.id = id;
    this.pid = pid;
    this.name = name;
    this.url = url;
    this.contextId = contextId;
    this.title = title;
    this.target = target;
    this.icon = icon;
    this.iconOpen = iconOpen;
    this.iconClose = iconClose;
    this._io = open || false; // is opened flag
    this._is = false; // is selected flag
    this._ls = false; // last sibling flag
    // pvo: 01-10-2008 - first sibling flag
    this._fs = false; // ^^^
    this._siblings = 0;
    //end: pvo: 01-10-2008
    this._hc = (typeof (hasChildren) != 'undefined' && hasChildren == true); // has children flag
    this._ai = 0; // array index
    this._p;
    this.itemID = itemID;
    this.disabled = disabled;
    this.onDoubleClick = onDoubleClick;
    this._dragDrop = null;
    this.additionalCssClass = additionalCssClass;
    this.checkable = checkable;
    this.checked = checked;
    this.additionalattributes = additionalAttributes;
    this.knownIcon = knownIcon;

    if (this.id >= 0) {
        this.set_dragDropSettings(dragDrop);
    }
};

Node.prototype.get_dragDropSettings = function () {
    /// <summary>Gets drag and drop settings.</summary>

    return this._dragDrop;
}

Node.prototype.set_dragDropSettings = function (settings) {
    /// <summary>Sets drag and drop settings.</summary>
    /// <param name="settings">Drag and drop settings.</param>

    this._dragDrop = new Dynamicweb.Controls.Tree.DragDropSettings(settings);
}

function TreeIndex(nodeComparator) {
    this._ids = {}; // {id: node}
    this._pids = {}; // {pid: [id1,id2,...], pid2: [...], ...}
    this._indexes = {}; // {id: aNodes index}
    this._nodeComparator = nodeComparator || function (a, b) { return a - b; };
}

TreeIndex.prototype.clear = function () {
    this._ids = {};
    this._pids = {};
    this._indexes = {};
}

TreeIndex.prototype.rebuildIndex = function (nodes) {
    this.clear();
    for (var i = 0; i < nodes.length; ++i) {
        this.insertNode(nodes[i], i);
    }
}

TreeIndex.prototype.insertNode = function (node, index) {
    this._ids[node.id] = node;
    this._indexes[node.id] = index;

    var pids = this._pids[node.pid] || [];
    if (pids.indexOf(node.id) < 0) {
        pids.push(node.id);
        pids.sort(this._nodeComparator);
        this._pids[node.pid] = pids;
    }
}

TreeIndex.prototype.deleteNode = function (node) {
    delete this._ids[node.id];
    delete this._indexes[node.id];

    if (this._pids[node.pid]) {
        var arr = this._pids[node.pid];
        var newArr = [];
        for (var i = 0; i < arr.length; ++i) {
            if (arr[i] != node.id)
                newArr.push(arr[i]);
        }
        this._pids[node.pid] = newArr;
    }
}

TreeIndex.prototype.deleteNodesByPid = function (pid) {
    var n = null;
    var ret = [];

    if (this._pids[pid] && this._pids[pid].length) {
        ret = this._pids[pid];

        for (var i = 0; i < ret.length; i++) {
            n = this._ids[ret[i]];
            if (n) {
                this.deleteNode(n);
            }
        }
    }

    return ret;
}

TreeIndex.prototype.selectIndexById = function (id) {
    return this._indexes[id];
}

TreeIndex.prototype.selectById = function (id) {
    return this._ids[id];
}

TreeIndex.prototype.selectByPid = function (pid) {
    return this._pids[pid];
}

// Tree object
function dTree(objName, nodeComparator) {
    this.config = {
        controlID: '',
        loadingMessage: 'Loading...',
        loadOnDemand: false,
        target: null,
        folderLinks: true,
        useSelection: true,
        useCookies: true,
        useLines: true,
        useIcons: true,
        useStatusText: false,
        closeSameLevel: false,
        inOrder: false,
        showRoot: true,
        autoID: false,
        afterClientCheck: null
    }
    this.icon = {
        root: '/Admin/Images/Ribbon/UI/Tree/img/base.gif',
        folder: '/Admin/Images/Ribbon/UI/Tree/img/folder.gif',
        folderOpen: '/Admin/Images/Ribbon/UI/Tree/img/folderopen.gif',
        node: '/Admin/Images/Ribbon/UI/Tree/img/page.gif',
        empty: '/Admin/Images/Ribbon/UI/Tree/img/empty.gif',
        line: '/Admin/Images/Ribbon/UI/Tree/img/line.gif',
        join: '/Admin/Images/Ribbon/UI/Tree/img/join.gif',
        joinBottom: '/Admin/Images/Ribbon/UI/Tree/img/joinbottom.gif',
        joinTop: '/Admin/Images/Ribbon/UI/Tree/img/jointop.gif',
        plus: '/Admin/Images/Ribbon/UI/Tree/img/plus.gif',
        plusBottom: '/Admin/Images/Ribbon/UI/Tree/img/plusbottom.gif',
        plusTop: '/Admin/Images/Ribbon/UI/Tree/img/plustop.gif',
        minus: '/Admin/Images/Ribbon/UI/Tree/img/minus.gif',
        minusBottom: '/Admin/Images/Ribbon/UI/Tree/img/minusbottom.gif',
        minusTop: '/Admin/Images/Ribbon/UI/Tree/img/minustop.gif',
        nlPlus: '/Admin/Images/Ribbon/UI/Tree/img/nolines_plus.gif',
        nlMinus: '/Admin/Images/Ribbon/UI/Tree/img/nolines_minus.gif',
        minusOne: '/Admin/Images/Ribbon/UI/Tree/img/minus_one.gif',
        plusOne: '/Admin/Images/Ribbon/UI/Tree/img/plus_one.gif'
    };
    this.obj = objName;
    this.aNodes = [];
    this.aNodesIndex = new TreeIndex(nodeComparator);
    this.aIndent = [];
    this.loadedNodes = [];
    this.root = new Node(-1);
    this.selectedNode = null;
    this.selectedFound = false;
    this.completed = false;

    this._loadingTimeoutID = -1;
    this._dragDrop = null;
    this._dragDropManager = null;
    this._isBusy = false;
    this._loadQueue = [];

    this._dynamic = null;
    this._resolver = null;
    this._editor = null;

    this._handlers = {
        beforeExpandAjax: [],
        afterExpandAjax: []
    };
};

dTree.error = function (message) {
    /// <summary>Displays an error message.</summary>
    /// <param name="message">Error message.</param>

    var er = null;

    if (typeof (Error) != 'undefined') {
        er = new Error();

        er.message = message;
        er.description = message;

        throw (er);

    } else {
        throw (message);
    }
}

dTree.prototype.add_beforeExpandAjax = function (callback) {
    /// <summary>Registers new callback which is executed before tree node are expanded.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }

    this._handlers.beforeExpandAjax[this._handlers.beforeExpandAjax.length] = callback;
}

dTree.prototype.add_afterExpandAjax = function (callback) {
    /// <summary>Registers new callback which is executed after tree node are expanded.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }

    this._handlers.afterExpandAjax[this._handlers.afterExpandAjax.length] = callback;
}

dTree.prototype.onBeforeExpandAjax = function (args) {
    /// <summary>Raises "beforeExpandAjax" event.</summary>
    /// <param name="args">Event arguments.</param>

    this.notify('beforeExpandAjax', args || {});
}

dTree.prototype.onAfterExpandAjax = function (args) {
    /// <summary>Raises "afterExpandAjax" event.</summary>
    /// <param name="args">Event arguments.</param>

    this.notify('afterExpandAjax', args || {});
}

dTree.ExpandEventArgs = function (parentNodeID, childrenNodes) {
    /// <summary>Provides information for "ExpandEventArgs" event.</summary>
    var result = new Object();

    result.ParentNodeID = parentNodeID;
    result.ChildrenNodes = childrenNodes;

    return result;
}

dTree.prototype.notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];
    var callbackException = null;

    if (eventName && eventName.length) {
        callbacks = this._handlers[eventName];

        if (callbacks && callbacks.length) {
            if (typeof (args) == 'undefined' || args == null) {
                args = {};
            }

            for (var i = 0; i < callbacks.length; i++) {
                callbackException = null;

                try {
                    callbacks[i](this, args);
                } catch (ex) {
                    callbackException = ex;
                }

                /* Preventing "Unable to execute code from freed script" errors to raise */
                if (callbackException && callbackException.number != -2146823277) {
                    this.error(callbackException.message);
                }
            }
        }
    }
}

dTree.prototype.get_dynamic = function () {
    /// <summary>Gets dynamic behavior of this tree.</summary>

    if (!this._dynamic) {
        this._dynamic = new dTree.DynamicBehavior(this);
    }

    return this._dynamic;
}

dTree.prototype.get_resolver = function () {
    /// <summary>Gets node resolver for this tree.</summary>

    if (!this._resolver) {
        this._resolver = new dTree.NodeResolver(this);
    }

    return this._resolver;
}

dTree.prototype.get_editor = function () {
    /// <summary>Gets node editor for this tree.</summary>

    if (!this._editor) {
        this._editor = new dTree.NodeEditor(this);
    }

    return this._editor;
}

dTree.prototype.get_dragDropSettings = function () {
    /// <summary>Gets drag and drop settings.</summary>

    return this._dragDrop;
}

dTree.prototype.set_dragDropSettings = function (settings) {
    /// <summary>Sets drag and drop settings.</summary>
    /// <param name="settings">Drag and drop settings.</param>

    this._dragDrop = new Dynamicweb.Controls.Tree.DragDropExtendedSettings(settings);
}

dTree.prototype.get_dragDropManager = function () {
    /// <summary>Gets an instance of Dynamicweb.Controls.Tree.DragDropManager that handles drag and drop operations.</summary>

    if (!this._dragDropManager) {
        this._dragDropManager = new Dynamicweb.Controls.Tree.DragDropManager(this);
    }

    return this._dragDropManager;
}

dTree.prototype.initializeDragDrop = function () {
    /// <summary>Initializes drag and drop functionality.</summary>

    this.get_dragDropManager().registerAll();
}

dTree.prototype.get_isBusy = function () {
    /// <summary>Gets value indicating whether tree is processing some kind of background action.</summary>

    return this._isBusy;
}

dTree.prototype.set_isBusy = function (value) {
    /// <summary>Sets value indicating whether tree is processing some kind of background action.</summary>
    /// <param name="nodeID">Value indicating whether tree is processing some kind of background action.</param>

    this._isBusy = value;
}

dTree.prototype.isParent = function (nodeID, parentNodeID) {
    /// <summary>Determines whether one node is a parent of another node.</summary>
    /// <param name="nodeID">Assumed child node.</param>
    /// <param name="parentNodeID">Parent node.</param>
    var ret = false;
    var pid = -1, node = null;

    nodeID = parseInt(nodeID);
    parentNodeID = parseInt(parentNodeID);

    if (parentNodeID < 0) {
        ret = true;
    } else if (nodeID == parentNodeID) {
        ret = false;
    } else {
        node = this.getNodeByID(nodeID);
        if (node) {
            pid = parseInt(node.pid);
            if (pid == parentNodeID) {
                ret = true;
            } else {
                ret = this.isParent(pid, parentNodeID);
            }
        }
    }

    return ret;
}

dTree.prototype.isDirectParent = function (nodeID, parentNodeID) {
    /// <summary>Determines whether one node is a direct parent of another node.</summary>
    /// <param name="nodeID">Assumed child node.</param>
    /// <param name="parentNodeID">Parent node.</param>

    return this.getNodeByID(nodeID).pid == parentNodeID;
}

dTree.prototype.getParent = function (nodeID, level) {
    /// <summary>Retrieves specified node's parent which resides at specified level.</summary>
    /// <param name="nodeID">Target node.</param>
    /// <param name="level">Target level (1-based) of the parent.</param>

    var ret = null;
    var currentNodeID = nodeID;
    var nodeLevel = this.getNodeLevel(nodeID);

    if (level > 0 && nodeLevel > level) {
        while (nodeLevel > level) {
            if (currentNodeID < 0) {
                break;
            } else {
                var node = this.getNodeByID(currentNodeID);
                if (node != null) {
                    currentNodeID = node.pid;
                    nodeLevel--;
                }
            }
        }

        if (currentNodeID >= 0) {
            ret = this.getNodeByID(currentNodeID);
        }
    }

    return ret;
}

dTree.prototype.getNodeLevel = function (nodeID) {
    /// <summary>Calculates the level of specified node.</summary>
    /// <param name="nodeID">An ID of the node.</param>

    var ret = 0;
    var currentNodeID = nodeID;

    if (currentNodeID >= 0) {
        while (currentNodeID >= 0) {
            currentNodeID = this.getNodeByID(currentNodeID).pid;
            ret++;
        }
    }

    if (!this.config.showRoot) {
        ret -= 1;
    }

    return ret;
}

// Adds a new node to the node array
dTree.prototype.add = function (id, pid, name, url, contextId, title, target, icon, iconOpen, iconClose, open, itemID, hasChildren, disabled, onDoubleClick, dragDrop, additionalCssClass, checkable, checked, additionalAttributes, knownIcon) {
    if (this.config.autoID && this.aNodes.length > 0) {
        id = this.aNodes[this.aNodes.length - 1].id + 1;
    }
    var newNode = new Node(id, pid, name, url, contextId, title, target, icon, iconOpen, iconClose, open, itemID, hasChildren, disabled, onDoubleClick, dragDrop, additionalCssClass, checkable, checked, additionalAttributes, knownIcon);
    this.aNodes.push(newNode);
    this.aNodesIndex.insertNode(newNode, this.aNodes.length - 1);
};

// Open/close all nodes
dTree.prototype.openAll = function () {
    this.oAll(true);
};
dTree.prototype.closeAll = function () {
    this.oAll(false);
};

/**
* @param id = index of removed node, not node id!
*/
dTree.prototype.removeNode = function (id) {
    if (id >= 0 && id < this.aNodes.length) {
        var newNodes = [];

        for (var i = 0; i < id; i++) {
            newNodes.push(this.aNodes[i]);
        }

        for (var j = i + 1; j < this.aNodes.length; j++) {
            newNodes.push(this.aNodes[j]);
        }

        this.aNodes = newNodes;

        this.aNodesIndex.clear();
        this.aNodesIndex.rebuildIndex(this.aNodes);
    }
}

// Outputs the tree to the page
dTree.prototype.toString = function () {
    var str = '<div class="dtree">\n';

    //this.config.useCookies = !this.config.loadOnDemand;

    if (document.getElementById) {
        if (this.config.useCookies) this.selectedNode = this.getSelected();
        str += this.addNode(this.root);
    } else str += 'Browser not supported.';

    str += '</div>';
    if (!this.selectedFound) this.selectedNode = null;
    this.completed = true;
    //Tree.addLoadEvent(Tree.setHeight);
    return str;
};

// Gets the list of child nodes for the specified parent node
dTree.prototype.getChildren = function (nodeID) {
    var that = this;
    return this.getNodesByPID(nodeID).map(function (id) { return that.getNodeByID(id); });
}

// Creates the tree structure
dTree.prototype.addNode = function (pNode) {
    var str = '';

    var childNodes = this.getNodesByPID(pNode.id);
    for (var i = 0; i < childNodes.length; ++i) {
        var cn = this.getNodeByID(childNodes[i]);
        var n = this.nodeIndex(childNodes[i]);
        cn._p = pNode;
        cn._ai = n;
        this.setCS(cn);
        if (!cn.target && this.config.target) cn.target = this.config.target;
        if (cn._hc && !cn._io && this.config.useCookies) cn._io = this.isOpen(cn.id);
        if (!this.config.folderLinks && cn._hc) cn.url = null;
        if (this.config.useSelection && cn.id == this.selectedNode && !this.selectedFound) {
            cn._is = true;
            this.selectedNode = n;
            this.selectedFound = true;
        }
        str += this.node(cn, n);
        if (cn._ls) break;
    }

    return str;
};

dTree.prototype.afterNodeChecked = function (nodeId) {
    var node = this.getNodeByID(nodeId);
    var box = $('tchk' + nodeId);
    window[this.config.afterClientCheck].call(t, node, box);
};

// Creates the node icon, url and text
dTree.prototype.node = function (node, nodeId) {
    //var str = '<div class="dTreeNode">' + this.indent(node, nodeId);
    var additionalAttribuesString = " "
    if ((node.additionalattributes != undefined) && (node.additionalattributes != null)) {
        var attrArr = node.additionalattributes;
        for (key in attrArr) {
            if (typeof (attrArr[key]) != 'function') {
                additionalAttribuesString += (key + '="' + attrArr[key] + '" ');
            }
        }
    }

    var selectClass = "";
    if (node._is) {
        selectClass = "nodeActive";
    }

    var contextmenu = "";

    if (node.contextId.length > 0) {
        contextmenu = ' oncontextmenu="return ContextMenu.show(event, \'' + node.contextId + '\', ' + node.id + ', \'' + node.itemID + '\', \'\', \'\', ' + nodeId + ');"';
    }

    var onclickjs = "";
    if (node.url) {
        onclickjs = ' onclick="' + node.url + ';event.stopPropagation();"';
    } else {
        if (node._hc) {
            onclickjs = ' onclick="' + this.obj + '.o(' + nodeId + ');event.stopPropagation();"';
            if (this.config.loadOnDemand) {
                onclickjs = ' onclick="' + this.obj + '.ajax_loadNodes(' + nodeId + ');event.stopPropagation();"';
            }
        }
    }

    var str = '<div class="dTreeNode  ' + selectClass + '" id="dtn' + nodeId + '" ' + contextmenu + onclickjs + ' style="display:' + ((!this.config.showRoot && this.root.id == node.pid) ? 'none' : '') + '" ' + additionalAttribuesString + ' >';

    str += this.indent(node, nodeId);

    if (node.checkable) {
        var checked = ''
        if (node.checked)
            checked = ' checked="checked"';

        clientCheck = "";
        if (this.config.afterClientCheck != null && this.config.afterClientCheck.length > 0) {
            clientCheck = " onchange='" + this.obj + ".afterNodeChecked(" + node.id + ");'";
        }

        str += '<input id="tchk' + node.id + '" type="checkbox" ' + (node.disabled ? 'disabled="disabled"' : '') + checked + clientCheck + ' data-node-id="' + node.id + '"  />';
    }

    if (this.config.useIcons) {
        if (!node.icon) node.icon = (node._hc) ? node.knownIcon || "fa fa-folder-o color-folder" : this.icon.node;
        if (!node.iconOpen) node.iconOpen = (node._hc) ? node.knownIcon || "fa fa-folder-open-o color-folder" : this.icon.node;
        if (!node.iconClose) node.iconClose = (node._hc) ? node.knownIcon || "fa fa-folder-o color-folder" : this.icon.node;
        if (this.root.id == node.pid) {
            node.knownIcon = "fa fa-folder-o color-folder";
        }
        
        var src = ((node._io) ? node.iconOpen : ((node._hc) ? node.iconClose : node.icon));

        var disabledCSS = '';
        if (node.disabled)
            disabledCSS = 'style="filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);-moz-opacity: 0.4;"';
        if (node.knownIcon) {
            str += "<i class='" + node.knownIcon + "' id=\"i" + this.obj + nodeId + "\"></i>";
        } else if (src.startsWith("<i ")) {
            str += src.slice(0, 2) + " id=\"i" + this.obj + nodeId + "\"" + src.slice(2);
        }
        else {
            str += '<img id="i' + this.obj + nodeId + '" src="' + src + '" alt="" ' + disabledCSS + ' />';
        }
    }

    var didStartA = false;

    /* "Expand/collapse" action should be performed by default */
    if (!node.url) {
        if (node._hc) {
            node.url = 'javascript:' + this.obj + '.o(' + nodeId + ');';
            if (this.config.loadOnDemand) {
                node.url = 'javascript:' + this.obj + '.ajax_loadNodes(' + nodeId + ');';
            }
        } else {
            node.url = 'javascript:void(0);';
        }
    }

    if (node.url || (node.onDoubleClick && node.onDoubleClick.length > 0)) {
        str += '<a id="s' + this.obj + nodeId + '" nodeID="' + nodeId + '" class="' + ((this.config.useSelection) ? ((node._is ? 'nodeSel' : 'node')) : 'node') + '" href="#"'

        if (node.title) str += ' title="' + node.title + '"';
        if (node.target) str += ' target="' + node.target + '"';
        if (this.config.useStatusText) str += ' onmouseover="window.status=\'' + node.name + '\';return true;" onmouseout="window.status=\'\';return true;" ';
        if (this.config.useSelection && ((node._hc && this.config.folderLinks) || !node._hc))
            str += ' onclick="' + this.obj + '.s(' + nodeId + ');"';


        if (node.onDoubleClick && node.onDoubleClick.length > 0)
            str += ' ondblclick="' + node.onDoubleClick + '" ';

        if (node.disabled)
            str += ' style="color: #b7b7b7"';

        str += '>';
        didStartA = true;
    }
        //	else if ((!this.config.folderLinks || !node.url) && node._hc && node.pid != this.root.id) {

    else if (((node._hc || node.contextId.length > 0) && node.pid != this.root.id) || (node.onDoubleClick && node.onDoubleClick.length > 0)) {
        var onExpand = this.obj + '.o(' + nodeId + ');';
        if (this.config.loadOnDemand)
            onExpand = this.obj + '.ajax_loadNodes(' + nodeId + ');';

        str += '<a id="s' + this.obj + nodeId;
        if (node._hc)
            str += ' href="javascript: ' + onExpand + '" class="node"';
        if (node.contextId.length > 0)
            str += ' oncontextmenu="return ContextMenu.show(event, \'' + node.contextId + '\', ' + node.id + ', \'' + node.itemID + '\', \'\', \'\', ' + nodeId + ');"';

        if (node.onDoubleClick && node.onDoubleClick.length > 0)
            str += ' ondblclick="' + node.onDoubleClick + '" ';

        if (node.disabled)
            str += ' style="color: #b7b7b7"';

        str += '>';
        didStartA = true;
    }
    str += '<span id="dtn' + nodeId + '_name" nodeID="' + nodeId + '" class="' + node.additionalCssClass + '">' + node.name + '</span>';
    if (didStartA)
        str += '</a>';

    str += '</div>';

    if (node._hc) {
        str += '<div id="d' + this.obj + nodeId + '" class="clip" style="display:' + ((this.root.id == node.pid || node._io) ? 'block' : 'none') + ';">';
        str += this.addNode(node);
        str += '</div>';
    }
    else {
        str += '<div id="d' + this.obj + nodeId + '" class="clip" style="display:none;"></div>';
    }
    this.aIndent.pop();
    return str;
};

// Adds the empty and line icons
dTree.prototype.indent = function (node, nodeId) {
    var str = '';
    var img = '';
    var onExpand = this.obj + '.o(' + nodeId + ');';

    if (this.config.loadOnDemand)
        onExpand = this.obj + '.ajax_loadNodes(' + nodeId + ');event.stopPropagation();';

    if (this.root.id != node.pid) {
        for (var n = 0; n < this.aIndent.length; n++)
            str += '<img src="' + ((this.aIndent[n] == 1 && this.config.useLines) ? this.icon.line : this.icon.empty) + '" alt="" class="invisible" />';
        (node._ls) ? this.aIndent.push(0) : this.aIndent.push(1);

        var openIcon = "fa-caret-right";

        if (node._hc) {
            str += '<span class="caret" onclick="' + onExpand + '"><img id="j' + this.obj + nodeId + '" src="';
            if (!this.config.useLines) str += (node._io) ? this.icon.nlMinus : this.icon.nlPlus;

                // pvo: 01-10-2008
            else {
                if (node._io) {
                    openIcon = "fa-caret-down";

                    if (node._ls && this.config.useLines) {
                        str += this.icon.minusBottom;
                    }

                    else if (!this.config.showRoot && node._fs && this.config.useLines && this.aNodes[0].id == node.pid)
                        str += this.icon.minusTop;
                    else
                        str += this.icon.minus;
                }
                else {
                    openIcon = "fa-caret-right";

                    if (node._ls && this.config.useLines) {
                        str += this.icon.plusBottom;
                    }

                    else if (!this.config.showRoot && node._fs && this.config.useLines && this.aNodes[0].id == node.pid)
                        str += this.icon.plusTop;
                    else
                        str += this.icon.plus;
                }
            }
            //else str += ((node._io) ? ((node._ls && this.config.useLines) ? this.icon.minusBottom : this.icon.minus) : ((node._ls && this.config.useLines) ? this.icon.plusBottom : this.icon.plus));
            str += '" alt="" style="display: none" /><i id="icon' + this.obj + nodeId + '" class="fa ' + openIcon + '  treeOpenBtn"></i></span>';
        } else {
            if (this.config.useLines) {
                if (node._fs && node.pid == this.aNodes[0].id) {
                    img = this.icon.joinTop;

                    if (node._siblings == 0)
                        img = this.icon.empty;
                } else if (node._ls)
                    img = this.icon.joinBottom;
                else
                    img = this.icon.join;
            } else {
                img = this.icon.empty;
            }

            str += '<img id="f' + this.obj + nodeId + '" src="' + img + '" alt="" class="invisible" style="width: 20px" />';
        }

        //} else str += '<img src="' + ((this.config.useLines) ? ((node._ls) ? this.icon.joinBottom : this.icon.join) : this.icon.empty) + '" alt="" />';

        // end: pvo: 01-10-2008
    }
    return str;
};

// Checks if a node has any children and if it is the last sibling
dTree.prototype.setCS = function (node) {
    var lastId;
    var firstId = -1;
    var siblings = 0;

    var childNodes = this.getNodesByPID(node.id);
    var siblingNodes = this.getNodesByPID(node.pid);

    if (childNodes.length > 0)
        node._hc = true;

    if (siblingNodes.length > 0) {
        siblings = siblingNodes.length;

        if (siblingNodes.length == 1 && siblingNodes[0] == node.id) {
            siblings = 0;
        }

        firstId = siblingNodes[0];
        lastId = siblingNodes[siblingNodes.length - 1];
    }

    node._siblings = siblings;
    if (lastId == node.id) node._ls = true;
    if (firstId == node.id) node._fs = true;
};

// Returns the selected node
dTree.prototype.getSelected = function () {
    var sn = this.getCookie('cs' + this.obj);
    return (sn) ? sn : null;
};

// Highlights the selected node based on the provided node id
dTree.prototype.select = function (id) {
    if (!this.config.useSelection) return;
    var cn = this.aNodes[t.nodeIndex(id)];
    if (cn._hc && !this.config.folderLinks) return;

    if (this.selectedNode != id) {
        if (this.selectedNode || this.selectedNode == 0) {
            eOld = document.getElementById("s" + this.obj + this.selectedNode);
            if (eOld) {
                eOld.className = "node";
            }

            var oldNodeElm = document.getElementById("dtn" + this.selectedNode);
            if (oldNodeElm) {
                oldNodeElm.className = "dTreeNode";
            }
        }
        this.highlight2(id);
        this.selectedNode = id;
        if (this.config.useCookies) this.setCookie('cs' + this.obj, cn.id);
    }
};

// Highlights the selected node by auto id
dTree.prototype.s = function (id) {
    if (!this.config.useSelection) return;
    var cn = this.aNodes[id];
    if (!cn) {
        cn = this.aNodes[t.nodeIndex(id)];
    }
    if (cn._hc && !this.config.folderLinks) return;

    if (this.selectedNode != id) {
        if (this.selectedNode || this.selectedNode == 0) {
            eOld = document.getElementById("s" + this.obj + this.selectedNode);
            if (eOld) {
                eOld.className = "node";
            }

            var oldNodeElm = document.getElementById("dtn" + this.selectedNode);
            if (oldNodeElm) {
                oldNodeElm.className = "dTreeNode";
            }
        }
        this.highlight(id);
        this.selectedNode = id;
        if (this.config.useCookies) this.setCookie('cs' + this.obj, cn.id);
    }
};

dTree.prototype.highlight = function (id) {
    var elm = document.getElementById("s" + this.obj + id);
    var nodeElm = document.getElementById("dtn" + id);
    if (!elm) {
        elm = document.getElementById("s" + this.obj + t.nodeIndex(id));
    }
    if (elm) {
        elm.className = "nodeSel";
        nodeElm.className = "dTreeNode nodeActive";
    }
};

dTree.prototype.highlight2 = function (id) {
    var elm = document.getElementById("s" + this.obj + t.nodeIndex(id));
    var nodeElm = document.getElementById("dtn" + id);
    if (elm) {
        elm.className = "nodeSel";
        nodeElm.className = "dTreeNode nodeActive";
    }
};

// Toggle Open or close
dTree.prototype.o = function (id) {
    var cn = this.aNodes[id];
    if (!cn) {
        cn = this.aNodes[t.nodeIndex(id)];
    }
    this.nodeStatus(!cn._io, id, cn._ls, cn._fs);
    cn._io = !cn._io;
    if (this.config.closeSameLevel) this.closeLevel(cn);
    if (this.config.useCookies) this.updateCookie();
};

// Open or close all nodes
dTree.prototype.oAll = function (status) {
    for (var n = 0; n < this.aNodes.length; n++) {
        if (this.aNodes[n]._hc && this.aNodes[n].pid != this.root.id) {
            this.nodeStatus(status, n, this.aNodes[n]._ls, this.aNodes[n]._fs)
            this.aNodes[n]._io = status;
        }
    }
    if (this.config.useCookies) this.updateCookie();
};

// Open or close all nodes
dTree.prototype.getCheckedNodes = function () {
    var checkedNodes = [];
    for (var i = 0; i < this.aNodes.length; i++) {
        var n = this.aNodes[i];
        if (n.checkable) {
            var box = $('tchk' + n.id);
            if (box.checked) {
                n.checked = true;
                checkedNodes.push(n);
            }
        }
    }
    return checkedNodes;
};

dTree.prototype.checkNode = function (nodeId) {
    var n = this.getNodeByID(nodeId);
    if (n.checkable) {
        var box = $('tchk' + n.id);
        if (!box.checked) {
            n.checked = true;
            box.checked = true;
        }
    }
};

dTree.prototype.uncheckAllNodes = function () {
    for (var i = 0; i < this.aNodes.length; i++) {
        var n = this.aNodes[i];
        if (n.checkable) {
            var box = $('tchk' + n.id);
            if (box.checked) {
                n.checked = false;
                box.checked = false;
            }
        }
    }
};

// Opens the tree to a specific node
dTree.prototype.openTo = function (nId, bSelect, bFirst) {
    if (!bFirst) {
        var node = this.getNodeByID(nId);
        if (node != null) nId = this.nodeIndex(nId);
    }
    var cn = (nId == -1 ? this.root : this.aNodes[nId]);
    if (cn.pid == this.root.id || !cn._p) return;
    cn._io = true;  //!!bFirst;
    cn._is = bSelect;
    if (this.completed && cn._hc) this.nodeStatus(true /*!!bFirst*/, cn._ai, cn._ls, cn._fs);
    if (this.completed && bSelect) this.s(cn._ai);
    else if (bSelect) this._sn = cn._ai;
    this.openTo(cn._p._ai, false, true);
};

// Opens the tree to a specific node with the given ItemID
dTree.prototype.openToItemID = function (iId, bSelect, bFirst) {
    var node = this.getNodeByItemID(iId);
    if (node != null) this.openTo(node.id, true);
};

dTree.prototype.loadTo = function (itemID, fromItemID, selectItemID, onComplete) {
    /// <summary>Loads tree levels to a specified level.</summary>
    /// <param name="itemID">Item ID of the node that represents an end point.</param>
    /// <param name="fromItemID">Item ID of the node that represents a start point.</param>
    /// <param name="selectItemID">Item ID of the node under the end level that should be selected.</param>
    /// <param name="onComplete">Callback which is fired when operation completes.</param>

    var self = this;

    onComplete = onComplete || function () { }

    if (!fromItemID) {
        fromItemID = this.get_dynamic().get_pathSeparator();
    }

    this.get_dynamic().expand(fromItemID, {
        path: itemID,
        onComplete: function () {
            if (selectItemID) {
                self.get_dynamic().highlight(selectItemID);
            }

            onComplete();
        }
    });
}

// Closes all nodes on the same level as certain node
dTree.prototype.closeLevel = function (node) {
    for (var n = 0; n < this.aNodes.length; n++) {
        if (this.aNodes[n].pid == node.pid && this.aNodes[n].id != node.id && this.aNodes[n]._hc) {
            this.nodeStatus(false, n, this.aNodes[n]._ls, this.aNodes[n]._fs);
            this.aNodes[n]._io = false;
            this.closeAllChildren(this.aNodes[n]);
        }
    }
}

// Closes all children of a node
dTree.prototype.closeAllChildren = function (node) {
    for (var n = 0; n < this.aNodes.length; n++) {
        if (this.aNodes[n].pid == node.id && this.aNodes[n]._hc) {
            if (this.aNodes[n]._io) this.nodeStatus(false, n, this.aNodes[n]._ls, this.aNodes[n]._fs);
            this.aNodes[n]._io = false;
            this.closeAllChildren(this.aNodes[n]);
        }
    }
}

// Change the status of a node(open or closed)
dTree.prototype.nodeStatus = function (status, id, bottom, top) {
    eDiv = document.getElementById('d' + this.obj + id);
    eJoin = document.getElementById('j' + this.obj + id);
    eVectorIcon = document.getElementById('icon' + this.obj + id);

    if (this.config.useIcons) {
        eIcon = document.getElementById('i' + this.obj + id);
        var node = this.aNodes[id];
        if (!node) {
            node = this.aNodes[t.nodeIndex(id)];
        }
        if (eIcon.tagName.toLocaleString() == "img") {
            var src = node.icon;
            src = ((node._io) ? node.iconClose : ((node._hc) ? node.iconOpen : node.icon));
            eIcon.src = src;
        }
    }

    // pvo: 01-10-2008
    var newImg = '';

    if (this.config.useLines) {
        if (status) {
            if (eVectorIcon) {
                eVectorIcon.addClassName("fa-caret-down");
                eVectorIcon.removeClassName("fa-caret-right");
            }

            if (!this.config.showRoot && top && this.aNodes[id].pid == this.aNodes[0].id) {
                newImg = this.icon.minusTop;

                if (this.aNodes[id]._siblings == 0)
                    newImg = this.icon.minusOne;
            }
            else if (bottom)
                newImg = this.icon.minusBottom;
            else
                newImg = this.icon.minus;
        } else {
            if (eVectorIcon) {
                eVectorIcon.addClassName("fa-caret-right");
                eVectorIcon.removeClassName("fa-caret-up");
            }

            if (!this.config.showRoot && top && this.aNodes[id].pid == this.aNodes[0].id) {
                newImg = this.icon.plusTop;

                if (this.aNodes[id]._siblings == 0)
                    newImg = this.icon.plusOne;
            }
            else if (bottom)
                newImg = this.icon.plusBottom;
            else
                newImg = this.icon.plus;
        }
    } else {
        if (status)
            newImg = this.icon.nlMinus;
        else
            newImg = this.icon.nlPlus;
    }

    if (eJoin) {
        eJoin.src = newImg;
    }

    eDiv.style.display = (status) ? 'block' : 'none';
};


// [Cookie] Clears a cookie
dTree.prototype.clearCookie = function () {
    var now = new Date();
    var yesterday = new Date(now.getTime() - 1000 * 60 * 60 * 24);
    this.setCookie('co' + this.obj, 'cookieValue', yesterday);
    this.setCookie('cs' + this.obj, 'cookieValue', yesterday);
};

// [Cookie] Sets value in a cookie
dTree.prototype.setCookie = function (cookieName, cookieValue, expires, path, domain, secure) {
    document.cookie =
		escape(cookieName) + '=' + escape(cookieValue)
		+ (expires ? '; expires=' + expires.toGMTString() : '')
		+ (path ? '; path=' + path : '')
		+ (domain ? '; domain=' + domain : '')
		+ (secure ? '; secure' : '');
};

// [Cookie] Gets a value from a cookie
dTree.prototype.getCookie = function (cookieName) {
    var cookieValue = '';
    var posName = document.cookie.indexOf(escape(cookieName) + '=');
    if (posName != -1) {
        var posValue = posName + (escape(cookieName) + '=').length;
        var endPos = document.cookie.indexOf(';', posValue);
        if (endPos != -1) cookieValue = unescape(document.cookie.substring(posValue, endPos));
        else cookieValue = unescape(document.cookie.substring(posValue));
    }
    return (cookieValue);
};

// [Cookie] Returns ids of open nodes as a string
dTree.prototype.updateCookie = function () {
    var str = '';
    for (var n = 0; n < this.aNodes.length; n++) {
        if (this.aNodes[n]._io && this.aNodes[n].pid != this.root.id) {
            if (str) str += '.';
            str += this.aNodes[n].id;
        }
    }
    this.setCookie('co' + this.obj, str, null, '/');
};

// [Cookie] Checks if a node id is in a cookie
dTree.prototype.isOpen = function (id) {
    var ret = false;
    var childFound = false;

    var aOpen = this.getCookie('co' + this.obj).split('.');

    for (var n = 0; n < aOpen.length; n++) {
        if (aOpen[n] == id) {
            ret = true;
            break;
        }
    }

    /* Node can not be marked as "open" if it doesn't have child nodes */
    if (ret) {
        childFound = this.getNodesByPID(id).length > 0;
        ret = ret && childFound;
    }

    return ret;
};


dTree.prototype.nodeIndex = function (nodeID) {
    var res = this.aNodesIndex.selectIndexById(nodeID);
    if (res || res == 0)
        return res;
    return -1;
}

/* ++++++ "Load on demand" implementation ++++++ */

/* Loads child nodes specified by parent ID using AJAX  */
dTree.prototype.ajax_loadNodes = function (parentID, forceLoad, onLoaded, customArgument) {
    var self = this;
    var json = null;
    var next = null;
    var hasChildren = null;

    if (!customArgument)
        customArgument = '';

    if (forceLoad) {
        this.ajax_markNode(parentID, false);
    }

    var cn, isRaiseExpandEvent = false;

    if (parentID >= 0) {
        cn = this.aNodes[parentID];
        if (!cn) cn = this.aNodes[t.nodeIndex(parentID)];
        isRaiseExpandEvent = !cn._io;
    }

    if (isRaiseExpandEvent) {
        var argBeforeExpandAjax = new dTree.ExpandEventArgs(parentID, null);
        this.onBeforeExpandAjax(argBeforeExpandAjax);
    }

    if (parentID >= 0 && this.ajax_nodesLoaded(parentID)) {
        this.o(parentID);

        if (isRaiseExpandEvent) {
            var children = this.getChildren(parentID);
            var argAfterExpandAjax = new dTree.ExpandEventArgs(parentID, children);
            this.onAfterExpandAjax(argAfterExpandAjax);
        }
    } else {
        if (parentID >= 0 && this.aNodes[parentID]._io)
            this.o(parentID);

        this.ajax_toggleLoading(parentID, true);

        if (!this.get_isBusy()) {
            this.set_isBusy(true);

            Dynamicweb.Ajax.doPostBack({
                eventTarget: this.config.controlID,
                eventArgument: this.aNodes[parentID].id + ',' + customArgument,

                onComplete: function (response) {
                    hasChildren = false;

                    if (response && response.responseText) {
                        try {
                            json = response.responseText.evalJSON();
                        } catch (ex)
                        {
                            console.log(ex);
                            json = null;
                        }

                        if (json) {
                            hasChildren = json.items.length > 0;
                            self.ajax_onNodesLoaded(parentID, json);
                        }
                    }

                    self.set_isBusy(false);

                    if (typeof (onLoaded) == 'function')
                        onLoaded(parentID);

                    if (!hasChildren) {
                        self.ajax_toggleLoading(parentID, false);
                        self.ajax_setNoChildren(parentID);
                    } else if (!self.aNodes[parentID]._hc) {
                        self.ajax_setNoChildren(parentID, false);
                    }

                    if (self._loadQueue.length > 0) {
                        next = self._loadQueue.pop();
                        self.ajax_loadNodes.apply(self, next);
                    }
                }
            });
        } else {
            this._loadQueue.push(Prototype.Browser.IE ? Array.prototype.slice.call(arguments) :
                [].splice.call(arguments, 0));
        }
    }
};

dTree.prototype.ajax_setNoChildren = function (parentID, noChildren) {
    var img = '';
    var lnk = null;
    var nodeLink = null;
    var nodeIcon = null;
    var imgContainer = null;
    var node = this.aNodes[parentID];

    if (node) {
        imgContainer = document.getElementById('j' + this.obj + parentID);
        if (!imgContainer && (typeof (noChildren) != 'undefined' && noChildren == false)) {
            nodeIcon = $('i' + this.obj + parentID);
            if (nodeIcon) {
                lnk = new Element('a');
                lnk.appendChild(new Element('img', { 'id': 'j' + this.obj + parentID, 'alt': '', 'title': '', 'border': '0' }));

                nodeIcon.up().removeChild(nodeIcon.previous());
                nodeIcon.up().insertBefore(lnk, nodeIcon);

                imgContainer = lnk.firstChild;
            }
        }

        if (imgContainer) {
            if (typeof (noChildren) == 'undefined' || noChildren == null || noChildren == true) {
                node._hc = false;

                if (this.config.useLines) {
                    if (node._fs && node.pid == this.aNodes[0].id) {
                        img = this.icon.joinTop;

                        if (node._siblings == 0)
                            img = this.icon.empty;
                    } else if (node._ls)
                        img = this.icon.joinBottom;
                    else
                        img = this.icon.join;
                } else {
                    img = this.icon.empty;
                }

                if (imgContainer.parentNode) {
                    imgContainer.parentNode.style.cursor = 'default';
                    imgContainer.parentNode.style.outline = 'none';
                    imgContainer.parentNode.href = 'javascript:void(0);';

                    nodeLink = $(imgContainer.parentNode).next('a');
                    if (nodeLink && nodeLink.href && nodeLink.href.indexOf('.ajax_loadNodes') > 0) {
                        nodeLink.href = 'javascript:void(0);';
                    }
                }
            } else {
                node._hc = true;

                if (this.config.useLines) {
                    if (node._fs && node.pid == this.aNodes[0].id) {
                        img = this.icon.minusTop;
                        if (node._siblings == 0) {
                            img = this.icon.minusOne;
                        }
                    } else if (node._ls) {
                        img = this.icon.minusBottom;
                    } else if (node._siblings > 0) {
                        img = this.icon.minus;
                    } else {
                        img = this.icon.minusOne;
                    }
                } else {
                    img = this.icon.nlMinus;
                }

                if (imgContainer.parentNode) {
                    imgContainer.parentNode.style.cursor = 'auto';
                    imgContainer.parentNode.href = 'javascript:' + this.obj + '.ajax_loadNodes(' + parentID + ');';
                }
            }

            imgContainer.src = img;
        }
    }
}

/* Retrieves page calling URL */
dTree.prototype.ajax_getHref = function () {
    var ret = location.href;
    var hashIndex = ret.indexOf('#');

    if (hashIndex >= 0)
        ret = ret.substring(0, hashIndex);

    return ret;
}

/* Marks specified node as loaded/not loaded */
dTree.prototype.ajax_markNode = function (nodeID, loaded) {
    if (!this.loadedNodes)
        this.loadedNodes = [];

    this.loadedNodes[nodeID + ''] = loaded;
}

/* Fires when nodes loaded from the server */
dTree.prototype.ajax_onNodesLoaded = function (nodeID, nodes) {
    var addedNodes = [];
    var manager = this.get_dragDropManager();

    this.ajax_markNode(nodeID, true);

    if (nodes) {
        addedNodes = this.ajax_addNodes(nodes);
        this.ajax_setIndent(nodeID);

        var addTo = $('d' + this.obj + nodeID);
        var html = this.addNode(this.aNodes[nodeID], true);
        if (addTo) {
            addTo.update(html);

            addTo.setStyle({ display: 'block' });
        }

        if (addedNodes && addedNodes.length > 0) {
            manager.register(addedNodes);
        }
    }

    this.ajax_toggleLoading(nodeID, false);

    if (nodeID > 0)
        this.o(nodeID);

    var children = this.getChildren(nodeID);
    var argAfterExpandAjax = new dTree.ExpandEventArgs(nodeID, children);
    this.onAfterExpandAjax(argAfterExpandAjax);
}

/* Calculates starting indent for the node. */
dTree.prototype.ajax_setIndent = function (nodeID) {

    var n = this.aNodes[nodeID];
    var parentID = -1;

    this.aIndent = [];
    while (n) {
        (n._ls) ? this.aIndent.push(0) : this.aIndent.push(1);

        parentID = n.pid;
        n = null;
        for (var i = 0; i < this.aNodes.length; i++) {
            if (this.aNodes[i].id == parentID && this.aNodes[i].id != this.root.id) {
                n = this.aNodes[i];
                break;
            }
        }
    }

    if (!this.config.showRoot)
        this.aIndent.pop();

    // Revert - LDE 11. Feb. 2009
    for (var i = 0; i < this.aIndent.length / 2; i++) {
        var temp = this.aIndent[i];
        this.aIndent[i] = this.aIndent[this.aIndent.length - 1 - i];
        this.aIndent[this.aIndent.length - 1 - i] = temp;
    }

}

/* Adds specified nodes to the node collection. */
dTree.prototype.ajax_addNodes = function (nodes) {

    var item = null;
    var index = -1;
    var addedNodes = [];
    var rowIndicies = [];

    for (var i = 0; i < nodes.items.length; i++) {
        item = nodes.items[i];

        if (this.config.autoID && this.aNodes.length > 0) {
            item.id = this.aNodes[this.aNodes.length - 1].id + 1;
        }

        index = this.nodeIndex(item.id);

        var newNode = new Node(item.id, item.pid, item.name, item.url, item.contextId, item.title,
            item.target, item.icon, item.iconOpen, item.iconClose, false, item.itemID, item.hasChildren == 'true', item.disabled == 'true', item.onDoubleClick, item.dragDrop, item.additionalCssClass, item.checkable, item.checked, item.additionalAttributes, item.knownIcon);
        if (this.config.autoID || index < 0) {
            this.aNodes.push(newNode);
            index = this.aNodes.length - 1;
        } else {
            this.aNodes[index] = newNode;
        }
        rowIndicies.push(index);
    }

    for (var i = 0; i < rowIndicies.length; i++) {
        addedNodes[addedNodes.length] = this.aNodes[rowIndicies[i]];
    }

    /* sorting nodes */
    this.sortNodes(rowIndicies, 0, rowIndicies.length - 1);

    // update index
    this.aNodesIndex.rebuildIndex(this.aNodes);

    return addedNodes;
}

/* Toggles 'Loading...' label on the parent node. */
dTree.prototype.ajax_toggleLoading = function (nodeID, show) {
    var obj = this;
    var nodeLabel = $('dtn' + nodeID + '_name');

    if (nodeID > 0) {
        if (show) {
            this.ajax_toggleLoading(nodeID, false);

            this._loadingTimeoutID = setTimeout(function () {
                nodeLabel.update(obj.config.loadingMessage);
            }, 500);
        } else {
            if (this._loadingTimeoutID > 0) {
                clearTimeout(this._loadingTimeoutID);
            }

            nodeLabel.update(this.aNodes[nodeID].name);
        }
    }
}

/* Determines whether nodes specified by parent ID are already in the tree. */
dTree.prototype.ajax_nodesLoaded = function (nodeID) {
    var ret = false;

    if (this.loadedNodes)
        ret = (this.loadedNodes[nodeID + ''] == true);

    return ret;
}

/* sort nodes by indicies (quick sort) */
dTree.prototype.sortNodes = function (indicies, start, end) {
    var i = start, j = end,
        x = indicies[Math.floor(Math.random() * (end - start + 1)) + start];

    do {
        while (indicies[i] < x)
            i++;

        while (indicies[j] > x)
            j--;

        if (i <= j) {
            this.swap(indicies, i, j);
            this.swap(this.aNodes, indicies[i], indicies[j]);
            i++; j--;
        }

    } while (i <= j);

    if (i < end)
        this.sortNodes(indicies, i, end);

    if (start < j)
        this.sortNodes(indicies, start, j);
}

dTree.prototype.nodeText = function (nodeID) {
    /// <summary>Returns the text of the given node.</summary>
    /// <param name="nodeID">An ID of the node.</param>
    /// <returns>Text of the given node.</returns>

    var n = null;
    var ret = '';

    if (typeof (nodeID) != 'undefined') {
        if (typeof (nodeID) == 'string') {
            n = this.getNodeByItemID(nodeID);
        } else {
            n = this.getNodeByID(nodeID);
        }

        if (n) {
            ret = n.name;
        }
    }

    return ret;
}

dTree.prototype.getSlice = function (pid) {
    return this._recursivelyCollect(pid);
}

dTree.prototype._recursivelyCollect = function (pid) {
    var ret = [];
    var children = [];

    if (pid) {
        ret = this.aNodesIndex._pids[pid];
        if (ret && ret.length) {
            for (var i = 0; i < ret.length; i++) {
                children = this._recursivelyCollect(ret[i]);
                if (children && children.length) {
                    for (var j = 0; j < children.length; j++) {
                        ret.push(children[j]);
                    }
                }
            }
        }
    }

    if (!ret) {
        ret = [];
    }

    return ret;
}

/* Gets node by ID */
dTree.prototype.getNodeByID = function (nodeID) {
    return this.aNodesIndex.selectById(nodeID) || null;
}

dTree.prototype.getNodeByItemID = function (itemID) {
    var ret = null;

    if (itemID) {
        for (var i = 0; i < this.aNodes.length; i++) {
            if (this.aNodes[i].itemID == itemID) {
                ret = this.aNodes[i];
                break;
            }
        }
    }

    return ret;
}

dTree.prototype.getNodesByPID = function (parentID) {
    return this.aNodesIndex.selectByPid(parentID) || [];
}

/* swaps two elements in specified array */
dTree.prototype.swap = function (list, i, j) {
    var temp = list[i];
    list[i] = list[j];
    list[j] = temp;
}

/* ++++++ End: "Load on demand" implementation ++++++ */

dTree.DynamicBehavior = function (tree) {
    /// <summary>Represents a dynamic (AJAX-enabled) tree.</summary>
    /// <param name="tree">Tree object.</param>

    this._tree = null;
    this._pathSeparator = '/';

    if (typeof (tree) == 'undefined' || !tree || typeof (tree.removeNode) != 'function') {
        dTree.error('Parameter object does not represent an instance of "dTree".');
    } else {
        this._tree = tree;
    }
}

dTree.DynamicBehavior.prototype.get_tree = function () {
    /// <summary>Gets the reference to the tree instance.</summary>

    return this._tree;
}

dTree.DynamicBehavior.prototype.get_isProgress = function () {
    /// <summary>Gets value indicating whether the progress indicator is visible.</summary>

    var ret = false;
    var body = $(document.getElementsByTagName('body')[0]);

    if (body) {
        ret = body.hasClassName('tree-content-progress');
    }

    return ret;
}

dTree.DynamicBehavior.prototype.set_isProgress = function (value) {
    /// <summary>Sets value indicating whether the progress indicator is visible.</summary>
    /// <param name="value">Value indicating whether the progress indicator is visible.</param>

    var body = $(document.getElementsByTagName('body')[0]);

    if (body) {
        if (value) {
            body.addClassName('tree-content-progress');
        } else {
            body.removeClassName('tree-content-progress');
        }
    }
}

dTree.DynamicBehavior.prototype.get_pathSeparator = function () {
    /// <summary>Gets tree node path separator.</summary>

    return this._pathSeparator;
}

dTree.DynamicBehavior.prototype.set_pathSeparator = function (value) {
    /// <summary>Gets tree node path separator.</summary>

    this._pathSeparator = (value + '');

    if (!this._pathSeparator) {
        this._pathSeparator = '/';
    }
}

dTree.DynamicBehavior.prototype.addNode = function (n) {
    /// <summary>Adds new node to the tree.</summary>
    /// <param name="n">Node reference.</param>

    var parent = null;

    if (n && n.pid) {
        parent = this.getNode(n.pid);
        if (parent) {
            this.insertNode(n, parent._siblings);
        }
    }
}

dTree.DynamicBehavior.prototype.insertNode = function (n, index) {
    /// <summary>Inserts new node to the tree.</summary>
    /// <param name="n">Node reference.</param>
    /// <param name="index">Zero-based index that represents a position on the target level to insert node into.</param>
    /// <returns>Newly created node.</returns>

    var html = '';
    var tmp = null;
    var ret = null;
    var nodeID = 0;
    var addTo = null;
    var indexes = [];
    var childIndex = 0;
    var addedNodes = [];
    var children = null;
    var manager = this.get_tree().get_dragDropManager();

    n = this._prepareNode(n);
    ret = n;

    if (n && n.pid) {
        nodeID = this.get_tree().nodeIndex(n.pid);

        children = this.get_tree().getNodesByPID(n.pid);
        if (children && children.length) {
            n._siblings = children.length;
            n._fs = index <= 0;
            n._ls = (index >= children.length);

            for (var i = 0; i < children.length; i++) {
                childIndex = this.get_tree().nodeIndex(children[i]);
                if (childIndex) {
                    indexes.push(childIndex);

                    this.get_tree().aNodes[childIndex]._siblings += 1;

                    if (this.get_tree().aNodes[childIndex]._ls && n._ls) {
                        this.get_tree().aNodes[childIndex]._ls = false;
                    } else if (this.get_tree().aNodes[childIndex]._fs && n._fs) {
                        this.get_tree().aNodes[childIndex]._fs = false;
                    }
                }
            }
        }

        addedNodes = this.get_tree().ajax_addNodes({ items: [n] });
        this.get_tree().aNodes[nodeID]._hc = true;

        indexes.push(this.get_tree().nodeIndex(addedNodes[0].id));

        if (indexes && indexes.length > 1 && index <= (indexes.length - 1)) {
            if (index < 0) {
                index = 0;
            } else if (index > (indexes.length - 1)) {
                index = children.length - 1;
            }

            tmp = this.get_tree().aNodes[indexes[indexes.length - 1]];
            for (var i = indexes.length - 1; i >= index + 1; i--) {
                this.get_tree().aNodes[indexes[i]] = this.get_tree().aNodes[indexes[i - 1]];
            }
            this.get_tree().aNodes[indexes[index]] = tmp;

            this.get_tree().aNodesIndex.rebuildIndex(this.get_tree().aNodes);
        }

        this.get_tree().ajax_setIndent(nodeID);

        addTo = $('d' + this.get_tree().obj + nodeID);
        html = this.get_tree().addNode(this.get_tree().aNodes[nodeID], true);

        if (addTo) {
            addTo.update(html);
            addTo.setStyle({ display: 'block' });
        }

        if (addedNodes && addedNodes.length > 0) {
            manager.register(addedNodes);
        }
    }

    return ret;
}

dTree.DynamicBehavior.prototype.removeNode = function (n) {
    /// <summary>Removes the given node as well as all its child nodes.</summary>
    /// <param name="n">Node reference.</param>

    var clip = null;
    var self = this;
    var nodes = null;
    var children = [];
    var markup = null;
    var mutations = [];
    var childIndex = 0;
    var parentIndex = 0;
    var removeNodeIndex = 0;
    var node = this.getNode(n);

    var identifier = function (str) {
        var ret = -1;
        var m = null;

        if (str && (m = /[a-zA-Z]+([0-9]+)/gi.exec(str)) != null) {
            ret = parseInt(m[1]);
        }

        return ret;
    }

    var prefix = function (str) {
        var ret = '';
        var m = null;

        if (str && (m = /([a-zA-Z]+)[0-9]+/gi.exec(str)) != null) {
            ret = m[1];
        }

        return ret;
    }

    if (node) {
        removeNodeIndex = this.get_tree().nodeIndex(node.id);
        markup = document.getElementById('dtn' + removeNodeIndex);
        clip = document.getElementById('d' + this.get_tree().obj + removeNodeIndex);
    }

    this._removeNodeRecursive(node);
    this.get_tree().selectedNode = null;

    if (node) {
        children = this.get_tree().getNodesByPID(node.pid);
        if (children && children.length) {
            for (var i = 0; i < children.length; i++) {
                childIndex = this.get_tree().nodeIndex(children[i]);
                if (childIndex) {
                    this.get_tree().aNodes[childIndex]._siblings -= 1;
                    this.get_tree().aNodes[childIndex]._fs = (i == 0);
                    this.get_tree().aNodes[childIndex]._ls = (i == (children.length - 1));
                }
            }

            if (node._ls) {
                this._updateStateIcon(this.getNode(children[children.length - 1]));
            }
        } else {
            parentIndex = this.get_tree().nodeIndex(node.pid);
            if (parentIndex) {
                this.get_tree().aNodes[parentIndex]._hc = false;
            }

            this._updateStateIcon(this.getNode(node.pid));
        }
    }

    if (markup) {
        $(markup).up().removeChild(markup);
    }

    if (clip) {
        $(clip).up().removeChild(clip);
    }

    mutations = [
        { selector: 'div.dTreeNode', mutate: function (node) {
                var newIdentifier = identifier(node.id) - 1;

                if (newIdentifier >= removeNodeIndex) {
                    node.id = prefix(node.id) + newIdentifier;
                }
            }
        },
        { selector: 'div.clip', mutate: function (node) {
                var newIdentifier = identifier(node.id) - 1;

                if (newIdentifier >= removeNodeIndex) {
                    node.id = prefix(node.id) + newIdentifier;
                }
            }
        },
        { selector: 'div.dTreeNode img[id]', mutate: function (node) {
                var newIdentifier = identifier(node.id) - 1;

                if (newIdentifier >= removeNodeIndex) {
                    node.id = prefix(node.id) + newIdentifier;
                }
            }
        },
        { selector: 'div.dTreeNode a', mutate: function (node) {
                var newIdentifier = identifier(node.up().id);

                if (newIdentifier >= removeNodeIndex) {
                    if (node.id) {
                        node.id = prefix(node.id) + newIdentifier;
                    }

                    if ((node.readAttribute('href') + '').indexOf('.ajax_loadNodes(') > 0) {
                        node.writeAttribute('href', 'javascript:' + self.get_tree().obj + '.ajax_loadNodes(' + newIdentifier + ');');
                    }

                    if (node.readAttribute('nodeID')) {
                        node.writeAttribute('nodeID', newIdentifier);
                    }

                    if ((node.readAttribute('onclick') + '').indexOf('.s(') > 0) {
                        node.onclick = function () {
                            self.get_tree().s(newIdentifier);
                        }

                        node.writeAttribute('onclick', 'javascript:' + self.get_tree().obj + '.s(' + newIdentifier + ');');
                    }
                }
            }
        },
        { selector: 'div.dTreeNode span[nodeID]', mutate: function (node) {
                var newIdentifier = identifier(node.id) - 1;

                if (newIdentifier >= removeNodeIndex) {
                    node.id = 'dtn' + newIdentifier + '_name';
                    node.writeAttribute('nodeID', newIdentifier);
                }
            }
        }
    ];

    for (var i = 0; i < mutations.length; i++) {
        nodes = $$(mutations[i].selector);
        if (nodes && nodes.length) {
            for (var j = 0; j < nodes.length; j++) {
                mutations[i].mutate($(nodes[j]));
            }
        }
    }
}

dTree.DynamicBehavior.prototype.removeChildNodes = function (p) {
    /// <summary>Removes all child nodes from the tree.</summary>
    /// <param name="p">Parent node reference.</param>

    var subNodes = this.get_tree().getNodesByPID(this.getNode(p));

    if (subNodes && subNodes.length) {
        for (var i = 0; i < subNodes.length; i++) {
            this.removeNode(subNodes[i]);
        }
    }
}

dTree.DynamicBehavior.prototype.expand = function (n, params) {
    /// <summary>Expands the given node.</summary>
    /// <param name="n">Node reference.</param>
    /// <param name="params">Method parameters.</param>

    var self = this;
    var current = '';
    var queue = null;
    var components = [];
    var difference = [];
    var sourceItemID = '';
    var onComplete = null;
    var nodeID = this.getNodeID(n);

    if (!params) {
        params = {};
    }

    onComplete = function () {
        var callback = params.onComplete || function () { }

        self.set_isProgress(false);
        callback();
    }

    if (nodeID) {
        if (params.path) {
            if (typeof (Dynamicweb) == 'undefined' || typeof (Dynamicweb.Utilities) == 'undefined' || typeof (Dynamicweb.Utilities.RequestQueue) == 'undefined') {
                dTree.error('Asynchronous path traversal requires "Dynamicweb.Utilities.RequestQueue".');
            } else {
                sourceItemID = this.getNodeItemID(n);

                if (params.path.toLowerCase() == sourceItemID.toLowerCase()) {
                    onComplete();
                } else if (params.path.toLowerCase().indexOf(sourceItemID.toLowerCase()) != 0 || sourceItemID.length >= params.path.length) {
                    dTree.error('Target node is not a sub-node of the source node.');
                } else {
                    components = [];

                    /* Loading start level */
                    components.push('');

                    difference = this.getPathDifference(sourceItemID, params.path);
                    if (difference && difference.length) {
                        for (var i = 0; i < difference.length; i++) {
                            components.push(difference[i]);
                        }
                    }

                    current = sourceItemID;
                    for (var i = 0; i < components.length; i++) {
                        if (current.lastIndexOf(this.get_pathSeparator()) == sourceItemID.length - 1) {
                            components[i] = current + components[i];
                        } else if (components[i] && components[i].length) {
                            components[i] = current + this.get_pathSeparator() + components[i];
                        }
                        else {
                            components[i] = current;
                        }

                        current = components[i];
                    }

                    queue = new Dynamicweb.Utilities.RequestQueue();

                    this.set_isProgress(true);

                    for (var i = 0; i < components.length; i++) {
                        queue.add(this, self._expandInner, [components[i], function () {
                            if (!queue.next()) {
                                onComplete();
                            }
                        } ]);
                    }

                    queue.executeAll();
                }
            }
        } else {
            this.get_tree().ajax_loadNodes(nodeID, true, function () {
                onComplete();
            });
        }
    }
}

dTree.DynamicBehavior.prototype.highlight = function (n) {
    /// <summary>Highlights the given node.</summary>
    /// <param name="n">Node reference.</param>

    var tree = this.get_tree();
    var nodeID = this.getNodeID(n);

    if (nodeID && tree) {
        /* Node can be selected but not highlighted */
        if (tree.selectedNode && tree.aNodes[tree.selectedNode].id == nodeID) {
            tree.highlight(tree.selectedNode);
        } else {
            tree.s(tree.nodeIndex(nodeID));
        }
    }
}

dTree.DynamicBehavior.prototype._updateStateIcon = function (n) {
    /// <summary>Updates state icon of the given node.</summary>
    /// <param name="n">Node reference.</param>
    /// <private />

    var imgChild = null;
    var imgParent = null;

    if (n) {
        imgChild = document.getElementById('f' + this.get_tree().obj + this.get_tree().nodeIndex(n.id));
        imgParent = document.getElementById('j' + this.get_tree().obj + this.get_tree().nodeIndex(n.id));

        if (imgParent) {
            if (n._hc) {
                if (this.get_tree().config.useLines) {
                    if (n._io) {
                        if (n._fs && n._ls) {
                            imgParent.src = this.get_tree().icon.minusOne;
                        } else if (n._fs && !n._ls) {
                            imgParent.src = this.get_tree().icon.minusTop;
                        } else if (!n._fs && n._ls) {
                            imgParent.src = this.get_tree().icon.minusBottom;
                        } else {
                            imgParent.src = this.get_tree().icon.minus;
                        }
                    } else {
                        if (n._fs && n._ls) {
                            imgParent.src = this.get_tree().icon.plusOne;
                        } else if (n._fs && !n._ls) {
                            imgParent.src = this.get_tree().icon.plusTop;
                        } else if (!n._fs && n._ls) {
                            imgParent.src = this.get_tree().icon.plusBottom;
                        } else {
                            imgParent.src = this.get_tree().icon.plus;
                        }
                    }
                } else {
                    if (children > 0) {
                        imgParent.src = n._io ? this.get_tree().icon.nlMinus : this.get_tree().icon.nlPlus;
                    } else {
                        imgParent.src = this.get_tree().icon.empty;
                    }
                }
            } else {
                imgChild = imgParent;
            }
        }

        if (imgChild) {
            if (n._ls) {
                imgChild.src = this.get_tree().icon.joinBottom;
            } else if (n._fs) {
                if (n._ls) {
                    imgChild.src = this.get_tree().icon.joinBottom;
                } else {
                    imgChild.src = this.get_tree().icon.join;
                }
            }
        }
    }
}

dTree.DynamicBehavior.prototype._prepareNode = function (n) {
    /// <summary>Prepares node to be added to the tree.</summary>
    /// <param name="n">Node reference.</param>
    /// <private />

    var ret = new Node();

    if (!n) {
        n = {};
    }

    ret.id = n.id || 0;
    ret.pid = n.pid || 0;
    ret.itemID = n.itemID || '';
    ret.name = n.name || '';
    ret.url = n.url || '';
    ret.contextId = n.contextId || '';
    ret.title = n.title || '';
    ret.target = n.title || ''
    ret.target = n.title || '';
    ret.icon = n.icon || '';
    ret.iconOpen = n.iconOpen || '';
    ret.iconClose = n.iconClose || '';
    ret.onDoubleClick = n.onDoubleClick || '';
    ret.additionalCssClass = n.additionalCssClass || '';
    ret.additionalAttributes = n.additionalAttributes || '';

    ret.checkable = !!n.checkable;
    ret.checked = !!n.checked;

    ret._io = !!n._io;
    ret._is = !!n._is;
    ret._ls = !!n._ls;
    ret._fs = !!n._fs;
    ret._hc = !!n._hc;

    ret._siblings = n._siblings || 0;
    ret._ai = n._ai || 0;
    ret._p = n._p || null;

    ret.disabled = !!n.disabled;
    ret._dragDrop = n._dragDrop || null;

    return ret;
}

dTree.DynamicBehavior.prototype._removeNodeRecursive = function (n) {
    /// <summary>Removes specified node and all its child nodes from the tree.</summary>
    /// <param name="n">Node reference.</param>
    /// <private />

    var children = [];
    var node = this.get_tree().get_dynamic().getNode(n);

    if (node) {
        this.get_tree().removeNode(this.get_tree().nodeIndex(node.id));
        children = this.get_tree().aNodesIndex._pids[node.pid];

        // Is this the last node on its level?
        if (!children || !children.length) {
            this.get_tree().ajax_setNoChildren(this.get_tree().nodeIndex(node.pid));
        }

        // Removing all child nodes
        children = this.get_tree().aNodesIndex._pids[node.id];
        if (children && children.length) {
            for (var i = 0; i < children.length; i++) {
                this._removeNodeRecursive(children[i]);
            }
        }
    }
}

dTree.DynamicBehavior.prototype._expandInner = function (itemID, onComplete) {
    /// <summary>Loads single tree level.</summary>
    /// <param name="itemID">Node item ID.</param>
    /// <param name="onComplete">Callback to be executed when operation completes.</param>
    /// <private />

    var node = 0;

    onComplete = onComplete || function () { }

    if (itemID) {
        node = this.getNode(itemID);
        if (node) {
            this.removeChildNodes(node);

            this.get_tree().ajax_loadNodes(this.get_tree().nodeIndex(node.id), true, function () {
                onComplete();
            });
        } else {
            onComplete();
        }
    } else {
        onComplete();
    }
}

dTree.DynamicBehavior.prototype.getNode = function (n) {
    /// <summary>Returns node instance.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Node instance.</returns>

    return this.get_tree().get_resolver().getNode(n);
}

dTree.DynamicBehavior.prototype.getNodeID = function (n) {
    /// <summary>Returns node ID.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Node ID.</returns>
    /// <private />

    return this.get_tree().get_resolver().getNodeID(n);
}

dTree.DynamicBehavior.prototype.getNodeItemID = function (n) {
    /// <summary>Returns node item ID.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Node item ID.</returns>

    return this.get_tree().get_resolver().getNodeItemID(n);
}

dTree.DynamicBehavior.prototype.getPath = function (n) {
    /// <summary>Returns array containing path components.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>An array containing path components.</returns>

    var ret = [];
    var trail = 0;
    var reference = n;
    var parent = null;
    var components = [];
    var n = this.getNode(n);

    if (n) {
        parent = n;

        do {
            parent = this.get_tree().getNodeByID(parent.pid);
            if (!parent) {
                break;
            } else {
                trail = (parent.itemID || '').lastIndexOf(this.get_pathSeparator());
                if (trail >= 0 && trail < (parent.itemID.length - 1)) {
                    components.push(parent.itemID.substr(trail + 1));
                } else {
                    break;
                }
            }
        } while (true);

        for (var i = components.length - 1; i >= 0; i--) {
            ret.push(components[i]);
        }

        if (n.itemID && n.itemID.length) {
            trail = n.itemID.lastIndexOf(this.get_pathSeparator());
            if (trail >= 0 && trail < (n.itemID.length - 1)) {
                ret.push(n.itemID.substr(trail + 1));
            }
        }
    } else if (typeof (reference) == 'string') {
        components = reference.split(this.get_pathSeparator());
        if (components && components.length) {
            for (var i = 0; i < components.length; i++) {
                if (components[i]) {
                    ret.push(components[i]);
                }
            }
        }
    }

    return ret;
}

dTree.DynamicBehavior.prototype.buildPath = function (components) {
    /// <summary>Builds path string using the given array of path components.</summary>
    /// <param name="components">An array of path components.</param>
    /// <returns>Path string.</returns>

    var ret = this.get_pathSeparator();

    if (components && components.length) {
        for (var i = 0; i < components.length; i++) {
            ret += components[i];
            if (i < (components.length - 1)) {
                ret += this.get_pathSeparator();
            }
        }
    }

    return ret;
}

dTree.DynamicBehavior.prototype.combinePath = function (path1, path2) {
    /// <summary>Combines two node paths.</summary>
    /// <param name="path1">First path.</param>
    /// <param name="path2">Second path.</param>
    /// <returns>Combined path.</returns>

    var ret = path1 || path2 || '';

    if (path1 && path2) {
        ret = path1;

        if (path2.indexOf(this.get_pathSeparator()) == 0 || path1.lastIndexOf(this.get_pathSeparator()) == (path1.length - 1)) {
            ret += path2;
        } else {
            ret += (this.get_pathSeparator() + path2);
        }
    }

    return ret;
}

dTree.DynamicBehavior.prototype.getPathDifference = function (n1, n2) {
    /// <summary>Returns array containing path components retrieved by substracting path components of the given nodes.</summary>
    /// <param name="n1">First node's reference.</param>
    /// <param name="n2">Second node's reference.</param>
    /// <returns>An array containing substracted path components.</returns>

    var ret = [];
    var tmp = null;
    var path1 = this.getPath(n1);
    var path2 = this.getPath(n2);

    if (path1.length != path2.length) {
        if (path1.length > path2.length) {
            tmp = path1;
            path1 = path2;
            path2 = tmp;
        }

        for (var i = path1.length; i <= path2.length - 1; i++) {
            ret.push(path2[i]);
        }
    }

    return ret;
}

dTree.DynamicBehavior.prototype.reducePath = function (n) {
    /// <summary>Reduces the path to the given node to one level.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Reduced node path.</returns>

    var ret = '';
    var newComponents = [];
    var components = this.getPath(n);

    if (components && components.length > 1) {
        for (var i = 0; i < components.length - 1; i++) {
            newComponents[newComponents.length] = components[i];
        }
    }

    ret = this.buildPath(newComponents);

    return ret;
}

dTree.NodeEditor = function (tree) {
    /// <summary>Provides an ability to edit tree nodes.</summary>
    /// <param name="tree">Tree object.</param>

    this._tree = null;
    this._textboxID = '';
    this._isCommitting = false;

    if (typeof (tree) == 'undefined' || !tree || typeof (tree.removeNode) != 'function') {
        dTree.error('Parameter object does not represent an instance of "dTree".');
    } else {
        this._tree = tree;
        this._textboxID = 'treeEditor_' + this._tree.obj;
    }

    this._options = {};

    this._state = {
        current: null,
        parent: null,
        originalValue: '',
        isNewNode: false
    };
}

dTree.NodeEditor.prototype.get_tree = function () {
    /// <summary>Gets the reference to the tree instance.</summary>

    return this._tree;
}

dTree.NodeEditor.prototype.get_state = function () {
    /// <summary>Gets object state.</summary>

    if (!this._state) {
        this._state = {};
    }

    return this._state;
}

dTree.NodeEditor.prototype.get_isEditing = function () {
    /// <summary>Gets value indicating whether node is being edited.</summary>

    return document.getElementById(this._textboxID) != null;
}

dTree.NodeEditor.prototype.get_isNewNode = function () {
    /// <summary>Gets value indicating whether new node has been created (instead of editing existing node).</summary>

    return this._state.isNewNode;
}

dTree.NodeEditor.prototype.get_currentValue = function () {
    /// <summary>Gets current value.</summary>

    var ret = '';
    var tx = document.getElementById(this._textboxID);

    if (tx) {
        ret = tx.value;
    }

    return ret;
}

dTree.NodeEditor.prototype.get_originalValue = function () {
    /// <summary>Gets original value.</summary>

    return this._state.originalValue;
}

dTree.NodeEditor.prototype.beginEdit = function (n, params) {
    /// <summary>Triggers editor into the "Editing" state.</summary>
    /// <param name="n">Node being edited.</param>

    var parent = null;

    this.abort();

    if (!params) {
        params = {};
    }

    this._options = params;
    this._state.current = this.get_tree().get_resolver().getNode(n);
    this._state.parent = this._options.parent;
    this._state.isNewNode = this._state.parent && !this._state.current;

    if (this._state.parent) {
        this._state.parent = this.get_tree().get_resolver().getNode(this._state.parent);
    } else if (this._state.current) {
        this._state.parent = this.get_tree().getNodeByID(this._state.current.pid);
    }

    if (this._state.parent || this._state.current) {
        this._textbox(true,params["removeContentWhenEditing"]);
    }
}

dTree.NodeEditor.prototype.abort = function () {
    /// <summary>Terminates editing of the current node without rturning any value.</summary>

    var doAbort = true;
    if (!this._isCommitting) {
        if (this._options.onAbort) {
            try {
                doAbort = !!this._options.onAbort(this, {
                    node: this._state.current,
                    value: this.get_currentValue(),
                    originalValue: this.get_originalValue()
                });
            } catch (ex) { }
        }

        if (doAbort && this.get_isEditing()) {
            if (this.get_isNewNode()) {
                this.get_tree().get_dynamic().removeNode(this._state.current);
            }

            this._textbox(false);

            this._state.current = null;
            this._state.parent = null;
        }
    }
}

dTree.NodeEditor.prototype.beginCommit = function () {
    /// <summary>Triggers editor into the "Commiting" state.</summary>

    var tx = document.getElementById(this._textboxID);

    if (this._options.onCommit) {
        if (tx) {
            tx.disabled = true;
        }

        this._options.onCommit(this, {
            node: this._state.current,
            value: this.get_currentValue(),
            originalValue: this.get_originalValue()
        });
    } else {
        this.commit();
    }
}

dTree.NodeEditor.prototype.commit = function (value) {
    /// <summary>Commits node value.</summary>
    /// <param name="value">Node value (optional).</param>

    var index = 0;
    var span = null;
    var node = null;
    var self = this;
    var commited = null;
    var originalValue = this.get_originalValue();

    value = value || this.get_currentValue();

    commited = function () {
        self._isCommitting = true;

        self._textbox(false);

        if (!self.get_isNewNode()) {
            index = self.get_tree().nodeIndex(self._state.current.id);
            if (index) {
                self.get_tree().aNodes[index].name = value;

                span = document.getElementById('dtn' + index + '_name');
                if (span) {
                    span.innerHTML = value;
                }
            }
        } else {
            if ((self._options.createMode + '').toLowerCase() == 'reload') {
                self.get_tree().get_dynamic().removeNode(self._state.current);

                index = self.get_tree().nodeIndex(self._state.parent.id);
                if (index) {
                    self.get_tree().ajax_loadNodes(index, true, null);
                }
            }
        }

        self._isCommitting = false;
    }

    if (!this.get_isNewNode()) {
        Dynamicweb.Ajax.doPostBack({
            eventTarget: this.get_tree().config.controlID,
            eventArgument: 'NodeEdit:' + this._state.current.id + ',' + value,
            onComplete: function (response) { commited(); }
        });
    } else {
        commited();
    }
}

dTree.NodeEditor.prototype._textbox = function (isVisible, removeContentWhenEditing) {
    /// <summary>Triggers editor's textbox visibility.</summary>
    /// <param name="isVisible">Value indicating whether textbox is visible.</param>
    /// <private />

    var tx = null;
    var index = 0;
    var obj = null;
    var self = this;
    var prefixes = ['s'];
    var opened = null, render = null, triggerControls = null;
    var removeContent = removeContentWhenEditing;

    opened = function () {
        var lnk = null;
        var mutated = null;
        var newIndex = self.get_tree().aNodes.length;
        var node = { id: newIndex, pid: self._state.parent.id };

        if (self._options.onCreate) {
            mutated = self._options.onCreate(self, { node: node });
            if (mutated != null) {
                node = mutated;
            }
        }

        self._state.current = self.get_tree().get_dynamic().insertNode(node, 0);
        newIndex = self.get_tree().nodeIndex(self._state.current.id);

        /* Hiding previous selection */
        if (self.get_tree().selectedNode) {
            lnk = $('st' + self.get_tree().selectedNode);

            var nodeElm = $("dtn" + self.get_tree().selectedNode);
            if (lnk) {
                lnk.removeClassName('nodeSel');
                lnk.addClassName('node');

                nodeElm.removeClassName = "nodeActive";
            }

            self.get_tree().selectedNode = null;
        }

        triggerControls(newIndex);
        render(newIndex);
    }

    render = function (index) {
        if (index) {
            obj = document.getElementById('dtn' + index);

            if (obj) {
                obj.appendChild(tx);


                if (removeContent) {
                    tx.value = "";
                }
                else {
                    tx.value = typeof (obj.innerText) != 'undefined' ? obj.innerText : obj.textContent;
                }

                self._state.originalValue = tx.value;

                Event.observe(tx, 'keydown', function (e) {
                    if (e.keyCode == 13) {
                        Event.stopObserving(tx, 'blur');
                        if (Event.element(e).value.length) {
                            self.beginCommit();
                        }
                        Event.stop(e);
                    } else if (e.keyCode == 27) {
                        Event.stopObserving(tx, 'blur');
                        self.abort();
                    }
                });

                Event.observe(tx, 'blur', function () { self.abort(); });

                try {
                    tx.select();
                } catch (ex) { }
            }
        }
    }

    triggerControls = function (index) {
        if (index) {
            for (var i = 0; i < prefixes.length; i++) {
                obj = document.getElementById(prefixes[i] + self.get_tree().obj + index);
                if (obj) {
                    obj.style.display = (isVisible ? 'none' : '');
                }
            }
        }
    }

    if (!this.get_isNewNode()) {
        index = this.get_tree().nodeIndex(this._state.current.id);
    }

    tx = document.getElementById(this._textboxID);
    if (tx) {
        if (!isVisible || $(tx).up().id != 'dtn' + index) {
            tx.parentNode.removeChild(tx);
            tx = null;
        }
    }

    if (!this.get_isNewNode()) {
        triggerControls(index);
    }

    if (isVisible && !tx) {
        tx = new Element('input', { 'id': this._textboxID, 'type': 'text', 'class': 'tree-node-edit' });

        if (this.get_isNewNode()) {
            index = this.get_tree().nodeIndex(this._state.parent.id);

            if (index) {
                if (this._state.parent._hc) {
                    if (!this._state.parent._io) {
                        if (!this.get_tree().config.loadOnDemand) {
                            this.get_tree().o(index);
                            opened();
                        } else {
                            this.get_tree().ajax_loadNodes(index, false, function () {
                                opened();
                            });
                        }
                    } else {
                        opened();
                    }
                } else {
                    opened();
                }

            }
        } else {
            render(index);
        }
    }
}

dTree.NodeResolver = function (tree) {
    /// <summary>Provides various methods for resolving tree nodes.</summary>
    /// <param name="tree">Tree object.</param>

    this._tree = null;

    if (typeof (tree) == 'undefined' || !tree || typeof (tree.removeNode) != 'function') {
        dTree.error('Parameter object does not represent an instance of "dTree".');
    } else {
        this._tree = tree;
    }
}

dTree.NodeResolver.prototype.get_tree = function () {
    /// <summary>Gets the reference to the tree instance.</summary>

    return this._tree;
}

dTree.NodeResolver.prototype.getNode = function (n) {
    /// <summary>Returns node instance.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Node instance.</returns>

    var ret = null;
    var nodeID = 0;

    if (typeof (n) != 'undefined' && n != null) {
        if (typeof (n.id) != 'undefined') {
            ret = n;
        } else {
            nodeID = this.getNodeID(n);
            if (nodeID) {
                ret = this.get_tree().getNodeByID(nodeID);
            }
        }
    }

    return ret;
}

dTree.NodeResolver.prototype.getNodeID = function (n) {
    /// <summary>Returns node ID.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Node ID.</returns>
    /// <private />

    var ret = 0;
    var node = null;

    if (typeof (n) != 'undefined' && n != null) {
        if (typeof (n.id) != 'undefined') {
            ret = n.id;
        } else if (typeof (n) == 'string') {
            ret = parseInt(n);
            if (typeof (ret) == 'undefined' || isNaN(ret)) {
                node = this.get_tree().getNodeByItemID(n);
                if (node) {
                    ret = node.id;
                }
            }
        } else if (typeof (n) == 'number') {
            ret = n;
        }
    }

    return ret;
}

dTree.NodeResolver.prototype.getNodeItemID = function (n) {
    /// <summary>Returns node item ID.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Node item ID.</returns>

    var ret = '';
    var node = null;

    if (typeof (n) != 'undefined' && n != null) {
        if (typeof (n.itemID) != 'undefined') {
            ret = n.itemID;
        } else if (typeof (n) == 'string') {
            ret = n;
        } else if (typeof (n) == 'number') {
            node = this.get_tree().getNodeByID(n);
            if (node) {
                ret = node.itemID;
            }
        }
    }

    return ret;
}

// If Push and pop is not implemented by the browser
if (!Array.prototype.push) {
    Array.prototype.push = function array_push() {
        for (var i = 0; i < arguments.length; i++)
            this[this.length] = arguments[i];
        return this.length;
    }
};
if (!Array.prototype.pop) {
    Array.prototype.pop = function array_pop() {
        lastElement = this[this.length - 1];
        this.length = Math.max(this.length - 1, 0);
        return lastElement;
    }
};

if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function (obj) {
        for (var i = 0; i < this.length; i++) {
            if (this[i] == obj) {
                return i;
            }
        }
        return -1;
    }
}

if (!Array.prototype.filter) {
    Array.prototype.filter = function (fun /*, thisp*/) {
        var len = this.length >>> 0;
        if (typeof fun != "function")
            throw new TypeError();

        var res = [];
        var thisp = arguments[1];
        for (var i = 0; i < len; i++) {
            if (i in this) {
                var val = this[i]; // in case fun mutates this
                if (fun.call(thisp, val, i, this))
                    res.push(val);
            }
        }
        return res;
    };
}

if (!Array.prototype.map) {
    Array.prototype.map = function (fun /*, thisp*/) {
        var len = this.length >>> 0;
        if (typeof fun != "function")
            throw new TypeError();

        var res = new Array(len);
        var thisp = arguments[1];
        for (var i = 0; i < len; i++) {
            if (i in this)
                res[i] = fun.call(thisp, this[i], i, this);
        }

        return res;
    };
}
