(function (ns) {
    var editor = {
        init: function (opts) {
            var self = this;
            self.options = opts;

            if (typeof (Dynamicweb.Controls) != 'undefined' && typeof (Dynamicweb.Controls.OMC) != 'undefined' && typeof (Dynamicweb.Controls.OMC.DateSelector) != 'undefined') {
                Dynamicweb.Controls.OMC.DateSelector.Global.set_offset({ top: -118, left: Prototype.Browser.IE ? 1 : 0 }); // Since the content area is fixed to screen at 118px from top 
            }

            var buttons = $$('.item-edit-field-group-button-collapse');
            for (var i = 0; i < buttons.length; i++) {
                Event.observe(buttons[i], 'click', function (e) {
                    var elm = this;
                    var collapsedContent = elm.up().next('.item-edit-field-group-content');
                    collapsedContent.toggleClassName('collapsed');
                    if (!collapsedContent.hasClassName('collapsed') && Dynamicweb.Controls.StretchedContainer) {
                        Dynamicweb.Controls.StretchedContainer.stretchAll();
                        if (Dynamicweb.Controls.StretchedContainer.Cache && Dynamicweb.Controls.StretchedContainer.Cache.updatePreviousDocumentSize) {
                            Dynamicweb.Controls.StretchedContainer.Cache.updatePreviousDocumentSize();
                        }
                    }
                });
            }
        },

        validation: function () {
            this._validation = this._validation || new Dynamicweb.Validation.ValidationManager();
            return this._validation;
        },

        validate: function (onComplete) {
            if (Dynamicweb.Items.GroupVisibilityRule) {
                Dynamicweb.Items.GroupVisibilityRule.get_current().filterValidators(this.validation()).beginValidate(onComplete);
            } else {
                this.validation().beginValidate(onComplete);
            };
        }
    };

    ns.createEditor = function (opts) {
        editor.init(opts);
        return editor;
    };
    ns.current = function (newEditor) {
        if (!Dynamicweb.Utilities.TypeHelper.isUndefined(newEditor)) {
            ns._editor = newEditor;
        }
        return ns._editor;
    };
    ns.validateItemFields = function (suppresItemValidation, fn) {
        var editor = ns.current();
        if (suppresItemValidation || !editor) {
            fn({ isValid: true });
        } else {
            editor.validate(fn);
        }
    };
})(Dynamicweb.Utilities.defineNamespace("Dynamicweb.UserManagement.ItemEditors"));