<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DataPortability_Edit.aspx.vb" Inherits="Dynamicweb.Admin.DataPortability_Edit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<dw:ModuleHeader ID="ModuleHeader" ModuleSystemName="DataPortability" runat="server" />
<dw:ModuleSettings ID="ModuleSettings" ModuleSystemName="DataPortability" Value="DataDefinition,FormTemplate" runat="server" />
<dw:GroupBox Title="Data" runat="server">
    <table class="formsTable">
        <tr>
            <td style="width: 170px;">
                <dw:TranslateLabel Text="Data definition" runat="server" />
            </td>
            <td>
                <select id="DataDefinition" name="DataDefinition" class="std" runat="server"></select>
            </td>
        </tr>
        <tr>
            <td style="width: 170px;">
                <dw:TranslateLabel Text="Form template" runat="server" />
            </td>
            <td>
                <dw:FileManager ID="FormTemplate" Name="FormTemplate" runat="server" />
            </td>
        </tr>
    </table>
</dw:GroupBox>