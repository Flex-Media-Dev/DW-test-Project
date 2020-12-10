<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="QueryHelper.aspx.vb" Inherits="Dynamicweb.Admin.QueryHelper" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.eCommerce.UserPermissions" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><%=Translate.JsTranslate("Query Helper")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" />

    <script type="text/javascript">
        var row = <%=rowId %>;
        var oper = "<%=oper %>";
        var field = "<%=field %>";
        var count = <%=textBoxCount %>;
        var noCriteriaText = "<%=noCriteriatext %>";
        var missingParameters = '<%=Translate.JsTranslate("Required parameters are missing") %>'
        var usePlings = <%=usePlings %>;
        
        function ajaxLoader(url,divId) {
            new Ajax.Updater(divId, url, {
                asynchronous: false, 
                evalScripts: true,
                method: 'get',
                
                onSuccess: function(request) {
                    $(divId).update(request.responseText)
                }
            });
        }
        
        function ok() {
            if ($("expressionDiv").innerText.length == 2) {
                alert(noCriteriaText);
                $("qh_0").focus();
            } else {
                opener.recieveValuesFromHelper(row, $("expressionDiv").innerText);
                window.close();
            }
        }
        
        function cancel() {
            window.close();
        }
        
        function generateExpression() {
            var values = new Array;
            var expression = "";
            
            if (count > 2) {
                for (var i = 0; i < count; i++) {
                    if ($("qh_" + i).value.length != 0) {
                        if ($("qh_" + i).value == "<!--empty-->") {
                            if (usePlings) {
                                values.push("''");
                            } else {
                                values.push("");
                            }
                        } else {
                            if (usePlings) {
                                values.push("'" + $("qh_" + i).value + "'");
                            } else {
                                values.push($("qh_" + i).value);
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
            } else {
                if ($("qh_0").value.length != 0 && $("qh_1").value.length != 0) {
                    if (usePlings) {
                        expression = "'" + $("qh_0").value + "' AND '" + $("qh_1").value + "'";
                    } else {
                        expression = $("qh_0").value + " AND " + $("qh_1").value;
                    }
                } else {
                    expression = missingParameters;
                }
            }

            $("expressionDiv").innerText = expression;
        }
        
        function showRequestHelper(boxID) {
            var url = 'RequestHelper.aspx?id=' + boxID + "&value=" + $("qh_" + boxID).value;

            newwin = null;
            newwin = window.open(url, 'reqhelperwin', 'scrollbars,status,width=550,height=600');
            newwin.focus();
            if (!newwin.opener) {newwin.opener = self;}
        }
        
        function recieveValuesFromHelper(boxID, values) {
            $("qh_" + boxID).value = values;
            generateExpression();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dw:GroupBox Title="Info" runat="server" DoTranslation="true">
            <table>
                <tr>
                    <td><%=Translate.Translate("Field")%></td>
                    <td><%=field%></td>
                </tr>
                <tr>
                    <td><%=Translate.Translate("Operator")%></td>
                    <td><%=oper%></td>
                </tr>
                <tr>
                    <td><%=Translate.Translate("Complete expression")%></td>
                    <td>
                        <div id="expressionDiv"></div>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <dw:GroupBox Title="Vælg værdier" runat="server" DoTranslation="true">
            <div id="quert_builder"></div>
            <div><%=Translate.Translate("Notice that you can use %% to insert an empty string.", "%%", "&lt;!--empty--&gt;")%></div>
        </dw:GroupBox>
        <div style="text-align: right; padding-right: 5px;">
            <input type="button" onclick="ok();" value="<%=Translate.jstranslate("Ok") %>" />
            <input type="button" onclick="cancel();" value="<%=Translate.jstranslate("Cancel") %>" />
        </div>
    </form>

    <script type="text/javascript">
        if (oper == "IN" || oper == "NOT IN" || oper == "BETWEEN") {
            ajaxLoader("QueryHelper.aspx?AJAXCMD=true&rowId=" + row + "&oper=" + oper + "&value=<%=value %>", values)
            generateExpression();
        }
    </script>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
