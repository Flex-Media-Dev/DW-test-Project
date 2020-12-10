Dynamicweb.Items.ItemTypeUsage = function () {

    this._terminology = {};
    this._selectedItems = null;
    this._targetItemType = null;
};

Dynamicweb.Items.ItemTypeUsage._instance = null;

Dynamicweb.Items.ItemTypeUsage.get_current = function () {
    if (!Dynamicweb.Items.ItemTypeUsage._instance) {
        Dynamicweb.Items.ItemTypeUsage._instance = new Dynamicweb.Items.ItemTypeUsage();
    }

    return Dynamicweb.Items.ItemTypeUsage._instance;
};

Dynamicweb.Items.ItemTypeUsage.close = function (systemName) {
    if (!systemName) {
        location = "ItemTypeList.aspx";
    } else {
        location.href = '/Admin/Content/Items/ItemTypes/ItemTypeEdit.aspx?SystemName=' + systemName;
    }
};

Dynamicweb.Items.ItemTypeUsage.apply = function () {
    List._submitForm('List');
};

Dynamicweb.Items.ItemTypeUsage.openAreaEdit = function (areaID) {
    location = "/Admin/Content/Area/Edit.aspx?AreaID=" + areaID;
};

Dynamicweb.Items.ItemTypeUsage.openPageEdit = function (pageID) {
    location = "/Admin/Content/ParagraphList.aspx?PageID=" + pageID;
};

Dynamicweb.Items.ItemTypeUsage.openNamedListEdit = function (pageID, namedListId) {
    location = "/Admin/Content/Items/Editing/NamedItemListEdit.aspx?PageID=" + pageID + '&NamedItemList=' + namedListId;
};

Dynamicweb.Items.ItemTypeUsage.openParagraphEdit = function (paragraphID) {
    location = "/Admin/Content/ParagraphEdit.aspx?ID=" + paragraphID;
};

Dynamicweb.Items.ItemTypeUsage.openUserEdit = function (userID) {
    location = "/Admin/Module/Usermanagement/EditUser.aspx?UserID=" + userID;
};

Dynamicweb.Items.ItemTypeUsage.openUserGroupEdit = function (groupID) {
    location = "/Admin/Module/Usermanagement/EditGroup.aspx?ExternalMode=True&ID=" + groupID;
};

Dynamicweb.Items.ItemTypeUsage.onContextMenuView = function (sender, arg) {
    var view = "common";

    var row = List.getRowByID('ItemTypeUsageList', arg.callingID);
    var rows = Dynamicweb.Items.ItemTypeUsage.get_current().getSelectedItems();
    var selectedItem = document.getElementById('SelectedSystemName').value

    if (rows.indexOf(',') >= 0) {
        if (selectedItem) {
            view = "none";
        }
        else {
            if (row && row.hasClassName("selected")) {
                view = "selection";
            }
            else {
                view = "mixed";
            }
        }
    }

    return view;
};

Dynamicweb.Items.ItemTypeUsage.treeReload = function () {
    var src = top.right.location.href;
    if (src.endsWith('#')) {
        src = src.substr(0, src.length - 1);
    }

    var params = src.toQueryParams();
    if (params.OpenTo) {
        src = src.replace("OpenTo=" + encodeURIComponent(params.OpenTo), "OpenTo=" + encodeURIComponent("ContentTypes"));
        src = src.replace("OpenTo=" + params.OpenTo, "OpenTo=" + encodeURIComponent("ContentTypes"));
    }
    else
        src = src + "?OpenTo=" + encodeURIComponent("ContentTypes");

    top.right.location.href = src;
};

Dynamicweb.Items.ItemTypeUsage.prototype.onFilterChange = function (event, element) {
    var disable = false;
    if (element == this.usedInListFilter && this.usedInListFilter.value == 'ItemList') {
        disable = true;
        this.areaListFilter.value = this.areaListFilterDefValue;
    }

    if (disable) {
        this.areaListFilter.writeAttribute('disabled', 'disabled');
    } else {
        this.areaListFilter.removeAttribute('disabled');
    }
};

