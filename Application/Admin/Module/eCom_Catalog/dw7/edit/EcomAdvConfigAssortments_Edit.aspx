<%@ Page Language="vb" MasterPageFile="/Admin/Content/Management/EntryContent2.Master" AutoEventWireup="false" CodeBehind="EcomAdvConfigAssortments_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigAssortments_Edit" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">

    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        
        page.onSave = function() {

            document.getElementById('MainForm').submit();
        }
        
        page.onHelp = function() {
            <%=Dynamicweb.SystemTools.Gui.help("", "administration.controlpanel.ecom.assortment") %>
        }

    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:GroupBox runat="server" Title="Indstillinger">
        <dwc:CheckBox runat="server" Label="Enable" Value="True" Header="Assortments in frontend" ID="useAssortments" Name="/Globalsettings/Ecom/Assortments/UseAssortments" />
    </dwc:GroupBox>

    <% Translate.GetEditOnlineScript() %>
</asp:Content>
