var FileManagerPage = function () {
	this.onHelp = null;
	this.pageContentID = "ContentFrame";
	this.folder = "";
	this.folderID = 0;
	this.deleteMsg = "";
	this.deleteSeveralFilesMsg = "Delete selected files";
	this.restoreMsg = "";
	this.restoreSeveralFilesMsg = "Restore selected files";
	this.imageExtensions = new Array();
	this.editableExtensions = new Array();
	this.thumbnailView = null;
	this.hasAccessEdit = false;
	this.hasAccessCreate = false;
	this.hasAccessDelete = false;
}

FileManagerPage.prototype.initialize = function () {
	this.stretchContent();
	if (window.attachEvent) {
		window.attachEvent('onresize', function () { __page.stretchContent(); });
	} else if (window.addEventListener) {
		window.addEventListener('resize', function (e) { __page.stretchContent(); }, false);
	}
}

FileManagerPage.prototype.stretchContent = function () {
	var toolbarHeight = 0;
	var content = $(this.pageContentID);
	if (content) {
		toolbarHeight = $('divToolbar').getHeight();
		content.setStyle({ 'height': (document.body.clientHeight - toolbarHeight) + 'px' });
	}
}

FileManagerPage.prototype.metadata = function (dialogId) {	
	var qs = Object.toQueryString({
		'folder': encodeURIComponent(this.folder)
	});

	dialog.show(dialogId, '/Admin/Filemanager/Metadata/BulkEdit.aspx?' + qs);
}

FileManagerPage.prototype.metafields = function (dialogId) {
	var qs = Object.toQueryString({
	    'folder': encodeURIComponent(this.folder),
        'dialogId' : dialogId
	});
	
	dialog.show(dialogId, '/Admin/Filemanager/Metadata/ConfigurationEdit.aspx?' + qs);
}

FileManagerPage.prototype.help = function () {
	if (typeof (this.onHelp) == 'function') {
		this.onHelp();
	}
}

FileManagerPage.prototype.checkToolbarButtons = function (rows, fileName) {
    var enable = rows.length > 0;
    var toggle = enable ? Ribbon.enableButton : Ribbon.disableButton;

    if (this.hasAccessEdit) {
        if (this.hasAccessDelete) {
            toggle('btnMove');
            toggle('btnDelete');
        }
        if (this.hasAccessCreate) {
            toggle('btnCopy');
            toggle('btnFileRename');
        }

        toggle('btnMetatags');
        toggle('btnRestore');

        if (enable && (this.isImage(fileName) || this.isEditable(fileName))) {
            Ribbon.enableButton('btnFileEdit');
        } else {
            Ribbon.disableButton('btnFileEdit');
        }
    }
}


FileManagerPage.prototype.setListMode = function (mode) {

	//take previous view settings
	var searchPhrase = document.getElementById("Files:TextFilter");
	var searchInSubfolder = document.getElementById("Files:SearchInSubfoldersFilter");
	var selectedPageNumber = document.getElementById("FilesCurentPage");
	var selectedPageSize = document.getElementById("Files:PageSizeFilter");
	var selectedSortBy = document.getElementById("FilesSortBy");
	var selectedSortDir = document.getElementById("FilesSortDir");

	//copy view settings to URL 
	var contextParams = "";
    if (searchPhrase && searchPhrase.value.length > 0 && !WaterMark.get_emptyState(searchPhrase))
		contextParams += "&searchPhrase=" + encodeURIComponent(searchPhrase.value);
	if (searchInSubfolder && searchInSubfolder.checked)
		contextParams += "&SearchInSubfoldersFilter=true";
	if (selectedPageNumber && selectedPageNumber.value.length > 0)
		contextParams += "&selectedPageNumber=" + selectedPageNumber.value;
	if (selectedPageSize)
		contextParams += "&selectedPageSize=" + selectedPageSize.options[selectedPageSize.selectedIndex].value;
	if (selectedSortBy)
		contextParams += "&selectedSortBy=" + selectedSortBy.value;
	if (selectedSortDir)
		contextParams += "&selectedSortDir=" + selectedSortDir.value;


	var src = document.location.href;
	if (src.endsWith('#'))
		src = src.substr(0, src.length - 1);

	//clear duplicates of view settings
	var params = src.toQueryParams();
	if (params.ListMode)
		src = src.replace("&ListMode=" + params.ListMode, "");
	if (params.searchPhrase)
		src = src.replace("&searchPhrase=" + encodeURIComponent(params.searchPhrase), "");
	src = src.replace("&searchPhrase=" + params.searchPhrase, "");
	if (params.SearchInSubfoldersFilter)
		src = src.replace("&SearchInSubfoldersFilter=" + params.SearchInSubfoldersFilter, "");
	if (params.selectedPageNumber)
		src = src.replace("&selectedPageNumber=" + params.selectedPageNumber, "");
	if (params.selectedPageSize)
		src = src.replace("&selectedPageSize=" + params.selectedPageSize, "");
	if (params.selectedSortBy)
		src = src.replace("&selectedSortBy=" + params.selectedSortBy, "");
	if (params.selectedSortDir)
		src = src.replace("&selectedSortDir=" + params.selectedSortDir, "");

	// reload
	document.location.href = src + contextParams + "&ListMode=" + mode;
}

