var curElem = null;
var checks = {};	// Hashtable
var htRights = {};	// Hashtable
var changes = {};	// Hashtable

function definedRight(userID, userName, isGroup, permissions, inherited){
    this.userID = userID;
    this.isGroup = isGroup;
    this.userName = userName;
    this.permissions = permissions;
    this.inherited = inherited;
}

function doLoad(){
	var allChecks = document.getElementsByTagName('input');
	
	for(var idx = 0; idx < allChecks.length - 1; idx++){
		var elemID = new String();
		elemID = allChecks[idx].id;
		if((elemID.indexOf("PERMISSION_", 0) > -1) && allChecks[idx].type == 'checkbox'){
			checks[elemID] = allChecks[idx];	
		}
	}
	enableChecks(false);
	setTimeout ('highlightElement(0)', 100);
}

function highlightElement(index){
	var divs = document.getElementById('permissionUsersAndGroups').getElementsByTagName('div');
	try{
		highlightAction(divs[index], true);
		divs[index].click();
	}catch(e){}
}


function ReplaceTagsForInnerText(xStr){
    var regExp = /<\/?[^>]+>/gi;
    xStr = xStr.replace(regExp,"");
    return xStr;
}


function addItem(type, id) {
    addItem(type, id, event)
}

function addItem(type, id, evt) {

    var e = evt || window.event;

	if(htRights["RIGHTS_" + id] == undefined){
		var inEffect = -1;
		
		var url = "/Admin/Modules/eCom_Catalog/Edit/EcomPermission.aspx?CMD=GETINEFFECT&TYPE=" + RequestQueryString("CMD") + "&ID=" + RequestQueryString("ID") + "&GROUPID=" + id.toString();

		if(window.XMLHttpRequest){
			// code for all new browsers
			xmlhttp = new XMLHttpRequest();
		}else if(window.ActiveXObject){
			// code for IE5 and IE6
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	
		if(xmlhttp != null){
			var itemName = ""
			if(id == "-2" || id == -2){
				itemName = guitextEveryone;
			}else{
			    if (e.srcElement) {
				    itemName = e.srcElement.innerText;
                } else {
                    var innerTxt = document.getElementById("usr_obj_"+ id).innerHTML;
                    itemName = innerTxt;
				}
			}

			xmlhttp.open("GET", url, false);
			xmlhttp.send(null);
			htRights["RIGHTS_" + id] = new definedRight(id, itemName, type == 0, allRightsGranted, parseInt(xmlhttp.responseText));
		}else{
			alert(guitextNoXMLHttpSupport);
			e.srcElement.disabled = false;
			enableChecks(true);
		}
	}
	CreateListOfCurrentRights();
	getDefinedRights(document.getElementById("RIGHTS_" + id));
}


function removeSelected(){
	delete htRights[curElem.id];
	try{
		delete changes[curElem.id];
	}catch(noSuchElement){}
	curElem = null;
	CreateListOfCurrentRights();

	try{
		event.srcElement.disabled = true;
	} catch(noEvent){}
	
	unselectAllRights();
	try{
    	event.srcElement.disabled = true;
	} catch(noEvent){}
}

function hasChanges(){
	try{
		for(var key in changes){
			return true;
		}
	}catch(e){return false;}
	return false;
}

function commandCancel(){
	if(hasChanges() == true){
		if(confirm(guitextConfirmClose)){
			window.close();
		}
	}else{
		window.close();
	}
}

function RequestQueryString(name){
	name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
	var regexS = "[\\?&]" + name + "=([^&#]*)";
	var regex = new RegExp(regexS);
	var results = regex.exec(window.location.href);
	if(results == null){
		return "";
	}else{
		return results[1];
	}
}

var xmlhttp = null;
function commandOK(){
	enableChecks(false);
	try{
    	event.srcElement.disabled = true;
	} catch(noEvent){}
	
	var s = new String();
	for(var key in htRights){
		var dr = htRights[key];
		if(s.length > 0){
			s = s + "~"
		}
		s = s + dr.userID + "_" + dr.permissions;
	}
	
	var url = "EcomPermission.aspx?CMD=SAVE";
	url += "&TYPE=" + RequestQueryString("CMD");
	url += "&ID=" + RequestQueryString("ID");
	url += "&RIGHTS=" + s.valueOf();
	try{
		url += "&APPLYTOCHILDREN=" + document.getElementById('chkApplyToChildren').checked;
	}catch(notFoundError){}

	if(window.XMLHttpRequest){
		// code for all new browsers
		xmlhttp = new XMLHttpRequest();
	}else if(window.ActiveXObject){
		// code for IE5 and IE6
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	
	if(xmlhttp != null){
		xmlhttp.onreadystatechange = rightsPosted;
		xmlhttp.open("GET", url, true);
		xmlhttp.send(null);
	}else{
		alert(guitextNoXMLHttpSupport);
	    try{
    	    event.srcElement.disabled = false;
	    } catch(noEvent){}
	    enableChecks(true);
	}
}

function rightsPosted(){
	var displayError = false;

	if(xmlhttp.readyState == 4){
		// 4 = "loaded"
		if(xmlhttp.status == 200){
			// 200 = OK
			if(xmlhttp.responseText == "OK"){
				window.close();
				
			}else{
				displayError = true;
			}
		}else{
			displayError = true;
		}
	}
	
	if(displayError == true){
		alert(guitextUnknownError);
		document.getElementById('buttonOK').disabled = false;
		enableChecks(true);
	}
}

function enableChecks(enable){
	for(var key in checks){
	    // Disable Read for now. It's not working
        if (key == 'PERMISSION_Read')
    		checks[key].disabled = true;
    	else
    	    checks[key].disabled = !enable;
	}
}


function unselectAllRights(){
	for(var key in checks){
		document.getElementById(key).checked = false;
	}
}

function CreateListOfCurrentRights(){
	removeChildNodes(document.getElementById('permissionUsersAndGroups'));
	
	for(var key in htRights)
	{
		var dr = htRights[key];
		var elem = document.createElement('div');
		elem.setAttribute('id', 'RIGHTS_' + dr.userID);
		elem.style.cursor = 'hand';
		elem.style.paddingLeft = '5px';
		elem.style.paddingTop = '2px';
		elem.style.paddingBottom = '2px';
		elem.onclick = function(){ getDefinedRights(this) };
		elem.onmouseover = function(){ highlightAction(this, true) };
		elem.onmouseout = function(){ highlightAction(this, false) };
        
        var img = document.createElement('img');
        if(dr.isGroup){
			img.src = '/admin/Module/eCom_Catalog/images/usergroup_folder.gif'
        }else{
			img.src = '/admin/Module/eCom_Catalog/images/user_user.gif'
        }
        img.align = 'middle';
        elem.appendChild(img);
        
        var txt = document.createElement('span');
        if (navigator.appName.indexOf('Microsoft') == -1) {
            txt.textContent = dr.userName;
        }else{
            txt.innerHTML = dr.userName;
        }
        
        elem.appendChild(txt);
		document.getElementById('permissionUsersAndGroups').appendChild(elem);
	}
	markChangedElements();
}

function markAsChanged(){
	curElem.style.fontWeight = 'bolder';
	changes[curElem.id] = true;
}

function markChangedElements(){
	for(var key in changes){
		document.getElementById(key).style.fontWeight = 'bolder';
	}
}

function permissionsAllClicked(){
	unselectAllRights(false);
	document.getElementById('PERMISSION_All').checked = true;
	htRights[curElem.id].permissions = -1;
	markAsChanged();
}

function permissionsNoneClicked(){
	unselectAllRights(false);
	document.getElementById('PERMISSION_None').checked = true;
	htRights[curElem.id].permissions = 0;
	markAsChanged();
}

function permissionsOtherClicked(){
	document.getElementById('PERMISSION_All').checked = false;
	document.getElementById('PERMISSION_None').checked = false;
	
	var r = htRights[curElem.id]
	r.permissions = 0;
	
	for(var key in checks){
		var curCheck = document.getElementById(key);
		if(curCheck.checked == true){
			if(curCheck.disabled == false){
				var chkValue = parseInt(curCheck.value);
				if(chkValue > 0){
					r.permissions = r.permissions + chkValue;
				}
			}
		}
	}
	
	htRights[curElem.id] = r;
	markAsChanged();
}

function removeChildNodes(ctrl){
	for(var idx = ctrl.childNodes.length - 1; idx >= 0; idx--){
	    try {
		    if(ctrl.childNodes[idx].tagName.toLowerCase() == 'div'){
			    ctrl.removeChild(ctrl.childNodes[idx]);
		    }
        } catch(ex) {
            //
        }		    
	}
}

function showUsersRights(User){
	//alert('You clicked on "' + User.userName + '"');
	//alert('The following rights are granted : ' + User.permissions);

	unselectAllRights(true);
	
	switch(User.permissions){
		case -1:
			document.getElementById('PERMISSION_All').checked = true;					
			break;
		case 0:
			document.getElementById('PERMISSION_None').checked = true;
			break;
		default:
			for(var key in checks){
				var curCheck = document.getElementById(key);
				var chkValue = parseInt(curCheck.value);
				if(chkValue > 0){
					if((User.permissions & chkValue) == chkValue){
						curCheck.checked = true;
					}else{
						curCheck.checked = false;
					}
				}
			}
			break;
	}

}

function getDefinedRights(elem){
	clearCurrentSelection();
	setCurrentSelection(elem);
	showUsersRights(htRights[elem.id]);
	//document.getElementById('permissionForName').innerText = htRights[elem.id].userName;
	document.getElementById('buttonRemove').disabled = false;
	enableChecks(true);
}

function clearCurrentSelection(){
	if(curElem != null){
		curElem.style.backgroundColor = 'Transparent';
		curElem.style.color = 'Black'
	}
	
	setCurrentSelection(null);
	enableChecks(false);
}

function setCurrentSelection(NewCurrentElement){
	curElem = NewCurrentElement;
	if(curElem != null){
		curElem.style.backgroundColor = 'Highlight';
		curElem.style.color = 'HighlightText';
	}
}

function highlightAction(row, highlightOn){
	var bgColor;
	var color;
	
	if(highlightOn == true){
		bgColor = 'Highlight';
		color = 'HighlightText';
	}else{
		if(row != curElem){
			bgColor = 'Transparent';
			color = 'Black';
		}else{
			bgColor = 'Highlight';
			color = 'HighlightText';
		}
	}

	row.style.backgroundColor = bgColor;
	row.style.color = color;			
}
