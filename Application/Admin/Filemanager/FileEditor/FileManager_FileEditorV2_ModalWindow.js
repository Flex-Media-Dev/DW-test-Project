if (typeof (Editor) == 'undefined') {
    Editor = new Object();
}

/*************  "Save as"  dialog implementation *************/

var SaveAsDialog = new Object();

SaveAsDialog.initialize = function (sender, args) {
    SaveAsDialog.setOkButtonText('OK');
    SaveAsDialog.updateOkState();
}

SaveAsDialog.show = function (fileConvertedRazor, fileConvertedXslt) {
    var initialFile = $("InitialFileName");
    var initialFolder = $("InitialFileDir");
    var file;
    var folder;
    
    if (initialFile.value == '') {
        file = 'NewFile.html';
    } else {
        file = initialFile.value;
    }
    
    if (initialFolder.value == '') {
        folder = '/Folder/';
    } else {
        folder = initialFolder.value;
    }

    if (fileConvertedRazor == true) {
        file = file.replace(/\.(?:html)$/i, '');
        file += '.cshtml';
    }

    if (fileConvertedXslt == true) {
        file = file.replace(/\.(?:html)$/i, '');
        file += '.xslt';
    }
    
    dialog.show('SaveAsDialog');
}

SaveAsDialog.ok = function () {
    SaveAsDialog.execute();
}

SaveAsDialog.cancel = function (sender, args) {
    __snc_state_wait = false;
    SaveAsDialog.close();
}

/* Closes dialog */
SaveAsDialog.close = function () {
    dialog.hide('SaveAsDialog');
}

/* Updates the state of the "OK" button */
SaveAsDialog.updateOkState = function () {
    var ok = dialog.get_okButton('SaveAsDialog');

    if (ok) {
        var filename = $('txFileName');
        ok.disabled = !SaveAsDialog.validate(filename);
    }
}

/* Fires when the response from 'CheckFile' operation has come */
SaveAsDialog.onFileChecked = function (data) {
    var fileName = $('txFileName').value;
    var templatePath = "/Files" + $('InitialFileDir').value + fileName;
    var showFullPath = $('InitialFileFullPath').value.toLowerCase() === "true";

    var ret = true;
    var onSave = function () {
        toggleProcessing(false);
        if (winOpener.reloadPage) {
            winOpener.reloadPage(true);
        }
    }

    toggleProcessing(false, $('pSaveAsLoading'));
    
    /* File with given name already exists */
    if (data == "1")
        ret = showMessage('mFileExists', true);

    if (ret) {
        Editor.doSave(onSave, true);
        SaveAsDialog.close();
    }
}

/* Fires when the response from 'CheckDirectory' operation has come */
SaveAsDialog.onDirectoryChecked = function (data) {
    var ret = true;

    toggleProcessing(false, $('pSaveAsLoading'));
    
    /* Directory with given name doesn't exist */
    if (data == "1")
        ret = showMessage('mDirectoryDoesNotExist', true);

    if (ret)
        SaveAsDialog.checkFile();
}

/* Fires when user clicks on the folder in a folder manager */
SaveAsDialog.onSelectFolder = function (node) {
    var val = node.Value;
    var staticDirectory = $$('span.saveas-static-directory')[0];
    
    if (val.length > 35) {
        val = val.substring(0, 35) + '...';
        staticDirectory.writeAttribute('title', node.Value);
    }
    else
        staticDirectory.writeAttribute('title', '');

    staticDirectory.innerHTML = val;
}

/* Validates form */
SaveAsDialog.validate = function (filename) {
    var ret = true;
    filename = filename || $('txFileName');
    ret = filename && filename.value && filename.value.length > 0;

    return ret;
}

/* 'Enter' key handler */
SaveAsDialog.onTextChange = function (code) {
    var ret = true;

    if (code == 13) {
       SaveAsDialog.execute();
       ret = false;
    }

    return ret;
}

/* Performs a checking operation on the specified file name */
SaveAsDialog.checkFile = function () {
    var self = this;
    var dir = this.getDirectory()[0];

    var params = {
        Action: 'CheckFile',
        FileName: $('txFileName').value,
        FileDirectory: dir,
        InitialFileName: $$('input.initial-filename')[0].value,
        InitialFileDirectory: $$('input.initial-directory')[0].value
    }

    toggleProcessing(true, $('pSaveAsLoading'));

    new Ajax.Request('FileManager_FileEditorV2.aspx', {
        method: 'post',
        parameters: params,
        onComplete: function(response) { self.onFileChecked(response.responseText); }
    });
}

/* Performs a checking operation on the specified directory */
SaveAsDialog.checkDirectory = function (dir) {
    var self = this;

    var params = {
        Action: 'CheckDirectory',
        FileDirectory: dir
    }

    toggleProcessing(true, $('pSaveAsLoading'));

    new Ajax.Request('FileManager_FileEditorV2.aspx', {
        method: 'post',
        parameters: params,
        onComplete: function(response) { self.onDirectoryChecked(response.responseText); }
    });
}

