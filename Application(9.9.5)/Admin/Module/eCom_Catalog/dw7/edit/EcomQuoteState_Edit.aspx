<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomQuoteState_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomQuoteStateEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" >
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        });

        function saveState(close) {
            if (!validateSenderEmail()) { return; }

            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }

        function validateSenderEmail() {
            var senderEmail = document.getElementById('SenderMail');
            if (!validateEmailAddress(senderEmail.value)) {
                dwGlobal.showControlErrors(senderEmail, '<%=Translate.JsTranslate("Please use correct email format")%>');
                senderEmail.focus();
                return false;
            }
            return true;
        }

        function validateEmailAddress(address) {
            var regExp = /^[\w\-_]+(\.[\w\-_]+)*@[\w\-_]+(\.[\w\-_]+)*\.[a-z]{2,4}$/i;
            return address == '' || regExp.test(address);
        }

        function toggleCustomRecipienField() {
            var isSendToFieldChecked = document.getElementById('SendToField').checked;
            var customFieldRow = document.getElementById('CustomRecipientFieldRow');
            if (isSendToFieldChecked) {
                customFieldRow.classList.remove("hidden");
            } else {
                customFieldRow.classList.add("hidden");
            }
        }

        document.addEventListener("DOMContentLoaded", () => {
            toggleCustomRecipienField();
        });
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            
            <dw:Infobar Visible="false" ID="deleteStateInfoBar" runat="server"></dw:Infobar>
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID='tLabelName' runat='server' Text='Navn' />
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="NewUIinput" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelDescr" runat="server" Text="Beskrivelse" />
                        </td>
                        <td>
                            <asp:TextBox ID="DescrStr" CssClass="NewUIinput" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errDescrStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="IsDefault" runat="server" Label="Default" />
                            <dw:CheckBox ID="IsDefaultTmp" runat="server" Label="Default" AttributesParm="disabled" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="AllowOrder" runat="server" Label="Allow order" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="AllowEdit" runat="server" Label="Allow edit" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="DontUseInstatistics" runat="server" Label="Udelad fra statistik" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>                                 
            <dwc:GroupBox runat="server" Title="Notification">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Subject" />
                        </td>
                        <td>
                            <asp:TextBox ID="MailSubject" CssClass="NewUIinput" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="E-mail template" />
                        </td>
                        <td>
                            <dw:FileManager runat="server" ID="NotificationTemplate" Folder="Templates/eCom/Order/"
                                FullPath="True"></dw:FileManager>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Sender name" />
                        </td>
                        <td>
                            <asp:TextBox ID="SenderName" CssClass="NewUIinput" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Sender e-mail" />
                        </td>
                        <td>
                            <dwc:InputText ID="SenderMail" runat="server" ValidationMessage="" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="SendToDeliveryEmail" runat="server"  />
                            <label for="SendToDeliveryEmail">
                                <dw:TranslateLabel runat="server" Text="Send to shipping email" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="SendToField" runat="server" OnClick="toggleCustomRecipienField()" />
                            <label for="SendToField">
                                <dw:TranslateLabel runat="server" Text="Send to order field email" />
                            </label>
                        </td>
                    </tr>
                    <tr id="CustomRecipientFieldRow">
                        <td>
                            <dw:TranslateLabel runat="server" Text="Order field for email" />
                        </td>
                        <td>
                            <dw:GroupDropDownList runat="server" id="CustomRecipientFields" CssClass="std"></dw:GroupDropDownList>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="State rules">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Quotes can move to this state from" />
                        </td>
                        <td>
                            <div class="form-group">
                                <asp:Literal ID="ltQuotesFromStatesList" runat="server"></asp:Literal>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Quotes can move from this state to" />
                        </td>
                        <td>
                            <div class="form-group">
                                <asp:Literal ID="ltQuotesToStatesList" runat="server"></asp:Literal>
                            </div>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none;" runat="server" />
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server" />
        </form>
    </div>
    <asp:Literal ID="removeDelete" runat="server" />
    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        activateValidation('Form1');
    </script>
</body>
</html>