var pageID = 0;

var areaID = 0;

var loaded = false;
var templatesInitialized = false;

/* Indicates whether to wait for module settings to be retrieved
before to process saving of the paragraph */
var __wait_module_settings = false;

window.onresize = resize;

var btnNavigation = false;
window.onbeforeunload = function (evt) {
    if (!btnNavigation && paragraphCancelWarn) {
        setTimeout(function () { 
            var screenLoader = document.getElementById("screenLoaderOverlay");
            if (screenLoader) {
                screenLoader.style.display = "none";
            }
        }, 150);
        return paragraphCancelWarnText;
    }
    btnNavigation = false;
}

function getClientHeight(height) {

    var h = document.documentElement.clientHeight - $("myribbon").getHeight() - $("formTable").getHeight() - $("breadcrumb").getHeight();
    if (h < 0) h = 0;
    if (h >= 20) h -= 20;
    return h;
}
function myInit(PageID) {
    pageID = PageID;
    if (typeof editor != "undefined" && typeof editor.init != "undefined") {
        editor.init();
    }
    areaID = document.getElementById("AreaID").value;
    setHeight();
    loaded = true;
    $("ParagraphHeader").focus();
}

function SaveOk() {
    if (!loaded) {
        return false;
    }

    if (typeof editor != "undefined" && typeof editor.save != "undefined") {
        editor.save();
    }

    if (document.getElementById("ParagraphHeader").value.length < 1) {
        alert($("mSpecifyName").innerHTML);

        //Ribbon.radioButton('cmdViewText', 'cmdViewText', 'GroupView');
        ParagraphView.switchMode(ParagraphView.mode.text);

        $("ParagraphHeader").focus();

        return false;
    }

    //itembased paragraph name
    if (Dynamicweb.Paragraph.ItemEdit.get_current().get_itemType() && $("ParagraphHeader2") && $("ParagraphHeader2").value.length < 1) {
        alert($("mSpecifyName").innerHTML);
        $("ParagraphHeader2").focus();
        return false;
    }

    if ($("ParagraphModule__Frame").contentWindow.paragraphEvents != null
        && $("ParagraphModule__Frame").contentWindow.paragraphEvents != "undefined") {
        return $("ParagraphModule__Frame").contentWindow.paragraphEvents.validateInvoke();
    }
    return true;
}

function updateBreadCrumb() {
    if (document.getElementById("ParagraphHeader").value.length > 0) {
        document.getElementById("BreadcrumbParagraphHeader").innerText = document.getElementById("ParagraphHeader").value;
    }
}

var GlobalUrl = "";
function ShowGlobals() {
    dialog.show("GlobalsDialog", GlobalUrl);
}

function ShowVersions() {
    dialog.show("VersionsDialog", VersionUrl);
}

function ShowLanguages() {
    dialog.show("LanguageDialog", LanguageUrl);
}

function compareToMaster() {
    var loc = "ParagraphCompare.aspx?ID=" + document.getElementById("ID").value + "&PageID=" + parent.pageID + "&MasterID=" + document.getElementById("MasterID").value;
    window.open(loc, "", "width=855,height=550,toolbar=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no");

}

function SaveAndClose(caller) {
    Save(true, caller);
}

function Save(close, caller) {
    btnNavigation = true;
    if (!SaveOk()) {
        __cancelOverlay = true;
        btnNavigation = false;
        return false;
    }

    /* Deactivating saving buttons */
    toggleSavingButtons(false);

    /* Retrieving module settings first, then - saving paragraph */
    var success = retrieveModuleSettings(function () {
        document.getElementById("onSave").value = close ? "Close" : "Nothing";
        // Fire event to handle saving
        window.document.fire("General:DocumentOnSave");

        var form = document.getElementById("ParagraphForm");
        form.target = "SaveFrame";
        if (typeof form.onsubmit == "function") {
            form.onsubmit();
        };
        form.submit();

        /* Activating saving buttons back */
        if (!close) {
            toggleSavingButtons(true);
        }
    });
    if (!success) {
        __cancelOverlay = true;
        btnNavigation = false;
        return false;
    }
}

function saveAsTemplate() {
    dialog.show("SaveAsTemplateDialog");
}

