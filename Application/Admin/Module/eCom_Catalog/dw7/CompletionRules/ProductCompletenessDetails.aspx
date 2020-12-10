<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ProductCompletenessDetails.aspx.vb" Inherits="Dynamicweb.Admin.ProductCompletenessDetails" %>

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
        }
        td[onclick^=redirectToProductField] > i {
            cursor:pointer;
        }
    </style>
    <script>
        function redirectToProductField(productId, variantId, fieldControlId) {
            let pimApi = Action._getCurrentDialogOpener().Dynamicweb.PIM.BulkEdit.get_current();
            Action.CloseDialog();
            pimApi.openProduct({ productId, variantId, scrollToVariant: !!variantId, scrollToField: true, fieldControlIdToScroll: fieldControlId });
        }
    </script>
</head>
<dwc:DialogLayout runat="server" ID="CompletenessDetailsDialog" Title="Completeness - Missing fields" Size="Large" HidePadding="True">
    <content>
        <div class="col-md-0">
            <dw:List ID="DetailsList" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False" >                
                <Filters>
                    <dw:ListDropDownListFilter ID="VariantsFilter" Width="200" Label="Variant" AutoPostBack="true" Priority="1" runat="server" />
                    <dw:ListDropDownListFilter ID="FieldStateFilter" Width="120" Label="Show" AutoPostBack="true" Priority="2" runat="server">
                        <Items>
                            <dw:ListFilterOption Text="All" Value="" DoTranslate="true" Selected="true" />
                            <dw:ListFilterOption Text="Missing only" Value="Missing" DoTranslate="true" />
                        </Items>
                    </dw:ListDropDownListFilter>
                </Filters>
            </dw:List>
        </div>
    </content>
    <footer>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})">Close</button>
    </footer>
</dwc:DialogLayout>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
