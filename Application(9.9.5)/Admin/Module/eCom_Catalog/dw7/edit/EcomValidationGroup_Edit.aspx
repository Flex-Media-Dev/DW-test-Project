<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomValidationGroup_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomValidationGroup_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Ecommerce.Extensibility.Controls" Assembly="Dynamicweb.Ecommerce" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            $("SaveButton").onclick = validate;

            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        });

        function validate() {
            var success = true;
            var groupName = document.getElementById("NameStr").value;

            if (groupName.length > 255) {
                document.getElementById("errNameStr").innerHTML = '<%=Translate.JsTranslate("The group name must be shorter than 256 characters.") %>';
                success = false;
            }
            if (groupName.length == 0) {
                document.getElementById("errNameStr").innerHTML = '<%=Translate.JsTranslate("Please type a name.") %>';
                success = false;
            }

            success = validateParameters() && success;
            return success;
        }

        function save(close) {
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
            <asp:Literal ID="TableIsBlocked" runat="server"></asp:Literal>
            <!-- Group -->
            <dwc:GroupBox runat="server" ID="GroupGroupBox">
                <table class="formsTable">
                    <tr>
                        <td><label for="NameStr"><dw:TranslateLabel runat="server" Text="Name" /></label></td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="std" runat="server" />
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>                    
                </table>
                <dwc:CheckBox Label="Do not validate if all fields are empty" ID="DoNotValidateIfAllFieldsAreEmpty" runat="server" />                            
            </dwc:GroupBox>

            <!-- Fields -->
            <dwc:GroupBox runat="server" ID="FieldGroupBox">
                <de:ValidationConfigurator runat="server" ID="ValidationConfigurator" />
            </dwc:GroupBox>

            <asp:Button ID="SaveButton" Style="display: none" runat="server" />
            <asp:Button ID="DeleteButton" Style="display: none" runat="server" />
        </form>
    </div>
    <iframe frameborder="0" name="EcomUpdator" id="EcomUpdator" width="1" height="1" align="right" marginwidth="0" marginheight="0" src="EcomUpdator.aspx"></iframe>
</body>
</html>