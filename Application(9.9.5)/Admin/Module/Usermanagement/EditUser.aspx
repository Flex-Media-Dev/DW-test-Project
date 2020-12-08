<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditUser.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement.EditUser" ValidateRequest="false" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.Security.UserManagement" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="user" Namespace="Dynamicweb.Admin.UserManagement" Assembly="Dynamicweb.Admin" %>
<%@ Register TagPrefix="omc" TagName="VisitsList" Src="~/Admin/Module/OMC/Controls/VisitsList.ascx" %>
<%@ Register TagPrefix="emp" TagName="UCOrderList" Src="/Admin/Module/eCom_Catalog/dw7/UCOrderList.ascx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="Stylesheet" type="text/css" href="/Admin/Module/eCom_Catalog/dw7/css/OrderList.css" media="screen" />
    <link rel="Stylesheet" type="text/css" href="/Admin/Module/eCom_Catalog/dw7/css/OrderListPrint.css" media="print" />

    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUIStylesheet="true">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/queryString.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/OrderList.js" />
            <dw:GenericResource Url="EditUser.js" />
            <dw:GenericResource Url="ItemEdit.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        <% If Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "selectuser" Then %>
        dwGlobal.getUsersNavigator().expandAncestors(<%= Core.Converter.SerializeCompact(GetUserAncestorsNodeIds()) %>);
        <% End If %>

        function saveAndClose() {
            save(true);
        }

        function saveAndNotClose() {
            save(false);
        }

        function save(close, suppresItemValidation) {
            var usernameTextBox = $('Username');
            var passwordTextBox = $('Password');
            var emailTextBox = $('Email');
            var nameTextBox = $('Name');

        <% If userID = 0 Then %>            
            <% If (IsFieldEditable(UserDataBaseField.UserName) OrElse IsFieldEditable(UserDataBaseField.UserEmail)) Then %>            
            if ((!usernameTextBox || usernameTextBox.disabled) && (!emailTextBox || emailTextBox.disabled)) {
                alert('<%= Translate.Translate("Cannot create a user with empty Username and Email") %>');
                return;
            }
            <% Else If (Not IsFieldEditable(UserDataBaseField.Name)) %>
            alert('<%= Translate.Translate("Cannot create a user with empty Username, Name or Email. Enable any of that fields in the user and group type settings") %>');
            return;
            <% End If %>
        <% End If %>

            var isValidEmail = function (email) {
                var emailRegEx = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;
                return emailRegEx.test(email);
            };

            var valid = true;
            if (!passwordTextBox || passwordTextBox.value.trim() == '') {
                if (usernameTextBox && !emailTextBox) {
                    valid = usernameTextBox.disabled || usernameTextBox.value.trim() != '';
                    if (!valid) {
                        showErrors({ noUsername: true });
                        return;
                    }
                }
                if (valid && nameTextBox && (!usernameTextBox || usernameTextBox.disabled)
                    && (!emailTextBox || emailTextBox.disabled)) {
                    valid = nameTextBox.disabled || nameTextBox.value.trim() != '';
                    if (!valid) {
                        showErrors({ noName: true });
                        return;
                    }
                }
                if (valid && emailTextBox && !emailTextBox.disabled) {
                    valid = emailTextBox.value.trim() != '' || usernameTextBox && (usernameTextBox.disabled || usernameTextBox.value.trim() != '');
                    if (!valid) {
                        showErrors({ noEmail: true, noUsername: !usernameTextBox || !usernameTextBox.disabled });
                        return;
                    }
                    valid = emailTextBox.value.trim() == '' || isValidEmail(emailTextBox.value);
                    if (!valid) {
                        showErrors({ wrongEmail: true });
                        return;
                    }
                }
            }

            if (passwordTextBox && passwordTextBox.value.trim() != '') {
                if (usernameTextBox && !usernameTextBox.disabled) {
                    valid = usernameTextBox.value.trim() != '';
                    if (!valid) {
                        showErrors({ noUsername: true });
                        return;
                    }
                }
                if (nameTextBox && !nameTextBox.disabled && (!usernameTextBox || usernameTextBox.disabled)
                    && (!emailTextBox || emailTextBox.disabled)) {
                    valid = nameTextBox.value.trim() != '';
                    if (!valid) {
                        showErrors({ noName: true });
                        return;
                    }
                }
            }

            Dynamicweb.UserManagement.ItemEditors.validateItemFields(suppresItemValidation, function (result) {
                if (result.isValid) {
                    document.getElementById('EditUserForm').action = 'EditUser.aspx';

                    var form = $('EditUserForm');
                    form.request({
                        parameters: {
                            GroupID: groupID,
                            SmartSearchID: smartSearchID,
                            RepositoryName: repositoryName,
                            QueryName: repositoryQueryName,
                            UserID: userID,
                            DoValidatePassword: true
                        },
                        onSuccess: function (oXHR) {
                            // validate the form
                            if (oXHR.responseText == "OK") {
                                // Fire event to handle saving
                                window.document.fire("General:DocumentOnSave");

                                (form.onsubmit || function () { })(); // Force richeditors saving

                                form.action = 'EditUser.aspx' +
                                    '?GroupID=' + groupID +
                                    '&SmartSearchID=' + smartSearchID +
                                    '&RepositoryName=' + repositoryName +
                                    '&QueryName=' + repositoryQueryName +
                                    '&UserID=' + userID +
                                    '&BasedOn=' + basedOn +
                                    '&UserAndGroupTypeSystemName=' + userAndGroupTypeSystemName +
                                    '&DoSave=True' +
                                    '&DoClose=' + (close ? 'True' : 'False');
                                form.submit();
                            } else {
                                if ($('Password') && $('textPassword').style.display !== 'none') {
                                    $('Password').focus();
                                    $('passwordValidation').style.display = '';
                                    $('passwordValidation').update(oXHR.responseText);
                                } else {
                                    alert(oXHR.responseText);
                                }
                            }
                        }
                    });
                }
            });
        }

        function cancel() {
            document.location = 'ListUsers.aspx?GroupID=' + groupID + '&SmartSearchID=' + smartSearchID + '&RepositoryName=' + repositoryName + '&QueryName=' + repositoryQueryName;
        }

        function resetPassword() {
            document.getElementById('textPassword').style.display = '';
            document.getElementById('resetPasswordDiv').style.display = 'none';
            document.getElementById('EditUserForm').Password.focus();
        }

        function resetEncryptedPassword() {
            if (confirm('<%=Translate.JsTranslate("Are you sure you want to reset the password?") %>')) {
                document.getElementById('EditUserForm').Password.value = '';
                document.getElementById('textPassword').style.display = '';
                document.getElementById('encryptedPasswordDiv').style.display = 'none';
                document.getElementById('restorePasswordDiv').style.display = 'none';
                document.getElementById('EditUserForm').Password.focus();
                document.getElementById('PasswordTitle').innerText = '<%=Translate.JsTranslate("New password") %>';
            }
        }

        function generatePassword() {
            if (document.getElementById('EditUserForm').Password.value == '' || confirm('<%=Translate.JsTranslate("Do you want to overwrite the existing password?")%>')) {
                // Excluded: 0Oo lI1
                var numbers = '23456789';
                var lowercase = 'abcdefghijkmnpqrstuvwxyz';
                var uppercase = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
                var specials = '!@#$%^&*()';
                var length = Math.max(8, <%=PasswordMinLength%>);
                var pick = function (str, len) {
                    var ret = '';
                    while (ret.length < len) {
                        ret += str.charAt(Math.floor(Math.random() * str.length));
                    }
                    return ret;
                }

                var allChars = numbers + lowercase + uppercase + specials;
                var passwordChars = pick(numbers, 1) + pick(lowercase, 1) + pick(uppercase, 1) + pick(specials, 1);
                passwordChars += pick(allChars, length - passwordChars.length);

                var password = passwordChars.split('').sort(function () { return 0.5 - Math.random() }).join('');
                document.getElementById('EditUserForm').Password.value = password;
            }
        }

        function ValidateEmail() {
            var emailTextBox = $('Email');
            var email = emailTextBox.value;

            var form = $('EditUserForm');
            form.request({
                parameters: {
                    Email: email,
                    DoValidateEmail: true
                },
                onSuccess: function (oXHR) {
                    if (oXHR.responseText == "OK") {
                        $('ValidateEmailIcon').className = '<%=KnownIconInfo.ClassNameFor(KnownIcon.CheckCircle)%>';
                        $('ValidateEmailButton').setAttribute('title', '<%=Translate.Translate("Validate users email address and email domain")%>');
                        alert('<%=Translate.Translate("Email is valid")%>');
                    }
                    else {
                        $('ValidateEmailIcon').className = '<%=KnownIconInfo.ClassNameFor(KnownIcon.ExclaminationCircle)%>';
                        $('ValidateEmailButton').setAttribute('title', oXHR.responseText);
                        alert(oXHR.responseText);

                        emailTextBox.focus();
                    }
                }
            });
        }

        function ShowUserOrders() {
            dialog.show('OrdersDialog', '/Admin/Module/Usermanagement/UserOrdersList.aspx?userId=<%=userID%>&dialogMode=true');
        }

        function closePrintDialog() {
            dialog.hide('OrdersDialog');
        }

        function ShowUserEmails() {
            var detailDlgAction = <%= GetRecipientDetailsDialogAction().ToJson() %>;
            Action.Execute(detailDlgAction, { userId: <%=userID%>, title: '<%=Translate.Translate("User emails")%>' });
        }

        function ShowUserTransactions() {
            dialog.show('UserTransactionsDialog', '/Admin/Module/eCom_Catalog/dw7/lists/EcomLoyaltyUserTransaction_List.aspx?userID=<%=userID%>');
        }

        function ShowUserCardTokens() {
            dialog.show('UserSavedCardsTokensDialog', '/Admin/Module/Usermanagement/UserPaymentCardsTokensList.aspx?userId=<%=userID%>');
        }

        function ShowUserCardLog(savedCardId) {
            dialog.show('UserSavedCardsLogDialog', '/Admin/Module/Usermanagement/UserPaymentCardsLog.aspx?SavedCardID=' + savedCardId);
        }

        function ShowUserRecurringOrders() {
            dialog.show('UserRecurringOrdersDialog', '/Admin/Module/Usermanagement/UserOrdersList.aspx?userId=<%=userID%>&dialogMode=true&OrderType=recurringorders');
        }

        function ShowVisits() {
            dialog.show('VisitsDialog', '/Admin/Module/Usermanagement/ListVisits.aspx?UserId=<%=userID%>');
        }

        function ShowVisitorDetails(visitorId) {
            dialog.show('VisitorDetailsDialog', '/Admin/Module/OMC/Leads/Details/Default.aspx?ID=' + visitorId + '&Section=Basic');
        }

        function sendUserInfo() {
            <%= CreateSendUserDetailsDialogAction(userID, 0, False) %>
        }

        function sendRecoveryMail() {
            <%= CreateSendUserDetailsDialogAction(userID, 0, True) %>
        }

        function viewOrder(orderID) {
            parent.document.location.href = '/Admin/Module/eCom_Catalog/dw7/Edit/EcomOrder_Edit.aspx?Caller=usermanagement&ID=' + orderID + '<%=CallParameters%>';
        }

        function createRMA(orderID) {
            parent.document.location.href = "/Admin/Module/eCom_Catalog/dw7/Edit/EcomRma_Edit.aspx?Caller=usermanagement&OrderID=" + orderID + '<%=CallParameters%>';
        }

        function enterKeyPressHandler() {
            saveAndNotClose();
            return true;
        }
    </script>
