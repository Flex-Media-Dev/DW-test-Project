<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent2.Master" Language="vb" AutoEventWireup="false" CodeBehind="EcomAdvConfigPrices_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigPrices_Edit" EnableViewState="false" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="Stylesheet" type="text/css" href="../css/EcomAdvConfigPricesEdit.css" media="screen" />
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeScriptaculous="true"></dw:ControlResources>
    <script type="text/javascript" src="../js/EcomAdvConfigPricesEdit.js"></script>

    <script type="text/javascript">
        document.observe("dom:loaded", function () {
            var trans = {};
            trans['RequestError'] = '<%=Translate.Translate("Something went wrong! Try again.")%>';

            new Dynamicweb.Managment.Ecom.AdvConfig.Prices.Forms.Main({
                help: function () {
                    <%=Gui.Help("", "administration.controlpanel.ecom.prices") %>
                },
                translations: trans
            });
        });
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server" >
    <div id="PageContent">        
		<dwc:GroupBox runat="server" Title="Indstillinger">			
            <dwc:InputNumber Name="/Globalsettings/Ecom/Price/PricesInDbVAT" ID="PricesInDbVAT" Label="System moms" IncrementSize="0.01" runat="server">
                <dwc:FieldAddOn Text="%" />
            </dwc:InputNumber>
			<dwc:CheckBox runat="server" ID="UseSalesTaxGroupRateAsSystemTax" Name="/Globalsettings/Ecom/Price/UseSalesTaxGroupRateAsSystemTax" Label="Use VAT group rate as system tax" />
			<dwc:CheckBox runat="server" ID="PricesInDbIncludesVAT" Name="/Globalsettings/Ecom/Price/PricesInDbIncludesVAT" Label="Priser i DB inkl. moms" />
			<dwc:CheckBox runat="server" id="RoundPricesByCurrencyCulture" Name="/Globalsettings/Ecom/Price/RoundPricesByCurrencyCulture" Label="Round price calculations by currency culture" />
            <dwc:CheckBox runat="server" id="RoundPricesWithVAT" Name="/Globalsettings/Ecom/Price/RoundPricesWithVAT" Label="Afrund priser med moms" />
			<dwc:CheckBox runat="server" ID="CalculatePercentShippingFeeInclVAT" Name="/Globalsettings/Ecom/Price/CalculatePercentShippingFeeInclVAT" Label="Beregn % forsendelsesgebyr inkl. moms" />
			<dwc:CheckBox runat="server" ID="UseDeliveryCountry" Name="/Globalsettings/Ecom/Order/VAT/UseDeliveryCountry" Label="Brug alt. leveringsland ved moms" />
			<dwc:CheckBox runat="server" ID="CalculatePaymentFeeInclShippingFee" Name="/Globalsettings/Ecom/Price/CalculatePaymentFeeInclShippingFee" Label="Calculate payment fee from price including shipping fee" />
			<dwc:CheckBox runat="server" ID="AllowNegativeOrderTotalPrice" Name="/Globalsettings/Ecom/Price/AllowNegativeOrderTotalPrice" Label="Allow negative total order price" />
            <dw:Infobar runat="server" ID="NoSystemVatWarning" Visible="false" Type="Warning" Message="Prices in the database includes VAT, but no 'System VAT' is set"/>
            <dw:Infobar runat="server" ID="MultipleCountriesWarning" Visible="false" Type="Warning" Message="Prices in the database include VAT, but the solution contains multiple countries. Are you sure this is what you want?" />
        </dwc:GroupBox>
				
        <dwc:GroupBox Title="Calculate VAT on fees" runat="server">
			<dwc:CheckBox runat="server" ID="IncludeVATOnPaymentFee" Name="/Globalsettings/Ecom/Order/PaymentFee/IncludeVATOnPaymentFee" Label="Payment" />
			<dwc:CheckBox runat="server" ID="IncludeVATOnShippingFee" Name="/Globalsettings/Ecom/Order/ShippingFee/IncludeVATOnShippingFee" Label="Shipment" />			
		</dwc:GroupBox>
    </div>

    <% Translate.GetEditOnlineScript() %>

</asp:Content>
