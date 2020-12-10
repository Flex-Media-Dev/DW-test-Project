function EditTopFolder(opts) {

    var options = opts;
    var folderNameEl = document.getElementById("txtFolderName");
    // private api
    var validate = function () {
        if (folderNameEl && !folderNameEl.value) {
            dwGlobal.showControlErrors(folderNameEl, options.labels.emptyName);
            folderNameEl.focus();
            return false;
        }
        return true;
    };


    // public api
    var api = {
        init: function() {
            // init
            if (folderNameEl) {
                folderNameEl.focus();
            }
            var self = this;
            document.forms[0].addEventListener("keydown", function (e) {
                if (e.keyCode == 13) {
                    var srcElement = e.srcElement ? e.srcElement : e.target;
                    if (srcElement.type != 'textarea') {
                        self.save();
                        e.preventDefault();
                    }
                }
            });
        },
        help: showHelp,

        cancel: function () {
            Action.Execute(options.actions.cancel);
        },

        save: function (close) {
            if (validate()) {
                document.getElementById('CloseOnSave').value = (!!close).toString();
                document.getElementById('cmdSubmit').click();
            }
        }
    };
    api.init();
    return api;
}