/* Fires when dialog form is submited */
SaveAsDialog.execute = function (autoClose) {
    var ret = true;
    var needsToCheckDirectory = false;
    var dirArgs = this.getDirectory();
    var dir = dirArgs[0];

    if (this.validate()) {
        if (dirArgs[1])
            this.checkDirectory(dir);
        else
            this.checkFile();
    } else {
        ret = false;
    }

    return ret;
}

/* Retrieves file directory (first array element) and value indicating that directory needs to be checked (second array element) */
SaveAsDialog.getDirectory = function () {
    var val = null;
    var dir = new Array('', false);
    var staticDirectory = $$('span.saveas-static-directory')[0];
    
    if (staticDirectory && staticDirectory.innerHTML) {
        dir[0] = staticDirectory.innerHTML;
    } else {
        val = $('FLDM_txDirectory');

        if (val) {
            dir[0] = val.value;
        } else {
            dir[0] = '/Files/Templates';
        }

        dir[1] = true;
    }

    return dir;
}

/* Sets an "OK" button text */
SaveAsDialog.setOkButtonText = function (value) {
    var okBtn = dialog.get_okButton('SaveAsDialog');
    if (okBtn) {
        okBtn.innerHTML = value;
    }
}

/*************  "XSLT transform" dialog routines *************/

var XsltDialog = new Object();

/* Gets or sets callback function that will be called when user click "Save anyway" */
XsltDialog.SaveCallback = null;

/* Gets or sets callback function that will be called when dialog is shown */
XsltDialog.ShowCallback = null;

/* Gets or sets fields that needs to be initialized inside the dialog */
XsltDialog.Fields = {};

/* Performs initialization */
XsltDialog.initialize = function () {
    var field = null;
    
    XsltDialog.setOkButtonText($('mSaveAnyway').innerHTML);

    if (typeof (XsltDialog.ShowCallback) != 'undefined') {
        XsltDialog.ShowCallback();
    }

    if (XsltDialog.Fields) {
        for (var id in XsltDialog.Fields) {
            field = $(id);
            if (field) {
                field.value = XsltDialog.Fields[id];
            }
        }
    }
}

/* Performs finalization */
XsltDialog.finalize = function () {
    XsltDialog.setOkButtonText($('mSaveOK').innerHTML);

    XsltDialog.ShowCallback = null;
    XsltDialog.SaveCallback = null;
    XsltDialog.Fields = {};
}

/* Handles "OK" action */
XsltDialog.ok = function () {
    if (typeof (XsltDialog.SaveCallback) != 'undefined') {
        XsltDialog.SaveCallback();
    }

    XsltDialog.finalize();
    XsltDialog.close();
}

/* Handles "Cancel" action */
XsltDialog.cancel = function () {
    __snc_state_wait = false;
    XsltDialog.close();
}

/* Show dialog */
XsltDialog.show = function (params) {
    if (!params) {
        params = {};
    }

    if (typeof (params.onShow) == 'function') {
        XsltDialog.ShowCallback = params.onShow;
        params.onShow();
    }

    if (params.onSave) {
        XsltDialog.SaveCallback = params.onSave;
    }

    if (params.fields) {
        XsltDialog.Fields = params.fields;
    }

    dialog.show('XsltDialog');
}

/* Called when user accepts parse erorrs and clicks "Save anyway" button */
XsltDialog.errorsAccepted = function () {
    Editor.doSave(null, true, true);
}

/* Sets an "OK" button text */
XsltDialog.setOkButtonText = function (value) {
    var okBtn = dialog.get_okButton(Editor._dialogId);
    if (okBtn) {
        okBtn.innerHTML = value;
    }
}

/* Closes dialog */
XsltDialog.close = function () {
    dialog.hide('XsltDialog');
}

/* Sets an error message for the dialog */
XsltDialog.setError = function (error) {
    var errorContainer = $("InfoBar_errorInfobar").select(".alert-container")[0];    
    var alertIcon = errorContainer.select('i')[0].outerHTML;
    errorContainer.innerHTML = alertIcon + ' ' + error;
}

/*************  "Find/Replace" dialog routines *************/

var FindDialog = new Object();

var __find_cursor = null;
var __find_isVisible = false;
var __find_eventsInitialized = false;
var __find_menu = null;
var __find_skipClick = false;

FindDialog.initialize = function() {
    var menu = $('pSearch');
    var findField = $('txFind');

    FindDialog.hideReplace();
    FindDialog.updateFindState();

    __find_cursor = null;

    try {
        findField.focus();
    } catch (ex) { }

    __find_isVisible = true;
    FindDialog.fadeIn();

    if (!__find_eventsInitialized) {
        if (menu) {
            menu.observe('focus', FindDialog.fadeIn);
            menu.observe('click', function() {
                //if(!isIE()) {
                    if(__find_skipClick) {
                        __find_skipClick = false;
                    } else {
                        FindDialog.fadeIn()
                    }
                //} else {
                //    FindDialog.fadeIn();
                //}
            });
        }

        __find_eventsInitialized = true;
    }
}

