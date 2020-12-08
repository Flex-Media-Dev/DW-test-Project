var Dynamicweb = Dynamicweb || {};
Dynamicweb.ExternalLogin = Dynamicweb.ExternalLogin || {};

(function ($) {
    Dynamicweb.ExternalLogin.ProviderEdit = {
        page: SettingsPage.getInstance(),
        terminology: {},

        save: function (close) {
            this.removeUnloadEvent();
            if (!Toolbar.buttonIsDisabled('cmdSave') && this.validate()) {
                document.getElementById('Cmd').value = 'Save' + (close ? ',Close' : '');

                this.submit();
                this.progress();
            } else {
                return false;
            }
        },

        progress: function (cmd) {
            var o = new overlay('wait');

            if (cmd == 'hide') {
                o.hide();
            } else {
                o.show();
            }
        },

        submit: function () {
            this.removeUnloadEvent();
            this.page.submit();
        },

        saveAndClose: function () {
            this.removeUnloadEvent();
            this.save(true);
        },

        cancel: function () {
            this.removeUnloadEvent();
            location.href = '/Admin/Content/Management/Pages/ExternalLoginProvidersList.aspx';
        },

        deleteProvider: function () {
            this.removeUnloadEvent();
            if (confirm(this.terminology.DeleteConfirm)) {
                document.getElementById('Cmd').value = 'Delete,Close';
                MainForm.submit();
            }
        },

        validate: function () {
            var providerSelected = function (msg) {
                var result = true;
                var providerAddInType = $("button[data-id='Dynamicweb.Security.UserManagement.ExternalAuthentication.ExternalLoginProvider_AddInTypes']");

                if (providerAddInType.next().find("ul li:first").hasClass("selected")) {
                    alert(msg);
                    result = false;
                }
                return result;
            };
            var providerName = $('#txtProviderName');
            if (!providerName.val()) {
                dwGlobal.showControlErrors('txtProviderName', this.terminology.ProviderNameRequired);
                return false;
            } else {
                return providerSelected(this.terminology.ProviderRequired);
            }
        },

        afterEditorChanged: function () {
            var createLocalAccountWithoutPageClick = function () {
                var parent = $('#CreateLocalAccountWithoutPage').parent().parent();
                if (parent) {
                    if ($('#CreateLocalAccountWithoutPage').is(':checked')) {
                        parent.prev("div").hide();
                        parent.next("div").show();
                    } else {
                        parent.prev("div").show();
                        parent.next("div").hide();
                    }
                }
            };
            if ($('#CreateLocalAccountWithoutPage').length) {
                createLocalAccountWithoutPageClick();
                $('#CreateLocalAccountWithoutPage').click(function () {
                    createLocalAccountWithoutPageClick();
                });
            }
        },

        showLeaveConfirmation: function () {
            window.onbeforeunload = function () {
                return "This page is asking you to confirm that you want to leave - data you have entered may not be saved.";
            };
        },

        removeUnloadEvent: function () {
            window.onbeforeunload = null;
        }
    };


})(jQuery);
