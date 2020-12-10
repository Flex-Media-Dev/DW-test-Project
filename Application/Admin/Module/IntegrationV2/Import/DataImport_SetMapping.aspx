<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DataImport_SetMapping.aspx.vb" Inherits="Dynamicweb.Admin.DataImportSetMapping" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeScriptaculous="true" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Module/IntegrationV2/js/DoMapping.js" />
            <dw:GenericResource Url="/Admin/Images/Controls/UserSelector/UserSelector.js" />
        </Items>
    </dw:ControlResources>  
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/DoMapping.css" type="text/css" />
    <style>
        .input-group-addon.border-left.disabled {
            border-left: 1px #bdbdbd solid;
        }
        .input-group-addon.disabled+.input-group-addon.disabled {
            border-left: 1px #bdbdbd solid;
        }
        .input-group-addon{
            padding: 0px;
        }
        #screenLoaderOverlay {
            z-index: 1001;
        }
        #DW_Dialog_ModalOverlay {            
            z-index: 999;
        }
        #AdvancedSettingsDialog fieldset div  {
            text-transform: none !important;
        }
    </style>
    
    <script type="text/javascript">  
        var renamedConfigurations = {};
        var deletedConfigurations = [];

        function saveActivity() {
            document.getElementById("action").value = "save";
            dialog.show("ActivityNameDialog");
        }      
        
        function runActivity() {
            document.getElementById("action").value = "run";
            document.getElementById("ActivityName").value = '<%=TempActivityName%>';
            var action = <%=GetConfirmMessageAction().ToJson()%>;
            var activityConfigurationNameHidden = document.getElementById('ActivityConfigurationName');
            if (activityConfigurationNameHidden && activityConfigurationNameHidden.value) {
                var activityNamePlaceholder = '<%=ActivityNamePlaceholder%>';
                var activityName = renamedConfigurations[document.getElementById('ActivityConfiguration').value] || activityConfigurationNameHidden.value;
                action.Url = action.Url.replace(activityNamePlaceholder, encodeURIComponent(activityName));
            }
            appendConfigurationChangesHiddens();
            Action.Execute(action);
        }  

        function submitForm() {
            new overlay('screenLoaderOverlay').show();
            var activityNameInput = document.getElementById("ActivityName");
            if (validateConfigurationName(activityNameInput)) {
                appendConfigurationChangesHiddens();
                stopConfirmation();
                executeSubmitAction();
            } else {
                new overlay('screenLoaderOverlay').hide();
            }
        }

        function appendConfigurationChangesHiddens() {
            var deletedHidden = document.getElementById("DeletedConfigurations");
            if (deletedHidden) {
                document.getElementById("DeletedConfigurations").remove();
            }
            if (deletedConfigurations.length) {
                for (var i = 0; i < deletedConfigurations.length; i++) {
                    var deletedConfiguration = deletedConfigurations[i];
                    if (renamedConfigurations[deletedConfiguration]) {
                        delete renamedConfigurations[deletedConfiguration];
                    }
                    document.forms[0].appendChild(createInput("hidden", "DeletedConfigurations", "DeletedConfigurations", "|" + deletedConfiguration + "|"));
                }
            }
            var renameHidden = document.getElementById("RenamedConfigurations");
            if (renameHidden) {
                document.getElementById("RenamedConfigurations").remove();
            }
            if (renamedConfigurations) {
                for (var key in renamedConfigurations) {
                    var renamedConfiguration = key;
                    var newName = renamedConfigurations[key];
                    document.forms[0].appendChild(createInput("hidden", "RenamedConfigurations", "RenamedConfigurations", "|" + renamedConfiguration + "::" + newName + "|"));
                }
            }
        } 

        function executeSubmitAction(url) {
            document.ContentContainer.setAttribute("action", url || "");
            document.ContentContainer.target = "";
            Action.Execute({
                'Name': 'Submit'
            });
        } 

        function validateConfigurationName(activityNameInput) {
            if (!activityNameInput.value) {
                dwGlobal.showControlErrors(activityNameInput, "<%=Translate.Translate("Please enter the name")%>");
                activityNameInput.focus();
                return false;
            } else if (!/^[a-zA-Z0-9\u00c0-\u017e\-_()]+([a-zA-Z0-9\u00c0-\u017e\-_() ]*)$/.test(activityNameInput.value)) {
                dwGlobal.showControlErrors(activityNameInput, "<%=Translate.Translate("Name contains invalid characters")%>");
                activityNameInput.focus();
                return false;
            }
            return true;
        } 
        
        function addScriptToColumn() {
            //stopConfirmation();
            var mappingId = document.getElementById("currentMapping").value;
            var columnMappingId = document.getElementById("currentColumnMapping").value;
            var container = document.getElementById("mapping" + mappingId + "columnMapping" + columnMappingId + "div");
            storeScriptingData(mappingId, columnMappingId, container, document.getElementById("scriptValue").value, document.getElementById("scriptType").value, document.getElementById("checkScriptValueForInsert").checked);
            dialog.hide("editScripting");
        }

        function storeScriptingData(mappingId, columnMappingId, container, scriptValue, scriptType, checkScriptValueForInsert) {
            setScriptHidden("scriptValue"+ columnMappingId, container, scriptValue);
            setScriptHidden("scriptType"+ columnMappingId, container, scriptType);
            setScriptHidden("checkScriptValueForInsert" + columnMappingId, container, checkScriptValueForInsert);
            updateScriptingState(mappingId, columnMappingId, scriptType);
        }

        function scriptingValuesUpdate(scriptingValuesObj) {
            var columnMappingId = scriptingValuesObj.columnMappingId;
            var scriptValueEl = document.getElementById("scriptValue" + columnMappingId);
            if (scriptValueEl) {
                scriptingValuesObj.scriptingValue = scriptValueEl.value;
            }
            var scriptTypeEl = document.getElementById("scriptType" + columnMappingId);
            if (scriptTypeEl) {
                scriptingValuesObj.scriptingType = scriptTypeEl.value;
            }
            var checkScriptValueForInsertEl = document.getElementById("checkScriptValueForInsert" + columnMappingId);
            if (checkScriptValueForInsertEl) {
                scriptingValuesObj.scriptingValueForInsert = checkScriptValueForInsertEl.value;
            }
        }
        
        function setScriptHidden(scriptValueHiddenId, container, value) {
            var scriptValueHidden = document.getElementById(scriptValueHiddenId);
            if (!scriptValueHidden) {
                scriptValueHidden = createInput("hidden", scriptValueHiddenId, scriptValueHiddenId);
                container.appendChild(scriptValueHidden);
            }
            scriptValueHidden.value = value;
        }
            
        function previousStep() {
            document.ContentContainer.action = "/Admin/Module/IntegrationV2/Import/DataImport_SourceSettings.aspx"
            document.ContentContainer.target = "";
            Action.Execute({
                'Name': 'Submit'
            });
        }

        function openAdvancedSettings() {
            stopConfirmation();
            appendConfigurationChangesHiddens();
            getAdvancedSettingsOkButton().disabled = true;
            document.ContentContainer.setAttribute("action", "DataImport_AdvancedSettings.aspx");
            document.ContentContainer.target = "AdvancedSettingsDialogFrame";
            document.ContentContainer.submit();
            dialog.showLoader("AdvancedSettingsDialog");
            document.getElementById("AdvancedSettingsDialogFrame").onload = () => {
                var frameWindow = document.getElementById("AdvancedSettingsDialogFrame").contentWindow;
                frameWindow.renamedConfigurations = renamedConfigurations;
                frameWindow.deletedConfigurations = deletedConfigurations; 
                dialog.hideLoader("AdvancedSettingsDialog");
                if (frameWindow.removeUnloadEvent && typeof frameWindow.removeUnloadEvent === 'function') {
                    frameWindow.removeUnloadEvent();
                }
            };
            dialog.show("AdvancedSettingsDialog");
        }

        function rememberAdvancedSettings() {
            var frame = document.getElementById("AdvancedSettingsDialogFrame");
            var frameWindow = frame.contentWindow;
            renamedConfigurations = frameWindow.renamedConfigurations;
            deletedConfigurations = frameWindow.deletedConfigurations;
            var parametersContainer = document.getElementById("div_Dynamicweb.DataIntegration.Integration.Interfaces.IDestination_parameters").parentElement;
            parametersContainer.innerHTML = '';
            parametersContainer.appendChild(frameWindow.document.getElementById("div_Dynamicweb.DataIntegration.Integration.Interfaces.IDestination_parameters"));
            dialog.hide("AdvancedSettingsDialog");              
        }

        function destinationParametersLoadedCallback() {
            document.getElementById('AdvancedButton').disabled = false;
        }
        
        function getAdvancedSettingsOkButton() {
            return document.getElementById('AdvancedSettingsDialog').querySelector(".cmd-pane>.dialog-button-ok");
        }

        function advancedSettingsParametersLoadedCallback() {
            getAdvancedSettingsOkButton().disabled = false;
        }        

        let originalDoPostBackFunction = Dynamicweb.Ajax.doPostBack;
        Dynamicweb.Ajax.doPostBack = function (params) {
            params.explicitMode = false;
            originalDoPostBackFunction(params);
        }
    </script>  
