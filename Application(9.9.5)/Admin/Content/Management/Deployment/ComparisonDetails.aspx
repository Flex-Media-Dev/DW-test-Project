<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ComparisonDetails.aspx.vb" Inherits="Dynamicweb.Admin.ComparisonDetails" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Comparison</title>
    <dw:ControlResources CombineOutput="False" IncludePrototype="false" runat="server">
    </dw:ControlResources>
    <style>
        .table-diff {
            width:100%;
        }
        .table-diff td {
            border: 1px solid #000;
            padding: 10px;
        }
        .cd {
            color: red;
        }
        .ci {
            color: green;
        }
    </style>
</head>
<body>
    <form runat="server" enableviewstate="false">
        <div>
            <label></label>
        </div>
        <dw:List ID="DiffList" NoItemsMessage="No differences" Title="Differences" runat="server">
            <Columns>
                <dw:ListColumn Name="Field" runat="server" />
                <dw:ListColumn Name="Local" runat="server" />
                <dw:ListColumn Name="Remote" runat="server" />
            </Columns>
        </dw:List>
    </form>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>