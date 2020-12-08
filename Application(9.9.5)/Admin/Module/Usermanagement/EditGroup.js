var __form_posting = false;
var confirmationMsgSelect = "";
var confirmationMsgUnSelect = "";

function request(params, callback) {
    if (!params) {
        return;
    }

    var over = new overlay('UpdatingOverlay');

    params.ID = $('GroupID').value;
    params.ParentID = $('ParentGroupID').value;
    params.IsAjax = true;

    new Ajax.Request('/Admin/module/UserManagement/EditGroup.aspx?', {
        method: 'post',
        parameters: params,
        onCreate: function () {
            over.show();
        },
        onSuccess: function(response) {
            if (callback) {
                callback(response.responseText);
            }
        },
        onFailure: function () { },
        onComplete: function () {
            setTimeout(function() {
                over.hide();
            }, 500);
        }
    });
}

/* Fires when user clicks 'Save' button */
function save(onSaved, suppresItemValidation) {
    if (buttonIsEnabled('cmdSave')) {
        validateRestrictionsAndSave(function(){
            Dynamicweb.UserManagement.ItemEditors.validateItemFields(suppresItemValidation, function (result) {
                if (result.isValid) {
                    toggleToolsGroup(false);

                    /* posting a form using AJAX */
                    __form_posting = true;

                    // Fire event to handle saving
                    window.document.fire("General:DocumentOnSave");
                    prepareRichEditors();
                    var form = $('EditGroupForm');
                    (form.onsubmit || function () { })(); // Force richeditors saving

                    $('cmd').value = 'save';
                    form.submit();
                }
            });
        });
    }    
}

function validateRestrictionsAndSave(callback) {
    var nameTextBox = $('GroupName');
    if (!nameTextBox || nameTextBox.disabled) {
        $('InfoBar_GroupNameFieldMissedMessage').removeClassName('hidden');        
        return;
    }
    request(
        {
            AjaxAction: 'ValidateRestrictions',
            UserSelector: $('UserSelector') != null ? $('UserSelector').value : null,
            BasedOn: $('GroupBasedOn').value
        },
        function (errorText) {
            if (errorText) {
                $('WrongUsers').innerHTML = errorText;
                $('InfoBar_GroupRestrictionsErrorMessage').removeClassName('hidden');
                $('UserSelectorTable').show();
                $('DoClose').value = false;
            }
            else
            {
                callback();
            }
        });
}

function prepareRichEditors() {
    if (typeof (CKEDITOR) != 'undefined') {
        for (var i in CKEDITOR.instances) {
            CKEDITOR.instances[i].updateElement();
        }
    } else if (typeof (FCKeditorAPI) != 'undefined') {
        for (var i in FCKeditorAPI.Instances) {
            FCKeditorAPI.Instances[i].UpdateLinkedField();
        }
    }

}

/* Fires when user clicks 'Save and close' button */
function saveAndClose() {
    if (buttonIsEnabled('cmdSaveAndClose')) {
        $('DoClose').value = true;
        save();
    }    
}

/* Fires when user clicks 'Close' button */
function closeForm(groupID) {
    var n = null;
    var id = groupID;
    var nodeID = -1;
    
    if(buttonIsEnabled('cmdClose')) {
        if (!groupID) {
            id = parseInt($('GroupID').value);
        }            
        location.href = 'ListUsers.aspx?GroupID=' + id;
    }    
}

/* Fired when "Name" field value has been changed */
function groupNameChanged(field) {
    if (!__form_posting) {
        if (field) {
            toggleToolsGroup(field.value.length > 0, true);
        }
    }
}

/* Fires when user clicks 'Help' button */
function help() {
    eval($('jsHelp').innerHTML);
}

/* Determines whether specified button is enabled */
function buttonIsEnabled(buttonID) {
    var ret = true;
    
    if(typeof(Ribbon) != 'undefined') {
        ret = Ribbon.buttonIsEnabled(buttonID);
    }
    
    return ret;
}

/* Toggles 'Enabled' state of all buttons in 'Tools' group */
function toggleToolsGroup(enable, onlySaveActions) {
    var buttons = ['cmdSave', 'cmdSaveAndClose', 'cmdClose', 'cmdSave2', 'cmdSaveAndClose2', 'cmdClose2'];
    
    if(typeof(Ribbon) != 'undefined') {
        for (var i = 0; i < buttons.length; i++) {
            if (!onlySaveActions || (buttons[i] != 'cmdClose' && buttons[i] != 'cmdClose2')) {
                if(enable)
                    Ribbon.enableButton(buttons[i]);
                else
                    Ribbon.disableButton(buttons[i]);
            }
        }
    }
}

