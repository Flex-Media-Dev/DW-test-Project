<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TranslationKey_Edit.aspx.vb" Inherits="Dynamicweb.Admin.TranslationKey_Edit" %>

<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>
        <dw:TranslateLabel ID="lblTitle" Text="Translation key edit" runat="server" UseLabel="False" />
    </title>

    <dwc:ScriptLib runat="server">
        <script type="text/javascript" src="/Admin/Content/Management/Dictionary/Dictionary.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js"></script>
    </dwc:ScriptLib>

    <script type="text/javascript">
        document.observe('dom:loaded', function () {
            Dictionary.TranslationKey_Edit.initialize();
        });
    </script>
</head>
<body class="area-blue">
    <div class="dw8-container">
    <form id="MainForm" runat="server">
        <input type="hidden" id="hIsNew" runat="server" value="" />
        <input type="hidden" id="hKeyName" runat="server" value="" />
        <input type="hidden" id="returnUrl" runat="server" value="" />

        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Translation key edit" />

            <dw:Toolbar runat="server">
                <dw:ToolbarButton Text="Save" Icon="Save" ID="cmdSave" OnClientClick="Dictionary.TranslationKey_Edit.save(false);" runat="server"></dw:ToolbarButton>
                <dw:ToolbarButton Text="Save and close" Icon="Save" ID="cmdSaveAndClose" OnClientClick="Dictionary.TranslationKey_Edit.save(true);" runat="server"></dw:ToolbarButton>
                <dw:ToolbarButton Text="Cancel" Icon="Cancel" ID="cmdCancel" OnClientClick="Dictionary.TranslationKey_Edit.close();" runat="server"></dw:ToolbarButton>
                <dw:ToolbarButton Text="Delete" Icon="Delete" ID="cmdDelete" OnClientClick="Dictionary.TranslationKey_Edit.delete();" runat="server"></dw:ToolbarButton>
            </dw:Toolbar>

            <dwc:CardBody runat="server">
                <div id="ErrKeyNameDelete" style="display: none;">
                    <dw:Infobar ID="ErrKeyNameDeleteStr" runat="server" Type="Error" Message="Can not delete nonexistent key" />
                </div>
                <dw:Infobar ID="ErrKeyNameExistsStr" runat="server" Type="Error" Visible="false"  Message="The key with this name already exists" />

                <dwc:GroupBox runat="server" Title="Key">
                    <div id="ErrKeyNameStr" style="color: Red; display: none;"><%=Translate.JsTranslate("A name is needed")%></div>

                    <dwc:InputText ID="KeyNameStr" runat="server" Label="Navn" />
                    <dwc:InputText ID="KeyDefaultValue" runat="server" Label="Default value" />
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Translations">
                    <dw:EditableGrid ID="RegionsGrid" CssClass="no-padding" ShowHeader="false" AllowMultiSelect="true" AllowAddingRows="false" AllowDeletingRows="false" runat="server" PageSize="10">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <div class="dw-ctrl textarea-ctrl form-group">
                                        <asp:Label runat="server" ID="CultureName" CssClass="control-label" />
                                        <div class="form-group-input">
                                            <asp:TextBox Rows="4" TextMode="MultiLine" runat="server" ID="Value" Text="" CssClass="form-control auto-size" />
                                        </div>
                                    </div>
                                    <asp:HiddenField runat="server" ID="CultureCode" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </dw:EditableGrid>

                    <div id="confirmDelete" style="display: none;"><%=Translate.JsTranslate("Delete translation key?")%></div>

                    <input type="hidden" id="SubAction" name="SubAction" runat="server" value="" />
                    <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button> 
                    <asp:Button ID="DeleteButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
                    <asp:Button ID="CloseButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button> 
                </dwc:GroupBox>
            </dwc:CardBody>
        </dwc:Card>
    </form>
    </div>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
