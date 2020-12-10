
document.addEventListener("DOMContentLoaded", init, false);

function init() {
    document.querySelector('#systemMultiUploaderHiddenFileinput').addEventListener('change', handleFileSelect, false);
    document.querySelector('#systemMultiUploaderHidden').addEventListener('onsubmit', handleFormSubmit, false);
    $("#systemMultiUploaderHiddenFileinput").on("click", function (e) {
        e.stopPropagation();
    });
}

function handleFormSubmit(e) {
    e.preventDefault();
}

function handleFileSelect(e) {
    if (!e.target.files) {
        return false;
    }
    var targetLocationEl = $("#systemMultiUploaderHiddenTargetLocation");
    var opts = targetLocationEl.data("options");
    var targetLocation = targetLocationEl.val();
    var fileSelect = document.getElementById('systemMultiUploaderHiddenFileinput');
    var files = fileSelect.files;
    var fileNames = "";
    var filesInfo = [];

    $.each(files, function(i, f) {
        fileNames += f.name + "|";
        filesInfo.push({
            name: f.name,
            size: f.size
        });
    });

    //At this stage, ask the server (AJAX) if any of the files exists in the destination, and if one ore more of the files being uploaded exists, ask for confirmation about overwrite? If yes, upload all files using AllowOverwrite=True, if not, upload using AllowOverwrite=False
    $.post("/Admin/Filemanager/Upload/Store.aspx", {
        cmd: "CheckFileIsExist",
        targetLocation: targetLocation,
        files: fileNames
    }, function(data) {
        if (data) {
            var response = $.parseJSON(data);
            if (response.FileRenaimed && filesInfo.length == 1) {
                filesInfo[0].name = response.NewName;
            }

            if (response.FileExists) {
                var message = document.getElementById('uploadExistingFiles').innerHTML + "<br/><ul>";
                $.each(response.Files, function(i, f) {
                    message += "<li>" + f + "</li>";
                });
                message += "</ul>";

                var dlgAction = {
                    Url: "/Admin/CommonDialogs/Confirm?Caption=" + document.getElementById('uploadConfirm').innerHTML + "&Message=" + message + "&Buttons=3&SubmitOkTitle=Overwrite+files&SubmitCancelTitle=Do+not+overwrite",
                    Name: "OpenDialog",
                OpenAsSubDialog: true,
                OnSubmitted: {
                    Name: "ScriptFunction",
                    Function: function (act, model) {
                        sendFiles(files, filesInfo, targetLocation, true, opts);
                        fileSelect.value = "";
                    }
                },
                OnCancelled: {
                    Name: "ScriptFunction",
                    Function: function (act, model) {
                        if (response.Files.length != files.length) {
                            sendFiles(files, filesInfo, targetLocation, false, opts);
                        } else if (opts.uploaded) {
                            opts.uploaded({
                                success: true,
                                message: "",
                                files: filesInfo
                            });
                        }
                        fileSelect.value = "";
                    }
                }
            };
            opts.contextWnd.Action.Execute(dlgAction);
        } else {
            sendFiles(files, filesInfo, targetLocation, false, opts);
            fileSelect.value = "";
        }
    }
    });
return false;
}

function sendFiles(files, filesInfo, targetLocation, alowOverwrite, opts) {
    var formData = new FormData();

    for (var i = 0; i < files.length; i++) {
        var file = files[i];
        // Add the file to the request.
        formData.append('files[]', file, file.name);
    }
    formData.append("TargetLocation", targetLocation);                                                           
    formData.append("AllowOverwrite", alowOverwrite ? "True" : "False");
    formData.append("CreateTargetLocation", opts.createFolderIfNotExists ? "True" : "False");
    

    var xhr = new XMLHttpRequest();
    xhr.open('POST', document.getElementById("systemMultiUploaderHidden").action, true);
    xhr.onload = function () {
        if (xhr.status === 200) {
            // File(s) uploaded.

            notifire({ msg: document.getElementById('uploadProgressionDone').innerHTML, id: 'notifire-upload' });

            if (opts.uploaded) {
                var arr = xhr.responseText.split(":");
                var obj = {
                    success: true,
                    message: "",
                    files: filesInfo
                };
                if (arr && arr.length > 1) {
                    obj.success = arr[0] == "1";
                    obj.message = arr[1] || "";
                }
                opts.uploaded(obj);
            }
        } else {
            notifire({ msg: document.getElementById('uploadError').innerHTML });
        }
    };
    xhr.onprogress = function (e) {
        if (e.lengthComputable) {
            var percentage = Math.round((e.loaded / e.total) * 100);
            notifire({ msg: document.getElementById('uploadProgression').innerHTML + ' ' + percentage + '%', id: 'notifire-upload' });
        }
    };

    notifire({ msg: document.getElementById('uploadProgression').innerHTML, id: 'notifire-upload' });

    xhr.send(formData);
}

function startFilesUpload(options) {
    $('#systemMultiUploaderHiddenFileinput').val("").prop("accept", options.allowedExtensions || "");

    options = $.extend(true, {
        folder: "/Billeder",
        contextWnd: window.self,
        uploaded: null
    }, options);
    $("#systemMultiUploaderHiddenTargetLocation").val("/Files" + options.folder).data("options", options);
    var evt = jQuery.Event("click");
    evt.isDialog = true; // setup isDialog to true to prevent dialog close
    $("#systemMultiUploaderHiddenFileinput").trigger("click", evt);
}

function startUpload(folder, callBack) {
    startFilesUpload({
        folder: folder,
        contextWnd: window.self,
        uploaded: callBack
    });
}

function startDownload(folder) {
    var token = new Date().getTime();
    location = "/Admin/Filemanager/Browser/FileSystem.aspx?action=download&folder=/Files" + folder + "&DownloadToken=" + token;

    notifire({ msg: document.getElementById('downloadProgression').innerHTML, id: 'notifire-download' });
    checkCookie(180, token);
}

function checkCookie(timeout, token) {
    var cookieVal = getCookie("DownloadToken"); 

    if (cookieVal == token || timeout < 0) {
        notifire({ msg: document.getElementById('downloadProgressionDone').innerHTML, id: 'notifire-download' });
    }
    else {
        setTimeout(function () { checkCookie(timeout - 1, token); }, 1000);
    }
}  

function getCookie(name) {
    var parts = document.cookie.split(name + "=");
    if (parts.length == 2) return parts.pop().split(";").shift();
}