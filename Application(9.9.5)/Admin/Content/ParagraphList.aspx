<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ParagraphList.aspx.vb" Inherits="Dynamicweb.Admin.ParagraphList1" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Security" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls.OMC" TagPrefix="omc" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <script src="/Admin/Resources/vendors/Sortable/Sortable.js"></script>

    <!-- JQuery is not allowed to be included -->
    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUtilities="true" IncludeScriptaculous="false" IncludejQuery="false" />

    <link rel="Stylesheet" href="/Admin/Images/Ribbon/UI/List/List.css" />
    <link rel="Stylesheet" href="ParagraphList.css?v=3" />

    <!-- Page specific scripts -->
    <script type="text/javascript" src="ParagraphList.js?v=2"></script>
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script src="/Admin/Resources/js/layout/Actions.js"></script>
    <script src="/Admin/Link.js"></script>

    <style id="WorkflowCss" runat="server" type="text/css" visible="false">
        #ShowWorkflow1, #ShowWorkflow2, #ShowWorkflow3 {
            display: none;
            visibility: hidden;
        }

        .icon .fa-globe, .icon .fa-link {
            margin-left: -16px;
            font-size: 12px !important;
            float: left;
            position: relative;
            top: 17px;
            left: 23px;
        }

        .icon > img {
            vertical-align: middle;
        }
    </style>

    <% If OMCIsInstalled Then%>
    <script type="text/javascript" src="/Admin/Module/OMC/Experiments/Controls.js"></script>
    <script type="text/javascript">
        window.g_splitTestObj = createSplitTestObj(<%=PageID%>, <%=NoContent.ToString().ToLower()%>)
    </script>
    <%End If%>

    <script type="text/javascript">
        var experimentParagraphs = new Array();
        var InternalAllID = '<%=Dynamicweb.Context.Current.Request("caller")%>';
        var deleteMsg = '<%=GetDeleteParagraphMessage()%>';
        pageID = <%=Core.Converter.ToInt32(Dynamicweb.Context.Current.Request("PageID"))%>;
            
<%--        ShowParagraphSortingConfirmation = <%= IIf(ShowParagraphSortingConfirmation(), "true", "false") %>;--%>
        ParagraphSortingWarningMsg = '<%=Translate.JsTranslate("Sorting paragraphs on master page will sort on the language versions too. Continue?")%>';

        Dynamicweb.ParagraphList.Translations['ContainerRestriction'] = '<%=Translate.JsTranslate("Containers restriction does not allow to contain specified item.")%>';
        Dynamicweb.ParagraphList.Translations['Required'] = '<%=Translate.JsTranslate("Required")%>';
        Dynamicweb.ParagraphList.ItemEdit.get_current().set_item({id: '<%=_Page.ItemId%>', type: '<%=_Page.ItemType%>'}); 
        <% If Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "selectpage" Then %>
        dwGlobal.getContentNavigator().expandAncestors(<%= Converter.SerializeCompact(GetPageAncestorsNodeIds()) %>);
        <% ElseIf Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "refreshandselectpage" Then
            Dim ancestors As IEnumerable(Of String) = GetPageAncestorsNodeIds()
            Dim ancestorsToForceReload As IEnumerable(Of String) = ancestors.Take(1)
            %>
        dwGlobal.getContentNavigator().expandAncestors(<%= Converter.SerializeCompact(ancestors) %>, <%= Converter.SerializeCompact(ancestorsToForceReload) %>);
        <% ElseIf Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "refreshparentandselectpage" Then
            Dim ancestors As IEnumerable(Of String) = GetPageAncestorsNodeIds()
            Dim ancestorsToForceReload As IEnumerable(Of String) = ancestors.Skip(Math.Max(0, ancestors.Count - 2)).Take(1)
            %>
        dwGlobal.getContentNavigator().expandAncestors(<%= Converter.SerializeCompact(ancestors) %>, <%= Converter.SerializeCompact(ancestorsToForceReload) %>);
        <% End If %>

        var copyActionParams = <%=Me.GetCopyParagraphsAction.ToJson()%>;
        var moveActionParams = <%=Me.GetMoveParagraphsAction().ToJson()%>;

        function help() {
            eval($('jsHelp').innerHTML);
        }

        function help() {
            <%= Gui.Help(String.Empty, "page.edit")%>
        }
    </script>

