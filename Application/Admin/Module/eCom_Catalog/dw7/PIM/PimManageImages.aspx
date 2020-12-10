<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PimManageImages.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.PimManageImages" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Filemanager/Browser/FileList.js" />
            <dw:GenericResource Url="/Admin/Filemanager/filemanager_browse2.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ProductImageBlocks.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/PIM/PimManageImages.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/PIM/PimManageImages.css" />
        </Items>
    </dw:ControlResources>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="cmd" name="cmd" />
        <input type="hidden" id="DoClose" name="DoClose" />
        <input type="hidden" id="fileManagerImages" name="fileManagerImages" />
        <dwc:Card runat="server">
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdSave" runat="server" Icon="Save" Text="Save" OnClientClick="currentPage.save();" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Icon="Save" Text="Save and close" OnClientClick="currentPage.save(true);" />
                <dw:ToolbarButton ID="cmdCansel" runat="server" Icon="Cancel" IconColor="Danger" Text="Cancel" OnClientClick="currentPage.cancel();" />
                <dw:ToolbarButton ID="cmdAssign" runat="server" Icon="ObjectGroup" Text="Assign to asset category" OnClientClick="dialog.show('SelectImageGroupDialog');" Disabled="true" />
                <dw:ToolbarButton ID="cmdDetach" runat="server" Icon="Remove" Text="Detach" OnClientClick="currentPage.deleteSelected();" Disabled="true" />
            </dw:Toolbar>
            <div class="image-groups-cnt" runat="server" id="ImagesContainer">
                <asp:Repeater runat="server" ID="ImagesRepeater">
                    <ItemTemplate>
                        <dwc:GroupBox runat="server" ID="ImageGroupBox" ClassName="sortable">
                            <dw:List runat="server" ID="ImageList" Title="" ShowTitle="false" StretchContent="false" PageSize="300" AllowMultiSelect="true" NoItemsMessage="No images" OnClientSelect="currentPage.onRowSelected();" />
                        </dwc:GroupBox>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="default-image-cnt" runat="server" id="DefaultImageContainer">
                <dw:TranslateLabel runat="server" Text="Primary image" UseLabel="true" />
                <img id="MissingDefaultImage" runat="server" src="/Admin/Images/eCom/missing_image.jpg" >
                <img id="DefaultImage" runat="server" class="hidden">
            </div>

            <dw:Dialog ID="SelectImageGroupDialog" runat="server" Title="Assign to asset category" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" OkAction="currentPage.changeCategory();">
                <dwc:GroupBox runat="server">
                    <dwc:SelectPicker ID="ImageGroupPicker" runat="server" Label="Asset category"></dwc:SelectPicker>
                </dwc:GroupBox>
            </dw:Dialog>
        </dwc:Card>
    </form>
</body>
</html>
