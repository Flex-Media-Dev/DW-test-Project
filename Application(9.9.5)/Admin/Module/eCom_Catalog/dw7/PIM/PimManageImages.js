function DefaultImagesListPage(options) {
    let dialogId = "ImageManagementDialog";
    let dialogContainer = null;
    let dragSrcEl = null;
    let dragSrcGroupId = null;
    let newRowCounter = 0;

    function executeCommand(cmd) {
        document.getElementById('cmd').value = cmd;
        form1.submit();
    }

    function getSelectedRows() {
        return Array.from(dialogContainer.querySelectorAll("tr.listRow")).filter(function (row, index, array) {
            var checkbox = row.querySelector('.checkBoxCell > input[type="checkbox"]');
            return checkbox && checkbox.checked;
        });
    }


    function updateChanges(row, categoryId, sortIndex) {
        var detailId = row.getAttribute("itemid");
        if (detailId.indexOf(this.newDetailPrefix) == 0) {
            var newDetailsHidden = row.querySelector("input[id='NewDetails']");
            if (newDetailsHidden) {
                var imagePath = newDetailsHidden.getAttribute("imagePath");
                var itemId = row.querySelector("input[type='radio'][name='DefaultDetail']").value;
                newDetailsHidden.value = '|' + imagePath + '::' + categoryId + '::' + sortIndex + "::" + itemId + "|";
            }
        } else {
            var imageGroupHidden = row.querySelector("input[id='ImageGroupChanges']");
            if (!imageGroupHidden) {
                imageGroupHidden = document.createElement("input");
                imageGroupHidden.setAttribute("type", "hidden");
                imageGroupHidden.setAttribute("id", "ImageGroupChanges");
                imageGroupHidden.setAttribute("name", "ImageGroupChanges");
                row.appendChild(imageGroupHidden);
            }
            imageGroupHidden.value = '|' + detailId + '::' + categoryId + '::' + sortIndex + '|';
        }
    }

    function initializeRowsListeners() {
        var rows = dialogContainer.querySelectorAll("tr.listRow");
        for (let i = 0; i < rows.length; i++) {
            var row = rows[i];
            bindRowListeners(row);
        }
    }

    function bindRowListeners(row) {
        bindRowDefaultImageListener(row);
        bindRowDragAndDropListeners(row);
        bindRowLinkManagerListeners(row);
    }

    function bindRowLinkManagerListeners(row) {        
        var linkManagerInput = document.getElementById("Link_" + row.id + "_linkmanager");
        if (linkManagerInput) {
            linkManagerInput.addEventListener("change", function () {
                currentPage.updateDetailImage(row, linkManagerInput.value);
            });
        }
    }

    function bindRowDefaultImageListener(row) {
        var radiobuttonLabels = row.querySelectorAll("input[type='radio'][name='DefaultDetail'] + label");
        for (let i = 0; i < radiobuttonLabels.length; i++) {
            let radiobuttonLabel = radiobuttonLabels[i];
            let radiobutton = radiobuttonLabel.previousElementSibling;
            radiobuttonLabel.onclick = function (evt) {
                evt.preventDefault();
                evt.stopPropagation();
                if (!radiobutton.disabled) {
                    let radiobutton = evt.target.previousElementSibling;
                    radiobutton.checked = !radiobutton.checked;
                    markImageDefaultChanged();
                    if (radiobutton.checked) {
                        document.getElementById("MissingDefaultImage").classList.add("hidden");
                        document.getElementById("DefaultImage").classList.remove("hidden");
                        document.getElementById("DefaultImage").src = row.querySelector("img.img-responsive").getAttribute("data-image-path");
                    } else {
                        document.getElementById("DefaultImage").classList.add("hidden");
                        document.getElementById("MissingDefaultImage").classList.remove("hidden");
                    }
                }
            }
        }
    }
    
    function markImageDefaultChanged() {
        var defaultChangedHidden = document.getElementById('ImageDefaultChanged');
        if (!defaultChangedHidden) {
            defaultChangedHidden = document.createElement("input");
            defaultChangedHidden.setAttribute("type", "hidden");
            defaultChangedHidden.setAttribute("id", "ImageDefaultChanged");
            defaultChangedHidden.setAttribute("name", "ImageDefaultChanged");
            defaultChangedHidden.setAttribute("value", true);
            form1.appendChild(defaultChangedHidden);
        }
    }

    function bindRowDragAndDropListeners(row) {
        if (!row.classList.contains("dis")) {
            row.setAttribute("draggable", "true");
            row.ondragstart = dragStart;
            row.ondragover = allowDrop;
            row.ondrop = finishDrop;
        }
    }

    function allowDrop(evt) {
        evt.preventDefault();
        var eventRow = evt.target.closest("tr.listRow");
        var listBodyId = eventRow.parentElement.id;
        var currentGroupId = listBodyId.substring(0, listBodyId.lastIndexOf("_body")).substring("ImageGroup_".length)
        evt.dataTransfer.dropEffect = eventRow && dragSrcGroupId == currentGroupId ? "move" : "none";
    }

    function dragStart(evt) {
        dragSrcEl = evt.target;
        var listBodyId = evt.target.parentElement.id;
        dragSrcGroupId = listBodyId.substring(0, listBodyId.lastIndexOf("_body")).substring("ImageGroup_".length)
        evt.dataTransfer.setData("index", Array.from(evt.target.parentElement.children).indexOf(evt.target));
    }

    function finishDrop(evt) {
        evt.preventDefault();
        var oldIndex = parseInt(evt.dataTransfer.getData("index"));
        var eventRow = evt.target.closest("tr.listRow");
        var newIndex = Array.from(eventRow.parentElement.children).indexOf(eventRow)
        if (eventRow) {
            if (oldIndex < newIndex) {
                eventRow.parentElement.insertBefore(dragSrcEl, eventRow.nextSibling);
            } else {
                eventRow.parentElement.insertBefore(dragSrcEl, eventRow);
            }
        }
        for (var i = 0; i < eventRow.parentElement.children.length; i++) {
            var row = eventRow.parentElement.children[i];
            updateChanges(row, dragSrcGroupId, i);
        }
    }

    function addListRow(api, rowText, listBody, detailValue) {
        listBody.insertAdjacentHTML('beforeend', rowText);
        let addedRow = listBody.lastElementChild;
        api.bindRowListeners(addedRow);
        if (detailValue) {
            api.updateDetailImage(addedRow, detailValue);
        }
    }

    var api = {
        initialize: function (options) {
            this.productId = options.ProductId;
            this.variantId = options.VariantId;
            this.languageId = options.LanguageId;
            this.uploadFolder = options.UploadFolder;
            this.productNumber = options.ProductNumber;
            this.imagesAllowedExtentions = options.AllowedExtentions;
            this.defaultImageExtentions = options.DefaultImageExtensions;
            this.categoryControlTypes = options.CategoryControlTypes;
            this.newDetailPrefix = options.NewDetailPrefix;
            this.detailsType = options.DetailsType;

            dialogContainer = document.querySelector(".image-groups-cnt");
            Dynamicweb.ProductImageBlocks.get_current().initialize({
                container: dialogContainer,
                imageblockSelector: ".listRow > td > .image-cnt > img"
            });
            initializeRowsListeners();
            this.bindRowListeners = bindRowListeners;
        },
        save: function (close) {
            document.getElementById('DoClose').value = !!close;
            executeCommand('save');
        },
        deleteSelected: function () {
            var rows = getSelectedRows();
            for (var i = 0; i < rows.length; i++) {
                row = rows[i];
                this.delete(row.getAttribute("id"));
            }
        },
        delete: function (detailId) {
            var row = document.getElementById(detailId);
            if (row) {
                if (!detailId.startsWith('NewDetail')) {
                    var hiddenElement = document.createElement("input");
                    hiddenElement.setAttribute("type", "hidden");
                    hiddenElement.setAttribute("name", "DeletedDetails");
                    hiddenElement.setAttribute("value", detailId);
                    form1.appendChild(hiddenElement);
                }
                row.remove();
            }
        },
        onRowSelected: function () {
            var rows = getSelectedRows();
            if (rows.length > 0) {
                Toolbar.setButtonIsDisabled('cmdAssign', false);
                Toolbar.setButtonIsDisabled('cmdDetach', false);
            }
            else {
                Toolbar.setButtonIsDisabled('cmdAssign', true);
                Toolbar.setButtonIsDisabled('cmdDetach', true);
            }
        },
        cancel: function () {
            let dlg = window.parent.dialog;
            if (dlg) {
                new window.parent.overlay('__ribbonOverlay').show();
                dlg.hide(dialogId);
                window.parent.location.reload();
            }
        },

        updateDetailImage: function (row, filePath) {
            let pathHidden = row.querySelector("input[type='hidden'][name='NewDetails']");
            if (!pathHidden) {
                let lastColumn = row.lastElementChild;
                lastColumn.insertAdjacentHTML('beforeend', '<input name="NewDetails" id="NewDetails" type="hidden" imagePath="' + filePath + '"></tr>');
                pathHidden = lastColumn.lastElementChild;
            }
            let nodes = Array.prototype.slice.call(row.parentElement.children);
            var itemId = row.querySelector("input[type='radio'][name='DefaultDetail']").value;
            pathHidden.value = '|' + filePath + '::' + row.getAttribute("imageCategoryId") + '::' + nodes.indexOf(row) + "::" + itemId + "|";
            let detailExtension = filePath.substring(Math.max(filePath.lastIndexOf("."), 0));            
            document.getElementById("DefaultDetail_" + itemId).disabled =  this.defaultImageExtentions.indexOf(detailExtension) == -1;
        },

        selectImageForProduct: function (listId, categoryId) {
            let self = this;
            let categoryControlType = self.categoryControlTypes[categoryId];
            if (categoryControlType == 0) { //filemanager
                let allowedExtensions = self.imagesAllowedExtentions[categoryId];
                if (!allowedExtensions) {
                    allowedExtensions = self.imagesAllowedExtentions["all"];
                }
                showFileLinkDialog({
                    caller: 'fileManagerImages',
                    allowedExtensions: allowedExtensions,
                    multiSelect: true,
                    uploadFolder: self.uploadFolder,
                    onSelected: function (filePaths) {
                        const promises = filePaths.map(path => {
                            return self.addNewListRow(listId, categoryId, categoryControlType, path, true);
                        }); 
                        Promise.all(promises).then((rows) => {
                            const listBody = document.querySelector('tbody[id="' + listId + '_body"]');
                            rows.sort((firstRow, secondRow) => {
                                return firstRow.detailValue.localeCompare(secondRow.detailValue);
                            });
                            rows.forEach(row => {
                                addListRow(self, row.rowText, listBody, row.detailValue);
                            });
                        });
                    },
                    searchTerm: self.productNumber
                });
            } else {
                self.addNewListRow(listId, categoryId, categoryControlType);
            }
        },

        addNewListRow: function (listId, categoryId, categoryControlType, detailValue, usePromise) {
            let self = this;
            let listBody = document.querySelector('tbody[id="' + listId + '_body"]');
            let listRows = List.getAllRows(listId);
            if (listRows.length == 0 || !listRows[0].classList.contains("listRow")) {
                listBody.innerHTML = '';
            }
            let newDetailId = this.newDetailPrefix + newRowCounter++;
            let url = "/Admin/Module/eCom_Catalog/dw7/PIM/PimManageImages.aspx?IsAjax=true&cmd=AddListRow";
            url += "&ListId=" + listId;
            url += "&categoryId=" + categoryId;
            url += "&NewDetailId=" + newDetailId;
            url += "&categoryControlType=" + categoryControlType;
            url += "&NewDetailSortIndex=" + listBody.children.length;
            if (detailValue) {
                url += "&NewDetailValue=" + detailValue;
            }

            function ajaxCall(resolve) {
                return new Ajax.Request(url, {
                    method: 'get',
                    onSuccess: function (transport) {
                        if (usePromise) {
                            resolve({ detailValue: detailValue, rowText: transport.responseText });
                        } else {
                            addListRow(self, transport.responseText, listBody, detailValue);
                        }
                    }
                })
            }           

            if (usePromise) {
                return new Promise(resolve => ajaxCall(resolve));
            } else {
                ajaxCall();
            }
        },

        changeCategory: function () {
            var categoryId = document.getElementById('ImageGroupPicker').value;
            selectedRows = getSelectedRows();
            var listId = 'ImageGroup_' + categoryId;
            var listBody = document.querySelector('tbody[id="' + listId + '_body"]');
            for (var i = 0; i < selectedRows.length; i++) {
                var row = selectedRows[i];
                updateChanges(row, categoryId, listBody.children.length);
                var checkbox = row.querySelector('.checkBoxCell > input[type="checkbox"]');
                checkbox.checked = false;
                row.classList.remove("selected");
                var listRows = List.getAllRows(listId);
                if (listRows.length == 0 || !listRows[0].classList.contains("listRow")) {
                    listBody.innerHTML = '';
                }
                this.updateSelectAllCheckbox(listId, true);
                listBody.appendChild(row);
            }

            Toolbar.setButtonIsDisabled('cmdAssign', true);
            Toolbar.setButtonIsDisabled('cmdDetach', true);
            dialog.hide("SelectImageGroupDialog");
        },

        updateSelectAllCheckbox: function (listId, hasRows) {
            var allRowsCheckbox = document.getElementById("chk_all_" + listId);
            if (hasRows) {
                allRowsCheckbox.addEventListener("click", function () { List.setAllSelected(listId, allRowsCheckbox.checked); currentPage.onRowSelected(); });
            } else {
                allRowsCheckbox.removeEventListener("click", function () { List.setAllSelected(listId, allRowsCheckbox.checked); currentPage.onRowSelected(); });
            }
            allRowsCheckbox.disabled = !hasRows;
        }
    }

    api.initialize(options);
    return api;
}

function onDetailLoadError(img) {
    img.style.display = "none";
    img.previousElementSibling.style.display = "";
}