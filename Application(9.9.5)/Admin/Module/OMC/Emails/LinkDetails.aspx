<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LinkDetails.aspx.vb" Inherits="Dynamicweb.Admin.LinkDetails" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server" />
    <style>
        .list {
            min-height: 300px;
        }
    </style>
</head>
<dwc:DialogLayout runat="server" ID="LinkDetailsDialog" Title="Link" Size="Large" HidePadding="True">
    <content>
        <div class="col-md-0">
            <dw:Infobar ID="infoBar" runat="server" Visible="False"></dw:Infobar>
            <dwc:GroupBox ID="grbLinkInfo" runat="server" Title="Link Info" DoTranslation="True">
                <dw:Label ID="lblLinkUrl" runat="server" doTranslation="False" />
            </dwc:GroupBox>
            <dwc:GroupBox ID="grbRecipients" runat="server" Title="Recipients" DoTranslation="True">
                <dw:List ID="lstRecipients" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False">
                    <Columns>
                        <dw:ListColumn ID="clmRecRecipient" TranslateName="True" Name="Recipient" runat="server" HeaderAlign="Left" ItemAlign="Left" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecThisClick" TranslateName="True" Name="Clicks (this link)" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecAllClick" TranslateName="True" Name="Clicks (all link)" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecCart" TranslateName="True" Name="Shopping Cart" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecOrder" TranslateName="True" Name="Order" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                        <dw:ListColumn ID="clmRecUnsub" TranslateName="True" Name="Unsubscribed" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
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
