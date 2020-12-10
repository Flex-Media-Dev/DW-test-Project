<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="jobList.aspx.vb" Inherits="Dynamicweb.Admin.jobList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server" IncludeUIStylesheet="true">
        <Items>
            <dw:GenericResource Url="/Admin/Module/IntegrationV2/js/jobList.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>

    <script type="text/javascript">
        function CreateUrlTask() {
            $('activity').value = 'addurltask';
            dialog.hide('UrlBuilderDialog');
            document.getElementById('selectedUrlJob').value = SelectionBox.getElementsRightAsArray('UrlBuilderActionSelector');
            dialog.show('AddTaskDialog');
        }

        function GenerateUrl() {
            var jobs = SelectionBox.getElementsRightAsArray('UrlBuilderActionSelector');
            var syncExecution = document.getElementById('checkSyncExecution').checked;
            var stopOnFail = document.getElementById('checkStopOnFailedJob').checked;

            if (jobs.length == 0) {
                document.getElementById('UrlBuilderUrlValue').value = '';
                document.getElementById('btnCreateTask').disabled = 'disabled';
                return;
            }
            else {
                document.getElementById('btnCreateTask').removeAttribute('disabled');
            }

            ShowUrlBuilderOverlay();
            new Ajax.Request('/Admin/Module/IntegrationV2/jobList.aspx?action=UrlBuilder&SyncExecution=' + syncExecution + '&StopOnFailedJob=' + stopOnFail + '&jobsToRun=' + jobs, {
                method: 'post',
                onComplete: function (transport) {
                    document.getElementById('UrlBuilderUrlValue').value = transport.responseText;
                    HideUrlBuilderOverlay();
                },
            });
        }

        function SetSelectedJobs(listId, jobname) {
            var sjobs = GetSelectedJobsNames(listId);

            if (sjobs.length > 0)
                $('selectedJob').value = sjobs;
            else
                $('selectedJob').value = jobname;
        }

        function GetSelectedJobsNames(listId) {
            var ret = '';
            var jobs = List.getSelectedRows(listId);

            if (jobs != null) {
                var len = jobs.toArray().length;

                for (i = 0; i < len; i++) {
                    if (i > 0)
                        ret += ';';

                    ret += jobs[i].readAttribute("itemid");
                }
            }

            return ret;
        }

        function ShowUrlBuilderOverlay() {
            var o = new overlay('UrlBuilderOverlay');
            o.show();
        }

        function HideUrlBuilderOverlay() {
            var o = new overlay('UrlBuilderOverlay');
            o.hide();
        }

        function ValidateJobName() {
            var name = document.getElementById('newName').value;

            if (name == null || name == '' || name.indexOf(',') > -1) {
                alert('<%=Translate.JsTranslate("Invalid activity name")%>');
                return false;
            }
            else
                return true;
        }

        function DeleteJobs() {
            var jobs = List.getSelectedRows('activityList');

            if (jobs != null && jobs.toArray().length > 1)
                $('selectedJob').value = GetSelectedJobsNames('activityList');
            else
                $('selectedJob').value = ContextMenu.callingItemID;

            dialog.show('DeleteActivityDialog');
        }

        function DeleteActivity() {
            List.setAllSelected('activityList', false);
            $('form1').submit();
        }

        function OnSelectCtxView(sender, args) {
            var ret = ['activityListContextMenu'];
            var jobs = List.getSelectedRows('activityList');

            if (jobs != null && jobs.toArray().length > 1)
                ret.push('DeleteActivityButton');
            else {
                ret.push('RenameActivityButton');
                ret.push('EditDescriptionButton');
                ret.push('NotificationSettingsButton');
                ret.push('DeleteActivityButton');
                ret.push('RenameActivityButton');
                ret.push('LogButton');
                ret.push('AddTaskButton');
            }

            return ret;
        }

        function OnEditDescription() {
            var desc = List.getAllRows("activityList")[ContextMenu.callingID - 1].readAttribute('attrDescription');
            $('activity').value = 'editdesc';
            $('newJobDesc').value = desc;
            $('selectedJob').value = ContextMenu.callingItemID;
            dialog.show('editDescription');
        }

        function deleteLogs() {
            if (confirm('<%=Translate.JsTranslate("All logs older than a week will be deleted. Do you want to continue?")%>')) {
                var o = new overlay('forward');
                o.show();
                $('action').value = 'deleteLogs';
                $('form1').submit();
            };
        }

        function showLogs(url) {
            dialog.show("HistoryLogDialog", url);
        }

        function showNotificationSettings(url) {
            dialog.show("NotificationSettingsDialog", url || '/Admin/Module/IntegrationV2/NotificationSettings.aspx');
        }
    </script>
