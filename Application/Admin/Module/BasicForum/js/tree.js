/* Represents a group tree helper */
var GroupTree = new Object();
GroupTree.everyOneGroupID = -1000;
/* Retrieves an instance of the tree object */
GroupTree.getTree = function() {
    var ret = null;
    
    if(typeof(t) != 'undefined')
        ret = t;
    
    return ret;
}

/* Retrieves the content frame */
GroupTree.getContentFrame = function() {
    return document.getElementById('ContentFrame');
}

/* Determines whether specified group is a root group */
GroupTree.isRootGroup = function(groupID) {
    var node = GroupTree.getNodeByGroupID(groupID);
    var ret = false;
    
    if(node) {
        ret = (node.pid == 0);
    }
    
    return ret;
}

/* Retrieves child nodes specified by parent group ID */
GroupTree.getNodesByParentGroupID = function(parentID) {
    var tree = GroupTree.getTree();
    var nodes = [];
    
    if(tree) {
        for(var i = 0; i < tree.aNodes.length; i++) {
            if(tree.aNodes[i].pid == parentID) {
                nodes[nodes.length] = tree.aNodes[i];    
            }
        }
    }
    
    return nodes;
}

/* Reloads child nodes specified by parent group ID using AJAX */
GroupTree.reloadGroups = function(parentID, onReloaded) {
    var tree = GroupTree.getTree();
    var nodeID = GroupTree.getNodeIDByGroupID(parentID);
    
    if(tree && nodeID >= 0) {
        tree.ajax_loadNodes(nodeID, true, onReloaded);
    }
}

/* Retrieves tree node ID by specified group ID */
GroupTree.getNodeIDByGroupID = function(groupID) {
    var ret = -1;
    var tree = GroupTree.getTree();
    
    if(tree) {
        for(var i = 0; i < tree.aNodes.length; i++) {
            if(tree.aNodes[i].id == groupID) {
                ret = i;
                break;
            }
        }
    }
    
    return ret;
}

/* Retrieves tree node by specified group ID */
GroupTree.getNodeByGroupID = function(groupID) {
    var tree = GroupTree.getTree();
    var ret = null;
    
    if(tree) {
        for(var i = 0; i < tree.aNodes.length; i++) {
            if(tree.aNodes[i].id == groupID) {
                ret = tree.aNodes[i];
                break;
            }
        }    
    }
    
    return ret;
}

/* Highlights specified group */
GroupTree.selectGroup = function(groupID) {
    var tree = GroupTree.getTree();
    
    if(groupID && tree) {
        /* Node can be selected but not highlighted */
        if(tree.selectedNode && tree.aNodes[tree.selectedNode].id == groupID) {
            tree.highlight(tree.selectedNode);
        } else {
            for (var i = 0; i < tree.aNodes.length; i++) {
                if(tree.aNodes[i].id == groupID) {
                    tree.s(i);
                    break;
                }
            }
        }
    }
}

/* Changes the URL of the context frame */
GroupTree.setContent = function(script, args) {
    GroupTree.getContentFrame().src = script + args;    
}

GroupTree.sortNodes = function(a, b) {
    if (a == b)
        return 0;
    else if (a == GroupTree.everyOneGroupID)
        return -1;
    else if (b == GroupTree.everyOneGroupID)
        return 1;
    else {
        var tree = GroupTree.getTree();
        var node1 = tree.aNodesIndex.selectById(a);
        var node2 = tree.aNodesIndex.selectById(b);
        return node1.name.localeCompare(node2.name);
    }
}

function GetContentFrameHeight() {
    return document.getElementById('ContentFrame').clientHeight;
}
