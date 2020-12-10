<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomNumber_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.NumberEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    <script src="/Admin/FileManager/FileManager_browse2.js" type="text/javascript"></script>
    <script type="text/javascript">
        function save(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }
    </script>
</head>
<body class="area-pink screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <dw:Infobar ID="formatWarning" runat="server" Type="Warning" Visible="false">
        </dw:Infobar>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <dwc:InputText runat="server" Label="Navn" ID="type" Disabled="true" />
                <dwc:InputText runat="server" Label="Beskrivelse" ID="description" Disabled="true" />
                <dwc:InputNumber runat="server" Label="Startværdi" ID="counter" Disabled="true" />
                <dwc:InputText runat="server" Label="Præfiks" ID="prefix" />
                <dwc:InputText runat="server" Label="Postfiks" ID="postfix" />
                <dwc:InputNumber runat="server" Label="Tilvækst" ID="add" />
                <asp:Button ID="SaveButton" Style="display: none;" runat="server"></asp:Button>
            </dwc:GroupBox>
        </form>
    </div>
</body>
</html>