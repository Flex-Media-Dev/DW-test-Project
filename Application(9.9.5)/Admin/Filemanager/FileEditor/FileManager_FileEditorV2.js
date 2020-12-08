/***************************************************************************************************

	Current version:	1.4
	Created:		    03-05-2008
	Last modified:	    07-06-2010
	
	Purpose: 
	
	    Client-side implementation of template editor.
	
	Revision history:
	
		1.0 - 03-05-2008 - Pavel Volgarev
		    1. First version.
		
		1.1 - 15-09-2008 - Pavel Volgarev
		    1. Some changes in 'Save as' dialog, ribbon bar integrated.
		    2. 'Convert to XSLT' button added.
		
		1.2 - 20-09-2008 - Pavel Volgarev
			1. 'Template tags' functionality implemented.
			
	    1.3 - 06-11-2008 - Pavel Volgarev
	        1. 'Find & Replace' functionality added.
	    1.4 - 07-06-2010 - Pavel Volgarev
	        1. Migration from Codepress to CodeMirror.
	        2. Migration from jQuery to Prototype JS.
	        3. Performance optimizations.
			
***************************************************************************************************/

/* 'Save and close' state - value indicating whether 
all operations are completed and we can close the window */
var __snc_state = false;

/* value indicating whether we need to continue waiting 
for operations to be completed */
var __snc_state_wait = false;

/* Current slider state  (mouse y-coordinate) */
var __slider_current = null;

var __editor_state_timeout = null;

/* Firefox XPath support */
if (!window.ActiveXObject) {
    Document.prototype.selectNodes = Element.prototype.selectNodes = function (xpath) {
        var element = null;
        var ret = new Array();
        var evaluator = new XPathEvaluator();
        var result = evaluator.evaluate(xpath, this, null, XPathResult.ORDERED_NODE_ITERATOR_TYPE, null);

        if (result != null) {
            element = result.iterateNext();
            while (element) {
                ret.push(element);
                element = result.iterateNext();
            }
        }

        return ret;
    }

    Document.prototype.selectSingleNode = Element.prototype.selectSingleNode = function (xpath) {
        var ret = null;
        var evaulator = new XPathEvaluator();
        var result = evaulator.evaluate(xpath, this, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);

        if (result != null) {
            ret = result.singleNodeValue;
        }

        return ret;
    }
}

/*************  Page handling routines. *************/

var Page = new Object();

/* Fires when the page has beed loaded */
Page.onLoad = function () {
    /* disabling default context menu */
    document.oncontextmenu = function (e) {
        if (e) e.preventDefault();
        return false;
    }

    safeCall(function () {
        window.onresize = function () {
            Page.onResize();
        }
    });

    document.onscroll = function () {
        return false;
    }

    /* resizing editing area to fill remaining window space */
    safeCall(function () {
        Page.resizeEditingArea();
    });

    /* attaching  AJAX error handler */

    var onError = function () {
        toggleProcessing(false);
        toggleProcessing(false, 'pSaveAsLoading');
        showMessage('mAjaxError', false);
    }

    Ajax.Responders.register({
        onException: onError
    });

    Editor.updateStatus();

    createEvent('pSearch', 'click', function (e) {
        e.stopPropagation();
    });

    var focusCallbak = function () {
        if (FindDialog.isVisible()) {
            FindDialog.fadeOut();
        }
    }

    Editor.updateUndoRedoStates();

    /* Focusing on editing area */
    safeCall(function () {
        Editor.InternalObject.instance.focus();
    });
}

/* Performs page refresh */
Page.refresh = function () {
    var queryString = location.search;
    var file = $("InitialFileName").value;
    var folder = $("InitialFileDir").value;

    queryString = queryString.replace(/File=([^?&]+)/gi, 'File=' + encodeURIComponent(file));
    queryString = queryString.replace(/Folder=([^?&]+)/gi, 'Folder=' + encodeURIComponent(folder));

    location.href = location.pathname + queryString;
}

/* Fires when the page has been resized */
Page.onResize = function () {
    /* resizing editing area to fill remaining window space */
    /* this.resizeEditingArea();
    Editor.ModalWindow.center();*/
}

