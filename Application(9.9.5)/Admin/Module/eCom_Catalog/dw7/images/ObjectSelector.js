/* tested on IE7.0, FF2.0 & Opera9.0 */
function changeRowColor(objRow,ev) {
	ev = window.ev || ev;

	if (ev.ctrlKey == false) {
		/ * de-select all * /
		var items = getElementsByClass("osselecteditem", document, "div");

		for (var i = 0; i < items.length; i++) {
			items[i].className='ositem';
		}
	}

	if (ev.ctrlKey) {
		var text = objRow;
		if (text.setSelectionRange) {
			text.setSelectionRange(0, 100);
		} else if(document.selection) {
			var Sel = document.selection.createRange();
			Sel.execCommand("unselect");
		}
	}

	if (objRow.className =='osselecteditem') {
		objRow.className='ositem';
	}
	else {
		objRow.className='osselecteditem';
	} 
}

function deleteSelected(container) {
	var items = getElementsByClass("osselecteditem", document, "div");

	for (var i = 0; i < items.length; i++) {
		var inner = items[i].innerHTML;
                    
		var regex = /id="img((GRP|USR)_[\w]*)" class=/
		
		/* IE rewrites the HTML when adding it to the innerHTML with javascript. so we need another regex for IE */
		var regexIE = /id=img((GRP|USR)_[\w]*) src=/
                    
		var result = inner.match(regex);
		
		if(result == null) {
		    result = inner.match(regexIE);
		    if (result == null) {
		        result = inner.match(/id=img([^\s"]*) class=/);
		    }
		}
            
   		
		if(result != 'undefined' && result != null) {
		
			var selectoption = result[1];
			if(selectoption != null) {
				removeOption(result[1],container);
				items[i].innerHTML = '';
				items[i].outerHTML = '';
			}
		}
	}
}

function removeOption(optionValue, container) {
    var selectObject = document.getElementById(container);
	
    for (var i=(selectObject.options.length-1); i>=0; i--) {
	  if(selectObject.options[i].value == optionValue) {
		    selectObject.options[i] = null;
	  }
    }
}



function deleteSelectedProducts(container, valueFieldId, valueFieldRadio) {
	var items = getElementsByClass("osselecteditem", document, "div");

	for (var i = 0; i < items.length; i++) {
		var inner = items[i].innerHTML;
                   
		//var regex = /id="img(()[\w]*)" class=/
		var regex = /id="img([^\s"]*)" class=/
		
		/* IE rewrites the HTML when adding it to the innerHTML with javascript. so we need another regex for IE */
		//var regexIE = /id=img(()[\w]*) src=/
		var regexIE = /id=img([^\s"]*) src=/
                    
		var result = inner.match(regex);
		
		if(result == null) {
		    result = inner.match(regexIE); 
            if (result == null) { 
		        result = inner.match(/id=img([^\s"]*) class=/);
		    }
        }
       
            
		if(result != 'undefined' && result != null) {
			var selectoption = result[1];
			if(selectoption != null) {
				items[i].innerHTML = '';
				items[i].outerHTML = '';
				removeProductFormList(result[1],container,valueFieldId,valueFieldRadio);
			}
		}
	}
}


function removeProductFormList(optionValue, container, valueFieldId, valueFieldRadio) {
    var selectObject = document.getElementById(container);
    var valueObject = document.getElementById(valueFieldId);
    var newValue = valueObject.value;
	
	newValue = replaceSubstring(newValue, ";[" + optionValue + "]" , "");
	newValue = replaceSubstring(newValue, "["  + optionValue + "];", "");
	newValue = replaceSubstring(newValue, "["  + optionValue + "]" , "");
	document.getElementById(valueFieldId).value = newValue;
}



function getElementsByClass(searchClass,node,tag) {
    var classElements = new Array();
	if (node == null)
		node = document;
	if (tag == null)
		tag = '*';
	var els = node.getElementsByTagName(tag);
	var elsLen = els.length;
	var pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)");
	for (i = 0, j = 0; i < elsLen; i++) {
		if (pattern.test(els[i].className) ) {
			classElements[j] = els[i];
			j++;
		}
	}
	
	return classElements;
}
		
function addDivContent(itemId, itemName, itemImg, container) {
    var contentHolder = "";
    contentHolder += '  <div id="' + itemId + '" class="ositem" onclick="changeRowColor(this,event);">';
    contentHolder += '    <img id="img' + itemId + '" class="ositemimg" src="' + itemImg + '" />';
    contentHolder += '    ' + itemName + ' ';
    contentHolder += '  </div>';
			
    var CGdiv = document.getElementById(container + '_div');
    CGdiv.innerHTML += contentHolder;
			
    addOption(container, itemName, itemId)
}	
		
function addOption(container,optionText,optionValue) {
    var selectObject = document.getElementById(container);
    
    var len = selectObject.length++;
    selectObject.options[len].value = optionValue;
    selectObject.options[len].text = optionText;
    selectObject.options[len].selected = true;
}	


/* UserSelector */

function usToggleRadio(instance, radioid) {

	var divs = getElementsByClass(instance + '_hiddendivs', document, "div");	
	for (var i = 0; i < divs.length; i++) {
	    var div = divs[i];
	    if(div.id == instance + '_div_' + radioid) {
	        div.style.display = 'block';
	    }
	    else {
	        div.style.display = 'none';	        
	    }
	}
}

function osToggleCheckbox(instance, checkid) {

    var div = document.getElementById(instance + '_div_' + checkid);
    var checkbox = document.getElementById(instance + '_' + checkid);
    if(div && checkbox) {
	    if(checkbox.checked == true) {
            div.style.display = 'block';
        }
        else {
            div.style.display = 'none';	        
        }
    }
}

function dsUpdateHidden(instance, radioid, prefix) {

    var radioelement = document.getElementById(instance + '_' + radioid);
    var container = document.getElementById(instance);
    
    if (radioelement && radioelement.checked) 
    {
        var radiovalue = document.getElementById(instance + '_' + radioid + '_value');
        container.value = prefix + radiovalue.value;
    }
}

function ClearProdItems(container) {
    var CGdiv = document.getElementById(container + '_div');
    CGdiv.innerHTML = '';
}

function AddProdItemRows(id, radio) {

    ClearProdItems(id + '_' + radio);

    // show products
    var radvalue = document.getElementById(id + '_' + radio + '_value');
    
    // split up string
    var products = radvalue.value.split(';');
    for(var i = 0; i < products.length; i++)
    {
        addProductDivContent(products[i], products[i], '/Admin/Images/eCom/eCom_Product_small.gif', id + '_' + radio);
    }
    
    // force hidden field update
    invokeObjectByClick(id, radio);
    
//    //
//    var CGdiv = document.getElementById(id + '_' + radio + '_div');
//    CGdiv.innerHTML = '';
}

function invokeObjectByClick(id, radio) {
    var rad = document.getElementById(id + '_' + radio);
    if (rad != null)
        rad.click();
}

function addProductDivContent(itemId, itemName, itemImg, container) {
    var contentHolder = "";
    contentHolder += '  <div id="' + itemId + '" class="ositem" onclick="changeRowColor(this,event);">';
    contentHolder += '    <img id="img' + itemId + '" class="ositemimg" src="' + itemImg + '" />';
    contentHolder += '    ' + itemName + ' ';
    contentHolder += '  </div>';
			
    var CGdiv = document.getElementById(container + '_div');
    CGdiv.innerHTML += contentHolder;
}

function generateGuid() {
    var result, i, j;
    result = '';
    
    for(j=0; j<32; j++) {
        if( j == 8 || j == 12|| j == 16|| j == 20)
            result = result + '-';
        i = Math.floor(Math.random()*16).toString(16).toUpperCase();
        result = result + i;
    }
    
    return result
}


/* data verify'ers */

//*********************************** 
// CVS ADDIN FUNCTIONS 
//***********************************
function CSVAddField(instanceId) {
    var div = document.getElementById('CSVFields' + instanceId);
    
    var newdiv = document.createElement('div');
    newdiv.innerHTML = "<input type=\"text\" id=\""+ instanceId +"_"+ generateGuid() +"\" value=\"\" onclick=\"CSVSetSelectedElement('"+ instanceId +"',this);\" onkeyup=\"CSVUpdateHidden('"+ instanceId +"');\">";
    div.appendChild(newdiv);
    
    CSVUpdateHidden(instanceId);
}

function CSVDeleteField(instanceId) {
    var fieldSelected = CSVGetSelectedElement(instanceId);
    
    if (fieldSelected != null) {
        if (confirm("Delete?")) {
            var d = document.getElementById('CSVFields' + instanceId);
            d.removeChild(fieldSelected.parentNode);
            fieldSelected = null
        }    
    }

    CSVUpdateHidden(instanceId);
}

function CSVSetSelectedElement(instanceId, input) {
    // get previously selected
    var fieldSelected = CSVGetSelectedElement(instanceId);

    // change background color of previous selected
    if(fieldSelected != null) {
        fieldSelected.style.backgroundColor = '';
    }

    // save new value to hidden
    var hidden = document.getElementById('CSVSelected' + instanceId);    
    hidden.value = input.id;
    
    // change the background color of the currently selected
    input.style.backgroundColor = '#ffffe1';
}

function CSVGetSelectedElement(instanceId) {
    // get hidden field that knows what input is selected
    var hidden = document.getElementById('CSVSelected' + instanceId);
    
    // do we have a selected one?
    if(hidden != null && hidden.value != '') {
        // lets get and return the selected one
        var element = document.getElementById(hidden.value);
        return element;
    }
    
    // we have nothing
    return null;
}

function CSVMoveUp(instanceId) {
    CSVMove(instanceId, 'up'); 
}

function CSVMoveDown(instanceId) {
    CSVMove(instanceId, 'down'); 
}

function CSVMove(instanceId, action) {
    var fieldSelected = CSVGetSelectedElement(instanceId);
    if(fieldSelected != null) {
        var field = fieldSelected.parentNode;
    
        var items = CSVGetCollectionFromParent(field.parentNode);
        var index = CSVGetIndexInCollection(field);
          
        if (items.length > 0 && index != -1) {
            var highestindex = items.length - 1;
            
            if (index >= 0 && index < highestindex && action == 'down') {
                CSVMoveToIndex(field, CSVGetNextSibling(field));
            } else if (index > 0 && index <= highestindex && action == 'up') {
                CSVMoveToIndex(field, CSVGetPreviousSibling(field));
            } else {            
                // cant move number ' + index;
            }
        }
    }

    CSVUpdateHidden(instanceId);
}

function CSVGetCollectionFromParent(parent) {
    var items = parent.getElementsByTagName('DIV');
    return items;
}

function CSVGetIndexInCollection(element) {
    var items = CSVGetCollectionFromParent(element.parentNode);
    for(var i = 0; i < items.length; i++) {
        if(items[i] == element) {
            return i;
        }
    }

    return -1;
}

function CSVGetNextSibling(element) {
    var items = CSVGetCollectionFromParent(element.parentNode);
    for(var i = 0; i < items.length; i++) {
        if(items[i] == element) {
            return items[i+1];
        }
    }

    return null;
}

function CSVGetPreviousSibling(element) {
    var items = CSVGetCollectionFromParent(element.parentNode);
    for(var i = 0; i < items.length; i++) {
        if(items[i] == element) {
            return items[i-1];
        }
    }

    return null;
}

function CSVMoveToIndex(element, sibling) {
    var parent = element.parentNode;
    var dummy = document.createElement('DIV');
    if(sibling != null) {
        parent.replaceChild(dummy, element);
        parent.replaceChild(element, sibling);
        parent.replaceChild(sibling, dummy);
    }
}

function CSVUpdateHidden(instanceId) {

    var valueholder = document.getElementById(instanceId);
    valueholder.value = '';

    // Checkbox: Field names on first row
    var checkbox = document.getElementById('checkbox' + instanceId);
    if (checkbox.checked) {
        // Set the value
        valueholder.value = checkbox.value;
        // Hide the other controls
        CSVShowFields(instanceId, false)
    }
    else {
        // Show buttons and fields
        CSVShowFields(instanceId, true)

        // Fields    
        var divholder = document.getElementById('CSVFields' + instanceId);
        var idholder = '';
        var inputs = divholder.getElementsByTagName('INPUT');
        for (i = 0; i < inputs.length; i++) {
            if (inputs[i].type == 'text' && inputs[i].id != null && inputs[i].id != '') {
                idholder = inputs[i].id.toString();
                if (idholder.indexOf(instanceId) == 0 && idholder != instanceId) {
                    
                    // Check the field for any character that is not a letter, digit or underscore
                    var invalidChar = new RegExp("[^\\w]", "g"); // The 'g' tells the replace to replace ALL illegal chars, not just the last match (G for Global)
                    if (inputs[i].value.match(invalidChar))
                        inputs[i].value = inputs[i].value.replace(invalidChar, "");
                    
                    if (valueholder.value != '') {
                        valueholder.value += '#;#' 
                    }
                    valueholder.value += '['+ inputs[i].value +']';
                }
            }
        }
    }
}

function CSVShowFields(instanceId, show) {
	if (show) {
	    // Enable buttons
	    for (var i = 1; i <= 4; i++) {
	        var buttonID = "but" + i + instanceId;
		    document.getElementById(buttonID).style.filter = "";
		    document.getElementById(buttonID).style.cursor = "hand";
		    document.getElementById(buttonID).disabled = false;
		}
		// Enable fields
		var divholder = document.getElementById('CSVFields' + instanceId);
        var inputs = divholder.getElementsByTagName('INPUT');
        for (i = 0; i < inputs.length; i++) {
            if (inputs[i].type == 'text' && inputs[i].id != null && inputs[i].id != '') {
                inputs[i].disabled = false;
            }
        }
	}
	else {
	    // Disable buttons
	    for (var i = 1; i <= 4; i++) {
	        var buttonID = "but" + i + instanceId;
		    document.getElementById(buttonID).style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30);progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);-moz-opacity: 0.4;";
		    document.getElementById(buttonID).style.cursor = "";
		    document.getElementById(buttonID).disabled = true;
		}
		// Disable fields
		var divholder = document.getElementById('CSVFields' + instanceId);
        var inputs = divholder.getElementsByTagName('INPUT');
        for (i = 0, j = 0; i < inputs.length; i++) {
            if (inputs[i].type == 'text' && inputs[i].id != null && inputs[i].id != '') {
                inputs[i].disabled = true;
            }
        }
    }
}

//*********************************** 
// USER GROUP ADDIN FUNCTIONS 
//***********************************
function UserGroupAdd(id) {

    var formId = document.forms[0].id
    var caller = "opener.document.getElementById('" + formId + "')." + id;

	window.open("/Admin/Module/eCom_Catalog/Lists/EcomUserTree.aspx?caller=" + caller + "&output=single&cmd=onlyGroups","","displayWindow,width=460,height=400,scrollbars=no");
}
function UserGroupDelete(id) {
    var idContainer = document.getElementById(id);
    var nameContainer = document.getElementById(id + "_div");
    
    idContainer.innerHTML = "";
    nameContainer.innerHTML = "";
}


//*********************************** 
// PRODUCT GROUP ADDIN FUNCTIONS 
//***********************************
function ProductGroupAdd(id, append) {
	var cmd = 'ShowGroup';

	var formId = document.forms[0].id
	var caller = "opener.document.getElementById('" + formId + "')." + id;
	var caller2 = "opener.document.getElementById('" + formId + "').GroupName" + id;
	
	window.open("/Admin/Module/eCom_Catalog/dw7/edit/EcomGroupTree.aspx?CMD="+ cmd +"&AppendType="+ append +"&caller="+ caller +"&caller2="+ caller2,"","displayWindow,width=460,height=400,scrollbars=no");
}	

function ProductGroupRemove(id) {
    var grpId = document.getElementById(id);
    var grpName = document.getElementById('GroupName'+ id);
	grpId.value = '';
	grpName.value = '';
}

// Multiple Groups
function ProductMultiGroupsAdd(id) {
    var cmd = 'ShowGroupEditor';

    var formId = document.forms[0].id
    var caller = "opener.document.getElementById('" + formId + "').Groups" + id;
	var caller2 = id;
	
	var objIndex = document.getElementById('Groups'+ id);
	var grpArray = objIndex.value;

	window.open("/Admin/Module/eCom_Catalog/dw7/edit/EcomGroupTree.aspx?CMD="+ cmd +"&grpArray="+ grpArray +"&caller="+ caller +"&caller2="+ caller2,"","displayWindow,width=460,height=400,scrollbars=no");
}
	
function ProductMultiGroupsRemove(grpID, instanceId) {
	try {
		var objIndex = document.getElementById('gRow'+ grpID + instanceId).rowIndex;
		document.getElementById('DWEcomEditGroups').deleteRow(objIndex);
	} catch(e) {
		//Nothing
	}		
	
	var objGrp = document.getElementById('Groups'+ instanceId);
	var stdList = objGrp.value;
	stdList = replaceSubstring(stdList, "" + grpID + ",", "");
	stdList = replaceSubstring(stdList, "," + grpID + "", "");
	stdList = replaceSubstring(stdList, "" + grpID + "", "");
	objGrp.value = stdList;

	var objGrpTmp = document.getElementById('Groups'+ instanceId +'Tmp');
	var tmpList = objGrpTmp.value;
	tmpList = replaceSubstring(tmpList, "[" + grpID + "];", "");
	tmpList = replaceSubstring(tmpList, ";[" + grpID + "]", "");
	tmpList = replaceSubstring(tmpList, "[" + grpID + "]", "");
	objGrpTmp.value = tmpList;
	
	ProductMultiGroupsApply(instanceId);
}

function ProductMultiGroupsAppend(id) {
	var objIndex = document.getElementById('Groups'+ id);
	var grpArray = objIndex.value;
	var setArr = grpArray;
	var fetchArr = "";

	setArr = replaceSubstring(setArr, "[", "")
	setArr = replaceSubstring(setArr, "];", ",")
	setArr = replaceSubstring(setArr, "]", "")
	setArr = replaceSubstring(setArr, " ", "")
	setArr = replaceSubstring(setArr, ";", ",")
	objIndex.value = setArr;		

	fetchArr = setArr;

	ProductMultiGroupsFetch(fetchArr, id);
}

function ProductMultiGroupsFetch(fetchArr, id) {
    var groupFetch = fetchArr;

    if (groupFetch != "" && id != "") {
        getProductGroupsForEditor(id, groupFetch);
    }
}	

function ProductMultiGroupsApply(instanceId) {
    var objIndex = document.getElementById('Groups'+ instanceId);
    var groups = objIndex.value;

    var valueholder = document.getElementById(instanceId);
    
    valueholder.value = groups;
}	

//*********************************** 
// TRACE ADDIN FUNCTIONS 
//***********************************
function TraceUpdateHidden(instanceId) {
    var valueholder = document.getElementById(instanceId);
    var fileElem = document.getElementById("TraceFileLocator" + instanceId);
    var radioValue = "";

    if (document.getElementById(instanceId + "Consol").checked) {
        radioValue = "Consol";
        fileElem.style.display = "none";
    } else if (document.getElementById(instanceId + "File").checked) {
        radioValue = "File";
        fileElem.style.display = "block";
    }

    valueholder.value = '[' + radioValue +
                        ']#;#[' +
                              document.getElementById("TraceFile" + instanceId).value +
                        ']';
}


//*********************************** 
// XSL TRANSFORM ADDIN FUNCTIONS 
//***********************************
function XSLTransformUpdateHidden(instanceId) {
    var valueholder = document.getElementById(instanceId);
    var fileElem = document.getElementById("XSLTransformFileLocator" + instanceId);
    var textElem = document.getElementById("XSLTransformTxtLocator" + instanceId);
    var radioValue = "";

    if (document.getElementById(instanceId + "File").checked) {
        radioValue = "File";
        fileElem.style.display = "block";
        textElem.style.display = "none";
    } else if (document.getElementById(instanceId + "Text").checked) {
        radioValue = "Text";
        textElem.style.display = "block";
        fileElem.style.display = "none";
    }

    valueholder.value = '[' + radioValue +
                        ']#;#[' +
                              document.getElementById("XSLTransformFile" + instanceId).value +
                        ']#;#[' +
                              document.getElementById("XSLTransformTxt" + instanceId).value +
                        ']';
}


//*********************************** 
// DELIMITER ADDIN FUNCTIONS 
//***********************************
function DelimiterUpdateHidden(instanceId) {
    var valueholder = document.getElementById(instanceId);
    
    if (document.getElementById(instanceId + "Semicolon").checked) {
        valueholder.value = radioValue;
    } else if (document.getElementById(instanceId + "Comma").checked) {
        valueholder.value = radioValue;
    } else if (document.getElementById(instanceId + "Tab").checked) {
        valueholder.value = radioValue;
    }
}   



//*********************************** 
// ReportSettingsParameterEditor AddIn functions
//***********************************
function rspAddEmail(instance) {
    var container = document.getElementById(instance + '_div_addemails');
    var template = document.getElementById(instance + '_div_addemails_template');
    var newdiv = document.createElement('DIV');
    var newid = generateGuid();
    if(template) {
        newdiv.id = newid;
        newdiv.innerHTML = template.innerHTML.replace('#SELECTID#',newid);
        
        container.appendChild(newdiv);
    }
}

function rspUpdateHidden(instance) {
    var hidden = document.getElementById(instance);
    var container = document.getElementById(instance + '_div_addemails');
    
    var cb_store = document.getElementById(instance + '_store');
    var cb_send = document.getElementById(instance + '_send');
    var cb_show = document.getElementById(instance + '_show');
    
    if(cb_store && cb_send && cb_show) { 
        var filename = document.getElementById(instance + '_filename');
        var email = document.getElementById(instance + '_email');
        var val = '';
	    var to = '';
	    var cc = '';
	    var bcc = '';
	    
        if(cb_send.checked) {
            // get extra emails
	        var divs = container.getElementsByTagName('DIV');
	        for(var i = 0; i < divs.length; i++) {	        
	            var _sel = divs[i].getElementsByTagName('SELECT');
	            var _input = divs[i].getElementsByTagName('INPUT');	            
	            if(_sel && _sel.length > 0 && _input && _input.length > 0) {
	            
	                var emailvalue = '' + _input[0].value + '';
	                if(emailvalue == '') {
	                    emailvalue = ' ';
	                }
	            
	                if(_sel[0].value == 'to') {
	                    to += (to.length > 0 ? ',' : '');
	                    to += emailvalue;
	                }
	                else if(_sel[0].value == 'cc') {
	                    cc += (cc.length > 0 ? ',' : '');
	                    cc += emailvalue;
	                }
	                else if(_sel[0].value = 'bcc') {
	                    bcc += (bcc.length > 0 ? ',' : '');
	                    bcc += emailvalue;
	                }	            	                	            
	            }	        
	        }
        }       
        val += 'store=' + (cb_store.checked ? '1' : '0') + ';';
        val += (cb_store.checked ? 'filename=' + filename.value + ';' : '');        
        
        val += 'send=' + (cb_send.checked ? '1' : '0') + ';';
        val += (cb_send.checked ? 'email=' + email.value + ';' : '');
        val += (cb_send.checked ? 'to=' + to + ';' : '');
        val += (cb_send.checked ? 'cc=' + cc + ';' : '');
        val += (cb_send.checked ? 'bcc=' + bcc + ';' : '');
        
        val += 'show=' + (cb_show.checked ? '1' : '0') + ';';
          
        hidden.value = val;
    }
}

//*********************************** 
// DocumentViewerEditor
//***********************************
function dveToggleDocument(instance) {
    var container = document.getElementById(instance);
    if(instance) {
        if(container.style.display == 'none') {
            container.style.display = 'block';
        }
        else {
            container.style.display = 'none';
        }
    }
}