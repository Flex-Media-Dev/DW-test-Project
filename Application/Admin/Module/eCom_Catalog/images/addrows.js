var enableClick = true;
var prodGroupAdd = true;
var prodRelatedAdd = true;
var prodVariantGrpAdd = true;
var prodDetailAdd = true;
var prodPropertyAdd = true;
var prodProdItemAdd = true;

var levelA = true;
var levelB = false;
var levelC = false;

try {
	var FeePay1		= '<input type="hidden" name="DFEE_ID#DWCNT#" value="-1"><input type="hidden" name="DFEE_LineID#DWCNT#" value="#DWCNT#"><input type="text" maxlength="25" name="DFEE_Value#DWCNT#" value="0" size="6">';
	var FeePay2		= '<select name="DFEE_Type#DWCNT#"><option value="0">$</option><option value="1">%</option></select>';
	var FeePay3		= '<input type="text" maxlength="25" name="DFEE_WeightLimit#DWCNT#" value="0" size="6">';
	var FeePay4		= '<input type="text" maxlength="25" name="DFEE_Volume#DWCNT#" value="0" size="6">';
} catch(e) {
	//Nothing
}	

try {
	var Variant1	= '<input type="hidden" name="VARGRP_ID#DWCNT#" value="-1"><input type="hidden" name="VARGRP_LineID#DWCNT#" value="#DWCNT#"><input type="text" maxlength="255" name="VARGRP_Name#DWCNT#" value="" style="width:100%">';
} catch(e) {
	//Nothing
}	

try {
	var Stock1		= '<input type="hidden" name="STCKS_ID#DWCNT#" value="-1"><input type="hidden" name="STCKS_LineID#DWCNT#" value="#DWCNT#"><input type="text" maxlength="25" name="STCKS_Text#DWCNT#" value="" size="20">';
	var Stock2		= '<input type="text" maxlength="25" name="STCKS_Rate#DWCNT#" value="0" size="6">';
	var Stock3		= '<select name="STCKS_Definition#DWCNT#"><option value="<="><=</option><option value=">=">>=</option></select>';
	var Stock4		= '<input type="text" maxlength="255" name="STCKS_DelvTxt#DWCNT#" value="" size="20">';
	var Stock5		= '<input type="text" maxlength="255" name="STCKS_DelvValue#DWCNT#" value="" size="6">';
	var Stock6 = '<input type="text" maxlength="255" name="STCKS_Icon#DWCNT#" value="" size="25"> <img src="/Admin/Images/Browse.gif" onClick="browseFullPath(\'STCKS_Icon#DWCNT#\', \'\', document.all.STCKS_Icon#DWCNT#.value);" align=absMiddle class=H>';
} catch(e) {
	//Nothing
}	

try {
	var Price1		= '<input type=hidden name=PRICE_CurrencyID#DWCNT# value='+ CurrencyID +'><input type=hidden name="PRICE_ID#DWCNT#" value"-1"><input type=hidden name="PRICE_LineID#DWCNT#" value="#DWCNT#"><input type=text maxlength=25 name="PRICE_Quantity#DWCNT#" value="0" size=3>';
	var Price2		= '<input type=text maxlength=25 name="PRICE_PriceAmout#DWCNT#" value="'+ ZeroAmount +'" size=6 style="text-align: right;"> '+ CurrencySymbol;
	if (priceExtended) {
		var Price3		= '<input type=text maxlength=25 name="PRICE_PeriodAmout#DWCNT#" value="'+ ZeroAmount +'" size=6 style="text-align: right;"> '+ CurrencySymbol;
		var Price4		= '<input type=hidden name="PRICE_PeriodID#DWCNT#" value=""><input type=text maxlength=255 name="PRICE_Period#DWCNT#" value="" size=20>&nbsp;<a href=javascript:SelectPriceSelectors("Price_PeriodSelect","#DWCNT#");><img src=/Admin/Images/Browse.gif border=0></a>';
		var Price5		= '<input type=hidden name="PRICE_VariantID#DWCNT#" value=""><input type=text maxlength=255 name="PRICE_Variant#DWCNT#" value="" size=20>&nbsp;<a href=javascript:SelectPriceSelectors("Price_VariantSelect","#DWCNT#");><img src=/Admin/Images/Browse.gif border=0></a>';
		
	}	
	var Price7		= '<a href=javascript:DeleteDWRowSimple("#DWCNT#","_C_");><img src=../images/delete_small.gif align=absmiddle name=delDWRow border=0></a>';
} catch(e) {
	//Nothing
}	
		
		
try {
	var Detail1		= '<input type=hidden name="DETAIL_IDTYPE[0]#DWCNT#" value="0;#DWCNT#"><input type="hidden" name="DETAIL_ID[0]#DWCNT#" value="-1"><input type=hidden name=DETAIL_LineID[0]#DWCNT# value=#DWCNT#><input type=hidden name=DETAIL_Type[0]#DWCNT# value=0><input type=hidden name=Link_DETAIL_Value[0]#DWCNT#><input type="text" maxlength="255" name="DETAIL_Value[0]#DWCNT#" id="DETAIL_Value[0]#DWCNT#" value="" style="width:96%">&nbsp;<img src="/Admin/Images/Browse.gif" onClick=browseDetailArchive(0,#DWCNT#); align=absMiddle class=H>&nbsp;<img src=/Admin/Images/Icons/Page_int.gif onClick=internal(0,"","DETAIL_Value[0]#DWCNT#",""); align=absMiddle class=H>';
	var Detail2		= '<input type=hidden name="DETAIL_IDTYPE[1]#DWCNT#" value="1;#DWCNT#"><input type="hidden" name="DETAIL_ID[1]#DWCNT#" value="-1"><input type=hidden name=DETAIL_LineID[1]#DWCNT# value=#DWCNT#><input type=hidden name=DETAIL_Type[1]#DWCNT# value=1><textarea name="DETAIL_Value[1]#DWCNT#" cols="100" rows="10" style="width:100%"></textarea>';
} catch(e) {
	//Nothing
}		
		
