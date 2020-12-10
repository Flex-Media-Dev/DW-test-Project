<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="HealthReport.aspx.vb" Inherits="Dynamicweb.Admin.HealthReport" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Health report</title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/Management/Health/HealthReport.js" />            
        </Items>
    </dw:ControlResources>
    <style>
        #detailsTable tr {
            height: 50px;
            border: 2px solid #f5f5f5;
        }

        #detailsTable th:first-child,
        #detailsTable td:first-child{
            padding-left:5px;
        }

        #detailsTable tr:nth-child(even),
        #detailsTable th {
            background-color: #FAFAFA;
        }
    </style>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader" Title="Health report"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <dw:List ID="healthList" runat="server" ShowTitle="false" EnableViewState="false">
                    <Columns>
                        <dw:ListColumn ID="ColStatus" Name="" EnableSorting="false" runat="server" ItemAlign="Center" Width="25" />
                        <dw:ListColumn ID="ColName" Name="Name" EnableSorting="true" runat="server" Width="150" />
                        <dw:ListColumn ID="ColDescription" Name="Description" EnableSorting="true" runat="server" />
                        <dw:ListColumn ID="ColCount" Name="Count" EnableSorting="true" runat="server" Width="100" />
                    </Columns>
                </dw:List>
            </dwc:CardBody>
            <dwc:CardFooter runat="server" />
        </dwc:Card>

        <dw:Dialog ID="CheckDetailDialog" runat="server" Size="Large" Title="Detail information" ShowOkButton="true">
            <dwc:GroupBox runat="server" Title="General">
                <div class="form-group">
                    <label class="control-label"><dw:TranslateLabel runat="server" Text="Name" /></label>
                    <div id="dialogName"></div>
                </div>
                <div class="form-group">
                    <label class="control-label"><dw:TranslateLabel runat="server" Text="Description" /></label>
                    <div id="dialogDescription"></div>
                </div>
                </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Errors" Expandable="true">
                <div class="form-group" id="dialogDetails">
                    <label class="control-label"><dw:TranslateLabel runat="server" Text="Details" /></label>
                    <div class="form-group-input">
                        <table id="detailsTable" style="text-align:left">
                            <thead>
                                <tr>
                                    <th><dw:TranslateLabel runat="server" Text="Object type" /></th>
                                    <th><dw:TranslateLabel runat="server" Text="Key 1" /></th>
                                    <th><dw:TranslateLabel runat="server" Text="Key 2" /></th>
                                    <th><dw:TranslateLabel runat="server" Text="Key 3" /></th>
                                    <th><dw:TranslateLabel runat="server" Text="Value" /></th>
                                </tr>
                            </thead>
                            <tbody id="dialogDetailsTable">
                            </tbody>
                        </table>
                    </div>
                </div>
                </dwc:GroupBox>
             <dwc:GroupBox runat="server" Title="Check" Expandable="true">
                <div class="form-group">
                    <label class="control-label"><dw:TranslateLabel runat="server" Text="What was run" /></label>
                    <dwc:InputTextArea ID="dialogWhat" ClientIDMode="Static" runat="server" Rows="10" Disabled="true"/>
                </div>
            </dwc:GroupBox>
        </dw:Dialog>
    </form>

    <script>
        HealthReport.initializeEditor('<%=Request("provider")%>');
    </script>
</body>
</html>
