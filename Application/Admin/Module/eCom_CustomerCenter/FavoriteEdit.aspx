<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FavoriteEdit.aspx.vb" Inherits="Dynamicweb.Admin.FavoriteEdit" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ControlResources1" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Images/Controls/EditableList/EditableListEditors.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="js/FavoriteEdit.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {
            favoriteEdit.initialize(document.getElementById('form1'), <%= _listId %>, '<%= _mode %>', '<%= IsGroupFavorite %>' === 'True');
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <input type="hidden" id="Cmd" name="Cmd" />
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Edit favorite list"></dwc:CardHeader>
        <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false" >
            <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Icon="Save" Text="Save" OnClientClick="favoriteEdit.save();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Icon="Save" Text="Save and close" OnClientClick="favoriteEdit.saveAndClose();"></dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdClose" runat="server" Divide="None" Icon="Cancel" Text="Cancel" OnClientClick="favoriteEdit.cancel();"></dw:ToolbarButton>
        </dw:Toolbar>
        <dwc:GroupBox ID="GroupBox1" runat="server">
            <dwc:InputText ID="FavoriteListName" runat="server" Label="Name" MaxLength="255" ></dwc:InputText>
            <dwc:InputTextArea ID="FavoriteListDescription" runat="server" Label="Description" ></dwc:InputTextArea>
            <dwc:InputText ID="FavoriteListType" runat="server" Label="Type" MaxLength="255" ></dwc:InputText>
            <div class="dw-ctrl input-ctrl form-group">
                <label class="control-label"><dw:TranslateLabel Text="User" runat="server" ID="userSelectorLabel" /></label>
	            <div class="form-group-input">
                    <dw:EditableListColumnUserEditor ID="UserID_CustomSelector" runat="server" />
                    <small class="help-block error" id="helpFavoriteListName"></small>
        	    </div>
            </div>
            <dw:DateSelector runat="server" ID="FavoritePublishedDate" Label="Published to date" ></dw:DateSelector>
            <dwc:CheckBox ID="FavoriteIsPublished" runat="server" Label="Is published" />
            <dwc:CheckBox ID="FavoriteIsDefault" runat="server" Label="Is default" />
        </dwc:GroupBox>
    </dwc:Card>
    </form>
</body>
</html>
