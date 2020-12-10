<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomGroupSelector.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomGroupSelector1" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>
        <%=GetTitle()%></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    
    <script type="text/javascript" src="../images/functions.js"></script>
    <style type="text/css">
        .nav .title {
            width: 99%;
            display: none;
        }

        .nav .subtitle {
            width: 99%;
        }

        .nav .tree {
            width: 99%;
        }

        body.margin {
            margin: 0px;
        }

        input, select, textarea {
            font-size: 11px;
            font-family: verdana,arial;
        }

        div.search-box {
            position: absolute;
            top: 2px;
            right: 2px;
        }

        .box-end {
            height: 21px;
            background-color: #dfe9f5;
            border-top: 1px solid #c3c3c3;
        }
    </style>
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
            document.getElementById('transferGroupSelect').style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30)progid:DXImageTransform.Microsoft.BasicImage(grayscale=1)";
            document.getElementById('transferGroupSelect').removeAttribute("href");
            document.getElementById('transferGroupSelect').style.cursor = "";
        }

        function showLoad() {
            if (document.getElementById('DW_Ecom_GroupTree').style.display == "") {
                document.getElementById('DW_Ecom_GroupTree').style.display = "none";
                document.getElementById('GroupWaitDlg').style.display = "";
            }
        }

        function hideLoad() {
            document.getElementById('GroupWaitDlg').style.display = "none";
        }

        var newSelection = "";
        var selectedGrps = "";

        function submitGroups() {
            hideAddGroupsButton();
            showLoad();

            selectedGrps = "<%=selectedGrps%>";
			newSelection = selectedGrps

			LoopTree();
			setCaller();
			setTimeout("window.close()", 500);
        }

        function LoopTree() {

            var t = getTree();
            var checkedNodes = t.getCheckedNodes();
            for (i = 0; i < checkedNodes.length; i++) {
                var node = checkedNodes[i];
                var item = decodeURIComponent(node.itemID).evalJSON();

                oldValues = selectedGrps.toLowerCase();
                newValue = item.nodeId.toLowerCase();

                if (oldValues.indexOf("[" + newValue + "]") == -1) {
                    var nodeName = item.nodeId;

                    if (newSelection != "") {
                        newSelection += ';';
                    }

                    newSelection += "[" + nodeName + "]";
                }
            }
        }

        function setCaller() {
            if (newSelection != "") {
                var theCaller = eval("<%=callerString%>");
			    theCaller.value = newSelection;
			}

            <%If CMDString = "GetGroupRel" Then%>
		    window.opener.AddGroupRows();
            <%End If%>
		}

        function ProductListMoveToGroup(groupId) {
		    <%If CMDString = "PickFromListGroup" Then%>
		    var filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30);progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);-moz-opacity: 0.4;";
		    document.body.style.filter = "";

		    window.opener.productMenu.doMoveMultipleProducts(groupId);
		    setTimeout("window.close()", 500);
		    <%End If%>
		}

        function ProductListAttachToGroup(groupId) {
		    <%If CMDString = "PickFromListGroupForAttach" Then%>
            var filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30);progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);-moz-opacity: 0.4;";
            document.body.style.filter = "";

            window.opener.productMenu.doAttachMultipleProducts(groupId);
            setTimeout("window.close()", 500);
		    <%End If%>
        }

        function ProductListRemoveFromGroup(groupId) {
            <%If CMDString = "GetGroupIdForRemove" Then%>
            var filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30);progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);-moz-opacity: 0.4;";
            document.body.style.filter = "";

            window.opener.productMenu.doRemoveMultipleProducts(groupId);
            setTimeout("window.close()", 500);
		    <%End If%>
        }

        function ProductListCopyToGroup(groupId) {
		    <%If CMDString = "GetGroupIdForCopy" Then%>
		    var filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30);progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);-moz-opacity: 0.4;";
		    document.body.style.filter = "";

		    window.opener.productMenu.copyProductsToGroup(groupId);
		    setTimeout("window.close()", 500);
		    <%End If%>
		}
    </script>
</head>
<body>
    <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
    <div class="search-box">
        <asp:Literal ID="BoxSearch" runat="server"></asp:Literal>
    </div>
    <form id="form1" runat="server">
        <div id="GroupWaitDlg" style="position: absolute; top: 40; left: 5; width: 100%; height: 1; display: none; cursor: wait;">
            <img src="../images/loading.gif" border="0" alt="loading" />
        </div>
        <dw:StretchedContainer ID="contentStretcher" runat="server" Anchor="body">
            <div id="DW_Ecom_GroupTree">
                <dw:Tree ID="Tree1" runat="server" SubTitle="All categories" ShowRoot="false" OpenAll="false"
                    UseSelection="true" AutoID="true" UseCookies="false" LoadOnDemand="true" UseLines="true">
                    <dw:TreeNode ID="Root" NodeID="0" runat="server" Name="Root" ParentID="-1" />
                </dw:Tree>
                <asp:Literal ID="productSearchList" runat="server"></asp:Literal>
            </div>
        </dw:StretchedContainer>
        <input type="hidden" id="selected" name="selected" value="" runat="server" />
        <input type="hidden" id="didSetGroups" name="didSetGroups" value="<%= Dynamicweb.Context.Current.Request("didSetGroups") %>" />
    </form>
    <script type="text/javascript">
        var doSetSelected = '<%=setGroups %>';

        if (doSetSelected == "True") {
            var selectedGroups = eval('<%=selectedGroupsContainer %>');
            document.getElementById("selected").value = selectedGroups;
            document.getElementById("didSetGroups").value = "True";

            document.getElementById('form1').submit();
        }
    </script>
</body>
</html>
