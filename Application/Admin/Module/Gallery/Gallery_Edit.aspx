<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Gallery_Edit.aspx.vb" Inherits="Dynamicweb.Admin.Gallery_Edit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<dw:ModuleHeader ID="ModuleHeader1" runat="server" ModuleSystemName="Gallery" />
<dw:ModuleSettings ID="ModuleSettings1" runat="server" ModuleSystemName="Gallery" Value="ShowAction, PictureFolder, PDFfile, ListTemplate, xsltFile, PageSize, PageSizeForward, PageSizeForwardText, PageSizeForwardPicture, PageSizeBack, PageSizeBackPicture, PageSizeBackText, SortBy, SortOrder, MaxThumbWidth, MaxThumbHeight, MaxPictureWidth, MaxPictureHeight, FileLinkText, ListTextNoImages, ShowTemplate, Quality" />

<script type="text/javascript">
    function ActionChanged() {
        if (document.forms.paragraph_edit.ShowAction[0].checked) {
            document.getElementById("PictureFolderRow").style.display = "";
            document.getElementById("ListFolderSettings").style.display = "";
            document.getElementById("PagingSettings").style.display = "block";
            document.getElementById("PDFfileRow").style.display = "none";
            document.getElementById("ThumbnailsSettings").style.display = "";
        }
        else {
            document.getElementById("PictureFolderRow").style.display = "none";
            document.getElementById("ListFolderSettings").style.display = "none";
            document.getElementById("PagingSettings").style.display = "none";
            document.getElementById("PDFfileRow").style.display = "";
            document.getElementById("ThumbnailsSettings").style.display = "none";
        }
    }