function AddDWRowLine(typeStr) {
	AddDWRowLine(typeStr, "");
}

function AddDWRowLine(typeStr, prefix) {
	if (typeStr == "PAY" || typeStr == "SHIP" || typeStr == "VARIANT" || typeStr == "STOCK") {
		ActivateTabClick('Tab2');
	}
	if (enableClick) {

		var NextFindIDStr = "#DWCNT#";

		var oRow;
		var oCell;
		var cellLength;
		var nextRow;
		var linesCnt;
		var NextID;
		var elemRow;

		if (prefix == "") {
			nextRow		= document.getElementById('Form1').DWRowNextLine;
			linesCnt	= document.getElementById('Form1').DWRowNextLine.value;
			elemRow		= "DWRowLineTable";
		} else {
			nextRow		= eval('document.getElementById(\'Form1\').DWRowNextLine'+ prefix);
			linesCnt	= nextRow.value;
			elemRow		= "DWRowLineTable"+ prefix +"";
		}

		NextID = parseInt(linesCnt);

		try {
			oRow = document.getElementById(elemRow).insertRow(NextID);
			oRow.className = "OutlookItem";
			oRow.id = "DWRowLineTR"+ prefix + NextID;
			oRow.style.height = '25px';
		} catch(e) {
		    alert(e);
			//Nothing
		}		
		
		if (typeStr == "PAY") {	
			RemoveNoneline("DWRowNoFeeLine");
			
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(FeePay1,NextFindIDStr,NextID);
			
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(FeePay2,NextFindIDStr,NextID);
			
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.align = "right";
			oCell.innerHTML = '&nbsp;';
		}		

		if (typeStr == "SHIP") {	
			RemoveNoneline("DWRowNoFeeLine");
		
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(FeePay1,NextFindIDStr,NextID);
			
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(FeePay2,NextFindIDStr,NextID);

			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(FeePay3,NextFindIDStr,NextID);

			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(FeePay4,NextFindIDStr,NextID);
			
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.align = "right";
			oCell.innerHTML = '&nbsp;';
		}		
		
		if (typeStr == "VARIANT") {	
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(Variant1,NextFindIDStr,NextID);
			
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.align = "right";
			oCell.innerHTML = '&nbsp;';
		}			

		if (typeStr == "STOCK") {	
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(Stock3,NextFindIDStr,NextID);

			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(Stock2,NextFindIDStr,NextID);
			
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(Stock1,NextFindIDStr,NextID);

			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(Stock4,NextFindIDStr,NextID);

			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(Stock5,NextFindIDStr,NextID);

			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.nowrap = true;
			oCell.innerHTML = replaceSubstring(Stock6,NextFindIDStr,NextID);

			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.align = "right";
			oCell.innerHTML = '&nbsp;';
		}			

		if (typeStr == "PRICE") {
			RemoveNoneline("DWRowNoPriceLine");
			
			try {			
				cellLength = oRow.cells.length;
				oCell = oRow.insertCell(cellLength);
				oCell.innerHTML = replaceSubstring(Price1,NextFindIDStr,NextID);

				cellLength = oRow.cells.length;
				oCell = oRow.insertCell(cellLength);
				oCell.innerHTML = replaceSubstring(Price2,NextFindIDStr,NextID);
				
				if (priceExtended) {
					cellLength = oRow.cells.length;
					oCell = oRow.insertCell(cellLength);
					oCell.innerHTML = replaceSubstring(Price3,NextFindIDStr,NextID);

					cellLength = oRow.cells.length;
					oCell = oRow.insertCell(cellLength);
					oCell.innerHTML = replaceSubstring(Price4,NextFindIDStr,NextID);

					cellLength = oRow.cells.length;
					oCell = oRow.insertCell(cellLength);
					oCell.innerHTML = replaceSubstring(Price5,NextFindIDStr,NextID);

					if (useUnit) {
						cellLength = oRow.cells.length;
						oCell = oRow.insertCell(cellLength);
						oCell.innerHTML = replaceSubstring(Price6,NextFindIDStr,NextID);
					}
				}


				cellLength = oRow.cells.length;
				oCell = oRow.insertCell(cellLength);
				oCell.align = "right";
				oCell.innerHTML = replaceSubstring(Price7,NextFindIDStr,NextID);
			} catch(e) {
				//Nothing
			}		
		}
		
		if (typeStr == "DETAILURL") {
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(Detail1,NextFindIDStr,NextID);
            
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.align = "right";
			oCell.innerHTML = '&nbsp;';			
		}	
		
		if (typeStr == "DETAILTXT") {
			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.innerHTML = replaceSubstring(Detail2,NextFindIDStr,NextID);

			cellLength = oRow.cells.length;
			oCell = oRow.insertCell(cellLength);
			oCell.align = "right";
			oCell.innerHTML = '&nbsp;';			
		}			
		
		nextRow.value = NextID + 1;
	}	
}

