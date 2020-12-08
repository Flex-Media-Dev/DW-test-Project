<%@ Page Language="vb" AutoEventWireup="false" EnableViewState="false" CodeBehind="DataGroupEdit.aspx.vb" Inherits="Dynamicweb.Admin.DataGroupEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <dw:ControlResources CombineOutput="False" IncludePrototype="True" runat="server">
        <Items>
            <dw:GenericResource Url="js/DataGroupEdit.min.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="css/iconselector.css" />
        </Items>
    </dw:ControlResources>
    <title>Edit data group</title>
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            var groupName = document.getElementById('dataGroupName');
            groupName.focus();

            var groupId = document.getElementById('dataGroupId');
            IdFromNameGenerator(groupId, groupName);
        });
    </script>
</head>
<body>
    <form id="editForm" runat="server">
        <div class="screen-container">
            <dwc:Card runat="server">
                <dwc:CardHeader ID="cardHeader" Title="Edit data group" runat="server"></dwc:CardHeader>
                <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdAdd" runat="server" Icon="PlusSquare" Text="Add data item type" OnClientClick="currentPage.addDataItem()" />
                </dw:Toolbar>
                <dw:GroupBox ID="GroupOne" runat="server">
                    <dwc:InputText ID="dataGroupName" Name="dataGroupName" runat="server" Label="Name" ValidationMessage=""></dwc:InputText>
                    <dwc:InputText ID="dataGroupId" Name="dataGroupId" runat="server" Label="Id" ValidationMessage=""></dwc:InputText>
                    <div class="dw-ctrl form-group">
                        <label class="control-label"><dw:TranslateLabel ID="lbIcon" Text="Icon" runat="server" /></label>	
                        <div class="form-group-input">
                            <i id="IconSelector" class="size-3x"></i>                            
                            <dwc:Button runat="server" ID="EditIcon" OnClick="dialog.show('dlgIconSettings');" Title="Edit" />
	                    </div>
                    </div>
                </dw:GroupBox>
                <dw:List ID="dataGroupItemList" ShowPaging="false" NoItemsMessage="No data item types created" ShowTitle="false" runat="server">
                    <Columns>
                        <dw:ListColumn Name="Name" runat="server" />
                        <dw:ListColumn Name="Id" runat="server" />
                        <dw:ListColumn Name="Delete" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
            <dwc:ActionBar ID="actionBar" runat="server">
                <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500" OnClientClick="currentPage.save();">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" ID="cmdCancel" ShowWait="true" WaitTimeout="500" OnClientClick="currentPage.cancel();">
                </dw:ToolbarButton>
            </dwc:ActionBar>
        </div>
        <dw:Dialog ID="DataItemDetailsDialog" Title="Edit data item" Size="Medium" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" OkAction="currentPage.onDataItemEditOk();" runat="server">
            <iframe id="DataItemDetailsDialogFrame" name="DataItemDetailsDialogFrame"></iframe>
        </dw:Dialog>

        <dw:Dialog ID="dlgIconSettings" Title="Icon Settings" Size="Large" OkAction="currentPage.selectIcon();" ShowOkButton="true" ShowCancelButton="false" runat="server">
            <div class="filters">
                <div class="form-group">
                    <label class="control-label"><dw:TransLateLabel runat="server" Text="Color" /></label>
                    <select class="selectpicker" id="IconColorSelect">
                        <asp:Repeater runat="server" ID="IconColorSelectItems">
                            <ItemTemplate>
                                <option value="<%#Core.UI.KnownColorInfo.ClassNameFor(CType(Container.DataItem, Core.UI.KnownColor))%>" <%#if(CType(Container.DataItem, Core.UI.KnownColor) = CurrentDataGroupIconColor, "selected", "")%> class="<%#Core.UI.KnownColorInfo.ClassNameFor(CType(Container.DataItem, Core.UI.KnownColor))%>"><%#CType(Container.DataItem, Core.UI.KnownColor).ToString()%></option>
                            </ItemTemplate>
                        </asp:Repeater>
                    </select>
                </div>
                <dwc:InputText Label="Filter" ID="IconSearch" runat="server" />
            </div>
            <div class="icon-settings">
                <asp:Repeater runat="server" ID="IconsRepeater">
                    <ItemTemplate>
                        <div class="icon-block<%#if(CType(Container.DataItem, KnownIcon) = CurrentDataGroupIcon, " selected","")%>">
                            <i class="size-3x <%#KnownIconInfo.ClassNameFor(CType(Container.DataItem, KnownIcon), True, CurrentDataGroupIconColor)%>" title="<%#KnownIconInfo.ClassNameFor(CType(Container.DataItem, KnownIcon), True)%>"></i>
                            <span class="icon-block-label"><%#CType(Container.DataItem, KnownIcon).ToString()%></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="separator-10">&nbsp;</div>
        </dw:Dialog>
        <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
        <dw:Overlay runat="server"></dw:Overlay>
    </form>
</body>
</html>