FindDialog.close = function() {
    ContextMenu.hide('cmFind');
    Ribbon.unhoverButton('cmdFindReplace');
}

FindDialog.finalize = function() {
    __find_isVisible = false;
}

FindDialog.isVisible = function() {
    return __find_isVisible;
}

FindDialog.getMenuElement = function() {
    if (!__find_menu) {
        __find_menu = $('cmFind') || $('pSearch').up('.contextmenu');
    }

    return __find_menu;
}

FindDialog.showReplace = function() {
    var replaceField = $('txReplace');

    $('pReplaceText').hide();
    $('pReplace').show();

    try {
        replaceField.focus();
    } catch (ex) { }
}

FindDialog.hideReplace = function() {
    $('pReplaceText').show();
    $('pReplace').hide();
}

FindDialog.reset = function() {
    var pos = Editor.InternalObject.instance.getCursor();

    __find_cursor = null;
    Editor.InternalObject.instance.setSelection(pos);
}

FindDialog.updateFindState = function() {
    var enabled = $('txFind').value.length > 0;

    $$('.button-find button')[0].disabled = !enabled;
    $$('.button-replace button')[0].disabled = !enabled;
    $$('.button-replace-all button')[0].disabled = !enabled;
}

FindDialog.searchTextChanged = function(code) {
    var ret = true;

    if (code == 13) {
        FindDialog.executeFindNext();
        ret = false;
    } else {
        __find_cursor = null;
    }

    return ret;
}

FindDialog.replaceTextChanged = function(code) {
    var ret = true;

    if (code == 13) {
        FindDialog.executeReplace();
        ret = false;
    } else {
        __find_cursor = null;
    }

    return ret;
}

FindDialog.canExecute = function() {
    return !$('txFind').disabled;
}

FindDialog.executeFindNext = function(fromButton) {
    if (fromButton) {
        __find_skipClick = true;
    }

    if (FindDialog.canExecute()) {
        if (!FindDialog.findNext()) {
            alert($('mSearchingDone').innerHTML);
            FindDialog.reset();
        }
    }
}

FindDialog.executeReplace = function(fromButton) {
    if (fromButton) {
        __find_skipClick = true;
    }

    if (FindDialog.canExecute()) {
        if (FindDialog.selectionMatches())
            FindDialog.replaceSelection();
        else if (FindDialog.findNext())
            FindDialog.replaceSelection();
        else {
            alert($('mSearchingDone').innerHTML);
            FindDialog.reset();
        }
    }
}

FindDialog.executeReplaceAll = function(fromButton) {
    var replacedCount = 0;

    if (fromButton) {
        __find_skipClick = true;
    }

    if (FindDialog.canExecute()) {
        while (FindDialog.findNext()) {
            FindDialog.replaceSelection();
            replacedCount++;
        }

        alert($('mReplaced').innerHTML.replace('%%', replacedCount));
    }
}

/* Finds and highlights next match */
FindDialog.findNext = function () {
    var ret = false;
    var text = $('txFind').value;
    var matchCase = $('chkMatchCase').checked;

    if (__find_cursor == null) {
        var start = Editor.InternalObject.instance.firstLine();
        __find_cursor = Editor.InternalObject.instance.getSearchCursor(text, start, !matchCase);
    }

    if (__find_cursor) {
        if (__find_cursor.findNext()) {
            ret = true;
            Editor.InternalObject.instance.setSelection(__find_cursor.from(), __find_cursor.to());

            FindDialog.fadeOut();
        }
    }

    return ret;
}

FindDialog.fadeIn = function() {
    var c = $('pSearch');
    var contextMenu = $('cmFind');

    if (!contextMenu) {
        contextMenu = c.up('.contextmenu');
    }

    if (contextMenu) {
        contextMenu.removeClassName('search-panel-fade-out');
    }
}

FindDialog.fadeOut = function() {
    var c = $('pSearch');
    var contextMenu = $('cmFind');

    if (!contextMenu) {
        contextMenu = c.up('.contextmenu');
    }

    if (contextMenu) {
        contextMenu.addClassName('search-panel-fade-out');
    }
}

/* Replaces current match with value from 'Replace' text field */
FindDialog.replaceSelection = function() {
    var replacement = $('txReplace').value;

    if (__find_cursor) {
        __find_cursor.replace(replacement);
    }
}

/* Retrieves selected text */
FindDialog.getSelection = function() {
    return Editor.InternalObject.instance.getSelection();
}

/* Determines whether currently selected text matches value in 'Find' text field */
FindDialog.selectionMatches = function() {
    var selection = FindDialog.getSelection();
    var ret = false;

    if (selection && selection.length > 0)
        ret = (selection == $('txFind').value);

    return ret;
}

/* Set search text value in 'Find' text field */
FindDialog.setSearchText = function (searchText) {
    if (searchText !== undefined)
        $('txFind').value = searchText;
    else
        $('txFind').value = FindDialog.getSelection();
}



