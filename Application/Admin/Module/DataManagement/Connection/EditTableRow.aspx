<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditTableRow.aspx.vb" Inherits="Dynamicweb.Admin.EditTableRow" ValidateRequest="false" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dwa" Namespace="Dynamicweb.Admin" Assembly="Dynamicweb.Admin" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server" />
    <script type="text/javascript">
        var id = "<%=ItemId%>";
        var helpLang = "<%=helpLang %>";

        function save() {
            document.getElementById('Form1').action = "EditTableRow.aspx?ID=" + id + "&CMD=SAVE_TABLEROW&OnSave=Nothing";
            document.getElementById('Form1').submit();
        }

        function saveAndClose() {
            document.getElementById('Form1').action = "EditTableRow.aspx?ID=" + id + "&CMD=SAVE_TABLEROW&OnSave=Close";
            document.getElementById('Form1').submit();
        }

        function cancel() {
            document.getElementById('Form1').action = "EditTableRow.aspx?OnSave=Cancel";
            document.getElementById('Form1').submit();
        }

        function help() {
            window.open('http://manual.net.dynamicweb.dk/Default.aspx?ID=1&m=keywordfinder&keyword=modules.datamanagement.general.connection.edit.row.edit&LanguageID=' + helpLang, 'dw_help_window', 'location=no,directories=no,menubar=no,toolbar=yes,top=0,width=1024,height=' + (screen.availHeight - 100) + ',resizable=yes');
        }
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <form id="Form1" runat="server">
            <dw:RibbonBar ID="Ribbon" runat="server">
                <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="Default">
                    <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Funktioner">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="save();" ID="Save" />
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="saveAndClose();" ID="SaveAndClose" />
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="TimesCircle" OnClientClick="cancel();" ID="Cancel" />
                    </dw:RibbonBarGroup>

                    <dw:RibbonBarGroup ID="RibbonbarGroup2" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="HelpBut" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <dwc:CardBody runat="server">
                <dwc:GroupBox ID="GroupBox2" runat="server" DoTranslation="true" Title="Indstillinger">
                    <dwa:FormGenerator ID="fg1" runat="server"></dwa:FormGenerator>
                </dwc:GroupBox>
            </dwc:CardBody>
        </form>
    </dwc:Card>
</body>
</html>