/* Resizes the editing are to fill remaining window space */
Page.resizeEditingArea = function () {
    /*
        var editingArea = $('rowEditingArea');
        $(editingArea.select('iframe')[0]).setStyle({ height: editingArea.getHeight() });
        TemplateTagsSlider.reset();*/
}

/* Toggles the ribbon bar button state */
Page.toggleRibbonbarButton = function (buttonID, active, className) {
    if (!className)
        className = 'active';

    if (active)
        $(buttonID).addClassName(className);
    else
        $(buttonID).removeClassName(className);
}

/* Retrieves module system name from the directory of the module template */
Page.moduleNameFromPath = function () {
    var dir = $("InitialFileDir").value.toLowerCase();
    var ret = dir;

    if (dir.search('/') != 0)
        dir = '/' + dir;

    if (dir.search('/files/') != 0)
        dir = '/files' + dir;

    var parts = dir.split('/');
    var dirCount = 0;
    for (var i = 0; i < parts.length; i++) {
        if (parts[i].length > 0) {
            if ((parts[i] == 'files' || parts[i] == 'templates') && dirCount < 2) {
                dirCount++;
                continue;
            }
            else {
                ret = parts[i];
                break;
            }
        }
    }

    return ret;
}

/*************  Class which handles edit operations *************/

if (typeof (Editor) == 'undefined') {
    var Editor = new Object();
}

Editor._previousFile = '';
Editor._isCanBeConverted = false;

/* 'Cut' operation */
Editor.cut = function () {
    if (window.clipboardData) {
        if (this.copy()) {
            Editor.InternalObject.instance.replaceSelection("");
        }
    }
    else {
        this.exec('cut');
    }
}

Editor.extensionChanged = function () {
    var ret = false;
    var f = $("InitialFileName").value;

    if (Editor._previousFile) {
        ret = Editor.getExtension(f.toLowerCase()) !=
            Editor.getExtension(Editor._previousFile).toLowerCase();
    }

    return ret;
}

/* 'Copy' operation */
Editor.copy = function () {
    if (window.clipboardData) {
        window.clipboardData.clearData();
        return window.clipboardData.setData("Text", Editor.InternalObject.instance.getSelection());
    }
    else {
        this.exec('copy');
    }
    return false;
}

/* 'Paste' operation */
Editor.paste = function () {
    if (window.clipboardData) {
        var ret = window.clipboardData.getData("Text");
        if (ret) {
            Editor.InternalObject.instance.replaceSelection(ret, "end");
        }
        Editor.InternalObject.instance.focus();
    }
    else {
        this.exec('paste');
    }
}

/* 'Undo' operation */
Editor.undo = function () {
    var isXslt = false;
    var isRazor = false;

    if (!$('cmdUndo').hasClassName('disabled')) {
        Editor.InternalObject.instance.undo();

        if (this._isCanBeConverted) {
            isXslt = Editor.getCode().indexOf('xsl:stylesheet') >= 0;
            isRazor = !isXslt && Editor.getCode().indexOf('@GetValue(') >= 0;

            this.updateConvertButtonsState(isXslt, isRazor);
            this.updateHtmlButtonState(!isXslt || isRazor);
        }

        this.updateUndoRedoStates();
    }
}

/* 'Redo' operation */
Editor.redo = function () {
    var isXslt = false;
    var isRazor = false;

    if (!$('cmdRedo').hasClassName('disabled')) {
        Editor.InternalObject.instance.redo();

        if (this._isCanBeConverted) {
            isXslt = Editor.getCode().indexOf('xsl:stylesheet') >= 0;
            isRazor = !isXslt && Editor.getCode().indexOf('@GetValue(') >= 0;

            this.updateConvertButtonsState(isXslt, isRazor);
            this.updateHtmlButtonState(!isXslt || isRazor);
        }

        this.updateUndoRedoStates();
    }
}

/* Updates 'undo' and 'redo' buttons states */
Editor.updateUndoRedoStates = function () {
    var history = Editor.InternalObject.instance ? Editor.InternalObject.instance.historySize() : null;

    if (history != null) {
        Page.toggleRibbonbarButton('cmdUndo', history.undo <= 0, 'disabled');
        Page.toggleRibbonbarButton('cmdRedo', history.redo <= 0, 'disabled');
    }
}

/* determines whether current file is a unsaved file */
Editor.isNewFile = function () {
    var fName = $("InitialFileName").value;
    return (fName.length == 0);
}



