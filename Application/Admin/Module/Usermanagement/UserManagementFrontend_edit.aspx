<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UserManagementFrontend_edit.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement_edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<style type="text/css">
    #ShowProfileUserID_CustomSelector input {
        font-size: 11px;
        padding-left: 2px;
    }

    .chb-list {
        max-height: 200px;
        width: 60%;
        overflow: auto;
        border-radius: 3px;
        border: 1px solid #ABADB3;
    }

        .chb-list .chb-item:hover {
            background-color: rgb(173, 216, 230);
        }

    .row > label,
    label.row {
        display: block;
    }

        label.row input[type=radio],
        label.row input[type=checkbox] {
            vertical-align: -2px;
        }

    .send-restore-pwd-link-options {
        display: none;
    }

    .SendRestoreLink .send-restore-pwd-link-options {
        display: block;
        margin: 4px 25px;
    }
</style>

<script type="text/javascript" src="/Admin/Images/Controls/EditableList/EditableListEditors.js"></script>

<script type="text/javascript">

    function toggleIncludeSubsDiv() {
        document.getElementById('IncludeSubsDiv').style.display = $('ListIncludeSubs').checked ? '' : 'none';
    }

    function toggleShow() {
        if ($('ShowRadioList').checked) {
            $('ShowListDiv').style.display = 'block';
            $('ShowProfileDiv').style.display = 'none';

            $('CreateProfileDiv').style.display = 'none';
            $('AdminNotificationEmailGroup').style.display = 'none';
            $('UserNotificationEmailGroup').style.display = 'none';
            $('RedirectionDiv').style.display = 'none';
            $('ViewProfileManageAddressesDiv').style.display = 'none';
            $('ViewProfileViewAddressesDiv').style.display = 'none';            
            $('VCardDiv').style.display = 'block';
            $('UploadedImagesDiv').style.display = 'block';            
            $('ErrorMessagesDIV').style.display = 'none';
            showLoginSettingsPane(false);
            displayAddressMessages(false);
        } else if ($('ShowRadioProfile').checked) {
            $('ShowListDiv').style.display = 'none';
            $('ShowProfileDiv').style.display = 'block';
            $('CreateProfileDiv').style.display = 'none';
            $('AdminNotificationEmailGroup').style.display = 'none';
            $('UserNotificationEmailGroup').style.display = 'none';
            $('RedirectionDiv').style.display = 'none';
            $('ViewProfileDiv').style.display = 'block';
            $('ViewProfileEditProfileDiv').style.display = $('ShowProfileAllowEdit').checked ? 'block' : 'none';
            $('ViewProfileManageAddressesDiv').style.display = $('ShowProfileAllowEdit').checked ? 'block' : 'none';            
            $('ViewProfileViewAddressesDiv').style.display = $('ShowProfileAllowEdit').checked ? 'none' : 'block';            
            $('VCardDiv').style.display = 'block';
            $('UploadedImagesDiv').style.display = $('ShowProfileAllowEdit').checked ? 'block' : 'none';            
            $('ErrorMessagesDIV').style.display = $('ShowProfileAllowEdit').checked ? 'block' : 'none';
            showLoginSettingsPane(false);
            displayAddressMessages(true);
        } else if ($('ShowRadioEditAddress').checked) {
            $('ShowListDiv').style.display = 'none';
            $('ShowProfileDiv').style.display = 'none';
            $('CreateProfileDiv').style.display = 'none';
            $('AdminNotificationEmailGroup').style.display = 'none';
            $('UserNotificationEmailGroup').style.display = 'none';
            $('RedirectionDiv').style.display = 'none';
            $('ViewProfileDiv').style.display = 'none';
            $('ViewProfileEditProfileDiv').style.display = 'none';
            $('ViewProfileManageAddressesDiv').style.display = 'block';
            $('ViewProfileViewAddressesDiv').style.display = 'none';
            $('VCardDiv').style.display = 'block';
            $('UploadedImagesDiv').style.display = 'none';
            $('ErrorMessagesDIV').style.display = 'none';
            showLoginSettingsPane(false);
            displayAddressMessages(true);
        } else if ($('ShowRadioCreate').checked) {
            $('ShowListDiv').style.display = 'none';
            $('ShowProfileDiv').style.display = 'none';
            $('CreateProfileDiv').style.display = 'block';
            $('AdminNotificationEmailGroup').style.display = 'block';
            $('UserNotificationEmailGroup').style.display = 'block';
            $('RedirectionDiv').style.display = 'block';
            $('ViewProfileManageAddressesDiv').style.display = 'none';
            $('ViewProfileViewAddressesDiv').style.display = 'none';            
            $('VCardDiv').style.display = 'none';
            $('UploadedImagesDiv').style.display = 'block';            
            $('ErrorMessagesDIV').style.display = 'block';
            showLoginSettingsPane(false);
            displayAddressMessages(false);
        } else if ($('ShowRadioEdit').checked) {
            $('ShowListDiv').style.display = 'none';
            $('ShowProfileDiv').style.display = 'block';
            $('CreateProfileDiv').style.display = 'none';
            $('AdminNotificationEmailGroup').style.display = 'none';
            $('UserNotificationEmailGroup').style.display = 'none';
            $('RedirectionDiv').style.display = 'none';
            $('ViewProfileDiv').style.display = 'none';
            $('ViewProfileEditProfileDiv').style.display = 'block';
            $('ViewProfileManageAddressesDiv').style.display = 'none';
            $('ViewProfileViewAddressesDiv').style.display = 'none';
            $('VCardDiv').style.display = 'none';
            $('UploadedImagesDiv').style.display = 'none';
            $('ErrorMessagesDIV').style.display = 'block';
            showLoginSettingsPane(false);
            displayAddressMessages(false);
        } else if ($('ShowRadioLogin').checked) {
            $('ShowListDiv').style.display = 'none';
            $('ShowProfileDiv').style.display = 'none';
            $('CreateProfileDiv').style.display = 'none';
            $('AdminNotificationEmailGroup').style.display = 'none';
            $('UserNotificationEmailGroup').style.display = 'none';
            $('RedirectionDiv').style.display = 'none';
            $('ViewProfileManageAddressesDiv').style.display = 'none';
            $('ViewProfileViewAddressesDiv').style.display = 'none';
            $('VCardDiv').style.display = 'none';
            $('UploadedImagesDiv').style.display = 'none';
            $('ErrorMessagesDIV').style.display = 'none';
            showLoginSettingsPane(true);
            displayAddressMessages(false);
        }
        toggleCreateProfileRedirect();
    }

    function showLoginSettingsPane(show) {
        $('login-settings-pane').style.display = show ? 'block' : 'none';
        if (show) {
            $('ErrorMessagesDIV').style.display = 'block';
        }
    }

    function displayAddressMessages(show) {
        $('DeleteAddressMessageRow').style.display = show ? 'table-row' : 'none';
        $('DeleteMainAddressMessageRow').style.display = show ? 'table-row' : 'none';
        $('DeleteDefaultAddressMessageRow').style.display = show ? 'table-row' : 'none';
    }

    function toggleCreateProfileRedirect() {        
        if ($('CreateProfileRedirectTypePage').checked) {
            $('CreateProfileRedirectPageDiv').style.display = 'block';
            $('CreateProfileRedirectTemplateDiv').style.display = 'none';            
        } else {
            $('CreateProfileRedirectPageDiv').style.display = 'none';            
            $('CreateProfileRedirectTemplateDiv').style.display = 'block';            
        }
    }

    function toggleAutoLogin() {
        $('CreateProfileAutoLoginDiv').style.display = $('CreateProfileApprovalRadioNone').checked ? 'block' : 'none';
        $('UserConfirmationEmailGroup').style.display = $('CreateProfileApprovalRadioNone').checked || $('CreateProfileApprovalRadioByAdmin').checked ? 'none' : 'block';
        $('UserConfirmationEmailGroup').style.display = $('CreateProfileApprovalRadioByUser').checked ? 'block' : 'none';
    }

    function toggleProfileUserMode()
    {
        var userSelector = $('ShowProfileUserSelectorContainer');
        var allowEdit = $('ShowProfileAllowEdit');
        var allowEditDiv = $('ShowProfileAllowEditDiv');

        if ($('ShowProfileUserSelected').checked) {
            
            allowEdit.checked = false;
            allowEditDiv.style.display = "none";

            userSelector.style.display = "table-row";
        }
        else {
            allowEditDiv.style.display = "block";
            userSelector.style.display = "none";
        }
        
        toggleShow();
    }

    function userManagementValidate() {
        if ($('ListUserSelectorhidden').value.split(",").length > 1
            && $('ListSortByRadioSorting').checked
            && $('ShowRadioList').checked) {
            alert('<%=Translate.JsTranslate("The paragraph was not saved because you have selected several user groups and orderign by Backend sorting. Leave please one user group or choose another ordering.") %>');
            return false;
        } else if ($('ShowRadioCreate').checked 
            && $('CreateProfileNewUserGroupshidden').value.length == 0 
            && $('CreateProfileSelectableGroupshidden').value.length == 0) {
            alert('<%=Translate.JsTranslate("Created user should be assigned to any user group!") %>');
            return false;
        }
        return true;
    }
    window["paragraphEvents"].setValidator(userManagementValidate);
