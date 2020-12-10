<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ProductPreview.aspx.vb" Inherits="Dynamicweb.Admin.ProductPreview" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title><%= Translate.Translate("Preview") %></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="false" IncludeScriptaculous="false" IncludeClientSideSupport="false" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <style>
        .header {
            background-color: #EDF5FF;
            padding: 10px;
            height: 52px;
        }

            .header .select-picker-ctrl label {
                margin-right: 5px;
                padding-top: 6px;
                display: inline-block;
                vertical-align: top;
            }

            .header .form-group {
                display: inline-block;
                vertical-align: top;
                margin-right: 10px;
            }

                .header .form-group:last-child {
                    margin-right: 0px;
                }

                .header .form-group .form-group-input {
                    display: inline-block;
                    vertical-align: top;
                }

        #ProductPreviewFrame {
            border: 0;
            position: fixed;
            top: 52px;
            bottom: 0;
            left: 0;
            right: 0;
            width: 100%;
            height: 100%;
        }
    </style>

    <script>
        function ProductPreviewPage(opts) {
            var options = opts;
            var frameEl = document.getElementById(options.ids.productPreviewFrame);
            var populateSelector = function (el, items, valueToSelect) {
                el.options.length = 0;
                var isValueToSelectExists = false;
                for (var i = 0; i < items.length; i++) {
                    var variantInfo = items[i];
                    el.options.add(new Option(variantInfo.Text, variantInfo.Id));
                    isValueToSelectExists = variantInfo.Id == valueToSelect;
                }
                if (isValueToSelectExists) {
                    el.value = valueToSelect;
                }
                else if (items.length) {
                    el.value = items[0].Id;
                }
            };

            return {
                init: function () {
                    var languageSelectorEl = document.getElementById(options.ids.productLanguage);
                    var variantSelectorEl = document.getElementById(options.ids.productVariant);
                    var publishStateSelectorEl = document.getElementById(options.ids.productPublishedState);
                    var self = this;
                    languageSelectorEl.addEventListener("change", function () {
                        var selectedLanguage = languageSelectorEl.value;
                        var variants = options.variantsByLanguages[selectedLanguage];
                        populateSelector(variantSelectorEl, variants, variantSelectorEl.value);
                        var url = self.getProductPreviewUrl(selectedLanguage, variantSelectorEl.value, publishStateSelectorEl ? publishStateSelectorEl.value : "");
                        self.preview(url);
                    });

                    variantSelectorEl.addEventListener("change", function () {
                        var url = self.getProductPreviewUrl(languageSelectorEl.value, variantSelectorEl.value, publishStateSelectorEl ? publishStateSelectorEl.value : "");
                        self.preview(url);
                    });
                    if (publishStateSelectorEl) {
                        publishStateSelectorEl.addEventListener("change", function () {
                            var url = self.getProductPreviewUrl(languageSelectorEl.value, variantSelectorEl.value, publishStateSelectorEl ? publishStateSelectorEl.value : "");
                            self.preview(url);
                        });
                    }
                },

                getProductPreviewUrl: function (languageId, variantId, showDraft) {
                    var url = "<%=OriginalProductPreviewUrl %>";
                    if (languageId) {
                        url += "&LanguageID=" + languageId;
                    }
                    if (variantId) {
                        if (variantId == "noVariants") {
                            variantId = "";
                        }

                        url += "&VariantID=" + variantId;
                    }
                    if (showDraft) {
                        url += "&Preview=" + showDraft;
                    }
                    return url;
                },

                preview: function (url) {
                    frameEl.src = url;
                }
            };
            }
    </script>
</head>
<body>
    <form runat="server">
        <div class="header">
            <dwc:SelectPicker runat="server" ID="ProductLanguage" Label="Language"></dwc:SelectPicker>
            <dwc:SelectPicker runat="server" ID="ProductVariant" Label="Extended variants"></dwc:SelectPicker>
            <dwc:SelectPicker runat="server" ID="ProductPublishedState" Label="Published state" Visible="false"></dwc:SelectPicker>
        </div>
        <iframe runat="server" id="ProductPreviewFrame" src=""></iframe>
    </form>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>