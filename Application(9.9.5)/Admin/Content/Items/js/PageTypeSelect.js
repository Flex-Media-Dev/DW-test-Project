if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.PageTypeSelect = function () {
    this._parentPageId = 0;
    this._areaId = 1;
    this._basedOn = '';
    this._terminology = {};
}

Dynamicweb.Items.PageTypeSelect._instance = null;

Dynamicweb.Items.PageTypeSelect.get_current = function () {
    if (!Dynamicweb.Items.PageTypeSelect._instance) {
        Dynamicweb.Items.PageTypeSelect._instance = new Dynamicweb.Items.PageTypeSelect();
    }

    return Dynamicweb.Items.PageTypeSelect._instance;
}

Dynamicweb.Items.PageTypeSelect.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Items.PageTypeSelect.prototype.get_parentPageId = function () {
    return this._parentPageId;
}

Dynamicweb.Items.PageTypeSelect.prototype.set_parentPageId = function (value) {
    this._parentPageId = parseInt(value);

    if (!this._parentPageId) {
        this._parentPageId = 0;
    }
}

Dynamicweb.Items.PageTypeSelect.prototype.get_areaId = function () {
    return this._areaId;
}

Dynamicweb.Items.PageTypeSelect.prototype.set_areaId = function (value) {
    this._areaId = parseInt(value);

    if (!this._areaId) {
        this._areaId = 1;
    }
}

Dynamicweb.Items.PageTypeSelect.prototype.get_basedOn = function () {
    return this._basedOn;
}

Dynamicweb.Items.PageTypeSelect.prototype.set_basedOn = function (value) {
    this._basedOn = value;
}

Dynamicweb.Items.PageTypeSelect.prototype.onRowOver = function (row) {
    row.className = 'over';
}

Dynamicweb.Items.PageTypeSelect.prototype.onRowOut = function (row) {
    row.className = '';
}

Dynamicweb.Items.PageTypeSelect.prototype.newPage = function (basedOn) {
    var basedOnValue = '';
    var basedOnElement = null;
    var rowTemplate = document.getElementById('rowBasedOn');
    var chooseTemplateLabel = document.getElementById('ChosenTemplateName');
    
    this.set_basedOn(basedOn);
    
    var isChrome = !!window.chrome && !!window.chrome.webstore;
    if (isChrome) {
        event.preventDefault();
    }

    dialog.show('NewPageDialog');

    if (typeof (basedOn) != 'undefined' && basedOn != null) {
        basedOnElement = document.getElementById('BasedOn_' + basedOn);
    }

    if (basedOnElement != null) {
        basedOnValue = basedOnElement.text;

        if (parseInt(basedOn) > 0) {
            basedOnValue += ' (' + this.get_terminology()['Template'] + ')';
        } else {
            basedOnValue += ' (' + this.get_terminology()['ItemType'] + ')';
        }
        
        rowTemplate.style.visibility = 'visible';
        chooseTemplateLabel.style.visibility = 'visible';
        chooseTemplateLabel.innerHTML = basedOnValue;
    } else {
        rowTemplate.style.visibility = 'hidden';
        chooseTemplateLabel.style.visibility = 'hidden';
    }

    try {
        document.getElementById('PageName').select();
    } catch (ex) { }
}

Dynamicweb.Items.PageTypeSelect.prototype.newPageSubmit = function () {
    var o = null;
    var canSubmit = true;
    var basedOn = this.get_basedOn();
    var pageNameElement = document.getElementById('PageName');

    if (basedOn == null || (typeof (basedOn) == 'number' && basedOn <= 0) || (typeof (basedOn) == 'string' && !basedOn.length)) {
        basedOn = '';
    }
    var val = Dynamicweb.Utilities.StringHelper.removeLineTerminators(pageNameElement.value);
    if (!val.length) {
        alert(this.get_terminology()['SpecifyPageName']);

        try {
            document.getElementById('PageName').select();
        } catch (ex) { }

        canSubmit = false;
    } else {
        o = new overlay('ribbonOverlay');

        o.message('');
        o.show();
    }
	
    var publishState = "published";
    if ($("PageOptions_2").checked) { // I just hate developers....
        publishState = "unpublished";
    }
    else if ($("PageOptions_3").checked) {
        publishState = "hideInMenu";
    }

    if (canSubmit) {
        dialog.hide('NewPageDialog');

        location.href = '/Admin/Content/Items/Editing/PageTypeSelect.aspx?cmd=createpage&ParentPageID=' + this.get_parentPageId() + '&AreaID=' + this.get_areaId() +
        '&BasedOn=' + basedOn + '&PageName=' + encodeURIComponent(val) + '&state=' + publishState;
    }
    //top.left.UpdatePageCount_Add(1);
}

Dynamicweb.Items.PageTypeSelect.prototype.onPageTypeClick = function (basedOn) {
    this.newPage(basedOn);
    return false;
}

Dynamicweb.Items.PageTypeSelect.prototype.initialize = function () {
    document.observe('dom:loaded', function () {
        $('PageName').observe('keydown', function (e) {
            var code = e.keyCode || e.charCode || e.which;

            if (code == 13) { // Enter
                Dynamicweb.Items.PageTypeSelect.get_current().newPageSubmit();
            }
        });
    });
}

