<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SetupSplitTest.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.SetupSplitTest" ClientIDMode="Static" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="false">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <title>Setup split test</title>
    <style>
        .full-width > .ajax-rich-control {
            width: 100% !important;
        }
    </style>

    <script type="text/javascript">
        function initialize() {
            showScheduleDate();
            EndTestTypeChanged();
            document.getElementById("EndTestType").addEventListener("change", EndTestTypeChanged);

            document.getElementById("txtRecipients").addEventListener("change", function () {
                validateInputs("txtRecipients")
            });
            document.getElementById("lstRecipients").addEventListener("change", function () {
                validateRecipientsNumber('txtRecipients', 'lstRecipients');
            });

            document.getElementById("txtAmountOfOpened").addEventListener("change", function () {
                validateInputs("txtAmountOfOpened")
            });
            document.getElementById("lstStopRecipients").addEventListener("change", function () {
                validateRecipientsNumber('txtAmountOfOpened', 'lstStopRecipients');
            });
        }

        function EndTestTypeChanged() {
            var el = document.getElementById("EndTestType");
            var selectedVal = el.value;
            for (var i = 0; i < el.length; i++) {
                var opt = el.options[i];
                var optionSettingsEl = document.getElementById("EndTestType" + opt.value);
                if (optionSettingsEl) {
                    optionSettingsEl.style.display = selectedVal == opt.value ? "" : "none";
                }
            }
            showAfterPickingWinner(el);
        }

        function showAfterPickingWinner(box) {
            if (box.value != "4") {
                document.getElementById("AfterPickingWinner").style.display = "";
            }
            else {
                document.getElementById("AfterPickingWinner").style.display = "none";
            }
        }

        function submitSplitTest() {
            var frm = document.forms[0];
            frm.request({
                method: 'post',
                parameters: { ValidateEndTime: true },
                onSuccess: function (transport) {
                    if (transport.responseText.length > 0) {
                        alert(transport.responseText);
                    } else {
                        if (confirm('<%= Dynamicweb.SystemTools.Translate.Translate("This will start the split test. Do you wish to continue?")%>')) {
                            document.getElementById("cmdSave").value = "saveSplitTest";
                            frm.submit();
                        } else {
                            return false;
                        }
                    }
                }
            });
        }

        function validateInputs(elementID) {
            var inputValue = document.getElementById(elementID).value;
            var num = parseInt(inputValue) || 0;
            if (inputValue.length > 0 && num != 0) {
                document.getElementById("SaveExperimentBtn").disabled = false;
                document.getElementById(elementID).value = num;
            } else {
                if (inputValue.length > 0 && num == 0) {
                    document.getElementById(elementID).value = num;
                }
                document.getElementById(elementID).focus();
                document.getElementById("SaveExperimentBtn").disabled = true;
            }

            if (elementID == "txtRecipients") {
                validateRecipientsNumber(elementID, 'lstRecipients');
            } else if (elementID == "txtAmountOfOpened") {
                validateRecipientsNumber(elementID, 'lstStopRecipients');
            }
        }

        function validateRecipientsNumber(elementID, dropDownListID) {
            var inputValue = $(elementID).value;
            var num = parseInt(inputValue) || 0;

            if (document.getElementById(dropDownListID).value == '1' && num != 0 && num > 100) {
                $(elementID).value = 100;
            } else if (document.getElementById(dropDownListID).value == '2' && num != 0) {
                if (num < 0) {
                    $(elementID).value = 0;
                }
            }
            return true;
        }

        function showScheduleDate(box) {
            if (!document.getElementById("StartDate_2").checked) {
                document.getElementById("ScheduleDateSelectorDiv").style.display = "none";
            } else {
                document.getElementById("ScheduleDateSelectorDiv").style.display = "";
            }
        }

        function disableControls() {
            var fieldsetsEls = document.querySelectorAll("#GroupBoxRecipients fieldset, #GroupBoxSettings fieldset, #AfterPickingWinner fieldset");
            var forEach = Array.prototype.forEach;
            forEach.call(fieldsetsEls, function (el) {
                el.setAttribute("disabled", "disabled");
            });
        }
    </script>
</head>

