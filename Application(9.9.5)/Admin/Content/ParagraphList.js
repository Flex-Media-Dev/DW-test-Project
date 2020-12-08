var pageID = 0;
var pageParentID = 0;
var areaID = 0;
var AllowParagraphOperations = true;

var ShowParagraphSortingConfirmation = false;
var ParagraphSortingWarningMsg = '';

if (!Dynamicweb) {
    Dynamicweb = {};
}

if (!Dynamicweb.ParagraphList) {
    Dynamicweb.ParagraphList = {};
}

Dynamicweb.ParagraphList.Translations = {};

function init(PageID) {
    pageID = PageID;

    if (document.getElementById("AllowParagraphOperations").value == "false") {
        AllowParagraphOperations = false;
    }
    pageParentID = document.getElementById("PageParentID").value;
    areaID = document.getElementById("PageAreaID").value;
    InitParagraphList();
}

function insertParagraphBefore() {
    insertParagraph(ContextMenu.callingID, "before");
}

function insertParagraphAfter() {
    insertParagraph(ContextMenu.callingID, "after");
}

function getParagraphContainer(paragraphID) {
    var container = '',
        paragraph,
        criteria = paragraphID.toString();

    if (criteria.indexOf("Paragraph_") == -1) {
        criteria = "Paragraph_" + criteria;
    }

    paragraph = document.querySelector('ul.paragraph-container li.paragraph[id="' + criteria + '"]')

    if (paragraph) {
        container = paragraph.parentElement.readAttribute('id').replace('Container_', '');
    }

    return container;
}

// Executed after context-menu is shown
function initializeContextMenu(paragraphID, menu) {
    var globalIDs = $('GlobalIDs');
    var cmdDetachGlobal = $(menu.menuElement).select('span[id^="cmdDetachGlobal"]');

    // retrieving a 'Detach global element' button from the current context menu object.
    if (cmdDetachGlobal && cmdDetachGlobal.length > 0) {
        cmdDetachGlobal = $(cmdDetachGlobal[0]);

        // current paragraph is a global element - showing the button, otherwise - hiding it.
        if (globalIDs && globalIDs.value.indexOf(paragraphID + ',') >= 0) {
            cmdDetachGlobal.show();
        } else {
            cmdDetachGlobal.hide();
        }
    }

    if (!isSelected(paragraphID)) {
        toggleActiveMenuButton(true);
    } else {
        handleCheckboxes();
    }
}

function ShowVersions() {
    dialog.show('VersionsDialog', 'ParagraphVersions.aspx?PageID=' + pageID);
}

function insertModule() {
    dialog.show("insertModuleDialog");
}

// Detaches specified global element from its original source.
function detachGlobalElement(paragraphID) {
    if (!AllowParagraphOperations) { return false }
    location = '/Admin/Content/ParagraphList.aspx?cmd=DetachGlobal&DetachGlobal=' + paragraphID + '&PageID=' + pageID;
}

function addFrontendEditingStateToUrl(url, state) {
    state || (state = 'disable');
    if (url) {
        url = url.replace(/[?&]FrontendEditingState=[a-z]+/gi, '');
        url += (url.indexOf('?') > -1 ? '&' : '?') + 'FrontendEditingState=' + encodeURIComponent(state);
    }
    return url;
}

function openFrontendEditing() {
    var url = "/Admin/Content/FrontendEditing/FrontendEditing.aspx?PageID=" + pageID;
    url = addFrontendEditingStateToUrl(url, 'edit');
    window.open(url);
}

function showPage() {
    var showUrl = document.getElementById("showUrl").value;
    window.open(showUrl);
}

function previewPage() {
    var previewUrl = document.getElementById("previewUrl").value;
    window.open(previewUrl);
}

function previewComparePage() {
    var originalUrl = document.getElementById("showUrl").value;
    var draftUrl = document.getElementById("previewUrl").value;
    // Disable frontend editing
    originalUrl = addFrontendEditingStateToUrl(originalUrl);
    draftUrl = addFrontendEditingStateToUrl(draftUrl);
    window.open("/Admin/Content/Page/PageCompare.aspx?PageID=" + pageID + "&original=" + encodeURIComponent(originalUrl) + "&draft=" + encodeURIComponent(draftUrl));
}

function masterComparePage(masterid, languageid) {
    window.open("/Admin/Content/Page/PageCompare.aspx?lang=True&original=/Default.aspx?ID=" + masterid + "&draft=/Default.aspx?ID=" + languageid);
}

function startWorkflow(publish) {
    startWorkflowCmd(publish, "");
}

function startWorkflowCmd(publish, cmd) {
    location = '/Admin/Module/Workflow/WorkflowApprove.aspx?VCP=v2&cmd=' + cmd + '&PageID=' + pageID + '&publish=' + publish;
}

function QuitDraftCancel() {
    dialog.hide("QuitDraftDialog");
    Ribbon.checkBox("cmdUseDraft");
}

function QuitDraftOk() {
    if (document.getElementById("QuitDraftPublish").checked) {
        startWorkflowCmd(true, "ToggleDraft");
    }
    if (document.getElementById("QuitDraftDiscard").checked) {
        discardChangesAndToggleDraft();
    }
}

function useDraft() {
    var unpublished = eval(document.getElementById("hasUnpublishedContent").value)
    if (unpublished) {
        dialog.show("QuitDraftDialog");
    }
    else {
        toggleDraft();
    }
}

function toggleDraft() {
    location = '/Admin/Content/ParagraphList.aspx?cmd=ToggleDraft&PageID=' + pageID;
}

function discardChanges() {
    if (confirm($('confirmDiscard').innerHTML)) {
        location = '/Admin/Content/ParagraphList.aspx?cmd=discardchanges&PageID=' + pageID;
    }
}

function discardChangesAndToggleDraft() {
    location = '/Admin/Content/ParagraphList.aspx?cmd=discardchanges&cmd2=ToggleDraft&PageID=' + pageID;
}

function pageProperties() {
    location = "/Admin/Page_Edit.aspx?ID=" + pageID;
}

function pageProperties2() {
    location = "/Admin/Content/Page/PageEdit.aspx?ID=" + pageID;
}

function newParagraph() {
    location = '/Admin/Content/ParagraphEdit.aspx?PageID=' + pageID;
}

function newParagraphToContainer() {
    if (!AllowParagraphOperations) { return false }
    var container = ContextMenu.callingID;
    location = '/Admin/Content/ParagraphEdit.aspx?PageID=' + pageID + '&container=' + container;
}

function saveAsTemplate() {
    dialog.show("SaveAsTemplateDialog");
}

