<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Content/Management/EntryContent2.Master" CodeBehind="Leads.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.Leads" %>

<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Configuration" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%=Dynamicweb.SystemTools.Gui.WriteFolderManagerScript()%>

    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {
            document.frmGlobalSettings.submit();
        }
    </script>
    <style>
        .dwGrid td:last-child .number-selector-field {
            float: right;
            padding-right: 1px;
        }
    </style>
    <!--[if IE]>
    <style type="text/css">
        .omc-account select
        {
            width: 254px;
        }
    </style>
    <![endif]-->
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div id="PageContent" class="omc-control-panel">
        <dw:GroupBox ID="gbReturningVisitorsNotifications" Title="E-mail notifications - Returning Visitors" runat="server">
            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td colspan="2" class="omc-cpl-hint">
                        <dw:TranslateLabel ID="lbReturningVisitorsNotifitcations" Text="Here you can define when to send email notifications regarding returning visitors." runat="server" />
                    </td>
                </tr>
            </table>

            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="lbSendEvery" Text="Send interval (days)" runat="server" />
                    </td>
                    <td>
                        <omc:NumberSelector ID="numReturningVisitorsSendInterval" RequestKey="/Globalsettings/Modules/OMC/Notifications/ReturningVisitorsSendInterval"
                            SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/Notifications/ReturningVisitorsSendInterval  %>"
                            AllowNegativeValues="false" MinValue="1" MaxValue="365" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel ID="lbSendFrame" Text="Send between (hours)" runat="server" />
                    </td>
                    <td>
                        <div class="omc-cpl-numrange">
                            <div class="omc-cpl-numrange-selector">
                                <omc:NumberSelector ID="numSendFrameFrom" RequestKey="/Globalsettings/Modules/OMC/Notifications/ReturningVisitorsSendFrom"
                                    SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/Notifications/ReturningVisitorsSendFrom  %>"
                                    AllowNegativeValues="false" MinValue="1" MaxValue="24" runat="server" />
                            </div>

                            <div class="omc-cpl-numrange-separator">
                                <dw:TranslateLabel ID="lbAnd" Text="and" runat="server" />
                            </div>

                            <div class="omc-cpl-numrange-selector">
                                <omc:NumberSelector ID="numSendFrameTo" RequestKey="/Globalsettings/Modules/OMC/Notifications/ReturningVisitorsSendTo"
                                    SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/Notifications/ReturningVisitorsSendTo  %>"
                                    AllowNegativeValues="false" MinValue="1" MaxValue="24" runat="server" />
                            </div>

                            <div class="omc-clear"></div>
                        </div>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <br />

        <dw:GroupBox ID="gbLeadStates" Title="Lead states" runat="server">
            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td colspan="2" class="omc-cpl-hint">
                        <dw:TranslateLabel ID="lbLeadStatesExplanation" Text="Here you can define what states your leads can have." runat="server" />
                    </td>
                </tr>
            </table>

            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td valign="top" style="width: 170px; padding-top: 4px">
                        <dw:TranslateLabel ID="lbLeadStates" Text="Lead states" runat="server" />
                    </td>
                    <td>
                        <omc:EditableListBox ID="editLeadStates" RequestKey="/Globalsettings/Modules/OMC/LeadStates"
                            SelectedItems="<%$ GS: (System.String[]) /Globalsettings/Modules/OMC/LeadStates  %>" runat="server" />
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <br />

        <dw:GroupBox ID="gbLeadNames" Title="Renamed leads" runat="server">
            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td colspan="2" class="omc-cpl-hint">
                        <dw:TranslateLabel ID="TranslateLabel3" Text="Here you can delete the renamed companies that are shown for the specified ip address in Lead Management tool." runat="server" />
                    </td>
                </tr>
            </table>

            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td colspan="2">
                        <div style="border: 1px solid #6593CF;">
                            <dw:List ID="lstRenamedLeads" runat="server" NoItemsMessage="No renamed leads found" ShowTitle="false" ShowPaging="false">
                                <Columns>
                                    <dw:ListColumn Name="Company" Width="150" runat="server" />
                                    <dw:ListColumn Name="IP Address" Width="85" runat="server" />
                                    <dw:ListColumn Name="Renamed Company" Width="150" runat="server" />
                                    <dw:ListColumn Name="Remove" Width="45" runat="server" ItemAlign="Center" />
                                </Columns>
                            </dw:List>
                        </div>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <br />

        <dw:GroupBox ID="dbSource" Title="Sources / domains" runat="server">
            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td colspan="2" class="omc-cpl-hint">
                        <dw:TranslateLabel ID="TranslateLabel1" Text="Here you can specify sources that can be applied as filter in Lead Management tool." runat="server" />
                    </td>
                </tr>
            </table>

            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td style="width: 170px" valign="top" style="padding-top: 4px">
                        <dw:TranslateLabel ID="TranslateLabel2" Text="Sources" runat="server" />
                    </td>
                    <td>
                        <omc:MasterDetailListBox ID="editLeadSources" RequestKey="LeadSourcesSettings" runat="server" />
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <br />

        <asp:PlaceHolder ID="phLeadTool" runat="server">
            <dw:GroupBox ID="gbLeadTool" Title="Management tool" runat="server">
                <table border="0" cellpadding="2" cellspacing="0">
                    <tr>
                        <td colspan="2" class="omc-cpl-hint">
                            <dw:TranslateLabel ID="lbLeadToolExplanation" Text="Here you can change the parameters that affect the behavior of the Lead Management interface." runat="server" />
                        </td>
                    </tr>
                </table>

                <table border="0" cellpadding="2" cellspacing="0">
                    <tr>
                        <td style="width: 170px">
                            <dw:TranslateLabel ID="lbLeadsListPayload" Text="List payload" runat="server" />
                        </td>
                        <td valign="top">
                            <omc:NumberSelector ID="numLeadsListPayload" RequestKey="/Globalsettings/Modules/OMC/LeadsListPayload"
                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/LeadsListPayload  %>"
                                AllowNegativeValues="false" MinValue="0" MaxValue="100000" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <label for="chkLeadsListKeepTemporarilyApproved">
                                <dw:TranslateLabel ID="lbLeadsListKeepTemporarilyApproved" Text="Disable filtering of temporarily approved leads" runat="server" />
                            </label>
                        </td>
                        <td valign="top">
                            <input type="checkbox" id="chkLeadsListKeepTemporarilyApproved" name="/Globalsettings/Modules/OMC/LeadsListKeepTemporarilyApproved"
                                <%=If(Converter.ToBoolean(SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/OMC/LeadsListKeepTemporarilyApproved")), " checked='checked'", String.Empty)%>value="True" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>

            <br />
        </asp:PlaceHolder>

        <div class="omc-cpl-engagement" style="position: static">
            <dw:GroupBox ID="gbEngagementIndex" Title="Visitor engagement calculation" runat="server">
                <table border="0" cellpadding="2" cellspacing="0">
                    <tr>
                        <td colspan="2" class="omc-cpl-hint">
                            <dw:TranslateLabel ID="lbVisitorEngagementCalculation" Text="Here you can adjust the parameters that are used for calculating visitor engagement." runat="server" />
                        </td>
                    </tr>
                </table>

                <table border="0" cellpadding="2" cellspacing="0">
                    <tr>
                        <td style="width: 170px">
                            <dw:TranslateLabel ID="lbDisable" Text="Disable" runat="server" />
                        </td>
                        <td>
                            <input type="checkbox" id="chkDisable" name="/Globalsettings/Modules/OMC/VisitorEngagement/Disable" onclick="OMC.ControlPanel.getInstance().onEngagementEnabledChanged(!this.checked);"
                                <%=If(Converter.ToBoolean(SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/OMC/VisitorEngagement/Disable")), " checked='checked'", String.Empty)%>value="True" />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 170px">
                            <dw:TranslateLabel ID="lbCalculationTimeFrame" Text="Target time frame (days)" runat="server" />
                        </td>
                        <td>
                            <omc:NumberSelector ID="numTimeFrame" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/TimeFrame"
                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/TimeFrame  %>"
                                AllowNegativeValues="false" MinValue="1" MaxValue="365" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <h4 class="omc-cpl-heading">
                                <dw:TranslateLabel ID="lbClickDepthIndex" Text="Click depth" runat="server" />
                            </h4>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="lbPageviews" Text="Number of pages views" runat="server" />
                        </td>
                        <td>
                            <omc:NumberSelector ID="numPageviews" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/Pageviews"
                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/Pageviews  %>"
                                AllowNegativeValues="false" MinValue="1" MaxValue="5000" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="lbPageviewsPoints" Text="Points earned" runat="server" />
                        </td>
                        <td>
                            <omc:NumberSelector ID="numPageviewsPoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/PageviewsPoints"
                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/PageviewsPoints  %>"
                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <h4 class="omc-cpl-heading">
                                <dw:TranslateLabel ID="lbLoyalty" Text="Loyalty" runat="server" />
                            </h4>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="padding-top: 4px">
                            <dw:TranslateLabel ID="lbNumberOfVisits" Text="Number of visits" runat="server" />
                        </td>
                        <td>
                            <omc:NumberSelector ID="numVisits" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/NumberOfVisits"
                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/NumberOfVisits  %>"
                                AllowNegativeValues="false" MinValue="1" MaxValue="5000" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="lbNumberOfVisitsPoints" Text="Points earned" runat="server" />
                        </td>
                        <td>
                            <omc:NumberSelector ID="numVisitsPoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/NumberOfVisitsPoints"
                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/NumberOfVisitsPoints  %>"
                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <h4 class="omc-cpl-heading">
                                <dw:TranslateLabel ID="lbRecencyIndex" Text="Recency" runat="server" />
                            </h4>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="lbLastVisit" Text="Last visit (days)" runat="server" />
                        </td>
                        <td>
                            <omc:NumberSelector ID="numLastVisit" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/LastVisit"
                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/LastVisit  %>"
                                AllowNegativeValues="false" MinValue="1" MaxValue="365" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="lbLastVisitPoints" Text="Points earned" runat="server" />
                        </td>
                        <td>
                            <omc:NumberSelector ID="numLastVisitPoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/LastVisitPoints"
                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/LastVisitPoints  %>"
                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <h4 class="omc-cpl-heading">
                                <dw:TranslateLabel ID="lbBrandIndex" Text="Branded search" runat="server" />
                            </h4>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="padding-top: 4px">
                            <dw:TranslateLabel ID="lbSearchContains" Text="Search contains" runat="server" />
                        </td>
                        <td>
                            <omc:EditableListBox ID="editSearchContains" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/SearchContains"
                                SelectedItems="<%$ GS: (System.String[]) /Globalsettings/Modules/OMC/VisitorEngagement/SearchContains  %>" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="lbSearchContainsPoints" Text="Points earned" runat="server" />
                        </td>
                        <td>
                            <omc:NumberSelector ID="numSearchContainsPoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/SearchContainsPoints"
                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/SearchContainsPoints  %>"
                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <h4 class="omc-cpl-heading">
                                <dw:TranslateLabel ID="lbInteractions" Text="Interactions" runat="server" />
                            </h4>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="omc-control-panel-grid-container" style="width: 425px">
                                <table class="dwGrid" cellspacing="0" cellpadding="0" border="0" style="border-style: None; width: 100%; border-collapse: collapse; position: static">
                                    <tr class="header">
                                        <th scope="col" style="width: 275px; text-align: left;">
                                            <dw:TranslateLabel ID="lbInteractionType" Text="Interaction type" runat="server" />
                                        </th>
                                        <th scope="col" style="width: 150px; text-align:right;">
                                            <dw:TranslateLabel ID="lbInteractionPointsEarned" Text="Points earned" runat="server" />
                                        </th>
                                    </tr>
                                    <tr class="row actionRow highlightRow">
                                        <td>&nbsp;<dw:TranslateLabel ID="lbInteractionForm" Text="Submit a form" runat="server" />
                                        </td>
                                        <td>
                                            <omc:NumberSelector ID="numInteractionFormPoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/InteractionSubmitForm"
                                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/InteractionSubmitForm  %>"
                                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                                        </td>
                                    </tr>
                                    <tr class="row actionRow highlightRow">
                                        <td>&nbsp;<dw:TranslateLabel ID="lbInteractionOrder" Text="Place an order" runat="server" />
                                        </td>
                                        <td>
                                            <omc:NumberSelector ID="numInteractionOrderPoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/InteractionPlaceOrder"
                                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/InteractionPlaceOrder  %>"
                                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                                        </td>
                                    </tr>
                                    <tr class="row actionRow highlightRow">
                                        <td>&nbsp;<dw:TranslateLabel ID="lbInteractionProduct" Text="View a product" runat="server" />
                                        </td>
                                        <td>
                                            <omc:NumberSelector ID="numInteractionProductPoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/InteractionViewProduct"
                                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/InteractionViewProduct  %>"
                                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                                        </td>
                                    </tr>
                                    <tr class="row actionRow highlightRow">
                                        <td>&nbsp;<dw:TranslateLabel ID="lbInteractionFile" Text="Download a file" runat="server" />
                                        </td>
                                        <td>
                                            <omc:NumberSelector ID="numInteractionFilePoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/InteractionDownloadFile"
                                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/InteractionDownloadFile  %>"
                                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                                        </td>
                                    </tr>
                                    <tr class="row actionRow highlightRow">
                                        <td>&nbsp;<dw:TranslateLabel ID="lbInteractionSearch" Text="Search for content" runat="server" />
                                        </td>
                                        <td>
                                            <omc:NumberSelector ID="numInteractionSearchPoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/InteractionSearch"
                                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/InteractionSearch  %>"
                                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                                        </td>
                                    </tr>
                                    <tr class="row actionRow highlightRow">
                                        <td>&nbsp;<dw:TranslateLabel ID="lbInteractionViewNews" Text="View news item" runat="server" />
                                        </td>
                                        <td>
                                            <omc:NumberSelector ID="numInteractionViewNewsPoints" RequestKey="/Globalsettings/Modules/OMC/VisitorEngagement/InteractionViewNews"
                                                SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/VisitorEngagement/InteractionViewNews  %>"
                                                AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </div>

        <br />

        <dw:GroupBoxStart runat="server" ID="EmailDefaultSettings" doTranslation="true" Title="Default email settings" ToolTip="Default email settings" />
        <table cellpadding="2" cellspacing="0">
            <tr>
                <td style="width: 170px" id="Td1">
                    <dw:TranslateLabel ID="lbFromName" runat="server" Text="From name" />
                </td>
                <td>
                    <input type="text" id="LeadsEmailFromName" class="std" name="/Globalsettings/Modules/OMC/LeadsEmailDefaultSettings/FromName"
                        value="<%=SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/OMC/LeadsEmailDefaultSettings/FromName")%>" />
                </td>
            </tr>
            <tr>
                <td style="width: 170px" id="Td2">
                    <dw:TranslateLabel ID="lbFromEMail" runat="server" Text="From Mail" />
                </td>
                <td>
                    <input type="text" id="LeadsEmailFromEmail" class="std" name="/Globalsettings/Modules/OMC/LeadsEmailDefaultSettings/FromEmail"
                        value="<%=SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/OMC/LeadsEmailDefaultSettings/FromEmail")%>" />
                </td>
            </tr>
            <tr>
                <td style="width: 170px" id="Td3">
                    <dw:TranslateLabel ID="lbSubject" runat="server" Text="Subject" />
                </td>
                <td>
                    <input type="text" id="LeadsEmailSubject" class="std" name="/Globalsettings/Modules/OMC/LeadsEmailDefaultSettings/Subject"
                        value="<%=SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/OMC/LeadsEmailDefaultSettings/Subject")%>" />
                </td>
            </tr>
            <tr>
                <td style="width: 170px" id="Td4">
                    <dw:TranslateLabel ID="LeadsEmailLeadState" runat="server" Text="Lead state after sending" />
                </td>
                <td>
                    <select id="DefaultLeadsStateSelector" class="std" name="/Globalsettings/Modules/OMC/LeadsEmailDefaultSettings/LeadState" style="width: 255px;">
                        <asp:Literal ID="DefaultLeadsStates" runat="server"></asp:Literal>
                    </select>
                </td>
            </tr>
        </table>
        <dw:GroupBoxEnd runat="server" ID="GroupBoxEnd1" />

        <br />
        <br />

    </div>
    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True"></dw:Overlay>
    <script type="text/javascript">
        <asp:Literal id="litScript" runat="server" />

        function showWait(){
            var o = new overlay('wait');
            o.show();
        }

        function deleteRenamedLead(id, confirmMsg){
            if(confirm(confirmMsg)){
                var url = "/Admin/Module/OMC/Management/Leads.aspx?removeLead=true&id=" + id;
                document.getElementById("MainForm").action = url;
                document.getElementById("MainForm").submit();
            }            
        }
    </script>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:Content>
