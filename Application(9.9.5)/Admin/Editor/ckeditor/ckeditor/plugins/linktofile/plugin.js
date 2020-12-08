CKEDITOR.plugins.add('linktofile', {
    icons: 'linktofile',
    init: function (editor) {
        editor.addCommand('insertLinkToFile', {
            allowedContent: 'a[href]',

            exec: function (editor) {
                //set flag to be used for toolbar button click event indication
                if (document != null) {
                    document.isToolbarBtnClick = true;
                }

                var callback = function (options, model) {                    
                    var href = "/Files" + model.Selected;
                    var selectedText = editor.getSelection().getSelectedText();
                    if (selectedText && selectedText != '') {
                        editor.insertHtml('<a href="' + href + '">' + selectedText + '</a>');
                    } else {
                        editor.insertHtml('<a href="' + href + '">' + model.Selected + '</a>');
                    }
                }

                var dlgAction = createLinkDialog(LinkDialogTypes.File, [], callback);

                Action.Execute(dlgAction);                
            }
        });

        editor.ui.addButton('LinkToFile', {
            label: 'Insert link to file',
            command: 'insertLinkToFile',
            toolbar: 'links'
        });
    }
});