</script>
<body>
    <dw:GroupBox ID="GroupBox1" runat="server" Title="Vis" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td></td>
                <td>
                    <div class="radio">
                        <dw:RadioButton ID="ShowActionFolder" runat="server" FieldName="ShowAction" FieldValue="Folder" />
                        <label for="ShowActionFolder">
                            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Billed_mappe" />
                        </label>
                    </div>
                    <div class="radio">
                        <dw:RadioButton ID="ShowActionPDF" runat="server" FieldName="ShowAction" FieldValue="PDF" />
                        <label for="ShowActionPDF">
                            <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="PDF" />
                        </label>
                    </div>
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <dw:GroupBox ID="GroupBox2" runat="server" Title="Liste" DoTranslation="true">
        <table class="formsTable">
            <tr id="PictureFolderRow">
                <td>
                    <dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Mappe" />
                </td>
                <td>
                    <dw:FolderManager ID="PictureFolder" Name="PictureFolder" runat="server" />
                </td>
            </tr>
            <tr id="PDFfileRow">
                <td>
                    <dw:TranslateLabel ID="TranslateLabel11" runat="server" Text="PDF" />
                    (<dw:TranslateLabel ID="TranslateLabel22" runat="server" Text="Max 100 pages" />
                    )
                </td>
                <td>
                    <dw:FileManager ID="PDFfile" Name="PDFfile" runat="server" Extensions="pdf" AllowBrowse="true" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Template" />
                </td>
                <td>
                    <dw:FileManager ID="ListTemplate" runat="server" Folder="/Templates/Gallery/List" />
                </td>
            </tr>
        </table>
        <table id="ListFolderSettings" class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Sorter efter" />
                </td>
                <td>
                    <div class="radio">
                        <dw:RadioButton ID="SortByPictureName" runat="server" FieldName="SortBy" FieldValue="PictureName" />
                        <label for="SortByPictureName">
                            <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Navn" />
                        </label>
                    </div>
                    <div class="radio">
                        <dw:RadioButton ID="SortByPictureUpdatedDate" runat="server" FieldName="SortBy" FieldValue="PictureUpdatedDate" />
                        <label for="SortByPictureUpdatedDate">
                            <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Dato" />
                        </label>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Sort order" />
                </td>
                <td>
                    <div class="radio">
                        <dw:RadioButton ID="SortOrderASC" runat="server" FieldName="SortOrder" FieldValue="ASC" />
                        <label for="SortOrderASC">
                            <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Stigende" />
                        </label>
                    </div>
                    <div class="radio">
                        <dw:RadioButton ID="SortOrderDESC" runat="server" FieldName="SortOrder" FieldValue="DESC" />
                        <label for="SortOrderDESC">
                            <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Faldende" />
                        </label>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel19" runat="server" Text="Link til fil" />
                </td>
                <td>
                    <input type="text" class="std" maxlength="250" name="FileLinkText" value="<%=Properties.Value("FileLinkText")%>" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel20" runat="server" Text="Besked ved tom mappe" />
                </td>
                <td>
                    <input type="text" class="std" maxlength="250" name="ListTextNoImages" value="<%=Properties.Value("ListTextNoImages")%>" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <dw:GroupBox ID="GroupBox7" runat="server" Title="Quality">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabelQuality" runat="server" Text="Quality" />
                </td>
                <td>
                    <%=Gui.SpacListExt(Properties.Value("Quality"), "Quality", 50, 100, 1, "", False, "100")%>
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <div id="ThumbnailsSettings">
        <dw:GroupBox ID="GroupBox4" runat="server" Title="Thumbnails">
            <table class="formsTable">
                <tr>
                    <td>
                        <dw:TranslateLabel ID="TranslateLabel12" runat="server" Text="Dimensioner" />
                    </td>
                    <td>
                        <input type="text" class="std" style="width: 100px;" maxlength="4" name="MaxThumbWidth" id="MaxThumbWidth" value="<%=properties.Value("MaxThumbWidth")%>" />
                        <label for="MaxThumbWidth">
                            &nbsp;<dw:TranslateLabel ID="TranslateLabel13" runat="server" Text="Max bredde (px)" />
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <input type="text" class="std" style="width: 100px;" maxlength="4" name="MaxThumbHeight" id="MaxThumbHeight" value="<%=properties.Value("MaxThumbHeight")%>" />
                        <label for="MaxThumbHeight">
                            &nbsp;<dw:TranslateLabel ID="TranslateLabel14" runat="server" Text="Max højde (px)" />
                        </label>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>
    </div>

    <dw:GroupBox ID="GroupBox5" runat="server" Title="Billede">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel16" runat="server" Text="Dimensioner" />
                </td>
                <td>
                    <input type="text" class="std" style="width: 100px;" maxlength="4" name="MaxPictureWidth" id="MaxPictureWidth" value="<%=properties.Value("MaxPictureWidth")%>" />
                    <label for="MaxPictureWidth">
                        &nbsp;<dw:TranslateLabel ID="TranslateLabel17" runat="server" Text="Max bredde (px)" />
                    </label>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <input type="text" class="std" style="width: 100px;" maxlength="4" name="MaxPictureHeight" id="MaxPictureHeight" value="<%=properties.Value("MaxPictureHeight")%>" />
                    <label for="MaxPictureHeight">
                        &nbsp;<dw:TranslateLabel ID="TranslateLabel18" runat="server" Text="Max højde (px)" />
                    </label>
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <dw:GroupBox ID="GroupBox6" runat="server" Title="Detalje">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="Template" />
                </td>
                <td>
                    <dw:FileManager ID="ShowTemplate" Name="ShowTemplate" runat="server" Folder="/Templates/Gallery/Show" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <div id="PagingSettings">
        <dw:GroupBox ID="GroupBox3" runat="server" Title="Sideindeling">
            <table class="formsTable">
                <tr>
                    <td>
                        <dw:TranslateLabel ID="TranslateLabel15" runat="server" Text="Antal_pr._side" />
                    </td>
                    <td>
                        <%=Gui.SpacListExt(Properties.Value("PageSize"), "PageSize", 1, 200, 1, "", False, "100")%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("%% knap", "%%", "<em>" & Translate.Translate("Frem") & "</em>" )%>
                    </td>
                    <td>
                        <%=Gui.ButtonText("PageSizeForward", Properties.Value("PageSizeForward"), Properties.Value("PageSizeForwardPicture"), Properties.Value("PageSizeForwardText"))%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("%% knap", "%%", "<em>" & Translate.Translate("Tilbage") & "</em>" )%>
                    </td>
                    <td>
                        <%=Gui.ButtonText("PageSizeBack", Properties.Value("PageSizeBack"), Properties.Value("PageSizeBackPicture"), Properties.Value("PageSizeBackText"))%>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>
    </div>

    <script type="text/javascript">
    document.getElementById("ShowActionFolder").onclick = ActionChanged;
    document.getElementById("ShowActionPDF").onclick = ActionChanged;
    ActionChanged();
    </script>
</body>
