<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomRounding_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.RoundingEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js"></script>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript">
        strHelpTopic = 'ecom.controlpanel.rounding.edit';

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('Name').focus();
        });

        function testRounding() {
            var amount = document.getElementById("TestAmount");
            if (amount && amount.value != "") {
                
                var button = document.getElementById("roundButton");
                if (button) {
                    button.disabled = true;
                }
                getRoundingResult("<%=roundId%>", amount.value);
            } else {
                alert('<%=Translate.JsTranslate("Værdi skal et valid tal!")%>');
		    }
        }
            
        function save(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }
    </script>

    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
</head>

<body class="area-pink screen-container">

    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <dwc:InputText runat="server" ID="Name" ClientIDMode="Static" Label="Navn" />
                <dwc:SelectPicker runat="server" ID="Method" Label="Metode"></dwc:SelectPicker>
                <div class="form-group">
                    <strong><%=Translate.Translate("Heltal")%></strong>
                </div>
                <dwc:InputNumber runat="server" ID="ModIntegerPart" Min="0" Label="Faktor" />
                <dwc:InputNumber runat="server" ID="ModIntegerCorrection" Label="Tillæg" />
                <div class="form-group">
                    <strong><%=Translate.Translate("Decimaltal")%></strong>
                </div>
                <dwc:InputNumber runat="server" ID="ModDecimalPart" Min="0" Label="Faktor" />
                <dwc:InputNumber runat="server" ID="ModDecimalCorrection" Label="Tillæg" />
                <dwc:InputNumber runat="server" ID="Decimals" Min="0" Max="10" Label="Antal decimaler" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Test afrundingsmetode" ID="TestRoundingGroup" Visible="false">
                <div class="form-group">
                    <label class="control-label" for="TestAmount">
                        <%=Translate.Translate("Beløb") %>
                    </label>
                    <div class="input-group">
                        <div class="form-group-input" style="max-width: 120px;">
                            <input type="number" runat="server" class="std" name="TestAmount" id="TestAmount" value="0" step="0.01">
                        </div>
                        <span class="input-group-addon" onclick="testRounding();">
                            <i class="fa fa-play"></i>
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label">
                        <%=Translate.Translate("Resultat") %>
                    </label>
                    <div class="form-group-input">
                        <input type="text" class="std" disabled name="TestResult" id="TestResult" style="max-width: 120px;" />
                    </div>
                </div>
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none;" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server"></asp:Button>
        </form>
    </div>
</body>
</html>