</script>

<dw:ModuleHeader ID="ModuleHeader1" runat="server" ModuleSystemName="UserManagementFrontend" />

<input type="hidden" name="UserManagementFrontend_settings"
    value="ShowRadio,ListTemplate,ListUserSelectorHidden,ListIncludeSubs,ListIncludeSubsRadio,ListIncludeSubsLevels,DetailUserTemplate,DetailGroupTemplate,ListEditUserTemplate,ShowProfileTemplate,CreateProfileTemplate,CreateProfileApprovalRadio,CreateProfileNewUserGroupsHidden,ConfirmationEmailTemplate,ConfirmationEmailFromAddress,ConfirmationEmailSubject,NotificationEmailTemplate,NotificationEmailFromAddress,NotificationEmailSubject,NotificationEmailRecipientsHidden,CreateProfileSelectableGroupsHidden,ListEditUserSelectableGroupsHidden,ShowProfileAllowEdit,CreateProfileRedirectType,CreateProfileRedirectPage,CreateProfileRedirectTemplate,CreateProfileAutoLogin,ApprovalRedirectPage,ListSortByRadio,ListSortOrderRadio,ShowProfileEditUserTemplate,ShowProfileEditAddressesTemplate,ShowProfileViewAddressesTemplate,ShowProfileAddAddressTemplate,ShowProfileSelectableGroupsHidden,UploadedImagesFolder,UploadedImagesEnableMaxWidth,UploadedImagesMaxWidth,UploadedImagesEnableMaxHeight,UploadedImagesMaxHeight,PagingSettings,ErrorEmtyPassword,ErrorDuplicateEmail,ErrorPasswordsNotMatch,ErrorWrongPassword,ErrorPasswordLength,ErrorEmtyUsername,ErrorEmtyEmail,ErrorEmailNotFound,IncorrectEmailFormat,SearchTemplate,SearchResultTemplate,LoggedInRedirectPage,VCardFeildsString, ErrorUsernameTaken,DeleteMainAddressMessage,DeleteDefaultAddressMessage,DeleteAddressMessage,ErrorIllegalPasswordCharacters,ErrorPasswordSmallLength,ErrorPasswordComplexity,ErrorPasswordReuse,ShowProfileUser,ShowProfileUserID_CustomSelector,LoginTemplate,PasswordResetTemplate,PasswordRecoveryTemplate,PasswordRecoveryUserFields,PasswordRecoveryOperator,PasswordRecoveryMethod, PasswordRecoveryLinkLifeTime, PasswordRecoveryEmailTemplate,PasswordRecoveryEmailFrom, PasswordRecoveryEmailSubject,ErrorEmptyField,LoginSuccessRedirectToPage,MatchAnonymousOrdersOnEmail,DoUpdateUsersByEmail,RequireUniqueEmails, ConfirmationEmailFromName,NotificationEmailFromName,UserNotificationEmailTemplate,UserNotificationEmailFromAddress,UserNotificationEmailFromName,UserNotificationEmailSubject,ErrorWrongCountryCode,UseEmailForUserName,CreateProfileEmailAllowedActivity,EditProfileEmailAllowedActivity,SetProfile" />

