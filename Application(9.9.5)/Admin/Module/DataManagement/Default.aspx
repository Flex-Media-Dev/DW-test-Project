<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin.DMDefault" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.eCommerce.UserPermissions" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>DM</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" runat="server" />

    <script type="text/javascript">
        var initID = <%=Converter.ToInt32(Dynamicweb.Context.Current.Request("initID"))%>;
        var cmd = '<%=Converter.ToString(Dynamicweb.Context.Current.Request("CMD"))%>';
        var txtNoMoreViews = '<%=Translate.JsTranslate("You cannot create any more data lists. Install 'Data List (Extended)' to create more.") %>';
    
        function submitMe(itemId) {
            document.getElementById('Form1').InitID.value = itemId;
            document.getElementById('Form1').submit();
        }
    
        function submitReload(itemId, cmd) {
            document.getElementById('Form1').InitID.value = itemId;
            document.getElementById('Form1').CMD.value = cmd;
            document.getElementById('Form1').submit();
        }
    
        function getContentFrameHeight() {
            return document.getElementById("ContentFrame").clientHeight;
        }
    
        function ContextmenuClick(cmd) {
            var id = ContextMenu.callingItemID;
            ContentFrameHandler(id, "", cmd);
        }
    
        function NodeClick(Id, Name, cmd) {
            ContentFrameHandler(Id, Name, cmd);
        }

        function ContentFrameHandler(Id, Name, cmd) {
    
            var contentFrame = document.getElementById("ContentFrame");
            switch(cmd) {
                case "ADD_CONNECTION":
                    contentFrame.src = "Connection/EditConnection.aspx?CMD=" + cmd;
                    break;
                case "DELETE_CONNECTION":
                    if (confirm('<%=Translate.JsTranslate("Delete connection?")%>')) {
                        contentFrame.src = "Connection/EditConnection.aspx?ID=" + Id + "&CMD=" + cmd;
                    }
                    break;
                case "EDIT_CONNECTION":
                case "COPY_CONNECTION":
                    contentFrame.src = "Connection/EditConnection.aspx?ID=" + Id + "&CMD=" + cmd;
                    break;
                case "ADD_VIEW":
                    contentFrame.src = "View/EditView.aspx?CMD=" + cmd;
                    break;
                case "EDIT_VIEW":
                    contentFrame.src = "View/EditView.aspx?ID=" + Id + "&CMD=" + cmd;
                    break;
                case "EDIT_AND_PREVIEW":
                    contentFrame.src = "View/EditView.aspx?ID=" + Id + "&CMD=" + cmd + "&preview=True";
                    break;
                case "DELETE_VIEW":
                    if (confirm('<%=Translate.JsTranslate("Delete view?")%>')) {
                        if(initID == Id) {
                            var url = "View/EditView.aspx?ID=" + Id + "&CMD=" + cmd;
                            new Ajax.Request( 'View/EditView.aspx', {
                                method:  'post',
                                parameters:  { 'ID': Id,'CMD':cmd},
                                onSuccess:  function(response) {
                                    parent.document.getElementById('ContentFrame').src='/Admin/Module/DataManagement/Default.aspx';
                                },
                                onFailure:  function() {
                                    alert("Wasn't deleted due to the error");
                                }
                            });
                        } else {
                            contentFrame.src = "View/EditView.aspx?ID=" + Id + "&CMD=" + cmd;
                        }
                    }
                    break;
                case "TESTVALUES_VIEW":
                    contentFrame.src = "ListContent.aspx?ID=" + Id + "&CMD=VIEWS&ChangeTestVars=True";
                    break;
                case "ADD_FORM_VIEW":
                    contentFrame.src = "Form/EditForm.aspx?CMD=" + cmd;
                    break;
                case "ADD_FORM_MANUAL":
                    contentFrame.src = "Form/EditForm.aspx?CMD=" + cmd;
                    break;
                case "EDIT_FORM":
                    contentFrame.src = "Form/EditForm.aspx?ID=" + Id + "&CMD=" + cmd;
                    break;
                case "DELETE_FORM":
                    if (confirm('<%=Translate.JsTranslate("Delete form?")%>')) {
                        contentFrame.src = "Form/EditForm.aspx?ID=" + Id + "&CMD=" + cmd;
                    }
                    break;      
                case "ADD_PUBLISHING":
                    contentFrame.src = "Publishing/EditPublishing.aspx?CMD=" + cmd;
                    break;
                case "EDIT_PUBLISHING":
                case "DELETE_PUBLISHING":
                    contentFrame.src = "Publishing/EditPublishing.aspx?ID=" + Id + "&CMD=" + cmd;
                    break;
                default:
                    contentFrame.src = "ListContent.aspx?ID=" + Id + "&Name=" + Name + "&CMD=" + cmd;
                    break;
            }
        }

        function collapseTree(e) {
            var treeContainer = document.getElementById('treeContainer');
            var contentContainer = document.getElementsByClassName('ContentFrameContainer')[0];
            var cellTreeCollapsed = document.getElementById('cellTreeCollapsed');

            if (treeContainer.classList.contains('collapsed')){
                treeContainer.classList.remove('collapsed');
                contentContainer.classList.remove('collapsed');
                cellTreeCollapsed.classList.add('hidden');
            } else {
                treeContainer.classList.add('collapsed');
                contentContainer.classList.add('collapsed');
                cellTreeCollapsed.classList.remove('hidden');
            } 
        }
    </script>
