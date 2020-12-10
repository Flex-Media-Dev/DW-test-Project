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

/* Represents SmartSearch preview mode state */
GroupTree.userSmartSearchPreviewMode = "";

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

/* Fires when user clicks group */
GroupTree.click = function (groupID) {
    removeCookie("ListUsersPageSize" + groupID);
    removeCookie("ListUsersPageNumber" + groupID);
    navigateContent('ListUsers.aspx?GroupID=' + groupID);    
}

/* Fires when user clicks group */
GroupTree.clickSmartSearch = function (smartSearchID) {
    removeCookie("ListUsersPageSize" + smartSearchID);
    removeCookie("ListUsersPageNumber" + smartSearchID);
    navigateContent('ListUsers.aspx?SmartSearchID=' + smartSearchID);
}

/* Fires when user clicks repository query */
GroupTree.clickRepositoryQuery = function (repositoryName, queryName) {
    navigateContent('ListUsers.aspx?RepositoryName=' + repositoryName + '&QueryName=' + queryName);
}

/* Retrieves tree node ID by specified group ID */
GroupTree.getNodeIDByGroupID = function(groupID) {
    var ret = -1;
    var tree = GroupTree.getTree();
    
    if (tree) {
        var index = tree.aNodesIndex.selectIndexById(groupID);

        if (index !== undefined) {
            ret = index;
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

/* Fires when tree is loaded */
GroupTree.onLoad = function (clickGroupID, cmdUserID, cmdAction) {
    var tree = GroupTree.getTree();
    var firstNode = 1;
    var clickID = typeof (clickGroupID) != 'undefined' ? parseInt(clickGroupID) : 0;
    var userID = typeof (cmdUserID) != 'undefined' ? parseInt(cmdUserID) : 0;


    if (userID > 0) {
        /* View specified user */
        var action = typeof (cmdAction) != 'undefined' ? '&' + cmdAction + '=True' : '';
        setContentIsVisible(true);
        GroupTree.setContent('EditUser.aspx', '?GroupID=-1000&UserID=' + userID + action);
    }
    else if (tree && tree.aNodes.length > 1) {
        /* Clicking specified (or first) group */
        if (clickID > 0) {
            GroupTree.selectGroup(clickID);
            GroupTree.click(clickID);
        } else {
            tree.s(firstNode);
            GroupTree.click(tree.aNodes[firstNode].id);
        }
    }
}

/* Changes the URL of the context frame */
GroupTree.setContent = function (script, args) {
    GroupTree.getContentFrame().src = script + args;    
}

/* Represents a group tree context menu */
GroupTree.contextMenu = new Object();

/* Fires when context menu is shown */
GroupTree.contextMenu.onShow = function(groupID) {
    var specialGroups = $('noDeleteGroups').value;
    var deleteCmd = $('cbDeleteGroup');
    var delim = ',';
    var canDelete = true;
    
    if(specialGroups.indexOf(delim) < 0)
        delim = '';
    
    /* Determining whether user can delete specified group */
    if(specialGroups.indexOf(groupID + delim) >= 0 ||
        specialGroups.indexOf(delim + groupID) >= 0 ||
        specialGroups.indexOf(delim + groupID + delim) >= 0) {
        
        canDelete = false;
    }
    
    if (canDelete) {
        if (deleteCmd) {
            deleteCmd.show();
        }   
    }   
    else {
        if (deleteCmd) {
            deleteCmd.hide();
        }
    }
}

/* 'Add smart search' action */
GroupTree.contextMenu.addSmartSearch = function (addToRoot) {
    GroupTree.setContent('/Admin/Content/Management/SmartSearches/EditSmartSearch.aspx', '?CMD=ADD_SMART_SEARCH' + '&calledFrom=userMgr' + GroupTree.userSmartSearchPreviewMode + '&providerType=Dynamicweb.SmartSearch.Providers.User.UserProviderSmartSearch');
}

/* 'Edit smart search' action */
GroupTree.contextMenu.editSmartSearch = function () {
    var tree = GroupTree.getTree();
    var nodeItemID = (tree && tree.aNodes) ? tree.aNodes[tree.selectedNode].itemID : '';

    ContextMenu.hide();

    if (nodeItemID && nodeItemID != '')
        GroupTree.setContent('/Admin/Content/Management/SmartSearches/EditSmartSearch.aspx', '?ID=' + nodeItemID + '&CMD=EDIT_SMART_SEARCH' + GroupTree.userSmartSearchPreviewMode + '&calledFrom=userMgr');
}

/* 'Delete smart search' action */
GroupTree.contextMenu.deleteSmartSearch = function ()
{
    var tree = GroupTree.getTree();
    var nodeItemID = (tree && tree.aNodes) ? tree.aNodes[tree.selectedNode].itemID : '';

    ContextMenu.hide();

    if (nodeItemID && nodeItemID != '')
    {
        if(confirm(document.getElementById('mDeleteSmartSearch').innerHTML))
        {
            GroupTree.setContent('/Admin/Content/Management/SmartSearches/EditSmartSearch.aspx', '?ID=' + nodeItemID + '&CMD=DELETE_SMART_SEARCH' + '&calledFrom=userMgr');
            tree.get_dynamic().removeNode(tree.aNodes[tree.selectedNode]);
        }
    }
}

GroupTree.ReloadSmartSearch = function (url)
{
    var tree = GroupTree.getTree();
    var ssId = GroupTree.getNodeIDByItemID('SMART_SEARCH');

    if (tree && ssId >= 0)
        tree.ajax_loadNodes(ssId, true, true);

    GroupTree.setContent(url);
}

GroupTree.getNodeIDByItemID = function(itemID)
{
    var ret = -1;
    var tree = GroupTree.getTree();

    if(tree)
    {
        for(var i = 0; i < tree.aNodes.length; i++)
        {
            if(tree.aNodes[i].itemID == itemID)
            {
                ret = i;
                break;
            }
        }
    }

    return ret;
}

/* 'Add group' action */
GroupTree.contextMenu.addGroup = function(addToRoot) {
    var parentID = ContextMenu.callingID;
    var params = '';
    
    if(!addToRoot) {
        params = '?ParentID=' + parentID;
    }
    
    GroupTree.setContent('EditGroup.aspx', params);
}

/* 'Edit group' action */
GroupTree.contextMenu.editGroup = function() {
    GroupTree.setContent('EditGroup.aspx', '?ID=' + ContextMenu.callingID);
}

/* 'Move group' action */
GroupTree.contextMenu.moveGroup = function () {
    ContextMenu.hide();
    GroupTree.openWindow('/Admin/Module/UserManagement/SelectGroupPopup.aspx' +
        '?GroupCallBack=GroupTree.moveGroupWithID' +
        '&CompatibleWithOldExtranet=true' +
        '&ShowSmartSearch=false',
        'AddGroupPopup',
        200,
        400,
        function (returnValue) {
            if (returnValue && returnValue.groupID && returnValue.groupName) {
                var groupID = returnValue.groupID;
                var groupName = returnValue.groupName;
                var userCount = returnValue.userCount;
                GroupTree.moveGroupWithID(groupID, groupName, userCount);
            }
        });    
}

GroupTree.moveGroupWithID = function (groupID, groupName, userCount) {
    var fromGroupID = ContextMenu.callingID;
    var url = "Main.aspx?Action=Move&GroupID=" + encodeURIComponent(fromGroupID) + "&ToGroupID=" + encodeURIComponent(groupID);
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function (transport) {
            if (transport.responseText.truncate().length > 0) {
                alert(transport.responseText);
            }
            else {
                location.reload();
            }
        }
    });
}

/* 'Delete group' action */
GroupTree.contextMenu.deleteGroup = function() {
    var groupID = ContextMenu.callingID;
    var node = GroupTree.getNodeByGroupID(groupID);
    
    ContextMenu.hide();
    
    if(node) {
        if (confirm(document.getElementById('mDeleteGroup').innerHTML)) {
            new Ajax.Request('Main.aspx?Action=Delete&GroupID=' + groupID, {
                method: 'get',
                onCreate: function () {
                    // hide content window before deleting
                    setContentIsVisible(false);
                },
                onComplete: function(response) {
                    var parentID = node.pid;   
                    var tree = GroupTree.getTree();
                    
                    /* Removing the group from the tree */
                    if(tree) {
                        tree.removeNode(GroupTree.getNodeIDByGroupID(groupID));
                        tree.selectedNode = null;
                    }
                    
                    /* is this a root group? */
                    if(parentID == 0) {
                        if(tree) {
                            tree.aNodes = [ tree.aNodes[0] ];
                            tree.loadedNodes = [];
                        }
                            
                        GroupTree.reloadGroups(0, function() {
                            GroupTree.onLoad();
                        });
                    } else {
                        /* Is this a last sub group? */
                        if(GroupTree.getNodesByParentGroupID(parentID).length == 0) {
                            parentOfParent = GroupTree.getNodeByGroupID(parentID);
                            
                            /* Reloading parent level */
                            if(parentOfParent) {
                                GroupTree.reloadGroups(parentOfParent.pid, function() {
                                    GroupTree.onLoad(parentID);
                                });    
                            }   
                        } else {
                            /* Reloading level */
                            GroupTree.reloadGroups(parentID, function() {
                                GroupTree.onLoad(parentID);
                            });
                        }
                    }
                }
            });
        }
    }
}


/* 'Sort users' action */
GroupTree.contextMenu.sortUsers = function () {
    GroupTree.setContent('ListUsersSorting.aspx', '?GroupID=' + ContextMenu.callingID);
}

/* 'Add user' action */
GroupTree.contextMenu.addUser = function() {
    GroupTree.setContent('EditUser.aspx', '?GroupID=' + ContextMenu.callingID);
}

GroupTree.sortNodes = function (a, b) {
    var result;

    if (a == b) result = 0;
    else if (a == GroupTree.everyOneGroupID) result = -1;
    else if (b == GroupTree.everyOneGroupID) result = 1;
    else {
        var tree = GroupTree.getTree();
        var node1 = tree.aNodesIndex.selectById(a);
        var node2 = tree.aNodesIndex.selectById(b);

        if (node1.itemID == "REPOSITORY_QUERIES" || node2.itemID == "REPOSITORY_QUERIES") {
            if (node1.itemID == node2.itemID) result = 0;
            else if (node1.itemID == "REPOSITORY_QUERIES") result = 1;
            else if (node2.itemID == "REPOSITORY_QUERIES") result = -1;
        }
        else if (node1.itemID == "SMART_SEARCH" || node2.itemID == "SMART_SEARCH") {
            if (node1.itemID == node2.itemID) result = 0;
            else if (node1.itemID == "SMART_SEARCH") result = 1;
            else if (node2.itemID == "SMART_SEARCH") result = -1;
        } else  {
            result = node1.name.localeCompare(node2.name);
        }
    }

    return result;
}

function GetContentFrameHeight() {
    return document.getElementById('ContentFrame').clientHeight;
}

function setContentIsVisible(isVisible) {
    $("ContentFrame").setStyle({ display: (isVisible ? '' : 'none') });
    $("cellContentLoading").setStyle({ display: (isVisible ? 'none' : ''), left: '0px' });
}

function navigateContent(url) {
    setContentIsVisible(false);
    $("ContentFrame").src = url;
}

function removeCookie(name) {    
    document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;path=/;';
}

GroupTree.contextMenu.importUsers = function () {
    GroupTree.setContent('ImportUsers.aspx', '?GroupID=' + ContextMenu.callingID);
}
GroupTree.contextMenu.exportUsers = function (useSmartSearch) {
    if (useSmartSearch) {
        var tree = GroupTree.getTree();
        var nodeItemID = (tree && tree.aNodes) ? tree.aNodes[tree.selectedNode].itemID: '';
        GroupTree.setContent('ExportUsers.aspx', '?GroupID=' + nodeItemID + "&UseSmartSearch=" +useSmartSearch);
    } else {
        GroupTree.setContent('ExportUsers.aspx', '?GroupID=' + ContextMenu.callingID);
    }    
}

GroupTree.openWindow = function (url, windowName, width, height, onPopupClose) {
    if (window.showModalDialog) {
        var returnValue = window.showModalDialog(url, windowName, 'dialogHeight:' + height + 'px; dialogWidth:' + width + 'px;');
        if (onPopupClose) {
            onPopupClose(returnValue);
        }
        return returnValue;
    }
    else {
        var popupWnd = window.open(url, windowName, 'status=0,toolbar=0,menubar=0,resizable=0,directories=0,titlebar=0,modal=yes,width=' + width + ',height=' + height);
        if (onPopupClose) {
            popupWnd.onunload = function () {
                onPopupClose(popupWnd.returnValue);
            }
        }
    }
}
