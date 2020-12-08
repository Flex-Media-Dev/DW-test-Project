<%@ Page Codebehind="NewsV2_Edit.aspx.vb" Language="vb" ValidateRequest="false" AutoEventWireup="false" Inherits="Dynamicweb.Admin.NewsV2.NewsV2_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="mc" Namespace="Dynamicweb.Admin.ModulesCommon" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.News" %>

<script src="/Admin/Module/NewsV2/Common.js" type="text/javascript"></script>

<script type="text/javascript" src="/admin/module/newsV2/NewsV2_edit.js"></script>

<script type="text/javascript">
function ValidateEmail(obj) 
{
	if(ValidateEmailRegExp(obj.value)==false)
		alert('<%=Translate.JSTranslate("Invalid value in: E-mail address")%>');
}

function CheckCompatibility()
{
    var order = document.getElementById('NewsParagraphOrderByMostPopular')
    var search = document.getElementById('NewsParagraphShowCustom')
    
    if(search.checked && order.checked)
        alert('<%=Translate.JSTranslate("The search is not compatible with the Most Popular sort order.")%>');
}
</script>

<input type="Hidden" name="NewsV2_settings" value="CustomVMUnique, CustomVMRequired, CustomVMIncorrect, NewsParagraphAdminEdit, NewsParagraphAdminEditText, NewsParagraphAdminEditPicture, AdvancedSettingsUse, NewsMostPopularLastDays, NewsParagraphSearchTemplate, NewsSenderEmail, RSSFeedRemoveM, NewsParagraphCategoryID, NewsParagraphShowFrom, NewsParagraphShowArchive, NewsParagraphShowManchet, NewsParagraphShowXCharacters, NewsParagraphReadMore, NewsParagraphReadMoreText, NewsParagraphReadMoreImage, NewsParagraphBackButtonPicture, NewsParagraphBackButtonText, NewsParagraphBackButton, NewsParagraphListTemplate, NewsParagraphDetailTemplate, NewsParagraphSettings, NewsParagraphCustomText, NewsParagraphCustomType, NewsParagraphShowCustom, NewsParagraphCustomButton, NewsParagraphCustomButtonPicture, NewsParagraphCustomButtonText, NewsParagraphShowPersonalize, NewsParagraphPersonalizeButton, NewsParagraphPersonalizeButtonPicture, NewsParagraphPersonalizeButtonText, NewsParagraphSortOrder, NewsParagraphCustomNumberPerList, NewsParagraphPagingButtonPrev, NewsParagraphPagingButtonPrevPicture, NewsParagraphPagingButtonPrevText, NewsParagraphPagingButtonNext, NewsParagraphPagingButtonNextPicture, NewsParagraphPagingButtonNextText, NewsParagraphCustomPagingType, NewsCulture, NewsFunction, NewsSubmitNotifyEmail, NewsSubmitNotify, NewsSubmitApprove, NewsSubmitNotifyTemplate, NewsSubmitFormTemplate, NewsSubmitReceiptPage, NewsApproveReceiptPage, NewsSubmitTemplateID, SNewsParagraphCategoryID, NewsSubmitNotifySubject, NewsParagraphFirstXChars, NewsParagraphOrderBy, NoNewsMessage, CustomFields">
<dw:ModuleHeader ID="headerModule" runat="server" ModuleSystemName="NewsV2" />
<style type="text/css">
    .tdInsButton td{
        margin-left:0px;
        padding-left:0px;
    }
