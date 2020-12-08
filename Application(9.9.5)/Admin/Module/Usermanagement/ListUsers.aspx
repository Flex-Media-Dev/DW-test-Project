<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListUsers.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement.ListUsers" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Security.Permissions" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  	<meta http-equiv="Pragma" content="no-cache" />
	<meta name="Cache-control" content="no-cache" />
	<meta http-equiv="Cache-control" content="no-cache" />
	<meta http-equiv="Expires" content="Tue, 20 Aug 1996 14:25:27 GMT" />

	<dw:ControlResources ID="ControlResources1" runat="server" />
	
	<script type="text/javascript" src="ListUsers.js"></script>
	
    <style type="text/css">      
        .row-ungrouped
        {
            background-color: #ffccbc;
        }
    </style>
    <script type="text/javascript">
        var groupID = <%=GroupID %>;
        var smartSearchID = '<%=SmartSearchID %>';
        var repositoryName = '<%=RepositoryName%>';
        var repositoryQueryName = '<%=RepositoryQuery %>';
        var doAddUser = '<%=DoAddUser %>' == 'True';
        
        var __context = new UserContext(groupID, smartSearchID, repositoryName, repositoryQueryName);
        
        /* Creating new row context menu */
        var __menu = new RowContextMenu({
            menuID: 'UserContext',
            groupID: groupID,
            permissionLevels: {
                cmdEditUser: <%= PermissionLevel.Edit %>, 
                cmdCreateCopy: <%= PermissionLevel.Create %>, 
                cmdDeleteUser: <%= PermissionLevel.Delete %>, 
                cmdDeleteSelected: <%= PermissionLevel.Delete %>, 
                cmdAttachToGroups: <%= PermissionLevel.Edit %>, 
                cmdDetachFromGroup: <%= PermissionLevel.Delete %>, 
                cmdActivateUser: <%= PermissionLevel.Edit %>,
                cmdDeactivateUser: <%= PermissionLevel.Edit %>, 
                cmdActivateSelected: <%= PermissionLevel.Edit %>,
                cmdSendUserInformation: <%= PermissionLevel.Edit %>,
                cmdDeactivateSelected: <%= PermissionLevel.Edit %>, 
                cmdNewUser: <%= PermissionLevel.Create %>,
            },
            onSelectContext: function(row, itemID) {
                var ret = '';
                var activeCount = 0;
                var selectedRows = List.getSelectedRows('UserList');
                
                /* Determining whether the target row is part of selection (and more that one row is selected) */
                if(List.rowIsSelected(row) && selectedRows.length > 1) {
                    
                    /* Getting the number of selected rows that are active */
                    for(var i = 0; i < selectedRows.length; i++) {
                        if(selectedRows[i].dataset.isactive === 'true')
                            activeCount++;
                    }
                    
                    if(activeCount === 0) {
                        /* No active rows */
                        ret = 'inactiveUserSelection';
                    } else if(activeCount == selectedRows.length) {
                        /* All rows are active */
                        ret = 'activeUserSelection';
                    } else {
                        /* Mixed mode */
                        ret = 'userSelection';
                    }
                } else {
                    /* Row is not selected (or it's the only one row which is selected) */
                    ret = row.dataset.isactive === 'true' ? 'activeUser' : 'inactiveUser';
                }
                
                return ret;
            }
        });
        
        if (doAddUser) {
            __context.newUser();
        }
        
        /* "activeUser" - applied to active user */
        __menu.registerContext('activeUser', 
            [ 'cmdEditUser', 'cmdCreateCopy', 'cmdDeleteUser', 
            'cmdAttachToGroups', 'cmdDetachFromGroup', 
            'cmdDeactivateUser', 'cmdNewUser' ]);
        
        /* "inactiveUser" - applied to inactive user */
        __menu.registerContext('inactiveUser', 
            [ 'cmdEditUser', 'cmdCreateCopy', 'cmdDeleteUser',
            'cmdAttachToGroups', 'cmdDetachFromGroup',
            'cmdActivateUser', 'cmdNewUser' ]); 
        
        /* "userSelection" - applied to selected users */
        __menu.registerContext('userSelection', 
            [ 'cmdDeleteSelected', 'cmdAttachToGroups', 'cmdDetachFromGroup', 
                'cmdActivateSelected', 'cmdDeactivateSelected', 'cmdNewUser', 'cmdSendUserInformation' ]);
        
        /* "activeUserSelection" - applied to selected users only when all users are active */    
        __menu.registerContext('activeUserSelection', 
            [ 'cmdDeleteSelected', 'cmdAttachToGroups', 'cmdDetachFromGroup', 
                'cmdDeactivateSelected', 'cmdNewUser', 'cmdSendUserInformation' ]);
         
         /* "inactiveUserSelection" - applied to selected users only when all users are inactive */   
         __menu.registerContext('inactiveUserSelection', 
            [ 'cmdDeleteSelected', 'cmdAttachToGroups', 'cmdDetachFromGroup', 
            'cmdActivateSelected', 'cmdNewUser' ]);
        
         document.observe("dom:loaded", function() {
             $("cmd").value = "";
             if ($("AttachGroupsDialogHidden").value === "true"){
                 $("AttachGroupsDialogHidden").value = "false";
                 __context.showGroupsDialog();
             }
         });

        function sendUserDetails() {
            var selectedUsers = __context._getTargetIDs();
            var dialogActionParams = <%= GetSentUserDetailsActionParams() %>;
            dialogActionParams.Url = '/Admin/Access/Access_User_SendMail.aspx?SelectedUserIds=' + selectedUsers;
            Action.Execute(dialogActionParams);
        }
    </script>
