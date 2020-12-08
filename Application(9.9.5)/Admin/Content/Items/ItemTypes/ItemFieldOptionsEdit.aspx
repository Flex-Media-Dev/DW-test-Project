<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ItemFieldOptionsEdit.aspx.vb" Inherits="Dynamicweb.Admin.ItemFieldOptionsEdit" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Data" %>
<%@ Import Namespace="Dynamicweb.Content.Items.Queries" %>
<%@ Import Namespace="Dynamicweb.Content.Items.Metadata" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
    <head runat="server">
        <meta http-equiv="X-UA-Compatible" content="IE=8" />

        <dw:ControlResources CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true" runat="server">
            <Items>
                <dw:GenericResource Url="/Admin/Content/Items/js/ItemFieldOptionsEdit.js" />
                <dw:GenericResource Url="/Admin/Content/Items/css/ItemFieldOptionsEdit.css" />
            </Items>
        </dw:ControlResources>

        <%=Gui.WriteFolderManagerScript()%>
    </head>

    <body>
        <form id="MainForm" runat="server">
            <div class="content">
                <div id="form-container">
                    <div id="SourceSettingsContainer">
                        <dwc:GroupBox Title="Source type" runat="server">
                            <ul id="SourceTypeList">
                                <li class="radio">
                                    <input type="radio" id="StaticSourceSelector" name="SourceTypeSelectors" value="<%=CType(FieldOptionSourceType.Static, Integer).ToString()%>" checked="checked"/>
                                    <label for="StaticSourceSelector" class="control-label">
                                        <dw:TranslateLabel ID="TranslateLabel1" Text="Static" runat="server" />
                                    </label>
                                </li>
                                <li class="radio">
                                    <input type="radio" id="SqlSourceSelector" name="SourceTypeSelectors" value="<%=CType(FieldOptionSourceType.Sql, Integer).ToString()%>" />
                                    <label for="SqlSourceSelector" class="control-label">
                                        <dw:TranslateLabel ID="TranslateLabel3" Text="SQL" runat="server" />
                                    </label>
                                </li>
                                <li class="radio">
                                    <input type="radio" id="ItemTypeSourceSelector" name="SourceTypeSelectors" value="<%=CType(FieldOptionSourceType.ItemType, Integer).ToString()%>" />
                                    <label for="ItemTypeSourceSelector" class="control-label">
                                        <dw:TranslateLabel ID="TranslateLabel2" Text="Item type" runat="server" />
                                    </label>
                                </li>
                            </ul>
                        </dwc:GroupBox>
                    </div>
                    <div id="edit-form-0" class="source-edit-form" style="display: none;">
                         <dw:EditableGrid ID="StaticSourceGrid" AllowAddingRows="true" AddNewRowMessage="Click here to add new option" 
                            NoRowsMessage="No options found" AllowDeletingRows="false" AllowSortingRows="true" runat="server" >
                            <Columns>
                                <asp:TemplateField HeaderText="Label">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txLabel" CssClass="std static-label" runat="server" autofocus="true" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Value">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txValue" CssClass="std static-value" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Icon">
                                    <ItemTemplate>
                                        <dw:FileArchive runat="server" ID="txIcon" ShowPreview="True" MaxLength="255" CssClass="std"></dw:FileArchive>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-CssClass="text-center" ItemStyle-HorizontalAlign="Center" HeaderText="Delete">
                                    <ItemTemplate>
                                        <a href="javascript:void(0);" onclick="Dynamicweb.Items.ItemFieldOptionsEdit.get_current().deleteRow(this);">
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove, True)%>"></i>
                                        </a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </dw:EditableGrid>
                    </div>

                    <div id="edit-form-1" class="source-edit-form" style="display: none;">
                        <div class="wrap">
                            <textarea class="std sql-query-string" placeholder="<%=Translate.Translate("Specify query text")%>"></textarea>
                            <div class="sql-toolbar">
                                <input type="button" class="sql-execute-btn btn btn-flat" value="<%=Translate.Translate("Execute Query (Ctrl plus Enter)")%>" />
                            </div>
                        </div>
                        <dwc:GroupBox runat="server">
                            <dwc:SelectPicker runat="server" ID="SqlNameFields" Label="Label"></dwc:SelectPicker>
                            <dwc:SelectPicker runat="server" ID="SqlValueFields" Label="Value"></dwc:SelectPicker>
                        </dwc:GroupBox>
                    </div>
                    <div id="edit-form-2" class="source-edit-form" style="display: none;">
                        <dwc:GroupBox Title="Settings" runat="server">
                            <dwc:SelectPicker runat="server" Label="Item type" ClientIDMode="Static" ID="ItemItemTypes"></dwc:SelectPicker>
                            <dwc:SelectPicker runat="server" Label="Label" ClientIDMode="Static" ID="ItemNameFields"></dwc:SelectPicker>
                            <dwc:SelectPicker runat="server" Label="Value" ClientIDMode="Static" ID="ItemValueFields"></dwc:SelectPicker>
                            <dwc:RadioGroup runat="server" Label="Select items from" Name="item-source-type">
                                <dwc:RadioButton runat="server" Label="Select items from this language / area" ClientIDMode="Static" ID="ItemSourceTypeArea" />
                            </dwc:RadioGroup>
                            <dwc:SelectPicker runat="server" Label="&nbsp;" DoTranslate="false" ClientIDMode="Static" ID="ItemSourceAreas"></dwc:SelectPicker>
                            <dwc:RadioGroup runat="server" Indent="true" Name="item-source-type">
                                <dwc:RadioButton runat="server" Label="Select items from current website" ClientIDMode="Static" ID="ItemSourceTypeCurrentArea" />
                                <dwc:RadioButton runat="server" Label="Select items under this page" ClientIDMode="Static" ID="ItemSourceTypePage" />
                            </dwc:RadioGroup>
                            <div class="form-group">
                                <label class="control-label">&nbsp;</label>
                                <%=Gui.LinkManager("", "ItemTypeSourcePage", String.Empty, "0", String.Empty, False, "on", True)%>
                            </div>
                            <dwc:RadioGroup runat="server" Indent="true" Name="item-source-type">
                                <dwc:RadioButton runat="server" Label="Select items under current page" ClientIDMode="Static" ID="ItemSourceTypeCurrentPage" />
                            </dwc:RadioGroup>
                            <dwc:CheckBox runat="server" Label="Include paragraph items" ID="ItemSourceParagraphs" />
                            <dwc:CheckBox runat="server" Label="Include all child items" ID="ItemSourceChilds" />
                        </dwc:GroupBox>
                    </div>
                </div>                
            </div>
            <asp:HiddenField ID="SqlSourceModel" runat="server"/>
            <asp:HiddenField ID="ItemTypeSourceModel" runat="server"/>
            <asp:HiddenField ID="PreloadData" runat="server"/>
            <asp:HiddenField ID="SourceTypeValue" runat="server"/>
        </form>

        <script type="text/javascript">
            document.observe("dom:loaded", function () {
                Dynamicweb.Items.ItemFieldOptionsEdit.get_current().get_terminology()['DeleteOption'] = '<%=Translate.JsTranslate("Are you sure you want to delete this option?")%>';
                Dynamicweb.Items.ItemFieldOptionsEdit.get_current().get_terminology()['RequestFailure'] = '<%=Translate.JsTranslate("Something went wrong. Try again.")%>';
                Dynamicweb.Items.ItemFieldOptionsEdit.get_current().get_terminology()['InvalidQuery'] = '<%=Translate.JsTranslate("Invalid query.")%>';
                Dynamicweb.Items.ItemFieldOptionsEdit.get_current().get_terminology()['ExecuteQuery'] = '<%=Translate.JsTranslate("Query string has been changed! Check and refill select boxes?")%>';
                Dynamicweb.Items.ItemFieldOptionsEdit.get_current().set_isTranslateOnly(<%=Me.IsTranslateOnly.ToString().ToLower()%>);
                Dynamicweb.Items.ItemFieldOptionsEdit.get_current().initialize('<%=Me.ItemType%>');
            });
        </script>
        <%Translate.GetEditOnlineScript()%>
    </body>
</html>