/* Editor configuration */
function popupEditorConfiguration() {
    // Set selected value
    // Have to do this everytime the dialog opens, because the user might have opened it before and hit cancel.
    var dropdown = $('ConfigurationSelector');
    var hidden = $('ConfigurationSelectorValue');
    for (i = 0; i < dropdown.length; i++)
        if (dropdown[i].value == hidden.value) {
        dropdown.selectedIndex = i;
        break;
    }

    // Show dialog
    dialog.show("EditorConfigurationDialog");
}

function setEditorConfiguration() {
    $('ConfigurationSelectorValue').value = $('ConfigurationSelector').value;
    dialog.hide('EditorConfigurationDialog');
}

function popupAllowBackend() {
    var checkbox = $('AllowBackendCheckbox');
    var hidden = $('AllowBackendValue');
    checkbox.checked = hidden.value == 'true' ? true : false;
    dialog.show('AllowBackendDialog');
}

function setAllowBackend() {
    $('AllowBackendValue').value = $('AllowBackendCheckbox').checked ? 'true' : 'false';
    if ($('AllowBackendCheckbox').checked)
        $('AllowBackendLoginButton').addClassName('active');
    else
        $('AllowBackendLoginButton').removeClassName('active');
    dialog.hide('AllowBackendDialog');
}

function SetMainDiv(div) {
    if (div == 'EditGroup') {
        document.getElementById('EditGroupDiv').style.display = '';
        document.getElementById('ViewPermissionsDiv').style.display = 'none';
    }
    else if (div == 'ViewPermissions') {
        document.getElementById('EditGroupDiv').style.display = 'none';
        document.getElementById('ViewPermissionsDiv').style.display = '';
    }
}

function popupStartPageDialog() {
    $('StartPage').value = $('StartPageValue').value;
    dialog.show('StartPageDialog');
}

function saveStartPageDialog() {
    $('StartPageValue').value = $('StartPage').value;
    dialog.hide('StartPageDialog');
}

function popupCommPermissions(show) {
    if (show) {
        dialog.show('CommPermissionsDialog');
    } else {
        dialog.hide('CommPermissionsDialog');
    }
}

function updateCommPermissions() {
    updateCommunicationEmail(function () {
        popupCommPermissions(false);
    });
}

function revertCommPermissions() {
    revertCommunicationEmail(function () {
        popupCommPermissions(false);
    });
}

function updateCommunicationEmail(callback) {
    var groupId = $('GroupID').value;
    if (!parseInt(groupId)) {
        $('CommunicationEmailValue').value = $('CommunicationEmail').checked;
        if (callback) {
            callback();
        }
        return;
    }
    if (checkCommunicationEmail()) {
        request(
            { AjaxAction: 'ApplyCommunicationEmail', CommunicationEmailValue: $('CommunicationEmail').checked }, function () {
            $('CommunicationEmailValue').value = $('CommunicationEmail').checked;

            if (callback) {
                callback();
            }
        });
    } else {
        callback();
    }
}

function revertCommunicationEmail(callback) {
    var input = $('CommunicationEmail'),
    hidden = $('CommunicationEmailValue');
    
    input.checked = hidden.value === 'true';

    if (callback) {
        callback();
    }
}

function checkCommunicationEmail() {
    var result = false, msg,
    input = $('CommunicationEmail'),
    hidden = $('CommunicationEmailValue');

    msg = input.checked ? confirmationMsgSelect : confirmationMsgUnSelect;
    result = confirm(msg);

    if (!result) {
        revertCommunicationEmail();
    }

    return result;
}

function validateEmails(onComplete) {
    var self = this;
    var callback = onComplete || function () { }

    this._isBusy = true;

    Dynamicweb.Ajax.doPostBack({
        eventTarget: "<%=UniqueID%>",
        eventArgument: 'Discover:',
        onComplete: function (transport) {
            self._isBusy = false;
            dialog.show("ValidationEmailDialog", "/Admin/Module/OMC/Emails/ValidateEmail.aspx?UserGroupEditMode=True");
        }
    });
 }

function OnCloseValidationEmailPopUp(sender, args) {
    validationPopUpClose();
    dialog.hide('ValidationEmailDialog');
}