</head>
<body class="area-black screen-container">
    <dwc:Card runat="server">
        <form id="form1" runat="server">
            <dwc:CardHeader runat="server" Title="Data Integration" />
            <dw:Overlay ID="forward" Message="Please wait" runat="server"></dw:Overlay>
            <dwc:CardBody runat="server">
                <div>
                    <dw:Toolbar runat="server" ID="JobSelect" ShowEnd="false">
                        <dw:ToolbarButton runat="server" ID="btnNew" Text="New activity" Icon="PlusSquare" Translate="true" OnClientClick="dialog.show('NewJobWizardDialog', '/Admin/Module/IntegrationV2/SelectSource.aspx');" />
                        <dw:ToolbarButton runat="server" ID="btnNewFromTemplate" Text="New activity from template" Icon="PlusSquare" Translate="true" OnClientClick="dialog.show('NewJobFromTemplateDialog', '/Admin/Module/IntegrationV2/NewJobFromTemplate.aspx');" />
                        <dw:ToolbarButton runat="server" ID="btnUrl" Text="URL Builder" Icon="Gavel" Translate="true" OnClientClick="dialog.show('UrlBuilderDialog')" />
                        <dw:ToolbarButton runat="server" ID="btnDeleteLogs" Text="Delete old logs" Icon="Delete" Translate="true" OnClientClick="deleteLogs();" />
                    </dw:Toolbar>
                </div>
                <div id="jobs">
                    <input type="hidden" name="selectedJob" id="selectedJob" runat="server" />
                    <input type="hidden" name="selectedUrlJob" id="selectedUrlJob" runat="server" />
                    <input type="hidden" name="activity" id="activity" runat="server" />
                    <input type="hidden" name="action" id="action" runat="server" />
                    <dw:List ID="activityList" Title="Activities" AllowMultiSelect="true" Personalize="true" runat="server" ContextMenuID="activityListContextMenu">
                        <Columns>
                            <dw:ListColumn ID="clmStatusIcon" runat="server" Width="5" />
                            <dw:ListColumn ID="clmName" Name="Name" runat="server" Width="140" />                            
                            <dw:ListColumn ID="clmRun" Name="Run" runat="server" Width="10" />
                            <dw:ListColumn ID="clmTask" Name="Scheduled" runat="server" Width="50"/>                            
                            <dw:ListColumn ID="clmNextRun" Name="Next run" runat="server" Width="30" />
                            <dw:ListColumn ID="clmDesc" Name="Description" runat="server" />
                        </Columns>
                    </dw:List>

                    <dw:ContextMenu runat="server" ID="activityListContextMenu" OnClientSelectView="OnSelectCtxView">
                        <dw:ContextMenuButton runat="server" ID="RenameActivityButton" Text="Rename" Icon="Edit" OnClientClick="$('activity').value='rename';$('newName').value=ContextMenu.callingItemID;$('selectedJob').value=ContextMenu.callingItemID;dialog.show('RenameActivityDialog')">
                        </dw:ContextMenuButton>
                        <dw:ContextMenuButton runat="server" ID="EditDescriptionButton" Text="Edit description" Icon="Pencil" OnClientClick="OnEditDescription();">
                        </dw:ContextMenuButton>
                        <dw:ContextMenuButton runat="server" ID="NotificationSettingsButton" Text="Notification settings" Icon="Gear" OnClientClick="showNotificationSettings('/Admin/Module/IntegrationV2/NotificationSettings.aspx?selectedJob=' + ContextMenu.callingItemID);">
                        </dw:ContextMenuButton>
                        <dw:ContextMenuButton runat="server" ID="DeleteActivityButton" Text="Delete" Icon="Remove" OnClientClick="$('activity').value='delete'; DeleteJobs();">
                        </dw:ContextMenuButton>
                        <dw:ContextMenuButton runat="server" ID="LogButton" Text="Log" Icon="InfoCircle">
                        </dw:ContextMenuButton>
                        <dw:ContextMenuButton runat="server" ID="AddTaskButton" Text="Schedule task" Icon="ClockO" OnClientClick="$('activity').value='addtask';$('selectedJob').value=ContextMenu.callingItemID;dialog.show('AddTaskDialog');">
                        </dw:ContextMenuButton>
                    </dw:ContextMenu>
                </div>
            </dwc:CardBody>

            <dw:Dialog Title="Generate URL" ID="UrlBuilderDialog" Width="482" runat="server" OkAction="$('form1').submit();" ShowOkButton="true" OkText="Close">
                <dw:Overlay ID="UrlBuilderOverlay" Message="Please wait" runat="server"></dw:Overlay>
                <dwc:GroupBox runat="server" Title="Jobs">
                    <dw:SelectionBox ID="UrlBuilderActionSelector" runat="server" Label="Jobs" Width="170" Height="180" LeftHeader="Source jobs" RightHeader="Target jobs" TranslateHeaders="True" ShowSortRight="True"></dw:SelectionBox>
                </dwc:GroupBox>

                <dwc:GroupBox Title="Settings" runat="server">
                    <dwc:CheckBox runat="server" ID="checkSyncExecution" Label="Synchronous execution" Header="Include in URL" />
                    <dwc:CheckBox runat="server" ID="checkStopOnFailedJob" Label="Stop on failed jobs" />
                    <div class="form-group">
                        <div class="form-group-input left-indent">
                            <dwc:Button runat="server" ID="btnGenerate" Title="Generate URL" OnClick="GenerateUrl();" />
                        </div>
                    </div>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Result">
                    <dwc:InputTextArea ID="UrlBuilderUrlValue" Rows="5" runat="server" Label="Generated URL"></dwc:InputTextArea>
                </dwc:GroupBox>

                <div class="form-group">
                    <div class="form-group-input left-indent">
                        <dwc:Button runat="server" ID="btnCreateTask" Disabled="true" Title="Create as scheduled task" OnClick="CreateUrlTask();" />
                    </div>
                </div>
            </dw:Dialog>

            <dw:Dialog Title="New activity" ID="newJob" Width="390" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="$('form1').submit();">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tl1" runat="server" Text="Activity name" />
                        </td>
                        <td>
                            <input type="text" id="name" runat="server" class="NewUIinput" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <input type="checkbox" id="newJobAutomatedMapping" runat="server" />
                            <label for="newJobAutomatedMapping"><dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Perform mapping automatically on run" /></label>
                        </td>
                    </tr>
                </table>
            </dw:Dialog>

            <dw:Dialog Title="Rename activity" ID="RenameActivityDialog" Width="390" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="if(ValidateJobName()) {$('form1').submit();}">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="New name" />
                        </td>
                        <td>
                            <input type="text" id="newName" runat="server" class="NewUIinput" />
                        </td>
                    </tr>
                </table>
            </dw:Dialog>

            <dw:Dialog Title="Delete activity" ID="DeleteActivityDialog" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="DeleteActivity();">
                Are you sure you want to delete the activity?
            </dw:Dialog>

            <dw:Dialog Title="Edit description" ID="editDescription" Width="390" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="$('form1').submit();">
                 <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Activity description" />
                        </td>
                        <td>
                            <textarea id="newJobDesc" name="newJobDesc" runat="server" rows="3" cols="30"></textarea>
                        </td>
                    </tr>
                </table>
            </dw:Dialog>

            <dw:Dialog ID="NewJobWizardDialog" runat="server" Title="Create new activity" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
                <iframe id="NewJobWizardDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="NewJobFromTemplateDialog" runat="server" Title="New activity from template" HidePadding="true" ShowOkButton="false" ShowCancelButton="true" ShowClose="true">
                <iframe id="NewJobFromTemplateDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="HistoryLogDialog" runat="server" Title="Job log" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
                <iframe id="HistoryLogDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="NotificationSettingsDialog" runat="server" Title="Edit notification settings" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
                <iframe id="NotificationSettingsDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="AddTaskDialog" Title="Add scheduled integration task" ShowOkButton="true" ShowCancelButton="true" runat="server" OkAction="dialog.hide('AddTaskDialog');var o = new overlay('forward');o.show();$('form1').submit();">
                <dwc:GroupBox ID="GroupBox1" runat="server" Title="Schedule">                        
                    <dw:DateSelector runat="server" ID="TaskActiveFrom" Label="Begin" AllowNeverExpire="false" IncludeTime="true"></dw:DateSelector>                                            
                    <dwc:SelectPicker runat="server" ID="TaskRepeat" Label="Repeat every"></dwc:SelectPicker>                        
                </dwc:GroupBox>
            </dw:Dialog>

        </form>
    </dwc:Card>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