<dw:GroupBox ID="GroupBox1" runat="server" Title="Show" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td></td>
            <td>
                <div class="radio">
                    <input type="radio" runat="server" name="ShowRadio" id="ShowRadioList" value="ShowRadioList" onclick="javascript:toggleShow();" />
                    <label for="ShowRadioList">
                        <dw:TranslateLabel runat="server" Text="List" />
                    </label>
                    <br />
                </div>
                <div class="radio">
                    <input type="radio" runat="server" name="ShowRadio" id="ShowRadioProfile" value="ShowRadioProfile" onclick="javascript:toggleShow();" />
                    <label for="ShowRadioProfile">
                        <dw:TranslateLabel runat="server" Text="View profile" />
                    </label>
                    <br />
                </div>
                 <div class="radio">
                    <input type="radio" runat="server" name="ShowRadio" id="ShowRadioEditAddress" value="ShowRadioEditAddress" onclick="javascript: toggleShow();" />
                    <label for="ShowRadioEditAddress">
                        <dw:TranslateLabel runat="server" Text="Manage addresses" />
                    </label>
                    <br />
                </div>
                <div class="radio">
                    <input type="radio" runat="server" name="ShowRadio" id="ShowRadioCreate" value="ShowRadioCreate" onclick="javascript:toggleShow();" />
                    <label for="ShowRadioCreate">
                        <dw:TranslateLabel runat="server" Text="Create profile" />
                        /
                        <dw:TranslateLabel runat="server" Text="Manage subscription" />
                    </label>
                    <br />
                </div>
                <div class="radio">
                    <input type="radio" runat="server" name="ShowRadio" id="ShowRadioEdit" value="ShowRadioEdit" onclick="javascript: toggleShow();" />
                    <label for="ShowRadioEdit">
                        <dw:TranslateLabel runat="server" Text="Edit profile" />
                    </label>
                    <br />
                </div>
                <div class="radio">
                    <input type="radio" runat="server" name="ShowRadio" id="ShowRadioLogin" value="ShowRadioLogin" onclick="javascript: toggleShow();" />
                    <label for="ShowRadioLogin">
                        <dw:TranslateLabel runat="server" Text="Login" />
                    </label>
                    <br />
                </div>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<div id="ShowListDiv">
    <dw:GroupBox ID="GroupBox2" runat="server" Title="List" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="ListTemplate" Name="ListTemplate" Folder="Templates/UserManagement/List" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Users and groups" />
                </td>
                <td>
                    <dw:UserSelector runat="server" ID="ListUserSelector" NoneSelectedText="No users or groups selected" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Hierarchy" />
                </td>
                <td>
                    <dw:CheckBox ID="ListIncludeSubs" runat="server" Name="ListIncludeSubs" onclick="javascript:toggleIncludeSubsDiv();" Label="Include subgroups and users from the selected group(s)" />
                </td>
            </tr>
            <tr id="IncludeSubsDiv" style="display: none;">
                <td></td>
                <td>
                    <div class="radio">
                        <input type="radio" runat="server" name="ListIncludeSubsRadio" id="ListIncludeSubsRadioAll" value="ListIncludeSubsRadioAll" />
                        <label for="ListIncludeSubsRadioAll">
                            <dw:TranslateLabel runat="server" Text="All" />
                        </label>
                    </div>
                    <div class="radio">
                        <input type="radio" runat="server" name="ListIncludeSubsRadio" id="ListIncludeSubsRadioLevels" value="ListIncludeSubsRadioLevels" />
                        <label for="ListIncludeSubsRadioLevels">
                            <dw:TranslateLabel runat="server" Text="levels" />
                        </label>
                    </div>
                    <input type="text" runat="server" id="ListIncludeSubsLevels" size="2" onclick="javascript:$(ListIncludeSubsRadioLevels).checked = true;" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Sort users" />
                </td>
                <td>
                    <span id="ListSortingLabel"></span>&nbsp;&nbsp;&nbsp;
					<dw:Button runat="server" Name="Change sorting" OnClick="dialog.show('ListEditSortingDialog');" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <dw:PagingSettings runat="server" ID="PagingSettings" />

    <dw:Dialog runat="server" Title="Edit sorting" ID="ListEditSortingDialog" ShowOkButton="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Sort users by" />
                </td>
                <td>

                    <div class="radio">
                        <input runat="server" type="radio" name="ListSortByRadio" id="ListSortByRadioName" value="ListSortByRadioName" onclick="UpdateSortLabel();" />
                        <label for="ListSortByRadioName">
                            <span id="ListSortByRadioNameLabel">
                                <dw:TranslateLabel runat="server" Text="Name" />
                            </span>
                        </label>
                    </div>
                    <div class="radio">
                        <input runat="server" type="radio" name="ListSortByRadio" id="ListSortByRadioUsername" value="ListSortByRadioUsername" onclick="UpdateSortLabel();" />
                        <label for="ListSortByRadioUsername">
                            <span id="ListSortByRadioUsernameLabel">
                                <dw:TranslateLabel runat="server" Text="Username" />
                            </span>
                        </label>
                    </div>
                    <div class="radio">
                        <input runat="server" type="radio" name="ListSortByRadio" id="ListSortByRadioSorting" value="ListSortByRadioSorting" onclick="UpdateSortLabel();" />
                        <label for="ListSortByRadioSorting">
                            <span id="ListSortByRadioSortingLabel">
                                <dw:TranslateLabel runat="server" Text="Backend order (possible only with one user group)" />
                            </span>
                        </label>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Sort order" />
                </td>
                <td>

                    <div class="radio">
                        <input runat="server" type="radio" name="ListSortOrderRadio" id="ListSortOrderRadioAsc" value="ListSortOrderRadioAsc" onclick="UpdateSortLabel();" />
                        <label for="ListSortOrderRadioAsc">
                            <span id="ListSortOrderRadioAscLabel">
                                <dw:TranslateLabel runat="server" Text="Ascending" />
                            </span>
                        </label>
                    </div>
                    <div class="radio">
                        <input runat="server" type="radio" name="ListSortOrderRadio" id="ListSortOrderRadioDesc" value="ListSortOrderRadioDesc" onclick="UpdateSortLabel();" />
                        <label for="ListSortOrderRadioDesc">
                            <span id="ListSortOrderRadioDescLabel">
                                <dw:TranslateLabel runat="server" Text="Descending" />
                            </span>
                        </label>
                    </div>
                </td>
            </tr>
        </table>
    </dw:Dialog>
    <script type="text/javascript">
        function UpdateSortLabel() {
            var label = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Sort by") %> ';
            if ($('ListSortByRadioName').checked)
                label += text($('ListSortByRadioNameLabel'));
            else if ($('ListSortByRadioUsername').checked)
                label += text($('ListSortByRadioUsernameLabel'));
            else if ($('ListSortByRadioSorting').checked)
                label += text($('ListSortByRadioSortingLabel'));

            label += ', ';

            if ($('ListSortOrderRadioAsc').checked)
                label += text($('ListSortOrderRadioAscLabel'));
            else if ($('ListSortOrderRadioDesc').checked)
                label += text($('ListSortOrderRadioDescLabel'));

            $('ListSortingLabel').innerHTML = label;

        }

        function text(elm) {
            return elm.innerText ? elm.innerText : elm.textContent;
        }
    </script>

    <dw:GroupBox ID="GroupBox3" runat="server" Title="Details - User" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="DetailUserTemplate" Name="DetailUserTemplate" Folder="Templates/UserManagement/List" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <dw:GroupBox ID="GroupBox4" runat="server" Title="Details - Group" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="DetailGroupTemplate" Name="DetailGroupTemplate" Folder="Templates/UserManagement/List" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <div id="SearchDiv">
        <dw:GroupBox ID="GroupBox6" Title="Search" DoTranslation="true" runat="server">
            <table class="formsTable">
                <tr>
                    <td>
                        <dw:TranslateLabel id="lbSearchTemplate" Text="Template" runat="server" />
                    </td>
                    <td>
                        <dw:FileManager runat="server" ID="SearchTemplate" Name="SearchTemplate" Folder="Templates/UserManagement/Search" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel id="lbSearchResultTemplate" Text="Results template" runat="server" />
                    </td>
                    <td>
                        <dw:FileManager runat="server" ID="SearchResultTemplate" Name="SearchResultTemplate" Folder="Templates/UserManagement/List" />
                    </td>
                </tr>
            </table>
        </dw:GroupBox>
    </div>