FileManagerPage.prototype.upload = function () {
	url = '/Admin/Filemanager/Upload/Upload.aspx?Folder=' + encodeURIComponent(this.folder) +
        '&AllowChangeLocation=false&AllowOverwriteFiles=false';

	return window.open(url, 'fmUploadWnd', 'status=false,toolbar=false,location=false,menubar=false,' +
        'directories=false,scrollbars=false,width=950,height=600');
}

FileManagerPage.changeColumn = function (columnId) {
	if (typeof (__doPostBack) == 'function') {
		__doPostBack('Files', 'ColumnSelectorMenu:' + columnId);
	}
}

FileManagerPage.uploadWindowLoaded = function (sender, args) {
	var manager = sender.UploadManager.getInstance();
	var folder = "/" + ImagesFolderName;
	var params = sender.location.href.toQueryParams();
	if (params.Folder)
		folder = params.Folder;

	if (manager.get_canUpload()) {
		manager.add_afterUpload(function (sender, args) {
			FileManagerPage.refresh(folder);
		});
	}
}

FileManagerPage.refresh = function (folder) {
	var src = location.href;
	location.href = FileManagerPage.updateURLParameter(src, "Folder", folder);
}

FileManagerPage.updateURLParameter = function (url, param, paramVal) {
    if (url.endsWith('#')) {
        url = url.substr(0, url.length - 1);
    }

    var params = url.toQueryParams();
    if (params[param]) {
        url = url.replace(param + "=" + encodeURIComponent(params[param]), param + "=" + encodeURIComponent(paramVal));
        url = url.replace(param + "=" + params[param], param + "=" + encodeURIComponent(paramVal));
    }
    else {
        url = url + (url.indexOf("?") > 0 ? "&" : "?") + param + "=" + encodeURIComponent(paramVal);
    }
    return url;
}

FileManagerPage.prototype.preview = function (file, dialogId) {
	if (file == 'contextmenu') {
		file = ContextMenu.callingItemID;
	}
	if (this.isImage(file) || file.toLowerCase().endsWith(".swf") || file.toLowerCase().endsWith(".pdf")) {
	    var url = "/Admin/FileManager/FileManager_preview.aspx?File=" + encodeURIComponent(file);
	    dialog.show(dialogId, url);	
	} else {
		FileManagerPage.open(file);
	}
}

FileManagerPage.prototype.defaultFileAction = function (file, dialogId) {
    if (this.isEditable(file)) {
        this.edit(dialogId, file)
    }
    else {
        this.preview(file, dialogId);
    }
}

