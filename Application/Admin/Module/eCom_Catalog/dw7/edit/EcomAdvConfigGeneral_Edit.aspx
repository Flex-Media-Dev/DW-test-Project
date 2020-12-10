<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb"
    AutoEventWireup="false" CodeBehind="EcomAdvConfigGeneral_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigGeneral_Edit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script language="javascript" type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {

            document.getElementById('MainForm').submit();
        }

        page.onHelp = function () {
            <%=Dynamicweb.SystemTools.Gui.Help("", "administration.controlpanel.ecom.general") %>
        }

        function ChkValidNum(field) {
            var newValue = '';
            for (i = 0; i < field.value.length; i++) {
                if (!isNaN(field.value.charAt(i))) {
                    newValue = newValue + '' + field.value.charAt(i);
                }
            }
            field.value = newValue;
        }
    </script>
    <style type="text/css">
        .groupbox .left-indent {
            margin-left: 180px;
        }
    </style>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="cardHeader" Title="Advanced configuration"></dwc:CardHeader>

        <dwc:CardBody runat="server">
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <dwc:InputText runat="server" Label="Antal dage kurven gemmes" ID="DaysToSave" Name="/Globalsettings/Ecom/Cookie/DaysToSave" onclick="ChkValidNum(this);" />
                <dwc:InputText runat="server" Label="Minutes the products in cart are reserved" ID="MinutesReserved" Name="/Globalsettings/Ecom/Product/MinutesReserved" onclick="ChkValidNum(this);" />

                <dwc:RadioGroup runat="server" Name="/Globalsettings/Ecom/Product/ReserveMode" Label="Reserve products">
                    <dwc:RadioButton runat="server" FieldValue="modeCheckout" ID="Mode1" Label="Reserve at checkout step" />
                    <dwc:RadioButton runat="server" FieldValue="modeAddToCart" ID="Mode2" Label="Reserve when product is added to cart" />
                </dwc:RadioGroup>

                <dwc:InputText runat="server" Label="Enhed for vægt" ID="Weight" Name="/Globalsettings/Ecom/Unit/Weight" />
                <dwc:InputText runat="server" Label="Enhed for rumfang" ID="Volume" Name="/Globalsettings/Ecom/Unit/Volume" />   
                <dwc:InputText runat="server" Label="Dimensions unit" ID="Dimensions" Name="/Globalsettings/Ecom/Unit/Dimensions" />            
                <dwc:CheckBox runat="server" Label="Allow different context dates" Value="true" ID="AllowDifferentContextDates" Name="/Globalsettings/Ecom/Cart/AllowDifferentContextDates" />
                <dwc:CheckBox runat="server" Label="Allow сombine products as family" Value="true" ID="AllowCombineProductsAsFamily" Name="/Globalsettings/Ecom/Product/AllowCombineProductsAsFamily" />
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Indexing">                
                <dwc:GroupBox runat="server" Title="Product Index Schema Extender" ClassName="groupbox left-indent">
                    <dwc:CheckBox runat="server" Indent="false" Label="Do not store default fields" Value="true" ID="DoNotStoreDefaultFields" Name="/Globalsettings/Ecom/Indexing/DoNotStoreDefaultFields" />
                    <dwc:CheckBox runat="server" Indent="false" Label="Do not analyze default fields" Value="true" ID="DoNotAnalyzeDefaultFields" Name="/Globalsettings/Ecom/Indexing/DoNotAnalyzeDefaultFields" />
                </dwc:GroupBox>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Navigation">
                <dwc:CheckBox runat="server" Label="Only apply eCommerce navigation if page is in path" Value="true" ID="ApplyOnliyIfPageIsInPath" Name="/Globalsettings/Ecom/Navigation/ApplyOnliyIfPageIsInPath" />
                <dwc:CheckBox runat="server" Label="Add product count to each group" Value="true" ID="CalcProductCountForGroup" Name="/Globalsettings/Ecom/Navigation/CalculateProductCountForGroup" />
                <dwc:CheckBox runat="server" Label="Apply startlevel and endlevel to navigation" Value="true" ID="ApplyStartAndEndLevelToNavigation" Name="/Globalsettings/Ecom/Navigation/ApplyStartAndEndLevelToNavigation" />
                
                <%If Dynamicweb.Frontend.XmlNavigation.GetCustomNavigationProviders().Count > 0 Then%>
                <dwc:CheckBox runat="server" Label="Use only custom navigation provider" Value="true" ID="UseOnlyCustomNavigationProvider" Name="/Globalsettings/Ecom/Navigation/UseOnlyCustomNavigationProvider" Info="If selected only custom navigation provider will be used, otherwise all existing navigation providers will be used" />
                <%End If%>

                <dwc:InputText runat="server" Label="Max number of products included in each group" ID="MaxNumberOfProducts" Name="/Globalsettings/Ecom/Navigation/MaxNumberOfProducts" />
                <dwc:InputText runat="server" Label="Products cache, minutes" ID="CacheProductsMinute" Name="/Globalsettings/Ecom/Navigation/CacheProductsMinute" />
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Language">
                <dwc:CheckBox runat="server" Label="Only show translated elements" Value="true" ID="DontUseDefaultLanguageIsNoProductExists" Name="/Globalsettings/Ecom/Product/DontUseDefaultLanguageIsNoProductExists" Info="Groups, products and related products" />
                <dwc:CheckBox runat="server" Label="Activate products on all language versions on create" Value="true" ID="ActivateProductsOnAllLanguageVersions" Name="/Globalsettings/Ecom/Product/ActivateProductsOnAllLanguageVersions" />
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Only show products">
                <dwc:CheckBox runat="server" Label="That are in stock" Value="true" ID="DontShowProductIfNotOnStock" Name="/Globalsettings/Ecom/Product/DontShowProductIfNotOnStock" />
                <dwc:CheckBox runat="server" Label="That have a price" Value="true" ID="DontShowProductIfHasNoPrice" Name="/Globalsettings/Ecom/Product/DontShowProductIfHasNoPrice" />
                <dwc:CheckBox runat="server" Label="That are active" Value="true" ID="DontAllowLinksToProductIfNotActive" Name="/Globalsettings/Ecom/Product/DontAllowLinksToProductIfNotActive" />

                <div class="form-group">
                    <dw:TranslateLabel runat="server" UseLabel="true" Text="Show this page for inactive products" />
                    <%=Dynamicweb.SystemTools.Gui.LinkManager(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Product/ProductNotActivePage"), "/Globalsettings/Ecom/Product/ProductNotActivePage", "", "0", "", False, "off", True)%>
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Only show variants">
                <dwc:CheckBox runat="server" Label="That are in stock" Value="true" ID="DontShowVariantIfNotOnStock" Name="/Globalsettings/Ecom/Product/DontShowVariantIfNotOnStock" />
                <dwc:CheckBox runat="server" Label="That have a price" Value="true" ID="DontShowVariantIfHasNoPrice" Name="/Globalsettings/Ecom/Product/DontShowVariantIfHasNoPrice" />
                <dwc:CheckBox runat="server" Label="That are active" Value="true" ID="DontAllowLinksToVariantIfNotActive" Name="/Globalsettings/Ecom/Product/DontAllowLinksToVariantIfNotActive" />
                <dwc:CheckBox runat="server" Label="Show default variant in product list" Value="true" ID="ShowVariantDefault" Name="/Globalsettings/Ecom/Product/ShowVariantDefault" />
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Produkt - Gruppevisnings cache">
                <dwc:CheckBox runat="server" Label="Aktiver" Value="true" ID="CacheProductCollection" Name="/Globalsettings/Ecom/ProductGroup/CacheProductCollection" />
                <dwc:InputText runat="server" Label="Antal minuter" ID="CacheProductCollectionMinutes" Name="/Globalsettings/Ecom/ProductGroup/CacheProductCollectionMinutes" />

                <%--<input type="text" value="<%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/ProductGroup/CacheProductCollectionMinutes") = "", "1", Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/ProductGroup/CacheProductCollectionMinutes"))%>"
                    id="Text1" name="/Globalsettings/Ecom/ProductGroup/CacheProductCollectionMinutes" />--%>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Additional fields">   
                <dwc:CheckBox runat="server" Label="Disable product count for backend eCommerce tree" Value="true" ID="DisableProductCountForBackend" Name="/Globalsettings/Ecom/Product/DisableProductCountForBackend" />
                <dwc:CheckBox runat="server" Label="Include variants in Bulk Edit" Value="true" ID="BulkEditForProductVariant" Name="/Globalsettings/Ecom/Product/BulkEditForProductVariant" />

                <%If Dynamicweb.Security.UserManagement.License.IsModuleAvailable("eCom_BackCatalog") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("eCom_BackCatalog") Then%>
                <dwc:CheckBox runat="server" Label="Show back catalog fields on products" Value="true" ID="ShowBackCatalogFields" Name="/Globalsettings/Ecom/Product/ShowBackCatalogFields" />
                <%End If%>
            </dwc:GroupBox>            

            <dwc:GroupBox runat="server" Title="Taxes in the backend">
                <dwc:CheckBox runat="server" Label="Consolidate taxes for each product" Value="true" ID="ConsolidateTaxesForProducts" Name="/Globalsettings/Ecom/Order/ConsolidateTaxesForProducts" />
                <dwc:CheckBox runat="server" Label="Consolidate taxes for the order" Value="true" ID="ConsolidateTaxesForOrder" Name="/Globalsettings/Ecom/Order/ConsolidateTaxesForOrder" />
            </dwc:GroupBox>            

            <dwc:GroupBox runat="server" Title="Power pack">
                <dwc:InputText runat="server" Label="Number of links needed to appear on Customer who saw also saw list" ID="LimitOfLinksToAppearOnTheList" Name="/Globalsettings/Ecom/RelatedProducts/LimitOfLinksToAppearOnTheList" />

                <%--                    <input type="text" value="<%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/RelatedProducts/LimitOfLinksToAppearOnTheList") = "", "5", Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/RelatedProducts/LimitOfLinksToAppearOnTheList"))%>" />--%>
            </dwc:GroupBox>            

            <dwc:GroupBox ID="GroupBox3" runat="server" Title="Edit and Delete permissions" DoTranslation="true">
                <dwc:CheckBox runat="server" Label="Allow edit order for all users" Value="true" ID="AllowEditOrderForUsers" Name="/Globalsettings/Ecom/Order/AllowEditOrderForUsers" />
                <dwc:CheckBox runat="server" Label="Allow edit order price to exceed original order price" Value="true" ID="AllowExceedOriginalOrderPrice" Name="/Globalsettings/Ecom/Order/AllowExceedOriginalOrderPrice" />
                <dwc:CheckBox runat="server" Label="Disable delete button for orders" Value="true" ID="DisableDeleteButtonForOrders" Name="/Globalsettings/Ecom/Order/DisableDeleteButtonForOrders" />
                <dwc:CheckBox runat="server" Label="Disable delete button on shops, groups and products for non administrators" Value="true" ID="DisableDeleteGroupsAndProductsBtn4AllUsers" Name="/Globalsettings/Ecom/Product/DisableDeleteGroupsAndProductsBtn4AllUsers" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox1" runat="server" Title="Integration" DoTranslation="true">
                <dwc:CheckBox runat="server" Label="Disable creation of new product/variant" Value="true" ID="DisableCreationNewProductVariant" Name="/Globalsettings/Ecom/Integration/DisableCreationNewProductVariant" />
                <dwc:CheckBox runat="server" Label="Disable creation of new groups" Value="true" ID="DisableCreationNewGroups" Name="/Globalsettings/Ecom/Integration/DisableCreationNewGroups" />
                <dwc:CheckBox runat="server" Label="Edit group id" Value="true" ID="EditGroupId" Name="/Globalsettings/Ecom/Integration/EditGroupId" />
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>

     <%Translate.GetEditOnlineScript()%>
</asp:Content>
