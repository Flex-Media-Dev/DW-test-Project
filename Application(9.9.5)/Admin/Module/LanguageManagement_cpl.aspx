<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="LanguageManagement_cpl.aspx.vb" Inherits="Dynamicweb.Admin.LanguageManagement_cpl" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function() {
             document.getElementById('MainForm').submit();
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Header">
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="ContentHeader" Title="Language management" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox runat="server" Title="Language versions">
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/DeactivateParagraphOnNew" Label="Deactivate new paragraphs" Info="When new paragraphs are created on the master, the copy created on the language will be deactivated"  />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/DeactivatePageOnNew" Label="Deactivate new pages"  Info="When new pages are created on the master, the copy created on the language will be deactivated" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/AllowNewParagraphs" Label="Allow paragraph operations (Create, copy, move, delete, sort)" Info="When activated, editors on language versions of the website can create, copy, move, delete and sort paragraphs." />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/AllowGlobalParagraphs" Label="Allow new global paragraphs" Info="When activated, editors on language versions can add global paragraphs to pages" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/AllowNewPages" Label="Allow page operations (Create, copy, move, delete, sort)" Info="When activated, editors on language versions of the website can create, copy, move, delete and sort pages." />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/InheritPageChanges" Label="Copy master changes to language versions if values are the same. (Pages)" Info="When properties on pages in the master are edited, the value will be copied to the language version if the language version has the same value as the master" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/InheritParagraphChanges" Label="Copy master changes to language versions if values are the same. (Paragraph)" Info="When properties on paragraphs in the master are edited, the value will be copied to the language version if the language version has the same value as the master" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/CompareParagraphAsText" Label="Compare paragraphs as text" Info="If activated, when the text of a master is compared to a language version, the formatting is not taken into consideration (i.e. Bold, Italics etc.)" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/UseAreaNamesForDropdowns" Label="Use area name in dropdowns instead of area culture name" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Modules/LanguageManagement/DontCopyPageStateChangesToLangVersion" Label="Make published/unpublished status independent of master" Info="When a master is published, unpublished or hidden, the language versions are not affected, no matter the above settings." />
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>

		
<% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:Content>
