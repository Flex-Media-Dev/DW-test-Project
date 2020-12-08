<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent2.Master" Language="vb" AutoEventWireup="false" CodeBehind="EcomAdvConfigLanguage_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigLanguage_Edit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">

    <style type="text/css">
        .hide {
            display:none;
        }
        .fieldsTable {
            border: 0;
            width: 100%;
            border-collapse: collapse;
        }

            .fieldsTable tr td, 
            .fieldsTable tr th {
                padding: 5px 8px;
                border-bottom: #efefef solid 1px;
                text-align: center;
                width: 15%;
            }

            .fieldsTable tr th {
                background-color: #f5f5f5;
            }

            .fieldsTable tr:last-child td {
                border-bottom: 0;
            }

.fieldsTable td:first-child,
.fieldsTable th:first-child {
    text-align: left;
    padding: 0px 0px;
    max-width: 359px;
    width: 359px;
}
    </style>

    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {

            document.getElementById('MainForm').submit();
        }

        page.onHelp = function () {
            <%=Dynamicweb.SystemTools.Gui.help("", "administration.controlpanel.ecom.language") %>
        }

        var tryDisableElement = function (id) {
            var el = $(id);
            if (el) {
                el.disable();
            }
        };

        $(document).observe('dom:loaded', function () {
            tryDisableElement("/Globalsettings/Ecom/ProductLanguageControl/Language/ProductDefaultUnitID");
            tryDisableElement("/Globalsettings/Ecom/Required/CommonFields/ProductDefaultUnitID");
            tryDisableElement("/Globalsettings/Ecom/ReadOnly/CommonFields/ProductDefaultUnitID");
            tryDisableElement("/Globalsettings/Ecom/Hidden/CommonFields/ProductDefaultUnitID");
        });

    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" name="/Globalsettings/Ecom/ProductLanguageControl/ChoicesMade" id="/Globalsettings/Ecom/ProductLanguageControl/ChoicesMade" value="True" />
    <dwc:GroupBox runat="server" Title="Language and variant field differentiation">
        <table class="fieldsTable table">
            <tr>
                <th><%= Translate.Translate("Lock content of fields")%></th>
                <th><%= Translate.Translate("Lock across all languages")%></th>
                <th><%= Translate.Translate("Lock across all variants")%></th>
                <th><%= Translate.Translate("Required fields")%></th>
                <th><%= Translate.Translate("Read only")%></th>
                <th><%= Translate.Translate("Hidden")%></th>
            </tr>
            <%= GetProductField()%>
            <%= GetCustomProductField()%>
        </table>
    </dwc:GroupBox>
    <%= GetProductCategories()%>
    <dwc:GroupBox runat="server" Title="Indstillinger">
        <dwc:CheckBox runat="server" Label="Read only applies admin / administrator" Value="True" Name="/Globalsettings/Ecom/Fields/ApplyReadonlyForAdministrators" ID="ApplyReadonlyForAdministrators" Header="Fields settings" />
        <dwc:CheckBox runat="server" Label="Hidden applies admin / administrator" Value="True" Name="/Globalsettings/Ecom/Fields/ApplyHiddenForAdministrators" ID="ApplyHiddenForAdministrators" />
        <dwc:CheckBox runat="server" Label="Show product ID field for new products" Value="True" Name="/Globalsettings/Ecom/Fields/ShowProductIdFieldForNewProducts" ID="ShowProductIdFieldForNewProducts" />
    </dwc:GroupBox>
    <% Translate.GetEditOnlineScript() %>
</asp:Content>
