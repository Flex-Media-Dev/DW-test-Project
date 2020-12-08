<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomTrackAndTrace_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomTrackAndTrace_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />

    <script type="text/javascript" src="/Admin/FormValidation.js"></script>

    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        }); 

        function showUsage() {
            dialog.show("UsageDialog");
        }
            
        function checkUsage() {
            if (<%= UsageCount %> > 0 ) {
                    alert('<%= Translate.JsTranslate("Cannot delete this track & trace as it is used in %% orders.", "%%", UsageOrders) %>');
                }
                else {
                    if (confirm('<%= Translate.JsTranslate("Do you want to delete this track & trace?") %>')) {
                        document.getElementById('Form1').DeleteButton.click(); 
                    }
                }
            }

            //  Delete row
            function delParameter(link) {
                var row = dwGrid_PropertiesGrid.findContainingRow(link);
                if (row) {
                    if (confirm('<%= Translate.JsTranslate("Do you want to delete this parameter?") %>')) {
                        dwGrid_PropertiesGrid.deleteRows([row]);
                    }
                }
            }
            function saveTrackAndTrace(close) {
                document.getElementById("Close").value = close ? 1 : 0;
                document.getElementById('Form1').SaveButton.click();
            }
    </script>
</head>

<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <asp:Literal ID="TableIsBlocked" runat="server"></asp:Literal>
            <dwc:GroupBox runat="server" Title="Track & trace">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn" />
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="std" runat="server" />
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelURL" runat="server" Text="URL schema" />
                        </td>
                        <td>
                            <asp:TextBox ID="URLStr" CssClass="std" runat="server" />
                            <small class="help-block info">http://www.YourTrackAndTraceService.com?First={0}&Next={1}&Last={2}</small>
                            <small class="help-block error" id="errURLStr"></small>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Parameters">
                <div id="errPropertiesGrid" runat="server" style="color: Red;"></div>
                <dw:EditableGrid runat="server" ID="PropertiesGrid" ClientIDMode="AutoID" AllowAddingRows="True">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="Name" Text="" CssClass="std" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="DefaultValue" Text="" CssClass="std" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="Description" Text="" CssClass="std" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="20px">
                            <ItemTemplate>
                                <span class="option-field-offset">
                                    <a href="javascript:void(0);" onclick="javascript:delParameter(this);">
                                        <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" title="<%= Translate.Translate("Delete") %>"></i>
                                    </a>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </dw:EditableGrid>
            </dwc:GroupBox>

            <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>

            <dw:Dialog runat="server" ID="UsageDialog" OkAction="dialog.hide('UsageDialog');" ShowCancelButton="false" ShowClose="false" ShowOkButton="true" Title="Usage" TranslateTitle="true">
                <div>
                    <asp:Literal runat="server" ID="UsageContent" />
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="DeleteDialog" OkAction="dialog.hide('DeleteDialog');" ShowCancelButton="false" ShowClose="false" ShowOkButton="true" Title="Cannot delete" TranslateTitle="true">
                <div>
                    <asp:Literal runat="server" ID="DeleteContent" />
                </div>
            </dw:Dialog>
        </form>
    </div>
    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addMinLengthRestriction('URLStr', 1, '<%=Translate.JsTranslate("A URL schema is needed")%>');
        activateValidation('Form1');
    </script>
</body>
</html>
