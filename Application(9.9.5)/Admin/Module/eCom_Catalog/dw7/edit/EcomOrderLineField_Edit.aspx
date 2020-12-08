<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomOrderLineField_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderLineField_Edit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameText').focus();
        });

        function showError(id, text) {
            document.getElementById(id).innerHTML = text;
            document.getElementById(id).style.display = 'block';
        }

        function validateAndSave(close) {
            var success = true;
            var systemName = document.getElementById("SystemNameText").value;
            var name = document.getElementById("NameText").value;
            var length = document.getElementById("LengthText").value;

            var errors = document.getElementsByClassName('help-block error');
            for (var i = 0; i != errors.length; ++i) {
                errors[i].style.display = 'none';
            }

            if (systemName.length > 255) {
                showError('SystemNameError', '<%=Translate.JsTranslate("The system name must be shorter than 256 characters.") %>');
                success = false;
            } else if (!systemName.match(/^[a-zA-Z0-9_]*$/)) {
                showError('SystemNameError', '<%=Translate.JsTranslate("The system name can only contain letters, numbers and underscores.") %>');
                success = false;
            }

            if (name.length > 255) {
                showError('NameError', '<%=Translate.JsTranslate("The name must be shorter than 256 characters.") %>');
                success = false;
            }
            if (name.length == 0) {
                showError('NameError', '<%=Translate.JsTranslate("Please type a name.") %>');
                success = false;
            }

            try {
                var lengthAsInt = parseInt(length);
                if (lengthAsInt <= 0) {
                    showError('LengthError', '<%=Translate.JsTranslate("The length must be positive.") %>');
                    success = false;
                }
            } catch (e) {
                showError('LengthError', '<%=Translate.JsTranslate("The length must be an integer.") %>');
                success = false;
            }
            if (success) {
                saveOrderLineFields(close);
            }
        }

        function saveOrderLineFields(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>

        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <asp:HiddenField runat="server" ID="IsNewOrderLineField" Value="False" />
            <asp:HiddenField runat="server" ID="SaveError" Value="" />
            
            <dwc:GroupBox runat="server" ID="GroupBox" Title="Settings">
                <table class="formsTable">
                    <tr>
                        <td>
                            <label for="NameText">
                                <dw:TranslateLabel runat="server" Text="Name" />
                            </label>
                        </td>
                        <td>
                            <asp:TextBox ID="NameText" CssClass="std" runat="server" />
                            <small class="help-block error" id="NameError"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="SystemNameText">
                                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="System name" />
                            </label>
                        </td>
                        <td>
                            <asp:TextBox ID="SystemNameText" CssClass="std" runat="server" />
                            <small class="help-block error" id="SystemNameError"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="LenghtText">
                                <dw:TranslateLabel runat="server" Text="Length of text input field" />
                            </label>
                        </td>
                        <td>
                            <dwc:InputNumber ID="LengthText" runat="server" Value="0" />
                            <small class="help-block error" id="LengthError"></small>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <asp:Button ID="SaveButton" Style="display: none" runat="server" />
            <asp:Button ID="DeleteButton" Style="display: none" runat="server" />


        </form>
    </div>
    <iframe frameborder="0" name="EcomUpdator" id="EcomUpdator" width="1" height="1" align="right" marginwidth="0" marginheight="0" src="EcomUpdator.aspx"></iframe>

    <script type="text/javascript">
        var errorCode = document.getElementById('SaveError').value;
        if (errorCode == 'DuplicateSystemName')
            document.getElementById("SystemNameError").innerHTML = '<%=Translate.JsTranslate("An orderline field with the same systemname exists. Please select another name.") %>';
    </script>
</body>
</html>