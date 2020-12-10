<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Settings_cpl.aspx.vb" Inherits="Dynamicweb.Admin.Settings_cpl" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="System.Data" %>


<%
    Dim DWAdminLanguage As String = CStr(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/LanguagePack/DefaultLanguage"))
%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="../Stylesheet.css">
    <title><%=Translate.JsTranslate("Generelt")%></title>
</head>
<body>
    <script type="text/javascript" src="/Admin/Validation.js"></script>
    <script>
        function OK_OnClick() {
            var eml = document.getElementById("/Globalsettings/Settings/CommonInformation/Email");
            var ret = true;

            if (eml.value.length > 0)
                ret = IsEmailValid(eml, "<%=Translate.JsTranslate("Ugyldig_værdi_i:_%%", "%%", Translate.Translate("E-mail"))%>");

        if (ret)
            document.getElementById('frmGlobalSettings').submit();
    }

    function findCheckboxNames(form) {
        var _names = "";
        for (var i = 0; i < form.length ; i++) {
            if (form[i].name != undefined) {
                if (form[i].type == "checkbox") {
                    _names = _names + form[i].name + "@"
                }
            }
        }
        form.CheckboxNames.value = _names;
    }
    </script>

    <%=Dynamicweb.SystemTools.Gui.MakeHeaders(Translate.Translate("Kontrol Panel - %%", "%%", Translate.Translate("Generelt")), Translate.Translate("Konfiguration"), "all")%>

    <table border="0" cellpadding="2" cellspacing="0" class="tabTable">
        <form method="post" action="ControlPanel_Save.aspx" name="frmGlobalSettings" id="frmGlobalSettings">
            <input type="hidden" name="CheckboxNames">
            <tr>
                <td valign="top">
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Indstilling"))%>
                    <table cellpadding='2' cellspacing='0' border='0' width='100%'>
                        <tr>
                            <td width="36" align="left">
                                <img src="../Images/Icons/cplGeneral.gif"></td>
                            <td align="left" nowrap style='font-size: 14; font-family: Verdana, Arial, Helvetica; font-weight: Bold;'><%=Translate.Translate("Generelt")%></td>
                        </tr>
                    </table>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>

                    <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Generel information"))%>
                    <table border="0" cellpadding="2" cellspacing="0">
                        <tr>
                            <td width="170">
                                <label for="/Globalsettings/Settings/CommonInformation/SolutionTitle"><%=Translate.Translate("Løsningstitel")%></label></td>
                            <td>
                                <input type="text" maxlength="255" value="<%=Server.HtmlEncode(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CommonInformation/SolutionTitle"))%>" class="std" id="/Globalsettings/Settings/CommonInformation/SolutionTitle" name="/Globalsettings/Settings/CommonInformation/SolutionTitle"></td>
                        </tr>
                        <tr>
                            <td>
                                <label for="/Globalsettings/Settings/CommonInformation/Partner"><%=Translate.Translate("Partner")%></label></td>
                            <td>
                                <input type="text" maxlength="255" value="<%=Server.HtmlEncode(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CommonInformation/Partner"))%>" class="std" id="/Globalsettings/Settings/CommonInformation/Partner" name="/Globalsettings/Settings/CommonInformation/Partner"></td>
                        </tr>
                        <tr>
                            <td>
                                <label for="/Globalsettings/Settings/CommonInformation/Email"><%=Translate.Translate("E-mail")%></label></td>
                            <td>
                                <input type="text" maxlength="255" value="<%=Server.HtmlEncode(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CommonInformation/Email"))%>" class="std" id="/Globalsettings/Settings/CommonInformation/Email" name="/Globalsettings/Settings/CommonInformation/Email"></td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <label for="/Globalsettings/Settings/CommonInformation/CopyrightMetaInformation"><%=Translate.Translate("Copyright")%></label></td>
                            <td>
                                <textarea class="std" name="/Globalsettings/Settings/CommonInformation/CopyrightMetaInformation"
                                    id="/Globalsettings/Settings/CommonInformation/CopyrightMetaInformation" rows="5"><%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CommonInformation/CopyrightMetaInformation")%></textarea></td>
                        </tr>
                    </table>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("IE 8 Compatibility"))%>
                    <table border="0" cellpadding="2" cellspacing="0">
                        <tr>
                            <td width="170"></td>
                            <td>
                                <%  If Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/IE8/Mode") = "" Then
                                        Dynamicweb.Configuration.SystemConfiguration.Instance.SetValue("/Globalsettings/Settings/IE8/Mode", "EmulateIE7")
                                    End If
                                %>
                                <input type="radio" value="IE8Standards" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/IE8/Mode") = "IE8Standards", "checked", "")%> id="Mode3" name="/Globalsettings/Settings/IE8/Mode"><label for="Mode3"><%=Translate.Translate("Standards Compliance")%> (<%=Translate.Translate("Standard")%>)</label><br />
                                <input type="radio" value="EmulateIE7" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/IE8/Mode") = "EmulateIE7", "checked", "")%> id="Mode1" name="/Globalsettings/Settings/IE8/Mode"><label for="Mode1"><%=Translate.Translate("Emulate IE 7")%>: "IE=EmulateIE7"</label><br />
                                <input type="radio" value="IE8Comp" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/IE8/Mode") = "IE8Comp", "checked", "")%> id="Mode2" name="/Globalsettings/Settings/IE8/Mode"><label for="Mode2"><%=Translate.Translate("Force IE 7 Standards Compliance")%>: "IE=7"</label>

                            </td>
                        </tr>
                    </table>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Performance"))%>
                    <table border="0" cellpadding="2" cellspacing="0" id="Table1">
                        <tr>
                            <td width="170"></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/Performance/AllNavigationImagesInTheSameJavascript") = "True", "checked", "")%> id="/Globalsettings/Settings/Performance/AllNavigationImagesInTheSameJavascript" name="/Globalsettings/Settings/Performance/AllNavigationImagesInTheSameJavascript"><label for="/Globalsettings/Settings/Performance/AllNavigationImagesInTheSameJavascript"><%=Translate.Translate("Alle navigationsbilleder i samme Javascript")%></label></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/Performance/ActivateDublinCore") = "True", "checked", "")%> id="/Globalsettings/Settings/Performance/ActivateDublinCore" name="/Globalsettings/Settings/Performance/ActivateDublinCore"><label for="/Globalsettings/Settings/Performance/ActivateDublinCore"><%=Translate.Translate("Aktiver Dublin Core")%></label></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/Performance/ActivateMouseoverTextsOnMenuItems") = "True", "checked", "")%> id="/Globalsettings/Settings/Performance/ActivateMouseoverTextsOnMenuItems" name="/Globalsettings/Settings/Performance/ActivateMouseoverTextsOnMenuItems"><label for="/Globalsettings/Settings/Performance/ActivateMouseoverTextsOnMenuItems"><%=Translate.Translate("Aktiver mouseover tekster på menupunkter")%></label></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/Performance/ActivateTitleTextsOnMenuItems") = "True", "checked", "")%> id="/Globalsettings/Settings/Performance/ActivateTitleTextsOnMenuItems" name="/Globalsettings/Settings/Performance/ActivateTitleTextsOnMenuItems"><label for="/Globalsettings/Settings/Performance/ActivateTitleTextsOnMenuItems"><%=Translate.Translate("Aktiver title tekster på menupunkter")%></label></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/Performance/DeactivateBrowserCache") = "True", "checked", "")%> id="/Globalsettings/Settings/Performance/DeactivateBrowserCache" name="/Globalsettings/Settings/Performance/DeactivateBrowserCache"><label for="/Globalsettings/Settings/Performance/DeactivateBrowserCache"><%=Translate.Translate("Deaktiver browser cache")%></label></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/Performance/DeactivateParagraphAnchor") = "True", "checked", "")%> id="/Globalsettings/Settings/Performance/DeactivateParagraphAnchor" name="/Globalsettings/Settings/Performance/DeactivateParagraphAnchor"><label for="/Globalsettings/Settings/Performance/DeactivateParagraphAnchor"><%=Translate.Translate("Deaktiver afsnits bogmærke")%></label></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input id="/Globalsettings/Settings/Performance/ActivateDropDownCache" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/Performance/ActivateDropDownCache") = "True", "checked", "")%>="" name="/Globalsettings/Settings/Performance/ActivateDropDownCache" type="checkbox" value="True"><label for="/Globalsettings/Settings/Performance/ActivateDropDownCache"><%=Translate.Translate("Aktiver dropdown cache")%></label></td>
                        </tr>
                    </table>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>
                    <%  If Session("DW_Admin_UserID") < 3 Then
                            Response.Write(Gui.GroupBoxStart(Translate.Translate("Kundeadgang")))
                    %>
                    <table border="0" cellpadding="2" cellspacing="0">
                        <tr>
                            <td width="170"><%=Translate.Translate("Standardsprog")%></td>
                            <td>
                                <select class="std" name="/Globalsettings/Modules/LanguagePack/DefaultLanguage" id="/Globalsettings/Modules/LanguagePack/DefaultLanguage">
                                    <%  If Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/LanguagePack/DefaultLanguage") = "" Then
                                            DWAdminLanguage = 1
                                        End If

                                        Using LanguageConn As System.Data.IDbConnection = Translate.LanguageDatabase.CreateConnection()
                                            Using cmdLanguage As IDbCommand = LanguageConn.CreateCommand

                                                cmdLanguage.CommandText = "SELECT * FROM [Languages] WHERE LanguageActive=1"
                                                Using drLanguageReader As IDataReader = cmdLanguage.ExecuteReader()
                                                    Dim opLanguageName As Integer = drLanguageReader.GetOrdinal("LanguageName")
                                                    Dim opid As Integer = drLanguageReader.GetOrdinal("LanguageID")

                                                    Do While drLanguageReader.Read
                                                        Response.Write("<option value=""" & drLanguageReader(opid) & """ " & IIf(CStr(drLanguageReader(opid)) = Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/LanguagePack/DefaultLanguage"), "Selected", "") & ">" & drLanguageReader(opLanguageName) & "</option>")
                                                    Loop

                                                End Using
                                            End Using
                                        End Using
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td width="170">
                                <%=Translate.Translate("Dynamicweb login URL")%>
                            </td>
                            <td>
                                <select name="/Globalsettings/Settings/DynamicwebLoginUrl" class="std">
                                    <option <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/DynamicwebLoginUrl") = "www.dynamicweb.dk", "selected", "")%>="" value="www.dynamicweb.dk">dynamicweb.dk</option>
                                    <option <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/DynamicwebLoginUrl") = "www.dynamicweb.se", "selected", "")%> value="www.dynamicweb.se">dynamicweb.se</option>
                                    <option <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/DynamicwebLoginUrl") = "www.dynamicweb.no", "selected", "")%>="" value="www.dynamicweb.no">dynamicweb.no</option>
                                    <option <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/DynamicwebLoginUrl") = "www.dynamicweb.nl", "selected", "")%>="" value="www.dynamicweb.nl">dynamicweb.nl</option>
                                    <option <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/DynamicwebLoginUrl") = "www.dynamicweb.pt", "selected", "")%>="" value="www.dynamicweb.pt">dynamicweb.pt</option>
                                    <option <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/DynamicwebLoginUrl") = "www.dynamicweb.biz", "selected", "")%>="" value="www.dynamicweb.biz">dynamicweb.biz</option>
                                </select>
                            </td>
                        </tr>                        
                        <tr>
                            <td width="170"><%=Translate.Translate("Lås")%></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CustomerAccess/LockStylesheet") = "True", "checked", "")%> id="DWLock_Stylesheet" name="/Globalsettings/Settings/CustomerAccess/LockStylesheet">
                                <label for="DWLock_Stylesheet"><%=Translate.Translate("Fanen %%", "%%", Translate.Translate("Stylesheet"))%></label>
                            </td>
                        </tr>
                        <tr>
                            <td width="170"></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CustomerAccess/LockTemplateFolder") = "True", "checked", "")%> id="DWLock_Templates" name="/Globalsettings/Settings/CustomerAccess/LockTemplateFolder">
                                <label for="DWLock_Templates"><%=Translate.Translate("Mappen %%", "%%", Translate.Translate("Template"))%></label>
                            </td>
                        </tr>
                        <tr>
                            <td width="170"></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CustomerAccess/LockSystemFolder") = "True", "checked", "")%> id="DWLock_System" name="/Globalsettings/Settings/CustomerAccess/LockSystemFolder">
                                <label for="DWLock_System"><%=Translate.Translate("Mappen %%", "%%", Translate.Translate("System"))%></label>
                            </td>
                        </tr>
                    </table>
                    <%      Response.Write(Gui.GroupBoxEnd)
                        End If%>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Min side"))%>
                    <table border="0" cellpadding="2" cellspacing="0" id="Table1">
                        <tr>
                            <td width="170">
                                <label for="/Globalsettings/Settings/MyPage/HideStat"><%=Translate.Translate("Skjul statistik")%></label></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/MyPage/HideStat") = "True", "checked", "")%> id="/Globalsettings/Settings/MyPage/HideStat" name="/Globalsettings/Settings/MyPage/HideStat"></td>
                        </tr>
                        <tr>
                            <td width="170">
                                <label for="/Globalsettings/Settings/MyPage/CustomInfoBoxURLLocation"><%=Translate.Translate("Seneste nyt side")%></label></td>
                            <td>
                                <input type="text" class="std" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/MyPage/CustomInfoBoxURLLocation")%>" id="/Globalsettings/Settings/MyPage/CustomInfoBoxURLLocation" name="/Globalsettings/Settings/MyPage/CustomInfoBoxURLLocation"></td>
                        </tr>
                    </table>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Brugerdefinerede fejlsider"))%>
                    <table border="0" cellpadding="2" cellspacing="0" id="Table1">
                        <tr>
                            <td width="170">
                                <label for="PageNotFoundRedirectTo"><%=Translate.Translate("HTTP 404")%></label></td>
                            <td><%=Dynamicweb.SystemTools.Gui.LinkManager(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/PageNotFound/RedirectTo"), "PageNotFoundRedirectTo", "")%></td>
                        </tr>
                    </table>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>
                    <tr>
                        <td align="right" valign="bottom">
                            <table>
                                <tr>
                                    <td>
                                        <%=Dynamicweb.SystemTools.Gui.Button(Translate.Translate("OK"), "findCheckboxNames(this.form);OK_OnClick();", "90")%>
                                    </td>
                                    <td>
                                        <%=Dynamicweb.SystemTools.Gui.Button(Translate.Translate("Annuller"), "location='ControlPanel.aspx';", "90")%>
                                    </td>
                                    <%=Dynamicweb.SystemTools.Gui.HelpButton("", "administration.controlpanel.general")%>
                                    <td width="2"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </td>
                <tr>
        </form>
    </table>
    <%
        Translate.GetEditOnlineScript()
    %>
    </body>
</html>