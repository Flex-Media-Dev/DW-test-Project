
var addInParameters_onLoaded = null;

function getXHTTPObject(divname) {
    var xhttp = false;

    if (window.ActiveXObject) {
        try {
            // IE 6 and higher 
            xhttp = new ActiveXObject("MSXML2.XMLHTTP");
            xhttp.onreadystatechange = function () {
                getParameters_callback(xhttp, divname);
            };
        } catch (e) {
            try {
                // IE 5 
                xhttp = new ActiveXObject("Microsoft.XMLHTTP");
                xhttp.onreadystatechange = function () {
                    getParameters_callback(xhttp, divname);
                };
            } catch (e) {
                xhttp = false;
            }
        }
    }
    else if (window.XMLHttpRequest) {
        try {
            // Mozilla, Opera, Safari ... 
            xhttp = new XMLHttpRequest();
            /* little hack */
            xhttp.onreadystatechange = function () {
                getParameters_callback(xhttp, divname);
            };

        } catch (e) {
            xhttp = false;
        }
    }

    return xhttp;
}

function getParameters(discounttype, group, id, divname, pageId, values) {
    /* we need a xhttp-object */
    var xhttp = getXHTTPObject(divname);

    /* is xhttp-object ok? */
    if (!xhttp) {
        return; // exit 
    }

    /* lets get data */
    var params = "";
    if (group) params = "&group=" + group;
    if (pageId) params += "&pageId=" + pageId;
    if (values) params += "&values=" + values;

    xhttp.open("GET", "/Admin/Module/eCom_Catalog/dw7/Edit/EcomConfigurableAddin_GetParameters.aspx?type=" + discounttype + "&id=" + id + params + "&ts=" + Date.now(), true);
    xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    xhttp.send(null);
}

