<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="ParagraphEdit.aspx.vb" Inherits="Dynamicweb.Admin.ParagraphEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls.OMC" TagPrefix="omc" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" CombineOutput="false">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Content/Items/js/Preset.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
            <dw:GenericResource Url="/Admin/Content/ParagraphEdit.js" />
            <dw:GenericResource Url="/Admin/Content/ParagraphEdit.css" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        var requiredValueWarn = "<%=Translate.JsTranslate("required") %>";
        var paragraphCancelWarnText = "<%=paragraphCancelWarnText %>";
        var paragraphCancelWarn = <%=paragraphCancelWarn.ToString.ToLower %>;
        var synchronizeListConfirmText = "<%= Translate.JsTranslate("Do you want to synchronize list item? Any unsaved changes to this content will be lost!") %>";
        <% If Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "selectpage" Then %>
        dwGlobal.getContentNavigator().expandAncestors(<%= Converter.SerializeCompact(GetPageAncestorsNodeIds()) %>);
        <% End if %>

        $(document).observe('keydown', function (e) {
            if (e.keyCode == 13 && <%=If(Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Context.Current.Request("VisualEditor")), "false", "true") %>) {
                var srcElement = e.srcElement ? e.srcElement : e.target;
                if (srcElement.type != 'textarea') {
                    e.preventDefault();
                    Save();
                }
            }
        });

        function openEditPermissions() {
            if ($F("ID") == "0") {
                alert("<%=paragraphNotSavedText %>");
                return false;
            }

            <%= ShowPermissionsAction() %>
            //dialog.show("ParagraphPermissionDialog", "/Admin/Content/ParagraphPermissionEdit.aspx?ParagraphID=" + document.getElementById("ID").value + "&DialogID=ParagraphPermissionDialog");
        }
        
    </script>
