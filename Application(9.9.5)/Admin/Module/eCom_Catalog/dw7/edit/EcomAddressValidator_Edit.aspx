<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomAddressValidator_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomAddressValidator_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    <script type="text/javascript" src="../images/functions.js"></script>
    <script type="text/javascript" src="../images/addrows.js"></script>
    <%= AddressValidatorAddin.Jscripts%>
    <script type="text/javascript" src="../images/AjaxAddInParameters.js"></script>
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
    <script src="/Admin/Resources/js/layout/Actions.js" type="text/javascript"></script>

    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        });

        function deleteTax() {
            if (confirm('<%= Translate.JsTranslate("Do you want to delete this setting?") %>')) {
                    document.getElementById('Form1').DeleteButton.click();
                }
            }

            function save(close) {
                if (!verifyCountryRelations())
                    return;

                document.getElementById("Close").value = close ? 1 : 0;
                document.getElementById('Form1').SaveButton.click();
            }

            function verifyCountryRelations() {
                var countryBoxes = $$("input:checked[name=CR_CountryRel]");

                var result = countryBoxes.length > 0;
                if (!result) {
                    alert('<%= Translate.JsTranslate("No country relation is set. Please select at least 1 country.") %>');
                }

                return result;
            }

    </script>
</head>
<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn" />
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="NewUIinput" runat="server" />
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="ActiveChk" Label="Active" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <ecom:CountryRelationSelector ID="CountryRelations" runat="server" />
            <dwc:GroupBox runat="server" Title="User groups" Expandable="true">
                <table class="formsTable">
                    <tr id="UserGroupSelectorDiv">
                        <td>
                            <dw:TranslateLabel runat="server" Text="Don’t run address validation for these user groups" />
                        </td>
                        <td>
                            <dw:UserSelector runat="server" ID="GroupsSelector" Show="Groups"></dw:UserSelector>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <asp:Panel runat="server" ID="ConfigurableProviders">
                <div id="err<%=AddressValidatorAddin.AddInTypeName %>_AddInTypes" style="color: Red; width: 100%; margin: 5px;"></div>
                <de:AddInSelector
                    runat="server"
                    ID="AddressValidatorAddin"
                    AddInShowNothingSelected="false"
                    AddInGroupName="Configurable address validation provider"
                    AddInTypeName="Dynamicweb.Ecommerce.Orders.AddressValidation.AddressValidatorProvider" />
            </asp:Panel>

            <asp:Literal runat="server" ID="LoadParametersScript"></asp:Literal>

            <asp:Button ID="SaveButton" Style="display: none;" runat="server" />
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server" />
            <input type="hidden" name="Close" id="Close" value="0" />
        </form>
    </div>
    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addMinLengthRestriction('<%=AddressValidatorAddin.AddInTypeName %>_AddInTypes', 1, '<%=Translate.JsTranslate("Select type of provider")%>');
        activateValidation('Form1');
    </script>
</body>
</html>