</div>

<div id="ShowProfileDiv">
    <div id="ViewProfileDiv">
        <dw:GroupBox ID="GroupBox7" runat="server" Title="Details - User" DoTranslation="true">
            <table class="formsTable">
                <tr>
                    <td>
                        <dw:TranslateLabel runat="server" Text="Template" />
                    </td>
                    <td>
                        <dw:FileManager runat="server" ID="ShowProfileTemplate" Name="ShowProfileTemplate" Folder="Templates/UserManagement/ViewProfile" />
                    </td>
                </tr>

                <tr>
                    <td>
                        <dw:TranslateLabel runat="server" Text="Show profile" />
                    </td>
                    <td>

                        <div class="radio">
                            <input runat="server" type="radio" name="ShowProfileUser" id="ShowProfileUserLoggedIn" value="ShowProfileUserLoggedIn" onclick="toggleProfileUserMode()" />
                            <label for="ShowProfileUserLoggedIn">
                                <dw:TranslateLabel runat="server" Text="Logged in user" />
                            </label>
                        </div>
                        <div class="radio">

                            <input runat="server" type="radio" name="ShowProfileUser" id="ShowProfileUserSelected" value="ShowProfileUserSelected" onclick="toggleProfileUserMode()" />
                            <label for="ShowProfileUserSelected">
                                <dw:TranslateLabel runat="server" Text="Selected user" />
                            </label>
                        </div>

                    </td>
                </tr>

                <tr id="ShowProfileUserSelectorContainer">
                    <td>
                        <dw:TranslateLabel runat="server" Text="Select user" />
                    </td>
                    <td>
                        <dw:EditableListColumnUserEditor ID="ShowProfileUserID_CustomSelector" runat="server" ClientIDMode="Static" Width="190" />
                    </td>
                </tr>

                <tr>
                    <td></td>
                    <td>
                        <div id="ShowProfileAllowEditDiv">
                            <dw:CheckBox ID="ShowProfileAllowEdit" runat="server" onclick="javascript:toggleShow();" Label="Allow editing" />
                        </div>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>
    </div>
    <div id="ViewProfileEditProfileDiv">
        <dw:GroupBox ID="GroupBox8" runat="server" Title="Edit profile" DoTranslation="true">
            <table class="formsTable">
                <tr>
                    <td>
                        <dw:TranslateLabel runat="server" Text="Template" />
                    </td>
                    <td>
                        <dw:FileManager runat="server" ID="ShowProfileEditUserTemplate" Name="ShowProfileEditUserTemplate" Folder="Templates/UserManagement/ViewProfile" />
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: top;">
                        <dw:TranslateLabel runat="server" text="User selectable groups" />
                    </td>
                    <td>
                        <dw:UserSelector runat="server" ID="ShowProfileSelectableGroups" Show="Groups" HeightInRows="5" />
                    </td>
                </tr>
                <tr id="EditProfileEmailAllowedActivityRow" runat="server">
                    <td style="vertical-align:top;">
                        <dw:TranslateLabel runat="server" text="Email consent" />
                    </td>
                    <td>
                        <select id="EditProfileEmailAllowedActivity" name="EditProfileEmailAllowedActivity" runat="server" class="std">
                        </select>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>
    </div>
