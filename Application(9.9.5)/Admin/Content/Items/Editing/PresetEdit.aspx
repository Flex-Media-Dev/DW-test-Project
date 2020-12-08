<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PresetEdit.aspx.vb" Inherits="Dynamicweb.Admin.PresetEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true" runat="server">
        <Items>                
            <dw:GenericResource Url="/Admin/Link.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
</head>
<% If False Then %>
<body>
    <form enableviewstate="false" runat="server">
    </form>
</body>
<% End If %>
    <dwc:DialogLayout runat="server" ID="PresetEditDialog" Title="Preset" HidePadding="False" Size="Medium">
        <Content>
            <div class="col-md-0">
                <div id="content">
                    <div runat="server" id="EditContent" visible="false">
                        <dwc:InputText runat="server" ID="PresetName" Label="Name" MaxLength="128"></dwc:InputText>
                        <dw:FileManager runat="server" ID="ImageSelector" FullPath="true" Folder="/images" Label="Image" />
                    </div>
                    <div runat="server" id="RemoveContent" visible="false">
                        <p>
                            <%= Translate.Translate("Are you sure you want to remove this preset @@?", "@@", Preset.Name) %>
                        </p>
                    </div>
                    <div runat="server" id="ResetContent" visible="false">
                        <p>
                            <%= Translate.Translate("Are you sure you want to reset this preset @@?", "@@", Preset.Name) %>
                        </p>
                    </div>
                </div>
            </div>
        </Content>
        <Footer>
            <button runat="server" id="cmdSave" class="btn btn-link waves-effect" type="button"><%= Translate.Translate("Save") %></button>
            <button runat="server" id="cmdOk" class="btn btn-link waves-effect" type="button"><%= Translate.Translate("Ok") %></button>
            <button runat="server" id="cmdCancel" class="btn btn-link waves-effect" type="button"><%= Translate.Translate("Cancel") %></button>
        </Footer>
    </dwc:DialogLayout>
</html>
