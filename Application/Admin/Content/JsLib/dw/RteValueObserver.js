'use strict';
Dynamicweb = Dynamicweb || {};
Dynamicweb.Utilities = Dynamicweb.Utilities || {};


Dynamicweb.Utilities.RteElementObserver = Dynamicweb.Utilities.RteElementObserver || Class.create(Abstract.TimedObserver, {
    initialize: function ($super, fieldName, element, frequency, callback) {
        var self = this;
        this._tryListenRte = function () {
            if (!self._rte) {
                var tinyRte = typeof (tinymce) != 'undefined' ? tinymce.get(fieldName) : null;
                if (tinyRte) {
                    self._rte = tinyRte;
                    self._getVal = function () {
                        return self._rte.getContent();
                    };
                    self._rte.on("change", function () {
                        self.val = self._getVal();
                    });
                } else if (typeof (CKEDITOR) != 'undefined') {
                    self._rte = CKEDITOR.instances[fieldName];
                    if (self._rte) {
                        self._getVal = function () {
                            return self._rte.getData();
                        };
                        self._rte.on("change", function () {
                            self.val = self._getVal();
                        });
                    }
                } else if (typeof (FCKeditorAPI) != 'undefined') {
                    self._rte = FCKeditorAPI.Instances[fieldName];
                    if (self._rte) {
                        self._getVal = function () {
                            return self._rte.GetData();
                        };
                        self._rte.Events.AttachEvent("OnSelectionChange", function () {
                            self.val = self._getVal();
                        });
                    }
                }
            }
        };
        $super(element, frequency, callback);
        this.fieldName = fieldName;
        this.element = $(element);

        self.val = null;
        this.lastValue = this.getValue();
    },
    getValue: function () {
        this._tryListenRte();
        if (!this.timer && this._getVal) {
            return this._getVal();
        }
        return this.val;
    }
});
