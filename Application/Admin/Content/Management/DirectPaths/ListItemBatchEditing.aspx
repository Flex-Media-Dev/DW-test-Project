<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListItemBatchEditing.aspx.vb" Inherits="Dynamicweb.Admin.ListItemBatchEditing" %>

<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Backend" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Content/JsLib/dw/Utilities.js" type="text/javascript"></script>
        <script src="/Admin/Content/JsLib/dw/Ajax.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js" type="text/javascript"></script>
        <script src="/Admin/Content/Management/DirectPaths/List.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>
    </dwc:ScriptLib>
    <style type="text/css">
        .invalidcell {
            border: 1px dashed #FF0000;
            background-color: #FFFF99;
        }
        .linkmanagercell > div{
            min-width: 160px;
        }
        @media (max-width: 1030px) {
	        .NewUIinput {
		        width:auto!important;
	        }
        }
    </style>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <asp:HiddenField ID="pathIds" runat="server" />
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" ID="CardHeader1" Title="Direkte_stier"></dwc:CardHeader>

                <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" runat="server" Disabled="false" Divide="None" Icon="Save" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSave')) {{ DirectPaths.batchMode_Save(false); }}" Text="Gem" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Disabled="false" Divide="None" Icon="Save" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSaveAndClose')) {{ DirectPaths.batchMode_Save(true); }}" Text="Gem og luk" />
                    <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" ShowWait="true" OnClientClick="DirectPaths.swichToListMode();" />
                </dw:Toolbar>
                <dwc:CardBody runat="server">
                    <asp:Literal ID="errorOutput" runat="server" Text=""></asp:Literal>
                    <div id="gridcontainer">
                        <dw:EditableGrid ID="Items" runat="server" EnableViewState="true" OnRowDataBound="Items_OnRowDataBound" NewRowInitialize="Items_OnNewRowInitialize"
                            DraggableColumnsMode="First" EnableSmartNavigation="True" AllowDeletingRows="true" AllowAddingRows="true">
                        </dw:EditableGrid>
                    </div>
                    <asp:HiddenField ID="SubAction" runat="server" />
                    <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
                </dwc:CardBody>
            </dwc:Card>
            <% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
        </form>
        <script type="text/javascript">
            (function ($) {
                $(function () {
                    DirectPaths.batchMode_ListInit();
                });
            })(jQuery);
        </script>
    </div>
</body>
</html>
