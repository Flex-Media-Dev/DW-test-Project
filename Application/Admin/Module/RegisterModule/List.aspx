<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="List.aspx.vb" Inherits="Dynamicweb.Admin.RegisterModule.List6" %>

<!DOCTYPE html>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <script type="text/javascript" src="js/module.js"></script>
    <script type="text/javascript">
        function del(ID) {
            if (confirm('<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("modul"))%>')) {
                location = "Delete.aspx?ID=" + ID;
            }
        }

        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("registermodule", "modules.registermodule.list")%>
        }

    </script>
</head>
<body class="area-black screen-container">
    <div class="card">
        <form id="form1" runat="server">
                <div class="card-header">
                    <h2 class="subtitle">
                        <dw:TranslateLabel ID="lbSetup" Text="Moduler" runat="server" />
                    </h2>
                </div>

                <dw:Toolbar ID="Buttons" runat="server" ShowEnd="false">
                    <dw:ToolbarButton ID="NewModule" runat="server" Divide="None" Icon="PlusSquare"
                        Text="Nyt modul" OnClientClick="module.addModule();">
                    </dw:ToolbarButton>
                    <dw:ToolbarButton ID="ToolbarButton3" runat="server" Divide="None" Icon="Help" Text="Help"
                        OnClientClick="help();">
                    </dw:ToolbarButton>
                </dw:Toolbar>

                <dw:List ID="List1" StretchContent="true" Title="Moduler" runat="server" AllowMultiSelect="false" ShowTitle="false"
                    PageSize="25">
                    <Columns>
                        <dw:ListColumn ID="Name" runat="server" EnableSorting="true" WidthPercent="50" Name="Navn"></dw:ListColumn>
                        <dw:ListColumn ID="SystemName" runat="server" Name="Systemnavn" EnableSorting="true"></dw:ListColumn>
                    </Columns>
                </dw:List>
            <dw:ContextMenu ID="ModulesMenu" runat="server">
                <dw:ContextMenuButton ID="EditModule" runat="server" Divide="None" Icon="Pencil"
                    Text="Edit module" OnClientClick="module.editClick();">
                </dw:ContextMenuButton>
                <dw:ContextMenuButton ID="DeleteModule" runat="server" Divide="Before" Icon="Delete"
                    Text="Delete module" OnClientClick="module.deleteClick();">
                </dw:ContextMenuButton>
            </dw:ContextMenu>
        </form>
    </div>
    <%
        Translate.GetEditOnlineScript()
    %>
</body>
</html>