</head>
<dwc:DialogLayout runat="server" ID="ImportDialog" Title="Activity mapping" Size="Large" HidePadding="True">
    <content>        
    <dw:Overlay ID="screenLoaderOverlay" runat="server"></dw:Overlay>
    <dw:Overlay ID="DW_Dialog_ModalOverlay" runat="server" ShowWaitAnimation="false"></dw:Overlay>        
        <div class="col-md-0">
            <div class="hidden" runat="server" id="AddinSelectorContainer">
                <asp:HiddenField ID="SelectedAddin" runat="server" />
                <asp:HiddenField ID="AddinConfiguration" runat="server" />
                <asp:Literal ID="sourceSelectorScripts" runat="server"></asp:Literal>
                <de:AddInSelector ID="sourceSelector" runat="server" ShowOnlySelectedGroup="true" AddInGroupName="Source" UseLabelAsName="True" AddInShowNothingSelected="false" AddInTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.ISource" AddInShowFieldset="true" AddInIgnoreTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.INotSource" />
                <asp:Literal ID="sourceSelectorLoadScript" runat="server"></asp:Literal>                      
            </div>
            <div class="hidden">                 
                <dwc:GroupBox runat="server" Title="Destination" Expandable="true">
                    <de:AddInSelector ID="DestinationSelector" runat="server" ShowOnlySelectedGroup="true" AddInGroupName="Destination" UseLabelAsName="True" AddInShowNothingSelected="false" AddInTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.IDestination" AddInShowSelector="false" AddInShowFieldset="false" AfterUpdateSelection="destinationParametersLoadedCallback()" />
                    <asp:Literal ID="DestinationSelectorLoadScript" runat="server"></asp:Literal>
                </dwc:GroupBox>  
                <div id="jobContainerDiv" runat="server"></div>
                <input type="hidden" name="action" id="action" value="" />
                <input type="hidden" name="currentMapping" id="currentMapping" value="" />
                <input type="hidden" name="currentColumnMapping" id="currentColumnMapping" value="" />
                <input type="hidden" name="activeMapping" id="activeMapping" runat="server" />
                <input type="hidden" name="activeMappingID" id="activeMappingID" runat="server" />
            </div>
            <dwc:GroupBox runat="server" id="ImportErrors" Visible="False" Title="Errors List" Expandable="true">
                <dw:Infobar ID="MappingErrorInfo" TranslateMessage="true" Message="Mapping errors should be fixed manually." runat="server" />
                <dw:List ID="ErrorList" runat="server" ShowTitle="false" PageSize="50" ShowPaging="true">
                    <Columns>
                        <dw:ListColumn ID="Source" EnableSorting="false" runat="server" Name="Source" Width="30"></dw:ListColumn>
                        <dw:ListColumn ID="ErrorType" EnableSorting="true" runat="server" Name="Error Type" Width="30"></dw:ListColumn>
                        <dw:ListColumn ID="Tables" runat="server" Name="Tables/Columns"></dw:ListColumn>
                    </Columns>
                </dw:List>
            </dwc:GroupBox>
            <dw:Infobar ID="MappingImportKeyErrorInfo" TranslateMessage="false" Message="" runat="server" Visible="false" />
            <div id="MappingsContainer" runat="server">
                <dwc:GroupBox runat="server" ID="testNameDivSizeLimiter" Title="Data column mapping">
                    <div style="width: 100%; padding-bottom: 3px;">
                        <div class="checkAllDiv">
                            <input type="checkbox" id="checkAllCheckbox" onclick="toggleActiveSelection()" class="checkbox" />
                            <label for="checkAllCheckbox"></label>
                        </div>
                        <div class="SourceHeading">
                            Source column
                        </div>
                        <div class="DestinationHeading">
                            Destination column
                        </div>
                    </div>
                    <div class="clearfix"></div>
                    <div class="data-column-mapings-container">
                        <div id="testName" runat="server"></div>
                        <div class="data-column-mapings-commands">
                            <button class="btn btn-flat footer-btn" onclick="currentPage.addNewMappingRow();" type="button">
                                <i class="fa fa-plus-square color-success"></i>
                                <dw:TranslateLabel runat="server" Text="Add new mapping row" />
                            </button>
                        </div>
                    </div>
                </dwc:GroupBox>
            </div>
        </div>
        <input type="hidden" name="GroupId" value="<%=Request("GroupId")%>" />
        <input type="hidden" name="ImportDataType" value="<%=Request("ImportDataType")%>" />
        <input type="hidden" name="SourceFile" value="<%=Request("SourceFile")%>" />
        <input type="hidden" name="ActivityConfiguration" id="ActivityConfiguration" value="<%=SelectedActivityConfiguration%>" />   
        <input type="hidden" id="ActivityConfigurationName" value="<%=GetActivityName(String.Empty)%>" />   
        <input type="hidden" name="PreviewImport" id="PreviewImport" value="<%=Request("PreviewImport")%>" />
        <input type="hidden" name="SourceTableSelector" value="<%=Request("SourceTableSelector")%>" />
        <dw:Dialog runat="server" ID="editScripting" ShowOkButton="true" ShowCancelButton="true" Size="Medium" Title="Scripting" OkAction="addScriptToColumn();">
            <select runat="server" id="scriptType" class="std" name="scriptType" onchange="toggleScriptTypeSelection()">
                <option value="none">None</option>
                <option value="append">Append</option>
                <option value="prepend">Prepend</option>
                <option value="constant">Constant</option>
            </select>
            <input type="text" id="scriptValue" class="std" name="scriptValue" />                
            <div class="form-group" id="checkScriptValueForInsertDiv" runat="server">
                <br />
                <input id="checkScriptValueForInsert" name="checkScriptValueForInsert" class="checkbox" type="checkbox">
                <label for="checkScriptValueForInsert"><dw:TranslateLabel runat="server" Text="Apply on create only" /></label>
            </div>
        </dw:Dialog>
        <dw:Dialog runat="server" ID="ActivityNameDialog" ShowOkButton="true" ShowCancelButton="true" Size="Medium" Title="Activity name" OkAction="submitForm();">
            <dwc:InputText runat="server" ID="ActivityName" Label="Name" ValidationMessage=""></dwc:InputText>
        </dw:Dialog>
        <dw:Dialog runat="server" ID="AdvancedSettingsDialog" ShowOkButton="true" ShowCancelButton="true" Size="Medium" Title="Advanced settings" OkAction="rememberAdvancedSettings();" HidePadding="true">            
            <iframe name="AdvancedSettingsDialogFrame" id="AdvancedSettingsDialogFrame" src="DataImport_AdvancedSettings.aspx" style="overflow: hidden; height: 100%;"></iframe>
        </dw:Dialog>
    </content>
    <footer>
        <button class="btn btn-link waves-effect" type="button" onclick="previousStep();">Previous</button>
        <button class="btn btn-link waves-effect" id="AdvancedButton" disabled="disabled" type="button" onclick="openAdvancedSettings();">Advanced</button>
        <button class="btn btn-link waves-effect" type="button" onclick="saveActivity();">Save</button>
        <button class="btn btn-link waves-effect" type="button" onclick="runActivity();">Run</button>
        <button class="btn btn-link waves-effect" type="button" onclick="stopConfirmation();Action.Execute({'Name':'Cancel'});">Cancel</button>
    </footer>
</dwc:DialogLayout>
</html>
