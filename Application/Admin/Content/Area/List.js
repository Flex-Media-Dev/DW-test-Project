contextAreaActive = true;
contextAreaName = "";

var prevSelected;
var allowedPageCount = Infinity;
var numberOfPagesInSolution = 0;
function selectRow(areaId) {
    var chk = $("A" + areaId);

    if (AreaPermissions.isModuleAvailable) {
        contextAreaActive = ($("AreaActive" + areaId).innerHTML == 'False' ? false : true);
        contextAreaName = getAreaName(areaId);

        if (!chk.disabled) {
            chk.checked = true;
        }

        if (prevSelected) {
            $("Area_" + prevSelected).removeClassName("active");
        }
        $("Area_" + areaId).addClassName("active");


        if (AreaPermissions.canAccess(areaId)) {
            Ribbon.enableButton('cmdShowWebsite');
        } else {
            Ribbon.disableButton('cmdShowWebsite');
        }

        if (document.all) {
            var isLanguage = $("IsLanguage" + areaId).innerText == 'False';
        }
        else
            var isLanguage = $("IsLanguage" + areaId).textContent == 'False';

        toggleRibbonButtons(isLanguage);
        prevSelected = areaId;
    }
}

function toggleRibbonButtons(enable) {
    if (enable) {
        Ribbon.enableButton('btnNewLanguage');
        //Ribbon.enableButton('SaveAndClose');
    } else {
        Ribbon.disableButton('btnNewLanguage');
        //Ribbon.disableButton('SaveAndClose');
    }
}

function newArea() {
    if (AreaPermissions.canCreate) {
        location = "Edit.aspx?AreaID=0";
    }
}

function edit() {
    var areaID = getAreaId();

    if (AreaPermissions.canEdit(areaID)) {
        location = "Edit.aspx?AreaID=" + areaID;
    }
}

function exportArea() {
    dialog.hide('ExportAreaDialog');

    var areaID = getAreaId();
    var mode = $('chkFullExport').checked ? 'full' : 'translation';

    if (AreaPermissions.canAccess(areaID)) {
        location = 'Edit.aspx?Export=True&Compress=false&Name=' + getAreaName(areaID) + '&AreaID=' + areaID + '&Mode=' + mode;
    }
}

function importArea() {
    dialog.show("ImportDialog", "Import.aspx");
}

function showC() {
    show(ContextMenu.callingID);
}

function showBtn() {
    show(getAreaId());
}

function show(areaId) {
    if (AreaPermissions.canAccess(areaId)) {
        var pageCount = parseInt($("AreaPagecount" + areaId).innerHTML);
        if (pageCount > 0 && contextAreaActive) {
            var url = "/Default.aspx?AreaID=" + areaId;
            window.open(url);
        } else {
            if (!contextAreaActive) {
                alert($("CantDisplayNotActiveMessage").innerHTML);
            } else {
                alert($("CantDisplayNoPagesMessage").innerHTML);
            }
        }
    }
}

function copyDialog() {
    copyLanguageDialog(true);
}

function newLanguageDialog() {
    copyLanguageDialog(false);
}

function copyLanguageDialog(copy) {
    var areaID = getAreaId();

    if (AreaPermissions.canCreate && AreaPermissions.canAccess(areaID)) {
        dialog.show('dialogCopy');
        $("areaNamebCopy").value = contextAreaName;
        var culture = $("AreaCulture" + getAreaId()).innerHTML.toLowerCase();
        for (var i = 0; i < document.forms.copyform.AreaCulture.length; i++) {
            if (document.forms.copyform.AreaCulture[i].value.toLowerCase() == culture) {
                document.forms.copyform.AreaCulture.selectedIndex = i;
                break;
            }
        }
        if (copy) {
            $("AreaName").value = contextAreaName + ' - ' + $("CopyText").innerHTML;
            $("copySettings").style.display = "inherit";
            $("T_dialogCopy").innerText = $("CopyDialogTitle").innerText;
            $("isLanguage").value = "false";
            $("AreaName").focus();
        } else {
            $("AreaName").value = contextAreaName;
            $("copySettings").style.display = "none";
            $("T_dialogCopy").innerText = $("NewLanguageDialogTitle").innerText
            $("isLanguage").value = "true";
        }

    }
}

function copy() {
    var areaID = getAreaId();

    if (AreaPermissions.canCreate && AreaPermissions.canAccess(areaID)) {
        if ($("AreaName").value.length < 1) {
            alert($("CopySpecifyName").innerHTML);
            $("AreaName").select()
            return false;
        }
        if (document.forms.copyform.AreaCulture.value.length < 1) {
            alert($("CopySpecifyCulture").innerHTML);
            document.forms.copyform.AreaCulture.focus()
            return false;
        }

        // check allowed page number fo solution
        if (allowedPageCount != Infinity && isFinite(allowedPageCount) == true) {
            var pageCount = numberOfPagesInSolution + parseInt($("AreaPagecount" + areaID).innerHTML);
            if (pageCount > allowedPageCount) {
                alert($("ExceedAllowedPageCount").innerHTML);
                return false;
            }
        }

        var copyPermissions = $("CopyPermissions").checked;
        var newAreaName = $("AreaName").value;
        var isLanguage = $("isLanguage").value;
        var regionalSettings = document.forms.copyform.AreaCulture.value;
        var updateContentLinks = $("updateContentLinks").value;
        var updateShortcuts = $("updateShortcuts").value;
        var updateGlobalparagraphs = $("updateGlobalparagraphs").value;
        var linkParms = "&updateContentLinks=" + updateContentLinks + "&updateShortcuts=" + updateShortcuts + "&updateGlobalparagraphs=" + updateGlobalparagraphs + ""
        var mode = 3;
        for (var i = 0; i < document.forms.copyform.CopyWhat.length; i++) {
            if (document.forms.copyform.CopyWhat[i].checked) {
                mode = document.forms.copyform.CopyWhat[i].value;
                break;
            }
        }
        var o = new overlay("copyWait");
        o.show();
        dialog.hide('dialogCopy');
        $("copyframe").src = "Copy.aspx?Compress=false&AreaID=" + areaID + "&mode=" + mode + "&copyPermissions=" + copyPermissions + "&newAreaName=" + encodeURIComponent(newAreaName) + "&regionalSettings=" + regionalSettings + "&isLanguage=" + isLanguage + linkParms;
    }
}