</style>
<tr>
    <td>
        <dw:GroupBoxStart doTranslation="true" runat="server" ID="SettingsStart" Title="Funktion" />
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td class="leftColHigh">
                    &nbsp;
                </td>
                <td>
                    <table cellpadding="2" cellspacing="0">
                        <tr>
                            <td class="leftCol">
                                <table cellspacing="0" cellpadding="0" border="0">
                                    <tr>
                                        <td>
                                            <label>
                                                <%=Dynamicweb.News.Standard.RadioButton(prop.Value("NewsFunction"), "NewsFunction", "ShowNews", "onclick='ToggleCreate()'")%>
                                                <dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Nyhedsliste" />
                                            </label>    
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <nobr>
                                                <span id="ModeCreateNews" runat="server">
                                                    <label>
                                                        <%=Dynamicweb.News.Standard.RadioButton(prop.Value("NewsFunction"), "NewsFunction", "CreateNews", "onclick='ToggleCreate()'")%>
                                                        <dw:TranslateLabel ID="TranslateLabel11" runat="server" Text="Frontend_editering" />
                                                    </label>
                                                    <span id="ModeCreateNewsRequired" visible="false" runat="server" />
                                                </span>    
                                            </nobr>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <dw:GroupBoxEnd ID="SettingsEnd" runat="server" />
        <div id="SubmitNewsShow" runat="server">
            <fieldset>
                <legend class="gbTitle">
                    <dw:TranslateLabel ID="lbFrontendEditing" Text="Frontend_editering" runat="server" />
                    <span id="SubmitNewsShowRequired" runat="server" visible="false" />
                </legend>
                <table cellpadding="2" cellspacing="0">
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Add to category" />
                        </td>
                        <td valign="top">
                            <select name="SNewsParagraphCategoryID" class="std">
                                <%=CategoriesSelectItems()%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftCol">
                            <dw:TranslateLabel runat="server" Text="Form Template" />
                        </td>
                        <td>
                            <%=Dynamicweb.SystemTools.Gui.FileManager(prop.Value("NewsSubmitFormTemplate"), "Templates/NewsV2/Edit", "NewsSubmitFormTemplate")%>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Attach template" />
                        </td>
                        <td>
                            <select name="NewsSubmitTemplateID" class="std">
                                <%=TmplControl(prop.Value("NewsSubmitTemplateID"))%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Kvittering" />
                        </td>
                        <td valign="top">
                            <%=Dynamicweb.SystemTools.Gui.LinkManager(prop.Value("NewsSubmitReceiptPage"), "NewsSubmitReceiptPage", "")%>
                        </td>
                    </tr>
                    <tr runat="server" id="CustomFieldsRow">
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Custom fields" />
                        </td>
                        <td>
                            <mc:ListSelector runat="server" Name="CustomFields" Columns="2" ID="CustomFieldsSelector"
                                DataTextField="Name" DataValueField="ID" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Incorrect field" runat="server" />
                        </td>
                        <td>
                            <input type="text" class="std" name="CustomVMIncorrect" value="<%=prop.Value("CustomVMIncorrect")%>" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Required field" runat="server" />
                        </td>
                        <td>
                            <input type="text" class="std" name="CustomVMRequired" value="<%=prop.Value("CustomVMRequired")%>" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Unique field" runat="server" />
                        </td>
                        <td>
                            <input type="text" class="std" name="CustomVMUnique" value="<%=prop.Value("CustomVMUnique")%>" />
                        </td>
                    </tr>
                </table>
                <dw:GroupBoxEnd ID="FrontendEditEnd" runat="server" />
                <dw:GroupBoxStart doTranslation="true" runat="server" ID="WorkflowStart" Title="Godkendelse" />
                <table cellpadding="2" cellspacing="0">
                    <tr>
                        <td class="leftCol">
                            <label for="NewsSubmitNotify">
                                <dw:TranslateLabel runat="server" Text="Notificer" />
                            </label>
                        </td>
                        <td>
                            <%=Dynamicweb.SystemTools.Gui.CheckBox(prop.Value("NewsSubmitNotify"), "NewsSubmitNotify")%>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftCol">
                            <dw:TranslateLabel runat="server" Text="Email" />
                        </td>
                        <td>
                            <input type="text" onchange="ValidateEmail(this);" name="NewsSubmitNotifyEmail" class="std"
                                value="<%=prop.Value("NewsSubmitNotifyEmail")%>"></td>
                    </tr>
                    <tr>
                        <td class="leftCol">
                            <dw:TranslateLabel runat="server" Text="Sender e-mail" />
                        </td>
                        <td>
                            <input type="text" onchange="ValidateEmail(this);" name="NewsSenderEmail" class="std"
                                value="<%=prop.Value("NewsSenderEmail")%>"></td>
                    </tr>
                    <tr>
                        <td class="leftCol">
                            <dw:TranslateLabel runat="server" Text="E-mail_emne" />
                        </td>
                        <td>
                            <input type="text" name="NewsSubmitNotifySubject" class="std" value="<%=prop.Value("NewsSubmitNotifySubject")%>"></td>
                    </tr>
                    <tr>
                        <td class="leftCol">
                            <label for="NewsSubmitApprove">
                                <dw:TranslateLabel runat="server" Text="Godkend" />
                            </label>
                        </td>
                        <td>
                            <dw:CheckBox id="NewsSubmitApprove" Value="1" onclick="ToggleApprove()" runat="server"/>
                        </td>
                    </tr>
                    <tr id="approvepage">
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Kvittering" />
                        </td>
                        <td valign="top">
                            <%=Dynamicweb.SystemTools.Gui.LinkManager(prop.Value("NewsApproveReceiptPage"), "NewsApproveReceiptPage", "")%>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftCol">
                            <dw:TranslateLabel runat="server" Text="Mail template" />
                        </td>
                        <td>
                            <%=Dynamicweb.SystemTools.Gui.FileManager(prop.Value("NewsSubmitNotifyTemplate"), "Templates/NewsV2/Edit", "NewsSubmitNotifyTemplate")%>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
        <div id="ListNewsShow">
            <dw:GroupBoxStart doTranslation="true" runat="server" ID="SimpleSettingsStart" Title="General" />
            <table cellpadding="2" cellspacing="0" width="100%">
                <tr>
                    <td class="leftColHigh">
                        <dw:TranslateLabel runat="server" Text="Teaser tekst" />
                    </td>
                    <td>
                        <label>
                            <%=Dynamicweb.News.Standard.RadioButton(prop.Value("NewsParagraphShowManchet"), "NewsParagraphShowManchet", "Manchet", "onclick='ToggleTeaser()'")%>
                            <dw:TranslateLabel runat="server" Text="Vis manchet" />
                        </label>
                        &nbsp;
                        <label>
                            <%=Dynamicweb.News.Standard.RadioButton(prop.Value("NewsParagraphShowManchet"), "NewsParagraphShowManchet", "FirstXChars", "onclick='ToggleTeaser()'")%>
                            <dw:TranslateLabel runat="server" Text="Vis de første" />
                            &nbsp;
                        </label>
                        <input type='text' name='NewsParagraphShowXCharacters' size='4' maxlength='255' class='std'
                            value='<%=prop.Value("NewsParagraphShowXCharacters")%>' style='width: 55px;'
                            onkeypress='return ChkNumeric(event);'>&nbsp;
                        <dw:TranslateLabel runat="server" Text="tegn" />
                        <br />
                        <table id="advXChars" cellpadding="0" cellspacing="0" style="display: ;">
                            <tr>
                                <td style="width: 134px;">
                                </td>
                                <td>
                                    <label>
                                        <%=Dynamicweb.News.Standard.RadioButton(prop.Value("NewsParagraphFirstXChars"), "NewsParagraphFirstXChars", Consts.FirstXChars.Teaser.ToString())%>
                                        <dw:TranslateLabel runat="server" Text="Teaser" />
                                    </label>
                                    &nbsp;
                                    <label>
                                        <%=Dynamicweb.News.Standard.RadioButton(prop.Value("NewsParagraphFirstXChars"), "NewsParagraphFirstXChars", Consts.FirstXChars.NewsText.ToString())%>
                                        <dw:TranslateLabel runat="server" Text="News text" />
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="listcategory">
                    <td class="leftColHigh">
                        <dw:TranslateLabel runat="server" Text="Medtag følgende kategorier" />
                    </td>
                    <td valign="top">
                        <%=CategoriesCheck()%>
                    </td>
                </tr>
                <tr>
                    <td class="leftColHigh">
                        <dw:TranslateLabel runat="server" Text="Status" />
                    </td>
                    <td>
                        <label>
                            <%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("NewsParagraphShowArchive"), "NewsParagraphShowArchive", "Active")%>
                            <dw:TranslateLabel runat="server" Text="Aktiv" />
                        </label>
                        &nbsp;
                        <label>
                            <%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("NewsParagraphShowArchive"), "NewsParagraphShowArchive", "Archive")%>
                            <dw:TranslateLabel runat="server" Text="Arkiverede" />
                        </label>
                        &nbsp;
                        <label>
                            <%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("NewsParagraphShowArchive"), "NewsParagraphShowArchive", "All")%>
                            <dw:TranslateLabel runat="server" Text="Alle" />
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="leftCol">
                        <dw:TranslateLabel runat="server" Text="Start with number" />
                    </td>
                    <td>
                        <input type="text" name="NewsParagraphShowFrom" style="width: 55px;" onkeypress="return ChkNumeric(event);"
                            maxlength="5" class="std" value="<%=prop.Value("NewsParagraphShowFrom")%>"></td>
                </tr>
                <tr>
                    <td class="leftCol">
                        <dw:TranslateLabel runat="server" Text="Items per page" />
                    </td>
                    <td>
                        <input type="text" name="NewsParagraphCustomNumberPerList" style="width: 55px;" maxlength="5"
                            onkeypress="return ChkNumeric(event);" class="std" value="<%=prop.Value("NewsParagraphCustomNumberPerList")%>">
                    </td>
                </tr>
            </table>
            <dw:GroupBoxEnd ID="SimpleSettingsEnd" runat="server" />

            <div ID="Advanced" style="padding: 16px">
                <dw:CheckBox Value="1" name="AdvancedSettingsUse" id="AdvancedSettingsUse" onclick="ToggleAdvanced();" runat="server" />
                <label for="NewsParagraphShowCustom" style="vertical-align: middle;">
                    <dw:TranslateLabel runat="server" Text="Advanced" />
                </label>
            </div>

            <div id="AdvancedSettingsGroup">
                <dw:GroupBoxStart doTranslation="true" runat="server" ID="DisplayStart" Title="Visning" />
                <table cellpadding="2" cellspacing="0" width="100%">
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="News detail template" />
                        </td>
                        <td>
                            <%=Gui.FileManager(prop.Value("NewsParagraphDetailTemplate"), "Templates/NewsV2/Item", "NewsParagraphDetailTemplate")%>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Paging type" />
                        </td>
                        <td>
                            <label>
                                <%=Dynamicweb.News.Standard.RadioButton(prop.Value("NewsParagraphCustomPagingType"), "NewsParagraphCustomPagingType", "1", "onclick='togglePagingType();'")%>
                                <dw:TranslateLabel runat="server" Text="Side numre" />
                            </label>
                            &nbsp;
                            <label>
                                <%=Dynamicweb.News.Standard.RadioButton(prop.Value("NewsParagraphCustomPagingType"), "NewsParagraphCustomPagingType", "2", "onclick='togglePagingType();'")%>
                                <dw:TranslateLabel runat="server" Text="Frem/tilbage knapper" />
                            </label>
                            &nbsp;
                            <label>
                                <%=Dynamicweb.News.Standard.RadioButton(prop.Value("NewsParagraphCustomPagingType"), "NewsParagraphCustomPagingType", "3", "onclick='togglePagingType();'")%>
                                <dw:TranslateLabel runat="server" Text="None" />
                            </label>
                        </td>
                    </tr>
                    <tr id="TR_NewsParagraphCustomPaging">
                        <td colspan="2">
                            <table cellpadding="0" cellspacing="2">
                                <tr>
                                    <td class="leftColHigh">
                                        <%=Translate.Translate("%% knap", "%%", "<em>" & Translate.Translate("Frem") & "</em>")%>
                                    </td>
                                    <td class="tdInsButton">
                                        <%=Dynamicweb.SystemTools.Gui.ButtonText("NewsParagraphPagingButtonNext", prop.Value("NewsParagraphPagingButtonNext"), prop.Value("NewsParagraphPagingButtonNextPicture"), prop.Value("NewsParagraphPagingButtonNextText"), False)%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="leftColHigh">
                                        <%=Translate.Translate("%% knap", "%%", "<em>" & Translate.Translate("Tilbage") & "</em>")%>
                                    </td>
                                    <td class="tdInsButton">
                                        <%=Dynamicweb.SystemTools.Gui.ButtonText("NewsParagraphPagingButtonPrev", prop.Value("NewsParagraphPagingButtonPrev"), prop.Value("NewsParagraphPagingButtonPrevPicture"), prop.Value("NewsParagraphPagingButtonPrevText"), True)%>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Visning som" />
                        </td>
                        <td>
                            <%=Dynamicweb.SystemTools.Gui.LinkManager(prop.Value("NewsParagraphSettings"), "NewsParagraphSettings", "", "0", "", False, True, True, "", False, True)%>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftCol">
                            <label for="RSSFeedRemoveM">
                                <dw:TranslateLabel runat="server" Text="Preserve paragraph setup" />
                            </label>
                        </td>
                        <td>
                            <%=Dynamicweb.SystemTools.Gui.CheckBox(prop("RSSFeedRemoveM"), "RSSFeedRemoveM")%>
                        </td>
                    </tr>                                                         
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Link til nyhed" />
                        </td>
                        <td class="tdInsButton">
                            <%=Dynamicweb.SystemTools.Gui.ButtonText("NewsParagraphReadMore", prop.Value("NewsParagraphReadMore"), prop.Value("NewsParagraphReadMoreImage"), prop.Value("NewsParagraphReadMoreText"), "Image", True)%>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Tilbage" />
                            <dw:TranslateLabel runat="server" Text="knap" />
                        </td>
                        <td class="tdInsButton">
                            <%=Dynamicweb.SystemTools.Gui.ButtonText("NewsParagraphBackButton", prop.Value("NewsParagraphBackButton"), prop.Value("NewsParagraphBackButtonPicture"), prop.Value("NewsParagraphBackButtonText"), True)%>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Edit news link" />
                        </td>
                        <td class="tdInsButton">
                            <%=Dynamicweb.SystemTools.Gui.ButtonText("NewsParagraphAdminEdit", prop.Value("NewsParagraphAdminEdit"), prop.Value("NewsParagraphAdminEditPicture"), prop.Value("NewsParagraphAdminEditText"), False)%>
                        </td>
                    </tr>
                    <%If Dynamicweb.Security.Authorization.UserHasAccess("Personalize", "") Then%>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Unread news" />
                        </td>
                        <td>
                            <input onclick="ShowHideNewsParagraphShowPersonalize();" value="1" type="CheckBox"
                                class="Clean" id="NewsParagraphShowPersonalize" name="NewsParagraphShowPersonalize"
                                <%=If(cstr(prop.value("NewsParagraphShowPersonalize") & "") = "1", "checked", "")%> />
                        </td>
                    </tr>
                    <tr id="TR_NewsParagraphShowPersonalize">
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Mark unread news" />
                        </td>
                        <td class="tdInsButton">
                            <%=Dynamicweb.SystemTools.Gui.ButtonText("NewsParagraphPersonalizeButton", prop.Value("NewsParagraphPersonalizeButton"), prop.Value("NewsParagraphPersonalizeButtonPicture"), prop.Value("NewsParagraphPersonalizeButtonText"), True)%>
                        </td>
                    </tr>
                    <%End If%>
					<tr><td>&nbsp;</td></tr>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="No news Message" />
                        </td>
                        <td>
                            <textarea class="std" name="NoNewsMessage"><%=prop.Value("NoNewsMessage")%></textarea>
                        </td>
                    </tr>
                </table>
                <dw:GroupBoxEnd ID="DisplayEnd" runat="server" />
                <div id="ListNewsShow1">
                    <dw:GroupBoxStart doTranslation="true" runat="server" ID="ListStart" Title="List" />
                    <table cellpadding="2" cellspacing="0">
                        <tr>
                            <td class="leftCol">
                                <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Template - Liste" />
                            </td>
                            <td>
                                <%=Dynamicweb.SystemTools.Gui.FileManager(prop.Value("NewsParagraphListTemplate"), "Templates/NewsV2/List", "NewsParagraphListTemplate")%>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftColHigh">
                                <dw:TranslateLabel runat="server" Text="Order by" />
                            </td>
                            <td valign="top">
                                <label>
                                    <%=CustomRadioButton(prop.Value("NewsParagraphOrderBy"), "NewsParagraphOrderBy", Consts.NewsOrderBy.News.ToString(), "onclick='ShowMostPopularOptions(false);CheckCompatibility();'")%>
                                    <dw:TranslateLabel runat="server" Text="News date" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftColHigh">
                            </td>
                            <td valign="top">
                                <label>
                                    <%=CustomRadioButton(prop.Value("NewsParagraphOrderBy"), "NewsParagraphOrderBy", Consts.NewsOrderBy.CreationDate.ToString(), "onclick='ShowMostPopularOptions(false);CheckCompatibility();'")%>
                                    <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Creation date" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftColHigh">
                            </td>
                            <td valign="top">
                                <label>
                                    <%=CustomRadioButton(prop.Value("NewsParagraphOrderBy"), "NewsParagraphOrderBy", Consts.NewsOrderBy.NewsHeader.ToString(), "onclick='ShowMostPopularOptions(false);CheckCompatibility();'")%>
                                    <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="News header" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td class="leftColHigh">
                            </td>
                            <td valign="top">
                                <label>
                                    <%=CustomRadioButton(prop.Value("NewsParagraphOrderBy"), "NewsParagraphOrderBy", Consts.NewsOrderBy.MostPopular.ToString(), "onclick='ShowMostPopularOptions(true);CheckCompatibility();'")%>
                                    <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Most popular" />
                                </label>
                            </td>
                        </tr>
                        <tr id="mostPupularOptions" style="display: none;">
                            <td class="leftColHigh">
                                <dw:TranslateLabel runat="server" Text="Last days" />
                            </td>
                            <td>
                                <input type='text' name='NewsMostPopularLastDays' size='4' maxlength='255' class='std'
                                    value='<%=prop.Value("NewsMostPopularLastDays")%>' style='width: 55px;' onkeypress='return ChkNumeric(event);'>&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="leftColHigh">
                                <dw:TranslateLabel runat="server" Text="Sortering" />
                            </td>
                            <td>
                                <label>
                                    <%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("NewsParagraphSortOrder"), "NewsParagraphSortOrder", "DESC")%>
                                    <dw:TranslateLabel runat="server" Text="Descending" />
                                </label>
                                &nbsp;
                                <label>
                                    <%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("NewsParagraphSortOrder"), "NewsParagraphSortOrder", "ASC")%>
                                    <dw:TranslateLabel runat="server" Text="Ascending" />
                                </label>
                            </td>
                        </tr>
                    </table>
                    <dw:GroupBoxEnd ID="ListEnd" runat="server" />
                </div>
                <div id="ListNewsShow2">
                    <fieldset>
                        <legend class="gbTitle"><span style="vertical-align: middle;">
                            <dw:CheckBox onclick="ShowHideNewsParagraphShowCustom();CheckCompatibility();" value="1" id="NewsParagraphShowCustom" name="NewsParagraphShowCustom" runat="server" />
                            <label for="NewsParagraphShowCustom" style="vertical-align: middle;">
                                <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Search" />
                            </label>
                        </legend>
                        <table cellpadding="2" cellspacing="0" id="TR_NewsParagraphShowCustom">
                            <tr>
                                <td class="leftCol">
                                    <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Template" />
                                </td>
                                <td>
                                    <%=Dynamicweb.SystemTools.Gui.FileManager(prop.Value("NewsParagraphSearchTemplate"), "Templates/NewsV2/List", "NewsParagraphSearchTemplate")%>
                                </td>
                            </tr>
                            <tr>
                                <td class="leftColHigh">
                                    <dw:TranslateLabel runat="server" Text="Vis" />
                                </td>
                                <td>
                                    <label>
                                        <%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("NewsParagraphCustomType"), "NewsParagraphCustomType", "Year")%>
                                        <dw:TranslateLabel runat="server" Text="År" />
                                    </label>
                                    &nbsp;
                                    <label>
                                        <%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("NewsParagraphCustomType"), "NewsParagraphCustomType", "YearMonth")%>
                                        <dw:TranslateLabel runat="server" Text="År/Måned" />
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td class="leftColHigh">
                                    &nbsp;
                                </td>
                                <td>
                                    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Tekst" />
                                    &nbsp;<input type="text" name="NewsParagraphCustomText" size="4" maxlength="255"
                                        class="std" value="<%=prop.Value("NewsParagraphCustomText")%>" style="width: 170px;">
                                </td>
                            </tr>
                            <tr>
                                <td class="leftColHigh">
                                    <%=Translate.Translate("%% knap", "%%", "<em>" & Translate.Translate("Aktiver",1) & "</em>")%>
                                </td>
                                <td class="tdInsButton">
                                    <%=Dynamicweb.SystemTools.Gui.ButtonText("NewsParagraphCustomButton", prop.Value("NewsParagraphCustomButton"), prop.Value("NewsParagraphCustomButtonPicture"), prop.Value("NewsParagraphCustomButtonText"), True)%>
                                </td>
                            </tr>
                        </table>
                        &nbsp;
                    </fieldset>
                </div>
                <div id="ListNewsShow3">
                    <dw:GroupBoxStart doTranslation="true" runat="server" ID="FormattingStart" Title="Formatering" />
                    <table cellpadding="2" cellspacing="0">
                        <tr>
                            <td class="leftCol">
                                <dw:TranslateLabel runat="server" Text="Regionale indstillinger" />
                            </td>
                            <td>
                                <%=CultureList(prop.Value("NewsCulture"), "NewsCulture", True)%>
                            </td>
                        </tr>
                    </table>
                    <dw:GroupBoxEnd ID="FormattingEnd" runat="server" />
                </div>
            </div>
        </div>
    </td>
</tr>
<tr>
    <td colspan="2">
    </td>
</tr>

<script type="text/javascript">
    ToggleCreate();
    ToggleAdvanced();
    ShowHideNewsParagraphShowCustom();
    ToggleApprove();
    ToggleTeaser();
    togglePagingType();
    ToggleMostPopular();    
    ShowHideNewsParagraphShowPersonalize();
    CheckCompatibility();
    disableDependentFields(<%=Dynamicweb.News.Standard.IsExtranetInstalled.ToString.ToLower()%>);
</script>

<%  Translate.GetEditOnlineScript()%>
