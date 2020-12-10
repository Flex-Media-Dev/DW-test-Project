

var main = {

    deleteMessage: "Delete?",

    contentFrame: function () {
        return document.getElementById("ContentFrame");
    },

    confirmDelete: function () {
        if (confirm(main.deleteMessage)) {
            return true;
        }
        return false;
    },

    getTree: function () {
        var tree;
        if (typeof (t) == 'undefined') {
            tree = window.parent.t;
        }
        else {
            tree = t;
        }
        return tree;
    },

    reloadTree: function (onLoaded) {
        var tree = main.getTree();
        tree.ajax_loadNodes(0, true, onLoaded);
    },

    removeCategoryNode: function (categoryId) {
        var tree = main.getTree();
        var nodeIndex = tree.nodeIndex(categoryId);

        tree.removeNode(nodeIndex);
        tree.selectedNode = null;

        this.reloadTree();
    },

    refreshNewsCountInTree: function (categoryId, status, newsCount) {
        var tree;
        if (typeof (t) == 'undefined') {
            tree = window.parent.t;
        }
        else {
            tree = t;
        }

        if (status == 0) {
            this.updateTreeNodeLabel(tree, categoryId, newsCount);
            this.updateTreeNodeLabel(tree, categoryId + 50000, newsCount);
        }
        else {
            this.updateTreeNodeLabel(tree, categoryId + 100000, newsCount);
        }
    },

    updateTreeNodeLabel: function (tree, nodeId, newsCount) {
        var node = tree.getNodeByID(nodeId);
        if (node == null) {
            return;
        }

        var nodeLabel = $('dtn' + nodeId + '_name');
        if (nodeLabel == null) {
            nodeLabel = window.parent.$('dtn' + node._ai + '_name');
        }
        node.name = node.name.replace(/\(\w*\)$/, '(' + newsCount + ')');
        nodeLabel.update(node.name);
    },

    openInContentFrame: function (url) {
        url = this.makeUrlUnique(url);

        var cf = main.contentFrame();
        if (cf) {
            cf.src = url;
        }
        else if (window.opener) {
            window.opener.location.href = url; //open in opener window
        }
        else {
            window.location.href = url; //reload current window
        }
    },

    makeUrlUnique: function (url) {
        var s = "?";
        if (url.indexOf("?") > 0) {
            s = "&";
        }
        return url + s + "zzz=" + Math.random();
    },

    openCustomFields: function () {
        this.openInContentFrame("/Admin/Module/NewsV2/Common/CustomFields/CustomFields_List.aspx?context=NewsV2_general");
    },

    openCustomFieldsSpecific: function () {
        this.openInContentFrame("/Admin/Module/NewsV2/Common/CustomGroups/CustomGroups_List.aspx?context=newsv2");

    }
}