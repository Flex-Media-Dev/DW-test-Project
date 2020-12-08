<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomCurrency_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomCurrency_Edit" %>

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
            $('NameStr').focus();
            var regionInfo = $('RegionalInfo');
            if (!regionInfo.disabled) {
                regionInfo.onchange = onChangeCultureInfo;
                regionInfo.onchange();
            }
        });

        function SaveCurrency(close) {
            var save = false;

            var field;
            if (document.getElementById('Form1').IsDefaultStr) {
                field = document.getElementById('Form1').IsDefaultStr;
            } else {
                if (document.getElementById('Form1').IsDefaultTmp) {
                    field = document.getElementById('Form1').IsDefaultTmp;
                }
            }

            if (field.checked) {
                var txt = '<%=Translate.JsTranslate("Du har valgt et denne valuta er standard.\nDette vil slå igennem på alle sprog!")%>';
                if (confirm(txt)) {
                    save = true;
                }
            } else {
                save = true;
            }

            if (save) {
                document.getElementById('Close').value = close ? 1 : 0;
                document.getElementById('Form1').SaveButton.click();
            }
        }

        var currencyCode = "";
        var currencySymbol = "";
        var fromstart = true;
        function onChangeCultureInfo() {
            var info = this.options[this.selectedIndex].value;
            if (!!info) {
                $$("#fieldsetSettings fieldset")[0].disabled = true;
                $$("#fieldsetRegionalSettings fieldset")[0].disabled = false;

                var url = "/Admin/Module/eCom_Catalog/dw7/edit/EcomCurrency_Edit.aspx?AJAX=LoadCultureInfo";
                new Ajax.Request(url, {
                    parameters: {
                        CultureInfo: info
                    },
                    onSuccess: function (transport) {
                        var countryInfoNotFound = function () {
                            $$("#fieldsetSettings fieldset")[0].disabled = false;
                            $$("#fieldsetRegionalSettings fieldset")[0].disabled = true;
                            alert('This country is absent in [EcomGlobalISO]!');
                        };
                        if (transport && transport.responseJSON) {

                            var json = transport.responseJSON;
                            var ddl = $('CurrencyCode');
                            currencyCode = json.CurrencyCode;
                            currencySymbol = json.CurrencySymbol;
                            var currencyCodeOption = ddl.select("option[value=" + currencyCode + "]")
                            if (!currencyCodeOption.length) {
                                currencyCode = json.PaymentCode;
                                var currencyCodeOption = ddl.select("option[value=" + currencyCode + "]")
                                if (!currencyCodeOption.length) {
                                    currencyCode = "";
                                }
                            }
                            ddl.value = currencyCode;
                            $('SymbolStr').value = json.CurrencySymbol;
                            $('PayGatewayCodeStr').value = json.PaymentCode;
                            var posPattern = "";

                            var positiveOptions = $('<%= ddlCurrencyPositivePattern.ClientID%>').options;
                            for (var i = 0; i < positiveOptions.length; i++) {
                                if (positiveOptions[i].selected){
                                    posPattern = positiveOptions[i].label;
                                }
                                if (positiveOptions[i].value == json.PositivePattern) {
                                    if (!fromstart) {
                                        //user changed in dropdown
                                        positiveOptions[i].selected = true;
                                        posPattern = positiveOptions[i].label;
                                    }
                                    $('spanDefaultPositivePattern').innerHTML = positiveOptions[i].text;
                                }
                            }
                            var negativeOptions = $('<%= ddlCurrencyNegativePattern.ClientID%>').options;
	                        for (var i = 0; i < negativeOptions.length; i++) {
	                            if (negativeOptions[i].value == json.NegativePattern) {
	                                if (!fromstart) {
	                                    negativeOptions[i].selected = true;
	                                }
	                                $('spanDefaultNegativePattern').innerHTML = negativeOptions[i].text;
	                            }
	                        }

	                        $('spanUseCurrencyCodeForFormat').innerHTML = posPattern.replace("$", currencyCode).replace("n", "123,00") + " instead of " + posPattern.replace("$", json.CurrencySymbol).replace("n", "123,00")
	                        fromstart = false;

	                        if (!currencyCodeOption.length) {
	                            countryInfoNotFound();
	                        }
                        }
                        else {
                            countryInfoNotFound();
                        }
                    },
                    onFailure: function () {
                        alert('Something went wrong!');
                    }
                });
            }
            else {
                $$("#fieldsetSettings fieldset")[0].disabled = false;
                $$("#fieldsetRegionalSettings fieldset")[0].disabled = true;
            }
        }

        function updateLabel(posPattern) {
            $('spanUseCurrencyCodeForFormat').innerHTML = posPattern.replace("$", currencyCode).replace("n", "123,00") + " instead of " + posPattern.replace("$", currencySymbol).replace("n", "123,00")
        }

    </script>
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>

