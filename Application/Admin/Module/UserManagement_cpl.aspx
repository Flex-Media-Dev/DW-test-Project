<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UserManagement_cpl.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement_cpl" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title><%=Translate.JsTranslate("UserManagement")%></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />

    <dwc:ScriptLib runat="server" ID="ScriptLib">
        <script src="/Admin/Content/JsLib/prototype-1.7.js" type="text/javascript"></script>
        <script src="/Admin/Content/JsLib/dw/Utilities.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>
        <script src="/Admin/Content/JsLib/require.js" type="text/javascript"></script>
    </dwc:ScriptLib>

    <script type="text/javascript">
        function findCheckboxNames() {
            var form = document.getElementById('frmGlobalSettings');
            var _names = "";
            for (var i = 0; i < form.length; i++) {
                if (form[i].name != undefined) {
                    if (form[i].type == "checkbox") {
                        _names = _names + form[i].name + "@";
                    }
                }
            }
            form.CheckboxNames.value = _names;
        }

        function toggleDynamicwebAdministration() {
            if (document.getElementById('UsersUseInAdministration').checked) {
                document.getElementById('DynamicwebAdministrationDiv').style.display = 'block';
            } else {
                document.getElementById('DynamicwebAdministrationDiv').style.display = 'none';
            }
        }

        function toggleExtranetAdministrationDiv() {
            if (document.getElementById('ExtranetUseInAdministration').checked) {
                document.getElementById('ExtranetAdministrationDiv').style.display = 'block';
            } else {
                document.getElementById('ExtranetAdministrationDiv').style.display = 'none';
            }
        }

        // Removes the '/Filer/' prefix of
        function fixSecureFolder() {
            var removeString = '/' + '<%=Dynamicweb.Content.Files.FilesAndFolders.GetFilesFolderName()%>' + '/';
            var secureFolder = document.getElementById('FLDM_/Globalsettings/Modules/Users/SecureFolderName');
            if (secureFolder.value.substring(0, removeString.length).toLowerCase() == removeString.toLowerCase()) {
                secureFolder.value = secureFolder.value.substring(removeString.length, secureFolder.value.length);
            }
            else {
                secureFolder.value = '';
            }
        }

        function EncryptPaswords(backend) {
            if (!confirmEncryption())
                return false;

            var usersLocation = "frontend";
            if (backend) {
                usersLocation = "backend";
            }

            new Ajax.Request('/Admin/Module/UserManagement_cpl.aspx?EncodePasswords=' + usersLocation + '&rnd=' + Math.random(), {
                method: 'get',
                onSuccess: function (transport) {
                    alert('<%= Translate.Translate("Passwords were encrypted") %>');
                },
                onFailure: function () {
                    alert('<%= Translate.Translate("Something went wrong") %>');
                }
            });
        }

        function checkBlockingPeriod() {
            dwGlobal.hideControlErrors("BlockingPeriod", "");
            if (!document.getElementById('BlockingPeriod').value || 0 === document.getElementById('BlockingPeriod').value.length) {
                return true;
            } else {
                var blockingPeriod = parseInt(document.getElementById('BlockingPeriod').value);
                if (isNaN(blockingPeriod)) {
                    dwGlobal.showControlErrors("BlockingPeriod", "<%= Translate.Translate("Blocking period has incorrect value") %>");
                    document.getElementById('BlockingPeriod').focus();
                    return false;
                } else if (blockingPeriod <= 0) {
                    dwGlobal.showControlErrors("BlockingPeriod", "<%= Translate.Translate("Blocking period must be at least 1 min") %>");
                    document.getElementById('BlockingPeriod').focus();
                    return false;
                }
            }
            return true;
        }

        function confirmEncryption() {
            return confirm('<%=Translate.JsTranslate("Please save your settings before encrypting passwords. Do you want to continue?")%>');
        }

        function viewSystemFieldsClick() {
            document.location = '/Admin/Module/SystemFields/SystemFieldEdit.aspx?TableName=AccessUser&ModuleName=Users&RedirectUrl=<%= HttpContext.Current.Request.Url.ToString() %>';
        }

        function viewCustomFieldsClick() {
            document.location = '/Admin/Module/CustomField/Default.aspx?TableName=AccessUser&DatabaseName=Access.mdb&ModuleName=Users&RedirectUrl=<%= HttpContext.Current.Request.Url.ToString() %>';
        }

        function viewAddressCustomFieldsClick() {
            document.location = '/Admin/Module/CustomField/Default.aspx?TableName=AccessUserAddress&DatabaseName=Access.mdb&ModuleName=Users&GroupBoxName=<%= Translate.JsTranslate("Edit custom address fields")%>&RedirectUrl=<%= HttpContext.Current.Request.Url.ToString() %>';
        }

        function saveUserManagement(close) {
            if (checkBlockingPeriod()) {
                findCheckboxNames();
                fixSecureFolder();
                if (!close) {
                    document.getElementById('hiddenSource').value = 'ManagementCenterSave';
                }
                document.getElementById('frmGlobalSettings').submit();
            } else {
                setTimeout(function () {
                    var __o = new overlay('__ribbonOverlay');
                    __o.hide()
                }, 300);
            }
        }

        function onLoad() {
            toggleDynamicwebAdministration();
            toggleExtranetAdministrationDiv();
            var hasExtranetExtended = '<%=Dynamicweb.Security.UserManagement.License.IsModuleAvailable("UserManagementFrontend") %>' == 'True'
            if (!hasExtranetExtended) {
                document.getElementById('SecureFolderDiv').style.display = 'none';
            }
            document.getElementById('BlockingPeriod').setAttribute("onchange", "checkBlockingPeriod();");
        }

        function setDefaultMethod(checkBox) {
            if ($(checkBox).checked == false) {
                return false;
            }

            var radioButtons = $$("input[id^=EncryptPasswordHash]")
            for (var i = 0; i < radioButtons.length; i++) {
                if (radioButtons[i].checked) {
                    return false;
                }
            }

            $$("input[id^=EncryptPasswordHash][value=SHA512]")[0].checked = true;
        }
    </script>
