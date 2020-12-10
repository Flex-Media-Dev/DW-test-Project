function EditEmailPage(opts) {
    var options = opts;

    var hasValue = function (el) {
        return !!el.value;
    };

    var pattern = /^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/;
    var matchPattern = function (el) {
        return (el.value).match(pattern);
    };

    var controlsToValidationCheck = [
        { id: options.ids.senderName, validations: [{ fn: hasValue, msg: options.labels.emptySenderName }] },
        {
            id: options.ids.senderEmail, validations: [
              { fn: hasValue, msg: options.labels.emptySendeEmail },
              { fn: matchPattern, msg: options.labels.incorrectSendeEmail }
            ]
        },
        { id: options.ids.senderSubject, validations: [{ fn: hasValue, msg: options.labels.emptySubject }] },
        { id: "Link_" + options.ids.emailPage, validations: [{ fn: hasValue, msg: options.labels.emptyEmailPage }] }
    ];

    var variantControlsToValidationCheck = [
        { id: options.ids.variantSenderName, validations: [{ fn: hasValue, msg: options.labels.emptyVariationSenderName }] },
        {
            id: options.ids.variantSenderEmail, validations: [
              { fn: hasValue, msg: options.labels.emptyVariationSenderEmail },
              { fn: matchPattern, msg: options.labels.incorrectVariationSenderEmail }
            ]
        },
        { id: options.ids.variantSenderSubject, validations: [{ fn: hasValue, msg: options.labels.emptyVariationSubject }] },
        { id: "Link_" + options.ids.variantEmailPage, validations: [{ fn: hasValue, msg: options.labels.emptyVariationEmailPage }] }
    ];


    var isValidFn = function (item) {
        var el = document.getElementById(item.id);
        if (el) {
            return item.validations.every(function (validation) {
                if (!validation.fn(el)) {
                    alert(validation.msg);
                    try {
                        el.focus();
                    } catch (ex) { }
                    return false
                }
                return true;
            });
        }
        return true;
    };

    var validate = function (onComplete, isValidateVariation) {
        var callback = onComplete || function () { }

        var isValid = controlsToValidationCheck.every(isValidFn);
        if (isValid && isValidateVariation) {
            isValid = variantControlsToValidationCheck.every(isValidFn);
        }
        callback(isValid);
    };

    var validateSubject = function () {
        var el = document.getElementById(options.ids.senderSubject);
        if (!hasValue(el)) {
            alert(options.labels.emptySubject);

            try {
                el.focus();
            } catch (ex) { }

            return false;
        }
        return true;
    };

    var api = {
        initialize: function (opts) {
            var self = this;
            this.options = opts;
            var buttons = Ribbon;
            if (!this.options.emailId) {
                buttons.disableButton('cmdStart_split_test');
            }
            if ($('cbCreateSplitTestVariation').checked) {
                buttons.enableButton('cmdStart_split_test');
            }
            if (!document.getElementById("lmEmailPage").value) {
                buttons.disableButton('cmdEdit_content');
                buttons.disableButton('cmdPreview');
                buttons.disableButton('cmdTemplate');
            }

            if (this.options.isEmailSent) {
                buttons.disableButton('cmdSend_Mail');
                buttons.disableButton('cmdStart_split_test');
                buttons.disableButton('cmdEdit_content');
                buttons.disableButton('cmdSave');
                buttons.disableButton('cmdSave_and_close');
                buttons.disableButton('cmdSave_2');
                buttons.disableButton('cmdSave_and_close_2');
                buttons.disableButton('cmdRecipient_provider');
            }

            if (buttons.buttonIsEnabled('cmdSend_Mail') && $('cbCreateSplitTestVariation').checked) {
                buttons.disableButton('cmdSend_Mail');
            }

            if (buttons.buttonIsEnabled('cmdValidate_e-mails') && !this.options.isAccessUserProvider) {
                buttons.disableButton('cmdValidate_e-mails');
            }

            if (this.options.isTemplate) {
                buttons.disableButton('cmdSend_Mail');
                buttons.disableButton('cmdStart_split_test');
                buttons.disableButton('cmdSave_as_template');
                $('cbCreateSplitTestVariation').disable();
            }

            const domainCtrl =  document.getElementById(this.options.ids.domainSelector);
            domainCtrl.addEventListener("change", function () {
                self.checkPrimaryDomain();
            })

            let btnEl = dwGlobal.addAddonButtonToControl(domainCtrl, function(btn) {
                btn.innerHTML = options.icons.addDomain;
                btn.setAttribute("title", options.labels.addDomain);
            });
            if (btnEl) {
                btnEl.addEventListener("click", function() {
                    let pd = prompt(options.labels.domain, "");
                    if (pd) {
                        var elOptNew = document.createElement('option');
                        elOptNew.text = pd;
                        elOptNew.value = pd;
                        elOptNew.setAttribute("selected", "selected")
                        domainCtrl.add(elOptNew);
                    }
                });
            }

            this.checkPrimaryDomain();

            // call globals

            toggleScheduledRepeatSettings();
            toggleQuarantinePeriodSettings();
            togglePlainTextRow();

            document.forms[0].addEventListener("keydown", function (e) {
                if (e.keyCode == 13) {
                    var srcElement = e.srcElement ? e.srcElement : e.target;
                    if (srcElement.type != 'textarea') {
                        self.save();
                        e.preventDefault();
                    }
                }
            });
            this.initAddTagsButtons();
        },
        help: showHelp,

        checkPrimaryDomain: function () {
            var pageId = parseInt($('lmEmailPage').value.split("=")[1]);
            var domainSelectorEl = document.getElementById(this.options.ids.domainSelector);
            var selectedDomain = domainSelectorEl[domainSelectorEl.selectedIndex].value;

            if (pageId > 0) {
                new Ajax.Request("EditEmail.aspx?CMD=CheckPrimaryDomain&SelectedDomain=" + selectedDomain + "&PageId=" + pageId, {
                    onSuccess: function (response) {
                        var div = $('divDomainErrorContainer');
                        var row = $('rowDomainErrorContainer');
                        if (response.responseText.length > 0) {
                            div.innerHTML = response.responseText;
                            row.show();
                        } else {
                            row.hide();
                        }
                    }
                });
            }
        },

        cancel: function (goToEmailStatsPage) {
            /// <summary>Discards any changes and closes the form.</summary>
            if (goToEmailStatsPage != null)
                dwGlobal.marketing.navigate('/Admin/Module/OMC/Emails/Statistics.aspx?newsletterId=' + this.options.emailId);
            else if (this._emailFolderId === -1)
                dwGlobal.marketing.navigate('/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=' + this.options.folderId + "&AllEmails=true" + '&topFolderId=' + this.options.topFolderId);
            else if (this._emailFolderId == -2)
                dwGlobal.marketing.navigate('/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=' + this.options.folderId + "&AllEmailTemplates=true" + '&topFolderId=' + this.options.topFolderId);
            else
                dwGlobal.marketing.navigate('/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=' + this.options.folderId + '&topFolderId=' + this.options.topFolderId);
        },

        save: function (closeWindow) {
            var isValid = validateSubject();
            if (isValid) {
                var o = new overlay('saveForward');
                o.show();
                document.getElementById('CloseOnSave').value = (!!closeWindow).toString();
                document.getElementById('cmdSubmit').click();
            }
        },

        cancelSchedule: function () {
            var confirmMsg = this.options.labels.confirmationCancelSchedule;
            if (confirm(confirmMsg)) {
                document.getElementById('cmdCancelSchedule').click();
            }
        },

        splitTestSetup: function (showAsSettings, name, recipientsCount) {
            var self = this;
            validate(function (isValid) {
                if (isValid) {
                    params = {
                        emailId: self.options.emailId,
                        emailName: name,
                        showAsSettings: showAsSettings,
                        recipientsCount: recipientsCount
                    };
                    Action.Execute(self.options.actions.setupSplitTest, params);
                }
            }, true);
        },

        checkLinkedPage: function (closeWindow, linkedPageId) {
            var self = this;

            var buttons = Ribbon;
            if (!buttons.buttonIsEnabled('cmdSend_Mail') && !$('cbCreateSplitTestVariation').checked) { buttons.enableButton('cmdSend_Mail'); }
            if (!buttons.buttonIsEnabled('cmdEdit_content')) { buttons.enableButton('cmdEdit_content'); }
            if (!buttons.buttonIsEnabled('cmdPreview') && self.options.isEmailSaved) { buttons.enableButton('cmdPreview'); }
            if (!buttons.buttonIsEnabled('cmdTemplate')) { buttons.enableButton('cmdTemplate'); }

            if (!buttons.buttonIsEnabled('cmdSave_as_template')) {
                buttons.disableButton('cmdSend_Mail');
                buttons.disableButton('cmdStart_split_test');
                buttons.disableButton('cmdSave_as_template');
                $('cbCreateSplitTestVariation').disable();
            }

            document.getElementById('CloseOnSave').value = (!!closeWindow).toString();

            if (linkedPageId == 'lmVariantEmailPage') {
                document.getElementById('cmdCheckVariationLinkedPage').click();
            } else if (linkedPageId == 'lmEmailPage') {
                self.checkPrimaryDomain();
                document.getElementById('cmdCheckLinkedPage').click();
            }
        },

        editContent: function (Name) {
            var pageId = document.getElementById("lmEmailPage").value;
            if (isNaN(pageId)) {
                pageId = document.getElementById("lmEmailPage").value.split('=')[1]
            }
            Action.Execute({
                Url: "/Admin/Content/ParagraphList.aspx?PageID=" + pageId + "&NavigatorSync=RefreshAndSelectPage",
                TargetArea: "Content",
                Name: "OpenScreen"
            });
        },

        previewEmail: function () {
            dialog.show('PreviewMailDialog');
        },

        showAttachments: function () {
            dialog.show('CMAttachDialog');
        },

        //showTemplate: function () {
        //    dialog.show('EmailTemplateDialog');
        //},

        showEncoding: function () {
            dialog.show('EmailEncodingDialog');
        },

        showSaveAsTemplate: function () {
            dialog.show('dlgSaveAsTemplate');
        },

        saveAsTemplate: function () {
            var self = this;
            Ribbon.disableButton('cmdSave_as_template');
            /* Validating input */
            var isValid = validateSubject();
            if (isValid) {
                var o = new overlay('saveForward');
                o.show();
                document.getElementById('CloseOnSave').value = 'False';
                document.getElementById('cmdSaveAsTemplate').click();
            }
            Ribbon.enableButton('cmdSave_as_template');
        },

        showUnsubscribe: function () {
            dialog.show('UnsubscribeDialog');
        },

        showContentSettings: function () {
            dialog.show('ContentSettingsDialog');
        },

        showRecipientSettings: function () {
            dialog.show('RecipientSettingsDialog');
        },

        showEngagementIndex: function () {
            var variationCheckbox = $('cbCreateSplitTestVariation');
            if (variationCheckbox) {
                if (variationCheckbox.checked) {
                    dwGlobal.marketing.showDialog('/Admin/Module/OMC/Emails/EngagementDetails.aspx?newsletterId=' + this.options.emailId + '&pageId=' + this.options.pageId + '&variantpageId=' + this.options.variantPageId, 588, 590, { title: 'Engagement index', hideCancelButton: true });
                } else {
                    dwGlobal.marketing.showDialog('/Admin/Module/OMC/Emails/EngagementDetails.aspx?newsletterId=' + this.options.emailId + '&pageId=' + this.options.pageId + '&variantpageId=' + this.options.variantPageId, 588, 410, { title: 'Engagement index', hideCancelButton: true });
                }
            }
        },

        showTracking: function () {
            dialog.show('EmailTrackingDialog');
        },

        showRecipientProvider: function () {
            dialog.show('RecipientProviderDialog');
        },

        showDeliveryProvider: function () {
            dialog.show('DeliveryProviderDialog');
        },

        validateEmails: function (onComplete) {
            var self = this;
            var callback = onComplete || function () { };
            Dynamicweb.Ajax.doPostBack({
                eventTarget: self.options.ids.pageId || "",
                eventArgument: 'Discover:',
                onComplete: function (transport) {
                    dwGlobal.marketing.showDialog(
                        '/Admin/Module/OMC/Emails/ValidateEmail.aspx',
                        800,
                        600,
                        { title: self.options.labels.nonValidEmailsAddress, hideCancelButton: true },
                        updateRecipients);
                }
            });
        },

        sendMail: function () {
            var self = this;
            validate(function (isValid) {
                if (isValid) {
                    var el = document.getElementById(self.options.ids.senderSubject);
                    var newsletterName = el.value;

                    var confirmMsg = self.options.labels.confirmationMsgSend;
                    confirmMsg = confirmMsg.replace('%%', newsletterName);

                    var recipientsValidated = !self.options.usingDefaultRecipientProvider || self.validateRecipientsPermission();
                    if (recipientsValidated && (self.sendConfirmed || confirm(confirmMsg))) {
                        var o = new overlay('saveForward');
                        o.message(self.options.labels.prepareRecipients);
                        o.show();
                        document.getElementById('cmdSend').click();
                    }
                }
            });
        },

        validateRecipientsPermission: function () {
            var recipientsText = $('lblTotalRecipientsValue').innerText;
            var recipientsEmpty = recipientsText.length <= 0 || recipientsText == '0';
            if (recipientsEmpty || (recipientsText.indexOf("/") > 0 && recipientsText.split("/")[0] != recipientsText.split("/")[1])) {
                var confirmMassage = recipientsEmpty ? options.labels.noRecipientsWithPermissions : options.labels.someRecipientsHaveNoPermissions.replace("%%", recipientsText);
                if (!confirm(confirmMassage)) {
                    $('UserSelectorDivRecipientSelector').focus();
                    return false;
                } else {
                    this.sendConfirmed = true;
                }
            }
            return true;
        },

        sheduledEmail: function () {
            var self = this;
            validate(function (isValid) {
                if (isValid && (!self.options.usingDefaultRecipientProvider || self.validateRecipientsPermission())) {
                    dialog.show('SchedulingDialog');
                    var repeatInterval = document.getElementById("ddlScheduledRepeatInterval");
                    var fn = toggleScheduledRepeatSettings;
                    repeatInterval.removeEventListener("change", fn);
                    repeatInterval.addEventListener("change", fn);
                }
            });
        },

        saveWithValidation: function (closeWindow) {
            var self = this;
            if (document.getElementById('EmailScheduled').value == 'true') {
                if (!confirm(this.options.labels.confirmScheduledEmail))
                    return;
            }

            /* First, disabling the "Save" button indicating that the operating is being performed */
            Ribbon.disableButton('cmdSave');

            /* Validating input */
            validate(function (isValid) {
                if (isValid) {

                    /* Show spinning wheel*/
                    var o = new overlay('saveForward');
                    o.show();

                    document.getElementById('CloseOnSave').value = (!!closeWindow).toString();
                    document.getElementById('cmdSubmit').click();
                }
                Ribbon.enableButton('cmdSave');
            });
        },

        splitTestExpired: function (newsletterId, name) {
            alert(this.options.labels.splitTestExpired);
            try {
                inputField.focus();
            }
            catch (ex) { }
            params = {
                emailId: newsletterId,
                emailName: name,
                showAsSettings: true,
                recipientsCount: 0
            };
            Action.Execute(self.options.actions.setupSplitTest, params);
        },

        setSplitTestmodeVariation: function (box) {
            var buttons = Ribbon;
            if (!box.checked) {
                document.getElementById(this.options.ids.variationPane).style.display = "none";
                buttons.disableButton('cmdStart_split_test');
                buttons.enableButton("cmdSend_Mail");
                this.options.variantPageId = 0;
            }
            else {
                document.getElementById(this.options.ids.variationPane).style.display = "";
                buttons.enableButton('cmdStart_split_test');
                buttons.disableButton("cmdSend_Mail");
                var ctrlIds = this.options.ids;
                var copyVals = [{
                    from: ctrlIds.senderName,
                    to: ctrlIds.variantSenderName,
                }, {
                    from: ctrlIds.senderEmail,
                    to: ctrlIds.variantSenderEmail,
                }, {
                    from: ctrlIds.senderName,
                    to: ctrlIds.variantSenderName,
                }, {
                    from: ctrlIds.senderSubject,
                    to: ctrlIds.variantSenderSubject,
                }, {
                    from: "Link_lmEmailPage",
                    to: "Link_lmVariantEmailPage",
                }, {
                    from: ctrlIds.preHeaderText,
                    to: ctrlIds.variantPreHeaderText,
                }]
                copyVals.forEach(function (item) {
                    var toEl = document.getElementById(item.to);
                    if (toEl && !toEl.value) {
                        var fromEl = document.getElementById(item.from);
                        toEl.value = fromEl.value;
                    }
                });
                currentPage.options.variantPageId = getVariantPageId();
            }
        },

        initAddTagsButtons: function () {
            if (!this.options.isEmailSent) {
                const senderSubjectCtrl = document.getElementById(this.options.ids.senderSubject);
                this.addTagSelectorToCtrl(senderSubjectCtrl);

                const variantSenderSubjectCtrl = document.getElementById(this.options.ids.variantSenderSubject);
                this.addTagSelectorToCtrl(variantSenderSubjectCtrl);

                const senderNameCtrl = document.getElementById(this.options.ids.senderName);
                this.addTagSelectorToCtrl(senderNameCtrl);

                const variantSenderNameCtrl = document.getElementById(this.options.ids.variantSenderName);
                this.addTagSelectorToCtrl(variantSenderNameCtrl);
            }
        },

        addTagSelectorToCtrl: function (ctrl) {
            const self = this;
            const tagsHolder = ctrl;
            const addTagBtn = dwGlobal.addAddonButtonToControl(tagsHolder, function (btn) {
                btn.innerHTML = self.options.icons.addTag;
                btn.setAttribute("title", self.options.labels.addTag);
            });

            addTagBtn.addEventListener("click", function () {
                const addTagDialogId = "AddEmailTag";
                const okBtn = dialog.get_okButton(addTagDialogId);
                const tagListCtrl = document.getElementById(self.options.ids.tagsList);
                if (self.prevAddEmailTagDlgOk) {
                    okBtn.removeEventListener("click", self.prevAddEmailTagDlgOk);
                }
                self.prevAddEmailTagDlgOk = function () {
                    const val = tagListCtrl.value
                    self.insertAtCaret(tagsHolder, val);
                    dialog.hide('AddEmailTag');
                }
                dialog.set_okButtonOnclick(addTagDialogId, self.prevAddEmailTagDlgOk);
                dialog.show(addTagDialogId);
            });
        },

        insertAtCaret: function (el, text) {
            if (document.selection) { 
                el.focus();
                let sel = document.selection.createRange();
                sel.text = text;
                el.focus();
            } else if (el.selectionStart || el.selectionStart == '0') { 
                let startPos = el.selectionStart;
                let endPos = el.selectionEnd;
                let scrollTop = el.scrollTop;
                el.value = el.value.substring(0, startPos) + text + el.value.substring(endPos, el.value.length);
                el.focus();
                el.selectionStart = startPos + text.length;
                el.selectionEnd = startPos + text.length;
                el.scrollTop = scrollTop;
            } else {
                el.value += text;
                el.focus();
            }
        },

        showPage: function (pageId) {
            const showUrl = `/Default.aspx?ID=${pageId}&Preview=${pageId}`;
            window.open(showUrl);
        },

        applyPage: function (pageId, pagePath) {
            const emailPageSelector = document.getElementById(options.ids.emailPage)
            if (emailPageSelector && emailPageSelector.disabled) {
                return;
            }
            updateInternalPageLinkValue(emailPageSelector, {
                Selected: pageId,
                SelectedAreaAndPageName: pagePath,
            }, function (model) {
                const ctrlId = "Link_" + options.ids.emailPage;
                onLinkManagerSelect(ctrlId, model);
                const createPagesCopyEl = document.getElementById("MakePageCopy");
                createPagesCopyEl.value = "true";
            });
        },

        showPagePreview: function () {
            const pageUrl = document.getElementById(options.ids.emailPage).value;
            if (pageUrl) {
                const previewContainer = document.querySelector(".content-preview-box");
                const previewIframe = document.querySelector(".content-preview");
                previewIframe.src = "/" + pageUrl;
                previewContainer.style.display = "block";
            }
        }
    };

    api.initialize(options);
    return api;
}