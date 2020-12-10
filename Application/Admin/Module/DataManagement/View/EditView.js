var query_rowId;
var query_oper;
var query_field;
var query_count;
var query_noCriteria;
var query_missingParams;
var query_usePlings;
var resultFromRequestHelperToQueryHelper = false;
var changeToSqlHasSaved = false;


function help() {
    window.open('http://manual.net.dynamicweb.dk/Default.aspx?ID=1&m=keywordfinder&keyword=modules.datamanagement.general.view.edit&LanguageID=' + helpLang, 'dw_help_window', 'location=no,directories=no,menubar=no,toolbar=yes,top=0,width=1024,height=' + (screen.availHeight-100) + ',resizable=yes,scrollbars=yes');
}

function save(isPreview, changeToSql) {
    var select = document.getElementById("vwBase");
    var ddlConn = document.getElementById("vwConnection");
    var ddlTables = document.getElementById("vwTables");
    var name = document.getElementById("vwName");

    var lstRight = document.getElementById("lstRight");
    $("fields").value = getFieldsArray();

    document.viewForm.target = '';
    if (myBase == 0) {
        document.viewForm.action = "EditView.aspx?ID=" + id + "&CMD=SAVE_VIEW_SQL&OnSave=Nothing";
    }else{
        document.viewForm.action = "EditView.aspx?ID=" + id + "&CMD=SAVE_VIEW_WIZ&OnSave=Nothing&connId=" + ddlConn.value.split(",")[0] + "&dbName=" + ddlConn.value.split(",")[1] + "&tblName=" + ddlTables.options[ddlTables.selectedIndex].text;
    }

    if (name.value.length == 0) {
        alert(txtViewNameMissing);
        if (!changeToSqlHasSaved) {
            Ribbon.activateButton("Type_1");
            Ribbon.deactivateButton("Type_0");
        }
        Ribbon.deactivateButton('btnPreview');
        dialog.show('Settings');
        name.focus();
    }else{
        if (isPreview) {
            document.viewForm.target = "ContentSaveFrame";
            document.viewForm.action += "&preview=true";
        }
        if (changeToSql != 'undefined' && changeToSql == true) {
            document.viewForm.target = "ContentSaveFrame";
            document.viewForm.action += "&changeToSQL=true";
        }
        document.viewForm.submit();
    }
}

function saveAndClose() {
    var select = document.getElementById("vwBase");
    var ddlConn = document.getElementById("vwConnection");
    var ddlTables = document.getElementById("vwTables");
    var name = document.getElementById("vwName");

    var lstRight = document.getElementById("lstRight");
    $("fields").value = getFieldsArray();

    document.viewForm.target = '';
    if (myBase == 0) {
        document.viewForm.action = "EditView.aspx?ID=" + id + "&CMD=SAVE_VIEW_SQL&OnSave=Close";
    }else{
        document.viewForm.action = "EditView.aspx?ID=" + id + "&CMD=SAVE_VIEW_WIZ&OnSave=Close&connId=" + ddlConn.value.split(",")[0] + "&dbName=" + ddlConn.value.split(",")[1] + "&tblName=" + ddlTables.options[ddlTables.selectedIndex].text;
    }

    if (name.value.length == 0) {
        alert(txtViewNameMissing);
        dialog.show('Settings');
        name.focus();
    }else{
        document.viewForm.submit();
    }
}

function cancel() {
    document.viewForm.target = '';
    document.viewForm.action = "EditView.aspx?CMD=CANCEL";
    document.viewForm.submit();
}

function getFields() {
    return "&fields=" + getFieldsArray();
}

function getFieldsArray() {
    var fieldsArr = SelectionBox.getElementsRightAsArray("SelectionBox1");
    return fieldsArr.join(",");
}

function doInit(base) {
    document.body.style.height = parent.getContentFrameHeight() - 1 + 'px';        
    ChangeBase(base);
    
    if (!isEdit) 
        dialog.show('Settings');

    // Set the onCompleted event
    dwGrid_conds.onRowAddedCompleted = function(row) {
        hideConditionalOperatorSelector();
        var fieldsBox = row.findControl("fields");
        fieldsBox.focus();
    };
}