function changeCategoryType() {
    var categoryTypeNew = document.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0];

    if (categoryTypeNew.checked) {
        document.getElementById("TemplateNewCategoryDiv").style.display = '';
        document.getElementById("TemplateExistingCategoriesDiv").style.display = 'none';
    }
    else {
        document.getElementById("TemplateNewCategoryDiv").style.display = 'none';
        document.getElementById("TemplateExistingCategoriesDiv").style.display = '';
    }
}

function saveAsTemplateOk() {
    var templateName = document.getElementById("TemplateName");
    if (!templateName.value) {
        dwGlobal.showControlErrors(templateName, requiredValueWarn);
        templateName.focus();
        return;
    }
    else {
        dwGlobal.hideControlErrors(templateName);
    }

    var categoryTypeNew = document.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0] || { checked: true };
    var templateCategory = categoryTypeNew.checked ? document.getElementById("TemplateNewCategory") : document.getElementById("TemplateCategory");
    if (!templateCategory.value) {
        dwGlobal.showControlErrors(templateCategory, requiredValueWarn);
        templateCategory.focus();
        return;
    }
    else {
        dwGlobal.hideControlErrors(templateCategory);
    }

    var url = "/Admin/Content/ParagraphEdit.aspx?cmd=saveastemplate&ID=" + document.getElementById("ID").value
        + "&TemplateName=" + encodeURI(templateName.value)
        + "&TemplateDescription=" + encodeURI(document.getElementById("TemplateDescription").value)
        + "&TemplateImage=" + encodeURI(document.getElementById("FM_TemplateImage").value)
        + "&TemplateCategory=" + encodeURI(templateCategory.value);
    location = url;
}

function saveAsTemplateCancel() {
    dialog.hide("SaveAsTemplateDialog");
}

/* Retrieves module settings from the 'Edit module' iframe */
function retrieveModuleSettings(onRetrieved) {
    var frame = $("ParagraphModule__Frame"),
        itemEdit = Dynamicweb.Paragraph.ItemEdit.get_current(),
        getSettings = function () {
            if (typeof (frame.contentWindow["submitForm"]) == "function" &&
            frame.contentWindow.document.getElementById("innerContent")) {
                __wait_module_settings = true;

                /* Submitting module settings */
                frame.contentWindow["submitForm"]();

                /* Waiting for settings to be received by hosting window */
                waitModule(onRetrieved);
            } else {
                if (typeof (onRetrieved) == "function")
                    onRetrieved();
            }
        };

    var success = true;
    if (itemEdit.get_itemType()) {
        itemEdit.validate(function (result) {
            if (result.isValid && typeof (onRetrieved) == "function") {
                var beadCrumb = $("BreadcrumbParagraphHeader");
                if ($("ParagraphHeader2") != null) {
                    if (beadCrumb != null)
                        beadCrumb.innerText = $("ParagraphHeader2").value;
                    $("footerParagraphHeader").innerText = $("ParagraphHeader2").value;
                } else {
                    if (beadCrumb != null)
                        beadCrumb.innerText = $("itemParagraphTitle").value;
                    $("footerParagraphHeader").innerText = $("itemParagraphTitle").value;
                }

                getSettings();
            }
            else {
                toggleSavingButtons(true);
                btnNavigation = false;
                //Ribbon.radioButton('cmdViewItem', 'cmdViewItem', 'GroupView');
                ParagraphView.switchMode(ParagraphView.mode.item);
                success = false;
            }
        });
    }
    else if (frame) {
        getSettings();
    }
    return success;
}

/* Toggles saving buttons activity state */
function toggleSavingButtons(enable) {
    if (enable) {
        //Ribbon.enableButton('Save');
        //Ribbon.enableButton('SaveAndClose');
    } else {
        //Ribbon.disableButton('Save');
        //Ribbon.disableButton('SaveAndClose');
    }
}

/* Waits for the module settings to be received from the 'Edit module' iframe */
function waitModule(onComplete) {
    /* Still needs to wait ? */
    if (__wait_module_settings) {
        setTimeout(function () { waitModule(onComplete); }, 50);
    } else {
        /* Settings retrieved - executing 'onComplete' callback */
        if (typeof (onComplete) == "function")
            onComplete();
    }
}

function showPage() {
    if (!loaded) {
        return false;
    }
    //window.open("/Default.aspx?ID=" + pageID + "&Purge=True");
    window.open(document.getElementById("previewUrl").value);
}