</div>

<div id="CreateProfileDiv">
    <dw:GroupBox ID="GroupBox13" runat="server" Title="Create user" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="CreateProfileTemplate" Name="CreateProfileTemplate" Folder="Templates/UserManagement/CreateProfile" />
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;">
                    <dw:TranslateLabel runat="server" Text="Approval" />
                </td>
                <td>

                    <div class="radio">
                        <input runat="server" type="radio" name="CreateProfileApprovalRadio" id="CreateProfileApprovalRadioNone" value="CreateProfileApprovalRadioNone" onclick="javascript:toggleAutoLogin();" />
                        <label for="CreateProfileApprovalRadioNone">
                            <dw:TranslateLabel runat="server" Text="None" />
                        </label>
                    </div>


                    <div id="CreateProfileAutoLoginDiv" style="margin: 5px 0px 10px 10px;">
                        <dw:CheckBox ID="CreateProfileAutoLogin" name="CreateProfileAutoLogin" runat="server" Label="Auto login after creation" />
                    </div>


                    <div class="radio">
                        <input runat="server" type="radio" name="CreateProfileApprovalRadio" id="CreateProfileApprovalRadioByAdmin" value="CreateProfileApprovalRadioByAdmin" onclick="javascript:toggleAutoLogin();" />
                        <label for="CreateProfileApprovalRadioByAdmin">
                            <dw:TranslateLabel runat="server" Text="By admin" />
                        </label>
                    </div>
                    <div class="radio">

                        <input runat="server" type="radio" name="CreateProfileApprovalRadio" id="CreateProfileApprovalRadioByUser" value="CreateProfileApprovalRadioByUser" onclick="javascript:toggleAutoLogin();" />
                        <label for="CreateProfileApprovalRadioByUser">
                            <dw:TranslateLabel runat="server" Text="By user" />
                        </label>
                    </div>
                </td>
            </tr>
            <tr style="vertical-align: top;">
                <td>
                    <dw:TranslateLabel runat="server" Text="Groups for new users" />
                </td>
                <td>
                    <dw:UserSelector runat="server" ID="CreateProfileNewUserGroups" NoneSelectedText="No group selected" Show="Groups" HeightInRows="3" />
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;">
                    <dw:TranslateLabel runat="server" text="User selectable groups" />
                </td>
                <td>
                    <dw:UserSelector runat="server" ID="CreateProfileSelectableGroups" Show="Groups" HeightInRows="5" />
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;"></td>
                <td>
                    <dw:CheckBox ID="MatchAnonymousOrdersOnEmail" name="MatchAnonymousOrdersOnEmail" Label="Match anonymous orders on the email address" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;"></td>
                <td>
                    <dw:CheckBox ID="DoUpdateUsersByEmail" name="DoUpdateUsersByEmail" Label="Update existing users based on email match" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;"></td>
                <td>
                    <dw:CheckBox ID="RequireUniqueEmails" name="RequireUniqueEmails" Label="Require unique emails" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="vertical-align:top;"></td>
                <td>
                    <dw:CheckBox ID="UseEmailForUserName" name="UseEmailForUserName" Label="Use email for user name" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="vertical-align:top;"></td>
                <td>
                    <dw:CheckBox ID="SetProfile" name="SetProfile" Label="Set profile" runat="server" />
                </td>
            </tr>
            <tr id="CreateProfileEmailAllowedActivityRow" runat="server">
                <td style="vertical-align:top;">
                    <dw:TranslateLabel runat="server" text="Email consent" />
                </td>
                <td>
                    <select id="CreateProfileEmailAllowedActivity" name="CreateProfileEmailAllowedActivity" runat="server" class="std">
                    </select>
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <div id="UserConfirmationEmailGroup">
        <dw:GroupBox ID="GroupBox14" runat="server" Title="User confirmation e-mail" DoTranslation="true">
            <table class="formsTable">
                <tr>
                    <td>
                        <dw:TranslateLabel runat="server" Text="Template" />
                    </td>
                    <td>
                        <dw:FileManager runat="server" ID="ConfirmationEmailTemplate" Name="ConfirmationEmailTemplate" Folder="Templates/UserManagement/CreateProfile" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel runat="server" Text="From address" />
                    </td>
                    <td>
                        <input type="text" runat="server" class="std" id="ConfirmationEmailFromAddress" /></td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel runat="server" Text="From name" />
                    </td>
                    <td>
                        <input type="text" runat="server" class="std" id="ConfirmationEmailFromName" /></td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel runat="server" Text="Subject" />
                    </td>
                    <td>
                        <input type="text" runat="server" class="std" id="ConfirmationEmailSubject" /></td>
                </tr>
            </table>
        </dw:GroupBox>
    </div>
