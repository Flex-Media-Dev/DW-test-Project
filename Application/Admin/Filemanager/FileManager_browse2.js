//*********** FileManager WebControl ************

function morefiles(selected, strCaller, strFolder, strFile, allowedExtensions, selectedCallback) {
	if (selected == 'more') {
		browse(strCaller, strFolder, strFile, allowedExtensions, selectedCallback)
	}
}

function browse(strCaller, strFolder, strFile, allowedExtensions, selectedCallback) {
	if (focalIsBeingSet) {
		focalIsBeingSet = false;
		return;
	}
	var valEl = $(strCaller);
	if (valEl && valEl.disabled) {
		return;
	}
	strFolder = strFolder || "";
	strFile = strFile || "";

	var rootFolder = "";
	var filePath = "";
	if (strFile || strFolder) {
		if (strFolder && strFolder.substring(0, 1) != "/") {
			rootFolder += "/"
		}
		rootFolder += strFolder;
		filePath = rootFolder;
		if (strFile && strFile.substring(0, 1) != "/") {
			filePath += "/"
		}
		filePath += strFile;
	};
	_selectFile({
		extensions: allowedExtensions,
		rootFolder: rootFolder,
		filePath: filePath,
		selected: function (selectedFilePath) {
			fileManagerStoreSelectedFile(valEl, rootFolder, selectedFilePath, true);
		}
	});
}

function fileManagerStoreSelectedFile(valEl, rootFolder, selectedFilePath) {
	var path = selectedFilePath;
	var relPath = _makeRelativePath(rootFolder, path);
	if (valEl.options) {
		valEl.selectedIndex = _findOptionOrCreate(valEl, relPath, "/Files" + path);
	} else {
		valEl.value = path;
	}
	//focalRemove(valEl.id);
	_fireEvent(valEl, "change");
}

