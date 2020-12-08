<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BasicForms_Edit.aspx.vb" Inherits="Dynamicweb.Admin.BasicForms_Edit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<dw:ModuleHeader ID="ModuleHeader1" runat="server" ModuleSystemName="BasicForms" />
<dw:ModuleSettings ID="ModuleSettings1" runat="server" ModuleSystemName="BasicForms" Value="FormID, UseTemplate, Template, ReceiptTemplateText, FormSubmitButtonText, MailSubject, MailSender, MailSenderUseUserEmail, MailSenderName, MailReplyto, MailReplytoUseUserEmail, MailRecipient, MailCC, MailBCC, UseMailTemplate, MailTemplate, MailText, ReceiptSubject, ReceiptSenderName, ReceiptSender, ReceiptRecipient, ReceiptCC, ReceiptBCC, UseReceiptTemplate, ReceiptTemplate, ReceiptText, formSubmitAction, formSubmitPageAfterSave, formSubmitConfirmationTemplate, FormMaxSubmitAction, FormMaxSubmitsReachedPage, FormMaxSubmitsReachedTemplate, FormMaxSubmits, FormUploadPath, CreateUserOnSubmit, CreateNewUserGroupsHidden" />

<script type="text/javascript">
    function download() {
        if (document.getElementById("FormID").selectedIndex > 0) {
            var formid = document.getElementById("FormID").options[document.getElementById("FormID").selectedIndex].value
            var pageID = 0;
            if (document.getElementById("FormMaxSubmits").value.length > 0) {
                pageID = <%=Request.QueryString("PageId") %>;
            }
            location = "/Admin/Module/BasicForms/ListSubmits.aspx?action=ExportCsv&headers=true&formid=" + formid + "&PageId=" + pageID;
        }
    }
    function toggleSubmitAction() {
        if (document.getElementById("formSubmitActionPageRadio").checked) {
            document.getElementById("SaveActionTemplateContainer").style.display = "none";
            document.getElementById("SaveActionTemplateTextContainer").style.display = "none";
            document.getElementById("SaveActionPageRedirectContainer").style.display = "";
        } else {
            document.getElementById("SaveActionTemplateContainer").style.display = "";
            document.getElementById("SaveActionTemplateTextContainer").style.display = "";
            document.getElementById("SaveActionPageRedirectContainer").style.display = "none";
        }
		
    }

    function ChangeGetFromEmail(elm, id) {
        if (elm.checked) {
            document.getElementById(id).style.display = 'none';
            document.getElementById(id).disabled = true;
            document.getElementById(id).value = '';
        } else {
            document.getElementById(id).style.display = '';
            document.getElementById(id).disabled = false;
        }
    }

    function InitGetFromEmail() {
        ChangeGetFromEmail(document.getElementById("MailSenderUseUserEmail"), "MailSender");
        ChangeGetFromEmail(document.getElementById("MailSenderUseUserEmail"), "MailSenderName");
        ChangeGetFromEmail(document.getElementById("MailReplytoUseUserEmail"), "MailReplyto");
    }

    function enableTemplate(elm, id) {
        document.getElementById(id).style.display = elm.checked && elm.value == "1" ? "" : "none";
    }

    function toggleMaxSubmitAction() {
        if (document.getElementById("FormMaxSubmitsReachedPageRadio").checked) {
            document.getElementById("SaveActionMaxSubmitsTemplateContainer").style.display = "none";
            document.getElementById("SaveActionMaxSubmitsPageRedirectContainer").style.display = "";
        } else {
            document.getElementById("SaveActionMaxSubmitsTemplateContainer").style.display = "";
            document.getElementById("SaveActionMaxSubmitsPageRedirectContainer").style.display = "none";
        }
    }  
    function toggleUserSettings(checkbox) {
        document.getElementById('FieldMappingContainer').style.display = checkbox.checked ? "" : "none";
        document.getElementById('AlowEmailFieldContainer').style.display = checkbox.checked ? "" : "none";
        document.getElementById('NewUserGroupsContainer').style.display = checkbox.checked ? "" : "none";
    }
    
    function formChanged() {
        var formSelector = document.getElementById("FormID");
        var formId = formSelector[formSelector.selectedIndex].value;
        if (!formId || formId == '') {
            document.getElementById('CreateUserOnSubmitAllowed').value = false;
            return;
        }
        var url = "/Admin/Module/BasicForms/BasicForms_Edit.aspx?IsAjax=true&cmd=CheckFormHasMapping&FormId=" + encodeURIComponent(formId);
        new Ajax.Request(url, {
            method: 'get',
            onSuccess: function (transport) {
                var response = JSON.parse(transport.responseText);
                document.getElementById('CreateUserOnSubmitAllowed').value = response.hasMapping;
            }
        });
    }