function pageResizePreview() {
    window.open("/Admin/Content/PreviewResizable.aspx?original=" + encodeURIComponent(document.getElementById("previewUrl").value), "_blank", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no");
}

function Cancel() {
    if (!loaded) {
        return false;
    }
    btnNavigation = true;
    location = "ParagraphList.aspx?mode=viewparagraphs&PageID=" + pageID + "&unlock=" + document.getElementById("ID").value;
}

function setHeight() {
    var h = (document.documentElement.clientHeight);
    var style = window.getComputedStyle(document.body);
    var paddingTop = parseFloat(style.paddingTop);
    var pModule = $("ParagraphModule__Frame");

    // Magic numbers that seem to fix:
    // 3px for margin/padding when using Visual Editor
    // 183px for the ribbon and breadcrumb and (10 + 10)px for padding on body when using paragraph edit.
    var editorAreaHeight = paddingTop === 0 ? 3 : 183 + 10 + 10;
    if (h >= editorAreaHeight) {
        pModule.setStyle({ height: (h - editorAreaHeight) + "px" });
    }
    if (paddingTop === 0) {
        resizeEditors();
    }
}

function resizeEditors() {
    if (window.CKEDITOR) {
        for (var i in CKEDITOR.instances) {
            (function (i) {
                var editor = CKEDITOR.instances[i];
                editor.on("instanceReady", function () {
                    editor.resize('100%', '100%');
                });
            })(i);
        }
    }
}

function resize() {
    if (loaded) {
        setHeight();
    }
}

/*function onTemplateSelected(templateID) {
$('ParagraphTemplateID').value = templateID;

tmplScrollable_scrollable.hidePopUp();
__preview_large_show = false;
ParagraphTemplateZoom.hide();
}*/

function onTemplateSelected(sender, args) {
    $("ParagraphTemplateID").value = args.selectedTemplateID;
}



/* ++++++ Represents paragraph view type ++++++ */

var ParagraphView = new Object();

/* View mode - paragraph text or module settings */
ParagraphView.mode = { text: 0, module: 1, item: 2 };

/* Current view mode */
ParagraphView.currentMode = ParagraphView.mode.text;

/* Switches to the specified view mode */
ParagraphView.switchMode = function (mode) {
    var areas = ["textContent", "moduleContent", "itemContent"];
    var ribbonButtons = ["cmdViewText", "cmdViewModule", "cmdViewItem"];

    /* Current mode has been changed ? */
    if (ParagraphView.currentMode != mode) {
        for (var i = 0; i < areas.length; i++) {
            if (mode == i) {
                $(areas[i]).show();
                $(ribbonButtons[i]).addClassName("active");
                $("radio_GroupView_selected").value = ribbonButtons[i];
            }
            else {
                $(areas[i]).hide();
                if ($(ribbonButtons[i])) { $(ribbonButtons[i]).removeClassName("active"); }
            }
        }

        if (document.getElementById("BottomInformationBg")) {
            if (areas[mode] == "moduleContent") {
                document.getElementById("BottomInformationBg").style.display = "none";
            } else {
                document.getElementById("BottomInformationBg").style.display = "";
            }
        }
        ParagraphView.currentMode = mode;

        setTimeout(function () { setHeight(); }, 15);

        /* Loading module settings if current mode is 'Module settings' */
        if (mode == ParagraphView.mode.module)
            ParagraphModule.loadModule();
    }
}

/* ++++++ Handles module-specified operations on the paragraph ++++++ */

var ParagraphModule = new Object();

/* Loads module settings */
ParagraphModule.loadModule = function () {
    var frame = null;
    var paragraphID = parseInt($("ID").value);
    pageID = parseInt($("ParagraphPageID") ? $("ParagraphPageID").value : pageID);
    areaID = parseInt($("AreaID") ? $("AreaID").value : areaID);

    if ($("moduleContent").getStyle("display") != "none") {
        frame = $("ParagraphModule__Frame");

        /* Settings hasn't been loaded yet */
        if (frame.readAttribute("src").length == 0) {
            ParagraphModule.toggleLoading(true);

            /* Loading settings into the iframe */
            frame.writeAttribute("src", "/Admin/Content/ParagraphEditModule.aspx?ID=" + paragraphID +
                "&PageID=" + pageID + "&AreaID=" + areaID +
			    "&ShowToolbar=False&OnLoadCallback=ParagraphModule_toggleLoading" +
                "&OnCompleteCallback=ParagraphModule_onSettingsChanged&OnRemoveCallback=ParagraphModule_onModuleRemoved");
        }
    }
}

/* Applies module settings to the paragraph */
ParagraphModule.onSettingsChanged = function (pid, moduleName, moduleSettings) {
    $("ParagraphModuleSystemName").value = moduleName;
    $("ParagraphModuleSettings").value = moduleSettings;

    /* Reset waiting flag (indicates that we can process with other operations) */
    __wait_module_settings = false;
}

/* Removes module from the paragraph */
ParagraphModule.onModuleRemoved = function (pid) {
    ParagraphModule.onSettingsChanged(pid, "", "");
}

/* Toggles 'Loading' image visibility */
ParagraphModule.toggleLoading = function (show) {
    if ($("moduleContent").getStyle("display") != "none") {
        if (show) {
            $("imgProcessing").show();
            $("moduleInnerContent").hide();
        } else {
            $("imgProcessing").hide();
            $("moduleInnerContent").show();

            ParagraphModule.initializeSettingsPage();
        }
    }
}

/* Initializes module settings page when it's loaded */
ParagraphModule.initializeSettingsPage = function () {
    var frame = $("ParagraphModule__Frame");
    var wnd = null;
    var content = null;

    if (frame) {
        wnd = frame.contentWindow;

        try {
            $(wnd.document.body).setStyle({
                border: "0px solid black",
                backgroundColor: "#ffffff",
                marginTop: "0px"
            });
        } catch (ex) { }

        content = wnd.document.getElementById("mainContent");

        if (!content)
            content = wnd.document.getElementById("innerContent");

        if (content) {
            try {
                $(content).setStyle({
                    border: "0px solid black"
                });
            } catch (ex) { }
        }
    }
}

/* ++++++ Event wrappers for module settings page ++++++ */

/* Fires when module settings page is loaded */
function ParagraphModule_toggleLoading() {
    ParagraphModule.toggleLoading(false);
}

/* Fires when module settings has been retrieved */
function ParagraphModule_onSettingsChanged(pid, moduleName, moduleSettings) {
    ParagraphModule.onSettingsChanged(pid, moduleName, moduleSettings);

}

/* Fires when module has been removed */
function ParagraphModule_onModuleRemoved() {
    ParagraphModule.onModuleRemoved();
    return false;
}

function savePermissions() {
    var permissionsFrame = document.getElementById("ParagraphPermissionDialogFrame");
    var iFrameDoc = (permissionsFrame.contentWindow || permissionsFrame.contentDocument);
    if (iFrameDoc.document) iFrameDoc = iFrameDoc.document;
    iFrameDoc.getElementById("PagePermissionForm").submit();
    dialog.hide("ParagraphPermissionDialog");
}

function imageSettingsValid() {

    var images = document.getElementById("FM_ParagraphImage");
    if (images && images[images.selectedIndex].value == "") {
        return true;
    }

    var caption = $("ParagraphImageCaption");
    var alt = $("ParagraphImageMouseOver");

    return caption.value.length > 0 && alt.value.length > 0;
}

function saveImageSettings() {
    if (!imageSettingsValid()) {
        alert($("imageSettingsValidationMessage").value);
    }
    else {
        dialog.hide("ImageSettingsDialog");
    }
}


function setMasterValue(strFieldName, NewValue) {
    var form = document.getElementById("ParagraphForm");
    if (strFieldName == "ParagraphImage" && NewValue.indexOf("/") > 0) {
        selObj = form.elements[strFieldName];
        selObj.options.length = selObj.options.length + 1;
        selObj.options[selObj.options.length - 1].value = NewValue;
        selObj.options[selObj.options.length - 1].text = NewValue;
        selObj.selectedIndex = selObj.options.length - 1;
    }
    else {
        if (strFieldName == "ParagraphText") {
            if (CKEDITOR && CKEDITOR.instances[strFieldName]) {
                CKEDITOR.instances[strFieldName].setData(NewValue);
            } else if (FCKeditorAPI && FCKeditorAPI.GetInstance(strFieldName)) {
                FCKeditorAPI.GetInstance(strFieldName).SetHTML(NewValue);
            }
        } else {
            var element = form.elements[strFieldName];
            if (element.type && element.type === "checkbox") {
                element.checked = (NewValue === "True" || NewValue === "true");
            } else if (element.length > 0 && element[0].getAttribute("id") === strFieldName + "_0") {
                var vals = NewValue.split(",");
                for (var i = 0; i < element.length; i++) {
                    var chkbox = element[i];
                    chkbox.checked = (vals.indexOf(chkbox.value) != -1);
                }
            } else if (element.tagName === "SELECT") {
                if (element.className.lastIndexOf("FileManagerSelect", 0) === 0 && NewValue.indexOf("/") > -1) {
                    for (var i = 0; i < element.options.length; i++) {
                        if (element.options[i].getAttribute("fullpath") === NewValue) {
                            element.selectedIndex = i;
                        }
                    }
                } else {
                    for (var i = 0; i < element.options.length; i++) {
                        if (element.options[i].value === NewValue) {
                            element.selectedIndex = i;
                        }
                    }
                }
            } else if (window[strFieldName + "_Richselect"]) {
                RichSelect.setselected($(strFieldName + "_selectitems").select('li[data-value="' + NewValue + '"]')[0].firstDescendant(), strFieldName);
            } else {
                element.value = NewValue;
            }
        }
    }
}

var ParagraphEdit = {
    Marketing: null,

    openContentRestrictionDialog: function () {
        this.Marketing.openSettings("ContentRestriction", { data: { ItemType: "Paragraph", ItemID: $F("ID") } });
    },

    openProfileDynamicsDialog: function () {
        this.Marketing.openSettings("ProfileDynamics", { data: { ItemType: "Paragraph", ItemID: $F("ID") } });
    }
}

function Toggle_UseAltImage(el) {
    if (document.getElementById("UseAltImageSection").style.display == "none") {
        document.getElementById("UseAltImageSection").style.display = "table";
        document.getElementById("AlternativePictureBoxIcon").addClassName("fa-minus");
        document.getElementById("AlternativePictureBoxIcon").removeClassName("fa-plus");
    } else {
        document.getElementById("UseAltImageSection").style.display = "none";
        document.getElementById("AlternativePictureBoxIcon").addClassName("fa-plus");
        document.getElementById("AlternativePictureBoxIcon").removeClassName("fa-minus");
    }
}

if (typeof (Dynamicweb) == "undefined") {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Paragraph) == "undefined") {
    Dynamicweb.Paragraph = new Object();
}