/* 'Save' operation */
Editor.save = function (withoutXsltCheck, onSaved) {
    var callback = null;
    var saveAsFile = Editor.tryGetCurrentFile();
    var initialFile = $("InitialFileName");

    var fileConvertedXslt = (!this.checkXsltExtension(initialFile.value) && this.isXsltFileLoaded());
    var fileConvertedRazor = (!this.checkRazorExtension(initialFile.value) && this.isRazorFileLoaded());

    saveAsFile = (saveAsFile.value == undefined) ? saveAsFile : saveAsFile.value;
    if (this.isNewFile() || fileConvertedXslt) {
        if (!this.isNewFile() && !this.checkXsltExtension(saveAsFile)) {
            saveAsFile += '.xslt';
        }
        SaveAsDialog.show(fileConvertedRazor, fileConvertedXslt);
    }
    else if (this.isNewFile() || fileConvertedRazor) {
        if (!this.isNewFile() && !this.checkRazorExtension(saveAsFile)) {
            saveAsFile += '.cshtml';
        }
        SaveAsDialog.show(fileConvertedRazor, fileConvertedXslt);
    }
    else {
        var onDuringSave = function (data) {
            if (typeof (onSaved) === 'function') {
                onSaved(data);
            }
            toggleProcessing(false);
            if (winOpener.reloadPage) {
                winOpener.reloadPage(true);
            }
        };
        this.doSave(onDuringSave, false, withoutXsltCheck);
    }
}

Editor.checkXsltExtension = function (file) {
    var ext = this.getExtension(file);
    return (ext == 'xsl' || ext == 'xslt');
}

Editor.checkRazorExtension = function (file) {
    var ext = this.getExtension(file);
    return (ext == 'cshtm' || ext == 'cshtml' || ext == 'vbhtm' || ext == 'vbhtml');
}

Editor.tryGetCurrentFile = function () {
    var ctrl = $('txFileName');

    if (ctrl && ctrl.value) {
        return ctrl.value;
    }
    return '';
}

/* Save and close' operation */
Editor.saveAndClose = function () {
    var saveAsFile = Editor.tryGetCurrentFile();
    var initialFile = $("InitialFileName");
    var fileConvertedXslt = (!this.checkXsltExtension(initialFile.value) && this.isXsltFileLoaded());
    var fileConvertedRazor = (!this.checkRazorExtension(initialFile.value) && this.isRazorFileLoaded());
    var onSave = function () { Editor.waitForClose(); };

    saveAsFile = (saveAsFile.value == undefined) ? saveAsFile : saveAsFile.value;
    if (this.isNewFile() || fileConvertedXslt) {
        if (!this.isNewFile() && !this.checkXsltExtension(saveAsFile)) {
            saveAsFile += '.xslt';
        }

        /* Starting to wait to close the editor */
        __snc_state_wait = true;
        onSave();

        SaveAsDialog.show(fileConvertedRazor, fileConvertedXslt);
    }
    else if (this.isNewFile() || fileConvertedRazor) {
        if (!this.isNewFile() && !this.checkRazorExtension(saveAsFile)) {
            saveAsFile += '.cshtm';
        }

        /* Starting to wait to close the editor */
        __snc_state_wait = true;
        onSave();
        SaveAsDialog.show(fileConvertedRazor, fileConvertedXslt);
    }
    else {        
        onSave = function (data) {
            toggleProcessing(false);
            if (winOpener.reloadPage) {
                winOpener.reloadPage(true);
            }
            window.close();
        };        

        this.doSave(onSave);
    }
}

/* Waits to allow to close the editor */
Editor.waitForClose = function () {
    if (__snc_state)
        winOpener.reloadPage(true);
    else
        if (__snc_state_wait)
            setTimeout(function () { Editor.waitForClose(); }, 100);
}

/* 'Save as' operation */
Editor.saveAs = function () {
    var initialFile = $("InitialFileName");
    var fileConvertedXslt = (!this.checkXsltExtension(initialFile.value) && this.isXsltFileLoaded());
    var fileConvertedRazor = (!this.checkRazorExtension(initialFile.value) && this.isRazorFileLoaded());
    SaveAsDialog.show(fileConvertedRazor, fileConvertedXslt);
}