</div>

<div id="AdminNotificationEmailGroup">
    <dw:GroupBox ID="GroupBox15" runat="server" Title="Admin notification e-mail" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="NotificationEmailTemplate" Name="NotificationEmailTemplate" Folder="Templates/UserManagement/CreateProfile" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="From address" />
                </td>
                <td>
                    <input type="text" runat="server" class="std" id="NotificationEmailFromAddress" /></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="From name" />
                </td>
                <td>
                    <input type="text" runat="server" class="std" id="NotificationEmailFromName" /></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Subject" />
                </td>
                <td>
                    <input type="text" runat="server" class="std" id="NotificationEmailSubject" /></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Recipients" />
                </td>
                <td>
                    <dw:UserSelector runat="server" Show="Users" HeightInRows="3" ID="NotificationEmailRecipients" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>
<div id="UserNotificationEmailGroup">
    <dw:GroupBox ID="GroupBox10" runat="server" Title="User notification e-mail" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="UserNotificationEmailTemplate" Name="UserNotificationEmailTemplate" Folder="Templates/UserManagement/CreateProfile" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="From address" />
                </td>
                <td>
                    <input type="text" runat="server" class="std" id="UserNotificationEmailFromAddress" /></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="From name" />
                </td>
                <td>
                    <input type="text" runat="server" class="std" id="UserNotificationEmailFromName" /></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Subject" />
                </td>
                <td>
                    <input type="text" runat="server" class="std" id="UserNotificationEmailSubject" /></td>
            </tr>
        </table>
    </dw:GroupBox>
