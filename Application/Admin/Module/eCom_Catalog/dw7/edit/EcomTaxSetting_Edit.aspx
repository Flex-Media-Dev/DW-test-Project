<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomTaxSetting_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomTaxSetting_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript" src="../images/functions.js"></script>
    <script type="text/javascript" src="../images/addrows.js"></script>
    <%= TaxProviderAddin.Jscripts%>
    <script type="text/javascript" src="../images/AjaxAddInParameters.js"></script>
    <script type="text/javascript" src="/Admin/Extensibility/JavaScripts/ProductsAndGroupsSelector.js"></script>
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>

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
                var countryBoxes = $$("input:checkbox[name='CR_CountryRel']"); // $$("input#CR_CountryRel");

                var result = false;
                for (var i = 0; i < countryBoxes.length; i++) {
                    if (countryBoxes[i].checked) {
                        result = true;
                        break;
                    }
                }

                if (!result) {
                    alert('<%= Translate.JsTranslate("No country relation is set. Please select at least 1 country.") %>');
                    // TODO: Switch to country tab
                    Tabs.tab(2);
                }

                return result;
            }

            function isReadyForTest() {
                var msg = '<%= Translate.JsTranslate("Do you want to continue? All unsaved data will be lost.") %>'
                if (confirm(msg)) {
                    $('loadingDiv').show();
                    return true;
                }
                else return false;
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
                            <small id="errNameStr" class="help-block error"></small>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dwc:CheckBox ID="ActiveChk" runat="server" Indent="false" Label="Active" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            
            <ecom:CountryRelationSelector ID="CountryRelations" runat="server" />
            
            <asp:Panel runat="server" ID="ConfigurableTaxProviders">
                <div id="err<%=TaxProviderAddin.AddInTypeName %>_AddInTypes" style="color: Red; width: 100%; margin: 5px;"></div>
                <de:AddInSelector
                    runat="server"
                    ID="TaxProviderAddin"
                    useNewUI="true"
                    AddInShowNothingSelected="false"
                    AddInGroupName="Configurable tax Provider"
                    AddInTypeName="Dynamicweb.Ecommerce.Products.Taxes.TaxProvider" />
            </asp:Panel>

            <asp:Literal runat="server" ID="LoadParametersScript"></asp:Literal>
            
            <dwc:GroupBox runat="server" Title="Test connection">
                <table class="formsTable">
                    <tr>
                        <td>
                            <asp:Button ID="TestConnectionButton" CssClass="btn btn-flat" OnClientClick="return isReadyForTest();" runat="server" Enabled="false" />
                            <div id="loadingDiv" style="display: none;">
                                <img src='/Admin/Module/eCom_Catalog/images/ajaxloading_trans.gif' style='margin: 5px; padding: 5px;' /></div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                            <asp:Literal runat="server" ID="TestResult"></asp:Literal>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            
            <asp:Button ID="SaveButton" Style="display: none;" runat="server" />
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server" />
            <input type="hidden" name="Close" id="Close" value="0" />
        </form>
    </div>
    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addMinLengthRestriction('<%=TaxProviderAddin.AddInTypeName %>_AddInTypes', 1, '<%=Translate.JsTranslate("Tax provider is needed")%>');
        activateValidation('Form1');
    </script>
</body>
</html>
