<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecipientsList.aspx.vb" Inherits="Dynamicweb.Admin.RecipientsList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server" />
</head>
<body style="height: auto">
    <form id="frmRecipientsList" runat="server">

        <script type="text/javascript">
            function ChangeRecipientState(rcpKey) {
                var excluded = document.getElementById('excludedNew').value;

                if(excluded.indexOf(rcpKey) == -1) {
                    if(excluded.length > 0)
                        excluded += ',';

                    excluded += rcpKey;
                    document.getElementById('includeImg' + rcpKey).src = '/Admin/images/Minus.gif';
                }
                else {
                    excluded = excluded.replace(rcpKey, '').replace('\'\'', '\'');
                    document.getElementById('includeImg' + rcpKey).src = '/Admin/images/Check.gif';
                }

                document.getElementById('excludedNew').value = excluded;
                parent.OMC.MasterPage.get_current().get_contentWindow().$('RecipientsExcluded').value = excluded;
            }
        </script>

        <input type="hidden" id="excludedNew" name="excludedNew" value="<%=Me.ExcludedIds%>" />
        <input type="hidden" id="emailId" name="emailId" value="<%=Request("emailId")%>" />
        <dw:Infobar ID="infoBar" runat="server" Visible="False">
        </dw:Infobar>
        <dw:List ID="lstSummary" runat="server" PageSize="20" ShowHeader="True" ShowPaging="True" ShowTitle="False" StretchContent="True">
            <Columns>
                <dw:ListColumn ID="clmRcpName" TranslateName="True" Name="Name" runat="server" HeaderAlign="Left" ItemAlign="Left" EnableSorting="True" />
                <dw:ListColumn ID="clmRcpEmail" TranslateName="True" Name="Email" runat="server" HeaderAlign="Left" ItemAlign="Left" EnableSorting="True" />
                <dw:ListColumn ID="clmRcpRecieved" TranslateName="True" Name="Recieved" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                <dw:ListColumn ID="clmRcpOpened" TranslateName="True" Name="Opened" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                <dw:ListColumn ID="clmRcpClicked" TranslateName="True" Name="Clicked" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                <dw:ListColumn ID="clmRcpCart" TranslateName="True" Name="Cart" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                <dw:ListColumn ID="clmRcpOrderNl" TranslateName="True" Name="Order (email)" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                <dw:ListColumn ID="clmRcpOrderTtl" TranslateName="True" Name="Order (total)" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                <dw:ListColumn ID="clmRcpPerf" TranslateName="True" Name="Performance" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                <dw:ListColumn ID="clmLastEmailSentTime" TranslateName="True" Name="Last email sent" runat="server" HeaderAlign="Center" ItemAlign="Center" EnableSorting="True" />
                <dw:ListColumn ID="clmRcpActive" runat="server" TranslateName="True" Name="Include" HeaderAlign="Center" ItemAlign="Center" EnableSorting="False" />
            </Columns>
        </dw:List>
    </form>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
