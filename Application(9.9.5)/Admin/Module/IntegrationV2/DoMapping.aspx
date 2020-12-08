<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DoMapping.aspx.vb" Inherits="Dynamicweb.Admin.DoMapping" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register Assembly="System.Web.Extensions, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Module/IntegrationV2/js/DoMapping.js" />
        </Items>
    </dw:ControlResources>
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/DoMapping.css" type="text/css" />

    <script type="text/javascript">
        function help() {
    <%=Dynamicweb.SystemTools.Gui.Help("data integration", "modules.dataintegration.edit")%>
        }
    </script>
</head>
<body class="area-black screen-container" onload="enableConfirmation();">
    <dwc:Card runat="server">
        <form id="form1" runat="server">
            <dw:Overlay ID="forward" Message="Please wait" runat="server"></dw:Overlay>

            <input type="hidden" name="action" id="action" value="" />
            <input type="hidden" name="currentMapping" id="currentMapping" value="" />
            <input type="hidden" name="currentColumnMapping" id="currentColumnMapping" value="" />
            <input type="hidden" name="activeMapping" id="activeMapping" runat="server" />
            <input type="hidden" name="activeMappingID" id="activeMappingID" runat="server" />
            <input type="hidden" name="jobName" id="jobName" runat="server" />

            <dwc:CardBody runat="server">
                <dw:RibbonBar runat="server" ID="doMappingBar">
                    <dw:RibbonBarTab runat="server" ID="doMappingBarTab" Name="Activity">
                        <dw:RibbonBarGroup runat="server" ID="doMappingSaveGroup" Name="Tools">
                            <dw:RibbonBarButton runat="server" ID="Save" Size="Small" Icon="Save" Text="Save" OnClientClick="save();" />
                            <dw:RibbonBarButton runat="server" ID="SaveAndClose" Size="Small" Icon="Save" Text="Save and close" OnClientClick="saveAndClose();" />
                            <dw:RibbonBarButton runat="server" ID="Cancel" Size="Small" Icon="TimesCircle" Text="Cancel" OnClientClick="cancel();" ShowWait="true" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" ID="SaveAndRun" Name="Run">
                            <dw:RibbonBarButton runat="server" ID="SaveAndRunButton" Size="Large" Icon="PlayCircleOutline" Text="Save and run" OnClientClick="stopConfirmation();var runIt= confirm('Run activity?');if (runIt){ var o = new overlay('forward');o.show(); SaveAndRun();} else return false;" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" ID="doMappingEditGroup" Name="Mapping">
                            <dw:RibbonBarButton runat="server" ID="addTableMapping" Size="Small" Icon="PlusSquare" Text="Add table mapping" OnClientClick="addTableMapping()" ShowWait="true" />
                            <dw:RibbonBarButton runat="server" ID="addAdapter" Size="Small" Icon="PlusSquare" Text="Add adapter" Visible="false" />
                            <dw:RibbonBarButton runat="server" ID="tableAddColumnMapping" Size="Small" Text="Add column mapping to current table" OnClientClick="tableAddColumnMapping()" Icon="PlusSquare" />
                            <dw:RibbonBarButton runat="server" ID="tableRemoveColumnMapping" Size="Small" Text="Remove unselected column mapping" OnClientClick="tableRemoveColumnMapping()" Icon="Delete" />
                            <dw:RibbonBarButton runat="server" ID="createMappingAtRuntime" Size="Small" Text="Create mappings at runtime" OnClientClick="stopConfirmation();$('action').value='createMappingAtRuntime';$('form1').submit();stopConfirmation();" Icon="SiteMap" />
                            <dw:RibbonBarButton runat="server" ID="sortAdapters" Size="Small" Icon="Sort" Text="Sort adapters" Visible="false" OnClientClick="stopConfirmation();location.href='AdapterSort.aspx';" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" ID="doMappingEditTable" Name="Tables">
                            <dw:RibbonBarButton runat="server" ID="addDestinationTable" Size="Small" Icon="GridOn" Text="Add new destination table" OnClientClick="stopConfirmation();dialog.show('addTableDialog');" ShowWait="false" />
                            <dw:RibbonBarButton runat="server" ID="addColumnToDestinationTable" Size="Small" Text="Add column to current destination table" OnClientClick="addColumnMapping()" Icon="GridOn" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" ID="doMappingEditSourceDestination" Name="Settings">
                            <dw:RibbonBarButton runat="server" ID="editSourceSettings" Size="Small" Icon="Pencil" Text="Edit source settings" OnClientClick="stopConfirmation();showSourceDestinationSettingsDialog('SourceEditDialog', '/Admin/Module/IntegrationV2/editSource.aspx');" />
                            <dw:RibbonBarButton runat="server" ID="editDestinationSettings" Size="Small" Icon="Pencil" Text="Edit destination settings" OnClientClick="stopConfirmation();showSourceDestinationSettingsDialog('DestinationEditDialog','/Admin/Module/IntegrationV2/editDestination.aspx');" />
                            <dw:RibbonBarButton runat="server" ID="editNotificationSettings" Size="Small" Icon="Pencil" Text="Edit notification settings" OnClientClick="stopConfirmation();showSourceDestinationSettingsDialog('NotificationSettingsDialog','/Admin/Module/IntegrationV2/NotificationSettings.aspx');" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" ID="validateSchemaGroup" Name="Settings xml file" Visible="false">
                            <dw:RibbonBarButton runat="server" ID="validateSchema" Size="Large" Text="Check tables schema" Icon="Check" OnClientClick="showErrorsDialog();/*stopConfirmation();$('action').value='checkErrorsInSettingsXmlFile';$('form1').submit();*/" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" ID="activitylog" Name="Log">
                            <dw:RibbonBarButton runat="server" ID="showHistoryLog" Size="Large" Text="Log" Icon="EventNote" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" ID="doMappingHelp" Name="Help">
                            <dw:RibbonBarButton runat="server" ID="help" Size="Large" Icon="Help" Text="Help" OnClientClick="help();" />
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>
                </dw:RibbonBar>
                <div id="breadcrumb" runat="server"></div>
                <dw:Infobar ID="InfoDiv" TranslateMessage="true" Message="This job is set to do mappings automatically at runtime." Title="This job is set to do mappings automatically at runtime." runat="server" />

                <dwc:GroupBox runat="server" Title="Table">
                    <div style="width: 100%; padding-bottom: 3px;">
                        <div class="SourceHeadingTable">
                            Source table
                        </div>
                        <div class="DestinationHeadingTable">
                            Destination table
                        </div>
                    </div>
                    <div class="clearfix"></div>
                    <div id="jobContainerDiv" runat="server"></div>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Adapters" ID="gbAdapters" Visible="false">
                    <dw:List ID="AdaptersList" runat="server" ShowCount="false" ShowTitle="false">
                        <Columns>
                            <dw:ListColumn ID="AdapterName" Name="Name" runat="server" />
                            <dw:ListColumn ID="AdapterType" Name="Type" runat="server" />
                            <dw:ListColumn ID="AdapterDescription" Name="Description" runat="server" />                            
                            <dw:ListColumn ID="Status" Name="Status" runat="server" />
                            <dw:ListColumn ID="Delete" Name="Delete" runat="server" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>

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
                    <div id="testName" runat="server"></div>
                </dwc:GroupBox>
            </dwc:CardBody>

            <dw:Dialog runat="server" ID="addTableDialog" ShowOkButton="true" ShowCancelButton="true" Width="390" Title="New destination table" OkAction="stopConfirmation();$('action').value='createNewDestinationTable';$('form1').submit();">
                <dwc:GroupBox runat="server" Title="Settings">
                    <dwc:InputText Name="newTableName" ID="newTableName" runat="server" Label="Table name" />
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="addColumnDialog" ShowOkButton="true" ShowCancelButton="true" Width="390" Title="New destination column" OkAction="stopConfirmation();$('action').value='createNewDestinationColumn';$('form1').submit();">
                <dwc:GroupBox runat="server" Title="Settings">
                    <dwc:InputText Name="newColumnName" ID="newColumnName" runat="server" Label="Column name" />
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="editScripting" ShowOkButton="true" ShowCancelButton="true" Size="Medium" Title="Scripting" OkAction="stopConfirmation();$('action').value='editScripting';$('form1').submit();">
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

            <dw:Dialog runat="server" ID="editConditionals" ShowOkButton="true" ShowCancelButton="true" Title="Edit conditionals" Size="Medium" OkAction="stopConfirmation();collectNewConditionsRows();$('action').value='editConditionals';$('form1').submit();">
                <div id="editConditionalsDiv"></div>
                <div class="text-center">
                    <input type="hidden" id="new-conditions" name="new-conditions" value="" />
                    <button type="button" class="btn btn-flat" onclick="newConditionRow()"><i class="fa fa-plus-square color-success"></i> Add new condition</button>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="selectKeys" ShowOkButton="true" ShowCancelButton="true" Title="Select key columns" Size="Medium" OkAction="stopConfirmation();$('action').value='setKeyColumn';$('form1').submit();">
                <div id="selectKeyColumns"></div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="editDestinationSettingsDialog" ShowOkButton="true" ShowCancelButton="true" Title="Edit source settings" Width="600">
            </dw:Dialog>

            <dw:Dialog runat="server" ID="showErrorsDlg" Width="600" ShowClose="false" ShowOkButton="true" ShowCancelButton="true" Title="Errors found in job settings xml file" OkAction="stopConfirmation();$('action').value='fixErrorsInSettingsXmlFile';$('form1').submit();">
                <dw:List ID="errorList" runat="server" Title="Errors List" TranslateTitle="True" StretchContent="false" PageSize="25" ShowPaging="true" Height="400">
                    <Columns>
                        <dw:ListColumn ID="Source" EnableSorting="false" runat="server" Name="Source" Width="30"></dw:ListColumn>
                        <dw:ListColumn ID="ErrorType" EnableSorting="true" runat="server" Name="Error Type" Width="30"></dw:ListColumn>
                        <dw:ListColumn ID="Tables" runat="server" Name="Tables/Columns"></dw:ListColumn>
                    </Columns>
                </dw:List>
                <dw:TranslateLabel ID="lblMappingErrorText" Text="Mapping errors should be fixed manually." runat="server" />
                <br />
                <dw:TranslateLabel ID="lblConfirmText" Text="Click OK to update the schema for source and destination" runat="server" />
            </dw:Dialog>

            <dw:Dialog runat="server" ID="editTableScripting" ShowOkButton="true" ShowCancelButton="true" Title="Select table scripting" OkAction="stopConfirmation();$('action').value='editTableScripting';$('form1').submit();">
                <div id="editTableScriptingDiv"></div>
            </dw:Dialog>

            <dw:Dialog ID="HistoryLogDialog" runat="server" Title="Job log" HidePadding="true" Size="Large" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
                <iframe id="HistoryLogDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="SourceEditDialog" runat="server" Title="Edit source settings" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
                <iframe id="SourceEditDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="DestinationEditDialog" runat="server" Title="Edit destination settings" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
                <iframe id="DestinationEditDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="NotificationSettingsDialog" runat="server" Title="Edit notification settings" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
                <iframe id="NotificationSettingsDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="SelectOptions" ShowOkButton="true" ShowCancelButton="true" Title="Edit table destination settings" Size="Medium" OkAction="stopConfirmation();$('action').value='editOptions';$('form1').submit();">
                <dw:Infobar ID="OptionsWarningBar" Type="Warning" runat="server" Message="Job mapping options have top priority. Source Xml options will be overwritten"></dw:Infobar>
                <dw:GroupBox runat="server" ID="OptionsProviderTitle" Title="Table">                    
                    <dwc:CheckBox runat="server" ID="RemoveMissingAfterImport" Label="Remove missing rows after import" />
                    <dwc:CheckBox runat="server" ID="UpdateOnlyExistingRecords" Label="Update only existing records" />
                    <dwc:CheckBox runat="server" ID="DeactivateMissingProducts" Label="Deactivate missing products" />
                    <dwc:CheckBox runat="server" ID="DeleteIncomingItems" Label="Delete incoming rows" />
                    <dwc:CheckBox runat="server" ID="DiscardDuplicates" Label="Discard duplicates" />                    
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="AddAdapterDialog" runat="server" Title="Add adapter" Size="Auto" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" OkAction="submitAdapter();" CancelAction="dialog.hide('AddAdapterDialog');" 
                ShowClose="true" OkText="Save and close">
                <iframe id="AddAdapterDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>
        </form>
    </dwc:Card>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
