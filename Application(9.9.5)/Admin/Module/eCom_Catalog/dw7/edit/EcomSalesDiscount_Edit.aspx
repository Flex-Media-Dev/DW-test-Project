<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomSalesDiscount_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomSalesDiscount_Edit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Ecommerce.Extensibility.Controls" Assembly="Dynamicweb.Ecommerce" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Ecommerce.Orders.SalesDiscounts" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1" />
    <meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1" />
    <meta name="vs_defaultClientScript" content="JavaScript" />
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5" />

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/functions.js" />
            <dw:GenericResource Url="/Admin/FormValidation.js" />
            <dw:GenericResource Url="/Admin/Extensibility/JavaScripts/ProductsAndGroupsSelector.js" />
            <dw:GenericResource Url="/Admin/Extensibility/Stylesheets/ProductsAndGroupsSelector.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/ToolTip.css" />
        </Items>
    </dw:ControlResources>

    <%=AddInControl.Jscripts%>

    <style>
        .dw-list-line {
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }
    </style>

    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
            <%If Dynamicweb.Security.Authorization.UserHasAccess("eCom_SalesDiscountExtended", "") AndAlso Dynamicweb.Security.UserManagement.License.IsModuleAvailable("eCom_MultiShopAdvanced") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("eCom_MultiShopAdvanced") Then%>
            toggleCountries();
            <%End If%>

            <%If Dynamicweb.Security.Authorization.UserHasAccess("eCom_SalesDiscountExtended", "")%>
            Event.observe($("DiscountValue"), "change", function (event) {
                toggleValueType();
            });
            <%End If%>
        });

	    <%If Dynamicweb.Security.Authorization.UserHasAccess("eCom_SalesDiscountExtended", "") Then%>
        function OnChangeDiscountType(addInName) {
            toggleValueProductDiv(addInName);
            toggleValueGroupBox(addInName);
            toggleValueType();
        }

        function toggleValueProductDiv(addInName) {
            var optionProduct = $$("select#DiscountValue option[value=<%= DiscountValueTypes.Products%>]")[0];
            if (!optionProduct)
            {
                console.log("Something wrong hapened: discount value with type 'product' was not found");
                return;
            }

            if (addInName === '<%=GetType(ProductDiscount).FullName%>') {
                var discountValueSelect = $("DiscountValue");
                if (discountValueSelect.value === "<%= DiscountValueTypes.Products%>") {
                    discountValueSelect.value = "<%= DiscountValueTypes.Fixed%>";
                }
                optionProduct.hide();
            } else {
                optionProduct.show();
            }
        }

        function toggleValueGroupBox(addInName) {
            try {
                var valueGroupBoxDiv = $('ValueGroupBox_Div');

                if (hideDiscountValueGroupBox(addInName)) {
                    // Hide the div
                    valueGroupBoxDiv.style.display = 'none';
                }
                else {
                    // Show the div
                    valueGroupBoxDiv.style.display = '';
                }
            } catch (e) {
                //Nothing
            }
        }

        function toggleValueType() {
            var discountValue = parseInt($("DiscountValue").value);
            if (discountValue == 0) {
                $('discount-value-percentage').hide();
                $('discount-value-products').hide();
                $('discount-value-fixed').show();
                return true;
            }
            if (discountValue == 1) {
                $('discount-value-percentage').show();
                $('discount-value-products').hide();
                $('discount-value-fixed').hide();
                return true;
            }
            if (discountValue == 2) {
                $('discount-value-percentage').hide();
                $('discount-value-products').show();
                $('discount-value-fixed').hide();
                return true;
            }
            return false;
        }

        function toggleCountries() {
            if ($('CountryRadio_1').checked) {
                $('SelectedCountries').hide();
            }
            else {
                $('SelectedCountries').show();
            }
        }
        <%End If%>

        // Overwrite the doSubmit in form validation
        function doSubmit(button) {
            // Remove any error messages
            try {
                $('valueError').innerHTML = '';
            } catch (ex) { }

            if (document.getElementById("Products_radio_all")) {
                if (document.getElementById("Products_radio_all").checked) {
                    if (!confirm('<%=Translate.JsTranslate("Apply discount to all products?")%>\n\n<%=Translate.JsTranslate("Please check your configuration!")%>')) {
                        document.getElementById('productsError').innerHTML = '<%=Translate.JsTranslate("Check your settings - it seems like all products in a shop gets this discount!") %>';
                        return false;
                    }
                }
            }

            var parentform = getParentFormElement(button);
            if (parentform != null) {
                var validated = doFormValidation(parentform);

                var valueGroupBoxDiv = document.getElementById('ValueGroupBox_Div');
                if (valueGroupBoxDiv.style.display != 'none') {
                    // If discount value panel is showed, check the value inputs
                    var fixedRadio = document.getElementById("DiscountValue_radio_fixed")
                    if (fixedRadio != null && fixedRadio.checked) {
                        var value = document.getElementById("DiscountValueText_Fixed").value;
                        var doubleValue = parseFloat(value);
                        if (isNaN(doubleValue)) {
                            document.getElementById('valueError').innerHTML = '<%=Translate.Translate("Value must be a number") %>';
                            validated = false;
                        }
                    }
                    var percentageRadio = document.getElementById("DiscountValue_radio_percentage")
                    if (percentageRadio != null && percentageRadio.checked) {
                        var value = document.getElementById("DiscountValueText_Percentage").value;
                        var doubleValue = parseFloat(value);
                        if (isNaN(doubleValue)) {
                            document.getElementById('valueError').innerHTML = '<%=Translate.Translate("Value must be a number") %>';
                            validated = false;
                        }
                        else if (doubleValue == 0) {
                            document.getElementById('valueError').innerHTML = '<%=Translate.Translate("Please enter a non-zero value") %>';
                                validated = false;
                            }
                    }
                    var productsRadio = document.getElementById("DiscountValue_radio_products")
                    if (productsRadio != null && productsRadio.checked) {
                        var value = document.getElementById("DiscountValueProductsSelector_value").value;
                        if (value == null || value == '') {
                            document.getElementById('valueError').innerHTML = '<%=Translate.Translate("At least one product must be selected") %>';
                            validated = false;
                        }
                    }
                }

                return validated;
            }
        }

        function getDate(dateString) {
            var dateRegex = /(\d+)-(\d+)-(\d+) (\d+):(\d+)/;
            var match = dateRegex.exec(dateString);
            var date = new Date();
            date.setDate(match[1]);
            date.setMonth(match[2] - 1); // Month has an OB1E
            date.setFullYear(match[3]);
            date.setHours(match[4]);
            date.setMinutes(match[5]);
            date.setSeconds(0);
            date.setMilliseconds(0);
            return date;
        }

        function setDetailsDisabled() {
            setEnabled(document.getElementById('SalesDiscountDetailsDiv'));
        }
        function setEnabled(el) {
            try {
                el.disabled = true;
            } catch (e) { }

            if (el.childNodes && el.childNodes.length > 0)
                for (var x = 0; x < el.childNodes.length; x++)
                    setEnabled(el.childNodes[x]);
        }

        function save(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }                
    </script>

