/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = {};
}

if (typeof (Dynamicweb.Controls.ProductListBox) == 'undefined') {
    Dynamicweb.Controls.ProductListBox = {};
}

/* ++++++ End: Registering namespace ++++++ */

/* ++++++ ProductListBox Manager ++++++ */

if (typeof (Dynamicweb.Controls.ProductListBox.Manager) === 'undefined') {

    Dynamicweb.Controls.ProductListBox.Manager = function () {
        this._providers = new Dynamicweb.Ajax.Hash();
    };

    Dynamicweb.Controls.ProductListBox.Manager.prototype.set_provider = function (id, instance) {
        this._providers.set(id, instance);
    }

    Dynamicweb.Controls.ProductListBox.Manager.prototype.get_provider = function (id) {
        return this._providers.get(id);
    }

    Dynamicweb.Controls.ProductListBox.Manager.prototype.remove_provider = function (id) {
        return this._providers.unset(id);
    }

    Dynamicweb.Controls.ProductListBox.Manager.prototype.clear = function () {
        this._providers = new Dynamicweb.Ajax.Hash();
    }

    Dynamicweb.Controls.ProductListBox.Manager._instance = null;

    Dynamicweb.Controls.ProductListBox.Manager.get_current = function () {
        if (!Dynamicweb.Controls.ProductListBox.Manager._instance) {
            Dynamicweb.Controls.ProductListBox.Manager._instance = new Dynamicweb.Controls.ProductListBox.Manager();
        }

        return Dynamicweb.Controls.ProductListBox.Manager._instance;
    }
}

/* ++++++ End: ProductListBox Manager ++++++ */

/* ++++++ ProductListBox Provider ++++++ */

Dynamicweb.Controls.ProductListBox.Provider = function () {
    /// <summary>Represents a product selection provider.</summary>

    this._id = '';
    this._languageId = '';
    this._shopId = '';
    this._onlyGroups = false;
    this._onlyProducts = true;
};

Dynamicweb.Controls.ProductListBox.Provider.prototype.set_id = function (id) {
    this._id = id;
};

Dynamicweb.Controls.ProductListBox.Provider.prototype.set_languageId = function (value) {
    this._languageId = value;
};

Dynamicweb.Controls.ProductListBox.Provider.prototype.get_languageId = function () {
    return this._languageId;
};

Dynamicweb.Controls.ProductListBox.Provider.prototype.set_shopId = function (value) {
    this._shopId = value;
};

Dynamicweb.Controls.ProductListBox.Provider.prototype.get_shopId = function () {
    return this._shopId;
};

Dynamicweb.Controls.ProductListBox.Provider.prototype.set_onlyGroups = function (value) {
    this._onlyGroups = value;
    if (value) this._onlyProducts = false;
};

Dynamicweb.Controls.ProductListBox.Provider.prototype.set_onlyProducts = function (value) {
    this._onlyProducts = value;
    if (value) this._onlyGroups = false;
};

Dynamicweb.Controls.ProductListBox.Provider.prototype.select = function (options) {
    // Changed selector to only allow products to be selected.
    // To reintroduce group selector, remove the following line:
    // 'onlyproducts=True',
    var self = this,
        caller = encodeURIComponent("opener.Dynamicweb.Controls.ProductListBox.Manager.get_current().get_provider('" + this._id + "')"),
        query = [
            'cmd=ProductsAndGroupsSelector',
            'caller=' + caller,
            'onlygroups=' + this._onlyGroups,
            'onlyproducts=' + this._onlyProducts,
            'showSearches=False',
            'SetLanguageID=' + this.get_languageId(),
            'MasterShopID=' + this.get_shopId()
        ];

    if (options && options.callback) {
        self.value = '';
        self.addProduct = function (id, name, image, container) {
            id = id.replace(',', ':');
            options.callback({ value: id, text: name, icon: image });
        };
    }

    window.open('/Admin/Module/eCom_Catalog/dw7/Edit/EcomGroupTree.aspx?' + query.join('&'), "", "displayWindow,width=460,height=400,scrollbars=no");
};

/* ++++++ End: ProductListBox Provider ++++++ */