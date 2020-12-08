var timeStart;
var timeEnd;
var finished = false;

var Page = 1;
if (!TotalPages) {
	var TotalPages = Page;
}
var secondLastPage = parseInt(TotalPages - 1)



window.attachEvent("onload", PageInit);
window.attachEvent("onbeforeunload", AskCloseWizard);

window.document.oncontextmenu = DisableRClick;

//******************************//
// Disable right mouse click
//******************************//
function DisableRClick() {
	/*
	event.cancelBubble = true;
	return false
	*/
}

//******************************//
// Page init settings
//******************************//
function PageInit() {
	document.getElementById('BUTTONCANCEL').attachEvent("onclick", WindowClose);
	document.getElementById('BUTTONPREV').attachEvent("onclick", PrevPage);
	document.getElementById('BUTTONNEXT').attachEvent("onclick", NextPage);
	document.getElementById('BUTTONSTART').attachEvent("onclick", WizardStart);
	document.getElementById('BUTTONCLOSEW').attachEvent("onclick", CloseNoAsk);

	ShowPage(1);
	SetStatus();
}

function SetStatus() {
	var verStr = "v.1.0";
		
	document.getElementById('Version').innerHTML = 'DW Ecom '+ verStr;
	document.title = 'DW Ecom Wizard '+ verStr;
}

function SetActivePage() {
	document.getElementById('Page').innerHTML = Page;
	document.getElementById('TotalPages').innerHTML = TotalPages;
}

function ActivatePages(p) {
	if (p == 1) {
		document.getElementById('PAGE1').style.display = '';
		document.getElementById('BUTTONCANCEL').disabled = false;
		document.getElementById('BUTTONPREV').disabled = true;
		document.getElementById('BUTTONNEXT').disabled = false;
	} else if (p < secondLastPage) {
		document.getElementById('PAGE'+ p).style.display = '';
		document.getElementById('BUTTONCANCEL').disabled = false;
		document.getElementById('BUTTONPREV').disabled = false;
		document.getElementById('BUTTONNEXT').disabled = false;
		document.getElementById('BUTTONSTART').disabled = false;
	} else if(p == secondLastPage) {
		document.getElementById('PAGE'+ secondLastPage).style.display = '';
		document.getElementById('BUTTONCANCEL').disabled = false;
		document.getElementById('BUTTONPREV').disabled = false;
		document.getElementById('BUTTONSTART').disabled = false;
	} else if(p == TotalPages) {
		document.getElementById('PAGE'+ TotalPages).style.display = '';
		document.getElementById('BUTTONCANCEL').style.display = 'none';
		document.getElementById('BUTTONPREV').style.display = 'none';
		document.getElementById('BUTTONNEXT').style.display = 'none';
		document.getElementById('BUTTONSTART').style.display = 'none';
		document.getElementById('BUTTONCLOSEW').disabled = false;
		document.getElementById('BUTTONCLOSEW').style.display = '';
	}
}

function ShowPage(p) {

	Page = p

	HideAllPages();
	DisableAllButtons();
	SetActivePage();

	ActivatePages(p);
}
 
function PrevPage() {
	if (Page > 0) {
		ShowPage(Page-1);
	}
}

function NextPage() {
	if (Page < TotalPages) {
		ShowPage(Page+1);
    }
} 

function DisableAllButtons() {
	document.getElementById('BUTTONCANCEL').disabled = true;
	document.getElementById('BUTTONNEXT').disabled = true;
	document.getElementById('BUTTONPREV').disabled = true;
	document.getElementById('BUTTONSTART').disabled = true;

	DisableCloseButton();
}

function DisableCloseButton() {
	document.getElementById('BUTTONCLOSEW').disabled = true;
	document.getElementById('BUTTONCLOSEW').style.display = 'none';
}

function HideAllPages() {
	try {				
		document.getElementById('PAGEEXECUTE').style.display = 'none';
	} catch(e) {
		//Nothing
	}

	for (p = 0; p < TotalPages + 1; p++) {
		try {				
			document.getElementById('PAGE'+ p).style.display = 'none';
		} catch(e) {
			//Nothing
		}
	};
}

function AskCloseWizard() {
	event.returnValue = "Will you cancel the guide?";
}

function CloseNoAsk() {
	window.detachEvent("onbeforeunload", AskCloseWizard);
	window.close();
}

function WindowClose() {
	window.detachEvent("onbeforeunload", AskCloseWizard);
	window.attachEvent("onbeforeunload", AskCloseWizard);
	window.close();
}

function WindowCloseWait() {
	window.setTimeout("CloseNoAsk()", 2000);
}	

function ExecuteForm() {
	HideAllPages();
	DisableAllButtons();
	
	document.body.style.cursor = 'wait';
	document.getElementById('PAGEEXECUTE').style.display = '';
	
	if (method == 'PRODUCT') {
		document.WizardForm.CMD.value = "SAVE";
		document.WizardForm.target = "EcomUpdator"
		document.WizardForm.submit();
	}

	if (method == 'IMPEXP') {
	}

	WizardFinish()
}

function WizardStart() {
	timeStart = returnTime();
	ExecuteForm()
}

function WizardError() {
	timeEnd = returnTime();
}

function WizardFinish() {
	timeEnd = returnTime();
	document.body.style.cursor = 'default';
	window.setTimeout("WizardEnd()", 1000);
}

function WizardEnd() {
	ShowPage(TotalPages);
}

function reloadParentPage(prodId, groupId) {
	if (window.dialogArguments) {
		returnValue = prodId;
	} else {
		window.opener.location = "/admin/Module/eCom_Catalog/Edit/EcomProduct_Edit.aspx?ID="+ prodId +"&GroupID="+ groupId;
	}
}

function returnTime() {
	Stamp = new Date();

	var Hours;
	var Mins;
	var Secs;

	Hours 	= Stamp.getHours();
	Mins 	= Stamp.getMinutes();
	Secs	= Stamp.getSeconds(); 

	if (Secs < 10) {
		Secs = "0" + Secs;
	}

	if (Mins < 10) {
		Mins = "0" + Mins;
	}

	if (Hours < 10) {
		Hours = "0" + Hours;
	}
	
	return Hours +":"+ Mins + ":"+ Secs
}
