<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PagePermission.aspx.vb" Inherits="Dynamicweb.Admin.PagePermission" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server" IncludePrototype="true"/>

    <script type="text/javascript">
        var pageID = <%=PageID %>;
        var areaID = <%=AreaID %>;

        function defaultUserSelected() {
            userSelected('default')
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
            } else {
                // Create new div
                var newDiv = document.createElement('div');
                newDiv.id = 'PermissionDiv' + id;
                $('PermissionDiv').appendChild(newDiv);
                
                // Get by AJAX
                ajaxPermission(id);
            }
        }
    
        function ajaxPermission(id) {
            var url = 'PagePermission.aspx?ajaxID=' + id + '&time=' + new Date().getTime();
            if (pageID != 0)
                url += '&PageID=' + pageID;
            else if (areaID != 0)
                url += '&AreaID=' + areaID;
                
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
                    $(divId).innerHTML = request.responseText;
                    
                    // Add to save collection
                    var idsToSave = $('idsToSave');
                    if (idsToSave.value.length > 0)
                        idsToSave.value += ',';
                    idsToSave.value += id;

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
                for (var i = 0; i < accesses.length; i++)
                    for (var j = 0; j < levels.length; j++)
                        if ($(id + levels[j] + accesses[i]))
                            $(id + levels[j] + accesses[i]).checked = false;
                
                //Return false to keep the user or group in the list
                return false;
            }

            // Remove the div
            try {
                $('PermissionDiv').removeChild($('PermissionDiv' + id));
            }
            catch (e) { }
            
            // Remove from save-ids
            var idsToSave = $('idsToSave');
            var ids = idsToSave.value.split(',');
            var newIdsToSave = '';
            for (i = 0; i < ids.length; i++) {
                if (ids[i] != '' + id) {
                    if (newIdsToSave.length > 0)
                        newIdsToSave += ',';
                    newIdsToSave += ids[i];
                }
            }
            idsToSave.value = newIdsToSave;
            
            return true;
        }
    </script>
</head>
<body>
    <form runat="server" id="PagePermissionForm">
        <asp:HiddenField runat="server" ID="idsToSave" />
        
        <dwc:GroupBox ID="LoginTemplateGroupBox" runat="server" Title="Frontend settings" DoTranslation="true">
            <table id="FrontendSettingsTable">
                <tr id="ShowInMenuRow">
                    <td style="width:170px; vertical-align:top">
                        <dw:TranslateLabel runat="server" Text="Show this page in menu" />
                    </td>
                    <td>
                        <asp:RadioButtonList runat="server" ID="ShowInMenu"></asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td style="width:170px; vertical-align:top">
                        <dw:TranslateLabel runat="server" Text="Login template" />
                    </td>
                    <td>
                        <dw:FileManager ID="PagePermissionTemplate" runat="server" Folder="Templates/Extranet" />
                    </td>
                </tr>                    
            </table>
        </dwc:GroupBox>        
        
        <dwc:GroupBox ID="UserSelectorGroupBox" runat="server" Title="Select group(s) and user(s)" DoTranslation="true">
            <table>
                <tr>
                    <td style="width:170px; vertical-align:top">
                        <dw:TranslateLabel runat="server" Text="Select" />
                    </td>
                    <td>
                        <dw:UserSelector runat="server" ID="UserSelector" NoneSelectedText="All users have permission" 
                            OnSelectScript="userSelected" OnUnselectScript="unselect" OnRemoveScript="remove" 
                            DisplayDefaultUser="true" DefaultUserName="Everyone" OnDefaultUserSelectScript="defaultUserSelected"
                            OnDefaultUserRemoveScript="defaultUserRemoved" HeightInRows="7" DiscoverHiddenItems="true" />
                    </td>
                </tr>                    
            </table>
        </dwc:GroupBox>

        <dwc:GroupBox ID="PermissionsGroupBox" runat="server" Title="Set permission" DoTranslation="true">
            <div id="PermissionDiv">
                <div id="PermissionDivNone">
                    <span style="color:Gray"><dw:TranslateLabel runat="server" Text="No user or group is selected" /></span>
                </div>
            </div>
        </dwc:GroupBox>
    </form>
    
    <script type="text/javascript">
        <%If Not ShowLoginTemplate Then%>
            UserSelectorUserSelector.selectDefaultDiv();
        <%End If%>

        if (pageID == 0) {
            // Hide page specific controls
            var table = document.getElementById('FrontendSettingsTable');
            if (table)
            {
                var tableBody = table.tBodies[0];
                tableBody.removeChild(document.getElementById('ShowInMenuRow'));
            }
        }
        
    </script>
</body>
</html>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
    %>