<dwc:DialogLayout runat="server" ID="SplitTestSettings" Size="Medium" Title="Setup split test" HidePadding="True">
    <content>
        <div class="col-md-0">
        <input type="hidden" runat="server" id="cmdSave" name="cmdSave" value=""/>
        <input type="hidden" runat="server" id="spltNewsletterId" name="spltNewsletterId" value=""/> 
        <input type="hidden" runat="server" id="spltNewsletterName" name="spltNewsletterName" value=""/> 
        <input type="hidden" runat="server" id="settingsMode" name="settingsMode" value=""/> 

        <dwc:GroupBox ID="GroupBoxRecipients" runat="server" DoTranslation="True" Title="Test recipients">
            <dwc:InputNumber runat="server" Id="txtRecipients" Name="txtRecipients" Min="1" Label="Amount" />
            <dwc:SelectPicker runat="server" ID="lstRecipients" Name="lstRecipients" Label="Unit">
                <asp:ListItem Selected="True" Text="%" Value="1"></asp:ListItem>
                <asp:ListItem Selected="False" Value="2"></asp:ListItem>
            </dwc:SelectPicker>
        </dwc:GroupBox>

        <dwc:GroupBox ID="GroupBoxGoal" runat="server" DoTranslation="True" Title="Conversion Goal">
            <dwc:RadioGroup runat="server" ID="ConversionGoal" Name="ConversionGoal" Label="Conversion Goal" >
                <dwc:RadioButton FieldValue="bestengagement" Label="Best Engagement" DoTranslation="true" runat="server" />
                <dwc:RadioButton FieldValue="mostopened" Label="Most Opened" DoTranslation="true" runat="server" />
                <dwc:RadioButton FieldValue="mostclicked" Label="Most Clicked" DoTranslation="true" runat="server" />
            </dwc:RadioGroup>
        </dwc:GroupBox>

        <dwc:GroupBox ID="GroupBoxSettings" runat="server" DoTranslation="True" Title="Settings">
            <dwc:RadioGroup runat="server" ID="StartDate" Name="StartDate" Label="Start Test" >
                <dwc:RadioButton FieldValue="1" Label="Start test now" DoTranslation="true" runat="server" OnClick="showScheduleDate(this);" />
                <dwc:RadioButton FieldValue="2" Label="Schedule test" DoTranslation="true" runat="server" OnClick="showScheduleDate(this);" />
            </dwc:RadioGroup>
            <div id="ScheduleDateSelectorDiv" style="display: none;">
                <dw:DateSelector runat="server" ID="dsStartDate" Label="Start" IncludeTime="True" />
                <dwc:SelectPicker runat="server" ID="ScheduledSendTimeZone" Label="&nbsp;"></dwc:SelectPicker>
            </div>
            
            <br />

            <dwc:SelectPicker runat="server" ID="EndTestType" Name="EndTestType" Label="Pick the winner">
                <asp:ListItem Text="After X Hours" Value="1" Selected="True" />
                <asp:ListItem Text="At Given Time" Value="2" />
                <asp:ListItem Text="When X Has Opened" Value="3" />
                <asp:ListItem Text="Manually" Value="4" />
            </dwc:SelectPicker>

            <div id="EndTestType1" style="display:none">
                <dwc:InputNumber runat="server" ID="EndHoursAmount" Min="1" Max="24" Value="1" Label="&nbsp;" />
            </div>
            <div id="EndTestType2" style="display:none">
                <dw:DateSelector ID="sdEndDate" runat="server" IncludeTime="True" Label="&nbsp;" />
                <dwc:SelectPicker runat="server" ID="ScheduledWinnerTimeZone" Label="&nbsp;" />
            </div>
            <div id="EndTestType3" style="display:none">
                <dwc:InputNumber runat="server" Id="txtAmountOfOpened" name="txtAmountOfOpened" Label="Amount" />
                <dwc:SelectPicker runat="server" ID="lstStopRecipients" name="lstStopRecipients" Label="Unit">
                    <asp:ListItem Selected="True" Text="%" Value="1"></asp:ListItem>
                    <asp:ListItem Selected="False" Value="2"></asp:ListItem>
                </dwc:SelectPicker>
            </div>
        </dwc:GroupBox>

        <dwc:GroupBox ID="AfterPickingWinner" runat="server" DoTranslation="True" Title="After picking the winner">
            <dwc:CheckBox ID="chkNotifyEmails" name="NotifyEmails" runat="server" Label="Notify following people:" Indent="true" />
            <div class="form-group">
                <div class="form-group-input left-indent full-width">
                    <omc:EditableListBox id="editNotify" runat="server" />
                </div>
            </div>
        </dwc:GroupBox>
        </div>
    </content>
    <footer>
        <input type="button" class="btn btn-link waves-effect" value="" id="SaveExperimentBtn" runat="server" onclick="submitSplitTest();" />
        <input type="button" class="btn btn-link waves-effect" value="" id="CancelBtn" runat="server" onclick="Action.Execute({ 'Name': 'Cancel' });" />
    </footer>
</dwc:DialogLayout>
</html>
<%
    Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>