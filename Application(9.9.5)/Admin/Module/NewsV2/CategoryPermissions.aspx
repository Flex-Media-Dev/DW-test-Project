<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CategoryPermissions.aspx.vb"
    Inherits="Dynamicweb.Admin.NewsV2.CategoryPermissions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server" IncludePrototype="true" />
    <script type="text/javascript">
        function defaultUserSelected() {
            userSelected('default');
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
            $('PermissionDiv').appendChild(newDiv);

            // Get by AJAX
            ajaxPermission(id);
        }

        function ajaxPermission(id) {
            var url = 'CategoryPermissions.aspx?userID=' + id + '&time=' + new Date().getTime() + '&categoryId=<%=categoryId %>';
            var divId = 'PermissionDiv' + id;

            new Ajax.Updater(divId, url, {
                asynchronous: false,
                evalScripts: true,
                method: 'get',

                onLoading: function (request) { },
                onFailure: function (request) { },
                onComplete: function (request) { },
                onSuccess: function (request) {
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
                onException: function (request) { }
            });

            if ($('Access' + id + 'Deny').checked)
                setAllEnabled(false, id);
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
            var otherPermissionAccess = permissionAccess == 'Allow' ? 'Deny' : 'Allow';
            document.getElementById(permissionName + userID + otherPermissionAccess).checked = false;

            if (permissionName == 'Access') {
                var doEnable = permissionAccess == 'Allow' || !document.getElementById(permissionName + userID + permissionAccess).checked
                setAllEnabled(doEnable, userID)
            }
        }

        function setAllEnabled(enabled, userID) {
            try {
                var childControls = $('PermissionDiv' + userID).getElementsByTagName('input');
                for (var i = 0; i < childControls.length; i++) {
                    if (childControls[i].type == 'checkbox') {
                        if (childControls[i].id != 'Access' + userID + 'Allow' && childControls[i].id != 'Access' + userID + 'Deny') {
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

        function closeDialog() {
            parent.dialog.hide('<%=dialogID %>');
        }

        if ('<%=doClose %>' == 'True')
            closeDialog();

    </script>
</head>
<body class="area-deeppurple">
    <form runat="server" id="FileManagerPermissionEdit">
    <asp:HiddenField runat="server" ID="idsToSave" />
    <asp:HiddenField runat="server" ID="idsToDelete" />
    <table style="width: 100%">
        <tr>
            <td style="vertical-align: top;">
                <dw:GroupBox runat="server" Title="Select users" DoTranslation="true">
                    <div style="margin: 10px 10px 10px 10px;">
                        <dw:UserSelector runat="server" ID="UserSelector" NoneSelectedText="All users have permission"
                            OnSelectScript="userSelected" Show="Groups" OnUnselectScript="unselect" OnRemoveScript="remove"
                            OnlyBackend="true" DisplayDefaultUser="true" DefaultUserName="Everyone" OnDefaultUserSelectScript="defaultUserSelected"
                            HeightInRows="7" HideAdmins="true" />
                    </div>
                </dw:GroupBox>
                <dw:GroupBox runat="server" Title="Set permission" DoTranslation="true">
                    <div id="PermissionDiv" style="margin: 10px 10px 10px 10px; height: 201px;">
                        <div id="PermissionDivNone">
                            <span style="color: Gray">
                                <dw:TranslateLabel runat="server" Text="No user or group is selected" />
                            </span>
                        </div>
                    </div>
                </dw:GroupBox>
                <div style="margin: 10px 10px 10px 10px; text-align: right;">
                    <asp:Button runat="server" CssClass="btn" ID="SaveButton" UseSubmitBehavior="true" />
                    <asp:Button runat="server" CssClass="btn" ID="CancelButton" UseSubmitBehavior="false" />
                </div>
            </td>
        </tr>
    </table>
    </form>
    <script type="text/javascript">

        UserSelectorUserSelector.selectDefaultDiv();

    </script>
</body>
</html>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>