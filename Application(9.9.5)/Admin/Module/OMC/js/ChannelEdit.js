if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.SMP) == 'undefined') {
    Dynamicweb.SMP = new Object();
}

Dynamicweb.SMP.ChannelEdit = {
    terminology: {},

    save: function (close) {
        this.removeUnloadEvent();
        if (!Toolbar.buttonIsDisabled('cmdSave') && this.validate()) {
            document.getElementById('Cmd').value = 'Save' + (close ? ',Close' : '');

            this.progress();
            this.submit();
        }
    },

    progress: function(cmd) {
        var o = new overlay('WaitSpinner');

        if (cmd == 'hide') {
            o.hide();
        } else {
            o.show();
        }
    },

    submit: function () {
        this.removeUnloadEvent();
        document.getElementById('ChannelForm').submit();
    },

    saveAndClose: function () {
        this.removeUnloadEvent();
        this.save(true);
    },

    cancel: function () {
        this.removeUnloadEvent();
        location.href = '/Admin/Module/OMC/Management/ChannelList.aspx';
    },

    deleteChannel: function () {
        this.removeUnloadEvent();
        if (confirm(this.terminology.DeleteConfirm)) {
            document.getElementById('Cmd').value = 'Delete,Close';
            ChannelForm.submit();
        }
    },

    validate: function () {
        var providerSelected = function (msg) {
            var result = true;
            var e = document.getElementById('Dynamicweb.Content.Social.Adapter_AddInTypes');

            if (!e.options[e.selectedIndex].value) {
                alert(msg);
                result = false;
            }

            return result;
        }

        var checkChannelName = function (msg) {
            var result = true;
            var e = document.getElementById('txChannelName');

            if (e.value.replace(/ /g,'').length == 0) {
                alert(msg);
                e.focus();
                result = false;
            }

            return result;
        }

        return IsControlValid(document.getElementById('txChannelName'), this.terminology.ChannelNameRequired) &&
            providerSelected(this.terminology.ProviderRequired) && checkChannelName(this.terminology.ChannelNameRequired);
    },

    beginAuthorize: function (url, substitutes) {
        var e = null;
        var v = null;
        var params = '';
        var fullUrl = url;
        
        if (substitutes) {
            for (var p in substitutes) {
                if (typeof (substitutes[p]) != 'undefined' && typeof (substitutes[p]) != 'function') {
                    v = substitutes[p];

                    if (v && v.length) {
                        if (v[0] == '#') {
                            e = document.getElementById(v.substr(1));
                            if (e) {
                                if (e.type && e.type == "checkbox") {
                                    e = e.checked;
                                } else {
                                    e = e.value;
                                }                                
                            }
                        } else {
                            e = v;
                        }

                        if (e) {
                            params += (p + '=' + encodeURIComponent(e) + '&');
                        }
                    }
                }
            }

            if (params && params.length) {
                params = params.substr(0, params.length - 1);
                fullUrl += (fullUrl.indexOf('?') >= 0 ? '&' : '?' + params);
            }
        }

        window.open(fullUrl);
    },

    showNotification: function (type, message) {
        var isVisible = false;
        var n = null, text = null;
        var notifications = $$('.notification');
        
        for (var i = 0; i < notifications.length; i++) {
            n = $(notifications[i]);
            isVisible = notifications[i].className.indexOf('notification-' + type) > 0;

            n.setStyle({ display: isVisible ? 'block' : 'none' });
            if (isVisible && message && message.length) {
                text = n.select('.infobar-text')[0];
                if (text) {
                    text.innerHTML = message;
                }
            }
        }
    },

    onSuccess: function () {
        this.showNotification('success');
    },

    onError: function (message) {
        this.showNotification('error', message);
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


