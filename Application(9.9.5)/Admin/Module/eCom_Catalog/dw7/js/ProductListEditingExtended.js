if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

if (typeof (Dynamicweb.PIM) == 'undefined') {
    Dynamicweb.PIM = {};
}

var listMode = 'ListView', thumbnail = 'Thumbnail', multiEdit = 'TableView', productEdit = 'ProductEdit', productEditFieldsBulkEdit = "FieldsBulkEdit", gridView = 'GridEditView';

Dynamicweb.PIM.BulkEdit = function () {
    var QueryString = function () {
        // This function is anonymous, is executed immediately and 
        // the return value is assigned to QueryString!
        var query_string = {};
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        for (var i = 0; i < vars.length; i++) {
            var pair = [];
            var index = vars[i].indexOf('=');

            pair.push(vars[i].substring(0, index).toUpperCase())
            pair.push(vars[i].substring(index + 1, vars[i].length))

            // If first entry with this name
            if (typeof query_string[pair[0]] === "undefined") {
                query_string[pair[0]] = decodeURIComponent(pair[1]);
                // If second entry with this name
            } else if (typeof query_string[pair[0]] === "string") {
                var arr = [query_string[pair[0]], decodeURIComponent(pair[1])];
                query_string[pair[0]] = arr;
                // If third or later entry with this name
            } else {
                query_string[pair[0]].push(decodeURIComponent(pair[1]));
            }
        }
        return query_string;
    }();

    var url = new URL(window.location.href);
    if (url.searchParams && url.searchParams.get('TextSearch')) {
        url.searchParams.delete('TextSearch');
        var page = window.location.pathname.split("/").pop();
        var newState = page + "?" + url.searchParams.toString();
        window.history.replaceState({}, document.title, newState);
    }

    this._visibleFieldsLeft = null;
    this._visibleFieldsRight = null;
    this._currentlyEditingRichFieldId = '';
    this._basePath = QueryString.BASEPATH;
    this._groupId = QueryString.GROUPID;
    this._queryId = QueryString.QUERYID;
    this._dynamicStructure = QueryString.DYNAMICSTRUCTURE;    
    this._form = document.forms["Form1"];
    this._missingImagePath = '/Admin/Images/eCom/missing_image.jpg';
    this._getImagePath = '/Admin/Public/GetImage.ashx?width=100&height=66&crop=0&Compression=75&image=';
    this._controlDefinitions = [];
    this._fieldDefinitions = [];

    this._formInitialState = "";
    this._productPrimaryGroup = "";
    this.terminology = {};
    this.confirmAction = { Name: "OpenDialog", Url: "/Admin/CommonDialogs/Confirm?Caption=Confirm%20Action" };
    this.openScreenAction = { Name: "OpenScreen", Url: location.pathname + location.search };
    this._viewMode = window.top.pimSelectedMode;
    this._approvalState = 0;
    this.currentAttachGroupDialog = null;
    this._currentVariantCombination = QueryString.VARIANTID;
    this._checkUnloadChanges = true;
    this.presetFields = {};
    this._showAllProducts = QueryString.SHOWALLPRODUCTS;
};

Dynamicweb.PIM.BulkEdit._instance = null;

Dynamicweb.PIM.BulkEdit.get_current = function () {
    if (!Dynamicweb.PIM.BulkEdit._instance) {
        Dynamicweb.PIM.BulkEdit._instance = new Dynamicweb.PIM.BulkEdit();
    }

    return Dynamicweb.PIM.BulkEdit._instance;
};

Dynamicweb.PIM.BulkEdit.prototype.initialize = function (options) {
    var self = this;
    self.options = options
    if (options) {
        self._viewMode = options.viewMode || self._viewMode;
        self._fieldDefinitions = (options.fieldDefinitions && options.fieldDefinitions) || self._fieldDefinitions;
        self.openScreenAction = (options.actions && options.actions.openScreen) || window.openScreenAction || self.openScreenAction;
        self.confirmAction = (options.actions && options.actions.confirm) || window.confirmAction || self.confirmAction;
        self.closeAction = options.actions && options.actions.closeAction;
    }
    if (options.approvalState) {
        self._approvalState = options.approvalState;
    }
    options.imagesAllowedExtentions = options.imagesAllowedExtentions || ".gif,.jpg,.jpeg,.png,.svg,.pdf";
    this._controlDefinitions = this._createControlDefinitions();
    this._formInitialState = this._getFormValues();
    const listContainer = $("listContainer");
    if (self._viewMode == multiEdit || self._viewMode == productEdit) {
        this.initCategoryFieldsInheritanceUI(listContainer);
    } else if (self._viewMode == gridView) {
        self.initGridCategoryFieldsInheritanceUI();
        self.initializeCKEditors();
        self._setupBeforeUnloadConfirmation();
        self.handleScrollAndFocus();
        return;
    } else if (self._viewMode == productEditFieldsBulkEdit) {
        self.initializeFieldsBulkEdit();
        return;
    }

    var relatedGroupIdHidenField = $('PrimaryRelatedGroup');
    if (relatedGroupIdHidenField) {
        self._productPrimaryGroup = $('PrimaryRelatedGroup').value;
    }

    if (window.List) {
        var gotoPageFN = List.gotoPage;
        List.gotoPage = function (controlId, pageNumber) {
            var pageNumberhidden = $("PageNumber");
            pageNumberhidden.value = pageNumber || pageNumberhidden.value + 1;
            $('Cmd').value = "ChangePageIndex";

            gotoPageFN(controlId, pageNumber);
        }
    }

    var sortByField = $("SortBy");
    if (sortByField) {
        sortByField.on("change", function () { self.sortProducts(); });
    }

    var sortOrderField = $("SortOrder");
    if (sortOrderField) {
        sortOrderField.on("change", function () { self.sortProducts(); });
    }

    if (self._viewMode == productEdit) {
        self._setupBeforeUnloadConfirmation();
    }

    this._controlDefinitions.filter(function (definition, index, self) {
        return definition.controlType == "EditorText";
    }).forEach(function (definition) {
        var fieldDefinition = definition;
        var editor = document.getElementById(definition.controlId);        
        const storageEl = document.getElementById(fieldDefinition.controlId.substring(0, fieldDefinition.controlId.length - "_editor".length));
        if (editor && storageEl) {
            var onchange = function () {
                var html = editor.innerHTML.trim();
                if (html === '<br>' || html === '<p>' || html === '<p><br></p>' || html === '<div></div>' || html === '<div><br></div>') {
                    editor.innerHTML = "";
                }
                storageEl.value = editor.innerHTML;
                dwGlobal.Dom.triggerEvent(storageEl, "change");
            };

            editor.addEventListener("blur", onchange);
            editor.addEventListener("keyup", onchange);
            editor.addEventListener("paste", onchange);
            editor.addEventListener("copy", onchange);
            editor.addEventListener("cut", onchange);
            editor.addEventListener("delete", onchange);
            editor.addEventListener("mouseup", onchange);
        }
    });

    this.initializeCKEditors();
    this.initializeTinymceEditors();

    this._initializeImageBlocks(listContainer);

    if (self._viewMode != productEdit) {
        var selectedProducts = self.getSelectedProducts();
        if (selectedProducts.length > 0) {
            self._enableRibbonButtons();
        }
    }

    let productsCount = 0;
    if (self._viewMode != listMode) {
        productsCount = document.querySelectorAll("input[type='checkbox'][id^='SelectedProductCheckbox']").length;
    } else {
        let productListRows = List.getAllRows('ProductList');
        productsCount = productListRows.filter(element => element.classList.contains("listRow")).length;
    }
    if (productsCount > 0) {
        self._enableExportToExcelRibbonButton();
    }

    var textSearchInput = document.getElementById("TextSearch"); 
    if (textSearchInput) {
        textSearchInput.onkeypress = function (e) {
            if (e.keyCode === 13) {
                self.submitFormWithCommand('TextSearch');
            }
        };
    }

    this.handleScrollAndFocus();
}

Dynamicweb.PIM.BulkEdit.prototype._setupBeforeUnloadConfirmation = function () {
    var self = this;
    var fireCancelSubmitState = function () {
        if (self._cancelSubmitStateFn) {
            self._cancelSubmitStateFn();
            self._cancelSubmitStateFn = null;
        }
    }
    var userDecidedStayHereAndPressCancel = function () {
        // TFS-69855: ugly but the only possible to emulate user press 'Cancel' for beforeunload event confirmation message
        // It use the hack that alerts and confirm blocks javascript event loop and it blocks setTimeout fire too
        // setTimeout in this function needed for garantie 'unload' event will first then fireCancelPostState if user click 'Leave page'
        setTimeout(fireCancelSubmitState, 300);
    };
    window.addEventListener("beforeunload", function (e) {
        var hasChanges = self._checkUnloadChanges && self.checkFormChanged();
        if (hasChanges) {
            var screenLoader = document.getElementById("screenLoaderOverlay");
            if (screenLoader) {
                var hideSpinner = function () {
                    screenLoader.style.display = 'none';
                    window.removeEventListener("mousemove", hideSpinner);
                }
                window.addEventListener("mousemove", hideSpinner);
            }
        }
        if (hasChanges) {
            setTimeout(userDecidedStayHereAndPressCancel, 500);
            e.returnValue = "true";
        }
        return hasChanges || null;
    });

    window.addEventListener("unload", function () {
        self._cancelSubmitStateFn = null;
        var screenLoader = document.getElementById("screenLoaderOverlay");
        if (screenLoader) {
            screenLoader.style.display = 'block';
        }
    });
}

