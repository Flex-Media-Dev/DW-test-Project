<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AddAdapter.aspx.vb" Inherits="Dynamicweb.Admin.AddAdapter" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" IncludePrototype="false" IncludejQuery="true">
    </dw:ControlResources>
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>    
    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <script type="text/javascript">
        function hideDialog() {
            if (parent != null) {
                if (parent.dialog != null) {
                    parent.dialog.hide('AddAdapterDialog');
                } else if (parent.window != null && parent.window.dialog != null) {
                    parent.window.dialog.hide('AddAdapterDialog');
                }
                if (parent.stopConfirmation != null) {
                    parent.stopConfirmation();
                }
                if (parent.showWait != null) {
                    parent.showWait();
                }
                parent.window.location = parent.window.location;                
            }
        }

        function isValid() {
            var result = true;
            dwGlobal.hideAllControlsErrors(null, "");
            var taskNameEl = $("#adapterName");
            if (!taskNameEl.val()) {
                dwGlobal.showControlErrors("adapterName", "<%=Translate.JsTranslate("Adapter name can not be empty")%>");
                result = false;
            }
            return result;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dwc:GroupBox runat="server">
            <dw:Infobar ID="errorBar" runat="server" Visible="false" Type="Error"></dw:Infobar>
            <dwc:InputText ID="adapterName" runat="server" Label="Adapter name" ValidationMessage=""></dwc:InputText>
            <asp:Literal ID="adapterScripts" runat="server"></asp:Literal>
            <de:AddInSelector ID="adapterSelector" runat="server" UseLabelAsName="True" AddInShowNothingSelected="false"
                AddInTypeName="Dynamicweb.DataIntegration.Integration.Adapters.AdapterBase" />
            <asp:Literal ID="adapterSelectorLoadScript" runat="server"></asp:Literal>
        </dwc:GroupBox>
        <asp:HiddenField runat="server" ID="adapterId" />
    </form>
</body>
</html>