function ChangeBase(base) {
    if (myBase == 0 && base == 1)
        return;
        
    var divWiz = document.getElementById("divWiz");
    var divSQL = document.getElementById("divSQL");
    var tableTR = document.getElementById("tableTR");
    var ddlConn = document.getElementById("vwConnection");
    var time = new Date();

    if (myBase == 1 && base == 0) {
        var doChange = changeToSqlHasSaved ? true : confirm(txtConvertToSQL);
        if (doChange) {
            if (!changeToSqlHasSaved) {
                save(false, true);
                return;
            }
            //AJAX to get ViewSQL
            var statement = ajaxRequest("EditView.aspx?AJAXCMD=CONVERT_SQL&ID=" + id + "&timestamp=" + time.getTime());
            
            //Check for IE or Firefox and set Statement
            if (typeof($("vwStatement").innerText) == 'undefined') {
                $("vwStatement").textContent = statement;
            }else{
                $("vwStatement").innerText = statement;
            }

            Ribbon.activateButton("Type_0");
            Ribbon.deactivateButton("Type_1");
            Ribbon.disableButton("Type_1");
            Ribbon.disableButton("btnShowSelector");
            $("vwConnection").disabled = false;
        }else {
            $("Type_1").onclick();
            return;
        }
    }else if (isEdit && base == 0) {
        Ribbon.disableButton("Type_1");
        Ribbon.disableButton("btnShowSelector");
    }

    myBase = base
    
    switch (base) {
        case 0:
            divSQL.style.display = "block";
            $("conds").style.display = "none";
            divWiz.style.display = "none";
            tableTR.style.display = "none";
            break;
        case 1:
            var time = new Date();

            divSQL.style.display = "none";
            divWiz.style.display = "block";
            $("conds").style.display = "";
            tableTR.style.display = "";
            ajaxLoader("EditView.aspx?AJAXCMD=FILL_TABLES&ID=" + id + 
                       "&connId=" + ddlConn.value.split(",")[0] + 
                       "&dbName=" + ddlConn.value.split(",")[1] + 
                       "&timestamp=" + time.getTime(),
                       "tableDropdown");
            document.getElementById("vwTables").onchange();
            break;
        default:
            break;
    }
}

function fillFields() {
    var ddlConn = document.getElementById("vwConnection");
    var ddlTables = document.getElementById("vwTables");
    var time = new Date();
    
    
    var result = ajaxRequest("EditView.aspx?AJAXCMD=FILL_FIELDS&ID=" + id + 
                             "&connId=" + ddlConn.value.split(",")[0] + 
                             "&dbName=" + ddlConn.value.split(",")[1] + 
                             "&tblName=" + ddlTables.options[ddlTables.selectedIndex].text + 
                             "&timestamp=" + time.getTime());
    var fields = result.split(";");

    //Use function from SelectionBox Control JS library
    SelectionBox.fillLists(fields[0], "SelectionBox1");
    /*
    SelectionBox.getListItems("EditView.aspx?AJAXCMD=FILL_FIELDS&ID=" + id + 
                 "&connId=" + ddlConn.value.split(",")[0] + 
                 "&dbName=" + ddlConn.value.split(",")[1] + 
                 "&tblName=" + ddlTables.options[ddlTables.selectedIndex].text + 
                 "&timestamp=" + time.getTime(),
                 "SelectionBox1");
    */
    var useAllFields = fields[1] == "True" ? true : false;
    $("useFields_All").checked = useAllFields;
    $("useFields_Manual").checked = !useAllFields;
    if (useAllFields) {
        $("sel").hide();
    }else{
        $("sel").show();
    }
    
    if (!isEdit) {
        var allRows = dwGrid_conds.rows.getAll();
        dwGrid_conds.deleteRows(allRows);
    }
    fillFieldsWithPling();
    
    fillOrderBy();
}

function fillFieldsWithPling() {
    var ddlConn = document.getElementById("vwConnection");
    var ddlTables = document.getElementById("vwTables");
    var time = new Date();

    $("fieldsWithPling").value = ajaxRequest("EditView.aspx?AJAXCMD=FILL_WITH_PLING&ID=" + id + 
                                             "&connId=" + ddlConn.value.split(",")[0] + 
                                             "&dbName=" + ddlConn.value.split(",")[1] + 
                                             "&tblName=" + ddlTables.options[ddlTables.selectedIndex].text + 
                                             "&timestamp=" + time.getTime());
}

function fillOrderBy() {
    var ddlConn = document.getElementById("vwConnection");
    var ddlTables = document.getElementById("vwTables");
    var time = new Date();

    ajaxLoader("EditView.aspx?AJAXCMD=FILL_ORDERBY&ID=" + id +
               "&connId=" + ddlConn.value.split(",")[0] + 
               "&dbName=" + ddlConn.value.split(",")[1] + 
               "&tblName=" + ddlTables.options[ddlTables.selectedIndex].text + 
               "&timestamp=" + time.getTime(),
               "orderByDiv");
   
}

