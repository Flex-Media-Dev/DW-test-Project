var pageID = 0;
var areaID = 0;

var PageEdit = {
    pageHasUnsavedChanges: false,

    init: function (PageID) {
        pageID = PageID;
        //if (top.left) {
        //    areaID = top.left.areaid;
        //}
        if (parent.AreaID) {
            areaID = parent.AreaID;
        }
        
        this.enableSorting();
        document.observe('EcomGroupTree:GroupsComplete', (function (event) { this.enableSorting(); }).bind(this));        
        
        var navMainDiv = $('NavigationGroupSelector_some_main_div');        
        navMainDiv.style.marginTop = '10px';

        document.getElementById("PageMenuText").focus();

        this._contentTypeList = $('PageContentType');
        this._newContentType = $$('input.page-content-type')[0];
    },

    enableSorting: function () {
        var groupValues = $('NavigationGroupSelector_some_value');
        Sortable.create("NavigationGroupSelector_some_div", {
            tag: 'div',
            onUpdate: (function (container) {
                var newValue = '',
                    children = container.childNodes;

                for (var i = 0; i < children.length; i++) {
                    newValue += '[g:' + children[i].id.replace('g_', '') + ']';
                }

                groupValues.value = newValue;
                groupValues.onchange();
            }).bind(this)
        });
    },

    showPage: function () {
        window.open(document.getElementById("previewUrl").value);
    },

    SetPublish: function () {
        if (!document.getElementById("chk_PageActive").checked) {
            document.getElementById("chk_PageActive").checked = true;
        }
    },

    SetUnPublish: function () {
        document.getElementById("chk_PageActive").checked = false;
    },

    SetPublishHide: function () {
        document.getElementById("chk_PageActive").checked = false;
    },

    SaveOk: function () {
        var pageNameEl = document.getElementById("PageMenuText");
        var val = Dynamicweb.Utilities.StringHelper.removeLineTerminators(pageNameEl.value);
        if (val.length < 1) {
            alert($('NoNameText').innerHTML);
            document.getElementById("PageMenuText").focus();
            return false;
        }
        pageNameEl.value = val;
        if (document.getElementById('PagePermission')) {
            if (document.getElementById('PagePermission').options) {
                for (i = 0; i < document.getElementById('PagePermission').options.length; i++) {
                    document.getElementById('PagePermission').options[i].selected = true;
                }
            }
        }
        if (document.getElementById('PageUrlName')) {
            var text = $("PageUrlName").value;
            if (/[\+\?\#\%\:\;\|\<\>\*]|\s{2}|\"{2}/.match(text)) {
                alert(NotAllowedURLCharacters);
                $("PageUrlName").focus();
                return false;
            }
        }
        if (document.getElementById('PageExactUrl')) {
        	var text = $("PageExactUrl").value;
        	if (/[\+\?\#\%\:\;\|\<\>\*\&]|\s{2}|\"{2}/.match(text)) {
        		alert(NotAllowedURLCharacters);
        		$("PageExactUrl").focus();
        		return false;
        	}
        }

        return true;
    },

    updateBreadCrumb: function () {
        var val = Dynamicweb.Utilities.StringHelper.removeLineTerminators(document.getElementById("PageMenuText").value);
        if (val.length > 0) {
            document.getElementById("BreadcrumbActive").innerText = val;
        }
    },

    SaveAndClose: function () {
        this.Save(true);
    },

    Save: function (close) {
        if (!PageEdit.SaveOk()) {
            __cancelOverlay = true;
            return false;
        }
        var self = this
        var itemEdit = Dynamicweb.Page.ItemEdit.get_current();

        itemEdit.validate(function (result) {
            if (result.isValid) {
                self.pageHasUnsavedChanges = false;
                // Fire event to handle saving
                window.document.fire("General:DocumentOnSave");

                document.getElementById("onSave").value = close ? "Close" : "Nothing"
                var form = document.getElementById("MainForm");
                form.target = "SaveFrame";
                if (typeof form.onsubmit == 'function') {
                    form.onsubmit();
                };
                form.submit();
            }
            __cancelOverlay = true;
        });
        return false;
    },

    Cancel: function () {
        var redirectTo = location = "/Admin/Content/ParagraphList.aspx?PageID=" + pageID;
        var parentPageID = parseInt(document.getElementById("ParentPageID").value);

        if (pageID <= 0) {
            redirectTo = location = "/Admin/Content/ParagraphList.aspx?PageID=" + parentPageID;
            if (parentPageID <= 0) {
            	redirectTo = '/Admin/Blank.aspx';
            }
        }

        if (document.location.search.indexOf('openedFromFrontend=True') > -1) {
        	close();
        	return;
        }

        location = redirectTo;
    },

    openContentTypeDialog: function() {
        dialog.show('ContentTypeDialog');
        this._newContentType.focus();
    },

    addContentType: function () {
        var i, max, value, option, options, add = true;

        if (!this._contentTypeList && !this._newContentType) {
            return;
        }
        
        if (!this._newContentType.value) {
            return;
        }

        options = this._contentTypeList.options;
        max = options.length;
        value = this._newContentType.value.strip().stripTags().stripScripts().toLowerCase();
        
        for (i = 0; i < max; i += 1) {
            option = options[i];
            
            if (value === option.value) {
                add = false;
                this._contentTypeList.value = option.value;
                break;
            }
        }
        
        if (add) {
            option = document.createElement('option');
            option.value = value;
            option.innerHTML = value;

            options.add(option);
            this._contentTypeList.value = value;
        }
        
        this._newContentType.value = '';
        dialog.hide('ContentTypeDialog');
    },
    showRestrictionRules: function () {
        dialog.show('dlgEditRestrictionRules');
    },
    hideRestrictionRules: function () {
        dialog.hide('dlgEditRestrictionRules');
    }
}

function setVisibility(elementID, isVisible) {
    var elm = document.getElementById(elementID);

    if (elm) {
        elm.style.display = (isVisible ? '' : 'none');
    }
}

function devicelayouts() {
	dialog.show("DeviceLayoutDialog");
}

function ShowLanguages() {
    dialog.show('LanguageDialog', LanguageUrl);
}

function showOrHide(box) {
	if (!box.checked) {
		document.getElementById("pwd").style.display = "none";
		document.getElementById("PagePassword").value = "";
	} else {
		document.getElementById("pwd").style.display = "";
	}
}

function openEditPermission(mode) {
    if (pageID == "0") {
        alert(pageNotSavedText);
        return false;
    }
    dialog.show('PagePermissionDialog', '/Admin/Content/Page/PagePermission.aspx?PageID=' + pageID + '&DialogID=PagePermissionDialog&Mode=' + mode);
}

function ShowNamedList() {
    if (pageID == "0" || PageEdit.pageHasUnsavedChanges) {
        alert(pageHasUnsavedChangesText);
        return false;
    }
    location = '/Admin/Content/Items/Editing/NamedItemListEdit.aspx?PageID=' + pageID;
}

function savePermission() {
    var permissionsFrame = document.getElementById('PagePermissionDialogFrame');
    var iFrameDoc = (permissionsFrame.contentWindow || permissionsFrame.contentDocument);
    if (iFrameDoc.document) iFrameDoc = iFrameDoc.document;
    iFrameDoc.getElementById("PagePermissionForm").submit();
}

function changeSSLMode(sslMode) {
    var previousSSLMode = "";

    if (useSSLOption == "0") {
        previousSSLMode = "cmdSSLStandard";
    } else if (useSSLOption == "1") {
        previousSSLMode = "cmdSSLForce";
    } else if (useSSLOption == "2") {
        previousSSLMode = "cmdSSLUnforce";
    }

    if (sslMode != previousSSLMode) {
        var sslOptionConfirmed = confirm(sslConfirmation1 + "'" + document.getElementById(previousSSLMode).title + "'" + sslConfirmation2 + "'" + document.getElementById(sslMode).title + "' ?");
        if (sslOptionConfirmed != true) {
            document.getElementById("cmdSSLStandard").className = "ribbon-section-button";
            document.getElementById("cmdSSLForce").className = "ribbon-section-button";
            document.getElementById("cmdSSLUnforce").className = "ribbon-section-button";
            document.getElementById(previousSSLMode).className = "ribbon-section-button active";
            document.getElementById("radio_SSLMode_selected").value = previousSSLMode;
            if (document.getElementById("SSLMode") != null) {
                document.getElementById("SSLMode").value = useSSLOption;
            } else {
                document.getElementById("radio_SSLMode").value = useSSLOption;
            }
        } else {
            document.getElementById("cmdSSLStandard").className = "ribbon-section-button";
            document.getElementById("cmdSSLForce").className = "ribbon-section-button";
            document.getElementById("cmdSSLUnforce").className = "ribbon-section-button";
            document.getElementById(sslMode).className = "ribbon-section-button active";
        }
    }
}

var ElemCounter;

function ShowCounters(field, counter, counterMax) {

    HideCounter();

    if (field == 'undefined') return;

    var elemCounter = document.getElementById(counter);
    if (elemCounter == 'undefined') return;

    var elemCounterMax = document.getElementById(counterMax);
    if (elemCounterMax == 'undefined') return;

    ShowCounter(elemCounter, elemCounterMax.value, field.value.length);
    ElemCounter = elemCounter;

}

function HideCounter() {
    if (ElemCounter) {
        setTextContent(ElemCounter, '');
    }
}


function CheckAndHideCounter(field, counter, counterMax) {

    if (CheckCounter(field, counter, counterMax) == true) {

        HideCounter();
    }
}

function CheckCounter(field, counter, counterMax) {

    if (field == 'undefined') return false;

    var elemCounter = document.getElementById(counter);
    if (elemCounter == 'undefined') return false;

    var elemCounterMax = document.getElementById(counterMax);
    if (elemCounterMax == 'undefined') return false;

    ShowCounter(elemCounter, elemCounterMax.value, field.value.length);
    return true;
}

function ShowCounter(elemCounter, maxSize, currentSize) {

    if (currentSize < maxSize) {
        setTextContent(elemCounter, (maxSize - currentSize) + ' ' + remainingText);
    }
    else {
        setTextContent(elemCounter, recommendedText);
    }

    var sizeInPercentage = 100;

    if (maxSize > 0) {
        sizeInPercentage = currentSize * 100 / maxSize;
    }

    if (sizeInPercentage < 80) {
        elemCounter.style.color = '#7F7F7F';
    }
    else if (sizeInPercentage < 90) {
        elemCounter.style.color = '#000000';
    }
    else {
        elemCounter.style.color = '#FF0000';
    }
}

function setTextContent(element, text) {
	while (element.firstChild !== null) {
		element.removeChild(element.firstChild); // remove all existing content 
	}
	element.appendChild(document.createTextNode(text));
}

function comments() {
	dialog.show('CommentsDialog', '/Admin/Content/Comments/List.aspx?Type=page&ItemID=' + pageID);
}

function AccessibilityCheckboxClick(checkbox) {
    var originalCheckboxId = checkbox.id.substring(0, checkbox.id.length - 1);
    document.getElementById(originalCheckboxId).checked = checkbox.checked;
}

/* Page property item */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Page) == 'undefined') {
    Dynamicweb.Page = new Object();
}