</script>

<dw:GroupBox ID="GroupBox1" runat="server" Title="Formular" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td style="width: 170px;">
                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Formular" />
            </td>
            <td>
                <select runat="server" id="FormID" class="std" name="FormID" onchange="formChanged();"></select>
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel ID="TranslateLabel24" runat="server" Text="Template" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" name="UseTemplate" id="UseAutomatic" onclick="enableTemplate(this, 'templateRow');" value="0" runat="server" /><label for="UseAutomatic">Automatic</label>
                </div>
                <div class="radio">
                    <input type="radio" name="UseTemplate" id="UseTemplate" onclick="enableTemplate(this, 'templateRow');" value="1" runat="server" /><label for="UseTemplate">Template</label>
                </div>
            </td>
        </tr>
        <tr id="templateRow">
            <td>
                <dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="Template" />
            </td>
            <td>
                <dw:FileManager ID="Template" Name="Template" runat="server" Folder="/Templates/Forms/Form" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel32" runat="server" Text="Tekst_på_submit" />
            </td>
            <td>
                <input type="Text" name="FormSubmitButtonText" id="FormSubmitButtonText" runat="server" value="" maxlength="255" class="std" />
            </td>
        </tr>
        <tr runat="server" id="submitCountRow" visible="true">
            <td>
                <dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Submit" />
            </td>
            <td>
                <span runat="server" id="submitCount">
                    <span id="SubmitCountLabel" runat="server"></span>
                </span>
                <button onclick="download();return false;" class="btn btn-flat">
                    <dw:TranslateLabel ID="TranslateLabel22" runat="server" Text="Export csv" />
                </button>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox ID="GroupBox4" runat="server" Title="When submitting form" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td style="width: 170px; vertical-align: top;">
                <dw:TranslateLabel runat="server" Text="When submitting form" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" name="formSubmitAction" value="page" id="formSubmitActionPageRadio" onclick="toggleSubmitAction();" runat="server" /><label for="formSubmitActionPageRadio"><dw:TranslateLabel runat="server" Text="Redirect to page" />
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" name="formSubmitAction" value="template" id="formSubmitActionTemplateRadio" onclick="toggleSubmitAction();" runat="server" /><label for="formSubmitActionTemplateRadio"><dw:TranslateLabel runat="server" Text="Use confirmation template" />
                    </label>
                </div>
            </td>
        </tr>
        <tr id="SaveActionPageRedirectContainer">
            <td>
                <dw:TranslateLabel ID="TranslateLabel14" runat="server" Text="Page after submission" />
            </td>
            <td>
                <dw:LinkManager ID="formSubmitPageAfterSave" Name="formSubmitPageAfterSave" DisableTyping="False" DisableParagraphSelector="True" runat="server" DisableFileArchive="true" />
            </td>
        </tr>
        <tr id="SaveActionTemplateContainer">
            <td>
                <dw:TranslateLabel ID="TranslateLabel15" runat="server" Text="Confirmation template" />
            </td>
            <td>
                <dw:FileManager ID="formSubmitConfirmationTemplate" Name="formSubmitConfirmationTemplate" runat="server" Folder="/Templates/Forms/Confirmation" />
            </td>
        </tr>
        <tr id="SaveActionTemplateTextContainer">
            <td style="vertical-align: top;">
                <dw:TranslateLabel ID="TranslateLabel25" runat="server" Text="Tekst" />
            </td>
            <td>
                <dw:Editor ID="ReceiptTemplateText" runat="server" Width="60%" Height="150" ForceNew="true" InitFunction="true" WindowsOnLoad="false" GetClientHeight="false" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox ID="GroupBox2" runat="server" Title="Mail" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td colspan="2"><small class="help-block info"><dw:TranslateLabel runat="server" Text="Sends an email to website owner (you) with information about the form submit." /> </small><br /></td>
        </tr>
        <tr>
            <td style="width: 170px;">
                <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Emne" />
            </td>
            <td>
                <input type="Text" name="MailSubject" id="MailSubject" runat="server" value="" maxlength="255" class="std" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Sender name" />
            </td>
            <td>
                <div>
                    <input type="Text" name="MailSenderName" id="MailSenderName" runat="server" value="" maxlength="255" class="std" />
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel runat="server" Text="Sender email" />
            </td>
            <td>
                <div id="MailSenderCell" class="m-b-10" runat="server">
                    <input type="Text" name="MailSender" id="MailSender" runat="server" value="" maxlength="255" class="std" title="user@domain.com" />
                    <div><small>user@domain.com</small></div>
                </div>
                <dw:CheckBox name="MailSenderUseUserEmail" ID="MailSenderUseUserEmail" OnClick="ChangeGetFromEmail(this, 'MailSender'); ChangeGetFromEmail(this, 'MailSenderName');" runat="server" />
                <label for="MailSenderUseUserEmail"><%=Translate.Translate("Hent fra %%","%%","<em>" & Translate.Translate("E-mail felt") & "</em>")%></label>
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel ID="TranslateLabel16" runat="server" Text="Reply to" />
            </td>
            <td>
                <div id="Div1" class="m-b-10" runat="server">
                    <input type="Text" name="MailReplyto" id="MailReplyto" runat="server" value="" maxlength="255" class="std" title="user@domain.com" />
                    <div><small>user@domain.com</small></div>
                </div>
                <dw:CheckBox name="MailReplytoUseUserEmail" ID="MailReplytoUseUserEmail" OnClick="ChangeGetFromEmail(this, 'MailReplyto');" runat="server" />
                <label for="MailReplytoUseUserEmail"><%=Translate.Translate("Hent fra %%","%%","<em>" & Translate.Translate("E-mail felt") & "</em>")%></label>
            </td>
        </tr>
        <tr>
            <td style="height: 5px;"></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Modtager" />
            </td>
            <td>
                <input type="Text" name="MailRecipient" id="MailRecipient" runat="server" value="" maxlength="255" class="std" title="user@domain.com, user2@domain.com" />
                <div><small>user@domain.com, user2@domain.com</small></div>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Modtager CC" />
            </td>
            <td>
                <input type="Text" name="MailCC" id="MailCC" runat="server" value="" maxlength="255" class="std" title="user@domain.com, user2@domain.com" />
                <div><small>user@domain.com, user2@domain.com</small></div>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Modtager BCC" />
            </td>
            <td>
                <input type="Text" name="MailBCC" id="MailBCC" runat="server" value="" maxlength="255" class="std" title="user@domain.com, user2@domain.com" />
                <div><small>user@domain.com, user2@domain.com</small></div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel ID="TranslateLabel26" runat="server" Text="Template" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" name="UseMailTemplate" id="UseMailAutomatic" onclick="enableTemplate(this, 'MailTemplateRow');" value="0" runat="server" /><label for="UseMailAutomatic">Automatic</label>
                </div>
                <div class="radio">
                    <input type="radio" name="UseMailTemplate" id="UseMailTemplate" onclick="enableTemplate(this, 'MailTemplateRow');" value="1" runat="server" /><label for="UseMailTemplate">Template</label>
                </div>
            </td>
        </tr>
        <tr id="MailTemplateRow">
            <td>
                <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Template" />
            </td>
            <td>
                <dw:FileManager ID="MailTemplate" Name="MailTemplate" runat="server" Folder="/Templates/Forms/Mail" />
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel ID="TranslateLabel17" runat="server" Text="Tekst" />
            </td>
            <td>
                <dw:Editor ID="MailText" runat="server" Width="60%" Height="150" ForceNew="true" InitFunction="true" WindowsOnLoad="false" GetClientHeight="False" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox ID="GroupBox3" runat="server" Title="Kvittering" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td colspan="2"><small class="help-block info"><dw:TranslateLabel runat="server" Text="Sends an email receipt to the visitor who filled out the form with information about the form submit. Requires that the form has a field for email specified." /> </small><br /></td>
        </tr>
        <tr>
            <td style="width: 170px;">
                <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Emne" />
            </td>
            <td>
                <input type="Text" name="ReceiptSubject" id="ReceiptSubject" runat="server" value="" maxlength="255" class="std" /></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Sender name" />
            </td>
            <td>
                <input type="text" name="ReceiptSenderName" id="ReceiptSenderName" runat="server" value="" maxlength="255" class="std" />
            </td>
        </tr>
        <tr id="Tr1" runat="server">
            <td style="width: 170px;">
                <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Sender email" />
            </td>
            <td>
                <input type="Text" name="ReceiptSender" id="ReceiptSender" runat="server" value="" maxlength="255" class="std" title="user@domain.com" />
                <div><small>user@domain.com, user2@domain.com</small></div>
            </td>
        </tr>

        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel11" runat="server" Text="Modtager CC" />
            </td>
            <td>
                <input type="Text" name="ReceiptCC" id="ReceiptCC" runat="server" value="" maxlength="255" class="std" title="user@domain.com, user2@domain.com" />
                <div><small>user@domain.com, user2@domain.com</small></div>
            </td>
        </tr>
        <tr>
            <td style="width: 170px;">
                <dw:TranslateLabel ID="TranslateLabel12" runat="server" Text="Modtager BCC" />
            </td>
            <td>
                <input type="Text" name="ReceiptBCC" id="ReceiptBCC" runat="server" value="" maxlength="255" class="std" title="user@domain.com, user2@domain.com" />
                <div><small>user@domain.com, user2@domain.com</small></div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel ID="TranslateLabel30" runat="server" Text="Template" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" name="UseReceiptTemplate" id="UseReceiptAutomatic" onclick="enableTemplate(this, 'ReceiptTemplateRow');" value="0" runat="server" /><label for="UseReceiptAutomatic">Automatic</label>
                </div>
                <div class="radio">
                    <input type="radio" name="UseReceiptTemplate" id="UseReceiptTemplate" onclick="enableTemplate(this, 'ReceiptTemplateRow');" value="1" runat="server" /><label for="UseReceiptTemplate">Template</label>
                </div>
            </td>
        </tr>
        <tr id="ReceiptTemplateRow">
            <td>
                <dw:TranslateLabel ID="TranslateLabel13" runat="server" Text="Template" />
            </td>
            <td>
                <dw:FileManager ID="ReceiptTemplate" Name="ReceiptTemplate" runat="server" Folder="/Templates/Forms/Mail" />
            </td>
        </tr>
        <tr id="ReceiptTemplateTextRow">
            <td style="vertical-align: top;">
                <dw:TranslateLabel ID="TranslateLabel18" runat="server" Text="Tekst" />
            </td>
            <td>
                <dw:Editor ID="ReceiptText" runat="server" Width="600" Height="150" ForceNew="true" InitFunction="true" WindowsOnLoad="false" GetClientHeight="False" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<script>
    function showDialog(name) {
        dialog.show(name);
        document.getElementById(name).scrollIntoView();
    }
    
    function initValidators () {
        window["paragraphEvents"].setValidator(function () {
            var PageValidator = document.getElementById("FormMaxSubmits");          
            var ret = true;
            if (PageValidator.value != ""){
                if(document.getElementById("FormMaxSubmitsReachedPageRadio").checked){
                    var path = document.getElementById("Link_FormMaxSubmitsReachedPage");
                    if(path.value == ""){
                        alert("Please specify redirect page");
                        document.getElementById("Link_FormMaxSubmitsReachedPage").style.borderColor = "red";
                        ret = false;
                    }                    
                }else{
                    var template = document.getElementById("FormMaxSubmitsReachedTemplate_path");
                    if(template.value == ""){
                        alert("Please specify template");
                        document.getElementById("FM_FormMaxSubmitsReachedTemplate").style.borderColor = "red";
                        ret = false;
                    }
                }                
            } else if (!document.getElementById("FormID")[document.getElementById("FormID").selectedIndex].value) {
                alert("<%=Translate.Translate("Please select form")%>");
                ret = false;
            } else if (document.getElementById('CreateUserOnSubmit').checked) {
                ret = document.getElementById('CreateUserOnSubmitAllowed').value === "true";
                if (!ret) {
                    alert("<%=Translate.Translate("Create user on form submit checked, but selected form fields are not mapped - at least email address should be mapped")%>");
                }
            }
            return ret;
        });
    }

    toggleSubmitAction();

    enableTemplate(document.getElementById("UseTemplate"), 'templateRow');
    enableTemplate(document.getElementById("UseMailTemplate"), 'MailTemplateRow');
    enableTemplate(document.getElementById("UseReceiptTemplate"), 'ReceiptTemplateRow');
