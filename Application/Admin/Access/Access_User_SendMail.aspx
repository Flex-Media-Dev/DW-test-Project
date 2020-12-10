<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<%@ Page CodeBehind="Access_User_SendMail.aspx.vb" Language="vb" ValidateRequest="false" AutoEventWireup="false" Inherits="Dynamicweb.Admin.Access_User_SendMail" CodePage="65001" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title><%=Translate.JsTranslate("Send %%", "%%", Translate.JsTranslate("brugeroplysninger"))%></title>
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="Cache-control" content="no-cache">
    <meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="Expires" content="Tue, 20 Aug 1996 14:25:27 GMT">

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="False" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var isRecoveryMode = "<%=IsRecoveryMode%>" === "True";

        function IsValidEmail(email) {
            var regExp = /^[\w\-_]+(\.[\w\-_]+)*@[\w\-_]+(\.[\w\-_]+)*\.[a-z]{2,4}$/i;
            return regExp.test(email);
        }

        function SendMailStep(submitForm) {
            var valid = true;
            var subjectControl = document.forms[0].elements["MailTemplateSubject"];
            if (subjectControl != null && subjectControl.value == "") {
                dwGlobal.showControlErrors("MailTemplateSubjectInput", "<%=Translate.JsTranslate("required")%>");
                valid = false;
            } else {
                dwGlobal.hideControlErrors("MailTemplateSubjectInput");
            }

            if (!IsValidEmail(document.forms[0].MailTemplateFromEmail.value)) {
                dwGlobal.showControlErrors("MailTemplateFromEmailInput", "<%=Translate.JsTranslate("required")%>");
                valid = false;
            } else {
                dwGlobal.hideControlErrors("MailTemplateFromEmailInput");
            }

            var MailTemplateElem = document.getElementById("FM_MailTemplateFile");
            var formGroup = MailTemplateElem.closest(".form-group");
            if (MailTemplateElem.value == "") {
                formGroup.classList.add("has-error");
                $("helpMailTemplate").innerText = "<%=Translate.JsTranslate("required")%>";
                $("helpMailTemplate").style.display = "block";
                valid = false;
            } else {
                formGroup.classList.remove("has-error");
                $("helpMailTemplate").style.display = "none";
            }

            if (isRecoveryMode) {
                var mailPage = document.getElementById("RecoveryPage");
                var pageId = parseInt(mailPage.value.split("=")[1]);
                var formGroup = mailPage.closest(".form-group");
                if (pageId == 0 || isNaN(pageId)) {
                    formGroup.classList.add("has-error");
                    $("helpMailPage").innerText = "<%=Translate.JsTranslate("required")%>";
                    $("helpMailPage").style.display = "block";
                    valid = false;
                } else {
                    formGroup.classList.remove("has-error");
                    $("helpMailPage").style.display = "none";
                }
            }

            if (!valid) {
                return false;
            }

            if (submitForm == true) {
                document.forms[0].action = '';
                document.forms[0].submit();
            } else {
                document.location.href = "Access_User_SendMail.aspx?UserID=<%=UserIdReq%>" + isRecoveryMode ? "&MailMode=recovery" : "";
            }
        }

        function disableSelectors(setting) {
            document.getElementById('FM_MailTemplateFile').disabled = setting;
            document.getElementById('MailTemplateEncoding').disabled = setting;
        }

        function checkDomain() {
            var mailPage = document.getElementById("RecoveryPage");
            var domainSelector = document.getElementById("RecoveryPageDomain");
            var pageId = parseInt(mailPage.value.split("=")[1]);
            var selectedDomain = domainSelector[domainSelector.selectedIndex].value;

            if (pageId > 0) {
                new Ajax.Request("Access_User_SendMail.aspx?CMD=CheckPrimaryDomain&SelectedDomain=" + selectedDomain + "&PageId=" + pageId, {
                    onSuccess: function (response) {
                        if (response.responseText.length > 0) {
                            dwGlobal.showControlErrors("helpRecoveryPageDomain", response.responseText);
                        } else {
                            dwGlobal.hideControlErrors("helpRecoveryPageDomain", response.responseText);
                        }
                    }
                });
            } else {
                dwGlobal.showControlErrors("helpRecoveryPageDomain", "<%=Translate.Translate("Select a page")%>");
            }
        }

        document.observe("dom:loaded", function () {
            var small = document.createElement("small");
            small.id = "helpMailTemplate";
            small.className = "help-block error left-indent";
            var fileManager = $("FM_MailTemplateFile");
            var fmContainer = fileManager.closest(".filemanager").parentElement;
            fmContainer.appendChild(small);
        })
    </script>
</head>
<body>
    <dwc:DialogLayout runat="server" ID="MainLayout" HidePadding="true">
        <Content>
            <div class="col-md-0 boxed-fields">
                <dw:Infobar ID="NotValidEmailInfo" runat="server" Type="Error" Message="User email not valid" />
                <dw:Infobar ID="RecipientsCount" runat="server" Type="Information" Message="" />
                <dw:GroupBox runat="server">
                    <dwc:InputText runat="server" ID="MailTemplateSubjectInput" Name="MailTemplateSubject" Label="Subject" ValidationMessage="" />
                    <dwc:InputText runat="server" ID="MailTemplateFromNameInput" Name="MailTemplateFromName" Label="Sender name" />
                    <dwc:InputText runat="server" ID="MailTemplateFromEmailInput" Name="MailTemplateFromEmail" Label="Sender e-mail" ValidationMessage="" />
                    <div class="form-group">
                        <dw:TranslateLabel UseLabel="true" Text="Encoding" runat="server" />
                        <div class="form-group-input">
                            <%=Gui.EncodingList(MailTemplateEncoding, "MailTemplateEncoding", True, False)%>
                        </div>
                    </div>

                    <dw:FileManager ID="MailTemplateFile" Folder="Templates/ExtranetExtended" Label="Template" runat="server" />

                    <%if IsRecoveryMode Then%>

                    <div class="form-group">
                        <dw:TranslateLabel UseLabel="true" Text="Page" runat="server" />
                        <div class="form-group-input">
                            <dw:LinkManager ID="RecoveryPage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" CssClass="std field-name" ClientAfterSelectCallback="checkDomain" />
                            <small class="help-block error" id="helpMailPage"></small>
                        </div>
                    </div>

                    <dwc:SelectPicker Label="Domain" ID="RecoveryPageDomain" ValidationMessage="" ClientIDMode="Static" runat="server"></dwc:SelectPicker>

                    <%End If%>

                    <dwc:CheckBox runat="server" ID="ForceAsync" Label="Send in background" />
                </dw:GroupBox>
            </div>
        </Content>
        <Footer>
            <button type="button" runat="server" id="SendButton" class="dialog-button-ok btn btn-clean" onclick="SendMailStep(true)">
                <dw:TranslateLabel Text="Send" runat="server" />
            </button>
            <button type="button" class="dialog-button-ok btn btn-clean" onclick="Action.Execute({'Name':'Cancel'})">
                <dw:TranslateLabel Text="Cancel" runat="server" />
            </button>
        </Footer>
    </dwc:DialogLayout>
</body>
</html>
