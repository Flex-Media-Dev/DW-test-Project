<%@ Page CodeBehind="Default.aspx.vb" Language="vb" AutoEventWireup="false" Inherits="Dynamicweb.Admin._Default" CodePage="65001" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>

<!DOCTYPE html>
<html>
<head>
    <title>
        <dw:TranslateLabel runat="server" Text="Login" UseLabel="false" />
        (Dynamicweb <%=LicenseName%>)
    </title>
    <link id=​"favicon" rel=​"shortcut icon" type=​"image/​png" href=​"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACQAAAAjCAYAAAD8BaggAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNkRpr/UAAAO6SURBVFhHxdhriExxGMfxmbWGJULJLUT7ArnzglzCC7mtvVhLvFgvlEvKpZYky2gnSiG5FK2sW5JsoZS0imQn8oLESrnk0koukcsuw/e35zkZ48zOMGbnqY/Z5pz///nNf845cw5fqlVYND0bhzDH/rYtGSoFQCXeYj6y9F5GiwAb8Q2vMQJ+25SZIsBaCxRBDQKwrS1cNPbjAL7jBxowF5lZJRoPwUtodRRIr5fQFrZXmiq6AX+3wTw8hBvG9QbDYHv/59LERqf1UJTjNr4iNozovaVIz9fGxN0QRB28Ang5iLQF0oq4B22yziPLFwr3xAbkwmZMsQqKpg/EXRokuzpSHQhe7kKIK/iOQ2j1b6E06Bd/YHONP2/O7H6EOkujRiQMVlA0I+irqN3P+G+I4Bl6w5okUxYArdEfJdiOYzjsq7i+dlzp8jKC1dL0E+IFe9R7zYGlBPrAOIX5Ya9FsGaJygkTwAycxmu4k0V70q78wmRCTaHxTijcE9TjMaqnlZSMI0w1+8aOPwIdV9bUq36tygCcwWd4BYl2EVpFHfC6APZAH3RHNis5mG3vETtPPbrCmnuVk3g2XiB6cHNeoh9sEqcI04T318HrQ+m9DbZ7nAqFZ+ItdCa4Eq3QO2gVbJKocs6k8/AaJxo7Fa1shMZIdtMr/+iAPYGtKMdhaLWaC6Wlz3Vmi6lQOAf3bD8vmvcNTmEztuA4dMw1TZDtzGTlpB2JB4gXSg072IjfKxRuD53iXuNcmlffRKP5ghWwSbwqFJ5rO3pNdtT2+rOcFbpj+ybjI5Ygy2aIU84l4CZiJ9AnKuTg1a1qV/RFL3SAxumM3WX7NqcB1zDROiZRofB6xH5t9yeULtMvvm7sH+AVnuEWKrk+5XcvqxrOfl4fRrQiumwsQCck+QPsHEsDoRVxJquojeSUX1xN4zC8rtC6cjcQ6s7khYuCgWDNSsZVQgftbizGILSDVtKaJVNOIA1yj4cIgWpmFRfoycIrjEuhIoRqxI284vxRbTdd0qVA1zsnxF8FiS5ncBn0tdX5K64PoNmWqObNcYPVY5LNmGI5gTpD9zO6d9YN/TZrmCwFO2kz/t9iYllljRJRkOfYC++LaKrFxDIB8QLo2ewRdmA8cpC+J1lNjM54itgwuv1Yg47QV+vub6PTUNZATx57EB3mPfLRFKRFSw0xGgrhBrqKzPzPh5pa831QGD2NVNnmzBQBRHeIehJRoFO2KXNFCB0vY6FTW/fVCX6tW6As1BicQ0d7O4Xy+X4CWmQNSw1g+usAAAAASUVORK5CYII=">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="robots" content="noindex,noarchive,nofollow" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta name="Cache-control" content="no-cache" />
    <meta http-equiv="Cache-control" content="no-cache" />

    <!-- Default control resources -->
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />

    <!-- Needed non-default scripts -->
    <script type="text/javascript">
        var SpecifyUsernameText = "<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.Translate("Brugernavn"))%>";
        var SpecifyPasswordText = "<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.Translate("Adgangskode"))%>";
        var MissingText = "<%=Translate.JsTranslate("Please input username and password")%>";
        var use2fa = <%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetBoolean("/Globalsettings/Modules/Users/Use2fa").ToString().ToLower()%>;
        var waitMessage = "<i class=\"fa fa-refresh fa-spin\" id=\"waiting\"></i>";
        (function ($) {
            $(function () {
                $('#Username').keydown(function (e) { catchThatEnter2(e); });
                $('#Username').focus(function () { this.select(); });
                $('#Password').keydown(function (e) { catchThatEnter(e); });
                $('#Password').focus(function () { this.select(); });
            });
        })(window.jQuery);
    </script>
    <script src="Default.js" type="text/javascript"></script>
    <link href="Login.css" rel="stylesheet" />
    <style>
        body {
            background: #00547F; /* fallback for old browsers */
            background: -webkit-linear-gradient(342deg, #0085ca, #00547F); /* Chrome 10-25, Safari 5.1-6 */
            background: linear-gradient(342deg, #00547F, #0085ca); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
        }
    </style>
</head>
<body onload="start();init();" class="area-blue login-screen label-top">
    <div class="dw-full-logo">
    </div>
    <dw:Dialog ID="ChangeLanguage" runat="server" Title="Change language" Width="500">
        <div id="langSelect">
            <%= GetLanguageSelect(True)%>
        </div>
    </dw:Dialog>
    <div class="container login-container" id="container">
        <dwc:Card runat="server">
            <form id="login" name="login" action="" method="post" onsubmit="checkInput('Access_User_login.aspx');return true;">
                <dwc:CardBody runat="server">
                    <dw:Infobar ID="infoOldVersion" runat="server" Message="" Type="Warning">
                        Solution was last upgraded: <%=Me.BuildDate%>. Consider upgrade to newer version
                    </dw:Infobar>
                    <dw:Infobar ID="warnVersionProblem" runat="server" Message="" Type="Error">
                    </dw:Infobar>
                    <dw:Infobar ID="warnSolutionLocked" runat="server" Message="" Type="Error" Visible="false">
                        <%= Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/System/dblgnfornafemsg")%>
                    </dw:Infobar>
                    <dw:Infobar ID="warnTrialExpired" runat="server" Message="" Type="Error" Visible="false">
                    </dw:Infobar>

                    

                    <div class="col-md-6 col-sm-6 col-xs-12 form-group-full-width">
                        <h2><%=Translate.Translate("Sign in to")%><br />
                            Dynamicweb</h2>
                        <dwc:InputText runat="server" title="Brugernavn" Placeholder="Brugernavn" Value="" ID="Username" Name="Username" />

                        <dwc:InputText runat="server" Password="true" title="Kodeord" Placeholder="Kodeord" Value="" ID="Password" Name="Password" MaxLength="1000" />
                        
                        <div>
                            <div id="warning" runat="server" style="display: none;">
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.ExclaminationTriangle, True)%>"></i>
                                <span id="warningMsg" runat="server"></span>
                            </div>
                        </div>

                        <div id="cookieswarning" style="display: none;">
                            <div>
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.ExclaminationTriangle, True)%>"></i>
                            </div>
                            <div><%=Translate.JsTranslate("Cookies must be enabled for using DynamicWeb")%></div>
                        </div>

                        <div style="display: none;">
                            <select title="<%=Translate.Translate("Sprog")%>" id="language" name="language" class="inputLang selectpicker" onchange="SetFormPath(document.getElementById('language').value);"><%= GetLanguageSelect(False)%></select>
                            <div class="spacer">
                            </div>
                        </div>

                        <% If Not Converter.ToBoolean(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CustomerAccess/HideRememberFeatures")) Then%>
                        <dwc:CheckBox runat="server" Label="Remember me on this computer" Name="usecookiea" ID="usecookiea" OnClick="cookieclick();" Indent="false" />
                        <small>By logging into Dynamicweb you accept our <a href="http://www.dynamicweb.com/licenseterms" target="_blank">License terms</a></small><br /><br />
                        <span style="display: none;">
                            <input <%=chkb%> name="usecookieb" id="usecookieb" onclick="nescafecheck();" type="checkbox" />
                            <input <%=chkAutoLogin%> name="AutoLogin" id="AutoLogin" type="checkbox" value="True" />
                        </span>
                        <%End If%>

                        <div>
                            <a class="btn btn-success signin-button" href="javascript:checkInput('Access_User_login.aspx');" id="loginBtn"><%=Translate.Translate("Sign in")%></a>&nbsp;&nbsp;<span id="waitingPlaceholder" style="display: none;"></span>
                        </div>
                        
                        <div>
                            <%= GetExternalProviderButtons() %>
                        </div>
                        <dw:Infobar ID="ExternalAuthError" Visible="false" Type="Error" runat="server" />
                        
                       <%-- <a class="btn btn-success" href="javascript:signIn()">Sign In using Azure AD</a>--%>
 <h4 id="WelcomeMessage"></h4>
                        <br />
                        <br />
                        <!--b><%= Translate.Translate("Hjælp")%>:</!--b> <a href="" class="btn btn-link"><%= Translate.Translate("I forgot my username or password")%></a><br /-->

                    </div>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <div style="text-align: right">
                            <img src="/Admin/Resources/img/DW_logo_200.png" />
                        </div>
                        <div class="customlogo partner-box" id="customLogo" runat="server">
                            <div id="customLogoLicensedDiv" runat="server">
                                <h5><%= Translate.Translate("Licensed to")%>: </h5>
                                <%=CustomerInfo %>
                                <div id="imageContainer">
                                    <img class="customlogoimg" id="imgPartnerLogo" runat="server" src="/Admin/Images/Nothing.gif" alt="" />
                                </div>
                            </div>
                            <div id="customLogoPartnerInfoDiv" runat="server">
                                
                                <h5><%= Translate.Translate("Partner")%>: </h5>
                                <p class="partnerinfo">
                                    <%=PartnerInfo%>
                                </p>
                            </div>
                        </div>
                    </div>
                </dwc:CardBody>

                <dwc:CardFooter runat="server">
                    <span id="versionInfo" runat="server" visible="true"></span>

                    <div class="pull-right"><%=GetSmallFlag() %> <a href="#" onclick="return dialog.show('ChangeLanguage');" class="btn btn-link"><%= Translate.Translate("Change language")%></a></div>
                </dwc:CardFooter>
                <%
                    Session.Clear()
                    Dim inputName As String = Dynamicweb.Admin.Access_User_Login.GetNewLogonCsrfInputName()
                    Dim token As String = Dynamicweb.Admin.Access_User_Login.GetNewLogonCsrfToken()
                %>
                <input type="hidden" name="<%=inputName%>" value="<%=token %>" />

            </form>
        </dwc:Card>
    </div>

    

    <dw:Dialog ID="BrowserCompability" runat="server" Title="Browser compability" ShowClose="true" Size="Small">
        <div>
            <p>
                <%=Translate.Translate("You are using a browser version which is not officially supported for the Dynamicweb administration interface. For a better experience, please use the latest versions of Microsoft Edge, Mozilla Firefox, Google Chrome or Apple Safari.")%>
            </p>
            <a href="http://doc.dynamicweb-cms.com/Default.aspx?ID=6819"><%=Translate.Translate("See the requirements")%></a>
        </div>
    </dw:Dialog>

    <script type="text/javascript">
        function getBrowserInfo() {
            var ua = navigator.userAgent, tem;
            var M = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];

            if (/trident/i.test(M[1])) {
                tem = /\brv[ :]+(\d+)/g.exec(ua) || [];
                return { name: 'IE', version: (tem[1] || '') };
            }
            if (M[1] === 'Chrome') {
                tem = ua.match(/\Edge\/(\d+)/)
                if (tem != null) { return { name: 'Edge', version: tem[1] }; }

                tem = ua.match(/\bOPR\/(\d+)/)
                if (tem != null) { return { name: 'Opera', version: tem[1] }; }
            }
            M = M[2] ? [M[1], M[2]] : [navigator.appName, navigator.appVersion, '-?'];
            if ((tem = ua.match(/version\/(\d+)/i)) != null) { M.splice(1, 1, tem[1]); }

            return { name: M[0], version: M[1] };
        }

        var b = getBrowserInfo();
        if ((b.name === "Chrome" && b.version < 50) || (b.name === "Firefox" && b.version < 45) || (b.name === "Safari" && b.version < 9) || (b.name === "Edge" && b.version < 13) || (b.name === "IE" && b.version < 12)) {
            dialog.show('BrowserCompability');
        }
        else if (b.name !== "Chrome" && b.name !== "Firefox" && b.name !== "Safari" && b.name !== "Edge" && b.name !== "IE") {
            dialog.show('BrowserCompability');
        }
    </script>

    <script src="https://secure.aadcdn.microsoftonline-p.com/lib/1.0.12/js/adal.min.js"></script>
    <script>
        var ADAL = new AuthenticationContext({
            instance: 'https://login.microsoftonline.com/',
            tenant: 'common', //COMMON OR YOUR TENANT ID

            clientId: '6ce3266e-040b-4b99-8ef9-336bfcf8ca97', //This is your client ID
            redirectUri: 'http://localhost/Admin/Access/ExternalAuthentication.aspx', //This is your redirect URI

            callback: userSignedIn,
            popUp: true
        });

        function signIn() {
            ADAL.login();
        }

        function userSignedIn(err, token) {
            console.log('userSignedIn called');
            if (!err) {
                console.log("token: " + token);
                showWelcomeMessage();
            }
            else {
                console.error("error: " + err);
            }
        }

        function showWelcomeMessage() {
            var user = ADAL.getCachedUser();
            var profile = user.profile;
            console.log("user: " + user);
            var divWelcome = document.getElementById('WelcomeMessage');
            divWelcome.innerHTML = "Welcome " + user.profile.name + " (" + userName + ")";
        }

    </script>
</body>
</html>
<% 
    Translate.GetEditOnlineScript()
%>