Dynamicweb.Paragraph.ItemEdit = function () {
    this._terminology = {};
    this._cancelUrl = "";
    this._paragraph = "";
    this._itemType = "";
    this._validation = null;
    this._validationPopup = null;
}

Dynamicweb.Paragraph.ItemEdit._instance = null;

Dynamicweb.Paragraph.ItemEdit.get_current = function () {
    if (!Dynamicweb.Paragraph.ItemEdit._instance) {
        Dynamicweb.Paragraph.ItemEdit._instance = new Dynamicweb.Paragraph.ItemEdit();
    }

    return Dynamicweb.Paragraph.ItemEdit._instance;
}

Dynamicweb.Paragraph.ItemEdit.prototype.get_validation = function () {
    if (!this._validation) {
        this._validation = new Dynamicweb.Validation.ValidationManager();
    }

    return this._validation;
}

Dynamicweb.Paragraph.ItemEdit.prototype.get_terminology = function () {
    return this._terminology;
}

Dynamicweb.Paragraph.ItemEdit.prototype.get_validationPopup = function () {
    if (this._validationPopup && typeof (this._validationPopup) == "string") {
        this._validationPopup = eval(this._validationPopup);
    }

    return this._validationPopup;
}

Dynamicweb.Paragraph.ItemEdit.prototype.set_validationPopup = function (value) {
    this._validationPopup = value;
}

