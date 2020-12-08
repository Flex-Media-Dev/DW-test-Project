<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BasicForum_Edit.aspx.vb" ValidateRequest="false" Inherits="Dynamicweb.Admin.BasicForum.BasicForum_Edit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!--@Start of file-->
<dw:ModuleHeader ID="ModuleHeader1" runat="server" ModuleSystemName="BasicForum" />
<dw:ModuleSettings ID="ModuleSettings1" runat="server" ModuleSystemName="BasicForum" Value="CategoriesSelector, ListForumTemplate, OrderForumBy, ListThreadTemplate, ShowThreadTemplate, CreatePostTemplate, OrderBy, ShowAction, CategoryShow, CategoryID, SubjectPrefix, EditorWidth, EditorHeight, EditorConfiguration, EditorSkin, EditorStyles, EditorIncludes, PagingSetting, PostsPagingSetting, NewThreadCategoryID,NewsletterSubscriptionSender,NewsletterSubscriptionSubject,NewsletterSubscriptionIncludeMessageTitle,NewsletterSubscriptionTemplate,CanMarkAsAnswer" />

<script type="text/javascript">
    function ActionChanged() {
        if (document.forms.paragraph_edit.ShowAction[1].checked) {
            document.getElementById("listForumSettings").style.display = "none";
            document.getElementById("listSelectedCategories").style.display = "none";
            document.getElementById("listThreadDefaultCategory").style.display = "block";
        }
        else {
            document.getElementById("listForumSettings").style.display = "block";
            document.getElementById("listSelectedCategories").style.display = "block";
            document.getElementById("listThreadDefaultCategory").style.display = "none";
        }
    }

    function getFields() {
        SelectionBox.getListItems("/Admin/Module/BasicForum/BasicForum_Edit.aspx?AJAXCMD=FILL_FIELDS", "CategoriesSelector");
    }

    function serializeCategories() {
        var fields = SelectionBox.getElementsRightAsArray("CategoriesSelector");
        $("CategoryID").value = fields.toString();
    }

    function changeView() {
        getFields();
    }

    document.observe("dom:loaded", function () {
        var toolbars = FCKConfig.ToolbarSets;
        var toolBarArray = new Array();
        for (var toolbar in toolbars) {
            if (toolbar == '<%=toolbarType%>') {
                toolBarArray.unshift("<option value=\"" + toolbar + "\" selected >" + toolbar + "</option>");
            }
            else {
                toolBarArray.unshift("<option value=\"" + toolbar + "\">" + toolbar + "</option>");
            }
        }
        toolBarArray.sort();
        $("EditorConfiguration").update(toolBarArray.join(" "));
    });

    Event.observe(window, "load", function () {
        if (window.parent.$("myribbon") != null) {
            var h = window.parent.document.documentElement.clientHeight - window.parent.$("myribbon").getHeight() - window.parent.$("formTable").getHeight() - window.parent.$("breadcrumb").getHeight();
            if (h < 0) h = 0;
            if (h >= 20) h -= 20;
            window.parent.$('ParagraphModule__Frame').setStyle({ height: h + 'px' });
        }
    });
</script>
<style>
    .heading-row {
        margin-top: 10px;
    }
