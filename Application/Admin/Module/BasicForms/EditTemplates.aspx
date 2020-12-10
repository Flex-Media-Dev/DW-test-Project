<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditTemplates.aspx.vb" Inherits="Dynamicweb.Admin.EditTemplates" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server">
        <Items>
            <dw:GenericResource Url="\Admin\Content\JsLib\dw\Ajax.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function goBack() {
            window.location = "ListForms.aspx";
        }

        function save(doClose) {
            document.getElementById('CMD').value = "save";
            if (doClose) {
                document.getElementById('DoClose').value = "true";
            }

            document.forms["mainForm"].submit();
        }
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Templates" />
        <form id="mainForm" runat="server">
            <dw:Toolbar runat="server">
                <dw:ToolbarButton ID="cmdSave" Text="Save" Icon="Save" OnClientClick="save(false);" runat="server" />
                <dw:ToolbarButton ID="cmdSaveAndClose" Text="Save and close" Icon="Save" OnClientClick="save(true);" runat="server" />
                <dw:ToolbarButton ID="cmdCancel" Text="Cancel" Icon="Cancel" OnClientClick="goBack();" runat="server" />
            </dw:Toolbar>
            <asp:HiddenField ID="CMD" Value="" runat="server" />
            <asp:HiddenField ID="DoClose" Value="false" runat="server" />

            <asp:Repeater ID="MasterRepeater" runat="server">
                <ItemTemplate>
                    <dwc:GroupBox ID="MasterGroup" DoTranslation="false" runat="server" Expandable="true">
                        <dw:FileManager ID="MasterFormTemplate" Label="Form" Folder="Templates/Forms/Form" FullPath="true" runat="server" />
                        <dw:FileManager ID="MasterEmailTemplate" Label="Email" Folder="Templates/Forms/Mail" FullPath="true" runat="server" />
                        <dw:FileManager ID="MasterReceiptTemplate" Label="Receipt" Folder="Templates/Forms/Mail" FullPath="true" runat="server" />
                        <asp:HiddenField ID="MasterId" runat="server" />

                        <asp:Repeater ID="LanguageRepeater" runat="server">
                            <ItemTemplate>
                                <dwc:GroupBox ID="LanguageGroup" DoTranslation="false" runat="server" Expandable="true">
                                    <dw:FileManager ID="LanguageFormTemplate" Label="Form" Folder="Templates/Forms/Form" FullPath="true" runat="server" />
                                    <dw:FileManager ID="LanguageEmailTemplate" Label="Email" Folder="Templates/Forms/Mail" FullPath="true" runat="server" />
                                    <dw:FileManager ID="LanguageReceiptTemplate" Label="Receipt" Folder="Templates/Forms/Mail" FullPath="true" runat="server" />
                                    <asp:HiddenField ID="LanguageId" runat="server" />
                                </dwc:GroupBox>
                            </ItemTemplate>
                        </asp:Repeater>

                    </dwc:GroupBox>
                </ItemTemplate>
            </asp:Repeater>
        </form>
        <dwc:CardFooter runat="server"></dwc:CardFooter>
    </dwc:Card>
</body>
</html>