function getAjaxPage(url) {
    /* we need a xhttp-object */
    var xhttp = getXHTTPObject();

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

function getParameters_callback(xhttp, divname) {
    /* get the div */
    /*alert(xhttp.readyState);*/

    if (xhttp.readyState == 4) {
        var parameterdiv = document.getElementById(divname);
        var execScriptsAttribute = parameterdiv.attributes["data-exec-scripts-gs"];
        var execScriptsInGlobalScope = execScriptsAttribute ? execScriptsAttribute.value == "true" : false;

        if (xhttp.status == 200) {
            /* set final outcome */
            try {
                //alert('got outcome : \n'+ xhttp.responseText);
                parameterdiv.innerHTML = xhttp.responseText;
                if (!((typeof onAfterUpdateSelection) == 'undefined'))
                    eval(onAfterUpdateSelection);

                execScripts(parameterdiv.innerHTML, execScriptsInGlobalScope);
            }
            catch (e) {
                //alert('exception' + e);
                /*parameterdiv.innerHTML = "Error in AJAX" + e.Message;*/
            }

            var groupbox = null;
            var parameters = parameterdiv.getElementsByClassName("addInConfigurationTable")[0];
            if (parameters) {
                if (parameterdiv.parentElement.tagName == "DIV" && parameterdiv.parentElement.className.indexOf("groupbox") >= 0) {
                    groupbox = parameterdiv.parentElement;
                } else if (parameterdiv.parentElement.parentElement.tagName == "DIV" && parameterdiv.parentElement.parentElement.className.indexOf("groupbox") >= 0) {
                    groupbox = parameterdiv.parentElement.parentElement;
                }
                if (groupbox && groupbox.style.display == "none") {
                    groupbox.style.display = "block";
                }
            }

            toggleHideParameters(parameters, "hideParameters(");

            if (addInParameters_onLoaded != null && typeof (addInParameters_onLoaded) == 'function') {
                try {
                    addInParameters_onLoaded();
                } catch (ex) { }
            }
        }
        else {
            parameterdiv.innerHTML = "Error in AJAX (" + xhttp.status + ")";
        }

        if (window.jQuery) {
            (function ($) { $('.selectpicker').selectpicker(); })(jQuery);
        }
    }
    /* else {
    /* set value* /
    parameterdiv.innerHTML = xhttp.readyState 
    }*/
}

function updateParametersBySenderId(senderId, divname, id, pageId) {
    var sender = document.getElementById(senderId);
    updateParameters(sender, divname, id, pageId);
}
function updateParametersBySenderIdAndGroup(senderId, divname, group, id) {
    var sender = document.getElementById(senderId);
    updateParametersInGroup(sender, divname, group, id);
}

function GetLoader(loaderdivname) {
    var loader = document.getElementById(loaderdivname);

    if (loader != null && loader.innerHTML != "") {
        return loader.innerHTML;
    } else {
        //return "retrieving new parameters...";
        return "";
    }
}

function refreshParameters() {
    var addInSelector = document.querySelector('select[id$="AddInTypes"]');
    if (!!addInSelector) {
        var parameters = getParametersFromContainer(document);
        var valuesElement = document.getElementById("ConfigurableAddIn_values");
        if (valuesElement && parameters) {
            var values = "";
            for (var key in parameters) {
                if (parameters.hasOwnProperty(key)) {
                    if (values !== "") { values += ";"; }
                    values += key + "::" + parameters[key];
                }
            }

            valuesElement.value = values;
        }

        var e = document.createEvent('HTMLEvents');
        e.initEvent("change", false, true);
        addInSelector.dispatchEvent(e);
    }
}

function updateParameters(sender, divname, id, pageId) {
    var values = document.getElementById('ConfigurableAddIn_values') != null ? document.getElementById('ConfigurableAddIn_values').value : "";
    updateParametersInGroup(sender, divname, "", id, pageId, values);

}

function updateParametersInGroup(sender, divname, group, id, pageId, values) {
    if (typeof (values) === 'undefined') {
        values = document.getElementById('ConfigurableAddIn_values') !== null ? document.getElementById('ConfigurableAddIn_values').value : "";
    }
    if (!((typeof onBeforeUpdateSelection) == 'undefined'))
        eval(onBeforeUpdateSelection);
    var parameterdiv = document.getElementById(divname);

    /* get discounttype */
    var selected = sender.options[sender.selectedIndex];

    if (selected.value.length > 0) {
        parameterdiv.innerHTML = GetLoader(divname + '_loader');
        /* lets get the parameters */
        /*parameterdiv.innerHTML = getParameters(selected.value);*/
        getParameters(selected.value, group, id, divname, pageId, values);
    }
    else {
        /* we have no parameters */


        var none = document.getElementById(divname + '_none');

        if (none != null && none.innerHTML != "") {
            parameterdiv.innerHTML = none.innerHTML;
        } else {
            var groupbox = null;
            if (parameterdiv.parentElement.tagName = "DIV" && parameterdiv.parentElement.className.indexOf("groupbox") >= 0) {
                groupbox = parameterdiv.parentElement;
            } else if (parameterdiv.parentElement.parentElement.tagName = "DIV" && parameterdiv.parentElement.parentElement.className.indexOf("groupbox") >= 0) {
                groupbox = parameterdiv.parentElement.parentElement;
            }
            if (groupbox) {
                groupbox.hide();
            }
        }
    }
}

function getParametersFromContainer(container) {
    container = container || document;

    var parameters = {}
    var parametersElement = container.getElementById("ConfigurableAddIn_parameters");
    if (parametersElement && parametersElement.value) {
        var parameterNames = parametersElement.value.split(",")

        for (var i = 0; i < parameterNames.length; i++) {
            var tokens = parameterNames[i].split("(");
            var parameterId = tokens[1].replace(")", "");
            var parameterName = tokens[0];

            //Get parameter element by ID
            var element = container.getElementById(parameterId);

            if (element == null) {
                element = container.getElementsByName(parameterId)[0];
            }

            if (element != null) {
                if (element.type === 'checkbox') {
                    var checkboxes = container.getElementsByName(parameterId);
                    if (checkboxes.length > 1) { // CheckListParameterEditor
                        parameters[parameterName] = element.parentNode.parentNode.select('input:checked').map((option) => option.value).join();
                    } else {
                        parameters[parameterName] = !!element.checked ? element.value : '';
                    }
                } else if (element.type === 'select-multiple') {
                    parameters[parameterName] = element.select('option:selected').map((option) => option.value).join();
                }
                else
                    parameters[parameterName] = element.value;
            }
        }
    }

    return parameters;
}

function execScripts(resText, execScriptsInGlobalScope) {
    var doc = document,
        head,
        firstScriptNode,
        isOpera = typeof opera !== 'undefined' && opera.toString() === '[object Opera]',
        context = {};

    head = doc.getElementsByTagName('head')[0];
    firstScriptNode = doc.getElementsByTagName('script')[0]

    var getFilesToLoad = function (content) {
        var ret = [],
            js = null,
            style = null,
            jsPattern = /<script[^>]+src="(.+?)".*?>/gi,
            stylePattern = /<link[^>]+href="(.+)"+\s\/>/gi;

        if (content) {
            while ((style = stylePattern.exec(content)) != null) {
                ret.push({ url: style[1], type: 'css' });
            }

            while ((js = jsPattern.exec(content)) != null) {
                ret.push({ url: js[1], type: 'js' });
            }
        }

        return ret;
    }

    var getCodeToEval = function (content) {
        var js,
            ret = [],
            jsPattern = /<script\b[^>]*>([\s\S]*?)<\/script>/gm;

        while ((js = jsPattern.exec(content)) != null) {
            if (js[1]) {
                ret.push(js[1]);
            }
        }

        return ret;
    };

    var createScriptNode = function () {
        var node = document.createElement('script');
        node.type = 'text/javascript';
        node.charset = 'utf-8';
        node.async = true;
        return node;
    };

    var createStyleNode = function () {
        var node = doc.createElement('link');
        node.type = 'text/css';

        return node;
    };

    var addListener = function (node, func, name, ieName) {
        if (node.attachEvent && !(node.attachEvent.toString && node.attachEvent.toString().indexOf('[native code') < 0) && !isOpera) {
            node.attachEvent(ieName, func);
        } else {
            node.addEventListener(name, func, false);
        }
    };

    var removeListener = function (node, func, name, ieName) {
        if (node.attachEvent && !(node.attachEvent.toString && node.attachEvent.toString().indexOf('[native code') < 0) && !isOpera) {
            node.detachEvent(ieName, func);
        } else {
            node.removeEventListener(name, func, false);
        }
    };

    var loadExternalFile = function (file, callback) {
        var node,
            onScriptLoad = function () {
                var loaded = false;

                // IE
                if (node.readyState) {
                    if (node.readyState === 'loaded' || node.readyState === 'complete') {
                        loaded = true;
                    }
                } else {
                    loaded = true;
                }

                if (loaded) {
                    removeListener(node, onScriptLoad, 'load', 'onreadystatechange');
                    if (callback) {
                        callback();
                    }
                }
            };

        if (file) {
            if (file.type === 'js') {
                node = createScriptNode();
                addListener(node, onScriptLoad, 'load', 'onreadystatechange');
                node.src = file.url;

                if (firstScriptNode) {
                    firstScriptNode.parentNode.insertBefore(node, firstScriptNode);
                } else {
                    head.appendChild(node);
                }
            } else if (file.type = 'css') {
                node = createStyleNode();
                node.href = file.url;
                head.appendChild(node);
            }
        }
    };

    var load = function (c) {
        var i = 0,
            codeBlock,
            codeBlocks = c.code,
            codeBlocksCount = codeBlocks.length,
            file,
            files = c.files,
            filesCount = files.length,
            filesLoaded = 0,
            onFilesLoaded = function () {
                doc.loaded = true;
                for (i = 0; i < codeBlocksCount; i += 1) {
                    codeBlock = c.code[i];

                    if (codeBlock) {
                        try {
                            if (execScriptsInGlobalScope) {
                                eval.call(window, codeBlock);
                            } else {
                                eval(codeBlock);
                            }
                        }
                        catch (e) {
                            alert(e.message + '\n' + codeBlock);
                        }

                    }
                }
            };

        if (filesCount > 0) {
            for (i = 0; i < filesCount; i += 1) {
                file = files[i];

                if (file) {
                    loadExternalFile(files[i], function () {
                        filesLoaded += 1;

                        if (filesCount === filesLoaded) {
                            onFilesLoaded();
                        }
                    });
                }
            }
        } else {
            onFilesLoaded();
        }
    };

    context.files = getFilesToLoad(resText);
    context.code = getCodeToEval(resText);

    load(context);
}

function getProductGroupsForParagraph(paragraphId, pageId, groupFetch) {
    /* we need a xhttp-object */
    var xhttp = getXHTTPObject();

    /* is xhttp-object ok? */
    if (!xhttp) {
        return; // exit 
    }

    /* lets get data */
    var returnUrl = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=AddParagraphEditGroups&ID=" + paragraphId + "&PageID=" + pageId + "&grpArr=" + groupFetch;
    xhttp.onreadystatechange = function () {
        getProductGroupsForParagraph_callback(xhttp);
    };
    xhttp.open("GET", returnUrl, true);
    xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    xhttp.send(null);
}

function getProductGroupsForParagraph_callback(xhttp) {
    if (xhttp.readyState == 4) {
        var GroupListDiv = document.getElementById("GroupListLayer");
        if (xhttp.status == 200) {
            try {
                GroupListDiv.innerHTML = xhttp.responseText
                //execScripts(GroupListDiv.innerHTML);
            }
            catch (e) {
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
    var xhttp = getXHTTPObject();

    /* is xhttp-object ok? */
    if (!xhttp) {
        return; // exit 
    }

    /* lets get data */
    var returnUrl = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=AddParagraphEditGroupsSearchv1&ID=" + paragraphId + "&PageID=" + pageId + "&grpArr=" + groupFetch;
    xhttp.onreadystatechange = function () {
        getProductGroupsForSearchv1_callback(xhttp);
    };
    xhttp.open("GET", returnUrl, false);
    xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    xhttp.send(null);
}

function getProductGroupsForSearchv1_callback(xhttp) {
    if (xhttp.readyState == 4) {
        var GroupListDiv = document.getElementById("GroupListLayer");
        //alert(GroupListDiv.innerHTML);
        if (xhttp.status == 200) {
            try {
                //alert(xhttp.responseText);
                GroupListDiv.innerHTML = xhttp.responseText;
                //execScripts(GroupListDiv.innerHTML);
            }
            catch (e) {
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
    var xhttp = getXHTTPObject();

    /* is xhttp-object ok? */
    if (!xhttp) {
        return; // exit 
    }

    /* lets get data */
    var returnUrl = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=AddGroupsToEditor&ID=" + Id + "&grpArr=" + groupFetch;
    xhttp.onreadystatechange = function () {
        getProductGroupsForEditor_callback(xhttp, Id);
    };
    xhttp.open("GET", returnUrl, false);
    xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    xhttp.send(null);

}

function getProductGroupsForEditor_callback(xhttp, Id) {
    if (xhttp.readyState == 4) {
        var GroupListDiv = document.getElementById("GroupListLayer" + Id);
        if (xhttp.status == 200) {
            try {
                GroupListDiv.innerHTML = xhttp.responseText
                ProductMultiGroupsApply(Id);
            }
            catch (e) {
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
    var xhttp = getXHTTPObject();

    /* is xhttp-object ok? */
    if (!xhttp) {
        return; // exit 
    }

    /* lets get data */
    var returnUrl = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=GetRoundingResult&ID=" + roundingId + "&Value=" + roundingValue;
    xhttp.onreadystatechange = function () {
        getRoundingResult_callback(xhttp);
    };
    xhttp.open("GET", returnUrl, false);
    xhttp.setRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    xhttp.send(null);
}

function getRoundingResult_callback(xhttp) {
    if (xhttp.readyState == 4) {
        var ResultField = document.getElementById("TestResult");
        if (xhttp.status == 200) {
            try {
                ResultField.value = xhttp.responseText
                var button = document.getElementById("roundButton");
                if (button) {
                    button.disabled = false;
                }
                //execScripts(GroupListDiv.innerHTML);
            }
            catch (e) {
                //alert(e);
            }
        }
        else {
            //GroupListDiv.innerHTML = "Error in AJAX [" + xhttp.status + "]";				
        }
    }
}

function getFeeRowResult(methodType, methodId, methodCountryId, newRowCnt, newFeeCnt) {
    var returnUrl = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=GetNewFeeLine&FeeCnt=" + newFeeCnt + "&RowCnt=" + newRowCnt + "&methodId=" + methodId + "&methodType=" + methodType + "&countryId=" + methodCountryId;
    new Ajax.Request(returnUrl, {
        method: 'get',
        onSuccess: function (transport) {
            getFeeRowResult_callback(transport, methodCountryId);
        }
    });
}

function getFeeRowResult_callback(transport, methodCountryId) {
    if (transport.readyState == 4) {
        if (transport.status == 200) {
            try {
                var NoFee = document.getElementById("FEE_NOROWS" + methodCountryId);
                NoFee.style.display = "none";
            } catch (e) {
                //alert(e);
            }

            try {
                var FeeTable = document.getElementById("FEE_NEWTABLE" + methodCountryId);

                if (Prototype.Browser.IE) {
                    FeeTable.innerHTML += transport.responseText;
                }
                else {
                    setDynamicContentNS6("FEE_NEWTABLE" + methodCountryId, transport.responseText);
                }
            } catch (e) {
                //alert(e);
            }

            try {
                var rowCnt = document.getElementById("FEE_ROWCOUNTER" + methodCountryId)
                var feeCnt = document.getElementById("FEE_LINECOUNTER" + methodCountryId)
                rowCnt.value = parseInt(rowCnt.value) + 1;
                feeCnt.value = parseInt(feeCnt.value) + 1;
            } catch (e) {
                //alert(e);
            }
        } else {
            //alert("Error in AJAX [" + transport.status + "]");
        }
    }
}

function setDynamicContentNS6(elementid, content) {
    var rng = document.createRange();
    var el = document.getElementById(elementid);
    rng.setStartBefore(el);
    var htmlFrag = rng.createContextualFragment(content);
    el.appendChild(htmlFrag);
}

function deleteFeeRowInDB(feeId, divId) {
    var returnUrl = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx?CMD=DeleteFeeLine&FeeID=" + feeId;
    new Ajax.Request(returnUrl, {
        method: 'get',
        onSuccess: function (transport) {
            doDeleteFeeRow(divId);
        }
    });
}

function doDeleteFeeRow(divId) {
    var div = document.getElementById("FEE_Div" + divId);
    if (div) {
        var parent = div.parentNode;
        parent.removeChild(div);
        var rows = parent.getElementsByClassName("OutlookItem");
        if (rows.length == 0) {
            parent.parentNode.getElementsByClassName("NoFeeRow")[0].style.display = '';
        }
    }
}

function toggleHideParameters(parametersDiv, functionName) {
    var dropdowns = findParametersByAttributeContainsValue(parametersDiv, "onchange", functionName, "select");
    if (dropdowns !== null) {
        for (var i = 0; i < dropdowns.length; i++) {
            var el = dropdowns[i];
            var value = el.getAttribute("onchange");
            if (value !== null) {
                value = value.split(";")[0];
                eval(value);
            }
        }
    }
}

function findParametersByAttributeContainsValue(parametersDiv, attribute, value, element_type) {
    if (parametersDiv !== null) {
        element_type = element_type || "*";
        var elements = [];
        var parameters = parametersDiv.getElementsByTagName(element_type);
        for (var i = 0; i < parameters.length; i++) {
            var parameter = parameters[i];
            var attributeValue = parameter.getAttribute(attribute);
            if (attributeValue !== null && attributeValue.indexOf(value) >= 0) { elements.push(parameter); }
        }
    }
    return elements;
}

function hideParameters(listId, parameters) {
    if (listId !== null && parameters !== null) {
        var hide = true;
        var dropdown = document.getElementById(listId);
        if (dropdown !== null) {
            var value = dropdown.options[dropdown.selectedIndex].value;
            hide = value !== null && value !== '' && value.toLowerCase() !== 'none';
            for (var i = 0; i < parameters.length; i++) {
                var el = document.getElementById(parameters[i]);
                if (el !== null && el.parentElement !== null && el.parentElement.parentElement !== null) {
                    el.parentElement.parentElement.style.display = hide ? 'none' : '';
                }
            }
        }
    }
}