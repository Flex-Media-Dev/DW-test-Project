<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrder_History.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrder_History" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server">
    </dw:ControlResources>

    <style>
        .version-image {
            padding-top: 2px;
            cursor: pointer;
        }

        .version-selected {
            background-color: #eeeeee;
        }
    </style>

    <script>
        function viewOrder(orderId, versionId) {
            parent.window.openHistoryOrder(orderId, versionId);
        }

        function compareOrder(orderId, versionId) {
            parent.window.openCompareOrder(orderId, versionId);
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <dw:List ID="OrderHistory" runat="server" Title="History" PageSize="50">
            <Columns>
                <dw:ListColumn ID="c1" runat="server" Name="" Width="25" ItemAlign="Center" HeaderAlign="Center"></dw:ListColumn>
                <dw:ListColumn ID="c2" runat="server" Name="Version" Width="50" ItemAlign="Center" HeaderAlign="Center"></dw:ListColumn>
                <dw:ListColumn ID="c3" runat="server" Name="Modified" Width="370" ItemAlign="Left" HeaderAlign="Left"></dw:ListColumn>
                <dw:ListColumn ID="c4" runat="server" Name="Show" Width="50" ItemAlign="Center" HeaderAlign="Center"></dw:ListColumn>
                <dw:ListColumn ID="c5" runat="server" Name="Compare" Width="0" ItemAlign="Center" HeaderAlign="Center"></dw:ListColumn>
            </Columns>
        </dw:List>
    </form>
</body>
</html>