</style>
<body>
    <dwc:GroupBox ID="GroupBox1" runat="server" Title="Display" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td></td>
                <td>
                    <dw:RadioButton ID="ShowActionListForums" runat="server" FieldName="ShowAction" FieldValue="ListForums" />
                    <dw:TranslateLabel ID="lbListCategories" Text="List forum categories" runat="server" />
                    <br />
                    <dw:RadioButton ID="ShowActionListThreads" runat="server" FieldName="ShowAction" FieldValue="ListThreads" />
                    <dw:TranslateLabel ID="lbListThreads" Text="List forum threads" runat="server" />
                    <br />
                </td>
            </tr>
        </table>
    </dwc:GroupBox>
    <div id="listThreadDefaultCategory">
        <dwc:GroupBox ID="GroupBox7" runat="server" Title="Category" DoTranslation="true">
            <table class="formsTable">
                <tr>
                    <td>
                        <dw:TranslateLabel ID="lbCategory" Text="Category" runat="server" />
                    </td>
                    <td>
                        <select id="NewThreadCategoryID" name="NewThreadCategoryID" runat="server" class="std"></select>
                    </td>
                </tr>
            </table>
        </dwc:GroupBox>
    </div>
    <div id="listSelectedCategories">
        <dwc:GroupBox ID="GBCategories" runat="server" Title="Categories" DoTranslation="true">
            <table>
                <tr>
                    <td>
                        <dw:SelectionBox ID="CategoriesSelector" runat="server" />
                        <input type="hidden" name="CategoryID" id="CategoryID" value="" runat="server" />
                    </td>
                </tr>
            </table>
        </dwc:GroupBox>
    </div>
    <div id="listForumSettings">
        <dwc:GroupBox ID="GroupBox4" runat="server" Title="List forum categories" DoTranslation="true">
            <table class="formsTable">
                <tr>
                    <td>
                        <dw:TranslateLabel ID="lbTemplate1" Text="Template" runat="server" />
                    </td>
                    <td>
                        <dw:FileManager ID="ListForumTemplate" runat="server" Folder="/Templates/BasicForum/ListForum" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <dw:TranslateLabel ID="lbOrderBy1" Text="Order by" runat="server" />
                    </td>
                    <td>
                        <dw:RadioButton ID="OrderForumByCreatedDate" runat="server" FieldName="OrderForumBy" FieldValue="Created date" />
                        <dw:TranslateLabel ID="lbCreatedDate" Text="Created date" runat="server" />
                        <br />
                        <dw:RadioButton ID="OrderForumByName" runat="server" FieldName="OrderForumBy" FieldValue="Name" />
                        <dw:TranslateLabel ID="lbName" Text="Name" runat="server" />
                        <br />
                        <dw:RadioButton ID="OrderForumByReplies" runat="server" FieldName="OrderForumBy" FieldValue="Replies" />
                        <dw:TranslateLabel ID="lbReplyCount" Text="Reply count" runat="server" />
                        <br />
                        <dw:RadioButton ID="OrderForumByThreads" runat="server" FieldName="OrderForumBy" FieldValue="Threads" />
                        <dw:TranslateLabel ID="lbThreadCount" Text="Thread count" runat="server" />
                        <br />
                        <dw:RadioButton ID="OrderForumBySelectedCategories" runat="server" FieldName="OrderForumBy" FieldValue="Selected Categories" />
                        <dw:TranslateLabel ID="lbSelectedSortOrder" Text="Selected sort order" runat="server" />
                        <br />
                        <br />
                    </td>
                </tr>
            </table>
        </dwc:GroupBox>
    </div>

    <script type="text/javascript">
        document.getElementById("ShowActionListForums").onclick = ActionChanged;
        document.getElementById("ShowActionListThreads").onclick = ActionChanged;
        ActionChanged();
    </script>
    <dwc:GroupBox ID="GroupBox2" runat="server" Title="List threads" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbTemplate2" Text="Template" runat="server" />
                </td>
                <td>
                    <dw:FileManager ID="ListThreadTemplate" runat="server" Folder="/Templates/BasicForum/ListThread" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbOrderBy2" Text="Order by" runat="server" />
                </td>
                <td>
                    <dw:RadioButton ID="OrderByCreated" runat="server" FieldName="OrderBy" FieldValue="Created" />
                    <dw:TranslateLabel ID="lbLastCreated" Text="Last created" runat="server" />
                    <br />
                    <dw:RadioButton ID="OrderByAnswered" runat="server" FieldName="OrderBy" FieldValue="Answered" />
                    <dw:TranslateLabel ID="lbLastAnswered" Text="Last answered" runat="server" />
                    <br />
                    <dw:RadioButton ID="OrderByUpdated" runat="server" FieldName="OrderBy" FieldValue="Updated" />
                    <dw:TranslateLabel ID="lbLastUpdated" Text="Last updated" runat="server" />
                </td>
            </tr>
        </table>
    </dwc:GroupBox>
    <dwc:GroupBox ID="GroupBox5" runat="server" Title="Show thread" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbTemplate3" Text="Template" runat="server" />
                </td>
                <td>
                    <dw:FileManager ID="ShowThreadTemplate" runat="server" Folder="/Templates/BasicForum/ShowThread" />
                </td>
            </tr>
        </table>
    </dwc:GroupBox>
    <dwc:GroupBox ID="Markasanswer" runat="server" Title="Answers" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="CanMark" Text="Who can mark post as Answer :" runat="server" />
                </td>
                <td>
                    <select id="CanMarkAsAnswer" name="CanMarkAsAnswer" runat="server" class="std">
                        <option></option>
                        <option></option>
                    </select>
                </td>
            </tr>
        </table>
    </dwc:GroupBox>
    <dwc:GroupBox ID="GroupBox6" runat="server" Title="Create post" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbTemplate4" Text="Template" runat="server" />
                </td>
                <td>
                    <dw:FileManager ID="CreatePostTemplate" runat="server" Folder="/Templates/BasicForum/CreatePost" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbSubjectPrefix" Text="Subject prefix" runat="server" />
                </td>
                <td>
                    <input id="SubjectPrefix" name="SubjectPrefix" type="text" class="std" runat="server" />
                </td>
            </tr>
        </table>
    </dwc:GroupBox>
    <dwc:GroupBox ID="gbEditor" Title="Editor" runat="server" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbWidth" Text="Width (px)" runat="server" />
                </td>
                <td>
                    <dwc:InputNumber ID="EditorWidth" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbHeight" Text="Height (px)" runat="server" />
                </td>
                <td>
                    <dwc:InputNumber ID="EditorHeight" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbSkin" Text="Farve_palet" runat="server" />
                </td>
                <td>
                    <select id="EditorSkin" class="std" runat="server"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbEditorStyles" Text="Stylesheet" runat="server" />
                </td>
                <td>
                    <dw:FileManager ID="EditorStyles" Folder="Templates/BasicForum/CreatePost" Extensions="css" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbToolbar" Text="Editor Configuration" runat="server" />
                </td>
                <td>
                    <select id="EditorConfiguration" class="std" runat="server"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbInclude" Text="Medtag" runat="server" />
                </td>
                <td>                    
                    <dw:CheckBox ID="EditorIncludesSyntaxHighlighter" FieldName="EditorIncludes" Value="SyntaxHighlighter" Label="SyntaxHighlighter v3.0.83" runat="server" />                            
                </td>
            </tr>
        </table>
    </dwc:GroupBox>

    <dwc:GroupBox ID="gbNewsletter" Title="Newsletter subscription" runat="server" DoTranslation="true">
        <input type="hidden" id="action" name="action">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbFrom" Text="Afsender" runat="server" />
                </td>
                <td>
                    <input type="text" class="std" name="NewsletterSubscriptionSender" value="<%=_prop("NewsletterSubscriptionSender")%>" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbSubject" Text="Subject" runat="server" />
                </td>
                <td>
                    <input type="text" class="std" name="NewsletterSubscriptionSubject" value="<%=_prop("NewsletterSubscriptionSubject")%>" />
                    <div class="heading-row">
                        <dw:CheckBox ID="chkIncludeTitle" FieldName="NewsletterSubscriptionIncludeMessageTitle" value="True" runat="server" />                        
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="lbTemplate" Text="Template" runat="server" />
                </td>
                <td>
                    <dw:FileManager ID="NewsletterSubscriptionTemplate" runat="server" Folder="/Templates/BasicForum/Subscription" />
                </td>
            </tr>
        </table>

        <%Translate.GetEditOnlineScript()%>
    </dwc:GroupBox>

    <dw:PagingSettings ID="PagingSetting" runat="server" Title="Threads paging" />

    <dw:PagingSettings ID="PostsPagingSetting" runat="server" Title="Posts paging" />


    <script type="text/javascript">
        SelectionBox.setNoDataLeft("CategoriesSelector");
        SelectionBox.setNoDataRight("CategoriesSelector");
    </script>
</body>
<!--@End of file-->
