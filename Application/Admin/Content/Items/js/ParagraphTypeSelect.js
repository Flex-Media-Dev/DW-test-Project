if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.ParagraphTypeSelect = function () {
    this._parentPageId = 0;
    this._areaId = 1;
    this._pageId = 0;
    this._basedOn = '';
    this._templateId = 0;
    this._terminology = {};
    this._container = '';
    this._sortDirection = '';
    this._paragraphSortID = '';
    this._rowId = 0;
    this._columnId = 0;
    this._visualEditor = false;
};

Dynamicweb.Items.ParagraphTypeSelect._instance = null;

Dynamicweb.Items.ParagraphTypeSelect.get_current = function () {
    if (!Dynamicweb.Items.ParagraphTypeSelect._instance) {
        Dynamicweb.Items.ParagraphTypeSelect._instance = new Dynamicweb.Items.ParagraphTypeSelect();
    }

    return Dynamicweb.Items.ParagraphTypeSelect._instance;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_terminology = function () {
    return this._terminology;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_pageId = function () {
    return this._pageId;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_pageId = function (value) {
    this._pageId = parseInt(value);

    if (!this._pageId) {
        this._pageId = 0;
    }
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_parentPageId = function () {
    return this._parentPageId;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_parentPageId = function (value) {
    this._parentPageId = parseInt(value);

    if (!this._parentPageId) {
        this._parentPageId = 0;
    }
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_areaId = function () {
    return this._areaId;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_areaId = function (value) {
    this._areaId = parseInt(value);

    if (!this._areaId) {
        this._areaId = 1;
    }
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_basedOn = function () {
    return this._basedOn;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_basedOn = function (value) {
    this._basedOn = value;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_templateId = function () {
    return this._templateId;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_templateId = function (value) {
    this._templateId = value;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_container = function () {
    return this._container;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_container = function (value) {
    this._container = value;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_sortDirection = function () {
    return this._sortDirection;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_sortDirection = function (value) {
    this._sortDirection = value;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_paragraphSortID = function () {
    return this._paragraphSortID;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_paragraphSortID = function (value) {
    this._paragraphSortID = value;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_rowID = function () {
    return this._rowId;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_rowID = function (value) {
    this._rowId = value;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_columnID = function () {
    return this._columnId;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_columnID = function (value) {
    this._columnId = value;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.get_visualEditor = function () {
    return this._visualEditor;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.set_visualEditor = function (value) {
    this._visualEditor = value;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.onRowOver = function (row) {
    row.className = 'over';
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.onRowOut = function (row) {
    row.className = '';
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.newParagraph = function (basedOn, templateId) {
    var basedOnValue = '';
    var basedOnElement = null;
    var rowTemplate = document.getElementById('rowBasedOn');
    var chooseTemplateLabel = document.getElementById('ChosenTemplateName');

    this.set_basedOn(basedOn);
    this.set_templateId(templateId);

    var isChrome = !!window.chrome && !!window.chrome.webstore;
    if (isChrome) {
        event.preventDefault();
    }

    dialog.show('NewParagraphDialog');

    if (typeof (basedOn) != 'undefined' && basedOn != null) {
        basedOnElement = document.getElementById('BasedOn_' + basedOn);
    }

    if (basedOnElement != null) {
        basedOnValue = basedOnElement.text;
        basedOnValue += ' (' + this.get_terminology()['ItemType'] + ')';

        rowTemplate.style.visibility = 'visible';
        chooseTemplateLabel.style.visibility = 'visible';
        chooseTemplateLabel.innerHTML = basedOnValue;
    } else {
        chooseTemplateLabel.style.visibility = 'hidden';
        rowTemplate.style.visibility = 'hidden';
    }

    try {
        document.getElementById('ParagraphName').select();
    } catch (ex) { }
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.newParagraphSubmit = function () {
    var canSubmit = true;
    var basedOn = this.get_basedOn();
    var templateId = this.get_templateId() || 0;
    var paragraphNameElement = document.getElementById('ParagraphName');

    if (basedOn == null || (typeof (basedOn) == 'number' && basedOn <= 0) || (typeof (basedOn) == 'string' && !basedOn.length)) {
        basedOn = '';
    }

    if (!paragraphNameElement.value.length) {
        alert(this.get_terminology()['SpecifyParagraphName']);

        try {
            document.getElementById('ParagraphName').select();
        } catch (ex) { }

        canSubmit = false;
    } else {
        var o = new overlay('ribbonOverlay');
        o.show();
    }

    if (canSubmit) {
        dialog.hide('NewParagraphDialog');

        location.href = '/Admin/Content/Items/Editing/ParagraphTypeSelect.aspx?cmd=createparagraph&PageID=' + this.get_pageId() + '&ParentPageID=' + this.get_parentPageId() + '&AreaID=' + this.get_areaId() +
            '&BasedOn=' + basedOn + '&TemplateId=' + templateId +
            '&ParagraphName=' + encodeURIComponent(paragraphNameElement.value) + '&container=' + this.get_container() + '&ParagraphSortDirection=' + this.get_sortDirection() + '&ParagraphSortID=' + this.get_paragraphSortID() +
            '&Row=' + this.get_rowID() + '&Column=' + this.get_columnID() + (this.get_visualEditor() ? "&VisualEditor=true" : "");
    }
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.onParagraphTypeClick = function (basedOn) {
    this.newParagraph(basedOn);
    return false;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.onParagraphTemplateClick = function (templateId) {
    this.newParagraph(null, templateId);
    return false;
};

Dynamicweb.Items.ParagraphTypeSelect.prototype.initialize = function () {
    document.observe('dom:loaded', function () {
        $('ParagraphName').observe('keydown', function (e) {
            var code = e.keyCode || e.charCode || e.which;

            if (code == 13) { // Enter
                Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraphSubmit();
            }
        });
    });
};

