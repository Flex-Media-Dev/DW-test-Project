<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomProductRelatedLimitations_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomProductRelatedLimitations_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>

<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        function toggleLanguages() {
            toggleFilterItem("gbLanguages");
        }

        function toggleCountries() {
            toggleFilterItem("gbCountries");
        }

        function toggleShops() {
            toggleFilterItem("gbShops");
        }

        function toggleVariants() {
            toggleFilterItem("gbVariants");
        }

        function toggleFilterItem(filterGroupPanelId) {
            var filterGroupPanel = document.getElementById(filterGroupPanelId);
            if (!filterGroupPanel) {
                return;
            }
            var groupCnt = filterGroupPanel.querySelector(".dw-ctrl.checkboxgroup-ctrl");
            if (filterGroupPanel.querySelector("input[type=radio][value=choose]").checked) {
                groupCnt.show();
            } else {
                groupCnt.hide();
            }
        }

        window.addEventListener("load", function () {
            var frame = window.frameElement;
            if (frame) {
                var container = frame.closest("div#RelatedLimitationDialog");
                parent.dialog.set_okButtonOnclick(container, function () {
                    document.getElementById('MainForm').submit();
                });
            }

            toggleLanguages();
            toggleCountries();
            toggleShops();
            toggleVariants();
        });
    </script>
    <style type="text/css">
        .dw-ctrl.checkboxgroup-ctrl > .form-group-input {
            margin-left: 180px;
        }
    </style>
</head>
<body class="area-pink">
    <form id="MainForm" runat="server">
        <div class="content">
            <div class="form-container">
                <dwc:GroupBox ID="gbVariants" Title="Variants" runat="server">
                    <dwc:RadioGroup runat="server" ID="VariantsRadio" Name="VariantsRadio" Indent="false" Label="Apply to">
                        <dwc:RadioButton runat="server" Label="All" FieldValue="all" OnClick="toggleVariants()" />
                        <dwc:RadioButton runat="server" Label="Selected" FieldValue="choose"  OnClick="toggleVariants()" />
                    </dwc:RadioGroup>
                    <dwc:CheckBoxGroup runat="server" ID="SelectedVariants" Name="SelectedVariants"></dwc:CheckBoxGroup>
                </dwc:GroupBox>
                <dwc:GroupBox ID="gbLanguages" Title="Languages" runat="server">
                    <dwc:RadioGroup runat="server" ID="LanguageRadio" Name="LanguageRadio" Indent="false" Label="Apply to">
                        <dwc:RadioButton runat="server" Label="All" FieldValue="all" OnClick="toggleLanguages()" />
                        <dwc:RadioButton runat="server" Label="Selected" FieldValue="choose"  OnClick="toggleLanguages()" />
                    </dwc:RadioGroup>
                    <dwc:CheckBoxGroup runat="server" ID="SelectedLanguages" Name="SelectedLanguages"></dwc:CheckBoxGroup>
                </dwc:GroupBox>
                <dwc:GroupBox ID="gbCountries" Title="Countries" runat="server">
                    <dwc:RadioGroup runat="server" ID="CountryRadio" Name="CountryRadio" Indent="false" Label="Apply to">
                        <dwc:RadioButton runat="server" Label="All" FieldValue="all" OnClick="toggleCountries()" />
                        <dwc:RadioButton runat="server" Label="Selected" FieldValue="choose"  OnClick="toggleCountries()" />
                    </dwc:RadioGroup>
                    <dwc:CheckBoxGroup runat="server" ID="SelectedCountries" Name="SelectedCountries"></dwc:CheckBoxGroup>
                </dwc:GroupBox>
                <dwc:GroupBox ID="gbShops" Title="Shops" runat="server">
                    <dwc:RadioGroup runat="server" ID="ShopRadio" Name="ShopRadio" Indent="false" Label="Apply to">
                        <dwc:RadioButton runat="server" Label="All" FieldValue="all" OnClick="toggleShops()" />
                        <dwc:RadioButton runat="server" Label="Selected" FieldValue="choose"  OnClick="toggleShops()" />
                    </dwc:RadioGroup>
                    <dwc:CheckBoxGroup runat="server" ID="SelectedShops" Name="SelectedShops"></dwc:CheckBoxGroup>
                </dwc:GroupBox>
            </div>
        </div>
    </form>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
