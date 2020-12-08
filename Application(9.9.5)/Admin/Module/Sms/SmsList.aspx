<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="SmsList.aspx.vb" Inherits="Dynamicweb.Admin.SmsList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>


<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        function showHelp() {
            <%=Gui.Help("", "modules.sms.general.list.item")%>
        }

        function addItem() {
            location = "Message.aspx";
        }

        function editItem(itemid) {
            location = "Message.aspx?MessageID=" + itemid;
        }

        function deleteItem() {
            var smsToDeleteIDs = getCheckedRows();
            if (smsToDeleteIDs.length > 0) {
                var act = <%= GetDeleteMessagesAction().ToJson() %>;
                Action.Execute(act, { ids: smsToDeleteIDs });
		    }
        }

        function lstSelectingHandler() {
            if (List && List.getSelectedRows('lstPaths').length > 0) {
                Toolbar.setButtonIsDisabled('cmdDelete', false);
            }
            else {
                Toolbar.setButtonIsDisabled('cmdDelete', true);
            }
        }

        function getCheckedRows() {
            var rowsIDs = [];
            var contextMenuCaller = ContextMenu.callingID;
            var checkedRows = List.getSelectedRows('lstPaths');

            if (checkedRows && checkedRows.length > 0) {
                for (var i = 0; i < checkedRows.length; i++) {
                    rowsIDs[i] = checkedRows[i].id.replace("row", "");
                }
            } else if (contextMenuCaller) {
                rowsIDs[0] = contextMenuCaller;
            }
            return rowsIDs;
        }

    </script>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Text messages" />
        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="cmdAdd" runat="server" Disabled="false" Divide="None" Icon="Pencil" Text="New text message" OnClientClick="addItem();" />
            <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="Before" Icon="TimesCircle" Text="Delete" Disabled="true" OnClientClick="deleteItem();" />
            <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="help" Text="Help" OnClientClick="showHelp();" />
        </dw:Toolbar>
        <dw:List ID="lstPaths" AllowMultiSelect="True" ShowPaging="true" ShowTitle="false" runat="server" PageSize="50" HandleSortingManually="False" OnClientSelect="lstSelectingHandler();">
            <Columns>
                <dw:ListColumn ID="colDate" EnableSorting="true" Name="Date" runat="server" WidthPercent="14" />
                <dw:ListColumn ID="colName" EnableSorting="true" Name="Name" runat="server" WidthPercent="15" />
                <dw:ListColumn ID="colMessage" EnableSorting="true" Name="Message" runat="server" WidthPercent="25" />
                <dw:ListColumn ID="colRecipients" EnableSorting="true" Name="Recipients" runat="server" WidthPercent="8" />
                <dw:ListColumn ID="colDelivered" EnableSorting="true" Name="Delivered" runat="server" WidthPercent="8" />
                <dw:ListColumn ID="colFirstdeliverDate" EnableSorting="true" Name="First delivered" runat="server" WidthPercent="15" />
                <dw:ListColumn ID="colLastdeliverDate" EnableSorting="true" Name="Last delivered" runat="server" WidthPercent="15" />
            </Columns>
        </dw:List>
    </dwc:Card>
</asp:Content>

<asp:Content ContentPlaceHolderID="FooterContext" runat="server">
    <dw:ContextMenu ID="SmsContext" runat="server">
        <dw:ContextMenuButton ID="cmdEditContext" runat="server" Divide="None" Text="Edit message" OnClientClick="editItem(ContextMenu.callingID);" Icon="Pencil" />
        <dw:ContextMenuButton ID="cmdDeleteContext" runat="server" Divide="None" Text="Delete message" OnClientClick="deleteItem(ContextMenu.callingID);" Icon="TimesCircle" />
    </dw:ContextMenu>
</asp:Content>