/* Clear an extensinon of InitialFileName */
Editor.clearCurrentFileExtension = function () {
    var cName = $("InitialFileName").value;
    cName = cName.replace(/\.(?:html)$/i, '');
    $("InitialFileName").value = cName;
}

/* Displays simple editor */
Editor.simpleEditor = function () {
    Editor.save(null, function () {
        location = 'Simple.aspx' + location.search;
    });
}

/* 'Fix HTML' operation */
Editor.fixHTML = function () {
    var self = this;

    if (!$('cmdCheck').hasClassName('disabled')) {
        var data = {
            Action: 'FixHTML',
            Text: Editor.getCode()
        }

        toggleProcessing(true);

        new Ajax.Request('FileManager_FileEditorV2.aspx', {
            method: 'post',
            parameters: data,
            onComplete: function (response) { self.onHTMLFixed(response.responseText); }
        });
    }
}

/* Determines whether xslt stylesheet is loaded */
Editor.isXsltFileLoaded = function () {
    var isXslt = $('IsXsltFile').value.toLowerCase();
    return (isXslt.length > 0 && isXslt == 'true');
}

/* Determines whether razor template is loaded */
Editor.isRazorFileLoaded = function () {
    var isRazor = $('IsRazorFile').value.toLowerCase();
    return (isRazor.length > 0 && isRazor == 'true');
}

/* 'Convert to XSLT' operation */
Editor.convertToXslt = function () {
    var self = this;

    if (!this.isXsltFileLoaded() && !this.isRazorFileLoaded() &&
        !$('cmdConvertToXslt').hasClassName('disabled')) {

        var data = {
            Action: 'ConvertToXslt',
            Text: this.getCode()
        }

        if (confirm($('mConvertConfirm').innerHTML)) {
            toggleProcessing(true);
            new Ajax.Request('FileManager_FileEditorV2.aspx', {
                method: 'post',
                parameters: data,
                onComplete: function (response) { self.onFileConverted(response.responseText, true, false); }
            });
        }
    }
}

/* 'Convert to Razor' operation */
Editor.convertToRazor = function () {

    if (!this.isXsltFileLoaded() && !this.isRazorFileLoaded() &&
        !$('cmdConvertToRazor').hasClassName('disabled')) {

        if (confirm($('mConvertConfirm').innerHTML)) {
            var rslt = TemplateRazor.convert(this.getCode());
            this.onFileConverted(rslt, false, true);
            //Editor.InternalObject.instance.setMode("razor")
            Editor.InternalObject.instance.setOption("mode", "razor");
            //CodeMirror.autoLoadMode(editor, modeInput.value); ;
            //If the template after the conversion still contains <!--@ the user can be alerted that there are things that are not parsed, and needs to be handled by hand.
            if (rslt.search(/<!--@/) >= 0) {
                alert($('mConvertResult').innerHTML);
            }
        }
    }
}

/* Fires when the 'Convert to ..' response has come  */
Editor.onFileConverted = function (data, isXslt, isRazor) {
    toggleProcessing(false);

    /* We've got a converted HTML. Replacing old code. */
    if (data.length > 0) {
        this.updateConvertButtonsState(isXslt, isRazor);
        this.updateHtmlButtonState(isRazor);

        Editor.setCode(data);
        this.updateUndoRedoStates();
    }

}

/* Fires when the 'Fix HTML' response has come  */
Editor.onHTMLFixed = function (data) {
    toggleProcessing(false);

    /* We've got a fixed HTML. Replacing old code. */
    if (data.length > 0) {
        Editor.setCode(data);
    }
}

/* Validates current XSLT stylesheet */
Editor.checkXslt = function (onChecked) {
    var data = {
        Action: 'CheckXSLT',
        Text: this.getCode()
    }

    toggleProcessing(true);
    new Ajax.Request('FileManager_FileEditorV2.aspx', {
        method: 'post',
        parameters: data,
        onComplete: function (response) { if (onChecked) onChecked(response.responseText); }
    });
}

