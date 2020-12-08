<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DataImport_SelectSource.aspx.vb" Inherits="Dynamicweb.Admin.DataImportSelectSource" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludejQuery="true" IncludeScriptaculous="true" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
        </Items>
    </dw:ControlResources>  
    
    <style>
        #SourceTableGroupbox {
            margin-bottom: 0px;
        }
    </style>
    
    <script type="text/javascript">      
        function sourceFileTypeChanged(selector) {
            document.getElementById("ConfigurationContainer").style.display = selector.value == "ExcelOld" ? "none" : "";
        }

        function nextStep() {
            if (!document.getElementById("FM_SourceFile").value) {
                var action = <%=GetConfirmMessageAction("Please select source file").ToJson()%>;
                Action.Execute(action);
            } else {
                Action.showCurrentDialogLoader();
                var fileTypeSelector = document.getElementById("SourceFileTypeSelector");
                if (fileTypeSelector && fileTypeSelector.value) {
                    if (fileTypeSelector.value == "ExcelOld") {
                        document.ContentContainer.action = "/Admin/Module/eCom_Catalog/dw7/PIM/PimImportFromExcel.aspx"
                    } else {
                        document.ContentContainer.action = "/Admin/Module/IntegrationV2/Import/DataImport_SourceSettings.aspx"
                    }
                }
                Action.Execute({
                    'Name': 'Submit'                
                });
            }
        }
    </script>  
</head>
<dwc:DialogLayout runat="server" ID="ImportDialog" Title="Data import" Size="Large" HidePadding="True">
    <content>
        <div class="col-md-0">
            <dwc:GroupBox runat="server" ID="SourceTableGroupbox" title="Settings">
                <div id="FileSelectorContainer" runat="server">
                    <dw:FileManager runat="server" ID="SourceFile" Label="Source file" AllowBrowse="true" Folder="/Files/" FullPath="true" />
                </div>
                <div id="SourceFileTypeContainer" runat="server">
                    <dwc:SelectPicker runat="server" ID="SourceFileTypeSelector" Name="SourceFileTypeSelector" Label="Source file type" clientidmode="static" />                
                    <div id="ConfigurationContainer" runat="server">
                        <dwc:SelectPicker runat="server" ID="ActivityConfiguration" Name ="ActivityConfiguration" Label="Import configuration" clientidmode="static"></dwc:SelectPicker>
                    </div>
                </div>
            </dwc:GroupBox>
            <input type="hidden" name="GroupId" value="<%=Request("GroupId")%>" />
            <input type="hidden" name="ImportDataType" value="<%=Request("ImportDataType")%>" />
        </div>
    </content>
    <footer>
        <button runat="server" type="button" id="PreviousStepButton">Previous</button>
        <button class="btn btn-link waves-effect" type="button" onclick="nextStep();">Next</button>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'});">Cancel</button>
    </footer>
</dwc:DialogLayout>
</html>