</head>
<body class="area-blue" onload="onLoad();">
    <div class="dw8-container">
        <form method="post" action="ControlPanel_Save.aspx" id="frmGlobalSettings" name="frmGlobalSettings">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Users"></dwc:CardHeader>
                <dwc:CardBody runat="server">
                    <input id="hiddenSource" type="hidden" name="_source" value="ManagementCenter" />
                    <input type="hidden" name="CheckboxNames" />

                    <%--TFS # 23570 - hidden from the UI. Please note that functionality should be saved--%>
                    <dwc:GroupBox DoTranslation="true" Title="System Fields" runat="server" Visible="False">
                        <dwc:Button runat="server" Title="View system fields" DoTranslate="true" OnClick="viewSystemFieldsClick();" />
                    </dwc:GroupBox>


                    <dwc:GroupBox DoTranslation="true" Title="Custom Fields" runat="server">
                        <dwc:Button runat="server" Title="Edit custom fields" DoTranslate="true" OnClick="viewCustomFieldsClick();" />
                    </dwc:GroupBox>

                    <dwc:GroupBox DoTranslation="true" Title="Custom Address Fields" runat="server">
                        <dwc:Button runat="server" Title="Edit custom address fields" DoTranslate="true" OnClick="viewAddressCustomFieldsClick();" />
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Custom files folder" DoTranslation="True">
                        <dwc:RadioGroup runat="server" ID="UploadedCustomFilesDefineWhere" Name="/Globalsettings/Modules/UserManagement/UploadedCustomFiles/DefineWhere" Label="Define upload folder">
                            <dwc:RadioButton runat="server" FieldValue="Globally" Label="Globally" />
                            <dwc:RadioButton runat="server" FieldValue="OnUser" Label="For each user" />
                        </dwc:RadioGroup>
                        <div class="form-group">
                            <dw:TranslateLabel runat="server" Text="Folder" UseLabel="True" />
                            <dw:FolderManager runat="server" Name="/Globalsettings/Modules/UserManagement/UploadedCustomFiles/FilesFolder" ID="UploadedCustomFiles" />
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Permissions" ID="newPermissions">
                        <dwc:CheckBox runat="server" Label="Use new permissions model" ID="UseUnifiedPermission" Info="Changing this value will force a logoff" Name="/Globalsettings/Settings/Permissions/UseNew" />
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Send user details - email settings" ID="SendUserDetails" runat="server">
                        <dwc:InputText Label="Subject" ID="SendDetailsSubject" Name="/Globalsettings/Modules/UserManagement/SendDetails/Subject" runat="server" />
                        <dwc:InputText Label="Sender name" ID="SendDetailsSenderName" Name="/Globalsettings/Modules/UserManagement/SendDetails/SenderName" runat="server" />
                        <dwc:InputText Label="Sender email" ID="SendDetailsSenderEmail" Name="/Globalsettings/Modules/UserManagement/SendDetails/SenderEmail" runat="server" />                        
                        <dw:FileManager Label="Template" ID="SendDetailsTemplate" Name="/Globalsettings/Modules/UserManagement/SendDetails/Template" Folder="/Templates/ExtranetExtended" runat="server" />                        
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Extranet secure folder" DoTranslation="true" ID="SecureFolderDiv" ClientIDMode="Static">
                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Sikker mappe" />
                            </label>
                            <div class="form-group-input">
                                <dw:FolderManager runat="server" ID="SecureFolder" Name="/Globalsettings/Modules/Users/SecureFolderName" />
                                <small class="help-block info" id="info/Globalsettings/Modules/Users/SecureFolderName">
                                    <%=Translate.Translate("The secure folder must be located in /Files") %>
                                </small>
                            </div>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Extranet login limitations" DoTranslation="true">
                        <dwc:CheckBox runat="server" ID="ExtranetPasswordSecurityEnable" Label="Enable login limitations" Name="/Globalsettings/Modules/UserManagement/ExtranetPasswordSecurity/SecurityEnable" />
                        <dwc:InputNumber ID="ExtranetPasswordSecurityPeriodLoginFailure" Label="Period for failed login attempts" Info="minutes" runat="server" Name="/Globalsettings/Modules/UserManagement/ExtranetPasswordSecurity/PeriodLoginFailure" Max="99999" />
                        <dwc:InputNumber ID="ExtranetPasswordSecurityLoginAttempts" Label="Login attempts" runat="server" Name="/Globalsettings/Modules/UserManagement/ExtranetPasswordSecurity/LoginAttempts" Max="99999" />
                        <dwc:InputNumber ValidationMessage="" ID="BlockingPeriod" Label="Blocking period" runat="server" Info="minutes" Name="/Globalsettings/Modules/UserManagement/ExtranetPasswordSecurity/BlockingPeriod" Max="99999" />
                        <dwc:InputNumber ValidationMessage="" ID="RecoveryTokenTimeout" Label="Recovery token timeout" runat="server" Info="hours" Name="/Globalsettings/Modules/UserManagement/ExtranetPasswordSecurity/RecoveryTokenTimeout" Max="99999" />
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" ID="DynamicwebAdministration">
                        <dwc:CheckBox ID="ShowPasswordIfPresent" runat="server" Name="/Globalsettings/Modules/Users/ShowPasswordIfPresent" Label="Show password if present"  />
                        <dwc:CheckBox ID="UsersUseInAdministration" runat="server" Name="/Globalsettings/Modules/Users/UseInAdministration" OnClick="toggleDynamicwebAdministration();" />
                        <div id="DynamicwebAdministrationDiv">
                            <dwc:CheckBox ID="UsersEncryptPassword" runat="server" Label="Krypter" Name="/Globalsettings/Modules/Users/EncryptPassword" OnClick="setDefaultMethod(this);" />
                            <dwc:RadioGroup runat="server" ID="EncryptPasswordHash" Name="/Globalsettings/Modules/Users/EncryptPasswordHash" Label="Hashing algorithm">
                                <dwc:RadioButton runat="server" ID="UsersEncryptPasswordHashMD5" Label="MD5" />
                                <dwc:RadioButton runat="server" ID="UsersEncryptPasswordHashSHA512" Label="SHA512" />
                            </dwc:RadioGroup>
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Users/PasswordExpireDays" Label="Expiration" ID="DynamicwebAdministrationPasswordExpireDays" />
                            <dw:TranslateLabel runat="server" Text="Kodeord genbrug" />
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Users/ReusePassword/AfterNumberOfTimes" Label="Efter antal gange" ID="DynamicwebAdministrationReusePasswordAfterNumberOfTime" />
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Users/ReusePassword/AfterNumberOfDays" Label="Efter Antal dage" ID="DynamicwebAdministrationReusePasswordAfterNumberOfDays" />
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Users/PasswordSecurity" Label="Kompleksitet" ID="DynamicwebAdministrationPasswordSecurity" />
                            <dw:Infobar runat="server" Type="Information">
                                <%=Translate.Translate("low - No restrictions")%><br />
                                <%=Translate.Translate("medium - Password must contain numbers and characters.")%><br />
                                <%=Translate.Translate("high - Password must contain numbers, upperand lower case characters and special characters.")%><br />
                            </dw:Infobar>
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Users/MinimumOfCharacters" Label="Min. antal karakterer" ID="DynamicwebAdministrationPasswordMinimumOfCharacters" />
                            <dwc:Button runat="server" ID="UsersEncryptPasswords" OnClick="EncryptPaswords(true);" Title="Krypter brugere" DoTranslate="true" />
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" ID="ExtranetAdministration">
                        <dwc:CheckBox ID="ExtranetUseInAdministration" runat="server" Name="/Globalsettings/Modules/Extranet/UseWithExtranet" OnClick="toggleExtranetAdministrationDiv();" />
                        <div id="ExtranetAdministrationDiv">
                            <dwc:CheckBox ID="ExtranetEncryptPassword" runat="server" Label="Krypter" Name="/Globalsettings/Modules/Extranet/EncryptPassword" />
                            <dwc:RadioGroup runat="server" ID="ExtranetEncryptPasswordHash" Name="/Globalsettings/Modules/Extranet/EncryptPasswordHash" Label="Hashing algorithm">
                                <dwc:RadioButton runat="server" ID="ExtranetEncryptPasswordHashMD5" Label="MD5" />
                                <dwc:RadioButton runat="server" ID="ExtranetEncryptPasswordHashSHA512" Label="SHA512" />
                            </dwc:RadioGroup>
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Extranet/PasswordExpireDays" Label="Expiration" ID="ExtranetPasswordExpireDays" />

                            <dw:TranslateLabel runat="server" Text="Kodeord genbrug" />
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Extranet/ReusePassword/AfterNumberOfTimes" Label="Efter antal gange" ID="ExtranetReusePasswordAfterNumberOfTime" />
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Extranet/ReusePassword/AfterNumberOfDays" Label="Efter Antal dage" ID="ExtranetReusePasswordAfterNumberOfDays" />
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Extranet/PasswordSecurity" Label="Kompleksitet" ID="ExtranetPasswordSecurity" />
                            <dw:Infobar runat="server" Type="Information">
                                <%=Translate.Translate("low - No restrictions")%><br />
                                <%=Translate.Translate("medium - Password must contain numbers and characters.")%><br />
                                <%=Translate.Translate("high - Password must contain numbers, upperand lower case characters and special characters.")%><br />
                            </dw:Infobar>
                            <dwc:SelectPicker runat="server" Name="/Globalsettings/Modules/Extranet/MinimumOfCharacters" Label="Min. antal karakterer" ID="ExtranetPasswordMinimumOfCharacters" />
                            <dwc:Button runat="server" ID="ExtranetEncryptPasswords" OnClick="EncryptPaswords(false);" Title="Krypter brugere" DoTranslate="true" />
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Login cookie" DoTranslation="true">
                        <dwc:InputText ID="UsersAutoLoginCookieValideForDays" Label="Valid for" Info="days" runat="server" Name="/Globalsettings/Modules/Users/AutoLoginCookie/ValideForDays" MaxLength="5" />
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" ID="EcomSettings" Title="Ecommerce" DoTranslation="true" Visible="false">
                        <dwc:CheckBox ID="IncludeShopIdInExtranetLogIn" runat="server" Label="Include shop id in extranet log in" Name="/Globalsettings/Ecom/Users/IncludeShopIdInExtranetLogIn" />
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" ID="ImpersonationSettings" Title="Impersonation" DoTranslation="true">
                        <dwc:RadioGroup runat="server" ID="UserImpersonationRadioBox" Name="/Globalsettings/Modules/Users/Impersonation" Label="Mode">
                            <dwc:RadioButton runat="server" ID="UserImpersonationOnlyOrders" Label="Only tag orders with impersonating user" />
                            <dwc:RadioButton runat="server" ID="UserImpersonationFull" Label="Replace current user with impersonated user" />
                        </dwc:RadioGroup>
                        <dwc:CheckBox ID="UserImpersonationFullExceptPermissions" runat="server" Label="Use impersonater for permissions" Name="/Globalsettings/Modules/Users/ImpersonationFullExceptPermissions" Info="Only for full impersonation. Frontend permissions will be conducted on the impersonater; prices etc. on impersonated user" />
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Recalculate User SmartSearches every" DoTranslation="true">
                        <dwc:SelectPicker runat="server" ID="SmartSearchesCahceRecalculatingInterval" Name="/Globalsettings/Modules/UserManagement/UserSmartSearchesCahceRecalculatingInterval" Label="Recalculate user SmartSearches every" />
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Indexing">
                        <dwc:CheckBox runat="server" ID="BuildUserIndexAfterUserUpdate" Name="/Globalsettings/Modules/Users/AutoBuildIndex" Label="Auto build index when user update" />
                        <dwc:SelectPicker runat="server" ID="UserIndex" Name="/Globalsettings/Modules/Users/IndexName" Label="Index" />
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
        </form>

        <dwc:ActionBar runat="server">
            <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" KeyboardShortcut="ctrl+s" OnClientClick="saveUserManagement();" ID="cmdSave" ShowWait="true">
            </dw:ToolbarButton>
            <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="saveUserManagement(true);" ID="cmdSaveAndClose" ShowWait="true">
            </dw:ToolbarButton>
            <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="location='ControlPanel.aspx';" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
            </dw:ToolbarButton>
        </dwc:ActionBar>
    </div>

    <script type="text/javascript">
        if ('<%=Converter.ToString(Dynamicweb.Context.Current.Request("didEncrypt")) %>'.length > 0) {
            if ('<%=Converter.ToString(Dynamicweb.Context.Current.Request("didEncrypt")) %>' == 'True')
                document.getElementById('encryptSuccess').style.display = '';
            else
                document.getElementById('encryptFailure').style.display = '';
        }
    </script>
    <% Translate.GetEditOnlineScript() %>
</body>
</html>

