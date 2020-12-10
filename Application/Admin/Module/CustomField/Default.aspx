<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin.CustomFields.CustomFieldEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.Ecommerce.UserPermissions" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Custom fields</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript" src="CustomField.js"></script>
    <script type="text/javascript">
        var txtSysNotUnique = '<%=Translate.JsTranslate("Some system names are not unique, missing or invalid. Make sure the name conforms to the naming convention.") %>';
        var helpLang = "<%=helpLang %>";
        var optionsDataTypeID = "<%=OptionsDataType.clientID %>";
        var typesWithOptions = <%=typesWithOptions %>;
        var optionRowValues = new Array;
    </script>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="Header"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <dw:Toolbar ID="CustomFieldToolbar" runat="server" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Icon="Save" Text="Save" OnClientClick="save();"></dw:ToolbarButton>
                    <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Icon="TimesCircle" Text="Cancel" OnClientClick="cancel()"></dw:ToolbarButton>
                    <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="None" Icon="Help" Text="Help" OnClientClick="help();"></dw:ToolbarButton>
                </dw:Toolbar>
                <div>
                    <dwc:GroupBox runat="server" Title="Custom Fields" DoTranslation="true" ID="CustomFieldsgroupBox">
                        <dw:EditableGrid ID="CustomFieldsList" runat="server" EnableViewState="true" ClientIDMode="AutoID">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:TextBox ID="CustomFieldName" runat="server" CssClass="NewUIinput" />
                                        <asp:HiddenField runat="server" ID="CustomFieldSettings" Value="" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:TextBox ID="CustomFieldSystemNameText" runat="server" CssClass="NewUIinput" />
                                        <asp:HiddenField ID="CustomFieldSystemName" runat="server" Value="" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:DropDownList ID="CustomFieldTypeDrop" Visible="true" runat="server" CssClass="NewUIinput" />
                                        <asp:TextBox ID="CustomFieldTypeText" Visible="false" runat="server" CssClass="NewUIinput" />
                                        <asp:HiddenField ID="CustomFieldType" Value="" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <i title="<%=Translate.Translate("Change position") %>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.ArrowsV) %>" style="cursor: move;"></i>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <div id="buttons" style="width: 16px;">
                                            <i title="<%=Translate.JsTranslate("Slet") %>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Close) %>" onclick="javascript:deleteSelectedRowFields(this);" style="cursor: pointer;"></i>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </dw:EditableGrid>                               
                    </dwc:GroupBox>
                </div>

                <div id="options" style="display: none;">
                    <dwc:GroupBox runat="server" Title="Options">
                        <table>
                            <tr>
                                <td style="width: 170px; vertical-align: top;">
                                    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Data type" />
                                </td>
                                <td>
                                    <asp:DropDownList runat="server" ID="OptionsDataType" CssClass="NewUIinput"></asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                        <dw:EditableGrid ID="CustomFieldOptions" runat="server" EnableViewState="true" DraggableColumnsMode="First" EnableSmartNavigation="false" ClientIDMode="AutoID">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:TextBox ID="CustomFieldOptionKey" runat="server" CssClass="NewUIinput" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:TextBox ID="CustomFieldOptionValue" runat="server" CssClass="NewUIinput" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <div id="buttons" style="visibility: hidden; width: 16px;">
                                            <i title="<%=Translate.JsTranslate("Slet") %>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Close) %>" onclick="javascript:deleteSelectedRowOptions();" style="cursor: pointer;"></i>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </dw:EditableGrid>
                    </dwc:GroupBox>
                </div>
            </dwc:CardBody>
        </dwc:Card>

        <asp:HiddenField ID="DoSave" runat="server" Value="True" />
        <asp:HiddenField ID="TableName" runat="server" />
        <asp:HiddenField ID="DatabaseName" runat="server" />
        <asp:HiddenField ID="ModuleName" runat="server" />
        <asp:HiddenField ID="RedirectUrl" runat="server" />
    </form>

    <script type="text/javascript">
        // Set the onCompleted events
        dwGrid_CustomFieldsList.onRowAddedCompleted = function(row) {
            $("options").hide();
            var nameBox = row.findControl("CustomFieldName");
            nameBox.focus();
        };

        dwGrid_CustomFieldOptions.onRowAddedCompleted = function(row) {
            var keyBox = row.findControl("CustomFieldOptionKey");
            keyBox.focus();
            
            var rowData;
            if (optionRowValues.length > 1) {
                rowData = optionRowValues[0];
                optionRowValues = optionRowValues.slice(1);
                dwGrid_CustomFieldOptions.addRow();
            } else if (optionRowValues.length = 1) {
                rowData = optionRowValues[0];
                optionRowValues = [];
            } else {
                return;
            }
            row.findControl("CustomFieldOptionKey").value = rowData[0];
            row.findControl("CustomFieldOptionValue").value = rowData[1];
        };
    </script>
</body>
<% Translate.GetEditOnlineScript() %>
</html>
