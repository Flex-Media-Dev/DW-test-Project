(function (ns) {
    // Translation keys list
    (function (nsTkl) {
        Object.extend(nsTkl, {
            initialize: function () {
                var designName = $('hDesignName').value;
                var isGlobal = $('hIsGlobal').value;
                var isItemType = $('hIsItemType').value;
                var list = $$('div.list');
                
                if (list != null && list.length > 0) {
                    list = $(list[0]);

                    list.observe('click', function (e) {
                        var keyName = '';
                        var elm = Event.element(e);
                        var row = elm.up('tr.listRow');

                        if (row != null) {
                            keyName = row.getAttribute('itemid');
                        }

                        if (keyName != "") {
                            var location = "";
                            keyName = encodeURIComponent(keyName);

                            if (isItemType.toLowerCase() == 'true') {
                                location = '/Admin/Content/Management/Dictionary/TranslationKey_Edit.aspx?IsItemType=true&DisallowNameEdit=true&KeyName=' + keyName;
                            } else if (isGlobal.toLowerCase() == 'true') {
                                location = '/Admin/Content/Management/Dictionary/TranslationKey_Edit.aspx?IsGlobal=true&KeyName=' + keyName;
                            } else if (isGlobal.toLowerCase() == 'false' && designName != "") {
                                location = '/Admin/Content/Management/Dictionary/TranslationKey_Edit.aspx?DesignName=' + designName + '&KeyName=' + keyName;
                            }

                            document.location.href = location;
                        }
                    });
                }
            },

            add: function () { 
                var designName = $('hDesignName').value;
                var isGlobal = $('hIsGlobal').value;
                var isItemType = $('hIsItemType').value;
                var location = "";
                
                if (isGlobal.toLowerCase() == 'true') {
                    location = '/Admin/Content/Management/Dictionary/TranslationKey_Edit.aspx?IsGlobal=true&IsNew=true';
                } else if (isGlobal.toLowerCase() == 'false' && designName != "") {
                    location = '/Admin/Content/Management/Dictionary/TranslationKey_Edit.aspx?DesignName=' + designName + '&IsNew=true';
                } else if (isItemType.toLowerCase() == 'true' && parent) {
                    location = '/Admin/Content/Management/Dictionary/TranslationKey_Edit.aspx?IsItemType=true&IsNew=true';
                } else {
                    location = '/Admin/Content/Management/Dictionary/TranslationKey_Edit.aspx?IsNew=true';
                }
                
                document.location.href = location;
            }
        });
    })(ns.TranslationKey_List = ns.TranslationKey_List || {});

    // Translation keys edit
    (function (nsTke) {
        Object.extend(nsTke, {
            initialize: function () {
                var isNew = $('hIsNew').value;
                if (isNew.toLowerCase() === "true") {
                    $('ErrKeyNameDelete').disabled = true;
                    $('cmdDelete').disabled = true;
                }
            },

            save: function (close) {
                var keyNameStr = $('KeyNameStr').value;
                var errKeyNameStr = $('ErrKeyNameStr');

                if (keyNameStr != "") {
                    document.getElementById("SubAction").value = close ? "close" : "";
                    document.getElementById('MainForm').SaveButton.click();
                } else {
                    errKeyNameStr.setStyle('display:inherit');
                }
            },

            delete: function () {
                var isNew = $('hIsNew').value;
                var errKeyNameDelete = $('ErrKeyNameDelete');

                if (isNew.toLowerCase() != "true") {
                    var confirmed = confirm($('confirmDelete').innerHTML);
                    if (confirmed == true) {
                        document.getElementById('MainForm').DeleteButton.click();
                    }
                } else {
                    errKeyNameDelete.setStyle('display:inherit');
                }
            },

            close: function () {
                document.getElementById('MainForm').CloseButton.click();
            }
        });
    })(ns.TranslationKey_Edit = ns.TranslationKey_Edit || {});

    // Translation keys reference
    (function (nsTkr) {
        Object.extend(nsTkr, {
            saveTranslations: function (close) {
                var o = new overlay('overlay'); o.show();
                document.getElementById('MainForm').SaveButton.value = close ? true : false;
                document.getElementById('MainForm').SaveButton.click();
            },

            add: function () {
                var designName = $('hDesignName').value;

                if (designName != "") {
                    document.location.href = '/Admin/Content/Management/Dictionary/TranslationKey_Edit.aspx?DesignName=' + designName + '&IsNew=true';
                }
            }
        });
    })(ns.TranslationKey_Reference = ns.TranslationKey_Reference || {});
})(window.Dictionary = window.Dictionary || {});
