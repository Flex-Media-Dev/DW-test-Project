<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="EditingSetup_cpl.aspx.vb" Inherits="Dynamicweb.Admin.EditingSetup_cpl" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register  Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () {
            page.submit();
        };
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>            
            <li><a href="#">Editing</a></li>
            <li class="active">User Interface</li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Interface settings" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox runat="server" ID="UserInterfacePropertiesGroup" Title="Brugergrænseflade" Visible="false">
                <input type="hidden" value="True" id="/Globalsettings/Settings/ContentEditor/UseNew" name="/Globalsettings/Settings/ContentEditor/UseNew" />
                <dwc:SelectPicker runat="server" ID="DefaultLanguage" Name="/Globalsettings/Modules/LanguagePack/DefaultLanguage" Label= "Default language" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Afsnit">
                <dwc:InputNumber runat="server" ID="MaximumLockingInMinutes" Name="/Globalsettings/Settings/Paragraph/MaximumLockingInMinutes" Label= "Maksimal låsning i minutter" Placeholder="30" />
                <dwc:SelectPicker runat="server" ID="SpacesBeforeParagraph" Name="/Globalsettings/Settings/Paragraph/SpacesBeforeParagraph" Label= "Mellemrum inden afsnit">
                    <asp:ListItem runat="server" Text="0" Value="0" />
                    <asp:ListItem runat="server" Text="1" Value="1" />
                    <asp:ListItem runat="server" Text="2" Value="2" />
                    <asp:ListItem runat="server" Text="3" Value="3" />
                    <asp:ListItem runat="server" Text="4" Value="4" />
                    <asp:ListItem runat="server" Text="5" Value="5" />
                    <asp:ListItem runat="server" Text="6" Value="6" />
                    <asp:ListItem runat="server" Text="7" Value="7" />
                    <asp:ListItem runat="server" Text="8" Value="8" />
                    <asp:ListItem runat="server" Text="9" Value="9" />
                </dwc:SelectPicker>
                <dwc:CheckBox runat="server" ID="RequireAltAndTitle" Name="/Globalsettings/Settings/Paragraph/RequireAltAndTitle" Label= "Require alt and title to be filled out" />
                <dwc:CheckBox runat="server" ID="UseNavigationCancel" Name="/Globalsettings/Settings/ContentEditor/UseNavigationCancel" Label= "Warn when closing paragraph without saving or cancel." />
                <dwc:CheckBox runat="server" ID="DisableStandard" Name="/Globalsettings/Settings/Paragraph/DisableStandard" Label= "Disable standard paragraph" />
                <dwc:CheckBox runat="server" ID="EnableFocalPoints" Name="/Globalsettings/Settings/Paragraph/EnableFocalPoints" Label= "Enable focal points for standard paragraphs" />
                <dwc:RadioGroup runat="server" ID="ParagraphSpaceMode" Name="/Globalsettings/Settings/Paragraph/SpaceMode" Label= "Paragraph space mode">
                    <dwc:RadioButton runat="server" FieldValue="tr" Label="Standard (tr)" />
                    <dwc:RadioButton runat="server" FieldValue="div" Label="Div" />
                    <dwc:RadioButton runat="server" FieldValue="none" Label="Ingen" />
                </dwc:RadioGroup>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Side">
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/Page/Edit/ShowLogoAlt" Label= "Show alt tekst for logo" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/Page/DisableStandard" Label= "Disable standard page" />
                <dwc:RadioGroup runat="server" ID="RadioGroup1" Name="/Globalsettings/Settings/Page/DefaultPagePublishingMode" Label="Default publish mode">
                    <dwc:RadioButton runat="server" FieldValue="Published" Label="Published" />
                    <dwc:RadioButton runat="server" FieldValue="Unpublished" Label="Unpublished" />
                    <dwc:RadioButton runat="server" FieldValue="HideInMenu" Label="Hide in menu" />
                </dwc:RadioGroup>
            </dwc:GroupBox>            
            <dwc:GroupBox runat="server" Title="Editor contexts">
                <dwc:SelectPicker runat="server" ID="EcomDescriptionEditorConfigID" Name="/Globalsettings/Settings/ProviderBasedEditor/EcomDescriptionEditorConfigID" Label= "Use in Ecommerce description" />
                <dwc:SelectPicker runat="server" ID="EcomTeaserEditorConfigID" Name="/Globalsettings/Settings/ProviderBasedEditor/EcomTeaserEditorConfigID" Label= "Use in Ecommerce teaser" />
                <dwc:SelectPicker runat="server" ID="DataProcessingDescriptionEditorConfigID" Name="/Globalsettings/Settings/ProviderBasedEditor/DataProcessingDescriptionEditorConfigID" Label= "Use in Data Processing description" />
            </dwc:GroupBox>
            <% Translate.GetEditOnlineScript() %>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
