if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Items) == 'undefined') {
    Dynamicweb.Items = new Object();
}

Dynamicweb.Items.ItemEdit = function () {
    this._terminology = {};
    this._cancelUrl = '';
    this._page = {};
    this._item = {};
    this._validation = null;
    this._validationPopup = null;
}

Dynamicweb.Items.ItemEdit._instance = null;

Dynamicweb.Items.ItemEdit.get_current = function () {
    if (!Dynamicweb.Items.ItemEdit._instance) {
        Dynamicweb.Items.ItemEdit._instance = new Dynamicweb.Items.ItemEdit();
    }

    return Dynamicweb.Items.ItemEdit._instance;
}

Dynamicweb.Items.ItemEdit.prototype.get_validation = function () {
    if (!this._validation) {
        this._validation = new Dynamicweb.Validation.ValidationManager();
    }

    return this._validation;
}

Dynamicweb.Items.ItemEdit.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Items.ItemEdit.prototype.get_validationPopup = function () {
    if (this._validationPopup && typeof (this._validationPopup) == 'string') {
        this._validationPopup = eval(this._validationPopup);
    }

    return this._validationPopup;
}

Dynamicweb.Items.ItemEdit.prototype.set_validationPopup = function (value) {
    this._validationPopup = value;
}

Dynamicweb.Items.ItemEdit.prototype.get_cancelUrl = function () {
    return this._cancelUrl;
}

Dynamicweb.Items.ItemEdit.prototype.set_cancelUrl = function (value) {
    this._cancelUrl = value;
}

Dynamicweb.Items.ItemEdit.prototype.get_page = function () {
    return this._page;
}

Dynamicweb.Items.ItemEdit.prototype.set_page = function (value) {
    this._page = value;
}

Dynamicweb.Items.ItemEdit.prototype.get_item = function () {
    return this._item;
}

Dynamicweb.Items.ItemEdit.prototype.set_item = function (value) {
    this._item = value;
}

Dynamicweb.Items.ItemEdit.prototype.set_showCancelWarn = function (value) {
    this._showCancelWarn = value;
}

Dynamicweb.Items.ItemEdit.prototype.get_showCancelWarn = function () {
    return this._showCancelWarn;
}


Dynamicweb.Items.ItemEdit.prototype.initialize = function () {
    setTimeout(function () {
        if (typeof (Dynamicweb.Controls) != 'undefined' && typeof (Dynamicweb.Controls.OMC) != 'undefined' && typeof (Dynamicweb.Controls.OMC.DateSelector) != 'undefined') {
            Dynamicweb.Controls.OMC.DateSelector.Global.set_offset({ top: -138, left: Prototype.Browser.IE ? 1 : 0 }); // Since the content area is fixed to screen at 138px from top (Edititem.css)
        }
    }, 500);

    var div = $$('.item-type-container');
    if (div.length > 0) {
        div[0].up().setStyle({ paddingLeft: '0px' });
    }
    var self = this;
    self.btnNavigation = false;
    window.addEventListener('beforeunload', function onbeforeunload(e) {
        if (!self.btnNavigation && self.get_showCancelWarn()) {
            setTimeout(function () { /* hack to restore prev state, DON"T REMOVE setTimeout */
                self._restoreStateWhenCancel();
            }, 1);
            e.returnValue = self.get_terminology()['CancelWarnText'];
            return e.returnValue
        }
        self.btnNavigation = false;
    });
}

Dynamicweb.Items.ItemEdit.prototype._restoreStateWhenCancel = function() {
    if (this._activeRedirectAction == "switchToParagraphs") {
        Ribbon.deactivateButton("cmdViewParagraphs");
        Ribbon.activateButton("cmdViewItem");
    }
    this._activeRedirectAction = null;

    var screenLoader = document.getElementById("screenLoaderOverlay");
    if (screenLoader) {
        screenLoader.style.display = "none";
    }
}

Dynamicweb.Items.ItemEdit.prototype.showItem = function () {
    window.open('/Default.aspx?ID=' + this.get_page().id + '&Purge=True', 'ItemWindow');
}

Dynamicweb.Items.ItemEdit.prototype.pageProperties = function () {
    this.btnNavigation = true;
    this.showWait();
    location = '/Admin/Content/Page/PageEdit.aspx?ID=' + this.get_page().id;
}

Dynamicweb.Items.ItemEdit.prototype.setPagePublished = function (state) {
    if (!state || !state.length) state = 'published';

    var url = '/Admin/Content/ParagraphList.aspx?cmd=publish&state=' + state + '&PageID=' + this.get_page().id;

    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function (transport) {
            if (transport && transport.responseJSON) {
                var page = transport.responseJSON;
                dwGlobal.getContentNavigator().refreshNode(page.parentNodeId, page.nodeId);
            }
        }
    });
}

Dynamicweb.Items.ItemEdit.prototype.pageMetadata = function () {
    dialog.show('MetaDialog');
}

Dynamicweb.Items.ItemEdit.prototype.saveAsTemplate = function () {
    dialog.show("SaveAsTemplateDialog");
}

