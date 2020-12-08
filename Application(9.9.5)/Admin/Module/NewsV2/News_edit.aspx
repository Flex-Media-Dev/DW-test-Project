<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="News_edit.aspx.vb"
    Inherits="Dynamicweb.Admin.NewsV2.News_edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Configuration" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls.OMC" TagPrefix="omc" %>
<%@ Register TagPrefix="cust" Namespace="Dynamicweb.Admin.ModulesCommon" Assembly="Dynamicweb.Admin" %>

<%@ Register Src="/Admin/Module/NewsV2/ComboRepeater.ascx" TagName="ComboRepeater"
    TagPrefix="cc" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>News_edit</title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>

    <script language="javascript" type="text/javascript" src="js/main.js"></script>
    <script language="javascript" type="text/javascript" src="js/news.js"></script>
    <script language="javascript" type="text/javascript" src="js/newsedit.js"></script>
    
</head>
<body class="area-deeppurple screen-container">
    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("newsv2", "modules.newsv2.general.news.edit")%>
              }
        var newsID = <%=Dynamicweb.Context.Current.Request("id") %>;        
    </script>

    <form id="TheForm" runat="server" class="formNews">
  <div style="min-width: 500px; overflow: hidden;">
        <input type="hidden" id="NewsTemplateID" name="NewsTemplateID" value="" />
        <dw:RibbonBar ID="NewsBar" runat="server">
            <dw:RibbonBarTab ID="RibbonGeneralTab" Name="Content" runat="server" Visible="true">
                <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                    <dw:RibbonBarButton ID="btnSaveNews" Text="Save" Title="Save" Icon="Save" Size="Small"
                        runat="server" EnableServerClick="true" OnClick="News_Save" />
                    <dw:RibbonBarButton ID="btnSaveAndCloseNews" Text="Save and close" Icon="Save"
                        Size="Small" runat="server" EnableServerClick="true" OnClick="News_SaveAndClose" />
                    <dw:RibbonBarButton ID="btnCancel" Text="Close" Icon="TimesCircle" Size="Small" runat="server"
                        EnableServerClick="true" PerformValidation="false" OnClick="Cancel_Click" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup5" Name="Information" runat="server">
                    <dw:RibbonBarRadioButton ID="DetailsRibbon" Text="Details" OnClientClick="ribbonTab(1);"
                        Checked="true" Group="newsGroup" Icon="File" Size="Small" runat="server" />
                    <dw:RibbonBarRadioButton ID="CategoriesRibbon" Text="Categories" OnClientClick="ribbonTab(3);"
                        Group="newsGroup" Icon="Folder" Size="Small" runat="server" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup2" Name="Content" runat="server">
                    <dw:RibbonBarButton ID="RibbonBarButton2" Text="Author" Title="Author" OnClientClick="openAuthorDialog();"
                        Icon="Edit" Size="Small" runat="server" />
					<dw:RibbonBarButton ID="commentBtn" Text="Comments" Icon="ModeComment" Size="Small" runat="server" OnClientClick="comments(newsID);" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup10" Name="Help" runat="server">
                    <dw:RibbonBarButton ID="Help" Text="Help" Title="Help" Icon="Help" Size="Large"
                        runat="server" OnClientClick="help();" />
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
            <dw:RibbonBarTab ID="RibbonBarTab1" Name="Options" runat="server" Visible="true">
                <dw:RibbonBarGroup ID="RibbonBarGroup7" Name="Tools" runat="server">
                    <dw:RibbonBarButton ID="btnSaveNews1" Text="Save" Title="Save" Icon="Save" Size="Small"
                        runat="server" EnableServerClick="true" OnClick="News_Save" />
                    <dw:RibbonBarButton ID="btnSaveAndCloseNews1" Text="Save and close" Icon="Save"
                        Size="Small" runat="server" EnableServerClick="true" OnClick="News_SaveAndClose" />
                    <dw:RibbonBarButton ID="RibbonBarButton9" Text="Close" Icon="TimesCircle" Size="Small"
                        runat="server" EnableServerClick="true" PerformValidation="false" OnClick="Cancel_Click" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup8" Name="General" runat="server">
                    <dw:RibbonBarCheckbox ID="NewsActive" Text="Active" Checked="true" Size="Small" runat="server"
                        Icon="Check" />
                    <dw:RibbonBarCheckbox ID="NewsArchive" Text="Archive" Size="Small" runat="server"
                        Icon="Archive" />
                    <dw:RibbonBarCheckbox ID="NewsOpenNewWindow" Text="Open in new window" Size="Small"
                        runat="server" Icon="OpenInNew" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonbarGroup9" runat="server" Name="Publication period">
                    <dw:RibbonBarPanel ID="Ribbonbarpanel1" runat="server">                        
                        <table class="publication-date-picker-table">
                            <tr>
                                <td>
                                    <dw:TranslateLabel Text="From" runat="server" />
                                </td>
                                <td>
                                    <dw:DateSelector runat="server" EnableViewState="false" ID="NewsValidFrom" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dw:TranslateLabel Text="To" runat="server" />
                                </td>
                                <td>
                                    <dw:DateSelector runat="server" EnableViewState="false" ID="NewsValidUntil" />
                                </td>
                            </tr>
                        </table>
                    </dw:RibbonBarPanel>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup11" Name="Help" runat="server">
                    <dw:RibbonBarButton ID="RibbonBarButton1" Text="Help" Title="Help" Icon="Help" Size="Large"
                        runat="server" OnClientClick="help();" />
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
            <dw:RibbonBarTab ID="NewsLetterIntegration" Name="Newsletter" runat="server" Visible="true">
                <dw:RibbonBarGroup ID="RibbonBarGroup6" Name="Tools" runat="server">
                    <dw:RibbonBarButton ID="btnSaveNews2" Text="Save" Title="Save" Icon="Save" Size="Small"
                        runat="server" EnableServerClick="true" OnClick="News_Save" />
                    <dw:RibbonBarButton ID="btnSaveAndCloseNews2" Text="Save and close" Icon="Save"
                        Size="Small" runat="server" EnableServerClick="true" OnClick="News_SaveAndClose" />
                    <dw:RibbonBarButton ID="RibbonBarButton6" Text="Close" Icon="TimesCircle" Size="Small"
                        runat="server" EnableServerClick="true" PerformValidation="false" OnClick="Cancel_Click" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup3" Name="Integration" runat="server">
                    <dw:RibbonBarCheckbox ID="NewsContentSubscription" Text="Content subscription" Size="Small"
                        runat="server" Icon="EnvelopeO" />
                    <dw:RibbonBarCheckbox ID="NewsManualProcess" Text="Manual process" Size="Small" runat="server"
                        Icon="EnvelopeO" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup12" Name="Help" runat="server">
                    <dw:RibbonBarButton ID="RibbonBarButton3" Text="Help" Title="Help" Icon="Help" Size="Large"
                        runat="server" OnClientClick="help();" />
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>

            <dw:RibbonBarTab ID="tabMarketing" Active="false" Name="Marketing" Visible="true" runat="server">
                <dw:RibbonbarGroup ID="groupMarketingSave" Name="Tools" runat="server">
					 <dw:RibbonBarButton ID="cmdMarketingSave" Text="Save" Title="Save" Icon="Save" Size="Small" runat="server" EnableServerClick="true" OnClick="News_Save" />
                    <dw:RibbonBarButton ID="cmdMarketingSaveAndClose" Text="Save and close" Icon="Save" Size="Small" runat="server" EnableServerClick="true" OnClick="News_SaveAndClose" />
                    <dw:RibbonBarButton ID="cmdMarketingCancel" Text="Close" Icon="TimesCircle" Size="Small" runat="server" EnableServerClick="true" PerformValidation="false" OnClick="Cancel_Click" />
                </dw:RibbonbarGroup>
                <dw:RibbonBarGroup ID="groupMarketingRestrictions" Name="Personalization" runat="server">
                    <dw:RibbonbarButton runat="server" ID="cmdMarketingPersonalize" Text="Personalize" Size="Small" Icon="AccountBox" />
                    <dw:RibbonbarButton ID="cmdMarketingProfileDynamics" Text="Add profile points" Size="Small" Icon="PersonAdd" runat="server" />
                </dw:RibbonBarGroup>
                <dw:RibbonbarGroup ID="groupMarketingHelp" Name="Help" runat="server">
					<dw:RibbonbarButton ID="cmdMarketingHelp" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" runat="server">
					</dw:RibbonbarButton>
				</dw:RibbonbarGroup>
            </dw:RibbonBarTab>

        </dw:RibbonBar>
        <div class="list">
            <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="title">
                        <%=GetBreadcrumb() %>
                    </td>
                </tr>
            </table>
        </div>
        <dw:Dialog ID="AuthorDialog" runat="server" Title="Author" ShowClose="true" Width="400"
            ShowOkButton="true">
            <table border="0" cellpadding="2" cellspacing="2">
                <tr>
                    <td class="leftCol">
                        <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Author" />
                    </td>
                    <td>
                        <asp:TextBox ID="NewsAuthor" runat="server" CssClass="std" MaxLength="255"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="leftCol">
                        <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Initials" />
                    </td>
                    <td>
                        <asp:TextBox ID="NewsInitials" runat="server" CssClass="std" MaxLength="255"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </dw:Dialog>
        <dw:StretchedContainer ID="ProductEditScroll" Stretch="Fill" Scroll="Auto" Anchor="document"
            runat="server">
            <div id="containerNews1">
                <div id="Tab1">
                    <dw:GroupBoxStart runat="server" ID="SettingsStart" doTranslation="true" Title="Settings"
                        ToolTip="Settings" />
                    <table border="0" cellpadding="2" cellspacing="0" width="100%">
                        <asp:Panel ID="ToCategoryPanel" runat="server" Height="50px" Width="125px">
                            <tr>
                                <td class="leftCol">
                                    <dw:TranslateLabel runat="server" Text="To category" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="ToCategoryDD" runat="server" AutoPostBack="true" CausesValidation="false">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                </td>
                            </tr>
                        </asp:Panel>
                        <tr>
                            <td class="leftCol">
                                <dw:TranslateLabel runat="server" Text="Date" />
                            </td>
                            <td>
                                <dw:DateSelector ID="NewsDate" runat="server" SetNeverExpire="true" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftCol">
                                <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Heading" />
                            </td>
                            <td>
                                <asp:TextBox ID="NewsHeading" runat="server" CssClass="std" MaxLength="255"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="requred"
                                    ControlToValidate="NewsHeading"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftColHigh">
                                <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Teaser text" />
                            </td>
                            <td>
                                <asp:TextBox ID="NewsTeaser" Rows="5" runat="server" CssClass="std" TextMode="MultiLine"
                                    MaxLength="255"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftCol">
                                <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Shortcut" />
                            </td>
                            <td>
                                <%=Gui.LinkManager(NewsShortcut, "NewsShortcut", "")%>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                    <dw:GroupBoxEnd runat="server" ID="SettingsEnd" />
                    <dw:GroupBoxStart runat="server" ID="GroupBoxStart1" doTranslation="true" Title="Text"
                        ToolTip="Text" />
                    <%=Gui.Editor("HtmlEditor", Converter.ToInt32(SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/TextEditor/EditorWidth")), Converter.ToInt32(SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/TextEditor/EditorHeight")), HtmlText, "", Nothing, "", "", Gui.EditorEdition.ForceNew)%>
                    <dw:GroupBoxEnd runat="server" ID="GroupBoxEnd1" />
                    <dw:GroupBoxStart runat="server" ID="GroupBoxStart2" doTranslation="true" Title="Layout"
                        ToolTip="Layout" />
                    <table border="0" cellpadding="2" cellspacing="0" class="formsTable">
                        <tr>
                            <td class="leftCol ">
                                <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Overview image" />
                            </td>
                            <td>
                                <%= Gui.FileManager(NewsOverviewImage, Dynamicweb.Content.Files.FilesAndFolders.GetImagesFolderName(), "NewsOverviewImage")%>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftCol">
                                <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Image" />
                            </td>
                            <td>
                                <%= Gui.FileManager(NewsImage, Dynamicweb.Content.Files.FilesAndFolders.GetImagesFolderName(), "NewsImage")%>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftCol">
                                <dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Image caption" />
                            </td>
                            <td>
                                <asp:TextBox ID="NewsImageCaption" runat="server" CssClass="std" MaxLength="255"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                    <dw:GroupBoxEnd runat="server" ID="GroupBoxEnd2" />
                    <cust:CustomFieldsControl ID="GeneralCustFields" runat="server" LeftColumnCssClass="leftCol"
                        Width="100%" Title="General" />
                    <cust:CustomFieldsControl ID="SpecificCustFields" runat="server" LeftColumnCssClass="leftCol"
                        Width="100%" Title="Specific" />
                </div>
                <div id="Tab3" style="display: none;">
                    <fieldset class="fieldset">                                                          
                        <legend class='gbTitle'>
                            <dw:TranslateLabel ID="TranslateLabel20" runat="server" Text="Related categories" />
                        </legend>
                        <cust:ListSelector Columns="1" ID="lstCategoriesCtrl" Name="lstCategories" DataTextField="NewsCategoryName"
                            DataValueField="ID" runat="server" />
                    </fieldset>
                </div>
                <% Translate.GetEditOnlineScript()%>
            </div>
        </dw:StretchedContainer>
    </div>
    <dw:Dialog ID="CommentsDialog" runat="server" Title="Comments" HidePadding="true" Width="625">
			<iframe id="CommentsDialogFrame"  frameborder="0"></iframe>
		</dw:Dialog>
    <omc:MarketingConfiguration ID="marketConfig" runat="server" />
	<script type="text/javascript">
        NewsEdit.Marketing = <%=marketConfig.ClientInstanceName%>;
    </script>

    <dw:Dialog ID="CreateMessageDialog" runat="server" Title="Publish news to social media" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" >
        <iframe id="CreateMessageDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <asp:HiddenField ID="OpenPreviewAfterSave" runat="server" Value="false"/>
    </form>
</body>
</html>