Dynamicweb.PIM.BulkEdit.prototype.initializeCKEditors = function () {
    var self = this;
    if (window.CKEDITOR) {
        for (var i in CKEDITOR.instances) {
            (function (i) {
                var editor = CKEDITOR.instances[i];
                editor.on("instanceReady", function () {
                    //set base z-index greater then dialog z-index
                    editor.config.baseFloatZIndex = 1500;

                    // Replace the old save's exec function with the new one
                    var overrideCmd = new CKEDITOR.command(editor, {
                        exec: function (editor) { self.updateEditorField(editor); }
                    });
                    editor.commands.save.exec = overrideCmd.exec;
                });
                editor.on('blur', function () {
                    var editorContainer = editor.container.$.up("div.pcm-editor");
                    if (editorContainer) {
                        editorContainer.removeClassName("focused");
                    }
                    self.disableEditorToolbar(editor);
                });
                editor.on('focus', function () {
                    var editorContainer = editor.container.$.up("div.pcm-editor");
                    if (editorContainer) {
                        editorContainer.addClassName("focused");
                    }
                    self.enableEditorToolbar(editor);
                });
            })(i);
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype.initializeTinymceEditors = function () {
    var self = this;
    if (window.tinymce) {
        tinymce.on("AddEditor", function (event) {
            const editor = event.editor;

            editor.on("focus", function () {                
                var mainContainer = editor.getContainer().up("div.pcm-editor-container");
                mainContainer.querySelectorAll("div.pcm-editor").forEach(function (element) {
                    const editorId = element.querySelector("div.pcm-editor-content textarea").id;
                    if (editor.id !== editorId) {
                        element.removeClassName("focused");
                        self.disableEditorToolbar(tinymce.get(editorId));
                    } else {
                        element.addClassName("focused");
                        self.enableEditorToolbar(editor);
                    }
                });           
            });

            editor.on("init", function () {
                self.disableEditorToolbar(editor);
            });
        });
    }
}

Dynamicweb.PIM.BulkEdit.prototype._initializeImageBlocks = function (container) {
    var self = this;
    if (container && window.imagePopupPreview && typeof (imagePopupPreview) == "function") {
        if (this._viewMode == productEditFieldsBulkEdit) {
        let imgPreviewObj = imagePopupPreview(300, 300, "/Admin/Images/eCom/missing_image.jpg");       
            container.on('click', ".image-menu-expand-button", function (e, element) {
                if (element.parentElement != null && element.parentElement.nextElementSibling != null) {
                    if (element.parentElement.nextElementSibling.classList.contains("image-block")) {
                        let imageElement = element.parentElement.nextElementSibling
                        imgPreviewObj.setPosition(e.pageX, e.pageY);
                        let imgUrl = imageElement.readAttribute("data-image-path");
                        let title = imageElement.readAttribute("data-title");
                        let modified = imageElement.readAttribute("data-modified");
                        imgPreviewObj.show(imgUrl, modified || "", title || "");
                    }
                }
            });

            container.on('mouseover', ".image-cnt", function (e, element) {
                let imageMenu = element.getElementsByClassName("image-menu")[0];
                const imageEl = element.querySelector(".image-block");
                if (imageMenu) {
                    const expandBtn = imageMenu.querySelector(".image-menu-expand-button");
                    if (expandBtn) {
                        if (imageEl.classList.contains("non-image")) {
                            expandBtn.writeAttribute("disabled", "disabled");
                        } else {
                            expandBtn.removeAttribute("disabled", "disabled");
                        }
                    }
                    imageMenu.style.display = 'block';
                }
            });

            container.on('mouseout', ".image-cnt", function (e, element) {
                let imageMenu = element.getElementsByClassName("image-menu")[0];
                if (imageMenu) {
                    if (e.toElement != null && (!e.toElement.classList.contains("image-menu") && (!e.toElement.parentElement.classList.contains("image-menu-button-container") && !e.toElement.parentElement.classList.contains("image-menu")))) {
                        //Show the image menu
                        imageMenu.style.display = 'none';
                    }
                }
                imgPreviewObj.hide();
            });
        } else {
            Dynamicweb.ProductImageBlocks.get_current().initialize({
                container: container,
                enableVideoPreview: true,
                previewPdfDialogTitle: self.terminology["PreviewPdfDialogTitle"]
            });
        }
    }
}

Dynamicweb.PIM.BulkEdit.prototype.initializeFieldsBulkEdit = function () {
    var self = this;
    var treeNodeOpeners = $$(".open-btn");
    if (treeNodeOpeners.length) {
        treeNodeOpeners.forEach(function (opener) {
            opener.on('click', function (e) {
                var innerList = opener.parentElement.next("ul");
                innerList.toggleClassName("hidden");
                if (innerList.hasClassName("hidden")) {
                    opener.removeClassName("fa-caret-down");
                    opener.addClassName("fa-caret-right");
                } else {
                    opener.removeClassName("fa-caret-right");
                    opener.addClassName("fa-caret-down");
                }

                if (e) {
                    if (typeof (e.cancelBubble) != 'undefined')
                        e.cancelBubble = true;
                    else if (typeof (e.stopPropagation) == 'function')
                        e.stopPropagation();
                }
            });
        });
    }
    if (window.dwGrid_FieldsGrid) {
        dwGrid_FieldsGrid.onRowAddedCompleted = self._updateFieldsGridRow;
        dwGrid_FieldsGrid.onRowAdding = self._onRowAdding;
        var rows = dwGrid_FieldsGrid.rows.getAll();
        if (rows.length > 0) {
            dwGrid_FieldsGrid.toggleLoading(true);
        }
        for (var i = 0; i < rows.length; i++) {
            self._updateFieldsGridRow(rows[i], (i == (rows.length - 1)));
        }
    }
    self._initializeImageBlocks($("FieldsGrid"));
}

Dynamicweb.PIM.BulkEdit.prototype._createControlDefinitions = function () {
    var defs = (this.options && this.options.controlDefinitions) || window.controlRows || [];
    var controlDefinitions = [];
    defs.forEach(function (column) { controlDefinitions = controlDefinitions.concat(column); });
    return controlDefinitions;
}

Dynamicweb.PIM.BulkEdit.prototype.handleScrollAndFocus = function () {
    if (this._viewMode != multiEdit && this._viewMode != productEdit &&
        this._viewMode != gridView) {        
        if (this._viewMode != productEdit) {
            this.setScrollCoordinates(null);
        }
        return;
    }

    let self = this;

    //Set top and left scroll coordinates
    const setScrollCoordinates = function (top, left) {
        dwGlobal.debounce(function () {
            self.setScrollCoordinates({ top: top, left: left });
        }, 250)();
    };

    //Find focusable control in view port
    const fieldInViewport = function (container, element) {
        let containerLocation = container.getBoundingClientRect();
        let elementLocation = element.getBoundingClientRect();
        return elementLocation.left > containerLocation.left && elementLocation.top > containerLocation.top &&
            elementLocation.right < containerLocation.right && elementLocation.bottom < containerLocation.bottom;
    };   

    // Get saved scroll position
    let list = $("listContainer");
    let header = $$(".pcm-wrap-header")[0];  
    let scrollCoordinates = this.getScrollCoordinates();

    if (this._viewMode == productEdit) {
        list.on('scroll', function () {
            header.scrollLeft = list.scrollLeft;
            setScrollCoordinates(list.scrollTop, list.scrollLeft);           
        });
    } else if (this._viewMode == gridView) {
        list = document.querySelector('.pcm-content>.list-wrap');
        list.scrollTop = scrollCoordinates?.top;        
        list.scrollLeft = scrollCoordinates?.left;        

        list.on('scroll', function () {
            setScrollCoordinates(list.scrollTop, list.scrollLeft);           
        }); 

        let focusedFieldHidden = document.getElementById("FocusedFieldId");
        if (focusedFieldHidden.value) {
            let foundDefinition = this._controlDefinitions.find(definition => definition.controlId == focusedFieldHidden.value);     
            let focusedField = foundDefinition ? this.getFieldByControlDefinition(foundDefinition) : null;
            if (focusedField && fieldInViewport(list, focusedField) && this.canBeFocused(foundDefinition)) {
                focusedField.focus();
            }            
        }  

        this._controlDefinitions.forEach(controlDefinition => {
            let field = self.getFieldByControlDefinition(controlDefinition);
            if (!field) {
                return;
            }
            field.on('focus', () => focusedFieldHidden.value = controlDefinition.controlId);               
        });
        
        return;
    }

    let url = new URL(window.location.href);
    let focusableControl = null;

    // Set focus on Variant edit form if extended variant was created
    if (this.extendedVariantWasCreated()) {
        let variantContainers = $$(".variant-item-container");
        let productId = url.searchParams.get("ID");
        let languages = this.getViewLanguages();
        let languageId = languages[0];
        for (let i = 0; i < variantContainers.length; i++) {
            var variantId = variantContainers[i].readAttribute("data-variant-id");
            for (let j = 0; j < this._fieldDefinitions.length; j++) {
                let fieldDefiniton = this._fieldDefinitions[j];
                let controlId = this.getControlId(productId, variantId, languageId, fieldDefiniton.fieldId, fieldDefiniton.type);
                let controlDefinition = this._controlDefinitions.find(definition => definition.controlId == controlId);
                if ($(controlId) && controlDefinition && this.canBeFocused(controlDefinition)) {
                    focusableControl = controlDefinition;
                    break;
                }
            }
            if (focusableControl) {
                break;
            }
        }
        if (focusableControl) {
            this.setFocusOnField(focusableControl);
        }

        return;
    }

    // Set focus on field with error
    if (this.formHasErrors()) {
        for (let i = 0; i < this._controlDefinitions.length; i++) {
            var controlDefinition = this._controlDefinitions[i];
            if (controlDefinition.hasError && this.canBeFocused(controlDefinition)) {
                focusableControl = controlDefinition;
                break;
            }
        }
        if (focusableControl) {
            this.setFocusOnField(focusableControl);
        }

        return;
    }

    if (this._viewMode != productEdit) {       
        return;
    }

    // Set scroll position
    let variantsContainer = $$(".pcm-list-item.variant");
    let controlDefinitionToFocus = null;
    if (window.top.fieldControlIdToScroll) {
        controlDefinitionToFocus = this._controlDefinitions.find(def => def.controlId == window.top.fieldControlIdToScroll);
        if (controlDefinitionToFocus) {
            let fieldElementToScroll = this.getFieldByControlDefinition(controlDefinitionToFocus);
            if (fieldElementToScroll) {
                window.top.navigateToVariants = false;
                fieldElementToScroll.scrollIntoView();
            }
        }
        if (window.top.navigateToVariants && variantsContainer.length > 0) {
            variantsContainer[0].scrollIntoView();
        }
        window.top.fieldControlIdToScroll = null;
        window.top.navigateToVariants = null;
    } else if (!!window.top.navigateToVariants && variantsContainer.length > 0) { // Scroll to variants container after clicking in variant tree
        window.top.navigateToVariants = null;
        variantsContainer[0].scrollIntoView();
    } else if (scrollCoordinates) { // Scroll to saved position
        list.scrollTop = scrollCoordinates.top;
        list.scrollLeft = scrollCoordinates.left;
    }
       
    if (controlDefinitionToFocus) {
        this.setFocusOnField(controlDefinitionToFocus);
    } else {
        for (let i = 0; i < this._controlDefinitions.length; i++) {
            let controlDefinition = this._controlDefinitions[i];
            let field = this.getFieldByControlDefinition(controlDefinition);
            if (!field) {
                continue;
            }
            if (this.canBeFocused(controlDefinition) && fieldInViewport(list, field)) {
                field.focus();
                break;
            }
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype.getScrollCoordinates = function () {
    return window.top.scrollCoordinates || null;
};

Dynamicweb.PIM.BulkEdit.prototype.setScrollCoordinates = function (point) {
    window.top.scrollCoordinates = point;
};

Dynamicweb.PIM.BulkEdit.prototype.canBeFocused = function (controlDefinition) {
    switch (controlDefinition.controlType) {
        case "Text":
        case "TextLong":
        case "EditorText":
        case "Integer":
        case "Double":
        case "Select":
        case "MultiSelectList":
        case "RadioButtonList":
        case "CheckBoxList":
        case "Link":
        case "Filemanager":
            return !this.isFieldEditorReadonly(controlDefinition);
    }
    return false;
};

Dynamicweb.PIM.BulkEdit.prototype.getFieldByControlDefinition = function (controlDefinition) {
    var field = null;
    switch (controlDefinition.controlType) {
        case "CheckBoxList":
        case "RadioButtonList":
        case "MultiSelectList":
        case "Select":
            var elements = $$("[name=" + controlDefinition.controlId + "]");
            if (elements.length > 0) {
                field = elements[0];
            }
            break;

        case "Text":
        case "TextLong":
        case "EditorText":
        case "Integer":
        case "Double":
        case "Link":
            field = $(controlDefinition.controlId);
            break;

        case "Filemanager":
            field = $(controlDefinition.controlId).next(".box-control-box");
            break;
    }
    return field;
};

Dynamicweb.PIM.BulkEdit.prototype.setFocusOnField = function (controlDefinition) {
    var field = this.getFieldByControlDefinition(controlDefinition)
    if (field) {
        // Expand GroupBox
        var cnt = $(controlDefinition.controlId);
        do {
            var groupbox = cnt.up(".groupbox");
            if (groupbox && Dynamicweb.Utilities.GroupBox.isCollapsed(groupbox)) {
                Dynamicweb.Utilities.GroupBox.toggleCollapse(groupbox, true);
            }
            cnt = groupbox
        } while (cnt)

        if (field.tagName == "DIV") {
            field.scrollIntoView();
        } else {
            field.focus();
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype.extendedVariantWasCreated = function () {
    var url = new URL(window.location.href);
    var variantContainers = $$(".variant-item-container");
    var makeExtendedVariant = url.searchParams.get("makeExtendedVariant");
    return !!makeExtendedVariant && makeExtendedVariant.toLowerCase() == "true" && variantContainers.length > 0;
};

Dynamicweb.PIM.BulkEdit.prototype.formHasErrors = function () {
    for (var i = 0; i < this._controlDefinitions.length; i++) {
        if (this._controlDefinitions[i].hasError) {
            return true;
        }
    }

    return false;
};

Dynamicweb.PIM.BulkEdit.prototype._getFormValues = function () {
    var self = this;
    if (self._viewMode == gridView) {
        return self._controlDefinitions.map(function (definition) {
            var controlId = definition.controlId;
            switch (definition.controlType) {
                case "EditorText":
                    controlId = controlId.substring(0, controlId.length - "_editor".length);
                    break;
                case "DateTime":
                case "Date":
                    controlId = controlId.substring(0, controlId.length - "_label".length) + "_calendar";
                    break;
            }

            var controlElement = document.getElementById(controlId);
            if (controlElement) {
                return document.getElementById(controlId).value;
            }
            else {
                return undefined;
            }
            
        }).join();
    } else {
        return $$("#pim-hidden-fields input:not([id='Cmd']):not([id='PresetId']):not([id='viewFields']):not([id='categoryFields']):not([id='DelocalizeProduct']), #listContainer input:not([id$='_datepicker']), #listContainer select:not([id='ImageGroupPicker'])").map(function (element) { return element.value; }).join();
    }
};

Dynamicweb.PIM.BulkEdit.prototype.checkFormChanged = function () {
    return this._getFormValues() != this._formInitialState;
};

Dynamicweb.PIM.BulkEdit.prototype.submitFormWithCommand = function (command, checkChanges) {
    Action.showCurrentScreenLoader(true);
    $('Cmd').value = command;
    this._checkUnloadChanges = !!checkChanges;
    this._form.submit();
};

Dynamicweb.PIM.BulkEdit.prototype.save = function (close) {
    if (this._form.checkValidity()) {
        Action.showCurrentScreenLoader(true);
    }
    $('Cmd').value = close ? "SaveAndClose" : "Save";
    this._checkUnloadChanges = false;
    el = document.createElement('input');
    el.type = 'submit';
    el.className = 'hidden';
    this._form.appendChild(el);
    el.click();
};

Dynamicweb.PIM.BulkEdit.prototype.changePageIndex = function (pageNumber) {
    var pageNumberhidden = $("PageNumber");
    pageNumberhidden.value = pageNumber || pageNumberhidden.value + 1;
    this.submitFormWithCommand("ChangePageIndex");
};

Dynamicweb.PIM.BulkEdit.prototype.cancel = function () {
    if (this.closeAction) {
        Action.Execute(this.closeAction);
    } else {
        this.submitFormWithCommand("Cancel");
    }
};

Dynamicweb.PIM.BulkEdit.prototype.switchViewMode = function (mode) {
    var url = this.getListViewUrl(mode);
    window.top.pimSelectedMode = mode;
    openScreenAction.Url = url;
    Action.Execute(openScreenAction);
};

Dynamicweb.PIM.BulkEdit.prototype.getListViewUrl = function (mode) {
    var url = '/Admin/Module/eCom_Catalog/dw7/PIM/PimProductList.aspx?ViewMode=' + mode;
    if (mode == "TableView") {
        url = '/Admin/Module/eCom_Catalog/dw7/PIM/PimMultiEdit.aspx?FromPIM=True';
    }
    if (this._queryId) {
        url += '&QueryID=' + this._queryId + '&groupID=' + this._groupId;
    } else if (this._groupId) {
        url += '&GroupID=' + this._groupId;
    }
    if (this._dynamicStructure) {
        url += '&DynamicStructure=' + this._dynamicStructure;
    }
    if (this._basePath) {
        url += '&BasePath=' + this._basePath;
    }
    var pageNumber = $("PageNumber");
    var pageSize = $("PageSize");

    if (pageNumber && pageSize) {
        url += '&PreviousViewPageNumber=' + (pageNumber.value || 1);
        url += '&PreviousViewPageSize=' + pageSize.value;
    }

    var searchApplied = $('SearchApplied');
    if (searchApplied && searchApplied.value == '1') {
        var searchBox = $('TextSearch');
        if (searchBox && searchBox.value.trim().length > 0) {
            url += '&TextSearch=' + searchBox.value;
        }
    }
    url += '&KeepListSettings=true';
    return url;
}

Dynamicweb.PIM.BulkEdit.prototype.getViewLanguages = function () {
    var languages = $("viewLanguages").value.split(",");
    return languages;
};

Dynamicweb.PIM.BulkEdit.prototype.setViewLanguages = function (languages) {
    $("viewLanguages").value = languages.join();
};

Dynamicweb.PIM.BulkEdit.prototype.changeLanguages = function (languageId) {    
    var languages = this.getViewLanguages();
    var languagePosition = languages.indexOf(languageId);
    if (languagePosition == -1) {
        languages.push(languageId);
    } else {
        languages.splice(languagePosition, 1);
    }
    this.setViewLanguages(languages);

    this.submitFormWithCommand("ChangeLanguages", this._viewMode == gridView);
};

Dynamicweb.PIM.BulkEdit.prototype.changeFields = function () {
    var self = this;
    var viewFieldsEl = $("viewFields");
    var prevViewFields = viewFieldsEl.value;
    var prevVisibleFieldsLeft = self._visibleFieldsLeft;
    var prevVisibleFieldsRight = self._visibleFieldsRight;
    self._cancelSubmitStateFn = function () {
        viewFieldsEl.value = prevViewFields;
        self._visibleFieldsLeft = prevVisibleFieldsLeft;
        self._visibleFieldsRight = prevVisibleFieldsRight;
    };

    viewFieldsEl.value = SelectionBox.getElementsRightAsArray("ViewFieldList").join();
    this._visibleFieldsLeft = null;
    this._visibleFieldsRight = null;

    this.setScrollCoordinates(null);
    var presetIdHidden = $("PresetId");
    var cmd = (presetIdHidden && presetIdHidden.value != '') ? "ChangePreset" : "ChangeFields";
    this.submitFormWithCommand(cmd, true);
};

Dynamicweb.PIM.BulkEdit.prototype.changePreset = function (presetId) {
    var self = this;
    var presetIdEl = $("PresetId");
    var prevPresetId = presetIdEl.value;
    new overlay('__ribbonOverlay').show();
    presetIdEl.value = presetId;
    self._cancelSubmitStateFn = function () {
        presetIdEl.value = prevPresetId;
    };
    this.setScrollCoordinates(null);
    this.submitFormWithCommand("ChangePreset", true);
};

Dynamicweb.PIM.BulkEdit.prototype.selectFieldsPreset = function (selector) {
    var selectedPresetId = selector.value;
    var selectedPresetFields = selectedPresetId ? this.presetFields[selectedPresetId].split(',') : [];
    SelectionBox.selectionRemoveAll("ViewFieldList");
    var lstLeft = document.getElementById("ViewFieldList_lstLeft");

    for (var i = 0; i < lstLeft.length; i++) {
        var option = lstLeft.options[i];
        option.selected = selectedPresetId && selectedPresetFields.indexOf(option.value) != -1;
    }

    SelectionBox.selectionAddSingle("ViewFieldList");

    //we clear the selector value on change of selectin box whic is called inside selectionAddSingle function
    $("PresetId").value = selectedPresetId;
    selector.value = selectedPresetId;
};

Dynamicweb.PIM.BulkEdit.prototype.openVisibleFields = function (e, dialogId) {    
    var target = $(e.srcElement || e.target);
    //presets dropdown called
    if (target.id == "VisibleFields_splitRight") {
        return;
    }

    if (this._visibleFieldsLeft && this._visibleFieldsRight) {
        var left = new Array();
        var right = new Array();

        for (var i = 0; i < this._visibleFieldsLeft.length; i++) {
            left.push({ Name: this._visibleFieldsLeft[i].text, Value: this._visibleFieldsLeft[i].value });
        }
        for (var i = 0; i < this._visibleFieldsRight.length; i++) {
            right.push({ Name: this._visibleFieldsRight[i].text, Value: this._visibleFieldsRight[i].value });
        }

        SelectionBox.fillLists(JSON.stringify({ left: left, right: right }), 'ViewFieldList');
    } else {
        this._visibleFieldsLeft = SelectionBox.getElementsLeftAsOptionArray('ViewFieldList');
        this._visibleFieldsRight = SelectionBox.getElementsRightAsOptionArray('ViewFieldList');
    }

    dialog.show(dialogId);
};

Dynamicweb.PIM.BulkEdit.prototype.sortProducts = function () {
    this.submitFormWithCommand("ChangeSortOrder");
}

Dynamicweb.PIM.BulkEdit.prototype.getSelectedProducts = function () {
    if (this._viewMode != listMode) {
        return $$("input[id^='SelectedProductCheckbox']:checked").map(function (checkbox) { return checkbox.value; });
    } else {
        return List.getSelectedRows('ProductList').map(function (row) { return row.getAttribute("itemid"); });
    }
}

Dynamicweb.PIM.BulkEdit.prototype.productListItemSelected = function () {
    var self = this;
    var selectedProducts = self.getSelectedProducts();
    if (selectedProducts.length > 0) {
        self._enableRibbonButtons();
    } else {
        self._disableRibbonButtons();
    }
};

Dynamicweb.PIM.BulkEdit.prototype.toggleAllChildProductsNodes = function (element) {
    let childCheckboxes = element.closest(".list-item").nextElementSibling.querySelectorAll("li>.list-item .checkbox");
    for (let i = 0; i < childCheckboxes.length; i++) {
        let checkbox = childCheckboxes[i];
        checkbox.checked = element.checked;
    }
    let treeCnt = element.closest(".product-tree-root");
    let allVariantsElements = treeCnt.querySelectorAll(".all-variants-root")
    for (let i = 0; i < allVariantsElements.length; i++) {
        let cnt = allVariantsElements[i];
        this.updateProductVariantsNodeTitle(cnt);
    }
    this.updateSelectedProductsNodeTitles(treeCnt);
}

Dynamicweb.PIM.BulkEdit.prototype.toggleProductNode = function (element) {
    if (document.getElementById("ProductSearchInput").value) {
        element.setAttribute("explicitSelected", element.checked);
    }
    let treeCnt = element.closest(".product-tree-root");
    this.updateSelectedProductsNodeTitles(treeCnt);
}

Dynamicweb.PIM.BulkEdit.prototype.toggleVariantsNodes = function (element) {
    if (document.getElementById("ProductSearchInput").value && element.closest(".product-variant")) {
        element.setAttribute("explicitSelected", element.checked);
    }
    let listItem = element.closest(".list-item");
    if (listItem.nextElementSibling) {
        let childCheckboxes = listItem.nextElementSibling.querySelectorAll("li>.list-item .checkbox");
        for (let i = 0; i < childCheckboxes.length; i++) {
            let checkbox = childCheckboxes[i];
            checkbox.checked = element.checked;
        }
    }

    let allVariantsElement = element.closest(".all-variants-root")
    this.updateProductVariantsNodeTitle(allVariantsElement);
    this.toggleProductNode(element);
    let allSelectedVariantsCount = allVariantsElement.querySelectorAll("li.product-variant>.list-item .checkbox:checked").length;
    let allVariantsCount = allVariantsElement.querySelectorAll("li.product-variant>.list-item .checkbox").length;
    allVariantsElement.querySelector(".list-item .checkbox").checked = allSelectedVariantsCount == allVariantsCount;
    let varGroups = allVariantsElement.querySelectorAll(".variant-group");
    for (let i = 0; i < varGroups.length; i++) {
        let grp = varGroups[i];
        let allVariantsCount = grp.querySelectorAll("li.product-variant>.list-item .checkbox").length;
        let selectedVariantsCount = grp.querySelectorAll("li.product-variant>.list-item .checkbox:checked").length;
        grp.querySelector(".list-item .checkbox").checked = selectedVariantsCount == allVariantsCount;
    }
}

Dynamicweb.PIM.BulkEdit.prototype.updateSelectedProductsNodeTitles = function (cnt) {
    let list = cnt.querySelector(".list");
    let allSelectedProductsCount = list.querySelectorAll("li.product>.list-item .checkbox:checked").length;
    let allSelectedVariantsCount = list.querySelectorAll("li.product-variant>.list-item .checkbox:checked").length;
    this.updateProductsCheckboxLabel(cnt.querySelector(".list-item"), allSelectedProductsCount, allSelectedVariantsCount)
    let cb = cnt.querySelector(".list-item .checkbox");
    let allProductsCount = list.querySelectorAll("li.product>.list-item .checkbox").length;
    let allVariantsCount = list.querySelectorAll("li.product-variant>.list-item .checkbox").length;
    cb.checked = allSelectedProductsCount == allProductsCount && allSelectedVariantsCount == allVariantsCount;
    this.updateSearchProductInputInfo(allSelectedProductsCount + allSelectedVariantsCount);
}

Dynamicweb.PIM.BulkEdit.prototype.updateProductVariantsNodeTitle = function (cnt) {
    let list = cnt.querySelector(".list");
    let allSelectedVariantsCount = list.querySelectorAll("li.product-variant>.list-item .checkbox:checked").length;
    this.updateProductsCheckboxLabel(cnt.querySelector(".list-item"), 0, allSelectedVariantsCount)
}

Dynamicweb.PIM.BulkEdit.prototype.updateProductsCheckboxLabel = function (listItem, selectedProductsCount, selectedVariantsCount) {
    let label = listItem.querySelector("label.node-title");
    let tpl = label.readAttribute("title-tpl");
    if (tpl) {
        label.innerHTML = Action.Transform(tpl, { productCount: selectedProductsCount, variantCount: selectedVariantsCount });
    }
}

Dynamicweb.PIM.BulkEdit.prototype.updateSearchProductInputInfo = function (count) {
    let searchProductInfo = document.getElementById("infoProductSearchInput");
    if (searchProductInfo) {
        let infoText = searchProductInfo.innerText;
        infoText = count + infoText.substring(infoText.indexOf("/"));
        searchProductInfo.innerText = infoText;
    }
};

Dynamicweb.PIM.BulkEdit.prototype.filterProductsBySearchText = function () {
    var textFieldElement = document.getElementById("ProductSearchInput");
    if (!textFieldElement) {
        return;
    }
    if (textFieldElement.getAttribute("initial") != "true") {
        this.clearAllSelection();
        textFieldElement.setAttribute("initial", true);
    }

    let textFilter = textFieldElement.value.toLowerCase();
    let container = document.getElementById("ProductsTree");
    let productNodes = container.querySelectorAll(".product-variant > .list-item >.node-title, .product > .list-item >.node-title");

    if (textFilter && textFilter != "") {
        let productCheckbox = container.querySelector("[name='SelectedProductCheckbox']");
        this.updateChildTreeNodesCheckboxes(productCheckbox, null, true, true);
    }

    for (var i = 0; i < productNodes.length; i++) {
        let node = productNodes[i];
        let listItems = node.closest(".list");
        let nodeCheckbox = node.closest("li").querySelector(".list-item input.checkbox");
        let showBlock = node.innerText.toLowerCase().indexOf(textFilter) != -1;

        if (showBlock) {
            node.closest("li").classList.remove('hidden');
        } else if (nodeCheckbox.getAttribute("explicitSelected") != "true") {
            node.closest("li").classList.add('hidden');
        }

        while (!listItems.parentElement.classList.contains("variant-selection-tree")) {
            let currentNode = listItems.parentElement;
            let childCheckboxes = listItems.querySelectorAll("ul>li:not(.hidden)");

            if (childCheckboxes.length > 0) {
                currentNode.classList.remove('hidden');
                if (showBlock && listItems.classList.contains("hidden")) {
                    listItems.parentElement.querySelector(".list-item .open-btn").click();
                }
            } else {
                currentNode.classList.add('hidden');
            }

            listItems = currentNode.closest(".list");
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype.resetSearchTextFilter = function () {
    document.getElementById("ProductSearchInput").value = "";
    this.filterProductsBySearchText();
};

Dynamicweb.PIM.BulkEdit.prototype.clearAllSelection = function (keepExplicitSelected) {
    let container = document.getElementById("ProductsTree");
    let productCheckbox = container.querySelector("[name='SelectedProductCheckbox']");
    productCheckbox.checked = false
    this.toggleAllChildProductsNodes(productCheckbox);
};

Dynamicweb.PIM.BulkEdit.prototype.updateChildTreeNodesCheckboxes = function (element, id, markParentOnlyIfAllChildMarked, keepExplicitSelected) {
    let childCheckboxes = element.closest(".list-item").nextElementSibling.querySelectorAll("li>.list-item:not(.variant-group) .checkbox");
    let explicitSelected = false;      //whether we select variant(s) in search mode
    let elementChecked = element.checked;           //original checked state of the element
    let searchMode = document.getElementById("ProductSearchInput") && !!document.getElementById("ProductSearchInput").value;    //indicator if we now using search
    if (!keepExplicitSelected && searchMode) {                   
        explicitSelected = element.checked;      //to be used as checkbox attribute
    }
    for (let i = 0; i < childCheckboxes.length; i++) {     //for all variant leaves related to current checkbox
        let checkbox = childCheckboxes[i];               //get child checkbox
        let checkboxContainer = checkbox.closest("li");       //get container 'li' element of checkbox
        if (!keepExplicitSelected && (!searchMode || checkboxContainer.style.display === "none")) {   //set explicit attribute if we not keep and use search mode
            checkbox.setAttribute("explicitSelected", explicitSelected);
        }
        if ((!keepExplicitSelected || checkbox.getAttribute("explicitSelected") != "true") &&         //set checked state if it is not explicitly checked 
            (!searchMode || !checkboxContainer.classList.contains("hidden"))) {                      // and we either not in search mode or checkbox match search criteria
            checkbox.checked = elementChecked;
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype.selectProduct = function (element, id) {
    var self = this;
    if (self._viewMode != listMode) {
        $$("input[id^='SelectedProductCheckbox" + id + "']").forEach(function (checkbox) { checkbox.checked = element.checked; });

        if (id) {
            $("SelectAll").checked = $$("input[id^='SelectedProductCheckbox']").every(function (checkbox) { return checkbox.checked });
        }
    }

    var selectedProducts = self.getSelectedProducts();
    if (selectedProducts.length > 0) {
        self._enableRibbonButtons();
    } else {
        self._disableRibbonButtons();
    }
};

Dynamicweb.PIM.BulkEdit.prototype._disableRibbonButtons = function () {
    BulkEdit.addClassName("disabled");
    BulkEdit.stopObserving('click');
    GridEdit.addClassName("disabled");
    GridEdit.stopObserving('click');
    btnAttachMultipleProducts.addClassName("disabled");
    btnAttachMultipleProducts.stopObserving('click');
    btnPublishMultipleProducts.addClassName("disabled");
    btnPublishMultipleProducts.stopObserving('click');
};

Dynamicweb.PIM.BulkEdit.prototype._enableRibbonButtons = function () {
    if (!this.options.isReadOnly) {
        this._enableBulkEditRibbonButton();
        this.enableAttachProductsRibbonButtons();
    }
};

Dynamicweb.PIM.BulkEdit.prototype._enableBulkEditRibbonButton = function () {
    var self = this;
    if (self.options.permissions.BulkEditingPermission >= (PermissionLevels.Edit || PermissionLevels.PermissionLevelEdit)) { 
        BulkEdit.removeClassName("disabled");
        BulkEdit.on("click", function () {
            let selectedProducts = self.getSelectedProducts();
            self.productsFieldsBulkEdit(selectedProducts, productEditFieldsBulkEdit);
        });
        GridEdit.removeClassName("disabled");
        GridEdit.on("click", function () {
            let selectedProducts = self.getSelectedProducts();
            self.productsFieldsBulkEdit(selectedProducts, gridView);
        });
    }
};
Dynamicweb.PIM.BulkEdit.prototype._enableExportToExcelRibbonButton = function () {
    var self = this;
    if (self.options.permissions.ExportExcelPermission >= (PermissionLevels.Read || PermissionLevels.PermissionLevelRead)) { 
        ExportToExcel.removeClassName("disabled");
        ExportToExcel.on("click", function () {
            let selectedProducts = self.getSelectedProducts();
            self.ShowExportToExcelDialog(selectedProducts);
        });
    }
};

Dynamicweb.PIM.BulkEdit.prototype.enableAttachProductsRibbonButtons = function () {
    var self = this;
    if (self.options.permissions.GroupRelationPermission >= (PermissionLevels.Delete || PermissionLevels.PermissionLevelDelete)) { 
        btnAttachMultipleProducts.removeClassName("disabled");
        btnAttachMultipleProducts.on("click", function () {
            self.currentAttachGroupDialog = "ProductWarehouseOnly";
            dialog.setTitle("AddGroupsDialog", self.terminology["AddPimGroup"] || "Add warehouse groups");
            dialog.show('AddGroupsDialog', "/Admin/Module/Ecom_Catalog/dw7/edit/EcomGroupTree.aspx?shopsToShow=ProductWarehouseOnly&CMD=ShowGroupRel&caller=parent.document.getElementById('Form1').GroupsToAdd");
        });
    }
    if (self.options.permissions.PublishChannelPermission >= (PermissionLevels.Delete || PermissionLevels.PermissionLevelDelete)) { 
        btnPublishMultipleProducts.removeClassName("disabled");
        btnPublishMultipleProducts.on("click", function () {
            self.currentAttachGroupDialog = "Channel";
            dialog.setTitle("AddGroupsDialog", self.terminology["AddEcomGroup"] || "Add distribution channel groups");
            dialog.show('AddGroupsDialog', "/Admin/Module/Ecom_Catalog/dw7/edit/EcomGroupTree.aspx?shopsToShow=ShopOrChannel&CMD=ShowGroupRel&caller=parent.document.getElementById('Form1').GroupsToAdd");
        });
    }
};

Dynamicweb.PIM.BulkEdit.prototype.getMultiEditLanguageCheckboxes = function (onlyChecked) {
    var languageCheckboxes = null;
    if (onlyChecked) {
        languageCheckboxes = $$("[name$='MultiEditLanguages']:checked");
    }
    else {
        languageCheckboxes = $$("[name$='MultiEditLanguages']");
    }
    return languageCheckboxes;
};

Dynamicweb.PIM.BulkEdit.prototype.selectMultiEditLanguage = function (selectAll) {
    var languageCheckboxes = this.getMultiEditLanguageCheckboxes();
    var allLanguagesCheckbox = languageCheckboxes.shift();
    if (selectAll) {
        languageCheckboxes.forEach(function (checkbox) { checkbox.checked = allLanguagesCheckbox.checked; });
    } else {
        allLanguagesCheckbox.checked = languageCheckboxes.every(function (checkbox) { return checkbox.checked; });
    }
    this.recalcParentNodeState(languageCheckboxes[0], true);
};

Dynamicweb.PIM.BulkEdit.prototype.openEditor = function (currentFieldId, fieldName) {
    var fieldIdParts = currentFieldId.split("_;_");
    function setEditorStateFunction(editorWrapper, disabled, currentlyActive) {
        const editor = editorWrapper.editorObj;
        return function () {
            if (editorWrapper.isTinymce) {
                const contentContainer = editorWrapper.container.up("div.pcm-editor-content");
                contentContainer.classList.add("tinymce");
            }
            const editorContainer = editorWrapper.container.up("div.pcm-editor");              
            editorContainer.removeClassName("focused");
            if (currentlyActive && !disabled) {
                editorContainer.addClassName("focused");
            }            
            editorWrapper.setReadOnly(disabled);
            if (disabled) {
                if (editorWrapper.isCKEditor) {
                    editor.commands["source"].disable();
                }
                setTimeout(function () { editorWrapper.document.body.style = "color: rgb(170, 170, 170);background-color: whitesmoke;"; }, 100);
            }
        };
    }

    var fieldLangId = fieldIdParts[2];

    var languages = this.getViewLanguages();
    for (var i = 0; i < languages.length; i++) {
        const editorId = "editor" + languages[i];
        const editorWrapper = new EditorWrapper(editorId);
        const editor = editorWrapper.editorObj;
        const fieldId = [fieldIdParts[0], fieldIdParts[1], languages[i], fieldIdParts[3]].join("_;_");
        const disabled = $(fieldId + "_editor").classList.contains("disabled");
        const isCurrentEditor = fieldLangId.toLowerCase() == languages[i].toLowerCase();
        const fieldValue = $(fieldId).value;

        const callbackFunction = function (isCurrentEditor) {
            return function () {
                if (isCurrentEditor) {
                    editorWrapper.focus();
                }
                editorWrapper.resetDirty();
            }
        };

        if (!disabled && isCurrentEditor) {
            editorWrapper.setData(fieldValue, callbackFunction(true));          
            this.enableEditorToolbar(editor);
        } else {
            editorWrapper.setData(fieldValue, callbackFunction(false));          
            this.disableEditorToolbar(editor);
        }

        if ((editorWrapper.isCKEditor && editor.document) || (editorWrapper.isTinymce && editor.initialized)) {
            (setEditorStateFunction(editorWrapper, disabled, isCurrentEditor))();
        }
        else {
            editorWrapper.onInstanceReady(setEditorStateFunction(editorWrapper, disabled, isCurrentEditor));            
        }
    }   

    this._currentlyEditingRichFieldId = currentFieldId;
    dialog.setTitle("EditorDialog", fieldName);
    dialog.show("EditorDialog");
};

Dynamicweb.PIM.BulkEdit.prototype.updateEditorField = function (editor) {
    var fieldIdParts = this._currentlyEditingRichFieldId.split("_;_");
    var languages = this.getViewLanguages();
    for (var i = 0; i < languages.length; i++) {
        var editorId = "editor" + languages[i];
        if (!editor || (editor && editor.name == editorId)) { // If editor is not defined - save all, otherwise - save only specified editor
            var fieldId = [fieldIdParts[0], fieldIdParts[1], languages[i], fieldIdParts[3]].join("_;_");
            var disabled = $(fieldId + "_editor").classList.contains("disabled");

            if (!disabled) {
                const editorWrapper = new EditorWrapper(editorId);
                var fieldValue = editorWrapper.getData();
                const categoryFieldEditor = Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.editorsById[fieldId];
                if (categoryFieldEditor) {
                    if (editorWrapper.checkDirty()) {
                        categoryFieldEditor.isInherited = false;
                        categoryFieldEditor.setValue(fieldValue);
                    }
                } else {
                    $(fieldId).value = fieldValue;
                    $(fieldId + "_editor").innerHTML = fieldValue.replace("<style", "<style media='none'");
                }
            }
            if (editor) {
                break;
            }
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype.editRTEfield = function (fieldId, fieldName) {
    const editorWrapper = new EditorWrapper('RTEditor');
    editorWrapper.setData($(fieldId).value);
    this.setEditorFieldValue = function () {
        var fieldValue = editorWrapper.getData();
        const categoryFieldEditor = Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.editorsById[fieldId];
        if (categoryFieldEditor) {
            if (editorWrapper.checkDirty()) {
                categoryFieldEditor.isInherited = false;
                $(fieldId).value = fieldValue;
            }
        } else {
            $(fieldId).value = fieldValue;
        }
    }
    dialog.setTitle("EditorDialog", fieldName);
    dialog.show("EditorDialog");
};

Dynamicweb.PIM.BulkEdit.prototype.finishRTE = function () {
    this.setEditorFieldValue();
    this.setEditorFieldValue = 'undefined';    
    dialog.hide("EditorDialog");
};

Dynamicweb.PIM.BulkEdit.prototype.closeEditorDialog = function () {
    this.updateEditorField();
    dialog.hide("EditorDialog");
};

Dynamicweb.PIM.BulkEdit.prototype.enableEditorToolbar = function (editor) {
    const editorId = editor.name ? editor.name : editor.id;
    const editorWrapper = new EditorWrapper(editorId);

    if (editorWrapper.isCKEditor) {
        for (var commnad in editor.commands) {
            editor.commands[commnad].enable();
        }
    } else {
        editorWrapper.container.querySelectorAll(".tox-editor-header button").forEach(function (button) {
            button.setAttribute("aria-disabled", "false");
            button.removeAttribute("disabled");
        });
    }
};

Dynamicweb.PIM.BulkEdit.prototype.disableEditorToolbar = function (editor) {
    const editorId = editor.name ? editor.name : editor.id;
    const editorWrapper = new EditorWrapper(editorId);

    if (editorWrapper.isCKEditor) {
        for (var commnad in editor.commands) {
            editor.commands[commnad].disable();
        }
    } else {
        editorWrapper.container.querySelectorAll(".tox-editor-header button").forEach(function (button) {
            button.setAttribute("aria-disabled", "true");
            button.setAttribute("disabled", "true");
        });
    }
};

Dynamicweb.PIM.BulkEdit.prototype.getControlId = function (productId, variantId, languageId, fieldId, fieldType) {
    var arr = [productId, variantId, languageId, fieldId];
    var id = arr.join("_;_");
    switch (fieldType) {
        case "EditorText":
            id += "_editor";
            break;
        case "Date":
        case "DateTime":
            id += "_label";
            break;
        case "Filemanager":
            id = "FM_" + id;
            break;
        case "Link":
            id = "Link_" + id;
            break;
    }
    return id;
};

Dynamicweb.PIM.BulkEdit.prototype.setSelectedFieldsValues = function () {
    let self = this;
    let getControlInfo = function (productId, variantId, languageId, fieldId, fieldType) {
        let controlId = self.getControlId(productId, variantId, languageId, fieldId, fieldType);
        return {
            controlId: controlId,
            controlType: fieldType
        };
    };
    let editedFields = self._getFieldsFromGrid();
    let documentFragment = document.createDocumentFragment();

    for (let k = 0; k < editedFields.length; k++) {
        let editedFieldObj = editedFields[k];
        let fieldDefinition = getControlInfo("", "", "", editedFieldObj.key, editedFieldObj.fieldType);
        self.createMultiEditHiddenField(fieldDefinition, editedFieldObj, documentFragment);
    }
    this.getForm().appendChild(documentFragment);
}

Dynamicweb.PIM.BulkEdit.prototype.getEditedFields = function () {
    var self = this;
    var editedFields = self._getFieldsFromGrid();

    return editedFields;
};

Dynamicweb.PIM.BulkEdit.prototype.isFieldEditorReadonly = function (fieldDifinition) {
    var isReadonly = false;
    switch (fieldDifinition.controlType) {
        case "Select":
        case "MultiSelectList":
            var fields = document.getElementsByName(fieldDifinition.controlId);
            isReadonly = fields.length == 0 || fields[0].hasClassName("disabled") || fields[0].disabled;
            break;
        case "RadioButtonList":
        case "CheckBoxList":
            var fields = document.getElementsByName(fieldDifinition.controlId);
            isReadonly = fields.length == 0 || fields[0].hasClassName("disabled") || fields[0].disabled;
            break;
        default:
            var el = document.getElementById(fieldDifinition.controlId);
            isReadonly = el.hasClassName("disabled") || el.disabled;
            break;
    }

    return isReadonly;
};

Dynamicweb.PIM.BulkEdit.prototype._createHidden = function (frm, controlId, value) {
    var el = document.getElementsByName(controlId);
    if (!el.length) {
        el = document.createElement('input');
        el.type = 'hidden';
        el.name = controlId;
        frm.appendChild(el);
    }
    el.value = value;
};

Dynamicweb.PIM.BulkEdit.prototype.createMultiEditHiddenField = function (fieldDefinition, updatedValue, documentFragment) {
    if (!fieldDefinition) {
        return;
    }
    var controlId = fieldDefinition.controlId;
    if (fieldDefinition.controlType == "Images") {        
        if (updatedValue.value != null) { 
            this._createHidden(documentFragment, "AddedImages_Details_" + controlId, updatedValue.value.addedImages);
            this._createHidden(documentFragment, "NewPrimaryImage_" + controlId, updatedValue.value.primaryImage);
        }
    }
    else {
        switch (fieldDefinition.controlType) {
            case "Date":
            case "DateTime":
                var tmpVal = updatedValue && updatedValue.value ? updatedValue.value : "";
                if (tmpVal.length > 4 && tmpVal.substr(0, 4) === "2999") {
                    tmpVal = "";
                }
                updatedValue.value = tmpVal;
                controlId = controlId.substring(0, controlId.length - "_label".length);
                break;
            case "EditorText":
                controlId = controlId.substring(0, controlId.length - "_editor".length);
                break;
            case "Filemanager":
                controlId = controlId.substring("FM_".length);
                break;
            case "Link":
                controlId = controlId.substring("Link_".length);
                break;
            case "Bool":
            case "Checkbox":
                this._createHidden(documentFragment, controlId + "_changed", true);
        }
        this._createHidden(documentFragment, controlId, updatedValue.value);
    }
};

Dynamicweb.PIM.BulkEdit.prototype._setFileManageControlValue = function (controlId, value) {
    var valEl = document.getElementById(controlId);
    var relPath = "";
    var path = "";
    if (value) {
        relPath = value;
        path = "/Files" + value;
    }

    if (valEl.options) {
        valEl.selectedIndex = _findOptionOrCreate(valEl, relPath, path);
    } else {
        valEl.value = path;
    }
    _fireEvent(valEl, "change");
};

Dynamicweb.PIM.BulkEdit.prototype._getFieldsFromGrid = function () {
    var self = this;
    var editedFields = dwGrid_FieldsGrid.rows.getAll().map(function (row) {
        var fieldSelector = row.element.select("select[id$='Fields']")[0];
        var id = fieldSelector.value;
        var selectedOption = fieldSelector.select("option[value='" + id + "']")[0];
        var label = selectedOption.innerHTML.trim();
        var variantEditing = selectedOption.getAttribute("variantediting");
        var languageEditing = selectedOption.getAttribute("languageediting");
        var fieldType = self._getControlType(id);

        var editorcontainer = null;
        var editorsContainer = row.element.select(".editorsContainer")[0];
        for (var i = 0; i < editorsContainer.children.length; i++) {
            var container = editorsContainer.children[i];
            if (container.tagName === "DIV") {
                if (!!self._getFieldsGridEditor(fieldType, container)) {
                    editorcontainer = container;
                    break;
                }
            }
        }
        if (!editorcontainer) {
            editorcontainer = editorsContainer.firstElementChild;
        }

        var value = self._getEditorValue(editorcontainer, fieldType);

        return { key: id, value: value, fieldType: fieldType, label: label, variantEditing: variantEditing, languageEditing: languageEditing };
    });

    return editedFields;
};

Dynamicweb.PIM.BulkEdit.prototype._getControlType = function (controlId) {
    var self = this;
    var controlType = "Text";

    var controlDifinition = self._getControlDefinition(controlId);

    if (controlDifinition && controlDifinition.controlType) {
        controlType = controlDifinition.controlType;
    }

    return controlType;
};

Dynamicweb.PIM.BulkEdit.prototype._getControlDefinition = function (controlId) {
    var self = this;
    return self._controlDefinitions.find(function (definition, index) {
        let id = controlId;
        switch (definition.controlType) {
            case "EditorText":
                id += "_editor";
                break;
            case "DateTime":
            case "Date":
                id += "_label";
                break;
        }
        return self._controlIdEndsWith(definition.controlId, "_" + id);
    });
};

Dynamicweb.PIM.BulkEdit.prototype._controlIdEndsWith = function (controlId, searchString) {
    var lastIndex = controlId.lastIndexOf(searchString);

    //Value not found
    if (lastIndex == -1) {
        return false;
    }

    //The value is found in the end of the controlId
    if (controlId.length == (lastIndex + searchString.length)) {
        return true;
    }

    return false;

};

Dynamicweb.PIM.BulkEdit.prototype._getEditorValue = function (editorContainer, fieldType) {
    var self = this;
    switch (fieldType) {
        case "Date":
        case "DateTime":
            if (editorContainer.select("[id$='" + fieldType + "FieldEditor_notSet']")[0].value == "True") {
                return "";
            }
            return editorContainer.select("[id$='" + fieldType + "FieldEditor_calendar']")[0].value;
        case "Checkbox":
        case "Bool":
            return editorContainer.select("[id$='" + fieldType + "FieldEditor']")[0].checked;
        case "EditorText":
            let editorId = editorContainer.id.substring("cke_".length);
            if (editorContainer.hasClassName('tox.tox-tinymce')) {
                const tinymceContainer = editorContainer.querySelector('.tox-edit-area').firstChild;
                if (tinymceContainer instanceof HTMLIFrameElement) {
                    editorId = tinymceContainer.id.split("_ifr")[0];
                }              
            }
            const editorWrapper = new EditorWrapper(editorId);
            if (editorWrapper.isTinymce || editorWrapper.isCKEditor) {
                return editorWrapper.getData();
            }
            return editorContainer.select("[id$='TextFieldEditor']")[0].value;
        case "MultiSelectList":
            var values = [];
            var editor = editorContainer.select("[id$='" + fieldType + "FieldEditor']")[0];
            for (var i = 0; i < editor.options.length; i++) {
                var option = editor.options[i];
                if (option.selected) {
                    values.push(option.value);
                }
            }
            return values;
        case "CheckBoxList":
            var checkedControls = editorContainer.querySelectorAll("input:checked");
            var values = [];
            for (var i = 0; i < checkedControls.length; i++) {
                values.push(checkedControls[i].value);
            }
            return values;
        case "RadioButtonList":
            var checkedCtrl = editorContainer.querySelector("input:checked");
            return checkedCtrl ? checkedCtrl.value : null;
        case "Images":
            var detailsHidden = editorContainer.querySelector("input.added-images-details");
            var primaryHidden = editorContainer.querySelector("input.new-primary-image");
            return { addedImages: detailsHidden ? detailsHidden.value : null, primaryImage: primaryHidden ? primaryHidden.value : null };
        default:
            var input = editorContainer.select("[id$='" + fieldType + "FieldEditor']")[0];
            var value = input.value;
            if (self._viewMode == gridView) {
                input.value = '';
            }
            return value;
    }
};

Dynamicweb.PIM.BulkEdit.prototype._onRowAdding = function () {
    if (!dwGrid_FieldsGrid.isBusy) {
        dwGrid_FieldsGrid._loadingTimeout = setTimeout(dwGrid_FieldsGrid.toggleLoading.bind(dwGrid_FieldsGrid, true), 1000);

        dwGrid_FieldsGrid.isBusy = true;

        Dynamicweb.Ajax.doPostBack({
            explicitMode: true,
            eventTarget: dwGrid_FieldsGrid.requestID,
            eventArgument: 'AddNewRow:' + dwGrid_FieldsGrid.state.currentRowID.value,
            onComplete: dwGrid_FieldsGrid.rowAddedEvent.bind(dwGrid_FieldsGrid),
            parameters: { ids: document.getElementById('Ids').value }
        });
    }
};

Dynamicweb.PIM.BulkEdit.prototype._updateFieldsGridRow = function (row, toggleGridLoader) {
    row.element.hide();
    var self = Dynamicweb.PIM.BulkEdit.get_current();
    const editorId = (row.ID - 1) + "EditorTextFieldEditor";
    var editorWrapper = new EditorWrapper(editorId);

    const initializeFunction = function () {
        if (editorWrapper.isCKEditor) {
            //set base z-index greater then dialog z-index
            editorWrapper.editorObj.config.baseFloatZIndex = 1500;
        }
        row.element.querySelectorAll("select[data-dwselector-transform='true']").forEach(function (selectorEl) {
            dwGlobal.createSelector({ select: selectorEl });
        });

        var container = row.element.select(".editorsContainer")[0];
        self._setEditorsVisibility(container, row.element.select("select[id$='Fields']")[0].value);
        row.element.select("select[id$='Fields']")[0].on('change', function () {
            self._setEditorsVisibility(container, this.value);
        });
        container.classList.remove("hidden");
        row.element.show();
        if (!!toggleGridLoader) {
            dwGrid_FieldsGrid.toggleLoading(false);
        }
    };

    if (editorWrapper.editorObj) {
        editorWrapper.onInstanceReady(initializeFunction);
    } else if (window.tinymce) {
        tinymce.on("AddEditor", function (event) {
            const editor = event.editor;
            if (editor.id == editorId) {
                editorWrapper = new EditorWrapper(editorId);
                editorWrapper.onInstanceReady(initializeFunction);
            }
        });
    }
};

Dynamicweb.PIM.BulkEdit.prototype._getFieldsGridEditor = function (fieldType, container) {
    let elementId = container.id;
    if (fieldType == "EditorText" && container.hasClassName("tox.tox-tinymce")) {
        elementId = container.querySelector(".tox-edit-area").firstChild.id;        
    }

    if (fieldType == "EditorText" && elementId.lastIndexOf("EditorTextFieldEditor") > -1) {        
        return container.previousElementSibling;
    } else if (fieldType == "Text") {
        return container.select("[id='TextFieldEditor']")[0];
    } else if (fieldType == "RadioButtonList") {
        return container.classList.contains("radio-group") ? container : null;
    } else if (fieldType == "CheckBoxList") {
        return container.classList.contains("checkboxgroup-ctrl") ? container : null;
    } else {
        return container.select("[id$='" + fieldType + "FieldEditor']")[0] || container.select("[id$='" + fieldType + "FieldEditor_calendar']")[0];
    }
};

Dynamicweb.PIM.BulkEdit.prototype._setEditorsVisibility = function (editorsContainer, controlId) {
    var self = this;
    var fieldEditor = null;
    var definition = self._getControlDefinition(controlId);
    var values = null;
    var fieldType = "Text";
    if (definition) {
        if (definition.controlType) {
            fieldType = definition.controlType;
        }
        if (definition.predefinedValues) {
            values = definition.predefinedValues;
        }
    }
    for (var i = 0; i < editorsContainer.children.length; i++) {
        var container = editorsContainer.children[i];
        if (container.tagName === "DIV") {
            var currentEditor = self._getFieldsGridEditor(fieldType, container);
            if (currentEditor) {
                if (!fieldEditor) {
                    fieldEditor = currentEditor;
                }
                container.show();
            } else {
                container.hide();
            }
        }
    }
    if (!fieldEditor) {
        editorsContainer.firstElementChild.show();
    } else if (fieldType == "Text" && definition) {
        if (definition.maxLength > 0) {
            fieldEditor.writeAttribute("maxlength", definition.maxLength);
        } else {
            fieldEditor.removeAttribute("maxlength");
        }
    } else if ((fieldType == "GroupDropDownList" || fieldType == "Select" || fieldType == "MultiSelectList") && fieldEditor && fieldEditor.tagName === "SELECT" && values) {
        fieldEditor.innerHTML = "";
        if (!values || !values.length) {
            fieldEditor.options.add(new Option(self.terminology["SelectPickerNoneOptionText"] || "None", ""));
        } else {
            self._populateDropDownList(fieldEditor, values);
        }
        if (fieldEditor.multiple) {
            var multiselectSize = fieldEditor.readAttribute("data-size");
            if (multiselectSize) {
                fieldEditor.size = (values.length > multiselectSize ? multiselectSize : values.length);
            }
        }
    }
    else if (fieldType == "RadioButtonList" || fieldType == "CheckBoxList" && fieldEditor && values && values.length) {
        fieldEditor = fieldEditor.children[0];
        const itemRenderer = fieldType == "RadioButtonList" ? self.renderRadioButtonItem : self.renderCheckboxItem;
        self._populateList(editorsContainer, fieldEditor, controlId, values, itemRenderer);
    }
    return fieldEditor;
};

Dynamicweb.PIM.BulkEdit.prototype.renderRadioButtonItem = function (controlId, controlName, text, value, isChecked) {
    let tplContent = `
<div class ="radio">
  <input id="${controlId}" name="${controlName}" type="radio" value="${value}">
  <label class ="control-label" for="${controlId}">${text}</label>
</div>`;
    const template = document.createElement("template");
    template.innerHTML = tplContent;
    const item = template.content.firstElementChild;
    if (isChecked) {
        item.querySelector("input").checked = true;
    }
    return item;
};

Dynamicweb.PIM.BulkEdit.prototype.renderCheckboxItem = function (controlId, controlName, text, value) {
    let tplContent = `
<div>
  <div class ="checkbox ">
    <input id="${controlId}" name="${controlName}" type="checkbox" class ="checkbox" value="${value}">
    <label class ="control-label" for="${controlId}">${text}</label>
  </div>
</div>`;
    const template = document.createElement("template");
    template.innerHTML = tplContent;
    const item = template.content.firstElementChild;
    return item;
};

Dynamicweb.PIM.BulkEdit.prototype._populateList = function (row, el, controlId, values, renderer) {
    el.innerHTML = "";
    const rowId = row.readAttribute("__rowid");
    for (let i = 0; i < values.length; i++) {
        const item = values[i];
        let itemCtrl = renderer(`${rowId}_${controlId}_${i}`, controlId, item.text, item.value, i === 0);
        el.appendChild(itemCtrl);
    }
}

Dynamicweb.PIM.BulkEdit.prototype._populateDropDownList = function (el, values, selectedValue) {
    var addOptionGroup = function (el, label) {
        var gr = document.createElement('OPTGROUP');
        gr.label = label;
        el.appendChild(gr);
        return gr;
    };
    var addOption = function (el, label, value) {
        var opt = document.createElement('OPTION');
        opt.textContent = label;
        opt.value = value;
        el.appendChild(opt);
        return opt;
    };
    var defaultGroup = el;
    for (var i = 0; i < values.length; i++) {
        var dropdownItem = values[i];
        if (dropdownItem.isOptionsGroup) {
            defaultGroup = addOptionGroup(el, dropdownItem.text);
        }
        else {
            var opt = addOption(defaultGroup, dropdownItem.text, dropdownItem.value);
            if (dropdownItem.value == selectedValue) {
                opt.setAttribute("selected", "selected");
            }
        }
    }

}

Dynamicweb.PIM.BulkEdit.prototype.openPreview = function (pageId, productId, variantId, groupId, languageId, showInList) {
    var variantIdParameter = (variantId && showInList) ? "&VariantID=" + variantId : "";
    var previewUrl = "/Admin/Module/eCom_Catalog/dw7/PIM/ProductPreview.aspx?PageId={0}&ProductID={1}{2}&GroupID={3}&LanguageID={4}&PimPreview=true".format(pageId, productId, variantIdParameter, groupId, languageId);
    Action.OpenWindow({ Url: previewUrl, OpenInNewTab: true });
};

Dynamicweb.PIM.BulkEdit.prototype.editProductImages = function (productImageId) {
    if (this.options.deprecateOldImages) {
        return;
    }
    this.currentlyEditingProductRow = productImageId;
    this._setFileManageControlValue('FM_ProductImageSmall', $(productImageId + '__ProductImageSmall').value.replace(/^(\/Files\/)/, ""));
    this._setFileManageControlValue('FM_ProductImageMedium', $(productImageId + '__ProductImageMedium').value.replace(/^(\/Files\/)/, ""));
    this._setFileManageControlValue('FM_ProductImageLarge', $(productImageId + '__ProductImageLarge').value.replace(/^(\/Files\/)/, ""));

    dialog.show('ProductImagesPicker');
};

Dynamicweb.PIM.BulkEdit.prototype.changeImages = function () {
    var smallImage = $('ProductImageSmall_path').value;
    var mediumImage = $('ProductImageMedium_path').value;
    var largeImage = $('ProductImageLarge_path').value;

    smallImage = this._fixImagePath(smallImage);
    mediumImage = this._fixImagePath(mediumImage);
    largeImage = this._fixImagePath(largeImage);

    $(this.currentlyEditingProductRow + '__ProductImageSmall').value = smallImage;
    $(this.currentlyEditingProductRow + '__ProductImageMedium').value = mediumImage;
    $(this.currentlyEditingProductRow + '__ProductImageLarge').value = largeImage;

    var productRowImage = $(this.currentlyEditingProductRow + '__Image');
    if (!smallImage && !mediumImage && !largeImage) {
        productRowImage.src = this._missingImagePath;
        productRowImage.addClassName("missing-image");
    } else {
        var image = smallImage || mediumImage || largeImage;
        productRowImage.src = this._getImagePath + encodeURIComponent(this._getCorrectImagePath(image));
        productRowImage.removeClassName("missing-image");
    }

    dialog.hide('ProductImagesPicker');
    this.currentlyEditingProductRow = "";
};

Dynamicweb.PIM.BulkEdit.prototype._getCorrectImagePath = function (path) {
    if (path != null && path.toLowerCase().startsWith("/files")) {
        path = "/Files" + path;
    }
    return path;
}

Dynamicweb.PIM.BulkEdit.prototype._fixImagePath = function (image) {
    var newPath = image.replace(/^(\/Files\/)/, "");
    if (newPath.length > 0) {
        newPath = newPath[0] === "/" ? newPath : "/" + newPath;
    }

    return newPath;
};

Dynamicweb.PIM.BulkEdit.prototype.closeRelatedGroupsDialog = function (pimGroupsShown) {
    var self = this;
    dialog.hide(pimGroupsShown ? "RelatedPimGroupsDialog" : "RelatedEcomGroupsDialog");
    if (self._productPrimaryGroup != $('PrimaryRelatedGroup').value || $("GroupsToDelete").value) {
        var message = self.terminology["ChangeRelatedGroup"] || "Do you want to save group changes on product?";
        self.showConfirmMessage(message, function () { self.submitFormWithCommand("SaveRelatedGroupChanges") });
    }
};

//buttons is flags enum value where SubmitOk = 1,  SubmitCancel = 2,    Cancel = 4,    Close = 8
Dynamicweb.PIM.BulkEdit.prototype.showConfirmMessage = function (message, onConfirm, onCancel, buttons, cancelButtonTitle, okButtonTitle) {
    var self = this;
    var confirmation = self._cloneAction(self.confirmAction);
    if (confirmation) {
        if (confirmation.Url.indexOf("&Message=") > -1) {
            confirmation.Url = confirmation.Url.replace(new RegExp('Message=[^&]*&*', "ig"), "");
        }
        confirmation.Url += "&Message=" + encodeURIComponent(message);
        if (onConfirm) {
            if (typeof (onConfirm) == "function") {
                confirmation.OnSubmitted = { Name: "ScriptFunction", Function: function () { onConfirm() } };
            } else if (typeof (onConfirm) == "object") {
                confirmation.OnSubmitted = onConfirm;
            }
        }
        if (buttons) {
            confirmation.Url += "&Buttons=" + buttons;
        }
        if (cancelButtonTitle) {
            confirmation.Url += "&CancelTitle=" + cancelButtonTitle;
            confirmation.Url += "&SubmitCancelTitle=" + cancelButtonTitle;
        }
        if (okButtonTitle) {
            confirmation.Url += "&SubmitOkTitle=" + okButtonTitle;
        }
        
        if (onCancel) {
            if (typeof (onCancel) == "function") {
                confirmation.OnCancelled = { Name: "ScriptFunction", Function: function () { onCancel() } };
            } else if (typeof (onCancel) == "object") {
                confirmation.OnCancelled = onCancel;
            }
        }
        Action.Execute(confirmation);
    }
};

Dynamicweb.PIM.BulkEdit.prototype.navigateToProduct = function (confirmMassage, productId, queryId, groupId, variantId, variantTreeClicked) {
    this.openProduct({ productId, queryId, groupId, variantId, scrollToVariant: variantTreeClicked });
}

Dynamicweb.PIM.BulkEdit.prototype.getProductListPageIds = function () {
    var pimProductPageIdsControl = document.getElementById("CurrentPageProductIds");
    if (this._viewMode != listMode && this._viewMode != thumbnail && this._viewMode != multiEdit) {
        if (!pimProductPageIdsControl || !pimProductPageIdsControl.value) {
            if (window.top.pimProductPageIdsControl) {
                return window.top.pimProductPageIdsControl[this._groupId];
            }
        } else {
            return pimProductPageIdsControl.value;
        }
    } else if (pimProductPageIdsControl) {
        if (!window.top.pimProductPageIdsControl) {
            window.top.pimProductPageIdsControl = {};
        }
        window.top.pimProductPageIdsControl[this._groupId] = pimProductPageIdsControl.value;
        return pimProductPageIdsControl.value;
    }
    return "";
}

Dynamicweb.PIM.BulkEdit.prototype.openProduct = function ({ productId, variantId = "", queryId, groupId, scrollToVariant = false, scrollToField = false, fieldControlIdToScroll, listPageIds = null, showAllProducts = undefined}) {
    var self = this;
    var url = self.getProductEditUrl({ productId, variantId, queryId, groupId });
    window.top.navigateToVariants = false;
    window.top.fieldControlIdToScroll = null;
    this.setScrollCoordinates(null);
    if (scrollToVariant) {
        window.top.navigateToVariants = true;
    }
    if (showAllProducts !== undefined) {
        window.top.showAllProducts = showAllProducts;
    }
    if (scrollToField) {
        window.top.fieldControlIdToScroll = fieldControlIdToScroll;
    }
    if (listPageIds == null) {
        listPageIds = self.getProductListPageIds();
    }
    Action.openWindowWithVerb("POST", url, { 'CurrentPageProductIds': listPageIds })
}

Dynamicweb.PIM.BulkEdit.prototype.getProductEditUrl = function ({ productId, variantId = "", queryId, groupId }) {
    var self = this;
    queryId = queryId || self._queryId;
    var parameters = "";
    if (queryId) {
        parameters = "&queryId=" + queryId + "&groupID=" + self._groupId;
    } else {
        parameters = "&GroupID=" + (groupId || self._groupId);
    }
    if (self._basePath) {
        parameters += "&BasePath=" + self._basePath;
    }
    return "/Admin/Module/eCom_Catalog/dw7/PIM/PimProduct_Edit.aspx?ID=" + productId + "&VariantID=" + variantId + parameters;
}

Dynamicweb.PIM.BulkEdit.prototype._cloneAction = function (originalAction) {
    if (null == originalAction || "object" != typeof originalAction) return originalAction;
    var copy = originalAction.constructor();
    for (var attr in originalAction) {
        if (originalAction.hasOwnProperty(attr)) copy[attr] = originalAction[attr];
    }
    return copy;
};

Dynamicweb.PIM.BulkEdit.prototype.setPageSize = function (size) {
    var prevSize = $("PageSizeHidden").value;
    var pageNumberEl = $("PageNumber");
    var ratio = prevSize / size;
    var newNumber = 1;
    if (ratio < 1) {
        newNumber = Math.ceil(pageNumberEl.value * ratio);
    } else {
        newNumber = Math.floor(ratio) * (pageNumberEl.value - 1) + 1;
    }
    pageNumberEl.value = newNumber < 1 ? 1 : newNumber;
    $("PageSizeHidden").value = size;
    this.submitFormWithCommand("ChangePageSize");
};

Dynamicweb.PIM.BulkEdit.prototype.ShowExportToExcelDialog = function (selectedProducts) {
    var self = this;
    if (selectedProducts != null) {
        var ids = selectedProducts.join('|,|');
        let frame = document.getElementById("ExportToExcelDialogFrame");
        dialog.showLoader('ExportToExcelDialog');
        frame.setAttribute('src', "about:blank"); // "about:blank" is way to show spiner during "POST" to iframe
        dialog.show('ExportToExcelDialog');
        if (self.options.permissions.ExportExcelPermission >= (PermissionLevels.Delete || PermissionLevels.PermissionLevelDelete)) { 
            var savePresetBtn = document.getElementById("SavePresetButton");
            if (!savePresetBtn) {
                var cmdPanel = document.getElementById('ExportToExcelDialog').querySelector(".bodywrapper .cmd-pane");
                cmdPanel.insertAdjacentHTML('afterbegin', '<button id="SavePresetButton" type="button" class="btn btn-clean" onclick="Dynamicweb.PIM.BulkEdit.prototype.SaveExportToExcelPreset();return false;">Save Preset</button>');            
            }
        }
        frame.onload = () => {
            dialog.hideLoader('ExportToExcelDialog');
            const groupId = self._groupId || "";
            const queryId = self._queryId || "";
            const showAllProducts = this._showAllProducts || "";
            Action.openWindowWithVerb("POST", `PimExportToExcel.aspx?GroupId=${groupId}&QueryId=${queryId}&ShowAllProducts=${showAllProducts}`, { 'ids': ids }, "ExportToExcelDialogFrame");
            frame.onload = () => {
                dialog.hideLoader('ExportToExcelDialog');
            };
        };
       
    }
};

Dynamicweb.PIM.BulkEdit.prototype.closeExportToExcelDialog = function () {
    dialog.hide("ExportToExcelDialog");
};

Dynamicweb.PIM.BulkEdit.prototype.ExportToExcel = function () {
    var exportProductsDialogFrame = document.getElementById('ExportToExcelDialogFrame');
    let dlg = dialog;
    dlg.showLoader('ExportToExcelDialog');
    var iFrameDoc = (exportProductsDialogFrame.contentWindow || exportProductsDialogFrame.contentDocument);
    iFrameDoc.exportToExcel();
    exportProductsDialogFrame.onload = () => {
        dlg.hideLoader('ExportToExcelDialog');
    };
};

Dynamicweb.PIM.BulkEdit.prototype.SaveExportToExcelPreset = function () {
    var exportProductsDialogFrame = document.getElementById('ExportToExcelDialogFrame');
    var iFrameDoc = (exportProductsDialogFrame.contentWindow || exportProductsDialogFrame.contentDocument);
    iFrameDoc.openPresetSaveDialog();
};

Dynamicweb.PIM.BulkEdit.prototype.closeExportDialog = function (url) {
    if (parent != null) {
        if (typeof parent.closeExportToExcel !== "undefined") {
            parent.closeExportToExcel();
        } else if (typeof parent.Dynamicweb.PIM.BulkEdit.prototype.closeExportToExcelDialog !== "undefined") {
            parent.Dynamicweb.PIM.BulkEdit.prototype.closeExportToExcelDialog();
        }
    }
    self._checkUnloadChanges = false;
    window.location = url;
};


////           Draft/workflow

Dynamicweb.PIM.BulkEdit.prototype.useDraft = function () {
    if (this._approvalState > 0) {
        dialog.show("QuitDraftDialog");
    }
    else {
        this.toggleDraft();
    }
}

Dynamicweb.PIM.BulkEdit.prototype.previewCompare = function (productId, versionId) {
    var url = '/Admin/Module/eCom_Catalog/dw7/Workflow/ProductVersionsCompare.aspx?ProductId=' + productId + '&VersionId=' + versionId;
    dialog.show('ProductVersionsCompareDialog', url);
}

Dynamicweb.PIM.BulkEdit.prototype.rollbackVersion = function (versionId) {
    document.getElementById("rollbackVersion").value = versionId;
    this.submitFormWithCommand("RollbackVersion");
}

Dynamicweb.PIM.BulkEdit.prototype.publishChanges = function () {
    this.submitFormWithCommand(this.terminology["PublishDraftCommand"] || "PublishDraft");
}

Dynamicweb.PIM.BulkEdit.prototype.discardChanges = function (skipChangesWarning) {
    var self = this;

    if (skipChangesWarning) {
        self.submitFormWithCommand(self.terminology["DiscardChangesCommand"] || "DiscardChanges");
    } else {
        var message = self.terminology["ConfirmDiscard"] || "Discard changes?";
        self.showConfirmMessage(message, function () { self.submitFormWithCommand(self.terminology["DiscardChangesCommand"] || "DiscardChanges") });
    }
}

Dynamicweb.PIM.BulkEdit.prototype.showVersions = function (productId, variantId, languageId) {
    var url = '/Admin/Module/eCom_Catalog/dw7/Workflow/ProductVersionsList.aspx?';
    url += 'ProductId=' + productId;
    url += '&ProductVariantId=' + variantId;
    url += '&ProductLanguageId=' + languageId;

    dialog.show('ProductVersionsDialog', url);
}

Dynamicweb.PIM.BulkEdit.prototype.toggleDraft = function () {
    var self = this;
    self.submitFormWithCommand(self.terminology["ToggleDraftCommand"] || "ToggleDraft", true);
}

Dynamicweb.PIM.BulkEdit.prototype.quitDraftCancel = function () {
    dialog.hide("QuitDraftDialog");
    Ribbon.checkBox("cmdUseDraft");
}

Dynamicweb.PIM.BulkEdit.prototype.quitDraftOk = function () {
    if (document.getElementById("QuitDraftPublish").checked) {
        document.getElementById("ExitDraftCmd").value = this.terminology["PublishDraftCommand"] || "PublishDraft";
    }
    if (document.getElementById("QuitDraftDiscard").checked) {
        document.getElementById("ExitDraftCmd").value = this.terminology["DiscardChangesCommand"] || "DiscardChanges";
    }
    this.submitFormWithCommand(this.terminology["ToggleDraftCommand"] || "ToggleDraft");
};

Dynamicweb.PIM.BulkEdit.prototype.productFieldsBulkEdit = function (productId) {
    var url = "/Admin/Module/eCom_Catalog/dw7/PIM/FieldsBulkEdit.aspx?ids={productId}&groupId={groupId}&queryId={queryId}";
    this.openScreenAction.Url = url;
    Action.Execute(this.openScreenAction, {
        productId: productId,
        groupId: this._groupId || "",
        queryId: this._queryId || ""
    });
};

Dynamicweb.PIM.BulkEdit.prototype.showProductPrices = function (productId) {
    let url = "/Admin/Module/eCom_Catalog/dw7/PIM/EcomPriceList.aspx?ProductId={productId}&groupId={groupId}&queryId={queryId}"
    url = Action.Transform(url, {
        productId: productId,
        groupId: this._groupId || "",
        queryId: this._queryId || ""
    });
    dialog.show("ProductPricesDialog", url);
};

Dynamicweb.PIM.BulkEdit.prototype.showProductStocks = function (productId) {
    let url = "/Admin/Module/eCom_Catalog/dw7/PIM/EcomStockList.aspx?ProductId={productId}&groupId={groupId}&queryId={queryId}"
    url = Action.Transform(url, {
        productId: productId,
        groupId: this._groupId || "",
        queryId: this._queryId || ""
    });
    dialog.show("ProductStocksDialog", url);    
};

Dynamicweb.PIM.BulkEdit.prototype.showProductDiscounts = function (productId) {
    let url = "/Admin/Module/eCom_Catalog/dw7/PIM/EcomDiscountList.aspx?ProductId={productId}&groupId={groupId}&queryId={queryId}"
    url = Action.Transform(url, {
        productId: productId,
        groupId: this._groupId || "",
        queryId: this._queryId || ""
    });
    dialog.show("ProductDiscountsDialog", url);    
};

Dynamicweb.PIM.BulkEdit.prototype.showProductVatGroups = function (productId) {
    let url = "/Admin/Module/eCom_Catalog/dw7/PIM/EcomVatGroupList.aspx?ProductId={productId}&groupId={groupId}&queryId={queryId}"
    url = Action.Transform(url, {
        productId: productId,
        groupId: this._groupId || "",
        queryId: this._queryId || ""
    });
    dialog.show("ProductVatGroupsDialog", url);
};

Dynamicweb.PIM.BulkEdit.prototype.productTypeChanged = function (productTypeSelector, productId, languageId) {
    var self = this;
    if (self._viewMode == productEdit && self.options.permissions.PartListPermission >= (PermissionLevels.Read || PermissionLevels.PermissionLevelRead)) { 
        if (productTypeSelector.value == 2) {
            RibbonPartsListsButton.removeClassName("disabled");
            RibbonPartsListsButton.on("click", function () {
                self.showProductParts(productId, languageId);
            });
        } else {
            RibbonPartsListsButton.addClassName("disabled");
            RibbonPartsListsButton.stopObserving('click');
        }
    }
}

Dynamicweb.PIM.BulkEdit.prototype.showProductParts = function (productId, languageId, checkArr, methodType) {
    let url = "/Admin/Module/eCom_Catalog/dw7/PIM/EcomPartsList.aspx?ProductId={productId}&ProductLanguageId={languageId}&FromPim=true"
    url = Action.Transform(url, {
        productId: productId,
        languageId: languageId
    });
    if (checkArr && methodType) {
        url += "&CMD=AddRelation";
        url += "&checkArr=" + checkArr;
        url += "&methodType=" + methodType;
        dialog.hide("ProductEditMiscDialog");
    }
    else if (window.event.target.id != 'RibbonPartsListsButton') {
        return;
    }
    dialog.show("PartsDialog", url);
};

Dynamicweb.PIM.BulkEdit.prototype.showComments = function (productId, languageId) {
    let url = "/Admin/Content/Comments/List.aspx?Type=ecomProduct&ItemID={productId}&LangID={languageId}&FromPim=true"
    url = Action.Transform(url, {
        productId: productId,
        languageId: languageId
    });
    dialog.show("CommentsDialog", url);
};

Dynamicweb.PIM.BulkEdit.prototype.productsFieldsBulkEdit = function (productIds, viewMode, fromProductEdit) {
    var self = this;
    var filteredProductIds = productIds;

    if (productIds.length >= 501) {
        filteredProductIds = productIds.slice(0, 501)
    }
    var url = viewMode == productEditFieldsBulkEdit ? "/Admin/Module/eCom_Catalog/dw7/PIM/FieldsBulkEdit.aspx" : "/Admin/Module/eCom_Catalog/dw7/PIM/PimGridEdit.aspx";
    url += "?groupId={groupId}&queryId={queryId}&multiProducts={multiProducts}&returnUrl={returnUrl}";
    var returnUrl = "";
    if (fromProductEdit) {
        var productId = productIds[0];
        returnUrl = self.getProductEditUrl({ productId });
    } else {
        returnUrl = self.getListViewUrl(self._viewMode);
    }
    var model = {
        ids: filteredProductIds.join('|,|'),
        multiProducts: !fromProductEdit,
        groupId: self._groupId || "",
        queryId: self._queryId || "",
        returnUrl: returnUrl
    };
    url = Action.Transform(url, model, true);

    var theForm = document.createElement('form');
    theForm.action = url;
    theForm.method = 'POST';

    var idsInput = document.createElement('input');
    idsInput.type = 'hidden';
    idsInput.name = 'ids';
    idsInput.value = filteredProductIds.join('|,|');
    theForm.appendChild(idsInput);

    document.body.appendChild(theForm);
    theForm.submit();
};

Dynamicweb.PIM.BulkEdit.prototype.getForm = function () {
    return this._form;
};

Dynamicweb.PIM.BulkEdit.prototype.openCategoryFieldsDialog = function () {
    dialog.show('ProductCategoryFieldsDialog');
};

Dynamicweb.PIM.BulkEdit.prototype.changeCategoryFields = function () {
    new overlay('screenLoaderOverlay').show();
    dialog.hide('ProductCategoryFieldsDialog');
    $("categoryFields").value = SelectionBox.getElementsRightAsArray("CategoryFieldsList").join();
    this.submitFormWithCommand("ChangeCategoryFields", true);
};

Dynamicweb.PIM.BulkEdit.prototype.addProduct = function (controlId) {
    var caller = "opener.Dynamicweb.PIM.BulkEdit.get_current()"; 
    var caller2 = encodeURIComponent(controlId);
    window.open("/Admin/Module/eCom_Catalog/dw7/Edit/EcomGroupTree.aspx?CMD=ShowProd&AddCaller=1&FromPIM=true&caller=" + caller + "&caller2=" + caller2, "", "displayWindow,width=460,height=400,scrollbars=no");
};

Dynamicweb.PIM.BulkEdit.prototype.updateProductEditor = function (controlId, prodID, variantID, prodName) {
    let el = document.getElementById(controlId);
    if (el) {
        el.value = prodID + "#" + variantID;

        el = document.getElementById(controlId + "_editor");
        el.value = prodName;
    }
};

Dynamicweb.PIM.BulkEdit.prototype.removeProduct = function (controlId) {
    let el = document.getElementById(controlId);
    if (el) {
        el.value = "";

        el = document.getElementById(controlId + "_editor");
        el.value = "";
    }
};

Dynamicweb.PIM.BulkEdit.prototype.uploadImageForProduct = function (e, btn, controlId, categoryId) {
    const self = this;
    let initialProductNumber = btn.closest(".image-buttons-container").readAttribute("data-product-number");    
    if (btn.readAttribute("create-upload-folder-for-product") !== "true") {
        initialProductNumber = null;
    }
    const uploadPath = btn.readAttribute("data-base-upload-folder");
    const imagesContainer = e.target.closest(".images-container");
    
    dwGlobal.fileUpload(self.getImagesUploadFolder(controlId, uploadPath, initialProductNumber), function (uploadInfo) {
        let folder = uploadInfo.Folder;
        if (folder && folder.substring(folder.length - 1) != "/") {
            folder += "/";
        }
        let files = uploadInfo.Files.map(function (fileInfo) {
            return folder + fileInfo.name;
        });
        self.addFilesToImageDetails(files, controlId, imagesContainer, categoryId, true);
    }, false, true, self.options.imagesAllowedExtentions);
    return false;
};

Dynamicweb.PIM.BulkEdit.prototype.getImagesUploadFolder = function (controlId, uploadPath, initialProductNumber) {
    let folder = uploadPath;
    if (folder && folder.substring(folder.length - 1) != "/") {
        folder += "/";
    }
    if (initialProductNumber != null) {
        let productNumber = this.getCurrentProductNumber(controlId, initialProductNumber);
        folder += (productNumber || "").replace(/[/\\?%*:|"\'<>]/g, '_');
    }
    return folder;
};

Dynamicweb.PIM.BulkEdit.prototype.getCurrentProductNumber = function (controlId, initialProductNumber) {
    let arr = controlId.split("_;_");
    let numberControlId = this.getControlId(arr[0], arr[1], arr[2], "__product_property__number", "");
    let el = document.getElementById(numberControlId);
    let productNumber = initialProductNumber;
    if (el) {
        productNumber = el.value;
    }
    return productNumber;
};

Dynamicweb.PIM.BulkEdit.prototype.selectImageForProduct = function (e, btn, controlId, categoryId) {
    let imagesContainer = e.target.closest(".images-container");
    let imageSelectorElId = "ImageSelector_" + controlId;
    let el = document.getElementById(imageSelectorElId);
    const initialProductNumber = btn.closest(".image-buttons-container").readAttribute("data-product-number");
    let productNumber = this.getCurrentProductNumber(controlId, initialProductNumber);
    let self = this;
    showFileLinkDialog({
        caller: imageSelectorElId,
        file: el.value,
        allowedExtensions: self.options.imagesAllowedExtentions,
        multiSelect: true,
        onSelected: function (filePathes) {
            for (let i = 0; i < filePathes.length; i++) {
                let filePath = filePathes[i];
                let relPath = _makeRelativePath("/Files", filePath);
                if (relPath && relPath.substring(0, 1) != "/") {
                    relPath = "/" + relPath;
                }
                self.addFilesToImageDetails([relPath], controlId, imagesContainer, categoryId, false);
            }
        },
        searchTerm: productNumber
    });
    return false;
};

Dynamicweb.PIM.BulkEdit.prototype.addFilesToImageDetails = function (files, controlId, imagesContainer, categoryId, isUpload) {
    var data = new FormData();
    data.append("CMD", "ImageDetailsItems");
    data.append("ControlId", controlId);

    var storageEl = document.getElementById("AddedImages_Details_" + controlId);
    var filesVal = [];
    var addedFiles = storageEl.value ? storageEl.value.split(":") : [];
    files.forEach(function (file) {
        filesVal.push(file + "|" + categoryId);
    });
    data.append('files', filesVal.join(":"));
    storageEl.value = addedFiles.concat(filesVal).join(":");
    var url = this.options.urls.taskRunner;
    var cnt = imagesContainer.querySelector(".image-cnt.image-buttons-container");
    var self = this;
    var isUploadCmd = isUpload;
    fetch(url, {
        method: 'POST',
        credentials: 'same-origin',
        body: data
    }).then(function (response) {
        if (response.status >= 200 && response.status < 300) {
            return response.text()
        }
        else {
            var error = new Error(response.statusText)
            error.response = response
            throw error
        }
    }).then(function (responseText) {
        cnt.insertAdjacentHTML("beforebegin", responseText);
        if (isUploadCmd) {
            for (var i = 0; i < files.length; i++) {
                var testFile = files[i];
                var sameInsertedImages = document.querySelectorAll(`img.image-block[data-image-path='${testFile}'],img.image-block[data-image-path='/Files${testFile}']`);
                for (var j = 0; j < sameInsertedImages.length; j++) {
                    var el = sameInsertedImages[j];
                    var src = el.getAttribute("src");
                    var prevTic = el.getAttribute("data-modified");
                    var t = new Date().getTime();
                    if (prevTic) {
                        src = src.replace(`&modified=${prevTic}`, `&modified=${t}`);
                    }
                    else {
                        src = src + `&modified=${t}`;
                    }
                    el.setAttribute("data-modified", t);
                    el.setAttribute("src", src);
                }
            }
        }
    }).catch(function (error) {
        console.log('There has been a problem with your fetch operation: ' + error.message);
        alert(error.message);
    });
}

Dynamicweb.PIM.BulkEdit.prototype.deleteDetailImage = function (e, controlId) {
    var imageCnt = e.target.closest(".image-cnt");
    var imagesContainer = imageCnt.closest(".images-container");
    if (dwGlobal.Dom.hasClass(imageCnt, "new-detail-image")) {
        var storageEl = document.getElementById("AddedImages_Details_" + controlId);
        var allAddedImages = imagesContainer.querySelectorAll(".image-cnt.new-detail-image");
        var index = -1;
        for (var i = 0; i < allAddedImages.length; i++) {
            if (allAddedImages[i] === imageCnt) {
                index = i;
                break;
            }
        }
        if (index > -1) {
            var addedFiles = storageEl.value ? storageEl.value.split(":") : [];
            addedFiles.splice(index, 1);
            storageEl.value = addedFiles.join(":");
        }
    }
    else {
        var storageEl = document.getElementById("RemovedImages_Details_" + controlId);
        var removedFiles = storageEl.value ? storageEl.value.split(":") : [];
        var detailId = imageCnt.readAttribute("data-detail-id");
        removedFiles.push(detailId);
        storageEl.value = removedFiles.join(":");
    }
    imageCnt.remove();
}

Dynamicweb.PIM.BulkEdit.prototype.setPrimaryImage = function (e, controlId) {
    var imageCnt = e.target.closest(".image-cnt");
    if (imageCnt.classList.contains("primary-image-container")) {
        this.makePrimaryImageAsDetailImage(e, controlId);
    } else {
        this.makeDetailImageAsPrimaryImage(e, controlId);
    }
}

Dynamicweb.PIM.BulkEdit.prototype.makePrimaryImageAsDetailImage = function (e, controlId, imageCnt, fnAfter) {
    var self = this;
    imageCnt = imageCnt || e.target.closest(".image-cnt");
    var imgPath = imageCnt.querySelector(".image-block").readAttribute("data-image-path");
    var detailId = imageCnt.readAttribute("data-detail-id");
    var groupId = parseInt(imageCnt.getAttribute("data-detail-group-id"));
    var defaultImageGroupContainer = document.getElementById("ImageGroupContainer_" + controlId + "_0");
    var defaultPrimaryImgCnt = defaultImageGroupContainer.querySelector(".primary-image-container-default");
    var data = new FormData();
    data.append("CMD", "DetailImage");
    data.append('file', imgPath);
    data.append("ControlId", controlId);
    data.append("detailId", detailId);
    data.append("groupId", groupId);

    var url = this.options.urls.taskRunner;
    fetch(url, {
        method: 'POST',
        credentials: 'same-origin',
        body: data
    }).then(function (response) {
        if (response.status >= 200 && response.status < 300) {
            return response.text()
        }
        else {
            var error = new Error(response.statusText)
            error.response = response
            throw error
        }
        }).then(function (responseText) {
            var storageEl = document.getElementById("NewPrimaryImage_" + controlId);
            var detailStorageEl = document.getElementById("NewPrimaryDetail_" + controlId);
            storageEl.value = "";
            detailStorageEl.value = "0";
            var containerId = "ImageGroupContainer_" + controlId;
            var groupContainer = document.getElementById(containerId + "_" + groupId) || document.getElementById(containerId + "_0");
            var addImageButtonsContainer = groupContainer.querySelector(".image-buttons-container");
            addImageButtonsContainer.insertAdjacentHTML("beforebegin", responseText);
            if (defaultPrimaryImgCnt) {
                var cnt = defaultPrimaryImgCnt.cloneNode(true)
                defaultPrimaryImgCnt.insertAdjacentElement("afterend", cnt);
                cnt.classList.add("primary-image-container");
                cnt.classList.remove("primary-image-container-default");

                var imgBadge = imageCnt.querySelector(".image-badge");
                if (imgBadge) {
                    imgBadge.remove();
                }

            }
            imageCnt.remove();
            self.setAssetCategoryTitle(addImageButtonsContainer.previousElementSibling);

            if (fnAfter) {
                fnAfter({
                    storageEl: storageEl,
                    detailStorageEl: detailStorageEl,

                })
            }
        }).catch(function (error) {
        console.log('There has been a problem with your fetch operation: ' + error.message);
        alert(error.message);
    });
}

Dynamicweb.PIM.BulkEdit.prototype.makeDetailImageAsPrimaryImage = function (e, controlId) {
    var self = this;
    var imageCnt = e.target.closest(".image-cnt");
    var defaultImageGroupContainer = document.getElementById("ImageGroupContainer_" + controlId + "_0");
    var primaryImgCnt = defaultImageGroupContainer.querySelector(".primary-image-container");

    var makeAsPrimary = function () {
        var primaryImgCnt = defaultImageGroupContainer.querySelector(".primary-image-container");
        var firstImageInBlock = defaultImageGroupContainer.firstChild;            
        defaultImageGroupContainer.insertBefore(imageCnt, firstImageInBlock);
        imageCnt.classList.add("primary-image-container");
        imageCnt.classList.remove("details-image-container");
        if (primaryImgCnt) {
            primaryImgCnt.remove();
        }
        imageCnt.setAttribute("data-is-default", "true");
        var imageMenu = imageCnt.querySelector(".image-menu");
        if (imageMenu) {
            var setDefaultButton = imageMenu.querySelector(".image-menu-set-default-button");
            setDefaultButton.setAttribute("title", self.terminology["RemoveDefaultImage"] || "Remove as default");
            imageMenu.querySelector(".image-menu-set-category-button").style.display = "none";
            imageMenu.querySelector(".image-menu-delete-button").setAttribute("disabled", "disabled");

            var badgeIcon = imageCnt.querySelector(".badge-icon");
            if (!badgeIcon) {
                badgeIcon = document.createElement("i");
                imageCnt.appendChild(badgeIcon);

                var imgBadge = imageCnt.querySelector(".image-badge");
                if (!imgBadge) {
                    var imgBadge = document.createElement("div");
                    imgBadge.setAttribute('class', 'image-badge');
                    imageCnt.insertBefore(imgBadge, imageCnt.childNodes[0]);
                }

                var assetCategoryTitle = imageCnt.querySelector(".asset-title");
                if (assetCategoryTitle) {
                    assetCategoryTitle.remove();
                }
            }
            badgeIcon.setAttribute("class", "badge-icon md  md-star color-default");
        }

        var storageEl = document.getElementById("NewPrimaryImage_" + controlId);
        var detailStorageEl = document.getElementById("NewPrimaryDetail_" + controlId);
        var imgPath = imageCnt.querySelector(".image-block").readAttribute("data-image-path");
        var detailId = imageCnt.readAttribute("data-detail-id");
        storageEl.value = imgPath;
        detailStorageEl.value = detailId;
    };

    if (primaryImgCnt && primaryImgCnt.getAttribute("data-is-default") == "true") {
        self.makePrimaryImageAsDetailImage(e, controlId, primaryImgCnt, makeAsPrimary);
    } else {
        makeAsPrimary();
    }
}

Dynamicweb.PIM.BulkEdit.prototype.setAssetCategoryTitle = function (imageBlock) {
    var assetCategoryTitle = imageBlock.querySelector(".asset-title");
    if (!assetCategoryTitle) {
        assetCategoryTitle = document.createElement("div");
        assetCategoryTitle.setAttribute('class', 'asset-title');
        imageBlock.insertBefore(assetCategoryTitle, imageBlock.childNodes[0]);
    }
    assetCategoryTitle.setAttribute("title", imageBlock.getAttribute("data-detail-category-name"));
    assetCategoryTitle.innerText = imageBlock.getAttribute("data-detail-category-name");
}

Dynamicweb.PIM.BulkEdit.prototype._moveImageBlock = function (imageBlock, imageGroupContainer) {    
    this.setAssetCategoryTitle(imageBlock);
    if (imageGroupContainer) {
        var addImageButtonsContainer = imageGroupContainer.querySelector(".image-buttons-container");
        imageGroupContainer.insertBefore(imageBlock, addImageButtonsContainer);
    }
}

Dynamicweb.PIM.BulkEdit.prototype.switchGroupedView = function (useGroupedViewMode) {
    $("groupedViewMode").value = useGroupedViewMode;
    this.submitFormWithCommand("SwitchGroupedView", true);
}

Dynamicweb.PIM.BulkEdit.prototype.delocalizeProduct = function (productId, variantId, languageId) {
    let val = [productId, variantId, languageId].join("_;_");
    this._createHidden(this.getForm(), "DelocalizeProduct", val);
    this.submitFormWithCommand("Delocalize", true);
}

Dynamicweb.PIM.BulkEdit.prototype.delocalizeProduct = function (productId, variantId, languageId) {
    let val = [productId, variantId, languageId].join("_;_");
    this._createHidden(this.getForm(), "DelocalizeProduct", val);
    this.submitFormWithCommand("Delocalize", true);
}

Dynamicweb.PIM.BulkEdit.prototype.chooseImageGroup = function (e, controlId) {
    this.imageCnt = e.target.closest(".image-cnt");
    this.detailId = this.imageCnt.readAttribute("data-detail-id");
    this.controlId = controlId;
    const detailGroupId = this.imageCnt.readAttribute("data-detail-group-id");
    const imageGroupPickerEl = document.getElementById("ImageGroupPicker");
    imageGroupPickerEl.value = detailGroupId;
    dialog.show("SelectImageGroupDialog");
}

Dynamicweb.PIM.BulkEdit.prototype.assignImageGroup = function () {
    const imageGroupPickerEl = document.getElementById("ImageGroupPicker");
    var storageEl = document.getElementById("ImageGroups_" + this.controlId);
    var groups = storageEl.value ? storageEl.value.split(",") : [];
    const detailGroupId = imageGroupPickerEl.value;
    var oldGroup = this.imageCnt.getAttribute("data-detail-group-id");

    this.imageCnt.writeAttribute("data-detail-group-id", detailGroupId);

    var selectedOption = imageGroupPickerEl.options[imageGroupPickerEl.selectedIndex];
    var groupName = selectedOption.getAttribute("data-detail-category-name");
    var groupIcon = selectedOption.getAttribute("data-detail-category-icon");

    this.imageCnt.writeAttribute("data-detail-category-name", groupName);
    this.imageCnt.writeAttribute("data-detail-category-icon", groupIcon);

    var imageContainer = this.imageCnt.closest(".field-container-with-border");
    var newContainerId = imageContainer.id;
    newContainerId = newContainerId.substring(0, newContainerId.lastIndexOf("_") + 1) + detailGroupId;
    var imageGroupContainer = document.getElementById(newContainerId);
    this._moveImageBlock(this.imageCnt, imageGroupContainer);

    var currentDetailId = this.detailId
    if (currentDetailId) {
        //existing detail
        groups = groups.filter(function (g) {
            return !g.startsWith(currentDetailId + ":");
        })
        groups.push(currentDetailId + ":" + detailGroupId);
        storageEl.value = groups.join(",");
    } else if (this.imageCnt.classList.contains("new-detail-image")) {
        //moving newly added detail
        var addedDetails = document.getElementById("AddedImages_Details_" + this.controlId);
        var currentImagePath = this.imageCnt.querySelector("img.image-block").getAttribute("data-image-path");

        var addedFiles = addedDetails.value ? addedDetails.value.split(":") : [];
        var index = addedFiles.indexOf(currentImagePath + "|" + oldGroup);
        if (index !== -1) {
            addedFiles.splice(index, 1);
        }
        addedDetails.value = addedFiles.concat([currentImagePath + "|" + detailGroupId]).join(":");
    }
    dialog.hide("SelectImageGroupDialog");
}

Dynamicweb.PIM.BulkEdit.prototype.initCategoryFieldsInheritanceUI = function (mainCnt) {
    const fieldRows = mainCnt.querySelectorAll(".cat-field-row");
    Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.editorsById = {};
    for (let i = 0; i < fieldRows.length; i++) {
        const row = fieldRows[i];
        let mainEditorEl = row.querySelector(".category-field.default-lang");
        const mainEditor = new Dynamicweb.PIM.BulkEdit.CategoryFieldEditor(mainEditorEl);
        mainEditor.init();
        const slaveEditors = row.querySelectorAll(".category-field:not(.default-lang)");
        for (let j = 0; j < slaveEditors.length; j++) {
            const fieldCnt = slaveEditors[j];
            const editor = new Dynamicweb.PIM.BulkEdit.CategoryFieldEditor(fieldCnt, mainEditor);
            editor.init();
            mainEditor.slaves.push(editor);
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype.initGridCategoryFieldsInheritanceUI = function () {
    const productRows = document.getElementById("productsContainer").querySelectorAll(".row:not(.header-row)");
    Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased.EditorText = Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased.LargeText;
    Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.editorsById = {};
    let mainEditors = {};
    for (let i = 0; i < productRows.length; i++) {
        const row = productRows[i];
        const productId = row.getAttribute("data-product-id");
        const productVariantId = row.getAttribute("data-variant-id");
        const productLanguageId = row.getAttribute("data-language-id");
        let editors = row.querySelectorAll(".category-field");
        for (let i = 0; i < editors.length; i++) {
            const rowEditorEl = editors[i];
            const rowEditor = new Dynamicweb.PIM.BulkEdit.CategoryFieldEditor(rowEditorEl);
            rowEditor.init();
            if (rowEditorEl.classList.contains("default-lang")) {
                if (i == 0) {
                    mainEditors[productId + productVariantId] = [];
                }
                mainEditors[productId + productVariantId].push(rowEditor);
            } else {
                const mainEditor = mainEditors[productId + productVariantId][i];
                mainEditor.slaves.push(rowEditor);
            }
        }
    }
}

Dynamicweb.PIM.BulkEdit.CategoryFieldEditor = function (fieldCnt, baseEditor) {
    const self = this;
    const editorEl = fieldCnt;
    const isMainEditor = !baseEditor;
    const mainEditor = baseEditor;
    const fieldType = editorEl.readAttribute("data-field-type");
    const fieldId = editorEl.readAttribute("data-field-id");
    const restoreToInheritedBtnEl = editorEl.querySelector(".restore-to-inherited-btn");
    const isInheritedStorageEl = document.getElementById(fieldId + "_IsInherited");
    if (fieldId) {
        Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.editorsById[fieldId] = this;
    }

    const fieldTypeBasedObj = Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased[fieldType] || Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased.Default;
    this.slaves = [];
    this.valueTrackersHandlers = [];
    Object.defineProperty(this, 'isMainEditor', {
        get: function () {
            return !mainEditor;
        }
    });

    Object.defineProperty(this, 'isInherited', {
        get: function () {
            const isInheritedValue = editorEl.readAttribute("data-category-field-is-inherited-val") === "true";
            return isInheritedValue;
        },
        set: function (val) {
            if (val === this.isInherited) {
                return;
            }
            isInheritedStorageEl.value = (!!val).toString();
            editorEl.writeAttribute("data-category-field-is-inherited-val", isInheritedStorageEl.value);
            if (val) {
                editorEl.addClassName("inherited-val");
                const editorVal = this.getParentValue();
                this.pauseValueTracking();
                this.setValue(editorVal);
                updateSlaveEditors();
                this.continueValueTracking();

            } else {
                editorEl.removeClassName("inherited-val");
            }
        }
    });

    const updateSlaveEditors = function () {
        if (self.isMainEditor) {
            const val = self.getValue();
        }
    };

    const watchEditorChanges = function (callback) {
        const trackValuechanges = function () {
            callback();
        };

        if (fieldType === "Date" || fieldType === "DateTime") {
            const obj = {
                handler: trackValuechanges,
                stop: function () {
                    this.trackChanges = false;
                },
                getValue: function () {
                    const val = Dynamicweb.UIControls.DatePicker.get_current().GetDate(fieldId) || "";
                    return val;
                },
                registerCallback: function () {
                    this.trackChanges = true;
                },
                execute: function () {
                    if (this.trackChanges) {
                        this.handler();
                    }
                }
            };

            self.valueTrackersHandlers.push(obj);
            obj.registerCallback();
        }
        else if (fieldType == "EditorText" && Dynamicweb.PIM.BulkEdit.get_current()._viewMode != gridView) {
            fieldTypeBasedObj.getElementsForValueTracking(editorEl).forEach(function (el) {
                var o = new Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.EditorObserver(el, 0.3, trackValuechanges);
                self.valueTrackersHandlers.push(o);
            });
        }
        else {
            fieldTypeBasedObj.getElementsForValueTracking(editorEl).forEach(function (el) {
                var o = new Form.Element.Observer(el, 0.3, trackValuechanges);
                self.valueTrackersHandlers.push(o);
            });
        }
    };

    self.init = function () {
        if (restoreToInheritedBtnEl) {
            restoreToInheritedBtnEl.addEventListener("click", function (e) {
                self.isInherited = true;
            });
        }
        watchEditorChanges(self.valueChanged);
    };

    self.pauseValueTracking = function () {
        this.valueTrackersHandlers.forEach(function (o) {
            o.stop();
        });
    };

    self.continueValueTracking = function () {
        this.valueTrackersHandlers.forEach(function (o) {
            o.lastValue = o.getValue();
            o.registerCallback();
        });
    };

    self.fireValueChanged = function () {
        this.valueTrackersHandlers.forEach(function (o) {
            o.execute();
        });
    };

    self.valueChanged = function () {
        self.isInherited = false;
        updateSlaveEditors();
    };

    self.getValue = function () {
        let val = fieldTypeBasedObj.getValue(editorEl);
        return val;
    };

    self.setValue = function (val) {
        fieldTypeBasedObj.setValue(editorEl, val);
    };

    self.getParentValue = function () {
        if (this.isMainEditor || mainEditor.isInherited) {
            let val = editorEl.readAttribute("data-category-field-parent-val");
            if (fieldTypeBasedObj.convertValue && val) {
                val = fieldTypeBasedObj.convertValue(editorEl, val);
            }
            return val;
        }
        return mainEditor.getValue();
    }
};

Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.EditorObserver = Class.create(Abstract.TimedObserver, {
    getValue: function () {
        return this.element.innerHTML;
    }
});

Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.dateTimePickerValueChanged = function (fieldId) {
    if (Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.editorsById) {
        const editor = Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.editorsById[fieldId];
        if (editor) {
            editor.fireValueChanged();
        }
    }
}

Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased = {
    _valueSeparator: ",",
    Default: {
        selector: "input",
        getElementsForValueTracking: function (cnt) {
            return cnt.querySelectorAll(this.selector);
        },
        getValue: function (cnt) {
            const el = cnt.querySelector(this.selector);
            return el ? el.value || "" : "";
        },
        setValue: function (cnt, val) {
            const el = cnt.querySelector(this.selector);
            if (el) {
                el.value = val;
            }
        }
    },
    Checkbox: {
        selector: "input.checkbox",
        getElementsForValueTracking: function (cnt) {
            return cnt.querySelectorAll(this.selector);
        },
        getValue: function (cnt) {
            const el = cnt.querySelector(this.selector);
            return el ? el.checked : false;
        },
        setValue: function (cnt, val) {
            const el = cnt.querySelector(this.selector);
            if (el) {
                el.checked = val;
            }
            dwGlobal.Dom.triggerEvent(el, "click"); // click to checkbox to mark it as changed
        },
        convertValue: function (cnt, val) {
            return val && val.toString().toLowerCase() === "true";
        }
    },
    List: {
        selector: ".checkbox-list input.checkbox, .radio-list input, select",
        getElementsForValueTracking: function (cnt) {
            return cnt.querySelectorAll(this.selector);
        },
        getValue: function (cnt) {
            const checkBoxList = cnt.querySelector(".checkbox-list");
            if (checkBoxList) {
                let arr = [];
                checkBoxList.querySelectorAll(this.selector).forEach(function (el) {
                    if (el.checked) {
                        arr.push(el.value);
                    }
                });
                return arr.join(Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased._valueSeparator);
            }
            const radioGroupList = cnt.querySelector(".radio-list");
            if (radioGroupList) {
                let val = "";
                radioGroupList.querySelectorAll(this.selector).forEach(function (el) {
                    if (el.checked) {
                        val = el.value;
                    }
                });
                return val;
            }
            const el = cnt.querySelector(this.selector);
            if (el) {
                let arr = [];
                el.querySelectorAll("option").forEach(function (el) {
                    if (el.selected) {
                        arr.push(el.value);
                    }
                });
                return arr.join(Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased._valueSeparator);
            }
            return "";
        },
        setValue: function (cnt, val) {
            const checkBoxList = cnt.querySelector(".checkbox-list");
            if (checkBoxList) {
                let arr = val || [];
                if (typeof val === 'string') {
                    arr = val.split(Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased._valueSeparator);
                }
                checkBoxList.querySelectorAll(this.selector).forEach(function (el) {
                    el.checked = arr.includes(el.value);
                });
            }
            const radioGroupList = cnt.querySelector(".radio-list");
            if (radioGroupList) {
                radioGroupList.querySelectorAll(this.selector).forEach(function (el) {
                    el.checked = el.value === val;
                });
            }
            const el = cnt.querySelector(this.selector);
            if (el) {
                let arr = val || [];
                if (typeof val === 'string') {
                    arr = val.split(Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased._valueSeparator);
                }
                el.querySelectorAll("option").forEach(function (el) {
                    el.selected = arr.includes(el.value);
                });
                if (el.dwSelector) {
                    el.dwSelector.select(arr);
                }
            }
        }
    },
    DateTime: {
        getElementsForValueTracking: function (cnt) {
            const fieldId = cnt.readAttribute("data-field-id");
            const escapedId = fieldId.replace(/\;|\./gi, function (x) { return "\\" + x; });
            return cnt.querySelectorAll("#" + escapedId + "_calendar,#" + escapedId + "_notSet");
        },
        getValue: function (cnt) {
            const fieldId = cnt.readAttribute("data-field-id");
            const val = Dynamicweb.UIControls.DatePicker.get_current().GetDate(fieldId) || "";
            return val;
        },
        setValue: function (cnt, val) {
            const fieldId = cnt.readAttribute("data-field-id");
            if (val) {
                Dynamicweb.UIControls.DatePicker.get_current().SetDate(fieldId, val);
                Dynamicweb.UIControls.DatePicker.get_current().UpdateCalendarDate(val, fieldId); // don't remove it
            }
            else {
                Dynamicweb.UIControls.DatePicker.get_current().SetDate(fieldId, null);
            }
        },
        convertValue: function (cnt, val) {
            let dt = null;
            if (val) {
                dt = new Date(Date.parse(val, "%Y-%m-%d %H:%M"));
                if (isNaN(dt)) {
                    dt = null;
                }
            }
            return dt;
        }
    },
    Link: {
        selector: ".link-manager-container input[type=text]",
        getElementsForValueTracking: function (cnt) {
            return cnt.querySelectorAll(this.selector);
        },
        getValue: function (cnt) {
            const el = cnt.querySelector(this.selector);
            return el ? el.value || "" : "";
        },
        setValue: function (cnt, val) {
            const el = cnt.querySelector(this.selector);
            if (el) {
                el.value = val;
                _fireEvent(el, "change");
            }
        }
    },
    EditorText: {
        selector: "span[contenteditable=true]",
        getElementsForValueTracking: function (cnt) {
            const elx = cnt.querySelectorAll(this.selector);
            return elx;
        },
        getValue: function (cnt) {
            const el = cnt.querySelector(this.selector);
            return el ? el.innerHTML || "" : "";
        },
        setValue: function (cnt, val) {
            const el = cnt.querySelector(this.selector);
            if (el) {
                el.innerHTML = val;
                const storageEl = cnt.querySelector(this.selector + "+input");
                if (storageEl) {
                    storageEl.value = val;
                    _fireEvent(storageEl, "change");
                }
            }
        }
    },
    Filemanager: {
        selector: "select",
        getElementsForValueTracking: function (cnt) {
            return cnt.querySelectorAll(this.selector);
        },
        getValue: function (cnt) {
            const el = cnt.querySelector(this.selector);
            let opt = el.querySelector("option:checked");
            if (opt) {
                return opt.readAttribute("fullpath");
            }
        },
        setValue: function (cnt, fullPath) {
            const el = cnt.querySelector(this.selector);
            if (fullPath) {
                const strFolder = cnt.readAttribute("data-root-folder");
                let rootFolder = "";
                if (strFolder) {
                    if (strFolder.substring(0, 1) != "/") {
                        rootFolder += "/"
                    }
                    rootFolder += strFolder;
                };
                let path = fullPath.substring("/Files".length);
                fileManagerStoreSelectedFile(el, rootFolder, path);
            }
            else {
                clearFileSelection(el)
            }
        },
        convertValue: function (cnt, val) {
            let path = val;
            if (path.startsWith("..")) {
                path = "/Files" + path.substring(2);
            }
            else {
                const strFolder = cnt.readAttribute("data-root-folder");
                let rootFolder = "";
                if (strFolder) {
                    if (strFolder.substring(0, 1) != "/") {
                        rootFolder += "/"
                    }
                    rootFolder += strFolder;
                };
                path = "/Files" + rootFolder + "/" + path;
            }
            return path;
        }
    }
};

Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased = dwGlobal.extendObject(Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased, {
    LargeText: dwGlobal.extendObject({}, Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased.Default, { selector: "textarea" }),
    Text: Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased.Default,
    Date: Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased.DateTime,
    Double: Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased.Default,
    Integer: Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.typesBased.Default
});

var publicationPeriodChangesInProgress = false;
Dynamicweb.PIM.BulkEdit.prototype.publicationPeriodSelectorChanged = function () {
    if (!publicationPeriodChangesInProgress) {
        publicationPeriodChangesInProgress = true;
        Dynamicweb.UIControls.DatePicker.get_current().SetDate("ProductActiveFrom", new Date(1990, 0));
        Dynamicweb.UIControls.DatePicker.get_current().SetDate("ProductActiveTo", null);
        publicationPeriodChangesInProgress = false;
    }    
}

Dynamicweb.PIM.BulkEdit.prototype.publicationPeriodActiveFromChanged = function () {
    if (!publicationPeriodChangesInProgress) {
        publicationPeriodChangesInProgress = true;
        let el = document.getElementById("ProductPeriodID");
        el.value = "";
        publicationPeriodChangesInProgress = false;
    }
}

Dynamicweb.PIM.BulkEdit.prototype.publicationPeriodActiveToChanged = function () {
    if (!publicationPeriodChangesInProgress) {
        publicationPeriodChangesInProgress = true;
        let el = document.getElementById("ProductPeriodID");
        el.value = "";
        publicationPeriodChangesInProgress = false;
    }
}

Dynamicweb.PIM.BulkEdit.prototype.ShowProductCompletenessByChannelDialog = function (products, groups) {
    let dlgAction = this.options.actions.openDialog;
    dlgAction.Url = "/Admin/Module/eCom_Catalog/dw7/PIM/AddedChannelGroupsPerProduct.aspx?groups={groups}";
    Action.OpenDialogWithPost(dlgAction, { groups }, { products });
}

function onDetailLoadError(img) {
    img.style.display = "none";
    img.previousElementSibling.style.display = "";
}

Dynamicweb.PIM.BulkEdit.prototype.selectPreset = function (presetId) {    
    this._createHidden(this._form, "preset", presetId);
    this.submitFormWithCommand('ChangePreset');
}