function RemoveNoneline(lineID) {
	try {			
		document.getElementById(''+ lineID).style.display = 'none';
	} catch(e) {
		//Nothing
	}
}
function DeleteDWRowSimple(rowID, prefix) {
	var Message = "Slet?";
	if (confirm (Message)) {
		DeleteTR("DWRowLineTable", "DWRowLineTR", rowID, prefix, "");

		var nextRow = eval('document.getElementById(\'Form1\').DWRowNextLine'+ prefix);
		nextRow.value = parseInt(nextRow.value) - 1;
	}
}	

var showMessage = true;
function DeleteDWRow(DWRowid, rowID, typeStr, methodID, prefix, arg1, arg2, message) {
	var deleteRow = false;
	
	if (!message || message == '')
	    message = 'Slet?';
	
	
	if (showMessage) {
	    if (confirm(message)) {
		    deleteRow = true;
	    }
	} else {
	    deleteRow = true;
	}    

	if (deleteRow) {

		if (typeStr != "PRODPRICECALC" && typeStr != "PRODITEM" && typeStr != "VARIANT") {
			DeleteTR("DWRowLineTable", "DWRowLineTR", rowID, prefix, "");
		}	
	
		var nextRow = eval('document.getElementById(\'Form1\').DWRowNextLine'+ prefix);
		nextRow.value = parseInt(nextRow.value) - 1;
			
		if (typeStr == "PAY") {
			EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DeletePayFee&typeID="+ methodID +"&ID="+ DWRowid;
		}
		if (typeStr == "SHIP") {
			EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DeleteShipFee&typeID="+ methodID +"&ID="+ DWRowid;
		}	
		if (typeStr == "VARIANT") {
			EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DeleteVariant&ID="+ DWRowid;
		}	
		if (typeStr == "STOCK") {
			EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DeleteStock&ID="+ DWRowid;
			location.reload();
		}	
		if (typeStr == "GROUPREL") {
			EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DeleteGroupRel&ID="+ methodID +"&parentID="+ DWRowid;
		}	
		if (typeStr == "PRODREL") {
			EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DeleteProdRelated&ID="+ methodID +"&relID="+ DWRowid +"&RelGrpID="+ arg1;
		}	

		if (typeStr == "PRODPRICECALC") {
			DeleteTR("DWRowLineTable", "DWRowLineTR_CALC", rowID, prefix, "_"+ arg2);
			EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DeleteProdPrice&ID="+ methodID +"&priceID="+ DWRowid +"&currID="+ arg1;
		}	

		if (typeStr == "DETAIL") {
			EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DeleteProdDetail&ID="+ DWRowid +"&prodID="+ methodID +"&varID="+ arg1;
		}

		if (typeStr == "PRODITEM") {
			FillDivLayer("LOADING", "", "PRODITEM");
			EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DelProductItem&ID="+ DWRowid +"&typeID="+ arg1 +"&itemID="+ methodID;
		}
    }   

    return deleteRow;
}

