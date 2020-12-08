<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Security_cpl.aspx.vb" Inherits="Dynamicweb.Admin.Security_cpl" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="../Stylesheet.css">
    <title></title>
</head>
<body>
    <script type="text/javascript" src="/Admin/Validation.js"></script>
    <script>
        function OK_OnClick() {
            var eml = document.getElementById("/Globalsettings/System/Security/FormAntiSpamReportTo");
            if (IsEmailValid(eml,
                "<%=Translate.JSTranslate("Ugyldig_værdi_i:_%%", "%%", Translate.JsTranslate("Send kopi til e-mail"))%>"))
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

    <%=Dynamicweb.SystemTools.Gui.MakeHeaders(Translate.Translate("Kontrol Panel - %%","%%",Translate.Translate("Sikkerhed",9)),Translate.Translate("Konfiguration"), "all")%>

    <table border="0" cellpadding="2" cellspacing="0" class="tabTable">
        <form method="post" action="ControlPanel_Save.aspx?Type=URL" name="frmGlobalSettings" id="frmGlobalSettings">
            <input type="hidden" name="CheckboxNames">
            <tr>
                <td valign="top">
                    <br>
                    <%=(Gui.GroupBoxStart(Translate.Translate("E-mail")))%>
                    <table border="0" cellpadding="2" cellspacing="0">
                        <tr>
                            <td width="170"><%=Translate.Translate("Masker_e-mailadresser")%></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/System/Url/EmailMunging") = "True", "checked", "")%> id="/Globalsettings/System/Url/EmailMunging" name="/Globalsettings/System/Url/EmailMunging"></td>
                        </tr>
                    </table>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
                    <%=(Gui.GroupBoxStart(Translate.Translate("Formular")))%>
                    <table border="0" cellpadding="2" cellspacing="0">
                        <tr>
                            <td width="170"><%=Translate.Translate("Aktiver antispam funktion")%></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/System/Security/FormAntiSpam") = "True", "checked", "")%> id="/Globalsettings/System/Security/FormAntiSpam" name="/Globalsettings/System/Security/FormAntiSpam"></td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Send kopi til e-mail")%></td>
                            <td>
                                <input type="text" maxlength="255" class="std" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/System/Security/FormAntiSpamReportTo")%>" name="/Globalsettings/System/Security/FormAntiSpamReportTo" id="/Globalsettings/System/Security/FormAntiSpamReportTo"></td>
                        </tr>
                    </table>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
                    <%If (Session("DW_Admin_UserID") = 2 Or Session("DW_Admin_UserID") = 4) Then%>
                    <%=(Gui.GroupBoxStart(Translate.Translate("Dynamicweb support")))%>
                    <table border="0" cellpadding="2" cellspacing="0">
                        <tr>
                            <td width="170"><%=Translate.Translate("Restrict access for support users")%></td>
                            <td>
                                <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/System/Security/AngelLocked") = "True", "checked", "")%> id="/Globalsettings/System/Security/AngelLocked" name="/Globalsettings/System/Security/AngelLocked"></td>
                        </tr>
                    </table>
                    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
                    <%End If%>

                    <tr>
                        <td align="right" valign="bottom">
                            <table>
                                <tr>
                                    <td><%=Dynamicweb.SystemTools.Gui.Button(Translate.Translate("OK"), "findCheckboxNames(this.form);OK_OnClick();", "90")%></td>
                                    <td><%=Dynamicweb.SystemTools.Gui.Button(Translate.Translate("Annuller"), "location='ControlPanel.aspx';", "90")%></td>
                                    <td><%=Dynamicweb.SystemTools.Gui.HelpButton("", "administration.controlpanel.security")%></td>
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
