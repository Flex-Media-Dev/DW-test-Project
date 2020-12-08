namespace ContentBuilder {

    //#region Model classes
    class Grid {
        constructor(root: HTMLElement, rowElements: HTMLElement[]) {
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

        readonly pageId: number;
        readonly container: string;
        readonly gridId: string;
        readonly isMissingRowDefinitions: boolean;
        readonly rowPlaceholders: GridRow[] = [];
        readonly rows: GridRow[];

        private readonly root: HTMLElement;

        persistNewRowAndColumnOrder() {
            const newOrder = this.rows.map(row => {
                return {
                    id: row.id,
                    columns: row.columns.map(col => col.paragraphId)
                };
            });
            return fetch(`/Admin/Content/GridRowEdit.aspx?PageID=${this.pageId}&cmd=sort`, {
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

        private createErrorContent() {
            const error = Helpers.elementFactory("div");
            error.innerHTML = `<strong>No row definitions found for Grid ID '${this.gridId}'. Verify that the Grid configuration in your Layout template is valid.</strong>`
            this.root.parentNode.appendChild(error);
        }
        private loadRows(rowElements: HTMLElement[], grid: Grid): GridRow[] {
            const rows: GridRow[] = [];
            rowElements.forEach((row, position) => {
                const sortIndex = position + 1;
                rows.push(new GridRow(row, grid, sortIndex));
            });
            return rows;
        }
        private createNewRowTarget(sortIndex: number) {
            const markup = `
                <dw-new-gridrow data-dw-gridrow="0" data-dw-grid-container="${this.container}" data-dw-grid-id="${this.gridId}" style="display: none; height: 62px; position: relative; cursor: pointer; z-index: 1">
                    <img src="/Admin/Public/plus-white-circle.svg" class="js-dw-gridrow-icon" style="height: 42px; width: 42px; left: calc(50% - 21px); top: calc(50% - 21px); position: absolute; z-index: ${zIndexMaxValue}" />
                    <div class="js-dw-gridrow-line" style="position: absolute; border-top: 1px dashed #a8a8a8; width: 100%; top: calc(50% - 1px);"></div>
                </dw-new-gridrow>
            `;
            const newRow = Helpers.makeElement(markup);

            const gridRow = new GridRow(newRow, this, sortIndex);
            newRow.onclick = () => gridRow.editRow();

            this.root.parentNode.appendChild(newRow);

            this.rowPlaceholders.push(gridRow);
        };
    }

    class GridRow implements IElementComponent, IDragElement {
        constructor(rowElement: HTMLElement, grid: Grid, sortIndex: number) {
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
                } else {
                    this.setupOverlay();
                }
                this.setupDragAndDrop();
            } else {
                const definitionId = rowElement.getAttribute("data-dw-gridrow-missing-definition");
                this.createErrorContent(definitionId);
            }
        }

        public static readonly type: string = "GridRow";

        readonly id: number;
        readonly grid: Grid;

        readonly columns: GridColumn[];
        readonly element: HTMLElement;
        readonly type = GridRow.type;
        readonly isMissingDefinition: boolean;
        readonly hasPublicationPeriod: boolean;
        readonly hideForDesktops: boolean;
        readonly hideForPhones: boolean;
        readonly hideForTablets: boolean;
        get hasContent(): boolean {
            return this.columns.reduce((hasContent, currentColumn) => {
                if (hasContent)
                    return hasContent;
                return !currentColumn.isPlaceholder;
            }, false);
        }
        get rowOverlay(): RowOverlay {
            return this.overlay;
        }
        get columnCount(): number {
            return this.numberOfColumns;
        }

        private numberOfColumns: number;
        private overlay: RowOverlay;
        private readonly isPlaceholder: boolean;
        private readonly sortIndex: number;
        private setPlaceholderActive: () => void;
        private setPlaceholderInactive: () => void;

        editRow(id?: number, position?: number) {
            if (!id && !position) {
                id = this.id;
                position = this.sortIndex;
            }

            if (id > 0) {
                Helpers.showSpinner();

                const frame = document.getElementById("dlgEditGridRowFrame") as HTMLIFrameElement;
                frame.onload = () => {
                    Helpers.hideSpinner();
                    dialog.show("dlgEditGridRow");
                };
                frame.src = `GridRowEdit.aspx?PageId=${this.grid.pageId}&ID=${id}&SortIndex=${position}&Container=${this.grid.container}&GridId=${this.grid.gridId}&VisualEditor=true`;
            } else {
                state.toolbar.showNewRow();
            }
        }
        insertRowBefore() {
            this.editRow(0, this.sortIndex);
        };
        insertRowAfter() {
            this.editRow(0, this.sortIndex + 1);
        };
        saveRowAsTemplate() {
            Helpers.showSpinner();

            const frame = document.getElementById("dlgSaveAsTemplateFrame") as HTMLIFrameElement;
            frame.onload = () => {
                Helpers.hideSpinner();
                dialog.show("dlgSaveAsTemplate");
            };
            frame.src = `GridRowTemplateEdit.aspx?PageId=${this.grid.pageId}&ID=${this.id}`;
        };
        deleteRow() {
            if (!confirm(`Are you sure you want to delete the row with id '${this.id}'? This will unlink all column content from the row but not delete them.`))
                return;

            Helpers.showSpinner();

            const url = `GridRowEdit.aspx?PageId=${this.grid.pageId}&ID=${this.id}&cmd=delete`;
            fetch(url).then(resp => {
                if (resp.ok) {
                    Helpers.hideSpinner();
                    Helpers.reloadEditor();
                }
            }).catch(reason => {
                Helpers.log("Unable to delete row", this.id, reason);
            });
        };
        replaceColumn(existingColumn: GridColumn, newColumn: GridColumn) {
            const existingIndex = this.columns.indexOf(existingColumn);
            this.columns[existingIndex] = newColumn;
            newColumn.row = this;
        };

        private createNewRow(definitionId: string, isTemplate: boolean, sortIndex: number) {
            Helpers.showSpinner();
            fetch(`GridRowEdit.aspx?PageId=${this.grid.pageId}&cmd=create`, {
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
            }).then(resp => {
                if (resp.ok) {
                    return resp.text();
                } else {
                    return Promise.reject(`${resp.status}: ${resp.statusText}`);
                }
            }).catch(reason => {
                Helpers.log("Unable to create new row", reason);
            }).finally(() => {
                Helpers.hideSpinner();
                Helpers.reloadEditor();
            })
        }

        private createErrorContent(definitionId: string) {
            const error = Helpers.elementFactory("div");
            error.innerHTML = `<strong>Row definition '${definitionId}' for row '${this.id}' not found for Grid ID '${this.grid.gridId}'. Verify that your RowDefinitions.json file contains the definition ID.</strong>`;
            this.element.appendChild(error);
        }
        private setupPlaceholder() {
            const icon = this.element.querySelector("img") as HTMLImageElement;
            const line = this.element.querySelector("div") as HTMLElement;

            const setActive = () => {
                icon.src = "/Admin/Public/plus-circle-blue.svg";
                line.style.borderTop = "1px dashed #0084CA";
            };
            const setInactive = () => {
                icon.src = "/Admin/Public/plus-white-circle.svg";
                line.style.borderTop = '1px dashed #a8a8a8';
            };

            this.element.onmouseenter = setActive;
            this.element.onmouseleave = setInactive;
            setInactive();

            this.setPlaceholderActive = setActive;
            this.setPlaceholderInactive = setInactive;
        };
        private setupOverlay() {
            const overlay = new RowOverlay(this);
            this.element.appendChild(overlay.element);

            this.element.onmouseover = () => {
                if (!state.dragging.source) overlay.show();
            }
            this.element.onmouseout = () => overlay.hide();

            this.overlay = overlay;
        };
        private setupDragAndDrop() {
            if (!this.isPlaceholder) {
                this.overlay.dragHandle.ondragstart = (e) => {
                    state.dragging.source = this;
                    this.overlay.element.style.opacity = '0';

                    e.dataTransfer.setDragImage(this.element, 10, 10);
                    e.dataTransfer.effectAllowed = "move";
                };

                this.overlay.dragHandle.ondragend = (e) => {
                    e.preventDefault();

                    state.dragging.reset();
                    this.overlay.element.style.opacity = '1';
                };
            }

            this.element.ondragenter = (e) => {
                e.preventDefault();

                const isNewRowSource = state.dragging.source.type === NewRowType.type;
                const isOtherRowSource = state.dragging.source.type === GridRow.type;

                if (isNewRowSource || isOtherRowSource) {
                    e.stopPropagation();

                    state.dragging.target = state.dragging.target || this;
                    if (state.dragging.target !== this) {
                        const previousRow = state.dragging.target as GridRow;
                        previousRow.hideDropTarget();
                        state.dragging.target = this;
                    }

                    if (state.dragging.source !== this && this.shouldShowDropTarget(e)) {
                        this.showDropTarget(e);
                    }
                }
            };

            this.element.ondragover = (e) => {
                e.preventDefault();

                const isNewRowSource = state.dragging.source.type === NewRowType.type;
                const isOtherRowSource = state.dragging.source.type === GridRow.type;

                if (isNewRowSource || isOtherRowSource) {
                    e.stopPropagation();

                    const sourceRow = state.dragging.source as GridRow;
                    if ((isNewRowSource || (isOtherRowSource && sourceRow !== this && sourceRow.grid === this.grid)) && this.shouldShowDropTarget(e)) {
                        e.dataTransfer.dropEffect = "move";
                        this.showDropTarget(e);
                    } else {
                        e.dataTransfer.dropEffect = "none";
                        this.hideDropTarget();
                    }
                }
            };

            this.element.ondragleave = (e) => {
                e.preventDefault();

                const isNewRowSource = state.dragging.source.type === NewRowType.type;
                const isOtherRowSource = state.dragging.source.type === GridRow.type;

                if (isNewRowSource || isOtherRowSource) {
                    e.stopPropagation();

                    this.hideDropTarget();
                }
            }

            this.element.ondrop = (e) => {
                e.preventDefault();

                const isNewRowSource = state.dragging.source.type === NewRowType.type;
                const isOtherRowSource = state.dragging.source.type === GridRow.type;

                if (isNewRowSource || isOtherRowSource) {
                    e.stopPropagation();

                    const dropPosition = this.getDropPosition(e);
                    if (isNewRowSource) {
                        const newRowType = state.dragging.source as NewRowType;
                        const sortIndex = this.sortIndex + (dropPosition === "above" ? 0 : 1);
                        this.createNewRow(newRowType.definitionId, newRowType.isTemplate, sortIndex);
                    } else if (isOtherRowSource) {
                        Helpers.showSpinner();

                        const draggedRow = state.dragging.source as GridRow;

                        const sourceIndex = this.grid.rows.indexOf(draggedRow);
                        let targetIndex = this.grid.rows.indexOf(this);
                        if (sourceIndex > targetIndex) {
                            targetIndex += dropPosition === "above" ? 0 : 1;
                        } else {
                            targetIndex += dropPosition === "above" ? -1 : 0;
                        }

                        Helpers.reorderItems(this.grid.rows, sourceIndex, targetIndex);
                        this.grid.persistNewRowAndColumnOrder().then(resp => {
                            if (resp.ok) {
                                Helpers.reloadEditor();
                                Helpers.hideSpinner();
                            } else {
                                return Promise.reject(`Unable to save new row order. Reason: ${resp.status} - ${resp.statusText}`);
                            }
                        }).catch(reason => {
                            Helpers.error(reason);
                            Helpers.reloadEditor();
                            Helpers.hideSpinner();
                        });
                    }
                }
            };
        };
        private shouldShowDropTarget(e: DragEvent) {
            const sourceRow = state.dragging.source as GridRow;
            const dropPosition = this.getDropPosition(e);
            const indexOfSource = this.grid.rows.indexOf(sourceRow)
            const indexOfThis = this.grid.rows.indexOf(this);
            const showDropTarget =
                indexOfSource === -1 ||
                (!(indexOfThis === indexOfSource - 1 && dropPosition === "below") &&
                    !(indexOfThis === indexOfSource + 1 && dropPosition === "above"));

            return showDropTarget;
        }
        private showDropTarget(e: DragEvent) {
            if (this.isPlaceholder) {
                this.setPlaceholderActive();
            } else {
                const position = this.getDropPosition(e);
                this.overlay.showDropTarget(position);
            }
        }
        private hideDropTarget() {
            if (this.isPlaceholder) {
                this.setPlaceholderInactive();
            } else {
                this.overlay.clearDropTarget();
            }
        }
        private getDropPosition(e: DragEvent): "above" | "below" {
            const rect = this.element.getBoundingClientRect();
            const limit = Math.min(rect.height / 2, 150);
            const distanceTop = Math.abs(rect.top - e.clientY);
            const dropTop = distanceTop < limit;

            return dropTop ? "above" : "below";
        }

        private static loadColumns(rowElement: HTMLElement, row: GridRow): GridColumn[] {
            const gridColumns = Array.from(rowElement.querySelectorAll(".dw-gridcolumn"));
            row.numberOfColumns = gridColumns.length;
            const columns: GridColumn[] = []
            gridColumns.forEach((column: HTMLElement) => {
                const col = new GridColumn(column, row);
                columns.push(col);
            });
            return columns;
        };
    }

    class GridColumn implements IElementComponent, IDragElement {
        constructor(columnElement: HTMLElement, row: GridRow) {
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

        public static readonly type: string = "GridColumn";

        row: GridRow;
        readonly paragraphId: string;
        readonly paragraphName: string;
        readonly isPlaceholder: boolean;
        readonly element: HTMLElement;
        readonly type: string = GridColumn.type;
        readonly trigger: HTMLElement;
        get columnOverlay(): ColumnOverlay {
            return this.overlay;
        }

        private readonly columnPosition: number;
        private overlay: ColumnOverlay;

        editColumn() {
            if (!this.isPlaceholder) {
                Helpers.showSpinner();

                const frame = document.getElementById('dlgEditParagraphFrame') as HTMLIFrameElement;
                frame.onload = () => {
                    const doc = frame.contentWindow.document;
                    const hasModuleButton = doc.getElementById('cmdViewModule');

                    document.getElementById('Toolbar').style.display = hasModuleButton ? 'block' : 'none';

                    const dialogTitle = `${Helpers.getTranslation("Edit")} ${this.paragraphName}`;
                    dialog.setTitle("dlgEditParagraph", dialogTitle)
                    dialog.show("dlgEditParagraph");

                    Helpers.hideSpinner();
                };
                frame.src = `ParagraphEdit.aspx?ID=${this.paragraphId}&PageId=${this.row.grid.pageId}&Row=${this.row.id}&Column=${this.columnPosition}&VisualEditor=true`;
            } else {
                state.toolbar.showNewColumn();
            }
        };
        saveColumnAsTemplate() {
            Helpers.showSpinner();

            const frame = document.getElementById("dlgSaveColumnAsTemplateFrame") as HTMLIFrameElement;
            frame.onload = () => {
                Helpers.hideSpinner();
                dialog.show("dlgSaveColumnAsTemplate");
            };
            frame.src = `GridColumnTemplateEdit.aspx?ID=${this.paragraphId}`;
        };
        deleteColumn() {
            if (!confirm(`Are you sure you want to delete the column/paragraph with name: '${this.paragraphName}' and ID: '${this.paragraphId}'?`))
                return;

            Helpers.showSpinner();

            const url = `/Admin/Content/Paragraph/Paragraph_Delete.aspx?mode=viewparagraphs&ID=${this.paragraphId}&PageID=${this.row.grid.pageId}`;
            fetch(url).then(resp => {
                if (resp.ok) {
                    Helpers.reloadEditor();
                }
                Helpers.hideSpinner();
            }).catch(reason => {
                Helpers.log("Unable to delete paragraph", this.paragraphId, reason);
            });
        };
        linkContent() {
            Helpers.showSpinner();

            const url = `ContentBuilder.aspx?cmd=ListParagraphs&ID=${this.row.grid.pageId}`;
            fetch(url).then(resp => {
                if (resp.ok) {
                    return resp.json();
                } else {
                    Helpers.log("Unable to load paragraphs", resp.status, resp.statusText);
                }
            }).then((paragraphs: ParagraphModel[]) => {
                const existingParagraphContainer = document.querySelector(".link-paragraph-container") as HTMLElement;
                while (existingParagraphContainer.firstChild) {
                    existingParagraphContainer.removeChild(existingParagraphContainer.firstChild);
                }

                if (paragraphs.length > 0) {
                    const fragment = document.createDocumentFragment();
                    for (const paragraph of paragraphs) {
                        const markup = `
                            <div data-paragraph-id="${paragraph.Id}" class="paragraph-type">
                                <span class="large-icon">${paragraph.Icon}</span>
                                <div>${paragraph.Name}</div>
                                <div class="description">
                                    <small>${paragraph.Timestamp}</small>
                                </div>
                            </div>
                        `;
                        const paragraphElement = Helpers.makeElement(markup);

                        paragraphElement.onclick = () => {
                            dialog.hide("dlgLinkParagraph");
                            Helpers.showSpinner();

                            const url = `ContentBuilder.aspx?cmd=LinkParagraph&ParagraphId=${paragraph.Id}&RowId=${this.row.id}&position=${this.columnPosition}`;
                            fetch(url).then(resp => {
                                if (resp.ok) {
                                    Helpers.reloadEditor();
                                } else {
                                    Helpers.log("Unable to link paragraph to row", resp.status, resp.statusText);
                                }
                            })
                                .catch(reason => Helpers.log("Unable to link paragraph to row", reason))
                                .finally(() => Helpers.hideSpinner());
                        }
                        fragment.appendChild(paragraphElement);
                    }

                    existingParagraphContainer.appendChild(fragment);

                } else {
                    const noParagraphsElement = Helpers.makeElement(`<div class="description">${Helpers.getTranslation("No paragraps available")}</div>`);
                    existingParagraphContainer.appendChild(noParagraphsElement);
                }
                dialog.show("dlgLinkParagraph");
                Helpers.hideSpinner();
            }).catch(reason => Helpers.log("Unable to load paragraphs", reason));
        }
        unlinkContent() {
            if (!confirm(`Are you sure you want to unlink the paragraph with name: '${this.paragraphName}' and ID: '${this.paragraphId}'?`)) {
                return;
            }

            Helpers.showSpinner();

            const url = `ContentBuilder.aspx?cmd=UnlinkParagraph&ParagraphID=${this.paragraphId}`;
            fetch(url).then(resp => {
                if (resp.ok) {
                    Helpers.reloadEditor();
                } else {
                    Helpers.log("Unable to unlink paragraph", resp.status, resp.statusText);
                }
            })
                .catch(reason => Helpers.log("Unable to unlink paragraph", reason))
                .finally(() => Helpers.hideSpinner());
        }

        private getTriggerAncestor() {
            const siblings = Array.from(this.element.parentElement.children).filter(n => n !== this.element);
            const columnSiblings = siblings.filter(n => n.classList.contains("dw-gridcolumn"));
            const shouldStartWithParent = siblings.length > 0 && columnSiblings.length === 0;
            let candidate = shouldStartWithParent ? this.element.parentElement : this.element;
            while (candidate.parentElement.children.length === 1 && candidate.parentElement !== this.row.element) {
                candidate = candidate.parentElement;
            }
            return candidate;
        }
        private setPlaceholder() {
            this.element.style.minHeight = '60px';
            this.element.style.height = '100%';
            this.element.style.width = '100%';
            this.element.style.display = 'inline-block';
            this.element.style.backgroundColor = 'rgba(256, 256, 256, 0.3)';
            this.element.style.boxSizing = "border-box";
            this.element.style.border = "1px dashed #bdbdbd";
            this.element.style.position = "relative";
            this.element.title = Helpers.getTranslation("Drop column here");

            const columnPlaceholderIcon = Helpers.elementFactory("img") as HTMLImageElement;
            columnPlaceholderIcon.style.width = "42px";
            columnPlaceholderIcon.style.height = "42px";
            columnPlaceholderIcon.style.left = 'calc(50% - 21px)';
            columnPlaceholderIcon.style.top = 'calc(50% - 21px)';
            columnPlaceholderIcon.style.position = "absolute";
            columnPlaceholderIcon.src = "/Admin/Public/plus.svg";
            this.element.appendChild(columnPlaceholderIcon);
        }
        private setupOverlay() {
            const overlay = new ColumnOverlay(this);
            this.overlay = overlay;

            this.trigger.onmouseover = () => {
                if (!state.dragging.source) {
                    if (this.isPlaceholder) this.element.style.border = "";
                    overlay.show();
                }
            };
            this.trigger.onmouseout = () => {
                if (this.isPlaceholder) this.element.style.border = "1px dashed #bdbdbd";
                overlay.hide();
            }
        }
        private setupDragAndDrop() {
            var referenceCounter = 0; //https://stackoverflow.com/questions/7110353/html5-dragleave-fired-when-hovering-a-child-element

            if (!this.isPlaceholder) {
                this.overlay.dragHandle.draggable = true;

                this.overlay.dragHandle.ondragstart = (e) => {
                    state.dragging.source = this;
                    this.row.rowOverlay.hide();
                    this.overlay.element.style.opacity = '0';

                    e.dataTransfer.setDragImage(this.element, 10, 10);
                    e.dataTransfer.effectAllowed = "move";
                };

                this.overlay.dragHandle.ondragend = (e) => {
                    e.preventDefault();
                    const previousColumn = state.dragging.target as GridColumn;
                    if (previousColumn && previousColumn.columnOverlay) previousColumn.columnOverlay.clearDropTarget();

                    this.overlay.element.style.opacity = '1';
                    state.dragging.reset();
                };
            }

            this.trigger.ondragenter = (e) => {
                e.preventDefault();

                const isNewColumnSource = state.dragging.source.type === NewColumnType.type;
                const isOtherColumnSource = state.dragging.source.type === GridColumn.type;

                if (isNewColumnSource || isOtherColumnSource) {
                    e.stopPropagation();
                    referenceCounter++;

                    state.dragging.target = state.dragging.target || this;
                    if (state.dragging.target !== this) {
                        const previousColumn = state.dragging.target as GridColumn;
                        previousColumn.hideDropTarget();
                        state.dragging.target = this;
                    }

                    if (isNewColumnSource && this.isPlaceholder) {
                        if (this.shouldShowDropTarget(e)) this.showDropTarget(e, true);
                    } else if (isOtherColumnSource && state.dragging.source !== this) {
                        const draggedColumn = state.dragging.source as GridColumn;
                        const isSameRow = draggedColumn.row === this.row;

                        if ((isSameRow || this.isPlaceholder) && this.shouldShowDropTarget(e)) {
                            this.showDropTarget(e, !isSameRow && this.isPlaceholder);
                        }
                    }
                }
            };

            this.trigger.ondragover = (e) => {
                e.preventDefault();

                const isNewColumnSource = state.dragging.source.type === NewColumnType.type;
                const isOtherColumnSource = state.dragging.source.type === GridColumn.type;

                if (isNewColumnSource || isOtherColumnSource) {
                    e.stopPropagation();

                    let activate = false;
                    let shouldReplace = false;
                    if (isNewColumnSource && this.isPlaceholder) {
                        activate = true;
                        shouldReplace = true;
                    } else if (isOtherColumnSource && state.dragging.source !== this) {
                        const draggedColumn = state.dragging.source as GridColumn;
                        const isSameRow = draggedColumn.row === this.row;

                        activate = isSameRow || this.isPlaceholder;
                        shouldReplace = !isSameRow && this.isPlaceholder;
                    }
                    if (activate && this.shouldShowDropTarget(e)) {
                        e.dataTransfer.dropEffect = "move";
                        this.showDropTarget(e, shouldReplace);
                    } else {
                        e.dataTransfer.dropEffect = "none";
                    }
                }
            };

            this.trigger.ondragleave = (e) => {
                e.preventDefault();

                const isNewColumnSource = state.dragging.source.type === NewColumnType.type;
                const isOtherColumnSource = state.dragging.source.type === GridColumn.type;

                if (isNewColumnSource || isOtherColumnSource) {
                    e.stopPropagation();
                    referenceCounter--;

                    if (referenceCounter === 0) {
                        this.hideDropTarget();
                    }
                }
            }

            this.trigger.ondrop = (e) => {
                e.preventDefault();

                const isNewColumnSource = state.dragging.source.type === NewColumnType.type;
                const isOtherColumnSource = state.dragging.source.type === GridColumn.type;

                if (isNewColumnSource || isOtherColumnSource) {
                    e.stopPropagation();

                    if (isNewColumnSource) {
                        Helpers.showSpinner();

                        const newColumnType = state.dragging.source as NewColumnType;
                        const frame = document.getElementById('dlgEditParagraphFrame') as HTMLIFrameElement;
                        frame.onload = () => {
                            const frameWindow = frame.contentWindow as ParagraphFrameWindow;
                            newColumnType.createColumn(frameWindow);

                            frame.onload = () => { };

                            Helpers.hideSpinner();
                            if (newColumnType.creationType === "template") {
                                Helpers.reloadEditor();
                            } else {
                                dialog.get_cancelButton('dlgEditParagraph').style.display = "none";
                                dialog.show('dlgEditParagraph');
                            }
                        };
                        frame.src = `ParagraphEdit.aspx?ID=${this.paragraphId}&PageId=${this.row.grid.pageId}&Row=${this.row.id}&Column=${this.columnPosition}&VisualEditor=true`;
                    } else {
                        const draggedColumn = state.dragging.source as GridColumn;
                        const isSameRow = draggedColumn.row === this.row;

                        const source = state.dragging.source as GridColumn;
                        const target = state.dragging.target as GridColumn;

                        if (isSameRow) {
                            const row = source.row;
                            const dropPosition = this.getDropPosition(e);

                            const sourceIndex = row.columns.indexOf(source);
                            let targetIndex = row.columns.indexOf(target);
                            if (sourceIndex > targetIndex) {
                                targetIndex += dropPosition === "left" ? 0 : 1;
                            } else {
                                targetIndex += dropPosition === "left" ? -1 : 0;
                            }

                            Helpers.reorderItems(row.columns, sourceIndex, targetIndex);
                        } else {
                            const sourceRow = source.row;
                            const targetRow = target.row;

                            sourceRow.replaceColumn(source, target);
                            targetRow.replaceColumn(target, source);
                        }

                        this.row.grid.persistNewRowAndColumnOrder()
                            .then(resp => {
                                if (resp.ok) Helpers.reloadEditor();
                                else return Promise.reject(`Unable to save new column order. Reason: ${resp.status} - ${resp.statusText}. Undoing changes...`);
                            })
                            .catch(reason => Helpers.error(reason))
                            .finally(() => Helpers.hideSpinner());
                    }
                }
            };
        }
        private shouldShowDropTarget(e: DragEvent) {
            const sourceColumn = state.dragging.source as GridColumn;
            const indexOfSource = this.row.columns.indexOf(sourceColumn);
            const indexOfThis = this.row.columns.indexOf(this);
            const dropPosition = this.getDropPosition(e);
            const showDropTarget =
                !(indexOfThis === indexOfSource - 1 && dropPosition === "right") &&
                !(indexOfThis === indexOfSource + 1 && dropPosition === "left");

            return showDropTarget;
        }
        private showDropTarget(e: DragEvent, shouldReplace: boolean) {
            let position: "left" | "right" | "replace" = "replace";
            if (!shouldReplace) {
                position = this.getDropPosition(e);
            }
            this.overlay.showDropTarget(position);
        }
        private hideDropTarget() {
            this.overlay.clearDropTarget();
        }
        private getDropPosition(e: DragEvent): "left" | "right" {
            const rect = this.element.getBoundingClientRect();
            const limit = Math.min(rect.width / 2, 150);
            const distanceLeft = Math.abs(rect.left - e.clientX);
            const dropLeft = distanceLeft < limit;

            return dropLeft ? "left" : "right";
        }
    }

    class RowOverlay implements IElementComponent {
        constructor(row: GridRow) {
            this.row = row;

            const dragHandle = this.createDragHandle();
            const toolbar = this.createRowToolbar(dragHandle);
            const element = this.createOverlay(toolbar);
            this.dragHandle = dragHandle;
            this.toolbar = toolbar;
            this.element = element;
        }

        readonly element: HTMLElement;
        readonly dragHandle: HTMLElement;

        private readonly toolbar: HTMLElement;
        private readonly row: GridRow;

        show() {
            this.setDimensions();
            this.element.style.display = "block";
        };
        hide() {
            this.element.style.display = "none";
        };
        showDropTarget(position: "above" | "below") {
            this.toolbar.style.display = "none";
            this.element.style.border = "";
            if (position === "above") {
                this.element.style.borderTop = "2px solid #0084ca";
            } else {
                this.element.style.borderBottom = "2px solid #0084ca";
            }
            this.show();
        };
        clearDropTarget() {
            this.toolbar.style.display = "block";
            this.element.style.borderTop = "";
            this.element.style.borderBottom = "";
            this.element.style.border = "2px solid #0084CA";
            this.hide();
        };

        private setDimensions() {
            let { top, height, width } = this.row.element.getBoundingClientRect();
            const { position } = state.contentFrame.contentWindow.getComputedStyle(this.row.element);
            if (position !== "relative") {
                this.element.style.top = `${this.row.element.offsetTop}px`;
                this.element.style.left = `${this.row.element.offsetLeft}px`;
                this.element.style.width = `${width}px`;
                this.element.style.height = `${height}px`;
                top = this.row.element.offsetTop;
            }
            this.toolbar.style.top = 0 <= top && top < 38 ? `0px` : `-38px`;
        }
        private createDragHandle() {
            const dragHandleTitle = Helpers.getTranslation("Drag this");
            const dragHandle = Helpers.createButton("<img src='/Admin/Public/Dragger.svg' style='height: 28px; width: 28px; display: table;'>", dragHandleTitle, () => { });
            dragHandle.style.cursor = 'grab';
            return dragHandle;
        };
        private createRowToolbar(dragHandle: HTMLElement) {
            let buttonsCount = 2;

            const toolbar = Helpers.elementFactory("dw-row-toolbar");
            toolbar.style.display = 'block';
            toolbar.style.zIndex = `${zIndexMaxValue - 1}`; // Max value (minus 1) for z-index in modern browsers - to make sure the overlay floats to the top.
            toolbar.style.height = '40px';
            toolbar.style.position = 'absolute';
            toolbar.style.top = '-38px';
            toolbar.style.pointerEvents = 'auto';

            if (dragHandle && !state.isMobile) {
                toolbar.appendChild(dragHandle);
                buttonsCount++;
            }
            const editRowButtonTitle = Helpers.getTranslation("Edit row");
            const editRowButton = Helpers.createButton("<img src='/Admin/Public/pen.svg' style='height: 28px; width: 22px; display: table'>", editRowButtonTitle, () => this.row.editRow());
            toolbar.appendChild(editRowButton);

            if (this.row.hasPublicationPeriod) {
                const publicationIconTitle = Helpers.getTranslation("Publication period");
                const publicationIcon = Helpers.createToolbarIcon("<div style='height: 28px; width: 12px'><img src='/Admin/Public/PublicationPeriod.svg' style='position: relative;top: 50%;transform: translateY(-50%);display: table;max-width: 100%;'></div>", publicationIconTitle);
                toolbar.appendChild(publicationIcon);
            }
            if (this.row.hideForDesktops) {
                const hideForDesktopsIconTitle = Helpers.getTranslation("Hidden for desktops");
                const hideForDesktopsIcon = Helpers.createToolbarIcon("<div style='height: 28px; width: 12px'><img src='/Admin/Public/HideDesktop.svg' style='position: relative;top: 50%;transform: translateY(-50%);display: table;max-width: 100%;'></div>", hideForDesktopsIconTitle);
                toolbar.appendChild(hideForDesktopsIcon);
            }
            if (this.row.hideForPhones) {
                const hideForPhonesIconTitle = Helpers.getTranslation("Hidden for phones");
                const hideForPhonesIcon = Helpers.createToolbarIcon("<div style='height: 28px; width: 12px'><img src='/Admin/Public/HideMobile.svg' style='position: relative;top: 50%;transform: translateY(-50%);display: table;max-width: 100%;'></div>", hideForPhonesIconTitle);
                toolbar.appendChild(hideForPhonesIcon);
            }
            if (this.row.hideForTablets) {
                const hideForTabletsIconTitle = Helpers.getTranslation("Hidden for tablets");
                const hideForTabletsIcon = Helpers.createToolbarIcon("<div style='height: 28px; width: 12px'><img src='/Admin/Public/HideTablet.svg' style='position: relative;top: 50%;transform: translateY(-50%);display: table;max-width: 100%;'></div>", hideForTabletsIconTitle);
                toolbar.appendChild(hideForTabletsIcon);
            }

            if (this.row.hasContent && state.isAdmin && !state.isMobile) {
                const saveTemplateRowTitle = Helpers.getTranslation("Save row as template");
                const saveTemplateRowButton = Helpers.createButton("<img src='/Admin/Public/file-download.svg' style='height: 28px; width: 22px; display: table'>", saveTemplateRowTitle, () => this.row.saveRowAsTemplate());
                toolbar.appendChild(saveTemplateRowButton);
                buttonsCount++;
            }

            const deleteRowButtonTitle = Helpers.getTranslation("Delete row");
            const deleteRowButton = Helpers.createButton("<img src='/Admin/Public/trash-alt.svg' style='height: 28px; width: 28px; display: table'>", deleteRowButtonTitle, () => this.row.deleteRow());
            toolbar.appendChild(deleteRowButton);

            toolbar.style.left = 'calc(50% - ' + (buttonsCount * 36) / 2 + 'px)';

            return toolbar;
        };
        private createOverlay(toolbar: HTMLElement) {
            const overlay = Helpers.elementFactory("dw-row-overlay");
            overlay.style.border = "2px solid #0084CA";
            overlay.style.boxSizing = "border-box";
            overlay.style.display = 'none';
            overlay.style.position = 'absolute';
            overlay.style.pointerEvents = "none";
            overlay.style.width = "100%";
            overlay.style.height = "100%";
            overlay.style.zIndex = `${zIndexMaxValue - 2}`; // Max value (minus 2) for z-index in modern browsers - to make sure the overlay floats to the top.
            overlay.draggable = false;

            if (toolbar) {
                overlay.appendChild(toolbar);
            }

            return overlay;
        };
    }

    class ColumnOverlay implements IElementComponent {
        constructor(column: GridColumn) {
            this.column = column;

            const dragHandle = this.column.isPlaceholder ? null : this.createDragHandle();
            const toolbar = this.createColumnToolbar(dragHandle);
            const element = this.createOverlay(toolbar);
            this.dragHandle = dragHandle;
            this.toolbar = toolbar;
            this.element = element;

            state.contentFrame.contentWindow.document.body.appendChild(element);

            this.createDropTargets();
        }

        readonly element: HTMLElement;
        readonly dragHandle: HTMLElement;

        private readonly toolbar: HTMLElement;
        private readonly column: GridColumn;
        private leftDropMarker: HTMLElement;
        private rightDropMarker: HTMLElement;

        show() {
            this.setDimensions();
            this.element.style.display = "block";
        };
        hide() {
            this.element.style.display = "none";
        };
        showDropTarget(position: "left" | "right" | "replace") {
            this.leftDropMarker.style.display = "none";
            this.rightDropMarker.style.display = "none";
            this.setDimensions();

            if (position === "replace") {
                this.toolbar.style.display = "none";
                this.show();
            } else if (position === "left") {
                this.leftDropMarker.style.display = "block";
            } else {
                this.rightDropMarker.style.display = "block";
            }
        };
        clearDropTarget() {
            this.toolbar.style.display = "block";
            this.leftDropMarker.style.display = "none";
            this.rightDropMarker.style.display = "none";
            this.hide();
        }

        private setDimensions() {
            const { pageXOffset, pageYOffset } = state.contentFrame.contentWindow;
            const box = (this.column.isPlaceholder ? this.column.element : this.column.trigger).getBoundingClientRect();
            const left = box.left + pageXOffset;
            const margin = this.column.isPlaceholder || box.height < 80 ? 0 : 8;
            this.element.style.top = `${box.top + pageYOffset + margin}px`;
            this.element.style.left = `${left + margin}px`;
            this.element.style.height = `${box.height - margin * 2}px`;
            this.element.style.width = `${box.width - margin * 2}px`;

            const rowBox = this.column.row.element.getBoundingClientRect();
            const [top, height] = [rowBox.top + pageYOffset, rowBox.height];
            this.leftDropMarker.style.top = `${top}px`;
            this.leftDropMarker.style.left = `${left}px`;
            this.leftDropMarker.style.height = `${height}px`;
            this.rightDropMarker.style.top = `${top}px`;
            this.rightDropMarker.style.left = `${left + box.width - 1}px`;
            this.rightDropMarker.style.height = `${height}px`;
        }
        private createDragHandle() {
            const dragHandleTitle = Helpers.getTranslation("Drag this");
            const dragHandle = Helpers.createButton("<img src='/Admin/Public/Dragger.svg' style='height: 28px; width: 28px'>", dragHandleTitle, () => { });
            dragHandle.style.cursor = 'grab';
            return dragHandle;
        };
        private createColumnToolbar(dragHandle: HTMLElement) {
            const toolbar = Helpers.elementFactory("dw-column-toolbar");
            toolbar.style.display = 'block';
            toolbar.style.zIndex = `${zIndexMaxValue - 1}`; // Max value (minus 1) for z-index in modern browsers - to make sure the overlay floats to the top.
            toolbar.style.height = '40px';
            toolbar.style.position = 'absolute';
            toolbar.style.top = '-2px';
            toolbar.style.right = '-2px';
            toolbar.style.pointerEvents = 'auto';

            if (this.column.isPlaceholder) {
                if (state.isAdmin && !state.isMobile) {
                    const linkColumnButtonTitle = Helpers.getTranslation("Link paragraph");
                    const linkColumnButton = Helpers.createButton("<img src='/Admin/Public/link.svg' style='height: 28px; width: 22px'>", linkColumnButtonTitle, () => this.column.linkContent());
                    toolbar.appendChild(linkColumnButton);
                }
            } else {
                if (dragHandle && !state.isMobile) {
                    toolbar.appendChild(dragHandle);
                }
                const editColumnButtonTitle = Helpers.getTranslation("Edit column");
                const editColumnButton = Helpers.createButton("<img src='/Admin/Public/pen.svg' style='height: 28px; width: 22px'>", editColumnButtonTitle, () => this.column.editColumn());
                toolbar.appendChild(editColumnButton);

                if (state.isAdmin && !state.isMobile) {
                    const saveTemplateColumnTitle = Helpers.getTranslation("Save column as template");
                    const saveTemplateColumnButton = Helpers.createButton("<img src='/Admin/Public/file-download.svg' style='height: 28px; width: 22px'>", saveTemplateColumnTitle, () => this.column.saveColumnAsTemplate());
                    toolbar.appendChild(saveTemplateColumnButton);

                    const linkColumnButtonTitle = Helpers.getTranslation("Unlink paragraph");
                    const linkColumnButton = Helpers.createButton("<img src='/Admin/Public/unlink.svg' style='height: 28px; width: 22px'>", linkColumnButtonTitle, () => this.column.unlinkContent());
                    toolbar.appendChild(linkColumnButton);
                }

                const deleteColumnTitle = Helpers.getTranslation("Delete column");
                const deleteColumnButton = Helpers.createButton("<img src='/Admin/Public/trash-alt.svg' style='height: 28px; width: 28px'>", deleteColumnTitle, () => this.column.deleteColumn());
                toolbar.appendChild(deleteColumnButton);
            }

            toolbar.onmouseover = () => {
                this.show();
                this.column.row.rowOverlay.show();
            }
            toolbar.onmouseout = () => {
                this.hide();
                this.column.row.rowOverlay.hide();
            }

            return toolbar;
        };
        private createOverlay(toolbar: HTMLElement) {
            const overlay = Helpers.elementFactory("dw-column-overlay");
            overlay.style.border = '1px dashed #0084CA';
            overlay.style.backgroundColor = "rgba(0, 133, 202, 0.12)";
            overlay.style.display = 'none';
            overlay.style.position = 'absolute';
            overlay.style.pointerEvents = 'none';
            overlay.style.zIndex = `${zIndexMaxValue - 2}`; // Max value (minus 2) for z-index in modern browsers - to make sure the overlay floats to the top.

            if (toolbar) {
                overlay.appendChild(toolbar);
            }

            return overlay;
        };

        private createDropTargets() {
            const leftMarker = Helpers.elementFactory("dw-overlay-dropmarker");
            leftMarker.style.display = "none";
            leftMarker.style.position = "absolute";
            leftMarker.style.borderLeft = "2px solid #0084CA";

            this.leftDropMarker = leftMarker;
            state.contentFrame.contentWindow.document.body.appendChild(leftMarker);

            const rightMarker = leftMarker.cloneNode(true) as HTMLElement;

            this.rightDropMarker = rightMarker;
            state.contentFrame.contentWindow.document.body.appendChild(rightMarker);

        }
    }

    class ContentBuilderToolbar {
        constructor(root: Element, pageId: number) {
            this.root = root;
            this.pageId = pageId;

            this.panels = {
                newRow: root.querySelector(".toolbar-new-row"),
                newColumn: root.querySelector(".toolbar-new-column")
            }
            this.panelTabs = {
                newRow: root.querySelector(".toolbar-tab-rows"),
                newColumn: root.querySelector(".toolbar-tab-columns"),
            };

            this.setupSearch();

            const rowsSelected = this.panelTabs.newRow.classList.contains("selected");
            const columnsSelected = this.panelTabs.newColumn.classList.contains("selected");
            this.currentPanel = rowsSelected || columnsSelected ? (rowsSelected ? "newRow" : "newColumn") : "newRow";
            this.reload();
        }

        readonly root: Element;
        readonly pageId: number;

        private rows: NewRowType[];
        private columns: NewColumnType[];
        private panels: { [K: string]: HTMLElement };
        private panelTabs: { [K: string]: HTMLElement };
        private searchInput: HTMLInputElement;
        private searchValue: string;
        private currentPanel: "newRow" | "newColumn";

        setSearchValue(value: string) {
            this.searchValue = value;
            this.searchInput.value = value;
        }
        showNewRow() {
            this.showPanel("newRow");
        }
        showNewColumn() {
            this.showPanel("newColumn");
        }
        reload() {
            this.clearToolbar();
            this.rows = [];
            this.columns = [];

            const rows = this.loadRows();
            const columns = this.loadColumns();
            Promise.all([rows, columns]).then(() => this.showPanel(this.currentPanel));
        }
        clearToolbar() {
            for (const panelType in this.panels) {
                const panel = this.panels[panelType];
                while (panel.firstChild) {
                    panel.firstChild.remove();
                }
            }
        }

        private setupSearch() {
            const input = this.root.querySelector(".toolbar-filter input#filter") as HTMLInputElement;
            input.oninput = () => {
                this.searchValue = input.value;
                this.filterPanel();
            }
            this.searchInput = input;
            this.searchValue = input.value;
        }
        private loadRows() {
            const rows = fetch(`ContentBuilder.aspx?ID=${this.pageId}&cmd=GetRowDefinitions`).then(resp => {
                if (resp.ok) {
                    return resp.json();
                } else {
                    Helpers.log("Unable to load type for 'New Row'", resp.status, resp.statusText);
                }
            }).then((definitionCategories: CategoryCollection<RowDefinition>) => {
                const fragment = document.createDocumentFragment();
                for (const category in definitionCategories) {
                    const definitions = definitionCategories[category];

                    const categoryWrapper = Helpers.makeElement(`<div class="category-container" style="display: none;"></div>`);
                    const categoryElement = Helpers.makeElement(`<div class="category-header">${category}</div>`);
                    categoryWrapper.appendChild(categoryElement);

                    definitions.forEach(d => {
                        const markup = `
                            <div class="toolbar-new-rowtype">
                                ${d.Image && d.Image !== '' && !d.Image.includes(`.svg`)
                                ? `<img src="/Admin/Public/GetImage.ashx?width=410&amp;height=210&amp;crop=5&amp;compression=75&amp;image=${d.Image}" class="template-image" title="${d.Name}" />`
                                : ``}
                                ${d.Image && d.Image !== '' && d.Image.includes(`.svg`)
                                ? `<img src="${d.Image}" class="template-image" title="${d.Name}" />`
                                : ``}
                                ${d.Name !== '' && d.Image == ''
                                ? `<div>${d.Name}</div>`
                                : ``}
                            </div>
                        `;
                        const newRowElement = Helpers.makeElement(markup);

                        categoryWrapper.appendChild(newRowElement);

                        this.rows.push(new NewRowType(newRowElement, d));
                    });

                    fragment.appendChild(categoryWrapper);
                }

                this.panels.newRow.appendChild(fragment);

            }).catch(reason => Helpers.log("Unable to get new row types", reason));

            return rows;
        }
        private loadColumns() {
            const columns = fetch(`ContentBuilder.aspx?ID=${this.pageId}&cmd=GetColumnDefinitions`).then(resp => {
                if (resp.ok) {
                    return resp.json();
                } else {
                    Helpers.log("Unable to load type for 'New Columns'", resp.status, resp.statusText);
                }
            }).then((definitionCategories: CategoryCollection<ColumnDefinition>) => {
                const fragment = document.createDocumentFragment();
                for (const category in definitionCategories) {
                    const definitions = definitionCategories[category];

                    const categoryWrapper = Helpers.makeElement(`<div class="category-container" style="display: none;"></div>`);
                    const categoryElement = Helpers.makeElement(`<div class="category-header">${category}</div>`);
                    categoryWrapper.appendChild(categoryElement);

                    definitions.forEach(d => {
                        const iconOrImage = d.Image
                            ? `<img src="/Admin/Public/GetImage.ashx?width=410&amp;height=210&amp;crop=5&amp;compression=75&amp;image=${d.Image}" class="template-image" title="${d.Name}" />`
                            : `<span class="large-icon">${d.Icon}</span>`;
                        const markup = `
                            <div class="paragraph-type" title="${d.Name}">
                                ${iconOrImage}  
                                ${d.Name !== '' && iconOrImage == ''
                                ? `<div>${d.Name}</div>`
                                : ``}
                                ${d.Description !== '' && iconOrImage == ''
                                ? `<div class="description"><small>${d.Description}</small></div>`
                                : ``}
                            </div>`;
                        const newColumnElement = Helpers.makeElement(markup);

                        categoryWrapper.appendChild(newColumnElement);

                        this.columns.push(new NewColumnType(newColumnElement, d))
                    });

                    fragment.appendChild(categoryWrapper);
                }

                this.panels.newColumn.appendChild(fragment);

            }).catch(reason => Helpers.log("Unable to get new column types", reason));

            return columns;
        }

        private filterPanel() {
            const elements: { element: HTMLElement, contentText: string }[] = this.currentPanel === "newColumn" ? this.columns : this.rows;
            elements.forEach(e => {
                const searchText = this.searchValue.toLowerCase();

                const categoryContainer = e.element.closest('.category-container');
                const categoryName = categoryContainer.querySelector('.category-header').innerHTML.toLowerCase();

                e.element.style.display = categoryName.includes(searchText) || e.contentText.includes(searchText) ? "block" : "none";
            });

            const elementSelector = this.currentPanel === "newColumn" ? ".paragraph-type" : ".toolbar-new-rowtype";
            this.panels[this.currentPanel].querySelectorAll<HTMLElement>('.category-container').forEach(container => {
                const allElementsHidden = !Array.from(container.querySelectorAll<HTMLElement>(elementSelector)).some(element => element.style.display === "block");
                container.style.display = allElementsHidden ? "none" : "block";
            });
        }
        private showPanel(panel: "newRow" | "newColumn") {
            for (const panelType in this.panels) {
                const element = this.panels[panelType];
                const tab = this.panelTabs[panelType];
                const isMatch = panel === panelType;

                element.style.display = isMatch ? "block" : "none";

                const tabClassHandler = isMatch ? (cssClass: string) => tab.classList.add(cssClass) : (cssClass: string) => tab.classList.remove(cssClass);
                tabClassHandler("selected");
            }
            if (this.currentPanel !== panel) {
                this.setSearchValue("");
            }
            this.currentPanel = panel;
            this.filterPanel();
        };
    }

    class NewRowType implements IDragElement {
        constructor(element: HTMLElement, definition: RowDefinition) {
            this.element = element;
            this.type = NewRowType.type;
            this.definitionId = definition.Id;
            this.isTemplate = definition.IsTemplate;

            this.contentText = `${definition.Description} ${definition.Image} ${definition.Name}`.toLowerCase();

            this.setupDragAndDrop();
        }

        public static type: string = "NewRowType";

        element: HTMLElement;
        contentText: string;
        definitionId: string;
        type: string;
        readonly isTemplate: boolean;

        private setupDragAndDrop() {
            this.element.draggable = true;
            this.element.ondragstart = (e) => {
                e.dataTransfer.effectAllowed = "move";

                state.dragging.source = this;
                state.grids.forEach(grid => {
                    if (grid.rows.length === 0) {
                        grid.rowPlaceholders.forEach(row => { row.element.style.display = "block"; });
                    }
                })
            };
            this.element.ondragend = (e) => {
                e.preventDefault();
                e.stopPropagation();
                state.dragging.reset();

                state.grids.forEach(grid => {
                    if (grid.rows.length === 0) {
                        grid.rowPlaceholders.forEach(row => { row.element.style.display = "none"; });
                    } else {
                        grid.rows.forEach(r => {
                            const overlay = r.rowOverlay;
                            overlay.clearDropTarget();
                        });
                    }
                })
            }
        };
    }

    class NewColumnType implements IDragElement {
        constructor(element: HTMLElement, definition: ColumnDefinition) {
            this.element = element;
            this.type = NewColumnType.type;
            this.creationType = definition.IsTemplate ? "template" : definition.IsItemBased ? "item" : "new";
            this.creationArgument = definition.IsTemplate ? parseInt(definition.Id) : definition.Id;

            this.contentText = `${definition.Description} ${definition.Image} ${definition.Name}`.toLowerCase();

            this.setupDragAndDrop();
        }

        public static type: string = "NewColumnType";

        element: HTMLElement;
        contentText: string;
        type: string;

        creationType: "new" | "item" | "template";
        private creationArgument: string | number;

        createColumn(window: ParagraphFrameWindow) {
            let creationStarted = false;
            if (this.creationType === "new") {
                window.Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraph('0');
                creationStarted = true;
            } else if (this.creationType === "item") {
                window.Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraph(this.creationArgument);
                creationStarted = true;
            } else if (this.creationType === "template") {
                window.Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraph(null, this.creationArgument);
                creationStarted = true;
            }

            if (creationStarted) {
                const nameField = window.document.querySelector("#ParagraphName") as HTMLInputElement;
                nameField.value = "New column";
                window.Dynamicweb.Items.ParagraphTypeSelect.get_current().newParagraphSubmit();
            }
        }

        private setupDragAndDrop() {
            this.element.draggable = true;
            this.element.ondragstart = (e) => { state.dragging.source = this; }
            this.element.ondragend = (e) => {
                e.preventDefault();
                e.stopPropagation();

                const previousColumn = state.dragging.target as GridColumn;
                previousColumn.columnOverlay.clearDropTarget();

                state.dragging.reset();
            }
        }
    }
    //#endregion

    //#region State and Helpers
    class State {
        constructor() {
            this.dragging = {
                source: null,
                target: null,
                reset: () => {
                    this.dragging.source = null;
                    this.dragging.target = null;
                }
            };
            this.grids = [];
        }
        grids: Grid[];
        dragging: {
            source: IDragElement;
            target: IDragElement;
            reset: () => void;
        };
        toolbar: ContentBuilderToolbar;
        contentFrame: HTMLIFrameElement;
        debug: boolean = true;
        isMobile: boolean;
        isAdmin: boolean;
        translations: { [K: string]: string } = {};
    }

    class Helpers {
        public static getSiblings = (elm: HTMLElement, end: string, filter?: string) => {
            const siblings = [];
            let candidate = elm.nextElementSibling;

            while (candidate) {
                if (candidate.matches(end)) break;
                if (filter && candidate.matches(filter) || !filter) {
                    siblings.push(candidate);
                }
                candidate = candidate.nextElementSibling;
            }

            return siblings;
        };
        public static getTranslation = (text: string) => state.translations[text] || text;
        public static reloadEditor = () => state.contentFrame.contentWindow.location.reload(true);
        public static makeElement = (markup: string): HTMLElement => {
            const fragment = document.createRange().createContextualFragment(markup);
            const element = fragment.firstElementChild as HTMLElement;
            return element;
        };
        public static elementFactory: (elementType: string) => HTMLElement;
        public static createButton = (text: string, title: string, action: Function) => {
            const button = Helpers.elementFactory("dw-toolbar-button");

            button.title = title;
            button.innerHTML = text;
            button.onclick = (e) => {
                e.preventDefault();
                e.stopPropagation();
                action();
            }

            button.style.display = "inline-block";
            button.style.backgroundColor = "#414141";
            button.style.border = "none";
            button.style.padding = "5px";
            button.style.cursor = "pointer";
            button.style.boxSizing = "content-box";

            button.onmouseenter = () => button.style.backgroundColor = "#757575";
            button.onmouseleave = () => button.style.backgroundColor = "#414141";

            return button;
        };
        public static createToolbarIcon = (text: string, title: string) => {
            const button = Helpers.elementFactory("dw-toolbar-button");

            button.title = title;
            button.innerHTML = text;

            button.style.display = "inline-block";
            button.style.backgroundColor = "#757575";
            button.style.border = "none";
            button.style.padding = "5px";
            button.style.boxSizing = "content-box";

            return button;
        };
        public static reorderItems = (collection: IDragElement[], source: IDragElement | number, target: IDragElement | number) => {
            const swapItems = (startIndex: number, completionPredicate: (idx: number) => boolean, nextIndexCalculator: (idx: number) => number) => {
                let currentIndex = startIndex;
                while (completionPredicate(currentIndex)) {
                    const nextIndex = nextIndexCalculator(currentIndex);
                    [collection[currentIndex], collection[nextIndex]] = [collection[nextIndex], collection[currentIndex]];
                    currentIndex = nextIndex;
                }
            };

            const sourceIndex = typeof source === 'number' ? source : collection.indexOf(source);
            const targetIndex = typeof target === 'number' ? target : collection.indexOf(target);

            if (sourceIndex > targetIndex) {
                swapItems(sourceIndex, currentIndex => currentIndex > targetIndex, currentIndex => currentIndex - 1);
            } else {
                swapItems(sourceIndex, currentIndex => currentIndex < targetIndex, currentIndex => currentIndex + 1);
            }
        };
        public static showSpinner = () => showOverlay("spinner"); // Method to show the wait spinner
        public static hideSpinner = () => hideOverlay("spinner"); // Method to hide the wait spinner
        public static log = (...args: any[]) => Helpers.outputMessage("log", ...args);
        public static warn = (...args: any[]) => Helpers.outputMessage("warn", ...args);
        public static error = (...args: any[]) => Helpers.outputMessage("error", ...args);
        private static outputMessage = (outputType: "error" | "warn" | "log", ...args: any[]) => {
            if (state.debug) {
                const date = new Date();
                console[outputType](`${date.toLocaleDateString()}:${date.toLocaleTimeString()} - `, ...args);
            }
        };
    }
    //#endregion

    //#region Interfaces
    interface IDragElement {
        element: HTMLElement;
        type: string;
    }

    interface IElementComponent {
        element: HTMLElement;
    }

    interface RowDefinition {
        ColumnCount: number;
        Image: string;
        Id: string;
        Name: string;
        Description: string;
        IsTemplate: boolean;
    }

    interface CategoryCollection<T> {
        [K: string]: T[];
    }

    interface ColumnDefinition {
        IsTemplate: boolean;
        IsItemBased: boolean;
        IsStandard: boolean;
        Id: string;
        Category: string;
        Name: string;
        Description: string;
        Image: string;
        Icon: string;
    }

    interface ParagraphModel {
        Id: number;
        Name: string;
        Icon: string;
        Timestamp: string;
    }

    interface ParagraphFrameWindow extends Window {
        Save: () => boolean;
        ParagraphView: {
            switchMode: (mode: number) => void
        };
        Dynamicweb: {
            Items: {
                ParagraphTypeSelect: {
                    get_current: () => {
                        newParagraphSubmit: () => void;
                        newParagraph: (id: string | number, templateId?: string | number) => void;
                    }
                }
            }
        }
    };

    interface RowFrameWindow extends Window {
        Dynamicweb: {
            Items: {
                ItemEdit: {
                    get_current: () => {
                        save: () => boolean;
                    }
                }
            }
        }
    };
    //#endregion

    //#region Public API
    export function initializeEditor(pageId: number, isAdmin: boolean, translations: { [K: string]: string }) {
        if (parent.document !== document) {
            const navigator = parent.document.querySelector("#sidebar") as HTMLElement;
            navigator.style.display = "none";
            const container = parent.document.querySelector("#content-container") as HTMLElement;
            container.style.paddingLeft = "0px";
        }

        showOverlay("wait");

        state.translations = translations;
        state.isAdmin = isAdmin;

        const contentFrame = document.querySelector("iframe.view-port") as HTMLIFrameElement;
        contentFrame.addEventListener("load", () => {
            contentFrame.contentWindow.addEventListener("unload", () => {
                showOverlay("wait");
            });

            let didLoadGrid = false;
            const grids: Grid[] = [];

            const doc = contentFrame.contentWindow.document;
            if (doc) {
                Helpers.elementFactory = type => doc.createElement(type);
                const roots = Array.from(doc.querySelectorAll("dw-placeholder.dw-grid")) as HTMLElement[];
                roots.forEach((root) => {
                    const rowElements = Helpers.getSiblings(root, "dw-placeholder.dw-grid", ".dw-gridrow") as HTMLElement[];
                    const grid = new Grid(root, rowElements);

                    if (grid && !grid.isMissingRowDefinitions) {
                        didLoadGrid = true;
                        grids.push(grid);
                    }
                });
            }

            if (didLoadGrid) {
                state.grids = grids;

                const location = new URL(contentFrame.contentDocument.location.href.toLocaleLowerCase());
                const devicetype = location.searchParams.get("devicetype");
                state.isMobile = (devicetype == "mobile" || devicetype == "tablet");

                if (location.searchParams.has("devicetype")) {
                    // Hide Scrollbars But Keep Functionality
                    const style = doc.createElement("style") as HTMLStyleElement;
                    style.innerHTML = "html::-webkit-scrollbar { display: none; } html {-ms-overflow-style: none; }";
                    doc.head.append(style);
                }
                else {
                    const toolbarElement = document.querySelector(".toolbar");
                    state.toolbar = new ContentBuilderToolbar(toolbarElement, state.grids[0].pageId);
                }
            } else {
                if (state.toolbar) {
                    state.toolbar.clearToolbar();
                    state.toolbar = null;
                }
                state.grids = null;
            }

            hideOverlay("wait");
        });

        const contentUrl = `/Default.aspx?ID=${pageId}&visualedit=true`;
        contentFrame.src = contentUrl;
        state.contentFrame = contentFrame;
    }

    export function navigate() {
        const callback = (options: string, model: { Selected: string }) => {
            const contentFrame = document.querySelector("iframe.view-port") as HTMLIFrameElement;
            const location = new URL(contentFrame.contentDocument.location.href);
            if (location.searchParams.has("devicetype")) {
                const deviceType = location.searchParams.get("devicetype");
                contentFrame.src = `/Default.aspx?ID=${model.Selected}&visualedit=true&devicetype=${deviceType}`;
            }
            else {
                contentFrame.src = `/Default.aspx?ID=${model.Selected}&visualedit=true`;
            }
        }

        const dlgAction = createLinkDialog(linkDialogTypes.page, ['TypesPermittedForChoosing=' + linkDialogPageTypeAllowed], callback);
        Action.Execute(dlgAction);
    }

    export function showPreviewMenu() {
        const previewMenu = document.querySelector(".toolbar-preview-menu") as HTMLElement;
        previewMenu.classList.toggle("show");
        previewMenu.onmouseleave = () => showPreviewMenu();
    }

    export function showPreview(deviceType: string, width: number, height: number) {
        const location = new URL(state.contentFrame.contentDocument.location.href.toLocaleLowerCase());
        location.searchParams.delete("devicetype");

        const container = document.querySelector("#content-container") as HTMLElement;
        const contentFrame = document.querySelector("iframe.view-port") as HTMLIFrameElement;
        const rotateButton = document.querySelector("a.rotate-preview-btn") as HTMLElement;

        contentFrame.src = `${location}&devicetype=${deviceType}`;
        if (width > 0 && height > 0) {
            if (container.classList.contains('preview--rotate')) {
                contentFrame.style.width = `${height}px`;
                contentFrame.style.height = `${width}px`;
            }
            else {
                contentFrame.style.width = `${width}px`;
                contentFrame.style.height = `${height}px`;
            }
            container.classList.add("preview--mobile");
            rotateButton.classList.add("preview--mobile");
        }
        else {
            contentFrame.style.width = `100%`;
            contentFrame.style.height = `100%`;
            container.classList.remove("preview--mobile");
            rotateButton.classList.remove("preview--mobile");
        }
    }

    export function rotatePreviewFrame() {
        const contentFrame = document.querySelector("iframe.view-port") as HTMLIFrameElement;
        let frameWidth = contentFrame.style.width;
        let frameHeight = contentFrame.style.height;

        const container = document.querySelector("#content-container") as HTMLElement;
        container.classList.toggle('preview--rotate');

        contentFrame.style.width = frameHeight;
        contentFrame.style.height = frameWidth;
    }

    export function showPage() {
        const location = new URL(state.contentFrame.contentDocument.location.href);
        location.searchParams.delete("visualedit");
        location.searchParams.delete("devicetype");

        const showUrl = `${location}`;
        window.open(showUrl, "_blank");
    }

    export function saveRow() {
        Helpers.showSpinner();
        const frame = document.getElementById('dlgEditGridRowFrame') as HTMLIFrameElement;
        const frameWindow = frame.contentWindow as RowFrameWindow;

        frame.onload = () => {
            Helpers.reloadEditor();
            Helpers.hideSpinner();
        };

        const success = frameWindow.Dynamicweb.Items.ItemEdit.get_current().save();
        if (success === false) {
            // Explicitly false = validation error
            Helpers.hideSpinner();
        } else {
            dialog.hide("dlgEditGridRow");
        }
    }

    export function saveColumn() {
        Helpers.showSpinner();
        const frame = document.getElementById('dlgEditParagraphFrame') as HTMLIFrameElement;
        const frameWindow = frame.contentWindow as ParagraphFrameWindow;
        frame.onload = () => {
            Helpers.reloadEditor();
            Helpers.hideSpinner();
        };
        const success = frameWindow.Save(); // Will return false on validation error and undefined in all other cases
        if (success === false) {
            // Explicitly false = validation error
            Helpers.hideSpinner();
        } else {
            // No errors
            dialog.get_cancelButton('dlgEditParagraph').style.display = "";
            dialog.hide("dlgEditParagraph");
        }
    }

    export function saveAsTemplate() {
        const frame = document.getElementById('dlgSaveAsTemplateFrame') as HTMLIFrameElement;
        const frameWindow = frame.contentWindow;
        const doc = frameWindow.document;
        const form = doc.forms[0];
        const formData = new FormData(form);

        const templateName = doc.getElementById("TemplateName") as HTMLInputElement;
        if (!templateName.value) {
            dwGlobal.showControlErrors(templateName, Helpers.getTranslation("Required"));
            templateName.focus();
            return;
        }
        else {
            dwGlobal.hideControlErrors(templateName);
        }

        const categoryTypeNew = doc.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0] as HTMLInputElement;
        const templateCategory = (categoryTypeNew == undefined || categoryTypeNew.checked ? doc.getElementById("TemplateNewCategory") : doc.getElementById("TemplateCategory")) as HTMLInputElement;
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
        }).then((resp) => {
            if (resp.ok) {
                dialog.hide("dlgSaveAsTemplate");
                state.toolbar.reload();
            }
        })
            .catch((reason) => Helpers.log("An error occurred while saving the row template", reason))
            .finally(() => Helpers.hideSpinner());
    }

    export function saveColumnAsTemplate() {
        const frame = document.getElementById('dlgSaveColumnAsTemplateFrame') as HTMLIFrameElement;
        const frameWindow = frame.contentWindow;
        const doc = frameWindow.document;
        const form = doc.forms[0];
        const formData = new FormData(form);

        const templateName = doc.getElementById("TemplateName") as HTMLInputElement;
        if (!templateName.value) {
            dwGlobal.showControlErrors(templateName, Helpers.getTranslation("Required"));
            templateName.focus();
            return;
        }
        else {
            dwGlobal.hideControlErrors(templateName);
        }

        const categoryTypeNew = doc.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0] as HTMLInputElement;
        const templateCategory = (categoryTypeNew == undefined || categoryTypeNew.checked ? doc.getElementById("TemplateNewCategory") : doc.getElementById("TemplateCategory")) as HTMLInputElement;
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
        }).then((resp) => {
            if (resp.ok) {
                dialog.hide("dlgSaveColumnAsTemplate");
                state.toolbar.reload();
            }
        })
            .catch((reason) => Helpers.log("An error occurred while saving the column template", reason))
            .finally(() => Helpers.hideSpinner());
    }

    export function switchColumnEditMode(mode: number) {
        const frame = document.getElementById('dlgEditParagraphFrame') as HTMLIFrameElement;
        const frameWindow = frame.contentWindow as ParagraphFrameWindow;
        frameWindow.ParagraphView.switchMode(mode);
    }

    export function showRowSelector() {
        if (state.toolbar) {
            state.toolbar.showNewRow();
        }
    }

    export function showColumnSelector() {
        if (state.toolbar) {
            state.toolbar.showNewColumn();
        }
    }

    export function popEditorOut() {
        window.open(`${location.href}&popout=true`, "_blank");
    }

    export function closeVisualEditor() {
        const restoreTree = () => {
            if (parent.document !== document) {
                const navigator = parent.document.querySelector("#sidebar") as HTMLElement;
                navigator.style.display = null;
                const container = parent.document.querySelector("#content-container") as HTMLElement;
                container.style.paddingLeft = null;
            }
            window.removeEventListener("unload", restoreTree);
        }

        if (state.grids && state.grids.length > 0) {
            Helpers.showSpinner();

            window.addEventListener("unload", restoreTree);
            location.href = `/Admin/Content/ParagraphList.aspx?PageID=${state.grids[0].pageId}&NavigatorSync=RefreshParentAndSelectPage`;
        } else {
            //TODO: Figure out how to redirect to content tree without page id.
        }
    }
    //#endregion

    //#region Constants and definitions
    const zIndexMaxValue: number = 2147483638; // The max value of z-index in modern browsers
    const state: State = new State();
    const linkDialogTypes = {
        page: 0,
        paragraph: 1
    };
    const linkDialogPageTypeAllowed: number = 6;

    declare function showOverlay(id: string): void;
    declare function hideOverlay(id: string): void;
    declare const dialog: {
        show: (id: string) => void;
        hide: (id: string) => void;
        setTitle: (id: string, title: string) => void;
        get_cancelButton: (id: string) => HTMLElement;
    };
    declare const dwGlobal: {
        showControlErrors: (ctrl: HTMLInputElement, msg: string) => void;
        hideControlErrors: (ctrl: HTMLInputElement) => void;
        getContentNavigator: () => {
            reload: () => void;
        };
    };
    declare const Action: {
        Execute: (action: object) => void;
    }
    declare function createLinkDialog(dialogType: number, queryStringParams: string[], afterSelectCallback: (options: string, model: { Selected: string, ParagraphID: string }) => void): object;
    //#endregion

}
