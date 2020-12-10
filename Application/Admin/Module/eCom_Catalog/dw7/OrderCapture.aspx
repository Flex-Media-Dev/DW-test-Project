<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="OrderCapture.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.OrderCapture" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Ecommerce.Orders.Gateways" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <link rel="Stylesheet" type="text/css" href="css/OrderCapture.css" />
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeRequireJS="True" runat="server" />

    <script type="text/javascript" src="js/OrderCapture.js" ></script>
    <script type="text/javascript">
        var orderCaptureState = '<%=order.CaptureInfo.State.ToString() %>';
        var orderCaptureInfoDate = '<%=order.CaptureInfo.CaptureTime.ToString("ddd, dd MMM yyyy HH:mm", Dynamicweb.Environment.ExecutingContext.GetCulture(False)) %>';
        var orderCaptureMessage = '<%=HttpUtility.JavaScriptStringEncode(order.CaptureInfo.Message)%>';
        var orderCaptureSupported = '<%=order.IsCaptureSupported %>' == 'True';
        var orderPartialCaptureSupported = '<%=order.IsPartialCaptureSupported%>' == 'True';
        var orderID = '<%=Dynamicweb.Context.Current.Request("ID") %>';

        document.observe("dom:loaded", function () {
            $('txtCaptureAmount').value = '<%=Dynamicweb.Ecommerce.Common.Application.DefaultCurrency.Format((order.Price.Price + order.ExternalPaymentFee) - order.CaptureAmount, False)%>';
            setCaptureDialog();
        });

    </script>
    <style type="text/css">
        table.warning td{ color: gray; }
    </style>
</head>
<body>
    <form id="CaptureDialog" runat="server">
        <dw:GroupBox runat="server" DoTranslation="true" Title="Information">
        
            <div id="Capture_Loading">
                <img src="/Admin/Module/eCom_Catalog/images/ajaxloading_trans.gif" alt=""/><br /><br />
                <dw:TranslateLabel runat="server" Text="Capturing..." />
            </div>
            
            <div id="CaptureInfo">
                <div id="CaptureInfo_Captured">
                    <table style="width:100%; " >
                        <colgroup>
                            <col style="width:120px;"/>
                            <col />
                        </colgroup>
                        <tr>
                            <td colspan="2">
                                <div id="CaptureInfo_Split">
                                    <dw:TranslateLabel runat="server" text="The payment was split" />
                                </div>
                                <div id="CaptureInfo_Captured_Success">
                                    <dw:TranslateLabel runat="server" text="The order was successfully captured" />
                                </div>
                                <div id="CaptureInfo_Captured_Failure">
                                    <dw:TranslateLabel runat="server" text="An error occurred when trying to capture the order." />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Date" />
                            </td>
                            <td>
                                <span id="Capture_Date" />
                            </td>
                        </tr>
                        <tr><td colspan="2">&nbsp;</td></tr>
                        <tr>
                            <td style="vertical-align:top;">
                                <dw:TranslateLabel runat="server" Text="Message" />
                            </td>
                            <td>
                                <span id="Capture_Message" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="CaptureInfo_NotCaptured">
                    <dw:TranslateLabel runat="server" Text="This order is not captured from Dynamicweb eCommerce" />
                </div>
                <div id="CaptureInfo_NotSupported">
                    <dw:TranslateLabel runat="server" Text="The payment gateway used for this order does not support remote capture" />
                </div>
            </div>
        </dw:GroupBox>
        
        <div id="sectionAction">
        <dw:GroupBox runat="server" Title="Action" DoTranslation="true">
            <table id="tblCapturePartial" style='width: 100%;display:none;border:0;'>
                <colgroup>
                    <col style="width:120px;"/>
                    <col />
                </colgroup>
                <tr>
                    <td>
                        <dw:TranslateLabel runat="server" Text="Capture type" />
                    </td>
                    <td>
                        <input type="radio" id="chkFullCapture" name="captureType" checked="checked" onclick="togglePartialCapture();" />
                        <label for="chkFullCapture"><%= Translate.Translate("Full amount")%></label> 
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <input type="radio" id="chkPartialCapture" name="captureType" onclick="togglePartialCapture();" />
                        <label for="chkPartialCapture"><%= Translate.Translate("Split amount")%></label> 
                    </td>
                </tr>
                <tr id="rowCaptureAmount">
                    <td>
                        <label for="txtCaptureAmount"><%= Translate.Translate("Amount")%></label> 
                    </td>
                    <td>
                        <input type="text" id="txtCaptureAmount" style="width:80px;text-align:right" class="std" />
                    </td>
                </tr>
                <tr id="rowFinalCapture">
                    <td>
                    </td>
                    <td>
                        <%If OrderManager.GetFor(order).IsOperationSupported(OrderOperations.FinalOnlyPartialCapture) Then%>
                        <input type="checkbox" id="chkFinalCapture" checked="checked" disabled="disabled"/>
                        <%Else%>
                        <input type="checkbox" id="chkFinalCapture"/>
                        <%End If%>
                        <label for="chkFinalCapture"><%= Translate.Translate("Final capture")%></label> 
                    </td>
                </tr>
                <%If OrderManager.GetFor(order).IsOperationSupported(OrderOperations.FinalOnlyPartialCapture) Then%>
                <tr>
                    <td colspan="2">
	                    <dw:Infobar ID="infoFinalOnlyPartialCapture" UseInlineStyles="false" runat="server" Message="This provider only supports one split capture. The split capture is final captured after one split capture." Type="Warning"></dw:Infobar>
                    </td>
                </tr>
                <%End If%>
            </table>
            <input type="button" id="CaptureButton" value="Capture" class="std" style="float:right;width:62px;" onclick="Capture();" />
        </dw:GroupBox>
        </div>
        <div id="sectionHistory" style="display:none;">
        <dw:GroupBox runat="server" Title="History" DoTranslation="true">
            <table id="tblCaptureHistory" runat="server" style="width:100%;border:0;">
            </table>
        </dw:GroupBox>
        </div>

        <%  Translate.GetEditOnlineScript()%>
    </form>
</body>
</html>
