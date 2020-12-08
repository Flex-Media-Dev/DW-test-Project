function initPage(options) {
    var page = SettingsPage.getInstance();
    var methods = getPrivateMethods(options);
    page.onSave = function () { return methods.save(false); };
    page.saveAndClose = function () { return methods.save(true); };
}

function getPrivateMethods(options) {
    return {
        save: function (close) {
            var ret = this.IsValid();
            if (ret) {
                var url = "?Save=true";
                if (close) {
                    url += "&Close=True";
                }
                var frm = $("MainForm");
                frm.action = url;
                frm.submit();
            }
            return ret;
        },

        IsValid: function () {
            var selectedSources = jQuery("input[name=PackagesSources]:checked");
            if (!selectedSources.length) {
                alert(options.messages.oneSourceShouldSelected);
                return false;
            }
            return true;
        }
    };
}