function deleteAreaDialog() {
    var areaId = getAreaId();
    if (AreaPermissions.canDelete(areaId)) {
        if (AreaPermissions.hasLanguageVersions(areaId)) {
            $("multipleLanguageVersionsWarning").style.display = "block";
        } else {
            $("multipleLanguageVersionsWarning").style.display = "none";
        }
        dialog.show('dialogDelete');
        $("areaNameb").innerHTML = contextAreaName;
    } else {
        dialog.show('dialogCannotDelete');
    }
}
function deleteArea() {
    var areaID = getAreaId();

    if (AreaPermissions.canDelete(areaID)) {
        dialog.hide('dialogDelete');
        var o = new overlay("copyWait");
        o.message("");
        o.show();

        location = "Delete.aspx?AreaID=" + areaID;
    }
}

function openAreaPermissions() {
    var areaID = getAreaId();

    if (AreaPermissions.canSecure(areaID)) {
        if (AreaPermissions.useNew) {
            Action.Execute(
                {
                    'Name': 'ShowPermissions',
                    'PermissionKey': areaID,
                    'PermissionName': 'Area'
                });
        }
        else
        {
            dialog.show('AreaPermissionDialog', '/Admin/Content/Page/PagePermission.aspx?AreaID=' + areaID + '&DialogID=AreaPermissionDialog&Mode=permissions');
        }
    }
}

function savePermission() {
    var permissionsFrame = document.getElementById('AreaPermissionDialogFrame');
    var iFrameDoc = (permissionsFrame.contentWindow || permissionsFrame.contentDocument);
    if (iFrameDoc.document) iFrameDoc = iFrameDoc.document;
    iFrameDoc.getElementById("PagePermissionForm").submit();
}

function updateStatus(message) {
    //alert(message);
    var o = new overlay("copyWait");
    o.message(message);
}

function deleteAreaBtn() {
    contextAreaName = getAreaName(getAreaId());
    deleteAreaDialog()
}

function getAreaName(AreaID) {
    var areaid = "AreaName" + AreaID;
    return $(areaid).innerHTML;
}

function getAreaId() {
    if (document.getElementById('form1').Area.length) {
        for (var i = 0; i < document.getElementById('form1').Area.length; i++) {
            if (document.getElementById('form1').Area[i].checked) {
                return document.getElementById('form1').Area[i].value;
            }
        }
    }
    else {
        return document.getElementById('form1').Area.value;
    }
}


function onContextMenuSelectView(sender, args) {
    /// <summary>Handles "SelectView" event of the area context-menu.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="args">Event arguments.</param>

    var areaFound = false;
    var ret = ['cmdView'];
    var areaId = parseInt(args.callingID);

    if (typeof (AreaPermissions) != 'undefined') {
        areaFound = AreaPermissions.canAccess(areaId);

        if (areaFound) {
            ret.push('cmdExport');

            if (AreaPermissions.canCreate) {
                ret.push('cmdCopy');
            }

            if (AreaPermissions.canEdit(areaId)) {
                ret.push('cmdEdit');
                ret.push(contextAreaActive ? 'cmdInactive' : 'cmdActive');
            }

            if (AreaPermissions.canDelete(areaId) && areaId != 1) {
                ret.push('cmdDelete');
            }

            if (AreaPermissions.canSecure(areaId)) {
                ret.push('cmdAreaPermissions');
            }
        }
    }

    return ret;
}

function isSelected(AreaID) {
    var found = false;
    $('form1').getInputs('checkbox').each(function (s) {
        if ((s.checked) && (parseInt(s.value) == parseInt(AreaID))) {
            found = true;
        }
    });

    return found;
}

function toggleAllSelected() {
    setAllSelected($('chkAll').checked);
}

function setAllSelected(isSelected) {
    $('form1').getInputs('checkbox').each(function (s) {
        s.checked = isSelected;
    });

    handleCheckboxes();
}

function toggleActive(areaID, currentState) {
    if (AreaPermissions.canEdit(areaID)) {
        new Ajax.Request("/Admin/Content/Area/List.aspx", {
            method: 'get',
            parameters: {
                "AreaID": areaID,
                "active": (currentState == 'False' ? "True" : "False"),
                "dt": new Date().getTime()
            },
            onLoaded: function (transport) {
                var nav = dwGlobal.getContentNavigator();
                if (nav) {
                    nav.refreshRootSelector();
                }

                window.document.location = "/Admin/Content/Area/List.aspx";
            }
        });
    }
}