<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Edit.aspx.vb" Inherits="Dynamicweb.Admin.DirectPaths_Edit" %>

<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>


<html>
<head id="PageHeader" runat="server">
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Content/JsLib/dw/Utilities.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>
        <script src="/Admin/Content/Management/DirectPaths/List.js" type="text/javascript"></script>
    </dwc:ScriptLib>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" ID="CardHeader1" Title="Rediger"></dwc:CardHeader>
                <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdSave" runat="server" Disabled="false" Divide="None" Icon="Save" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSave')) {{ DirectPaths.editSave(false); }}" Text="Gem" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Disabled="false" Divide="None" Icon="Save" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSaveAndClose')) {{ DirectPaths.editSave(true); }}" Text="Gem og luk" />
                    <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" ShowWait="true" OnClientClick="DirectPaths.swichToListMode();" />
                    <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="None" Visible="false" Icon="Delete" OnClientClick="" Text="Delete" />
                </dw:Toolbar>
                <dwc:CardBody runat="server">
                    <dw:Infobar ID="ErrorMessage" Visible="false" Type="Error" Message="Please specify the path" runat="server" />
                    <span id="confirmDelete" style="display: none"><%=Translate.Translate("Slet?") %></span>
                    <asp:HiddenField ID="PostBackAction" runat="server" />
                    <dwc:GroupBox ID="GroupBox1" runat="server" Title="" GroupWidth="6">
                        <dwc:InputText runat="server" ID="ItemPath" Label="Sti" />

                        <div class="form-group">
                            <label class="control-label" for="ItemRedirect"><%=Translate.Translate("Link")%></label>
                            <dw:LinkManager runat="server" ID="ItemRedirect" />
                        </div>

                        <dwc:SelectPicker ID="ddArea" runat="server" Label="Website" />

                        <dwc:RadioGroup runat="server" ID="ItemStatus" Name="ItemStatus" Label="Status" >
                            <dwc:RadioButton FieldValue="200" Label="Behold sti (200 OK)" DoTranslation="true" runat="server" />
                            <dwc:RadioButton FieldValue="301" Label="Vidersend til link (301 Moved Permanently)" DoTranslation="true" runat="server" />
                            <dwc:RadioButton FieldValue="302" Label="Vidersend til link (302 Moved Temporarily)" DoTranslation="true" runat="server" />
                        </dwc:RadioGroup>

                        <dwc:CheckBox ID="ItemActive" Name="ItemActive" Value="True" Label="Aktiv" runat="server" />
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
            <% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
        </form>
    </div>
</body>
</html>
