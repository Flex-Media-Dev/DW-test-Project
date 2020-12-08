<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AddedChannelGroupsPerProduct.aspx.vb" Inherits="Dynamicweb.Admin.AddedChannelGroupsPerProduct" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <style>
        .list {
            min-height: 300px;
            height:auto;
        }
    </style>
    <script>
        function applyToChannel(productId, variantId, fieldControlId) {
            let pimApi = Action._getCurrentDialogOpener().Dynamicweb.PIM.BulkEdit.get_current();
            Action.CloseDialog();
            pimApi.submitFormWithCommand("AddGroups");
        }
    </script>
</head>
<dwc:DialogLayout runat="server" ID="DetailsDialog" Title="Add distribution channel groups confirmation" Size="Large" HidePadding="false">
    <content>
        <div class="col-md-0">
            <dw:Infobar ID="infoBox" Type="Information" Message="Only matched complition rules products will be added to channels" runat="server" />
            <dw:List ID="DetailsList" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False">
                <Columns>
                    <dw:ListColumn runat="server" ID="ListColumn0" Name="Group Name" />
                    <dw:ListColumn runat="server" ID="ListColumn1" Name="Channel" />
                    <dw:ListColumn runat="server" ID="ListColumn2" Name="Group Path" />
                    <dw:ListColumn runat="server" ID="ListColumn3" Name="Completeness" />
                    <dw:ListColumn runat="server" ID="ListColumn4" Name="" Width="40" />
                </Columns>
            </dw:List>
        </div>
    </content>
    <footer>
        <button class="btn btn-link waves-effect" type="button" onclick="applyToChannel()"><%=Translate.Translate("Confirm") %></button>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})"><%=Translate.Translate("Cancel") %></button>
    </footer>
</dwc:DialogLayout>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>

