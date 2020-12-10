<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DataItemTypeEdit.aspx.vb" Inherits="Dynamicweb.Admin.DataItemTypeEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <dw:ControlResources CombineOutput="False" IncludePrototype="true" runat="server"></dw:ControlResources>
    <%= DataItemProviderAddin.Jscripts%>
    <title>Edit data group item</title>
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            var itemName = document.getElementById('dataItemTypeName');
            itemName.focus();

            var itemId = document.getElementById('dataItemTypeId');
            parent.IdFromNameGenerator(itemId, itemName, true);
        });
    </script>
</head>
<body>
    <form id="editItemForm" runat="server">
        <input type="hidden" id="dataItemTypeOriginalId" name="dataItemTypeOriginalId" runat="server" />
        <div>
            <dw:GroupBox ID="GroupOne" runat="server">
                <dwc:InputText ID="dataItemTypeName" Name="dataItemTypeName" runat="server" Label="Name" ValidationMessage=""></dwc:InputText>
                <dwc:InputText ID="dataItemTypeId" Name="dataItemTypeId" runat="server" Label="Id" ValidationMessage=""></dwc:InputText>
                <de:AddInSelector
                    runat="server"
                    ID="DataItemProviderAddin"
                    AddInShowNothingSelected="false"
                    AddInGroupName="Data Item Provider"
                    AddInTypeName="Dynamicweb.Deployment.DataItemProvider" />
                <%= DataItemProviderAddin.LoadParameters %>
            </dw:GroupBox>
        </div>
    </form>
</body>
</html>
