function doGenerelRollerMenu(divNum) {
	doGenerelRollerMenu(divNum,0,0);
}

function doGenerelRollerMenu(divNum, divX, divY) {
	closeAllRollerMenu();

	if (divNum == 'LanguagerLayer') {
		try {
			submitTabID()
		} catch (e) {
			//Nothing
		}		
		
		x = 1;
		y = 20;
	}	
	
	if (divNum == 'CountryLayer') {
		x = 205;
		y = 60;
	}



	if (divNum == 'DetailLayer') {
		if (prodDetailAdd) {
			x = 323;
			y = 60;
		} else {
			x = 0;
			y = 0;
		}	
	}

	if (divNum == 'PropertyLayer') {
		if (prodPropertyAdd) {
			x = 382;
			y = 60;
		} else {
			x = 0;
			y = 0;
		}	
	}

	if (divNum == 'VariantGroupLayer') {
	    ActivateTabClick('Tab7');
	    if (prodVariantGrpAdd) {
	        x = 493
	        y = 60;
	    } else {
	        x = 0;
	        y = 0;
	    }
	}

	if (divNum == 'OrderLineFieldLayer') {
	    ActivateTabClick('Tab3');
	    if (true) {
	        x = 280
	        y = 60;
	    } else {
	        x = 0;
	        y = 0;
	    }
	}

	if (divNum == 'RelatedLayer') {
		ActivateTabClick('Tab8');
		if (prodRelatedAdd) {
			x = 554;
			y = 60;
		} else {
			x = 0;
			y = 0;
		}	
	}


	if (divNum == 'ProdItemLayer') {
		ActivateTabClick('Tab11');	
		if (prodProdItemAdd) {
			x = 615;
			y = 60;
		} else {
			x = 0;
			y = 0;
		}	
	}
	
	if (divNum == 'statViews') {
		x = 6;
		y = 60;
	}		
       	
	if (x != 0) {
		var tmpDiv = eval(divNum);
		/*var tmpDiv = document.getElementById(divNum);*/
		if (tmpDiv != null) {
			tmpDiv.style.display = "none";

			tmpDiv.style.pixelLeft = x; 
			tmpDiv.style.pixelTop = y; 	

			tmpDiv.style.left = x + "px";
            		tmpDiv.style.top = y + "px";	
				
			if(tmpDiv.style.display == "block") { 
				tmpDiv.style.display = "none";
			} else {
				tmpDiv.style.display = "block";
			}	
		}	
	}	
}

function closeAllRollerMenu() {
	try {
		closeRollerMenu('LanguagerLayer');
		closeRollerMenu('CountryLayer');
		closeRollerMenu('VariantGroupLayer');
		closeRollerMenu('RelatedLayer');
		closeRollerMenu('DetailLayer');
		closeRollerMenu('PropertyLayer');
		closeRollerMenu('ProdItemLayer');

		closeRollerMenu('OrderLineFieldLayer');
	} catch (e) {
		//Nothing
	}
}

function closeAllRollerMenuWait(timeInt) {
	try {
		setTimeout('closeAllRollerMenu()', "+ parseInt(timeInt) +")
	} catch (e) {
		//Nothing
	}
}	

function closeRollerMenu(divNum) {
	try {
		/*var tmpDiv = eval(divNum);*/
		var tmpDiv = document.getElementById(divNum);
		if (tmpDiv != null) {
			tmpDiv.style.display = "none";
		}	
	} catch (e) {
		//Nothing
	}
}	

function mouseoutBox(element) {
	element.cells.item(1).style.paddingLeft		= '5px';
	element.cells.item(0).style.width			= '20px';
	element.cells.item(0).style.height			= '20px';
	element.style.backgroundColor				= '#FFFFFF';
	element.style.border						= 'none';
	element.cells.item(0).style.backgroundColor = '#D4D0C8';
}

function mouseoverBox(element, pix) {
    if (pix)
	    element.style.width						= pix+'px';
	element.cells.item(1).style.paddingLeft		= '5px';
	element.cells.item(0).style.width			= '19px';
	element.cells.item(0).style.height			= '18px';
	element.style.backgroundColor				= '#C1D2EE';
	element.style.border						= 'solid 1px #316AC5';
	element.cells.item(0).style.backgroundColor = '#99B7E3';
}

