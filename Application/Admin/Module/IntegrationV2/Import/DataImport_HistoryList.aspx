<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DataImport_HistoryList.aspx.vb" Inherits="Dynamicweb.Admin.DataImportHistoryList" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="uc" TagName="UCHistoryList" Src="~/Admin/Module/IntegrationV2/UCHistoryList.ascx" %>

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
            <dw:GenericResource Url="/Admin/Resources/js/DwSimple.min.js" />
        </Items>
    </dw:ControlResources>      

    <script type="text/javascript">                 
        function previousStep() {
            Action.showCurrentDialogLoader();
            window.history.back();            
        }  
    </script>
</head>
<dwc:DialogLayout runat="server" ID="SourceSettingsDialog" Title="Source" Size="Large" HidePadding="True">
    <content>
        <div class="col-md-0">
            <uc:UCHistoryList runat="server" ID="HistoryListPlain" />  
            <input type="hidden" name="SourceFile" value="<%=Request("SourceFile")%>" />
            <input type="hidden" name="ActivityConfiguration" value="<%=Request("ActivityConfiguration")%>" />
            <input type="hidden" name="PreviewImport" id="PreviewImport" value="<%=Request("PreviewImport")%>" />
        </div>
    </content>
    <footer>
        <button class="btn btn-link waves-effect" type="button" onclick="previousStep();">Reconfigure</button>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.showCurrentDialogLoader();<%=New Dynamicweb.Management.Actions.ModalAction("Cancelled").ToString()%>">Finish</button>
    </footer>
</dwc:DialogLayout>
</html>
