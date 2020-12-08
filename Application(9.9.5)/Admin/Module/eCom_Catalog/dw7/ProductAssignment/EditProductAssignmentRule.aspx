<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditProductAssignmentRule.aspx.vb" Inherits="Dynamicweb.Admin.EditProductAssignmentRule" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/ProductAssignment/EditProductAssignmentRule.js" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        .mapping-id-column {
            width: 30px;
            text-align: center !important;
        }
        .mapping-remove-row-column {
            width: 50px;
            text-align: center !important;
        }
    </style>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit Assignment Rule" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(close);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete rule" runat="server" OnClientClick="currentPage.deleteAssignmentRule();"></dw:ToolbarButton>
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="gbSettings" Title="Settings" runat="server">
                        <dwc:InputText ID="assignmentRuleId" runat="server" Label="ID" Disabled="true" />
                        <dwc:InputText ID="assignmentRuleName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                        <dwc:CheckBox ID="assignmentRuleVisible" runat="server" Label="Visible" Indent="true" />
                    </dwc:GroupBox>
                    <dwc:GroupBox ID="gbRuleSettings" Title="Rule settings" runat="server">
                        <dw:SelectionBox ID="RuleShops" runat="server" Label="Shops" Width="250" Height="250" ShowSortRight="true" />
                        <input type="hidden" name="RuleShopsIDs" id="RuleShopsIDs" value="" runat="server" />
                        <dwc:RadioGroup runat="server" ID="RuleMode" Name="RuleMode" SelectedValue="Group" Indent="true">
                            <dwc:RadioButton runat="server" ID="RuleModeGroupRulesButton" Label="Group Rules" FieldValue="Group" OnClick="currentPage.setGroupMode()" />
                            <dwc:RadioButton runat="server" ID="RuleModeQueryButton" Label="Query" FieldValue="query" OnClick="currentPage.setQueryMode()" />
                        </dwc:RadioGroup>
                        <div id="queryParameters" style="display:none">
                            <div class="dw-ctrl select-picker-ctrl form-group has-error">
                                <label class="control-label">Query</label>
                                <div class="form-group-input">
                                    <dw:GroupDropDownList runat="server" ID="QuerySelect" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
                                    <small class="help-block error" id="helpQuerySelect"></small>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label">Parameter mapping</label>
                                <div class="form-group-input">
                                    <dw:EditableGrid runat="server" ID="QueryMappingsList" AllowAddingRows="true" AllowDeletingRows="true" NoRowsMessage="No mappings" AddNewRowMessage="Add new mapping" RowStyle-CssClass="pointer" >
                                        <Columns>
                                            <asp:TemplateField HeaderText="Group Field" ItemStyle-CssClass="group-field-column">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="GroupField" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Query parameter" ItemStyle-CssClass="query-parameter-column">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="QueryParameter" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Delete" ItemStyle-CssClass="row-delete mapping-remove-row-column" HeaderStyle-CssClass="mapping-remove-row-column">
                                                <ItemTemplate>
                                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" onclick="currentPage.deleteMappingListRows(event, this);"></i>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </dw:EditableGrid>
                                    <dw:Infobar ID="SaveNotification" DisplayType="Warning" Message="Save the assignment rule" Visible="false" runat="server"></dw:Infobar>
                                </div>
                            </div>
                        </div>
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="hidden" id="RedirectTo" name="RedirectTo" value="" />
            <input type="hidden" id="DeletedMappings" name="DeletedMappings" value="" />
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>