function ajaxLoader(url,divId) {

    new Ajax.Updater(divId, url, {
        asynchronous: false, 
        evalScripts: true,
        method: 'get',
        
        onSuccess: function(request) {
            $(divId).update(request.responseText);
        }
    } );

}

function ajaxRequest(url) {
    var resultText;
    new Ajax.Request(url, {
        asynchronous: false,
        method: 'get',
        
        onSuccess: function(request) {
            resultText = request.transport.responseText;
        }
    });

    return resultText;
}

function deleteSelectedRow(obj) {
    var row = dwGrid_conds.findContainingRow(obj);
    dwGrid_conds.deleteRows([row]);
    hideConditionalOperatorSelector();
}

function handleRowSelected(obj) {
    row = dwGrid_conds.findContainingRow(obj);
    try {
        var rows = dwGrid_conds.rows.getAll();
        for (var i = 0; i < rows.length; i++) {
            if (row.ID == rows[i].ID) {
                rows[i].setSelected(true);
                rows[i].findControl('buttons').style.visibility = "visible";
            } else {
                rows[i].setSelected(false);
                rows[i].findControl('buttons').style.visibility = "hidden";
            }
        }
    } catch (e) { }
}

function hideConditionalOperatorSelector() {
    var rows = dwGrid_conds.rows.getAll();

    if (rows.length > 0) {
        // Hide the selector from the first row
        rows[0].findControl("conditionalOperator").style.visibility = "hidden";
        
        // Show the selector for all the other rows
        for (var i = 1; i < rows.length; i++) {
            rows[i].findControl("conditionalOperator").style.visibility = "visible";
        }
    }
}

function showHelper( obj ) {
    var row = dwGrid_conds.findContainingRow(obj);
    var rowId = row.ID;
    var oper = row.findControl("oper").value; //Get the value from the 'oper' select control
    var field = row.findControl("fields").value; //Get value from the 'fields' select control
    var value = escape(row.findControl("criteria").value); //Get the value from the 'criteria' text input
    var fieldsWithPlings = $("fieldsWithPling").value.split(",") //Get the fields whose values must be inside a pair of '´s
    var usePlings = false;
    
    for (var i = 0; i < fieldsWithPlings.length; i++) {
        if (fieldsWithPlings[i] == field) {
            usePlings = true;
            i = fieldsWithPlings.length;
        }
    }
    
    if (oper == "IN" || oper == "NOT IN" || oper == "BETWEEN") {
        showQueryHelper(rowId, oper, field, value, usePlings);
    } else {
        showRequestHelper(rowId, value, false);
    }
}

function showRequestHelper(rowId, value, resultToQueryHelper) {
    resultFromRequestHelperToQueryHelper = resultToQueryHelper;
    ajaxLoader("EditView.aspx?AJAXCMD=REQ_BUILDER&rowId=" + rowId + "&value=" + value, "reqBuilder");
    $("req_ddlSelect").onchange();
    dialog.show("RequestHelper");
}

function showQueryHelper(rowId, oper, field, value, usePlings) {
    ajaxLoader("EditView.aspx?AJAXCMD=QUERY_HELPER&ref=" + [rowId, oper, field] + "&value=" + value + "&usePlings=" + usePlings, "query_builder");
    dialog.show("QueryHelper");
    
    //Fill parameters from hidden fields
    query_count = $("query_count").value;
    query_field = field;
    query_missingParams = $("query_missingParams").value;
    query_noCriteria = $("query_noCriteria").value;
    query_oper = oper;
    query_rowId = rowId
    query_usePlings = usePlings;
    
    $("query_fieldName").update(field);
    $("query_operator").update(oper);
}

function recieveValuesFromHelper(rowID, values) {
    var row = dwGrid_conds.rows.getRowByID(rowID);
    
    row.findControl("criteria").value = values; //Put the return value into the 'criteria' text input
}

function recieveValuesToQueryHelper(boxID, values) {
    $("QueryHelper_" + boxID).value = values;
    generateQueryExpression();
}

function okReq() {
    var reqString = "@" + $("req_ddlSelect").value + '("' + $("req_var_name").value + '")';
    if (resultFromRequestHelperToQueryHelper) {
        recieveValuesToQueryHelper(parseInt($("req_Id").value), reqString);
    }else{
        recieveValuesFromHelper(parseInt($("req_Id").value), reqString);
    }
    dialog.hide("RequestHelper");
}