Dynamicweb.Paragraph.ItemEdit.prototype.get_paragraph = function () {
    return this._paragraph;
}

Dynamicweb.Paragraph.ItemEdit.prototype.set_paragraph = function (value) {
    this._paragraph = value;
}

Dynamicweb.Paragraph.ItemEdit.prototype.get_itemType = function () {
    return this._itemType;
}

Dynamicweb.Paragraph.ItemEdit.prototype.set_itemType = function (value) {
    this._itemType = value;
}

Dynamicweb.Paragraph.ItemEdit.prototype.initialize = function (options) {
    ParagraphView.switchMode(ParagraphView.mode.item);

    setTimeout(function () {
        if (typeof (Dynamicweb.Controls) != "undefined" && typeof (Dynamicweb.Controls.OMC) != "undefined" && typeof (Dynamicweb.Controls.OMC.DateSelector) != "undefined") {
            Dynamicweb.Controls.OMC.DateSelector.Global.set_offset({ top: -138, left: Prototype.Browser.IE ? 1 : 0 }); // Since the content area is fixed to screen at 138px from top (Edititem.css)
        }
    }, 500);

    if (options && options.masterItem && Array.isArray(options.masterItem)) {
        for (var i = 0; i < options.masterItem.length; i++) {
            var itemField = options.masterItem[i];
            var icon = document.createElement("i");
            icon.className = itemField.isMatch ? options.matchIcon : options.notMatchIcon;
            icon.title = itemField.isMatch ? options.matchTitle : options.notMatchTitle;

            var itemControl = $$('[name="' + itemField.fieldName + '"]')[0] || $(itemField.fieldName);

            if (!itemField.isMatch) {
                icon.onclick = (function (itemField) {
                    setMasterValue(itemField.fieldName, itemField.masterFieldValue);
                }).bind(null, itemField);
                icon.style.cursor = "pointer";
                switch (itemField.fieldType) {
                    case "ItemLinkEditor":
                    case "LinkEditor":
                        icon.onclick = (function (itemField) {
                            setMasterValue(itemField.fieldName, itemField.masterFieldValue);
                            setMasterValue("Link_" + itemField.fieldName, itemField.masterFieldValue);
                        }).bind(null, itemField);
                        break;
                    case "FileEditor":
                        icon.onclick = (function (itemField) {
                            setMasterValue(itemField.fieldName, itemField.masterFieldValue);
                            setMasterValue(itemField.fieldName + "_path", itemField.masterFieldValue);
                        }).bind(null, itemField);
                        break;
                    case "FolderEditor":
                        icon.onclick = (function (itemField) {
                            setMasterValue(itemField.fieldName, itemField.masterFieldValue.substring(6));
                        }).bind(null, itemField);
                        break;
                    case "DateEditor":
                    case "DateTimeEditor":
                        icon.onclick = (function (itemField) {
                            var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
                            var date = new Date(itemField.masterFieldValue.year,
                                itemField.masterFieldValue.month - 1,
                                itemField.masterFieldValue.day,
                                itemField.masterFieldValue.hour,
                                itemField.masterFieldValue.minute);
                            if (datepicker != null) {
                                datepicker.UpdateCalendarDate(date, itemField.fieldName);
                            }
                        }).bind(null, itemField);
                        break;
                    case "GeolocationEditor":
                        icon.onclick = (function (itemField) {
                            setMasterValue(itemField.fieldName + ".Lat", itemField.masterFieldValue.lat);
                            setMasterValue(itemField.fieldName + ".Lng", itemField.masterFieldValue.lng);
                        }).bind(null, itemField);
                        break;
                    case "RichTextEditor":
                        icon.onclick = (function (itemField) {
                            if (CKEDITOR && CKEDITOR.instances[itemField.fieldName]) {
                                CKEDITOR.instances[itemField.fieldName].setData(itemField.masterFieldValue);
                            } else if (FCKeditorAPI && FCKeditorAPI.GetInstance(itemField.fieldName)) {
                                FCKeditorAPI.GetInstance(itemField.fieldName).SetHTML(itemField.masterFieldValue);
                            }
                        }).bind(null, itemField);
                        break;
                    case "ProductEditor":
                        icon.onclick = (function (itemField) {
                            var productListBox = window[itemField.fieldName + "_ProductListBox"];
                            if (productListBox) {
                                productListBox.clear();
                                productListBox.set_dataSource(JSON.parse(itemField.masterFieldValue));
                            }
                        }).bind(null, itemField);
                        break;
                    case "UserEditor":
                        itemControl = $(itemField.fieldName + "hidden");
                        icon.onclick = (function (itemField) {
                            var userSelector = window["UserSelector" + itemField.fieldName];
                            if (userSelector) {
                                userSelector.ClearUsers();
                                userSelector.set_dataSource(JSON.parse(itemField.masterFieldValue));
                            }
                        }).bind(null, itemField);
                        break;
                    case "EditableListEditor":
                        icon.onclick = (function (itemField) {
                            var editableListBox = window[itemField.fieldName + "_EditableListBox"];
                            if (editableListBox) {
                                editableListBox.clear();
                                editableListBox.set_values(itemField.masterFieldValue);
                            }
                        }).bind(null, itemField);
                        break;
                    case "GoogleFontEditor":
                        itemControl = $(itemField.fieldName + "-selectedFont");
                        icon.onclick = (function (itemField) {
                            var googleFontInstance = window[itemField.fieldName + "GoogleFont"];
                            if (googleFontInstance) {
                                $(googleFontInstance._selectedFontHiddenId).value = itemField.masterFieldValue.family;
                                $(googleFontInstance._selectedFontPreviewSpanId).innerText = itemField.masterFieldValue.family;
                                $(googleFontInstance._variantSelectorId).innerHTML = '';

                                var option = document.createElement("option");
                                option.innerText = itemField.masterFieldValue.selectedVariant;
                                option.value = itemField.masterFieldValue.selectedVariant;

                                $(googleFontInstance._variantSelectorId).appendChild(option);
                            }
                        }).bind(null, itemField);
                        break;
                    case "ItemRelationListEditor":
                        if (itemField.showIcon) {
                            icon.onclick = (function (itemField) {
                                this.synchronizeListField(itemField);
                            }).bind(this, itemField);
                        }
                        else {
                            icon = null;
                        }

                        break;
                }
            }
            if (itemControl && icon) {
                var fieldvalueContainer = itemControl.up(".item-field-value-container");
                var fieldLabelCell = fieldvalueContainer.previous("td");
                var versionRestoreContainer = fieldLabelCell.select("span")[0];

                var container = document.createElement("span");
                container.innerText = " ";
                container.appendChild(icon);

                versionRestoreContainer.appendChild(container);
            }
        }
    }
};

