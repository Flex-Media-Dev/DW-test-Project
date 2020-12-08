function ecomGroupEditInit(options) {
    $(document).observe("mouseup", enableAddDWRow);
    $(document).observe("click", enableAddDWRow);
    enableAddDWRow();
    var tabField = $("activeTab");
    showTab(tabField.value);
    if (typeof (InitFckEditorProductFields) == 'function') {
        InitFckEditorProductFields();
    }
    GroupEdit.initGroupCategoryFields();
    let bodyShiftFix = function (e) {
        document.body.scrollTo(0, 0);
    };
    Object.keys(CKEDITOR.instances).forEach(function (key) {
        CKEDITOR.instances[key].on("panelShow", bodyShiftFix);
    });
    if (options.isPimGroup) {
        document.getElementById("product-workflow-editor").style.display = "";
    }

    var container = document.getElementById("AssetsGroupBox");
    Dynamicweb.ProductImageBlocks.get_current().initialize({
        container: container,
        enableVideoPreview: true
    });
}

var strHelpTopic = 'ecom.productman.group.edit';

function showTab(name) {
    $$(".groupTab").each(Element.hide);
    $(name).show();
    $("activeTab").value = name;

    switch (name) {
        case 'generalTab':
            strHelpTopic = 'ecom.productman.group.edit.general';
            break;
        case 'locationTab':
            strHelpTopic = 'ecom.productman.group.edit.location';
            break;
        default:
            strHelpTopic = 'ecom.productman.group.edit';
            break;
    }
}

function clearErrorMessages() {
    $F("NameStr").innerHTML = "";
}

function setErrorMark(condition, field) {
    $(field).innerHTML = !condition ? "*" : "";
    return condition;
}

function saveGroupData() {

    // process form
    if (!validateFields()) {
        $("basicBtn").onclick($('basicBtn'));
        return false; 
    }

    if (!GroupEdit.validate()) {
        return false;
    }

    if (!ConfirmSave()) {
        return false;
    }
    return true;
}

function validateFields() {
    // validate fields
    var isOk = true;
    isOk = setErrorMark(!$F(globalNameStr).blank(), "errNameStr");

    // its ok to create a group without a number
    //isOk = setErrorMark(!$F(globalNumberStr).blank(), "errNumberStr") && isOk;
    var infobar = $("validationSummaryInfo");
    if (isOk) {
        infobar.hide();
    } else {
        infobar.show();
    }
    return isOk;
}

function deleteGroup() {
    var alertmsg = globalMsgDelete;
    if (globalGroupId != "")
        alertmsg = getAjaxPage("EcomUpdator.aspx?CMD=ShopCheckForProducts&groupID=" + globalGroupId);
    return confirm(alertmsg);
}

function delocalize() {
    if (globalGroupId != "") {
        var Message = getAjaxPage("EcomUpdator.aspx?CMD=ShopCheckForDelocalize&groupID=" + globalGroupId);
        return confirm (Message);
    }
    else return false;
}	

function AddGroups(fieldName) {
    showTab("locationTab");

	if (enableClick) {
		var caller = "opener.document.getElementById('Form1')."+ fieldName;
		window.open("/Admin/module/ecom_catalog/dw7/edit/EcomGroupTree.aspx?CMD=ShowGroupToGroupRel&MasterGroupID=" + globalGroupId + "&MasterShopID=" + globalShopId + "&caller=" + caller, "", "displayWindow,width=460,height=400,scrollbars=no");
	}
}

function CheckPrimaryDWRow(chk, rowID) {
    if (!chk.hasClassName('RelatedGroupPrimary')) {
        var inputs = $$("#DWRowLineTable span.RelatedGroupPrimary");
        inputs.each(function (item) { item.removeClassName('RelatedGroupPrimary'); });
        $('GRPREL_PRIMARY_ID').value = rowID;
        chk.innerHTML = "<i class='md  md-check color-success'></i>";
    }
    else {
        $('GRPREL_PRIMARY_ID').value = "";
        chk.innerHTML = "<i class='md  md-close color-danger'></i>";
    }
    chk.toggleClassName('RelatedGroupPrimary');
}

function inheritParentCategories(chk, grId) {
    var val = $("inherited-categories").value;
    var arr = JSON.parse(val);
    if (chk.hasClassName('RelatedGroupInherited')) {
        var idx = arr.indexOf(grId);
        if (idx > -1) {
            arr.splice(idx, 1);
        }
        chk.innerHTML = "<i class='md  md-close color-danger'></i>";
    }
    else {
        arr.push(grId);
        chk.innerHTML = "<i class='md  md-check color-success'></i>";
    }
    $("inherited-categories").value = JSON.stringify(arr);
    chk.toggleClassName('RelatedGroupInherited');
}

function CheckDeleteDWRow(rowID, rowCount, layerName, GroupId, prefix, arg1, arg2) {
    DeleteDWRow(rowID, rowCount, layerName, GroupId, prefix, arg1, arg2, globalMsgDelete);
}

function DeleteAllGroups() {
    // Delete from GUI
    var count = globalGroupRelationsCount;
    if(count > 0) {
        for (var i = 1; i <= count; i++) // The indexer is 1-based
            DeleteTR("DWRowLineTable", "DWRowLineTR", i, "", "");
    }
    // Delete from database
	EcomUpdator.document.location.href = "../Edit/EcomUpdator.aspx?CMD=DeleteAllParentGroups&GroupID=" + globalGroupId;
}