</head>
<body onload="init(<%=PageID%>);" class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <omc:MarketingConfiguration ID="marketConfig" runat="server" />

            <script type="text/javascript">
                var Marketing = <%=marketConfig.ClientInstanceName%>;
            </script>

            <input type="hidden" runat="server" id="previewUrl" />
            <input type="hidden" runat="server" id="showUrl" />
            <input type="hidden" runat="server" id="hasUnpublishedContent" />
            <input type="hidden" runat="server" id="PageParentID" />
            <input type="hidden" runat="server" id="PageAreaID" />
            <input type="hidden" runat="server" id="PageApprovalType" />
            <input type="hidden" runat="server" id="PageDescription" />
            <input type="hidden" runat="server" id="AllowParagraphOperations" value="true" />
            <input type="hidden" runat="server" id="NewParagraphsIDs" value="" />
            <input type="hidden" runat="server" id="NewPageID" value="" />
            <input type="hidden" runat="server" id="OldPageState" value="" />
            <input type="hidden" runat="server" id="isOmcExp" value="" />

            <div>
                <dw:RibbonBar runat="server" ID="myribbon">
                    <dw:RibbonBarTab Active="true" Name="Indhold" runat="server" ID="tabContent">
                        <dw:RibbonBarGroup ID="contentInsertTabSubGroup" runat="server" Name="Indsæt">
                            <dw:RibbonBarButton ID="NewParagraph" runat="server" Size="Small" Text="Nyt afsnit" Icon="PlusSquare" IconColor="Success" OnClientClick="newParagraph();" ShowWait="true"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="InsertGlobalElement" runat="server" Size="Small" Text="Global element" Icon="Globe" OnClientClick="insertGlobalElement();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdSort" Visible="false" runat="server" Icon="Sort" Active="false" Disabled="false" Size="Small" Text="Sorter" OnClientClick="location = '/Admin/Paragraph/Paragraph_SortAll.aspx?PageID=' + pageID;"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup ID="viewGrooup" runat="server" Name="Content" Visible="false">
                            <dw:RibbonBarRadioButton ID="cmdViewItem" Visible="false" Group="GroupView" Size="Large" Icon="Cube" Text="Page" OnClientClick="switchToItem();" runat="server" />
                            <dw:RibbonBarRadioButton ID="cmdViewParagraphs" Visible="false" Group="GroupView" Size="Large" Icon="FileTextO" Text="Paragraphs" Checked="true" runat="server" />
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup Name="Show" runat="server">
                            <dw:RibbonBarButton ID="cmdShowpage" runat="server" Size="Large" Text="Vis side" Icon="PageView" OnClientClick="showPage();" />
                            <dw:RibbonBarButton ID="cmdVisualEditor" runat="server" Size="Large" Text="Visual Editor" Icon="ViewQuilt" OnClientClick="showVisualEditor();" />
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup ID="contentPublishingTabSubGroup" Name="Publicering" runat="server">
                            <dw:RibbonBarRadioButton ID="cmdPublished" runat="server" Checked="false" Group="Publishing" Text="Publiceret" Icon="Check" Value="0" OnClientClick="publish()"></dw:RibbonBarRadioButton>
                            <dw:RibbonBarRadioButton ID="cmdHideInNavigation" runat="server" Checked="false" Group="Publishing" Text="Hide in menu" Icon="EyeSlash" Value="2" OnClientClick="unPublishHide()"></dw:RibbonBarRadioButton>
                            <dw:RibbonBarRadioButton ID="cmdHidden" runat="server" Checked="false" Group="Publishing" Text="Unpublished" Icon="Close" Value="1" OnClientClick="unPublish()"></dw:RibbonBarRadioButton>
                            <dw:RibbonBarButton ID="cmdEdit" runat="server" Size="Small" Text="Frontend editering" Icon="Edit" OnClientClick="openFrontendEditing();"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup runat="server" Name="Side">
                            <dw:RibbonBarButton runat="server" Size="Large" Text="Egenskaber" Icon="InfoOutline" OnClientClick="pageProperties2();" ShowWait="true"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup ID="PrimaryLanugageSelectorGrp" runat="server" Name="Sprog" Visible="false">
                            <dw:RibbonBarButton ID="languageSelector" runat="server" Active="false" ImagePath="/Admin/Images/Flags/flag_dk.png" Disabled="false" Size="Large" Text="Sprog" ContextMenuId="languageSelectorContext"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup Name="Help" runat="server">
                            <dw:RibbonBarButton Text="Help" Icon="Help" Size="Large" OnClientClick="help();" runat="server" />
                        </dw:RibbonBarGroup>

                    </dw:RibbonBarTab>

                    <dw:RibbonBarTab ID="RibbonbarTab2" Active="false" Name="Funktioner" runat="server">
                        <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Paragraph">
                            <dw:RibbonBarButton runat="server" Text="Kopier" ID="CopyParagraphs" Size="Small" Icon="ContentCopy" Disabled="true" OnClientClick="copyParagraphs();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Kopier hertil" ID="CopyParagraphsHere" Size="Small" Icon="Copy" Disabled="true" OnClientClick="copyParagraphsHere();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Flyt" ID="MoveParagraphs" Size="Small" Icon="ArrowRight" Disabled="true" OnClientClick="moveParagraphs();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Slet" ID="DeleteParagraphs" Size="Small" Icon="Delete" Disabled="true" OnClientClick="deleteParagraphs();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Medtag" ID="IncludeParagraphs" Size="Small" Icon="Check" Disabled="true" OnClientClick="toggleActiveAll();"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup ID="grpPreview" runat="server" Name="Preview">
                            <dw:RibbonBarButton runat="server" ID="PreviewPage" Text="Preview" Icon="OpenInNew" OnClientClick="pagePreviewCombined();"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup ID="RibbonbarGroup5" runat="server" Name="Funktioner">
                            <dw:RibbonBarButton ID="cmdSaveAsTemplate" runat="server" Size="small" Text="Save as template" Icon="File" OnClientClick="saveAsTemplate();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdEditTemplateSettings" runat="server" Size="small" Text="Template settings" Icon="Pencil" OnClientClick="saveAsTemplate();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="btnSeoAnalize" runat="server" Size="small" Text="SEO Optimize" Icon="Tachometer" OnClientClick="showOptimize();"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>

                        <dw:RibbonBarGroup ID="rbgReports" runat="server" Name="Rapporter" Visible="true">
                            <dw:RibbonBarButton ID="cmdReportPageviews" runat="server" Size="Small" Text="Sidevisninger" Icon="LineChart" ContextMenuId="ReportPageviewOptions" />
                            <dw:RibbonBarButton ID="RibbonbarButton6" Icon="PieChart" Text="Søgeord" Size="small" ContextMenuId="ReportSearchEnginePhrasesOptions" runat="server" />
                            <dw:RibbonBarButton ID="RibbonbarButton4" Icon="Directions" Text="Referers fra søgemaskiner" Size="small" ContextMenuId="ReportSearchEngineOptions" runat="server" />
                            <dw:RibbonBarButton ID="RibbonbarButton8" runat="server" Size="small" Text="Traffic" Icon="BarChart" OnClientClick="report('Traffic');" />
                            <dw:RibbonBarButton ID="RibbonbarButton7" runat="server" Size="small" Text="Page performance" Icon="File" OnClientClick="report('PagePerformance');" />
                            <dw:RibbonBarButton ID="cmdWebPageAnalysis" runat="server" Size="small" Text="Webpage Analysis" Icon="Sliders" OnClientClick="showWebPageAnalysisDialog();" />
                        </dw:RibbonBarGroup>

                    </dw:RibbonBarTab>

                    <dw:RibbonBarTab ID="WorkflowTab" Active="false" Name="Workflow" runat="server">
                        <dw:RibbonBarGroup ID="workflowGroup" runat="server" Name="Workflow" Visible="True">
                            <dw:RibbonBarCheckbox ID="cmdUseDraft" runat="server" Checked="false" Text="Use draft" Icon="FileTextO" OnClientClick="useDraft();"></dw:RibbonBarCheckbox>
                            <dw:RibbonBarButton ID="cmdShowDraft" runat="server" Size="Small" Text="Vis kladde" Icon="Search" OnClientClick="previewPage();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdCompare" runat="server" Size="Small" Text="Compare" Icon="Exchange" OnClientClick="previewComparePage();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdPublish" runat="server" Size="Small" Text="Approve" Icon="CheckBox" OnClientClick="startWorkflow(true);"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdDiscardChanges" runat="server" Size="Small" Text="Discard changes" Icon="ExitToApp" OnClientClick="discardChanges();"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdStartWorkflow" ModuleSystemName="Workflow" runat="server" Size="Small" Text="Start godkendelse" Icon="PlayCircleO" OnClientClick="startWorkflow(false);"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdShowPreviouesVersions" ModuleSystemName="VersionControl" runat="server" Size="Small" Text="Tidligere versioner" Icon="History" OnClientClick="previewBydateShow(false);"></dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="Versions" runat="server" ModuleSystemName="VersionControl" Size="Small" Icon="File" Text="Versions" Visible="true" OnClientClick="ShowVersions();"></dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>

                    <dw:RibbonBarTab ID="tabMarketing" Active="false" Name="Marketing" Visible="false" runat="server">
                        <dw:RibbonBarGroup ID="groupMarketingRestrictions" Name="Split test" runat="server">
                            <dw:RibbonBarButton ID="ExperimentSetupBtn" Text="Setup split test" Size="Large" Icon="CallSplit" OnClientClick="g_splitTestObj.ExperimentSetup();" runat="server" />
                            <dw:RibbonBarButton ID="ExperientPreviewBtn" Text="Preview" Size="Small" Icon="ExternalLink" OnClientClick="g_splitTestObj.ExperimentPreview();" runat="server" Disabled="True" />
                            <dw:RibbonBarButton ID="ExperientSettingsBtn" Text="Settings" Size="Small" Icon="Gear" OnClientClick="g_splitTestObj.ExperimentSetup();" runat="server" Disabled="True" />
                            <dw:RibbonBarButton ID="ExperientViewReportBtn" Text="View report" Size="Small" Icon="LineChart" OnClientClick="g_splitTestObj.ExperimentReport();" runat="server" Disabled="True" />
                            <dw:RibbonBarButton ID="ExperimentStart" Text="Start" Size="Small" Icon="Play" OnClientClick="g_splitTestObj.ExperimentStart();" runat="server" Disabled="True" />
                            <dw:RibbonBarButton ID="ExperimentPause" Text="Pause" Size="Small" Icon="Pause" OnClientClick="g_splitTestObj.ExperimentPause();" runat="server" Disabled="True" />
                            <dw:RibbonBarButton ID="ExperientStopBtn" Text="Stop" Size="Small" Icon="Stop" OnClientClick="g_splitTestObj.ExperimentDelete();" runat="server" Disabled="True" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="groupMarketingContent" Name="Indhold" runat="server" Visible="false">
                            <dw:RibbonBarButton ID="ExperimentTestBtn" Text="Create variant" Size="Large" Icon="Copy" OnClientClick="experimentTestParagraph();" runat="server" Disabled="true" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="groupPersonalization" Name="Personalization" runat="server">
                            <dw:RibbonBarButton ID="RibbonbarButton15" Text="Personalize page" Size="Small" Icon="Star" OnClientClick="openContentRestrictionDialog();" runat="server" />
                            <dw:RibbonBarButton ID="RibbonbarButton16" Text="Add profile points" Size="Small" Icon="PersonAdd" OnClientClick="openProfileDynamicsDialog();" runat="server" />
                            <dw:RibbonBarButton ID="cmdPreviewProfileVisit" Text="Preview page" Size="Small" Icon="OpenInNew" OnClientClick="profileVisitPreview();" runat="server" />
                            <dw:RibbonBarButton ID="PersonalizationShow" Text="Email Personalization" Size="Small" Icon="Star" OnClientClick="showOMCPersonalization();" runat="server" />
                            <dw:RibbonBarButton ID="EmailPreview" Text="Email Preview" Size="Small" Icon="OpenInNew" OnClientClick="EmailPreviewShow();" runat="server" />
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>
                </dw:RibbonBar>

            </div>

            <dw:PageBreadcrumb ID="BreadcrumbControl" runat="server" />

            <div class="list">
                <asp:Repeater ID="ContainerRepeater" runat="server" EnableViewState="false">
                    <HeaderTemplate>
                        <ul>
                            <li class="header">
                                <span class="C1">
                                    <span id="checkall">
                                        <input id="chkAll" name="chkAll" type="checkbox" onclick="toggleAllSelected();" class="checkbox" /><label for="chkAll"></label></span>
                                </span>
                                <span class="pipe"></span><span class="C2"><%=Translate.Translate("Afsnitsnavn")%></span>
                                <span class="pipe"></span><span class="C3"><%=Translate.Translate("Medtag")%></span>
                                <span class="pipe" id="ShowWorkflow1"></span><span class="C4" id="ShowWorkflow2"><%=Translate.Translate("Publiceret")%></span>
                                <span class="pipe"></span><span class="C4"><%=Translate.Translate("Redigeret")%></span>
                                <span class="pipe"></span><span class="C5"><%=Translate.Translate("Bruger")%></span>
                                <span class="pipe"></span><span class="C6"><%=Translate.Translate("Aktiv fra")%></span>
                                <span class="pipe"></span><span class="C7"><%=Translate.Translate("Aktiv til")%></span>
                                <span class="pipe"></span>
                            </li>
                        </ul>
                        <div id="_contentWrapper">
                            <ul id="items">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li class="ContainerDummy" <%# GetGridIdAttribute(Container.DataItem) %> oncontextmenu="<%# Dynamicweb.Controls.ContextMenu.GetContextMenuAction("AddParagraph", DataBinder.Eval(Container.DataItem, "Name")) %>">
                            <div class="ContainerDiv h" onclick="toggleContentPlacegoldersView(this)" <%# ShowContainer(Container.DataItem) %>>
                                <span class="handle"></span>
                                <span class="icon">
                                    <i class="<%#KnownIconInfo.ClassNameFor(If(CheckContainerIsGrid(Container.DataItem), KnownIcon.GridOn, KnownIcon.Briefcase), True)%>"></i>
                                </span>
                                <input type="hidden" class="container-name" value="<%# DataBinder.Eval(Container.DataItem, "Name")%>" />
                                <span class="container-title"><%# DataBinder.Eval(Container.DataItem, "Title")%></span>
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleDown, True)%> arrow <%#If(CheckContainerIsEmpty(Container.DataItem), "hidden", "")%>"></i>
                            </div>
                            <asp:Repeater ID="containerParagraphsRepeater" runat="server">
                                <HeaderTemplate>
                                    <div class="paragraphsWrapper">
                                        <ul style="position: relative; min-height: 5px" class="paragraph-container paragraph-container-grid-<%#Core.Converter.ToBoolean(CType(DataBinder.Eval(Container.Parent.Parent, "DataItem"), Dynamicweb.Rendering.Designer.DynamicElement).Settings.Item("grid")) %>" id="Container_<%# DataBinder.Eval(Container.Parent.Parent, "DataItem.Name")%>" data-items-allowed="<%#DataBinder.Eval(Container.Parent.Parent, "DataItem.Settings").Get("items-allowed") %>">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <li class="paragraph <%# If(IsGrid(Container.DataItem), "paragraph-" + GetParagraphColumns(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) + " paragraph-grid", String.Empty) %>" id="Paragraph_<%# Eval("ID") %>" data-item-type="<%#GetItemType(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %>" oncontextmenu="<%#Contextmenu(CType(Container.DataItem, Dynamicweb.Content.Paragraph), Container) %>">
                                        <span class="C1">
                                            <span id="PI_<%# Eval("ID") %>" class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><span class="icon"><%#Icon(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span></span>
                                            <input id="P<%# Eval("ID") %>" type="checkbox" name="P<%# Eval("ID") %>" value="<%# Eval("ID") %>" onclick="handleCheckboxes();" class="checkbox browseHide <%#If(CType(Container.DataItem, Dynamicweb.Content.Paragraph).IsTemplate, "disableInclude", String.Empty)%>" <%#CheckCheckboxIsAllowed(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %> /><label for="P<%# Eval("ID") %>"></label>
                                        </span>
                                        <div class="handle">
                                            <span class="C2">
                                                <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>">
                                                    <a href="<%#ClickAction(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %>" style="<%#LinkStyle(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %>">
                                                        <%#GetHeader(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>&nbsp;&nbsp;&nbsp;
								                            <%#Permissions(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                        <%#LockIcon(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %>
                                                        <%#WorkflowState(CType(Container.DataItem, Dynamicweb.Content.Paragraph).ApprovalState)%>
                                                        <%#MasterUpdatedIcon(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                        <%#ScheduledPublicationIcon(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                        <%#Experiment(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                        <%#ProfiledParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                    </a></span>
                                            </span>
                                            <span class="C3"><a href="<%#ToggleActiveLink(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %>" style="<%#LinkStyle(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %>" class="browseHide"><%#ActiveGif(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></a></span>
                                            <span class="C4" id="ShowWorkflow3">
                                                <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#Eval("VersionTimeStamp", "{0:ddd, dd MMM yyyy HH':'mm}")%></span>
                                            </span>
                                            <span class="C4" title="<%=Translate.Translate("Oprettet") %>: <%#GetCreatedAt(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>">
                                                <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#GetLastModifiedAt(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span>
                                            </span>
                                            <span class="C5" title="<%=Translate.Translate("Oprettet af")%>: <%#GetCreatedByName(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>">
                                                <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#GetModifiedByName(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span>
                                            </span>
                                            <span class="C6" id="Span1">
                                                <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#ActiveFrom(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span>
                                            </span>
                                            <span class="C7" id="Span2">
                                                <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#ActiveTo(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span>
                                            </span>
                                        </div>
                                        <script type="text/javascript">
                                            experimentParagraphs.push('P'+<%#If(CType(Container.DataItem, Dynamicweb.Content.Paragraph).Variation > 1, Eval("ID"), 0) %>);
                                        </script>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </ul>
                                    </div>
                                </FooterTemplate>
                            </asp:Repeater>
                            <asp:Repeater ID="containerGridRowsRepeater" OnItemDataBound="containerGridRowsRepeater_ItemDataBound" runat="server">
                                <HeaderTemplate>
                                    <dw:Infobar runat="server" ID="infoGridIssue" DisplayType="Warning" TranslateMessage="false" Visible="false"></dw:Infobar>
                                    <div class="paragraphsWrapper">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <dw:Infobar runat="server" ID="infoGridIssue" DisplayType="Warning" TranslateMessage="false" Visible="false"></dw:Infobar>
                                    <ul style="position: relative;" class="paragraph-container paragraph-gridrow <%# GetGridRowShowClass(Container.DataItem.Item1) %>" id="<%# GetGridRowElementId(Container.DataItem.Item1) %>" data-items-allowed="<%#DataBinder.Eval(Container.Parent.Parent, "DataItem.Settings").Get("items-allowed") %>" oncontextmenu="<%# Dynamicweb.Controls.ContextMenu.GetContextMenuAction("EditGridRow", GetGridRowElementId(Container.DataItem.Item1)) %>">
                                        <li class="paragraph paragraph-header">
                                            <span class="C1"></span>
                                            <span class="C2">
                                                <span class="ShowTrue">
                                                    <%# CType(Container.DataItem.Item1, Dynamicweb.Content.GridRow).DefinitionId %>
                                                    <%# ScheduledPublicationIcon(CType(Container.DataItem.Item1, Dynamicweb.Content.GridRow)) %>
                                                </span>
                                            </span>
                                            <span class="C3">
                                                <%# ActiveIcon(CType(Container.DataItem.Item1, Dynamicweb.Content.GridRow).Active) %>
                                            </span> 
                                            <span class="C4" title="<%=Translate.Translate("Oprettet") %>: <%#GetCreatedAt(CType(Container.DataItem.Item1, Dynamicweb.Content.GridRow))%>">
                                                <span class="ShowTrue"><%#GetLastModifiedAt(CType(Container.DataItem.Item1, Dynamicweb.Content.GridRow))%></span>
                                            </span>
                                            <span class="C5" title="<%=Translate.Translate("Oprettet af")%>: <%#GetCreatedByName(CType(Container.DataItem.Item1, Dynamicweb.Content.GridRow))%>">
                                                <span class="ShowTrue"><%#GetModifiedByName(CType(Container.DataItem.Item1, Dynamicweb.Content.GridRow))%></span>
                                            </span>
                                            <span class="C6">
                                                <span class="ShowTrue"><%#GetValidFrom(CType(Container.DataItem.Item1, Dynamicweb.Content.GridRow))%></span>
                                            </span>
                                            <span class="C7">
                                                <span class="ShowTrue"><%#GetValidTo(CType(Container.DataItem.Item1, Dynamicweb.Content.GridRow))%></span>
                                            </span>
                                        </li>
                                    <asp:Repeater ID="gridrowColumnsRepeater" runat="server">
                                        <ItemTemplate>
                                            <li class="paragraph">
                                                <span class="C1">
                                                    <span id="PI_<%# Eval("ID") %>" class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><span class="icon"><%#Icon(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span></span>
                                                    <input id="P<%# Eval("ID") %>" type="checkbox" name="P<%# Eval("ID") %>" value="<%# Eval("ID") %>" onclick="handleCheckboxes();" class="checkbox browseHide disableInclude disableCopy disableMove" <%#CheckCheckboxIsAllowed(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %> /><label for="P<%# Eval("ID") %>"></label>
                                                </span>
                                                <div class="handle">
                                                    <span class="C2">
                                                        <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>">
                                                            <a href="<%#ClickAction(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %>" style="<%#LinkStyle(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %>">
                                                                <%#GetHeader(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>&nbsp;&nbsp;&nbsp;
								                                    <%#Permissions(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                                <%#LockIcon(CType(Container.DataItem, Dynamicweb.Content.Paragraph)) %>
                                                                <%#WorkflowState(CType(Container.DataItem, Dynamicweb.Content.Paragraph).ApprovalState)%>
                                                                <%#MasterUpdatedIcon(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                                <%#ScheduledPublicationIcon(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                                <%#Experiment(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                                <%#ProfiledParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>
                                                            </a></span>
                                                    </span>
                                                    <span class="C3">&nbsp;</span>
                                                    <span class="C4" id="ShowWorkflow3">
                                                        <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#Eval("VersionTimeStamp", "{0:ddd, dd MMM yyyy HH':'mm}")%></span>
                                                    </span>
                                                    <span class="C4" title="<%=Translate.Translate("Oprettet") %>: <%#GetCreatedAt(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>">
                                                        <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#GetLastModifiedAt(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span>
                                                    </span>
                                                    <span class="C5" title="<%=Translate.Translate("Oprettet af")%>: <%#GetCreatedByName(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>">
                                                        <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#GetModifiedByName(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span>
                                                    </span>
                                                    <span class="C6" id="Span1">
                                                        <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#ActiveFrom(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span>
                                                    </span>
                                                    <span class="C7" id="Span2">
                                                        <span class="Show<%#DoShowParagraph(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%>"><%#ActiveTo(CType(Container.DataItem, Dynamicweb.Content.Paragraph))%></span>
                                                    </span>
                                                </div>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    </ul>
                                </ItemTemplate>
                            </asp:Repeater>
                        </li>
                    </ItemTemplate>
                    <FooterTemplate>
                                </ul>
                            </div>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>

            <dw:Infobar runat="server" ID="unpublishedContentInfo" Type="Information" Message="This page has unpublished changes" Title="Publish" Visible="false" OnClientClick="Ribbon.checkBox('cmdUseDraft');useDraft();//startWorkflow(false);">
            </dw:Infobar>

            <dw:Infobar runat="server" ID="noParagraphsInfo" Type="Information" Message="Ingen afsnit på denne side" Title="Nyt afsnit" OnClientClick="newParagraph();">
            </dw:Infobar>

            <dw:Infobar runat="server" ID="isTemplateInfo" Type="Information" Message="This page is a template for new pages." Title="Skabelon" Visible="false" OnClientClick="saveAsTemplate();">
            </dw:Infobar>

            <dw:Infobar runat="server" ID="designMissing" Type="Warning" Message="No design is selected. This is causing problems" Title="Skabelon" Visible="false" OnClientClick="saveAsTemplate();">
            </dw:Infobar>

            <dw:Infobar runat="server" ID="shortcutInfo" Type="Information">
                <%=LinkInfo()%>
            </dw:Infobar>

            <dw:Infobar Visible="false" Message="Layout missing" runat="server" Type="Information" Title="" OnClientClick="" ID="layoutMissing">
            </dw:Infobar>

            <input type="hidden" id="GlobalIDs" runat="server" />
            <input type="hidden" id="GlobalElementsIDs" runat="server" />

            <span id="jsHelp" style="display: none">
                <%=Dynamicweb.SystemTools.Gui.Help("", "page.paragraph.listNEW")%>
            </span>

            <span id="confirmDiscard" style="display: none">
                <%=Dynamicweb.SystemTools.Translate.JsTranslate("Discard changes")%>?
            </span>
        </form>

    </div>
    <div class="card-footer" id="BottomInformationBg" runat="server">
        <table border="0">
            <tr>
                <td>
                    <dw:TranslateLabel Text="Name" runat="server" />
                    :
                </td>
                <td class="value"><b id="_pagename" runat="server"></b></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="TitleLbl" runat="server" Text="Titel" />
                    <dw:TranslateLabel ID="ItemTypeLbl" runat="server" Text="Item type" Visible="False" />
                    :
                </td>
                <td class="value"><span id="_title" runat="server"></span></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel Text="ID" runat="server" />
                    :
                </td>
                <td class="value"><span id="_pageid" runat="server">0</span></td>
            </tr>
        </table>
        <table border="0">
            <tr>
                <td>
                    <dw:TranslateLabel Text="Created" runat="server" />
                    :
                </td>
                <td class="value"><span id="_created" runat="server"></span></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel Text="Page Edited" runat="server" />
                    :
                </td>
                <td class="value"><span id="_edited" runat="server"></span></td>
            </tr>
             <tr>
                <td>
                    <dw:TranslateLabel Text="Content Edited" runat="server" />
                    :
                </td>
                <td class="value"><span id="_contentEdited" runat="server"></span></td>
            </tr>
        </table>
        <table border="0">
            <tr>
                <td>
                    <dw:TranslateLabel Text="Template" runat="server" />
                    :
                </td>
                <td class="value"><span id="_template" runat="server"></span></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel Text="URL" runat="server" />
                    :
                </td>
                <td class="value"><span id="_url" runat="server"></span></td>
            </tr>
        </table>
        <%If Not String.IsNullOrEmpty(_profile.InnerText) Then%>
        <table border="0">
            <tr>
                <td colspan="2">
                    <b>
                        <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Dispaly of the page is dependant on OMC profile" />
                        :</b>
                    <span class="value" id="_profile" runat="server"></span>
                </td>
            </tr>
        </table>
        <%End If%>
    </div>


    <dw:Dialog ID="PreviewByDateDialog" runat="server" Title="Show previous version" ShowCancelButton="true" ShowOkButton="true" ShowClose="true" OkAction="previewBydate();">
        <table border="0" style="width: 450px;">
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel15" runat="server" Text="Dato" />
                </td>
                <td>
                    <dw:DateSelector ID="DateSelector1" runat="server" AllowNeverExpire="false" AllowNotSet="false" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
    </dw:Dialog>

    <%    If Me.Page1.ID > 0 Then%>
    <dw:Dialog ID="VersionsDialog" runat="server" Title="Versioner" HidePadding="true" Width="600">
        <iframe id="VersionsDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>
    <% End If%>

    <%If _Page.ApprovalState <> 0 Then %>
    <dw:Dialog ID="QuitDraftDialog" runat="server" Title="Quit draft" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" CancelAction="QuitDraftCancel();" OkAction="QuitDraftOk();">
        <span class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Warning) %>"></span>
        <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="This page has unpublished content. What do you want to do?" />
        <br />
        <br />
        <table border="0" style="width: 150px;">
            <tr>
                <td>
                    <dw:RadioButton ID="QuitDraftPublish" runat="server" FieldName="QuitDraft" FieldValue="Publish" SelectedFieldValue="Publish" />
                    <label for="QuitDraftPublish">
                        <span class="<%=KnownIconInfo.ClassNameFor(KnownIcon.CheckBox) %>" style="vertical-align: text-top"></span>
                        <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Publish" />
                    </label>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:RadioButton ID="QuitDraftDiscard" runat="server" FieldName="QuitDraft" FieldValue="Discard" />
                    <label for="QuitDraftDiscard">
                        <span class="<%=KnownIconInfo.ClassNameFor(KnownIcon.ExitToApp) %>" style="vertical-align: text-top"></span>
                        <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Discard changes" />
                    </label>
                </td>
            </tr>
        </table>

        <br />

        <br />
    </dw:Dialog>
    <% End If%>

    <dw:Dialog ID="SaveAsTemplateDialog" runat="server" Size="Medium" Title="Save as template" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" CancelAction="SaveAsTemplateCancel();" OkAction="SaveAsTemplateOk();">
        <dwc:GroupBox runat="server">
            <dwc:InputText runat="server" ID="TemplateName" Label="Navn" MaxLength="255" />
            <dwc:InputText runat="server" ID="TemplateDescription" Label="Beskrivelse" MaxLength="255" />
            <dw:FileManager runat="server" ID="TemplateImage" Folder="/images" Extensions="jpg,jpeg,bmp,gif,png,webp" Name="TemplateImage" Label="Image" />
            <div id="isTemplateRow" runat="server" visible="false">
                <dwc:CheckBox ID="isTemplate" runat="server" Value="1" Label="Aktiv" SelectedFieldValue="1" />
            </div>
        </dwc:GroupBox>
    </dw:Dialog>

    <dw:Dialog ID="OptimizeDialog" runat="server" Title="SEO Optimize" HidePadding="true" ShowOkButton="true" ShowCancelButton="false" ShowClose="true">
        <iframe id="OptimizeDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="GlobalsDialog" runat="server" ShowClose="true" Title="Global element" HidePadding="true" Width="600">
        <iframe id="GlobalsDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>
    <script type="text/javascript">
        GlobalUrl = '/Admin/Content/Paragraph/InsertGlobalElement.aspx?AreaID=<%=Me.Page1.AreaID %>';
    </script>

    <dw:Dialog ID="WebPageAnalysisDialog" runat="server" Title="Report" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="WebPageAnalysisDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="CreateMessageDialog" runat="server" Title="Publish page to social media" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="CreateMessageDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="ReportsDialog" runat="server" Title="Report" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="ReportsDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="ParagraphOptionsDialog" runat="server" Visible="false" Title="Paragraph options" ShowOkButton="true" ShowCancelButton="false" ShowClose="false" CancelAction="dialog.hide('ParagraphOptionsDialog');" OkAction="updateParagraphOptions();">
        <img src="/Admin/Images/Ribbon/Icons/warning.png" alt="" style="vertical-align: middle;" />
        <dw:TranslateLabel ID="TranslateLabel17" runat="server" Text="Would you like the paragraphs to be:" />
        <br />
        <br />
        <table border="0" style="width: 150px;">
            <tr>
                <td>
                    <dw:RadioButton ID="AsTheyAreButton" runat="server" FieldName="ParagraphOptions" FieldValue="AsTheyAre" SelectedFieldValue="AsTheyAre" />
                </td>
                <td>
                    <label for="AsTheyAreButton">
                        <dw:TranslateLabel ID="TranslateLabel18" runat="server" Text="Leave as they are" />
                    </label>
                </td>
            </tr>
            <tr>
                <td style="height: 3px;"></td>
            </tr>
            <tr>
                <td>
                    <dw:RadioButton ID="ActiveButton" runat="server" FieldName="ParagraphOptions" FieldValue="Active" />
                </td>
                <td>
                    <label for="ActiveButton">
                        <dw:TranslateLabel ID="TranslateLabel19" runat="server" Text="Active" />
                    </label>
                </td>
            </tr>
            <tr>
                <td style="height: 3px;"></td>
            </tr>
            <tr>
                <td>
                    <dw:RadioButton ID="NotActiveButton" runat="server" FieldName="ParagraphOptions" FieldValue="NotActive" />
                </td>
                <td>
                    <label for="NotActiveButton">
                        <dw:TranslateLabel ID="TranslateLabel20" runat="server" Text="Not active" />
                    </label>
                </td>
            </tr>
        </table>
    </dw:Dialog>

    <dw:Dialog ID="PageOptionsDialog" runat="server" Visible="false" Title="Page options" ShowOkButton="true" ShowCancelButton="false" ShowClose="False" OkAction="updatePageOptions();" CancelAction="dialog.hide('PageOptionsDialog');">
        <img src="/Admin/Images/Ribbon/Icons/warning.png" alt="" style="vertical-align: middle;" />
        <dw:TranslateLabel ID="lblCopyWarning" runat="server" Text="Copying page will not copy page on the language websites due to perfomance problems." Visible="false" />
        <dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="Would you like the page to be:" />
        <br />
        <br />
        <table border="0">
            <% If Dynamicweb.Context.Current.Request("cmd") = "copypage" %>
            <tr>
                <td>
                    <label for="NewPageName">
                        <dw:TranslateLabel ID="TranslateLabel26" runat="server" Text="New page name" />
                    </label>
                </td>
                <td style="height: 6px;">
                    <input type="text" runat="server" id="NewPageName" name="NewPageName" class="NewUIinput" maxlength="255" value="" />
                </td>
            </tr>
            <tr>
                <td style="height: 6px;">
                    <label>
                        <dw:TranslateLabel ID="TranslateLabel28" runat="server" Text="Page status" />
                    </label>
                </td>
                <% Else%>
            <tr>
                <td style="height: 6px;"></td>
                <% End If %>
                <td>
                    <dw:RadioButton ID="RadioButton1" runat="server" FieldName="PageOptions" FieldValue="AsTheyAre" SelectedFieldValue="AsTheyAre" />
                    <label for="AsTheyAreButton">
                        <dw:TranslateLabel ID="TranslateLabel22" runat="server" Text="Leave as they are" />
                    </label>
                    <br />
                    <dw:RadioButton ID="Published" runat="server" FieldName="PageOptions" FieldValue="Published" />
                    <label for="Published">
                        <dw:TranslateLabel ID="TranslateLabel23" runat="server" Text="Published" />
                    </label>
                    <br />
                    <dw:RadioButton ID="HideInMenu" runat="server" FieldName="PageOptions" FieldValue="HideInMenu" />
                    <label for="HideInMenu">
                        <dw:TranslateLabel ID="TranslateLabel25" runat="server" Text="Hide in menu" />
                    </label>
                    <br />
                    <dw:RadioButton ID="Unpublished" runat="server" FieldName="PageOptions" FieldValue="Unpublished" />
                    <label for="Unpublished">
                        <dw:TranslateLabel ID="TranslateLabel24" runat="server" Text="Unpublished" />
                    </label>
                </td>
            </tr>
        </table>
    </dw:Dialog>

    <script type="text/javascript">
        ListHasTemplateModule = <%=ListHasTemplateModule.tostring.toLower %>;
    </script>

    <dw:ContextMenu ID="AddParagraph" runat="server">
        <dw:ContextMenuButton ID="addparagraphbtn" runat="server" Text="Nyt afsnit" Image="AddDocument" Icon="PlusSquare" OnClientClick="newParagraphToContainer();">
        </dw:ContextMenuButton>
    </dw:ContextMenu>
    <dw:ContextMenu ID="ParagraphInclude" OnShow="initializeContextMenu(ContextMenu.callingID, this);" runat="server">
        <dw:ContextMenuButton ID="cmdEditParagraphInclude" runat="server" Divide="After" Icon="Pencil" Text="Rediger">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdCopyInclude" runat="server" Divide="None" Icon="ContentCopy" Text="Kopier" OnClientClick="copyParagraph();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdCopyHereInclude" runat="server" Divide="None" Icon="Copy" Text="Kopier hertil" OnClientClick="copyParagraphHere();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdMoveInclude" runat="server" Divide="None" Icon="ArrowRight" Text="Flyt" OnClientClick="moveParagraph();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdToggleActiveInclude" runat="server" Divide="Before" Icon="Check" Text="Medtag" OnClientClick="toggleActiveR();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdDetachGlobalInclude" runat="server" Divide="After" Text="Detach global element" Icon="Globe" OnClientClick="detachGlobalElement(ContextMenu.callingID);">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdInsertBeforeInclude" runat="server" Divide="None" Icon="LongArrowLeft" Text="Insert before" OnClientClick="insertParagraphBefore();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdInsertAfterInclude" runat="server" Divide="After" Icon="LongArrowRight" Text="Insert after" OnClientClick="insertParagraphAfter();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdDeleteInclude" runat="server" Divide="None" Icon="Delete" Text="Slet" OnClientClick="deleteParagraph();">
        </dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:ContextMenu ID="ParagraphIncludeModule" OnShow="initializeContextMenu(ContextMenu.callingID, this);" runat="server">
        <dw:ContextMenuButton ID="cmdEditParagraphIncludeModule" runat="server" Divide="None" Icon="Pencil" Text="Rediger">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" Divide="After" Icon="Gear" Text="Modulopsætning" OnClientClick="openModuleSettings();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdCopyIncludeModule" runat="server" Divide="None" Icon="ContentCopy" Text="Kopier" OnClientClick="copyParagraph();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdCopyHereIncludeModule" runat="server" Divide="None" Icon="Copy" Text="Kopier hertil" OnClientClick="copyParagraphHere();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdMoveIncludeModule" runat="server" Divide="None" Icon="ArrowRight" Text="Flyt" OnClientClick="moveParagraph();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdToggleActiveIncludeModule" runat="server" Divide="Before" Icon="Check" Text="Medtag" OnClientClick="toggleActiveR();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdDetachGlobalIncludeModule" runat="server" Divide="After" Text="Detach global element" Icon="Globe" OnClientClick="detachGlobalElement(ContextMenu.callingID);">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdInsertBeforeIncludeModule" runat="server" Divide="None" Icon="LongArrowLeft" Text="Insert before" OnClientClick="insertParagraphBefore();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdInsertAfterIncludeModule" runat="server" Divide="After" Icon="LongArrowRight" Text="Insert after" OnClientClick="insertParagraphAfter();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdDeleteIncludeModule" runat="server" Divide="None" Icon="Delete" Text="Slet" OnClientClick="deleteParagraph();">
        </dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:ContextMenu ID="ParagraphExclude" OnShow="initializeContextMenu(ContextMenu.callingID, this);" runat="server">
        <dw:ContextMenuButton ID="cmdEditParagraphExclude" runat="server" Divide="After" Icon="Pencil" Text="Rediger">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdCopyExclude" runat="server" Divide="None" Icon="ContentCopy" Text="Kopier" OnClientClick="copyParagraph();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdCopyHereExclude" runat="server" Divide="None" Icon="Copy" Text="Kopier hertil" OnClientClick="copyParagraphHere();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdMoveExclude" runat="server" Divide="None" Icon="ArrowRight" Text="Flyt" OnClientClick="moveParagraph();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdToggleActiveExclude" runat="server" Divide="Before" Icon="Close" Text="Exclude" OnClientClick="toggleActiveR();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdDetachGlobalExclude" runat="server" Divide="After" Text="Detach global element" Icon="Check" OnClientClick="detachGlobalElement(ContextMenu.callingID);">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdInsertBeforeExclude" runat="server" Divide="None" Icon="LongArrowLeft" Text="Insert before" OnClientClick="insertParagraphBefore();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdInsertAfterExclude" runat="server" Divide="After" Icon="LongArrowRight" Text="Insert after" OnClientClick="insertParagraphAfter();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdDeleteExclude" runat="server" Divide="None" Icon="Delete" Text="Slet" OnClientClick="deleteParagraph();">
        </dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:ContextMenu ID="ParagraphExcludeModule" OnShow="initializeContextMenu(ContextMenu.callingID, this);" runat="server">
        <dw:ContextMenuButton ID="cmdEditParagraphExcludeModule" runat="server" Divide="None" Icon="Pencil" Text="Rediger">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" Divide="After" Icon="Gear" Text="Modulopsætning" OnClientClick="openModuleSettings();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdCopyExcludeModule" runat="server" Divide="None" Icon="ContentCopy" Text="Kopier" OnClientClick="copyParagraph();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdCopyHereExcludeModule" runat="server" Divide="None" Icon="Copy" Text="Kopier hertil" OnClientClick="copyParagraphHere();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdMoveExcludeModule" runat="server" Divide="None" Icon="ArrowRight" Text="Flyt" OnClientClick="moveParagraph();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdToggleActiveExcludeModule" runat="server" Divide="Before" Icon="Close" Text="Exclude" OnClientClick="toggleActiveR();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdDetachGlobalExcludeModule" runat="server" Divide="After" Text="Detach global element" Icon="Globe" OnClientClick="detachGlobalElement(ContextMenu.callingID);">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdInsertBeforeExcludeModule" runat="server" Divide="None" Icon="LongArrowLeft" Text="Insert before" OnClientClick="insertParagraphBefore();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="cmdInsertAfterExcludeModule" runat="server" Divide="After" Icon="LongArrowRight" Text="Insert after" OnClientClick="insertParagraphAfter();">
        </dw:ContextMenuButton>

        <dw:ContextMenuButton ID="cmdDeleteExcludeModule" runat="server" Divide="None" Icon="Delete" Text="Slet" OnClientClick="deleteParagraph();">
        </dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:ContextMenu ID="languageSelectorContext" runat="server" MaxHeight="400">
    </dw:ContextMenu>

    <dw:ContextMenu ID="ReportPageviewOptions" runat="server">
        <dw:ContextMenuButton ID="ContextmenuButton9" runat="server" Divide="None" Icon="LineChart" Text="Dag" OnClientClick="report('PageviewsDay');">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextmenuButton7" runat="server" Divide="None" Icon="LineChart" Text="Uge" OnClientClick="report('PageviewsWeek');">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextmenuButton8" runat="server" Divide="None" Icon="LineChart" Text="Måned" OnClientClick="report('PageviewsMonth');">
        </dw:ContextMenuButton>
    </dw:ContextMenu>
    <dw:ContextMenu ID="ReportSearchEnginePhrasesOptions" runat="server">
        <dw:ContextMenuButton ID="ContextmenuButton10" runat="server" Divide="None" Icon="PieChart" Text="Phrases" OnClientClick="report('SearchEnginePhrases');">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextmenuButton11" runat="server" Divide="None" Icon="PieChart" Text="Keywords" OnClientClick="report('SearchEngineKeywords');">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextmenuButton12" runat="server" Divide="None" Icon="PieChart" Text="Words per phrase" OnClientClick="report('SearchEnginePhraseWordCount');">
        </dw:ContextMenuButton>
    </dw:ContextMenu>
    <dw:ContextMenu ID="ReportSearchEngineOptions" runat="server">
        <dw:ContextMenuButton ID="ContextmenuButton13" runat="server" Divide="None" Icon="BarChart" Text="Top 5 referrers" OnClientClick="report('SearchEngineReferrers');">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextmenuButton16" runat="server" Divide="None" Icon="BarChart" Text="All referrals" OnClientClick="report('SearchEngineAllReferrals');">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextmenuButton14" runat="server" Divide="None" Icon="BarChart" Text="Top 5 crawlers" OnClientClick="report('SearchEngineBotIndex');">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextmenuButton15" runat="server" Divide="None" Icon="BarChart" Text="Indexations over time" OnClientClick="report('SearchEngineIndexTime');">
        </dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:ContextMenu ID="EditGridRow" runat="server" OnShow="onGridRowContextMenuShown()">
        <dw:ContextMenuButton ID="EditGridRowButton" runat="server" Divide="After" Text="Edit row" Icon="Edit" OnClientClick="showEditGridRowDialog()">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="CopyGridRowButton" runat="server" Divide="None" Icon="ContentCopy" Text="Copy row" OnClientClick="copyGridRow();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="CopyGridRowHereButton" runat="server" Divide="After" Icon="Copy" Text="Copy row here" OnClientClick="copyGridRowHere();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="EditGridRowTemplateButton" runat="server" Visible="false" Text="Row template settings" Icon="Pencil" Divide="After" OnClientClick="showRowTemplateSettingsDialog()">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="UnpublishGridRowButton" runat="server" Divide="None" Text="Unpublish row" Icon="Close" OnClientClick="toggleGridRowActive(false)">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="PublishGridRowButton" runat="server" Divide="None" Text="Publish row" Icon="Check" OnClientClick="toggleGridRowActive(true)">
        </dw:ContextMenuButton>
         <dw:ContextMenuButton ID="DeleteGridRowButton" runat="server" Divide="Before" Text="Delete row" Icon="Delete" OnClientClick="deleteGridRow()">
        </dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:Dialog runat="server" ID="dlgEditGridRow" Title="Edit row" Size="Large" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" OkAction="saveGridRow();">
        <iframe id="dlgEditGridRowFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="dlgRowTemplateSettings" Size="Medium" Title="Row template setting" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" CancelAction="dialog.hide('dlgRowTemplateSettings')" OkAction="saveRowTemplate()">
        <iframe id="dlgRowTemplateSettingsFrame" style="width: 100%;"></iframe>
    </dw:Dialog>

    <%Translate.GetEditOnlineScript()%>
    <dw:Dialog ID="OMCExperimentDialog" runat="server" ShowOkButton="false" HidePadding="True" ShowCancelButton="false" Title="Split test">
        <iframe id="OMCExperimentDialogFrame" frameborder="0" style="width: 750px;"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="OMCPersonalizationDialog" runat="server" Title="Email Personalization" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="false">
        <iframe id="OMCPersonalizationDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>
</body>
</html>
