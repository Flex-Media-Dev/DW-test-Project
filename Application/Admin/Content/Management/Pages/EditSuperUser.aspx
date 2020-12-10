<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="EditSuperUser.aspx.vb" Inherits="Dynamicweb.Admin.EditSuperUser" %>

<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <% If DoClose Then %>
    <script type="text/javascript">
        SettingsPage.getInstance().cancel();
    </script>
    <% End if %>

    <script type="text/javascript">
        (function ($, options) {
            $(function () {
                var passwordIsEncrypted = <%= System.Web.Helpers.Json.Encode(PasswordIsEncrypted) %>;
                var cntTextPwdEl = $("#textPassword").toggleClass("hide", passwordIsEncrypted);
                var cntEncryptedPwdEl =$("#encryptedPasswordDiv").toggleClass("hide", !passwordIsEncrypted);
                var pwdEl = $(options.pwdElId);

                var page = SettingsPage.getInstance();
                page.onSave = function (pageObj, close) {
                    if (close) {
                        $("#DoSaveAndClose").val("True");
                        
                    } else {
                        $("#DoSave").val("True");
                    }
                    $(options.doSavePasswordElId).val(cntTextPwdEl.is(":visible") ? "True" : "False");
                    pageObj.submit();
                };

                $("#resetEncryptedPassword").on("click", function() {
                    if (confirm(options.resetPasswordConfirmationMessage)) {
                        cntTextPwdEl.toggleClass("hide", false);
                        cntEncryptedPwdEl.toggleClass("hide", true);
                        pwdEl.val("").focus();
                    }
                    return false;
                });

                $("#generatePassword").on("click", function() {
                    if (!pwdEl.val() || confirm(options.overwriteExistingPassword)) {
                        // Excluded: 0Oo lI1
                        var passwordChars = "23456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
                        var password = "";
                        while (password.length < 8) {
                            password += passwordChars.charAt(Math.floor(Math.random() * passwordChars.length))
                        }
                        pwdEl.val(password);
                    }
                    return false;
                });
            });
        })(jQuery, {
            resetPasswordConfirmationMessage: "<%=Dynamicweb.SystemTools.Translate.JsTranslate("Are you sure you want to reset the password?") %>",
            overwriteExistingPassword: "<%=Dynamicweb.SystemTools.Translate.JsTranslate("Do you want to overwrite the existing password?")%>",
            pwdElId: "#<%= Password.ClientID %>",
            doSavePasswordElId: "#<%= DoSavePassword.ClientID %>"
        });
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>            
            <li><a href="#">System</a></li>
            <li><a href="#">Edit super users</a></li>
            <li><a href="#"><asp:Label runat="server" ID="UserTypeBreadcrumb"></asp:Label></a></li>
        </ol>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" id="CardHeader" Title="Edit super user" />
        <dwc:CardBody runat="server">
            <input type="hidden" id="DoSave" name="DoSave"  />
            <input type="hidden" id="DoSaveAndClose" name="DoSaveAndClose"  />

            <dwc:GroupBox runat="server" Title="Edit" DoTranslation="true">
                <div class="form-group">
                    <label class="control-label" for="Username">
                        <%= Translate.Translate("Username") %>                        
                    </label>
                    <div class="form-group-input">
                        <input type="text" disabled="disabled" maxlength="255" runat="server" id="UserName" class="form-control" />
                    </div>
                </div>
                <div id="textPassword" class="hide">
                    <div class="form-group">
                        <label class="control-label" for="<%= Password.ClientID %>">
                            <%= Translate.Translate("Password") %>
                        </label>
                        <div class="form-group input-group">
                            <div class="form-group-input">
                                <input type="text" runat="server" id="Password" maxlength="255" class="form-control" />
                            </div>
                            <span class="input-group-addon">
                                <a id="generatePassword" href="#" title="<%=Dynamicweb.SystemTools.Translate.JsTranslate("Generate password") %>">
                                    <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Key) %>"></i>
                                </a>
                            </span>
                            <input type="hidden" id="DoSavePassword" runat="server" />
                        </div>
                    </div>
                    <dwc:CheckBox runat="server" ID="DoEncryptPassword" Label="Encrypt" DoTranslate="true" Value="True" />                        
                </div>
                <div class="form-group hide" id="encryptedPasswordDiv">
                    <label class="control-label">
                        <%= Translate.Translate("Password") %>
                    </label>
                    <p class="form-control-static">
                        <a id="resetEncryptedPassword" href="#">
                            <%= Translate.Translate("The password is encrypted. Click here to reset the password") %>
                        </a>
                    </p>
                </div>
                <div class="form-group">
                    <label class="control-label" for="Email">
                        <%= Translate.Translate("Email") %>
                    </label>
                    <div class="form-group-input">
                        <input type="text" maxlength="255" runat="server" id="Email" class="form-control" />
                    </div>
                </div>

                <table>
                    <asp:Repeater runat="server" ID="ErrorRepeater">
                        <ItemTemplate>
                            <tr>
                                <td />
                                <td>
                                    <span style="color: Red;">
                                        <%#Container.DataItem %>
                                    </span>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:Content>