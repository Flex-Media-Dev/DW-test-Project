<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="IndexSearch_List.aspx.vb" Inherits="Dynamicweb.Admin.Repositories.IndexSearch_List" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Search for editors</title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>

    <script>
        function clickRow(name) {
            Action.Execute(<%=OnClick()%>, { Name: name });
        }

        function createNew() {
            location = '/Admin/Module/Repositories/IndexSearch_Edit.aspx'
        }
    </script>
</head>
<body class="screen-container">
    <div class="dw8-container">
        <form id="form1" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" ID="CardHeader" Title="Search for editors" />

                <dw:Toolbar ID="SurveyToolbar" runat="server" ShowStart="true" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="tbNew" runat="server" OnClientClick="createNew();" Icon="PlusSquare" Text="New configuration" Divide="After"></dw:ToolbarButton>
                </dw:Toolbar>
                <dwc:CardBody runat="server">
                    <dw:List ID="IndexList" ShowPaging="false" NoItemsMessage="No index search configurations found" ShowTitle="false" ShowCollapseButton="false" runat="server">
                        <Columns>
                            <dw:ListColumn ID="colName" runat="server" Name="Name" />
                        </Columns>
                    </dw:List>
                </dwc:CardBody>
            </dwc:Card>
        </form>
    </div>
</body>
</html>
