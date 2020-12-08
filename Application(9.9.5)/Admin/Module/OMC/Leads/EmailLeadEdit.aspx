<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="EmailLeadEdit.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.EmailLeadEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Webpage analysis</title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
    <link rel="Stylesheet" href="/Admin/Content/PageTemplates/Reports/PagePerformanceReport.css" type="text/css" />
    <style type="text/css" >
        #SendEmailDiv table.tabTable, #SendEmailDiv fieldset
        {
        display: block;
        width: 473px;
        }
        .attachmentControl
        {
        padding:10px;
        }

        select.FileManagerSelect.std 
        {
        width:255px !important;
        }
    </style>
    <script type="text/javascript">
        function validateFields(){
            var pattern = /^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/;
            var recipientList = $$('[name="recipientsList"]')[0].value;

            if (recipientList != null && recipientList.length > 0) {
                var recipentEmails = recipientList.split(",");
                for(var i=0; i < recipentEmails.length; i++){
                    if (!recipentEmails[i].match(pattern)) {
                        alert('<%= Translate.JsTranslate("The recipients email has incorrect format. Please specify correct recipient email address.") %>');
                        return false;
                    }
                }
            }

            if (recipientList != null && recipientList.length <= 0) {
                alert('<%= Translate.JsTranslate("Please specify the recipient email address.") %>');
                return false;
            }else if(!$('txSenderName').value){
                alert('<%= Translate.JsTranslate("Please specify the sender name.") %>');
                $('txSenderName').focus();
                return false; 
            }else if(!$('txSenderEmail').value){
                alert('<%= Translate.JsTranslate("Please specify the sender email.") %>');
                $('txSenderEmail').focus();
                return false;
            }else if(!($('txSenderEmail').value).match(pattern)){
                alert('<%= Translate.JsTranslate("The sender email has incorrect format. Please specify correct sender email address.") %>');
                $('txSenderEmail').focus();
                return false;
            }else if(!$('txSubject').value){
                alert('<%= Translate.JsTranslate("Please specify the email subject.") %>');
                $('txSubject').focus();
                return false;
            }else{
                return true;
            }
        }

        function markAsLead(url, rowId) {
            new Ajax.Request(url, {
                method: 'get',
                onSuccess: function (transport) {
                    if (parent.LeadsListPage && parent.currentPage) {
                        parent.currentPage.applyFilters();
                    }
                    parent.dialog.hide('SendEmailDialog');

                    for (var i = 0; i < parent.$$('ul.omc-leads-list-row').length; i++) {
                        if (parent.$$('ul.omc-leads-list-row')[i].readAttribute('data-id') == rowId) {
                                 parent.$$('ul.omc-leads-list-row')[i].remove();
                            break; 
                        }
                    }

                }, 
            });
        }
    </script>
</head>
<body  style="height:0px;">
    <form id="form1" runat="server">
    <div id="SendEmailDiv">
        <dw:GroupBox ID="gbGeneral" Title="General" runat="server">
            <table>
                <tr>
                    <td style="width: 170px; vertical-align: top;">
                        <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Send To:"/>
                    </td>
                    <td>
                        <omc:EditableListBox id="recipientsList" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="lbSenderName" Text="From: Name" runat="server" />
                    </td>
                    <td>
                        <asp:TextBox ID="txSenderName" CssClass="std field-name" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="lbSenderEmail" Text="From: e-mail" runat="server" />
                    </td>
                    <td>
                        <asp:TextBox ID="txSenderEmail" CssClass="std field-name" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="TranslateLabel5" Text="Subject" runat="server" />
                    </td>
                    <td>
                        <asp:TextBox ID="txSubject" CssClass="std field-name" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="TranslateLabel3" Text="Additional message" runat="server" />
                    </td>
                    <td>
                        <asp:TextBox ID="txtAdditionalMsg" CssClass="std field-name" runat="server" ClientIDMode="Static" TextMode="MultiLine" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="TranslateLabel1" Text="Template:" runat="server" />
                    </td>
                    <td>
                        <dw:FileManager ID="fmTemplate" runat="server" Folder="Templates/OMC/Notifications" File="EmailLeadsStatistic.html" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="TranslateLabel2" Text="Lead state after sending:" runat="server" />
                    </td>
                    <td>
                        <select id="LeadsStateSelector" class="std" name="LeadsStateSelector"  style="width:255px;">
                            <asp:Literal ID="LeadsStates" runat="server"></asp:Literal>
                        </select>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <div>
            <input type="submit" value="Send" id="SaveExperimentBtn" runat="server" style="float:right; margin-right:10px;" onclick="if(!validateFields()){return false;}" />
        </div>
    </div>
</form>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html> 
