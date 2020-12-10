function EmailList(opts) {
    
    var options = opts;

    return {
        help: window.showHelp,
        emailSelected: function() {
            var isAllEmailsFolder = options.isAllEmailsFolder;
            var isTemplatesFolder = options.isTemplatesFolder;
            if (List && List.getSelectedRows('lstEmailsList').length > 0) {
                if (!isTemplatesFolder && !isAllEmailsFolder) {
                    Toolbar.setButtonIsDisabled('cmdMove', options.permissionLevel < PermissionLevels.Delete);
                    Toolbar.setButtonIsDisabled('cmdCopy', options.permissionLevel < PermissionLevels.Create);
                }
                Toolbar.setButtonIsDisabled('cmdDelete', options.permissionLevel < PermissionLevels.Delete);
            } else {
                if (!isTemplatesFolder && !isAllEmailsFolder) {
                    Toolbar.setButtonIsDisabled('cmdMove', true);
                    Toolbar.setButtonIsDisabled('cmdCopy', true);
                }
                Toolbar.setButtonIsDisabled('cmdDelete', true);
            }
        },


        editEmail: function (emailId) {
            document.getElementById('LoadingOverlay').style.display = "block";
            var folderId = options.folderId;
            if (folderId === undefined) folderId = 0;
            var topFolderId = options.topFolderId;
            if (topFolderId === undefined) topFolderId = 0;

            var folder = "";
            if (folderId == -1) {
                folder = "folderId=" + folderId + "&AllEmails=true&topFolderId=" + topFolderId;
            }
            else if (folderId == -2) {
                folder = "folderId=" + folderId + "&AllEmailTemplates=true&topFolderId=" + topFolderId;
            }
            else {
                folder = "folderId=" + folderId + "&topFolderId=" + topFolderId;
            }

            if (emailId > 0) {
                dwGlobal.marketing.navigate("/Admin/Module/OMC/Emails/EditEmail.aspx?newsletterId=" + emailId + "&" + folder);
            }
            else {
                dwGlobal.marketing.navigate("/Admin/Module/OMC/Emails/EmailTypeSelect.aspx?" + folder);
            }
        },

        confirmDeleteEmail: function () {
            var ids = dwGlobal.marketing.getCheckedRows('lstEmailsList');
            Action.Execute(options.actions.delete, {
                ids: ids
            });
        },

        copyEmail: function () {
            var ids = dwGlobal.marketing.getCheckedRows('lstEmailsList');
            Action.Execute(options.actions.copy, {
                ids: ids
            });
        },

        moveEmail: function() {
            var ids = dwGlobal.marketing.getCheckedRows('lstEmailsList');
            Action.Execute(options.actions.move, {
                ids: ids
            });
        },

        resendEmail: function (emailResendProvider) {
            var ids = dwGlobal.marketing.getCheckedRows('lstEmailsList');
            var folderId = options.draftFolderId;
            if (folderId === undefined) folderId = 0;
            var topFolderId = options.topFolderId;
            if (topFolderId === undefined) topFolderId = 0;
            Action.Execute(options.actions.resendEmail, {
                id: ids,
                provider: emailResendProvider
            });
        },

        showSaveAsTemplateDialog: function(emailId) {
            Action.Execute(options.actions.saveAsTemplate, {
                id: emailId
            });
        },

        emailStatistics: function (emailId) {
            document.getElementById('LoadingOverlay').style.display = "block";
            dwGlobal.marketing.navigate("/Admin/Module/OMC/Emails/Statistics.aspx?newsletterId=" + emailId);
        },

        showSplitTestReport: function (emailId) {
            document.getElementById('LoadingOverlay').style.display = "block";
            dwGlobal.marketing.navigate("/Admin/Module/OMC/Emails/SplitTestReport.aspx?newsletterId=" + emailId);
        },

        setContexMenuView: function (sender, args) {
            var ret = 'Basic';
            var row = List.getRowByID('lstEmailsList', args.callingID);

            if (row.hasAttribute('View')) {
                ret = row.readAttribute('View');
            }

            return ret;
        }
    };
}
