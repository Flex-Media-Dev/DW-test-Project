function createEditMappingPage(opts) {
    let options = opts;
    let groupFieldEl = document.getElementById(options.ids.groupField);
    let queryParameterEl = document.getElementById(options.ids.queryParameter);

    let hasValue = function (el) {
        return !!el.value;
    };
    var validate = function () {
        let result = true;
        if (!hasValue(groupFieldEl)) {
            dwGlobal.showControlErrors(groupFieldEl, options.labels.emptyGroupField);
            groupFieldEl.focus();
            result = false;
        }
        else {
            dwGlobal.hideControlErrors(groupFieldEl)
        }
        if (!hasValue(queryParameterEl)) {
            dwGlobal.showControlErrors(queryParameterEl, options.labels.emptyQueryParameter);
            if (result) {
                queryParameterEl.focus();
            }
            result = false;
        }
        else {
            dwGlobal.hideControlErrors(queryParameterEl)
        }
        return result;
    };

    var obj = {
        init: function (opts) {
            this.options = opts;
        },

        save: function (close) {
            if (validate()) {
                if (close) {
                    document.getElementById('RedirectTo').value = "rule";
                }
                var cmd = document.getElementById('cmdSubmit');
                cmd.value = "Save";
                cmd.click();
            }
        },

        cancel: function () {
            Action.Execute(this.options.actions.ruleEdit);
        }
    };
    obj.init(opts);
    return obj;
}
