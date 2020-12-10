<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" ClientIDMode="Static" CodeBehind="CustomizedURLs_cpl.aspx.vb" Inherits="Dynamicweb.Admin.CustomizedURLs_cpl" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Configuration" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {
            page.submit();
        }

        function showHideProviders() {
            if (document.getElementById("ParseContentURLWithParams")) {
                if (document.getElementById("ParseContentURLWithParams").checked) {
                    document.getElementById("GroupUrlProviders").style.display = "none";
                    document.getElementById("FolderedQueryStringSettings").style.display = "";
                } else {
                    document.getElementById("GroupUrlProviders").style.display = "";
                    document.getElementById("FolderedQueryStringSettings").style.display = "none";
                }
            }
        }

        (function ($) {
            $(function () {
                var showHidePathParameters = function () {
                    if (this.value === 'Path') {
                        if ($("#ConvertModuleUrlsSettings")) {
                            $("#ConvertModuleUrlsSettings").show();
                        }
                        $("#GroupUrlProviders").show();
                        $("#UrlTypePathSettings").show();
                    } else {
                        if ($("#ConvertModuleUrlsSettings")) {
                            $("#ConvertModuleUrlsSettings").hide();
                        }

                        $("#GroupUrlProviders").hide();
                        $("#UrlTypePathSettings").hide();
                    }
                };

                var pathParametersEl = $('input:radio[name=\\/Globalsettings\\/System\\/Url\\/Type]');
                pathParametersEl.on("change", showHidePathParameters);
                $.each(pathParametersEl, function (index, item) {
                    if (item.checked) { showHidePathParameters.bind(item)(); }
                });

                function showHideProviders() {
                    if (document.getElementById("ParseContentURLWithParams")) {
                        if (document.getElementById("ParseContentURLWithParams").checked) {
                            document.getElementById("GroupUrlProviders").style.display = "none";
                            document.getElementById("FolderedQueryStringSettings").style.display = "";
                        } else {
                            document.getElementById("GroupUrlProviders").style.display = "";
                            document.getElementById("FolderedQueryStringSettings").style.display = "none";
                        }
                    }
                }
            });
        })(jQuery);
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">Web and HTTP</a></li>
            <li class="active"><%= Translate.Translate("Brugerdefinerede URLer")%></li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Brugerdefinerede URLer"></dwc:CardHeader>
        <dwc:CardBody runat="server">

            <dwc:GroupBox ID="GroupUrl" runat="server" Title="URL" GroupWidth="6">
                <dwc:RadioGroup runat="server" ID="RadioGroupUrlType" Name="/Globalsettings/System/Url/Type" Label="URL type">
                    <dwc:RadioButton runat="server" ID="UrlTypeNone" Label="Kun standard" FieldValue="None" />
                    <dwc:RadioButton runat="server" ID="UrlTypePath" Label="Placering og sidenavn" FieldValue="Path" />
                </dwc:RadioGroup>
                <div id="UrlTypePathSettings">
                    <dwc:CheckBox runat="server" ID="ExtensionLess" Name="/Globalsettings/System/Url/ExtensionLess" Label="Use extension less URL's (Do not include .aspx)" Visible="false" />
                    <dwc:CheckBox runat="server" ID="PlaceAllPagesInRoot" Name="/Globalsettings/System/Url/PlaceAllPagesInRoot" Label="Place all pages in root." />

                    <dwc:RadioGroup runat="server" ID="UrlInlcudeAreaType" Name="/Globalsettings/System/Url/UrlInlcudeAreaType">
                        <dwc:RadioButton runat="server" Label="Vis ikke" FieldValue="NoAreaName" />
                        <dwc:RadioButton runat="server" Label="Start med sproglagets navn" FieldValue="UseAreaNameInPath" />
                        <dwc:RadioButton runat="server" Label="Use ISO code from regional settings (i.e. en-GB)" FieldValue="UseAreaRegionalInPath" />
                    </dwc:RadioGroup>

                    <dwc:CheckBox runat="server" ID="UniqueForEachLanguage" Name="/Globalsettings/System/Url/UniqueForEachLanguage" Label="Ensure unique paths for each area" Info="Requires unique domain for each area<br/>WARNING: This can break links on your website." DoTranslate="false" />
                    <dwc:CheckBox runat="server" ID="UniqueForEachMasterWebsite" Name="/Globalsettings/System/Url/UniqueForEachMasterWebsite" Label="Group by master website" />
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupUrlProviders" runat="server" Title="Add ins" GroupWidth="6">
                <div id="UrlProviders" runat="server"></div>
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupSettings" runat="server" Title="Indstillinger" GroupWidth="6">
                <dwc:CheckBox runat="server" ID="ParseContentURL" Name="/Globalsettings/System/Url/ParseContentURL" Label="Brug brugerdefinerede URLer" />

                <%If SystemConfiguration.Instance.GetValue("/Globalsettings/System/Url/ParseContentURLWithParams") = "True" Then%>
                <div id="ConvertModuleUrlsSettings">
                    <%
                        If String.IsNullOrEmpty(SystemConfiguration.Instance.GetValue("/Globalsettings/System/Url/ParseContentURLWithParamsMethod")) Then
                            SystemConfiguration.Instance.SetValue("/Globalsettings/System/Url/ParseContentURLWithParamsMethod", "Slashes")
                        End If
                    %>
                    <dwc:CheckBox runat="server" ID="ParseContentURLWithParams" Name="/Globalsettings/System/Url/ParseContentURLWithParams" Label="Convert module URL's" />
                    <div id="FolderedQueryStringSettings" class="p-l-20">
                        <dwc:RadioButton runat="server" ID="ParseContentURLWithParamsMethod_Slashes" Name="/Globalsettings/System/Url/ParseContentURLWithParamsMethod" Label="Foldered querystring" FieldValue="Slashes" />
                        <dwc:RadioButton runat="server" ID="ParseContentURLWithParamsMethod_Encryption" Name="/Globalsettings/System/Url/ParseContentURLWithParamsMethod" Label="Encryption" FieldValue="Encryption" />
                    </div>
                </div>
                <%End If %>

                <dwc:CheckBox runat="server" ID="CaseInsensitive" Name="/Globalsettings/System/Url/CaseInsensitive" Label="Case insensitive URLs (Lower case)" Visible="false" Header="Formatering" />

                <%
                    Dim TrimSpaces As String = SystemConfiguration.Instance.GetValue("/Globalsettings/System/Url/TrimSpaces")
                    If TrimSpaces = "True" Then
                        SystemConfiguration.Instance.SetValue("/Globalsettings/System/Url/TrimSpaces", "Underscore")
                    ElseIf TrimSpaces <> "KeepSpaces" And TrimSpaces <> "Underscore" And TrimSpaces <> "Hyphen" Then
                        SystemConfiguration.Instance.SetValue("/Globalsettings/System/Url/TrimSpaces", "KeepSpaces")
                    End If
                %>

                <dwc:RadioGroup runat="server" ID="TrimSpaces" Name="/Globalsettings/System/Url/TrimSpaces" Label="" Visible="false">
                    <dwc:RadioButton runat="server" ID="TrimSpaces_KeepSpaces" Label="Keep spaces" FieldValue="KeepSpaces" />
                    <dwc:RadioButton runat="server" ID="TrimSpaces_Hyphen" Label="Erstat [Space] med [dash]" FieldValue="Hyphen" />
                    <dwc:RadioButton runat="server" ID="TrimSpaces_Underscore" Label="Erstat [Space] med [underscore]" FieldValue="Underscore" />
                </dwc:RadioGroup>
                <dwc:CheckBox runat="server" ID="ReplaceSlash" Name="/Globalsettings/System/Url/ReplaceSlash" Label="Replace [slash] with [dash] (/ -> -)" Visible="false" />
                <dwc:CheckBox runat="server" ID="LatinNormalize" Name="/Globalsettings/System/Url/LatinNormalize" Label="" />
                 <%If SystemConfiguration.Instance.GetValue("/Globalsettings/System/Url/LatinNormalize") = "True" Then%>
                    <dwc:InputTextArea runat="server" ID="LatinNormalizeCustomMappings" Name="/Globalsettings/System/Url/LatinNormalizeMappings" Label="Custom mappings" Info="List of custom character replacements. I.e ã:a will replace ã with a. Seperate with ; 'ã:a;ô:o" Rows="5"  />
                <%End If %>
                <dwc:CheckBox runat="server" ID="AmpEncode" Name="/Globalsettings/System/Url/AmpEncode" Label="Encode ampersand(&) in all links" Visible="false" />
                <dwc:CheckBox runat="server" ID="QueryStringToUnicode" Name="/Globalsettings/System/Url/QueryStringToUnicode" Label="Convert QueryString parameters to Unicode" Visible="false" />
                <dwc:CheckBox runat="server" ID="EnsureUniquePath" Name="/Globalsettings/System/Url/EnsureUniquePath" Label="Vidersend til link (301 Moved Permanently)" Header="Ensure unique path" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupeCommerce" runat="server" Title="eCommerce">
                <dwc:CheckBox runat="server" ID="UseStrictURLRecognition" Name="/Globalsettings/System/Url/UseStrictURLRecognition" Label="Use strict URL recognition" Info="Requires that the application pool runs in integrated pipeline mode" />
                <dwc:CheckBox runat="server" ID="UseCanonicalInEcommerce" Name="/Globalsettings/System/Url/UseCanonicalInEcommerce" Label="Canoncial link in meta" />
                <dwc:CheckBox runat="server" ID="Page404ForProductsNotInWebsiteShop" Name="/Globalsettings/System/Url/Page404ForProductsNotInWebsiteShop" Label="404 for products not in website shop" />
                <dwc:CheckBox runat="server" ID="Page404ForProductsNotInWebsiteLang" Name="/Globalsettings/System/Url/Page404ForProductsNotInWebsiteLang" Label="404 for products not in website language" />
                <dwc:CheckBox runat="server" ID="IncludeProductIdInUrlNames" Name="/Globalsettings/System/Url/IncludeProductIdInUrlNames" Label="Include product id in product url" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupMeta" runat="server" Title="Meta">
                <dwc:CheckBox runat="server" ID="UseCanoncial" Name="/Globalsettings/System/Url/UseCanoncial" Label="Canoncial link in meta" />
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>

    <script type="text/javascript">
        var objForm = document.getElementById('MainForm');
        var objFormElement = objForm.elements["/Globalsettings/System/Url/TypePageID/Prefix"]
        if (objFormElement) {
            if (objFormElement.value == "") {
                objFormElement.value = "Page";
            }
        }
        showHideProviders();
        //showHidePathParameters();

        if (document.getElementById("ParseContentURLWithParams")) {
            document.getElementById("ParseContentURLWithParams").onclick = function () { showHideProviders() };
        }
    </script>

    <%Translate.GetEditOnlineScript()%>
</asp:Content>