Dynamicweb.Items.ItemEdit.prototype.SaveAsTemplateOk = function () {
    var isTemplate = "true";
    if (document.getElementById("isTemplate")) {
        isTemplate = document.getElementById("isTemplate").checked.toString();
    }
    this.btnNavigation = true;
    location = '/Admin/Content/Items/Editing/ItemEdit.aspx?PageID=' + this.get_page().id + '&ItemID' + this.get_item().id +
        '&cmd=saveastemplate&TemplateName=' + encodeURI(document.getElementById("TemplateName").value) + '&TemplateDescription=' + encodeURI(document.getElementById("TemplateDescription").value + "&isTemplate=" + isTemplate);
}

Dynamicweb.Items.ItemEdit.prototype.SaveAsTemplateCancel = function () {
    dialog.hide("SaveAsTemplateDialog");
}

Dynamicweb.Items.ItemEdit.prototype.showValidationResults = function () {
    this.get_validationPopup().set_contentUrl('/Admin/Content/PageValidate.aspx?ID=' + this.get_page().id);
    this.get_validationPopup().show();
}

Dynamicweb.Items.ItemEdit.prototype.validate = function (onComplete) {
    Dynamicweb.Items.GroupVisibilityRule.get_current().filterValidators(this.get_validation()).beginValidate(onComplete);
}

Dynamicweb.Items.ItemEdit.prototype.save = function (close) {
    var self = this;
    self.btnNavigation = true;

    this.validate(function (result) {
        self.showWait();
        if (result.isValid) {
            // Fire event to handle saving
            window.document.fire("General:DocumentOnSave");

            $('hClose').value = (!!close).toString();
            var form = $("MainForm");
            if (typeof form.onsubmit == 'function') {
                 form.onsubmit();
            };
            form.submit();
        }
        new overlay('PleaseWait').hide();
    });
}

Dynamicweb.Items.ItemEdit.prototype.saveAndClose = function () {
    this.save(true);
}

Dynamicweb.Items.ItemEdit.prototype.cancel = function () {
    this.btnNavigation = true;
    location.href = this.get_cancelUrl();
}

Dynamicweb.Items.ItemEdit.prototype.showWait = function () {
    new overlay('PleaseWait').show();
}

Dynamicweb.Items.ItemEdit.prototype.masterComparePage = function (masterid, languageid) {
    window.open("/Admin/Content/Page/PageCompare.aspx?lang=True&original=/Default.aspx?ID=" + masterid + "&draft=/Default.aspx?ID=" + languageid);
}

Dynamicweb.Items.ItemEdit.prototype.pageMetadataClose = function () {
    HideCounter();

    dialog.hide('MetaDialog');
}

Dynamicweb.Items.ItemEdit.prototype.pageMetadataSave = function () {
    var keywords = encodeURIComponent(document.getElementById('PageKeywords').value);
    var title = encodeURIComponent(document.getElementById('PageDublincoreTitle').value);
    var description = encodeURIComponent(document.getElementById('PageDescription').value);

    dialog.hide('MetaDialog');
    this.btnNavigation = true;
    location = '/Admin/Content/Items/Editing/ItemEdit.aspx?PageID=' + this.get_page().id + '&ItemID' + this.get_item().id + 
        '&cmd=SaveMeta&PageMetaTitle=' + title + '&PageMetaKeywords=' + keywords + '&PageMetaDescription=' + description;
}


Dynamicweb.Items.ItemEdit.prototype.switchToParagraphs = function () {
    this._activeRedirectAction = "switchToParagraphs";
    location = '/Admin/Content/ParagraphList.aspx?PageID=' + this.get_page().id + '&mode=viewParagraphs';
}

Dynamicweb.Items.ItemEdit.prototype.openFrontendEditing = function () {
    window.open("/Admin/Content/FrontendEditing/FrontendEditing.aspx?PageID=" + this.get_page().id);
}

function toggleValidationInProgress(show) { /* Legacy declaration */ }

/* Version control */

Dynamicweb.Items.VersionControl = function () {
    this._hasUnpublishedContent = false;
    this._page = {};
    this._terminology = {};
}

Dynamicweb.Items.VersionControl._instance = null;

Dynamicweb.Items.VersionControl.get_current = function () {
    if (!Dynamicweb.Items.VersionControl._instance) {
        Dynamicweb.Items.VersionControl._instance = new Dynamicweb.Items.VersionControl();
    }

    return Dynamicweb.Items.VersionControl._instance;
}

Dynamicweb.Items.VersionControl.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Items.VersionControl.prototype.get_page = function () {
    return this._page;
}

Dynamicweb.Items.VersionControl.prototype.set_page = function (value) {
    this._page = value;
}

Dynamicweb.Items.VersionControl.prototype.useDraft = function () {
    if (this._hasUnpublishedContent) {
        dialog.show("QuitDraftDialog");
    }
    else {
        this.toggleDraft();
    }
}