</div>
<div id="RedirectionDiv">
    <dw:GroupBox ID="GroupBox16" runat="server" Title="Redirection" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="After creation, redirect to" />
                </td>
                <td>

                    <div class="radio">
                        <input type="radio" runat="server" name="CreateProfileRedirectType" id="CreateProfileRedirectTypePage" onclick="javascript:toggleCreateProfileRedirect();" />
                        <label for="CreateProfileRedirectTypePage">
                            <dw:TranslateLabel runat="server" Text="Page" />
                        </label>
                    </div>
                    <div class="radio">
                        <input type="radio" runat="server" name="CreateProfileRedirectType" id="CreateProfileRedirectTypeTemplate" onclick="javascript:toggleCreateProfileRedirect();" />
                        <label for="CreateProfileRedirectTypeTemplate">
                            <dw:TranslateLabel runat="server" Text="Template" />
                        </label>
                    </div>


                    <div id="CreateProfileRedirectPageDiv">
                        <dw:LinkManager runat="server" ID="CreateProfileRedirectPage" />
                    </div>
                    <div id="CreateProfileRedirectTemplateDiv">
                        <dw:FileManager runat="server" ID="CreateProfileRedirectTemplate" Name="CreateProfileRedirectTemplate" Folder="Templates/UserManagement/CreateProfile" />
                    </div>
                </td>
            </tr>
            <tr id="AfterApprovalRedirectToRow">
                <td style="vertical-align: top;">
                    <dw:TranslateLabel runat="server" Text="After approval, redirect to" />
                </td>
                <td>
                    <dw:LinkManager runat="server" ID="ApprovalRedirectPage" />
                </td>
            </tr>
            <tr id="IfLoggedInRedirectToRow">
                <td style="vertical-align: top;">
                    <dw:TranslateLabel runat="server" Text="If logged in, redirect to" />
                </td>
                <td>
                    <dw:LinkManager runat="server" ID="LoggedInRedirectPage" DisableFileArchive="True" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="ViewProfileManageAddressesDiv">
    <dw:GroupBox ID="GroupBox9" runat="server" Title="Manage addresses" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Template - Address list" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="ShowProfileEditAddressesTemplate" Name="ShowProfileEditAddressesTemplate" Folder="Templates/UserManagement/Addresses" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Template - Create address" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="ShowProfileAddAddressTemplate" Name="ShowProfileAddAddressTemplate" Folder="Templates/UserManagement/Addresses" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="ViewProfileViewAddressesDiv">
    <dw:GroupBox ID="GroupBox20" runat="server" Title="View addresses" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Template - Address list" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="ShowProfileViewAddressesTemplate" Name="ShowProfileViewAddressesTemplate" Folder="Templates/UserManagement/Addresses" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="VCardDiv">
    <dw:GroupBox ID="GroupBox17" runat="server" Title="vCard" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Insert into vCard" />
                </td>
                <td>
                    <div class="chb-list">
                        <dwc:CheckBoxGroup ID="VCardFields" Name="VCardFeildsString" runat="server"></dwc:CheckBoxGroup>
                    </div>
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="UploadedImagesDiv">
    <dw:GroupBox ID="GroupBox18" runat="server" Title="Uploaded images" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Folder" />
                </td>
                <td>
                    <dw:FolderManager runat="server" name="UploadedImagesFolder" id="UploadedImagesFolder" />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <dw:CheckBox ID="UploadedImagesEnableMaxWidth" name="UploadedImagesEnableMaxWidth" Label="Resize - Max width" runat="server" />
                    <input runat="server" type="number" min="0" name="UploadedImagesMaxWidth" id="UploadedImagesMaxWidth" size="5" class="std" />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <dw:CheckBox ID="UploadedImagesEnableMaxHeight" name="UploadedImagesEnableMaxHeight" Label="Resize - Max height" runat="server" />
                    <input runat="server" type="number" min="0" name="UploadedImagesMaxHeight" id="UploadedImagesMaxHeight" size="5" class="std" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="login-settings-pane">
    <dw:GroupBox ID="GroupBox5" runat="server" Title="Login settings" DoTranslation="true" ClassName="login-settings">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Login Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="LoginTemplate" Name="LoginTemplate" Folder="Templates/UserManagement/Login" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Password Recovery Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="PasswordRecoveryTemplate" Name="PasswordRecoveryTemplate" Folder="Templates/UserManagement/Login" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Password Reset Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="PasswordResetTemplate" Name="PasswordResetTemplate" Folder="Templates/UserManagement/Login" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="On login, redirect to" />
                </td>
                <td>
                    <dw:LinkManager runat="server" ID="LoginSuccessRedirectToPage" DisableFileArchive="True" DisableParagraphSelector="True" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Fields for password recovery" />
                </td>
                <td>
                    <div class="chb-list">
                        <dwc:CheckBoxGroup ID="PasswordRecoveryUserFields" Name="PasswordRecoveryUserFields" runat="server"></dwc:CheckBoxGroup>
                    </div>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>

                    <div class="radio">

                        <input class="rpm" type="radio" runat="server" name="PasswordRecoveryOperator" id="RecoveryOperatorAND" value="" />
                        <label class="row" for="RecoveryOperatorAND">
                            <dw:TranslateLabel runat="server" Text="All selected fields must apply" />
                        </label>
                    </div>

                    <div class="radio">
                        <input class="rpm" type="radio" runat="server" name="PasswordRecoveryOperator" id="RecoveryOperatorOR" value="AnyField" />
                        <label class="row" for="RecoveryOperatorOR">
                            <dw:TranslateLabel runat="server" Text="Any selected fields must apply" />
                        </label>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Restore password method" />
                </td>
                <td id="restore-method-pane">
                    <div class="radio">
                        <input class="rpm" type="radio" runat="server" name="PasswordRecoveryMethod" id="SendExistingPassword" value="SendExistingPassword" />
                        <label class="row" for="SendExistingPassword">
                            <dw:TranslateLabel runat="server" Text="Send existing password" />
                        </label>
                    </div>
                    <div class="radio">
                        <input class="rpm" type="radio" runat="server" name="PasswordRecoveryMethod" id="SendNewPassword" value="SendNewPassword" />
                        <label class="row" for="SendNewPassword">
                            <dw:TranslateLabel runat="server" Text="Send new password" />
                        </label>
                    </div>
                    <div class="radio">
                        <input class="rpm" type="radio" runat="server" name="PasswordRecoveryMethod" id="SendRestoreLink" value="SendRestoreLink" />
                        <label class="row" for="SendRestoreLink">
                            <dw:TranslateLabel runat="server" Text="Send link to reset page" />
                        </label>
                    </div>

                    <div class="send-restore-pwd-link-options">
                        <label for="PasswordRecoveryLinkLifeTime">
                            <dw:TranslateLabel runat="server" Text="Link active in" />
                        </label>
                        <input type="text" runat="server" name="PasswordRecoveryLinkLifeTime" id="PasswordRecoveryLinkLifeTime" size="2" />
                        hrs
                    </div>
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <dw:GroupBox runat="server" Title="Email settings">
        <dw:FileManager Label="Template" runat="server" ID="PasswordRecoveryEmailTemplate" Name="PasswordRecoveryEmailTemplate" Folder="Templates/UserManagement/Login" />
        <dwc:InputText runat="server" ID="PasswordRecoveryEmailFrom" Label="From address" />
        <dwc:InputText runat="server" ID="PasswordRecoveryEmailSubject" Label="Subject" />
    </dw:GroupBox>