function okQuery() {
    if ($("expressionDiv").innerText.length == 2) {
        alert(noCriteriaText);
        $("QueryHelper_0").focus();
    }else{
        recieveValuesFromHelper(parseInt(query_rowId), $("expressionDiv").innerText);
        dialog.hide("QueryHelper");
    }
}

function generateQueryExpression() {
    var values = new Array;
    var expression = "";
    
    if (query_count > 2) {
        for (var i = 0; i < query_count; i++) {
            if ($("QueryHelper_" + i).value.length != 0) {
                if ($("QueryHelper_" + i).value == "<!--empty-->") {
                    if (query_usePlings) {
                        values.push("''");
                    }else{
                        values.push("");
                    }
                }else{
                    if (query_usePlings) {
                        values.push("'" + $("QueryHelper_" + i).value + "'");
                    }else{
                        values.push($("QueryHelper_" + i).value);
                    }
                }
            }
        }
        
        expression = "(";
        if (values.length > 0) {
            expression += values[0];
            for (var i = 1; i < values.length; i++) {
                expression += ", " + values[i];
            }
        }
        expression += ")";
    }else{
        if ($("QueryHelper_0").value.length != 0 && $("QueryHelper_1").value.length != 0) {
            if (query_usePlings) {
                expression = "'" + $("QueryHelper_0").value + "' AND '" + $("QueryHelper_1").value + "'";
            }else{
                expression = $("QueryHelper_0").value + " AND " + $("QueryHelper_1").value;
            }
        }else{
            expression = query_missingParams;
        }
    }

    $("expressionDiv").innerText = expression;
}

function showInfoPane() {
    ajaxLoader("EditView.aspx?AJAXCMD=REQ_INFO&type=" + $("req_ddlSelect").value, "reqInfoPane");
}

function HandleKeyDown(e, obj) {
    // Check if [TAB] or [ENTER] was pressed
    if (!e.shiftKey && (e.keyCode == 9 || e.keyCode == 13)) {
        var allRows = dwGrid_conds.rows.getAll();
        var lastRow = allRows[allRows.length - 1];
        var thisRow = dwGrid_conds.findContainingRow(obj);
        
        var isLastRow = (thisRow.ID == lastRow.ID);
        
        if (isLastRow) {
            dwGrid_conds.addRow();
        }
    }
}

function toggleDesignerEnabled() {
    if ($('selTR').style.display == 'none') {
        $('selTR').style.display = '';
    }else{
        $('selTR').style.display = 'none';
    }
}

function toggleUseAllFields(obj) {
    if ($(obj).id == "useFields_All") {
        $("sel").hide();
    }else{
        $("sel").show();
    }
}

//#######################################################
// Preview methods/functions
//#######################################################
function Preview() {
    if ($('PreviewLayer').style.display == 'none') {
        if (!confirm(txtConfirmPreview)) {
            return;
        } else {
            save(true);  
        }
    } else {
        Previewer();
    }        
}

var PreviewActive = false;

function Previewer() {
    if ($('PreviewLayer').style.display == 'none') {        
        PreviewActive = true;
        $('PreviewLayer').style.display = '';
        PreviewRunner();
    } else {        
        PreviewActive = false;
        $('PreviewLayer').style.display = 'none';
        Ribbon.deactivateButton('btnPreview');
    }
}

function PreviewRunner() {
    var d = new Date();
    var contentLayer = "PreviewContent";
    
    isEdit = true;
    
    $("iPreview").src = "../ListContent.aspx?CMD=VIEWS&ID=" + id;
}

function PreviewLoader(url,divId) {
    new Ajax.Request(url, {
        //asynchronous: true, 
        method: 'get',
        
        onSuccess: function(request) {
            $(divId).update(request.responseText);
        },
        
        onFailure: function(request) {
            $(divId).update("<br/><span class='disableText' style='margin:5px;padding:5px;'>"+ request.responseText +"</span>");
        },        
        
        onException: function(request) {
            $(divId).update("<br/><span class='disableText' style='margin:5px;padding:5px;'>" + request.responseText + "</span>");
        }        
    });
}

function ClosePreviewer() {
    if ($('PreviewLayer').style.display != 'none') {
        Previewer();        
    }
}

function setViewID(viewID) {
    id = viewID;
}
