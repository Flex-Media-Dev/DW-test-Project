<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DataManagement_cpl.aspx.vb" Inherits="Dynamicweb.Admin.DataManagement_cpl" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title><%=Translate.JsTranslate("DataManagement")%></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <link rel="Stylesheet" type="text/css" href="../Stylesheet.css" />
    
    <script type="text/javascript" language="javascript">
        function findCheckboxNames(form) {
            var _names = "";
            for (var i = 0; i < form.length; i++) {
                if (form[i].name != undefined) {
                    if (form[i].type == "checkbox") {
                        _names = _names + form[i].name + "@"
                    }
                }
            }
            form.CheckboxNames.value = _names;
        }
        
        function findEvents(form) {
            var _names = "";
            for (var i = 0; i < form.length; i++) {
                if (form[i].name != undefined) {
                    if (form[i].type == "checkbox" && form[i].checked == true) {
                        _names = _names + form[i].id + ","
                    }
                }
            }
            if (_names.length > 1) {
                _names = _names.substring(0, _names.length - 1);
            }
            document.getElementById('events').value = _names;
        }

    </script>
</head>
<body>
    <%=Dynamicweb.SystemTools.Gui.MakeHeaders(Translate.Translate("Kontrol Panel - %%", "%%", Translate.Translate("DataManagement")), Translate.Translate("Konfiguration"), "all")%>
    <form method="post" action="ControlPanel_Save.aspx" name="frmGlobalSettings" id="frmGlobalSettings">
		<input type="hidden" name="CheckboxNames" />
		<input type="hidden" name="/Globalsettings/Modules/DataManagement/HiddenEvents" id="events" />
        <table border="0" cellpadding="2" cellspacing="0" class="tabTable">

		    <tr>
			    <td valign="top">
    			<dw:ModuleHeader runat="server" ModuleSystemName="DataManagement"/> 

			        <dw:GroupBox runat="server" Title="Form events">
			            <table>
			                <tr>
			                    <td><dw:TranslateLabel runat="server" Text="Choose which form save events should not be available to editors" /></td>
			                    <td>
			                        <table cellpadding="0" cellspacing="0">
			                            <tr>
			                                <td style="border-right: solid 1px #000000; border-bottom: solid 1px #000000;"><dw:TranslateLabel runat="server" Text="Event" /></td>
			                                <td style="border-bottom: solid 1px #000000;"><dw:TranslateLabel runat="server" Text="Hidden" /></td>
			                            </tr>
			                            <asp:Literal runat="server" ID="eventsList" />
			                        </table>
			                    </td>
			                </tr>
			            </table>
			        </dw:GroupBox>
			    </td>
		    </tr>
		    
		    <tr>
			    <td align="right" valign="bottom">
			        <dw:Button ID="Button1" runat="server" OnClick="findEvents(this.form); document.getElementById('frmGlobalSettings').submit();" Name="Ok" />&nbsp;
			        <dw:Button ID="Button2" runat="server" OnClick="location='ControlPanel.aspx';" Name="Cancel" />&nbsp;
			    </td>
		    </tr>
        </table>
    </form>
</body>
</html>
