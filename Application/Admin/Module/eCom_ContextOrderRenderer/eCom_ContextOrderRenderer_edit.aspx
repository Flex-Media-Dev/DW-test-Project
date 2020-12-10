<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="eCom_ContextOrderRenderer_edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_ContextOrderRenderer" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <style type="text/css">
        .test-order-container .checked, .test-order-container .unchecked {
            display: none;
        }
        .test-order-container.checked .checked, .test-order-container.unchecked .unchecked {
            display: table-row;
        }
    </style>
    <script type="text/javascript">
        document.observe("dom:loaded", function () {
            var cnt = $("test-order-container");
            var modeSelector = $("RenderInTestMode");
            var checkFn = function changeTestMode() {
                if (modeSelector.checked) {
                    cnt.addClassName("checked");
                    cnt.removeClassName("unchecked");
                } else {
                    cnt.addClassName("unchecked");
                    cnt.removeClassName("checked");
                }
            }
            modeSelector.on("change", checkFn);
            checkFn();
        });
    </script>
</head>
<body>
    <input type="hidden" name="eCom_ContextOrderRenderer_settings" value="Template,ImagePatternProductCatalog,RenderInTestMode,TestOrderId" />
    <dw:ModuleHeader ID="dwHeaderModule" runat="server" ModuleSystemName="eCom_ContextOrderRenderer" />

    <dw:GroupBox ID="grpboxPaging" Title="Settings" runat="server">
        <table class="formsTable">
            <tr style="padding-top: 10px;">
                <td>
                    <dw:TranslateLabel ID="DwTemplate" runat="server" Text="Template" />
                </td>
                <td>
                    <dw:FileManager runat="server" ID="Template" Name="Template" Folder="Templates/eCom/Order/" FullPath="True"></dw:FileManager>
                </td>
            </tr>
            <!-- Image pattern settings -->
            <tr>
                <td style="vertical-align:top;">
                    <dw:TranslateLabel runat="server" Text="Use image pattern settings from product catalog" />
                </td>
                <td>
                    <dw:LinkManager runat="server" id="ImagePatternProductCatalog" EnablePageSelector="False" DisableFileArchive="True"></dw:LinkManager>
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <fieldset id="test-order-container" class="test-order-container unchecked">
        <table class="formsTable">
            <tr>
                <td></td>
                <td>
                    <div>
                        <dw:CheckBox FieldName="RenderInTestMode" ID="RenderInTestMode" runat="server" />
                    </div>
                </td>
            </tr>
            <tr class="unchecked">
                <td></td>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Select 'Test mode display' checkbox to allow test order select" />
                </td>
            </tr>
            <tr class="checked">
                <td>
                    <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Select order or cart" />
                </td>
                <td>
                    <%=RenderOrderSelector()%>
                </td>
            </tr>
        </table>
    </fieldset>
</body>
</html>