FileManagerPage.prototype.edit = function (dialogId, fileItem) {
    var width = window.screen.width - 300;
    var height = window.screen.height - 300;
    if (!fileItem) {
        fileItem = ContextMenu.callingItemID;
    }
	var parts = fileItem.split("/");
	var file = parts[parts.length - 1];
	var filesDir = fileItem.substr(0, fileItem.length - file.length);
	var editorScript = "/Admin/Filemanager/FileEditor/FileManager_FileEditorV2.aspx";
	DW_FileEditor_window = window.open(editorScript + "?File=" + encodeURIComponent(file) + "&Folder=" + encodeURIComponent(filesDir) + "&width=" + width + "&height=" + height, "", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=yes,minimize=no,width=" + width + ",height=" + height + ",left=100 ,top=100");
	DW_FileEditor_window.focus();
}

FileManagerPage.editImage = function (dialogId) {	
	dialog.show(dialogId, "/Admin/Filemanager/ImageEditor/Edit.aspx?File=/Files" + encodeURIComponent(ContextMenu.callingItemID));	
}

FileManagerPage.CallFileSystem = function (action, folder, files) {
	showLoading();
	var filesArr = files.split('|');
	for (var i = 0; i < filesArr.length; i++) {
		url = FileManagerPage.makeUrlUnique("/Admin/Filemanager/Browser/FileSystem.aspx?action=" + action + "&file=" + encodeURIComponent(filesArr[i]) + "&folder=" + encodeURIComponent(folder));
		if (i < filesArr.length - 1) {
			new Ajax.Request(url, {
				method: 'get',
				asynchronous: false,
				onSuccess: function (transport) {
					if (transport.responseText.truncate().length > 0)
						alert(transport.responseText);
						hideLoading();
				}
			});
		}
		else {
			//process last file 
			new Ajax.Request(url, {
				method: 'get',
				asynchronous: false,
				onSuccess: function (transport) {
					if (transport.responseText.truncate().length > 0)
						alert(transport.responseText);
					else {
						var file = files.split('|')[0];
						var lastIndex = (file.lastIndexOf('/') > -1) ? file.lastIndexOf('/') : file.length - 1
						var folderFromFiles = file.substring(0, lastIndex);
						FileManagerPage.refresh((folder) ? folder : folderFromFiles);
					}
				}
			});
		}
	}
}

FileManagerPage.makeUrlUnique = function (url) {
	var s = "?";
	if (url.indexOf("?") > 0) {
		s = "&";
	}
	return url + s + "zzz=" + Math.random();
}


FileManagerPage.prototype.copyHere = function () {
	var files = this.GetSelectedFilesRow();
	var tmpFile = files.split('|')[0];
	var path = tmpFile.substring(0, tmpFile.lastIndexOf('/'));
	FileManagerPage.DoCopy(path, files);
}

FileManagerPage.DoCopy = function (destinationFolder, file) {
	FileManagerPage.CallFileSystem("copy", destinationFolder, file);
}

FileManagerPage.prototype.restoreFile = function (name) {
	var file = name;
	if (name)
		file = this.folder + "/" + name;
	else
		file = ContextMenu.callingItemID;

	var filesArr = this.GetSelectedFilesRow();
	if (filesArr.indexOf('|') >= 0) {
		if (confirm(this.restoreSeveralFilesMsg + '?'))
			FileManagerPage.CallFileSystem("restoreFromTrashbin", '', filesArr);
	}
	else {
		if (confirm(this.restoreMsg + ': ' + file + '?'))
			FileManagerPage.CallFileSystem("restoreFromTrashbin", '', file);
	}
}

FileManagerPage.prototype.deleteFile = function (name) {
	var file = name;
	if (name)
		file = this.folder + "/" + name;
	else
		file = ContextMenu.callingItemID;
	var rows;
	if (this.thumbnailView.enabled)
		rows = this.thumbnailView.getSelectedRows();
	else
		rows = List.getSelectedRows('Files');

	if (rows != null && rows.length > 1) {
		if (confirm(this.deleteSeveralFilesMsg + '?'))
			FileManagerPage.CallFileSystem("delete", '', this.GetSelectedFilesRow());
	}
	else {
		if (confirm(this.deleteMsg + ': ' + file + '?'))
			FileManagerPage.CallFileSystem("delete", '', file);
	}
}

FileManagerPage.prototype.translateTemplate = function () {
	var wnd = null;
	var module = '';
	var design = '';
	var isGlobal = false;
	var isDesignGlobal = false;

	if (this.folder.toLowerCase() == '/templates') {
		isGlobal = true;
	} else if (this.folder.toLowerCase() == '/templates/designs') {
		isDesignGlobal = true;
	} else if (this.folder.toLowerCase().indexOf('templates/designs/') > 0) {
		design = this.folder.toLowerCase().substring('/templates/designs/'.length);
		if (design.indexOf("/") >= 0) {
			design = design.substring(0, module.indexOf("/"));
		}
	} else {
		module = this.folder.toLowerCase().substring('/templates/'.length);
		if (module.indexOf("/") >= 0) {
			module = module.substring(0, module.indexOf("/"));
		}
	}

	// Screen center
	var x = screen.width / 2 - 800 / 2;
	var y = screen.height / 2 - 600 / 2;

	if (isDesignGlobal == true) {
		wnd = window.open('/Admin/Content/Management/Dictionary/TranslationKey_List.aspx?IsGlobal=true',
            'dwEditTranslateWnd',
            'width=800,height=600,scrollbars=no,toolbar=no,location=no,directories=no,status=no,resizable=yes,left=' + x + ',top=' + y)
	} else if (design != '') {
		wnd = window.open('/Admin/Content/Management/Dictionary/TranslationKey_List.aspx?designName=' + design,
            'dwEditTranslateWnd',
            'width=800,height=600,scrollbars=no,toolbar=no,location=no,directories=no,status=no,resizable=yes,left=' + x + ',top=' + y)
	} 

	if (wnd) wnd.focus();
}

FileManagerPage.open = function (file) {
	if (file) {
	    window.open('/Admin/File/Preview?fileName=/Files' + file);
	}
	else {
		window.open('/Files' + ContextMenu.callingItemID);
	}
}

FileManagerPage.download = function () {
	document.location.href = "/Admin/Public/download.aspx?Filarchive=true&File=Files" + encodeURIComponent(ContextMenu.callingItemID), "FileManagerAction", "";
	return false;
}

FileManagerPage.prototype.isImage = function (file) {
	var res = false;
	if (file) {
		file = file.toLowerCase();
		this.imageExtensions.each(function (item) {
			if (file.endsWith(item))
				res = true;
		});
	}
	return res;
}

FileManagerPage.prototype.isEditable = function (file) {
	var res = false;
	if (file) {
		file = file.toLowerCase();
		this.editableExtensions.each(function (item) {
			if (file.endsWith(item))
				res = true;
		});
	}
	return res;
}

FileManagerPage.prototype.GetSelectedFilesRow = function () {
	var ret = ContextMenu.callingItemID;
	var severalFiles = false;
	var checkedRows;
	if (this.thumbnailView.enabled) {
		checkedRows = this.thumbnailView.getSelectedRows();
		severalFiles = this.thumbnailView.rowIsSelected(ContextMenu.callingID) && checkedRows.length > 1;
	}
	else {
		checkedRows = List.getSelectedRows('Files');
		var selectedRow = List.getRowByID('Files', ContextMenu.callingID);
		severalFiles = List.rowIsSelected(selectedRow) && checkedRows.length > 1;
	}
	if (severalFiles) {
		ret = '';
		for (var i = 0; i < checkedRows.length; i++) {
			ret += checkedRows[i].readAttribute('itemID') + "|";
		}
		ret = ret.substring(0, ret.length - 1);
	}
	return ret;
}

FileManagerPage.prototype.openWindow = function (url, windowName, width, height, callback) {
	var returnValue;

	if (window.showModalDialog) {
		returnValue = window.showModalDialog(url, windowName, "dialogWidth:" + width + "px; dialogHeight:" + height + "px");

		if (callback)
			callback(returnValue);
	}
	else {
		var popupWnd = window.open(url, windowName, 'status=0,toolbar=0,menubar=0,resizable=0,directories=0,titlebar=0,modal=yes,width=' + width + ',height=' + height);

		if (callback) {
			popupWnd.onunload = function () {
				callback(popupWnd.returnValue);
				returnValue = popupWnd.returnValue;
			}
		}
	}

	return returnValue;
}