function validationPopUpClose() {
    var url = '/Admin/Module/Usermanagement/EditGroup.aspx';
    var groupId = $('GroupID').value;
    var groupParentId = $('ParentGroupID').value;
    new Ajax.Request(url,
    {
        method: 'get',
        parameters: {
            ID: groupId,
            ParentID: groupParentId,
            OnPopUpClose: true
        }
    });
}

function ShowBulkEditPermissions() {
    var groupId = $('GroupID').value;
    dialog.show("BulkEditPermissionsDialog", "EditPermissions.aspx?Id=" + groupId);
}

function CloseBulkEditPermissions() {
    dialog.hide('BulkEditPermissionsDialog');
    dialog.set_contentUrl("BulkEditPermissionsDialog", "");
}

function OnSaveBulkEditPermissions() {
    var metadataDialogFrame = document.getElementById('BulkEditPermissionsDialogFrame');
    var iFrameDoc = (metadataDialogFrame.contentWindow || metadataDialogFrame.contentDocument);

    iFrameDoc.saveAndClose();
    dialog.hide("BulkEditPermissionsDialog");
}

//Impersonation functionality
var ImpersonationContext = function (id, parentID) {
    this.ID = id;
    this.parentID = parentID;
}

ImpersonationContext.prototype.saveImpersonationDialog = function () {
    document.getElementById('EditGroupForm').action = 'EditGroup.aspx?ID=' + this.ID + '&ParentID=' + this.parentID + '&SaveImpersonationDialog=true';
    document.getElementById('EditGroupForm').submit();
    dialog.hide('ImpersonationDialog');
}

function handleUserSelectorTableVisibility(sender) {
    if (sender.value == "0") {
        $('UserSelectorTable').show();
        $('UsersProviderChangedWarning').hide();
    } else {
        $('UsersProviderChangedWarning').show();
        $('UserSelectorTable').hide();
    }
}

function changeItemType() {
    var ge = Dynamicweb.UserManagement.Group.Editors.current();
    ge.saveChanges();
}

function closeChangeItemTypeDialog() {
    var ge = Dynamicweb.UserManagement.Group.Editors.current();
    ge.cancelChanges();
}

(function (ns) {
    var editor = {
        init: function (opts) {
            this.options = opts;
            this.options.ids = this.options.ids || {
                dialog: "ItemTypeDialog",
                form: "EditGroupForm",
                waitOverlay: "UpdatingOverlay",
                itemType: "ItemTypeSelect",
                defaultUserItemType: "ItemTypeUserDefaultSelect",
            };
        },

        _showWait: function () {
            new overlay(this.options.ids.waitOverlay).show();
        },
        
        _hideWait: function () {
            new overlay(this.options.ids.waitOverlay).hide();
        },

        currentItemType: function() {
            return RichSelect.getSelectedValue(this.options.ids.itemType);
        },

        currentDefaultUserItemType: function () {
            return RichSelect.getSelectedValue(this.options.ids.defaultUserItemType);
        },
    
        saveChanges: function () {
            var systemName = this.currentItemType();

            if (this.options.data.itemType != systemName) {
                if (this.options.data.itemType && !confirm(this.options.titles.changeItemConfirm)) {
                    return;
                }
            }
            window.dialog.hide(this.options.ids.dialog);
            if (this.options.data.itemType != systemName) {
                var fn = $('GroupID').value != 0 ? function () {
                    window.location.reload(true);
                } : null;
                window.save(fn, true);
            }
        },

        cancelChanges: function () {
            var fnSetDefaultForRichSelect = function (richSelectName, defaultVal) {
                var rsId = richSelectName + (defaultVal ? defaultVal : "dwrichselectitem");
                var rsEl = $(rsId);
                if (rsEl) {
                    RichSelect.setselected(rsEl.down("div"), richSelectName);
                }
            };

            fnSetDefaultForRichSelect(this.options.ids.itemType, this.options.data.itemType);
            fnSetDefaultForRichSelect(this.options.ids.defaultUserItemType, this.options.data.defaultUserItemType);
            window.dialog.hide(this.options.ids.dialog);
        }
    };

    ns.createEditor = function (opts) {
        editor.init(opts);
        return editor;
    };

    ns.current = function (newEditor) {
        if (!Dynamicweb.Utilities.TypeHelper.isUndefined(newEditor)) {
            ns._editor = newEditor;
        }
        return ns._editor;
    };
})(Dynamicweb.Utilities.defineNamespace("Dynamicweb.UserManagement.Group.Editors"));