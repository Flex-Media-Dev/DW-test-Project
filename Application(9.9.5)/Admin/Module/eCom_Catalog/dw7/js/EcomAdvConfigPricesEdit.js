if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

if (typeof (Dynamicweb.Managment) == 'undefined') {
    Dynamicweb.Managment = {};
}

if (typeof (Dynamicweb.Managment.Ecom) == 'undefined') {
    Dynamicweb.Managment.Ecom = {};
}

if (typeof (Dynamicweb.Managment.Ecom.AdvConfig) == 'undefined') {
    Dynamicweb.Managment.Ecom.AdvConfig = {};
}

if (typeof (Dynamicweb.Managment.Ecom.AdvConfig.Prices) == 'undefined') {
    Dynamicweb.Managment.Ecom.AdvConfig.Prices = {};
    Dynamicweb.Managment.Ecom.AdvConfig.Prices.Forms = {};
    Dynamicweb.Managment.Ecom.AdvConfig.Prices.Forms.Main = Class.create({
        initialize: function (settings) {
            var that = this;
            var toolbar = SettingsPage.getInstance();
            toolbar.onSave = function () {
                that.save(toolbar.submit);
            };
            toolbar.onHelp = settings.help;

            this.translations = settings.translations;
            that.overlay = new overlay('__ribbonOverlay');
                        
            //hack due to there is no possibility to remove overlay if form doesn't valid
            var btnSave = $$('#cmdSave.toolbar-button')[0];
            btnSave.removeAttribute('onclick');
            btnSave.on('click', function() {
                toolbar.save();
            });

            var btnSaveAndClose = $$('#cmdSaveAndClose.toolbar-button')[0];
            btnSaveAndClose.removeAttribute('onclick');
            btnSaveAndClose.on('click', function() {
                toolbar.saveAndClose();
            });          
            
        },
        
        request: function (params, callback) {
            var that = this;
            if (!params) {
                params = {};
            }

            params['IsAjax'] = 'True';

            new Ajax.Request('/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigPrices_Edit.aspx', {
                method: 'POST',
                parameters: params,
                onCreate: function() {
                    that.overlay.show();
                },
                onSuccess: function(response) {
                    if (callback) {
                        callback(response.responseText);
                    }
                },
                onFailure: function() {
                    alert(that.translations['RequestError']);
                },
                onComplete: function () {
                    that.overlay.hide();
                }
            });
        },
        
        save: function (callback) {
            var that = this;
            that.overlay.show();

            if (callback) {
                callback();
            }

        }
    });
}