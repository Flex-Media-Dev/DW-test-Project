<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="EditFlow.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.Flows.EditFlow" %>

<%@ Import Namespace="Dynamicweb.EmailMarketing" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content runat="server" ContentPlaceHolderID="HeadContent">
    <style type="text/css">
        .steps-list-container .steps-add-container {
            display:flex;
            margin-top:10px;
            justify-content:center;
        }
        .steps-list-container .infobar + .steps-add-container {
            display:none;
        }
    </style>
    <script>
        function showHelp() {
            <%=Gui.Help("omc.email.flow", "omc.email.flow")%>
        }
        function createEditFlowPage(opts) {
            var options = opts;
            var flowNameEl = document.getElementById(options.ids.name);
            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                if (!hasValue(flowNameEl)) {
                    dwGlobal.showControlErrors(flowNameEl, options.labels.emptyName);
                    flowNameEl.focus();
                    return false;
                }
                return true;
            };

            var obj = {
                init: function (opts) {
                    this.options = opts;
                    this.updateProcessingRadioButtons(document.getElementById("ScheduledRepeatInterval"));
                },

                save: function (close, cmdValue) {
                    if (validate()) {
                        if (close) {
                            document.getElementById('Close').value = "true";
                        }
                        var cmd = document.getElementById('cmdSubmit');
                        cmd.value = cmdValue || "Save";
                        cmd.click();
                    }
                },

                cancel: function () {
                    Action.Execute(this.options.actions.cancel);
                },

                deleteFlow: function () {
                    Action.Execute(this.options.actions.delete);
                },

                showCreateFlowStepDialog: function () {
                    document.getElementById("submitParam").value = "";
                    this._showEditFlowStepDialog("", "", this.options.defaults.delayUnit, this.options.defaults.delayValue);
                    return false;
                },

                showEditFlowStepDialog: function (stepId, emailId, emailTitle, delayUnit, delay) {
                    document.getElementById("submitParam").value = stepId;
                    this._showEditFlowStepDialog(emailId, emailTitle, delayUnit, delay);
                    return false;
                },

                _showEditFlowStepDialog: function (emailId, emailTitle, delayUnit, delay) {
                    document.getElementById(this.options.ids.delayUnit).value = delayUnit;
                    document.getElementById(this.options.ids.delayValue).value = delay;
                    document.getElementById("Title_EmailSelector").value = emailTitle;
                    var emailSelector = document.getElementById("EmailSelector");
                    emailSelector.value = emailId;
                    dwGlobal.hideControlErrors(emailSelector);
                    dialog.show('CreateFlowStepDialog');
                },

                createFlowStep: function () {
                    dialog.show('CreateFlowStepDialog');
                    var emailSelector = document.getElementById("EmailSelector");
                    var selectedEmail = emailSelector.value;
                    if (selectedEmail) {
                        this.save(false, document.getElementById("submitParam").value ? "SaveAndEditStep" : "SaveAndCreateStep");
                    } else {
                        dwGlobal.showControlErrors(emailSelector, this.options.labels.emptyEmail);
                    }
                },

                deleteStep: function (evt, stepId) {
                    evt.stopPropagation();
                    Action.Execute(this.options.actions.deleteStep, { stepId: stepId });
                    return false;
                },

                deleteStepConfirmed: function (act, model) {
                    document.getElementById("submitParam").value = model.stepId;
                    currentPage.save(false, 'SaveAndRemoveStep');
                },

                updateProcessingRadioButtons: function (selectpicker) {
                    if (selectpicker.value === "0") {
                        document.getElementById("RecipientBehavior_1").checked = true;
                        document.getElementById("RecipientBehavior_2").disabled = true;
                    } else {                        
                        document.getElementById("RecipientBehavior_2").disabled = false;
                    }
                },                
            };
            obj.init(opts);
            return obj;
        }
    </script>
</asp:Content>

