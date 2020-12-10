// JScript File

function ToggleMostPopular()
{
    var chk = document.getElementById("NewsParagraphOrderByMostPopular");
    ShowMostPopularOptions(chk.checked);
}

function  ShowMostPopularOptions(visible)
{
    document.getElementById("mostPupularOptions").style.display = visible ? '' : 'none';
}

function ShowHideNewsParagraphShowPersonalize()
{
    var chk = document.getElementById("NewsParagraphShowPersonalize");
    if(chk != null && chk != "undefined")
    {
	    if (chk.checked) {
		    document.getElementById("TR_NewsParagraphShowPersonalize").style.display = "";
	    } 	else {
		    document.getElementById("TR_NewsParagraphShowPersonalize").style.display = "none";
	    }
	}
}
function ShowHideNewsParagraphShowCustom(){

    if (document.getElementById("NewsParagraphShowCustom").checked) {
        document.getElementById("TR_NewsParagraphShowCustom").style.display = "";
    } else {
        document.getElementById("TR_NewsParagraphShowCustom").style.display = "none";
    }
}

function togglePagingType()
{
    var intType;
    if (document.forms[0]['NewsParagraphCustomPagingType'][0].checked) {
        intType = 1;
    }else if (document.forms[0]['NewsParagraphCustomPagingType'][1].checked) {
        intType = 2;
    }else{
        intType = 3;
    }
    document.getElementById("TR_NewsParagraphCustomPaging").style.display = intType == 3 ? "none" : "";
}


function toggleSSubmitBtn(){
    if (document.getElementById("SBtn1").checked) {
        document.getElementById("SShowBtn1").style.display = "";
        document.getElementById("SShowBtn2").style.display = "none";
    }
    else if (document.getElementById("SBtn2").checked) {
        document.getElementById("SShowBtn1").style.display = "none";
        document.getElementById("SShowBtn2").style.display = "";
    }
    else if (document.getElementById("SBtn3").checked) {
        document.getElementById("SShowBtn1").style.display = "";
        document.getElementById("SShowBtn2").style.display = "";
    }
}

function ToggleCreate() {
    if (document.getElementById('CreateNews').checked) {
        document.getElementById('listcategory').style.display = 'none';
        document.getElementById('ListNewsShow').style.display = 'none';
        document.getElementById('ListNewsShow1').style.display = 'none';
        document.getElementById('ListNewsShow2').style.display = 'none';
        document.getElementById('ListNewsShow3').style.display = 'none';
        document.getElementById('SubmitNewsShow').style.display = '';
    } else {
        document.getElementById('ListNewsShow').style.display = '';
        document.getElementById('ListNewsShow1').style.display = '';
        document.getElementById('ListNewsShow2').style.display = '';
        document.getElementById('ListNewsShow3').style.display = '';
        document.getElementById('listcategory').style.display = '';
        document.getElementById('SubmitNewsShow').style.display = 'none';
    }
}

function ChkNumeric(e)
{
    var k = (typeof e.charCode == "undefined" ? e.keyCode : e.charCode);
    if (k < 32 || e.ctrlKey || e.altKey || e.metaKey) return true;
    return (k >= 48 && k <= 57);
}

function ToggleTeaser()
{
    document.getElementById("advXChars").style.display = document.getElementById('Manchet').checked ? 'none' : '';
}

function ToggleApprove()
{
    document.getElementById('approvepage').style.display = document.getElementById('NewsSubmitApprove').checked ? '' : 'none';
}


function ToggleAdvanced() {
    if (document.getElementById('AdvancedSettingsUse').checked) {
        document.getElementById('AdvancedSettingsGroup').style.display = '';
    } else {
        document.getElementById('AdvancedSettingsGroup').style.display = 'none';
    }
}

function disableDependentFields(isExtranetInstalled) {
    var fields = [
        'ModeCreateNews',
        'SubmitNewsShow'
    ];

    if(!isExtranetInstalled)
        for(var i = 0; i < fields.length; i++)
            disableContents(fields[i]);
}

function disableContents(id) {
    var obj = document.getElementById(id);
    if(obj && obj.childNodes) {
        var childs = obj.childNodes;
        for(var i = 0; i < childs.length; i++) {
            var child = childs[i];
            
            if(typeof(child.disabled) != 'undefined')
                child.disabled = true;
            if(typeof(child.setAttribute) == 'function')
                child.setAttribute('style', 'color: #c3c3c3');
        }
    }
}
