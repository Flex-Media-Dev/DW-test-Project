<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PresetItemEdit.aspx.vb" Inherits="Dynamicweb.Admin.PresetItemEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true" runat="server">
        <Items>                
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />                
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
            <dw:GenericResource Url="/Admin/Content/Items/js/PresetItemEdit.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/ItemEdit.css" />
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
    <dwc:DialogLayout runat="server" ID="ItemEditDialog" Title="Edit item" HidePadding="True" Size="Large">
        <Content>
            <div class="col-md-0">
                <div id="content">
                    <asp:Literal ID="litFieldsDlg" runat="server" />
                </div>
            </div>
        </Content>
        <Footer>
            <button runat="server" id="cmdSave" class="btn btn-link waves-effect" type="button" onclick="Dynamicweb.Items.PresetItemEdit.get_current().save();"><%= Translate.Translate("Save") %></button>
            <button runat="server" id="cmdCreateNewPreset"  class="btn btn-link waves-effect" type="button" onclick="Dynamicweb.Items.PresetItemEdit.get_current().newPreset();"><%= Translate.Translate("Create new preset") %></button>
            <button runat="server" id="cmdOverwritePreset"  class="btn btn-link waves-effect" type="button" onclick="Dynamicweb.Items.PresetItemEdit.get_current().overwritePreset();"><%= Translate.Translate("Overwrite preset") %></button>
            <button class="btn btn-link waves-effect" type="button" onclick="Dynamicweb.Items.PresetItemEdit.get_current().cancel();"><%= Translate.Translate("Cancel") %></button>
        </Footer>
    </dwc:DialogLayout>
    <script type="text/javascript">
        //fixed dropdown buttons in editor dialog not working
        if (window.CKEDITOR) {
            for (var i in window.CKEDITOR.instances) {
                (function (i) {
                    var editor = CKEDITOR.instances[i];
                    editor.on("instanceReady", function () {
                        editor.config.baseFloatZIndex = 10000;
                    });
                })(i);
            }
        }
    </script>
</html>
