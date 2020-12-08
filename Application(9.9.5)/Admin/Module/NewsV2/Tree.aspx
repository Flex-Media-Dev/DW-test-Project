<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Tree.aspx.vb" Inherits="Dynamicweb.Admin.NewsV2.Tree" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <script type="text/javascript" src="js/main.js"></script>
    <script type="text/javascript" src="js/news.js"></script>
    <style type="text/css">
        .nav .title
        {
            width: 98%;
        }
        
        .nav .subtitle
        {
            width: 98%;
        }
        
        .nav .tree
        {
            width: 98%;
        }
    </style>
    <script type="text/javascript">
        news.filters = '<% = _filters %>';
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <dw:Tree ID="Tree1" runat="server" SubTitle="All categories" Title="Navigation" ShowRoot="false"
            OpenAll="false" UseSelection="true" UseCookies="false" LoadOnDemand="true" UseLines="true"
            ClientNodeComparator="function() {return 0;}">
            <dw:TreeNode ID="Root" NodeID="0" runat="server" Name="Root" ParentID="-1" />
        </dw:Tree>
    </div>
    </form>
</body>
</html>
