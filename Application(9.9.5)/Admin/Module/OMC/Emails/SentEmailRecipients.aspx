<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SentEmailRecipients.aspx.vb" Inherits="Dynamicweb.Admin.SentEmailRecipients" ClientIDMode="Static" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />

    <title></title>

    <script type="text/javascript">
        function switchList(state) {
            document.getElementById("ListState").value = state;
            updateToolbarButtons(state);
            document.forms[0].submit();
        }

        function updateToolbarButtons(state) {
            state = state || document.getElementById("ListState").value;
            var overviewBtn = document.getElementById("cmdShowOverviewList");
            var unsubscribersBtn = document.getElementById("cmdShowUnsubscribersList");
            if (state == 'overview') {
                dwGlobal.Dom.addClass(overviewBtn, "active");
                dwGlobal.Dom.removeClass(unsubscribersBtn, "active");
            }
            else if (state == 'unsubscribers') {
                dwGlobal.Dom.addClass(unsubscribersBtn, "active");
                dwGlobal.Dom.removeClass(overviewBtn, "active");
            }
        }

        function ShowUserPopup(emailId, userId, title, rcptId) {
            var detailDlgAction = <%= GetRecipientDetailsDialogAction(False).ToJson() %>;
            Action.Execute(detailDlgAction, {
                emailId: emailId,
                userId: userId, 
                rcptId: rcptId,
                title: title
            });
        }

        function init() {
            updateToolbarButtons();
        }
    </script>
    <style>
        .list {
            min-height: 300px;
        }
        .column-name {
            max-width: 400px !important;
        }
    </style>
</head>
<dwc:DialogLayout runat="server" ID="RecipientsDialog" Title="Recipients" Size="Large" HidePadding="True">
    <content>
            <asp:HiddenField runat="server" ID="ListState" Value="overview" />
            <div class="col-md-0">
                <dw:Toolbar runat="server">
                    <dw:ToolbarButton ID="cmdShowOverviewList" runat="server" Text="Overview" ShowWait="true" OnClientClick="switchList('overview');" />
                    <dw:ToolbarButton ID="cmdShowUnsubscribersList" runat="server" Text="Unsubscribers" ShowWait="true" OnClientClick="switchList('unsubscribers');" />
                </dw:Toolbar>
                <dw:List ID="lstRecipients" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False" StretchContent="True" PageSize="250">
                    <Columns>
                        <dw:ListColumn ID="clmRecRecipient" TranslateName="True" Name="Recipient" runat="server" HeaderAlign="Left" ItemAlign="Left" EnableSorting="True" CssClass="column-name" />
                        <dw:ListColumn ID="clmRecOpened" TranslateName="True" Name="Opened" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecClicked" TranslateName="True" Name="Clicked links" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecCart" TranslateName="True" Name="Cart" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecOrder" TranslateName="True" Name="Order value" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecUnsub" TranslateName="True" Name="Unsubscribed" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecIndex" TranslateName="True" Name="Engagement Index" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                    </Columns>
                </dw:List>
                <dw:List ID="lstUnsubscribers" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False" StretchContent="True" PageSize="250">
                    <Columns>
                        <dw:ListColumn ID="clmRecRecipientUnsub" TranslateName="True" Name="Recipient" runat="server" HeaderAlign="Left" ItemAlign="Left" EnableSorting="True" CssClass="column-name" />
                        <dw:ListColumn ID="clmRecOpenedUnsub" TranslateName="True" Name="Opened" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecClickedUnsub" TranslateName="True" Name="Clicked links" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecCartUnsub" TranslateName="True" Name="Cart" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecOrderUnsub" TranslateName="True" Name="Order value" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecUnsubUnsub" TranslateName="True" Name="Unsubscribed" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecIndexUnsub" TranslateName="True" Name="Engagement Index" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                    </Columns>
                </dw:List>
            </div>
        </content>
    <footer>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})">Close</button>
    </footer>
</dwc:DialogLayout>
<script>
    init();
</script>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