function dropdownHover(element){
	element.className = "DropDownButton_hover";
	element.cells[0].style.width = "1px";
	element.cells[2].style.width = "1px";
}

function dropdownNormal(element){
	element.className = "DropDownButton";
	element.cells[0].style.width = "2px";
	element.cells[2].style.width = "2px";
}

function GetFileNameFromUrl(url) {
	var sbq = url.split("?");
	var sbs = sbq[0].split("/");
	return sbs[sbs.length-1];
}

function GetQueryFromUrl(url) {
	if (url.indexOf("?") == -1) return "";
	
	var sbq = url.split("?");
	return sbq[sbq.length-1];
}

function GetLangIDFromQs(qs) {
	var res = "";
	lpos = qs.indexOf("selectedLangID");
	
	if (lpos == -1) return qs;

	qs2 = qs.substring(lpos,qs.length);
	lpos2 = qs2.indexOf("&");
	if (lpos2 == -1) {
		res = qs.substring(0,lpos-1)
	} else {
		res = qs.substring(0,lpos) + qs.substring(lpos+lpos2+1,qs.length);
	}
	return res;
}

function GetTabIDFromQs(qs) {
	var res = "";
	lpos = qs.indexOf("Tab");
	
	if (lpos == -1) return qs;

	qs2 = qs.substring(lpos,qs.length);
	lpos2 = qs2.indexOf("&");
	if (lpos2 == -1) {
		res = qs.substring(0,lpos-1)
	} else {
		res = qs.substring(0,lpos) + qs.substring(lpos+lpos2+1,qs.length);
	}
	return res;
}

function RemoveTabIDFromUrl(url) {
	var res = "";
	lpos = url.indexOf("Tab");
	
	if (lpos == -1) return url;

	var url2 = url.substring(lpos,url.length);
	lpos2 = url2.indexOf("&");
	if (lpos2 == -1) {
		res = url.substring(0,lpos-1)
	} else {
		res = url.substring(0,lpos) + url.substring(lpos+lpos2+1,url.length);
	}
	return res;
}


function RemoveSearchFieldFromURL(url) {
	var res = "";
	lpos = url.indexOf("searchField");
	if (lpos == -1) return url;

	var url2 = url.substring(lpos,url.length);
	lpos2 = url2.indexOf("&");
	if (lpos2 == -1) {
		res = url.substring(0,lpos-1)
	} else {
		res = url.substring(0,lpos) + url.substring(lpos+lpos2+1,url.length);
	}
	return res;
}

function selectLang(langID) {
	var sepr = '&';
	var oldURL = GetFileNameFromUrl(location.href);
	var newURL = "";
	var qsURL = GetQueryFromUrl(location.href);
	var qsURL2 = GetLangIDFromQs(qsURL);
	
	oldURL = ""+ oldURL.toLowerCase();
	newURL = oldURL +"?selectedLangID="+ langID;

    if (document.getElementById("searchFieldTmp")) {
        var searchField = document.getElementById("searchFieldTmp").value
	    if (searchField != "") {

	        qsURL2 = RemoveSearchFieldFromURL(qsURL2);
		    newURL += "&searchField="+ searchField;
	    }
    }		

	if (qsURL2 != "") {
		newURL += "&"+ qsURL2;
	}

	try	{
		var tabID = document.getElementById('Form1').Tab.value;
		if (tabID != "") {
			tabID = replaceSubstring(tabID, "Tab", "");
		
			newURL = RemoveTabIDFromUrl(newURL);
			newURL += "&Tab="+ tabID;
		}
	} catch(e) {
		//Nothing
	}		
	
	if (langID != "") {
		//alert(newURL);
		location.href = newURL;
	}
}


function selectCountry(countryID) {
	closeRollerMenu('CountryLayer');

	if (countryID == "-1") {
		parent.DW_Ecom_Main.location.href = "../Edit/EcomCountry_Edit.aspx?addAll=yes";
	} else {
		parent.DW_Ecom_Main.location.href = "../Edit/EcomCountry_Edit.aspx?autocreate="+ countryID;
	}
}		