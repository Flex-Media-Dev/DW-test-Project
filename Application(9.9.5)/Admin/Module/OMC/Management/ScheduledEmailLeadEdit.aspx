<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ScheduledEmailLeadEdit.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.ScheduledEmailLeadEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
     <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
     <script type="text/javascript">
        function validateFields() {
            var pattern = /^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/;
            var recipientList = $$('[name="recipientsList"]')[0].value;

            if (recipientList != null && recipientList.length > 0) {
                var recipentEmails = recipientList.split(",");
                for (var i = 0; i < recipentEmails.length; i++) {
                    if (!recipentEmails[i].match(pattern)) {
                        alert('<%= Translate.JsTranslate("The recipients email has incorrect format. Please specify correct recipient email address.") %>');
                        return false;
                    }
                }
            }

            if (recipientList != null && recipientList.length <= 0) {
                alert('<%= Translate.JsTranslate("Please specify the recipient email address.") %>');
                return false;
            } else if (!$('txSenderName').value) {
                alert('<%= Translate.JsTranslate("Please specify the sender name.") %>');
                $('txSenderName').focus();
                return false;
            } else if (!$('txSenderEmail').value) {
                alert('<%= Translate.JsTranslate("Please specify the sender email.") %>');
                $('txSenderEmail').focus();
                return false;
            } else if (!($('txSenderEmail').value).match(pattern)) {
                alert('<%= Translate.JsTranslate("The sender email has incorrect format. Please specify correct sender email address.") %>');
                $('txSenderEmail').focus();
                return false;
            } else if (!$('txSubject').value) {
                alert('<%= Translate.JsTranslate("Please specify the email subject.") %>');
                $('txSubject').focus();
                return false;
            } else {
                var confirmText = '<%= Translate.JsTranslate("The sending of leads email will be scheduled for ")%>' + getScheduledDate() + '<%=Translate.JsTranslate(". Do you want to continue?")%>';
                if (!confirm(confirmText)) {
                    return false;
                } else {
                    return true;
                }
            }
        }

        function markAsLead(rowId, isLead) {
            parent.dialog.hide('pwSendEmail');
            var ulElement = null;
            for (var i = 0; i < parent.$$('ul.omc-leads-list-row').length; i++) {
                if (parent.$$('ul.omc-leads-list-row')[i].readAttribute('data-id') == rowId) {
                    if (isLead) {
                        (parent.$$('ul.omc-leads-list-row a.omc-leads-list-mark-lead')[i]).click();
                    } else {
                        (parent.$$('ul.omc-leads-list-row a.omc-leads-list-mark-notlead')[i]).click();
                    }
                    break;
                }
            }
        }

        function getScheduledDate() {
            var scheduledDate = "";
            if ($('dsScheduleDate_month') && $('dsScheduleDate_day') && $('dsScheduleDate_year') && $('dsScheduleDate_hour') && $('dsScheduleDate_minute')) {
                scheduledDate = " '" + $('dsScheduleDate_month').value + "-" + $('dsScheduleDate_day').value + "-" + $('dsScheduleDate_year').value + "-" + $('dsScheduleDate_hour').value + "-" + $('dsScheduleDate_minute').value + "' ";
            }
            return scheduledDate;
        }

        function serializeLeadStates() {
            $("LeadStatesID").value = SelectionBox.getElementsRightAsArray("LeadStatesSelector");
        }

    </script>
</head>
<body style="height:0px;" >
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
                        <dw:FileManager ID="fmTemplate" runat="server" Folder="Templates/OMC/Notifications" File="EmailLeadsPotentialLeads.html" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="TranslateLabel2" Text="Website" runat="server" />
                    </td>
                    <td>
                        <select id="WebsiteSelector" class="std" name="WebsiteSelector"  style="width:255px;">
                            <asp:Literal ID="Websites" runat="server"></asp:Literal>
                        </select>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <dw:GroupBox ID="gbIncludeLeadStates" Title="Include lead states" runat="server">
            <table cellpadding="1" cellspacing="1" border="0">
                <tr>
                    <td>
                        <dw:SelectionBox ID="LeadStatesSelector" runat="server" CssClass="std" />
                        <input type="hidden" name="LeadStatesID" id="LeadStatesID" value="" runat="server" ClientIDMode="Static"/>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <dw:GroupBox ID="gbScheduling" Title="Scheduling" runat="server">
            <table>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="TranslateLabel4" Text="Begin sending notifications from" runat="server" />
                    </td>
                    <td colspan="2" >
                        <dw:DateSelector ID="dsScheduleDate" runat="server" IncludeTime="True" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="TranslateLabel6" Text="Send out every" runat="server" />
                    </td>
                    <td style="width: 20%">
                        <omc:NumberSelector ID="RepeatPeriod" AllowNegativeValues="false" MinValue="1" MaxValue="100" runat="server" /> 
                    </td>
                    <td>
                        <select id="PeriodSelector" class="std" name="PeriodSelector"  style="width:75px;">
                            <asp:Literal ID="PeriodSelectorValues" runat="server"></asp:Literal>
                        </select>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <dw:GroupBox ID="gbSendSettings" Title="Send settings" runat="server">
            <table>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="TranslateLabel11" Text="Mails should be sent out as:" runat="server" />
                    </td>
                    <td>
                        <dw:RadioButton ID="rbPerDay" runat="server" FieldName="SendParams" FieldValue="1" />
                        <dw:TranslateLabel id="TranslateLabel9" Text="Separate mails containing daily leads" runat="server" /><br />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                    </td>
                    <td style="padding-bottom:10px;">
                        <dw:RadioButton ID="rbAggregated" runat="server" FieldName="SendParams" FieldValue="2"/>
                        <dw:TranslateLabel id="TranslateLabel10" Text="One mail containing all leads" runat="server" /><br />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                    </td>
                    <td style="padding-bottom:5px;"> 
                        <dw:CheckBox ID="chkAllowAction" FieldName="AllowAction" runat="server"/>
                        <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Allow lead state actions from the e-mail" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="TranslateLabel12" Text="Only send top" runat="server" />
                    </td>
                    <td>
                        <omc:NumberSelector ID="numLimitLeads" AllowNegativeValues="false" MinValue="1" MaxValue="500" runat="server" />&nbsp;<dw:TranslateLabel ID="TranslateLabel13" Text="leads from engagement index" runat="server" />  
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <div>
            <input type="submit" value="Save" id="SaveExperimentBtn" runat="server" style="float:right; margin-right:5px;" onclick="if(!validateFields()){return false;}" />
        </div>

        <input type="hidden" name="isUpdate" id="isUpdate" value="" runat="server"/>
        <input type="hidden" name="hleadMailID" id="hleadMailID" value="" runat="server"/>
    </div>
    </form>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
