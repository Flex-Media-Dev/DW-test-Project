if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.ItemFieldTranslationsEdit = function () {
    this._terminology = {};
    this._initialized = false;
}

Dynamicweb.Items.ItemFieldTranslationsEdit._instance = null;

Dynamicweb.Items.ItemFieldTranslationsEdit.get_current = function () {
    if (!Dynamicweb.Items.ItemFieldTranslationsEdit._instance) {
        Dynamicweb.Items.ItemFieldTranslationsEdit._instance = new Dynamicweb.Items.ItemFieldTranslationsEdit();
    }

    return Dynamicweb.Items.ItemFieldTranslationsEdit._instance;
}

Dynamicweb.Items.ItemFieldTranslationsEdit.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Items.ItemFieldTranslationsEdit.prototype.initialize = function () {
    if (!this._initialized) {
        this._initialized = true;
    }
}

Dynamicweb.Items.ItemFieldTranslationsEdit.prototype.itemTypeChange = function () {
    var itemList = $("dItemList");
    var itemSelectedSystemName = itemList.options[itemList.selectedIndex].value;

    if (itemSelectedSystemName.length == 0) {
        location.href = "/Admin/Content/Management/Dictionary/TranslationKey_List.aspx?IsItemType=True";
    } else {
        location.href = "/Admin/Content/Management/Dictionary/TranslationKey_List.aspx?IsItemType=True&ItemTypeName=" + itemSelectedSystemName;
    }
}

Dynamicweb.Items.ItemFieldTranslationsEdit.prototype.addMissedTranslations = function () {
    var itemList = $("dItemList");
    var itemSelectedSystemName = itemList.options[itemList.selectedIndex].value;

    if (itemSelectedSystemName.length == 0) {
        location.href = "/Admin/Content/Management/Dictionary/TranslationKey_List.aspx?IsItemType=True";
    } else {
        location.href = "/Admin/Content/Management/Dictionary/TranslationKey_List.aspx?IsItemType=True&AddMissingTranslations=True&ItemTypeName=" + itemSelectedSystemName;
    }
}
