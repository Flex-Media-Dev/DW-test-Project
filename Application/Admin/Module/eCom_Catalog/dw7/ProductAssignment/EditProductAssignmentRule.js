function createEditAssignmentRulePage(opts) {
    let options = opts;
    let assignmentRuleNameEl = document.getElementById(options.ids.name);
    let visibleEl = document.getElementById(options.ids.visible);
    let shopsSelectorStorageEl = document.getElementById(options.ids.shopsSelectorStorage);
    let queryRuleModeEl = document.querySelector(`input[name=${options.ids.ruleMode}][value=query]`);
    let queryParamsCntEl = document.getElementById(opts.ids.queryParametersContainer);
    let querySelectorEl = document.getElementById(opts.ids.querySelector);

    var hasValue = function (el) {
        return !!el.value;
    };
    var validate = function () {
        let result = true;
        if (!hasValue(assignmentRuleNameEl)) {
            dwGlobal.showControlErrors(assignmentRuleNameEl, options.labels.emptyName);
            assignmentRuleNameEl.focus();
            result = false;
        }
        if (queryRuleModeEl.checked && !hasValue(querySelectorEl)) {
            dwGlobal.showControlErrors(querySelectorEl, options.labels.emptyQuery);
            if (result) {
                querySelectorEl.focus();
            }
            result = false;
        }
        return result;
    };

    var obj = {
        init: function (opts) {
            this.options = opts;

            let ini = {
                name: assignmentRuleNameEl.value,
                isVisible: visibleEl.checked,
                shops: shopsSelectorStorageEl.value,
                isQueryMode: queryRuleModeEl.checked,
                query: querySelectorEl.value
            };
            this.options.initial = ini;

            this.deletedMappingsIds = [];
            if (ini.isQueryMode) {
                this.setQueryMode();
            }
            else {
                this.setGroupMode();
            }

            dwGrid_QueryMappingsList.onRowAdding = this.editMapping.bind(this);
            dwGrid_QueryMappingsList.onRowsDeletedCompleted = this._deleteMapping.bind(this);

        },

        editMapping: function (evt, rowEl) {
            let mappingId = rowEl ? rowEl.getAttribute("ItemId") : null;
            if (this._hasChangesOnPage()) {
                Action.Execute(this.options.actions.confirmSaveToMappingEdit, { RuleId: this.options.ruleId, MappingId: mappingId });
            }
            else {
                Action.Execute(this.options.actions.queryMappingEdit, { RuleId: this.options.ruleId, MappingId: mappingId });
            }
            return true;
        },

        _deleteMapping: function (rows) {
            for (let i = 0; i < rows.length; i++) {
                this.deletedMappingsIds.push(rows[i].element.getAttribute("ItemId"));
            }
        },

        _hasChangesOnPage: function () {
            let ini = this.options.initial;
            return !this.options.ruleId || this.deletedMappingsIds.length
                || ini.name !== assignmentRuleNameEl.value
                || ini.isVisible !== visibleEl.checked
                || ini.shops !== shopsSelectorStorageEl.value
                || ini.isQueryMode !== queryRuleModeEl.checked
                || ini.query !== querySelectorEl.value;
        },

        save: function (close, redirectToEditMapping) {
            if (validate()) {
                if (close) {
                    document.getElementById('RedirectTo').value = typeof (redirectToEditMapping) == "undefined" ? "list" : redirectToEditMapping;
                }
                let DeletedMappingsEl = document.getElementById('DeletedMappings');
                DeletedMappingsEl.value = this.deletedMappingsIds.join();
                let cmd = document.getElementById('cmdSubmit');
                cmd.value = "Save";
                cmd.click();
            }
        },

        saveBeforeEditMapping: function () {
            this.save(true, 0)
        },

        cancel: function () {
            Action.Execute(this.options.actions.list);
        },

        deleteAssignmentRule: function () {
            Action.Execute(this.options.actions.deleteAssignmentRule, { ids: this.options.ruleId });
        },

        setGroupMode: function () {
            queryParamsCntEl.style.display = "none";
        },

        setQueryMode: function () {
            queryParamsCntEl.style.display = "";
        },

        storeShops: function () {
            const shopIds = SelectionBox.getElementsRightAsArray(this.options.ids.shopSelector);
            shopsSelectorStorageEl.value = shopIds;
        },

        deleteMappingListRows: function (evt, el) {
            evt.stopPropagation();
            let row = dwGrid_QueryMappingsList.findContainingRow(el);
            dwGrid_QueryMappingsList.deleteRows([row]);
        }
    };
    obj.init(opts);
    return obj;
}