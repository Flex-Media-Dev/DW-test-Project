<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomShipping_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomShipping_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Shipping </title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
            <dw:GenericResource Url="/Admin/Module/OMC/js/NumberSelector.js" />            
            <dw:GenericResource Url="../css/EcomShipping_Edit.css" />
            <dw:GenericResource Url="/Admin/FormValidation.js" />
            <dw:GenericResource Url="../js/EcomShipping_Edit.js" />
        </Items>
    </dw:ControlResources>
    <%= ServiceAddin.Jscripts%>

    <script type="text/javascript">
        strHelpTopic = 'ecom.controlpanel.shipping.edit';
        var shippingEditor = null;

        function saveShipping(close) {
            shippingEditor.save(close);
        }

        document.observe("dom:loaded", function () {
            shippingEditor = Dynamicweb.eCommerce.Shipping.initShippingMethodEditor({});
            <% If Not IsPostBack AndAlso Not String.IsNullOrEmpty(ServiceAddin.AddInSelectedType) Then%>
            <%= ServiceAddin.GetLoadParameters()%>
            <% End If%>
        });
    </script>
</head>

<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <dwc:GroupBox runat="server" Title="Metode">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn" />
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="std" runat="server" />
                            <small id="errNameStr" class="help-block error">
                                <%=Translate.JsTranslate("A name is needed")%>
                            </small>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            <dw:TranslateLabel ID="tLabelDescription" runat="server" Text="Beskrivelse" />
                        </td>
                        <td>
                            <asp:TextBox ID="DescriptionStr" CssClass="std" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelIcon" runat="server" Text="Icon" />
                        </td>
                        <td>
                            <dw:FileArchive runat="server" ID="ShipIcon" CssClass="std" ShowPreview="True" MaxLength="255"></dw:FileArchive>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                            <dw:CheckBox ID="ActiveCheckBox" runat="server" Label="Active" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Countries">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Shipping available in" />
                        </td>
                        <td>
                            <dwc:RadioGroup runat="server" ID="country_mode" Name="country-mode" Indent="false">
                                <dwc:RadioButton runat="server" Label="All countries" FieldValue="all" />
                                <dwc:RadioButton runat="server" Label="Selected countries" FieldValue="choose" />
                            </dwc:RadioGroup>
                            <div id="country_rel_list_container" class="m-t-10" style="display: none">
                                <ecom:CountryRelationSelector ID="CountryRelList" runat="server" />
                            </div>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox Title="Frontend group(s) and user(s)" DoTranslation="True" runat="server">
                <table class="formsTable">
                    <tr>
                        <td style="width: 170px; padding: 5px; vertical-align:top;">
                            <%=Translate.Translate("Shipping available for")%>
                        </td>
                        <td>
                            <dwc:RadioGroup runat="server" ID="user_mode" Name="user-mode" Indent="false">
                                <dwc:RadioButton runat="server" Label="All users" FieldValue="all" />
                                <dwc:RadioButton runat="server" Label="Selected groups" FieldValue="choose" />
                            </dwc:RadioGroup>
                            <div id="users_container" class="m-t-10" style="display: none">
                                <dw:UserSelector runat="server" ID="AllowedGroups" Show="Groups" Width="250" />
                                <asp:CheckBox runat="server" ID="AllowAnonymousUsers" />
                                <label for="AllowAnonymousUsers">
                                    <dw:TranslateLabel runat="server" Text="Anonymous users" />
                                </label>
                            </div>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Fee settings">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Standardgebyr" />
                        </td>
                        <td>
                            <asp:TextBox ID="MaxStr" CssClass="std" runat="server"></asp:TextBox>
                            <small class="help-block info"><%=Translate.Translate("This will be the fee if the provider selected below doesn't return a value")%></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Fragt fri ved køb over" />
                        </td>
                        <td>
                            <asp:TextBox ID="FreeFeeAmount" CssClass="std" runat="server"></asp:TextBox>
                            <small class="help-block info"><%=Translate.Translate("If an order is over this amount, the provider will not be asked to calculate a fee")%></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Discounts" />
                        </td>
                        <td>
                            <dw:CheckBox ID="TakeDiscountIntoAccount" runat="server" Label="Base free shipping calculation on discounted price instead of original price" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                            <dw:CheckBox ID="EligibleForFreeShipping" runat="server" Label="Eligible for free shipping" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <asp:Panel runat="server" ID="ServicePanel" class="ship-provider-selector hide">
                <de:AddInSelector
                    runat="server"
                    ID="ServiceAddin"
                    AddInGroupName="Shipping Provider"
                    AddInTypeName="Dynamicweb.Ecommerce.Cart.ShippingProvider" />
            </asp:Panel>
            <dwc:GroupBox runat="server" ID="FeeRulesCnt" Title="Fee rules">
                <dwc:RadioGroup runat="server" ID="FeeRulesSource" Name="FeeRulesSource" Label="Fee settings">
                    <dwc:RadioButton ID="FeeRulesSource_1" runat="server" Label="Use fee rules from provider" FieldValue="1" />
                    <dwc:RadioButton ID="FeeRulesSource_2" runat="server" Label="Use custom fee rules" FieldValue="2" />
                </dwc:RadioGroup>

                <span id="FeeRulesMatrix" class="hide">
                    <dwc:RadioGroup runat="server" ID="FeeSelection" Name="FeeSelection" Indent="true">
                        <dwc:RadioButton ID="FeeSelection_1" runat="server" Label="Use lowest applicable fee" FieldValue="low" />
                        <dwc:RadioButton ID="FeeSelection_2" runat="server" Label="Use highest applicable fee" FieldValue="high" />
                    </dwc:RadioGroup>

                    <dwc:RadioGroup runat="server" ID="LimitsUseLogic" Name="LimitsUseLogic" Indent="true">
                        <dwc:RadioButton ID="LimitsUseLogic_1" runat="server" Label="Both weight and volume must apply" FieldValue="1" />
                        <dwc:RadioButton ID="LimitsUseLogic_2" runat="server" Label="Either weight or volume must apply" FieldValue="2" />
                    </dwc:RadioGroup>

                    <dw:EditableList ID="Rules" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" Personalize="true"></dw:EditableList>
                </span>
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>
            <input id="Close" type="hidden" name="Close" value="0" />
        </form>
    </div>
</body>
</html>
