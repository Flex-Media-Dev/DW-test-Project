<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomVatGrp_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomVatGrp_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        });

        function saveVat(close) {
            document.getElementById('Close').value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }

        var deleteMsg = '<%= DeleteMessage %>';
        function deleteVat() {
            if (confirm(deleteMsg)) document.getElementById('Form1').DeleteButton.click();
        }
    </script>

    <script language="JavaScript">
        function switchVatGroupType(radio) {
            if (radio.value == "default") {
                document.getElementById('ConfigurableVatProviders').style.display = 'none';
            }
            else {
                document.getElementById('ConfigurableVatProviders').style.display = 'block';
            }
        }
    </script>

    <script src="/Admin/FormValidation.js"></script>

    <%=VatProviderAddin.Jscripts%>
</head>
<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <asp:Literal ID="NoVatExistsForLanguageBlock" runat="server"></asp:Literal>
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
                        <td>
                            <dw:TranslateLabel ID="tLabelVatName" runat="server" Text="Egennavn" />
                        </td>
                        <td>
                            <asp:TextBox ID="VatNameStr" CssClass="NewUIinput" runat="server" />
                            <small class="help-block error" id="errVatNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelType" runat="server" Text="Type" />
                        </td>
                        <td>
                            <dwc:RadioGroup runat="server" Name="toggleAddIns" ID="toggleAddIns" Indent="false">
                                <dwc:RadioButton runat="server" FieldValue="default" Label="Default" OnClick="switchVatGroupType(this);" />
                                <dwc:RadioButton runat="server" FieldValue="provider" Label="Provider" OnClick="switchVatGroupType(this);" />
                            </dwc:RadioGroup>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <asp:Panel runat="server" ID="ConfigurableVatProviders" Style="display: none;">
                <de:AddInSelector
                    runat="server"
                    ID="VatProviderAddin"
                    AddInGroupName="Configurable VAT Provider"
                    AddInTypeName="Dynamicweb.Ecommerce.Prices.ConfigurableVatProvider" />
            </asp:Panel>
            <asp:Button ID="SaveButton" Style="display: none;" runat="server" />
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server" />
            <input type="hidden" name="Close" id="Close" value="0" />
            <ecom:CountryRelationSelector ID="VatFees" runat="server" />
            <asp:Literal runat="server" ID="LoadParametersScript"></asp:Literal>
        </form>
    </div>

    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name needs to be specified")%>');
        addMinLengthRestriction('VatNameStr', 1, '<%=Translate.JsTranslate("A vat-name needs to be specified")%>');
        activateValidation('Form1');
    </script>
</body>
</html>
