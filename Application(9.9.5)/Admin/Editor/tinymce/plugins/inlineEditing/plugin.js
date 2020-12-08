!(function () {
	var status = (function () {
		const statusBar = parent.statusBar;

		return {
			set: function (message, data) {
				if (statusBar) {
					statusBar.set.apply(statusBar, arguments);
				}
				return this;
			},

			fade: function (duration) {
				if (statusBar) {
					statusBar.fade.apply(statusBar, arguments);
				}
				return this;
			}
		}
	}()),

	closeEditor = function (editor) {
		editor.hide();
		editor.show();
	},

	saveConfirmationDialog = function (editor) {
		return editor.windowManager.open({
			title: translate('Save changes?'),
			size: 'normal',
			body: {
				type: 'panel',
				items: [
					{
						type: 'htmlpanel',
						html: '<p>' + translate('You have unsaved changes') + '</p>'
					}
				]
			},
			buttons: [
				{
					type: 'submit',
					name: 'saveBtn',
					text: translate('Save changes'),
					primary: true
				},
				{
					type: 'cancel',
					name: 'cancelBtn',
					text: translate('Return to editor'),
					primary: true
				},
				{
					type: 'custom',
					name: 'discardChangesBtn',
					text: translate('Discard changes'),
					primary: true
				}
			],
			onSubmit: function (dialogApi) {
				dialogApi.close();
				saveContent(editor, false);
				closeEditor(editor);
			},
			onCancel: function () {
				editor.fire('focus', editor.getBody());
			},
			onAction: function (dialogApi) {
				dialogApi.close();
				discardChanges(editor);
			}
		});
	},

	saveContent = function (editor, confirmSave, callbacks) {
		const element = editor.getBody();
		const id = element.getAttribute('data-id');
		const content = editor.getContent();

		if (!editor.isDirty()) {
			return true;
		}
		if (confirmSave == true) {
			//show confirmation dialog
			saveConfirmationDialog(editor);
			return false;
		}
		else {
			if (element.classList.contains('.plaintext')) {
				content = content
					// Remove empty paragraphs
					.replace(/<p>&nbsp;<\/p>/g, '')
					// Remove tags
					.replace(/<[^>]*>/g, '')
					// Replace non-breaking spaces
					.replace(/&nbsp;/g, ' ');

				if (!element.classList.contains('.longtext')) {
					// Normalize white space
					content = content.replace(/[\s\n]+/mg, ' ')
						// Remove leading and trailing white space
						.replace(/^\s+/, '').replace(/\s+$/, '');
				}
				editor.setContent(content);
			}

			setStatus('Saving content …');
			//save updated content to attribute for restore at next cancel(at cancel plugin)
			element.setAttribute('originalText', content);

			const formData = new FormData();
			formData.append('id', id);
			formData.append('value', content);

			fetch('/Admin/Content/FrontendEditing/FrontendDataHandler.aspx?action=save', {
				method: 'POST',
				body: formData
			}).then(function (response) {
				if (!response.ok) {
					setStatus('Save failed', { className: 'alert' });
					if (callbacks && callbacks.onSaveFailed) {
						callbacks.onSaveFailed(editor, response);
					}
				} else {
					setStatus('Content saved', { className: 'success' }).fade();
					editor.setDirty(false);
					if (callbacks && callbacks.onContentSaved) {
						callbacks.onContentSaved(editor, response);
					}
				}
			}).catch(function (response) {
				setStatus('Save failed', { className: 'alert' });
				if (callbacks && callbacks.onSaveFailed) {
					callbacks.onSaveFailed(editor, response);
				}
			});
		}
		return true;
	},

	discardChanges = function (editor) {
		//check if changes were made
		if (editor.isDirty()) {
			//restore original content
			const originalText = editor.getBody().getAttribute('originalText');
			editor.setContent(originalText);
			editor.setDirty(false);
		}
		closeEditor(editor);
	},

	editorFocus = function () {
		status.fade();
	},

	editorBlur = function (event) {
		const editor = event.target;
		const originalText = editor.getBody().getAttribute('originalText');
		const currentText = editor.getContent({ format: 'html' });
		if (originalText == currentText) {
			editor.setDirty(false);
		}
		return saveContent(editor, true);
	},

	translate = parent.translate ? parent.translate : function (text) { return text; },

	setStatus = function (text, data) {
		if (!data) {
			data = {};
		}
		data.translate = true;
		return status.set(text, data);
	},

	editorsIds = (function () {
		const idsList = [];

		document.querySelectorAll('.dw-frontend-editable').forEach(function (element) {
			idsList.push(element.id);
		});

		return idsList;
	})();

	tinymce.PluginManager.add('inlineEditing', function (editor) {
		const saveCommandName = "mceInlineSave";
		const cancelCommandName = "mceInlineCancel";

		editor.addCommand(saveCommandName, function () {
			saveContent(editor, false, {
				onContentSaved: function () {
					editor.setDirty(false);
					closeEditor(editor);
				}
			});
		});

		editor.addCommand(cancelCommandName, function () {
			discardChanges(editor);
			setStatus('').fade();
		});

		editor.ui.registry.addButton('inlineSave', {
			icon: "save",
			tooltip: "Save",
			disabled: false,
			onAction: function () {
				editor.execCommand(saveCommandName);
			}
		});

		editor.ui.registry.addButton('inlineCancel', {
			icon: "cancel",
			tooltip: "Cancel",
			disabled: false,
			onAction: function () {
				editor.execCommand(cancelCommandName);
			}
		});

		editor.on('blur', editorBlur);
		editor.on('focus', editorFocus);
		editor.on('init', function () {
			editorsIds = editorsIds.filter(value => value !== editor.id);
			if (editorsIds.length == 0) {
				setStatus('Frontend editing ready').fade();
			}
		});
		editor.on('deactivate', function () {
			//if dialog is shown, stop deactivate event
			if (document.querySelector(".tox-dialog-wrap")) {
				return false;
			}
		});
	});
})();
