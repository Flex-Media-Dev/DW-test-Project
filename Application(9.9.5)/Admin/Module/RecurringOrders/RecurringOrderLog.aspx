<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecurringOrderLog.aspx.vb" Inherits="Dynamicweb.Admin.RecurringOrders.RecurringOrderLog" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>
<html>
<head>    
        <dw:ControlResources ID="ctrlResources" runat="server">
            <Items>
            </Items>
        </dw:ControlResources>
    <style type="text/css">
        table.tabTable{
            height:0px;
        }
        table.tabTable tbody tr td{
            padding:0px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">                       
    <dw:List ID="EventsLst" ShowFooter="true" runat="server" TranslateTitle="True" StretchContent="true" PageSize="25" ShowPaging="true" Title="Recurring order log" Height="480"  Width="784">
        <Columns>
			<dw:ListColumn ID="colTime" runat="server" Name="Time" EnableSorting="true" Width="160" />
			<dw:ListColumn ID="colMessage" runat="server" Name="Message" EnableSorting="false" />
        </Columns>
    </dw:List>        
        <%Translate.GetEditOnlineScript()%>
    </form>
</body>
</html>


