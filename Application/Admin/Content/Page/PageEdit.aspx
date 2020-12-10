<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="PageEdit.aspx.vb" Inherits="Dynamicweb.Admin.PageEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.Extensibility" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register Assembly="Dynamicweb.Ecommerce" Namespace="Dynamicweb.Ecommerce.Extensibility.Controls" TagPrefix="de" %>
<%@ Register Assembly="Dynamicweb" Namespace="Dynamicweb.Extensibility" TagPrefix="de" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeScriptaculous="true" runat="server" CombineOutput="false">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Content/Page/PageEdit.css" />
            <dw:GenericResource Url="/Admin/Content/Page/PageEdit.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
        </Items>
    </dw:ControlResources>

    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script src="/Admin/Resources/js/layout/Actions.js"></script>
    <%= UrlDataProviderAddin.Jscripts%>

    <% If Converter.ToBoolean(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Navigation/EnableNavigationGroupSorting")) Then  %>
    <style type="text/css">
        .ositem:hover {
            background-color: #EBF7FD;
        }        
    </style>
    <% End If%>

    <script type="text/javascript">
        var NotAllowedURLCharacters = "<%=NotAllowedURLCharacters %>";
    </script>

    <script type="text/javascript">
        var pageNotSavedText = "<%=pageNotSavedText %>";
        var pageHasUnsavedChangesText = '<%=Translate.JsTranslate("The page has not been saved.")%>';
        var remainingText = '<%=Translate.JsTranslate("remaining before recommended maximum")%>';
        var recommendedText = '<%=Translate.JsTranslate("recommended maximum exceeded")%>';
        var sslConfirmation1 = '<%=Translate.JsTranslate("Are you sure you want to change SSL settings from ")%>';
        var sslConfirmation2 = '<%=Translate.JsTranslate(" to ")%>';
        //var groupSorting = 'True' == '<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Navigation/EnableNavigationGroupSorting")%>';    

        function showAssortmentsInfo(list, assortmentProviderName) {
            if (list != null) {
                if (list.selectedIndex > 0 && list.options[list.selectedIndex].text != assortmentProviderName) {
                    showAssortments(false);
                } else {
                    showAssortments(true);
                }
            }
        }
        function showAssortments(show) {
            var infoBar = document.getElementById("InfoBar_infoAssortments");
            if (infoBar != null) {
                if (show) {
                    infoBar.style.display = "";
                } else {
                    infoBar.style.display = "none";
                }
            }
        }

        $(document).observe('keydown', function (e) {
            if (e.keyCode == 13) {
                var srcElement = e.srcElement ? e.srcElement : e.target;
                if (srcElement.type != 'textarea') {
                    e.preventDefault();
                    PageEdit.Save();
                }
            }
            else {
                PageEdit.pageHasUnsavedChanges = true;
            }

        });
        function chkNavProductGroupsOnChange() {
            var checkBox = document.getElementById("chkNavProductGroups");
            if (checkBox != null) {
                checkBox.onchange = function () {
                    var checkBox = document.getElementById("chkNavProductGroups");
                    if (checkBox != null) {
                        setVisibility('divProductGroups', checkBox.checked);
                    }
                }
            }
        }

        function serializePermissions() {
            $("GroupPermissionsIDs").value = SelectionBox.getElementsRightAsArray("GroupPermissions");
        }
    </script>
</head>
<body onload="PageEdit.init(<%=Core.Converter.ToInt32(Dynamicweb.Context.Current.Request("ID"))%>);chkNavProductGroupsOnChange();" class="screen-container">

    <form id="MainForm" name="MainForm" runat="server" action="PageEdit.aspx" method="post" enableviewstate="false">
        <input type="hidden" runat="server" id="previewUrl" />
        <div class="card">
            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab Active="true" Name="Menupunkt" runat="server" ID="MenuBar">
                    <dw:RibbonBarGroup runat="server" ID="toolsGroup" Name="Funktioner" Visible="true">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="PageEdit.Save();" ID="cmdSave" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="PageEdit.SaveAndClose();" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="PageEdit.Cancel();" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup2" runat="server" Name="Side">
                        <dw:RibbonBarButton ID="cmdPreview" runat="server" Size="Large" Text="Vis" Icon="PageView" OnClientClick="PageEdit.showPage();">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup3" runat="server" Name="Tilgængelighed">
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Medtag i menu" Icon="CheckCircle" Hide="true" RenderAs="FormControl" ID="PageActive">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Klikbar" Icon="Times" RenderAs="FormControl" ID="PageAllowclick">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Vis i brødkrummesti" Icon="Book" RenderAs="FormControl" ID="PageShowInLegend">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Vis sidst opdateret" Icon="ClockO" RenderAs="FormControl" ID="PageShowUpdateDate">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Medtag i søgning" Icon="Search" RenderAs="FormControl" ID="PageAllowsearch">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Medtag i sitemap" Icon="Sitemap" RenderAs="FormControl" ID="PageShowInSitemap">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Hide for phones" Icon="Mobile" RenderAs="FormControl" ID="PageHideForPhones">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Hide for tablets" Icon="tablet" RenderAs="FormControl" ID="PageHideForTablets">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Hide for desktops" Icon="Desktop" RenderAs="FormControl" ID="PageHideForDesktops">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarButton ID="cmdRestrictionRules" Visible="false" runat="server" Size="Small" Text="Limit children" Icon="Key" OnClientClick="PageEdit.showRestrictionRules();">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" Name="Side">
                        <dw:RibbonBarRadioButton ID="cmdPublished" runat="server" Checked="false" Group="Publishing" Text="Publiceret" Icon="Check" Value="0" OnClientClick="PageEdit.SetPublish();">
                        </dw:RibbonBarRadioButton>
                        <dw:RibbonBarRadioButton ID="cmdHideInMenu" runat="server" Checked="false" Group="Publishing" Text="Hide in menu" Icon="EyeSlash" Value="2" OnClientClick="PageEdit.SetPublishHide()">
                        </dw:RibbonBarRadioButton>
                        <dw:RibbonBarRadioButton ID="cmdHidden" runat="server" Checked="false" Group="Publishing" Text="Unpublished" Icon="Close" Value="1" OnClientClick="PageEdit.SetUnPublish();">
                        </dw:RibbonBarRadioButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="PrimaryLanugageSelectorGrp" runat="server" Name="Sprog" Visible="false">
                        <dw:RibbonBarButton ID="languageSelector" runat="server" Active="false" ImagePath="/Admin/Images/Flags/flag_dk.png" Disabled="false" Size="Large" Text="Sprog" ContextMenuId="languageSelectorContext">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup4" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButtonHelp1" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
                <dw:RibbonBarTab Active="true" Name="Tilgængelighed" runat="server" ID="MenuBar2">
                    <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup17" Name="Funktioner" Visible="true">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="PageEdit.Save();" ID="RibbonBarButton25" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="PageEdit.SaveAndClose();" ID="RibbonBarButton26" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="PageEdit.Cancel();" ID="RibbonBarButton27" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup19" runat="server" Name="Tilgængelighed">
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Medtag i menu" Icon="CheckCircle" Hide="true" RenderAs="FormControl" ID="PageActive2" OnClientClick="AccessibilityCheckboxClick(this);">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Klikbar" Icon="Times" RenderAs="FormControl" ID="PageAllowclick2" OnClientClick="AccessibilityCheckboxClick(this);">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Vis i brødkrummesti" Icon="Book" RenderAs="FormControl" ID="PageShowInLegend2" OnClientClick="AccessibilityCheckboxClick(this);">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Vis sidst opdateret" Icon="ClockO" RenderAs="FormControl" ID="PageShowUpdateDate2" OnClientClick="AccessibilityCheckboxClick(this);">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Medtag i søgning" Icon="Search" RenderAs="FormControl" ID="PageAllowsearch2" OnClientClick="AccessibilityCheckboxClick(this);">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Medtag i sitemap" Icon="Sitemap" RenderAs="FormControl" ID="PageShowInSitemap2" OnClientClick="AccessibilityCheckboxClick(this);">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Hide for phones" Icon="Mobile" RenderAs="FormControl" ID="PageHideForPhones2" OnClientClick="AccessibilityCheckboxClick(this);">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Hide for tablets" Icon="tablet" RenderAs="FormControl" ID="PageHideForTablets2" OnClientClick="AccessibilityCheckboxClick(this);">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Hide for desktops" Icon="Desktop" RenderAs="FormControl" ID="PageHideForDesktops2" OnClientClick="AccessibilityCheckboxClick(this);">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarButton runat="server" Visible="false" Size="Small" Text="Limit children" Icon="Key" OnClientClick="PageEdit.showRestrictionRules();" ID="cmdRestrictionRules2">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
                <dw:RibbonBarTab ID="RibbonbarTab1" Active="false" Name="Options" runat="server">
                    <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup9" Name="Funktioner" Visible="true">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="PageEdit.Save();" ID="RibbonBarButton1" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="PageEdit.SaveAndClose();" ID="RibbonBarButton2" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="PageEdit.Cancel();" ID="RibbonBarButton3" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup6" runat="server" Name="Composition">
                        <dw:RibbonBarButton ID="NavigationRibbonButton" runat="server" Text="Navigation" Size="Small" Icon="Compass" OnClientClick="dialog.show('NavigationDialog');">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="UrlHandlingRibbonButton" runat="server" Text="URL" Size="Small" Icon="Globe" OnClientClick="dialog.show('UrlHandlingDialog');">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup7" runat="server" Name="Publication period">
                        <dw:RibbonBarPanel ID="RibbonbarPanel1" ExcludeMarginImage="true" runat="server">
                            <table class="publication-date-picker-table">
                                <tr>
                                    <td>
                                        <dw:TranslateLabel Text="From" runat="server" />
                                    </td>
                                    <td>
                                        <dw:DateSelector runat="server" EnableViewState="false" ID="PageActiveFrom" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dw:TranslateLabel Text="To" runat="server" />
                                    </td>
                                    <td>
                                        <dw:DateSelector runat="server" EnableViewState="false" ID="PageActiveTo" />
                                    </td>
                                </tr>
                            </table>
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup8" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButtonHelp2" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
                <dw:RibbonBarTab Active="false" Name="Settings" runat="server" ID="ContentBar2">
                    <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup15" Name="Funktioner" Visible="true">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="PageEdit.Save();" ID="RibbonBarButton11" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="PageEdit.SaveAndClose();" ID="RibbonBarButton12" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="PageEdit.Cancel();" ID="RibbonBarButton13" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup16" runat="server" Name="Indstillinger">
                        <!-- The cache button is hidden, because the page caching functionality has been removed. It might be introduced again later. -->
                        <dw:RibbonBarButton ID="RibbonbarButton15" runat="server" Text="Cache" Icon="Database" Size="Small" OnClientClick="dialog.show('CacheDialog');" Visible="false" />
                        <dw:RibbonBarButton ID="RibbonbarButton16" runat="server" Text="Genvej" Icon="Share" Size="Small" OnClientClick="dialog.show('ShortcutDialog');" />
                        <dw:RibbonBarButton ID="RibbonBarButton17" runat="server" Text="Sikkerhed" Icon="Key" Size="Small"  OnClientClick="dialog.show('SecurityDialog');" />
                        <dw:RibbonBarButton ID="PermissionsButton2" runat="server" Text="Permissions" Icon="Lock"  Size="Small" OnClientClick="openEditPermission('permissions');" />
                        <dw:RibbonBarButton ID="RibbonBarButton19" runat="server" Text="Login template" Icon="AccountBox"  Size="Small" OnClientClick="openEditPermission('template');" />
                        <dw:RibbonBarButton ID="RibbonBarButton20" runat="server" Text="Password" Icon="Key"  Size="Small" OnClientClick="dialog.show('PasswordDialog');" />
                        <dw:RibbonBarButton ID="RibbonbarButton21" runat="server" Text="Sti" Icon="Link"  Size="Small" OnClientClick="dialog.show('UrlStatusDialog');" />
                        <dw:RibbonBarButton ID="RibbonBarButton22" runat="server" Text="Comments"  Icon="Pencil" Size="Small" OnClientClick="comments();" />
                        <dw:RibbonBarButton ID="RibbonBarButton23" runat="server" Text="Item type" Icon="Cube"  Size="Small" OnClientClick="Dynamicweb.Page.ItemEdit.get_current().openItemType();" />
                        <dw:RibbonBarButton ID="RibbonBarButton24" runat="server" Text="Item lists" Icon="Cubes"  Size="Small" OnClientClick="ShowNamedList();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
                <dw:RibbonBarTab Active="false" Name="Advanced" runat="server" ID="ContentBar">
                    <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup11" Name="Funktioner" Visible="true">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="PageEdit.Save();" ID="RibbonBarButton4" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="PageEdit.SaveAndClose();" ID="RibbonBarButton5" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="PageEdit.Cancel();" ID="RibbonBarButton6" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup10" runat="server" Name="Indstillinger">
                        <!-- The cache button is hidden, because the page caching functionality has been removed. It might be introduced again later. -->
                        <dw:RibbonBarButton ID="RibbonbarButtonCache" runat="server" Text="Cache" Icon="Database" Size="Small" OnClientClick="dialog.show('CacheDialog');" Visible="false" />
                        <dw:RibbonBarButton ID="RibbonbarButtonShortcut" runat="server" Text="Genvej" Icon="Share" Size="Small" OnClientClick="dialog.show('ShortcutDialog');" />
                        <dw:RibbonBarButton ID="extranetBtn" runat="server" Text="Sikkerhed" Icon="Key" Size="Small"  OnClientClick="dialog.show('SecurityDialog');" />
                        <dw:RibbonBarButton ID="PermissionsButton" runat="server" Text="Permissions" Icon="Lock"  Size="Small" OnClientClick="openEditPermission('permissions');" />
                        <dw:RibbonBarButton ID="LoginTemplateButton" runat="server" Text="Login template" Icon="AccountBox"  Size="Small" OnClientClick="openEditPermission('template');" />
                        <dw:RibbonBarButton ID="PasswordButton" runat="server" Text="Password" Icon="Key"  Size="Small" OnClientClick="dialog.show('PasswordDialog');" />
                        <dw:RibbonBarButton ID="RibbonbarButtonPath" runat="server" Text="Sti" Icon="Link"  Size="Small" OnClientClick="dialog.show('UrlStatusDialog');" />
                        <dw:RibbonBarButton ID="RibbonBarButtonComments" runat="server" Text="Comments"  Icon="Pencil" Size="Small" OnClientClick="comments();" />
                        <dw:RibbonBarButton ID="ItemTypeButton" runat="server" Text="Item type" Icon="Cube"  Size="Small" OnClientClick="Dynamicweb.Page.ItemEdit.get_current().openItemType();" />
                        <dw:RibbonBarButton ID="cmdViewNamedList" runat="server" Text="Item lists" Icon="Cubes"  Size="Small" OnClientClick="ShowNamedList();" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="SSLRibbonbarGroup" runat="server" Name="Https">
                        <dw:RibbonBarRadioButton ID="cmdSSLStandard" Group="SSLMode" runat="server" Checked="false" Value="0" Text="Standard" Icon="Lock" Size="Small" OnClientClick="changeSSLMode('cmdSSLStandard');">
                        </dw:RibbonBarRadioButton>
                        <dw:RibbonBarRadioButton ID="cmdSSLForce" Group="SSLMode" runat="server" Checked="false" Value="1" Text="Force SSL" Icon="PlusSquare" Size="Small" OnClientClick="changeSSLMode('cmdSSLForce');">
                        </dw:RibbonBarRadioButton>
                        <dw:RibbonBarRadioButton ID="cmdSSLUnforce" Group="SSLMode" runat="server" Checked="false" Value="2" Text="Un-force SSL" Icon="Delete" Size="Small" OnClientClick="changeSSLMode('cmdSSLUnforce');">
                        </dw:RibbonBarRadioButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" Name="Workflow" ID="workflowGroup">
                        <dw:RibbonBarPanel runat="server" ID="versionBtn">
                            <span style="height: 45px; margin-top: 5px;">
                                <%=Dynamicweb.SystemTools.Gui.ApprovalTypeBox(p.ApprovalType, p.ApprovalState, False, True, "PageApprovalType", "")%>
                            </span>
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" ID="ribbonGrpMaster" Name="Language management" Visible="false">
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Lock language versions" RenderAs="FormControl" ID="PageMasterType">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarButton ID="languagemgmtInherit" runat="server" Size="Small" Icon="Globe" Text="Languages" Visible="false" OnClientClick="ShowLanguages();">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup5" runat="server" Name="Display mode">
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="List sub pages" Icon="ViewList" RenderAs="FormControl" ID="PageListSubPages">
                        </dw:RibbonBarCheckbox>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup12" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButtonHelp3" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
                <dw:RibbonBarTab ID="grpLayout" Active="False" Name="Layout" runat="server" Visible="false">
                    <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup13" Name="Funktioner" Visible="true">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="PageEdit.Save();" ID="RibbonBarButton8" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="PageEdit.SaveAndClose();" ID="RibbonBarButton9" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="PageEdit.Cancel();" ID="RibbonBarButton10" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup14" runat="server" Name="Layout">
                        <dw:RibbonBarPanel ID="RibbonbarPanel2" runat="server">
                            <dw:Richselect ID="PageLayout" runat="server" Height="80" Itemheight="60" Width="300" Itemwidth="300">
                            </dw:Richselect>
                            <span runat="server" id="IneritedTemplate"></span>
                        </dw:RibbonBarPanel>
                        <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Inherit to subpages" Icon="Folder" RenderAs="FormControl" ID="PageLayoutApplyToSubPages">
                        </dw:RibbonBarCheckbox>
                        <dw:RibbonBarButton runat="server" ID="RibbonBarButton14" Size="Small" Icon="PlusSquare" Text="Device layouts" OnClientClick="devicelayouts();" />
                        <dw:RibbonBarButton runat="server" ID="RibbonBarButton7" Size="Small" Icon="FileCodeO" Text="Content type" OnClientClick="dialog.show('contentTypeDialogEdit');" />
                    </dw:RibbonBarGroup>
                   
                    <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButtonHelp4" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <dw:PageBreadcrumb ID="breadcrumbControl" runat="server" />
            <dw:Infobar runat="server" ID="noItemTypeInfo" Type="Error" Title="Item type missing">
            </dw:Infobar>

            <dw:GroupBox ID="GB_Page" runat="server" Title="Title" DoTranslation="true">
                <table class="formsTable">
                    <tr>
                        <td>
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Sidenavn" />
                            </div>
                        </td>
                        <td>
                            <input type="text" name="PageMenuText" id="PageMenuText" runat="server" maxlength="255" class="std" onkeyup="PageEdit.updateBreadCrumb();" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>

            <dw:GroupBox ID="GB_Meta" runat="server" Title="Meta" DoTranslation="true">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Titel" />
                        </td>
                        <td>
                            <input type="text" id="PageMetaTitle" name="PageMetaTitle" size="30" class="NewUIinput" runat="server" style="margin-bottom: 1px;" onfocus="ShowCounters(this,'PageDublincoreTitleCounter','PageDublincoreTitleCounterMax');" onkeyup="CheckCounter(this,'PageDublincoreTitleCounter','PageDublincoreTitleCounterMax');" onblur="CheckAndHideCounter(this,'PageDublincoreTitleCounter','PageDublincoreTitleCounterMax');" />
                            <br />
                            <strong id="PageDublincoreTitleCounter" class="char-counter"></strong>
                            <input type="hidden" id="PageDublincoreTitleCounterMax" name="PageDublincoreTitleCounterMax" runat="server" value="55" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Beskrivelse" />
                        </td>
                        <td>
                            <textarea id="PageDescription" name="PageDescription" cols="30" rows="3" class="std" runat="server" onfocus="ShowCounters(this,'PageDescriptionCounter','PageDescriptionCounterMax');" onkeyup="CheckCounter(this,'PageDescriptionCounter','PageDescriptionCounterMax');" onblur="CheckAndHideCounter(this,'PageDescriptionCounter','PageDescriptionCounterMax');"></textarea><br />
                            <strong id="PageDescriptionCounter" class="char-counter"></strong>
                            <input type="hidden" id="PageDescriptionCounterMax" name="PageDescriptionCounterMax" runat="server" value="155" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Nøgleord" />
                        </td>
                        <td>
                            <textarea id="PageKeywords" name="PageKeywords" cols="30" rows="3" class="std" runat="server" onfocus="ShowCounters(this,'PageKeywordsCounter','PageKeywordsCounterMax');" onkeyup="CheckCounter(this,'PageKeywordsCounter','PageKeywordsCounterMax');" onblur="CheckAndHideCounter(this,'PageKeywordsCounter','PageKeywordsCounterMax');"></textarea><br />
                            <strong id="PageKeywordsCounter" class="char-counter"></strong>
                            <input type="hidden" id="PageKeywordsCounterMax" name="PageKeywordsCounterMax" runat="server" value="1000" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2">
                            <dw:CheckBox runat="server" ID="Noindex" FieldName="Noindex" />
                            <label for="Noindex">
                                <dw:TranslateLabel Text="Noindex" runat="server" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2">
                            <dw:CheckBox runat="server" ID="Nofollow" FieldName="Nofollow" />
                            <label for="Nofollow">
                                <dw:TranslateLabel Text="Nofollow" runat="server" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2">
                            <dw:CheckBox runat="server" ID="Robots404" FieldName="Robots404" />
                            <label for="Robots404">
                                <dw:TranslateLabel Text="404 for detected robots" runat="server" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="Canonical page" />
                        </td>
                        <td>
                            <input type="text" name="PageCanonical" id="PageCanonical" runat="server" maxlength="255" class="NewUIinput" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>

            <dw:GroupBox ID="GB_Url" runat="server" Title="Url" DoTranslation="true">
                <table class="formsTable">
                    <tr id="FriendlyUrlRow" runat="server">
                        <td>
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Url" />
                            </div>
                        </td>
                        <td>
                            <div runat="server" id="FriendlyUrl">
                            </div>
                        </td>
                    </tr>
                    <tr id="Tr1" runat="server">
                        <td>
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Use in url" />
                            </div>
                        </td>
                        <td>
                            <input type="text" id="PageUrlName" name="PageUrlName" size="30" maxlength="50" class="NewUIinput" runat="server" />
                        </td>
                    </tr>
                    <tr id="PageUrlIgnoreForChildrenRow" runat="server">
                        <td>
                            <div class="nobr">
                            </div>
                        </td>
                        <td>
                            <dw:CheckBox runat="server" ID="PageUrlIgnoreForChildren" FieldName="PageUrlIgnoreForChildren" />
                            <label for="PageUrlIgnoreForChildren">
                                <dw:TranslateLabel Text="Do not include in subpage URLs" runat="server" />
                            </label>
                        </td>
                    </tr>
                    <tr id="exacturl" runat="server" visible="true">
                        <td>
                            <div class="nobr" valign="top">
                                <dw:TranslateLabel ID="TranslateLabel22" runat="server" Text="Exact URL for this page" />
                            </div>
                        </td>
                        <td>
                            <input type="text" id="PageExactUrl" name="PageExactUrl" size="30" maxlength="255" class="NewUIinput" runat="server" />
                            <small>I.e. pagename.xml or mypath/somepage.php</small>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>

            <div id="content-item">
                <asp:Literal ID="litFields" runat="server" />
            </div>

        </div>

        <div class="card-footer" id="BottomInformationBg" runat="server">
        </div>

        <dw:Dialog runat="server" ID="DeviceLayoutDialog" Title="Device layouts" ShowOkButton="true">
            <dw:GroupBox ID="GroupBox2" runat="server" Title="Templates">
                <table cellpadding="1" cellspacing="1">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel19" runat="server" Text="Phone" />
                        </td>
                        <td>
                            <asp:ListBox runat="server" Rows="1" ID="PageLayoutPhone" CssClass="NewUIinput" Width="250" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel20" runat="server" Text="Tablet" />
                        </td>
                        <td>
                            <asp:ListBox runat="server" Rows="1" ID="PageLayoutTablet" CssClass="NewUIinput" Width="250" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </dw:Dialog>

        <dw:Dialog ID="dlgResponsible" runat="server" Title="Ansvarlig" ShowOkButton="true" Visible="false">
            <dw:GroupBox ID="GroupBox1" runat="server" Title="Ansvarlig" DoTranslation="true">
                <table cellpadding="2" cellspacing="2">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel131" runat="server" Text="Ansvarlig" />
                        </td>
                        <td>
                            <%'=Dynamicweb.SystemTools.Gui.UserList("PageManager", p.Manager)%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel141" runat="server" Text="Opdater" />
                        </td>
                        <td>
                            <select class="std" name="PageManageFrequence">
                                <option value="0">
                                    <%=Translate.Translate("Intet valgt")%>
                                </option>
                                <option value="1" <%=If(p.ManageFrequence = "1", "selected", "")%>>
                                    <%=Translate.Translate("Hver dag")%>
                                </option>
                                <option value="2" <%=If(p.ManageFrequence = "2", "selected", "")%>>
                                    <%=Translate.Translate("Hver 2. dag")%>
                                </option>
                                <option value="14" <%=If(p.ManageFrequence = "14", "selected", "")%>>
                                    <%=Translate.Translate("Hver 14. dag")%>
                                </option>
                                <option value="30" <%=If(p.ManageFrequence = "30", "selected", "")%>>
                                    <%=Translate.Translate("Hver måned")%>
                                </option>
                                <option value="60" <%=If(p.ManageFrequence = "60", "selected", "")%>>
                                    <%=Translate.Translate("Hver 2. måned")%>
                                </option>
                                <option value="90" <%=If(p.ManageFrequence = "90", "selected", "")%>>
                                    <%=Translate.Translate("Hver 3. måned")%>
                                </option>
                                <option value="180" <%=If(p.ManageFrequence = "180", "selected", "")%>>
                                    <%=Translate.Translate("Hver 6. måned")%>
                                </option>
                                <option value="360" <%=If(p.ManageFrequence = "360", "selected", "")%>>
                                    <%=Translate.Translate("Hvert år")%>
                                </option>
                            </select>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </dw:Dialog>
        <dw:Dialog ID="UrlStatusDialog" runat="server" Title="Sti" ShowOkButton="true">
            <dw:GroupBox ID="GB_UrlStatus" runat="server">
                <table cellpadding="1" cellspacing="1">
                    <tr>
                        <td>
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Direct path" />
                            </div>
                        </td>
                        <td>
                            <input type="hidden" runat="server" id="UrlPathID" name="UrlPathID" />
                            <input type="text" runat="server" id="UrlPath" name="UrlPath" maxlength="255" class="NewUIinput" />
                            <a href="" id="UrlPathTestLink" runat="server" target="_blank" visible="false">
                                <img src="/Admin/Images/Ribbon/Icons/Small/link.png" border="0" align="absmiddle" alt="<%=Dynamicweb.SystemTools.Translate.Translate("Test") %>" /></a>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Status" />
                            </div>
                        </td>
                        <td>
                            <dw:RadioButton runat="server" ID="UrlPathStatus200" FieldName="UrlPathStatus" FieldValue="200" />
                            <label for="UrlPathStatus200">
                                <dw:TranslateLabel ID="TranslateLabel9" Text="Behold sti (200 OK)" runat="server" />
                            </label>
                            <br />
                            <dw:RadioButton runat="server" ID="UrlPathStatus301" FieldName="UrlPathStatus" FieldValue="301" SelectedFieldValue="301" />
                            <label for="UrlPathStatus301">
                                <dw:TranslateLabel ID="TranslateLabel10" Text="Vidersend til link (301 Moved Permanently)" runat="server" />
                            </label>
                            <br />
                            <dw:RadioButton runat="server" ID="UrlPathStatus302" FieldName="UrlPathStatus" FieldValue="302" />
                            <label for="UrlPathStatus302">
                                <dw:TranslateLabel ID="TranslateLabel113" Text="Vidersend til link (302 Moved Temporarily)" runat="server" />
                            </label>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </dw:Dialog>

        <%   If Me.p.IsMaster Then%>
        <dw:Dialog ID="LanguageDialog" runat="server" Title="Language management" HidePadding="true">
            <iframe id="LanguageDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <script type="text/javascript">
            LanguageUrl = '/Admin/Content/Page/Languages.aspx?PageID=<%=Me.p.ID %>';
        </script>

        <% End If%>

        <dw:Dialog ID="NavigationDialog" runat="server" Size="Medium" Title="Navigation" ShowOkButton="true">
            <dw:GroupBox Title="Navigation" runat="server">
                <table class="formsTable">
                    <tr>
                        <td>
                            <label class="group-header">
                                <dw:TranslateLabel ID="TranslateLabel11" Text="Navigation tag" runat="server" />
                            </label>
                        </td>
                        <td>
                            <input type="text" runat="server" id="PageNavigationTag" name="PageNavigationTag" maxlength="255" class="NewUIinput" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
            <asp:Panel ID="eComNavContainer" runat="server">
                <br />
                <dw:GroupBox ID="gbProductGroups" Title="Ecommerce" DoTranslation="false" runat="server">
                    <dwc:CheckBox ID="chkNavProductGroups" Header="Ecommerce navigation" runat="server" Label="Enable" />

                    <div id="divProductGroups" runat="server">
                        <table>
                            <tr>
                                <td>
                                    <!-- Parent selector -->
                                    <table class="formsTable">
                                        <tr id="NavigationProviderListRow" runat="server">
                                            <td>
                                                <label class="group-header">
                                                    <dw:TranslateLabel ID="TranslateLabel25" Text="Navigation provider" runat="server" />
                                                </label>
                                            </td>
                                            <td>
                                                <asp:DropDownList runat="server" ID="NavigationProviderList" CssClass="std" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label class="group-header">
                                                    <dw:TranslateLabel ID="lbGroupParent" Text="Group parent" runat="server" />
                                                </label>
                                            </td>
                                            <td>
                                                <dwc:RadioButton ID="rbGroups" Name="NavigationProductGroupParent" runat="server" Label="Groups" FieldValue="Groups" />
                                                <dwc:RadioButton ID="rbShop" Name="NavigationProductGroupParent" runat="server" Label="Shop" FieldValue="Shop" />
                                                <div class="form-group">
                                                    <dw:Infobar ID="infoAssortments" ClientIDMode="Static" Type="Information" Message="Assortments are enabled" UseInlineStyles="false" runat="server" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- Group selector -->
                                    <div id="divGroupsSelector" runat="server">
                                        <table>
                                            <tr>
                                                <td colspan="2">
                                                    <de:ProductsAndGroupsSelector runat="server" OnlyGroups="true" ID="NavigationGroupSelector" ShowLabelsOnTheLeft="True" ShopSelectorLabel="In shop" GroupSelectorLabel="Selected groups" RadioButtonsSelectorLabel="Groups" CallerForm="MainForm" Width="404px" Height="100px" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <!-- Shop selector -->
                                    <div id="divShopSelector" runat="server">
                                        <table cellpadding="2" cellspacing="0">
                                            <tr>
                                                <td style="width: 170px" valign="top">
                                                    <dw:TranslateLabel ID="lbShopSelector" Text="Shop" runat="server" />
                                                </td>
                                                <td>
                                                    <de:ShopDropDown ID="NavigationShopSelector" runat="server" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>

                                    <dwc:CheckBox ID="chkIncludeProducts" Header="Include products" runat="server" />

                                    <!-- Max level selector, Productpage selector -->
                                    <table cellpadding="2" cellspacing="0">
                                        <tr>
                                            <td style="width: 170px" valign="top">
                                                <dw:TranslateLabel ID="lbMaxLevelsSelector" Text="Max levels" runat="server" />
                                            </td>
                                            <td>
                                                <select id="ddMaxLevels" runat="server" class="std" style="width: 140px;">
                                                    <option label="1" value="1" />
                                                    <option label="2" value="2" />
                                                    <option label="3" value="3" />
                                                    <option label="4" value="4" />
                                                    <option label="5" value="5" />
                                                    <option label="6" value="6" />
                                                    <option label="7" value="7" />
                                                    <option label="8" value="8" />
                                                    <option label="9" value="9" />
                                                    <option label="10" value="10" />
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 170px" valign="top">
                                                <dw:TranslateLabel ID="lbProductpageSelector" Text="Product page" runat="server" />
                                            </td>
                                            <td>
                                                <asp:Literal ID="litProductPage" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </dw:GroupBox>
            </asp:Panel>
        </dw:Dialog>

        <dw:Dialog ID="UrlHandlingDialog" runat="server" Size="Medium" Title="URL" ShowOkButton="true">
            <de:AddInSelector
                runat="server"
                ID="UrlDataProviderAddin"
                AddInShowNothingSelected="true"
                AddInGroupName="Provider"
                AddInTypeName="Dynamicweb.Frontend.UrlHandling.UrlDataProvider" />
            <%= UrlDataProviderAddin.LoadParameters %>
        </dw:Dialog>

        <dw:Dialog ID="CacheDialog" runat="server" Title="Cache" ShowOkButton="true">
            <dw:GroupBox ID="GB_Cache" runat="server">
                <table cellpadding="1" cellspacing="1">
                    <tr>
                        <td valign="top">
                            <dw:TranslateLabel runat="server" Text="Type" />
                        </td>
                        <td>
                            <dw:RadioButton runat="server" ID="PageCacheMode1" FieldName="PageCacheMode" FieldValue="1" />
                            <label for="PageCacheMode1">
                                <dw:TranslateLabel runat="server" Text="Ingen" />
                            </label>
                            <br />
                            <dw:RadioButton runat="server" ID="PageCacheMode2" FieldName="PageCacheMode" FieldValue="2" />
                            <label for="PageCacheMode2">
                                <dw:TranslateLabel runat="server" Text="Standard" />
                            </label>
                            <br />
                            <dw:RadioButton runat="server" ID="PageCacheMode3" FieldName="PageCacheMode" FieldValue="3" />
                            <label for="PageCacheMode3">
                                <dw:TranslateLabel runat="server" Text="Hele siden" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Gyldig" />
                        </td>
                        <td>
                            <%=CacheFrequence(p.CacheFrequence, "PageCacheFrequence")%>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </dw:Dialog>
        <dw:Dialog ID="PasswordDialog" runat="server" Title="Password" ShowOkButton="true">
            <table>
                <tr style="height: 25px;">
                    <td>
                        <dw:CheckBox runat="server" Value="1" ID="PageProtect" AttributesParm="onclick='showOrHide(this);'" />
                        <label for="PageProtect">
                            <dw:TranslateLabel ID="TranslateLabel112" runat="server" Text="Kodeordsbeskyttelse" />
                        </label>
                    </td>
                    <td></td>
                </tr>
                <tr style="height: 25px;" id="pwd" runat="server">
                    <td>
                        <dw:TranslateLabel ID="TranslateLabel122" runat="server" Text="Kodeord" />
                    </td>
                    <td>
                        <input type="text" runat="server" id="PagePassword" name="PagePassword" size="30" maxlength="255" value="" style="width: 120px;" class="NewUIinput" />
                    </td>
                </tr>
            </table>
        </dw:Dialog>
        <dw:Dialog ID="SecurityDialog" runat="server" Title="Sikkerhed" ShowOkButton="true" Size="Medium">
            <dwc:GroupBox runat="server" Title="Rettigheder">
                <dw:SelectionBox ID="GroupPermissions" RightHeader="Selected groups" LeftHeader="All groups" Label="Allowed groups" NoDataTextLeft="No groups" NoDataTextRight="No groups"
                    TranslateNoDataText="true" TranslateHeaders="true" Width="180" ContentChanged="serializePermissions();" runat="server">
                </dw:SelectionBox>
                <input type="hidden" value="GroupPermissionsIDs" name="" id="GroupPermissionsIDs" runat="server" />
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Login">
                <table>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Vis i menu" />
                        </td>
                        <td>
                            <dw:RadioButton runat="server" ID="PagePermissionType2" FieldName="PagePermissionType" FieldValue="2" />
                            <label for="PagePermissionType2">
                                <dw:TranslateLabel runat="server" Text="Kun for brugere med adgang" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:RadioButton runat="server" ID="PagePermissionType1" FieldName="PagePermissionType" FieldValue="1" />
                            <label for="PagePermissionType1">
                                <dw:TranslateLabel runat="server" Text="For alle brugere" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Template" />
                        </td>
                        <td>
                            <dw:FileManager ID="PagePermissionTemplate" runat="server" Folder="Templates/Extranet" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </dw:Dialog>
        <dw:Dialog ID="ShortcutDialog" runat="server" Title="Genvej" ShowOkButton="true">
            <dw:GroupBox ID="GB_Shortcut" runat="server">
                <table>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Genvej" />
                        </td>
                        <td>
                            <dw:LinkManager ID="PageShortCut" runat="server" DisableFileArchive="False" DisableParagraphSelector="True" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" Value="1" ID="PageShortCutRedirect" FieldName="PageShortCutRedirect" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="PagePermissionDialog" Title="Page permissions" HidePadding="true" ShowOkButton="true" Size="Medium" ShowCancelButton="true" OkAction="savePermission();">
            <iframe id="PagePermissionDialogFrame"></iframe>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="contentTypeDialogEdit" Title="Content type">
            <dw:GroupBox runat="server">
                <table>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Content type" />
                        </td>
                        <td>
                            <div class="input-group" style="width: 281px;">
                                <div class="form-group-input">
                                    <select id="PageContentType" class="std form-control" runat="server"></select>
                                </div>
                                <span class="input-group-addon" title="Add" onclick="PageEdit.openContentTypeDialog();">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Plus)%>"></i>
                                </span>
                            </div>

                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </dw:Dialog>

        <dw:Dialog ID="CommentsDialog" runat="server" Title="Comments" HidePadding="true">
            <iframe id="CommentsDialogFrame"></iframe>
        </dw:Dialog>

        <div class="page-content-type">
            <dw:Dialog ID="ContentTypeDialog" ShowOkButton="True" ShowCancelButton="True" ShowClose="True" Title="Input new content type" OkAction="PageEdit.addContentType();" runat="server">
                <input type="text" class="std page-content-type" />
            </dw:Dialog>
        </div>

        <dw:Dialog ID="dlgEditRestrictionRules" Title="Edit restrictions" OkAction="PageEdit.hideRestrictionRules();" ShowOkButton="true" ShowCancelButton="false" ShowClose="true" runat="server">
            <div class="restrictions-container">
                <dw:GroupBox ID="gbRestrictionRules" Title="Children restrictions" runat="server"></dw:GroupBox>
            </div>
            <div class="separator-10">&nbsp;</div>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="ChangeItemTypeDialog" Title="Change item type" ShowOkButton="true" ShowCancelButton="true" CancelAction="Dynamicweb.Page.ItemEdit.get_current().cancelChangeItemType();" OkAction="Dynamicweb.Page.ItemEdit.get_current().changeItemType();">
            <dw:GroupBox ID="GroupBox3" runat="server">
                <dw:Richselect ID="ItemTypeSelect" runat="server" Height="60" Itemheight="60" Width="300" Itemwidth="300">
                </dw:Richselect>
            </dw:GroupBox>
        </dw:Dialog>

        <dw:ContextMenu ID="languageSelectorContext" runat="server" MaxHeight="400">
        </dw:ContextMenu>
        <iframe id="SaveFrame" name="SaveFrame" style="display: none;"></iframe>
        <input type="hidden" id="ID" name="ID" runat="server" />
        <input type="hidden" id="AreaID" name="AreaID" runat="server" />
        <input type="hidden" id="ParentPageID" name="ParentPageID" runat="server" />
        <input type="hidden" id="cmd" name="cmd" value="save" />
        <input type="hidden" id="onSave" name="onSave" value="Close" />
    </form>

    <span id="NoNameText" style="display: none">
        <%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%></span>

    <script type="text/javascript">

        function help() {
		<%=Dynamicweb.SystemTools.Gui.Help("", "page.editNEW") %>
        }
        var useSSLOption = '<%=p.SSLMode%>';
    </script>

    <%Translate.GetEditOnlineScript()%>
</body>
</html>
