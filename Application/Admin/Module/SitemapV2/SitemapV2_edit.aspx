<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="SitemapV2_edit.aspx.vb" Inherits="Dynamicweb.Admin.SitemapV2.SitemapV2_edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>


<dw:ModuleHeader ID="ModuleHeader1" runat="server" ModuleSystemName="SitemapV2"></dw:ModuleHeader>
<dw:ModuleSettings ID="ModuleSettings1" runat="server" ModuleSystemName="SitemapV2" />


<dw:GroupBox ID="gb_General" runat="server" Title="Generelt">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel ID="Translatelabel2" runat="server" Text="Fra"></dw:TranslateLabel>
            </td>
            <td>
                <div class="radio">
                    <input type="radio" onclick="EnableCurrentArea();" runat="server" value="CurrentArea" id="MenuCurrentArea" name="Menu"><label for="MenuCurrentArea"><dw:TranslateLabel ID="Translatelabel35" runat="server" Text="Aktuelle sproglag"></dw:TranslateLabel>
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" onclick="EnableArea();" runat="server" value="Area" id="MenuArea" name="Menu"><label for="MenuArea"><dw:TranslateLabel ID="Translatelabel3" runat="server" Text="sproglag"></dw:TranslateLabel>
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" onclick="EnablePage();" runat="server" value="Page" id="MenuPage" name="Menu"><label for="MenuPage"><dw:TranslateLabel ID="Translatelabel4" runat="server" Text="side"></dw:TranslateLabel>
                    </label>
                </div>
            </td>
        </tr>
        <tr id="TrArea">
            <td>
                <dw:TranslateLabel ID="Translatelabel5" runat="server" Text="Sproglag"></dw:TranslateLabel>
            </td>
            <td>
                <select id="AreaID" runat="server" name="AreaID" class="std"></select>
            </td>
        </tr>
        <tr id="TrPage">
            <td>
                <dw:TranslateLabel ID="Translatelabel6" runat="server" Text="Underpunkter til side"></dw:TranslateLabel>
            </td>
            <td>
                <dw:LinkManager ID="PageSelected" Name="PageSelected" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="Translatelabel7" runat="server" Text="Første niveau"></dw:TranslateLabel>
            </td>
            <td>
                <select id="FirstLevel" runat="server" name="FirstLevel" class="std" style="width: 150px;"></select>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="Translatelabel8" runat="server" Text="Sidste niveau"></dw:TranslateLabel>
            </td>
            <td>
                <select id="LastLevel" runat="server" name="LastLevel" class="std" style="width: 150px;"></select>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox FieldName="IncludeAllPages" ID="IncludeAllPages" runat="server" Value="True" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="Translatelabel9" runat="server" Text="Template"></dw:TranslateLabel>
            </td>
            <td>
                <asp:literal runat="server" id="litTemplate"></asp:literal>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox AttributesParm="onclick='SetDivOwnStyles();'" FieldName="UseOwnStyles" ID="UseOwnStyles" runat="server" Value="True" />
            </td>
        </tr>
    </table>
