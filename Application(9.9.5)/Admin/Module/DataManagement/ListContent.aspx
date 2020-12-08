<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListContent.aspx.vb" Inherits="Dynamicweb.Admin.ListContent_2" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" style="height: 100%;">
<head runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Module/DataManagement/css/main.css" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var itemId = <%=ItemID%>;
        var redirCMD = "<%=redirCMD %>";
        if ('<%=Converter.ToBoolean(Dynamicweb.Context.Current.Request("Refresh")) %>' == 'True') {
            if (redirCMD.length != 0) {
                parent.submitReload(itemId, redirCMD);
            } else {
                parent.submitMe(itemId);
            }
        }

        function ContextmenuClick(cmd) {
            ContentRowHandler(cmd);
        }
    
        function ContentRowHandler(cmd) {
            var Id = ContextMenu.callingItemID;
            var listId = ContextMenu.callingID;

            if (cmd == "LIST_TABLEROWS") {
                editRow(Id);
            }
            if (cmd == "EDIT_TABLEROW") {
                location = "Connection/EditTableRow.aspx?ID=" + Id;
            }        
        }
    
        function editRow(Id) {
            location = "ListContent.aspx?item=" + Id + "&CMD=TABLEVIEW";
        }

        function PerformViewCheck() {
            var showPopup = <%=showPopup %>;
            if (showPopup) {
                doPopupForTestVariables();
            }
        }
    
        function doPopupForTestVariables() {
            var time = new Date();
            ajaxLoader("ListContent.aspx?AJAXCMD=FILL_POPUP&ID=" + itemId + "&timestamp=" + time.getTime(), "PopupTable");
            dialog.show('popup');
        }

        function ajaxLoader(url,divId) {
            new Ajax.Updater(divId, url, {
                asynchronous: false, 
                method: 'get',
            
                onSuccess: function(request) {
                    $(divId).update(request.responseText)
                }
            });
        }
    
        function saveTestVars() {
            document.getElementById('form1').action = "ListContent.aspx?CMD=SAVE_VARS&ID=" + itemId;
            document.getElementById('form1').submit();
        }
    </script>
</head>
<body onload="javascript:PerformViewCheck();" class="screen-container">
    <form id="form1" runat="server">
        <dw:List ID="List1" runat="server" Title="Items" PageSize="30" />

        <dw:Dialog ID="popup" ShowOkButton="true" runat="server" OkAction="saveTestVars();" ShowClose="false" Title="Test values" Size="Medium">
            <dwc:GroupBox ID="GroupBox1" DoTranslation="true" runat="server" Title="Angiv testværdier">
                <div id="PopupTable" style="overflow: auto;"></div>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:ContextMenu ID="ContextmenuItems" runat="server">
            <dw:ContextMenuButton ID="ContextmenuButton1" runat="server" Divide="After" Icon="Pageview" Text="Show" OnClientClick="ContextmenuClick('LIST_TABLEROWS');" />
            <dw:ContextMenuButton ID="ContextmenuButton2" runat="server" Divide="None" Icon="Refresh" Text="Refresh" OnClientClick="location=location;" />
        </dw:ContextMenu>

        <dw:ContextMenu ID="ContextmenuEditItems" runat="server">
            <dw:ContextMenuButton ID="ContextmenuButton3" runat="server" Divide="None" Icon="Pencil" Text="Edit" OnClientClick="ContextmenuClick('EDIT_TABLEROW');" />
        </dw:ContextMenu>
    </form>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
