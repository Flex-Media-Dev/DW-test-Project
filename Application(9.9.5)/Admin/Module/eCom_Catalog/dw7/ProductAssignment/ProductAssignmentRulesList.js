function createAssignmentRuleListPage(opts) {
    var obj = {
        init: function (opts) {
            this.options = opts;
        },
        confirmDeleteAssignmentRules: function (evt, rowID) {
            evt.stopPropagation();
            var self = this;
            var ids = window.List.getSelectedRows(this.options.ids.list);
            var row = null;
            var confirmStr = "";
            var assignmentRuleIds = [];
            if (rowID) {
                row = window.List.getRowByID(this.options.ids.list, 'row' + rowID);
                if (row) {
                    confirmStr = row.children[0].innerText ? row.children[0].innerText : row.children[0].innerHTML;
                    confirmStr = confirmStr.replace('&nbsp;', "");
                    confirmStr = confirmStr.replace('&qout;', "");
                    assignmentRuleIds.push(row.getAttribute("itemid"));
                }
            }
            confirmStr = "\'" + confirmStr + "\'";
            Action.Execute(this.options.actions.delete, {
                ids: assignmentRuleIds,
                names: confirmStr
            });
        },

        createAssignmentRule: function () {
            Action.Execute(this.options.actions.edit, { assignmentRuleId: "" });
        },

        editAssignmentRule: function (evt, assignmentRuleId) {
            Action.Execute(this.options.actions.edit, { assignmentRuleId: assignmentRuleId });
        }
    };
    obj.init(opts);
    return obj;
}