</dw:GroupBox>
<div id="DivOwnStyles">
    <dw:GroupBox ID="gb_Style1" runat="server" Title="Niveau 1">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel16" runat="server" Text="Punktgrafik"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:FileArchive runat="server" name="Graphics1" ID="Graphics1" ShowPreview="True" MaxLength="255" CssClass="std"></dw:FileArchive>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel14" runat="server" Text="Font"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="Font1" runat="server" name="Font1" class="std"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel17" runat="server" Text="Fontstørrelse"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="FontSize1" runat="server" name="FontSize1" class="std" style="width: 150px;"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel18" runat="server" Text="Fontfarve"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:ColorSelect runat="server" ID="FontColor1" Name="FontColor1"></dw:ColorSelect>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel1" runat="server" Text=""></dw:TranslateLabel>
                </td>
                <td>
                    <dw:CheckBox FieldName="IsBold1" ID="IsBold1" Value="True" runat="server" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
    <dw:GroupBox ID="gb_Style2" runat="server" Title="Niveau 2">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel11" runat="server" Text="Punktgrafik"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:FileArchive runat="server" name="Graphics2" ID="Graphics2" ShowPreview="True" CssClass="std"></dw:FileArchive>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel12" runat="server" Text="Font"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="Font2" runat="server" name="Font2" class="std"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel13" runat="server" Text="Fontstørrelse"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="FontSize2" runat="server" name="FontSize2" class="std" style="width: 150px;"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel15" runat="server" Text="Fontfarve"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:ColorSelect runat="server" ID="FontColor2" Name="FontColor2" First="false"></dw:ColorSelect>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <dw:CheckBox FieldName="IsBold2" ID="IsBold2" Value="True" runat="server" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
    <dw:GroupBox ID="gb_Style3" runat="server" Title="Niveau 3">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel20" runat="server" Text="Punktgrafik"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:FileArchive runat="server" name="Graphics3" ID="Graphics3" ShowPreview="True" CssClass="std"></dw:FileArchive>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel21" runat="server" Text="Font"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="Font3" runat="server" name="Font3" class="std"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel22" runat="server" Text="Fontstørrelse"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="FontSize3" runat="server" name="FontSize3" class="std" style="width: 150px;"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel23" runat="server" Text="Fontfarve"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:ColorSelect runat="server" ID="FontColor3" Name="FontColor3" First="false"></dw:ColorSelect>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <dw:CheckBox FieldName="IsBold3" ID="IsBold3" Value="True" runat="server" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
    <dw:GroupBox ID="gb_Style4" runat="server" Title="Niveau 4">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel25" runat="server" Text="Punktgrafik"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:FileArchive runat="server" name="Graphics4" ID="Graphics4" ShowPreview="True" CssClass="std"></dw:FileArchive>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel26" runat="server" Text="Font"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="Font4" runat="server" name="Font4" class="std"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel27" runat="server" Text="Fontstørrelse"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="FontSize4" runat="server" name="FontSize4" class="std" style="width: 150px;"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel28" runat="server" Text="Fontfarve"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:ColorSelect runat="server" ID="FontColor4" Name="FontColor4" First="false"></dw:ColorSelect>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <dw:CheckBox FieldName="IsBold4" ID="IsBold4" Value="True" runat="server" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
    <dw:GroupBox ID="gb_Style5" runat="server" Title="Niveau 5">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel30" runat="server" Text="Punktgrafik"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:FileArchive runat="server" name="Graphics5" ID="Graphics5" ShowPreview="True" CssClass="std"></dw:FileArchive>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel31" runat="server" Text="Font"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="Font5" runat="server" name="Font5" class="std"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel32" runat="server" Text="Fontstørrelse"></dw:TranslateLabel>
                </td>
                <td>
                    <select id="FontSize5" runat="server" name="FontSize5" class="std" style="width: 150px;"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="Translatelabel33" runat="server" Text="Fontfarve"></dw:TranslateLabel>
                </td>
                <td>
                    <dw:ColorSelect runat="server" ID="FontColor5" Name="FontColor5" First="false"></dw:ColorSelect>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <dw:CheckBox FieldName="IsBold5" ID="IsBold5" Value="True" runat="server" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>
<script type="text/javascript">
        if (document.getElementById('MenuArea').checked) {
            EnableArea();
        }
        else if (document.getElementById('MenuCurrentArea').checked) {
            EnableCurrentArea();
        }
        else {
            EnablePage();
        }
        SetDivOwnStyles();
        function SetDivOwnStyles() {
            if (document.getElementById('UseOwnStyles').checked) {
                EnableById('DivOwnStyles');
            }
            else {
                DisableById('DivOwnStyles');
            }
        }
        function EnablePage() {
            DisableById('TrArea');
            EnableById('TrPage');
        }
        function EnableArea() {
            DisableById('TrPage');
            EnableById('TrArea');
        }
        function EnableCurrentArea() {
            DisableById('TrPage');
            DisableById('TrArea');
        }
        function DisableById(id) {
            document.getElementById(id).style.display = 'none';
        }
        function EnableById(id) {
            document.getElementById(id).style.display = '';
        }
</script>