function SaveAsTemplateOk() {
    var isTemplate = "true";
    if (document.getElementById("isTemplate")) {
        isTemplate = document.getElementById("isTemplate").checked.toString();
    }
    url = "/Admin/Content/ParagraphList.aspx?cmd=saveastemplate&PageID=" + pageID
        + "&TemplateName=" + encodeURI(document.getElementById("TemplateName").value)
        + "&TemplateDescription=" + encodeURI(document.getElementById("TemplateDescription").value)
        + "&TemplateImage=" + encodeURI(document.getElementById("FM_TemplateImage").value)
        + "&isTemplate=" + encodeURI(isTemplate);

    location = url;
}

function SaveAsTemplateCancel() {
    dialog.hide("SaveAsTemplateDialog");
}

function publish() {
    if ($("cmdValidate")) {
        $("cmdValidate").removeClassName("disabled");
    }
    setPublish('published');
}

function unPublish() {
    if ($("cmdValidate")) {
        $("cmdValidate").addClassName("disabled");
    }
    setPublish('unpublished');
}

function unPublishHide() {
    if ($("cmdValidate")) {
        $("cmdValidate").removeClassName("disabled");
    }
    setPublish('hideInMenu');
}

function previewBydateShow() {
    dialog.show('PreviewByDateDialog');
}

function previewBydate() {
    var theDate = Date.parse(document.getElementById("DateSelector1_calendar").value, '%Y-%m-%d %H:%M:%S');
    var ms = theDate + ((new Date()).getTimezoneOffset() * 60 * 1000) * -1;
    viewByDate(ms);
}

function viewByDate(date) {
    window.open(document.getElementById("previewUrl").value + "&ts=" + date);
}

function CompareByDate(date) {
    window.open("/Admin/Content/Page/PageCompare.aspx?PageID=" + pageID + "&VersionCompare=True&Date=" + encodeURIComponent(date) + "&original=" + encodeURIComponent(document.getElementById("showUrl").value) + "&draft=" + encodeURIComponent(document.getElementById("previewUrl").value + "&ts=" + date));
}

function setPublish(publishState) {
    //Set NewPageName if is cmd = copy
    if ($("NewPageName") !== null) {
        url = '/Admin/Content/ParagraphList.aspx?cmd=publish&state=' + publishState + '&PageID=' + pageID + '&NewPageName=' + encodeURI($("NewPageName").value);
        $("NewPageName").value = '';
    } else {
        url = '/Admin/Content/ParagraphList.aspx?cmd=publish&state=' + publishState + '&PageID=' + pageID
    }
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function (transport) {
            if (transport && transport.responseJSON) {
                var page = transport.responseJSON;
                $('_pagename').update(page.name);
                $('_title').update(page.title);
                $('_url').update(page.url);
                dwGlobal.getContentNavigator().refreshNode(page.parentNodeId, page.nodeId);
            }
        }
    });
}

var GlobalUrl = '';
function insertGlobalElement() {
    dialog.show('GlobalsDialog', GlobalUrl);
}

function insertNewGlobalElement() {
    var callback = function (options, model) {
        AddGlobal(model.ParagraphID);
    }
    var dlgAction = createLinkDialog(LinkDialogTypes.Paragraph, [], callback);
    Action.Execute(dlgAction);
}

function insertMultiSelectGlobal(List) {
    var ParagraphID = "";
    var rows = List.getSelectedRows('insertGlobalElementList');
    if (rows.length > 0) {
        for (var i = 0; i < rows.length; i++) {
            if (i == 0) {
                ParagraphID = rows[i].id.substr(3);
            } else {
                ParagraphID += "," + rows[i].id.substr(3);
            }
        }
        AddGlobal(ParagraphID);
    }
}

