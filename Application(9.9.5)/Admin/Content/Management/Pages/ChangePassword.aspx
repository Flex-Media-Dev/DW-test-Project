<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ChangePassword.aspx.vb" Inherits="Dynamicweb.Admin.ChangePassword" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %><%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
    <!-- Default control resources -->
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />

    <!-- Needed non-default scripts -->
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>


    <script type="text/javascript">
        function resetEncryptedPassword() {
            if (confirm('<%=Dynamicweb.SystemTools.Translate.JsTranslate("Are you sure you want to reset the password?") %>')) {
                document.getElementById('EditUserForm').Password.value = '';
                document.getElementById('textPassword').style.display = '';
                document.getElementById('encryptedPasswordDiv').style.display = 'none';
                document.getElementById('EditUserForm').Password.focus();
                $('DoSavePassword').value = 'True';
            }
        }

        function generatePassword() {
            if (document.getElementById('EditUserForm').Password.value == '' || confirm('<%=Dynamicweb.SystemTools.Translate.JsTranslate("Do you want to overwrite the existing password?")%>')) {

                var passwordChars = '23456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';

                var password = '';
                while (password.length < 8)
                    password += passwordChars.charAt(Math.floor(Math.random() * passwordChars.length))
                document.getElementById('EditUserForm').Password.value = password;
            }
        }

        function saveAndClose() {
            $('DoSaveAndClose').value = 'True';
            document.getElementById('EditUserForm').submit();
        }

        function showStartFrame() {
            location = '/Admin/Blank.aspx';
            //history.go(-1);
        }
    </script>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:BlockHeader runat="server">
            <div id="breadcrumb">&nbsp;<i class="fa fa-angle-right"></i>&nbsp;Change password</div>
        </dwc:BlockHeader>

        <form runat="server" id="EditUserForm" name="EditUserForm">

            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Change password"></dwc:CardHeader>

                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="GroupBox1" runat="server" Title="Edit" DoTranslation="true">
                        <!-- Username -->
                        <div class="form-group">
                            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Username" />
                            <div class="form-group-input">
                                <input type="text" runat="server" id="Username" disabled="true" class="form-control" />
                            </div>
                        </div>

                        <!-- Password -->
                        <div id="textPassword" style="display: none;">
                            <div class="form-group">
                                <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Password" />
                                <div class="form-group-input">
                                    <input type="text" runat="server" id="Password" maxlength="255" class="form-control" />
                                    <input type="hidden" runat="server" id="DoSavePassword" />
                                </div>
                            </div>

                            <div class="form-group">
                                <a href="javascript:generatePassword();" class="btn btn-default"><%=Dynamicweb.SystemTools.Translate.JsTranslate("Generate password") %></a>
                            </div>


                            <div class="form-group">
                                <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Encrypt" />
                                <input type="checkbox" runat="server" id="DoEncryptPassword" class="checkbox" />
                                <label for="DoEncryptPassword"></label>
                            </div>
                        </div>

                        <div id="encryptedPasswordDiv" style="display: none; float: left;">
                            <a href="javascript:resetEncryptedPassword();">
                                <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="The password is encrypted. Click here to reset the password" />
                            </a>
                        </div>

                        <asp:Repeater runat="server" ID="ErrorRepeater">
                            <ItemTemplate>
                                <span style="color: Red;">
                                    <%#Container.DataItem %>
                                </span>
                            </ItemTemplate>
                        </asp:Repeater>
                    </dwc:GroupBox>
                </dwc:CardBody>

            </dwc:Card>

            <input type="hidden" id="DoSaveAndClose" name="DoSaveAndClose" />
            <dwc:ActionBar runat="server">
                <dw:ToolbarButton ID="ButtonSaveAndClose" runat="server" Image="NoImage" Text="Save and close" OnClientClick="saveAndClose();" />
                <dw:ToolbarButton ID="ButtonCancel" runat="server" Image="NoImage" Text="Cancel" OnClientClick="javascript:showStartFrame();" />
            </dwc:ActionBar>
        </form>
    </div>

    <script type="text/javascript">
        // Do close?
        if ('<%=DoClose %>' == 'True')
            showStartFrame();

        // Init password
        var passwordIsEncrypted = '<%=PasswordIsEncrypted %>' == 'True';
        $('textPassword').style.display = passwordIsEncrypted ? 'none' : 'block';
        $('encryptedPasswordDiv').style.display = passwordIsEncrypted ? 'block' : 'none';
        $('DoSavePassword').value = passwordIsEncrypted ? 'False' : 'True';

        // Init the save-flag
        $('DoSaveAndClose').value = 'False';

    </script>
</body>

<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