Dynamicweb.Items.ItemTypeUsage.prototype.get_terminology = function () {
    return this._terminology;
};

Dynamicweb.Items.ItemTypeUsage.prototype.openEditDialog = function (systemName) {
    location.href = '/Admin/Content/Items/ItemTypes/ItemTypeEdit.aspx?SystemName=' + encodeURIComponent(systemName || '');
};

Dynamicweb.Items.ItemTypeUsage.prototype.getSelectedItems = function () {
    var ret = '';
    var prevstr = $('SelectedItems').value;
    var allitems = eval("[" + prevstr + "]");

    for (var i = 0; i < allitems.length; i++) {
        var row = List.getRowByID('ItemTypeUsageList', allitems[i].id.toString());
        if (!row.readAttribute) {
            ret += allitems[i].itemid + ',';
        }
    }

    var rows = List.getSelectedRows('ItemTypeUsageList');
    if (rows != null && rows.length > 0) {
        for (var i = 0; i < rows.length; i++) {
            ret += rows[i].readAttribute("itemid") + ',';
        }
    } else if (!ret) {
        ret = ContextMenu.callingItemID;
    }

    ret = ret.replace(/,+$/, '');
    this._selectedItems = ret;

    return ret;
};

Dynamicweb.Items.ItemTypeUsage.prototype.clearSelectedItems = function () {
    $('SelectedItems').value = "";
    var rows = List.getSelectedRows('ItemTypeUsageList');
    if (rows != null && rows.length > 0) {
        for (var i = 0; i < rows.length; i++) {
            List.setRowSelected("ItemTypeUsageList", rows[i], false);
        }
    }
};

Dynamicweb.Items.ItemTypeUsage.prototype.initiatePostBack = function (action, id, argument) {
    var f = document.getElementById('MainForm');
    var postBackField = document.getElementById('PostBackAction');
    var postBackArgument = document.getElementById('PostBackArgument');
    var itemSystemNames = document.getElementById('ItemSystemNames');

    if (!f && document.forms.length > 0) {
        f = document.forms[0];
    }

    if (postBackField)
        postBackField.value = action;

    if (postBackArgument) {
        postBackArgument.value = argument || '';
    }

    if (itemSystemNames && typeof (id) != 'undefined')
        itemSystemNames.value = id;

    f.submit();
};

Dynamicweb.Items.ItemTypeUsage.prototype.initiateAsyncPostBack = function (action, id, argument) {
    new Ajax.Request('/Admin/Content/Items/ItemTypes/ItemTypeUsage.aspx', {
        method: 'post',
        parameters: {
            "IsAsync": true,
            "PostBackAction": action,
            "ItemSystemNames": id,
            "PostBackArgument": argument || ''
        },
        onSuccess: function (response) {
            Dynamicweb.Items.ItemTypeUsage.treeReload();
        }
    });
};

Dynamicweb.Items.ItemTypeUsage.prototype.initialize = function () {
    var list = $$('div.list');

    this.itemTypeListFilter = $$('#ItemTypeDropDownListFilter select')[0];
    this.itemTypeListFilterDefValue = $('ItemTypeListFilterDefaultValue').value;

    this.areaListFilter = $$('#AreaDropDownListFilter select')[0];
    this.areaListFilterDefValue = $('AreaListFilterDefaultValue').value;

    this.usedInListFilter = $$('#UsedInListFilter select')[0];
    this.usedInListFilterDefValue = $('UsedInListFilterDefaultValue').value;

    document.on('change', 'div.filters select', this.onFilterChange.bind(this));

    if (list != null && list.length > 0) {
        list = $(list[0]);

        list.observe('click', function (e) {
            var itemSystemName = '';
            var elm = Event.element(e);
            var row = elm.up('tr.listRow');
            var tagName = elm.tagName.toLowerCase();

            if (row != null) {
                itemSystemName = $(row).readAttribute('itemID');
            }

            if (itemSystemName) {
                if (tagName !== 'img' && tagName !== 'a') {
                    Dynamicweb.Items.ItemTypeUsage.get_current().openEditDialog(itemSystemName);
                }
                else {
                    return true;
                }
            }
        });
    }
};