function AddGroupRows() {
    dialog.hide("GroupEditMiscDialog");
    dialog.set_contentUrl("GroupEditMiscDialog", "");

    if (document.getElementById('Form1').addGroupsChecked.value.length > 0) {
        FillDivLayer("LOADING", "", "GRPREL");

        var grpArray = document.getElementById('Form1').addGroupsChecked.value;
        AddDWRowFromArry("GROUPS", globalGroupId, grpArray, "../Edit/", globalParentId, globalFromPIM ? "&FromPIM=true" : "")
    }
    else if (document.getElementById('Form1').relatedGroupsChecked.value.length > 0) {
        FillDivLayer2("LOADING", "", "relatedGroupsTab");

        var grpArray = document.getElementById('Form1').relatedGroupsChecked.value;
        AddDWRowFromArry("RELATEDGROUPS", globalGroupId, grpArray, "../Edit/", globalParentId, "")
    }
}

function removeFromField(grpID) {
	var tmpList = ""
	var listGrp = document.getElementById('Form1').oldGroupsChecked.value;
	
	tmpList = replaceSubstring(listGrp, "[" + grpID + "];", "")
	tmpList = replaceSubstring(tmpList, "[" + grpID + "]", "")
	document.getElementById('Form1').oldGroupsChecked.value = tmpList;
}  

function RemoveInternalEcom(fieldCaller) {
	if (fieldCaller != "") {
		document.getElementById("ID_" + fieldCaller).value = "";
		document.getElementById("Name_" + fieldCaller).value = "";
	}	
}

function FillDivLayer(typeStr, fillData, fillLayer) {
	var fillStr = ""
	
	if (typeStr == "LOADING") {
		fillStr = globalFillStr;
	}

	if (typeStr == "DWNONE") {
		fillStr = '<br/>';
	}

	if (fillData != "") {
		fillStr = fillData;
	}
	
	if (fillLayer == "GRPREL") {
		$('GrpRelData').innerHTML = fillStr;
	}	
}

// OrderLineFields
function addOrderLineField(systemName, name) {
    // Check if the orderline field is allready selected
    for (var i = 0; i < getOrderLineFieldCount(); i++)
        if (document.getElementById('OrderLineFieldHidden_' + i) && document.getElementById('OrderLineFieldHidden_' + i).value == systemName)
            return;

    // Make row
    var table = document.getElementById('OrderLineFieldTable');
    var tableBody = table.tBodies[0];
    var row = tableBody.insertRow(-1);
    var index = getOrderLineFieldCount();
    row.id = 'OrderLinefieldRow_' + index;

    // Make name cell
    var nameCell = row.insertCell(-1);
    nameCell.innerHTML = '<input type=hidden name=OrderLineFieldHidden_' + index + ' ID=OrderLineFieldHidden_' + index + ' value="' + systemName + '">' + name;

    // Make delete cell
    var deleteCell = row.insertCell(-1);
    deleteCell.innerHTML = '<a href=javascript:deleteOrderLineField(' + index + ');><i class="fa fa-remove color-danger" title="' + globalMsgDelete + '"></i></a>';
    deleteCell.style.width = '20px';
    
    incOrderLineFieldCount();
    
}

function deleteOrderLineField(rowIndex) {
    var row = document.getElementById('OrderLinefieldRow_' + rowIndex);
    var tableBody = document.getElementById('OrderLineFieldTable').tBodies[0];
    tableBody.deleteRow(row.rowIndex);
}

function getOrderLineFieldCount() {
    return parseInt(document.getElementById('OrderLineFieldCount').value, 10);
}

function incOrderLineFieldCount() {
    document.getElementById('OrderLineFieldCount').value = getOrderLineFieldCount() + 1;
}

function getFieldByID(field) {
    var ret = document.getElementById(field);

    if (!ret) {
        var elements = document.getElementsByName(field);

        if (elements != null && elements.length) {
            ret = elements[0];
        }
    }
    return ret;
}

var GroupEdit = {
    validation_result: null,

    get_validation: function () {
        if (!this._validation) {
            this._validation = new Dynamicweb.Validation.ValidationManager();
        }
        return this._validation;
    },

    validate: function (validateID) {
        var context = { manager: this.get_validation() };
        var validators = this.get_validation().get_validators();
        var validationErrors = "";
        if (validators && validators.length) {
            for (var i = 0; i < validators.length; i++) {
                if (validators[i].get_target() == validateID || !validateID) {
                    Dynamicweb.Validation.setFocusToValidateField = (validationErrors.length == 0);
                    var res = validators[i].beginValidate(context, GroupEdit.field_validation_error)
                    if (!res.isValid) {
                        if (validationErrors == "") {
                            validationErrors += res.errorMessage;
                        }
                    }
                    var elem = document.getElementById("asterisk_" + validators[i].get_target().replace("ctl00_ContentHolder_", ""))
                    if (elem)
                        elem.attributes["class"].value = (res.isValid ? "hide-error " : "validation-error ");
                }
            }
        }
        if (!validateID && validationErrors != "")
            alert(validationErrors);
        return (validationErrors.length == 0);
    },

    field_validation_error: function (result) {
        return result;
    },

    initGroupCategoryFields: function () {
        $$(".parent-category-cnt").each(function (el) {
            initCategoryFieldsInheritanceUI(el);
        });
    }
}