/* Retrieves ajax-safe source code */
Editor.getCode = function (encode) {
    var tx = Editor.InternalObject.instance.getValue();

    if (encode) {
        tx = tx.replace(/&/gi, '_!&!_');
        tx = tx.replace(/&#/gi, '_!&!_#');
        tx = tx.replace(/</gi, '&lt;');
        tx = tx.replace(/>/gi, '&gt;');
    }

    return tx;
}

/* Sets editor area content */
Editor.setCode = function (value) {
    Editor.InternalObject.instance.setValue(value);
}

/* Saves current file */
Editor.doSave = function (onSave, fromSaveAs, withoutXsltCheck) {
    var cName = $($$('input.initial-filename')[0]);
    var cDir = $($$('input.initial-directory')[0]);

    var fName = cName.value;
    var fDir = cDir.value;

    /* Was this procedure called by 'Save as' dialog ? */
    if (fromSaveAs != null && fromSaveAs) {
        fName = $('txFileName').value;
        fDir = SaveAsDialog.getDirectory()[0];

        /* Data comes from the XsltDialog */
        if (typeof (fName) == 'undefined') {
            fName = $('XsltFilename').value;
            fDir = $('XsltDirectory').value;
        }
    }

    /* Should we validate the file as XSLT stylesheet ? */
    if (withoutXsltCheck == null || withoutXsltCheck == false) {
        var ext = this.getExtension(fName);
        if (ext.length > 0 && (ext == 'xsl' || ext == 'xslt')) {
            this.checkXslt(function (data) {
                if (data.length > 0) {
                    var onOkClick = null;

                    if (onSave == null || typeof (onSave) != 'function')
                        onOkClick = XsltDialog.errorsAccepted;
                    else
                        onOkClick = function () { XsltDialog.errorsAccepted(); onSave(); }

                    toggleProcessing(false);

                    XsltDialog.show({
                        onSave: function () { onOkClick(); },
                        onShow: function () { XsltDialog.setError(data); },
                        fields: { XsltFilename: fName, XsltDirectory: fDir }
                    });
                }
                else
                    Editor.sendFile(fName, fDir, onSave);
            });
        }
        else
            Editor.sendFile(fName, fDir, onSave);
    }
    else
        Editor.sendFile(fName, fDir, onSave);
}

/* Updates 'Convert to ...' button state according to new file extension */
Editor.updateConvertButtonsState = function (isXslt, isRazor) {
    var cmdXslt = $('cmdConvertToXslt');
    var cmdRazor = $('cmdConvertToRazor');

    if (cmdXslt && cmdRazor && typeof (cmdXslt.addClassName) == 'function') {
        if (isXslt || isRazor) {
            cmdXslt.addClassName('disabled');
            cmdRazor.addClassName('disabled');
            $('IsXsltFile').value = isXslt;
            $('IsRazorFile').value = isRazor;
        }
        else {
            cmdXslt.removeClassName('disabled');
            cmdRazor.removeClassName('disabled');
            $('IsXsltFile').value = 'false';
            $('IsRazorFile').value = 'false';
        }
    }

}

/* Updates 'Check HTML' button state according to new file extension */
Editor.updateHtmlButtonState = function (isHtml) {
    var cmd = $('cmdCheck');

    if (cmd && typeof (cmd.addClassName) == 'function') {
        if (!isHtml) {
            cmd.addClassName('disabled');
        }
        else {
            cmd.removeClassName('disabled');
        }
    }
}

/* Retrieves file extension from the file name */
Editor.getExtension = function (fileName) {
    var ret = '';

    if (fileName.indexOf('.') >= 0 &&
		fileName.indexOf('.') < (fileName.length - 1)) {

        ret = fileName.substring(fileName.lastIndexOf('.') + 1,
			fileName.length).toLowerCase();
    }

    return ret;
}

/* Posts current file to the server */
Editor.sendFile = function (fileName, fileDir, onFileSent) {

    var callback,
        data = {
            Text: Editor.getCode(true),
            FileName: fileName,
            FileDirectory: fileDir
            //IsUnicode: ($("chkUnicode").value.length > 0 ? 'on' : '')
        },
        func = function () {

            /* Editor is waiting to be allowed to exit. Allowing... */
            if (__snc_state_wait)
                __snc_state = true;
            else {
                var ext = Editor.getExtension(fileName);

                toggleProcessing(false);
                Editor.updateConvertButtonsState(Editor.checkXsltExtension(fileName), Editor.checkRazorExtension(fileName));
                Editor.updateHtmlButtonState((ext.length > 0 && (ext == 'htm' || ext == 'html' || ext == 'xhtml' || ext == 'cshtm' || ext == 'cshtml')));

                $("InitialFileName").value = fileName;
                $("InitialFileDir").value = fileDir;
                Editor.updateStatus();
            }
        };

    if (onFileSent == null || typeof (onFileSent) != "function") {
        callback = func;
    } else {
        callback = function () {
            func();
            onFileSent(data);
        };
    }

    toggleProcessing(true);

    new Ajax.Request('FileManager_FileEditorV2.aspx', {
        method: 'post',
        parameters: data,
        onComplete: function (response) {
            var statusCode = null;
            var canProcess = true;
            var statusMessage = '';

            if (data && response.responseText.length > 1) {
                statusCode = response.responseText.substr(0, 1);

                if (statusCode != '0' && response.responseText.length > 2) {
                    statusMessage = response.responseText.substr(2, response.responseText.length - 2);

                    canProcess = false;

                    toggleProcessing(false);
                    Page.closeAllDialogs();

                    alert($('mUnableToSaveFile').innerHTML + '\n\n' + statusMessage);
                }
            }

            if (canProcess && typeof (onFileSent) != 'undefined') {
                callback(data);
            }
        }
    });
}

/* Executes edit operation */
Editor.exec = function (command) {
    var wnd = window; // Editor.InternalObject.instance.win;

    /* Fix of IE8 */
    if (isIE() && command == 'paste') {
        try {
            wnd.focus();
        } catch (ex) { }
    }

    try {
        wnd.document.execCommand(command, false, null);
    } catch (ex) {
        /* 
        Firefox sometimes throws an exception, but command executes successfully. 
        We don't need to display a warning message in this case 
        */
        if ((command == 'cut' || command == 'copy' || command == 'paste') && (ex.toString().indexOf("NS_ERROR_ILLEGAL_VALUE") < 0))
            showMessage('mClipboardNotAllowed', false);
    }

    if (!isIE()) {
        setTimeout(function () { Editor.InternalObject.instance.focus(); }, 500);
    }

    setTimeout(function () {
        Editor.updateUndoRedoStates();
    }, 100);
}

/* Updates status bar text */
Editor.updateStatus = function () {
    var hasStatus = false;
    var cName = $("InitialFileName").value;
    var cDir = $("InitialFileDir").value;
    var statusText = '&nbsp;';

    if (cName.length > 0) {
        if (cDir.length > 0) {
            if (cDir.charAt(0) != '/')
                cDir = '/' + cDir;
            if (cDir.charAt(cDir.length - 1) != '/')
                cDir = cDir + '/';
            if (cDir.search(/Files/) != 2)
                cDir = '/Files' + cDir;
        }
        else
            cDir = '/Files/';

        hasStatus = true;
        statusText = (cDir + cName).replace('//', '/');
    }

    if (!hasStatus) {
        statusText = $('mNoFile').innerHTML;
    }

    if (Editor._previousFile) {
        if (Editor.extensionChanged()) {
            Editor.showRefreshBalloon();
        }
    } else {
        Editor._previousFile = cName;
    }

    $('pStatus').innerHTML = statusText;
    document.title = $('mPageTitle').innerHTML + ' - ' + cName;
}

Editor.showRefreshBalloon = function () {
    $('refreshBalloon').show();
}

Editor.hideRefreshBalloon = function () {
    $('refreshBalloon').hide();
}

Editor.InternalObject = new Object();

Editor.InternalObject.instance = null;
Editor.InternalObject.mode = '';

/* Initializes an editor */
Editor.InternalObject.initialize = function (params) {
    if (!params) {
        params = {}
    }

    if (params.id && Editor.InternalObject.instance == null) {
        Editor.InternalObject.instance = CodeMirror.fromTextArea($(params.id), {
            mode: Editor.InternalObject.mode,
            tabMode: 'indent',
            lineNumbers: false,
            textWrapping: false,
            historyEventDelay: 100
        });
    }
    Editor.InternalObject.instance.on("change", function () { Editor.updateUndoRedoStates(); });
    Editor.InternalObject.instance.setSize("100%", "100%");
}

/*************  Common used routines *************/

function safeCall(func, tryNum) {
    var tryMax = 20;

    if (!tryNum)
        tryNum = 1;

    if (tryNum <= tryMax) {
        if (typeof (func) == 'function') {
            try {
                func();
            } catch (ex) {
                setTimeout(function () {
                    safeCall(func, (tryNum + 1));
                }, 50);
            }
        }
    }
}

/* displays an alert (confirm) message */
function showMessage(messageID, isConfirm) {
    var msg = document.getElementById(messageID).innerHTML;
    var ret = true;

    if (!isConfirm)
        alert(msg);
    else
        ret = confirm(msg);

    return ret;
}

/* Shows (or hides) specified progress image */
function toggleProcessing(show, id) {
    var img = null;
    var imgID = 'pLoading';

    if (id != null)
        imgID = id;

    img = imgID;
    if (typeof (imgID.toLowerCase) != 'undefined') {
        img = $(imgID);
    }

    if (imgID == 'pLoading' || imgID == 'LoadingDialog')
        toggleProcessingMain(show);
    else {
        if (show)
            img.show();
        else
            img.hide();
    }
}

/* Shows (or hides) the main processing splash screen */
function toggleProcessingMain(show) {
    var elm = $('LoadingDialog');

    if (elm) {
        if (show) {
            elm.show();
        } else {
            elm.hide();
        }
    }
}

/* Attaches a new event handler to DOM element */
function createEvent(id, eventName, onEvent) {
    $(id).stopObserving(eventName);
    $(id).observe(eventName, onEvent);
}

function attr(obj, attributeName, value) {
    var ret = '';
    var o = obj;

    if (o) {
        if (typeof (o.toLowerCase) != 'undefined') {
            o = $(o);
        }
    }

    if (o && attributeName) {
        if (typeof (value) == 'undefined') {
            if (typeof (o.getAttribute) != 'undefined') {
                ret = o.getAttribute(attributeName);
            } else if (typeof (o.readAttribute) != 'undefined') {
                ret = o.readAttribute(attributeName);
            }
        } else {
            if (typeof (o.setAttribute) != 'undefined') {
                o.setAttribute(attributeName, value);
            } else if (typeof (obj.writeAttribute) != 'undefined') {
                o.writeAttribute(attributeName, value);
            }
        }
    }

    return ret;
}

function eventTarget(e) {
    var ret = null;

    if (e) {
        if (e.target) {
            ret = e.target;
        } else if (e.srcElement) {
            ret = e.srcElement;
        }
    }

    return ret;
}

/* Determines whether Internet Explorer is used */
function isIE() {
    return (typeof (document.attachEvent) != 'undefined');
}

/*************  Razor converter *************/

if (typeof (TemplateRazor) == 'undefined') {
    var TemplateRazor = new Object();
}

TemplateRazor.reLoop = /<!--@LoopStart\(([\s\S]*?)\)-->([\s\S]*?)<!--@LoopEnd\(\1\)-->/g;
TemplateRazor.reTag = /<!--@((?!If|EndIf|Translate|Global:Page.Content|Global:Paragraph.Content)[\s\S]*?)-->/g;
TemplateRazor.reIfDefined = /<!--@If Defined\(([\s\S]*?)\)-->([\s\S]*?)<!--@EndIf\(\1\)-->/g;
TemplateRazor.reIfNotDefined = /<!--@If Not Defined\(([\s\S]*?)\)-->([\s\S]*?)<!--@EndIf\(\1\)-->/g;

TemplateRazor.convert = function (html) {
    var str = html; // document.body.innerHTML;
    /*
    str = "blablabla<!--@LoopStart(BOMItems)-->" +
    "<td nowrap><!--@Ecom:Order:OrderLine.Quantity--></td>" +
    "</tr>" +
    "<!--@LoopEnd(BOMItems)-->";
    */
    str = str.replace(this.reLoop, this.loopReplacer.bind(this, 1));
    str = str.replace(this.reIfDefined, this.ifDefinedReplacer);
    str = str.replace(this.reIfNotDefined, this.ifNotDefinedReplacer);
    str = str.replace(this.reTag, this.tagReplacer);
    return str;
}

// First run through the template and find all loops (LoopStart() and LoopEnd())
// <!--@LoopStart(Images)--> becomces @foreach (LoopItem i in GetLoop("Images")){
// <!--@LoopEnd(Images)--> becomes }
TemplateRazor.loopReplacer = function (depth, match, loopName, loopContent) {
    var loopItem = 'i' + (depth == 1 ? '' : depth);

    loopContent = loopContent.replace(this.reLoop, this.loopReplacer.bind(this, depth + 1));
    loopContent = loopContent.replace(this.reIfDefined, this.loopIfDefinedReplacer.bind(this, loopItem));
    loopContent = loopContent.replace(this.reIfNotDefined, this.loopIfNotDefinedReplacer.bind(this, loopItem));
    loopContent = loopContent.replace(this.reTag, this.loopTagReplacer.bind(this, loopItem));
    return '@foreach (LoopItem ' + loopItem + ' in GetLoop("' + loopName + '")){' + loopContent + '}';
}

// Handle if defined in loop
// <!--@If Defined(Ecom:Order:OrderLine.ProductVariantText)--> <b>AreaID defined.<br /></b> <!--@EndIf(DwAreaID)-->
// becomes @if (Core.Converter.ToBoolean(ol.GetValue("Ecom:Order:OrderLine.ProductVariantText"))){<text><b>AreaID defined.<br /></b></text>}
TemplateRazor.loopIfDefinedReplacer = function (loopItem, match, ifName, ifContent, offset, s) {
    ifContent = ifContent.replace(this.reIfDefined, this.loopIfDefinedReplacer.bind(this, loopItem));
    return '@if(Core.Converter.ToBoolean(' + loopItem + '.GetValue("' + ifName + '"))){<text>' + ifContent + '</text>}';
}

// Handle not defined in loop
// <!--@If Not Defined(Ecom:Order:OrderLine.ProductVariantText)--> <b>AreaID defined.<br /></b> <!--@EndIf(DwAreaID)-->
// becomes @if (!Core.Converter.ToBoolean(ol.GetValue("Ecom:Order:OrderLine.ProductVariantText"))){<text><b>AreaID defined.<br /></b></text>}
TemplateRazor.loopIfNotDefinedReplacer = function (loopItem, match, ifName, ifContent, offset, s) {
    ifContent = ifContent.replace(this.reIfNotDefined, this.loopIfNotDefinedReplacer.bind(this, loopItem));
    return '@if(!Core.Converter.ToBoolean(' + loopItem + '.GetValue("' + ifName + '"))){<text>' + ifContent + '</text>}';
}

// All template tags inside loops are handled
// <!--@Gallery.Image.Thumb.Medium--> becomes @i.GetValue("Gallery.Image.Thumb.Medium")
TemplateRazor.loopTagReplacer = function (loopItem, match, tagName) {
    return '@' + loopItem + '.GetValue("' + tagName + '")';
}

// Handle if defined
// <!--@If Defined(DwAreaID)--> <b>AreaID defined.<br /></b> <!--@EndIf(DwAreaID)-->
// becomes @if(Core.Converter.ToBoolean(GetValue("DwAreaID"))){<text><b>AreaID defined.<br /></b></text>}
TemplateRazor.ifDefinedReplacer = function (match, ifName, ifContent, offset, s) {
    ifContent = ifContent.replace(this.reIfDefined, this.ifDefinedReplacer);
    return '@if(Core.Converter.ToBoolean(GetValue("' + ifName + '"))){<text>' + ifContent + '</text>}';
}

// Handle if not defined
// <!--@If Not Defined(DwAreaID)--> <b>AreaID defined.<br /></b> <!--@EndIf(DwAreaID)-->
// becomes @if(!Core.Converter.ToBoolean(GetValue("DwAreaID"))){<text><b>AreaID defined.<br /></b></text>}
TemplateRazor.ifNotDefinedReplacer = function (match, ifName, ifContent, offset, s) {
    ifContent = ifContent.replace(this.reIfNotDefined, this.ifDefinedReplacer);
    return '@if(!Core.Converter.ToBoolean(GetValue("' + ifName + '"))){<text>' + ifContent + '</text>}';
}

// Regular tags
// replace <!--@whatever--> with @GetValue("whatever")
TemplateRazor.tagReplacer = function (match, tagName, offset, s) {
    return '@GetValue("' + tagName + '")';
}