function browseExternalMediaDatabase(strCaller, browserUrl) {
	DW_browse_window = window.open(browserUrl + "?Control=" + strCaller, "DW_browse_window", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no,minimize=no,width=1024,height=768,left=200,top=120");
	DW_browse_window.focus();
}

function _selectFile(options) {
	var queryStringParams = [];
	if (options.extensions) {
		queryStringParams.push("AllowedExtensions=" + options.extensions);
	}
	if (options.filePath || options.rootFolder) {
		queryStringParams.push("path=" + options.filePath || options.rootFolder);
	}
	if (options.rootFolder) {
		queryStringParams.push("uploadFolder=" + options.rootFolder);
	}

	var dlgAction = {
		Url: "/Admin/Files/Dialogs/SelectFile?" + queryStringParams.join("&"),
		Name: "OpenDialog",
		OnSubmitted: {
			Name: "ScriptFunction",
			Function: function (act, model) {
				options.selected(model.Selected);
			}
		}
	};
	Action.Execute(dlgAction);
}

function _makeRelativePath(baseFolder, fullPath) {
	var strFile = fullPath;
	if (baseFolder && !strFile.toLowerCase().startsWith(baseFolder.toLowerCase())) {
		var count = (baseFolder.match(/\//g) || []).length;
		if (count > 0) {
			var dotsPath = (new Array(count + 1)).join("../");
			if (dotsPath && dotsPath.substring(dotsPath.length - 1) == "/" && strFile.substring(0, 1) == "/") {
				strFile = strFile.substring(1);
			}
			strFile = dotsPath + strFile;
		}
	}
	else {
		if (baseFolder == "/")
			strFile = strFile.substring(1, strFile.length);
		else
			strFile = strFile.substring(baseFolder.length + 1, strFile.length);
	}
	return strFile;
}

function _findOptionOrCreate(selObj, relFilePath, fullPath, searchByFullPath, upgradeIfFound) {
	var index = -1;
	for (var i = 0; i < selObj.options.length; i++) {
		if (searchByFullPath ? selObj.options[i].getAttribute('fullPath') == fullPath : selObj.options[i].value == relFilePath) {
			index = i;
			break;
		}
	}
	if (index < 0) {
		selObj.options[selObj.options.length] = new Option(relFilePath, relFilePath);
		index = selObj.options.length - 1;
		selObj.options[index].setAttribute('fullPath', fullPath);
	}
	else if (upgradeIfFound) {
		var opt = selObj.options[index];
		opt.innerText = relFilePath;
		opt.value = relFilePath;
		opt.setAttribute('fullPath', fullPath);
	}
	return index;
}

function _fireEvent(element, event) {
	if (document.createEventObject) {
		var evt = document.createEventObject();
		return element.fireEvent('on' + event, evt)
	} else {
		var evt = document.createEvent("HTMLEvents");
		evt.initEvent(event, true, true);
		return !element.dispatchEvent(evt);
	}
}

function browseFullPath(strCaller, strFolder, strFile, allowedExtensions, selectedCallback) {
	var valEl = $(strCaller);
	if (valEl && valEl.disabled) {
		return;
	}
	strFolder = strFolder || "";
	strFile = strFile || "";

	var rootFolder = "";
	var filePath = "";
	if (strFile || strFolder) {
		if (strFolder && strFolder.substring(0, 1) != "/") {
			rootFolder += "/"
		}
		rootFolder += strFolder;
		if (!strFile) {
			filePath = rootFolder;
		} else {
			if (strFile.substring(0, 1) != "/") {
				filePath += "/"
			}
			filePath += strFile;
		}
	}

	_selectFile({
		extensions: allowedExtensions,
		rootFolder: rootFolder,
		filePath: filePath,
		selected: function (selectedFilePath) {
			var path = selectedFilePath;
			if (valEl.options) {
				valEl.selectedIndex = _findOptionOrCreate(valEl, path, "/Files" + path);
			} else {
				valEl.value = path;
			}
			_fireEvent(valEl, "change");
			if (selectedCallback) {
				selectedCallback(path);
			}
		}
	});
}


function templateActions(action, controlID, folder, useNewEditor, caller, showFullPath) {
	var originalID = null,
        origFolder = folder,
        templatesRoot = 'templates/',
        file = document.getElementById(controlID).value,
        lastSlash = -1,
        params = {},
        url,
        genUrl = function (_url, _params) {
        	var prop,
                pair,
                result = _url;

        	for (prop in _params) {
        		if (_params[prop] && _params.hasOwnProperty(prop)) {
        			pair = prop + "=" + _params[prop];
        			if (result.indexOf('?') !== -1) {
        				result += '&' + pair;
        			} else {
        				result += '?' + pair;
        			}
        		}
        	}

        	return result;
        };

	if (controlID) {
		originalID = controlID.replace('FM_', '');


		if (origFolder.toLowerCase().indexOf(templatesRoot) >= 0) {
			var hidden = document.getElementById(originalID + '_path');
			if (hidden && hidden.value) {
				var templatesIndex = hidden.value.toLowerCase().indexOf(templatesRoot);
				if (templatesIndex > 0) {
					file = hidden.value.substring(templatesIndex, hidden.value.length);
				}
			}
		}
	}

	lastSlash = file.lastIndexOf('/');
	if (_canExecuteAction(action, originalID)) {
		if (lastSlash >= 0 && lastSlash < (file.length - 1)) {
			folder = file.substring(0, lastSlash);
			folder = folder.replace('../', '');

			if (origFolder.toLowerCase().indexOf(templatesRoot) >= 0 &&
                folder.toLowerCase().indexOf(templatesRoot) < 0) {

				folder = templatesRoot + folder;
			}

			file = file.substring(lastSlash, file.length).replace('/', '');
		}

		params['File'] = file;
		params['Folder'] = folder;
		params['CallerOriginalID'] = originalID;
		params['CallerCallback'] = caller.attributes['data-caller-callback'] ? caller.attributes['data-caller-callback'].value : '';
		params['CallerReload'] = caller.attributes['data-caller-reload'] ? caller.attributes['data-caller-reload'].value : '';
		params['ShowFullPath'] = showFullPath;

		url = genUrl('/Admin/FileManager/FileEditor/FileManager_FileEditorV2.aspx', params);

		var wnd = window.open(url, '', 'scrollbars=no,toolbar=no,location=no,directories=no,status=no,resizable=yes');
		wnd.focus();
	}
}

function _canExecuteAction(action, controlID) {
	var img = null;
	var ret = true;
	var imgID = 'editImage_' + controlID;

	if (action == 'translate') {
		imgID = 'translateImage_' + controlID;
	}

	img = document.getElementById(imgID);

	if (img && _attr(img, '_enabled')) {
		ret = (_attr(img, '_enabled') == 'true');
	}

	return ret;
}

function _attr(obj, attributeName, attributeValue) {
	var ret = null;

	if (obj) {
		if (attributeName) {
			if (!attributeValue) {
				if (typeof (obj.readAttribute) != 'undefined') {
					ret = obj.readAttribute(attributeName);
				} else if (typeof (obj.getAttribute) != 'undefined') {
					ret = obj.getAttribute(attributeName);
				}
			} else {
				if (typeof (obj.writeAttribute) != 'undefined') {
					obj.writeAttribute(attributeName, attributeValue);
				} else if (typeof (obj.setAttribute) != 'undefined') {
					obj.setAttribute(attributeName, attributeValue);
				}
			}
		}
	}

	return ret;
}

function updateHiddenPath(inputName) {
	var dropDown = document.getElementById('FM_' + inputName);
	var hidden = document.getElementById(inputName + '_path');

	if (dropDown && hidden) {
		var selectedOption = dropDown[dropDown.selectedIndex];

		if (selectedOption && selectedOption.attributes['fullPath'])
			hidden.value = selectedOption.attributes['fullPath'].nodeValue;
		else
			hidden.value = '';


		if (hidden.onchange) {
			hidden.onchange();
		}

		_showSelectedFile(inputName, hidden.value, selectedOption ? selectedOption.text : "");

		//hidden.fire('FileManager:HiddenPathChanged');
	}
}

function _showSelectedFile(inputName, filePath, relPath) {
	var fileName = filePath.split("/").pop();
	var fileType = fileName.split('.').pop().toLowerCase();
	var img = document.getElementById('FM_' + inputName + "_image");
	var addicon = document.getElementById('FM_' + inputName + "_addicon");
	var namecontainer = document.getElementById('FM_' + inputName + "_filename");

	if (img) {
        if (fileType == "jpg" || fileType == "jpeg" || fileType == "png" || fileType == "gif" || fileType == "webp" || fileType == "pdf"
			|| fileType == "psd" || fileType == "eps" || fileType == "ai" || fileType == "tif" || fileType == "tiff" || fileType == "svg"
			|| fileType == "bmp") {
			img.src = "/Admin/Public/GetImage.ashx?width=450&height=353&donotupscale=1&crop=5&Compression=90&image=" + filePath;

			img.className = "";
			addicon.className = "hidden";
			namecontainer.innerText = relPath;
		} else if (fileName == "") {
			img.src = "";
			img.className = "hidden";
			addicon.className = "fa fa-plus-circle thumbnail-add-file";
			addicon.style = "display: block";
			namecontainer.innerText = "";
		} else {
			img.src = "";
			img.className = "hidden";
			addicon.className = "fa fa-file thumbnail-add-file";
			addicon.style = "display: block";
			namecontainer.innerText = "";
		}
	}
}

function clearFileSelection(strCaller) {
	var valEl = $(strCaller);
	if (valEl && valEl.disabled) {
		return;
	}
	if (valEl.options) {
		valEl.selectedIndex = _findOptionOrCreate(valEl, "", "");
	} else {
		valEl.value = "";
	}
	//focalRemove(strCaller);
	_fireEvent(valEl, "change");
}

function browseFolder(strCaller, strFolder, strFile) {
	var valEl = $(strCaller);
	if (valEl && valEl.disabled) {
		return;
	}

	strFolder = strFolder || "";
	strFile = strFile || "";

	var dlgAction = {
		Url: "/Admin/Files/Dialogs/SelectFolder?folder=" + strFile || strFolder,
		Name: "OpenDialog",
		OnSubmitted: {
			Name: "ScriptFunction",
			Function: function (act, model) {
				var path = model.Selected;
				valEl.value = path;
				_fireEvent(valEl, "change");
			}
		}
	};
	Action.Execute(dlgAction);
}

function fileUpload(strCaller, strFolder, showFullPath) {
	var valEl = $(strCaller);
	if (valEl && valEl.disabled) {
		return;
	}

	strFolder = strFolder || "";
	if (strFolder && strFolder.substring(0, 1) != "/") {
		strFolder = "/" + strFolder;
	}

	var wnd = window.top;
	wnd.startUpload(strFolder, function (objResponse) {
		if (objResponse.success) {
			var fileName = objResponse.files[0].name;
			var path = strFolder + "/" + fileName;
			if (valEl.options) {
				var optionIdx = _findOptionOrCreate(valEl, !!showFullPath ? path : fileName, "/Files" + path);
				valEl.options[optionIdx].innerText = fileName + " (" + dwGlobal.humanFileSize(objResponse.files[0].size) + ")";
				valEl.selectedIndex = optionIdx;
			}
			else {
				valEl.value = path;
			}
			_fireEvent(valEl, "change");
		}
		else {
			Action.Execute({
				Name: "ShowMessage",
				Message: objResponse.message
			});
		}
	});
}

//*********** FileArchive WebControl ************

function previewImgFile(objFile) {
	var sFile = encodeURIComponent(objFile.value);

	if (sFile.length > 0) {
		window.open('/Admin/FileManager/FileManager_preview.aspx?File=' + sFile, '', 'resizable=no,scrollbars=auto,toolbar=no,location=no,directories=no,status=no,minimize=no,help=no,width=608,height=315,left=200,top=120').focus();
	}
}

var dwGlobal = dwGlobal || {};
dwGlobal.humanFileSize = dwGlobal.humanFileSize || function (bytes) {
	var thresh = 1024;
	if (Math.abs(bytes) < thresh) {
		return bytes + " B";
	}
	var units = ["Kb", "Mb", "Gb"];
	var unitPrecisions = [0, 1, 3];
	var u = -1;
	do {
		bytes /= thresh;
		u++;
	} while (Math.abs(bytes) >= thresh && u < units.length - 1);
	return bytes.toFixed(unitPrecisions[u]) + " " + units[u];
}


//**************** Focal points *******************
var focalIsBeingSet = false;
function initializeFocal(imgId, focalX, focalY) {
	var mouseIsDown = false;
	var imageElement = document.getElementById("FM_" + imgId + "_image");
	//var imageElement = document.getElementById("filemanager-imgWrapper" + imgId);

	imageElement.addEventListener("mousemove", function (e) {
		event.preventDefault;
		var rect = e.target.getBoundingClientRect();
		var x = Math.floor(e.clientX - rect.left); //x position within the element.
		var y = Math.floor(e.clientY - rect.top);  //y position within the element.
		document.getElementById("FM_" + imgId + "_mouseposition").innerHTML = '' + x + ' , ' + y + ' ; ' + rect.width + 'px x ' + rect.height + 'px';
		calculateFocalpoint(e.srcElement, x, y, rect.width, rect.height, imgId);
	});

	imageElement.addEventListener("mouseout", function (e) {
		document.getElementById("FM_" + imgId + "_mouseposition").innerHTML = '-';
	});

	imageElement.addEventListener("mouseup", function (e) {
		mouseIsDown = false;
		setFocalClick(e);
	});

	document.getElementById("FM_" + imgId).addEventListener("change", function (e) {
		focalReset(imgId);
	});

	document.getElementById("FM_" + imgId + "_image").addEventListener("load", function (e) {
		focalSetDefaultFocal(focalX, focalY, imgId);
	});

	document.getElementById("focal" + imgId).addEventListener("mouseup", function (e) {
		mouseIsDown = false;
		setFocalClick(e);
	});


	function setFocalClick(e) {
		focalIsBeingSet = true;
		if (!e.srcElement.getAttribute('src')) {
			return;
		}
		var rect = e.target.getBoundingClientRect();
		var x = Math.floor(e.clientX - rect.left); //x position within the element.
		var y = Math.floor(e.clientY - rect.top);  //y position within the element.

		focalSetFocalpoint(e.srcElement, x, y, rect.width, rect.height, imgId);
	}

	imageElement.addEventListener('mousedown', () => mouseIsDown = true);
}

function calculateFocalpoint(imgObject, x, y, width, height, imgId) {
	if (!imgObject.getAttribute('src')) {
		return;
	}

	var focalX = 0, focalY = 0;
	var percentFromLeft = Math.round((x / width) * 100);
	if (percentFromLeft < 50) {
		focalX = (100 - (percentFromLeft * 2)) * -1;
	}
	if (percentFromLeft > 50) {
		focalX = (percentFromLeft * 2) - 100;
	}

	var percentFromTop = Math.round((y / height) * 100);
	if (percentFromTop < 50) {
		focalY = (100 - (percentFromTop * 2));
	}
	if (percentFromTop > 50) {
		focalY = ((percentFromTop * 2) - 100) * -1;
	}

	document.getElementById("FM_" + imgId + "_mouseposition").innerHTML = 'Pos: ' + x + ' (' + percentFromLeft + '%), ' + y + ' (' + percentFromTop + '%) ';
	document.getElementById("FM_" + imgId + "_mouseposition").innerHTML += 'Focal: ' + focalX + ' , ' + focalY;
}

function focalSetDefaultFocal(focalX, focalY, imgId, isWaiting) {
	var img = document.getElementById("FM_" + imgId + "_image");

	if (img.offsetWidth == 0) {
		setTimeout(function (e) {
			focalSetDefaultFocal(focalX, focalY, imgId, true);
		}, 1000);
		if (!isWaiting) {
			updateSelectedImageWithFocal(imgId, focalX, focalY);
		}
	} else{
		if (img.offsetWidth > 0) {
			focalSetFocal(focalX, focalY, imgId);
		}
	}
	
}

function focalSetFocal(focalX, focalY, imgId) {
	var img = document.getElementById("FM_" + imgId + "_image");
	var xPercent, yPercent = 50; //Middle of image
	xPercent = (100 + focalX) / 2;
	yPercent = (100 - focalY) / 2;

	var xPixels, yPixels = 0;
	xPixels = Math.round((img.offsetWidth / 100) * xPercent);
	yPixels = Math.round((img.offsetHeight / 100) * yPercent);

	focalSetFocalpoint(img, xPixels, yPixels, img.offsetWidth, img.offsetHeight, imgId);
	if (focalX == 0 && focalY == 0) {
		focalRemove(imgId);
	}
}

function focalRemove(imgId) {
	imgId = imgId.replace("FM_", "");
	document.getElementById("focal" + imgId).style.display = "none";
	document.getElementById("FM_" + imgId + "_mouseposition").innerHTML = "-";
	document.getElementById("FM_" + imgId + "_focalpoints").innerHTML = "-";
}

function focalReset(imgId) {
	focalSetFocal(0, 0, imgId)
}

function focalSetFocalpoint(imgObject, x, y, width, height, imgId) {
	if (!imgObject.getAttribute('src')) {
		return;
	}

	var wrapper = document.getElementById("FM_" + imgId + "_wrapper")
	var leftMargin = (wrapper.offsetWidth - width) / 2;
	var topMargin = (wrapper.offsetHeight - height) / 2;

	document.getElementById("focal" + imgId).style.left = (x + leftMargin) + 'px';
	document.getElementById("focal" + imgId).style.top = (y + topMargin) + 'px';
	document.getElementById("focal" + imgId).style.display = "";

	var focalX = 0, focalY = 0;
	var percentFromLeft = Math.round((x / width) * 100);
	if (percentFromLeft < 50) {
		focalX = (100 - (percentFromLeft * 2)) * -1;
	}
	if (percentFromLeft > 50) {
		focalX = (percentFromLeft * 2) - 100;
	}

	var percentFromTop = Math.round((y / height) * 100);
	if (percentFromTop < 50) {
		focalY = (100 - (percentFromTop * 2));
	}
	if (percentFromTop > 50) {
		focalY = ((percentFromTop * 2) - 100) * -1;
	}

	document.getElementById("FM_" + imgId + "_focalpoints").innerHTML = 'Pos: ' + x + ' (' + percentFromLeft + '%), ' + y + ' (' + percentFromTop + '%) ';
	document.getElementById("FM_" + imgId + "_focalpoints").innerHTML += 'Focal: ' + focalX + ' , ' + focalY;
	updateSelectedImageWithFocal(imgId, focalX, focalY);
}

function updateSelectedImageWithFocal(inputName, focalX, focalY) {
	var dropDown = document.getElementById('FM_' + inputName);
	var hidden = document.getElementById(inputName + '_path');

	var filePath = hidden.value.split("?")[0];

	if (dropDown) {
		var selectedOption = dropDown[dropDown.selectedIndex];
		var optionValue = selectedOption.value.split("?")[0];
		if(focalX == 0 && focalY == 0){
			selectedOption.value = optionValue;
			hidden.value = filePath;
		} else {
			selectedOption.value = optionValue + "?x=" + focalX + "&y=" + focalY;
			hidden.value = filePath + "?x=" + focalX + "&y=" + focalY;
		}
	}
}