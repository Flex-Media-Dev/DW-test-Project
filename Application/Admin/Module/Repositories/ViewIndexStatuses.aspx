<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewIndexStatuses.aspx.vb" Inherits="Dynamicweb.Admin.Repositories.ViewIndexStatuses" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>All indexes</title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>

    <script>
        function clickIndex(repository, item) {
            Action.Execute(<%=OnClickAction()%>, {Repository: repository, Item: item});
        }
    </script>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader" Title="All indexes" />
            <dwc:CardBody runat="server">
                <dw:List ID="IndexList" ShowPaging="false" NoItemsMessage="No indexes in the solution" ShowTitle="false" ShowCollapseButton="false" runat="server">
                    <Columns>
                        <dw:ListColumn Id="colIcon" runat="server" />
                        <dw:ListColumn Id="colRepository" runat="server" Name="Repository" />
                        <dw:ListColumn Id="colIndex" runat="server" Name="Index" />
                        <dw:ListColumn Id="colInstanceCount" runat="server" Name="Instances" />
                        <dw:ListColumn Id="colIsOnlineInstance" runat="server" Name="Online instance" />
                        <dw:ListColumn Id="colLastRun" runat="server" Name="Last run" />
                        <dw:ListColumn Id="colDuration" runat="server" Name="Last runtime" />
                        <dw:ListColumn Id="colNextRun" runat="server" Name="Next run" />
                        <dw:ListColumn Id="colBalancer" runat="server" Name="Balancer" />
                    </Columns>
                </dw:List>
            </dwc:CardBody>
        </dwc:Card>
    </form>
</body>
</html>
