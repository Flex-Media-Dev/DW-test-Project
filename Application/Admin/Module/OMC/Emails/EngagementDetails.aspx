<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EngagementDetails.aspx.vb" Inherits="Dynamicweb.Admin.EngagementDetails" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server" />
</head>
<body style="height: auto">
    <form id="frmEngagementDetails" runat="server">

        <script type="text/javascript">
   
        </script>

       <div class="omc-control-panel-grid-container" style="width: 540px; margin-left:10px;">
            <table class="dwGrid" cellspacing="0" cellpadding="0" border="0" style="border-style: None;width:100%; border-collapse: collapse; position: static">
               <tr class="header">
                    <th scope="col" style="width: 361px;">
                        <dw:TranslateLabel ID="lbConversion" Text="Common conversion" runat="server" />
                    </th>
                    <th scope="col" width="114">
                        <dw:TranslateLabel ID="lbEngagementIndex" Text="Engagement Index" runat="server" />
                    </th>
                    <th scope="col" width="57">
                        <dw:TranslateLabel ID="lbActive" Text="Active" runat="server" />
                    </th>
                </tr>
             </table>
            <table id="headerLinkTable" class="dwGrid" cellspacing="0" cellpadding="0" border="0" style="border-style: None; border-collapse: collapse; position: static">
                <tr class="row actionRow highlightRow" align="center">
                    <td align="left" width="361">
                        &nbsp;<dw:TranslateLabel ID="lbInteractionForm" Text="Open the mail" runat="server" />
                    </td>
                    <td>
                        <omc:NumberSelector ID="numEngIdxOpenMail" AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                    </td>
                    <td width="64">
                        <dw:CheckBox ID="chkEngIdxOpenMail" runat="server" />
                    </td>
                </tr>
                <tr class="row actionRow highlightRow" align="center">
                    <td align="left" width="361">
                        &nbsp;<dw:TranslateLabel ID="lbInteractionProduct" Text="Adding products to cart" runat="server" />
                    </td>
                    <td>
                        <omc:NumberSelector ID="numEngIdxAddingProductsToCart" AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                    </td>
                    <td width="64">
                        <dw:CheckBox ID="chkEngIdxAddingProductsToCart" runat="server" />
                    </td>
                </tr>
                <tr class="row actionRow highlightRow" align="center">
                    <td align="left" width="361">
                        &nbsp;<dw:TranslateLabel ID="TranslateLabel19" Text="Placing an order" runat="server" />
                    </td>
                    <td>
                        <omc:NumberSelector ID="numEngIdxPlacingOrder" AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                    </td>
                    <td width="64">
                        <dw:CheckBox ID="chkEngIdxPlacingOrder" runat="server" />
                    </td>
                </tr>
                <tr class="row actionRow highlightRow" align="center">
                    <td align="left" width="361">
                        &nbsp;<dw:TranslateLabel ID="lbInteractionFile" Text="Signing on to e-mail" runat="server" />
                    </td>
                    <td>
                        <omc:NumberSelector ID="numEngIdxSigningNewsletter" AllowNegativeValues="false" MinValue="0" MaxValue="100" runat="server" />
                    </td>
                    <td width="64">
                        <dw:CheckBox ID="chkEngIdxSigningNewsletter" runat="server" />
                    </td>
                </tr>
                <tr class="row actionRow highlightRow" align="center">
                    <td align="left" width="361">
                        &nbsp;<dw:TranslateLabel ID="lbInteractionSearch" Text="Unsubscribes the e-mail" runat="server" />
                    </td>
                    <td>
                        <omc:NumberSelector ID="numEngIdxUnsubscribesNewsletter" AllowNegativeValues="true" MinValue="-100" MaxValue="100" runat="server" />
                    </td>
                    <td width="64">
                        <dw:CheckBox ID="chkEngIdxUnsubscribesNewsletter" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div class="omc-control-panel-grid-container" style="width: 540px; border-bottom: none; margin-bottom: 0px; margin-left:10px;">
            <table class="dwGrid" cellspacing="0" cellpadding="0" border="0" style="border-style: None; width: 100%; border-collapse: collapse; position: static">
                <tr class="header">
                    <th scope="col" style="width: 340px;">
                        <dw:TranslateLabel ID="TranslateLabelOriginallinks" Text="Original links" runat="server" />
                    </th>
                    <th scope="col">
                        <dw:TranslateLabel ID="TranslateLabel23" Text="Engagement Index" runat="server" />
                    </th>
                    <th scope="col" width="57">
                        <dw:TranslateLabel ID="TranslateLabel24" Text="Active" runat="server" />
                    </th>
                </tr>
            </table>
        </div>
        <div class="omc-control-panel-grid-container" style="width: 540px; height: 150px; border-top: none; margin-top: 0px; margin-left:10px; overflow: auto;" id="originalLinkDiv" runat="server">
            <table id="originalLinkTable" class="dwGrid" cellspacing="0" cellpadding="0" border="0" style="border-style: None; border-collapse: collapse; position: static;">
                <asp:Literal runat="server" ID="ltOriginalLinks"></asp:Literal>
            </table>
        </div>
        <br />
        <div id="variantDiv" style="display:none;">
            <div class="omc-control-panel-grid-container" style="width: 540px; border-bottom: none; margin-bottom: 0px; margin-left:10px; ">
                <table class="dwGrid" cellspacing="0" cellpadding="0" border="0" style="border-style: None; width: 100%; border-collapse: collapse; position: static">
                    <tr class="header">
                        <th scope="col" style="width: 340px;">
                            <dw:TranslateLabel ID="TranslateLabel25" Text="Variant links" runat="server" />
                        </th>
                        <th scope="col">
                            <dw:TranslateLabel ID="TranslateLabel26" Text="Engagement Index" runat="server" />
                        </th>
                        <th scope="col" width="57">
                            <dw:TranslateLabel ID="TranslateLabel27" Text="Active" runat="server" />
                        </th>
                    </tr>
                </table>
            </div>
            <div class="omc-control-panel-grid-container" style="width: 540px; height: 150px; border-top: none; margin-top: 0px; margin-left:10px; overflow: auto;" id="variantLinkDiv" runat="server">
                <table id="variantLinkTable" class="dwGrid" cellspacing="0" cellpadding="0" border="0" style="border-style: None; border-collapse: collapse; position:static">
                    <asp:Literal runat="server" ID="ltVariantLinks"></asp:Literal>
                </table>
            </div>
        </div>
        <br />
        <div class="footer" style="text-align: right; margin-right: 15px;">
            <asp:Button Text="OK" ID="btnOk" runat="server" Width="60px" />
            <asp:Button Text="Cancel" ID="btnCancel" runat="server" Width="60px" />
        </div>
    </form>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
