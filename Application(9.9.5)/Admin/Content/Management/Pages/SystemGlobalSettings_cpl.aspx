<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SystemGlobalSettings_cpl.aspx.vb" Inherits="Dynamicweb.Admin.SystemGlobalSettings_cpl" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <dwc:ScriptLib runat="server" ID="ScriptLib1">    
        <script src="../../../Images/Ribbon/UI/WaterMark.js"></script>
        <script src="../../../Images/Ribbon/UI/List/List.js"></script>
        <script src="../../../Images/Ribbon/UI/Dialog/Dialog.js"></script>
    </dwc:ScriptLib>
    <script type="text/javascript">
        function editSetting(path, value) {
            $('SettingPath').value = path;
            $('SettingValue').value = value;
            $('EditSettingDialog').select('.gbTitle')[0].textContent = path;
            dialog.show("EditSettingDialog");
        }

        function saveSetting() {
            $('cmd').value = "save";
            $('MainForm').submit();
        }
    </script>
    <style>
        .row {
            margin-left: -10px;
            margin-right: -10px;
        }
    </style>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Global settings"></dwc:CardHeader>
            <dwc:CardBody runat="server">               
                <form id="MainForm" runat="server">
                    <input type="hidden" id="cmd" name="cmd" />
                    <dw:List Title="Global settings" ID="GlobalsettingsList" runat="server" ShowTitle="false" >
                        <Columns>
                            <dw:ListColumn Name="Path" runat="server" />
                            <dw:ListColumn Name="Value" runat="server" />
                        </Columns>
                        <Filters>
                            <dw:ListTextFilter runat="server" ID="TextSearch" WaterMarkText="Find" />
                        </Filters>
                    </dw:List>
                    <dw:Dialog runat="server" ID="EditSettingDialog" Title="Edit Global setting" ShowOkButton="true" OkAction="saveSetting();" Size="Medium">
                        <dw:GroupBox Title="Edit setting" runat="server">
                            <input type="hidden" id="SettingPath" name="SettingPath" />
                            <dwc:InputText ID="SettingValue" runat="server" ClientIDMode="Static" Label="Value" />
                        </dw:GroupBox>
                    </dw:Dialog>
                </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>
</body>
</html>