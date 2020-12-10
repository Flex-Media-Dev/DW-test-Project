<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FileManagerPermissionEdit.aspx.vb" Inherits="Dynamicweb.Admin.FileManagerPermissionEdit" ClientIDMode="Static" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUIStylesheet="true"/>

    <script type="text/javascript">
        function defaultUserSelected() {
            userSelected('default');
        }
        function defaultUserRemoved() {
            remove('default');
            return false;
        }

        function userSelected(id) {
            // Hide all subdivs
            var subdivs = $('PermissionDiv').getElementsByTagName('div');
            for (var i = 0; i < subdivs.length; i++)
                subdivs[i].style.display = 'none';
            
            // Do we allready have the correct subdiv?
            if ($('PermissionDiv' + id)) {
                $('PermissionDiv' + id).style.display = '';
                return;
            }

            // Create new div
            var newDiv = document.createElement('div');
            newDiv.id = 'PermissionDiv' + id;
            newDiv.style.overflow = 'auto';
            newDiv.style.maxHeight = '201px';
            newDiv.style.width = '200px';
            $('PermissionDiv').appendChild(newDiv);

            // Get by AJAX
            ajaxPermission(id);
        }
    
        function ajaxPermission(id)
        {
            var url = 'FileManagerPermissionEdit.aspx?userID=' + id + '&time=' + new Date().getTime() + '&AccessElementType=<%=eltype%>&Element=<%=folder%>&SecurityFolder=<%=isSecurityFolder%>&isEmailMarketing=' + $('isEmailMarketing').value;
            var divId = 'PermissionDiv' + id;

            new Ajax.Updater(divId, url, {
                asynchronous: false,
                evalScripts: true,
                method: 'get',

                onLoading: function(request) { },
                onFailure: function(request) { },
                onComplete: function(request) { },
                onSuccess: function(request) {
                    //Add to div
                    $(divId).update(request.responseText);
                    
                    // Add to save collection
                    var idsToSave = $('idsToSave'); 
                    if (idsToSave.value.length > 0)
                        idsToSave.value += ',';
                    idsToSave.value += id;

                    // Remove from delete-ids
                    var idsToDelete = $('idsToDelete');
                    var ids = idsToDelete.value.split(',');
                    var newIdsToDelete = '';
                    for (var i = 0; i < ids.length; i++) {
                        if (ids[i] != '' + id) {
                            if (newIdsToDelete.length > 0)
                                newIdsToDelete += ',';
                            newIdsToDelete += ids[i];
                        }
                    }
                    idsToDelete.value = newIdsToDelete;
                },
                onException: function(request) { }
            });

        }

        function unselect() {
            // Hide all subdivs
            var subdivs = $('PermissionDiv').getElementsByTagName('div');
            for (var i = 0; i < subdivs.length; i++)
                subdivs[i].style.display = 'none';
                
            // Display 'none selected' div
            $('PermissionDivNone').style.display = '';
        }

        function remove(id) {
            var canBeDeleted = $(id + 'CanBeDeleted').value == "True";

            if (!canBeDeleted) {
                //Only uncheck the checkboxes
                var accesses = new Array('Allow', 'Deny');
                var levels = new Array('Frontend', 'Backend');
                for (var i = 0; i < accesses.length; i++) {
                    if ($("Read" + id + accesses[i]))
                        $("Read" + id + accesses[i]).checked = false;

                    if ($("Write" + id + accesses[i]))
                        $("Write" + id + accesses[i]).checked = false;
                }

                //Return false to keep the user or group in the list
                return false;
            }
            // Reset the users permission on this module
            var idsToDelete = $('idsToDelete');
            if (idsToDelete.value.length > 0)
                idsToDelete.value += ',';
            idsToDelete.value += id;

            // Remove the div
            try {
                $('PermissionDiv').removeChild($('PermissionDiv' + id));
            }
            catch (e) { }

            // Remove from save-ids
            var idsToSave = $('idsToSave');
            var ids = idsToSave.value.split(',');
            var newIdsToSave = '';
            for (var i = 0; i < ids.length; i++) {
                if (ids[i] != '' + id) {
                    if (newIdsToSave.length > 0)
                        newIdsToSave += ',';
                    newIdsToSave += ids[i];
                }
            }
            idsToSave.value = newIdsToSave;
        }

        function checkboxClicked(permissionName, userID, permissionAccess) {
            if (document.getElementById(permissionName + userID + permissionAccess)) {
                var otherPermissionAccess = permissionAccess == 'Allow' ? 'Deny' : 'Allow';
                document.getElementById(permissionName + userID + otherPermissionAccess).checked = false;
            }
        }

        function setAllEnabled(enabled, userID) {
            try {
                var childControls = $('PermissionDiv' + userID).getElementsByTagName('input');
                for (var i = 0; i < childControls.length; i++) {
                    if (childControls[i].type == 'checkbox') {
                        if (childControls[i].id != 'Read' + userID + 'Allow' && childControls[i].id != 'Read' + userID + 'Deny') {
                            childControls[i].disabled = !enabled;
                            if (!enabled)
                                childControls[i].checked = false;
                        }
                        if (childControls[i].id != 'Write' + userID + 'Allow' && childControls[i].id != 'Write' + userID + 'Deny') {
                            childControls[i].disabled = !enabled;
                            if (!enabled)
                                childControls[i].checked = false;
                        }
                    }
                }
            }
            catch (e) {
                return;
            }
        }
    </script>
</head>
<dwc:DialogLayout runat="server" ID="FileManagerPermissionEdit" Title="Edit permissions" HidePadding="True">
    <Content>
        <div class="col-md-0">
            <asp:HiddenField runat="server" ID="idsToSave" />
            <asp:HiddenField runat="server" ID="idsToDelete" />
            <asp:HiddenField runat="server" ID="isEmailMarketing" />
            <dw:GroupBox runat="server" Title="Select users" DoTranslation="true">
                <%If isSecurityFolder Then%>
                    <dw:UserSelector runat="server" ID="UserSelectorSecFolder" NoneSelectedText="All users have permission" OnSelectScript="userSelected" 
                                        OnUnselectScript="unselect" OnDefaultUserRemoveScript="defaultUserRemoved" OnRemoveScript="remove" OnlyBackend="false" DisplayDefaultUser="true" DefaultUserName="Everyone" 
                                        OnDefaultUserSelectScript="defaultUserSelected" HeightInRows="7" HideAdmins="true" />
                <%Else%>
                    <dw:UserSelector runat="server" ID="UserSelector" NoneSelectedText="All users have permission" OnSelectScript="userSelected" 
                                        OnUnselectScript="unselect" OnDefaultUserRemoveScript="defaultUserRemoved" OnRemoveScript="remove" OnlyBackend="true" DisplayDefaultUser="true" DefaultUserName="Everyone" 
                                        OnDefaultUserSelectScript="defaultUserSelected" HeightInRows="7" HideAdmins="true" />
                <%End If%>
            </dw:GroupBox>
                    
            <dw:GroupBox runat="server" Title="Set permission" DoTranslation="true">
                <div id="PermissionDiv">
                    <div id="PermissionDivNone">
                        <span style="color:Gray"><dw:TranslateLabel runat="server" Text="No user or group is selected" /></span>
                    </div>
                </div>
            </dw:GroupBox>                    
        </div>
        <script type="text/javascript">
            UserSelectorUserSelector.selectDefaultDiv();
        </script>
    </Content>
    <Footer>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Submit'})">OK</button>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})">Cancel</button>
    </Footer>
</dwc:DialogLayout>
</html>
<%
    Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>