Dynamicweb.Items.VersionControl.prototype.toggleDraft = function () {
    Dynamicweb.Items.ItemEdit.get_current().btnNavigation = true;
    location = '/Admin/Content/Items/Editing/ItemEdit.aspx?cmd=ToggleDraft&PageID=' + this.get_page().id;
}

Dynamicweb.Items.VersionControl.prototype.quitDraftCancel = function () {
    dialog.hide("QuitDraftDialog");
    Ribbon.checkBox("cmdUseDraft");
}

Dynamicweb.Items.VersionControl.prototype.quitDraftOk = function () {
    if (document.getElementById("QuitDraftPublish").checked) {
        this.startWorkflowCmd(true, "ToggleDraft");
    }
    else if (document.getElementById("QuitDraftDiscard").checked) {
        this.discardChangesAndToggleDraft();
    }
}

Dynamicweb.Items.VersionControl.prototype.discardChangesAndToggleDraft = function () {
    Dynamicweb.Items.ItemEdit.get_current().btnNavigation = true;
    location = '/Admin/Content/Items/Editing/ItemEdit.aspx?cmd=discardChangesAndToggleDraft&PageID=' + this.get_page().id;
}

Dynamicweb.Items.VersionControl.prototype.previewPage = function () {
    var previewUrl = "/Default.aspx?ID=" + this.get_page().id + "&Preview=" + this.get_page().id;
    window.open(previewUrl);
}

Dynamicweb.Items.VersionControl.prototype.previewComparePage = function (theDate) {
    var originalUrl = "/Default.aspx?ID=" + this.get_page().id; 
    var draftUrl = "/Default.aspx?ID=" + this.get_page().id + "&Preview=" + this.get_page().id; 
    // Disable frontend editing
    originalUrl = this.addFrontendEditingStateToUrl(originalUrl);
    draftUrl = this.addFrontendEditingStateToUrl(draftUrl);

    if (!theDate) {
        window.open("/Admin/Content/Page/PageCompare.aspx?PageID=" + this.get_page().id + "&original=" + encodeURIComponent(originalUrl) + "&draft=" + encodeURIComponent(draftUrl));
    }
    else {
    	window.open("/Admin/Content/Page/PageCompare.aspx?PageID=" + this.get_page().id + "&VersionCompare=True&Date=" + encodeURIComponent(theDate) + "&original=" + encodeURIComponent(originalUrl) + "&draft=" + encodeURIComponent(draftUrl + "&ts=" + theDate));
    }
}

Dynamicweb.Items.VersionControl.prototype.addFrontendEditingStateToUrl = function (url, state) {
    state || (state = 'disable');
    if (url) {
        url = url.replace(/[?&]FrontendEditingState=[a-z]+/gi, '');
        url += (url.indexOf('?') > -1 ? '&' : '?') + 'FrontendEditingState=' + encodeURIComponent(state);
    }
    return url;
}

Dynamicweb.Items.VersionControl.prototype.startWorkflow = function (publish) {
    this.startWorkflowCmd(publish, "");
}

Dynamicweb.Items.VersionControl.prototype.startWorkflowCmd = function (publish, cmd) {
    Dynamicweb.Items.ItemEdit.get_current().btnNavigation = true;
    location = '/Admin/Module/Workflow/WorkflowApprove.aspx?VCP=v2&cmd=' + cmd + '&PageID=' + this.get_page().id + '&publish=' + publish;
}

Dynamicweb.Items.VersionControl.prototype.discardChanges = function () {
    if (confirm(this.get_terminology()['ConfirmDiscard'])) {
        Dynamicweb.Items.ItemEdit.get_current().btnNavigation = true;
        location = '/Admin/Content/Items/Editing/ItemEdit.aspx?cmd=discardchanges&PageID=' + this.get_page().id;
    }
}

Dynamicweb.Items.VersionControl.prototype.previewBydateShow = function () {
    dialog.show('PreviewByDateDialog');
}

Dynamicweb.Items.VersionControl.prototype.previewBydate = function (theDate) {
    var previewUrl = "/Default.aspx?ID=" + this.get_page().id + "&Preview=" + this.get_page().id;
    if (!theDate) {
        theDate = Date.parse($("DateSelector1_calendar").value, '%Y-%m-%d %H:%M:%S');
        theDate = theDate + ((new Date()).getTimezoneOffset() * 60 * 1000) * -1;
    }
    window.open(previewUrl + "&ts=" + theDate);
}

Dynamicweb.Items.VersionControl.prototype.ShowVersions = function (url) {
    dialog.show('VersionsDialog', url);
}

// Called from ParagraphVersions.aspx
function viewByDate(date) {
    Dynamicweb.Items.VersionControl.get_current().previewBydate(date);
}

// Called from ParagraphVersions.aspx
function CompareByDate(date) {
    Dynamicweb.Items.VersionControl.get_current().previewComparePage(date);
}

Dynamicweb.Items.ItemEdit.prototype.previewItem = function () {
    window.open("/Admin/Content/PreviewCombined.aspx?PageID=" + this.get_page().id + "&original=" + encodeURIComponent('/Default.aspx?ID=' + this.get_page().id + '&Purge=True'), "_blank", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no");
}