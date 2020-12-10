(function (ns) {
    var editor = {
        init: function (opts) {
            var self = this;
            self.options = opts;
            self.matrixPane = $("FeeRulesMatrix");
            self.providersPane = $("div_Dynamicweb.Ecommerce.Cart.ShippingProvider_parameters").up(".ship-provider-selector");
            self.countrySelectorAllEl = $("country_mode_1");
            self.countrySelectorChooseEl = $("country_mode_2");
            self.countrySelectorCnt = $("country_rel_list_container");
            self.userSelectorAllEl = $("user_mode_1");
            self.userSelectorChooseEl = $("user_mode_2");
            self.userSelectorCnt = $("users_container");
            var isNew = window.location.href.indexOf("?") < 0;
            var methodSelectorEl = $("Dynamicweb.Ecommerce.Cart.ShippingProvider_AddInTypes");
            var useRulesFromProviderEl = $("FeeRulesSource_1");
            var useCustomFeeRulesEl = $("FeeRulesSource_2"); 
            var showShippingMatrix = function (show) {
                if (show) {
                    self.matrixPane.removeClassName("hide");
                } else {
                    self.matrixPane.addClassName("hide");
                }
            };
            var showProvidersPane = function (show) {
                if (show) {
                    useRulesFromProviderEl.disabled = true;
                    self.providersPane.addClassName("hide");
                    if (!useCustomFeeRulesEl.checked) {
                        useCustomFeeRulesEl.checked = true;
                        showShippingMatrix(true);
                    }
                } else {
                    useRulesFromProviderEl.disabled = false;
                    self.providersPane.removeClassName("hide");
                    var provider = methodSelectorEl.value;
                    if (isNew) {
                        if (provider.lastIndexOf("GLS") >= 0 || provider.lastIndexOf("Unifaun") >= 0 || provider.lastIndexOf("PostDanmark") >= 0) {
                            if (!useCustomFeeRulesEl.checked) {
                                useCustomFeeRulesEl.checked = true;
                                showShippingMatrix(true);
                            }
                        }
                        else {
                            useRulesFromProviderEl.checked = true;
                            showShippingMatrix(false);
                        }
                    }
                }
            };
            $(useRulesFromProviderEl).on("change", function () {
                showShippingMatrix(false);
            });
            $(useCustomFeeRulesEl).on("change", function () {
                showShippingMatrix(true);
            });
            showShippingMatrix(useCustomFeeRulesEl.checked);
            $(methodSelectorEl).on("change", function () {
                showProvidersPane(!$(this).value);
            });
            showProvidersPane(!methodSelectorEl.value);

            $("NameStr").focus();
            var hasUnchecked = self.countrySelectorCnt.select("input[type=checkbox][name=CR_CountryRel]").any(function (el) { return !el.checked; });
            if (hasUnchecked) {
                self.countrySelectorCnt.show();
                self.countrySelectorChooseEl.checked = true;
            } else {
                self.countrySelectorAllEl.checked = true;
            }

            self.countrySelectorAllEl.on("change", function () {
                self.countrySelectorCnt.hide();
            });
            self.countrySelectorChooseEl.on("change", function () {
                self.countrySelectorCnt.show();
            });

            var showUserSelector = !!($("AllowedGroups").value) || $("AllowAnonymousUsers").checked;
            if (showUserSelector) {
                self.userSelectorCnt.show();
                self.userSelectorChooseEl.checked = true;
            } else {
                self.userSelectorAllEl.checked = true;
            }

            self.userSelectorAllEl.on("change", function () {
                self.userSelectorCnt.hide();
            });
            self.userSelectorChooseEl.on("change", function () {
                self.userSelectorCnt.show();
            });
        },

        save: function (close) {
            if (this.validate()) {
                if (this.countrySelectorAllEl.checked) {
                    this.countrySelectorCnt.select("input[type=checkbox][name=CR_CountryRel]").each(function (el) {
                        el.checked = true;
                    });
                }
                document.getElementById("Close").value = close ? 1 : 0;
                document.getElementById('Form1').SaveButton.click();
            }
        },

        validate: function () {
            var isValid = true;
            var el = $("NameStr");
            var name = el.value;
            if (name.length === 0) {
                var err = $("errNameStr");
                err.style.display = "";
                el.focus();
                isValid = false;
            }
            return isValid;
        }
    };
    ns.initShippingMethodEditor = function (opts) {
        editor.init(opts);
        return editor;
    };
})(Dynamicweb.Utilities.defineNamespace("Dynamicweb.eCommerce.Shipping"));