Dynamicweb.Paragraph.ItemEdit.prototype.synchronizeListField = function (itemField) {
    if (confirm(synchronizeListConfirmText)) {
        this.showWait();
        btnNavigation = true;
        $("cmd").value = "synchronizeListField_" + itemField.fieldName;
        $("ParagraphForm").submit();
    }
};

Dynamicweb.Paragraph.ItemEdit.prototype.validate = function (onComplete) {
    if (Dynamicweb.Items.GroupVisibilityRule) {
        Dynamicweb.Items.GroupVisibilityRule.get_current().filterValidators(this.get_validation()).beginValidate(onComplete);
    } else {
        this.get_validation().beginValidate(onComplete);
    }
};

Dynamicweb.Paragraph.ItemEdit.prototype.showWait = function () {
    new overlay("PleaseWait").show();
}

Dynamicweb.Paragraph.ItemEdit.prototype.openItemType = function () {
    dialog.show("ChangeItemTypeDialog");
}

Dynamicweb.Paragraph.ItemEdit.prototype.changeItemType = function () {
    var systemName;
    var moduleConfirm = "";

    if ($("ParagraphModuleSystemName").value != "") {
        moduleConfirm = " " + $("moduleConfirmText").value;
    }
    systemName = $("ItemTypeSelect").value;
    if (this.get_itemType() != systemName) {
        if (confirm($("changeItemTypeConfirm").value + moduleConfirm || !this.get_itemType())) {
            this.showWait();
            btnNavigation = true;
            $("cmd").value = "changeItemType";
            $("ParagraphForm").submit();
        }
        else {
            return;
        }
    }

    dialog.hide("ChangeItemTypeDialog");
}

Dynamicweb.Paragraph.ItemEdit.prototype.cancelChangeItemType = function () {
    var ItemTypeSelect = null;

    if (this.get_itemType())
        ItemTypeSelect = "ItemTypeSelect" + this.get_itemType();
    else
        ItemTypeSelect = "ItemTypeSelectdwrichselectitem";

    ItemTypeSelect = $(ItemTypeSelect);
    if (ItemTypeSelect) RichSelect.setselected(ItemTypeSelect.down("div"), "ItemTypeSelect");

    dialog.hide("ChangeItemTypeDialog");
}