</head>
<body class="area-green screen-container">
    <div class="card">
        <form id="EditUserForm" runat="server" style="margin-bottom: 0; height: 100%;" data-onpress-enter-handler="enterKeyPressHandler">
            <dw:RibbonBar ID="Ribbon" runat="server">
                <dw:RibbonBarTab runat="server" Active="true" Name="User">
                    <dw:RibbonBarGroup runat="server" Name="Show">
                        <dw:RibbonBarRadioButton runat="server" ID="ViewUserSettingsButton" Size="Large" Text="User" Icon="PersonOutline" OnClientClick="SetMainDiv('EditUser');" />
                        <dw:RibbonBarRadioButton runat="server" ID="ViewUserAddressesButton" Size="Large" Text="Addresses" Icon="PermContactCal" OnClientClick="SetMainDiv('UserAddresses');" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" Name="Information">
                        <dw:RibbonBarButton runat="server" ID="rbbViewUserVisits" Text="Visits" Size="Small" Icon="DirectionsWalk" OnClientClick="ShowVisits();" Disabled="True" />
                        <dw:RibbonBarButton runat="server" ID="ViewUserOrdersButton" Text="Orders" Size="Small" Icon="Assignment" OnClientClick="ShowUserOrders();" />
                        <dw:RibbonBarButton runat="server" ID="ViewUserEmailButton" Text="Email Marketing" Size="Small" Icon="Email" OnClientClick="ShowUserEmails();" />
                        <dw:RibbonBarButton runat="server" ID="ViewUserLoyaltyPoints" Text="Loyalty points" Size="Small" Icon="Loyalty" Visible="false" OnClientClick="ShowUserTransactions()" />
                        <dw:RibbonBarButton runat="server" ID="ViewUserPaymentCardsTokens" Text="User Saved Cards" Size="Small" Icon="Creditcard" OnClientClick="ShowUserCardTokens()" />
                        <dw:RibbonBarButton runat="server" ID="ViewUserRecurringOrders" Text="Recurring Orders" Size="Small" Icon="AvTimer" OnClientClick="ShowUserRecurringOrders()" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" Name="Settings" ID="Settings">
                        <dw:RibbonBarButton runat="server" Text="Editor configuration" OnClientClick="popupEditorConfiguration();" Size="Small" Icon="toggleOn" />
                        <dw:RibbonBarButton runat="server" Text="Send user details" OnClientClick="sendUserInfo();" Size="Small" Icon="QuickContactsMail" />
                        <dw:RibbonBarButton runat="server" ID="AllowBackendLoginButton" Text="Allow backend login" OnClientClick="popupAllowBackend();" Size="Small" Icon="Key" Active="true" />
                        <dw:RibbonBarButton runat="server" ID="ImpersonationButton" Text="Impersonation" OnClientClick="dialog.show('ImpersonationDialog');" Size="Small" Icon="FaceUnlock" />
                        <dw:RibbonBarButton runat="server" ID="ExternalLoginButton" Text="External accounts" Visible="false" OnClientClick="dialog.show('ExternalLoginDialog');" Size="Small" Icon="LockOpen" />
                        <dw:RibbonBarButton runat="server" ID="ItemTypeButton" Text="Item Type" OnClientClick="dialog.show('ItemTypeDialog');" Size="Small" Icon="Cube" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="ViewUserAddresses" runat="server" Name="User addresses" Visible="false">
                        <dw:RibbonBarButton ID="BtnAddAddress" runat="server" Text="Add address" OnClientClick="__context.navigateNewAddress();" Size="Small" Icon="PlusSquare" />
                        <dw:RibbonBarButton ID="BtnDeleteAddresses" runat="server" Text="Delete addresses" Disabled="true" OnClientClick="removeAddresses();" Size="Small" Icon="Delete" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" Name="Help">
                        <dw:RibbonBarButton runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
                <dw:RibbonBarTab runat="server" Active="true" Name="Options">
                    <dw:RibbonBarGroup runat="server" Name="User type">
                        <dw:RibbonBarRadioButton ID="cmdUserStandard" runat="server" Checked="false" Group="UserType" Text="Standard" Value="5" Image="NoImage">
                        </dw:RibbonBarRadioButton>
                        <dw:RibbonBarRadioButton ID="cmdUserAdmin" runat="server" Checked="false" Group="UserType" Text="Admin" Value="3" Image="NoImage">
                        </dw:RibbonBarRadioButton>
                        <dw:RibbonBarRadioButton ID="cmdUserAdministrator" runat="server" Checked="false" Group="UserType" Text="Administrator" Value="1" Image="NoImage">
                        </dw:RibbonBarRadioButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" Name="Publication period" ID="PublicationPeriodRibbon">
                        <dw:RibbonBarPanel runat="server" ExcludeMarginImage="true">
                            <div class="EditUserRibbonDiv">
                                <table class="publication-date-picker-table">
                                    <tr runat="server" id="ValidFromDateTr">
                                        <td>
                                            <dw:TranslateLabel runat="server" Text="From" />
                                        </td>
                                        <td>
                                            <dw:DateSelector runat="server" EnableViewState="false" ID="ValidFromDate" IncludeTime="true" AllowNeverExpire="false" />
                                        </td>
                                    </tr>
                                    <tr runat="server" id="ValidToDateTr">
                                        <td>
                                            <dw:TranslateLabel runat="server" Text="To" />
                                        </td>
                                        <td>
                                            <dw:DateSelector runat="server" EnableViewState="false" ID="ValidToDate" IncludeTime="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <dw:RibbonBarCheckbox runat="server" ID="Active" Text="Active" Size="Large" RenderAs="FormControl" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" Name="Help">
                        <dw:RibbonBarButton runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div id="EditUserDiv" runat="server">
                <dw:Infobar runat="server" Visible="false" ID="UserRestrictionsErrorMessage" Type="Error" Message="User type restrictions does not allow to attach one or more selected groups">
                    <br />
                    <asp:Label runat="server" ID="WrongGroups"></asp:Label>
                </dw:Infobar>
                <dw:Infobar runat="server" Visible="false" ID="UserPermissionsErrorMessage" Type="Error" Message="You don't have access to attach/detach from groups">
                    <br />
                    <asp:Label runat="server" ID="WrongPermissionGroups"></asp:Label>
                </dw:Infobar>

                <dw:GroupBox runat="server" Title="User info" ID="UserInfoGroupBox">
                    <table class="formsTable">
                        <tr id="UserNameRow" runat="server">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Username" />
                            </td>
                            <td>
                                <input type="text" runat="server" id="Username" maxlength="255" class="NewUIinput" />
                                <div id="UsernameTakenDiv" class="EditUserErrorDiv" style="display: none;">
                                    <%=Translate.Translate("This user name is already in use. Please choose another user name")%>
                                </div>
                                <div id="NoUsernameDiv" class="EditUserErrorDiv" style="display: none;">
                                    <%=Translate.Translate("Please enter a user name")%>
                                </div>
                                <script type="text/javascript">
                                    if (document.getElementById('Username').value.length == 0)
                                        document.getElementById('Username').focus()
                                </script>
                            </td>
                        </tr>
                        <tr id="PasswordRow" runat="server">
                            <td id="PasswordTitle">
                                <dw:TranslateLabel ID="PasswordLabel" runat="server" Text="New password" />
                            </td>
                            <td>
                                <div id="textPassword" style="display: none;">
                                    <table style="width: 100%">
                                        <tr>
                                            <td>
                                                <input type="text" runat="server" id="Password" maxlength="255" class="NewUIinput" />
                                                <a runat="server" id="GeneratePassword" href="javascript:generatePassword();">
                                                    <i class="fa fa-gears (alias)" title="<%=Translate.JsTranslate("Generate password") %>"></i>
                                                </a>
                                                <div id="passwordValidation" class="EditUserErrorDiv" style="display: none;"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div id="IllegalPasswordDiv" class="EditUserErrorDiv" style="display: none;">
                                                    <%=Translate.Translate("Your password contains system reserved characters. Please choose another password")%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr runat="server" id="DoEncryptPasswordTr">
                                            <td>
                                                <dw:CheckBox runat="server" ID="DoEncryptPassword" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="resetPasswordDiv" style="display: none;">
                                    <a href="javascript:resetPassword();">
                                        <dw:TranslateLabel runat="server" Text="The password is hidden. Click here to reset the passwrod" />
                                    </a>
                                </div>
                                <div id="encryptedPasswordDiv" style="display: none;">
                                    <a href="javascript:resetEncryptedPassword();">
                                        <dw:TranslateLabel runat="server" Text="The password is encrypted. Click here to reset the password" />
                                    </a>
                                </div>
                                <div id="restorePasswordDiv" style="display: none; padding-top: 10px;">
                                    <a href="javascript:sendRecoveryMail();">
                                        <dw:TranslateLabel runat="server" Text="Send recovery mail" />
                                    </a>
                                </div>
                            </td>
                        </tr>

                    </table>
                </dw:GroupBox>

                <dw:GroupBox runat="server" Title="Personal" ID="PersonalGroupBox">
                    <dwc:InputText runat="server" ID="Name" MaxLength="255" Label="Name" />
                    <div id="NoNameDiv" class="EditUserErrorDiv" style="padding-left:180px;display: none;">
                        <%=Translate.Translate("Please enter a name")%>
                    </div>
                    <dwc:InputText runat="server" ID="UserTitle" MaxLength="255" Label="Title" />
                    <dwc:InputText runat="server" ID="UserFirstName" MaxLength="255" Label="First name" />
                    <dwc:InputText runat="server" ID="UserMiddleName" MaxLength="255" Label="Middle name" />
                    <dwc:InputText runat="server" ID="UserLastName" MaxLength="255" Label="Last name" />
                    <table runat="server" id="UserEmailRow" class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Email" />
                            </td>
                            <td>
                                <input type="text" runat="server" id="Email" maxlength="255" class="NewUIinput" clientidmode="Static" />
                                <span style="position: relative; top: 3px;">
                                    <a runat="server" id="ValidateEmailButton" style="font-size: 20px;" onclick="ValidateEmail();">
                                        <i runat="server" id="ValidateEmailIcon"></i>
                                    </a>
                                </span>
                                <div id="NoEmailDiv" class="EditUserErrorDiv" style="display: none;">
                                    <%=Translate.Translate("Please enter an Email")%>
                                </div>
                                <div id="WrongEmailFormatDiv" class="error" style="display: none;">
                                    <%=Translate.Translate("Email address has incorrect format")%>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <dw:FileManager ID="fmImage" Name="fmImage" Extensions="jpg,png,gif,jpeg,bmp,webp" runat="server" Label="Image" />
                    <%If License.IsModuleAvailable("EmailMarketing") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("EmailMarketing") Then%>
                    <dwc:CheckBox runat="server" ID="CommunicationEmail" Label="Email permission" />
                    <%End If%>
                    <%If Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("DataProcessing") Then%>
                    <table runat="server" id="consentsTable" class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Consents" />
                            </td>
                            <td runat="server" id="consentsCell">
                                <dw:List ID="ConsentsList" runat="server" AllowMultiSelect="false" ShowTitle="false" Personalize="true" NoItemsMessage="No consents"
                StretchContent="false" UseCountForPaging="true" HandlePagingManually="true" ContextMenuID="ConsentsContextMenu">
                                    </dw:List>

                            </td>
                        </tr>
                    </table>
                    <%End If%>
                </dw:GroupBox>

                <dw:GroupBox runat="server" Title="Address" ID="AddressGroupBox">
                    <dwc:InputText runat="server" ID="Address" MaxLength="255" Label="Address" />
                    <dwc:InputText runat="server" ID="Address2" MaxLength="255" Label="Address2" />
                    <dwc:InputText runat="server" ID="HouseNumber" MaxLength="255" Label="House number" />
                    <dwc:InputText runat="server" ID="Zip" MaxLength="255" Label="Zip" />
                    <dwc:InputText runat="server" ID="City" MaxLength="255" Label="City" />
                    <dwc:InputText runat="server" ID="State" MaxLength="255" Label="State or region" />
                    <dwc:InputText runat="server" ID="Country" MaxLength="255" Label="Country" />
                    <dwc:SelectPicker runat="server" ID="ddlCountries" Label="Billing/Shipping country"></dwc:SelectPicker>
                </dw:GroupBox>

                <dw:GroupBox runat="server" Title="Phone" ID="PhoneGroupBox">
                    <dwc:InputText runat="server" ID="Phone" Label="Phone" />
                    <dwc:InputText runat="server" ID="PhonePrivate" Label="Phone (private)" />
                    <dwc:InputText runat="server" ID="MobilePhone" Label="Mobile phone" />
                    <dwc:InputText runat="server" ID="Fax" Label="Fax" />
                </dw:GroupBox>

                <dw:GroupBox runat="server" Title="Ecommerce" ID="EcommerceGroupBox">
                    <dwc:InputText runat="server" ID="CustomerNumber" MaxLength="255" Label="Customer number" />
                    <dwc:InputText runat="server" ID="ExternalId" MaxLength="255" Label="External Id" />
                    <dwc:SelectPicker runat="server" ID="Currency" Label="Currency"></dwc:SelectPicker>
                    <dwc:SelectPicker runat="server" ID="ddlStockLocation" Label="Stock location"></dwc:SelectPicker>
                    <dwc:InputText runat="server" ID="ShopId" MaxLength="255" Label="Shop id" Visible="false" />
                </dw:GroupBox>

                <dw:GroupBox runat="server" Title="Work" ID="WorkGroupBox">
                    <dwc:InputText runat="server" ID="Company" Label="Company" />
                    <dwc:InputText runat="server" ID="Department" Label="Department" />
                    <dwc:InputText runat="server" ID="Jobtitle" Label="JobTitle" />
                    <dwc:InputText runat="server" ID="PhoneBusiness" Label="Phone (business)" />
                    <dwc:InputText runat="server" ID="VatRegNumber" Label="VATIN" />
                    <dwc:CheckBox runat="server" ID="ReverseVat" Label="Reverse charge for VAT" />
                </dw:GroupBox>

                <%If License.IsModuleAvailable("Maps") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("Maps") Then%>
                <dw:GroupBox runat="server" Title="GeoLocation" ID="GeoLocationGroupBox">
                    <dwc:InputText runat="server" ID="GeoLocationLat" Label="GeoLocationLat" />
                    <dwc:InputText runat="server" ID="GeoLocationLng" Label="GeoLocationLng" />
                    <table class="formsTable">
                        <tr>
                            <td></td>
                            <td>
                                <button runat="server" type="button" id="GeoLocationShowOnMap" class="btn btn-default">
                                    <dw:TranslateLabel runat="server" Text="Show location on map" />
                                </button>
                                <button runat="server" type="button" id="GeoLocationGetFromAPI" class="btn btn-default">
                                    <dw:TranslateLabel runat="server" Text="Get location from API" />
                                </button>
                            </td>
                        </tr>
                    </table>
                    <dwc:CheckBox runat="server" ID="GeoLocationIsCustom" Label="GeoLocationIsCustom" />
                    <dw:FileManager runat="server" ID="GeoLocationImage" Name="GeoLocationImage" Extensions="jpg,png,gif" Label="Image" />
                </dw:GroupBox>

                <script type="text/javascript" src="Maps.js"></script>
                <script type="text/javascript">
                    mapsSettings.messages['Unable to get location for address "#{address}"'] = '<%= StringHelper.JsEnable(Translate.Translate("Unable to get location for address ""#{address}""")) %>';
                </script>
                <%End If%>

                <% If License.HasAccess(Actions.EditStartPage) Then %>
                <dw:GroupBox ID="StartPageGroupBox" runat="server" Title="Start page">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Frontend start page" />
                            </td>
                            <td>
                                <dw:LinkManager runat="server" ID="StartPage" DisableFileArchive="true" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <% End If %>

                <dw:SystemFieldValueEdit ID="UserSystemFields" runat="server" />

                <dw:CustomFieldValueEdit ID="UserCustomFields" runat="server" />

                <div id="content-item">
                    <asp:Literal ID="litFields" runat="server" />
                </div>

                <dw:GroupBox ID="UserGroups" runat="server" Title="Groups" DoTranslation="true">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Select groups" />
                            </td>
                            <td>
                                <dw:UserSelector runat="server" ID="GroupsSelector" Show="Groups"></dw:UserSelector>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>

                <%If IsLiveIntegrationEnabled Then%>
                <dw:GroupBox runat="server" Title="Live integration" ID="LiveIntegrationGroupBox">
                    <dwc:CheckBox runat="server" ID="DisableLivePrices" Label="Disable live prices" />
                </dw:GroupBox>
                <%End If%>

                <dw:GroupBox runat="server" Title="Audit" ID="AuditGroupBox">
                    <table class="infoTable">
                        <tr runat="server" id="CreatedOnTr">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Created on" />
                            </td>
                            <td>
                                <asp:Label ID="CreatedOn" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr runat="server" id="UpdatedOnTr">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Updated on" />
                            </td>
                            <td>
                                <asp:Label ID="UpdatedOn" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr runat="server" id="CreatedByTr">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Created by" />
                            </td>
                            <td>
                                <asp:Label ID="CreatedBy" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr runat="server" id="UpdatedByTr">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Updated by" />
                            </td>
                            <td>
                                <asp:Label ID="UpdatedBy" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr runat="server" id="EmailPermissionsUpdatedOnTr">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Email permission updated on" />
                            </td>
                            <td>
                                <asp:Label ID="EmailPermissionsUpdatedOn" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr runat="server" id="LastLoginOnTr">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Last login on" />
                            </td>
                            <td>
                                <asp:Label ID="LastLoginOn" runat="server" Text="" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </div>

            <dwc:ActionBar runat="server">
                <dw:ToolbarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Image="NoImage" OnClientClick="saveAndNotClose();" ID="cmdSave" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500" OnClientClick="saveAndClose();">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" ID="cmdCancel" ShowWait="true" WaitTimeout="500" OnClientClick="cancel()">
                </dw:ToolbarButton>
            </dwc:ActionBar>

            <!-- Addresses -->
            <div id="ViewUserAddressesDiv" runat="server" style="display: none; overflow-x: auto;">
                <dw:List ID="AddressList" runat="server" AllowMultiSelect="true" Title="Addresses" PageSize="200" OnClientSelect="addressListRowSelected();" SortColumnIndex="4" Personalize="true">
                </dw:List>
                <dw:ContextMenu ID="AddressListContextMenu" runat="server">
                    <dw:ContextMenuButton ID="cmdEditAddress" runat="server" Divide="None" Icon="Pencil" Text="Edit Address" OnClientClick="__context.navigateEditAddress();"></dw:ContextMenuButton>
                    <dw:ContextMenuButton ID="cmdMakeDefault" runat="server" Divide="After" Icon="Check" Text="Make default" OnClientClick="__context.makeDefaultAddress();"></dw:ContextMenuButton>
                    <dw:ContextMenuButton ID="cmdRemoveAddress" runat="server" Divide="None" Icon="Delete" Text="Delete address" OnClientClick="__context.removeAddress();"></dw:ContextMenuButton>
                    <dw:ContextMenuButton ID="cmdNoActions" runat="server" Divide="None" Icon="Ban" Text="No actions" OnClientClick="return false;" Disabled="true"></dw:ContextMenuButton>
                </dw:ContextMenu>
            </div>
            <!-- End Addresses -->

            <dw:Dialog runat="server" ID="EditorConfigurationDialog" Title="Editor configuration" Size="Medium" ShowCancelButton="true" ShowOkButton="true" OkAction="setEditorConfiguration();">
                <dw:GroupBox runat="server">
                    <div class="form-group">
                        <label class="control-label" for="ConfigurationSelector">
                            <dw:TranslateLabel runat="server" Text="Select configuration" />
                        </label>
                        <div class="form-group-input">
                            <asp:DropDownList runat="server" ID="ConfigurationSelector" CssClass="std" />
                        </div>
                    </div>
                </dw:GroupBox>
            </dw:Dialog>
            <asp:HiddenField runat="server" ID="ConfigurationSelectorValue" />

            <dw:Dialog runat="server" ID="AllowBackendDialog" Title="Allow backend login" Size="Medium" ShowCancelButton="true" ShowOkButton="true" OkAction="setAllowBackend();">
                <dw:GroupBox runat="server">
                    <div class="form-group">
                        <label class="control-label" for="AllowBackendCheckbox">
                            <dw:TranslateLabel runat="server" Text="Backend login" />
                        </label>
                        <div class="form-group-input">
                            <dw:CheckBox runat="server" ID="AllowBackendCheckbox" />
                            <div style="margin: 5px 5px 5px 5px;">
                                <asp:Literal runat="server" ID="AllowBackendDisabledText" Text="This option is disabled because the user is a backend user inherited from these groups:"></asp:Literal>
                            </div>
                            <div style="margin: 10px 10px 10px 10px;">
                                <asp:Literal runat="server" ID="AllowBackendGroups"></asp:Literal>
                            </div>
                        </div>
                    </div>
                </dw:GroupBox>
            </dw:Dialog>
            <asp:HiddenField runat="server" ID="AllowBackendValue" />

            <!-- Impersonation Dialog -->
            <dw:Dialog runat="server" ID="ImpersonationDialog" Title="Impersonation" Width="250" ShowCancelButton="true" ShowOkButton="true" OkAction="__impersonationContext.saveImpersonationDialog();">
                <dw:GroupBox ID="GroupBox2" runat="server" Title="I can impersonate" DoTranslation="true">
                    <table class="EditUserTable" cellpadding="1" cellspacing="1">
                        <tr>
                            <td>
                                <dw:UserSelector runat="server" ID="ICanImpersonateUserSelector" Show="Both" HideAdmins="true"></dw:UserSelector>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="GroupBox4" runat="server" Title="Can impersonate me" DoTranslation="true">
                    <table class="EditUserTable" cellpadding="1" cellspacing="1">
                        <tr>
                            <td>
                                <dw:UserSelector runat="server" ID="CanImpersonateMeUserSelector" Show="Both" HideAdmins="true"></dw:UserSelector>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>
            <!-- ExternalLogin Dialog -->
            <dw:Dialog runat="server" ID="ExternalLoginDialog" Title="External accounts" Size="Large" ShowCancelButton="false" ShowOkButton="false">
                <dw:Overlay ID="waitExternalLoginsList" runat="server" Message="Please wait" />
                <div id="externalLoginsListDiv">
                    <dw:List ID="ExternalLoginsList" ShowTitle="false" PageSize="10" ShowPaging="true" runat="server" NoItemsMessage="You have no external login accounts">
                        <Columns>
                            <dw:ListColumn Name="Provider type" runat="server" />
                            <dw:ListColumn Name="Provider name" runat="server" />
                            <dw:ListColumn Name="Provider user name" runat="server" />
                            <dw:ListColumn ID="colRemove" Name="Remove" Width="50" runat="server" ItemAlign="Center" />
                        </Columns>
                    </dw:List>
                </div>
            </dw:Dialog>

            <dw:Dialog ID="OrdersDialog" runat="server" Title="Orders" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" Width="1000">
                <iframe id="OrdersDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="RecipientDetailsDialog" runat="server" Title="User emails" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" Width="800">
                <iframe id="RecipientDetailsDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="UserTransactionsDialog" runat="server" Title="Loyalty points" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" Width="800">
                <iframe id="UserTransactionsDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="UserSavedCardsTokensDialog" runat="server" Title="Saved Cards" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" Width="800">
                <iframe id="UserSavedCardsTokensDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="UserSavedCardsLogDialog" runat="server" Title="Saved Card Log" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" Width="600">
                <iframe id="UserSavedCardsLogDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="UserRecurringOrdersDialog" runat="server" Title="Recurring Orders" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" Width="1000">
                <iframe id="UserRecurringOrdersDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="VisitsDialog" runat="server" Title="Visits" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" Width="800">
                <iframe id="VisitsDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="VisitorDetailsDialog" runat="server" Title="Visitor details" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" Width="850">
                <iframe id="VisitorDetailsDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ItemTypeDialog" Size="Medium" Title="Item type" ShowOkButton="true" ShowCancelButton="true" CancelAction="closeChangeItemTypeDialog();" OkAction="changeItemType();">
                <dw:GroupBox ID="GroupBox11" runat="server">
                    <table cellpadding="1" cellspacing="1">
                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="User properties" />
                            </td>
                            <td>
                                <dw:Richselect ID="ItemTypeSelect" runat="server" Height="60" Itemheight="60" Width="300" Itemwidth="300">
                                </dw:Richselect>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>
        </form>
    </div>

    <div class="card-footer">
        User id: <%=userID %>
    </div>

    <script type="text/javascript">
        var groupID = <%=groupID %>;
        var smartSearchID = '<%=smartSearchID %>';
        var repositoryName = '<%=repositoryName%>';
        var repositoryQueryName = '<%=repositoryQuery%>';
        var userID = <%=userID %>;
        var basedOn = '<%=basedOn%>';
        var userAndGroupTypeSystemName = '<%=currentUser.UserAndGroupTypeSystemName%>';
        var errorCmd = '<%=errorCmd %>';
        var deleteSingleMsg = '<%=Translate.Translate("Delete address?") %>';
        var deleteMultipleMsg = '<%=Translate.Translate("Delete addresses?") %>';
        var deleteMainAddressMsg = '<%=Translate.Translate("Main address can not be deleted") %>';
        var deleteDefaultAddressMsg = '<%=Translate.Translate("You can’t delete a default address. Set another address as default before delete this address.") %>';
        var __impersonationContext = new ImpersonationContext(userID, groupID);

        var __context = new AddressContext(userID, groupID, smartSearchID, repositoryName, repositoryQueryName, deleteSingleMsg, deleteMultipleMsg, deleteMainAddressMsg, deleteDefaultAddressMsg);
        /* Creating new row context menu */
        var __menu = new RowContextMenu({
            menuID: 'AddressListContextMenu',
            onSelectContext: function (row, itemID) {
                var ret = '';
                var activeCount = 0;
                var mainAddressSelected = false;
                var selectedRows = List.getSelectedRows('AddressList');
                /* Determining whether the target row is part of selection (and more that one row is selected) */
                if (List.rowIsSelected(row) && selectedRows.length > 1) {
                    for (var i = 0; i < selectedRows.length; i++) {
                        if (selectedRows[i].readAttribute('__isMainAddress') == 'true') {
                            mainAddressSelected = true;
                            break;
                        }
                    }
                    if (mainAddressSelected) {
                        ret = 'multipleAddressesSelectionWithMainAddress';
                    } else {
                        ret = 'multipleAddressesSelection';
                    }
                } else {
                    if (row.readAttribute('__isMainAddress') == 'true') {
                        ret = 'singleMainAddressSelected';
                    } else {
                        ret = 'singleAddressSelected';
                    }
                }
                return ret;
            }
        });

        function removeAddresses() {
            var rows = List.getSelectedRows('AddressList');
            var isMainAddressSelected = false;
            var isDefaultAddressSelected = false;
            if (rows && rows.length > 0) {
                var ids = '';
                var userID = '';
                for (var i = 0; i < rows.length; i++) {
                    userID = rows[i].id;
                    if (userID != null && userID.length > 0) {
                        ids += (userID.replace(/row/gi, '') + ',')
                    }
                    if (rows[i].readAttribute('__isMainAddress') == 'true' && !isMainAddressSelected) {
                        isMainAddressSelected = true;
                    }
                    if (rows[i].readAttribute('__isDefault') == 'true' && !isDefaultAddressSelected) {
                        isDefaultAddressSelected = true;
                    }
                }
                if (ids.length > 0) {
                    ids = ids.substring(0, ids.length - 1);
                    if (isMainAddressSelected) {
                        alert(deleteMainAddressMsg);
                    } else if (isDefaultAddressSelected) {
                        alert(deleteDefaultAddressMsg);
                    } else {
                        var deleteMsg = deleteSingleMsg
                        if (rows.length > 1) {
                            deleteMsg = deleteMultipleMsg;
                        }
                        if (confirm(deleteMsg)) {
                            document.location = 'EditUser.aspx?RemoveAddress=True&userID=' + <%=userID %> + '&groupID=' + <%=groupID %> + '&RemoveAddressID=' + ids;
                        }
                    }
                }
            }
        }

        function removeExternalLogin(id) {
            var o = new overlay('waitExternalLoginsList');
            o.show();

            var request = 'EditUser.aspx?RemoveExternalLogin=True&userID=' + <%=userID %> + '&groupID=' + <%=groupID %> + '&RemoveExternalLoginID=' + id;
            new Ajax.Request(request, {
                method: 'get',
                onComplete: function (transport) {
                    if (200 == transport.status) {
                        o.hide();
                    }
                },
                onSuccess: function (transport) {
                    if (transport.responseText != "") {
                        $("externalLoginsListDiv").update(transport.responseText);
                    }
                }
            });
        }

        function help() {
	        <%=Gui.Help("", "modules.usermanagement.general", Translate.GetLanguageLocale(0)) %>
        }

        document.observe("dom:loaded", function () {
            __menu.registerContext('multipleAddressesSelection', ['cmdRemoveAddress']);
            __menu.registerContext('singleAddressSelected', ['cmdEditAddress', 'cmdMakeDefault', 'cmdRemoveAddress']);
            __menu.registerContext('multipleAddressesSelectionWithMainAddress', ['cmdNoActions']);
            __menu.registerContext('singleMainAddressSelected', ['cmdEditAddress']);

            // Init password
            var encryptEl = document.getElementById("EditUserForm").DoEncryptPassword;
            if (encryptEl.checked) {
                document.getElementById('textPassword').style.display = 'none';
                document.getElementById('resetPasswordDiv').style.display = 'none';
                document.getElementById('encryptedPasswordDiv').style.display = '';
                document.getElementById('restorePasswordDiv').style.display = '';
            } else {
                if ('<%= ShowPasswordIfPresent%>' === 'True' || <%= userID%> === 0) {
                    document.getElementById('textPassword').style.display = '';
                    document.getElementById('resetPasswordDiv').style.display = 'none';
                }
                else {
                    document.getElementById('textPassword').style.display = 'none';
                    document.getElementById('resetPasswordDiv').style.display = '';
                }
                document.getElementById('encryptedPasswordDiv').style.display = 'none';
                document.getElementById('restorePasswordDiv').style.display = 'none';
            }
            
            //Notify on username dublicate
            if (errorCmd == 'UsernameTaken') {
                $('UsernameTakenDiv').style.display = '';
                var usernameTextBox = $('Username');
                usernameTextBox.select();
            }

            if (errorCmd == 'IllegalPassword') {
                $('IllegalPasswordDiv').style.display = '';
                $('Password').select();
            }
        });
    </script>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
