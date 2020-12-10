
		var xhttp = false;
		var parameterdivname = '';
		var addInParameters_onLoaded = null;
		
		function getXHTTPObject() {     
			if (window.ActiveXObject) {  
                try {  
					// IE 6 and higher 
					xhttp = new ActiveXObject("MSXML2.XMLHTTP"); 
					xhttp.onreadystatechange=getParameters_callback; 
                } catch (e) { 
                    try { 
                        // IE 5 
                        xhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
						xhttp.onreadystatechange=getParameters_callback; 
                    } catch (e) { 
                        xhttp=false; 
                    } 
                } 
			} 
            else if (window.XMLHttpRequest) { 
                try { 
                    // Mozilla, Opera, Safari ... 
                    xhttp = new XMLHttpRequest();
                    /* little hack */
                    xhttp.onreadystatechange = function () {
						getParameters_callback();
					};

                } catch (e) { 
                    xhttp=false;
                } 
            } 
        }
		
		function getParameters(discounttype,group) {
			/* we need a xhttp-object */
			getXHTTPObject();
			
			/* is xhttp-object ok? */
			if (!xhttp) { 
                return; // exit 
            }
            var groupString="";
            if (group)
                groupString = "&group=" + group;
			/* lets get data */
            xhttp.open("GET", "/Admin/Module/eCom_Catalog/Edit/EcomConfigurableAddin_GetParameters.aspx?type=" + discounttype + groupString + "&ts=" + Date.now(), true);
			xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            xhttp.send(null);
		}
		
		function getAjaxPage(url) {
			/* we need a xhttp-object */
			getXHTTPObject();
			
			/* is xhttp-object ok? */
			if (!xhttp) { 
                return; // exit 
            } 
			
			/* lets get data */
			xhttp.open("GET", url, false);
			xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            xhttp.send(null);
            return xhttp.responseText;
		}
		
		function getParameters_callback() {
			/* get the div */
			/*alert(xhttp.readyState);*/
		                 
            if (xhttp.readyState == 4) {
				var parameterdiv = document.getElementById(parameterdivname);
				var execScriptsAttribute = parameterdiv.attributes["data-exec-scripts-gs"];
				var execScriptsInGlobalScope = execScriptsAttribute ? execScriptsAttribute.value == "true" : false;

				if(xhttp.status==200) {
					/* set final outcome */
					try {
						//alert('got outcome : \n'+ xhttp.responseText);
						parameterdiv.innerHTML = xhttp.responseText;
						execScripts(parameterdiv.innerHTML, execScriptsInGlobalScope);
					}
					catch(e) {
						//alert('exception' + e);
						/*parameterdiv.innerHTML = "Error in AJAX" + e.Message;*/
					}
					
					if(addInParameters_onLoaded != null && typeof(addInParameters_onLoaded) == 'function') {
					    try {
					        addInParameters_onLoaded();
					    } catch(ex) {}
					}
				}
				else {
					parameterdiv.innerHTML = "Error in AJAX ("+ xhttp.status +")";		
				}
            }
           /* else {
				/* set value* /
				parameterdiv.innerHTML = xhttp.readyState 
            }*/
		}
		
		function updateParametersBySenderId(senderId, divname) {
			var sender = document.getElementById(senderId);
			updateParameters(sender, divname);

        }
		function updateParametersBySenderIdAndGroup(senderId, divname,group) {
		    var sender = document.getElementById(senderId);
		    updateParametersInGroup(sender, divname,group);
		}
		function GetLoader(loaderdivname) {
			var loader = document.getElementById(loaderdivname);
			
			if(loader != null && loader.innerHTML != "") {
				return loader.innerHTML;
			} else {
				//return "retrieving new parameters...";
				return "";
			}			
		}
		
		function GetNoParameters(nonedivname) {
			var none = document.getElementById(nonedivname);
			if (none != null && none.innerHTML != "") {
				return none.innerHTML;
			} else {
				return "no parameters";
			}			
		}

		function updateParameters(sender, divname) {
       
		    updateParametersInGroup(sender, divname, "")

		}

		function updateParametersInGroup(sender, divname, group) {
		    parameterdivname = divname;
		    var parameterdiv = document.getElementById(divname);

		    /* get discounttype */
		    var selected = sender.options[sender.selectedIndex];

		    if (selected.value.length > 0) {
		        parameterdiv.innerHTML = GetLoader(divname + '_loader');
		        /* lets get the parameters */
		        /*parameterdiv.innerHTML = getParameters(selected.value);*/
		        getParameters(selected.value,group);
		    }
		    else {
		        /* we have no parameters */
		        parameterdiv.innerHTML = GetNoParameters(divname + '_none');
		    }
		}
		
		function execScripts(resText, execScriptsInGlobalScope) {
            var si = 0;
            while (true) {
                var ss = resText.toLowerCase().indexOf("<" + "script" + ">", si);
                if (ss == -1) {
                    //alert(resText.toLowerCase().indexOf("<" + "script" + ">", si));
                    return;
                }
                var se = resText.toLowerCase().indexOf("<" + "/" + "script" + ">", ss);
                if (se == -1) {
                  //  alert(resText.toLowerCase().indexOf("<" + "/" + "script" + ">", ss));
                    return;
                }
                si = se + 9;
				var sc = resText.substring(ss + 8, se);
				if (execScriptsInGlobalScope) {
					eval.call(window, sc);
				} else {
					eval(sc);
				}
            }
        }


		function getProductGroupsForParagraph(paragraphId, pageId, groupFetch) {
			/* we need a xhttp-object */
			getXHTTPObject();
			
			/* is xhttp-object ok? */
			if (!xhttp) { 
                return; // exit 
            } 
			
			/* lets get data */
			var returnUrl = "/Admin/Module/eCom_Catalog/Edit/EcomUpdator.aspx?CMD=AddParagraphEditGroups&ID="+ paragraphId +"&PageID="+ pageId +"&grpArr="+ groupFetch;
			xhttp.onreadystatechange = function() {
			    getProductGroupsForParagraph_callback();
			};
            xhttp.open("GET",returnUrl,true);
			xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            xhttp.send(null);
		}
		
        function getProductGroupsForParagraph_callback() {
            if (xhttp.readyState == 4) {
				var GroupListDiv = document.getElementById("GroupListLayer");
				if(xhttp.status==200) {
					try {
						GroupListDiv.innerHTML = xhttp.responseText
						//execScripts(GroupListDiv.innerHTML);
					}
					catch(e) {
						//alert(e);
					}
				}
				else {
					//GroupListDiv.innerHTML = "Error in AJAX [" + xhttp.status + "]";				
				}
            }
		}		
		
		
        function getProductGroupsForSearchv1(paragraphId, pageId, groupFetch) {
			/* we need a xhttp-object */
			getXHTTPObject();
			
			/* is xhttp-object ok? */
			if (!xhttp) { 
                return; // exit 
            } 
            
			/* lets get data */
			var returnUrl = "/Admin/Module/eCom_Catalog/Edit/EcomUpdator.aspx?CMD=AddParagraphEditGroupsSearchv1&ID="+ paragraphId +"&PageID="+ pageId +"&grpArr="+ groupFetch;
            xhttp.onreadystatechange = function () {
				getProductGroupsForSearchv1_callback();
			};
            xhttp.open("GET",returnUrl,false);
			xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            xhttp.send(null);
		}		
		
        function getProductGroupsForSearchv1_callback() {
            if (xhttp.readyState == 4) {
				var GroupListDiv = document.getElementById("GroupListLayer");
				//alert(GroupListDiv.innerHTML);
				if(xhttp.status==200) {
					try {
					    //alert(xhttp.responseText);
						GroupListDiv.innerHTML = xhttp.responseText;
						//execScripts(GroupListDiv.innerHTML);
					}
					catch(e) {
						//alert(e);
					}
				}
				else {
					//GroupListDiv.innerHTML = "Error in AJAX [" + xhttp.status + "]";				
				}
            }
		}			
		
		function getProductGroupsForEditor(Id, groupFetch) {
			/* we need a xhttp-object */
			getXHTTPObject();
			
			/* is xhttp-object ok? */
			if (!xhttp) { 
                return; // exit 
            } 
			
			/* lets get data */
			var returnUrl = "/Admin/Module/eCom_Catalog/dw7/edit/EcomUpdator.aspx?CMD=AddGroupsToEditor&ID="+ Id +"&grpArr="+ groupFetch;
            xhttp.onreadystatechange = function () {
				getProductGroupsForEditor_callback(Id);
			};
            xhttp.open("GET",returnUrl,false);
			xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            xhttp.send(null);
            
		}
		
        function getProductGroupsForEditor_callback(Id) {
            if (xhttp.readyState == 4) {
				var GroupListDiv = document.getElementById("GroupListLayer"+ Id);
				if(xhttp.status==200) {
					try {
						GroupListDiv.innerHTML = xhttp.responseText
						ProductMultiGroupsApply(Id);
					}
					catch(e) {
						//alert(e);
					}
				}
				else {
					//GroupListDiv.innerHTML = "Error in AJAX [" + xhttp.status + "]";				
				}
            }
		}			
		
		function getRoundingResult(roundingId, roundingValue) {
			/* we need a xhttp-object */
			getXHTTPObject();
			
			/* is xhttp-object ok? */
			if (!xhttp) { 
                return; // exit 
            } 
			
			/* lets get data */
            var returnUrl = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=GetRoundingResult&ID=" + roundingId + "&Value=" + roundingValue;
            xhttp.onreadystatechange = function () {
				getRoundingResult_callback();
			};
            xhttp.open("GET",returnUrl,false);
			xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            xhttp.send(null);
		}		
		
		function getRoundingResult_callback() {
            if (xhttp.readyState == 4) {
				var ResultField = document.getElementById("TestResult");
				if(xhttp.status==200) {
					try {
						ResultField.value = xhttp.responseText
                        var button = document.getElementById("roundButton");
		                if (button) {
		                    button.disabled = false;
		                }						
						//execScripts(GroupListDiv.innerHTML);
					}
					catch(e) {
						//alert(e);
					}
				}
				else {
					//GroupListDiv.innerHTML = "Error in AJAX [" + xhttp.status + "]";				
				}
            }
		}
		
		function getFeeRowResult(methodType, methodId, methodCountryId, newRowCnt, newFeeCnt) {
			/* we need a xhttp-object */
			getXHTTPObject();
			
			/* is xhttp-object ok? */
			if (!xhttp) { 
                return; // exit 
            } 
			
			/* lets get data */
            var returnUrl = "/Admin/Module/eCom_Catalog/Edit/EcomUpdator.aspx?CMD=GetNewFeeLine&FeeCnt=" + newFeeCnt + "&RowCnt=" + newRowCnt + "&methodId=" + methodId + "&methodType=" + methodType + "&countryId=" + methodCountryId;
            xhttp.onreadystatechange = function () {
				getFeeRowResult_callback(methodCountryId);
			};
            xhttp.open("GET",returnUrl,true);
			xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
			xhttp.send(null);
		}
		
		function getFeeRowResult_callback(methodCountryId) {
            if (xhttp.readyState == 4) {
				if(xhttp.status==200) {

					try {
					    var NoFee = document.getElementById("FEE_NOROWS"+ methodCountryId);
					    NoFee.style.display = "none";
					} catch(e) {
						//alert(e);
					}

					try {
					    var FeeTable = document.getElementById("FEE_NEWTABLE"+ methodCountryId);
					    FeeTable.innerHTML += xhttp.responseText;
					} catch(e) {
						//alert(e);
					}				
					
					try {
                        var rowCnt = document.getElementById("FEE_ROWCOUNTER"+ methodCountryId)
                        var feeCnt = document.getElementById("FEE_LINECOUNTER"+ methodCountryId)
                        rowCnt.value = parseInt(rowCnt.value) + 1;
                        feeCnt.value = parseInt(feeCnt.value) + 1;                        
					} catch(e) {
						//alert(e);
					}
				} else {
				    //alert("Error in AJAX [" + xhttp.status + "]");
				}
            }
		}	
		
		function deleteFeeRowInDB(feeId, divId) {
			/* we need a xhttp-object */
			getXHTTPObject();
			
			/* is xhttp-object ok? */
			if (!xhttp) { 
                return; // exit 
            } 
			
			/* lets get data */
			var returnUrl = "/Admin/Module/eCom_Catalog/Edit/EcomUpdator.aspx?CMD=DeleteFeeLine&FeeID="+ feeId;
            xhttp.onreadystatechange = function () {
				deleteFeeRowInDB_callback(divId);
			};
            xhttp.open("GET",returnUrl,false);
			xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            xhttp.send(null);            
		}			
		
		function deleteFeeRowInDB_callback(divId) {
            if (xhttp.readyState == 4) {
				if(xhttp.status==200) {
					try {
                        var div = document.getElementById("FEE_ROWTABLE"+divId);
                        if (div) {
                            var parent = div.parentNode;
                            parent.removeChild(div);
                        }					    
					} catch(e) {
						//alert(e);
					}
				} else {
				    //alert("Error in AJAX [" + xhttp.status + "]");
				}
            }
		}				