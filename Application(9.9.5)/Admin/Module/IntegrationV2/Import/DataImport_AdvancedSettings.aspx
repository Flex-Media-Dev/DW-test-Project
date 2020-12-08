<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DataImport_AdvancedSettings.aspx.vb" Inherits="Dynamicweb.Admin.DataImportAdvancedSettings" %>

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
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js" />
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
        .col-md-0 fieldset div  {
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

        function openRenameConfigurationDialog(rowId, path, originalName) {
            var name = originalName;
            if (!!renamedConfigurations[path]) {
                name = renamedConfigurations[path];
            }
            document.getElementById("selectedConfiguration").value = path;
            document.getElementById("selectedConfigurationRow").value = rowId;
            document.getElementById("NewConfigurationName").value = name;
            dialog.show("RenameConfigurationDialog");
        }

        function renameConfiguration() {
            var activityNameInput = document.getElementById("NewConfigurationName");
            var selectedConfiguration = document.getElementById("selectedConfiguration");
            var rowId = document.getElementById("selectedConfigurationRow").value;
            if (parent.validateConfigurationName(activityNameInput) && selectedConfiguration.value) {
                renamedConfigurations[selectedConfiguration.value] = activityNameInput.value;
                List.getRowByID("ConfigurationsList", rowId).children[0].innerText = activityNameInput.value;
                dialog.hide("RenameConfigurationDialog");
                selectedConfiguration.value = '';
                activityNameInput.value = '';
            }
        }

        function deleteConfiguration(rowId, path) {
            List.getRowByID("ConfigurationsList", rowId).remove();
            deletedConfigurations.push(path);
        }     
    </script>  
</head>
<body>
    <form id="form1" runat="server">     
        <dw:Overlay ID="screenLoaderOverlay" runat="server"></dw:Overlay>
        <div class="col-md-0">
            <dwc:GroupBox runat="server" ID="ProviderSelectorGroupbox" Expandable="true">
                <de:AddInSelector ID="DestinationSelector" runat="server" ShowOnlySelectedGroup="true" AddInGroupName="Destination" UseLabelAsName="True" AddInShowNothingSelected="false" AddInTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.IDestination" AddInShowSelector="false" AddInShowFieldset="false" AfterUpdateSelection="parent.advancedSettingsParametersLoadedCallback()" />
                <asp:Literal ID="DestinationSelectorLoadScript" runat="server"></asp:Literal>
                <asp:Literal ID="DestinationSelectorScripts" runat="server"></asp:Literal>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Configuration files" Expandable="true">                
                <dw:List runat="server" ID="ConfigurationsList" ShowPaging="false" PageSize="100" ShowTitle="false">
                    <Columns>
                        <dw:ListColumn ID="ListColumn1" runat="server" Name="Name" WidthPercent="95"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn2" runat="server" Name="Rename" Width="30" ItemAlign="Center" HeaderAlign="Center"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn3" runat="server" Name="Delete" Width="30" ItemAlign="Center" HeaderAlign="Center"></dw:ListColumn>
                    </Columns>
                </dw:List>
            </dwc:GroupBox>
        </div>
        <dw:Dialog runat="server" ID="RenameConfigurationDialog" ShowOkButton="true" ShowCancelButton="true" Size="Medium" Title="Rename configuration" OkAction="renameConfiguration();">                        
            <input type="hidden" id="selectedConfiguration" />
            <input type="hidden" id="selectedConfigurationRow" />            
            <dwc:InputText runat="server" ID="NewConfigurationName" Label="Name" ValidationMessage=""></dwc:InputText>
        </dw:Dialog>
    </form>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
