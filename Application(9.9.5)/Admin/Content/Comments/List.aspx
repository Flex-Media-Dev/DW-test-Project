<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="List.aspx.vb" Inherits="Dynamicweb.Admin.List5" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server" />
    <script type="text/javascript">
        var ItemID = '<%=ItemID %>';
        var Type = '<%=Type %>';
        var LangID = '<%=LangID %>';
        var IsFullPage = '<%=IsFullPage %>';
        var IsNewNavigator = '<%=IsNewNavigator %>';
         
        var titleEl = parent.document.getElementById("T_CommentsDialog");
        if (titleEl) {
            var cleanTitle = titleEl.getAttribute("data-clean-title");
            if (!cleanTitle) {
                cleanTitle = titleEl.innerHTML;
                titleEl.setAttribute("data-clean-title", cleanTitle);
            }
            titleEl.innerHTML = cleanTitle + ' (' + <%=CommentsCount %> + ')';
        }
    </script>
    <script src="Comments.js" type="text/javascript"></script>
</head>
<body <%=If(IsNewNavigator, "class=""screen-container""", String.Empty) %>>
    <dwc:Card runat="server">
        <dwc:CardHeader ID="CardHeader" runat="server" Title="Comments" />
        <dwc:CardBody runat="server">
            <form id="form1" runat="server">
                <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowStart="false">
                    <dw:ToolbarButton ID="AddToolbarBtn" runat="server" Divide="None" Icon="PlusSquare" Text="Tilføj" OnClientClick="add();">
                    </dw:ToolbarButton>
                </dw:Toolbar>
                <dw:List ID="CommentList" runat="server" Title="Kommentarer" PageSize="25" ShowTitle="False">
                    <Columns>                        
                        <dw:ListColumn ID="ListColumn2" EnableSorting="true" runat="server" Name="Dato" Width="140"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn3" EnableSorting="true" runat="server" Name="Navn" Width="0"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn7" EnableSorting="true" runat="server" Name="Active" Width="50" ItemAlign="Center"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn6" EnableSorting="true" runat="server" Name="Rating" Width="50" ItemAlign="Center"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn4" EnableSorting="true" runat="server" Name="Besked" Width="0"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn8" EnableSorting="true" runat="server" Name="Type" Width="0"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn9" EnableSorting="true" runat="server" Name="Object ID" Width="0"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn5" EnableSorting="false" runat="server" Name="" Width="25" ItemAlign="Center"></dw:ListColumn>
                    </Columns>
                </dw:List>
            </form>
        </dwc:CardBody>
    </dwc:Card>
</body>
</html>
