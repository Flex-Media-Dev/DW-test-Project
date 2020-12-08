<%@ Page CodeBehind="Filepublish_Edit.aspx.vb" ValidateRequest="false" Language="vb" AutoEventWireup="false" Inherits="Dynamicweb.Admin.Filepublish_Edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Modules" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<dw:ModuleHeader ID="ModuleHeader1" runat="server" ModuleSystemName="Filepublish" />
<dw:ModuleSettings ID="ModuleSettings1" runat="server" ModuleSystemName="Filepublish" Value="FilepublishFolder, FilepublishTemplate, FilepublishTemplateItem, FilepublishForceDownload, FilepublishShowSubdirs, FilepublishIconFolder, FilepublishUploadFolder, FilepublishUploadTemplate, FilepublishUploadNotify, FilepublishUploadSubject, FilepublishUploadRecipient, FilepublishUploadRecipientCC, FilepublishUploadRecipientBCC, FilepublishUploadText, FilepublishUploadConfirm, FilepublishUploadDestination, FilepublishDirUpText, FilepublishSortOrder, FilepublishSortBy" />

<dw:GroupBox ID="GroupBox1" runat="server" Title="Visning" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td><%=Translate.Translate("Mappe")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.FolderManager(prop.Value("FilepublishFolder"), "FilepublishFolder")%></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Tving download")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.CheckBox(prop.Value("FilepublishForceDownload"), "FilepublishForceDownload")%></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Vis undermapper")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.CheckBox(prop.Value("FilepublishShowSubdirs"), "FilepublishShowSubdirs")%></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Ikon mappe")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.FolderManager(prop.Value("FilepublishIconFolder"), "FilepublishIconFolder")%></td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="GroupBox2" runat="server" Title="Sortering" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td><%=Translate.Translate("Sorter efter")%></td>
            <td>
                <div class="radio"><%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("FilepublishSortBy"), "FilepublishSortBy", "Name")%>&nbsp;<label for="FilepublishSortByName"><%=Translate.Translate("Navn")%></label></div>
                <div class="radio"><%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("FilepublishSortBy"), "FilepublishSortBy", "Date")%>&nbsp;<label for="FilepublishSortByDate"><%=Translate.Translate("Dato")%></label></div>
                <div class="radio"><%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("FilepublishSortBy"), "FilepublishSortBy", "Size")%>&nbsp;<label for="FilepublishSortBySize"><%=Translate.Translate("Størrelse")%></label></div>
            </td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Sortering")%></td>
            <td>
                <div class="radio"><%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("FilepublishSortOrder"), "FilepublishSortOrder", "DESC")%>&nbsp;<label for="FilepublishSortOrderDESC"><%=Translate.Translate("Faldende")%></label></div>
                <div class="radio"><%=Dynamicweb.SystemTools.Gui.RadioButton(prop.Value("FilepublishSortOrder"), "FilepublishSortOrder", "ASC")%>&nbsp;<label for="FilepublishSortOrderASC"><%=Translate.Translate("Stigende")%></label></div>
            </td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="GroupBox3" runat="server" Title="Upload" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td><%=Translate.Translate("Mappe")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.FolderManager(prop.Value("FilepublishUploadFolder"), "FilepublishUploadFolder")%></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Notificer")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.CheckBox(prop.Value("FilepublishUploadNotify"), "FilepublishUploadNotify")%></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Emne")%></td>
            <td>
                <input type="Text" name="FilepublishUploadSubject" value="<%=prop.Value("FilepublishUploadSubject")%>" class="std"></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Modtager")%></td>
            <td>
                <input type="Text" name="FilepublishUploadRecipient" value="<%=prop.Value("FilepublishUploadRecipient")%>" class="std"></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Modtager CC")%></td>
            <td>
                <input type="Text" name="FilepublishUploadRecipientCC" value="<%=prop.Value("FilepublishUploadRecipientCC")%>" class="std"></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Modtager BCC")%></td>
            <td>
                <input type="Text" name="FilepublishUploadRecipientBCC" value="<%=prop.Value("FilepublishUploadRecipientBCC")%>" class="std"></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Tekst")%></td>
            <td>
                <textarea class="std" name="FilepublishUploadText" rows="5"><%=prop.Value("FilepublishUploadText")%></textarea></td>
        </tr>
        <tr>
            <td valign="top"><%=Translate.Translate("Side efter indsendelse")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.LinkManager(prop.Value("FilepublishUploadConfirm"), "FilepublishUploadConfirm", "")%></td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="GroupBox4" runat="server" Title="Brugerdefinerede tekster" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td><%=Translate.Translate("Op")%></td>
            <td>
                <input type="Text" name="FilepublishDirUpText" value="<%=prop.Value("FilepublishDirUpText")%>" class="std"></td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="GroupBox5" runat="server" Title="Templates" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td><%=Translate.Translate("Liste")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.FileManager(prop.Value("FilepublishTemplate"), "Templates/Filepublish", "FilepublishTemplate")%></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Liste element")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.FileManager(prop.Value("FilepublishTemplateItem"), "Templates/Filepublish", "FilepublishTemplateItem")%></td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Upload")%></td>
            <td><%=Dynamicweb.SystemTools.Gui.FileManager(prop.Value("FilepublishUploadTemplate"), "Templates/Filepublish", "FilepublishUploadTemplate")%></td>
        </tr>
    </table>
</dw:GroupBox>


<%
    Translate.GetEditOnlineScript()
%>