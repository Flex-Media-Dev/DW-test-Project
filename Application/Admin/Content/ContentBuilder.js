var ContentBuilder;
(function (ContentBuilder) {
    //#region Model classes
    var Grid = /** @class */ (function () {
        function Grid(root, rowElements) {
            this.rowPlaceholders = [];
            this.gridId = root.getAttribute("data-dw-grid-id");
            this.isMissingRowDefinitions = root.hasAttribute("data-dw-grid-missing-definitions");
            if (!this.gridId) {
                // Don't try and load the grid if no grid is present
                return;
            }
            this.root = root;
            this.pageId = parseInt(root.getAttribute("data-dw-grid-page-id"));
            this.container = root.getAttribute("data-dw-grid-container");
            if (this.isMissingRowDefinitions) {
                this.createErrorContent();
                return;
            }
            this.rows = this.loadRows(rowElements, this);
            if (this.rows.length === 0) {
                // Add a single target on an empty page
                this.createNewRowTarget(1);
            }
        }
        Grid.prototype.persistNewRowAndColumnOrder = function () {
            var newOrder = this.rows.map(function (row) {
                return {
                    id: row.id,
                    columns: row.columns.map(function (col) { return col.paragraphId; })
                };
            });
            return fetch("/Admin/Content/GridRowEdit.aspx?PageID=" + this.pageId + "&cmd=sort", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    container: this.container,
                    rows: newOrder
                })
            });
        };
        ;
        Grid.prototype.createErrorContent = function () {
            var error = Helpers.elementFactory("div");
            error.innerHTML = "<strong>No row definitions found for Grid ID '" + this.gridId + "'. Verify that the Grid configuration in your Layout template is valid.</strong>";
            this.root.parentNode.appendChild(error);
        };
        Grid.prototype.loadRows = function (rowElements, grid) {
            var rows = [];
            rowElements.forEach(function (row, position) {
                var sortIndex = position + 1;
                rows.push(new GridRow(row, grid, sortIndex));
            });
            return rows;
        };
        Grid.prototype.createNewRowTarget = function (sortIndex) {
            var markup = "\n                <dw-new-gridrow data-dw-gridrow=\"0\" data-dw-grid-container=\"" + this.container + "\" data-dw-grid-id=\"" + this.gridId + "\" style=\"display: none; height: 62px; position: relative; cursor: pointer; z-index: 1\">\n                    <img src=\"/Admin/Public/plus-white-circle.svg\" class=\"js-dw-gridrow-icon\" style=\"height: 42px; width: 42px; left: calc(50% - 21px); top: calc(50% - 21px); position: absolute; z-index: " + zIndexMaxValue + "\" />\n                    <div class=\"js-dw-gridrow-line\" style=\"position: absolute; border-top: 1px dashed #a8a8a8; width: 100%; top: calc(50% - 1px);\"></div>\n                </dw-new-gridrow>\n            ";
            var newRow = Helpers.makeElement(markup);
            var gridRow = new GridRow(newRow, this, sortIndex);
            newRow.onclick = function () { return gridRow.editRow(); };
            this.root.parentNode.appendChild(newRow);
            this.rowPlaceholders.push(gridRow);
        };
        ;
        return Grid;
    }());
    var GridRow = /** @class */ (function () {
        function GridRow(rowElement, grid, sortIndex) {
            this.type = GridRow.type;
            this.element = rowElement;
            this.id = parseInt(rowElement.getAttribute("data-dw-gridrow"));
            this.isPlaceholder = rowElement.localName === "dw-new-gridrow";
            this.hasPublicationPeriod = rowElement.getAttribute("data-dw-gridrow-publication-period") === "true";
            this.hideForDesktops = rowElement.getAttribute("data-dw-gridrow-hide-desktop") === "true";
            this.hideForPhones = rowElement.getAttribute("data-dw-gridrow-hide-phone") === "true";
            this.hideForTablets = rowElement.getAttribute("data-dw-gridrow-hide-tablet") === "true";
            this.grid = grid;
            this.sortIndex = sortIndex;
            this.isMissingDefinition = rowElement.hasAttribute("data-dw-gridrow-missing-definition");
            if (!this.isMissingDefinition) {
                this.columns = GridRow.loadColumns(rowElement, this);
                if (this.isPlaceholder) {
                    this.setupPlaceholder();
                }
                else {
                    this.setupOverlay();
                }
                this.setupDragAndDrop();
            }
            else {
                var definitionId = rowElement.getAttribute("data-dw-gridrow-missing-definition");
                this.createErrorContent(definitionId);
            }
        }
        Object.defineProperty(GridRow.prototype, "hasContent", {
            get: function () {
                return this.columns.reduce(function (hasContent, currentColumn) {
                    if (hasContent)
                        return hasContent;
                    return !currentColumn.isPlaceholder;
                }, false);
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(GridRow.prototype, "rowOverlay", {
            get: function () {
                return this.overlay;
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(GridRow.prototype, "columnCount", {
            get: function () {
                return this.numberOfColumns;
            },
            enumerable: true,
            configurable: true
        });
        GridRow.prototype.editRow = function (id, position) {
            if (!id && !position) {
                id = this.id;
                position = this.sortIndex;
            }
            if (id > 0) {
                Helpers.showSpinner();
                var frame = document.getElementById("dlgEditGridRowFrame");
                frame.onload = function () {
                    Helpers.hideSpinner();
                    dialog.show("dlgEditGridRow");
                };
                frame.src = "GridRowEdit.aspx?PageId=" + this.grid.pageId + "&ID=" + id + "&SortIndex=" + position + "&Container=" + this.grid.container + "&GridId=" + this.grid.gridId + "&VisualEditor=true";
            }
            else {
                state.toolbar.showNewRow();
            }
        };
        GridRow.prototype.insertRowBefore = function () {
            this.editRow(0, this.sortIndex);
        };
        ;
        GridRow.prototype.insertRowAfter = function () {
            this.editRow(0, this.sortIndex + 1);
        };
        ;
        GridRow.prototype.saveRowAsTemplate = function () {
            Helpers.showSpinner();
            var frame = document.getElementById("dlgSaveAsTemplateFrame");
            frame.onload = function () {
                Helpers.hideSpinner();
                dialog.show("dlgSaveAsTemplate");
            };
            frame.src = "GridRowTemplateEdit.aspx?PageId=" + this.grid.pageId + "&ID=" + this.id;
        };
        ;
        GridRow.prototype.deleteRow = function () {
            var _this = this;
            if (!confirm("Are you sure you want to delete the row with id '" + this.id + "'? This will unlink all column content from the row but not delete them."))
                return;
            Helpers.showSpinner();
            var url = "GridRowEdit.aspx?PageId=" + this.grid.pageId + "&ID=" + this.id + "&cmd=delete";
            fetch(url).then(function (resp) {
                if (resp.ok) {
                    Helpers.hideSpinner();
                    Helpers.reloadEditor();
                }
            }).catch(function (reason) {
                Helpers.log("Unable to delete row", _this.id, reason);
            });
        };
        ;
        GridRow.prototype.replaceColumn = function (existingColumn, newColumn) {
            var existingIndex = this.columns.indexOf(existingColumn);
            this.columns[existingIndex] = newColumn;
            newColumn.row = this;
        };
        ;
        GridRow.prototype.createNewRow = function (definitionId, isTemplate, sortIndex) {
            Helpers.showSpinner();
            fetch("GridRowEdit.aspx?PageId=" + this.grid.pageId + "&cmd=create", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    sortIndex: sortIndex,
                    container: this.grid.container,
                    gridId: this.grid.gridId,
                    definition: definitionId,
                    isTemplate: isTemplate
                })
            }).then(function (resp) {
                if (resp.ok) {
                    return resp.text();
                }
                else {
                    return Promise.reject(resp.status + ": " + resp.statusText);
                }
            }).catch(function (reason) {
                Helpers.log("Unable to create new row", reason);
            }).finally(function () {
                Helpers.hideSpinner();
                Helpers.reloadEditor();
            });
        };
        GridRow.prototype.createErrorContent = function (definitionId) {
            var error = Helpers.elementFactory("div");
            error.innerHTML = "<strong>Row definition '" + definitionId + "' for row '" + this.id + "' not found for Grid ID '" + this.grid.gridId + "'. Verify that your RowDefinitions.json file contains the definition ID.</strong>";
            this.element.appendChild(error);
        };
        GridRow.prototype.setupPlaceholder = function () {
            var icon = this.element.querySelector("img");
            var line = this.element.querySelector("div");
            var setActive = function () {
                icon.src = "/Admin/Public/plus-circle-blue.svg";
                line.style.borderTop = "1px dashed #0084CA";
            };
            var setInactive = function () {
                icon.src = "/Admin/Public/plus-white-circle.svg";
                line.style.borderTop = '1px dashed #a8a8a8';
            };
            this.element.onmouseenter = setActive;
            this.element.onmouseleave = setInactive;
            setInactive();
            this.setPlaceholderActive = setActive;
            this.setPlaceholderInactive = setInactive;
        };
        ;
        GridRow.prototype.setupOverlay = function () {
            var overlay = new RowOverlay(this);
            this.element.appendChild(overlay.element);
            this.element.onmouseover = function () {
                if (!state.dragging.source)
                    overlay.show();
            };
            this.element.onmouseout = function () { return overlay.hide(); };
            this.overlay = overlay;
        };
        ;
        GridRow.prototype.setupDragAndDrop = function () {
            var _this = this;
            if (!this.isPlaceholder) {
                this.overlay.dragHandle.ondragstart = function (e) {
                    state.dragging.source = _this;
                    _this.overlay.element.style.opacity = '0';
                    e.dataTransfer.setDragImage(_this.element, 10, 10);
                    e.dataTransfer.effectAllowed = "move";
                };
                this.overlay.dragHandle.ondragend = function (e) {
                    e.preventDefault();
                    state.dragging.reset();
                    _this.overlay.element.style.opacity = '1';
                };
            }
            this.element.ondragenter = function (e) {
                e.preventDefault();
                var isNewRowSource = state.dragging.source.type === NewRowType.type;
                var isOtherRowSource = state.dragging.source.type === GridRow.type;
                if (isNewRowSource || isOtherRowSource) {
                    e.stopPropagation();
                    state.dragging.target = state.dragging.target || _this;
                    if (state.dragging.target !== _this) {
                        var previousRow = state.dragging.target;
                        previousRow.hideDropTarget();
                        state.dragging.target = _this;
                    }
                    if (state.dragging.source !== _this && _this.shouldShowDropTarget(e)) {
                        _this.showDropTarget(e);
                    }
                }
            };
            this.element.ondragover = function (e) {
                e.preventDefault();
                var isNewRowSource = state.dragging.source.type === NewRowType.type;
                var isOtherRowSource = state.dragging.source.type === GridRow.type;
                if (isNewRowSource || isOtherRowSource) {
                    e.stopPropagation();
                    var sourceRow = state.dragging.source;
                    if ((isNewRowSource || (isOtherRowSource && sourceRow !== _this && sourceRow.grid === _this.grid)) && _this.shouldShowDropTarget(e)) {
                        e.dataTransfer.dropEffect = "move";
                        _this.showDropTarget(e);
                    }
                    else {
                        e.dataTransfer.dropEffect = "none";
                        _this.hideDropTarget();
                    }
                }
            };
            this.element.ondragleave = function (e) {
                e.preventDefault();
                var isNewRowSource = state.dragging.source.type === NewRowType.type;
                var isOtherRowSource = state.dragging.source.type === GridRow.type;
                if (isNewRowSource || isOtherRowSource) {
                    e.stopPropagation();
                    _this.hideDropTarget();
                }
            };
            this.element.ondrop = function (e) {
                e.preventDefault();
                var isNewRowSource = state.dragging.source.type === NewRowType.type;
                var isOtherRowSource = state.dragging.source.type === GridRow.type;
                if (isNewRowSource || isOtherRowSource) {
                    e.stopPropagation();
                    var dropPosition = _this.getDropPosition(e);
                    if (isNewRowSource) {
                        var newRowType = state.dragging.source;
                        var sortIndex = _this.sortIndex + (dropPosition === "above" ? 0 : 1);
                        _this.createNewRow(newRowType.definitionId, newRowType.isTemplate, sortIndex);
                    }
                    else if (isOtherRowSource) {
                        Helpers.showSpinner();
                        var draggedRow = state.dragging.source;
                        var sourceIndex = _this.grid.rows.indexOf(draggedRow);
                        var targetIndex = _this.grid.rows.indexOf(_this);
                        if (sourceIndex > targetIndex) {
                            targetIndex += dropPosition === "above" ? 0 : 1;
                        }
                        else {
                            targetIndex += dropPosition === "above" ? -1 : 0;
                        }
                        Helpers.reorderItems(_this.grid.rows, sourceIndex, targetIndex);
                        _this.grid.persistNewRowAndColumnOrder().then(function (resp) {
                            if (resp.ok) {
                                Helpers.reloadEditor();
                                Helpers.hideSpinner();
                            }
                            else {
                                return Promise.reject("Unable to save new row order. Reason: " + resp.status + " - " + resp.statusText);
                            }
                        }).catch(function (reason) {
                            Helpers.error(reason);
                            Helpers.reloadEditor();
                            Helpers.hideSpinner();
                        });
                    }
                }
            };
        };
        ;
        GridRow.prototype.shouldShowDropTarget = function (e) {
            var sourceRow = state.dragging.source;
            var dropPosition = this.getDropPosition(e);
            var indexOfSource = this.grid.rows.indexOf(sourceRow);
            var indexOfThis = this.grid.rows.indexOf(this);
            var showDropTarget = indexOfSource === -1 ||
                (!(indexOfThis === indexOfSource - 1 && dropPosition === "below") &&
                    !(indexOfThis === indexOfSource + 1 && dropPosition === "above"));
            return showDropTarget;
        };
        GridRow.prototype.showDropTarget = function (e) {
            if (this.isPlaceholder) {
                this.setPlaceholderActive();
            }
            else {
                var position = this.getDropPosition(e);
                this.overlay.showDropTarget(position);
            }
        };
        GridRow.prototype.hideDropTarget = function () {
            if (this.isPlaceholder) {
                this.setPlaceholderInactive();
            }
            else {
                this.overlay.clearDropTarget();
            }
        };
        GridRow.prototype.getDropPosition = function (e) {
            var rect = this.element.getBoundingClientRect();
            var limit = Math.min(rect.height / 2, 150);
            var distanceTop = Math.abs(rect.top - e.clientY);
            var dropTop = distanceTop < limit;
            return dropTop ? "above" : "below";
        };
        GridRow.loadColumns = function (rowElement, row) {
            var gridColumns = Array.from(rowElement.querySelectorAll(".dw-gridcolumn"));
            row.numberOfColumns = gridColumns.length;
            var columns = [];
            gridColumns.forEach(function (column) {
                var col = new GridColumn(column, row);
                columns.push(col);
            });
            return columns;
        };
        ;
        GridRow.type = "GridRow";
        return GridRow;
    }());
    var GridColumn = /** @class */ (function () {
        function GridColumn(columnElement, row) {
            this.type = GridColumn.type;
            this.element = columnElement;
            this.row = row;
            this.trigger = this.getTriggerAncestor();
            this.isPlaceholder = columnElement.localName === 'dw-placeholder';
            this.paragraphId = this.isPlaceholder ? '0' : columnElement.getAttribute("data-dw-gridcolumn-paragraph");
            this.paragraphName = this.isPlaceholder ? '' : columnElement.getAttribute("data-dw-gridcolumn-name");
            this.columnPosition = parseInt(columnElement.getAttribute("data-dw-gridcolumn-position"));
            if (this.isPlaceholder) {
                this.setPlaceholder();
            }
            this.setupOverlay();
            this.setupDragAndDrop();
        }
        Object.defineProperty(GridColumn.prototype, "columnOverlay", {
            get: function () {
                return this.overlay;
            },
            enumerable: true,
            configurable: true
        });
        GridColumn.prototype.editColumn = function () {
            var _this = this;
            if (!this.isPlaceholder) {
                Helpers.showSpinner();
                var frame_1 = document.getElementById('dlgEditParagraphFrame');
                frame_1.onload = function () {
                    var doc = frame_1.contentWindow.document;
                    var hasModuleButton = doc.getElementById('cmdViewModule');
                    document.getElementById('Toolbar').style.display = hasModuleButton ? 'block' : 'none';
                    var dialogTitle = Helpers.getTranslation("Edit") + " " + _this.paragraphName;
                    dialog.setTitle("dlgEditParagraph", dialogTitle);
                    dialog.show("dlgEditParagraph");
                    Helpers.hideSpinner();
                };
                frame_1.src = "ParagraphEdit.aspx?ID=" + this.paragraphId + "&PageId=" + this.row.grid.pageId + "&Row=" + this.row.id + "&Column=" + this.columnPosition + "&VisualEditor=true";
            }
            else {
                state.toolbar.showNewColumn();
            }
        };
        ;
        GridColumn.prototype.saveColumnAsTemplate = function () {
            Helpers.showSpinner();
            var frame = document.getElementById("dlgSaveColumnAsTemplateFrame");
            frame.onload = function () {
                Helpers.hideSpinner();
                dialog.show("dlgSaveColumnAsTemplate");
            };
            frame.src = "GridColumnTemplateEdit.aspx?ID=" + this.paragraphId;
        };
        ;
        GridColumn.prototype.deleteColumn = function () {
            var _this = this;
            if (!confirm("Are you sure you want to delete the column/paragraph with name: '" + this.paragraphName + "' and ID: '" + this.paragraphId + "'?"))
                return;
            Helpers.showSpinner();
            var url = "/Admin/Content/Paragraph/Paragraph_Delete.aspx?mode=viewparagraphs&ID=" + this.paragraphId + "&PageID=" + this.row.grid.pageId;
            fetch(url).then(function (resp) {
                if (resp.ok) {
                    Helpers.reloadEditor();
                }
                Helpers.hideSpinner();
            }).catch(function (reason) {
                Helpers.log("Unable to delete paragraph", _this.paragraphId, reason);
            });
        };
        ;
        GridColumn.prototype.linkContent = function () {
            var _this = this;
            Helpers.showSpinner();
            var url = "ContentBuilder.aspx?cmd=ListParagraphs&ID=" + this.row.grid.pageId;
            fetch(url).then(function (resp) {
                if (resp.ok) {
                    return resp.json();
                }
                else {
                    Helpers.log("Unable to load paragraphs", resp.status, resp.statusText);
                }
            }).then(function (paragraphs) {
                var existingParagraphContainer = document.querySelector(".link-paragraph-container");
                while (existingParagraphContainer.firstChild) {
                    existingParagraphContainer.removeChild(existingParagraphContainer.firstChild);
                }
                if (paragraphs.length > 0) {
                    var fragment = document.createDocumentFragment();
                    var _loop_1 = function (paragraph) {
                        var markup = "\n                            <div data-paragraph-id=\"" + paragraph.Id + "\" class=\"paragraph-type\">\n                                <span class=\"large-icon\">" + paragraph.Icon + "</span>\n                                <div>" + paragraph.Name + "</div>\n                                <div class=\"description\">\n                                    <small>" + paragraph.Timestamp + "</small>\n                                </div>\n                            </div>\n                        ";
                        var paragraphElement = Helpers.makeElement(markup);
                        paragraphElement.onclick = function () {
                            dialog.hide("dlgLinkParagraph");
                            Helpers.showSpinner();
                            var url = "ContentBuilder.aspx?cmd=LinkParagraph&ParagraphId=" + paragraph.Id + "&RowId=" + _this.row.id + "&position=" + _this.columnPosition;
                            fetch(url).then(function (resp) {
                                if (resp.ok) {
                                    Helpers.reloadEditor();
                                }
                                else {
                                    Helpers.log("Unable to link paragraph to row", resp.status, resp.statusText);
                                }
                            })
                                .catch(function (reason) { return Helpers.log("Unable to link paragraph to row", reason); })
                                .finally(function () { return Helpers.hideSpinner(); });
                        };
                        fragment.appendChild(paragraphElement);
                    };
                    for (var _i = 0, paragraphs_1 = paragraphs; _i < paragraphs_1.length; _i++) {
                        var paragraph = paragraphs_1[_i];
                        _loop_1(paragraph);
                    }
                    existingParagraphContainer.appendChild(fragment);
                }
                else {
                    var noParagraphsElement = Helpers.makeElement("<div class=\"description\">" + Helpers.getTranslation("No paragraps available") + "</div>");
                    existingParagraphContainer.appendChild(noParagraphsElement);
                }
                dialog.show("dlgLinkParagraph");
                Helpers.hideSpinner();
            }).catch(function (reason) { return Helpers.log("Unable to load paragraphs", reason); });
        };
        GridColumn.prototype.unlinkContent = function () {
            if (!confirm("Are you sure you want to unlink the paragraph with name: '" + this.paragraphName + "' and ID: '" + this.paragraphId + "'?")) {
                return;
            }
            Helpers.showSpinner();
            var url = "ContentBuilder.aspx?cmd=UnlinkParagraph&ParagraphID=" + this.paragraphId;
            fetch(url).then(function (resp) {
                if (resp.ok) {
                    Helpers.reloadEditor();
                }
                else {
                    Helpers.log("Unable to unlink paragraph", resp.status, resp.statusText);
                }
            })
                .catch(function (reason) { return Helpers.log("Unable to unlink paragraph", reason); })
                .finally(function () { return Helpers.hideSpinner(); });
        };
        GridColumn.prototype.getTriggerAncestor = function () {
            var _this = this;
            var siblings = Array.from(this.element.parentElement.children).filter(function (n) { return n !== _this.element; });
            var columnSiblings = siblings.filter(function (n) { return n.classList.contains("dw-gridcolumn"); });
            var shouldStartWithParent = siblings.length > 0 && columnSiblings.length === 0;
            var candidate = shouldStartWithParent ? this.element.parentElement : this.element;
            while (candidate.parentElement.children.length === 1 && candidate.parentElement !== this.row.element) {
                candidate = candidate.parentElement;
            }
            return candidate;
        };
        GridColumn.prototype.setPlaceholder = function () {
            this.element.style.minHeight = '60px';
            this.element.style.height = '100%';
            this.element.style.width = '100%';
            this.element.style.display = 'inline-block';
            this.element.style.backgroundColor = 'rgba(256, 256, 256, 0.3)';
            this.element.style.boxSizing = "border-box";
            this.element.style.border = "1px dashed #bdbdbd";
            this.element.style.position = "relative";
            this.element.title = Helpers.getTranslation("Drop column here");
            var columnPlaceholderIcon = Helpers.elementFactory("img");
            columnPlaceholderIcon.style.width = "42px";
            columnPlaceholderIcon.style.height = "42px";
            columnPlaceholderIcon.style.left = 'calc(50% - 21px)';
            columnPlaceholderIcon.style.top = 'calc(50% - 21px)';
            columnPlaceholderIcon.style.position = "absolute";
            columnPlaceholderIcon.src = "/Admin/Public/plus.svg";
            this.element.appendChild(columnPlaceholderIcon);
        };
        GridColumn.prototype.setupOverlay = function () {
            var _this = this;
            var overlay = new ColumnOverlay(this);
            this.overlay = overlay;
            this.trigger.onmouseover = function () {
                if (!state.dragging.source) {
                    if (_this.isPlaceholder)
                        _this.element.style.border = "";
                    overlay.show();
                }
            };
            this.trigger.onmouseout = function () {
                if (_this.isPlaceholder)
                    _this.element.style.border = "1px dashed #bdbdbd";
                overlay.hide();
            };
        };
        GridColumn.prototype.setupDragAndDrop = function () {
            var _this = this;
            var referenceCounter = 0; //https://stackoverflow.com/questions/7110353/html5-dragleave-fired-when-hovering-a-child-element
            if (!this.isPlaceholder) {
                this.overlay.dragHandle.draggable = true;
                this.overlay.dragHandle.ondragstart = function (e) {
                    state.dragging.source = _this;
                    _this.row.rowOverlay.hide();
                    _this.overlay.element.style.opacity = '0';
                    e.dataTransfer.setDragImage(_this.element, 10, 10);
                    e.dataTransfer.effectAllowed = "move";
                };
                this.overlay.dragHandle.ondragend = function (e) {
                    e.preventDefault();
                    var previousColumn = state.dragging.target;
                    if (previousColumn && previousColumn.columnOverlay)
                        previousColumn.columnOverlay.clearDropTarget();
                    _this.overlay.element.style.opacity = '1';
                    state.dragging.reset();
                };
            }
            this.trigger.ondragenter = function (e) {
                e.preventDefault();
                var isNewColumnSource = state.dragging.source.type === NewColumnType.type;
                var isOtherColumnSource = state.dragging.source.type === GridColumn.type;
                if (isNewColumnSource || isOtherColumnSource) {
                    e.stopPropagation();
                    referenceCounter++;
                    state.dragging.target = state.dragging.target || _this;
                    if (state.dragging.target !== _this) {
                        var previousColumn = state.dragging.target;
                        previousColumn.hideDropTarget();
                        state.dragging.target = _this;
                    }
                    if (isNewColumnSource && _this.isPlaceholder) {
                        if (_this.shouldShowDropTarget(e))
                            _this.showDropTarget(e, true);
                    }
                    else if (isOtherColumnSource && state.dragging.source !== _this) {
                        var draggedColumn = state.dragging.source;
                        var isSameRow = draggedColumn.row === _this.row;
                        if ((isSameRow || _this.isPlaceholder) && _this.shouldShowDropTarget(e)) {
                            _this.showDropTarget(e, !isSameRow && _this.isPlaceholder);
                        }
                    }
                }
            };
            this.trigger.ondragover = function (e) {
                e.preventDefault();
                var isNewColumnSource = state.dragging.source.type === NewColumnType.type;
                var isOtherColumnSource = state.dragging.source.type === GridColumn.type;
                if (isNewColumnSource || isOtherColumnSource) {
                    e.stopPropagation();
                    var activate = false;
                    var shouldReplace = false;
                    if (isNewColumnSource && _this.isPlaceholder) {
                        activate = true;
                        shouldReplace = true;
                    }
                    else if (isOtherColumnSource && state.dragging.source !== _this) {
                        var draggedColumn = state.dragging.source;
                        var isSameRow = draggedColumn.row === _this.row;
                        activate = isSameRow || _this.isPlaceholder;
                        shouldReplace = !isSameRow && _this.isPlaceholder;
                    }
                    if (activate && _this.shouldShowDropTarget(e)) {
                        e.dataTransfer.dropEffect = "move";
                        _this.showDropTarget(e, shouldReplace);
                    }
                    else {
                        e.dataTransfer.dropEffect = "none";
                    }
                }
            };
            this.trigger.ondragleave = function (e) {
                e.preventDefault();
                var isNewColumnSource = state.dragging.source.type === NewColumnType.type;
                var isOtherColumnSource = state.dragging.source.type === GridColumn.type;
                if (isNewColumnSource || isOtherColumnSource) {
                    e.stopPropagation();
                    referenceCounter--;
                    if (referenceCounter === 0) {
                        _this.hideDropTarget();
                    }
                }
            };
            this.trigger.ondrop = function (e) {
                e.preventDefault();
                var isNewColumnSource = state.dragging.source.type === NewColumnType.type;
                var isOtherColumnSource = state.dragging.source.type === GridColumn.type;
                if (isNewColumnSource || isOtherColumnSource) {
                    e.stopPropagation();
                    if (isNewColumnSource) {
                        Helpers.showSpinner();
                        var newColumnType_1 = state.dragging.source;
                        var frame_2 = document.getElementById('dlgEditParagraphFrame');
                        frame_2.onload = function () {
                            var frameWindow = frame_2.contentWindow;
                            newColumnType_1.createColumn(frameWindow);
                            frame_2.onload = function () { };
                            Helpers.hideSpinner();
                            if (newColumnType_1.creationType === "template") {
                                Helpers.reloadEditor();
                            }
                            else {
                                dialog.get_cancelButton('dlgEditParagraph').style.display = "none";
                                dialog.show('dlgEditParagraph');
                            }
                        };
                        frame_2.src = "ParagraphEdit.aspx?ID=" + _this.paragraphId + "&PageId=" + _this.row.grid.pageId + "&Row=" + _this.row.id + "&Column=" + _this.columnPosition + "&VisualEditor=true";
                    }
                    else {
                        var draggedColumn = state.dragging.source;
                        var isSameRow = draggedColumn.row === _this.row;
                        var source = state.dragging.source;
                        var target = state.dragging.target;
                        if (isSameRow) {
                            var row = source.row;
                            var dropPosition = _this.getDropPosition(e);
                            var sourceIndex = row.columns.indexOf(source);
                            var targetIndex = row.columns.indexOf(target);
                            if (sourceIndex > targetIndex) {
                                targetIndex += dropPosition === "left" ? 0 : 1;
                            }
                            else {
                                targetIndex += dropPosition === "left" ? -1 : 0;
                            }
                            Helpers.reorderItems(row.columns, sourceIndex, targetIndex);
                        }
                        else {
                            var sourceRow = source.row;
                            var targetRow = target.row;
                            sourceRow.replaceColumn(source, target);
                            targetRow.replaceColumn(target, source);
                        }
                        _this.row.grid.persistNewRowAndColumnOrder()
                            .then(function (resp) {
                            if (resp.ok)
                                Helpers.reloadEditor();
                            else
                                return Promise.reject("Unable to save new column order. Reason: " + resp.status + " - " + resp.statusText + ". Undoing changes...");
                        })
                            .catch(function (reason) { return Helpers.error(reason); })
                            .finally(function () { return Helpers.hideSpinner(); });
                    }
                }
            };
        };
        GridColumn.prototype.shouldShowDropTarget = function (e) {
            var sourceColumn = state.dragging.source;
            var indexOfSource = this.row.columns.indexOf(sourceColumn);
            var indexOfThis = this.row.columns.indexOf(this);
            var dropPosition = this.getDropPosition(e);
            var showDropTarget = !(indexOfThis === indexOfSource - 1 && dropPosition === "right") &&
                !(indexOfThis === indexOfSource + 1 && dropPosition === "left");
            return showDropTarget;
        };
        GridColumn.prototype.showDropTarget = function (e, shouldReplace) {
            var position = "replace";
            if (!shouldReplace) {
                position = this.getDropPosition(e);
            }
            this.overlay.showDropTarget(position);
        };
        GridColumn.prototype.hideDropTarget = function () {
            this.overlay.clearDropTarget();
        };
        GridColumn.prototype.getDropPosition = function (e) {
            var rect = this.element.getBoundingClientRect();
            var limit = Math.min(rect.width / 2, 150);
            var distanceLeft = Math.abs(rect.left - e.clientX);
            var dropLeft = distanceLeft < limit;
            return dropLeft ? "left" : "right";
        };
        GridColumn.type = "GridColumn";
        return GridColumn;
    }());
    var RowOverlay = /** @class */ (function () {
        function RowOverlay(row) {
            this.row = row;
            var dragHandle = this.createDragHandle();
            var toolbar = this.createRowToolbar(dragHandle);
            var element = this.createOverlay(toolbar);
            this.dragHandle = dragHandle;
            this.toolbar = toolbar;
            this.element = element;
        }
        RowOverlay.prototype.show = function () {
            this.setDimensions();
            this.element.style.display = "block";
        };
        ;
        RowOverlay.prototype.hide = function () {
            this.element.style.display = "none";
        };
        ;
        RowOverlay.prototype.showDropTarget = function (position) {
            this.toolbar.style.display = "none";
            this.element.style.border = "";
            if (position === "above") {
                this.element.style.borderTop = "2px solid #0084ca";
            }
            else {
                this.element.style.borderBottom = "2px solid #0084ca";
            }
            this.show();
        };
        ;
        RowOverlay.prototype.clearDropTarget = function () {
            this.toolbar.style.display = "block";
            this.element.style.borderTop = "";
            this.element.style.borderBottom = "";
            this.element.style.border = "2px solid #0084CA";
            this.hide();
        };
        ;
        RowOverlay.prototype.setDimensions = function () {
            var _a = this.row.element.getBoundingClientRect(), top = _a.top, height = _a.height, width = _a.width;
            var position = state.contentFrame.contentWindow.getComputedStyle(this.row.element).position;
            if (position !== "relative") {
                this.element.style.top = this.row.element.offsetTop + "px";
                this.element.style.left = this.row.element.offsetLeft + "px";
                this.element.style.width = width + "px";
                this.element.style.height = height + "px";
                top = this.row.element.offsetTop;
            }
            this.toolbar.style.top = 0 <= top && top < 38 ? "0px" : "-38px";
        };
        RowOverlay.prototype.createDragHandle = function () {
            var dragHandleTitle = Helpers.getTranslation("Drag this");
            var dragHandle = Helpers.createButton("<img src='/Admin/Public/Dragger.svg' style='height: 28px; width: 28px; display: table;'>", dragHandleTitle, function () { });
            dragHandle.style.cursor = 'grab';
            return dragHandle;
        };
        ;
        RowOverlay.prototype.createRowToolbar = function (dragHandle) {
            var _this = this;
            var buttonsCount = 2;
            var toolbar = Helpers.elementFactory("dw-row-toolbar");
            toolbar.style.display = 'block';
            toolbar.style.zIndex = "" + (zIndexMaxValue - 1); // Max value (minus 1) for z-index in modern browsers - to make sure the overlay floats to the top.
            toolbar.style.height = '40px';
            toolbar.style.position = 'absolute';
            toolbar.style.top = '-38px';
            toolbar.style.pointerEvents = 'auto';
            if (dragHandle && !state.isMobile) {
                toolbar.appendChild(dragHandle);
                buttonsCount++;
            }
            var editRowButtonTitle = Helpers.getTranslation("Edit row");
            var editRowButton = Helpers.createButton("<img src='/Admin/Public/pen.svg' style='height: 28px; width: 22px; display: table'>", editRowButtonTitle, function () { return _this.row.editRow(); });
            toolbar.appendChild(editRowButton);
            if (this.row.hasPublicationPeriod) {
                var publicationIconTitle = Helpers.getTranslation("Publication period");
                var publicationIcon = Helpers.createToolbarIcon("<div style='height: 28px; width: 12px'><img src='/Admin/Public/PublicationPeriod.svg' style='position: relative;top: 50%;transform: translateY(-50%);display: table;max-width: 100%;'></div>", publicationIconTitle);
                toolbar.appendChild(publicationIcon);
            }
            if (this.row.hideForDesktops) {
                var hideForDesktopsIconTitle = Helpers.getTranslation("Hidden for desktops");
                var hideForDesktopsIcon = Helpers.createToolbarIcon("<div style='height: 28px; width: 12px'><img src='/Admin/Public/HideDesktop.svg' style='position: relative;top: 50%;transform: translateY(-50%);display: table;max-width: 100%;'></div>", hideForDesktopsIconTitle);
                toolbar.appendChild(hideForDesktopsIcon);
            }
            if (this.row.hideForPhones) {
                var hideForPhonesIconTitle = Helpers.getTranslation("Hidden for phones");
                var hideForPhonesIcon = Helpers.createToolbarIcon("<div style='height: 28px; width: 12px'><img src='/Admin/Public/HideMobile.svg' style='position: relative;top: 50%;transform: translateY(-50%);display: table;max-width: 100%;'></div>", hideForPhonesIconTitle);
                toolbar.appendChild(hideForPhonesIcon);
            }
            if (this.row.hideForTablets) {
                var hideForTabletsIconTitle = Helpers.getTranslation("Hidden for tablets");
                var hideForTabletsIcon = Helpers.createToolbarIcon("<div style='height: 28px; width: 12px'><img src='/Admin/Public/HideTablet.svg' style='position: relative;top: 50%;transform: translateY(-50%);display: table;max-width: 100%;'></div>", hideForTabletsIconTitle);
                toolbar.appendChild(hideForTabletsIcon);
            }
            if (this.row.hasContent && state.isAdmin && !state.isMobile) {
                var saveTemplateRowTitle = Helpers.getTranslation("Save row as template");
                var saveTemplateRowButton = Helpers.createButton("<img src='/Admin/Public/file-download.svg' style='height: 28px; width: 22px; display: table'>", saveTemplateRowTitle, function () { return _this.row.saveRowAsTemplate(); });
                toolbar.appendChild(saveTemplateRowButton);
                buttonsCount++;
            }
            var deleteRowButtonTitle = Helpers.getTranslation("Delete row");
            var deleteRowButton = Helpers.createButton("<img src='/Admin/Public/trash-alt.svg' style='height: 28px; width: 28px; display: table'>", deleteRowButtonTitle, function () { return _this.row.deleteRow(); });
            toolbar.appendChild(deleteRowButton);
            toolbar.style.left = 'calc(50% - ' + (buttonsCount * 36) / 2 + 'px)';
            return toolbar;
        };
        ;
        RowOverlay.prototype.createOverlay = function (toolbar) {
            var overlay = Helpers.elementFactory("dw-row-overlay");
            overlay.style.border = "2px solid #0084CA";
            overlay.style.boxSizing = "border-box";
            overlay.style.display = 'none';
            overlay.style.position = 'absolute';
            overlay.style.pointerEvents = "none";
            overlay.style.width = "100%";
            overlay.style.height = "100%";
            overlay.style.zIndex = "" + (zIndexMaxValue - 2); // Max value (minus 2) for z-index in modern browsers - to make sure the overlay floats to the top.
            overlay.draggable = false;
            if (toolbar) {
                overlay.appendChild(toolbar);
            }
            return overlay;
        };
        ;
        return RowOverlay;
    }());
    var ColumnOverlay = /** @class */ (function () {
        function ColumnOverlay(column) {
            this.column = column;
            var dragHandle = this.column.isPlaceholder ? null : this.createDragHandle();
            var toolbar = this.createColumnToolbar(dragHandle);
            var element = this.createOverlay(toolbar);
            this.dragHandle = dragHandle;
            this.toolbar = toolbar;
            this.element = element;
            state.contentFrame.contentWindow.document.body.appendChild(element);
            this.createDropTargets();
        }
        ColumnOverlay.prototype.show = function () {
            this.setDimensions();
            this.element.style.display = "block";
        };
        ;
        ColumnOverlay.prototype.hide = function () {
            this.element.style.display = "none";
        };
        ;
        ColumnOverlay.prototype.showDropTarget = function (position) {
            this.leftDropMarker.style.display = "none";
            this.rightDropMarker.style.display = "none";
            this.setDimensions();
            if (position === "replace") {
                this.toolbar.style.display = "none";
                this.show();
            }
            else if (position === "left") {
                this.leftDropMarker.style.display = "block";
            }
            else {
                this.rightDropMarker.style.display = "block";
            }
        };
        ;
        ColumnOverlay.prototype.clearDropTarget = function () {
            this.toolbar.style.display = "block";
            this.leftDropMarker.style.display = "none";
            this.rightDropMarker.style.display = "none";
            this.hide();
        };
        ColumnOverlay.prototype.setDimensions = function () {
            var _a = state.contentFrame.contentWindow, pageXOffset = _a.pageXOffset, pageYOffset = _a.pageYOffset;
            var box = (this.column.isPlaceholder ? this.column.element : this.column.trigger).getBoundingClientRect();
            var left = box.left + pageXOffset;
            var margin = this.column.isPlaceholder || box.height < 80 ? 0 : 8;
            this.element.style.top = box.top + pageYOffset + margin + "px";
            this.element.style.left = left + margin + "px";
            this.element.style.height = box.height - margin * 2 + "px";
            this.element.style.width = box.width - margin * 2 + "px";
            var rowBox = this.column.row.element.getBoundingClientRect();
            var _b = [rowBox.top + pageYOffset, rowBox.height], top = _b[0], height = _b[1];
            this.leftDropMarker.style.top = top + "px";
            this.leftDropMarker.style.left = left + "px";
            this.leftDropMarker.style.height = height + "px";
            this.rightDropMarker.style.top = top + "px";
            this.rightDropMarker.style.left = left + box.width - 1 + "px";
            this.rightDropMarker.style.height = height + "px";
        };
        ColumnOverlay.prototype.createDragHandle = function () {
            var dragHandleTitle = Helpers.getTranslation("Drag this");
            var dragHandle = Helpers.createButton("<img src='/Admin/Public/Dragger.svg' style='height: 28px; width: 28px'>", dragHandleTitle, function () { });
            dragHandle.style.cursor = 'grab';
            return dragHandle;
        };
        ;
        ColumnOverlay.prototype.createColumnToolbar = function (dragHandle) {
            var _this = this;
            var toolbar = Helpers.elementFactory("dw-column-toolbar");
            toolbar.style.display = 'block';
            toolbar.style.zIndex = "" + (zIndexMaxValue - 1); // Max value (minus 1) for z-index in modern browsers - to make sure the overlay floats to the top.
            toolbar.style.height = '40px';
            toolbar.style.position = 'absolute';
            toolbar.style.top = '-2px';
            toolbar.style.right = '-2px';
            toolbar.style.pointerEvents = 'auto';
            if (this.column.isPlaceholder) {
                if (state.isAdmin && !state.isMobile) {
                    var linkColumnButtonTitle = Helpers.getTranslation("Link paragraph");
                    var linkColumnButton = Helpers.createButton("<img src='/Admin/Public/link.svg' style='height: 28px; width: 22px'>", linkColumnButtonTitle, function () { return _this.column.linkContent(); });
                    toolbar.appendChild(linkColumnButton);
                }
            }
            else {
                if (dragHandle && !state.isMobile) {
                    toolbar.appendChild(dragHandle);
                }
                var editColumnButtonTitle = Helpers.getTranslation("Edit column");
                var editColumnButton = Helpers.createButton("<img src='/Admin/Public/pen.svg' style='height: 28px; width: 22px'>", editColumnButtonTitle, function () { return _this.column.editColumn(); });
                toolbar.appendChild(editColumnButton);
                if (state.isAdmin && !state.isMobile) {
                    var saveTemplateColumnTitle = Helpers.getTranslation("Save column as template");
                    var saveTemplateColumnButton = Helpers.createButton("<img src='/Admin/Public/file-download.svg' style='height: 28px; width: 22px'>", saveTemplateColumnTitle, function () { return _this.column.saveColumnAsTemplate(); });
                    toolbar.appendChild(saveTemplateColumnButton);
                    var linkColumnButtonTitle = Helpers.getTranslation("Unlink paragraph");
                    var linkColumnButton = Helpers.createButton("<img src='/Admin/Public/unlink.svg' style='height: 28px; width: 22px'>", linkColumnButtonTitle, function () { return _this.column.unlinkContent(); });
                    toolbar.appendChild(linkColumnButton);
                }
                var deleteColumnTitle = Helpers.getTranslation("Delete column");
                var deleteColumnButton = Helpers.createButton("<img src='/Admin/Public/trash-alt.svg' style='height: 28px; width: 28px'>", deleteColumnTitle, function () { return _this.column.deleteColumn(); });
                toolbar.appendChild(deleteColumnButton);
            }
            toolbar.onmouseover = function () {
                _this.show();
                _this.column.row.rowOverlay.show();
            };
            toolbar.onmouseout = function () {
                _this.hide();
                _this.column.row.rowOverlay.hide();
            };
            return toolbar;
        };
        ;
        ColumnOverlay.prototype.createOverlay = function (toolbar) {
            var overlay = Helpers.elementFactory("dw-column-overlay");
            overlay.style.border = '1px dashed #0084CA';
            overlay.style.backgroundColor = "rgba(0, 133, 202, 0.12)";
            overlay.style.display = 'none';
            overlay.style.position = 'absolute';
            overlay.style.pointerEvents = 'none';
            overlay.style.zIndex = "" + (zIndexMaxValue - 2); // Max value (minus 2) for z-index in modern browsers - to make sure the overlay floats to the top.
            if (toolbar) {
                overlay.appendChild(toolbar);
            }
            return overlay;
        };
        ;
        ColumnOverlay.prototype.createDropTargets = function () {
            var leftMarker = Helpers.elementFactory("dw-overlay-dropmarker");
            leftMarker.style.display = "none";
            leftMarker.style.position = "absolute";
            leftMarker.style.borderLeft = "2px solid #0084CA";
            this.leftDropMarker = leftMarker;
            state.contentFrame.contentWindow.document.body.appendChild(leftMarker);
            var rightMarker = leftMarker.cloneNode(true);
            this.rightDropMarker = rightMarker;
            state.contentFrame.contentWindow.document.body.appendChild(rightMarker);
        };
        return ColumnOverlay;
    }());
    var ContentBuilderToolbar = /** @class */ (function () {
        function ContentBuilderToolbar(root, pageId) {
            this.root = root;
            this.pageId = pageId;
            this.panels = {
                newRow: root.querySelector(".toolbar-new-row"),
                newColumn: root.querySelector(".toolbar-new-column")
            };
            this.panelTabs = {
                newRow: root.querySelector(".toolbar-tab-rows"),
                newColumn: root.querySelector(".toolbar-tab-columns"),
            };
            this.setupSearch();
            var rowsSelected = this.panelTabs.newRow.classList.contains("selected");
            var columnsSelected = this.panelTabs.newColumn.classList.contains("selected");
            this.currentPanel = rowsSelected || columnsSelected ? (rowsSelected ? "newRow" : "newColumn") : "newRow";
            this.reload();
        }
        ContentBuilderToolbar.prototype.setSearchValue = function (value) {
            this.searchValue = value;
            this.searchInput.value = value;
        };
        ContentBuilderToolbar.prototype.showNewRow = function () {
            this.showPanel("newRow");
        };
        ContentBuilderToolbar.prototype.showNewColumn = function () {
            this.showPanel("newColumn");
        };
        ContentBuilderToolbar.prototype.reload = function () {
            var _this = this;
            this.clearToolbar();
            this.rows = [];
            this.columns = [];
            var rows = this.loadRows();
            var columns = this.loadColumns();
            Promise.all([rows, columns]).then(function () { return _this.showPanel(_this.currentPanel); });
        };
        ContentBuilderToolbar.prototype.clearToolbar = function () {
            for (var panelType in this.panels) {
                var panel = this.panels[panelType];
                while (panel.firstChild) {
                    panel.firstChild.remove();
                }
            }
        };
        ContentBuilderToolbar.prototype.setupSearch = function () {
            var _this = this;
            var input = this.root.querySelector(".toolbar-filter input#filter");
            input.oninput = function () {
                _this.searchValue = input.value;
                _this.filterPanel();
            };
            this.searchInput = input;
            this.searchValue = input.value;
        };
        ContentBuilderToolbar.prototype.loadRows = function () {
            var _this = this;
            var rows = fetch("ContentBuilder.aspx?ID=" + this.pageId + "&cmd=GetRowDefinitions").then(function (resp) {
                if (resp.ok) {
                    return resp.json();
                }
                else {
                    Helpers.log("Unable to load type for 'New Row'", resp.status, resp.statusText);
                }
            }).then(function (definitionCategories) {
                var fragment = document.createDocumentFragment();
                var _loop_2 = function (category) {
                    var definitions = definitionCategories[category];
                    var categoryWrapper = Helpers.makeElement("<div class=\"category-container\" style=\"display: none;\"></div>");
                    var categoryElement = Helpers.makeElement("<div class=\"category-header\">" + category + "</div>");
                    categoryWrapper.appendChild(categoryElement);
                    definitions.forEach(function (d) {
                        var markup = "\n                            <div class=\"toolbar-new-rowtype\">\n                                " + (d.Image && d.Image !== '' && !d.Image.includes(".svg")
                            ? "<img src=\"/Admin/Public/GetImage.ashx?width=410&amp;height=210&amp;crop=5&amp;compression=75&amp;image=" + d.Image + "\" class=\"template-image\" title=\"" + d.Name + "\" />"
                            : "") + "\n                                " + (d.Image && d.Image !== '' && d.Image.includes(".svg")
                            ? "<img src=\"" + d.Image + "\" class=\"template-image\" title=\"" + d.Name + "\" />"
                            : "") + "\n                                " + (d.Name !== '' && d.Image == ''
                            ? "<div>" + d.Name + "</div>"
                            : "") + "\n                            </div>\n                        ";
                        var newRowElement = Helpers.makeElement(markup);
                        categoryWrapper.appendChild(newRowElement);
                        _this.rows.push(new NewRowType(newRowElement, d));
                    });
                    fragment.appendChild(categoryWrapper);
                };
                for (var category in definitionCategories) {
                    _loop_2(category);
                }
                _this.panels.newRow.appendChild(fragment);
            }).catch(function (reason) { return Helpers.log("Unable to get new row types", reason); });
            return rows;
        };
        ContentBuilderToolbar.prototype.loadColumns = function () {
            var _this = this;
            var columns = fetch("ContentBuilder.aspx?ID=" + this.pageId + "&cmd=GetColumnDefinitions").then(function (resp) {
                if (resp.ok) {
                    return resp.json();
                }
                else {
                    Helpers.log("Unable to load type for 'New Columns'", resp.status, resp.statusText);
                }
            }).then(function (definitionCategories) {
                var fragment = document.createDocumentFragment();
                var _loop_3 = function (category) {
                    var definitions = definitionCategories[category];
                    var categoryWrapper = Helpers.makeElement("<div class=\"category-container\" style=\"display: none;\"></div>");
                    var categoryElement = Helpers.makeElement("<div class=\"category-header\">" + category + "</div>");
                    categoryWrapper.appendChild(categoryElement);
                    definitions.forEach(function (d) {
                        var iconOrImage = d.Image
                            ? "<img src=\"/Admin/Public/GetImage.ashx?width=410&amp;height=210&amp;crop=5&amp;compression=75&amp;image=" + d.Image + "\" class=\"template-image\" title=\"" + d.Name + "\" />"
                            : "<span class=\"large-icon\">" + d.Icon + "</span>";
                        var markup = "\n                            <div class=\"paragraph-type\" title=\"" + d.Name + "\">\n                                " + iconOrImage + "  \n                                " + (d.Name !== '' && iconOrImage == ''
                            ? "<div>" + d.Name + "</div>"
                            : "") + "\n                                " + (d.Description !== '' && iconOrImage == ''
                            ? "<div class=\"description\"><small>" + d.Description + "</small></div>"
                            : "") + "\n                            </div>";
                        var newColumnElement = Helpers.makeElement(markup);
                        categoryWrapper.appendChild(newColumnElement);
                        _this.columns.push(new NewColumnType(newColumnElement, d));
                    });
                    fragment.appendChild(categoryWrapper);
                };
                for (var category in definitionCategories) {
                    _loop_3(category);
                }
                _this.panels.newColumn.appendChild(fragment);
            }).catch(function (reason) { return Helpers.log("Unable to get new column types", reason); });
            return columns;
        };
        ContentBuilderToolbar.prototype.filterPanel = function () {
            var _this = this;
            var elements = this.currentPanel === "newColumn" ? this.columns : this.rows;
            elements.forEach(function (e) {
                var searchText = _this.searchValue.toLowerCase();
                var categoryContainer = e.element.closest('.category-container');
                var categoryName = categoryContainer.querySelector('.category-header').innerHTML.toLowerCase();
                e.element.style.display = categoryName.includes(searchText) || e.contentText.includes(searchText) ? "block" : "none";
            });
            var elementSelector = this.currentPanel === "newColumn" ? ".paragraph-type" : ".toolbar-new-rowtype";
            this.panels[this.currentPanel].querySelectorAll('.category-container').forEach(function (container) {
                var allElementsHidden = !Array.from(container.querySelectorAll(elementSelector)).some(function (element) { return element.style.display === "block"; });
                container.style.display = allElementsHidden ? "none" : "block";
            });
        };
        ContentBuilderToolbar.prototype.showPanel = function (panel) {
            var _loop_4 = function (panelType) {
                var element = this_1.panels[panelType];
                var tab = this_1.panelTabs[panelType];
                var isMatch = panel === panelType;
                element.style.display = isMatch ? "block" : "none";
                var tabClassHandler = isMatch ? function (cssClass) { return tab.classList.add(cssClass); } : function (cssClass) { return tab.classList.remove(cssClass); };
                tabClassHandler("selected");
            };
            var this_1 = this;
            for (var panelType in this.panels) {
                _loop_4(panelType);
            }
            if (this.currentPanel !== panel) {
                this.setSearchValue("");
            }
            this.currentPanel = panel;
            this.filterPanel();
        };
        ;
        return ContentBuilderToolbar;
    }());
    var NewRowType = /** @class */ (function () {
        function NewRowType(element, definition) {
            this.element = element;
            this.type = NewRowType.type;
            this.definitionId = definition.Id;
            this.isTemplate = definition.IsTemplate;
            this.contentText = (definition.Description + " " + definition.Image + " " + definition.Name).toLowerCase();
            this.setupDragAndDrop();
        }
        NewRowType.prototype.setupDragAndDrop = function () {
            var _this = this;
            this.element.draggable = true;
            this.element.ondragstart = function (e) {
                e.dataTransfer.effectAllowed = "move";
                state.dragging.source = _this;
                state.grids.forEach(function (grid) {
                    if (grid.rows.length === 0) {
                        grid.rowPlaceholders.forEach(function (row) { row.element.style.display = "block"; });
                    }
                });
            };
            this.element.ondragend = function (e) {
                e.preventDefault();
                e.stopPropagation();
                state.dragging.reset();
                state.grids.forEach(function (grid) {
                    if (grid.rows.length === 0) {
                        grid.rowPlaceholders.forEach(function (row) { row.element.style.display = "none"; });
                    }
                    else {
                        grid.rows.forEach(function (r) {
                            var overlay = r.rowOverlay;
                            overlay.clearDropTarget();
                        });
                    }
                });
            };
        };
        ;
        NewRowType.type = "NewRowType";
        return NewRowType;
    }());
    var NewColumnType = /** @class */ (function () {
        function NewColumnType(element, definition) {
            this.element = element;
            this.type = NewColumnType.type;
            this.creationType = definition.IsTemplate ? "template" : definition.IsItemBased ? "item" : "new";
            this.creationArgument = definition.IsTemplate ? parseInt(definition.Id) : definition.Id;
            this.contentText = (definition.Description + " " + definition.Image + " " + definition.Name).toLowerCase();
            this.setupDragAndDrop();
        }
        NewColumnType.prototype.createColumn = function (window) {
            var creationStarted = false;
            if (this.creationType === "new") {
                window.Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraph('0');
                creationStarted = true;
            }
            else if (this.creationType === "item") {
                window.Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraph(this.creationArgument);
                creationStarted = true;
            }
            else if (this.creationType === "template") {
                window.Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraph(null, this.creationArgument);
                creationStarted = true;
            }
            if (creationStarted) {
                var nameField = window.document.querySelector("#ParagraphName");
                nameField.value = "New column";
                window.Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraphSubmit();
            }
        };
        NewColumnType.prototype.setupDragAndDrop = function () {
            var _this = this;
            this.element.draggable = true;
            this.element.ondragstart = function (e) { state.dragging.source = _this; };
            this.element.ondragend = function (e) {
                e.preventDefault();
                e.stopPropagation();
                var previousColumn = state.dragging.target;
                previousColumn.columnOverlay.clearDropTarget();
                state.dragging.reset();
            };
        };
        NewColumnType.type = "NewColumnType";
        return NewColumnType;
    }());
    //#endregion
    //#region State and Helpers
    var State = /** @class */ (function () {
        function State() {
            var _this = this;
            this.debug = true;
            this.translations = {};
            this.dragging = {
                source: null,
                target: null,
                reset: function () {
                    _this.dragging.source = null;
                    _this.dragging.target = null;
                }
            };
            this.grids = [];
        }
        return State;
    }());
    var Helpers = /** @class */ (function () {
        function Helpers() {
        }
        Helpers.getSiblings = function (elm, end, filter) {
            var siblings = [];
            var candidate = elm.nextElementSibling;
            while (candidate) {
                if (candidate.matches(end))
                    break;
                if (filter && candidate.matches(filter) || !filter) {
                    siblings.push(candidate);
                }
                candidate = candidate.nextElementSibling;
            }
            return siblings;
        };
        Helpers.getTranslation = function (text) { return state.translations[text] || text; };
        Helpers.reloadEditor = function () { return state.contentFrame.contentWindow.location.reload(true); };
        Helpers.makeElement = function (markup) {
            var fragment = document.createRange().createContextualFragment(markup);
            var element = fragment.firstElementChild;
            return element;
        };
        Helpers.createButton = function (text, title, action) {
            var button = Helpers.elementFactory("dw-toolbar-button");
            button.title = title;
            button.innerHTML = text;
            button.onclick = function (e) {
                e.preventDefault();
                e.stopPropagation();
                action();
            };
            button.style.display = "inline-block";
            button.style.backgroundColor = "#414141";
            button.style.border = "none";
            button.style.padding = "5px";
            button.style.cursor = "pointer";
            button.style.boxSizing = "content-box";
            button.onmouseenter = function () { return button.style.backgroundColor = "#757575"; };
            button.onmouseleave = function () { return button.style.backgroundColor = "#414141"; };
            return button;
        };
        Helpers.createToolbarIcon = function (text, title) {
            var button = Helpers.elementFactory("dw-toolbar-button");
            button.title = title;
            button.innerHTML = text;
            button.style.display = "inline-block";
            button.style.backgroundColor = "#757575";
            button.style.border = "none";
            button.style.padding = "5px";
            button.style.boxSizing = "content-box";
            return button;
        };
        Helpers.reorderItems = function (collection, source, target) {
            var swapItems = function (startIndex, completionPredicate, nextIndexCalculator) {
                var _a;
                var currentIndex = startIndex;
                while (completionPredicate(currentIndex)) {
                    var nextIndex = nextIndexCalculator(currentIndex);
                    _a = [collection[nextIndex], collection[currentIndex]], collection[currentIndex] = _a[0], collection[nextIndex] = _a[1];
                    currentIndex = nextIndex;
                }
            };
            var sourceIndex = typeof source === 'number' ? source : collection.indexOf(source);
            var targetIndex = typeof target === 'number' ? target : collection.indexOf(target);
            if (sourceIndex > targetIndex) {
                swapItems(sourceIndex, function (currentIndex) { return currentIndex > targetIndex; }, function (currentIndex) { return currentIndex - 1; });
            }
            else {
                swapItems(sourceIndex, function (currentIndex) { return currentIndex < targetIndex; }, function (currentIndex) { return currentIndex + 1; });
            }
        };
        Helpers.showSpinner = function () { return showOverlay("spinner"); }; // Method to show the wait spinner
        Helpers.hideSpinner = function () { return hideOverlay("spinner"); }; // Method to hide the wait spinner
        Helpers.log = function () {
            var args = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i] = arguments[_i];
            }
            return Helpers.outputMessage.apply(Helpers, ["log"].concat(args));
        };
        Helpers.warn = function () {
            var args = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i] = arguments[_i];
            }
            return Helpers.outputMessage.apply(Helpers, ["warn"].concat(args));
        };
        Helpers.error = function () {
            var args = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i] = arguments[_i];
            }
            return Helpers.outputMessage.apply(Helpers, ["error"].concat(args));
        };
        Helpers.outputMessage = function (outputType) {
            var args = [];
            for (var _i = 1; _i < arguments.length; _i++) {
                args[_i - 1] = arguments[_i];
            }
            if (state.debug) {
                var date = new Date();
                console[outputType].apply(console, [date.toLocaleDateString() + ":" + date.toLocaleTimeString() + " - "].concat(args));
            }
        };
        return Helpers;
    }());
    ;
    ;
    //#endregion
    //#region Public API
    function initializeEditor(pageId, isAdmin, translations) {
        if (parent.document !== document) {
            var navigator_1 = parent.document.querySelector("#sidebar");
            navigator_1.style.display = "none";
            var container = parent.document.querySelector("#content-container");
            container.style.paddingLeft = "0px";
        }
        showOverlay("wait");
        state.translations = translations;
        state.isAdmin = isAdmin;
        var contentFrame = document.querySelector("iframe.view-port");
        contentFrame.addEventListener("load", function () {
            contentFrame.contentWindow.addEventListener("unload", function () {
                showOverlay("wait");
            });
            var didLoadGrid = false;
            var grids = [];
            var doc = contentFrame.contentWindow.document;
            if (doc) {
                Helpers.elementFactory = function (type) { return doc.createElement(type); };
                var roots = Array.from(doc.querySelectorAll("dw-placeholder.dw-grid"));
                roots.forEach(function (root) {
                    var rowElements = Helpers.getSiblings(root, "dw-placeholder.dw-grid", ".dw-gridrow");
                    var grid = new Grid(root, rowElements);
                    if (grid && !grid.isMissingRowDefinitions) {
                        didLoadGrid = true;
                        grids.push(grid);
                    }
                });
            }
            if (didLoadGrid) {
                state.grids = grids;
                var location_1 = new URL(contentFrame.contentDocument.location.href.toLocaleLowerCase());
                var devicetype = location_1.searchParams.get("devicetype");
                state.isMobile = (devicetype == "mobile" || devicetype == "tablet");
                if (location_1.searchParams.has("devicetype")) {
                    // Hide Scrollbars But Keep Functionality
                    var style = doc.createElement("style");
                    style.innerHTML = "html::-webkit-scrollbar { display: none; } html {-ms-overflow-style: none; }";
                    doc.head.append(style);
                }
                else {
                    var toolbarElement = document.querySelector(".toolbar");
                    state.toolbar = new ContentBuilderToolbar(toolbarElement, state.grids[0].pageId);
                }
            }
            else {
                if (state.toolbar) {
                    state.toolbar.clearToolbar();
                    state.toolbar = null;
                }
                state.grids = null;
            }
            hideOverlay("wait");
        });
        var contentUrl = "/Default.aspx?ID=" + pageId + "&visualedit=true";
        contentFrame.src = contentUrl;
        state.contentFrame = contentFrame;
    }
    ContentBuilder.initializeEditor = initializeEditor;
    function navigate() {
        var callback = function (options, model) {
            var contentFrame = document.querySelector("iframe.view-port");
            var location = new URL(contentFrame.contentDocument.location.href);
            if (location.searchParams.has("devicetype")) {
                var deviceType = location.searchParams.get("devicetype");
                contentFrame.src = "/Default.aspx?ID=" + model.Selected + "&visualedit=true&devicetype=" + deviceType;
            }
            else {
                contentFrame.src = "/Default.aspx?ID=" + model.Selected + "&visualedit=true";
            }
        };
        var dlgAction = createLinkDialog(linkDialogTypes.page, ['TypesPermittedForChoosing=' + linkDialogPageTypeAllowed], callback);
        Action.Execute(dlgAction);
    }
    ContentBuilder.navigate = navigate;
    function showPreviewMenu() {
        var previewMenu = document.querySelector(".toolbar-preview-menu");
        previewMenu.classList.toggle("show");
        previewMenu.onmouseleave = function () { return showPreviewMenu(); };
    }
    ContentBuilder.showPreviewMenu = showPreviewMenu;
    function showPreview(deviceType, width, height) {
        var location = new URL(state.contentFrame.contentDocument.location.href.toLocaleLowerCase());
        location.searchParams.delete("devicetype");
        var container = document.querySelector("#content-container");
        var contentFrame = document.querySelector("iframe.view-port");
        var rotateButton = document.querySelector("a.rotate-preview-btn");
        contentFrame.src = location + "&devicetype=" + deviceType;
        if (width > 0 && height > 0) {
            if (container.classList.contains('preview--rotate')) {
                contentFrame.style.width = height + "px";
                contentFrame.style.height = width + "px";
            }
            else {
                contentFrame.style.width = width + "px";
                contentFrame.style.height = height + "px";
            }
            container.classList.add("preview--mobile");
            rotateButton.classList.add("preview--mobile");
        }
        else {
            contentFrame.style.width = "100%";
            contentFrame.style.height = "100%";
            container.classList.remove("preview--mobile");
            rotateButton.classList.remove("preview--mobile");
        }
    }
    ContentBuilder.showPreview = showPreview;
    function rotatePreviewFrame() {
        var contentFrame = document.querySelector("iframe.view-port");
        var frameWidth = contentFrame.style.width;
        var frameHeight = contentFrame.style.height;
        var container = document.querySelector("#content-container");
        container.classList.toggle('preview--rotate');
        contentFrame.style.width = frameHeight;
        contentFrame.style.height = frameWidth;
    }
    ContentBuilder.rotatePreviewFrame = rotatePreviewFrame;
    function showPage() {
        var location = new URL(state.contentFrame.contentDocument.location.href);
        location.searchParams.delete("visualedit");
        location.searchParams.delete("devicetype");
        var showUrl = "" + location;
        window.open(showUrl, "_blank");
    }
    ContentBuilder.showPage = showPage;
    function saveRow() {
        Helpers.showSpinner();
        var frame = document.getElementById('dlgEditGridRowFrame');
        var frameWindow = frame.contentWindow;
        frame.onload = function () {
            Helpers.reloadEditor();
            Helpers.hideSpinner();
        };
        var success = frameWindow.Dynamicweb.Items.ItemEdit.get_current().save();
        if (success === false) {
            // Explicitly false = validation error
            Helpers.hideSpinner();
        }
        else {
            dialog.hide("dlgEditGridRow");
        }
    }
    ContentBuilder.saveRow = saveRow;
    function saveColumn() {
        Helpers.showSpinner();
        var frame = document.getElementById('dlgEditParagraphFrame');
        var frameWindow = frame.contentWindow;
        frame.onload = function () {
            Helpers.reloadEditor();
            Helpers.hideSpinner();
        };
        var success = frameWindow.Save(); // Will return false on validation error and undefined in all other cases
        if (success === false) {
            // Explicitly false = validation error
            Helpers.hideSpinner();
        }
        else {
            // No errors
            dialog.get_cancelButton('dlgEditParagraph').style.display = "";
            dialog.hide("dlgEditParagraph");
        }
    }
    ContentBuilder.saveColumn = saveColumn;
    function saveAsTemplate() {
        var frame = document.getElementById('dlgSaveAsTemplateFrame');
        var frameWindow = frame.contentWindow;
        var doc = frameWindow.document;
        var form = doc.forms[0];
        var formData = new FormData(form);
        var templateName = doc.getElementById("TemplateName");
        if (!templateName.value) {
            dwGlobal.showControlErrors(templateName, Helpers.getTranslation("Required"));
            templateName.focus();
            return;
        }
        else {
            dwGlobal.hideControlErrors(templateName);
        }
        var categoryTypeNew = doc.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0];
        var templateCategory = (categoryTypeNew == undefined || categoryTypeNew.checked ? doc.getElementById("TemplateNewCategory") : doc.getElementById("TemplateCategory"));
        if (!templateCategory.value) {
            dwGlobal.showControlErrors(templateCategory, Helpers.getTranslation("Required"));
            templateCategory.focus();
            return;
        }
        else {
            dwGlobal.hideControlErrors(templateCategory);
        }
        Helpers.showSpinner();
        frameWindow.fetch(form.action, {
            method: 'POST',
            body: formData
        }).then(function (resp) {
            if (resp.ok) {
                dialog.hide("dlgSaveAsTemplate");
                state.toolbar.reload();
            }
        })
            .catch(function (reason) { return Helpers.log("An error occurred while saving the row template", reason); })
            .finally(function () { return Helpers.hideSpinner(); });
    }
    ContentBuilder.saveAsTemplate = saveAsTemplate;
    function saveColumnAsTemplate() {
        var frame = document.getElementById('dlgSaveColumnAsTemplateFrame');
        var frameWindow = frame.contentWindow;
        var doc = frameWindow.document;
        var form = doc.forms[0];
        var formData = new FormData(form);
        var templateName = doc.getElementById("TemplateName");
        if (!templateName.value) {
            dwGlobal.showControlErrors(templateName, Helpers.getTranslation("Required"));
            templateName.focus();
            return;
        }
        else {
            dwGlobal.hideControlErrors(templateName);
        }
        var categoryTypeNew = doc.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0];
        var templateCategory = (categoryTypeNew == undefined || categoryTypeNew.checked ? doc.getElementById("TemplateNewCategory") : doc.getElementById("TemplateCategory"));
        if (!templateCategory.value) {
            dwGlobal.showControlErrors(templateCategory, Helpers.getTranslation("Required"));
            templateCategory.focus();
            return;
        }
        else {
            dwGlobal.hideControlErrors(templateCategory);
        }
        Helpers.showSpinner();
        frameWindow.fetch(form.action, {
            method: 'POST',
            body: formData
        }).then(function (resp) {
            if (resp.ok) {
                dialog.hide("dlgSaveColumnAsTemplate");
                state.toolbar.reload();
            }
        })
            .catch(function (reason) { return Helpers.log("An error occurred while saving the column template", reason); })
            .finally(function () { return Helpers.hideSpinner(); });
    }
    ContentBuilder.saveColumnAsTemplate = saveColumnAsTemplate;
    function switchColumnEditMode(mode) {
        var frame = document.getElementById('dlgEditParagraphFrame');
        var frameWindow = frame.contentWindow;
        frameWindow.ParagraphView.switchMode(mode);
    }
    ContentBuilder.switchColumnEditMode = switchColumnEditMode;
    function showRowSelector() {
        if (state.toolbar) {
            state.toolbar.showNewRow();
        }
    }
    ContentBuilder.showRowSelector = showRowSelector;
    function showColumnSelector() {
        if (state.toolbar) {
            state.toolbar.showNewColumn();
        }
    }
    ContentBuilder.showColumnSelector = showColumnSelector;
    function popEditorOut() {
        window.open(location.href + "&popout=true", "_blank");
    }
    ContentBuilder.popEditorOut = popEditorOut;
    function closeVisualEditor() {
        var restoreTree = function () {
            if (parent.document !== document) {
                var navigator_2 = parent.document.querySelector("#sidebar");
                navigator_2.style.display = null;
                var container = parent.document.querySelector("#content-container");
                container.style.paddingLeft = null;
            }
            window.removeEventListener("unload", restoreTree);
        };
        if (state.grids && state.grids.length > 0) {
            Helpers.showSpinner();
            window.addEventListener("unload", restoreTree);
            location.href = "/Admin/Content/ParagraphList.aspx?PageID=" + state.grids[0].pageId + "&NavigatorSync=RefreshParentAndSelectPage";
        }
        else {
            //TODO: Figure out how to redirect to content tree without page id.
        }
    }
    ContentBuilder.closeVisualEditor = closeVisualEditor;
    //#endregion
    //#region Constants and definitions
    var zIndexMaxValue = 2147483638; // The max value of z-index in modern browsers
    var state = new State();
    var linkDialogTypes = {
        page: 0,
        paragraph: 1
    };
    var linkDialogPageTypeAllowed = 6;
    //#endregion
})(ContentBuilder || (ContentBuilder = {}));
