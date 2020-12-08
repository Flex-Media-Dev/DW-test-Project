var groupId = "";
function StartWizard(mode, arg1) {
	var width = 500;
	var height = 410;
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;

	var afterPopupClose = function (returnValue) { };
	if (mode == "PRODUCT") {
		groupId = arg1;
		page = "/admin/Module/eCom_Catalog/dw7/Wizard/EcomWizard.aspx?GroupID=" + groupId + "&mode=" + mode;
		afterPopupClose = function (returnValue) {
		    if (returnvalue && returnvalue != "" && returnvalue != "undefined") {
		            GotoProduct(returnvalue);
		    }
		}
	}	
	if (mode == "IMPEXP")
	    page = "/admin/Module/eCom_Catalog/dw7/Wizard/EcomWizardImpExp.aspx?method=" + arg1 + "&mode=" + mode;
			
	if (window.showModalDialog) {	    
	    var returnvalue = window.showModalDialog(page, "displayWindow", "dialogWidth:" + width + "px;dialogHeight:" + height + "px;dialogLeft:" + left + "px;dialogTop:" + top + "px;center:yes;help:no;status:no;scroll:no;");
	    afterPopupClose(returnvalue);
	} else {
	    var popupWnd = window.open(page, 'displayWindow', 'status=0,toolbar=0,menubar=0,resizable=0,directories=0,titlebar=0,modal=yes,width=' + width + ',height=' + height);
	    popupWnd.onunload = function () {
	        afterPopupClose(popupWnd.returnValue);
	    }
	}	
}

function GotoProduct(prodId) {
	document.location = "/admin/Module/eCom_Catalog/dw7/Edit/EcomProduct_Edit.aspx?ID="+ prodId +"&GroupID="+ groupId;
}