<asp:Content ID="mainContent1" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="PageTitle" DoTranslate="false" Title="New flow"></dwc:CardHeader>
        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
            <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(true);" />
            <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.deleteFlow();" />
            <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="Help" Text="Help" OnClientClick="showHelp();" />
        </dw:Toolbar>
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="gbSettings" Title="Settings" runat="server">
                <dwc:InputText runat="server" ID="FlowName" Label="Name" ValidationMessage="" />
                <dwc:CheckBox runat="server" ID="Active" Name="Active" Label="Active" />
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel runat="server" Text="To" />
                    </label>
                    <dw:UserSelector runat="server" ID="RecipientSelector" NoneSelectedText="No one recipients selected" HeightInRows="7" DiscoverHiddenItems="False" MaxOne="False" OnlyBackend="False" ShowSmartSearches="True" ShowRepositoryQueries="true" Width="250" />
                </div>
                <dwc:CheckBox runat="server" ID="StopAddingNewRecipients" Name="StopAddingNewRecipients" Label="Stop adding new recipients" />
                <dw:DateSelector runat="server" ID="ScheduleStartDate" Label="Start" IncludeTime="True" />
                <dwc:SelectPicker runat="server" ID="ScheduledRepeatInterval" Label="Repeat every" onchange="currentPage.updateProcessingRadioButtons(this);" ClientIDMode="static" />
                <dwc:RadioGroup runat="server" ID="RecipientBehavior" Name="RecipientBehavior" Label="Processing" SelectedValue="ProcessAll" ClientIDMode="static">
                    <dwc:RadioButton runat="server" ID="ProcessAllRecipients" Label="Continue processing recipients not in 'To'" FieldValue="ProcessAll" />
                    <dwc:RadioButton runat="server" ID="ProcessOnlySelectedRecipients" Label="Stop processing recipients not in 'To'" FieldValue="ProcessOnlySelected" />
                </dwc:RadioGroup>
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbSteps" Title="Steps" runat="server">
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel runat="server" Text="Steps" />
                    </label>
                    <div class="form-group-input steps-list-container">
                        <dw:List ID="Steps" runat="server" Title="" ShowTitle="False" AllowMultiSelect="false">
	                        <Columns>
		                        <dw:ListColumn ID="colEmailSubject" runat="server" Name="Email Subject" />
			                    <dw:ListColumn ID="colPage" runat="server" Name="Page" />
		                        <dw:ListColumn ID="colEmail" runat="server" Name="Email Path" />
                                <dw:ListColumn ID="colDelay" runat="server" Name="Delay" />
                                <dw:ListColumn ID="colActions" runat="server" Name="" Width="20" ItemAlign="Right" />
		                    </Columns>
	                    </dw:List>
                        <dw:Infobar ID="SaveNotification" DisplayType="Warning" Message="Save the flow" Visible="false" runat="server"></dw:Infobar>
                        <div class="steps-add-container">
                            <button class="btn btn-flat footer-btn" onclick="currentPage.showCreateFlowStepDialog();" type="button">
                                <i class="fa fa-plus-square color-success"></i>
                                <dw:TranslateLabel runat="server" Text="Add new step" />
                            </button>
                        </div>
                    </div>
                </div>
            </dwc:GroupBox>

            <dw:Dialog runat="server" ID="CreateFlowStepDialog" Size="Medium" Title="Create flow step" ShowCancelButton="true" ShowOkButton="true" OkAction="currentPage.createFlowStep();">
                <dw:GroupBox runat="server">
                    <asp:Literal runat="server" ID="EmailSelectorPlaceHolder" />
                    <dwc:SelectPicker runat="server" ID="CreateFlowStepDelayValue" Label="Delay" />
                    <dwc:SelectPicker runat="server" ID="CreateFlowStepDelayUnit" Label="&nbsp;" />
                </dw:GroupBox>
            </dw:Dialog>

            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="save" style="display: none" />
            <input type="hidden" id="submitParam" name="SubmitParam" />
            <input type="hidden" id="Close" name="Close" />
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
