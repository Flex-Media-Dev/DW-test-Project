<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Access_User_ChangePassword.aspx.vb" Inherits="Dynamicweb.Admin.Access_User_ChangePassword" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="user" Namespace="Dynamicweb.Admin.UserManagement" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="<%= Dynamicweb.Environment.ExecutingContext.GetCulture() %>">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="Stylesheet" href="/Admin/Module/Usermanagement/Css/EditUser.css" />
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" />
    <script type="text/javascript">

        var userID = <%= userID %>;

        function generatePassword() {
            if (document.getElementById('EditUserForm').Password.value == '' || confirm('<%=Translate.JsTranslate("Do you want to overwrite the existing password?")%>')) {
                // Excluded: 0Oo lI1
                var passwordChars = '23456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';

                var password = '';
                while(password.length < 8)
                    password += passwordChars.charAt(Math.floor(Math.random() * passwordChars.length))
                document.getElementById('EditUserForm').Password.value = password;
            }
        }


        function saveAndClose() {
            save(true);
        }

        function saveAndNotClose() {
            save(false);
        }

        function save(close) {
            if (document.getElementById('EditUserForm').Password.value != document.getElementById('EditUserForm').repeatPassword.value)
            {
                alert('<%=Translate.JsTranslate("Passwords do not match.")%>');
                return;
            }

            document.getElementById('EditUserForm').action = 'Access_User_ChangePassword.aspx' +
										   '?UserID=' + userID +
										   '&DoValidatePassword=True';

            $('EditUserForm').request(
            {
                onSuccess: function (oXHR) {
                    // validate the form
                    if (oXHR.responseText == "OK") {
                        document.getElementById('EditUserForm').action = 'Access_User_ChangePassword.aspx' +
										   '?UserID=' + userID +
										   '&DoSave=True' +
										   '&DoClose=' + (close ? 'True' : 'False');
                        document.getElementById('EditUserForm').submit();
                    }
                    else {
                        $('passwordValidation').style.display = '';
                        $('passwordValidation').update(oXHR.responseText);
                    }
                }
            });

        }


        function setHeight() {
        
        }


    </script>

</head>
<body class="edit" onload="setHeight();" style="border-bottom: solid 1px #6593CF; height: 100%;">
    <form id="EditUserForm" runat="server" style="margin-bottom: 0; height: 100%;">

        <dw:RibbonBar ID="Ribbon" runat="server">
            <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="User">
                <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Tools">
                    <dw:RibbonBarButton ID="RibbonbarButton2" runat="server" Text="Gem og luk" Size="Small" Image="SaveAndClose" OnClientClick="saveAndClose();" />
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>

        <div id="EditUserDiv" style="height: 100%; overflow: auto; clear: both;" runat="server">
            <dw:GroupBox ID="GroupBox1" runat="server" Title="User info" DoTranslation="true">
                <table class="EditUserTable" cellpadding="1" cellspacing="1">
                    <tr>
                        <td colspan='3'>
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Your password has expired. Please set the new password." />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Password" />
                            </div>
                        </td>
                        <td>
                            <input type="password" runat="server" id="Password" maxlength="255" class="NewUIinput" />
                            <div id="passwordValidation" class="EditUserErrorDiv" style="display: none;"></div>
                        </td>
                        <td>
                            <a href="javascript:generatePassword();" title="<%=Translate.JsTranslate("Generate password") %>"><%=Dynamicweb.Core.UI.Icons.KnownIconInfo.GetIconHtml(Dynamicweb.Core.UI.Icons.KnownIcon.Gears) %></a>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Repeat Password" />
                            </div>
                        </td>
                        <td>
                            <input type="password" runat="server" id="repeatPassword" maxlength="255" class="NewUIinput" />
                        </td>
                        <td></td>
                    </tr>
                </table>
            </dw:GroupBox>
        </div>
    </form>
    <% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