</head>
<body class="area-pink">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <dw:Infobar runat="server" ID="NotLocalizedInfo" Type="Warning" Visible="false" Message="The discount is not localized to this language. Save the discount to localize it." />

            <dwc:GroupBox runat="server" Title="General">
                <dwc:InputText ID="NameStr" runat="server" Label="Navn" />
                <dwc:InputTextArea ID="DescriptionStr" runat="server" Label="Description" />
                <dwc:CheckBox ID="ActiveBool" runat="server" Label="Active" />
                <dw:DateSelector runat="server" ID="DateFrom" AllowNeverExpire="false" Label="Date from" />
                <dw:DateSelector runat="server" ID="DateTo" AllowNeverExpire="true" Label="Date to" />
            </dwc:GroupBox>
            <dw:Infobar runat="server" Visible="false" ID="NotDefaultInfo" Type="Information" Message="To edit the discount details you need to edit the discount in the default language" />

            <!-- Type -->
            <div id="SalesDiscountDetailsDiv">
                <dwc:GroupBox runat="server" Title="Discount type">
                    <table class="formsTable">
                            <tr>
                                <td></td>
                                <td><div style="clear: both; color: Red;" id="productsError"></div></td>
                            </tr>
                        </table>
                    <input type="hidden" id="Type_SalesDiscount_Hidden" <%If Dynamicweb.Security.Authorization.UserHasAccess("eCom_SalesDiscountExtended", "") Then%>
                        onchange="OnChangeDiscountType(this.value);" <%End If%> />
                    <de:SalesDiscountAddInSelector ID="AddInControl" runat="server" HiddenControlToUpdate="Type_SalesDiscount_Hidden" Label="Type" />
                </dwc:GroupBox>
                <div id="ValueGroupBox_Div">
                    <!-- Discount value -->
                    <dwc:GroupBox runat="server" Title="Discount value">
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Type" />
                                    <a class="tooltip">
                                    <i style="cursor: pointer;" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i>
                                    <span>
                                        <strong><%=Translate.Translate("Amount") %>:</strong><br />
                                        <%=Translate.Translate("Enter a fixed discount sum (e.g. 100) which is subtracted from the price. If the dicount is set to 25 for EURO, then the customer will only get 25 EURO as discount for websites that use EURO as currency.")%><br />
                                        <strong><%=Translate.Translate("Percentage") %>:</strong><br />
                                        <%=Translate.Translate("Enter a discount percentage. If the discount percentage is set to 50, then the customer will only be charged half the price.")%><br />
                                        <strong><%=Translate.Translate("Products") %>:</strong><br />
                                        <%=Translate.Translate("Choose one or more products from your product catalog by clicking the Add products icon. When the sales discount is activated then the chosen product(s) will be added to the customer's cart.")%><br />                                        
                                    </span>
                                </a>
                                </td>
                                <td>
                                    <dwc:SelectPicker runat="server" ID="DiscountValue"></dwc:SelectPicker>
                                </td>
                            </tr>
                        </table>
                        <div id="discount-value-fixed" style="display: none;">
                            <table class="formsTable">
                                <tr>
                                    <td>
                                        <dw:TranslateLabel runat="server" Text="Amount (Default currency)" />
                                    </td>
                                    <td>
                                        <dwc:InputNumber runat="server" ID="DiscountValueText_Fixed" />
                                    </td>
                                </tr>
                            </table>
                            <table class="formsTable" id="CurrencyTable" runat="server"></table>                            
                        </div>
                        <table class="formsTable">
                            <tr id="discount-value-percentage" style="display: none;">
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Percentage" />
                                </td>
                                <td>
                                    <dwc:InputNumber runat="server" ID="DiscountValueText_Percentage">
                                        <dwc:FieldAddOn Text="%" />
                                    </dwc:InputNumber>
                                </td>
                            </tr>
                            <tr id="discount-value-products" style="display: none;">
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Products" />
                                </td>
                                <td>
                                    <de:ProductsSelector runat="server" ID="DiscountValueProductsSelector" Width="300px" Height="150px" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <div style="clear: both; color: Red;" id="valueError"></div>
                                </td>
                            </tr>
                        </table>
                    </dwc:GroupBox>
                </div>
                <!-- Limitation -->
                <dwc:GroupBox runat="server" Title="User">
                    <table class="formsTable">
                        <!-- Users -->
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Used by" />
                            </td>
                            <td>
                                <dwc:RadioGroup runat="server" Indent="false" Name="UserSelectorRadio" ID="UserSelectorRadio">
                                    <dwc:RadioButton runat="server" OnClick="toggleUserSelectorDiv();" Label="All" FieldValue="[all]" /> 
                                    <dwc:RadioButton runat="server" OnClick="toggleUserSelectorDiv();" Label="Authenticated users" FieldValue="[auth]" /> 
                                    <dwc:RadioButton runat="server" OnClick="toggleUserSelectorDiv();" Label="Selected users and groups" FieldValue="[selected]" /> 
                                </dwc:RadioGroup>
                            </td>
                        </tr>
                        <tr id="UserGroupSelectorDiv" style="display: none;">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Users and/or groups" />
                            </td>
                            <td>
                                <dw:UserSelector runat="server" ID="SelectedUsersAndGroups" CompatibleWithOldExtranet="true" />
                            </td>
                        </tr>
                    </table>
                    <script type="text/javascript">
                        function toggleUserSelectorDiv() {
                            document.getElementById('UserGroupSelectorDiv').style.display = $("UserSelectorRadio_3").checked ? '' : 'none';
                        }
                        toggleUserSelectorDiv();
                    </script>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" Title="Order">
                    <!-- Shop -->
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Shop (website context):" />
                            </td>
                            <td>
                                <select id="ShopSelector" name="ShopSelector" runat="server" size="1" class="std"></select>
                            </td>
                        </tr>
                        <!-- Countries -->
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Country (website context):" />
                            </td>
                            <td>
                                <dwc:RadioGroup runat="server" Indent="false" Name="CountryRadio" ID="CountryRadio">
                                    <dwc:RadioButton runat="server" OnClick="toggleCountries();" Label="All" FieldValue="[all]" />
                                    <dwc:RadioButton runat="server" OnClick="toggleCountries();" Label="Selected" FieldValue="[selected]" />
                                </dwc:RadioGroup>
                                <asp:CheckBoxList ID="SelectedCountries" runat="server"></asp:CheckBoxList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Minimum total price" />
                            </td>
                            <td>
                                <dwc:InputNumber ID="MinimumBasketSize" runat="server" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </div>

            <asp:Button ID="SaveButton" Style="display: none" runat="server" />
            <asp:Button ID="DeleteButton" Style="display: none" runat="server" />
            <asp:Button ID="DelocalizeButton" Style="display: none" runat="server" />
        </form>
    </div>
    <%=AddInControl.LoadParameters%>

    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        activateValidation('Form1');

        // Disable all but name and description if this is not the default language
        if ('<%=IsDefault %>' == 'False')
            setDetailsDisabled();

    </script>
</body>
</html>
