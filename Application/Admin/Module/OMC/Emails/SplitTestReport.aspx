<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/EntryContent.Master" CodeBehind="SplitTestReport.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.SplitTestReport" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls.Charts" Assembly="Dynamicweb.Controls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function showSelectWinnerDialog()
        {
            if(document.getElementById('reportWinnerScheduled').value == 'true')
            {
                if(!confirm('<%=Translate.JsTranslate("This split test was scheduled. Are you sure you want to select winner manually?")%>'))
                {
                    return;
                }
            }

            dialog.show('SelectWinnerDialog');
        }

        function showUniqueLinks()
        {
            if(document.getElementById("MsgLinks2").checked)
            {
                document.getElementById("UniqueLinksDiv").style.display = "none";
                document.getElementById("TotalLinksDiv").style.display = "block";
            }
            else
            {
                document.getElementById("UniqueLinksDiv").style.display = "block";
                document.getElementById("TotalLinksDiv").style.display = "none";
            }
        }

        function showVarUniqueLinks()
        {
            if(document.getElementById("VarMsgLinks2").checked)
            {
                document.getElementById("VarUniqueLinksDiv").style.display = "none";
                document.getElementById("VarTotalLinksDiv").style.display = "block";
            }
            else
            {
                document.getElementById("VarUniqueLinksDiv").style.display = "block";
                document.getElementById("VarTotalLinksDiv").style.display = "none";
            }
        }

        function showScheduleDate(box)
        {
            if(!document.getElementById("StartDate2").checked)
            {
                document.getElementById("ScheduleDateSelectorDiv").style.display = "none";
            } else
            {
                document.getElementById("ScheduleDateSelectorDiv").style.display = "";
            }
        }

        function getScheduledDate()
        {            
            var scheduledDate = "";
            if ($('<%=dsStartDate.UniqueID%>_calendar') && Dynamicweb && Dynamicweb.UIControls && Dynamicweb.UIControls.DatePicker) {
                scheduledDate = Dynamicweb.UIControls.DatePicker.get_current().GetDate('<%=dsStartDate.UniqueID%>');
            }
            return scheduledDate;
        }

        function getConfirmText()
        {
            var confirmText = '';
            if(!document.getElementById("StartDate2").checked)
            {
                confirmText = '<%= Translate.JsTranslate("The e-mail %% will now be sent to the specified recipients. Do you want to continue?")%>';
            } else
            {
                confirmText = '<%= Translate.JsTranslate("The sending of e-mail %% will be scheduled for ")%>' + getScheduledDate() + '<%=Translate.JsTranslate(". Do you want to continue?")%>';
            }

            if ($("WinnerMessage1").checked) {
                if($('reportNewsletterName'))
                {
                    confirmText = confirmText.replace('%%', $('reportNewsletterName').value);
                } else
                {
                    confirmText = confirmText.replace('%%', '');
                }
            } else if ($("WinnerMessage2").checked) {
                if ($('reportNewsletterVariantName')) {
                    confirmText = confirmText.replace('%%', $('reportNewsletterVariantName').value);
                } else {
                    confirmText = confirmText.replace('%%', '');
                }
            }


            return confirmText;
        }

        function showSpiningWheel()
        {
            dialog.hide('SelectWinnerDialog');
            var o = new overlay('sendWinner');
            o.show();
        }
    </script>

    <div class="content-main">
        <dw:Overlay ID="sendWinner" runat="server"></dw:Overlay>
        <dw:RoundedFrame ID="frmSplitTestChart" Width="990" runat="server" CanCollapse="true">
            <div class="split-test-report-info">
                <h3>
                    <dw:TranslateLabel ID="labelConversionGoal" Text="" runat="server" />
                </h3>
                <dw:Chart ID="cSplitTestChart" Type="Line" Width="965" Height="200" GridlineColor="#e1e1e1" PointSize="4" Legend="none" AutoDraw="true" runat="server" />

                <h3>
                    <dw:TranslateLabel ID="lbLegend" Text="Legend" runat="server" />
                </h3>
                <ul class="split-test-report-legend">
                    <li>
                        <div class="split-test-report-legend-item" id="legendOriginal" runat="server" />
                        &nbsp;<dw:TranslateLabel ID="TranslateLabel3" Text="Original" runat="server" />
                    </li>
                    <li>
                        <div class="split-test-report-legend-item" id="legendVariant" runat="server" />
                        &nbsp;<dw:TranslateLabel ID="TranslateLabel6" Text="Variation" runat="server" />
                    </li>
                </ul>
            </div>
        </dw:RoundedFrame>

        <div class="split-test-report-separator"></div>

        <div class="split-test-report-split">
            <div class="split-test-report-left">
                <dw:RoundedFrame ID="frmCommomConv" Width="440" runat="server">
                    <asp:Panel ID="pList" runat="server">
                        <asp:Repeater ID="repCommomConv" runat="server">
                            <HeaderTemplate>
                                <table class="split-test-report-most-visits" cellspacing="2" cellpadding="2" border="0">
                                    <tr>
                                        <th class="split-test-report-page-name">
                                            <dw:TranslateLabel ID="lbConvertion" Text="Conversion" runat="server" />
                                        </th>
                                        <th class="split-test-report-page-name">
                                            <dw:TranslateLabel ID="TranslateLabel1" Text="Original" runat="server" />
                                        </th>
                                        <th class="split-test-report-page-name">
                                            <dw:TranslateLabel ID="TranslateLabel14" Text="Variation" runat="server" />
                                        </th>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Conversion")%></td>
                                    <td><%# Eval("OriginalConversions")%></td>
                                    <td><%# Eval("VariationConversions")%></td>
                                </tr>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <tr class="split-test-report-row-alternative">
                                    <td><%# Eval("Conversion")%></td>
                                    <td><%# Eval("OriginalConversions")%></td>
                                    <td><%# Eval("VariationConversions")%></td>
                                </tr>
                            </AlternatingItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </asp:Panel>
                    <asp:Panel ID="Panel3" runat="server">
                        <input id="btnSelectWinner" class="buttonSubmit" <%=If(Not IsSelectWinnerDisabled(), String.Empty, "disabled")%> onclick="showSelectWinnerDialog();" value="<%=Translate.Translate("Select a winner")%>" type="button" style="float: right; margin-left: 5px; margin-top: 10px;" />
                    </asp:Panel>
                </dw:RoundedFrame>
            </div>

            <div class="split-test-report-middle">
                <dw:RoundedFrame ID="frmSplitTestSettings" runat="server">
                    <asp:Panel ID="Panel4" runat="server">
                        <asp:Repeater ID="repSplitTestSettings" runat="server">
                            <HeaderTemplate>
                                <div style="height: 371px; overflow: auto;">
                                    <table class="split-test-report-most-visits" cellspacing="2" cellpadding="2" border="0" width="420">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Setting")%></td>
                                    <td><%# Eval("Value")%></td>
                                </tr>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <tr class="split-test-report-row-alternative">
                                    <td><%# Eval("Setting")%></td>
                                    <td><%# Eval("Value")%></td>
                                </tr>
                            </AlternatingItemTemplate>
                            <FooterTemplate>
                                </table>
                                    </div>
                            </FooterTemplate>
                        </asp:Repeater>
                    </asp:Panel>
                </dw:RoundedFrame>
            </div>
        </div>

        <div class="dashboard-clear"></div>
        <div class="dashboard-separator"></div>

        <div class="dashboard-split">
            <div class="dashboard-left" style="width: 495px;">
                <dw:RoundedFrame ID="frmOriginalLinks" Width="495" Height="320" runat="server">
                    <div class="dashboard-info" style="height: 250px">
                        <label>
                            <dw:RadioButton ID="rbUniqueLinks" runat="server" FieldName="MsgLinks" FieldValue="1" OnClientClick="showUniqueLinks();" />
                            <dw:TranslateLabel ID="TranslateLabel91" Text="Unique clicks" runat="server" />
                        </label>

                        <label>
                            <dw:RadioButton ID="rbTotalLinks" runat="server" FieldName="MsgLinks" FieldValue="2" OnClientClick="showUniqueLinks();" />
                            <dw:TranslateLabel ID="TranslateLabel92" Text="Total clicks" runat="server" />
                        </label>
                        <br />

                        <div class="omc-control-panel-grid-container" style="border-style: None; width: 440px;" id="originalLinkDiv" runat="server">
                            <div id="UniqueLinksDiv" style="overflow: hidden;">
                                <dw:List runat="server" ID="uniqueLinksList" ShowHeader="false" ShowPaging="False" ShowTitle="false" PageSize="25" Height="220">
                                    <Columns>
                                        <dw:ListColumn runat="server" ID="clmUniqueLinkUrl" WidthPercent="90" />
                                        <dw:ListColumn runat="server" ID="clmUniqueLinkClicks" WidthPercent="10" />
                                    </Columns>
                                </dw:List>
                            </div>
                            <div id="TotalLinksDiv" style="overflow: hidden;">
                                <dw:List runat="server" ID="totalLinksList" ShowHeader="false" ShowPaging="False" ShowTitle="false" PageSize="25" Height="220">
                                    <Columns>
                                        <dw:ListColumn runat="server" ID="clmTotalLinkUrl" WidthPercent="90" />
                                        <dw:ListColumn runat="server" ID="clmTotalLinkClicks" WidthPercent="10" />
                                    </Columns>
                                </dw:List>
                            </div>
                        </div>
                    </div>
                </dw:RoundedFrame>
            </div>

            <div class="dashboard-right" style="width: 495px;">
                <dw:RoundedFrame ID="frmVariantLinks" Width="495" Height="320" runat="server">
                    <div class="dashboard-info" style="height: 250px">
                        <label>
                            <dw:RadioButton ID="rbVarUniqueLinks" runat="server" FieldName="VarMsgLinks" FieldValue="1" OnClientClick="showVarUniqueLinks();" />
                            <dw:TranslateLabel ID="TranslateLabel93" Text="Unique clicks" runat="server" />
                        </label>

                        <label>
                            <dw:RadioButton ID="rbVarTotalLinks" runat="server" FieldName="VarMsgLinks" FieldValue="2" OnClientClick="showVarUniqueLinks();" />
                            <dw:TranslateLabel ID="TranslateLabel94" Text="Total clicks" runat="server" />
                        </label>
                        <br />

                        <div class="omc-control-panel-grid-container" style="border-style: None; width: 440px;" id="variantLinkDiv" runat="server">
                            <div id="VarUniqueLinksDiv" style="overflow: hidden;">
                                <dw:List runat="server" ID="VaruniqueLinksList" ShowHeader="false" ShowPaging="False" ShowTitle="false" PageSize="25" Height="220">
                                    <Columns>
                                        <dw:ListColumn runat="server" ID="clmVarUniqueLinkUrl" WidthPercent="90" />
                                        <dw:ListColumn runat="server" ID="clmVarUniqueLinkClicks" WidthPercent="10" />
                                    </Columns>
                                </dw:List>
                            </div>
                            <div id="VarTotalLinksDiv" style="overflow: hidden;">
                                <dw:List runat="server" ID="VartotalLinksList" ShowHeader="false" ShowPaging="False" ShowTitle="false" PageSize="25" Height="220">
                                    <Columns>
                                        <dw:ListColumn runat="server" ID="clmVarTotalLinkUrl" WidthPercent="90" />
                                        <dw:ListColumn runat="server" ID="clmVarTotalLinkClicks" WidthPercent="10" />
                                    </Columns>
                                </dw:List>
                            </div>
                        </div>
                    </div>
                </dw:RoundedFrame>
            </div>
        </div>
    </div>
   
    <br />
    <dw:Dialog runat="server" ID="SelectWinnerDialog" Width="406" Title="Select a winner" ShowClose="true" HidePadding="true">
        <style type="text/css">
            #SelectWinnerDiv table.tabTable, #SelectWinnerDiv fieldset
            {
                display: block;
                width: 360px;
            }
        </style>
        <div id="SelectWinnerDiv" class="content-main">
            <dw:GroupBox ID="GroupBoxSelectWinner" runat="server" DoTranslation="True" Title="Select the winner">
                <table>
                    <tr>
                        <td>
                            <dw:RadioButton ID="rbOriginal" runat="server" FieldName="WinnerMessage" FieldValue="1" />
                            <dw:TranslateLabel ID="TranslateLabel4" Text="Original" runat="server" />
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:RadioButton ID="rbVariant" runat="server" FieldName="WinnerMessage" FieldValue="2" />
                            <dw:TranslateLabel ID="TranslateLabel5" Text="Variation" runat="server" />
                            <br />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>

            <dw:GroupBox ID="GroupBoxStart" runat="server" DoTranslation="True" Title="Send the winner e-mail">
                <table>
                    <tr>
                        <td>
                            <dw:RadioButton ID="rbSendNow" runat="server" FieldName="StartDate" FieldValue="1" OnClientClick="showScheduleDate(this);" />
                            <dw:TranslateLabel ID="TranslateLabel9" Text="Send now" runat="server" />
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:RadioButton ID="rbScheduledSend" runat="server" FieldName="StartDate" FieldValue="2" OnClientClick="showScheduleDate(this);" />
                            <dw:TranslateLabel ID="TranslateLabel10" Text="Scheduled send" runat="server" />
                            <br />
                        </td>
                    </tr>
                    <tr id="ScheduleDateSelectorDiv" style="display: none;">
                        <td>
                            <table border="0">
                                <tr>
                                    <td style="padding-top: 5px">
                                        <dw:TranslateLabel ID="TranslateLabel22" Text="Send e-mail at:" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 5px;">
                                        <dw:DateSelector ID="dsStartDate" runat="server" IncludeTime="True" Width="350" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 5px;">
                                        <asp:DropDownList runat="server" ID="ScheduledSendTimeZone" DataTextField="Text" DataValueField="Value" Style="width: 350px;" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button runat="server" ID="SendButton" CssClass="buttonSubmit" Style="float: right;" OnClientClick="if(!confirm(getConfirmText())){return false;}else{showSpiningWheel();}" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </div>
    </dw:Dialog>

    <input type="hidden" runat="server" id="reportNewsletterId" name="reportNewsletterId" value="" />
    <input type="hidden" runat="server" id="reportNewsletterName" name="reportNewsletterName" value="" clientidmode="Static" />
    <input type="hidden" runat="server" id="reportNewsletterVariantName" name="reportNewsletterVariantName" value="" clientidmode="Static" />
    <input type="hidden" runat="server" id="reportWinnerScheduled" name="reportWinnerScheduled" value="false" clientidmode="Static" />

    <script type="text/javascript">
        document.observe("dom:loaded", function()
        {
            //setTimeout(function () { showUniqueLinks(); }, 200);
            showUniqueLinks();
            showVarUniqueLinks();
        });
    </script>

</asp:Content>
