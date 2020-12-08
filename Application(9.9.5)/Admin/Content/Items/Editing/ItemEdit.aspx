<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ItemEdit.aspx.vb" Inherits="Dynamicweb.Admin.ItemEdit" EnableViewState="false" ValidateRequest="false" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls.OMC" TagPrefix="omc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>

<!DOCTYPE html>
<html>
    <head runat="server">
        <title></title>
        <dw:ControlResources CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true" runat="server">
            <Items>
                <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
                <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
                <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
                <dw:GenericResource Url="/Admin/Content/Items/js/Preset.js" />
                <dw:GenericResource Url="/Admin/Link.js" />
                <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
                <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
                <dw:GenericResource Url="/Admin/Content/Items/js/ItemEdit.js" />
                <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
                <dw:GenericResource Url="/Admin/Content/Items/css/ItemEdit.css" />
            </Items>
        </dw:ControlResources>
        
        <% If OMCIsInstalled Then%>
        <script type="text/javascript" src="/Admin/Module/OMC/Experiments/Controls.js"></script>
        <script type="text/javascript">
            window.g_splitTestObj = createSplitTestObj(<%=TargetPage.ID%>, <%=NoContent.ToString().ToLower()%>)
        </script>
        <%End If%>

        <script type="text/javascript">
            var ElemCounter;

        <% If Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "refreshparentandselectpage" Then
                Dim ancestors As IEnumerable(Of String) = GetPageAncestorsNodeIds()
                Dim ancestorsToForceReload As IEnumerable(Of String) = ancestors.Skip(Math.Max(0, ancestors.Count - 2)).Take(1)
            %>
        dwGlobal.getContentNavigator().expandAncestors(<%= Converter.SerializeCompact(ancestors) %>, <%= Converter.SerializeCompact(ancestorsToForceReload) %>);            
        <% ElseIf Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "refreshandselectpage" Then
                Dim ancestors As IEnumerable(Of String) = GetPageAncestorsNodeIds()
                Dim ancestorsToForceReload As IEnumerable(Of String) = ancestors.Take(1)
            %>
        dwGlobal.getContentNavigator().expandAncestors(<%= Converter.SerializeCompact(ancestors) %>, <%= Converter.SerializeCompact(ancestorsToForceReload) %>);
        <% End If %>

            function ShowCounters(field, counter, counterMax) {
                HideCounter();

                if (field == 'undefined') return;

                var elemCounter = document.getElementById(counter);
                if (elemCounter == 'undefined') return;

                var elemCounterMax = document.getElementById(counterMax);
                if (elemCounterMax == 'undefined') return;

                ShowCounter(elemCounter, elemCounterMax.value, field.value.length);
                ElemCounter = elemCounter;

            }

            function HideCounter() {
                if (ElemCounter) {
                    setTextContent(ElemCounter, '');
                }
            }

            function CheckAndHideCounter(field, counter, counterMax) {
                if (CheckCounter(field, counter, counterMax) == true) {
                    HideCounter();
                }
            }

            function CheckCounter(field, counter, counterMax) {
                if (field == 'undefined') return false;

                var elemCounter = document.getElementById(counter);
                if (elemCounter == 'undefined') return false;

                var elemCounterMax = document.getElementById(counterMax);
                if (elemCounterMax == 'undefined') return false;

                ShowCounter(elemCounter, elemCounterMax.value, field.value.length);
                return true;
            }

            function ShowCounter(elemCounter, maxSize, currentSize) {
                if (currentSize < maxSize) {
                    setTextContent(elemCounter, (maxSize - currentSize) + ' ' + '<%=Translate.JsTranslate("remaining before recommended maximum")%>');
                }
                else {
                    setTextContent(elemCounter, '<%=Translate.JsTranslate("recommended maximum exceeded")%>');
                }

                var sizeInPercentage = 100;
                if (maxSize > 0) {
                    sizeInPercentage = currentSize * 100 / maxSize;
                }

                if (sizeInPercentage < 80) {
                    elemCounter.style.color = '#7F7F7F';
                }
                else if (sizeInPercentage < 90) {
                    elemCounter.style.color = '#000000';
                }
                else {
                    elemCounter.style.color = '#FF0000';
                }
            }

            function setTextContent(element, text) {
                if (element) {
                    element.innerHTML = text || '&nbsp;';
                }
            }            
            
            function report(reportName) {
                dialog.show("ReportsDialog", "/Admin/Content/PageTemplates/Reports/Page.aspx?Report=" + reportName + "&PageID=" + <%=Core.Converter.ToInt32(Dynamicweb.Context.Current.Request("PageID"))%>);
            }

            function deletePage() {
                dwGlobal.getContentNavigatorWindow().Action.Execute(<%=Me.GetDeletePageAction().ToJson()%>);
            }

            function newSubpage() {
                <%
            Dim act As Dynamicweb.Core.UI.Actions.Action = Me.GetCreatePageAction()
            If Not IsNothing(act) Then
                %>
                    dwGlobal.getContentNavigatorWindow().Action.Execute(<%=act.ToJson()%>);
                <%
            End If
                %>
            }

            function openContentRestrictionDialog() {
                var p = <%=Me.TargetPage.ID%>;
                var marketing = <%=marketConfig.ClientInstanceName%>;
                marketing.openSettings('ContentRestriction', { data: { ItemType: 'Page', ItemID: p } });
            }

            function openProfileDynamicsDialog() {
                var marketing = <%=marketConfig.ClientInstanceName%>;
                marketing.openSettings('ProfileDynamics', { data: { ItemType: 'Page', ItemID: <%=Me.TargetPage.ID%> } });
            }

            function profileVisitPreview() {
                window.open("/Admin/Module/Omc/Profiles/PreviewProfile.aspx?PageID=" + <%=Me.TargetPage.ID%> + "&original=" + encodeURIComponent(document.getElementById("previewUrl").value), "_blank", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no");
            }

            function EmailPreviewShow() {
                window.open("/Admin/Content/PreviewCombined.aspx?PageID=" + <%=Me.TargetPage.ID%> + "&original=" + encodeURIComponent(document.getElementById("showUrl").value) + "&emailPrewiew=true", "_blank", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no");
            }
        
            function showWebPageAnalysisDialog() {
                dialog.show("WebPageAnalysisDialog", "/Admin/Content/PageTemplates/Reports/PagePerformanceReport.aspx?PageID=<%=Me.TargetPage.ID%>");
            }

            function showOMCPersonalizationDialog() {
                dialog.show('OMCPersonalizationDialog', '/Admin/Module/OMC/Emails/EmailPersonalization.aspx?pageID=<%=TargetPage.ID%>');
            }

            $(document).observe('keydown', function (e) {
                if (e.keyCode == 13) {
                    var srcElement = e.srcElement ? e.srcElement : e.target;
                    if (srcElement.type != 'textarea') {
                        e.preventDefault();
                        Dynamicweb.Items.ItemEdit.get_current().save();
                    }
                }
            });

            window.document.observe('General:DocumentOnSave', (function (event) {                
                document.getElementById("save").value = "True";                
            }));
        </script>
    </head>
    <body class="screen-container">
        <div class="card">
            <form id="MainForm" enableviewstate="false" runat="server">
                <input type="hidden" runat="server" id="previewUrl" />
                <input type="hidden" runat="server" id="showUrl" />
                <dw:Overlay ID="PleaseWait" runat="server" />

                <input type="hidden" id="hClose" name="Close" value="False" />
                <input type="hidden" id="save" name="save" value="False" />

                <dw:RibbonBar runat="server" ID="myribbon">
                        <dw:RibbonBarTab Name="Content" runat="server">                            
                            <dw:RibbonBarGroup runat="server" ID="toolsGroup" Name="Funktioner" Visible="true">
                                <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().save();" ID="cmdSave" ShowWait="false" KeyboardShortcut="ctrl+s">
                                </dw:RibbonBarButton>
                                <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().saveAndClose();" ID="cmdSaveAndClose" ShowWait="false" >
                                </dw:RibbonBarButton>
                                <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().cancel();" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                                </dw:RibbonBarButton>
                            </dw:RibbonBarGroup>

				            <dw:RibbonbarGroup ID="groupView" Name="Content" runat="server">
				                <dw:RibbonbarRadioButton ID="cmdViewItem" Group="GroupView" Size="Large" Icon="Cube" Text="Page"  Checked="true" runat="server" />
				                <dw:RibbonbarRadioButton ID="cmdViewParagraphs" Group="GroupView" Size="Large" Icon="FileTexto" Text="Paragraphs" runat="server" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().switchToParagraphs();" />                                
				            </dw:RibbonbarGroup>

                            <dw:RibbonbarGroup Name="Show" runat="server">
                                <dw:RibbonbarButton ID="cmdPageView" Text="Show page" Icon="PageView" Size="Large" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().showItem();" runat="server" />
                            </dw:RibbonbarGroup>

                            <dw:RibbonBarGroup Name="Publicering" runat="server">
					            <dw:RibbonBarRadioButton ID="cmdPublished" Checked="false" Group="Publishing" Text="Publiceret" Icon="Check" Value="0" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().setPagePublished('published');" runat="server" />
					            <dw:RibbonBarRadioButton ID="cmdHideInNavigation" Checked="false" Group="Publishing" Text="Hide in menu" Icon="EyeSlash" Value="2" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().setPagePublished('hideInMenu');" runat="server" />
					            <dw:RibbonBarRadioButton ID="cmdHidden" Checked="false" Group="Publishing" Text="Unpublished" Icon="Close" Value="1" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().setPagePublished('unpublished');" runat="server" />
                                <dw:RibbonbarRadioButton ID="cmdEdit" runat="server" Size="small" Text="Frontend editering" Icon="Edit" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().openFrontendEditing();" />
                            </dw:RibbonBarGroup>

                            <dw:RibbonBarGroup runat="server" Name="Side">
					            <dw:RibbonbarButton ID="cmdPageProperties" Size="large" Text="Egenskaber" Icon="InfoOutline" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().pageProperties();" runat="server" />					            
				            </dw:RibbonbarGroup>

                            <dw:RibbonbarGroup ID="PrimaryLanugageSelectorGrp" runat="server" Name="Sprog" Visible="false">
					            <dw:RibbonBarButton ID="languageSelector" runat="server" Active="false" ImagePath="/Admin/Images/Flags/flag_dk.png" Disabled="false" Size="Large" Text="Sprog" ContextMenuId="languageSelectorContext"></dw:RibbonBarButton>
				            </dw:RibbonbarGroup>

                            <dw:RibbonbarGroup Name="Help" runat="server">
					            <dw:RibbonbarButton ID="cmdHelp" Text="Help" Icon="Help" Size="Large" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().help();" runat="server" />
				            </dw:RibbonbarGroup>
                        </dw:RibbonBarTab>
                        <dw:RibbonBarTab Name="Funktioner" runat="server">
                            <dw:RibbonBarGroup ID="grpPreview" runat="server" Name="Preview">
                                <dw:RibbonBarButton runat="server" ID="PreviewPage" Text="Preview" Icon="OpenInNew" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().previewItem();"></dw:RibbonBarButton>
                            </dw:RibbonBarGroup>

                            <dw:RibbonbarGroup runat="server" Name="Tools">
					            <dw:RibbonbarButton runat="server" Size="small" Text="Metadata" ImagePath="/Admin/Images/Ribbon/Icons/Small/TextCode.png" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().pageMetadata();" Visible="false" />
                                <dw:RibbonbarButton ID="cmdSaveAsTemplate" runat="server" Size="small" Text="Save as template" Icon="File" OnClientClick="Dynamicweb.Items.ItemEdit.get_current().saveAsTemplate();"></dw:RibbonbarButton>
				            </dw:RibbonbarGroup> 

                            <dw:RibbonbarGroup Name="Rapporter" Visible="true" runat="server">
					            <dw:RibbonbarButton ID="cmdReportPageviews" Size="Small" Text="Sidevisninger" Icon="LineChart" ContextmenuId="ReportPageviewOptions" runat="server" />
				                <dw:RibbonbarButton ID="cmdReportKeywords" Icon="PieChart" Text="Søgeord" Size="small" ContextMenuId="ReportSearchEnginePhrasesOptions" runat="server" />
				                <dw:RibbonbarButton ID="cmdReportSearchEngines" Icon="LineChart" Text="Referers fra søgemaskiner" Size="small" ContextMenuId="ReportSearchEngineOptions" runat="server" />
					            <dw:RibbonbarButton ID="cmdReportTraffic" Size="small" Text="Traffic" Icon="BarChart" OnClientClick="report('Traffic');" runat="server" />
				                <dw:RibbonbarButton ID="cmdReportPagePerformancec" Size="small" Text="Page performance" Icon="File" OnClientClick="report('PagePerformance');" runat="server" />
				                <dw:RibbonbarButton ID="cmdWebPageAnalysis" Size="small" Text="Webpage Analysis" Icon="Sliders" runat="server" OnClientClick="showWebPageAnalysisDialog();"/>
				            </dw:RibbonbarGroup>
                        </dw:RibbonBarTab>

                        <dw:RibbonBarTab ID="WorkflowTab" Active="false" Name="Workflow" runat="server">
                            <dw:RibbonBarGroup ID="workflowGroup" runat="server" Name="Workflow" Visible="True">
                                <dw:RibbonBarCheckbox ID="cmdUseDraft" runat="server" Checked="false" Text="Use draft" Icon="FileTextO" OnClientClick="Dynamicweb.Items.VersionControl.get_current().useDraft();"></dw:RibbonBarCheckbox>
                                <dw:RibbonBarButton ID="cmdShowDraft" runat="server" Size="Small" Text="Vis kladde" Icon="Search" OnClientClick="Dynamicweb.Items.VersionControl.get_current().previewPage();"></dw:RibbonBarButton>
                                <dw:RibbonBarButton ID="cmdCompare" runat="server" Size="Small" Text="Compare" Icon="Exchange" OnClientClick="Dynamicweb.Items.VersionControl.get_current().previewComparePage();"></dw:RibbonBarButton>
                                <dw:RibbonBarButton ID="cmdPublish" runat="server" Size="Small" Text="Approve" Icon="File" OnClientClick="Dynamicweb.Items.VersionControl.get_current().startWorkflow(true);"></dw:RibbonBarButton>
                                <dw:RibbonBarButton ID="cmdDiscardChanges" runat="server" Size="Small" Text="Discard changes" Icon="ExitToApp" OnClientClick="Dynamicweb.Items.VersionControl.get_current().discardChanges();"></dw:RibbonBarButton>
                                <dw:RibbonBarButton ID="cmdStartWorkflow" ModuleSystemName="Workflow" runat="server" Size="Small" Text="Start godkendelse" Icon="PlayCircleO" OnClientClick="Dynamicweb.Items.VersionControl.get_current().startWorkflow(false);"></dw:RibbonBarButton>
                                <dw:RibbonBarButton ID="cmdShowPreviousVersions" ModuleSystemName="VersionControl" runat="server" Size="Small" Text="Tidligere versioner" Icon="History" OnClientClick="Dynamicweb.Items.VersionControl.get_current().previewBydateShow(false);"></dw:RibbonBarButton>
                                <dw:RibbonBarButton ID="Versions" runat="server" ModuleSystemName="VersionControl" Size="Small" Icon="File" Text="Versions" Visible="true" OnClientClick="Dynamicweb.Items.VersionControl.get_current().ShowVersions(VersionUrl);"></dw:RibbonBarButton>
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
                            <dw:RibbonBarGroup ID="RibbonBarGroup15" Name="Personalization" runat="server">
                                <dw:RibbonBarButton ID="RibbonbarButton15" Text="Personalize page" Size="Small" Icon="Star" OnClientClick="openContentRestrictionDialog();" runat="server" />
                                <dw:RibbonBarButton ID="RibbonbarButton16" Text="Add profile points" Size="Small" Icon="PersonAdd" OnClientClick="openProfileDynamicsDialog();" runat="server" />
                                <dw:RibbonBarButton ID="cmdPreviewProfileVisit" Text="Preview page" Size="Small" Icon="OpenInNew" OnClientClick="profileVisitPreview();" runat="server" />
                                <dw:RibbonBarButton ID="PersonalizationShow" Text="Email Personalization" Size="Small" Icon="Star" OnClientClick="showOMCPersonalizationDialog();" Visible="false" runat="server" /> <%--ToDo: Remove may be?--%>
                                <dw:RibbonBarButton ID="EmailPreview" Text="Email Preview" Size="Small" Icon="OpenInNew" OnClientClick="EmailPreviewShow();" Visible="false" runat="server" />
                            </dw:RibbonBarGroup>
                        </dw:RibbonBarTab>
                    </dw:RibbonBar>
            
                <dw:PageBreadcrumb ID="BreadcrumbControl" runat="server" />

                <div id="content-item">
                    <asp:Literal ID="litFields" runat="server" />
                </div>

                <dw:Infobar runat="server" ID="unpublishedContentInfo" Type="Information" Message="This page has unpublished changes" Title="Publish" Visible="false" OnClientClick="Ribbon.checkBox('cmdUseDraft');Dynamicweb.Items.VersionControl.get_current().useDraft();//startWorkflow(false);">
                </dw:Infobar>          
            </form>
        </div>
         <div class="card-footer">
            <table border="0">
                <tr>
                    <td>
                        <dw:TranslateLabel Text="Name" runat="server" />:
                    </td>
                    <td class="value"><b><%=TargetPage.MenuText%></b></td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel Text="Item type" runat="server" />:
                    </td>
                    <td class="value"><%=TargetItemMeta.Name%></td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel Text="ID" runat="server" />:
                    </td>
                    <td class="value"><%=String.Format("{0} ({1})", TargetPage.ID, If(IsNothing(TargetItem), "0", TargetItem.Id))%></td>
                </tr>
            </table>
            <table border="0">
                <tr>
                    <td>
                        <dw:TranslateLabel Text="Created" runat="server" />:
                    </td>
                    <td class="value"><%=TargetPage.Audit.CreatedAt.ToString("ddd, dd MMM yyyy HH':'mm", Dynamicweb.Environment.ExecutingContext.GetCulture())%></td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel Text="Edited" runat="server" />:
                    </td>
                    <td class="value"><%=TargetPage.Audit.LastModifiedAt.ToString("ddd, dd MMM yyyy HH':'mm", Dynamicweb.Environment.ExecutingContext.GetCulture())%></td>
                </tr>
            </table>
            <table border="0">
                <tr>
                    <td>
                        <dw:TranslateLabel Text="Template" runat="server" />:
                    </td>
                    <td class="value"><%=TargetItemLayout%></td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel Text="URL" runat="server" />:
                    </td>
                    <td class="value"><%=GetPageUrl()%></td>
                </tr>
            </table>             
            <%If Not String.IsNullOrEmpty(_profile.InnerText) Then%>
                <table border="0">
                    <tr>
                        <td colspan="2">
                            <b><dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Dispaly of the page is dependant on OMC profile" />:</b>
                            <span class="value" id="_profile" runat="server"></span>
                        </td>
                    </tr>
                </table>
            <%End If%>
        </div>
        
        <dw:Dialog ID="WebPageAnalysisDialog" runat="server" Title="Report" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" >
            <iframe id="WebPageAnalysisDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>
        
        <dw:Dialog ID="ReportsDialog" runat="server" Title="Report" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" >
            <iframe id="ReportsDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>
        
        <dw:Dialog ID="CreateMessageDialog" runat="server" Title="Publish page to social media" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" >
            <iframe id="CreateMessageDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <dw:Dialog ID="MetaDialog" Width="518" runat="server" Title="Metadata" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" CancelAction="Dynamicweb.Items.ItemEdit.get_current().pageMetadataClose();" OkAction="Dynamicweb.Items.ItemEdit.get_current().pageMetadataSave();">
		    <table border="0">
			    <tr>
				    <td width="170" valign="top">
					    <dw:TranslateLabel Text="Titel" runat="server" />
				    </td>
				    <td valign="top">
					    <input type="text" id="PageDublincoreTitle" name="PageDublincoreTitle" size="30" class="NewUIinput" runat="server" style="width: 300px; margin-bottom:1px;" 
                            onfocus="ShowCounters(this,'PageDublincoreTitleCounter','PageDublincoreTitleCounterMax');" 
					        onkeyup="CheckCounter(this,'PageDublincoreTitleCounter','PageDublincoreTitleCounterMax');"  
                            onblur="CheckAndHideCounter(this,'PageDublincoreTitleCounter','PageDublincoreTitleCounterMax');"
                        />
				    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
				        <strong id="PageDublincoreTitleCounter" class="char-counter">&nbsp;</strong>
				        <input type="hidden" id="PageDublincoreTitleCounterMax" name="PageDublincoreTitleCounterMax" runat="server"/>
                        <div>&nbsp;</div>
			        </td>
                </tr>
			    <tr>
				    <td valign="top">
					    <dw:TranslateLabel runat="server" Text="Beskrivelse" />
				    </td>
				    <td valign="top">
					    <textarea id="PageDescription" name="PageDescription" cols="30" rows="3" wrap="on" style="width: 300px; height: 60px;" runat="server"
					        onfocus="ShowCounters(this,'PageDescriptionCounter','PageDescriptionCounterMax');" 
					        onkeyup="CheckCounter(this,'PageDescriptionCounter','PageDescriptionCounterMax');"  
					        onblur="CheckAndHideCounter(this,'PageDescriptionCounter','PageDescriptionCounterMax');"
					    ></textarea>
				    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
				        <strong id="PageDescriptionCounter" class="char-counter">&nbsp;</strong>
				        <input type="hidden" id="PageDescriptionCounterMax" name="PageDescriptionCounterMax" runat="server"/>
                        <div>&nbsp;</div>
			        </td>
                </tr>
			    <tr>
				    <td valign="top">
					    <dw:TranslateLabel runat="server" Text="Nøgleord" />
				    </td>
				    <td valign="top">
					    <textarea id="PageKeywords" name="PageKeywords" cols="30" rows="3" wrap="on" style="width: 300px; height: 60px;margin-bottom:1px;" runat="server"
                            onfocus="ShowCounters(this,'PageKeywordsCounter','PageKeywordsCounterMax');" 
					        onkeyup="CheckCounter(this,'PageKeywordsCounter','PageKeywordsCounterMax');"  
					        onblur="CheckAndHideCounter(this,'PageKeywordsCounter','PageKeywordsCounterMax');"
                        ></textarea>
				    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
					    <strong id="PageKeywordsCounter" class="char-counter">&nbsp;</strong>
					    <input type="hidden" id="PageKeywordsCounterMax" name="PageKeywordsCounterMax" runat="server"/>
                        <div>&nbsp;</div>
				    </td>
                </tr>
		    </table>
	    </dw:Dialog>

	    <dw:Dialog ID="SaveAsTemplateDialog" runat="server" Title="Save as template" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" CancelAction="Dynamicweb.Items.ItemEdit.get_current().SaveAsTemplateCancel();" OkAction="Dynamicweb.Items.ItemEdit.get_current().SaveAsTemplateOk();">
		<table border="0" style="width:350px;">
			<tr>
				<td style="width:100px;"><dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Navn" /></td>
				<td><input type="text" runat="server" id="TemplateName" name="TemplateName" class="NewUIinput" maxlength="255" />
				</td>
			</tr>
			<tr><td style="height:3px;"></td></tr>
			<tr>
				<td><dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Beskrivelse" /></td>
				<td><input type="text" runat="server" id="TemplateDescription" name="TemplateDescription" class="NewUIinput" maxlength="255" />
				</td>
			</tr>
			<tr><td style="height:3px;"></td></tr>
			<tr id="isTemplateRow" runat="server" visible="false">
				<td></td>
				<td>
					<dw:CheckBox ID="isTemplate" runat="server" Value="1" SelectedFieldValue="1" />
					<label for="isTemplate">
						<dw:TranslateLabel ID="TranslateLabel11" runat="server" Text="Aktiv" />
					</label>
				</td>
			</tr>
		</table>
		<br />
		<br />
	</dw:Dialog>

        <dw:Dialog ID="QuitDraftDialog" runat="server" Title="Quit draft" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" CancelAction="Dynamicweb.Items.VersionControl.get_current().quitDraftCancel();" OkAction="Dynamicweb.Items.VersionControl.get_current().quitDraftOk();">
            <img src="/Admin/Images/Ribbon/Icons/warning.png" alt="" style="vertical-align: middle;" />
            <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="This page has unpublished content. What do you want to do?" />
            <br />
            <br />
            <table border="0" style="width: 150px;">
                <tr>
                    <td>
                        <dw:RadioButton ID="QuitDraftPublish" runat="server" FieldName="QuitDraft" FieldValue="Publish" SelectedFieldValue="Publish" />
                    </td>
                    <td>
                        <img src="/Admin/Images/Ribbon/Icons/Small/document_ok.png" alt="" style="vertical-align: middle;" /></td>
                    <td>
                        <label for="QuitDraftPublish">
                            <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Publish" />
                        </label>
                    </td>
                </tr>
                <tr>
                    <td style="height: 3px;"></td>
                </tr>
                <tr>
                    <td>
                        <dw:RadioButton ID="QuitDraftDiscard" runat="server" FieldName="QuitDraft" FieldValue="Discard" />
                    </td>
                    <td>
                        <img src="/Admin/Images/Ribbon/Icons/Small/door.png" alt="" style="vertical-align: middle;" /></td>
                    <td>
                        <label for="QuitDraftDiscard">
                            <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Discard changes" />
                        </label>
                    </td>
                </tr>
            </table>

            <br />

            <br />
        </dw:Dialog>

        <dw:Dialog ID="PreviewByDateDialog" runat="server" Title="Show previous version" ShowCancelButton="true" ShowOkButton="true" ShowClose="true" OkAction="Dynamicweb.Items.VersionControl.get_current().previewBydate();">
            <table border="0" style="width: 450px;">
                <tr>
                    <td>
                        <dw:TranslateLabel ID="TranslateLabel15" runat="server" Text="Dato" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <dw:DateSelector ID="DateSelector1" runat="server" AllowNeverExpire="false" AllowNotSet="false" />
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </dw:Dialog>

        <dw:Dialog ID="VersionsDialog" runat="server" Title="Versioner" HidePadding="true" Width="600">
            <iframe id="VersionsDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <omc:MarketingConfiguration ID="marketConfig" runat="server" />

        <script type="text/javascript">
            var VersionUrl = '/Admin/Content/ParagraphVersions.aspx?PageID=<%=Me.TargetPage.ID%>';
        </script>

        <dw:ContextMenu ID="ReportPageviewOptions" runat="server">
		    <dw:ContextMenuButton Divide="None" Icon="LineChart" Text="Dag" OnClientClick="report('PageviewsDay');" runat="server" />
		    <dw:ContextMenuButton Divide="None" Icon="LineChart" Text="Uge" OnClientClick="report('PageviewsWeek');" runat="server" />
		    <dw:ContextMenuButton Divide="None" Icon="LineChart" Text="Måned" OnClientClick="report('PageviewsMonth');" runat="server" />
	    </dw:ContextMenu>

	    <dw:ContextMenu ID="ReportSearchEnginePhrasesOptions" runat="server">
		    <dw:ContextMenuButton Divide="None" Icon="PieChart" Text="Phrases" OnClientClick="report('SearchEnginePhrases');" runat="server" />
		    <dw:ContextMenuButton Divide="None" Icon="PieChart" Text="Keywords" OnClientClick="report('SearchEngineKeywords');" runat="server" />
		    <dw:ContextMenuButton Divide="None" Icon="PieChart" Text="Words per phrase" OnClientClick="report('SearchEnginePhraseWordCount');" runat="server" />
	    </dw:ContextMenu>

	    <dw:ContextMenu ID="ReportSearchEngineOptions" runat="server">
		    <dw:ContextMenuButton Divide="None" Icon="BarChart" Text="Top 5 referrers" OnClientClick="report('SearchEngineReferrers');" runat="server" />
		    <dw:ContextMenuButton Divide="None" Icon="BarChart" Text="All referrals" OnClientClick="report('SearchEngineAllReferrals');" runat="server" />
		    <dw:ContextMenuButton Divide="None" Icon="BarChart" Text="Top 5 crawlers" OnClientClick="report('SearchEngineBotIndex');" runat="server" />
		    <dw:ContextMenuButton Divide="None" Icon="BarChart" Text="Indexations over time" OnClientClick="report('SearchEngineIndexTime');" runat="server" />
	    </dw:ContextMenu>

	    <dw:ContextMenu ID="languageSelectorContext" runat="server" MaxHeight="400">
		
	    </dw:ContextMenu>

        <%Translate.GetEditOnlineScript()%>
        <dw:Dialog ID="OMCExperimentDialog" runat="server" Width="750" ShowOkButton="false" ShowCancelButton="false" HidePadding="True" Title="Setup split test">
            <iframe id="OMCExperimentDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <%--ToDo: Remove may be?--%>
        <dw:Dialog ID="OMCPersonalizationDialog" runat="server" Title="Email Personalization" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" >
            <iframe id="OMCPersonalizationDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>
    </body>
</html>
