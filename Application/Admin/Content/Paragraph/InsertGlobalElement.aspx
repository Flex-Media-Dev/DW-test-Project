<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="InsertGlobalElement.aspx.vb" Inherits="Dynamicweb.Admin.InsertGlobalElement" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta name="Cache-control" content="no-cache" />
    <meta http-equiv="Cache-control" content="no-cache" />
    <meta http-equiv="Expires" content="Tue, 20 Aug 1996 14:25:27 GMT" />

    <dw:ControlResources runat="server">
    </dw:ControlResources>

    <style type="text/css">
        #insertGlobalElementList_body tr {
            cursor: pointer;
        }

        .rightCorner {
            position: fixed;
            top: 27px;
            right: 0px;
        }
    </style>

</head>
<body class="area-blue modal-iframe">
    <form id="form1" runat="server">
        <dw:List ID="insertGlobalElementList" runat="server" Title="Include global paragraph" PageSize="20" ShowCollapseButton="False" AllowMultiSelect="True">
            <Filters>
                <dw:ListAutomatedSearchFilter ID="sFilter" runat="server" />
            </Filters>
            <Columns>
                <dw:ListColumn ID="ListColumn2" runat="server" Name="Afsnitsnavn" Width="0" EnableSorting="true"></dw:ListColumn>
                <dw:ListColumn ID="ListColumn4" runat="server" Name="I brug" Width="0" EnableSorting="true"></dw:ListColumn>
                <dw:ListColumn ID="ListColumn3" runat="server" Name="Fra" Width="0" EnableSorting="true"></dw:ListColumn>
            </Columns>
        </dw:List>

        <span class="rightCorner">
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowStart="false">
                <dw:ToolbarButton ID="ToolbarButton2" runat="server" Divide="None" Icon="PlusSquare" Text="Include Selected" OnClientClick="parent.insertMultiSelectGlobal(List);" EnableViewState="True">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="ToolbarButton1" runat="server" Divide="None" Icon="PlusSquare" Text="Tilføj" OnClientClick="parent.insertNewGlobalElement();">
                </dw:ToolbarButton>
            </dw:Toolbar>
        </span>
    </form>
</body>
</html>
