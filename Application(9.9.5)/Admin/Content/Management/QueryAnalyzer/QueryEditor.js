(function ($) {
    class SqlQueryEditorPage {
        constructor(opts) {
            this.options = opts;
            this.listContainerEl = document.getElementById(this.options.ids.ListContainer);
            this.numberRowsEl = document.getElementById(this.options.ids.NumberOfListRows);
            this.tableSelectorEl = document.getElementById(this.options.ids.TableSelector);
            this.historySelectorEl = document.getElementById(this.options.ids.HistorySelector);

            this.sqlEditorEl = document.getElementById(this.options.ids.SqlEditor);
            this.sqlEditor = CodeMirror.fromTextArea(this.sqlEditorEl, {
                mode: "text/x-mysql",
                tabMode: "indent",
                matchBrackets: true,
                lineNumbers: true,
                dragDrop: false
            });
            this.hideSqlEditorError();

            this.loader = new overlay('wait');
            this.loader.message('');

        }

        initPage() {
            this.historySelectorEl.dataset.allowSearch = true;
            document.addEventListener("keypress", (e) => {
                if (e.ctrlKey && (e.keyCode == 0xA || e.keyCode == 0xD)) {
                    this.tryExecuteSqlQuery();
                }
            });
            this.sqlEditor.focus();
            if (List) {
                List.gotoPage = (listID, pageIdx) => {
                    this.loader.show();
                    let queryEl = document.getElementById(this.options.ids.Query);
                    this.executeQuery(`${queryEl.value}&PageIndex=${pageIdx}`);
                }
            }
        }

        tryExecuteSqlQuery() {
            this.hideSqlEditorError();
            this.loader.show();
            let query = escape(this.sqlEditor.getValue());
            let pageSize = this.numberRowsEl.querySelector("select").value;
            $.ajax({
                type: "POST",
                url: "QueryEditor.aspx",
                data: `PageSize=${pageSize}&TestQuery=${query}`,
                datatype: "xml",
                success: (transport) => this.tryExecuteSqlQuerySuccess(transport),
                error: (transport) => {
                    this.showError(`${this.options.labels.requestError}!${transport}!`);
                }
            });
        }

        tryExecuteSqlQuerySuccess(transport) {
            var complete = false;
            if ($(transport).children("status").length > 0) {
                $(transport).find("status").each((idx, statusItem) => {
                    let status = $(statusItem).find("code").text();
                    let message = $(statusItem).find("msg").text();
                    if (status == 200) {
                        if (!isNaN(message)) {
                            if (message > 0) {//update, insert, delete
                                let msg = this.options.labels.insertUpdateDeleteConfirmationMsg;
                                if (confirm(msg.replace("{#}", message))) {
                                    complete = true;
                                }
                            }
                        }

                    }
                    else if (status == "15002") {
                        let msg = this.options.labels.status15002ConfirmationMsg;
                        if (confirm(msg)) {
                            complete = true;
                        }
                    } else {
                        let msg = this.options.labels.sqlExecutionError;
                        this.showError(`${msg}\n\n${message}`);
                    }
                    if (complete) {
                        let query = escape(this.sqlEditor.getValue());
                        this.executeQuery(query);
                    }
                });
            } else {
                this.retrieveList(transport);
            }
        }

        executeQuery(query) {
            $.ajax({
                type: "POST",
                url: "QueryEditor.aspx",
                data: "Query=" + query,
                success: (transport) => this.retrieveList(transport),
                error: (transport) => {
                    this.showError(`${this.options.labels.requestError}!${transport}!`);
                }
            });
        }

        retrieveList(listMarkup) {
            this.listContainerEl.innerHTML = `<div class="list-pane">${listMarkup}</div>`;
            let indexToRemove = -1;
            let query = this.sqlEditor.getValue();
            for (let i = 0; i < this.historySelectorEl.options.length; i++) {
                let opt = this.historySelectorEl.options[i];
                if (opt.value.toUpperCase() === query.toUpperCase()) {
                    indexToRemove = i;
                }
            }
            if (indexToRemove > -1) {
                this.historySelectorEl.remove(indexToRemove);
            }
            let opt = document.createElement("option");
            opt.value = query;
            opt.text = query;
            this.historySelectorEl.add(opt, 1);
            this.loader.hide();
    }

        hideSqlEditorError() {
            dwGlobal.hideControlErrors(this.sqlEditorEl, "");
            this.sqlEditor.setSize("100%", "240px");
        }

        showError(msg) {
            this.sqlEditor.setSize("100%", "218px");
            dwGlobal.showControlErrors("txtSql", msg);
            this.loader.hide();
        }

        changeNumberOfListRows(rowsAmountSelectorEl, data) {
            let pageIdx = 1;
            let pageSize = data.selectedValue;
            let queryEl = document.getElementById(this.options.ids.Query);
            if (queryEl) {
                this.loader.show();
                let query = queryEl.value;
                this.executeQuery(`${query}&PageIndex=${pageIdx}&PageSize=${pageSize}`);
            }
        }

        tableSelectQuery() {
            let oldQuery = this.sqlEditor.getValue().trim();
            if (!oldQuery || oldQuery == "SELECT * FROM ") {
                this.replaceQueryWithSelectedTable();
            } else {
                Action.Execute(this.options.actions.changeQueryWithTable);
            }
        }

        replaceQueryWithSelectedTable() {
            let tableName = this.tableSelectorEl.value;
            let query = "SELECT * FROM ";
            if (tableName) {
                let fields = this.options.tables[tableName];
                if (!fields) {
                    fields = "*";
                }

                if (fields.length > 100) {
                    fields = "\n  " + fields + "\n"
                }
                query = `SELECT ${fields} FROM ${tableName}`;
            }
            this.sqlEditor.setValue(query);
        }

        historySelectQuery() {
            let oldQuery = this.sqlEditor.getValue().trim();
            this.historyValue = this.historySelectorEl.value;
            this.historySelectorEl.value = '';
            if (!oldQuery || oldQuery == "SELECT * FROM") {
                this.replaceQueryWithHistoryItem();
            } else {
                Action.Execute(this.options.actions.changeQueryWithHistory);
            }
        }

        replaceQueryWithHistoryItem() {
            let query = this.historyValue;
            this.sqlEditor.setValue(query);
            this.tryExecuteSqlQuery();
        }
    };
    window.SqlQueryEditorPage = SqlQueryEditorPage;
})(jQuery);