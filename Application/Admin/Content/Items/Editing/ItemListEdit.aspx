<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ItemListEdit.aspx.vb" Inherits="Dynamicweb.Admin.ItemListEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
    <head id="Head1" runat="server">
        <title></title>
        <dw:ControlResources ID="ControlResources1" CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true" runat="server">
            <Items>                
                <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
                <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />                
                <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
                <dw:GenericResource Url="/Admin/Content/Items/js/Preset.js" />
                <dw:GenericResource Url="/Admin/Link.js" />
                <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
                <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
                <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
                <dw:GenericResource Url="/Admin/Content/Items/js/ItemListEdit.js" />
                <dw:GenericResource Url="/Admin/Content/Items/css/ItemEdit.css" />
                <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
                <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" />
            </Items>
        </dw:ControlResources>
        <style type="text/css">
           div.tox {
               z-index: 10000;
           } 
        </style>
    </head>
    <% If InstantSave Then %>
        <body class="screen-container">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="List item"></dwc:CardHeader>
                <dwc:CardBody runat="server">
                    <form enableviewstate="false" runat="server">
                        <input type="hidden" id="hClose" name="Close" value="False" />
                        <div id="content">
                            <div id="content-item" class="clearfix">
                                <asp:Literal ID="litFieldsPlainPage" runat="server" />
                            </div>
                        </div>
                    </form>
                </dwc:CardBody>
                <dwc:CardFooter runat="server">
                   <dwc:ActionBar runat="server">
                        <dw:ToolbarButton ID="cmdSave" Size="Small" Image="NoImage" KeyboardShortcut="ctrl+s" OnClientClick="Dynamicweb.Items.ItemListEdit.get_current().save();" Text="Save" runat="server" />
                        <dw:ToolbarButton ID="cmdSaveAndClose" Size="Small" Image="NoImage" OnClientClick="Dynamicweb.Items.ItemListEdit.get_current().saveAndClose();" Text="Save and close" runat="server" />
                        <dw:ToolbarButton ID="cmdCancel" Size="Small" Image="NoImage" OnClientClick="Dynamicweb.Items.ItemListEdit.get_current().cancel();"  Text="Cancel" runat="server" />
                     </dwc:ActionBar>
                </dwc:CardFooter>
            </dwc:Card>
        </body>
    <% Else %>
        <dwc:DialogLayout runat="server" ID="ItemListEditDialog" Title="List item" HidePadding="True" Size="Large" Visible="False">
            <Content>
                <div class="col-md-0">
                    <input type="hidden" id="hClose" name="Close" value="False" />
                    <div id="content">
                        <div id="content-item">
                            <asp:Literal ID="litFieldsDlg" runat="server" />
                        </div>
                    </div>
                </div>
            </Content>
            <Footer>
                <button ID="cmdDlgSave" class="btn btn-link waves-effect" type="button" onclick="Dynamicweb.Items.ItemListEdit.get_current().save();" runat="server">Save</button>
                <button class="btn btn-link waves-effect" type="button" onclick="Dynamicweb.Items.ItemListEdit.get_current().saveAndClose();">Save and close</button>
                <button class="btn btn-link waves-effect" type="button" onclick="Dynamicweb.Items.ItemListEdit.get_current().cancel();">Cancel</button>
            </Footer>
        </dwc:DialogLayout>
    <% End If %>
    <%Translate.GetEditOnlineScript()%>
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