</div>
<div id="ErrorMessagesDIV">
    <dw:GroupBox ID="GroupBox19" runat="server" Title="Error messages" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <label for="IncorrectEmailFormat">
                        <dw:TranslateLabel runat="server" Text="Incorrect e-mail format" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="IncorrectEmailFormat" id="IncorrectEmailFormat" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorEmtyEmail">
                        <dw:TranslateLabel runat="server" Text="Empty e-mail" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorEmtyEmail" id="ErrorEmtyEmail" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorDuplicateEmail">
                        <dw:TranslateLabel runat="server" Text="Duplicate e-mail" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorDuplicateEmail" id="ErrorDuplicateEmail" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorEmailNotFound">
                        <dw:TranslateLabel runat="server" Text="E-mail is not found" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorEmailNotFound" id="ErrorEmailNotFound" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorEmtyUsername">
                        <dw:TranslateLabel runat="server" Text="Empty username" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorEmtyUsername" id="ErrorEmtyUsername" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorUsernameTaken">
                        <dw:TranslateLabel runat="server" Text="Username is taken" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorUsernameTaken" id="ErrorUsernameTaken" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorEmtyPassword">
                        <dw:TranslateLabel runat="server" Text="Empty password" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorEmtyPassword" id="ErrorEmtyPassword" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorPasswordsNotMatch">
                        <dw:TranslateLabel runat="server" Text="Passwords do not match" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorPasswordsNotMatch" id="ErrorPasswordsNotMatch" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorWrongPassword">
                        <dw:TranslateLabel runat="server" Text="Wrong password" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorWrongPassword" id="ErrorWrongPassword" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorPasswordLength">
                        <dw:TranslateLabel runat="server" Text="Password length = 32" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorPasswordLength" id="ErrorPasswordLength" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorIllegalPasswordCharacters">
                        <dw:TranslateLabel runat="server" Text="Illegal password characters" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorIllegalPasswordCharacters" id="ErrorIllegalPasswordCharacters" value="" />
                </td>
            </tr>
            <tr id="DeleteAddressMessageRow">
                <td>
                    <label for="DeleteAddressMessage">
                        <dw:TranslateLabel runat="server" Text="Delete address message" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="DeleteAddressMessage" id="DeleteAddressMessage" value="" />
                </td>
            </tr>
            <tr id="DeleteMainAddressMessageRow">
                <td>
                    <label for="DeleteMainAddressMessage">
                        <dw:TranslateLabel runat="server" Text="Delete main address message" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="DeleteMainAddressMessage" id="DeleteMainAddressMessage" value="" />
                </td>
            </tr>
            <tr id="DeleteDefaultAddressMessageRow">
                <td>
                    <label for="DeleteDefaultAddressMessage">
                        <dw:TranslateLabel runat="server" Text="Delete default address message" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="DeleteDefaultAddressMessage" id="DeleteDefaultAddressMessage" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorPasswordSmallLength">
                        <dw:TranslateLabel runat="server" Text="Min. number of characters" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorPasswordSmallLength" id="ErrorPasswordSmallLength" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorPasswordComplexity">
                        <dw:TranslateLabel runat="server" Text="Password complexity" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorPasswordComplexity" id="ErrorPasswordComplexity" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorPasswordReuse">
                        <dw:TranslateLabel runat="server" Text="Password reuse" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorPasswordReuse" id="ErrorPasswordReuse" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorEmptyField">
                        <dw:TranslateLabel runat="server" Text="Empty field" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorEmptyField" id="ErrorEmptyField" value="" />
                </td>
            </tr>
            <tr>
                <td>
                    <label for="ErrorEmptyField">
                        <dw:TranslateLabel runat="server" Text="Wrong country code" />
                    </label>
                </td>
                <td>
                    <input type="text" class="std" runat="server" name="ErrorWrongCountryCode" id="ErrorWrongCountryCode" value="" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<script type="text/javascript">
    function initPasswordRecoverPane() {
        var cnt = $("restore-method-pane");
        var selOptions = cnt.select(".rpm:radio:checked");
        var fn = function (e, el) {
            cnt.className = el.value;
        };
        if (selOptions.length > 0) {
            fn(null, selOptions[0]);
        }        
        cnt.on("change", " .rpm", fn);
    }

    <%=RegisterAjaxControlScripts()%>

    toggleIncludeSubsDiv();
    toggleShow();
    toggleCreateProfileRedirect();
    toggleAutoLogin();
    UpdateSortLabel();
    toggleProfileUserMode();

    initPasswordRecoverPane();
</script>