function DeleteTR(tableObj, rowName, rowID, prefix, loopStr) {
	var tableName = tableObj +""+ prefix;
	var objRow = rowName +""+ prefix + rowID + ""+ loopStr;
	
	try {
		var objIndex = document.getElementById(objRow).rowIndex;
		document.getElementById(tableName).deleteRow(objIndex);
	} catch(e) {
		//Nothing
	}
}

function gotoUrl(url) {
    EcomUpdator.document.location.href = url;
}


function AddDWRowFromArry(typeStr, masterID, contentArray, root, arg1, arg2) {
	if (typeStr == "CLEAR") {
		EcomUpdator.document.location.href = root + "EcomUpdator.aspx";
	}		
	if (typeStr == "GROUPS") {
		EcomUpdator.document.location.href = root + "EcomUpdator.aspx?CMD=AddGroupRel&ID="+ masterID + "&GroupID="+ arg1 +"&grpArr="+ contentArray;
	}		
	if (typeStr == "PRODGROUPS") {
    	setTimeout("gotoUrl('" + root + "EcomUpdator.aspx?CMD=AddProdGroupRel&ID="+ masterID + "&grpArr="+ contentArray +"');", 500);
		//EcomUpdator.document.location.href = root + "EcomUpdator.aspx?CMD=AddProdGroupRel&ID="+ masterID + "&grpArr="+ contentArray;
	}	

	if (typeStr == "PRODACTIVEUNITS") {
		EcomUpdator.document.location.href = root + "EcomUpdator.aspx?CMD=AddDelProductUnits&ID="+ masterID + "&grpArr="+ contentArray + "&typeID="+ arg1;
	}		
}



function ActivateTabClick(tabId) {
	try {
		var tabElement = document.getElementById(tabId +"_head");
		TabClick(tabElement)
	} catch(e) {
		//Nothing
	}			
}

var isDefaultLang = true;
function productEnableButtons() {
	enableAddButton("Tab3Div", "addDetailBut");
	if (isDefaultLang) {
    	enableAddButton("Tab4Div", "addPropertyBut");
	    enableAddButton("Tab5Div", "transferGroupSelect");
	    enableAddButton("Tab7Div", "addVariantGrpBut");
	    enableAddButton("Tab8Div", "addRelatedBut");
    	enableAddButton("Tab11Div", "addProductItemBut");	
    }	    
}

function enableAddDWRow() {
    enableAddButton("Tab3Div", "groupsEditOrderLineField");
    enableAddButton("Tab2Div", "addDWRowBut");
}


function enableAddButton(divName, buttonName) {
    allDivs = document.getElementsByTagName("DIV")
    for (a=0; a < allDivs.length; a++) {
	    if (allDivs[a].className == divName) {
		    if (allDivs[a].style.display == "none") {
			    document.getElementById(buttonName).style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30);progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);-moz-opacity: 0.4;";
			    document.getElementById(buttonName).removeAttribute("href");
			    document.getElementById(buttonName).style.cursor = "";
			    enableClick = false;
			    setBooleanValue(buttonName, false)
		    } else {
			    document.getElementById(buttonName).style.filter = "";
			    document.getElementById(buttonName).style.cursor = "hand";
			    enableClick = true;
			    setBooleanValue(buttonName, true)
		    }
	    }
    }	
}

function setBooleanValue(ButName, value) {
	if (ButName == "transferGroupSelect") {
		prodGroupAdd = value;
	}	
	if (ButName == "addRelatedBut") {
		prodRelatedAdd = value;
	}	
	if (ButName == "addVariantGrpBut") {
		prodVariantGrpAdd = value;
	}	
	if (ButName == "addDetailBut") {
		prodDetailAdd = value;
	}	
	if (ButName == "addPropertyBut") {
		prodPropertyAdd = value;
	}
	if (ButName == "addProductItemBut") {
		prodProdItemAdd = value;
	}	
}