</head>
<body class="area-green screen-container">
    <div class="card">
        <form id="UserListForm" runat="server">
            <asp:HiddenField ID="cmd" runat="server" />
            <asp:HiddenField ID="cmdArgument" runat="server" />
            <asp:HiddenField ID="SelectedUserIds" runat="server" />
            <dw:List ID="UserList" runat="server" AllowMultiSelect="true" Title="Users" Personalize="true" NoItemsMessage="No users" UseCountForPaging="true"  HandlePagingManually="true">
                <Filters>
                    <dw:ListTextFilter ID="fSearch" Width="250" WaterMarkText="Search for users" Priority="1" runat="server" />
                    <dw:ListFlagFilter ID="fSearchAllFields" runat="server" Label=" Search in all fields" IsSet="false" Divide="none" LabelFirst="false" AutoPostBack="true" />
                    <dw:ListDropDownListFilter ID="fActiveState" Width="100" Label="Validity" AutoPostBack="true" Priority="3" runat="server">
                        <Items>
                            <dw:ListFilterOption Text="All" Value="None" Selected="true" />
                            <dw:ListFilterOption Text="Active" Value="True" />
                            <dw:ListFilterOption Text="Ikke_aktiv" Value="False" />
                        </Items>
                    </dw:ListDropDownListFilter>
                    <dw:ListDropDownListFilter ID="fBackendState" Width="100" Label="Backend login" AutoPostBack="true" Priority="2" runat="server" >
                        <Items>
                            <dw:ListFilterOption Text="All" Value="None" Selected="true" />
                            <dw:ListFilterOption Text="Allow" Value="True" />
                            <dw:ListFilterOption Text="Deny" Value="False" />
                        </Items>
                    </dw:ListDropDownListFilter>
                    <dw:ListDropDownListFilter ID="fUserPerPage" Width="50" Label="Users per page" AutoPostBack="true" Priority="4" runat="server">
                        <Items>
                            <dw:ListFilterOption Text="All" Value="None" />
                            <dw:ListFilterOption Text="25" Value="25" Selected="true"/>
                            <dw:ListFilterOption Text="50" Value="50"/>
                            <dw:ListFilterOption Text="100" Value="100"/>
                            <dw:ListFilterOption Text="200" value="200"/>
                        </Items>
                    </dw:ListDropDownListFilter>
                </Filters>
		    </dw:List>
            
            <dw:ContextMenu ID="UserContext" runat="server">
                <dw:ContextMenuButton ID="cmdEditUser" runat="server" Divide="None" Icon="Pencil" Text="Rediger" OnClientClick="__context.editUser();" />
                <%If GroupID <> -1000 Then%>
                    <dw:ContextMenuButton ID="cmdCreateCopy" runat="server" Divide="None" Icon="ContentCopy" Text="Create copy" OnClientClick="__context.newUser(true);" />
                <%End If%>
                <%If GroupID > 0 Then%>
                    <dw:ContextMenuButton ID="cmdNewUser" runat="server" Divide="Before" Icon="PlusSquare" Text="Ny_bruger" OnClientClick="__context.newUser();" />
                <%End If%>
                <dw:ContextMenuButton ID="cmdDeleteSelected" runat="server" Divide="Before" Icon="Delete" Text="Delete_selected" OnClientClick="__context.deleteUser();" />
                <dw:ContextMenuButton ID="cmdAttachToGroups" runat="server" Divide="None" Icon="AttachFile" Text="Tilføj_grupper" OnClientClick="__context.showAllGroupsDialog();" />
                <%If GroupID > 0 Then%>
                    <dw:ContextMenuButton ID="cmdDetachFromGroup" runat="server" Divide="None" Icon="NotInterested" Text="Remove from group" OnClientClick="__context.detachFromGroup();" />
                <%End If%>
                <dw:ContextMenuButton ID="cmdActivateUser" runat="server" Divide="Before" Icon="Check" Text="Activate" OnClientClick="__context.setActive(true);" />
                <dw:ContextMenuButton ID="cmdDeactivateUser" runat="server" Divide="None" Icon="Close" Text="DeActivate" OnClientClick="__context.setActive(false);" />
                <dw:ContextMenuButton ID="cmdSendUserInformation" runat="server" Divide="After" Icon="Email" Text="Send details to users" OnClientClick="sendUserDetails();" />
                <dw:ContextMenuButton ID="cmdActivateSelected" runat="server" Divide="None" Icon="Check" Text="Activate selected" OnClientClick="__context.setActive(true);" />
                <dw:ContextMenuButton ID="cmdDeactivateSelected" runat="server" Divide="None" Icon="Times" Text="Deactivate selected" OnClientClick="__context.setActive(false);" />
                <dw:ContextMenuButton ID="cmdDeleteUser" runat="server" Divide="Before" Icon="Delete" Text="Slet" OnClientClick="__context.deleteUser();" />
            </dw:ContextMenu>

		    <dw:Dialog ID="AttachGroupsDialog" Title="Tilføj_grupper" Width="260" ShowOkButton="true" ShowCancelButton="true" OkAction="__context.attachToGroups();" runat="server">
                <dw:Infobar runat="server" Visible="false" ID="UserRestrictionsErrorMessage" Type="Error" Message="User type restrictions does not allow to attach one or more selected groups">
                    <br />
                    <asp:Label runat="server" ID="WrongGroups"></asp:Label>
                </dw:Infobar>
                <dw:Infobar runat="server" Visible="false" ID="UserPermissionsErrorMessage" Type="Error" Message="You don't have access to attach/detach from groups">
                    <br />
                    <asp:Label runat="server" ID="WrongPermissionGroups"></asp:Label>
                </dw:Infobar>
		        <dw:UserSelector ID="GroupsSelector" Show="Groups" runat="server"></dw:UserSelector>
		    </dw:Dialog>
            <asp:HiddenField ID="AttachGroupsDialogHidden" runat="server" />
		
	        <span id="spDeleteUser" style="display: none"><dw:TranslateLabel ID="lbDeleteUser" Text="Delete user?" runat="server" /></span>
	    
	        <span id="spDeleteUsers" style="display: none"><dw:TranslateLabel ID="lbDeleteUsers" Text="Delete users?" runat="server" /></span>
	    
            <dw:Overlay ID="overlay1" ShowWaitAnimation="true" runat="server"></dw:Overlay>

        </form>
    </div>
    <div class="card-footer">
        </div>
 <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
