<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomStockGrp_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomStockGrp_Edit" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/FileManager/FileManager_browse2.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/functions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        });

        function submitStock() {
            document.getElementById('Form1').SaveButton.click();
        }
                
        function saveStockGrp(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }

        var deleteMsg = '<%= DeleteMessage %>';
        function deleteStockGrp() {
            if (confirm(deleteMsg)) document.getElementById('Form1').DeleteButton.click();
        }

        function deleteState(line) {
            var row = dwGrid_StatesGrid.findContainingRow(line);
            if (row) {
                if (confirm('<%= Translate.JsTranslate("Do you want to delete this row?") %>')) {
                    dwGrid_StatesGrid.deleteRows([row]);
                    EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=DeleteStock&ID=" + $(row.element).select("input[id$='StockStatusId']")[0].value;
                }
            }
        }
    </script>
    <script src="/Admin/FormValidation.js"></script>
</head>

<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <input type="hidden" name="Tab">
            <input id="Close" type="hidden" name="Close" value="0" />
            
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="std" runat="server"></asp:TextBox>
                            <div id="errNameStr" name="errNameStr" style="color: Red;"></div>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            
            <dwc:GroupBox runat="server" Title="States">
                <dw:EditableGrid runat="server" ID="StatesGrid" AllowAddingRows="true" AllowDeletingRows="true" AllowSortingRows="false" AllowSorting="false">
                    <Columns>
                        <asp:TemplateField>
                            <ItemStyle Width="50" />
                            <ItemTemplate>
                                <asp:HiddenField runat="server" ID="StockStatusId" />
                                <asp:HiddenField runat="server" ID="StockStatusLineId" />
                                <dwc:SelectPicker runat="server" ID="LevelSelector">
                                    <asp:ListItem Value="<="><=</asp:ListItem>
                                    <asp:ListItem Value=">=">>=</asp:ListItem>
                                </dwc:SelectPicker>
                                <asp:Label runat="server" ID="LevelText" Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle Width="60" />
                            <ItemTemplate>
                                <dwc:InputNumber runat="server" Value="0" ID="Amount" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <dwc:InputText runat="server" ID="Label" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <dwc:InputText runat="server" ID="DeliveryTime" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <dwc:InputText runat="server" ID="Unit" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle Width="285" />
                            <ItemTemplate>
                                <dw:FileManager runat="server" ShowPreview="false" AllowBrowse="true" Folder="/Files" ID="IconManager" FullPath="true" ClientIDMode="Static" />
                                <asp:Label runat="server" ID="IconLabel" Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="20px">
                            <ItemTemplate>
                                <span class="option-field-offset">
                                    <a href="javascript:void(0);" onclick="javascript:deleteState(this);" runat="server" id="RemoveButton">
                                        <i class="<%= Core.UI.Icons.KnownIconInfo.ClassNameFor(Core.UI.Icons.KnownIcon.Remove) %>" title="<%= Translate.Translate("Delete") %>"></i>
                                    </a>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </dw:EditableGrid>
            </dwc:GroupBox>
            
            <asp:Button ID="SaveButton" Style="display: none" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>
        </form>
    </div>
    <iframe frameborder="1" name="EcomUpdator" id="EcomUpdator" width="1" height="1" align="right"
        marginwidth="0" marginheight="0" border="0" src="EcomUpdator.aspx"></iframe>
    <script>
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name needs to be specified")%>');
        activateValidation('Form1');
    </script>
</body>
</html>
