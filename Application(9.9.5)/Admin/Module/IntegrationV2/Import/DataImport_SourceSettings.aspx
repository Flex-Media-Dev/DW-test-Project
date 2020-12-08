<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DataImport_SourceSettings.aspx.vb" Inherits="Dynamicweb.Admin.DataImportSourceSettings" %>

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
            <dw:GenericResource Url="/Admin/Module/IntegrationV2/js/SelectSource.js" />
        </Items>
    </dw:ControlResources>

    <style>
        .add-button-container {
            text-align: center;
        }
            .add-button-container button {
                width:100%;
            }
        #SourceTableGroupbox {
            margin-bottom: 0px;
        }
        .list table.main {
            height: 100%;
        }
        .list td.container {
            height: 100%;
        }
        .list #ListTableContainer {
            height: 100%;
        }
        .list .container table.table {
            max-height: 100%;
            margin-bottom: 0px;
        }
        .addInConfigurationTable > .form-group > div.filemanager > div.form-group-input {
            width: calc(100% - 31px) !important;
        }
        .addInConfigurationTable > .form-group > div.input-group > div.form-group-input {
            width: calc(100% - 31px) !important;
        }
        .source-settings {
            border-right: 1px solid #e0e0e0;
        }
        #ListTable {
            border-left: none;
        }
        .list .listRow td * {
            display:inline;
        }
    </style>

    <script type="text/javascript">
        function createOption(selectEl, text, val) {
            const opt = document.createElement("option");
            opt.innerHTML = text;
            opt.setAttribute("value", val);
            selectEl.append(opt);
            return opt;
        }

        function initPage(options) {
            console.log(arguments);
            var sourceTableSelectorEl = document.getElementById("SourceTableSelector");
            if (sourceTableSelectorEl) {
                var importKeySelectorEl = document.getElementById("ImportKeySelector");
                sourceTableSelectorEl.addEventListener("change", (e) => {
                    importKeySelectorEl.innerHTML = "";
                    createOption(importKeySelectorEl, options.labels.optionNothingSelected, "");
                    var columns = options.allColumns[sourceTableSelectorEl.value]
                    if (columns) {
                        for (var i = 0; i < columns.length; i++) {
                            createOption(importKeySelectorEl, columns[i], columns[i]);
                        }
                    }
                });
            }
        }

        function nextStep() {
            var selector = document.getElementById("SourceTableSelector");
            if (selector && !selector.value) {
                dwGlobal.showControlErrors("SourceTableSelector", "<%=Translate.Translate("Please select source")%>");
            } else {
                Action.showCurrentDialogLoader();
                document.ContentContainer.action = "/Admin/Module/IntegrationV2/Import/DataImport_SetMapping.aspx";
                if (selector.disabled) {
                    document.ContentContainer.action += "?SourceTableSelector=" + selector.value;
                }
                Action.Execute({
                    'Name': 'Submit'
                });
            }
        }

        function previousStep() {
            Action.showCurrentDialogLoader();
            document.ContentContainer.action = "/Admin/Module/IntegrationV2/Import/DataImport_SelectSource.aspx";
            Action.Execute({
                'Name': 'Submit'
            });
        }

        function parametersLoadedCallback() {
            document.getElementById('NextStepButton').disabled = false;
        }

        function showPreview() {
            var selector = document.getElementById("SourceTableSelector");
            if (selector && selector.options.length > 1 && !selector.value) {
                dwGlobal.showControlErrors("SourceTableSelector", "<%=Translate.Translate("Please select source")%>");
            } else {
                Action.showCurrentDialogLoader();
                document.getElementById("PreviewImport").value = true;
                Action.Execute({
                    'Name': 'Submit'
                });
            }
        }
    </script>
</head>
<dwc:DialogLayout runat="server" ID="SourceSettingsDialog" Title="Source" Size="Large" HidePadding="True">
    <content>
        <div class="col-md-5 source-settings">
            <asp:Literal ID="sourceSelectorScripts" runat="server"></asp:Literal>
            <de:AddInSelector ID="sourceSelector" runat="server" ShowOnlySelectedGroup="true" AddInGroupName="Source" UseLabelAsName="True" AddInShowNothingSelected="false" AddInTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.ISource" AddInShowFieldset="true" AddInIgnoreTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.INotSource" AddInDisableSelector="True" AfterUpdateSelection="parametersLoadedCallback()" />
            <asp:Literal ID="sourceSelectorLoadScript" runat="server"></asp:Literal>
            <dwc:GroupBox runat="server" ID="SourceTableGroupbox">
                <dwc:SelectPicker runat="server" ID="SourceTableSelector" Name ="SourceTableSelector" Label="Table/sheet" ValidationMessage="" ClientIdMode="Static"></dwc:SelectPicker>
                <dwc:SelectPicker runat="server" ID="ImportKeySelector" Name ="ImportKeySelector" Label="Import key" ValidationMessage="" ClientIdMode="Static"></dwc:SelectPicker>
            </dwc:GroupBox>
            <div class="add-button-container">
                <dwc:Button runat="server" id="PreviewButton" Name="PreviewImport" onclick="showPreview()" Value="True" Title="Apply settings to preview"></dwc:Button>
            </div>
        </div>
        <div class="col-md-7">
            <dw:list runat="server" ID="PreviewList" ShowTitle="false" PageSize="15"></dw:list>
        </div>
        <input type="hidden" name="GroupId" value="<%=Request("GroupId")%>" />
        <input type="hidden" name="ImportDataType" value="<%=Request("ImportDataType")%>" />
        <input type="hidden" name="SourceFile" value="<%=SourceFile%>" />
        <input type="hidden" name="ActivityConfiguration" value="<%=ActivityConfiguration%>" />
        <input type="hidden" name="PreviewImport" id="PreviewImport" value="<%=Request("PreviewImport")%>" />
    </content>
    <footer>
        <button class="btn btn-link waves-effect" type="button" onclick="previousStep();">Previous</button>
        <button class="btn btn-link waves-effect" id="NextStepButton" disabled="disabled" type="button" onclick="nextStep();">Next</button>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'});">Cancel</button>
    </footer>
</dwc:DialogLayout>
</html>
