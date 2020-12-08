<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Properties.aspx.vb" Inherits="Dynamicweb.Admin.PropertiesForm" %>

<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Properties" runat="server" />
    </title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server" />
    <style type="text/css">
        table.gbTab
        {
            width: 50%;
            display: inline;
            vertical-align: top;
            float: left;
        }
        
        table.gbTab tr
        {
            vertical-align: top;
        }
        
        table.gbTab tr td.col
        {
            width: 170px;
        }
        
        div.smallText
        {
            font-size: 8pt;
        }

        .image-preview {
            position: absolute;
            right: 15px;
        }
     
        div.panel
        {
            padding-bottom: 10px;
        }
        h2
        {
            margin-left: 10px;
        }
        #GeneralTab {
            position: absolute;
            height: calc(100% - 40px);
            width: 100%;
            overflow: auto;
        }
    </style>
    <script type="text/javascript">
        function Close() {
            window.parent.dialog.hide('PropertiesDialog');
        }
        function cc(objRow) { //Change color of row when mouse is over... (ChangeColor)
            objRow.style.backgroundColor = '#E1DED8';
        }

        function ccb(objRow) { //Remove color of row when mouse is out... (ChangeColorBack)
            objRow.style.backgroundColor = '';
        }

        function metadata() {
            var width = 650;
            var height = 492;

            var qs = Object.toQueryString({
                'file': '<%= HttpUtility.UrlEncode(Path) %>'
            });

            metadata_window = window.open("/Admin/Filemanager/Metadata/EditMetadata.aspx?" + qs, "", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=yes,minimize=no,width=" + width + ",height=" + height + ",left=100 ,top=100");
            metadata_window.focus();
        }
    </script>
</head>
<body style="overflow: hidden;"> 
    <form id="form1" runat="server">
        <div id="divToolbar">
            <dw:Toolbar ID="Buttons" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="cmdClose" runat="server" Divide="None" Icon="TimesCircle"
                    Text="Close" OnClientClick="Close();">
                </dw:ToolbarButton>
                 <dw:ToolbarButton ID="MetadataButton" runat="server" Divide="None" Icon="Label"
                    Text="Metatags" OnClientClick="metadata();">
                </dw:ToolbarButton>
            </dw:Toolbar>
        </div>
        <dw:Infobar runat="server" ID="FileLoadErrorMessage" Message="The file name contains invalid characters" Visible="false" Type="Error"></dw:Infobar>
        <div id="GeneralTab" runat="server">
            <div style="display: inline-block; vertical-align: middle;">
                <span style="float: left;">
                    <h2>
                        <asp:Literal ID="LiteralPath" runat="server"></asp:Literal>
                    </h2>
                </span>            
            </div>
            <dw:GroupBox ID="GroupBoxFileProperties" runat="server" Title="Fil" DoTranslation="true">
                <table class="gbTab" border="0" cellpadding="2" cellspacing="0">
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel1" Text="Filnavn" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralFileName" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel2" Text="Filtype" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralFileType" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel3" Text="Placering" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralLocation" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel4" Text="Størrelse" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralSize" runat="server" />
                            bytes
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel5" Text="Oprettet" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralCreated" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel6" Text="Ændret" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralModified" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel7" Text="Tilgået" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralAccessed" runat="server" />
                        </td>
                    </tr>
                </table>
                <div id="GroupBoxImagePreview" runat="server" class="image-preview">
                    <img alt="ImagePreview" src="/Admin/Public/GetImage.ashx?fmImage_path=/Files<%=Path%>&Width=200&Height=190&donotupscale=1&crop=5" id="ImagePreview" class="img-responsive2" />
                </div>
            </dw:GroupBox>
            <dw:GroupBox ID="GroupBoxImageProperties" runat="server" Title="Billedeoplysninger"
                DoTranslation="true">
                <table class="gbTab" border="0" cellpadding="2" cellspacing="0">
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel8" Text="Højde" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralHeight" runat="server" />
                            <dw:TranslateLabel ID="TranslateLabel9" Text="px" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel10" Text="Bredde" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralWeight" runat="server" />
                            <dw:TranslateLabel ID="TranslateLabel11" Text="px" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel12" Text="Farver" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralDepth" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel13" Text="Opløsning" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralHorizontalResolution" runat="server" /><span> x </span><asp:Literal ID="LiteralVerticalResolution" runat="server" /><span> dpi</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel14" Text="Farve type" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralColorSpace" runat="server" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
            <dw:GroupBox ID="GroupBoxSWFProperties" runat="server" Title="Billede" DoTranslation="true">
                <table class="gbTab" border="0" cellpadding="2" cellspacing="0">
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel15" Text="Højde" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralSWFHeight" runat="server" />
                            <dw:TranslateLabel ID="TranslateLabel16" Text="px" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel17" Text="Bredde" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralSWFWidth" runat="server" />
                            <dw:TranslateLabel ID="TranslateLabel18" Text="px" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="col">
                            <dw:TranslateLabel ID="TranslateLabel19" Text="Farver" runat="server" />
                        </td>
                        <td>
                            <asp:Literal ID="LiteralSWFDepth" runat="server" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>  
        </div>
    </form>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