</head>
<body onload="myInit($('ParagraphPageID').value);" class="<%=If(Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Context.Current.Request("VisualEditor")), "", "screen-container")%>">
    <div class="<%=If(Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Context.Current.Request("VisualEditor")), "", "card")%>">
        <span id="_statusPageId" class="card-header-info" style="<%=If(Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Context.Current.Request("VisualEditor")), "display: none;", "")%>">ID: <%=Core.Converter.ToInt32(Dynamicweb.Context.Current.Request("ID"))%></span>

        <form id="ParagraphForm" runat="server" action="ParagraphEdit.aspx" method="post">
            <input type="hidden" runat="server" id="previewUrl" />
            <input type="hidden" runat="server" id="itemParagraphTitle" />
            <input type="hidden" id="changeItemTypeConfirm" value="<%=Translate.JsTranslate("Are you sure that you want to change the Item type? All existing item data will be completely removed and cannot be restored!")%>" />
            <input type="hidden" id="moduleConfirmText" value="<%=Translate.JsTranslate("The attached app may be removed.")%>" />
            <input type="hidden" id="imageSettingsValidationMessage" value='<%= Translate.JsTranslate("Please type the image caption and alt-text.") %>' />

            <div style="min-width: 770px; overflow: hidden;<%=If(Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Context.Current.Request("VisualEditor")), "display: none;", "")%>" id="ribbonContainer">
                <dw:RibbonBar runat="server" ID="myribbon">
                    <dw:RibbonBarTab Active="true" Name="Content" runat="server">
                        <dw:RibbonBarGroup runat="server" ID="toolsGroup" Name="Funktioner" Visible="true">
                            <dw:RibbonBarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Icon="Save" OnClientClick="Save();" ID="Save" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" ID="SaveAndClose" OnClientClick="SaveAndClose();" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" ID="Cancel" OnClientClick="Cancel();" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="RibbonbarGroup2" runat="server" Name="Content">
                            <dw:RibbonBarButton ID="RibbonbarButton1" runat="server" Size="Large" Text="Vis" Icon="PageView" OnClientClick="showPage();">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="groupView" Name="Show" runat="server">
                            <dw:RibbonBarRadioButton ID="cmdViewText" Group="GroupView" Size="Large" Icon="FileTextO" Text="Text" runat="server" OnClientClick="ParagraphView.switchMode(ParagraphView.mode.text);" />
                            <dw:RibbonBarRadioButton ID="cmdViewItem" Group="GroupView" Size="Large" Icon="Cube" Text="Item" runat="server" OnClientClick="ParagraphView.switchMode(ParagraphView.mode.item);" />
                            <dw:RibbonBarRadioButton ID="cmdViewModule" Group="GroupView" Size="Large" Icon="ViewModule" Text="App" DoTranslate="false" runat="server" OnClientClick="ParagraphView.switchMode(ParagraphView.mode.module);" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="groupTemplates" Name="Template" runat="server">
                            <dw:RibbonBarPanel ID="panelTemplates" runat="server">
                                <dw:Richselect ID="ParagraphTemplate" runat="server" Height="80" Itemheight="50" Itemwidth="300" Width="300" Visible="false">
                                </dw:Richselect>
                                <span runat="server" id="MasterParagraphTemplateContainer" visible="false">
                                    <asp:Literal ID="MasterParagraphTemplateMatchIcon" runat="server"></asp:Literal>
                                    <input type="hidden" name="MasterParagraphTemplate" id="MasterParagraphTemplate" runat="server" value="" />
                                </span>
                            </dw:RibbonBarPanel>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="RibbonbarGroup8" runat="server" Name="Sprog" Visible="false">
                            <dw:RibbonBarButton ID="RibbonbarButton2" runat="server" Active="false" ImagePath="/Admin/Images/Flags/flag_dk.png" Disabled="false" Size="Large" Text="Sprog" ContextMenuId="languageSelector">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="PrimaryLanugageSelectorGrp" runat="server" Name="Sprog" Visible="false">
                            <dw:RibbonBarButton ID="languageSelector" runat="server" Active="false" ImagePath="/Admin/Images/Flags/flag_dk.png" Disabled="false" Size="Large" Text="Sprog" ContextMenuId="languageSelectorContext"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" Name="Help">
                            <dw:RibbonBarButton runat="server" Text="Help" Icon="Help" OnClientClick="help();">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>
                    <dw:RibbonBarTab ID="optionsTab" Active="false" Name="Options" runat="server">
                        <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup3" Name="Funktioner" Visible="true">
                            <dw:RibbonBarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Icon="Save" OnClientClick="Save();" ID="RibbonBarButton3" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" ID="cmdOptionsSaveAndClose" OnClientClick="SaveAndClose();" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" ID="cmdOptionsCancel" OnClientClick="Cancel();" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Publication period">
                            <dw:RibbonBarPanel runat="server">
                                <table class="publication-date-picker-table">
                                    <tr>
                                        <td>
                                            <dw:TranslateLabel Text="From" runat="server" />
                                        </td>
                                        <td>
                                            <dw:DateSelector runat="server" EnableViewState="false" ID="ParagraphValidFrom" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dw:TranslateLabel Text="To" runat="server" />
                                        </td>
                                        <td>
                                            <dw:DateSelector runat="server" EnableViewState="false" ID="ParagraphValidTo" />
                                        </td>
                                    </tr>
                                </table>
                            </dw:RibbonBarPanel>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="RibbonbarGroup4" runat="server" Name="Tilgængelighed">
                            <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Hide for phones" Image="Tree" RenderAs="FormControl" ID="ParagraphHideForPhones">
                            </dw:RibbonBarCheckbox>
                            <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Hide for tablets" Image="Tree" RenderAs="FormControl" ID="ParagraphHideForTablets">
                            </dw:RibbonBarCheckbox>
                            <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Hide for desktops" Image="Tree" RenderAs="FormControl" ID="ParagraphHideForDesktops">
                            </dw:RibbonBarCheckbox>
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>
                    <dw:RibbonBarTab ID="advancedTab" Active="false" Name="Advanced" runat="server">
                        <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup5" Name="Funktioner" Visible="true">
                            <dw:RibbonBarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Icon="Save" OnClientClick="Save();" ID="cmdAdvancedSave" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" ID="cmdAdvancedSaveAndClose" OnClientClick="SaveAndClose();" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" ID="cmdAdvancedCancel" OnClientClick="Cancel();" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" ID="settingsGroup1" Name="Settings">
                            <dw:RibbonBarButton runat="server" Text="Permissions" Icon="Lock" ID="PermissionsButton" Size="Small" OnClientClick="openEditPermissions();" />
                            <dw:RibbonBarButton runat="server" ID="Versions" Size="Small" Icon="History" Text="Versions" Visible="false" OnClientClick="ShowVersions();" />
                            <dw:RibbonBarButton runat="server" ID="Layout" Size="Small" Icon="Laptop" Text="Layout" OnClientClick="dialog.show('LayoutDialog');"></dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" ID="ItemTypeButton" Text="Item type" Icon="Cube" Size="Small" OnClientClick="Dynamicweb.Paragraph.ItemEdit.get_current().openItemType();" />
                            <dw:RibbonBarButton runat="server" ID="cmdSaveAsTemplate" Text="Save as template" Icon="File" Size="small" OnClientClick="saveAsTemplate();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" ID="cmdEditTemplateSettings" Size="small" Text="Template settings" Icon="Pencil" OnClientClick="saveAsTemplate();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" ID="GE" Size="Small" Image="InsertGlobalElement" Text="Global element" OnClientClick="ShowGlobals();"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" ID="ribbonGrpMaster" Name="Language management" Visible="false">
                            <dw:RibbonBarCheckbox runat="server" Size="Small" Text="Lock language versions" RenderAs="FormControl" ID="ParagraphMasterType">
                            </dw:RibbonBarCheckbox>
                            <dw:RibbonBarButton ID="languagemgmtInherit" runat="server" Size="Small" Icon="Globe" Text="Languages" Visible="false" OnClientClick="ShowLanguages();">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdCompare" runat="server" Size="Small" Text="Compare" ImagePath="/Admin/Images/Ribbon/Icons/Small/window_split_hor.png" OnClientClick="compareToMaster();" Visible="false"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>

                    <dw:RibbonBarTab ID="tabMarketing" Active="false" Name="Marketing" Visible="true" runat="server">

                        <dw:RibbonBarGroup ID="groupMarketingRestrictions" Name="Personalization" runat="server" ModuleSystemName="Profiling">
                            <dw:RibbonBarButton Text="Personalize" Size="Small" Icon="AccountBox" OnClientClick="ParagraphEdit.openContentRestrictionDialog();" runat="server" />
                            <dw:RibbonBarButton Text="Add profile points" Size="Small" Icon="PersonAdd" OnClientClick="ParagraphEdit.openProfileDynamicsDialog();" runat="server" />
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup ID="groupVariation" Name="Content" runat="server">
                            <dw:RibbonBarPanel ID="VariationPanel" runat="server">
                                <span class="ribbonItem" style="height: 20px; margin-top: 1px; text-align: left;">
                                    <dw:TranslateLabel runat="server" Text="Variation" />
                                    <br />
                                    <select runat="server" id="ParagraphVariation" class="NewUIinput" style="width: 120px;">
                                    </select>
                                </span>
                            </dw:RibbonBarPanel>
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup ID="groupMarketingHelp" Name="Help" runat="server">
                            <dw:RibbonBarButton ID="cmdMarketingHelp" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" runat="server">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>
                </dw:RibbonBar>
            </div>

            <div style="<%=If(Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Context.Current.Request("VisualEditor")), "display: none;", "")%>">
               <dw:PageBreadcrumb ID="breadcrumbControl" runat="server" />
            </div>

            <div id="textContent">
                <dw:GroupBox Title="" runat="server" ID="groupbox1">
                    <table id="formTable" class="formsTable">
                        <%   If Me.Paragraph.IsGlobal Or Me.Paragraph.HasGlobal Then%>
                        <tr>
                            <td colspan="2">
                                <table bgcolor="#FEFEFE" style="border: 1px solid #ABADB3; width: 100%; cursor: pointer;">
                                    <tr>
                                        <td onclick="ShowGlobals();">
                                            <img src="/Admin/Images/Ribbon/icons/Small/warning.png" align="absmiddle" alt="" />&nbsp;<%=Translate.JsTranslate("Global element med %% referencer.", "%%", Me.Paragraph.GlobalCount)%></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%  End If%>
                        <tr>
                            <%-- <td>
                                <div>
                                    <dw:TranslateLabel Text="Afsnitsnavn" runat="server" />
                                    
                                </div>
                            </td>--%>
                            <td colspan="2">
                                <input type="text" name="ParagraphHeader" id="ParagraphHeader" runat="server" enableviewstate="false" maxlength="255" class="NewUIinput" onkeyup="updateBreadCrumb();" title="" />
                                <span runat="server" id="MasterParagraphHeaderContainer" visible="false">
                                    <asp:Literal ID="ParagraphHeaderMatchIcon" runat="server"></asp:Literal>
                                    <input type="hidden" name="MasterParagraphHeader" id="MasterParagraphHeader" runat="server" value="" />
                                </span>
                            </td>
                        </tr>
                        <tr id="MasterParagraphTextContainer" runat="server" visible="false">
                            <td colspan="2">
                                <div>
                                    <dw:TranslateLabel ID="TranslateLabel1" Text="Text" runat="server" />
                                    <asp:Literal ID="ParagraphTextMatchIcon" runat="server"></asp:Literal>
                                    <input type="hidden" name="ParagraphText" id="MasterParagraphText" runat="server" value="" />
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2">
                                <div style="min-width: 250px; min-height: 400px;" id="editorContainer">
                                    <dw:Editor runat="server" ID="ParagraphText" name="ParagraphText" Width="100%" Height="400px" InitFunction="false" WindowsOnLoad="false" GetClientHeight="false" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox Title="Billede" runat="server" ID="groupbox2">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <div>
                                    <dw:TranslateLabel Text="Billede" runat="server" />
                                    <span runat="server" id="MasterParagraphImageContainer" visible="false">
                                        <asp:Literal ID="ParagraphImageMatchIcon" runat="server"></asp:Literal>
                                        <input type="hidden" name="MasterParagraphImage" id="MasterParagraphImage" runat="server" value="" />
                                    </span>
                                </div>
                            </td>
                            <td>
                                <dw:FileManager ID="ParagraphImage" Name="ParagraphImage" runat="server" Extensions="jpg,gif,png,swf,webp" CssClass="NewUIinput" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox runat="server">
                    <table>
                        <tr>
                            <td>
                                <div onclick="javascript:Toggle_UseAltImage(this);" data-checked="true" name="AlternativePictureBox" id="AlternativePictureBox" value="1" id="both">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Plus, True)%>" id="AlternativePictureBoxIcon"></i>
                                    <label for="AlternativePictureBox" class="gbTitle"><%=Translate.Translate("Image settings") %></label>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table id="UseAltImageSection" class="formsTable" style="display: none">
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Link" runat="server" />
                            </td>
                            <td>
                                <dw:LinkManager ID="ParagraphImageURL" runat="server" DisableFileArchive="False" DisableParagraphSelector="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Target" runat="server" />
                            </td>
                            <td>
                                <select id="ParagraphImageTarget" name="ParagraphImageTarget" runat="server" class="std">
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Billedetekst" runat="server" />
                            </td>
                            <td>
                                <input type="text" runat="server" id="ParagraphImageCaption" name="ParagraphImageCaption" maxlength="255" class="NewUIinput" /></td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Alt-tekst" runat="server" />
                            </td>
                            <td>
                                <input type="text" runat="server" id="ParagraphImageMouseOver" name="ParagraphImageMouseOver" maxlength="255" class="NewUIinput" /></td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Skalering" runat="server" />
                            </td>
                            <td>
                                <dw:CheckBox runat="server" FieldName="ParagraphImageResize" ID="ParagraphImageResize" />
                                <label for="ParagraphImageResize">
                                    <dw:TranslateLabel Text="Tilpas billede" runat="server" />
                                </label>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>

                

                <script type="text/javascript">
                    resizeEditor = function(){ 
                        try{ 
                            //var configHeight = CKEDITOR.instances['ParagraphText'].config.height; 
                            var containerHeight = document.getElementById("editorContainer").offsetHeight;
                            CKEDITOR.instances['ParagraphText'].resize(CKEDITOR.instances['ParagraphText'].config.width, containerHeight); 
                        }
                        catch(err){} 
                    }
                </script>
            </div>

            <div id="moduleContent" style="display: none; padding-right: 0; margin-right: 0;">
                <div id="imgProcessing" style="display: block; text-align: center; vertical-align: middle; margin-top: 40px;">
                    <i class="fa fa-refresh fa-spin"></i>
                </div>
                <div id="moduleInnerContent" style="display: none">
                    <iframe id="ParagraphModule__Frame" width="100%" src="" frameborder="0"></iframe>
                </div>
            </div>

            <div id="itemContent" style="display: none;">

                <table cellpadding="1" cellspacing="1" width="100%">
                    <% If IsNothing(TargetItemMeta) OrElse String.IsNullOrEmpty(TargetItemMeta.FieldForTitle) Then%>
                    <tr>
                        <td>
                            <dw:GroupBox ID="itemContentGb" runat="server" Title="Name">
                                <table class="formsTable">
                                    <tr>
                                        <td style="width: 170px;">
                                            <span style="display: block;">
                                                <dw:TranslateLabel ID="TranslateLabel9" Text="Afsnitsnavn" runat="server" />
                                                <span runat="server" id="MasterParagraphHeader2Container" visible="false">
                                                    <asp:Literal ID="ParagraphHeader2MatchIcon" runat="server"></asp:Literal>
                                                    <input type="hidden" name="MasterParagraphHeader2" id="MasterParagraphHeader2" runat="server" value="" />
                                                </span>
                                            </span>
                                        </td>
                                        <td>
                                            <input type="text" id="ParagraphHeader2" name="ParagraphHeader2" runat="server" enableviewstate="false" maxlength="255" class="std NewUIinput" />
                                        </td>
                                    </tr>
                                </table>
                            </dw:GroupBox>
                        </td>
                    </tr>
                    <% End If%>
                    <% If Me.Paragraph.IsGlobal Or Me.Paragraph.HasGlobal Then%>
                    <tr>
                        <td style="padding: 10px">
                            <table width="100%" style="border: 0px;">
                                <tr>
                                    <td colspan="2">
                                        <table bgcolor="#FEFEFE" style="border: 1px solid #ABADB3; width: 100%; cursor: pointer;">
                                            <tr>
                                                <td onclick="ShowGlobals();">
                                                    <img src="/Admin/Images/Ribbon/icons/Small/warning.png" align="absmiddle" alt="" />&nbsp;<%=Translate.JsTranslate("Global element med %% referencer.", "%%", Me.Paragraph.GlobalCount)%></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <% End If%>
                </table>

                <div id="content-item">
                    <asp:Literal ID="litFields" runat="server" />
                </div>
            </div>

            <dwc:ActionBar runat="server" Visible="false">
                <dw:ToolbarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Image="NoImage" OnClientClick="Save();" ID="cmdSave" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500" OnClientClick="SaveAndClose();">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
            </dwc:ActionBar>

            <iframe id="SaveFrame" name="SaveFrame" style="display: none;"></iframe>

            <span id="mSpecifyName" style="display: none">
                <%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>
            </span>

            <span id="mConfirmDelete" style="display: none">
                <dw:TranslateLabel ID="lbConfirmDelete" Text="Fjern modul?" runat="server" />
            </span>

            <dw:Dialog ID="LayoutDialog" runat="server" Title="Layout" ShowOkButton="true">
                <dw:GroupBox ID="GB_Layout" runat="server">
                    <table class="formsTable">
                        <tr id="paragraphIndexRow" runat="server">
                            <td ></td>
                            <td>
                                <dw:CheckBox runat="server" Value="1" ID="ParagraphIndex" FieldName="ParagraphIndex" />
                                <label for="ParagraphIndex">
                                    <dw:TranslateLabel runat="server" Text="Indeks" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Placeholder" />
                            </td>
                            <td>
                                <asp:ListBox runat="server" Rows="1" ID="ParagraphContainer" CssClass="NewUIinput" Width="250" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox Title="Device layouts" runat="server" ID="deviceLayoutsGroupBox" Visible="false">
                    <style>
                         .help-block {
                            text-align:center;
                        }
                         input.item-option-input:checked + label .help-block.info{
                             color:#fff!important;
                         }
                    </style>
                    <table class="formsTable">
                        <tr runat="server" id="ColumnsLargeRow" visible="false">
                            <td>
                                <dw:TranslateLabel Text="Desktop" runat="server" />
                            </td>
                            <td>
                                <div class="list-rows-with-icons max-cols-12" id="ColumnsLargeDiv" runat="server">
                                </div>
                            </td>
                        </tr>
                        <tr runat="server" id="ColumnsMediumRow" visible="false">
                            <td>
                                <dw:TranslateLabel Text="Tablet" runat="server" />
                            </td>
                            <td>
                                <div class="list-rows-with-icons max-cols-12" id="ColumnsMediumDiv" runat="server">
                                    </div>
                            </td>
                        </tr>
                        <tr runat="server" id="ColumnsSmallRow" visible="false">
                            <td>
                                <dw:TranslateLabel Text="Phone" runat="server" />
                            </td>
                            <td>
                                <div class="list-rows-with-icons max-cols-12" id="ColumnsSmallDiv" runat="server">
                                    </div>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ParagraphPermissionDialog" Title="Paragraph permissions" Size="Small" HidePadding="true" ShowCancelButton="true" ShowOkButton="true" OkAction="savePermissions();">
                <iframe id="ParagraphPermissionDialogFrame" runat="server" frameborder="0"></iframe>
            </dw:Dialog>

            <%   If Me.Paragraph.HasGlobal Then%>
            <dw:Dialog ID="GlobalsDialog" runat="server" Title="Global element" HidePadding="true" Width="525">
                <iframe id="GlobalsDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>
            <script type="text/javascript">
                GlobalUrl = 'ParagraphGlobalElements.aspx?ParagraphID=<%=Me.Paragraph.ID %>';
            </script>
            <% End If%>

            <%    If Me.Paragraph.IsMaster Then%>
            <dw:Dialog ID="LanguageDialog" runat="server" Title="Language management" HidePadding="true" Width="525">
                <iframe id="LanguageDialogFrame" src="about:blank" frameborder="0"></iframe>
            </dw:Dialog>
            <script type="text/javascript">
                LanguageUrl = '/Admin/Content/Paragraph/Languages.aspx?ParagraphID=<%=Me.Paragraph.ID %>';
            </script>
            <% End If%>

            <%   If Me.Paragraph.ID > 0 Then%>
            <dw:Dialog ID="VersionsDialog" runat="server" Title="Versioner" HidePadding="true" Width="600">
                <iframe id="VersionsDialogFrame" src="about:blank" frameborder="0"></iframe>
            </dw:Dialog>
            <script type="text/javascript">
                VersionUrl = 'ParagraphVersions.aspx?ParagraphID=<%=Me.Paragraph.ID %>';
            </script>
            <% End If%>

            <dw:Dialog runat="server" ID="ImageSettingsDialog" Title="Indstillinger for billede" ShowOkButton="true" Width="525">
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ChangeItemTypeDialog" Size="Medium" Title="Change item type" ShowOkButton="true" ShowCancelButton="true" CancelAction="Dynamicweb.Paragraph.ItemEdit.get_current().cancelChangeItemType();" OkAction="Dynamicweb.Paragraph.ItemEdit.get_current().changeItemType();">
                <dw:GroupBox ID="GroupBox3" runat="server">
                    <table cellpadding="1" cellspacing="1">
                        <tr>
                            <td>
                                <label>
                                    <dw:TranslateLabel runat="server" Text="Change item type" />
                                </label>
                            </td>
                            <td>
                                <dw:Richselect ID="ItemTypeSelect" runat="server" Height="50" Itemheight="50" Width="300" Itemwidth="300">
                                </dw:Richselect>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="SaveAsTemplateDialog" runat="server" Size="Medium" Title="Save as paragraph template" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" CancelAction="saveAsTemplateCancel();" OkAction="saveAsTemplateOk();">
                <dwc:GroupBox runat="server">
                    <dwc:InputText runat="server" ID="TemplateName" Label="Navn" ValidationMessage="" MaxLength="255" />
                    <dwc:InputText runat="server" ID="TemplateDescription" Label="Beskrivelse" MaxLength="255" />
                    <dw:FileManager runat="server" ID="TemplateImage" Name="TemplateImage"  Label="Image" Extensions="jpg,gif,png,swf,webp" />
                    <dwc:RadioGroup runat="server" ID="TemplateCategoryType" Name="TemplateCategoryType" Label="Categories" Info="" SelectedValue="new" >
                        <dwc:RadioButton runat="server" ID="TemplateCategoryTypeNew" Label="New" FieldValue="new" OnClick="changeCategoryType()" />
                        <dwc:RadioButton runat="server" ID="TemplateCategoryTypeExisting" Label="Existing" FieldValue="existing" OnClick="changeCategoryType()" />
                    </dwc:RadioGroup>
                    <div id="TemplateNewCategoryDiv">
                        <dwc:InputText runat="server" ID="TemplateNewCategory" Label="Category name" ValidationMessage="" MaxLength="255" />
                    </div>
                    <div id="TemplateExistingCategoriesDiv" style="display: none;">
                        <dwc:SelectPicker ID="TemplateCategory" runat="server" Label="Category name"></dwc:SelectPicker>
                    </div>
                </dwc:GroupBox>
            </dw:Dialog>

            <omc:MarketingConfiguration ID="marketConfig" runat="server" />
            <script type="text/javascript">
                ParagraphEdit.Marketing = <%=marketConfig.ClientInstanceName%>;
            </script>

            <dw:ContextMenu ID="languageSelectorContext" runat="server" MaxHeight="400">
            </dw:ContextMenu>

            <input type="hidden" id="ID" name="ID" runat="server" />
            <input type="hidden" id="MasterID" name="MasterID" runat="server" />
            <input type="hidden" id="ParagraphPageID" name="ParagraphPageID" runat="server" />
            <input type="hidden" id="AreaID" name="AreaID" runat="server" />
            <input type="hidden" id="cmd" name="cmd" value="save" />
            <input type="hidden" id="onSave" name="onSave" value="Close" />
            <input type="hidden" id="caller" name="caller" value="" runat="server" />

            <input type="hidden" id="ParagraphModuleSystemName" name="ParagraphModuleSystemName" value="" runat="server" />
            <input type="hidden" id="ParagraphModuleSettings" name="ParagraphModuleSettings" value="" runat="server" />

            <input type="hidden" id="ParagraphTemplateID" name="ParagraphTemplateID" value="" runat="server" />
            <input type="hidden" name="ParagraphSortDirection" id="ParagraphSortDirection" value="<%=Request.QueryString("ParagraphSortDirection")%>" />
            <input type="hidden" name="ParagraphSortID" id="ParagraphSortID" value="<%=Request.QueryString("ParagraphSortID")%>" />

            <dw:Overlay ID="PleaseWait" runat="server" />
        </form>
    </div>
    <div class="card-footer" id="BottomInformationBg" style="<%=If(Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Context.Current.Request("VisualEditor")), "display: none;", "")%>" ">
        <table border="0">
            <tr>
                <td>
                    <div>
                        <dw:TranslateLabel ID="TranslateLabel2" Text="Name" runat="server" />
                        :
                    </div>
                </td>
                <td class="value bold">
                    <div id="footerParagraphHeader"><%=Paragraph.Header%></div>
                </td>
            </tr>

            <%If Not IsNothing(TargetItemMeta) Then%>
            <tr>
                <td>
                    <div>
                        <dw:TranslateLabel ID="TranslateLabel3" Text="Item type" runat="server" />
                        :
                    </div>
                </td>
                <td class="value">
                    <div><%=If(Not IsNothing(TargetItemMeta), TargetItemMeta.Name, "")%></div>
                </td>
            </tr>
            <%End If%>

            <tr>
                <td>
                    <div>
                        <dw:TranslateLabel ID="TranslateLabel4" Text="Created" runat="server" />
                        :
                    </div>
                </td>
                <td class="value">
                    <div id="statusPanelEdited"><%=Paragraph.Audit.CreatedAt.ToString("ddd, dd MMM yyyy HH':'mm", Dynamicweb.Environment.ExecutingContext.GetCulture())%></div>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>
                    <div>
                        <dw:TranslateLabel ID="TranslateLabel10" Text="Template" runat="server" />
                        :
                    </div>
                </td>
                <td class="value">
                    <div id="statusPanelTemplate" class="large"><%=LayoutPath%></div>
                </td>
            </tr>
            <tr>
                <td>
                    <div>
                        <dw:TranslateLabel ID="TranslateLabel5" Text="ID" runat="server" />
                        :
                    </div>
                </td>
                <td class="value">
                    <div><%=Paragraph.ID%></div>
                </td>
            </tr>
            <%If Not IsNothing(TargetItemMeta) Then%>
            <tr>
                <td>
                    <div>
                        <dw:TranslateLabel ID="TranslateLabel7" Text="Item ID" runat="server" />
                        :
                    </div>
                </td>
                <td class="value">
                    <div><%=If(Not IsNothing(TargetItem), TargetItem.Id, "")%></div>
                </td>
            </tr>
            <%End If%>
        </table>
        <table>
            <tr>
                <td>
                    <div>
                        <dw:TranslateLabel ID="TranslateLabel8" Text="Edited" runat="server" />
                        :
                    </div>
                </td>
                <td class="value">
                    <div id="statusPanelUpdated"><%=Paragraph.Audit.LastModifiedAt.ToString("ddd, dd MMM yyyy HH':'mm", Dynamicweb.Environment.ExecutingContext.GetCulture())%></div>
                </td>
                <td colspan="2"></td>
            </tr>
        </table>
    </div>

    <script type="text/javascript">
        function help(){
		<%=Dynamicweb.SystemTools.Gui.HelpPopup("", "page.paragraph.editNEW","dk") %>
        }

        areaID = <%=if(Dynamicweb.Context.Current.Request("AreaID"),"0")%>;
        <%=If(Not String.IsNullOrEmpty(Dynamicweb.Context.Current.Request("ParagraphViewMode")), "ParagraphView.switchMode(" + Dynamicweb.Context.Current.Request("ParagraphViewMode") + ")", "")%>
    </script>

    <%Translate.GetEditOnlineScript()%>
</body>
</html>
