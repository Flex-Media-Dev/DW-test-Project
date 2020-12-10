var uploadManager = {
    dropzone: null,
    init: function (options) {
        var self = this;
        this.targetFolder = options.targetFolder;
        this.set_imageSettingIsEnabled(false);
        this.set_archiveSettingIsEnabled(false);
        this.set_groupIsEnabled('rowDimensions', false);
        this.set_groupIsEnabled('rowCreateFolders', false);

        var previewNode = $("templateItem");
        previewNode.id = "";
        var previewTemplate = previewNode.parentNode.innerHTML;
        previewNode.parentNode.removeChild(previewNode);

        self.dropzone = new Dropzone("ul#items", {
            url: "Store.aspx",
            autoProcessQueue: false,
            uploadMultiple: false,
            maxFilesize: parseInt($("fileSizeLimit").value),
            parallelUploads: 10,
            thumbnailWidth: 30,
            thumbnailHeight: 20,
            previewTemplate: previewTemplate,
            //autoQueue: false, // Make sure the files aren't queued until manually added
            previewsContainer: "#items", // Define the container to display the previews
            clickable: "#cmdSelectFile", // Define the element that should be used as click trigger to select files.
            init: function () {
                this.on("queuecomplete", function () {
                    self.onChangeFilesCount();
                    reloadFileList();

                    notifire({ msg: 'Upload queue complete' });
                });

                this.on("addedfile", function (file) {
                    self.onAddedFiles(file);

                    notifire({ msg: 'Uploading', id: 'upload-message' });
                });

                this.on("success", function (file, responseText, e) {
                    self.onFileComplete(file, responseText);

                    notifire({ msg: 'Upload complete', id: 'upload-message' });
                });

                this.on("error", function (file, responseText, e) {
                    self.onFileComplete(file, "0:Unhandled error");

                    notifire({ msg: 'Upload: Unhandled error', id: 'upload-message' });
                });

                this.on("totaluploadprogress", function (total, totalBytes, totalBytesSent) {
                    self.onChangeFilesCount();
                    self.onUploadprogress(total, totalBytes, totalBytesSent);

                    notifire({ msg: 'Uploading ' + (100 * totalBytesSent / totalBytes), id: 'upload-message' });
                });
            }
        });
    },

    _formatFileSize: function (fileSize) {
        var ret = '';

        fileSize = parseInt(fileSize);

        if (fileSize > 1000000000) {
            ret = (Math.round(fileSize / 100000000) / 10).toString() + '&nbsp;GB';
        } else if (fileSize > 1000000) {
            ret = (Math.round(fileSize / 100000) / 10).toString() + '&nbsp;MB';
        } else if (fileSize > 1000) {
            ret = (Math.round(fileSize / 100) / 10).toString() + '&nbsp;KB';
        } else {
            ret = fileSize.toString() + '&nbsp;B';
        }

        return ret;
    },

    _isImageFile: function (filename) {
        return this._checkExtension(filename, ['jpg', 'jpeg', 'png', 'gif', 'bmp']);
    },

    _isArchiveFile: function (filename) {
        return this._checkExtension(filename, ['zip', 'rar']);
    },

    _checkExtension: function (filename, extensions) {
        var ret = false;

        if (!extensions || extensions.length == 0)
            ret = true;
        else {
            var ext = this._getExtension(filename);
            if (ext.length > 0) {
                for (var i = 0; i < extensions.length; i++) {
                    if (extensions[i].toLowerCase() == ext) {
                        ret = true;
                        break;
                    }
                }
            }
        }

        return ret;
    },

    _getExtension: function (file) {
        var ext = '';
        var separatorIndex = 0;

        if (typeof (file) == 'string') {
            separatorIndex = file.lastIndexOf('.');
            if (separatorIndex >= 0 && separatorIndex < file.length - 1) {
                ext = file.substr(separatorIndex, file.length - separatorIndex);
            }
        } else {
            if (!file.type.length) {
                ext = this.getExtension(file.name);
            } else {
                ext = file.type;
            }
        }

        ext = ext.replace(/\./gi, '');

        return ext.toLowerCase();
    },

    set_imageSettingIsEnabled: function (isEnabled) {
        this.set_groupIsEnabled('groupImageSettings', isEnabled);
    },

    set_archiveSettingIsEnabled: function (isEnabled) {
        this.set_groupIsEnabled('groupArchiveSettings', isEnabled);
    },

    set_groupIsEnabled: function (groupID, isEnabled) {
        var group = $(groupID);
        var fields = null;
        var parentDisabled = null;

        if (group) {
            if (isEnabled) {
                group.removeClassName('groupDisabled');
            } else {
                group.addClassName('groupDisabled');
            }

            fields = group.select('input');
            if (fields && fields.length > 0) {
                for (var i = 0; i < fields.length; i++) {
                    if (!isEnabled)
                        fields[i].disabled = true;
                    else {
                        parentDisabled = $(fields[i]).up('*.groupDisabled');

                        if (parentDisabled == null || parentDisabled.id == groupID) {
                            fields[i].disabled = false;
                        }
                    }
                }
            }
        }
    },

    startUpload: function () {
        this.dropzone.options.params = {
            TargetLocation: this.targetFolder,
            AllowOverwrite: Ribbon.isChecked("chkOverwriteFiles"),
            ImageResize: Ribbon.isChecked("chkResize"),
            ImageQuality: $("ddQuality").value,
            ImageResizeWidth: $("txImageWidth").value,
            ImageResizeHeight: $("txImageHeight").value,
            ArchiveExtract: Ribbon.isChecked("chkExtractArchives"),
            ArchiveCreateFolders: Ribbon.isChecked("chkCreateFolders")
        };
        this.dropzone.processQueue();
    },

    onSelectFile: function (check) {
        if (check) {
            Ribbon.enableButton("cmdRemoveSelected");
        }
        else {
            var checkboxes = $$('ul[id="items"] span.C1 input:checked');
            if (checkboxes && checkboxes.length > 0) {
                Ribbon.enableButton("cmdRemoveSelected");
            }
            else {
                Ribbon.disableButton("cmdRemoveSelected");
            }
        }
    },

    selectAllFiles: function (check) {
        var checkboxes = $$('ul[id="items"] span.C1 input');

        if (checkboxes && checkboxes.length > 0) {
            for (var i = 0; i < checkboxes.length; i++) {
                checkboxes[i].checked = check;
            }
        }

        if (check) {
            Ribbon.enableButton("cmdRemoveSelected");
        }
        else {
            Ribbon.disableButton("cmdRemoveSelected");
        }
    },

    removeSelectedFiles: function () {
        for (var i = this.dropzone.files.length - 1; i >= 0; i--) {
            var file = this.dropzone.files[i];
            var chk = file.previewElement.down('span.C1 input');
            if (chk && chk.checked) {
                this.dropzone.removeFile(file);
            }
        }

        this.onChangeFilesCount();
    },


    removeFiles: function () {
        this.dropzone.removeAllFiles();
        this.onChangeFilesCount();
    },

    onAddedFiles: function (file) {
        var msgText = '';
        var dstFileName = file.name;
        if (dstFileName.indexOf(',') > -1) {
            dstFileName = dstFileName.replace(/,/g, '_');
            msgText = document.getElementById('Message_FileWarning_1').innerHTML.replace('%%', file.name) + '\n\r';
        }
        if (dstFileName.indexOf(';') > -1) {
            dstFileName = dstFileName.replace(/;/g, '_');
            msgText += document.getElementById('Message_FileWarning_2').innerHTML.replace('%%', file.name) + '\n\r';
        }
        if (dstFileName.indexOf('+') > -1) {
            dstFileName = dstFileName.replace(/\+/g, '_');
            msgText += document.getElementById('Message_FileWarning_3').innerHTML.replace('%%', file.name) + '\n\r';
        }
        if (dstFileName.indexOf('\'') > -1) {
            dstFileName = dstFileName.replace(/'/g, '_');
            msgText += document.getElementById('Message_FileWarning_6').innerHTML.replace('%%', file.name) + '\n\r';
        }
        if (dstFileName.indexOf('#') > -1) {
            dstFileName = dstFileName.replace(/#/g, '_');
            msgText += document.getElementById('Message_FileWarning_7').innerHTML.replace('%%', file.name) + '\n\r';
        }
        // chars -- are raise error when file name is passed trought url parameters and checked by SQLEscapeInjection function
        dstFileName = dstFileName.replace(/\-{2,}/g, '-');

        if (msgText != '') {
            alert(msgText);
            var _ref1 = file.previewElement.querySelectorAll("[data-dz-name]");
            for (var i = 0, j = _ref1.length; i < j; i++) {
                _ref1[i].innerHTML = dstFileName;
            }
        }

        var _ref2 = file.previewElement.querySelectorAll("[data-dz-modified]");
        for (var i = 0, j = _ref2.length; i < j; i++) {
            var lastModifiedDate = file.lastModifiedDate;
            if (!lastModifiedDate) {
                lastModifiedDate = new Date(file.lastModified);
            }
            _ref2[i].innerHTML = lastModifiedDate.toLocaleDateString() + " " + lastModifiedDate.toLocaleTimeString();
        }

        var checkbox = file.previewElement.down('span.C1 input');
        checkbox.observe('click', function (event) {
            var element = Event.element(event);
            uploadManager.onSelectFile(element.checked);
        });

        this.onChangeFilesCount();
        this.onUploadprogress(0);
    },

    onChangeFilesCount: function () {
        var totalSize = 0,
            totalCount = 0;

        if (this.dropzone.files.length > 0) {
            Ribbon.enableButton("cmdRemoveAll");
            $('chkAll').disabled = false;
        }
        else {
            Ribbon.disableButton("cmdRemoveAll");
            Ribbon.disableButton("cmdRemoveSelected");
            $('chkAll').disabled = true;
        }

        if (this.dropzone.getQueuedFiles().length > 0 || this.dropzone.getAddedFiles().length > 0) {
            Ribbon.enableButton("cmdUpload");
            var files = this.dropzone.getQueuedFiles();
            if (files.length > 0) {
                totalCount += files.length;
                for (var i = 0; i < files.length; i++) {
                    totalSize += files[i].size;
                }
            }

            files = this.dropzone.getAddedFiles();
            if (files.length > 0) {
                var file = files[0];
                if (this._isImageFile(file.name)) {
                    this.set_imageSettingIsEnabled(true);
                } else if (this._isArchiveFile(file.name)) {
                    this.set_archiveSettingIsEnabled(true);
                }

                if (files.length > 0) {
                    totalCount += files.length;
                    for (var i = 0; i < files.length; i++) {
                        totalSize += files[i].size;
                    }
                }
            }
        }
        else {
            Ribbon.disableButton("cmdUpload");
            this.set_archiveSettingIsEnabled(false);
            this.set_imageSettingIsEnabled(false);
        }

        $("uploadstatus-filecount").innerHTML = totalCount;
        $("uploadstatus-size").innerHTML = this._formatFileSize(totalSize);
    },

    onFileComplete: function (file, responseText) {
        var isSucceeded = false;
        var message = "";
        if (responseText.length > 1) {
            isSucceeded = parseInt(responseText.substr(0, 1)) == 1;
            var sepIndex = responseText.indexOf(':');
            if (sepIndex == 1) {
                message = responseText.substr(2);
            }
        }

        if (file.previewElement) {
            var statusContainer = file.previewElement.down('i.uploadStatus');
            statusContainer.addClassName(isSucceeded ? "fa fa-check color-success" : "fa fa-exclamation color-warning");
            statusContainer.writeAttribute('alt', message);
            statusContainer.writeAttribute('title', message);

            file.previewElement.classList.add("uploadLogEntry");
        }
    },

    onUploadprogress: function (total, totalBytes, totalBytesSent) {
        var progress = $('progressGlobal').down('span.progressFill');
        progress.setStyle({ 'width': total + '%' });

        this.onSelectFile(false);
    }
}