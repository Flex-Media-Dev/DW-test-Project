CKEDITOR.plugins.add('internallink', {
    icons: 'internallink',
    init: function (editor) {
        editor.addCommand('insertInternalLink', {
            allowedContent: 'a[href]',

            exec: function (editor) {
                //set flag to be used for toolbar button click event indication
                if (document != null) {
                    document.isToolbarBtnClick = true;
                }

                var callback = function (options, model) {
                    var href = "Default.aspx?ID=" + model.Selected;
                    var selectedText = editor.getSelection().getSelectedText();
                    if (selectedText && selectedText != '') {
                        editor.insertHtml('<a href="' + href + '">' + selectedText + '</a>');
                    } else {
                        editor.insertHtml('<a href="' + href + '">' + model.SelectedPageName + '</a>');
                    }
                }

                var dlgAction = createLinkDialog(LinkDialogTypes.Page, [], callback);

                Action.Execute(dlgAction);                
            }
        });

        editor.ui.addButton('Internallink', {
            label: 'Insert internal link',
            command: 'insertInternalLink',
            toolbar: 'links'
        });
    }
});