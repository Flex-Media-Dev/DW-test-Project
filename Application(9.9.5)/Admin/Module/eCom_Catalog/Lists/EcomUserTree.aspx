<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomUserTree.aspx.vb" Inherits="Dynamicweb.Admin.EcomUserTree" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
     
    <script type="text/javascript" src="../images/functions.js"></script>
        <style type="text/css">
        .nav .title
        {
            width: 99%;
            display: none;
        }
        
        .nav .subtitle
        {
            width: 99%;
        }
        
        .nav .tree
        {
            width: 99%;
            top: 93px;
        }
        
        body.margin
        {
            margin: 0px;
        }
        input, select, textarea
        {
            font-size: 11px;
            font-family: verdana,arial;
        }
        
        .box-end
        {
            height: 21px;
            background-color: #dfe9f5;
            border-top: 1px solid #c3c3c3;
        }
    </style>
    <script type="text/javascript" language="JavaScript" src="../images/functions.js"></script>
    <script type="text/javascript">

        function getTree() {
            var tree;
            if (typeof (t) == 'undefined') {
                tree = window.parent.t;
            }
            else {
                tree = t;
            }
            return tree;
        }

        function hideAddGroupsButton() {
            //document.getElementById('transferExtranetSelect').style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30)progid:DXImageTransform.Microsoft.BasicImage(grayscale=1)";
            //document.getElementById('transferExtranetSelect').removeAttribute("href");
            //document.getElementById('transferExtranetSelect').style.cursor = "";
        }

        function showLoad() {
            if (document.getElementById('DW_Ecom_GroupTree').style.display == "") {
                document.getElementById('DW_Ecom_GroupTree').style.display = "none";
                document.getElementById('GroupWaitDlg').style.display = "";
            }
        }

        function precheckItems() {
            if (hasOptions(theCaller)) {
                var t = getTree();
                for (var i = (theCaller.options.length - 1); i >= 0; i--) {
                    var itemid = theCaller.options[i].value;
                    var nodeid = itemid.substring(4, itemid.length);
                    t.checkNode(nodeid);
                }
            }
        }

        var theCaller = eval("<%=caller%>");
        var theOutput = '<%=output %>'
        function submitGroups() {

            hideAddGroupsButton();
            showLoad();
            removeAllOptions(theCaller);

            var theCall = opener.document.getElementById(theCaller.id + '_div');

            /* clean out old values from the fake div */
            theCall.innerHTML = '';

            var itemId;
            var itemName;

            var t = getTree();
            var checkedNodes = t.getCheckedNodes();
            for (i = 0; i < checkedNodes.length; i++) {
                var node = checkedNodes[i];
                if (!existsOption(node.itemID)) {
                    var tmpid = node.itemID;
                    itemId = tmpid.substring(4, tmpid.length);
                    itemName = node.name;

                    var imgsrc = '';

                    /* is it a groups */
                    if (tmpid.substring(0, 4) == "GRP_") {
                        imgsrc = '/admin/access/ExtranetGroup_closed.gif';
                    }
                    /* or is it a user */
                    if (tmpid.substring(0, 4) == "USR_") {
                        imgsrc = '/admin/access/User_extranet.gif';
                    }

                    /* add fake div for gui look purposes */
                    var contentHolder = "";
                    contentHolder += '  <div id="' + tmpid + '" class="item" onclick="changeRowColor(this,event);">';
                    //contentHolder += '    <img id="img' + tmpid + '" class="itemimg" src="' + imgsrc + '" />';
                    contentHolder += '    ' + itemName + ' ';
                    contentHolder += '  </div>';
                    theCall.innerHTML += contentHolder;

                    /* add to select */
                    addOption(theCaller, itemName, tmpid);
                }
            }

            /*select all groups and users in selectbox*/
            SelectAllList(theCaller)

            /*end actions*/
            window.close();
        }

        function SelectAllList(selectObject) {
            for (var i = 0; i < selectObject.length; i++) {
                selectObject.options[i].selected = true;
            }
        }


        function existsOption(nodeID) {
            /* strip extra characters from the nodeID for easier comparing */
            var tmpnodeID = replaceSubstring(nodeID, 'GRP_', '');
            tmpnodeID = replaceSubstring(tmpnodeID, 'USR_', '');

            for (var i = (theCaller.options.length - 1); i >= 0; i--) {
                var optionID = theCaller.options[i].value;
                /* strip extra characters from the optionID */
                tmpoptionID = replaceSubstring(optionID, 'GRP_', '');
                tmpoptionID = replaceSubstring(tmpoptionID, 'USR_', '');
                /* is there a option object allready with this id? */
                if (tmpnodeID == tmpoptionID) {
                    return true;
                }
            }
            return false;
        }

        function addOption(selectObject, optionText, optionValue) {
            var len = selectObject.length++;
            selectObject.options[len].value = optionValue;
            selectObject.options[len].text = optionText;
            selectObject.selectedIndex = len;
        }

        function hasOptions(obj) {
            if (obj != null && obj.options != null) {
                return true;
            }
            return false;
        }

        function removeAllOptions(selectObject) {
            if (!hasOptions(selectObject)) {
                return;
            }

            for (var i = (selectObject.options.length - 1); i >= 0; i--) {
                var info = selectObject.options[i].value;
                selectObject.options[i] = null;		
            }
            selectObject.selectedIndex = 0;
        }

        function AfterCheckHandler(node, checkbox) {
            var t = getTree();
            t.uncheckAllNodes();
            t.checkNode(node.id);
        }		
    </script>
</head>
<body>
    <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
    <form id="form1" runat="server">
    <div id="GroupWaitDlg" style="position: absolute; top: 40px; left: 5; width: 100%;
        height: 1; display: none; cursor: wait;">
        <img src="../images/loading.gif" border="0" alt="loading" />
    </div>
    <dw:StretchedContainer ID="contentStretcher" runat="server" Anchor="body">
        <div id="DW_Ecom_GroupTree">
            <dw:Tree ID="Tree1" runat="server" ShowSubTitle="false" ShowRoot="false" OpenAll="false"
                UseSelection="true" AutoID="false" UseCookies="false" LoadOnDemand="false" UseLines="true" AfterClientCheck="AfterCheckHandler" >
                <dw:TreeNode ID="Root" NodeID="0" runat="server" Name="Root" ParentID="-1" />
            </dw:Tree>
            <asp:Button ID="SubmitCheckBoxForm" Style="display: none" runat="server"></asp:Button>
        </div>
    </dw:StretchedContainer>
    </form>
    <script type="text/javascript">
        precheckItems();
    </script>
</body>
</html>