</head>
<body>
    <form id="Form1" runat="server">
        <dw:ModuleAdmin ID="ModuleAdmin" runat="server">
            <dw:Tree ID="Tree1" runat="server" Title="Data Lists" ShowSubTitle="False" ShowRoot="false" OpenAll="false" UseSelection="true" UseCookies="true" UseLines="true">
                <dw:TreeNode ID="TreeNode1" NodeID="0" runat="server" Name="Root" ParentID="-1" />
            </dw:Tree>
        </dw:ModuleAdmin>
        <input type="hidden" id="InitID" name="InitID" value="0" />
        <input type="hidden" id="CMD" name="CMD" value="" />
    </form>

    <dw:ContextMenu ID="ConnectionContext" runat="server">
        <dw:ContextMenuButton runat="server" Divide="None" Icon="PlusSquare" Text="New connection" OnClientClick="ContextmenuClick('ADD_CONNECTION');" />
    </dw:ContextMenu>
    <dw:ContextMenu ID="ConnectionContext_Adv" runat="server">
        <dw:ContextMenuButton runat="server" Divide="None" Icon="PlusSquare" Text="New connection" OnClientClick="ContextmenuClick('ADD_CONNECTION');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Pencil" Text="Edit connection" OnClientClick="ContextmenuClick('EDIT_CONNECTION');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Delete" Text="Delete connection" OnClientClick="ContextmenuClick('DELETE_CONNECTION');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Copy" Text="Copy connection" OnClientClick="ContextmenuClick('COPY_CONNECTION');" />
    </dw:ContextMenu>

    <dw:ContextMenu ID="ViewContext" runat="server">
        <dw:ContextMenuButton runat="server" Divide="None" Icon="PlusSquare" Text="New data list" OnClientClick="ContextmenuClick('ADD_VIEW');" />
    </dw:ContextMenu>
    <dw:ContextMenu ID="ViewContextDisabled" runat="server">
        <dw:ContextMenuButton runat="server" Divide="None" Icon="PlusSquare" Text="New data list" OnClientClick="alert(txtNoMoreViews);" />
    </dw:ContextMenu>
    <dw:ContextMenu ID="ViewContext_Adv" runat="server">
        <dw:ContextMenuButton runat="server" Divide="None" Icon="PlusSquare" Text="New data list" OnClientClick="ContextmenuClick('ADD_VIEW');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Pencil" Text="Edit data list" OnClientClick="ContextmenuClick('EDIT_VIEW');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Delete" Text="Delete data list" OnClientClick="ContextmenuClick('DELETE_VIEW');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Cog" Text="Change test values" OnClientClick="ContextmenuClick('TESTVALUES_VIEW');" />
    </dw:ContextMenu>

    <dw:ContextMenu ID="FormContext" runat="server">
        <dw:ContextMenuButton runat="server" Divide="None" Icon="PlusSquare" Text="Create form from table" OnClientClick="ContextmenuClick('ADD_FORM_VIEW');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="PlusSquare" Text="Create form manually" OnClientClick="ContextmenuClick('ADD_FORM_MANUAL');" />
    </dw:ContextMenu>
    <dw:ContextMenu ID="FormContext_Adv" runat="server">
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Pencil" Text="Edit form" OnClientClick="ContextmenuClick('EDIT_FORM');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Delete" Text="Delete form" OnClientClick="ContextmenuClick('DELETE_FORM');" />
    </dw:ContextMenu>

    <dw:ContextMenu ID="PublishingContext" runat="server">
        <dw:ContextMenuButton runat="server" Divide="None" Icon="PlusSquare" Text="New publishing" OnClientClick="ContextmenuClick('ADD_PUBLISHING');" />
    </dw:ContextMenu>
    <dw:ContextMenu ID="PublishingContext_Adv" runat="server">
        <dw:ContextMenuButton runat="server" Divide="None" Icon="PlusSquare" Text="New publishing" OnClientClick="ContextmenuClick('ADD_PUBLISHING');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Pencil" Text="Edit publishing" OnClientClick="ContextmenuClick('EDIT_PUBLISHING');" />
        <dw:ContextMenuButton runat="server" Divide="None" Icon="Delete" Text="Delete publishing" OnClientClick="ContextmenuClick('DELETE_PUBLISHING');" />
    </dw:ContextMenu>

    <script type="text/javascript">
        if (initID.length != 0 && cmd.length != 0) {
            ContentFrameHandler(initID, "", cmd);
        } else {
            try {
                if (t) {
                    if (initID > 0) {
                        // Open to firstID
                        t.openTo(initID);
                        for (i = 0; i < t.aNodes.length; i++) {
                            var node = t.aNodes[i];
                            if (node.id == initID) {
                                t.s(i);
                            }
                        }
                    } else {
                        // Open selected node
                        for (i = 0; i < t.aNodes.length; i++) {
                            var nodeB = t.aNodes[i];
                            if (nodeB._is) {
                                initID = nodeB.id;
                                break;
                            }
                        }
                    }
                }
            } catch (e) {
            }

            ContentFrameHandler(initID, "");
        }
    </script>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
