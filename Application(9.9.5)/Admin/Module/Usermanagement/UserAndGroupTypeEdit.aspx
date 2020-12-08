<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UserAndGroupTypeEdit.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement.UserAndGroupTypeEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>User and group type</title>

    <dw:ControlResources IncludePrototype="True" IncludeUIStylesheet="true" runat="server" >
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Ajax.js" />
            <dw:GenericResource Url="/Admin/Module/UserManagement/js/UserAndGroupTypeEdit.js" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.css" />
            <dw:GenericResource Url="/Admin/Module/UserManagement/css/UserAndGroupTypeEdit.css" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <form id="MainForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader ID="cardHeader" Title="User and group type" runat="server"></dwc:CardHeader>
            <div id="breadcrumb" runat="server"></div>
            <dwc:CardBody ID="cardBody" runat="server">
                <dwc:GroupBox runat="server" Title="settings">
                    <dwc:InputText id="txtName" runat="server" Label="Name" ValidationMessage="" />
                    <dwc:InputText id="txtSystemName" runat="server" Label="System name" ValidationMessage="" />
                    <dwc:InputTextArea id="txtDescription" runat="server" Label="Description" Rows="5" />
                    <dwc:RadioGroup id="grpTemplateType" runat="server" Label="Template type">
                        <dwc:RadioButton ID="btnUser" runat="server" Label="User" FieldValue="user" />
                        <dwc:RadioButton ID="btnGroup" runat="server" Label="Group" FieldValue="group" />
                    </dwc:RadioGroup>
                    <div class="dw-ctrl form-group">
                        <label class="control-label"><dw:TranslateLabel ID="lbIcon" Text="Icon" runat="server" /></label>	
                        <div class="form-group-input">
                            <i id="UserAndGroupTypeIcon" class="size-3x"></i>                            
                            <input type="hidden" id="SmallIcon" name="SmallIcon" value="<%=UserAndGroupType.Icon.ToString()%>" />
                            <input type="hidden" id="IconColor" name="IconColor" value="<%=UserAndGroupType.IconColor%>" />
                            <dwc:Button runat="server" ID="EditIcon" OnClick="dialog.show('dlgIconSettings');" Title="Edit" />
	                    </div>
                    </div>
                </dwc:GroupBox>
                <dw:GroupBox ID="gbRestrictions" Title="Restrictions" runat="server">
                    <dwc:CheckBoxGroup runat="server" ID="AllowedParents" Name="AllowedParents" Label="Allowed parents"></dwc:CheckBoxGroup>
                </dw:GroupBox>
                <dwc:GroupBox runat="server" Title="Field definitions">
                    <table id="fieldDefinitions" class="fieldsTable table">
                        <tr>
                            <th><%= Translate.Translate("Fields")%></th>
                            <th>
                                <%= Translate.Translate("Show")%>
                                <a href="javascript:void(0);" class="columnMenu" onclick="return ContextMenu.show(event, 'ContextMenuVisible', '0','','BottomRightRelative');"><i class="fa fa-caret-down"></i></a>
                            </th>
                            <th>
                                <%= Translate.Translate("Read only")%>
                                <a href="javascript:void(0);" class="columnMenu" onclick="return ContextMenu.show(event, 'ContextMenuReadOnly', '0','','BottomRightRelative');"><i class="fa fa-caret-down"></i></a>
                            </th>
                            <th>
                                <%= Translate.Translate("Hidden")%>
                                <a href="javascript:void(0);" class="columnMenu" onclick="return ContextMenu.show(event, 'ContextMenuHidden', '0','','BottomRightRelative');"><i class="fa fa-caret-down"></i></a>
                            </th>
                        </tr>
                        <%= GetStandardUserFields()%>
                        <%= GetCustomFields("AccessUser")%>
                        <%= GetCustomFields("AccessUserAddress")%>
                        <%= GetSystemFields()%>
                    </table>
                </dwc:GroupBox>
            </dwc:CardBody>
            <dwc:CardFooter ID="cardFooter" runat="server">
                <div class="row">
                    <div class="col-sm-1">
                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Cube, True) %> size-2x"></i>
                    </div>
                    <div class="col-sm-8">
                        <div><dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Navn" />:&nbsp;<span id="bottomInfoName" runat="server"></span></div>
                        <div><dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="System name" />:&nbsp;<span id="bottomInfoSystemName" runat="server"></span></div>
                    </div>
                </div>
            </dwc:CardFooter>
        </dwc:Card>
        <dwc:ActionBar runat="server">
            <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" KeyboardShortcut="ctrl+s" ID="cmdSave" OnClientClick="currentPage.save(false);">
            </dw:ToolbarButton>
            <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" OnClientClick="currentPage.save(true);">
            </dw:ToolbarButton>
            <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="currentPage.cancel();" ID="cmdCancel">
            </dw:ToolbarButton>
        </dwc:ActionBar>

        <dw:ContextMenu ID="ContextMenuVisible" runat="server">
            <dw:ContextMenuButton ID="btnCheckAllVisible" runat="server" Icon="Check" Text="Check all" OnClientClick="currentPage.checkAll('Visible')"></dw:ContextMenuButton>
        </dw:ContextMenu>

        <dw:ContextMenu ID="ContextMenuReadOnly" runat="server">
            <dw:ContextMenuButton ID="btnCheckAllReadOnly" runat="server" Icon="Check" Text="Check all" OnClientClick="currentPage.checkAll('ReadOnly')"></dw:ContextMenuButton>
        </dw:ContextMenu>

        <dw:ContextMenu ID="ContextMenuHidden" runat="server">
            <dw:ContextMenuButton ID="btnCheckAllHidden" runat="server" Icon="Check" Text="Check all" OnClientClick="currentPage.checkAll('Hidden')"></dw:ContextMenuButton>
        </dw:ContextMenu>

        <dw:Dialog ID="dlgIconSettings" Title="Icon Settings" Size="Large" OkAction="currentPage.selectIcon();" ShowOkButton="true" ShowCancelButton="false" runat="server">
            <div class="filters">
                <div class="form-group">
                    <label class="control-label"><dw:TransLateLabel runat="server" Text="Color" /></label>
                    <select class="selectpicker" ID="IconColorSelect">
                        <asp:Repeater runat="server" ID="IconColorSelectItems">
                            <ItemTemplate>
                                <option value="<%#Core.UI.KnownColorInfo.ClassNameFor(CType(Container.DataItem, Core.UI.KnownColor))%>" <%#If(CType(Container.DataItem, Core.UI.KnownColor) = UserAndGroupType.IconColor, "selected", "")%> class="<%#Core.UI.KnownColorInfo.ClassNameFor(CType(Container.DataItem, Core.UI.KnownColor))%>"><%#CType(Container.DataItem, Core.UI.KnownColor).ToString()%></option>
                            </ItemTemplate>
                        </asp:Repeater>
                    </select>
                </div>
                <dwc:InputText Label="Filter" ID="IconSearch" runat="server" />
            </div>
            <div class="icon-settings">
                <asp:Repeater runat="server" ID="IconsRepeater">
                    <ItemTemplate>
                        <div class="icon-block<%#if(CType(Container.DataItem, KnownIcon) = UserAndGroupType.Icon, " selected","")%>">
                            <i class="size-3x <%#KnownIconInfo.ClassNameFor(CType(Container.DataItem, KnownIcon), True, UserAndGroupType.IconColor)%>" title="<%#KnownIconInfo.ClassNameFor(CType(Container.DataItem, KnownIcon), True)%>"></i>
                            <span class="icon-block-label"><%#CType(Container.DataItem, KnownIcon).ToString()%></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="separator-10">&nbsp;</div>
        </dw:Dialog>

        <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
    </form>
</body>
</html>
