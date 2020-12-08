<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadMailsList.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.LeadMailsList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" IncludeScriptaculous="true"></dw:ControlResources>
    <link rel="Stylesheet" href="/Admin/Images/Ribbon/UI/List/List.css" />
    <script language="javascript" type="text/javascript">
        function help() {
            <%=Dynamicweb.SystemTools.Gui.Help("omc.leadtool", "omc.leadtool") %>
        }

        function showStartFrame() {
            location = '/Admin/Blank.aspx';
        }

        function deleteMail() {
            var leadMailID = ContextMenu.callingItemID;
            if (confirm("<%= Translate.JsTranslate("Do you want to delete this scheduled lead mail.")%>")) {
                new Ajax.Request("/Admin/Module/OMC/Management/LeadMailsList.aspx", {
                    method: 'get',
                    parameters: {
                        LeadMailID: leadMailID,
                        Delete: "delete"
                    },
                    onComplete: function (transport) {
                        if (transport.responseText.length == 0) {
                            window.location.reload(true);
                        } else {
                            alert(transport.responseText);
                        }
                    }
                });
            }
        }

        function editScheduledMail(id) {
            dialog.show("ScheduledSendEmailDialog", '/Admin/Module/OMC/Management/ScheduledEmailLeadEdit.aspx?LeadMailID=' + (id || ContextMenu.callingItemID));
        }
    </script>
</head>
<body class="area-teal screen-container">
    <div class="card">
        <div class="card-header">
            <h2 class="subtitle"><%=Translate.Translate("List of mail reports")%></h2>
        </div>

        <dw:Toolbar ID="toolbar" runat="server" ShowEnd="false">
            <dw:ToolbarButton runat="server" Text="Annuller" Icon="Cancel" OnClientClick="showStartFrame();" ID="Cancel" />
            <dw:ToolbarButton runat="server" Text="New lead mail" Icon="PlusSquare" ID="cmdAddEmail" Divide="After" OnClientClick="dialog.show('ScheduledSendEmailDialog', '/Admin/Module/OMC/Management/ScheduledEmailLeadEdit.aspx');" />
            <dw:ToolbarButton runat="server" Text="Help" Icon="Help" OnClientClick="help();" ID="Help" />
        </dw:Toolbar>

        <form id="form1" runat="server">
            <div>
                <dw:List ID="lstEmails" PageSize="15" ShowTitle="false" NoItemsMessage="No emails found" runat="server">
                    <Columns>
                        <dw:ListColumn ID="ListColumn1" Name="" Width="10" runat="server" />
                        <dw:ListColumn ID="colSubject" Name="Subject" Width="280" EnableSorting="true" runat="server" />
                        <dw:ListColumn ID="colFrom" Name="From" Width="80" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="colRecipients" Name="Recipients" Width="280" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="colSentDate" Name="Sent date" Width="150" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="colScheduleDate" Name="Schedule date" Width="150" runat="server" EnableSorting="true" />
                    </Columns>
                </dw:List>
            </div>

            <dw:ContextMenu ID="menuEditLeadMail" OnShow="" runat="server">
                <dw:ContextMenuButton ID="cmdEditLeadMail" Text="Edit mail" Icon="Pencil" OnClientClick="editScheduledMail();" runat="server" />
                <dw:ContextMenuButton ID="cmdDeleteLeadMail" Text="Delete mail" Icon="Delete" OnClientClick="deleteMail();" runat="server" Divide="Before" />
            </dw:ContextMenu>

            <dw:Dialog ID="ScheduledSendEmailDialog" runat="server" Title="Scheduled mails" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" Width="533">
                <iframe id="ScheduledSendEmailDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

        </form>
    </div>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