Dynamicweb.Page.ItemEdit = function () {
    this._terminology = {};
    this._cancelUrl = '';
    this._page = '';
    this._itemType = '';
    this._validation = null;
    this._validationPopup = null;
}

Dynamicweb.Page.ItemEdit._instance = null;

Dynamicweb.Page.ItemEdit.get_current = function () {
    if (!Dynamicweb.Page.ItemEdit._instance) {
        Dynamicweb.Page.ItemEdit._instance = new Dynamicweb.Page.ItemEdit();
    }

    return Dynamicweb.Page.ItemEdit._instance;
}

Dynamicweb.Page.ItemEdit.prototype.get_validation = function () {
    if (!this._validation) {
        this._validation = new Dynamicweb.Validation.ValidationManager();
    }

    return this._validation;
}

Dynamicweb.Page.ItemEdit.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Page.ItemEdit.prototype.get_page = function () {
    return this._page;
}

Dynamicweb.Page.ItemEdit.prototype.set_page = function (value) {
    this._page = value;
}

Dynamicweb.Page.ItemEdit.prototype.get_itemType = function () {
    return this._itemType;
}

Dynamicweb.Page.ItemEdit.prototype.set_itemType = function (value) {
    this._itemType = value;
}

Dynamicweb.Page.ItemEdit.prototype.initialize = function () {
    setTimeout(function () {
        if (typeof (Dynamicweb.Controls) != 'undefined' && typeof (Dynamicweb.Controls.OMC) != 'undefined' && typeof (Dynamicweb.Controls.OMC.DateSelector) != 'undefined') {
            Dynamicweb.Controls.OMC.DateSelector.Global.set_offset({ top: -138, left: Prototype.Browser.IE ? 1 : 0 }); // Since the content area is fixed to screen at 138px from top (Edititem.css)
        }
    }, 500);
}

