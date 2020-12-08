<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="QueryEditor.aspx.vb" Inherits="Dynamicweb.Admin.Management.QueryAnalyzer.QueryEditor" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Filemanager/FileEditor/CodeMirror-5.21/lib/codemirror.js" type="text/javascript"></script>
        <script src="/Admin/Filemanager/FileEditor/CodeMirror-5.21/mode/sql/sql.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
        <link rel="stylesheet" href="/Admin/Filemanager/FileEditor/CodeMirror-5.21/lib/codemirror.css" />
        <link rel="stylesheet" href="/Admin/Resources/vendors/slim-select/slimselect.min.css" />
        <script src="/Admin/Resources/vendors/slim-select/slimselect.min.js"></script>
        <script src="/Admin/Resources/js/layout/dwselector.js"></script>
        <link href="QueryEditor.css" rel="stylesheet" />
        <script src="QueryEditor.js"></script>
    </dwc:ScriptLib>
</head>
<body class="area-blue">
    <div class="screen-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="SQL Firehose"></dwc:CardHeader>
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="ExecuteQuery" runat="server" Divide="None" Icon="Database" OnClientClick="currentPage.tryExecuteSqlQuery()" Text="Execute Query (Ctrl plus Enter)" />
            </dw:Toolbar>
            <dwc:CardBody runat="server" BodyType="ribbon">
                <form id="form1" runat="server">
                    <dwc:InputTextArea ID="txtSql" runat="server" Value="SELECT * FROM " Rows="20" ValidationMessage="" />
                    <div id="ListContainer">
                        <asp:Literal ID="listOutput" runat="server"></asp:Literal>
                    </div>
                    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
                    </dw:Overlay>
                </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript() %>
</html>