</head>
<body class="area-pink screen-container">
    <div class="card">
        <form id="Form1" method="post" runat="server">
            <input type="hidden" name="Close" id="Close" value="0" />
            <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
            <dwc:GroupBox runat="server" Title="Currency">
                <asp:Literal ID="CurrencyExists" runat="server"></asp:Literal>
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="NewUIinput" runat="server" MaxLength="255"></asp:TextBox>
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelCulture" runat="server" Text="Regional info" />
                        </td>
                        <td>
                            <asp:DropDownList ID="RegionalInfo" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelRate" runat="server" Text="Valutakurs"></dw:TranslateLabel>
                        </td>
                        <td>
                            <dwc:InputNumber ID="RateStr" runat="server"></dwc:InputNumber>
                            <small class="help-block error" id="errRateStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="IsDefaultStr" runat="server" Label="Default" />
                            <dw:CheckBox ID="IsDefaultTmp" runat="server" Label="Default" AttributesParm="disabled" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelRoundingID" runat="server" Text="Afrunding"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:DropDownList ID="RoundingIDStr" CssClass="NewUIinput" runat="server"></asp:DropDownList></td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox ID="fieldsetRegionalSettings" runat="server" Title="Regional settings">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Positive pattern"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCurrencyPositivePattern" CssClass="NewUIinput" runat="server" onchange="updateLabel(this[this.selectedIndex].label);"></asp:DropDownList>
                            <small class="help-block info">
                                <dw:TranslateLabel runat="server" Text="Regional default" />:&nbsp;<span id="spanDefaultPositivePattern"></span>
                            </small>
                            <small class="help-block error" id="errCurrencyPositivePattern"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Negative pattern"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCurrencyNegativePattern" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                            <small class="help-block info">
                                <dw:TranslateLabel runat="server" Text="Regional default" />:&nbsp;<span id="spanDefaultNegativePattern"></span>
                            </small>
                            <small class="help-block error" id="errCurrencyNegativePattern"></small>
                        </td>
                    </tr>
                     <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Valutasymbol"></dw:TranslateLabel>
                        </td>
                        <td>
                            <dw:CheckBox ID="UseCurrencyCodeForFormat" runat="server" Label="Use currency code instead of symbol" />
                            <small class="help-block info"><span id="spanUseCurrencyCodeForFormat"></span></small>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox ID="fieldsetSettings" runat="server" Title="Settings">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelCode" runat="server" Text="Valutakode"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:DropDownList ID="CurrencyCode" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                            <small class="help-block error" id="errCurrencyCode"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelSymbol" runat="server" Text="Valutasymbol"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="SymbolStr" CssClass="NewUIinput" runat="server" MaxLength="5"></asp:TextBox>
                            <small class="help-block error" id="errSymbolStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelSymbolPlace" runat="server" Text="Valutaformat"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:DropDownList ID="SymbolPlace" CssClass="NewUIinput" runat="server"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelPayGatewayCode" runat="server" Text="Betalingskode"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:DropDownList ID="PayGatewayCodeStr" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                            <small class="help-block error" id="errPayGatewayCodeStr"></small>
                        </td>
                    </tr>
                </table>
                </dwc:GroupBox>

            <asp:Button ID="SaveButton" Style="display: none;" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server"></asp:Button>
        </form>
    </div>
    <asp:Literal ID="removeDelete" runat="server"></asp:Literal>
    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addMinLengthRestriction('CurrencyCode', 1, '<%=Translate.JsTranslate("A currency code has to be selected")%>');
        addMinLengthRestriction('SymbolStr', 1, '<%=Translate.JsTranslate("A symbol string is needed")%>');
        addMinLengthRestriction('PayGatewayCodeStr', 1, '<%=Translate.JsTranslate("A payment gateway country code has to be selected")%>');
        addValueNonNegativeOrZeroRestriction('RateStr', '<%=Translate.JsTranslate("Exchange rate must be larger than 0.")%>');
        activateValidation('Form1');
    </script>

</body>
</html>