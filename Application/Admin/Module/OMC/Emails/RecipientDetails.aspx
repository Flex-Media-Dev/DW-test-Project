<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecipientDetails.aspx.vb" Inherits="Dynamicweb.Admin.RecipientDetails" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server" />
    <script>
        function OpenInUM() {
            var openUserInfoAction = <%= GetOpenUserInfoAction() %>;
            if (openUserInfoAction) {
                var parentDlg = Action._getCurrentDialogOpener();
                Action.Execute({Name: "CloseDialog"});
                parentDlg.Action.Execute({Name: "CloseDialog"});
                Action.Execute(openUserInfoAction);
            }
        }
    </script>
</head>
<dwc:DialogLayout runat="server" ID="RecipientDialog" Title="Recipient Details" Size="Large" HidePadding="True">
    <content>
        <div class="col-md-0">
        <input type="hidden" id="userid" name="userid" value="<%=Request("userId")%>" />
        <dw:Infobar ID="infoBar" runat="server" Visible="False" TranslateMessage="True">
        </dw:Infobar>
        <%If Not IsUserManagement Then%>
        <dwc:GroupBox ID="grbUserInfo" runat="server" Title="User Info" DoTranslation="True">
            <div style="text-align: left; float: left;">
                <dw:Label ID="lblUserTitle" runat="server" doTranslation="False" />
                <dw:Label ID="lblEmail" runat="server" doTranslation="False" />
                <dw:Label ID="lblLocation" runat="server" doTranslation="False" />
            </div>
            <div style="text-align: right; float: right;">
                <dw:Button ID="openInUM" runat="server" Name="Open in user management" OnClick="OpenInUM();"/>
            </div>
        </dwc:GroupBox>
        <%End If%>
        <dwc:GroupBox ID="grbSummary" runat="server" Title="Summary" DoTranslation="True">
            <dw:List ID="lstSummary" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False" PageSize="25">
                <Columns>
                    <dw:ListColumn ID="clmSumRecieved" TranslateName="True" Name="Recieved" runat="server" HeaderAlign="Left" ItemAlign="Left" />
                    <dw:ListColumn ID="clmSumOpened" TranslateName="True" Name="Opened" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmSumClicked" TranslateName="True" Name="Clicked" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmSumCart" TranslateName="True" Name="Cart" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmSumOrderNl" TranslateName="True" Name="Order (email)" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmSumOrderTtl" TranslateName="True" Name="Order (total)" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmSumUnsub" TranslateName="True" Name="Unsubscribed" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmSumPerf" TranslateName="True" Name="Performance" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                </Columns>
            </dw:List>
        </dwc:GroupBox>
        <%If Not IsUserManagement Then%>
        <dwc:GroupBox ID="grbEmail" runat="server" Title="This mail" DoTranslation="True">
            <dw:List ID="lstEmail" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False" PageSize="10">
                <Columns>
                    <dw:ListColumn ID="clmEmailTime" TranslateName="True" Name="Open time" runat="server" HeaderAlign="Left" ItemAlign="Left" />
                    <dw:ListColumn ID="clmEmailOpened" TranslateName="True" Name="Opened" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmEmailClick" TranslateName="True" Name="Click" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmEmailCart" TranslateName="True" Name="Cart" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmEmailOrder" TranslateName="True" Name="Order" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmEmailUnsubscribe" TranslateName="True" Name="Unsubscribe" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmEmailPerformance" TranslateName="True" Name="Performance" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmEmailBrowser" TranslateName="True" Name="Browser" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmEmailPlatform" TranslateName="True" Name="Platform" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                </Columns>
            </dw:List>
        </dwc:GroupBox>
        <dwc:GroupBox ID="grbLinks" runat="server" Title="Links clicked in this mail" DoTranslation="True">
            <dw:List ID="lstLinks" runat="server" OnRowExpand="OnLinksRowExpand" ShowHeader="True" ShowPaging="True" ShowTitle="False" PageSize="10" >
                <Columns>
                    <dw:ListColumn ID="clmLinkUrl" TranslateName="False" Name="URL's" runat="server" HeaderAlign="Left" ItemAlign="Left" WidthPercent="90" />
                    <dw:ListColumn ID="clmLinkCnt" TranslateName="True" Name="Total" runat="server" HeaderAlign="Center" ItemAlign="Center" WidthPercent="10" />
                </Columns>
            </dw:List>
        </dwc:GroupBox>
        <%End If%>
        <dwc:GroupBox ID="grbNewsletters" runat="server" Title="Emails" DoTranslation="True">
            <dw:List ID="lstNewsletters" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False"  OnRowExpand="OnEmailRowExpand">
                <Columns>
                    <dw:ListColumn ID="clmNewsLetter" TranslateName="True" Name="Email" runat="server" HeaderAlign="Left" ItemAlign="Left" WidthPercent="30" />
                    <dw:ListColumn ID="clmNewsSent" TranslateName="True" Name="Sent" runat="server" HeaderAlign="Center" ItemAlign="Left" />
                    <dw:ListColumn ID="clmNewsOpened" TranslateName="True" Name="Opened" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmNewsClicked" TranslateName="True" Name="Clicked" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmNewsCart" TranslateName="True" Name="Cart" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmNewsOrder" TranslateName="True" Name="Order" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmNewsUnsub" TranslateName="True" Name="Unsubscribed" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn ID="clmNewsPerf" TranslateName="True" Name="Performance" runat="server" HeaderAlign="Center" ItemAlign="Center" />
                </Columns>
            </dw:List>
        </dwc:GroupBox>
        </div>
    </content>
    <footer>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})">Close</button>
    </footer>
</dwc:DialogLayout>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
