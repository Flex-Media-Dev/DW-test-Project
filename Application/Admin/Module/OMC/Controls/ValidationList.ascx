<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ValidationList.ascx.vb" Inherits="Dynamicweb.Admin.OMC.Controls.ValidationList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
         <script type="text/javascript">
             document.observe('dom:loaded', function () {
                     if(!<%=Me.BounceMode.ToString().ToLower()%>){
                         var o = new overlay("lookupForward");
                         o.show();
                         <%=ClientInstanceName%>.showList(null, false, <%=Me.UserGroupEditMode.ToString().ToLower()%>);
                     }
               });
        </script>
   <div id="divValidationList" runat="server">
    <dw:List ID="lstValidationList" PageSize="15" ShowTitle="false" NoItemsMessage="No invalid emails found" runat="server" Height="360">
        <Columns>
            <dw:ListColumn ID="colRecipientName" Name="Name" WidthPercent="20" runat="server" />
            <dw:ListColumn ID="colEmail" Name="E-mail" Width="200" ItemAlign="Center" runat="server" />
            <dw:ListColumn ID="colSave" Name="Save" ItemAlign="Center" HeaderAlign="Center" runat="server" />
            <dw:ListColumn ID="colClear" Name="Clear" ItemAlign="Center" HeaderAlign="Center" runat="server" />
            <dw:ListColumn ID="colRemovePermission" Name="Remove permission" ItemAlign="Center" HeaderAlign="Center" runat="server" />
            <dw:ListColumn ID="colRemoveUser" Name="Remove user" ItemAlign="Center" HeaderAlign="Center" runat="server" />
            <dw:ListColumn ID="colReason" Name="Reason" WidthPercent="20" runat="server" />
            <dw:ListColumn ID="colUpdated" Name="Updated" WidthPercent="20" runat="server" />
            <dw:ListColumn ID="colResend" Name="Resend" WidthPercent="20" ItemAlign="Center"  runat="server" />
        </Columns>
    </dw:List>
</div>
<dw:Overlay ID="lookupForward" runat="server">Please wait </dw:Overlay>