Dynamicweb.Page.ItemEdit.prototype.validate = function (onComplete) {
    if (Dynamicweb.Items.GroupVisibilityRule) {
        Dynamicweb.Items.GroupVisibilityRule.get_current().filterValidators(this.get_validation()).beginValidate(onComplete);
    } else {
        this.get_validation().beginValidate(onComplete);
    };
}

Dynamicweb.Page.ItemEdit.prototype.openItemType = function () {
    dialog.show("ChangeItemTypeDialog");
}

Dynamicweb.Page.ItemEdit.prototype.changeItemType = function () {
    var systemName;

    systemName = $("ItemTypeSelect").value;
    if (this.get_itemType() != systemName) {
        if (confirm(this.get_terminology()['ChangeItemTypeConfirm'])) {
            //this.showWait();
            location = '/Admin/Content/Items/Editing/ItemEdit.aspx?PageID=' + pageID + '&cmd=changeItemType&ItemTypeSelect=' + systemName;
        }
        else {
            return;
        }
    }

    dialog.hide("ChangeItemTypeDialog");
}

Dynamicweb.Page.ItemEdit.prototype.cancelChangeItemType = function () {
    var ItemTypeSelect = null;

    if (this.get_itemType())
        ItemTypeSelect = "ItemTypeSelect" + this.get_itemType();
    else
        ItemTypeSelect = "ItemTypeSelectdwrichselectitem";

    ItemTypeSelect = $(ItemTypeSelect);
    if (ItemTypeSelect) RichSelect.setselected(ItemTypeSelect.down("div"), "ItemTypeSelect");

    dialog.hide("ChangeItemTypeDialog");
}