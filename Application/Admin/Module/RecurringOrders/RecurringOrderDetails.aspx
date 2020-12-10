<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecurringOrderDetails.aspx.vb" Inherits="Dynamicweb.Admin.RecurringOrders.RecurringOrderDetails" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Src="~/Admin/Module/eCom_Catalog/dw7/edit/UCOrderEdit.ascx" TagPrefix="oe" TagName="UCOrderEdit" %>

<!DOCTYPE html>
<html>
<head>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        table.tabTable {
            height: 0px;
        }

        div.list table.main {
            width: 779px;
        }

        table.tabTable tbody tr td {
            padding: 0px;
        }
    </style>
    <script type="text/javascript">        
        function handleCanceledDeliveries(DeliveryIndex) {   
            var canceledIDs = $('CanceledDeliveries').value ? $('CanceledDeliveries').value.split(',') : [];
            if (canceledIDs.indexOf(DeliveryIndex) < 0){
                canceledIDs[canceledIDs.length] = DeliveryIndex
                $('CanceledDeliveries').value = canceledIDs.join(',');
                $('delivery'+DeliveryIndex).src='../../Images/Minus.gif';
                //todo switch image
            }else if(canceledIDs.indexOf(DeliveryIndex) >= 0){                
                canceledIDs.splice(canceledIDs.indexOf(DeliveryIndex), 1);
                $('CanceledDeliveries').value = canceledIDs.join(',');
                $('delivery'+DeliveryIndex).src='../../Images/Check.gif';
                //todo: switch image
            }
        }

        document.observe('dom:loaded', function () {
            var frame = window.frameElement;
            var container = $(frame).up('div#FutureDeliveriesDialog');
            parent.dialog.set_okButtonOnclick(container, function(){
                new Ajax.Request('RecurringOrderDetails.aspx', {
                    method: 'post',
                    parameters: {
                        IsAjax : true,
                        CanceledDeliveries : $('CanceledDeliveries').value,
                        Cmd: 'Save',
                        RecurringOrderId : <%=Dynamicweb.Context.Current.Request("RecurringOrderId")%>
                        }
                });
            });
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" name="CanceledDeliveries" id="CanceledDeliveries" value="" runat="server" />

        <dw:List ID="FutureDeliveries" ShowFooter="true" runat="server" TranslateTitle="True" StretchContent="true" PageSize="21" ShowPaging="true" Title="Future Deliveries">
            <Columns>
                <dw:ListColumn ID="colDeliveryDate" runat="server" Name="Date" EnableSorting="true" />
                <dw:ListColumn ID="colSkip" runat="server" Name="Active" EnableSorting="false" ItemAlign="Center" Width="100" HeaderAlign="Center" />
            </Columns>
        </dw:List>
        <%Translate.GetEditOnlineScript()%>
    </form>
</body>
</html>


