window.onresize = resizeContent;

function getCaller() {
    var ret = null;

    /* Called as pop-up window */
    if (window.opener && !window.opener.closed) {
        ret = window.opener;
        /* Called from the frame */
    } else if (window.parent) {
        ret = window.parent;
    }

    return ret;
}

function submitForm(doNotClose, callback) {

    var cmd = $('cmdSaveAndClose'),
        allowSubmit = true,
        over,
        showOverlay = window.opener !== null;

    if (showOverlay) {
        over = new overlay("ParagraphEditModuleOverlay");
    }

    if (cmd)
        allowSubmit = !cmd.hasClassName('disabled');

    if (allowSubmit) {
        if (cmd) {
            cmd.addClassName('disabled');
            //Ribbon.disableButton('cmdSaveAndClose');
        }

        window["paragraphEvents"].beforeSaveInvoke();

        if (typeof (window["paragraphEvents"].validateInvoke) == 'function') {
            allowSubmit = window["paragraphEvents"].validateInvoke();
        }

        if (!!allowSubmit) {
            if (typeof (FCKeditorAPI) != 'undefined') {
                var oEditors = FCKeditorAPI.__Instances;
                for (var id in oEditors) {
                    if (id) {
                        var oEditor = FCKeditorAPI.GetInstance(id);
                        document.getElementById(id).value = oEditor.GetHTML();
                    }
                }
            }

            if (typeof CKEDITOR != "undefined") {
                var oEditors = CKEDITOR.instances;
                for (var id in oEditors) {
                    if (id) {
                        document.getElementById(id).value = CKEDITOR.instances[id].getData();
                    }
                }
            }

            $('paragraph_edit').request({
                method: 'post',
                parameters: {
                    action: 'GetModuleXML'
                },

                onCreate: function () {
                    if (showOverlay) {
                        over.show();
                    }
                },

                onComplete: function (response) {
                    var caller = getCaller();

                    if (caller) {
                        try {
                            var pid = parseInt($('ParagraphID').value);
                            var func = $('OnSettingsSaved').value;
                            var moduleName = $('ModuleSystemName').value;

                            if (func.length > 0 && typeof (caller[func]) != 'undefined')
                                caller[func](pid, moduleName, response.responseText);
                        } catch (ex) { }
                    }

                    if (!doNotClose) {
                        closeForm();
                    } else if (cmd) {
                        cmd.removeClassName('disabled');
                    }

                    if (callback) {
                        callback(response);
                    }

                    if (showOverlay) {
                        setTimeout(function () {
                            over.hide();
                        }, 150);
                    }
                }
            });
        } else if (cmd) {
            cmd.removeClassName('disabled');
        }
    }
}

function closeForm() {
    window.close();
}

function removeModule(doConfirm) {
    var callback = $('OnModuleRemoved').value;
    var caller = getCaller();

    if (callback && callback.length > 0) {
        if (caller) {
            try {
                var confirmed = false;
                if (doConfirm) {
                    confirmed = confirm($('mConfirmRemove').innerHTML)
                }
                if (!doConfirm || confirmed) {
                    // Remove the module with AJAX
                    new Ajax.Request('ParagraphEditModule.aspx?ID=' + parseInt($('ParagraphID').value) + '&action=RemoveModuleSettingsAJAX', {
                        method: 'get',
                        onSuccess: function (response) {
                            if (caller[callback](parseInt($('ParagraphID').value))) {
                                closeForm();
                            } else {
                                gotoModuleList();
                            }
                        }
                    });
                }
            } catch (ex) { }
        }
    }
}

function gotoModuleList() {
    var lnk = location.href;

    lnk = lnk.replace(/\?ParagraphModuleSystemName=([a-zA-Z0-9_]+)/gi, '');
    lnk = lnk.replace(/&ParagraphModuleSystemName=([a-zA-Z0-9_]+)/gi, '');
    lnk += '&ForceModuleSelection=True';

    location.href = lnk;
}

function resizeContent() {
    var content = document.getElementById('innerContent');
    if (content) {
        content.style.display = '';
        content.style.height = '100%';
    }
}

function initForm() {
    var link = location.href;
    var frm = null, externalField = null;
    var externalSettings = null, moduleSystemName = null;
    var caller = getCaller();

    resizeContent();
    executeOnLoad();

    externalSettings = link.match(/LoadSettingsFrom=([a-zA-Z0-9]+)/gi);
    if (externalSettings && externalSettings.length > 0) {
        if (caller) {
            try {
                externalField = caller.document.getElementById(externalSettings[0].replace('LoadSettingsFrom=', ''));
                if (externalField) {
                    frm = $('paragraph_edit');
                    $('ExternalModuleSettings').value = encodeHTML(externalField.value);
                    link = link.replace('?' + externalSettings[0], '');
                    link = link.replace('&' + externalSettings[0], '');

                    moduleSystemName = link.match(/ParagraphModuleSystemName=([^&\?]+)/gi);
                    if (moduleSystemName && moduleSystemName.length > 0) {
                        $('ExternalModuleSettingsFor').value = moduleSystemName[0].replace('ParagraphModuleSystemName=', '');
                        link = link.replace('?' + moduleSystemName[0], '');
                        link = link.replace('&' + moduleSystemName[0], '');
                    }

                    frm.action = link;
                    frm.submit();
                }
            }
            catch (ex) {
            }
        }
    }

    //add attribute for calling callback function on template saving
    $$('table tr td img[data-role="filemanager-button-edit"]').each(function (el) {
        el.writeAttribute('data-caller-reload', 'false');
    });

    // fire event when frame is loaded
    $(document).fire('shortcut:moduleLoaded');
}

function executeOnLoad() {
    var callback = $('OnLoaded').value;
    var caller = getCaller();

    if (caller && callback.length > 0) {
        if (typeof (caller[callback]) == 'function')
            caller[callback]();
    }
}

function encodeHTML(html) {
    var ret = html;

    ret = ret.replace(/&/g, '&amp;');
    ret = ret.replace(/</g, '&lt;');
    ret = ret.replace(/>/g, '&gt;');

    return ret;
}

function reloadModuleSettings() {
    if (parent.$('ParagraphModule__Frame')) {
        parent.$('ParagraphModule__Frame').src = '';
        parent.ParagraphModule.loadModule();
    }
    else {
        parent.location.href = parent.location.href;
    }
}

/* Adds if necessary and selects new element to dropdown list. Used in FileEditorV2 and Simple Editor.  */
function selectNewOption(fileName, dropdownControlId, fileExists) {

    var dropdownControl = $(dropdownControlId);

    /* Add new file to the dropdownlist */
    if (fileExists == 0 || fileExists == null) {
        dropdownControl.options[dropdownControl.options.length] = new Option(fileName, fileName);
    }

    /* Select new element */
    for (var i, j = 0; i = dropdownControl.options[j]; j++) {
        if (i.value == fileName) {
            dropdownControl.selectedIndex = j;
            break;
        }
    }

}

/* Checks if option alredy exists in the dropdown list. Used in FileEditorV2 and Simple Editor. */
function checkOption(optionName, dropdownControlId) {
    var optionExists = false;
    var dropdownControl = $(dropdownControlId);

    for (var i, j = 0; i = dropdownControl.options[j]; j++) {
        if (i.value == optionName) {
            optionExists = true;
            break;
        }
    }
    return optionExists;
}