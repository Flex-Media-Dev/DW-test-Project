<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Content/Management/EntryContent2.Master" CodeBehind="SplitTests.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.SplitTests" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%=Dynamicweb.SystemTools.Gui.WriteFolderManagerScript()%>

     <script type="text/javascript">
         var page = SettingsPage.getInstance();

         page.onSave = function () {
             getSplitTestsIDs();
            <%HttpContext.Current.Session.Remove("OMC.SplitTestIDs") %>
             document.frmGlobalSettings.submit();
         }

         function showSplitTestsList() {
             dialog.show('SelectSplitTestsDialog', "/Admin/Module/OMC/Management/SplitTestsList.aspx");
         }

        function getSplitTestsIDs() {
            var ifr = document.getElementById('SelectSplitTestsDialogFrame');
            var ifrDoc = ifr.contentDocument || ifr.contentWindow.document;
            var theForm = ifrDoc.getElementById( 'listForm' );

            if(theForm!= null){
                var expIDs = ""
                for(var i=0; i < theForm.length; i++ ){
                     if(theForm[i].type == 'checkbox' && theForm[i].checked == true){
                         if(theForm[i].parentNode.parentNode.getAttributeNode('itemId') != null){
                           expIDs = expIDs + theForm[i].parentNode.parentNode.getAttributeNode('itemId').value + ",";
                         }
                     }
                }
                document.getElementById("/Globalsettings/Modules/OMC/Notifications/SplitTestsDefinitions").value = expIDs ;
            }
         }
    </script>

</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div id="PageContent" class="omc-control-panel">
        <dw:GroupBox ID="gbExportedSplitTestsEmailNotifications" Title="E-mail notifications - Split tests" runat="server">
             <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td colspan="2" class="omc-cpl-hint">
                        <dw:TranslateLabel ID="lbExportedSplitTestsEmailNotifications" Text="Here you can define when to send email notifications containing split tests report data." runat="server" />
                    </td>
                </tr>
            </table>

            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="lbSendEvery" Text="Send interval (days)" runat="server" />
                    </td>
                    <td>
                        <omc:NumberSelector ID="numSplitTestsSendInterval" RequestKey="/Globalsettings/Modules/OMC/Notifications/SplitTestsSendInterval"
                            SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/Notifications/SplitTestsSendInterval  %>" 
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
                                <omc:NumberSelector ID="numSplitTestsSendFrameFrom" RequestKey="/Globalsettings/Modules/OMC/Notifications/SplitTestsSendFrom"
                                    SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/Notifications/SplitTestsSendFrom  %>" 
                                    AllowNegativeValues="false" MinValue="1" MaxValue="24" runat="server" />
                            </div>

                            <div class="omc-cpl-numrange-separator">
                                <dw:TranslateLabel ID="lbAnd" Text="and" runat="server" />
                            </div>

                            <div class="omc-cpl-numrange-selector">
                                <omc:NumberSelector ID="numSplitTestsSendFrameTo" RequestKey="/Globalsettings/Modules/OMC/Notifications/SplitTestsSendTo"
                                    SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/Notifications/SplitTestsSendTo  %>" 
                                    AllowNegativeValues="false" MinValue="1" MaxValue="24" runat="server" />
                            </div>

                            <div class="omc-clear"></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel ID="SendCR" Text="Send email if improvement exceeded " runat="server" />
                    </td>
                    <td>
                        <div class="omc-cpl-numrange">
                            <div class="omc-cpl-numrange-selector">
                                <omc:NumberSelector ID="numSplitTestsSendCRThreshold" RequestKey="/Globalsettings/Modules/OMC/Notifications/SplitTestsSendImprovementLimit"
                                    SelectedValue="<%$ GS: (System.Int32) /Globalsettings/Modules/OMC/Notifications/SplitTestsSendImprovementLimit%>" 
                                    AllowNegativeValues="false" MinValue="1" MaxValue="100" runat="server" />
                            </div>
                             <div class="omc-cpl-numrange-separator">
                                <dw:TranslateLabel ID="TranslateLabel1" Text="(%)" runat="server" />  
                            </div>
                        </div>
                    </td>
                </tr>
            </table>

            
            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td colspan="2" class="omc-cpl-hint" style="padding-top: 20px">
                        <dw:TranslateLabel ID="lbSplitTestsRecipients" Text="Here you can specify whom to send notifications and what notification scheme to use." runat="server" />
                    </td>
                </tr>
            </table>

            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="lbScheme" Text="Scheme" runat="server" />
                    </td>
                    <td>
                        <asp:Literal ID="litNotificationProfile" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="padding-top: 4px">
                        <dw:TranslateLabel ID="lbRecipients" Text="Recipients" runat="server" />
                    </td>
                    <td>
                        <omc:EditableListBox id="editRecipients" RequestKey="/Globalsettings/Modules/OMC/Notifications/SplitTestsRecipients"
                            SelectedItems="<%$ GS: (System.String[]) /Globalsettings/Modules/OMC/Notifications/SplitTestsRecipients  %>" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 170px">
                        <dw:TranslateLabel ID="lbReports" Text="Reports to send" runat="server" />
                    </td>
                    <td>
                        <div class="omc-reports-field">
                            <input type="button" id="cmdSelectReports" class="newUIbutton" value="<%=Dynamicweb.SystemTools.Translate.Translate("Select reports")%>" onclick="showSplitTestsList();"/>

                            <dw:Dialog ID="SelectSplitTestsDialog" Title="Select split test reports" TranslateTitle="true" Width="850" runat="server">
                                <iframe id="SelectSplitTestsDialogFrame" frameborder="0"></iframe>
                            </dw:Dialog>
                            <input type="hidden" name="/Globalsettings/Modules/OMC/Notifications/SplitTestsDefinitions"  id="/Globalsettings/Modules/OMC/Notifications/SplitTestsDefinitions" value="<%=Dynamicweb.Core.Converter.ToString(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/OMC/Notifications/SplitTestsDefinitions")) %>"/>
                        <div class="omc-reports-field">
                    </td>
                </tr>
            </table>

            </dw:GroupBox>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:Content>
