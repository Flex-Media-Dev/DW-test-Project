; (function ($, undefined) {
	var status = (function () {
		var statusBar = parent.statusBar;

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
		var id = 'hiddenFocus' + editor.element.getAttribute('data-id')
		var el = document.getElementById(id);
		if (el) {
			el.style.display = '';
			el.focus();
			el.click();
			el.style.display = 'none';
		}
	},

	saveContent = function (editor, confirmSave, callbacks) {
		var id = editor.element.getAttribute('data-id'),
		content = editor.getData();

		if (!editor.checkDirty()) {
			return true;
		}
		if (confirmSave == true) {
			//show confirmation dialog
			CKEDITOR.currentInstance.openDialog('saveConfirmationDialog');
			return false;
		}
		else {
			if ($(editor.element).is('.plaintext')) {
				content = content
				// Remove empty paragraphs
									.replace(/<p>&nbsp;<\/p>/g, '')
				// Remove tags
									.replace(/<[^>]*>/g, '')
				// Replace non-breaking spaces
									.replace(/&nbsp;/g, ' ');

				if (!$(editor.element).is('.longtext')) {
					// Normalize white space
					content = content.replace(/[\s\n]+/mg, ' ')
					// Remove leading and trailing white space
										.replace(/^\s+/, '').replace(/\s+$/, '');
				}
				editor.setData(content);
			}

			setStatus('Saving content …');
			//save updated content to attribute for restore at next cancel(at cancel plugin)
			editor.element.setAttribute('originalText', content)
			var data = {
				id: id,
				value: content
			}

			$.post('/Admin/Content/FrontendEditing/FrontendDataHandler.aspx?action=save', data)
				.success(function (response) {
					if (!response.message) {
						// Success, but no message from server means that save has failed. Probably because the user is logged out.
						setStatus('Save failed', { className: 'alert' }); //.fade();
						if (callbacks && callbacks.onSaveFailed) {
							callbacks.onSaveFailed(editor, response);
						}
					} else {
						setStatus('Content saved', { className: 'success' }).fade();
						editor.resetDirty();
						if (callbacks && callbacks.onContentSaved) {
							callbacks.onContentSaved(editor, response);
						}
					}
				})
				.error(function (response) {
					// @TODO use response.message
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
		if (editor.checkDirty()) {
			//restore original content
			var originalText = editor.element.getAttribute('originalText')
			editor.setData(originalText);
			editor.resetDirty();
		}
		closeEditor(editor);
	},

	editorFocus = function () {
		status.fade();
	},

	editorBlur = function () {
		//check if it is toolbar button click event
		if (document && document.isToolbarBtnClick == true) {
			return false;
		}
		return saveContent(this, true);
	},

	editorConfigLoaded = function (evt) {
		var editor = evt.editor;
		if (editor.config.toolbar && $.grep(editor.config.toolbar, function (e) { return e.name == 'dwediting'; }).length == 0) {
			editor.config.toolbar.unshift({ name: 'dwediting', items: ['InlineSave', 'InlineCancel'] });
		}
		if (editor.config.toolbarGroups && $.grep(editor.config.toolbarGroups, function (e) { return e.name == 'dwediting'; }).length == 0) {
			editor.config.toolbarGroups.unshift({ name: 'dwediting', groups: ['InlineSave', 'InlineCancel'] });
			editor.ui.addToolbarGroup('dwediting', 0);
		}
	},

	translate = parent.translate ? parent.translate : function(text) { return text; },

	setStatus = function(text, data) {
		if (!data) {
			data = {};
		}
		data.translate = true;
		return status.set(text, data);
	};

	CKEDITOR.plugins.add('inlineSave', {
		icons: 'inlinesave',
		init: function (editor) {
			editor.addCommand('cmdInlineSave', {
				exec: function (editor) {
					saveContent(editor, false, {
						onContentSaved: function() {
							// @TODO This should be done only when save is successful, i.e. in a callback function
							editor.resetDirty();
							closeEditor(editor);
						}
					});
				}
			});
			editor.ui.addButton('InlineSave', {
				label: 'Save content',
				command: 'cmdInlineSave',
				toolbar: 'dwediting'
			});
		}
	});

	CKEDITOR.plugins.add('inlineCancel', {
		icons: 'inlinecancel',
		init: function (editor) {
			editor.addCommand('cmdInlineCancel', {
				exec: function (editor) {
					discardChanges(editor);
					setStatus('').fade();
				}
			});
			editor.ui.addButton('InlineCancel', {
				label: 'Cancel editing',
				command: 'cmdInlineCancel',
				toolbar: 'dwediting'
			});
		}
	});

	CKEDITOR.dialog.add('saveConfirmationDialog', function (api) {
		var dialogDefinition =
			{
				title: translate('Save changes?'),
				minWidth: 300,
				minHeight: 50,
				contents: [
					{
						id: 'tab1',
						label: 'Label',
						title: 'Title',
						expand: true,
						padding: 0,
						elements:
						[
							{
								type: 'html',
								html: '<p>'+translate('You have unsaved changes')+'</p>'
							}
						]
					}
				],
				buttons: [
					{
						type: 'button', id: 'saveBtn', label: translate('Save changes'), onClick: function () {
							saveContent(CKEDITOR.currentInstance, false);
							CKEDITOR.dialog.getCurrent().hide();
							setTimeout(function () { closeEditor(CKEDITOR.currentInstance) }, 500);
						}
					},
					{
						type: 'button', id: 'cancelBtn', label: translate('Return to editor'), onClick: function () {
							CKEDITOR.dialog.getCurrent().hide();
							//move focus back to the editor
							CKEDITOR.currentInstance.focus();
						}
					},
					{
						type: 'button', id: 'discardChangesBtn', label: translate('Discard changes'), onClick: function () {
							CKEDITOR.dialog.getCurrent().hide();
							setTimeout(function () { discardChanges(CKEDITOR.currentInstance) }, 10);
						}
					}
				]
			};

		return dialogDefinition;
	});

	CKEDITOR.on('instanceCreated', function (event) {
		var editor = event.editor;
		editor.on('blur', editorBlur);
		editor.on('focus', editorFocus);
		editor.on('configLoaded', editorConfigLoaded);

		// Merge frontend editor configuration into editor configuration
		if (typeof dwFrontendEditing.editorConfiguration != 'undefined') {
			CKEDITOR.tools.extend(editor.config, dwFrontendEditing.editorConfiguration, true);
		}
	});

	CKEDITOR.disableAutoInline = true;

	$(document).ready(function () {
		var editors = [];
		$('.dw-frontend-editable.richtext').each(function () {
			editors.push(this);
			CKEDITOR.inline(this);
		});
		$('.dw-frontend-editable.plaintext').each(function () {
			editors.push(this);
			CKEDITOR.inline(this, {
				toolbar: [ { name: 'dwediting', items: ['InlineSave', 'InlineCancel'] } ]
			});
		});
		if (editors.length > 0) {
			setStatus('Frontend editing ready').fade();
		}
	});
}(dwFrontendEditing.jQuery));