function AddGlobal(ParagraphID) {
    new Ajax.Request('/Admin/Content/Paragraph/Paragraph_AddGlobal.aspx?mode=viewparagraphs&ParagraphPageID=' + pageID + '&ParagraphGlobalID=' + ParagraphID, {
        method: 'get',
        onComplete: function (response) {
            var html = response.responseText;
            if (html.length > 0) {
                Action.Execute(JSON.parse(html.replace(/'/g, '"')));
            } else {
                if (document.getElementById("GlobalsDialog")) {
                    dialog.hide('GlobalsDialog');
                }
                location = '/Admin/Content/ParagraphList.aspx?PageID=' + pageID;
            }
        }
    });
}

function SelectParagraphID(ParagraphID) {
    top.opener.AddGlobal(ParagraphID);
}

function SelectParagraph(ParagraphID, PageID, ParagraphHeader, ParagraphItemType) {
    var wnd = window.opener,
        selfWnd = window,
        callerEl,
        storageEl,
        callbackFunc,
        callbackResponse;

    if (!wnd && window.parent) {
        wnd = window.parent.opener;
        selfWnd = window.parent;
    }

    callerEl = wnd.document.getElementById("Link_" + InternalAllID);
    storageEl = wnd.document.getElementById(InternalAllID);

    if (callerEl && storageEl) {
        callerEl.value = ParagraphHeader;
        storageEl.value = "Default.aspx?ID=" + PageID + "#" + ParagraphID;
    }
    if (storageEl) {
        callbackFunc = _readAttribute(storageEl, 'data-opener-callback');

        if (callbackFunc && wnd[callbackFunc] && typeof (wnd[callbackFunc]) === 'function') {
            wnd[callbackFunc]({
                areaID: areaID,
                pageID: PageID,
                paragraphID: ParagraphID,
                paragraphName: ParagraphHeader
            });
        } else {
            _writeAttribute(storageEl, 'data-area-id', areaID);
            _writeAttribute(storageEl, 'data-page-id', PageID);
            _writeAttribute(storageEl, 'data-paragraph-id', ParagraphID);
            _writeAttribute(storageEl, 'data-paragraph-name', ParagraphHeader);
            _writeAttribute(storageEl, 'data-paragraph-itemtype', ParagraphItemType);

            if (storageEl.onchange) {
                callbackResponse = storageEl.onchange.apply(storageEl);
            }
        }
    }

    if (callbackResponse == null || callbackResponse.closeMenu == null || callbackResponse.closeMenu == true) {
        selfWnd.close();
    }
}

function EmailPreviewShow() {
    window.open("/Admin/Content/PreviewCombined.aspx?PageID=" + pageID + "&original=" + encodeURIComponent(document.getElementById("showUrl").value) + "&emailPrewiew=true", "_blank", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no");
}

/* Validates page markup and displays an infobar if validation is failed */
function validatePage() {
    new Ajax.Request('/Admin/Content/ParagraphList.aspx?cmd=ValidateMarkup&PageID=' + pageID, {
        method: 'get',
        onComplete: function (response) {
            var html = response.responseText;
            if (html.length > 0) {
                $('markupWarning').update(html);

                if (typeof (Effect.SlideDown) == 'function')
                    Effect.SlideDown('markupWarning', { duration: 0.5 });
                else
                    $('markupWarning').show();
            }
        }
    });
}

/* Switches the 'Processing' icon and 'Validation details' frame visibility */
function toggleValidationInProgress(show) {
    if (show) {
        $('imgProcessing').show();
        $('validateContent').hide();
    } else {
        $('imgProcessing').hide();
        $('validateContent').show();
    }
}

function toggleActiveR() {
    var paragraphID = ContextMenu.callingID;
    if (isSelected(paragraphID)) {
        if (isMenuButtonEnabled('cmdToggleActiveInclude')) {
            toggleActiveAll();
        }
        return;
    }
    var currentState = "True";
    if ($('PI_' + paragraphID).hasClassName("ShowFalse")) {
        currentState = "False";
    }
    toggleActive(paragraphID, currentState, "");
}
function toggleActive(paragraphID, currentState, caller) {
    var url = "/Admin/Content/ParagraphList.aspx?PageID=" + pageID + "&cmd=toggleactive&ID=" + paragraphID + "&active=" + (currentState == 'False' ? "true" : "false") + "&caller=" + caller;
    location = url;
}
function toggleActiveAll() {
    var SelectedIDList = getSelectedParagraphIds();
    if (SelectedIDList == "") { return }
    var url = "/Admin/Content/ParagraphList.aspx?PageID=" + pageID + "&cmd=toggleactive&ID=" + SelectedIDList + "&active=" + (inActives ? "true" : "false");
    location = url;
}

function deleteParagraph() {
    if (!AllowParagraphOperations) { return false }
    var paragraphID = ContextMenu.callingID;
    if (isSelected(paragraphID)) {
        deleteParagraphs();
        return;
    }

    var isChrome = !!window.chrome && !!window.chrome.webstore;
    if (isChrome) {
        event.preventDefault();
    }

    deleteParagraphs(paragraphID);
}
function deleteParagraphs() {
    if (!AllowParagraphOperations) { return false }
    var SelectedIDList = "";
    if (arguments.length == 0) {
        SelectedIDList = getSelectedParagraphIds();
    }
    else {
        SelectedIDList = arguments[0];
    }
    if (document.getElementById("PageApprovalType")) {
        if (document.getElementById("PageApprovalType").value != "0") {
            var url = "ParagraphList.aspx?mode=viewparagraphs&PageID=" + pageID + "&ID=" + SelectedIDList + "&cmd=deleteparagraphs";
            location = url;
            return;
        }
    }
    if (SelectedIDList == "") { return }
    if (confirm(deleteMsg)) {
        var url = "/Admin/Content/Paragraph/Paragraph_Delete.aspx?mode=viewparagraphs&ID=" + SelectedIDList + "&PageID=" + pageID;
        location = url;
    }
}

function experimentTestParagraph() {
    var experimentTesting = true;
    copyParagraphsHere("", experimentTesting);
}

function editParagraph(caller) {
    location = "ParagraphEdit.aspx?ID=" + ContextMenu.callingID + "&PageID=" + pageID;
}

function insertParagraph(paragraphSortID, sortDirection) {
    if (!AllowParagraphOperations) { return false }

    var container = getParagraphContainer(paragraphSortID);

    location = "ParagraphEdit.aspx?PageID=" + pageID + '&ParagraphSortID=' + paragraphSortID + '&ParagraphSortDirection=' + sortDirection + '&container=' + container;
}

var contextParagraphID = 0;
function mouseoverParagraph(ParagraphID) {
    contextParagraphID = ParagraphID;
    $('Paragraph_' + ParagraphID).addClassName("ShowActive")
}

var inActives = false;
function getSelectedParagraphIds() {
    inActives = false;
    var SelectedIDList = "";
    $('form1').getInputs('checkbox').each(function (s) {
        if (s.id != 'chkAll' && s.checked) {
            if ($('PI_' + s.value).hasClassName("ShowFalse")) {
                inActives = true;
            }
            if (SelectedIDList == "") {
                SelectedIDList = s.value;
            } else {
                SelectedIDList = SelectedIDList + "," + s.value;
            }
        }
    });
    return SelectedIDList;
}

function isSelected(ParagraphID) {
    var found = false;
    $('form1').getInputs('checkbox').each(function (s) {
        if ((s.checked) && (parseInt(s.value) == parseInt(ParagraphID))) {
            found = true;
        }
    });

    return found;
}

function toggleAllSelected() {
    setAllSelected($('chkAll').checked);
}

function setAllSelected(isSelected) {
    $('form1').getInputs('checkbox').each(function (s) {
        if (!s.disabled)
            s.checked = isSelected;
    });

    handleCheckboxes();
}

function toggleActiveMenuButton(active) {
    var includeMenuButton = document.getElementById('cmdToggleActiveInclude').querySelector('a');
    var includeModuleMenuButton = document.getElementById('cmdToggleActiveIncludeModule').querySelector('a');
    var excludeMenuButton = document.getElementById('cmdToggleActiveExclude').querySelector('a');
    var excludeModuleMenuButton = document.getElementById('cmdToggleActiveExcludeModule').querySelector('a');

    if (active) {
        includeMenuButton.classList.remove('button-disabled');
        includeModuleMenuButton.classList.remove('button-disabled');
        excludeMenuButton.classList.remove('button-disabled');
        excludeModuleMenuButton.classList.remove('button-disabled');
    } else {
        includeMenuButton.classList.add('button-disabled');
        includeModuleMenuButton.classList.add('button-disabled');
        excludeMenuButton.classList.add('button-disabled');
        excludeModuleMenuButton.classList.add('button-disabled');
    }
}

function isMenuButtonEnabled(buttonId) {
    var menuButton = document.getElementById(buttonId).querySelector('a');
    return !menuButton.classList.contains('button-disabled');
}

function handleCheckboxes() {
    var checked = false;
    var checkedCount = 0;
    var checkboxes = $('form1').getInputs('checkbox');
    var disableInclude = false;
    var disableCopy = false;
    var disableMove = false;

    checkboxes.each(function (s) {
        if (s.disabled && s.id != 'chkAll') {
            checkedCount++;
        }
        if (s.checked && s.id != 'chkAll') {
            checked = true;
            checkedCount++;
            if (s.hasClassName('disableInclude')) {
                disableInclude = true;
            }
            if (s.hasClassName('disableCopy')) {
                disableCopy = true;
            }
            if (s.hasClassName('disableMove')) {
                disableMove = true;
            }
        }
    });
    var allCheckedAreExperiments = true;
    checkboxes.each(function (s) {
        if (s.checked && s.id != 'chkAll') {
            if (experimentParagraphs.indexOf(s.id) == -1) {
                allCheckedAreExperiments = false;
            }
        }
    });
    $('chkAll').checked = !(checkedCount < (checkboxes.length - 1));

    var omcTab = document.getElementById("tabitem3");

    if (checked) {
        if (!AllowParagraphOperations) { return false }
        Ribbon.enableButton('CopyParagraphs');
        Ribbon.enableButton('CopyParagraphsHere');
        if (disableCopy) {
            Ribbon.disableButton('CopyParagraphs');
            Ribbon.disableButton('CopyParagraphsHere');
        }
        Ribbon.enableButton('MoveParagraphs');
        if (disableMove) {
            Ribbon.disableButton('MoveParagraphs');
        }
        Ribbon.enableButton('DeleteParagraphs');
        Ribbon.enableButton('IncludeParagraphs');
        toggleActiveMenuButton(true);

        if (disableInclude) {
            Ribbon.disableButton('IncludeParagraphs');
            toggleActiveMenuButton(false);
        }
        if (!allCheckedAreExperiments)
            Ribbon.enableButton('ExperimentTestBtn');
        else
            Ribbon.disableButton('ExperimentTestBtn');

        if (omcTab === null || omcTab.className !== 'activeitem') {
            Ribbon.tab(2, "myribbon");
        }
    } else {
        Ribbon.disableButton('CopyParagraphs');
        Ribbon.disableButton('CopyParagraphsHere');
        Ribbon.disableButton('MoveParagraphs');
        Ribbon.disableButton('DeleteParagraphs');
        Ribbon.disableButton('IncludeParagraphs');
        if (!allCheckedAreExperiments)
            Ribbon.enableButton('ExperimentTestBtn');
        else
            Ribbon.disableButton('ExperimentTestBtn');

        if (omcTab === null || omcTab.className !== 'activeitem') {
            Ribbon.tab(1, "myribbon");
        }
    }
}

/* Fired when two list elements needs to be swapped in the list */
function onSorting(element, dropOn) {
    var dragObj = $(element), dropObj = $(dropOn);
    var temp = null;

    // Sorting items without touching separators

    if (element && dropOn) {
        if (dropObj.hasClassName('separator')) {
            // direction - "Up"
            temp = dropObj.previous();

            // ensure that these are two siblings
            if (temp != null && dropObj.next() == element) {
                this._insertBefore(element, temp);
                this._insertBefore(dropOn, temp);
            }
        } else {
            // direction - "Down"
            temp = dragObj.next();
            if (temp != null) {

                // ensure that these are two siblings
                if (temp.hasClassName('separator') && temp.next() == dropOn) {
                    this._insertBefore(dropOn, element);
                    this._insertBefore(temp, element);
                }
            }
        }
    }
}

function currentPosition(element) {
    var id = element.readAttribute('id'),
        currentPosition;

    if (id) {
        currentPosition = {};
        currentPosition.parent = element.parentElement;
        currentPosition.nextSibling = element.nextElementSibling;
        currentPosition.previousSibling = element.previousElementSibling;
    }
    return currentPosition;
}

function setPosition(element, positions) {
    var id = element.readAttribute('id');

    if (id) {
        positions[id] = currentPosition(element);
        return positions[id];
    }
    else {
        return null;
    }
}

function canMove(element, positions, containers) {
    var result = true,
        itemType = element.readAttribute('data-item-type'),
        newParent = element.parentElement.readAttribute('id'),
        previousParent = getPosition(element, positions).parent.readAttribute('id'),
        container;

    if (previousParent !== newParent) {
        container = containers && containers.get(newParent);
        if (container && container.itemsAllowed.length > 0) {
            if (itemType) {
                result = container.itemsAllowed.indexOf(itemType) > -1;
            } else {
                result = false;
            }
        }
    }

    return result;
}

function getPosition(element, positions) {
    var id = element.readAttribute('id'),
        result;

    if (id) {
        result = positions[id];
    }

    return result;
}

var positions = {};
function InitParagraphList() {
    var list = $('items'),
        containers = new Dynamicweb.Utilities.Dictionary(),
        contains = function (parent, element) {
            var result = false;

            if (parent && element) {
                result = parent.contains(element);
            }

            return result;
        },
        revert = function (element) {
            var position = getPosition(element, positions),
                currentParent = element.parentElement,
                previousParent,
                insertAfter = function (parent, target, source) {
                    var result = false;

                    if (contains(parent, source)) {
                        sibling = source.nextElementSibling;

                        if (sibling) {
                            parent.insertBefore(target, sibling);
                        }
                    }

                    if (!result) {
                        parent.appendChild(target);
                    }
                },
                insertBefore = function (parent, target, source) {
                    if (contains(parent, source)) {
                        parent.insertBefore(element, source);
                    } else {
                        parent.appendChild(target);
                    }
                };

            if (position && currentParent) {
                previousParent = position.parent;
                currentParent.removeChild(element);

                if (position.previousSibling && position.nextSibling) {
                    // check whether siblings still exist in parent
                    if (contains(previousParent, position.nextSibling)) {
                        insertBefore(previousParent, element, position.nextSibling);
                    } else if (contains(previousParent, position.previousSibling)) {
                        insertAfter(previousParent, element, position.previousSibling);
                    } else {
                        previousParent.appendChild(element);
                    }
                } else if (position.previousSibling) {
                    insertAfter(previousParent, element, position.previousSibling);
                } else if (position.nextSibling) {
                    insertBefore(previousParent, element, position.nextSibling);
                } else {
                    previousParent.appendChild(element);
                }
            }
        };

    if (!AllowParagraphOperations) {
        return false;
    }

    // collect restrictions of all containers
    var containerElements = document.querySelectorAll("ul.paragraph-container:not(.paragraph-gridrow)");

    for (var i = 0; i < containerElements.length; i++) {
        var element = containerElements[i];
        var id = element.readAttribute('id'),
	        itemsAllowed = element.readAttribute('data-items-allowed');

        if (id) {
            containers.add(id, { itemsAllowed: [] });

            if (itemsAllowed) {
                itemsAllowed.split(',').each(function (item) {
                    containers.get(id).itemsAllowed.push(item.trim());
                });
            }
        }
    }

    //set initial height for paragraphsWrapper elements
    var paragraphWrappers = document.querySelectorAll(".ContainerDummy .paragraphsWrapper");
    paragraphWrappers.forEach(function (wrapper) {
        wrapper.style.height = wrapper.scrollHeight + "px";
    });

    var oldPosition = {};
    var oldRowPosition = {};
    for (var i = 0; i < containers._storage.length; i++) {
        var container = containers._storage[i];
        var key = container.key;
        var element = document.getElementById(key);

        enableSortingOnRow(element);

        Sortable.create(element, {
            animation: 150,
            group: {
                name: 'paragraph-sort'
            },
            onStart: function (event) {
                var el = event.srcElement || event.target;
                var a = el.down("a");
                oldPosition = setPosition(event.item, positions);
            },
            onEnd: function (event) {
                var el = event.item;
                var a = el.down("a");

                var newPosition = currentPosition(el);

                if (!!(oldPosition) && !!(newPosition) && (
                    oldPosition.parent != newPosition.parent ||
                    oldPosition.nextSibling != newPosition.nextSibling ||
                    oldPosition.previousSibling != newPosition.previousSibling)) {
                    if (!canMove(el, positions, containers)) {
                        revert(el);
                        alert(Dynamicweb.ParagraphList.Translations['ContainerRestriction']);
                    } else {
                        SortDone();
                        _showHideToggleIcon(oldPosition.parent, newPosition.parent)
                    }
                }
            },
            onMove: function (evt, originalEvent) {
                _expandToggledContainer(originalEvent.currentTarget);
            }
        });
    }

    //Activate Sortable on rows
    var rows = document.getElementsByClassName("paragraph-wrapper");

    for (var i = 0; i < rows.length; i++) {
        enableSortingInsideRow(rows[i], positions);
    };

    // Fix: Prototype includes scroll offsets 
    Position.includeScrollOffsets = true;

    enableDragAndDropFromSideMenu();
}

function enableSortingOnRow(row) {
    Sortable.create(row, {
        animation: 150,
        group: "rows",
        draggable: ".grid-row",
        handle: ".row-handle",
        onStart: function (event) {
            oldRowPosition = setPosition(event.item, positions);
        },
        onEnd: function (event) {
            var oldIndex = event.oldIndex;
            var newIndex = event.newIndex;
            var el = event.item;
            var a = el.down("a");
            var newPosition = currentPosition(el);

            SortDone();

        },
    });
}

function enableSortingInsideRow(row, positions) {
    var id = row.getAttribute("id");
    var oldPosition;

    Sortable.create(row, {
        animation: 150,
        group: "paragraphs",
        draggable: ".paragraph",
        onStart: function (event) {
            var el = event.srcElement || event.target;
            var a = el.down("a");


            oldPosition = setPosition(event.item, positions);
        },
        onEnd: function (event) {
            var el = event.item;
            var a = el.down("a");

            var newPosition = currentPosition(el);

            if (!!(oldPosition) && !!(newPosition) && (
                oldPosition.parent != newPosition.parent ||
                oldPosition.nextSibling != newPosition.nextSibling ||
                oldPosition.previousSibling != newPosition.previousSibling)) {
                if (!canMove(el, positions)) {
                    revert(el);
                    alert(Dynamicweb.ParagraphList.Translations['ContainerRestriction']);
                } else {
                    SortDone();
                    _showHideToggleIcon(oldPosition.parent, newPosition.parent)
                }
            }
        },
        onMove: function (evt, originalEvent) {
            var el = evt.dragged;
            var newPosition = currentPosition(el);

            if (!!(oldPosition) && !!(newPosition) && (
                oldPosition.parent != newPosition.parent ||
                oldPosition.nextSibling != newPosition.nextSibling ||
                oldPosition.previousSibling != newPosition.previousSibling)) {
                //_expandToggledContainer(newPosition.parent);
            }
        }
    });
}

function enableDragAndDropFromSideMenu() {
    currentPosition = function (element) {
        var id = element.readAttribute('id'),
            currentPosition;

        if (id) {
            currentPosition = {};
            currentPosition.parent = element.parentElement;
            currentPosition.nextSibling = element.nextElementSibling;
            currentPosition.previousSibling = element.previousElementSibling;
        }
        return currentPosition;
    }

    var paragraphSelectionList = document.getElementsByClassName("paragraph-selection-list")[0];
    if (!paragraphSelectionList) {
        return;
    }

    var related = {};
    Sortable.create(paragraphSelectionList, {
        animation: 150,
        group: {
            name: "paragraphs",
            pull: "clone",
            revertClone: true,
        },
        onEnd: function (event) {
            var item = event.item;
            var sibling = event.item.previousElementSibling;
            var paragraphList = findParentUntil(item, 'paragraph-container');
            var dropRow = findParentUntil(item, 'grid-row');
            var dropRowWrapper = findParentUntil(item, 'paragraph-wrapper');

            if (dropRowWrapper) {
                //Clone the new paragraph
                var templateId = item.readAttribute("data-templateId");
                saveParagraph(templateId, function (paragraphId) {
                    var e = document.getElementById("Paragraph_test");
                    e.setAttribute("id", "Paragraph_" + paragraphId);
                    SortDone();
                });

                //Check if the row is full
                var totalParagraphsWidth = 0;
                for (var i = 0; i < dropRowWrapper.children.length; i++) {
                    var currentElement = dropRowWrapper.children[i];

                    //Not the new element
                    if (currentElement.className.indexOf('paragraph-selection') == -1) {
                        totalParagraphsWidth += currentElement.offsetWidth / dropRow.offsetWidth * 100
                    }
                }

                //If the row is full
                if (totalParagraphsWidth >= 98) {
                    console.log("row is full");
                    var temporaryElementType = "li";
                    var temporaryElement = document.createElement(temporaryElementType);

                    var rows = document.getElementsByClassName("grid-row");
                    var rowIds = [];

                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        var rowId = row.readAttribute("id").replace("r", "");
                        rowIds.push(rowId);
                        rowIds = rowIds.sort();
                    };

                    var lastRowId = parseInt(rowIds[rowIds.length - 1]);
                    var newRowId = 'r' + (lastRowId + 1);

                    var row = document.createElement("div");
                    row.className = "grid-row";
                    row.id = newRowId;

                    var handle = document.createElement("div");
                    handle.className = "row-handle";
                    row.appendChild(handle);

                    var wrapper = document.createElement("div");
                    wrapper.className = "paragraph-wrapper";
                    row.appendChild(wrapper);

                    wrapper.innerHTML = renderItem([], "testTemplate");

                    item.outerHTML = "";

                    paragraphList.insertBefore(row, findParentUntil(sibling, 'grid-row').nextElementSibling);

                    enableSortingOnRow(wrapper);

                }
                else {
                    var temporaryElementType = "li";
                    var temporaryElement = document.createElement(temporaryElementType);

                    item.outerHTML = renderItem([], "testTemplate");
                }

                SortDone();
            }
        },
        onMove: function (evt, originalEvent) {
            var targetElement = originalEvent.target;

            if (targetElement) {
                var rows = document.getElementsByClassName("grid-row-onDrop");

                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.classList.remove("grid-row-onDrop");
                }

                console.log(originalEvent);
                console.log(targetElement);
                if (targetElement.classList.contains("paragraph-wrapper") || targetElement.classList.contains("grid-row")) {
                    targetElement.classList.add("grid-row-onDrop");
                }
            }
        },
    });
}

function saveParagraph(templateId, callback) {
    if (ShowParagraphSortingConfirmation && ParagraphSortingWarningMsg != null && ParagraphSortingWarningMsg != '' && !confirm(ParagraphSortingWarningMsg)) {
        location.replace(location);
    } else {
        var dt = new Date;
        var url = "/Admin/Content/Paragraph/Paragraph_Save.aspx";
        new Ajax.Request(url, {
            method: 'post',
            parameters: {
                PageID: pageID,
                TemplateID: templateId
            },
            onComplete: function (transport) {
                callback(transport.responseText);
            }
        });
    }
}

function renderItem(data, templateId) {
    var template = loadTemplate(templateId);

    //if (template != null) {
    //    for (property in data) {
    //        var item = data[property];
    //        var nameKey = "data." + property;

    //        template = template.replace(new RegExp(nameKey, "gi"), item);
    //    }
    //}

    return template;
}

//Load the chosen template
function loadTemplate(templateId) {
    if (document.getElementById(templateId)) {
        return document.getElementById(templateId).innerHTML;
    } else {
        console.log("Dynamo: Template element not found - " + templateId);
        return null;
    }
}

function findParentUntil(element, parentClass) {

    var el = element;
    if (el && el != null) {
        while (el && !el.classList.contains(parentClass)) {
            el = el.parentElement;
        }

        return el;
    }
}

var ListHasTemplateModule = false;
function SortDone() {
    var data = {};
    var AssocArray = {};

    var containerElements = document.querySelectorAll("ul.paragraph-container:not(.paragraph-gridrow)");

    for (var i = 0; i < containerElements.length; i++) {
        var element = containerElements[i];
        var id = element.readAttribute('id').replace('Container_', '');
        var rows = element.querySelectorAll("li.paragraph:not(.hidden)")
        if (rows.length > 0) {
            data[id] = [];

            for (var j = 0; j < rows.length; j++) {
                var row = rows[j];
                var paragraphId = row.readAttribute('id').replace('Paragraph_', '')
                data[id].push(paragraphId);

                var gridrow = findParentUntil(row, 'grid-row');
                if (gridrow) {
                    AssocArray[paragraphId] = gridrow.readAttribute('id')
                }

            }
        }
    }

    if (ShowParagraphSortingConfirmation && ParagraphSortingWarningMsg != null && ParagraphSortingWarningMsg != '' && !confirm(ParagraphSortingWarningMsg)) {
        location.replace(location);
    } else {
        var dt = new Date;
        var url = "/Admin/Content/Paragraph/Paragraph_SortAll_Save.aspx?mode=viewparagraphs";
        new Ajax.Request(url, {
            method: 'post',
            parameters: {
                PageID: pageID,
                Containers: JSON.stringify(data),
                ParentContainers: JSON.stringify(AssocArray),
                dt: dt
            },
            onComplete: function (transport) {
                if (ListHasTemplateModule) {
                    location.replace(location);
                }
            }
        });
    }
}

/* Opens the 'Edit module' window */
function openModuleSettings(paragraphID) {
    var pid = paragraphID, url = '';
    var wnd = null;

    if (!pid)
        pid = ContextMenu.callingID;

    if ($('GlobalElementsIDs')) {
        var globalIDs = $('GlobalElementsIDs').value.split(',');
        for (var i = 0; i < globalIDs.length; i++) {
            var gid = "_" + globalIDs[i];
            if (gid.indexOf("_" + pid + '-') >= 0) {
                pid = globalIDs[i].split('-')[1];
                break;
            }
        }
    }

    if (pid > 0) {
        url = '/Admin/Content/ParagraphEditModule.aspx?ID=' + pid + '&PageID=' + pageID + '&AreaID=' + areaID + '&OnCompleteCallback=editModule&OnRemoveCallback=editModule';
        wnd = window.open(url, 'EditModuleWnd', 'resizable=no,scrollbars=yes,toolbar=no,location=no,directories=no,status=yes,width=1100,height=860,modal=yes');

        if (wnd)
            wnd.focus();
    }
}

/* Fires when module settings are applied (or when module is removed) */
function editModule(paragraphID, moduleSystemName, moduleSettings) {
    setTimeout(function () {
        new Ajax.Request('/Admin/Content/FrontendEditing/FrontendEdit.aspx', {
            method: 'post',
            parameters: {
                cmd: 'SetModuleSettings',
                ID: paragraphID,
                moduleName: moduleSystemName,
                moduleSettings: moduleSettings
            },

            onComplete: function (response) {
                var url = removeURLParameter(location.href, 'CopiedParagraphIDs');
                if (url.indexOf("cmd=copypage") != -1) {
                    url = removeURLParameter(location.href, 'cmd');
                };
                location.href = url;
            }
        });
    }, 150);

    return true;
}

function removeURLParameter(url, parameter) {
    var urlparts = url.split('?');
    if (urlparts.length >= 2) {

        var prefix = encodeURIComponent(parameter) + '=';
        var pars = urlparts[1].split(/[&;]/g);

        for (var i = pars.length; i-- > 0;) {
            if (pars[i].lastIndexOf(prefix, 0) !== -1) {
                pars.splice(i, 1);
            }
        }

        url = urlparts[0] + '?' + pars.join('&');
        return url;
    } else {
        return url;
    }
}

function switchToItem() {
    location = '/Admin/Content/Items/Editing/ItemEdit.aspx?PageID=' + pageID;
}

function switchToNamedItemList() {
    location = '/Admin/Content/Items/Editing/NamedItemListEdit.aspx?PageID=' + pageID;
}

function updateParagraphOptions() {
    dialog.hide('ParagraphOptionsDialog');
    if ($("NewParagraphsIDs").value != '') {
        var IDs = $("NewParagraphsIDs").value;
        if ($("ParagraphOptionsActive").checked) {
            var url = "/Admin/Content/ParagraphList.aspx?PageID=" + pageID + "&cmd=toggleactive&ID=" + IDs + "&active=1";
            location = url;
        }
        if ($("ParagraphOptionsNotActive").checked) {
            var url = "/Admin/Content/ParagraphList.aspx?PageID=" + pageID + "&cmd=toggleactive&ID=" + IDs + "&active=0";
            location = url;
        }
    }
}

//Update page options according to popup options window
function updatePageOptions() {
    dialog.hide("PageOptionsDialog");
    var PageID = $("NewPageID").value;
    $("NewPageID").value = "";
    var OldPageState = $("OldPageState").value;
    if (PageID !== '' && OldPageState !== '') {
        if ($("PageOptionsAsTheyAre").checked) {
            switch (OldPageState) {
                case "published":
                    publish();
                    if (!$("cmdPublished").hasClassName('active')) {
                        $("cmdPublished").addClassName('active')
                        $("cmdHidden").removeClassName('active')
                        $("cmdHideInNavigation").removeClassName('active')
                    }
                    break;
                case "unpublished":
                    unPublish();
                    if (!$("cmdHidden").hasClassName('active')) {
                        $("cmdPublished").removeClassName('active')
                        $("cmdHidden").addClassName('active')
                        $("cmdHideInNavigation").removeClassName('active')
                    }
                    break;
                case "hideinmenu":
                    unPublishHide();
                    if (!$("cmdHideInNavigation").hasClassName('active')) {
                        $("cmdPublished").removeClassName('active')
                        $("cmdHidden").removeClassName('active')
                        $("cmdHideInNavigation").addClassName('active')
                    }
                    break;
                default:
                    break;
            }
        }
        if ($("PageOptionsPublished").checked) {
            publish();
            if (!$("cmdPublished").hasClassName('active')) {
                $("cmdPublished").addClassName('active')
                $("cmdHidden").removeClassName('active')
                $("cmdHideInNavigation").removeClassName('active')
            }
        }
        if ($("PageOptionsUnpublished").checked) {
            unPublish();
            if (!$("cmdHidden").hasClassName('active')) {
                $("cmdPublished").removeClassName('active')
                $("cmdHidden").addClassName('active')
                $("cmdHideInNavigation").removeClassName('active')
            }
        }
        if ($("PageOptionsHideInMenu").checked) {
            unPublishHide();
            if (!$("cmdHideInNavigation").hasClassName('active')) {
                $("cmdPublished").removeClassName('active')
                $("cmdHidden").removeClassName('active')
                $("cmdHideInNavigation").addClassName('active')
            }
        }
    }
}

function _writeAttribute(element, name, value) {
    element.setAttribute(name, value);
}

function _readAttribute(element, name) {
    return (!element.attributes || !element.attributes[name]) ? '' :
             element.attributes[name].value;
}

Dynamicweb.ParagraphList.ItemEdit = function () {
    this._terminology = {};
    this._item = {};
}

Dynamicweb.ParagraphList.ItemEdit._instance = null;

Dynamicweb.ParagraphList.ItemEdit.get_current = function () {
    if (!Dynamicweb.ParagraphList.ItemEdit._instance) {
        Dynamicweb.ParagraphList.ItemEdit._instance = new Dynamicweb.ParagraphList.ItemEdit();
    }

    return Dynamicweb.ParagraphList.ItemEdit._instance;
}

Dynamicweb.ParagraphList.ItemEdit.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.ParagraphList.ItemEdit.prototype.get_item = function () {
    return this._item;
}

Dynamicweb.ParagraphList.ItemEdit.prototype.set_item = function (value) {
    this._item = value;
}

function openContentRestrictionDialog(params) {
    var p = pageID;

    if (params && params.pageID) {
        p = params.pageID;
    }

    Marketing.openSettings('ContentRestriction', { data: { ItemType: 'Page', ItemID: p } });
}

function openProfileDynamicsDialog() {
    Marketing.openSettings('ProfileDynamics', { data: { ItemType: 'Page', ItemID: pageID } });
}

function profileVisitPreview() {
    window.open("/Admin/Module/Omc/Profiles/PreviewProfile.aspx?PageID=" + pageID + "&original=" + encodeURIComponent(document.getElementById("previewUrl").value), "_blank", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no");
}

function pagePreviewCombined() {
    window.open("/Admin/Content/PreviewCombined.aspx?PageID=" + pageID + "&original=" + encodeURIComponent(document.getElementById("showUrl").value), "_blank", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no");
}

function copyParagraph() {
    if (!AllowParagraphOperations) { return false }
    var paragraphID = ContextMenu.callingID;
    if (isSelected(paragraphID)) {
        copyParagraphs();
        return;
    }
    copyParagraphs(paragraphID);
}
function copyParagraphs() {
    if (!AllowParagraphOperations) { return false }
    var SelectedIDList = "";
    if (arguments.length == 0) {
        SelectedIDList = getSelectedParagraphIds();
    }
    else {
        SelectedIDList = arguments[0];
    }
    if (SelectedIDList == "") { return }

    copyActionParams.Url = "/Admin/Content/Dialogs/CopyParagraphsToPage?area=" + areaID + "&CopyID=" + SelectedIDList;
    Action.Execute(copyActionParams);
}

function copyParagraphHere() {
    if (!AllowParagraphOperations) { return false }
    var paragraphID = ContextMenu.callingID;
    if (isSelected(paragraphID)) {
        copyParagraphsHere();
        return;
    }
    copyParagraphsHere(paragraphID);
}

function copyParagraphsHere(paragraphID, experimentTesting) {
    if (!AllowParagraphOperations) { return false }
    var SelectedIDList = "";
    if (!paragraphID) {
        SelectedIDList = getSelectedParagraphIds();
    }
    else {
        SelectedIDList = paragraphID;
    }
    if (SelectedIDList == "") { return }

    copyActionParams.Url = "/Admin/Content/Dialogs/CopyParagraphsToPage?area=" + areaID + "&CopyID=" + SelectedIDList + "&pageId=" + pageID + (experimentTesting ? "&isExperiment=true" : "");
    Action.Execute(copyActionParams);
}

function moveParagraph() {
    if (!AllowParagraphOperations) { return false }
    var paragraphID = ContextMenu.callingID;
    if (isSelected(paragraphID)) {
        moveParagraphs();
        return;
    }
    moveParagraphs(paragraphID);
}

function moveParagraphs() {
    if (!AllowParagraphOperations) { return false }
    var SelectedIDList = "";
    if (arguments.length == 0) {
        SelectedIDList = getSelectedParagraphIds();
    }
    else {
        SelectedIDList = arguments[0];
    }
    if (SelectedIDList == "") { return }

    moveActionParams.Url = "/Admin/Content/Dialogs/MoveParagraphsToPage?area=" + areaID + "&MoveID=" + SelectedIDList;
    Action.Execute(moveActionParams);
}

function toggleContentPlacegoldersView(element) {
    element.toggleClassName("collapsed");
    var paragraphsWrapper = element.parentElement.querySelectorAll(".paragraphsWrapper")[0];
    paragraphsWrapper.toggleClassName("hidded-content"); 
}

function _showHideToggleIcon(oldContainer, newContainer) {
    if (oldContainer.childElementCount == 0) {
        oldContainer.closest(".ContainerDummy").select("div.ContainerDiv i").last().toggleClassName("hidden");
    }
    if (newContainer.childElementCount == 1) {
        newContainer.closest(".ContainerDummy").select("div.ContainerDiv i").last().toggleClassName("hidden");
    }
}

function _expandToggledContainer(container) {
    container.removeClassName("hidded-content");
    container.closest(".ContainerDummy").select("div.ContainerDiv")[0].removeClassName("collapsed");
}

function report(reportName) {
    dialog.show("ReportsDialog", "/Admin/Content/PageTemplates/Reports/Page.aspx?Report=" + reportName + "&PageID=" + pageID);
}

function showWebPageAnalysisDialog() {
    dialog.show("WebPageAnalysisDialog", "/Admin/Content/PageTemplates/Reports/PagePerformanceReport.aspx?PageID=" + pageID);
}

function showOptimize() {
    dialog.show('OptimizeDialog', "Page/PageOptimize.aspx?PageID=" + pageID);
}

function showOMCPersonalization() {
    dialog.show('OMCPersonalizationDialog', "/Admin/Module/OMC/Emails/EmailPersonalization.aspx?pageID=" + pageID);
}

function showVisualEditor() {
    location.href = "/Admin/Content/ContentBuilder.aspx?ID=" + pageID;
}

function onGridRowContextMenuShown() {
    var gridRowMenu = ContextMenu.menuElement;
    var unpublishOption = gridRowMenu.querySelector("#UnpublishGridRowButton");
    var publishOption = gridRowMenu.querySelector("#PublishGridRowButton");

    var hiddenClass = "hidden";
    var gridRowContainer = document.getElementById(ContextMenu.callingID);   
    if (gridRowContainer.hasClassName("ShowFalse")) {
        publishOption.classList.remove(hiddenClass);
        unpublishOption.classList.add(hiddenClass);
    } else {
        publishOption.classList.add(hiddenClass);
        unpublishOption.classList.remove(hiddenClass);
    }
}

function toggleGridRowActive(active) {
    var gridRowId = ContextMenu.callingID.split("_")[2];
    var url = "/Admin/Content/ParagraphList.aspx?cmd=togglerowactive&GridRowID=" + gridRowId + "&active=" + active;

    location = url;
}

function showEditGridRowDialog() {
    var gridRowContainer = document.getElementById(ContextMenu.callingID);
    var gridId = gridRowContainer.closest("li.ContainerDummy").getAttribute("data-dw-grid-id");

    var stringArray = ContextMenu.callingID.split("_");
    var gridContainer = stringArray[1];
    var gridRowId = stringArray[2];

    var path = "/Admin/Content/GridRowEdit.aspx?PageId=" + pageID + "&ID=" + gridRowId + "&Container=" + gridContainer + "&GridId=" + gridId + "&VisualEditor=True";
    dialog.show("dlgEditGridRow", path);
}

function saveGridRow() {
    const frame = document.getElementById('dlgEditGridRowFrame');
    const frameWindow = frame.contentWindow;

    frame.onload = () => {
        dialog.hide("dlgEditGridRow");
        location.reload();
    };

    frameWindow.Dynamicweb.Items.ItemEdit.get_current().save();
}

function deleteGridRow() {
    var gridRowId = ContextMenu.callingID.split("_")[2];
    if (!confirm(`Are you sure you want to delete the row with id '${gridRowId}'?`))
        return;
    var url = "/Admin/Content/GridRowEdit.aspx?PageId=" + pageID + "&ID=" + gridRowId + "&cmd=delete";
    fetch(url).then(resp => {
        if (resp.ok) {
            location.reload();
        }
    }).catch((reason) => console.log("Unable to delete row", reason));
}

function copyGridRow() {
    var gridRowId = ContextMenu.callingID.split("_")[2];

    copyActionParams.Url = "/Admin/Content/Dialogs/CopyGridRowToPage?area=" + areaID + "&CopyID=" + gridRowId;
    Action.Execute(copyActionParams);
}

function copyGridRowHere() {
    var gridRowId = ContextMenu.callingID.split("_")[2];

    copyActionParams.Url = "/Admin/Content/Dialogs/CopyGridRowToPage?area=" + areaID + "&CopyID=" + gridRowId + "&pageId=" + pageID;
    Action.Execute(copyActionParams);
}

function showRowTemplateSettingsDialog() {
    var stringArray = ContextMenu.callingID.split("_");
    var gridRowId = stringArray[2];

    var path = "/Admin/Content/GridRowTemplateEdit.aspx?PageId=" + pageID + "&ID=" + gridRowId;
    dialog.show("dlgRowTemplateSettings", path);
}

function saveRowTemplate() {
    var frame = document.getElementById('dlgRowTemplateSettingsFrame');
    var frameWindow = frame.contentWindow;
    var doc = frameWindow.document;
    var form = doc.forms[0];
    var formData = new FormData(form);
    var templateName = doc.getElementById("TemplateName");
    if (!templateName.value) {
        dwGlobal.showControlErrors(templateName, Dynamicweb.ParagraphList.Translations["Required"]);
        templateName.focus();
        return;
    }
    else {
        dwGlobal.hideControlErrors(templateName);
    }
    var categoryTypeNew = doc.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0];
    var templateCategory = (categoryTypeNew == undefined || categoryTypeNew.checked ? doc.getElementById("TemplateNewCategory") : doc.getElementById("TemplateCategory"));
    if (!templateCategory.value) {
        dwGlobal.showControlErrors(templateCategory, Dynamicweb.ParagraphList.Translations["Required"]);
        templateCategory.focus();
        return;
    }
    else {
        dwGlobal.hideControlErrors(templateCategory);
    }

    frameWindow.fetch(form.action, {
        method: 'POST',
        body: formData
    }).then(function (resp) {
        if (resp.ok) {
            location.href = "/Admin/Content/ParagraphList.aspx?NavigatorSync=RefreshParentAndSelectPage&PageID=" + pageID;
        }
    }).catch(function (reason) { return console.log("An error occurred while saving the row template", reason); });
}