</script>

<dw:GroupBox ID="MaxSubmitsReachedTextGroup" runat="server" Title="Max submits" DoTranslation="true">
    <table class="formsTable">
        <tr id="MaxSubmitsAllowedContainer">
            <td>
                <dw:TranslateLabel ID="TranslateLabel23" runat="server" Text="Max submits on this page" />
                <small>
                    <dw:TranslateLabel ID="TranslateLabel31" runat="server" Text="Submits" />
                    : <span id="MaxSubmitsOnForm" runat="server" /></small>
            </td>
            <td>
                <input type="text" name="FormMaxSubmits" id="FormMaxSubmits" runat="server" enableviewstate="false" maxlength="255" class="NewUIinput" />
            </td>
        </tr>
        <tr>
            <td style="width: 170px; vertical-align: top;">
                <dw:TranslateLabel runat="server" Text="When max submits is reached" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" name="FormMaxSubmitAction" value="page" id="FormMaxSubmitsReachedPageRadio" onclick="toggleMaxSubmitAction();" runat="server" /><label for="FormMaxSubmitsReachedPageRadio"><dw:TranslateLabel runat="server" Text="Redirect to page" />
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" name="FormMaxSubmitAction" value="template" id="FormMaxSubmitsReachedTemplateRadio" onclick="toggleMaxSubmitAction();" runat="server" /><label for="FormMaxSubmitsReachedTemplateRadio"><dw:TranslateLabel runat="server" Text="Template" />
                    </label>
                </div>
            </td>
        </tr>
        <tr id="SaveActionMaxSubmitsPageRedirectContainer">
            <td>
                <dw:TranslateLabel ID="FormMaxSubmitsReachedPageLabel" runat="server" Text="Page" />
            </td>
            <td>
                <dw:LinkManager ID="FormMaxSubmitsReachedPage" Name="FormMaxSubmitsReachedPage" DisableTyping="False" DisableParagraphSelector="True" runat="server" DisableFileArchive="true" />
            </td>
        </tr>
        <tr id="SaveActionMaxSubmitsTemplateContainer">
            <td>
                <dw:TranslateLabel ID="FormMaxSubmitsReachedTemplateLabel" runat="server" Text="Template" />
            </td>
            <td>
                <dw:FileManager ID="FormMaxSubmitsReachedTemplate" Name="FormMaxSubmitsReachedTemplate" runat="server" Folder="/Templates/Forms/Confirmation" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox ID="GroupBox5" runat="server" Title="Upload settings" DoTranslation="true">
    <table class="formsTable">
        <tr id="FormUploadPathContainer">
            <td style="width: 170px; vertical-align: top;">
                <dw:TranslateLabel ID="TranslateLabel28" runat="server" Text="Upload path" />
            </td>
            <td>
                <dw:FolderManager ID="FormUploadPath" Name="FormUploadPath" DisableTyping="False" DisableParagraphSelector="True" runat="server" DisableFileArchive="False" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox ID="GroupBox6" runat="server" Title="User Management" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td style="width: 170px; vertical-align: top;">
                <label for="CreateUserOnSubmit"><%=Translate.Translate("Create user on form submit")%></label>
            </td>
            <td>
                <dw:CheckBox name="CreateUserOnSubmit" ID="CreateUserOnSubmit" runat="server" />
                <input type="hidden" id="CreateUserOnSubmitAllowed" name="CreateUserOnSubmitAllowed" value="true" />
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel ID="TranslateLabel29" runat="server" Text="Groups for new users" />
            </td>
            <td>
                <dw:UserSelector runat="server" ID="CreateNewUserGroups" NoneSelectedText="No group selected" Show="Groups" HeightInRows="3" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<script>
    formChanged();
    initValidators();
    toggleMaxSubmitAction();
    InitGetFromEmail();
</script>
