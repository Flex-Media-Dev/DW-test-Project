<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Setup.aspx.vb" Inherits="Dynamicweb.Admin.Setup" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true"
        IncludePrototype="false" />
    <link rel="StyleSheet" href="Setup.css" type="text/css" />
    <script type="text/javascript" src="Setup.js"></script>
    <title></title>
</head>
<body>
    <div runat="server" id="closeJs" visible="false">
        <script type="text/javascript">
            close();
        </script>
    </div>

    <form id="experimentSetupForm" method="post" action="Setup.aspx">
        <input type="hidden" runat="server" id="ExperimentType" name="ExperimentType" />
        <input type="hidden" runat="server" id="ExperimentID" name="ExperimentID" />
        <input type="hidden" runat="server" id="StepName" name="StepName" value="" />
        <input type="hidden" runat="server" id="id" name="id" />

        <!-- step 1 -->
        <div id="step1ChooseType" class="step" style="display: none;">
            <div class="step__content step__content--without-footer">
                <dwc:GroupBox runat="server" Title="Select split test type">
                    <div runat="server" id="ContentBasedTestOption" class="option" onclick="setType(2);">
                        <b><%= Translate.Translate("Content based split test")%></b>
                        <ul>
                            <li><%= Translate.Translate("Test different versions of paragraphs against each other.")%></li>
                            <li><%= Translate.Translate("Use this split test if you want to test different design elements such as buttons.")%></li>
                            <li><%= Translate.Translate("Use this split test if you want to test different texts and images.")%></li>
                            <li><%= Translate.Translate("Copies paragraphs in different version that can be differentiated.")%></li>
                        </ul>
                    </div>
                    <div class="option" onclick="setType(1);">
                        <b><%= Translate.Translate("Page based split test")%></b>
                        <ul>
                            <li><%= Translate.Translate("Test two different pages against each other.")%></li>
                            <li><%= Translate.Translate("Use this split test if you want to test different layouts.")%></li>
                            <li><%= Translate.Translate("Select another page to test against this one.")%></li>
                        </ul>
                    </div>
                </dwc:GroupBox>
            </div>
        </div>

        <!-- step 2 -->
        <div id="step2ChooseAlternatePage" class="step" style="display: none;">
            <div class="step__content" onclick="observerAlternateLink();">
                <dwc:GroupBox runat="server" Title="Alternate page">
                    <div class="form-group">
                        <label class="control-label"><%= Translate.Translate("Page that will be shown as alternative")%></label>
                        <dw:LinkManager ID="ExperimentAlternatePage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" />
                    </div>
                </dwc:GroupBox>
            </div>
            <footer>
                <input type="button" class="btn" value="<%= Translate.Translate("Previous")%>" onclick="showStep('step1ChooseType');" />
                <input type="button" class="btn" value="<%= Translate.Translate("Next")%>" id="step2ChooseAlternatePageforwardButton" disabled="disabled" onclick="showStep('step3ChooseGoal');" />
            </footer>
        </div>

        <!-- step 3 -->
        <div id="step3ChooseGoal" class="step" style="display: none;">
            <div class="step__content">
                <dwc:GroupBox runat="server" Title="Conversion goal">
                    <ul class="list--clean" id="goalsList">
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypePage" FieldValue="Page" runat="server" Label="Choose another page as conversion page" OnClick="showContent('inputAlternativePage');" Name="ExperimentGoalType" />
                            <div class="m-l-25 hidden-content" id="inputAlternativePage">
                                <dw:LinkManager ID="ExperimentGoalTypePageValue" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" />
                            </div>
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeItem" FieldValue="Item" runat="server" Label="Create an item" OnClick="showContent('inputItemType');" Name="ExperimentGoalType" />
                            <div class="m-l-25 hidden-content" id="inputItemType">
                                <dw:Richselect ID="ItemTypeSelect" runat="server" Height="60" Itemheight="60" Width="300" Itemwidth="300">
                                </dw:Richselect>
                            </div>
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeForm" FieldValue="Form" runat="server" Label="Submitting af form from the forms module" OnClick="showContent('inputForm');" Name="ExperimentGoalType" />
                            <div class="m-l-25 hidden-content" id="inputForm">
                                <select name="ExperimentGoalTypeFormValue" id="ExperimentGoalTypeFormValue" class="std">
                                    <asp:Literal ID="FormList" runat="server"></asp:Literal>
                                </select>
                            </div>
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeCart" FieldValue="Cart" runat="server" Label="Adding products to cart" OnClick="showContent();" Name="ExperimentGoalType" />
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeOrder" FieldValue="Order" runat="server" Label="Placing an order" OnClick="showContent();" Name="ExperimentGoalType" />
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeFile" FieldValue="File" runat="server" Label="Downloading a file" OnClick="showContent('inputDownloadFile');" Name="ExperimentGoalType" />
                            <div class="m-l-25 hidden-content p-b-10" id="inputDownloadFile">
                                <dw:FileManager ID="ExperimentGoalTypeFileValue" runat="server" Folder="Files" />
                                <small class="help-block"><%= Translate.Translate("(Must be in /Files/")%><%= Dynamicweb.Content.Files.FilesAndFolders.GetFilesFolderName()%>
                                    <%= Translate.Translate("folder)")%></small>
                            </div>
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeNewsletter" FieldValue="Newsletter" runat="server" Label="Signing up for newsletter" OnClick="showContent();" Name="ExperimentGoalType" />
                        </li>
                        <li id="customProviderContentItem" runat="server" style="display: none;">
                            <div id="customProviderContent" runat="server" visible="false">
                                <dwc:RadioButton ID="CustomGoalProvider" FieldValue="CustomGoalProviderType" runat="server" Label="Custom providers" OnClick="showContent('inputCustomGoalProvider');" Name="ExperimentGoalType" />
                                <div class="m-l-25 hidden-content" id="inputCustomGoalProvider">
                                    <asp:Literal ID="sourceSelectorScripts" runat="server"></asp:Literal>
                                    <de:AddInSelector ID="sourceSelector" runat="server" ShowOnlySelectedGroup="true"
                                        AddInGroupName="ConversionGoalProvider" UseLabelAsName="True" AddInShowNothingSelected="true"
                                        AddInTypeName="Dynamicweb.Analytics.Goals.ConversionGoalProvider" AddInShowFieldset="false" />
                                    <asp:Literal ID="sourceSelectorLoadScript" runat="server"></asp:Literal>
                                </div>
                            </div>
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeTimespent" FieldValue="Timespent" runat="server" Label="Maximize time spent on site" OnClick="showContent();" Name="ExperimentGoalType" />
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeHighestAverageValueOrder" FieldValue="HighestAverageValueOrder" Label="Highest average order value" runat="server" OnClick="showContent();" Name="ExperimentGoalType" />
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeHighestAverageMarkupOrder" FieldValue="HighestAverageMarkupOrder" Label="Highest average markup order" runat="server" OnClick="showContent();" Name="ExperimentGoalType" />
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypeBounce" FieldValue="Bounce" Label="Minimize bounce rate" runat="server" OnClick="showContent();" Name="ExperimentGoalType" />
                        </li>
                        <li>
                            <dwc:RadioButton ID="ExperimentGoalTypePageviews" FieldValue="Pageviews" Label="Maximize page views" runat="server" OnClick="showContent();" Name="ExperimentGoalType" />
                        </li>
                    </ul>
                </dwc:GroupBox>
            </div>
            <footer>
                <input type="button" class="btn" value="<%= Translate.Translate("Previous")%>" onclick="showStep('step1ChooseType');" />
                <input type="submit" class="btn" value="" id="step3ChooseGoalNext" disabled="disabled" onclick="return verifyGoal();" runat="server" />
            </footer>
        </div>

        <!-- step 4 -->
        <div id="step4Settings" class="step" style="display: none;">
            <div class="step__content" onclick="observerAlternateLink();">
                <dwc:GroupBox runat="server" Title="Settings">
                    <dwc:InputText runat="server" ID="ExperimentName" Name="ExperimentName" Label="Split test name"></dwc:InputText>
                
                    <input type="hidden" runat="server" id="ExperimentGoalTypeFormValueHidden" name="ExperimentGoalTypeFormValueHidden" />
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Split test type")%></label>
                        <div class="form-group-input"><label id="TranslatelabelType" runat="server"></label></div>
                    </div>

                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Conversion goal")%></label>
                        <div class="form-group-input"><label id="TranslatelabelGoal" runat="server"></label></div>
                    </div>
                    
                    <dwc:CheckBox runat="server" Label="Enable" Header="Active" Value="True" ID="ExperimentActive" Name="ExperimentActive" />

                    <dwc:RadioGroup runat="server" Name="ExperimentConversionMetric" Label="Conversion metrics">
                        <dwc:RadioButton runat="server" ID="ExperimentConversionMetric1200" FieldValue="1200" Label="Register conversion through entire visit" />
                        <dwc:RadioButton runat="server" ID="ExperimentConversionMetric0" FieldValue="0" Label="Register conversion in next step only" />
                    </dwc:RadioGroup>
                </dwc:GroupBox>
    
                <dwc:GroupBox runat="server" Title="Traffic sent through this split test">
                    <dwc:RadioGroup runat="server" Name="ExperimentIncludes" Label="Visitors to include">
                        <dwc:RadioButton runat="server" ID="ExperimentIncludes100" FieldValue="100" Label="100" />
                        <dwc:RadioButton runat="server" ID="ExperimentIncludes75" FieldValue="75" Label="75" />
                        <dwc:RadioButton runat="server" ID="ExperimentIncludes50" FieldValue="50" Label="50" />
                        <dwc:RadioButton runat="server" ID="ExperimentIncludes25" FieldValue="25" Label="25" />
                        <dwc:RadioButton runat="server" ID="ExperimentIncludes10" FieldValue="10" Label="10" />
                    </dwc:RadioGroup>

                    <ul style="display: none;">
                        <!--Not implemented yet - does it make sense?-->
                        <li><b><%= Translate.Translate("Subsequent visiting behavior")%></b></li>
                        <li>
                            <dw:RadioButton ID="ExperimentPatternSticky" FieldName="ExperimentPattern" FieldValue="1"
                                runat="server" />
                            <label for="ExperimentPattern1">
                                <%= Translate.Translate("Sticky")%></label><br />
                            <dw:RadioButton ID="ExperimentPatternRandom" FieldName="ExperimentPattern" FieldValue="2"
                                runat="server" />
                            <label for="ExperimentPattern2">
                                <%= Translate.Translate("Random")%></label>
                        </li>
                    </ul>
                    <div id="ShowToSearchEngineBotsSettings">
                        <dwc:RadioGroup runat="server" Name="ExperimentShowToBots" Label="Show to search engine bots">
                            <dwc:RadioButton runat="server" ID="ExperimentShowToBots1" FieldValue="0" Label="Show original to search engines" />
                            <dwc:RadioButton runat="server" ID="ExperimentShowToBots0" FieldValue="1" Label="Show all versions to search engines" />
                        </dwc:RadioGroup>
                    </div>
                </dwc:GroupBox>
            </div>

            <footer>
                <input type="button" class="btn" value="" id="SettingsPreviousBtn" runat="server" onclick="showStep('step3ChooseGoal');" />
                <input type="button" class="btn" value="" id="SettingNextBtn" disabled="disabled" runat="server" onclick="showStep('step5ExperimentEnding');" />
            </footer>
        </div>

        <!-- step 5 -->

        <div id="step5ExperimentEnding" class="step" style="display: none;">
            <div class="step__content">
                <dwc:GroupBox runat="server" Title="End split test">
                    <dwc:RadioGroup runat="server" Name="ExperimentEndingType" Label="End split test">
                        <dwc:RadioButton ID="ExperimentEndingTypeManually" FieldValue="1" runat="server" OnClick="showEndingTypeParams('divActionAndNotification');" Label="Manually" />
                        <dwc:RadioButton ID="ExperimentEndingTypeAtGivenTime" FieldValue="2" runat="server" OnClick="showEndingTypeParams('divAtGivenTime');" Label="At given time" />
                        <dwc:RadioButton ID="ExperimentEndingTypeAfterXViews" FieldValue="3" runat="server" OnClick="showEndingTypeParams('divAfterXViews');" Label="After x views"  />
                        <dwc:RadioButton ID="ExperimentEndingTypeIsSignificant" FieldValue="4" runat="server" OnClick="showEndingTypeParams();" Label="When result is significant" />
                    </dwc:RadioGroup>
                    
                    <div id="divAtGivenTime" style="display: none;">
                        <div class="form-group">
                            <label class="control-label"><%=Translate.Translate("End date")%></label>
                            <dw:DateSelector ID="sdEndDate" runat="server" IncludeTime="True" />
                        </div>
                        <div class="form-group">
                            <label class="control-label"><%=Translate.Translate("Time zone")%></label>
                            <select name="ExperimentEndingTypeTimeZone" id="SelectExperimentEndingTypeTimeZone" class="std">
                                <asp:Literal ID="LiteralTimeZone" runat="server"></asp:Literal>
                            </select>
                        </div>
                    </div>
                    <div id="divAfterXViews" style="display: none;">
                        <div class="form-group">
                            <label class="control-label"><%=Translate.Translate("Views amount")%></label>
                            <div class="form-group-input">
                                <omc:NumberSelector ID="endViewsAmount" AllowNegativeValues="false" MinValue="1" MaxValue="1000000" runat="server" />
                            </div>
                        </div>
                    </div>
                </dwc:GroupBox>
                <div id="divActionAndNotification" style="display: none">
                    <dwc:GroupBox runat="server" Title="Action after split test ends">
                        <dwc:CheckBox Name="DeleteExperiment" Value="True" runat="server" ID="cbDeleteExperiment" Label="Stop experiment" Info="All data on visitors and conversions will be deleted"/>
                        <div id="divKeepVersions">
                            <dwc:RadioGroup runat="server" Name="ExperimentEndingActionType" Label="&nbsp;">
                                <dwc:RadioButton ID="ExperimentEndingActionTypeKeepAll" FieldValue="1" runat="server" Label="Keep all versions with the best performing published" />    
                                <dwc:RadioButton ID="ExperimentEndingActionTypeKeepBestPerforming" FieldValue="2" runat="server" Label="Keep the best performing version and delete the other" />
                            </dwc:RadioGroup>
                        </div>
                        <div class="form-group">
                            <label class="control-label"><%=Translate.Translate("Notification e-mail template:")%></label>
                            <dw:FileManager ID="fmTemplate" runat="server" Folder="Templates/OMC/Notifications" File="EmailExperimentAutoStop.html" />
                        </div>
                        <div class="form-group">
                            <label class="control-label"><%=Translate.Translate("Notify following people:")%></label>
                            <div class="form-group-input">
                                <omc:EditableListBox ID="editNotify" runat="server" />
                            </div>
                        </div>
                    </dwc:GroupBox>
                </div>
            </div>
            <footer>
                <input type="button" class="btn" value="<%= Translate.Translate("Previous")%>" onclick="showStep('step4Settings');" />
                <input type="button" class="btn" value="" id="SaveExperimentBtn" runat="server" onclick="saveExperiment();" />
            </footer>
        </div>
    </form>
    <script type="text/javascript">
        <%= _ErrorMsgJS%>
        var PageBasedSplitTestTranslated = '<%= Translate.Translate("Page based split test.")%>';
        var ContentBasedSplitTestTranslated = '<%= Translate.Translate("Content based split test.")%>';
        var OpenAnotherPageAsConversionPage = '<%= Translate.Translate("Open another page as conversion page")%>';
        var AnyItemType = '<%= Translate.Translate("Any item type")%>';
        var SubmittingAnItemFromTheItemCreatorModule = '<%= Translate.Translate("Create an item")%>';
        var SubmittingAFormFromTheFormsModule = '<%= Translate.Translate("Submitting af form from the forms module")%>';
        var AddingProductsToCart = '<%= Translate.Translate("Adding products to cart")%>';
        var PlacingAnOrder = '<%= Translate.Translate("Placing an order")%>';
        var DownloadingFile = '<%= Translate.Translate("Downloading file")%>';
        var SigningUpForNewsletter = '<%= Translate.Translate("Signing up for newsletter")%>';
        var MaximizeTimeSpentOnSite = '<%= Translate.Translate("Maximize time spent on site")%>';
        var MinimizeBounceRate = '<%= Translate.Translate("Minimize bounce rate")%>';
        var MaximizePageViews = '<%= Translate.Translate("Maximize page views")%>';
        var HighestAverageOrderValueGoalProvider = '<%= Translate.Translate("Highest average order value")%>';
        var HighestAverageMarkupGoalProvider = '<%= Translate.Translate("Highest average markup order")%>';

        validateName();
        if ($('ExperimentEndingType2') && $('ExperimentEndingType2').checked) {
            showEndingTypeParams('divAtGivenTime');
        } else if ($('ExperimentEndingType3') && $('ExperimentEndingType3').checked) {
            showEndingTypeParams('divAfterXViews');
        } else if ($('ExperimentEndingType4') && $('ExperimentEndingType4').checked) {
            showEndingTypeParams();
        }
    </script>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
