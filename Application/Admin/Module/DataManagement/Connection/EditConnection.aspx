<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditConnection.aspx.vb" Inherits="Dynamicweb.Admin.EditConnection" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server" />
    <style type="text/css">
        .validation-error {
            background-color: #FFAAAA;
        }
    </style>
    <script type="text/javascript">
        var id = <%=ItemID%>;
        var cmd = "<%=CMD%>";
        var helpLang = "<%=helpLang %>";
        
        function validateField(name) {
            var elemGet = $(name);
            var elemSet = $(name);
            if (elemGet === null) {
                // assume the FM
                elemGet = $(name + '_path');
                elemSet = $('FM_' + name);
            }
            
            if (elemGet.getValue() === '') {
                elemSet.addClassName('validation-error');
                return false;
            } else {
                elemSet.removeClassName('validation-error');
                return true;
            }
        }

        function checkFields() {
            var type = $F("radio_csType_selected");
            var fields = [];
            var isClean = validateField('csName');
            switch(type) {
                case 'csType_sql':
                case 'csType_crm4':
                    isClean = isClean && validateField('csServer');
                    isClean = isClean && validateField('csDBName');
                    break;
            }
            return isClean;
        }
        
        function save() {
            if(!checkFields())
                return false;
            document.getElementById('form1').action = "EditConnection.aspx?ID=" + id + "&CMD=SAVE_CONNECTION&OnSave=Nothing";
            document.getElementById('form1').submit();
        }

        function saveAndClose() {
            if(!checkFields())
                return false;
            document.getElementById('form1').action = "EditConnection.aspx?ID=" + id + "&CMD=SAVE_CONNECTION&OnSave=Close";
            document.getElementById('form1').submit();
        }

        function cancel() {
            document.getElementById('form1').target = '';
            document.getElementById('form1').action = "EditConnection.aspx?CMD=CANCEL";
            document.getElementById('form1').submit();
        }

        function help() {
            window.open('http://manual.net.dynamicweb.dk/Default.aspx?ID=1&m=keywordfinder&keyword=modules.datamanagement.general.connection.edit&LanguageID=' + helpLang, 'dw_help_window', 'location=no,directories=no,menubar=no,toolbar=yes,top=0,width=1024,height=' + (screen.availHeight-100) + ',resizable=yes,scrollbars=yes');
        }
        
        function ChangeFieldLayout(type) {
            $$('.sql-settings').each(Element.hide);
            $$('.access-settings').each(Element.hide);
            $$('.crm4-settings').each(Element.hide);
            $$('.' + type + '-settings').each(Element.show);
            if (type == "crm4") {
                $("tlDatabaseName").innerHTML = '<%=Translate.JsTranslate("Organization") %>';
                $$("#settingsDiv legend")[0].innerHTML = 'Microsoft CRM 4';
            } else {
                $("tlDatabaseName").innerHTML = '<%=Translate.JsTranslate("Database name") %>';
                $$("#settingsDiv legend")[0].innerHTML = '<%=Translate.JsTranslate("Database") %>&nbsp;';
            }
        }
        
        function toggleTrusted(obj) {
            var pass = $("csPassword");
            var user = $("csUserId");
            
            if (obj.checked) {
                pass.disabled = true;
                user.disabled = true;    
            } else {
                pass.disabled = false;
                user.disabled = false;    
            }
        }
        
        Event.observe(window, "load", function() {
            ChangeFieldLayout('<%=GetTypeString()%>');
            
            ['csName', 'csServer', 'csDBName'].each(function(e){
                $(e).observe("change", function() {
                    validateField(e);
                });
            });
        });
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <form id="form1" runat="server">
            <dw:RibbonBar ID="Ribbon" runat="server">
                <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="Connection">
                    <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Funktioner">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="save();" ID="Save" EnableServerClick="false" />
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="saveAndClose();" ID="SaveAndClose" EnableServerClick="false" />
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="TimesCircle" OnClientClick="cancel();" ID="Cancel" EnableServerClick="false" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="rgButtons" runat="server" Name="Connection type">
                        <dw:RibbonBarRadioButton OnClientClick="ChangeFieldLayout('sql');" ID="csType_sql" Group="csType" Text="SQL" RenderAs="Default" Value="0" Checked="true" runat="server" Size="Large" Icon="Database" />
                        <dw:RibbonBarRadioButton OnClientClick="ChangeFieldLayout('access');" ID="csType_access" Group="csType" Text="MS Access" RenderAs="Default" Value="1" runat="server" Size="Large" Icon="Database" Hide="true" />
                        <dw:RibbonBarRadioButton OnClientClick="ChangeFieldLayout('crm4');" ID="csType_crm4" Group="csType" Text="MS CRM 4" RenderAs="Default" Value="2" runat="server" Size="Large" Icon="Database" DoTranslate="False" ModuleSystemName="CRMIntegration" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup2" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="HelpBut" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <dwc:CardBody runat="server">
                <dwc:GroupBox ID="gbName" runat="server" DoTranslation="true" Title="Indstillinger">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Name" />
                            </td>
                            <td>
                                <input type="text" name="csName" id="csName" runat="server" maxlength="255" class="NewUIinput" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
                <div id="settingsDiv">
                    <dwc:GroupBox ID="gbSettings" runat="server" DoTranslation="true" Title="Database">
                        <table class="formsTable">
                            <tr id="sql_1">
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Server name" />
                                </td>
                                <td>
                                    <input type="text" name="csServer" id="csServer" runat="server" maxlength="255" class="NewUIinput" />
                                </td>
                            </tr>
                            <tr id="sql_2">
                                <td>
                                    <div id="tlDatabaseName">
                                        <dw:TranslateLabel runat="server" Text="Database name" />
                                    </div>
                                </td>
                                <td>
                                    <input type="text" name="csDBName" id="csDBName" runat="server" maxlength="255" class="NewUIinput" />
                                </td>
                            </tr>
                            <tr id="sql_3">
                                <td>
                                    <dw:TranslateLabel runat="server" Text="User name" />
                                </td>
                                <td>
                                    <input type="text" name="csUserId" id="csUserId" runat="server" maxlength="255" class="NewUIinput" />
                                </td>
                            </tr>
                            <tr id="sql_4">
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Password" />
                                </td>
                                <td>
                                    <input type="text" name="csPassword" id="csPassword" runat="server" maxlength="255" class="NewUIinput" />
                                </td>
                            </tr>
                            <tr id="sql_5">
                                <td></td>
                                <td>
                                    <dw:CheckBox FieldName="csTrusted" ID="csTrusted" runat="server" AttributesParm="onclick='toggleTrusted(this);'" />
                                </td>
                            </tr>
                        </table>
                    </dwc:GroupBox>
                </div>
            </dwc:CardBody>
        </form>
    </dwc:Card>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
